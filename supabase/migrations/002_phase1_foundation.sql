create type public.account_status as enum ('active', 'pending_verification', 'suspended');
create type public.exam_publication_status as enum ('draft', 'published', 'archived');

alter table public.profiles
  add column if not exists email text,
  add column if not exists institution text,
  add column if not exists avatar_url text,
  add column if not exists last_login timestamptz,
  add column if not exists account_status public.account_status not null default 'active',
  add column if not exists updated_at timestamptz not null default now();

update public.profiles
set
  email = coalesce(profiles.email, users.email),
  institution = coalesce(profiles.institution, profiles.college),
  updated_at = now()
from auth.users as users
where users.id = profiles.id;

create unique index if not exists idx_profiles_email_unique on public.profiles (lower(email));

alter table public.subjects
  add column if not exists is_active boolean not null default true,
  add column if not exists updated_at timestamptz not null default now();

alter table public.topics
  add column if not exists is_active boolean not null default true,
  add column if not exists updated_at timestamptz not null default now();

alter table public.exams
  add column if not exists passing_marks numeric(8,2) not null default 0,
  add column if not exists negative_marking boolean not null default false,
  add column if not exists start_date timestamptz,
  add column if not exists end_date timestamptz,
  add column if not exists status public.exam_publication_status not null default 'draft',
  add column if not exists shuffle_questions boolean not null default false,
  add column if not exists shuffle_options boolean not null default false,
  add column if not exists allow_review boolean not null default true,
  add column if not exists proctoring_enabled boolean not null default false,
  add column if not exists fullscreen_required boolean not null default false,
  add column if not exists max_tab_switches integer not null default 3,
  add column if not exists attempt_limit integer not null default 1,
  add column if not exists updated_at timestamptz not null default now();

update public.exams
set
  passing_marks = case
    when passing_marks = 0 then round((coalesce(total_marks, 0) * 0.4)::numeric, 2)
    else passing_marks
  end,
  status = case
    when is_published then 'published'::public.exam_publication_status
    else 'draft'::public.exam_publication_status
  end,
  updated_at = now();

alter table public.exams
  add constraint exams_max_tab_switches_check check (max_tab_switches >= 0),
  add constraint exams_attempt_limit_check check (attempt_limit >= 1),
  add constraint exams_passing_marks_check check (passing_marks >= 0),
  add constraint exams_date_window_check check (end_date is null or start_date is null or end_date >= start_date);

alter table public.questions
  alter column exam_id drop not null;

alter table public.questions
  add column if not exists subject_id uuid references public.subjects(id) on delete set null,
  add column if not exists question_image_url text,
  add column if not exists option_images jsonb,
  add column if not exists explanation text,
  add column if not exists created_by uuid references public.profiles(id) on delete set null,
  add column if not exists updated_at timestamptz not null default now(),
  add column if not exists is_active boolean not null default true;

update public.questions as q
set
  subject_id = e.subject_id,
  created_by = e.created_by,
  updated_at = now()
from public.exams as e
where e.id = q.exam_id
  and (q.subject_id is null or q.created_by is null);

alter table public.questions
  add constraint questions_option_images_check check (
    option_images is null
    or (
      jsonb_typeof(option_images) = 'array'
      and jsonb_array_length(option_images) = 4
    )
  );

create table if not exists public.exam_questions (
  id uuid primary key default gen_random_uuid(),
  exam_id uuid not null references public.exams(id) on delete cascade,
  question_id uuid not null references public.questions(id) on delete cascade,
  display_order integer not null,
  created_at timestamptz not null default now(),
  unique (exam_id, question_id),
  unique (exam_id, display_order)
);

insert into public.exam_questions (exam_id, question_id, display_order)
select q.exam_id, q.id, q.display_order
from public.questions as q
where q.exam_id is not null
on conflict (exam_id, question_id) do update
set display_order = excluded.display_order;

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  message text not null,
  type text not null default 'info',
  is_read boolean not null default false,
  link_url text,
  created_at timestamptz not null default now()
);

create index if not exists idx_subjects_active_name on public.subjects (is_active, name);
create index if not exists idx_topics_subject_active_name on public.topics (subject_id, is_active, name);
create index if not exists idx_questions_subject_topic on public.questions (subject_id, topic_id);
create index if not exists idx_questions_filters on public.questions (is_active, difficulty, created_at desc);
create index if not exists idx_exam_questions_exam_order on public.exam_questions (exam_id, display_order);
create index if not exists idx_notifications_user_created on public.notifications (user_id, created_at desc);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
before update on public.profiles
for each row execute procedure public.set_updated_at();

drop trigger if exists subjects_set_updated_at on public.subjects;
create trigger subjects_set_updated_at
before update on public.subjects
for each row execute procedure public.set_updated_at();

drop trigger if exists topics_set_updated_at on public.topics;
create trigger topics_set_updated_at
before update on public.topics
for each row execute procedure public.set_updated_at();

drop trigger if exists exams_set_updated_at on public.exams;
create trigger exams_set_updated_at
before update on public.exams
for each row execute procedure public.set_updated_at();

drop trigger if exists questions_set_updated_at on public.questions;
create trigger questions_set_updated_at
before update on public.questions
for each row execute procedure public.set_updated_at();

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (
    id,
    full_name,
    college,
    institution,
    email,
    account_status,
    last_login
  )
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', split_part(coalesce(new.email, ''), '@', 1), 'Student'),
    nullif(new.raw_user_meta_data ->> 'college', ''),
    coalesce(nullif(new.raw_user_meta_data ->> 'institution', ''), nullif(new.raw_user_meta_data ->> 'college', '')),
    new.email,
    case when new.email_confirmed_at is null then 'pending_verification'::public.account_status else 'active'::public.account_status end,
    now()
  )
  on conflict (id) do update
  set
    full_name = excluded.full_name,
    college = coalesce(excluded.college, public.profiles.college),
    institution = coalesce(excluded.institution, public.profiles.institution),
    email = excluded.email,
    account_status = excluded.account_status,
    last_login = now();

  insert into public.student_stats (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

create or replace function public.handle_auth_user_updated()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  update public.profiles
  set
    email = new.email,
    account_status = case
      when new.email_confirmed_at is null then 'pending_verification'::public.account_status
      else 'active'::public.account_status
    end,
    last_login = now()
  where id = new.id;

  return new;
end;
$$;

drop trigger if exists on_auth_user_updated on auth.users;
create trigger on_auth_user_updated
after update on auth.users
for each row execute procedure public.handle_auth_user_updated();

alter table public.notifications enable row level security;
alter table public.exam_questions enable row level security;

drop policy if exists "profile self read" on public.profiles;
create policy "profile self read" on public.profiles for select using (auth.uid() = id);

drop policy if exists "published exams readable" on public.exams;
create policy "published exams readable" on public.exams for select using (status = 'published' and is_published = true);

drop policy if exists "subjects readable" on public.subjects;
create policy "subjects readable" on public.subjects for select using (is_active = true);

drop policy if exists "topics readable" on public.topics;
create policy "topics readable" on public.topics for select using (is_active = true);

drop policy if exists "own attempts readable" on public.exam_attempts;
create policy "own attempts readable" on public.exam_attempts for select using (auth.uid() = user_id);

drop policy if exists "own metrics readable" on public.performance_metrics;
create policy "own metrics readable" on public.performance_metrics for select using (auth.uid() = user_id);

drop policy if exists "stats readable" on public.student_stats;
create policy "stats readable" on public.student_stats for select using (auth.uid() = user_id);

drop policy if exists "badges readable" on public.badges;
create policy "badges readable" on public.badges for select using (true);

drop policy if exists "student badges readable" on public.student_badges;
create policy "student badges readable" on public.student_badges for select using (auth.uid() = user_id);

drop policy if exists "notifications self read" on public.notifications;
create policy "notifications self read" on public.notifications for select using (auth.uid() = user_id);

drop policy if exists "exam questions readable" on public.exam_questions;
create policy "exam questions readable" on public.exam_questions
for select using (
  exists (
    select 1
    from public.exams
    where exams.id = exam_questions.exam_id
      and exams.status = 'published'
      and exams.is_published = true
  )
);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('avatars', 'avatars', true, 5242880, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do update
set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('question-media', 'question-media', true, 7340032, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do update
set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "avatar upload own folder" on storage.objects;
create policy "avatar upload own folder" on storage.objects
for insert to authenticated
with check (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
);

drop policy if exists "avatar update own folder" on storage.objects;
create policy "avatar update own folder" on storage.objects
for update to authenticated
using (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
)
with check (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
);

drop policy if exists "avatar delete own folder" on storage.objects;
create policy "avatar delete own folder" on storage.objects
for delete to authenticated
using (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
);

drop policy if exists "avatar public read" on storage.objects;
create policy "avatar public read" on storage.objects
for select using (bucket_id = 'avatars');

drop policy if exists "question media upload" on storage.objects;
create policy "question media upload" on storage.objects
for insert to authenticated
with check (bucket_id = 'question-media');

drop policy if exists "question media update" on storage.objects;
create policy "question media update" on storage.objects
for update to authenticated
using (bucket_id = 'question-media')
with check (bucket_id = 'question-media');

drop policy if exists "question media delete" on storage.objects;
create policy "question media delete" on storage.objects
for delete to authenticated
using (bucket_id = 'question-media');

drop policy if exists "question media public read" on storage.objects;
create policy "question media public read" on storage.objects
for select using (bucket_id = 'question-media');
