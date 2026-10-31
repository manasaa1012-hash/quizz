-- Phase 4: server-authoritative gamification, leaderboards and notifications.

create table if not exists public.levels (
  level_number integer primary key check (level_number > 0),
  name text not null,
  xp_required integer not null unique check (xp_required >= 0),
  created_at timestamptz not null default now()
);

insert into public.levels (level_number, name, xp_required) values
  (1, 'Starter', 0), (2, 'Explorer', 200), (3, 'Scholar', 500),
  (4, 'Achiever', 1000), (5, 'Expert', 1800), (6, 'Master', 3000),
  (7, 'Champion', 5000), (8, 'Legend', 8000)
on conflict (level_number) do update set name = excluded.name, xp_required = excluded.xp_required;

create table if not exists public.xp_transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  amount integer not null check (amount <> 0),
  reason text not null,
  source_type text not null,
  source_id uuid not null,
  created_at timestamptz not null default now(),
  unique (user_id, source_type, source_id, reason)
);

insert into public.xp_transactions(user_id,amount,reason,source_type,source_id,created_at)
select user_id,total_xp,'legacy_balance','migration',user_id,coalesce(last_quiz_date,now())
from public.student_stats where total_xp>0
on conflict do nothing;

alter table public.student_stats
  add column if not exists current_level integer not null default 1 references public.levels(level_number),
  add column if not exists longest_streak integer not null default 0,
  add column if not exists last_activity_date date,
  add column if not exists questions_solved integer not null default 0,
  add column if not exists correct_answers integer not null default 0,
  add column if not exists total_response_seconds bigint not null default 0,
  add column if not exists perfect_scores integer not null default 0;

update public.student_stats
set last_activity_date = coalesce(last_activity_date, last_quiz_date::date),
    longest_streak = greatest(longest_streak, streak_days),
    current_level = coalesce((select max(l.level_number) from public.levels l where l.xp_required <= total_xp), 1);

with answer_totals as (
  select ea.user_id,
    count(*) filter(where sa.selected_answer is not null)::integer solved,
    count(*) filter(where sa.is_correct)::integer correct,
    coalesce(sum(sa.time_taken_seconds) filter(where sa.selected_answer is not null),0)::bigint response_seconds
  from public.exam_attempts ea join public.student_answers sa on sa.attempt_id=ea.id
  where ea.status='submitted' group by ea.user_id
), perfect_totals as (
  select user_id,count(*)::integer perfect from public.exam_attempts
  where status='submitted' and percentage=100 and unanswered_count=0 group by user_id
)
update public.student_stats s set
  questions_solved=coalesce(a.solved,0), correct_answers=coalesce(a.correct,0),
  total_response_seconds=coalesce(a.response_seconds,0), perfect_scores=coalesce(p.perfect,0)
from answer_totals a left join perfect_totals p on p.user_id=a.user_id where s.user_id=a.user_id;

alter table public.badges
  add column if not exists icon text not null default 'Award',
  add column if not exists image_url text,
  add column if not exists criteria_type text not null default 'total_xp',
  add column if not exists criteria_value numeric(10,2) not null default 0,
  add column if not exists is_active boolean not null default true,
  add column if not exists created_at timestamptz not null default now(),
  add column if not exists updated_at timestamptz not null default now();

insert into public.badges (name, description, xp_required, icon, criteria_type, criteria_value, is_active) values
  ('First Quiz', 'Complete your first quiz.', 0, 'ClipboardCheck', 'quizzes_completed', 1, true),
  ('100 Questions Solved', 'Answer 100 quiz questions.', 0, 'ListChecks', 'questions_solved', 100, true),
  ('500 XP', 'Earn 500 total XP.', 500, 'Sparkles', 'total_xp', 500, true),
  ('1000 XP', 'Earn 1000 total XP.', 1000, 'Zap', 'total_xp', 1000, true),
  ('7-Day Streak', 'Learn for seven consecutive days.', 0, 'Flame', 'streak', 7, true),
  ('30-Day Streak', 'Learn for thirty consecutive days.', 0, 'Flame', 'streak', 30, true),
  ('Accuracy Master', 'Maintain at least 90% accuracy after 50 answers.', 0, 'Target', 'accuracy', 90, true),
  ('Speed Master', 'Average at most 20 seconds after 50 answers.', 0, 'Timer', 'speed_under', 20, true),
  ('Quiz Champion', 'Complete 25 quizzes.', 0, 'Trophy', 'quizzes_completed', 25, true),
  ('Subject Expert', 'Reach 85% average in a subject over at least three quizzes.', 0, 'BookOpenCheck', 'subject_accuracy', 85, true),
  ('Top 10', 'Reach the global leaderboard top ten.', 0, 'Crown', 'global_rank', 10, true),
  ('Perfect Score', 'Earn a perfect quiz score.', 0, 'BadgeCheck', 'perfect_scores', 1, true)
on conflict (name) do update set
  description = excluded.description, icon = excluded.icon, criteria_type = excluded.criteria_type,
  criteria_value = excluded.criteria_value, is_active = excluded.is_active, updated_at = now();

alter table public.notifications
  add column if not exists link text,
  add column if not exists event_key text;
update public.notifications set link = link_url where link is null and link_url is not null;
do $$ begin
  if not exists(select 1 from pg_constraint where conname='notifications_user_event_unique') then
    alter table public.notifications add constraint notifications_user_event_unique unique(user_id,event_key);
  end if;
end $$;

create table if not exists public.leaderboard_snapshots (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  scope text not null,
  period_key text not null,
  rank integer not null check (rank > 0),
  metric_value numeric(12,2) not null default 0,
  created_at timestamptz not null default now(),
  unique(user_id, scope, period_key)
);

create index if not exists idx_xp_user_created on public.xp_transactions(user_id, created_at desc);
create index if not exists idx_xp_period on public.xp_transactions(created_at desc, user_id);
create index if not exists idx_student_stats_ranking on public.student_stats(total_xp desc, quizzes_completed desc);
create index if not exists idx_student_badges_earned on public.student_badges(user_id, earned_at desc);
create index if not exists idx_badges_active_criteria on public.badges(is_active, criteria_type);
create index if not exists idx_notifications_unread on public.notifications(user_id, is_read, created_at desc);
create index if not exists idx_leaderboard_snapshots_scope on public.leaderboard_snapshots(scope, period_key, rank);

alter table public.levels enable row level security;
alter table public.xp_transactions enable row level security;
alter table public.leaderboard_snapshots enable row level security;

drop policy if exists "levels readable" on public.levels;
create policy "levels readable" on public.levels for select to authenticated using (true);
drop policy if exists "own xp readable" on public.xp_transactions;
create policy "own xp readable" on public.xp_transactions for select using (auth.uid() = user_id);
drop policy if exists "leaderboard stats readable" on public.student_stats;
create policy "leaderboard stats readable" on public.student_stats for select to authenticated using (true);
drop policy if exists "active badges readable" on public.badges;
drop policy if exists "badges readable" on public.badges;
create policy "active badges readable" on public.badges for select to authenticated using (is_active = true);
drop policy if exists "leaderboard snapshots readable" on public.leaderboard_snapshots;
create policy "leaderboard snapshots readable" on public.leaderboard_snapshots for select to authenticated using (true);
drop policy if exists "notifications self update" on public.notifications;
create policy "notifications self update" on public.notifications for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

create or replace function public.apply_attempt_rewards(p_attempt_id uuid, p_user_id uuid)
returns boolean language plpgsql security definer set search_path = '' as $$
declare
  a public.exam_attempts%rowtype;
  s public.student_stats%rowtype;
  metric record;
  badge record;
  answered_count integer := 0;
  correct_count integer := 0;
  hard_correct integer := 0;
  total_seconds integer := 0;
  award integer := 30;
  old_level integer := 1;
  new_level integer := 1;
  new_streak integer := 1;
  old_rank integer;
  current_rank integer;
  is_new_day boolean := false;
  qualifies boolean;
begin
  select * into a from public.exam_attempts where id=p_attempt_id and user_id=p_user_id for update;
  if not found or a.status <> 'submitted' then raise exception using errcode='P0001', message='Submitted attempt not found'; end if;
  if a.reward_applied_at is not null then return false; end if;

  select count(*) filter(where sa.selected_answer is not null), count(*) filter(where sa.is_correct),
         count(*) filter(where sa.is_correct and coalesce(sa.question_snapshot->>'difficulty','medium')='hard'),
         coalesce(sum(sa.time_taken_seconds) filter(where sa.selected_answer is not null),0)
  into answered_count, correct_count, hard_correct, total_seconds
  from public.student_answers sa where sa.attempt_id=p_attempt_id;

  insert into public.student_stats(user_id) values(p_user_id) on conflict(user_id) do nothing;
  select * into s from public.student_stats where user_id=p_user_id for update;
  old_level := coalesce(s.current_level,1);
  is_new_day := s.last_activity_date is distinct from current_date;
  new_streak := case when not is_new_day then greatest(s.streak_days,1)
    when s.last_activity_date=current_date-1 then s.streak_days+1 else 1 end;
  award := 30 + correct_count*10 + hard_correct*5
    + case when answered_count>0 and correct_count=answered_count and coalesce(a.unanswered_count,0)=0 then 100 else 0 end
    + case when is_new_day then 20 else 0 end;

  if correct_count>0 then insert into public.xp_transactions(user_id,amount,reason,source_type,source_id)
    values(p_user_id,correct_count*10,'correct_answers','exam_attempt',p_attempt_id) on conflict do nothing; end if;
  if hard_correct>0 then insert into public.xp_transactions(user_id,amount,reason,source_type,source_id)
    values(p_user_id,hard_correct*5,'hard_answer_bonus','exam_attempt',p_attempt_id) on conflict do nothing; end if;
  insert into public.xp_transactions(user_id,amount,reason,source_type,source_id)
    values(p_user_id,30,'quiz_completed','exam_attempt',p_attempt_id) on conflict do nothing;
  if answered_count>0 and correct_count=answered_count and coalesce(a.unanswered_count,0)=0 then
    insert into public.xp_transactions(user_id,amount,reason,source_type,source_id) values(p_user_id,100,'perfect_score','exam_attempt',p_attempt_id) on conflict do nothing;
  end if;
  if is_new_day then
    insert into public.xp_transactions(user_id,amount,reason,source_type,source_id) values(p_user_id,20,'daily_streak_bonus','exam_attempt',p_attempt_id) on conflict do nothing;
  end if;

  for metric in select q.topic_id, count(*) filter(where sa.selected_answer is not null)::integer attempted,
      count(*) filter(where sa.is_correct)::integer correct, coalesce(sum(sa.time_taken_seconds),0)::integer total_time
    from public.student_answers sa join public.questions q on q.id=sa.question_id
    where sa.attempt_id=p_attempt_id and q.topic_id is not null group by q.topic_id
  loop
    insert into public.performance_metrics(user_id,topic_id,attempted,correct,accuracy,total_time_seconds,updated_at)
    values(p_user_id,metric.topic_id,metric.attempted,metric.correct,case when metric.attempted>0 then metric.correct*100.0/metric.attempted else 0 end,metric.total_time,now())
    on conflict(user_id,topic_id) do update set attempted=public.performance_metrics.attempted+excluded.attempted,
      correct=public.performance_metrics.correct+excluded.correct,total_time_seconds=public.performance_metrics.total_time_seconds+excluded.total_time_seconds,
      accuracy=case when public.performance_metrics.attempted+excluded.attempted>0 then
        (public.performance_metrics.correct+excluded.correct)*100.0/(public.performance_metrics.attempted+excluded.attempted) else 0 end,updated_at=now();
  end loop;

  update public.student_stats set total_xp=total_xp+award, quizzes_completed=quizzes_completed+1,
    streak_days=new_streak, longest_streak=greatest(longest_streak,new_streak),
    last_quiz_date=now(),last_activity_date=case when is_new_day then current_date else last_activity_date end,
    questions_solved=questions_solved+answered_count,correct_answers=correct_answers+correct_count,
    total_response_seconds=total_response_seconds+total_seconds,
    perfect_scores=perfect_scores+case when answered_count>0 and correct_count=answered_count and coalesce(a.unanswered_count,0)=0 then 1 else 0 end
  where user_id=p_user_id returning * into s;
  select coalesce(max(level_number),1) into new_level from public.levels where xp_required<=s.total_xp;
  update public.student_stats set current_level=new_level where user_id=p_user_id;
  update public.exam_attempts set xp_earned=award,reward_applied_at=now() where id=p_attempt_id;

  if new_level>old_level then
    insert into public.notifications(user_id,type,title,message,link,event_key)
    values(p_user_id,'level_up','Level up!',format('You reached Level %s.',new_level),'/app/achievements','level:'||new_level)
    on conflict(user_id,event_key) do nothing;
  end if;

  current_rank := (select count(*)+1 from public.student_stats other where other.total_xp>s.total_xp);
  select rank into old_rank from public.leaderboard_snapshots
    where user_id=p_user_id and scope='global' and period_key='all-time';
  insert into public.leaderboard_snapshots(user_id,scope,period_key,rank,metric_value,created_at)
  values(p_user_id,'global','all-time',current_rank,s.total_xp,now())
  on conflict(user_id,scope,period_key) do update set rank=excluded.rank,metric_value=excluded.metric_value,created_at=now();
  if old_rank is not null and old_rank-current_rank>=3 then
    insert into public.notifications(user_id,type,title,message,link,event_key)
    values(p_user_id,'rank_update','Leaderboard climb',format('You moved up to global rank #%s.',current_rank),'/app/leaderboard',format('rank:%s:%s',current_rank,current_date))
    on conflict(user_id,event_key) do nothing;
  end if;

  for badge in select * from public.badges b where b.is_active and not exists
    (select 1 from public.student_badges sb where sb.user_id=p_user_id and sb.badge_id=b.id)
  loop
    qualifies := case badge.criteria_type
      when 'quizzes_completed' then s.quizzes_completed>=badge.criteria_value
      when 'questions_solved' then s.questions_solved>=badge.criteria_value
      when 'total_xp' then s.total_xp>=badge.criteria_value
      when 'streak' then new_streak>=badge.criteria_value
      when 'accuracy' then s.questions_solved>=50 and s.correct_answers*100.0/nullif(s.questions_solved,0)>=badge.criteria_value
      when 'speed_under' then s.questions_solved>=50 and s.total_response_seconds/nullif(s.questions_solved,0)<=badge.criteria_value
      when 'perfect_scores' then s.perfect_scores>=badge.criteria_value
      when 'subject_accuracy' then exists(select 1 from public.exam_attempts ea join public.exams e on e.id=ea.exam_id where ea.user_id=p_user_id and ea.status='submitted' group by e.subject_id having count(*)>=3 and avg(ea.percentage)>=badge.criteria_value)
      when 'global_rank' then (select count(*)+1 from public.student_stats other where other.total_xp>s.total_xp)<=badge.criteria_value
      else false end;
    if qualifies then
      insert into public.student_badges(user_id,badge_id) values(p_user_id,badge.id) on conflict do nothing;
      if found then insert into public.notifications(user_id,type,title,message,link,event_key)
        values(p_user_id,'badge_earned','Badge earned',badge.name||': '||badge.description,'/app/achievements','badge:'||badge.id)
        on conflict(user_id,event_key) do nothing; end if;
    end if;
  end loop;
  return true;
end; $$;

revoke all on function public.apply_attempt_rewards(uuid,uuid) from public;
grant execute on function public.apply_attempt_rewards(uuid,uuid) to service_role;

create or replace function public.notify_adaptive_session_completed()
returns trigger language plpgsql security definer set search_path='' as $$
begin
  if new.status='completed' and old.status is distinct from new.status and new.attempted>0 then
    insert into public.notifications(user_id,type,title,message,link,event_key)
    values(new.user_id,'adaptive_recommendation','Adaptive practice update',
      case when new.correct*100.0/new.attempted>=80 then 'Excellent work. Continue with harder practice.'
        when new.correct*100.0/new.attempted>=50 then 'Keep practicing this topic to strengthen mastery.'
        else 'Review this topic’s fundamentals before your next session.' end,
      '/app/adaptive','adaptive:'||new.id)
    on conflict(user_id,event_key) do nothing;
  end if;
  return new;
end; $$;
drop trigger if exists adaptive_session_completed_notification on public.adaptive_sessions;
create trigger adaptive_session_completed_notification after update of status on public.adaptive_sessions
for each row execute procedure public.notify_adaptive_session_completed();

-- Enable database-backed live updates without adding duplicate publication entries.
do $$ begin
  if exists(select 1 from pg_publication where pubname='supabase_realtime') then
    if not exists(select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='student_stats') then alter publication supabase_realtime add table public.student_stats; end if;
    if not exists(select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='notifications') then alter publication supabase_realtime add table public.notifications; end if;
  end if;
end $$;
