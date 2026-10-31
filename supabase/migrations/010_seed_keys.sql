alter table public.exams
  add column if not exists seed_key text;

alter table public.questions
  add column if not exists seed_key text;

create unique index if not exists idx_exams_seed_key_unique
  on public.exams(seed_key);

create unique index if not exists idx_questions_seed_key_unique
  on public.questions(seed_key);
