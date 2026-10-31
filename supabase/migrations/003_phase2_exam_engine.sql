alter table public.exams
  add column if not exists instructions text,
  add column if not exists is_active boolean not null default true;

alter table public.exam_attempts
  add column if not exists attempt_number integer not null default 1,
  add column if not exists expires_at timestamptz,
  add column if not exists last_saved_at timestamptz,
  add column if not exists total_time_seconds integer not null default 0,
  add column if not exists average_response_time_seconds numeric(8,2) not null default 0,
  add column if not exists accuracy numeric(6,2) not null default 0,
  add column if not exists passed boolean not null default false,
  add column if not exists marks_gained numeric(8,2) not null default 0,
  add column if not exists negative_marks_obtained numeric(8,2) not null default 0;

alter table public.exam_attempts
  add constraint exam_attempts_attempt_number_check check (attempt_number >= 1),
  add constraint exam_attempts_total_time_check check (total_time_seconds >= 0),
  add constraint exam_attempts_avg_response_check check (average_response_time_seconds >= 0),
  add constraint exam_attempts_accuracy_check check (accuracy >= 0 and accuracy <= 100),
  add constraint exam_attempts_marks_gained_check check (marks_gained >= 0),
  add constraint exam_attempts_negative_marks_check check (negative_marks_obtained >= 0);

alter table public.student_answers
  add column if not exists marked_for_review boolean not null default false,
  add column if not exists visited boolean not null default false,
  add column if not exists updated_at timestamptz not null default now(),
  add column if not exists display_order integer,
  add column if not exists option_order jsonb;

alter table public.student_answers
  add constraint student_answers_option_order_check check (
    option_order is null
    or (
      jsonb_typeof(option_order) = 'array'
      and jsonb_array_length(option_order) = 4
    )
  );

create index if not exists idx_attempts_exam_user_status on public.exam_attempts(exam_id, user_id, status);
create index if not exists idx_answers_attempt_display_order on public.student_answers(attempt_id, display_order);
create index if not exists idx_answers_attempt_updated on public.student_answers(attempt_id, updated_at desc);
