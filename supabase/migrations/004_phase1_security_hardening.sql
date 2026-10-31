-- Phase 1 hardening: preserve suspensions, restrict admin media, and enforce
-- question/topic consistency. This migration is forward-only and data-safe.

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'admin'::public.user_role
      and account_status = 'active'::public.account_status
  );
$$;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

create or replace function public.handle_auth_user_updated()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.profiles
  set
    email = new.email,
    account_status = case
      when public.profiles.account_status = 'suspended'::public.account_status
        then 'suspended'::public.account_status
      when new.email_confirmed_at is null
        then 'pending_verification'::public.account_status
      else 'active'::public.account_status
    end,
    last_login = coalesce(new.last_sign_in_at, public.profiles.last_login)
  where id = new.id;

  return new;
end;
$$;

create or replace function public.validate_question_topic_subject()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.topic_id is not null and not exists (
    select 1
    from public.topics
    where id = new.topic_id
      and subject_id = new.subject_id
  ) then
    raise exception 'The selected topic does not belong to the selected subject.';
  end if;
  return new;
end;
$$;

drop trigger if exists questions_validate_topic_subject on public.questions;
create trigger questions_validate_topic_subject
before insert or update of subject_id, topic_id on public.questions
for each row execute procedure public.validate_question_topic_subject();

create or replace function public.reorder_exam_questions(
  p_exam_id uuid,
  p_question_ids uuid[]
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  expected_count integer;
  supplied_count integer;
begin
  select count(*) into expected_count
  from public.exam_questions
  where exam_id = p_exam_id;

  select count(distinct supplied.question_id) into supplied_count
  from unnest(p_question_ids) as supplied(question_id);

  if supplied_count <> expected_count or array_length(p_question_ids, 1) <> expected_count then
    raise exception 'Question order must contain every attached question exactly once.';
  end if;

  if exists (
    select 1 from unnest(p_question_ids) as supplied(question_id)
    where not exists (
      select 1 from public.exam_questions
      where exam_id = p_exam_id and question_id = supplied.question_id
    )
  ) then
    raise exception 'Question order contains a question not attached to this exam.';
  end if;

  update public.exam_questions
  set display_order = -display_order
  where exam_id = p_exam_id;

  update public.exam_questions as eq
  set display_order = ordered.position
  from unnest(p_question_ids) with ordinality as ordered(question_id, position)
  where eq.exam_id = p_exam_id
    and eq.question_id = ordered.question_id;
end;
$$;

revoke all on function public.reorder_exam_questions(uuid, uuid[]) from public;
grant execute on function public.reorder_exam_questions(uuid, uuid[]) to service_role;

drop policy if exists "question media upload" on storage.objects;
drop policy if exists "question media update" on storage.objects;
drop policy if exists "question media delete" on storage.objects;

create policy "question media admin upload" on storage.objects
for insert to authenticated
with check (
  bucket_id = 'question-media'
  and public.is_admin()
  and (storage.foldername(name))[1] = auth.uid()::text
);

create policy "question media admin update" on storage.objects
for update to authenticated
using (
  bucket_id = 'question-media'
  and public.is_admin()
  and (storage.foldername(name))[1] = auth.uid()::text
)
with check (
  bucket_id = 'question-media'
  and public.is_admin()
  and (storage.foldername(name))[1] = auth.uid()::text
);

create policy "question media admin delete" on storage.objects
for delete to authenticated
using (
  bucket_id = 'question-media'
  and public.is_admin()
  and (storage.foldername(name))[1] = auth.uid()::text
);

create index if not exists idx_profiles_role_status_created
  on public.profiles (role, account_status, created_at desc);
create index if not exists idx_exams_status_created
  on public.exams (status, created_at desc);
create index if not exists idx_attempts_status_submitted
  on public.exam_attempts (status, submitted_at desc);
