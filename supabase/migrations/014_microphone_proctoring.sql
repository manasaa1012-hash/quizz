-- Allow an administrator to require microphone access for a proctored exam.
alter table public.exams
  add column if not exists microphone_required boolean not null default false;
