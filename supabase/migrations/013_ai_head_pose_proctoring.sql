alter type public.exam_status add value if not exists 'paused';
alter type public.exam_status add value if not exists 'terminated';

alter table public.exams
  add column if not exists head_turn_yaw_threshold numeric(5,2) not null default 25,
  add column if not exists head_turn_duration_seconds integer not null default 2;

alter table public.exam_attempts
  add column if not exists paused_at timestamptz,
  add column if not exists paused_reason text,
  add column if not exists remaining_seconds_at_pause integer,
  add column if not exists reviewed_at timestamptz,
  add column if not exists review_action text;

create index if not exists idx_exam_attempts_paused on public.exam_attempts(status, paused_at desc);

do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'proctoring_reports') then
    alter publication supabase_realtime add table public.proctoring_reports;
  end if;
end $$;
