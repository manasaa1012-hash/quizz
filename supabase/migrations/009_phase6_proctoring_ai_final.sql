-- Phase 6: privacy-aware proctoring, server-calculated risk reports, and AI question drafts.

alter table public.exams
  add column if not exists webcam_required boolean not null default false,
  add column if not exists camera_denied_action text not null default 'warn';

alter table public.exams
  drop constraint if exists exams_camera_denied_action_check;
alter table public.exams
  add constraint exams_camera_denied_action_check
  check (camera_denied_action in ('warn', 'block'));

alter table public.proctoring_events
  add column if not exists severity text not null default 'low',
  add column if not exists details jsonb not null default '{}'::jsonb;

alter table public.proctoring_events
  drop constraint if exists proctoring_events_severity_check;
alter table public.proctoring_events
  add constraint proctoring_events_severity_check
  check (severity in ('info', 'low', 'medium', 'high', 'critical'));

-- Preserve legacy detail values while new clients use structured metadata.
update public.proctoring_events
set details = jsonb_build_object('message', detail)
where coalesce(detail, '') <> '' and details = '{}'::jsonb;

create index if not exists idx_proctor_events_user_created
  on public.proctoring_events(user_id, created_at desc);
create index if not exists idx_proctor_events_type_created
  on public.proctoring_events(event_type, created_at desc);

create table if not exists public.proctoring_reports (
  attempt_id uuid primary key references public.exam_attempts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  exam_id uuid not null references public.exams(id) on delete cascade,
  risk_score integer not null default 0 check (risk_score between 0 and 100),
  risk_level text not null default 'Low'
    check (risk_level in ('Low', 'Moderate', 'Suspicious', 'High Risk')),
  event_counts jsonb not null default '{}'::jsonb,
  calculation jsonb not null default '{}'::jsonb,
  calculated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create index if not exists idx_proctor_reports_risk
  on public.proctoring_reports(risk_score desc, calculated_at desc);
create index if not exists idx_proctor_reports_exam
  on public.proctoring_reports(exam_id, calculated_at desc);
create index if not exists idx_proctor_reports_user
  on public.proctoring_reports(user_id, calculated_at desc);

create table if not exists public.ai_question_drafts (
  id uuid primary key default gen_random_uuid(),
  created_by uuid not null references public.profiles(id) on delete cascade,
  subject_id uuid references public.subjects(id) on delete set null,
  topic_id uuid references public.topics(id) on delete set null,
  question_type text not null default 'multiple_choice',
  question_text text not null,
  options jsonb not null check (jsonb_typeof(options) = 'array' and jsonb_array_length(options) = 4),
  correct_answer integer not null check (correct_answer between 0 and 3),
  explanation text not null,
  difficulty public.question_difficulty not null,
  status text not null default 'draft' check (status in ('draft', 'approved', 'saved')),
  provider text not null,
  approved_at timestamptz,
  saved_question_id uuid references public.questions(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_ai_question_drafts_creator
  on public.ai_question_drafts(created_by, status, created_at desc);

drop trigger if exists ai_question_drafts_set_updated_at on public.ai_question_drafts;
create trigger ai_question_drafts_set_updated_at
before update on public.ai_question_drafts
for each row execute procedure public.set_updated_at();

alter table public.proctoring_reports enable row level security;
alter table public.ai_question_drafts enable row level security;

-- Students may read their own immutable event/report history. All writes go through
-- the authenticated backend service role, so no INSERT/UPDATE/DELETE policy exists.
drop policy if exists "own proctor events readable" on public.proctoring_events;
create policy "own proctor events readable" on public.proctoring_events
for select to authenticated using (auth.uid() = user_id or public.is_admin());

drop policy if exists "own proctor reports readable" on public.proctoring_reports;
create policy "own proctor reports readable" on public.proctoring_reports
for select to authenticated using (auth.uid() = user_id or public.is_admin());

drop policy if exists "admin ai drafts" on public.ai_question_drafts;
create policy "admin ai drafts" on public.ai_question_drafts
for select to authenticated using (public.is_admin());

-- Tighten Phase 1 question-media policies: only admins can mutate exam content.
drop policy if exists "question media upload" on storage.objects;
drop policy if exists "question media update" on storage.objects;
drop policy if exists "question media delete" on storage.objects;
drop policy if exists "question media admin upload" on storage.objects;
drop policy if exists "question media admin update" on storage.objects;
drop policy if exists "question media admin delete" on storage.objects;
create policy "question media admin upload" on storage.objects for insert to authenticated
with check (bucket_id = 'question-media' and public.is_admin() and (storage.foldername(name))[1] = auth.uid()::text);
create policy "question media admin update" on storage.objects for update to authenticated
using (bucket_id = 'question-media' and public.is_admin() and (storage.foldername(name))[1] = auth.uid()::text)
with check (bucket_id = 'question-media' and public.is_admin() and (storage.foldername(name))[1] = auth.uid()::text);
create policy "question media admin delete" on storage.objects for delete to authenticated
using (bucket_id = 'question-media' and public.is_admin() and (storage.foldername(name))[1] = auth.uid()::text);
