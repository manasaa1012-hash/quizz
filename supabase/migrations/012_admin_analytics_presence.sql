-- Admin analytics uses existing submitted attempts and answer snapshots. This table
-- only tracks a short-lived, authenticated browser heartbeat for live students.
create table if not exists public.student_presence (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  current_exam_id uuid references public.exams(id) on delete set null,
  session_started_at timestamptz not null default now(),
  last_activity_at timestamptz not null default now(),
  expires_at timestamptz not null default (now() + interval '90 seconds')
);

create index if not exists idx_student_presence_active
  on public.student_presence (expires_at desc);

alter table public.student_presence enable row level security;

drop policy if exists "presence owner readable" on public.student_presence;
create policy "presence owner readable" on public.student_presence
for select to authenticated using (auth.uid() = user_id or public.is_admin());

-- Presence writes are made by the authenticated backend using its service role.
