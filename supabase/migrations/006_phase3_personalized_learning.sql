-- Phase 3: persisted analytics, adaptive practice, recommendations, plans and predictions.

create table if not exists public.student_topic_ability (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  topic_id uuid not null references public.topics(id) on delete cascade,
  ability_score numeric(5,2) not null default 50 check (ability_score between 0 and 100),
  status text not null default 'Moderate' check (status in ('Strong','Moderate','Weak','Critical')),
  attempted integer not null default 0 check (attempted >= 0),
  accuracy numeric(5,2) not null default 0 check (accuracy between 0 and 100),
  recent_trend numeric(7,2) not null default 0,
  updated_at timestamptz not null default now(),
  unique(user_id, topic_id)
);

create table if not exists public.performance_predictions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  predicted_score numeric(5,2) not null check (predicted_score between 0 and 100),
  confidence numeric(5,4) not null check (confidence between 0 and 1),
  trend text not null check (trend in ('improving','stable','declining')),
  risk_level text not null check (risk_level in ('Low','Moderate','High')),
  feature_snapshot jsonb not null default '{}'::jsonb,
  actual_score numeric(5,2) check (actual_score between 0 and 100),
  prediction_error numeric(6,2),
  created_at timestamptz not null default now()
);

create table if not exists public.recommendations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  topic_id uuid references public.topics(id) on delete cascade,
  priority text not null check (priority in ('high','medium','low')),
  accuracy numeric(5,2) not null default 0,
  reason text not null,
  recommendation text not null,
  suggested_questions integer not null default 10 check (suggested_questions > 0),
  status text not null default 'active' check (status in ('active','completed','dismissed')),
  performance_version timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.revision_plans (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  duration_days integer not null check (duration_days in (7,14,30)),
  starts_on date not null default current_date,
  status text not null default 'active' check (status in ('active','completed','archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.revision_plan_tasks (
  id uuid primary key default gen_random_uuid(),
  plan_id uuid not null references public.revision_plans(id) on delete cascade,
  topic_id uuid references public.topics(id) on delete set null,
  scheduled_date date not null,
  day_number integer not null check (day_number > 0),
  activity text not null,
  target_questions integer not null default 15 check (target_questions > 0),
  status text not null default 'pending' check (status in ('pending','completed','skipped')),
  completed_at timestamptz,
  updated_at timestamptz not null default now()
);

create table if not exists public.adaptive_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  subject_id uuid not null references public.subjects(id) on delete restrict,
  topic_id uuid not null references public.topics(id) on delete restrict,
  target_questions integer not null check (target_questions between 1 and 50),
  status text not null default 'in_progress' check (status in ('in_progress','completed')),
  ability_before numeric(5,2) not null check (ability_before between 0 and 100),
  ability_after numeric(5,2) check (ability_after between 0 and 100),
  attempted integer not null default 0,
  correct integer not null default 0,
  started_at timestamptz not null default now(),
  completed_at timestamptz
);

create table if not exists public.adaptive_session_questions (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.adaptive_sessions(id) on delete cascade,
  question_id uuid not null references public.questions(id) on delete restrict,
  question_order integer not null check (question_order > 0),
  difficulty public.question_difficulty not null,
  selected_answer integer check (selected_answer between 0 and 3),
  is_correct boolean,
  response_time_seconds integer check (response_time_seconds >= 0),
  ability_before numeric(5,2) not null check (ability_before between 0 and 100),
  ability_after numeric(5,2) check (ability_after between 0 and 100),
  question_snapshot jsonb not null default '{}'::jsonb check (jsonb_typeof(question_snapshot) = 'object'),
  answered_at timestamptz,
  created_at timestamptz not null default now(),
  unique(session_id, question_id),
  unique(session_id, question_order)
);

create index if not exists idx_ability_user_score on public.student_topic_ability(user_id, ability_score);
create index if not exists idx_predictions_user_created on public.performance_predictions(user_id, created_at desc);
create index if not exists idx_recommendations_user_status on public.recommendations(user_id, status, priority);
create index if not exists idx_revision_plans_user on public.revision_plans(user_id, created_at desc);
create index if not exists idx_revision_tasks_plan_date on public.revision_plan_tasks(plan_id, scheduled_date);
create index if not exists idx_adaptive_sessions_user on public.adaptive_sessions(user_id, started_at desc);
create index if not exists idx_adaptive_questions_session_order on public.adaptive_session_questions(session_id, question_order);

alter table public.student_topic_ability enable row level security;
alter table public.performance_predictions enable row level security;
alter table public.recommendations enable row level security;
alter table public.revision_plans enable row level security;
alter table public.revision_plan_tasks enable row level security;
alter table public.adaptive_sessions enable row level security;
alter table public.adaptive_session_questions enable row level security;

create policy "own abilities read" on public.student_topic_ability for select using (auth.uid() = user_id);
create policy "own predictions read" on public.performance_predictions for select using (auth.uid() = user_id);
create policy "own recommendations read" on public.recommendations for select using (auth.uid() = user_id);
create policy "own revision plans read" on public.revision_plans for select using (auth.uid() = user_id);
create policy "own revision tasks read" on public.revision_plan_tasks for select using (
  exists (select 1 from public.revision_plans p where p.id = plan_id and p.user_id = auth.uid())
);
create policy "own adaptive sessions read" on public.adaptive_sessions for select using (auth.uid() = user_id);
create policy "own adaptive questions read" on public.adaptive_session_questions for select using (
  exists (select 1 from public.adaptive_sessions s where s.id = session_id and s.user_id = auth.uid())
);
