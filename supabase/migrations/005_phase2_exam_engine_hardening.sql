-- Phase 2 completion: atomic attempt creation/resume and submission claiming.

alter table public.exam_attempts
  add column if not exists submission_token uuid,
  add column if not exists xp_earned integer not null default 0,
  add column if not exists reward_applied_at timestamptz;

alter table public.student_answers
  add column if not exists question_snapshot jsonb;

alter table public.student_answers
  add constraint student_answers_question_snapshot_check check (
    question_snapshot is null or jsonb_typeof(question_snapshot) = 'object'
  );

-- Preserve submitted review records. Questions/exams with attempt history must
-- be archived rather than physically deleted.
alter table public.student_answers drop constraint if exists student_answers_question_id_fkey;
alter table public.student_answers
  add constraint student_answers_question_id_fkey
  foreign key (question_id) references public.questions(id) on delete restrict;

alter table public.exam_attempts drop constraint if exists exam_attempts_exam_id_fkey;
alter table public.exam_attempts
  add constraint exam_attempts_exam_id_fkey
  foreign key (exam_id) references public.exams(id) on delete restrict;

alter table public.exam_attempts
  add constraint exam_attempts_xp_earned_check check (xp_earned >= 0);

create index if not exists idx_attempts_submission_claim
  on public.exam_attempts (id, user_id, status, submission_token);

create or replace function public.start_or_resume_exam_attempt(
  p_exam_id uuid,
  p_user_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  selected_exam public.exams%rowtype;
  existing_attempt public.exam_attempts%rowtype;
  created_attempt public.exam_attempts%rowtype;
  submitted_count integer;
  question_count integer;
  v_current_time timestamptz := now();
begin
  -- Serialize starts for the same student/exam pair to prevent two attempts
  -- being created by concurrent requests.
  perform pg_advisory_xact_lock(hashtextextended(p_user_id::text || ':' || p_exam_id::text, 0));

  select * into selected_exam
  from public.exams
  where id = p_exam_id;

  if not found then
    raise exception using errcode = 'P0001', message = 'Exam not available';
  end if;

  select * into existing_attempt
  from public.exam_attempts
  where exam_id = p_exam_id
    and user_id = p_user_id
    and status = 'in_progress'
  order by started_at desc
  limit 1;

  if found then
    return jsonb_build_object('attempt', to_jsonb(existing_attempt), 'resumed', true);
  end if;

  if not selected_exam.is_published or selected_exam.status <> 'published'
    or not selected_exam.is_active then
    raise exception using errcode = 'P0001', message = 'Exam not available';
  end if;
  if selected_exam.start_date is not null and selected_exam.start_date > v_current_time then
    raise exception using errcode = 'P0001', message = 'This exam is not open yet';
  end if;
  if selected_exam.end_date is not null and selected_exam.end_date < v_current_time then
    raise exception using errcode = 'P0001', message = 'This exam is already closed';
  end if;

  select count(*) into submitted_count
  from public.exam_attempts
  where exam_id = p_exam_id
    and user_id = p_user_id
    and status = 'submitted';

  if submitted_count >= selected_exam.attempt_limit then
    raise exception using errcode = 'P0001', message = 'Attempt limit reached for this exam';
  end if;

  select count(*) into question_count
  from public.exam_questions eq
  join public.questions q on q.id = eq.question_id
  where eq.exam_id = p_exam_id and q.is_active;
  if question_count = 0 then
    raise exception using errcode = 'P0001', message = 'This exam has no questions';
  end if;

  insert into public.exam_attempts (
    exam_id, user_id, status, attempt_number, started_at, expires_at, last_saved_at
  ) values (
    p_exam_id,
    p_user_id,
    'in_progress',
    submitted_count + 1,
    v_current_time,
    v_current_time + make_interval(mins => selected_exam.duration_minutes),
    v_current_time
  )
  returning * into created_attempt;

  return jsonb_build_object('attempt', to_jsonb(created_attempt), 'resumed', false);
end;
$$;

revoke all on function public.start_or_resume_exam_attempt(uuid, uuid) from public;
grant execute on function public.start_or_resume_exam_attempt(uuid, uuid) to service_role;

create or replace function public.apply_attempt_rewards(
  p_attempt_id uuid,
  p_user_id uuid
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  selected_attempt public.exam_attempts%rowtype;
  metric record;
begin
  select * into selected_attempt
  from public.exam_attempts
  where id = p_attempt_id and user_id = p_user_id
  for update;

  if not found or selected_attempt.status <> 'submitted' then
    raise exception using errcode = 'P0001', message = 'Submitted attempt not found';
  end if;
  if selected_attempt.reward_applied_at is not null then
    return false;
  end if;

  for metric in
    select
      q.topic_id,
      count(*) filter (where sa.selected_answer is not null)::integer as attempted,
      count(*) filter (where sa.is_correct)::integer as correct,
      coalesce(sum(sa.time_taken_seconds), 0)::integer as total_time
    from public.student_answers sa
    join public.questions q on q.id = sa.question_id
    where sa.attempt_id = p_attempt_id and q.topic_id is not null
    group by q.topic_id
  loop
    insert into public.performance_metrics (
      user_id, topic_id, attempted, correct, accuracy, total_time_seconds, updated_at
    ) values (
      p_user_id,
      metric.topic_id,
      metric.attempted,
      metric.correct,
      case when metric.attempted > 0 then metric.correct * 100.0 / metric.attempted else 0 end,
      metric.total_time,
      now()
    )
    on conflict (user_id, topic_id) do update
    set attempted = public.performance_metrics.attempted + excluded.attempted,
        correct = public.performance_metrics.correct + excluded.correct,
        total_time_seconds = public.performance_metrics.total_time_seconds + excluded.total_time_seconds,
        accuracy = case
          when public.performance_metrics.attempted + excluded.attempted > 0
            then (public.performance_metrics.correct + excluded.correct) * 100.0
              / (public.performance_metrics.attempted + excluded.attempted)
          else 0
        end,
        updated_at = now();
  end loop;

  insert into public.student_stats (
    user_id, total_xp, quizzes_completed, streak_days, last_quiz_date
  ) values (
    p_user_id, selected_attempt.xp_earned, 1, 1, now()
  )
  on conflict (user_id) do update
  set total_xp = public.student_stats.total_xp + excluded.total_xp,
      quizzes_completed = public.student_stats.quizzes_completed + 1,
      streak_days = case
        when public.student_stats.last_quiz_date::date = current_date then public.student_stats.streak_days
        when public.student_stats.last_quiz_date::date = current_date - 1 then public.student_stats.streak_days + 1
        else 1
      end,
      last_quiz_date = now();

  update public.exam_attempts
  set reward_applied_at = now()
  where id = p_attempt_id;

  return true;
end;
$$;

revoke all on function public.apply_attempt_rewards(uuid, uuid) from public;
grant execute on function public.apply_attempt_rewards(uuid, uuid) to service_role;
