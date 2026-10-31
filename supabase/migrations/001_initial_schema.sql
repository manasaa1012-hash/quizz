create extension if not exists "pgcrypto";

create type public.user_role as enum ('student', 'admin');
create type public.exam_status as enum ('in_progress', 'submitted');
create type public.question_difficulty as enum ('easy', 'medium', 'hard');

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default 'Student',
  college text,
  role public.user_role not null default 'student',
  created_at timestamptz not null default now()
);

create table if not exists public.subjects (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists public.topics (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid not null references public.subjects(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now(),
  unique(subject_id, name)
);

create table if not exists public.exams (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  subject_id uuid references public.subjects(id) on delete set null,
  duration_minutes integer not null default 30 check (duration_minutes > 0),
  total_marks numeric(8,2) not null default 0 check (total_marks >= 0),
  is_published boolean not null default false,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  exam_id uuid not null references public.exams(id) on delete cascade,
  topic_id uuid references public.topics(id) on delete set null,
  question_text text not null,
  options jsonb not null check (jsonb_typeof(options) = 'array' and jsonb_array_length(options) = 4),
  correct_answer integer not null check (correct_answer between 0 and 3),
  difficulty public.question_difficulty not null default 'medium',
  marks numeric(8,2) not null default 1 check (marks > 0),
  negative_marks numeric(8,2) not null default 0 check (negative_marks >= 0),
  display_order integer not null default 1,
  created_at timestamptz not null default now()
);

create table if not exists public.exam_attempts (
  id uuid primary key default gen_random_uuid(),
  exam_id uuid not null references public.exams(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  status public.exam_status not null default 'in_progress',
  started_at timestamptz not null default now(),
  submitted_at timestamptz,
  score numeric(8,2) not null default 0,
  percentage numeric(6,2) not null default 0,
  correct_count integer not null default 0,
  incorrect_count integer not null default 0,
  unanswered_count integer not null default 0
);

create table if not exists public.student_answers (
  id uuid primary key default gen_random_uuid(),
  attempt_id uuid not null references public.exam_attempts(id) on delete cascade,
  question_id uuid not null references public.questions(id) on delete cascade,
  selected_answer integer check (selected_answer between 0 and 3),
  is_correct boolean not null default false,
  marks_awarded numeric(8,2) not null default 0,
  time_taken_seconds integer not null default 0 check (time_taken_seconds >= 0),
  unique(attempt_id, question_id)
);

create table if not exists public.performance_metrics (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  topic_id uuid not null references public.topics(id) on delete cascade,
  attempted integer not null default 0,
  correct integer not null default 0,
  accuracy numeric(6,2) not null default 0,
  total_time_seconds integer not null default 0,
  updated_at timestamptz not null default now(),
  unique(user_id, topic_id)
);

create table if not exists public.student_stats (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  total_xp integer not null default 0,
  quizzes_completed integer not null default 0,
  streak_days integer not null default 0,
  last_quiz_date timestamptz
);

create table if not exists public.proctoring_events (
  id uuid primary key default gen_random_uuid(),
  attempt_id uuid not null references public.exam_attempts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  event_type text not null,
  detail text,
  created_at timestamptz not null default now()
);

create table if not exists public.badges (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  description text not null,
  xp_required integer not null default 0
);

create table if not exists public.student_badges (
  user_id uuid references public.profiles(id) on delete cascade,
  badge_id uuid references public.badges(id) on delete cascade,
  earned_at timestamptz not null default now(),
  primary key(user_id, badge_id)
);

-- Create a profile automatically when Supabase Auth creates a user.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, full_name, college)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', split_part(coalesce(new.email,''), '@', 1), 'Student'),
    nullif(new.raw_user_meta_data ->> 'college', '')
  );
  insert into public.student_stats (user_id) values (new.id);
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- RLS
alter table public.profiles enable row level security;
alter table public.subjects enable row level security;
alter table public.topics enable row level security;
alter table public.exams enable row level security;
alter table public.questions enable row level security;
alter table public.exam_attempts enable row level security;
alter table public.student_answers enable row level security;
alter table public.performance_metrics enable row level security;
alter table public.student_stats enable row level security;
alter table public.proctoring_events enable row level security;
alter table public.badges enable row level security;
alter table public.student_badges enable row level security;

drop policy if exists "profile self read" on public.profiles;
create policy "profile self read" on public.profiles for select using (auth.uid() = id);

drop policy if exists "published exams readable" on public.exams;
create policy "published exams readable" on public.exams for select using (is_published = true);

drop policy if exists "subjects readable" on public.subjects;
create policy "subjects readable" on public.subjects for select using (true);

drop policy if exists "topics readable" on public.topics;
create policy "topics readable" on public.topics for select using (true);

drop policy if exists "own attempts readable" on public.exam_attempts;
create policy "own attempts readable" on public.exam_attempts for select using (auth.uid() = user_id);

drop policy if exists "own metrics readable" on public.performance_metrics;
create policy "own metrics readable" on public.performance_metrics for select using (auth.uid() = user_id);

drop policy if exists "stats readable" on public.student_stats;
create policy "stats readable" on public.student_stats for select using (true);

drop policy if exists "badges readable" on public.badges;
create policy "badges readable" on public.badges for select using (true);

-- Correct answers are intentionally not granted through a client-side RLS policy.
-- The backend uses the server-only service role to evaluate submissions.

create index if not exists idx_questions_exam on public.questions(exam_id, display_order);
create index if not exists idx_attempts_user on public.exam_attempts(user_id, submitted_at desc);
create index if not exists idx_answers_attempt on public.student_answers(attempt_id);
create index if not exists idx_metrics_user on public.performance_metrics(user_id);
create index if not exists idx_proctor_attempt on public.proctoring_events(attempt_id, created_at);
