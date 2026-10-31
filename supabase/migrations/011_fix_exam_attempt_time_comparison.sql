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
