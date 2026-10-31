


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."account_status" AS ENUM (
    'active',
    'pending_verification',
    'suspended'
);


ALTER TYPE "public"."account_status" OWNER TO "postgres";


CREATE TYPE "public"."exam_publication_status" AS ENUM (
    'draft',
    'published',
    'archived'
);


ALTER TYPE "public"."exam_publication_status" OWNER TO "postgres";


CREATE TYPE "public"."exam_status" AS ENUM (
    'in_progress',
    'submitted'
);


ALTER TYPE "public"."exam_status" OWNER TO "postgres";


CREATE TYPE "public"."multiplayer_phase" AS ENUM (
    'lobby',
    'countdown',
    'question',
    'reveal',
    'finished'
);


ALTER TYPE "public"."multiplayer_phase" OWNER TO "postgres";


CREATE TYPE "public"."multiplayer_room_status" AS ENUM (
    'open',
    'countdown',
    'in_progress',
    'finished',
    'closed'
);


ALTER TYPE "public"."multiplayer_room_status" OWNER TO "postgres";


CREATE TYPE "public"."question_difficulty" AS ENUM (
    'easy',
    'medium',
    'hard'
);


ALTER TYPE "public"."question_difficulty" OWNER TO "postgres";


CREATE TYPE "public"."user_role" AS ENUM (
    'student',
    'admin'
);


ALTER TYPE "public"."user_role" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."advance_multiplayer_room"("p_room_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
declare r public.multiplayer_rooms%rowtype; active_count integer; answer_count integer; begin
 select * into r from public.multiplayer_rooms where id=p_room_id for update; if not found then return; end if;
 if r.phase='countdown' and now()>=r.starts_at then update public.multiplayer_rooms set status='in_progress',phase='question',updated_at=now() where id=r.id; return; end if;
 if r.phase='question' then
  select count(*) into active_count from public.multiplayer_participants where room_id=r.id and left_at is null;
  select count(*) into answer_count from public.multiplayer_answers a join public.multiplayer_room_questions q on q.id=a.room_question_id where q.room_id=r.id and q.position=r.current_question_index;
  if now()>=r.question_ends_at or answer_count>=active_count then update public.multiplayer_rooms set phase='reveal',reveal_ends_at=now()+interval '4 seconds',updated_at=now() where id=r.id; end if; return;
 end if;
 if r.phase='reveal' and now()>=r.reveal_ends_at then
  if r.current_question_index+1>=r.question_count then perform public.finish_multiplayer_room(r.id); else
   update public.multiplayer_rooms set phase='question',current_question_index=current_question_index+1,question_started_at=now(),
    question_ends_at=now()+make_interval(secs=>question_time_seconds),reveal_ends_at=null,updated_at=now() where id=r.id; end if;
 end if;
end $$;


ALTER FUNCTION "public"."advance_multiplayer_room"("p_room_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."apply_attempt_rewards"("p_attempt_id" "uuid", "p_user_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
declare
  a public.exam_attempts%rowtype;
  s public.student_stats%rowtype;
  metric record;
  badge record;
  answered_count integer := 0;
  correct_count integer := 0;
  hard_correct integer := 0;
  total_seconds integer := 0;
  award integer := 30;
  old_level integer := 1;
  new_level integer := 1;
  new_streak integer := 1;
  old_rank integer;
  current_rank integer;
  is_new_day boolean := false;
  qualifies boolean;
begin
  select * into a from public.exam_attempts where id=p_attempt_id and user_id=p_user_id for update;
  if not found or a.status <> 'submitted' then raise exception using errcode='P0001', message='Submitted attempt not found'; end if;
  if a.reward_applied_at is not null then return false; end if;

  select count(*) filter(where sa.selected_answer is not null), count(*) filter(where sa.is_correct),
         count(*) filter(where sa.is_correct and coalesce(sa.question_snapshot->>'difficulty','medium')='hard'),
         coalesce(sum(sa.time_taken_seconds) filter(where sa.selected_answer is not null),0)
  into answered_count, correct_count, hard_correct, total_seconds
  from public.student_answers sa where sa.attempt_id=p_attempt_id;

  insert into public.student_stats(user_id) values(p_user_id) on conflict(user_id) do nothing;
  select * into s from public.student_stats where user_id=p_user_id for update;
  old_level := coalesce(s.current_level,1);
  is_new_day := s.last_activity_date is distinct from current_date;
  new_streak := case when not is_new_day then greatest(s.streak_days,1)
    when s.last_activity_date=current_date-1 then s.streak_days+1 else 1 end;
  award := 30 + correct_count*10 + hard_correct*5
    + case when answered_count>0 and correct_count=answered_count and coalesce(a.unanswered_count,0)=0 then 100 else 0 end
    + case when is_new_day then 20 else 0 end;

  if correct_count>0 then insert into public.xp_transactions(user_id,amount,reason,source_type,source_id)
    values(p_user_id,correct_count*10,'correct_answers','exam_attempt',p_attempt_id) on conflict do nothing; end if;
  if hard_correct>0 then insert into public.xp_transactions(user_id,amount,reason,source_type,source_id)
    values(p_user_id,hard_correct*5,'hard_answer_bonus','exam_attempt',p_attempt_id) on conflict do nothing; end if;
  insert into public.xp_transactions(user_id,amount,reason,source_type,source_id)
    values(p_user_id,30,'quiz_completed','exam_attempt',p_attempt_id) on conflict do nothing;
  if answered_count>0 and correct_count=answered_count and coalesce(a.unanswered_count,0)=0 then
    insert into public.xp_transactions(user_id,amount,reason,source_type,source_id) values(p_user_id,100,'perfect_score','exam_attempt',p_attempt_id) on conflict do nothing;
  end if;
  if is_new_day then
    insert into public.xp_transactions(user_id,amount,reason,source_type,source_id) values(p_user_id,20,'daily_streak_bonus','exam_attempt',p_attempt_id) on conflict do nothing;
  end if;

  for metric in select q.topic_id, count(*) filter(where sa.selected_answer is not null)::integer attempted,
      count(*) filter(where sa.is_correct)::integer correct, coalesce(sum(sa.time_taken_seconds),0)::integer total_time
    from public.student_answers sa join public.questions q on q.id=sa.question_id
    where sa.attempt_id=p_attempt_id and q.topic_id is not null group by q.topic_id
  loop
    insert into public.performance_metrics(user_id,topic_id,attempted,correct,accuracy,total_time_seconds,updated_at)
    values(p_user_id,metric.topic_id,metric.attempted,metric.correct,case when metric.attempted>0 then metric.correct*100.0/metric.attempted else 0 end,metric.total_time,now())
    on conflict(user_id,topic_id) do update set attempted=public.performance_metrics.attempted+excluded.attempted,
      correct=public.performance_metrics.correct+excluded.correct,total_time_seconds=public.performance_metrics.total_time_seconds+excluded.total_time_seconds,
      accuracy=case when public.performance_metrics.attempted+excluded.attempted>0 then
        (public.performance_metrics.correct+excluded.correct)*100.0/(public.performance_metrics.attempted+excluded.attempted) else 0 end,updated_at=now();
  end loop;

  update public.student_stats set total_xp=total_xp+award, quizzes_completed=quizzes_completed+1,
    streak_days=new_streak, longest_streak=greatest(longest_streak,new_streak),
    last_quiz_date=now(),last_activity_date=case when is_new_day then current_date else last_activity_date end,
    questions_solved=questions_solved+answered_count,correct_answers=correct_answers+correct_count,
    total_response_seconds=total_response_seconds+total_seconds,
    perfect_scores=perfect_scores+case when answered_count>0 and correct_count=answered_count and coalesce(a.unanswered_count,0)=0 then 1 else 0 end
  where user_id=p_user_id returning * into s;
  select coalesce(max(level_number),1) into new_level from public.levels where xp_required<=s.total_xp;
  update public.student_stats set current_level=new_level where user_id=p_user_id;
  update public.exam_attempts set xp_earned=award,reward_applied_at=now() where id=p_attempt_id;

  if new_level>old_level then
    insert into public.notifications(user_id,type,title,message,link,event_key)
    values(p_user_id,'level_up','Level up!',format('You reached Level %s.',new_level),'/app/achievements','level:'||new_level)
    on conflict(user_id,event_key) do nothing;
  end if;

  current_rank := (select count(*)+1 from public.student_stats other where other.total_xp>s.total_xp);
  select rank into old_rank from public.leaderboard_snapshots
    where user_id=p_user_id and scope='global' and period_key='all-time';
  insert into public.leaderboard_snapshots(user_id,scope,period_key,rank,metric_value,created_at)
  values(p_user_id,'global','all-time',current_rank,s.total_xp,now())
  on conflict(user_id,scope,period_key) do update set rank=excluded.rank,metric_value=excluded.metric_value,created_at=now();
  if old_rank is not null and old_rank-current_rank>=3 then
    insert into public.notifications(user_id,type,title,message,link,event_key)
    values(p_user_id,'rank_update','Leaderboard climb',format('You moved up to global rank #%s.',current_rank),'/app/leaderboard',format('rank:%s:%s',current_rank,current_date))
    on conflict(user_id,event_key) do nothing;
  end if;

  for badge in select * from public.badges b where b.is_active and not exists
    (select 1 from public.student_badges sb where sb.user_id=p_user_id and sb.badge_id=b.id)
  loop
    qualifies := case badge.criteria_type
      when 'quizzes_completed' then s.quizzes_completed>=badge.criteria_value
      when 'questions_solved' then s.questions_solved>=badge.criteria_value
      when 'total_xp' then s.total_xp>=badge.criteria_value
      when 'streak' then new_streak>=badge.criteria_value
      when 'accuracy' then s.questions_solved>=50 and s.correct_answers*100.0/nullif(s.questions_solved,0)>=badge.criteria_value
      when 'speed_under' then s.questions_solved>=50 and s.total_response_seconds/nullif(s.questions_solved,0)<=badge.criteria_value
      when 'perfect_scores' then s.perfect_scores>=badge.criteria_value
      when 'subject_accuracy' then exists(select 1 from public.exam_attempts ea join public.exams e on e.id=ea.exam_id where ea.user_id=p_user_id and ea.status='submitted' group by e.subject_id having count(*)>=3 and avg(ea.percentage)>=badge.criteria_value)
      when 'global_rank' then (select count(*)+1 from public.student_stats other where other.total_xp>s.total_xp)<=badge.criteria_value
      else false end;
    if qualifies then
      insert into public.student_badges(user_id,badge_id) values(p_user_id,badge.id) on conflict do nothing;
      if found then insert into public.notifications(user_id,type,title,message,link,event_key)
        values(p_user_id,'badge_earned','Badge earned',badge.name||': '||badge.description,'/app/achievements','badge:'||badge.id)
        on conflict(user_id,event_key) do nothing; end if;
    end if;
  end loop;
  return true;
end; $$;


ALTER FUNCTION "public"."apply_attempt_rewards"("p_attempt_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."finish_multiplayer_room"("p_room_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
declare r public.multiplayer_rooms%rowtype; row record; badge_row record; xp integer; begin
 select * into r from public.multiplayer_rooms where id=p_room_id for update; if r.status='finished' then return; end if;
 update public.multiplayer_rooms set status='finished',phase='finished',finished_at=now(),updated_at=now() where id=r.id;
 for row in select p.*,row_number() over(order by p.score desc,p.correct_count desc,coalesce(avg(a.response_time_ms),2147483647),p.joined_at)::integer rank,
   coalesce(avg(a.response_time_ms),0)::integer avg_ms from public.multiplayer_participants p left join public.multiplayer_answers a on a.participant_id=p.id
   where p.room_id=r.id and p.left_at is null group by p.id loop
   xp:=25+case row.rank when 1 then 75 when 2 then 40 when 3 then 20 else 0 end;
   insert into public.multiplayer_results(room_id,participant_id,user_id,rank,score,correct_count,question_count,accuracy,average_response_ms,xp_awarded)
    values(r.id,row.id,row.user_id,row.rank,row.score,row.correct_count,r.question_count,row.correct_count*100.0/r.question_count,row.avg_ms,xp) on conflict(room_id,user_id) do nothing;
   if found then
    insert into public.xp_transactions(user_id,amount,reason,source_type,source_id) values(row.user_id,xp,'multiplayer_reward','multiplayer_room',r.id) on conflict do nothing;
    update public.student_stats set total_xp=total_xp+xp where user_id=row.user_id;
    for badge_row in select b.* from public.badges b join public.student_stats s on s.user_id=row.user_id
      where b.is_active and b.criteria_type='total_xp' and s.total_xp>=b.criteria_value
        and not exists(select 1 from public.student_badges sb where sb.user_id=row.user_id and sb.badge_id=b.id)
    loop
      insert into public.student_badges(user_id,badge_id) values(row.user_id,badge_row.id) on conflict do nothing;
      if found then insert into public.notifications(user_id,type,title,message,link,event_key)
        values(row.user_id,'badge_earned','Badge earned',badge_row.name||': '||badge_row.description,'/app/achievements','badge:'||badge_row.id)
        on conflict(user_id,event_key) do nothing; end if;
    end loop;
    insert into public.notifications(user_id,type,title,message,link,event_key) values(row.user_id,'multiplayer_result',case when row.rank=1 then 'You won!' else 'Multiplayer results' end,
      format('You finished #%s in %s and earned %s XP.',row.rank,r.name,xp),'/app/multiplayer/'||r.room_code,'mp-result:'||r.id) on conflict(user_id,event_key) do nothing;
   end if;
 end loop;
 update public.student_stats s set current_level=coalesce((select max(level_number) from public.levels where xp_required<=s.total_xp),1)
  where user_id in(select user_id from public.multiplayer_participants where room_id=r.id);
end $$;


ALTER FUNCTION "public"."finish_multiplayer_room"("p_room_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_auth_user_updated"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
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


ALTER FUNCTION "public"."handle_auth_user_updated"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
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


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_admin"() RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'admin'::public.user_role
      and account_status = 'active'::public.account_status
  );
$$;


ALTER FUNCTION "public"."is_admin"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_multiplayer_member"("p_room_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
  select exists(select 1 from public.multiplayer_participants where room_id=p_room_id and user_id=auth.uid() and left_at is null)
$$;


ALTER FUNCTION "public"."is_multiplayer_member"("p_room_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."join_multiplayer_room"("p_room_id" "uuid", "p_user_id" "uuid") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$ declare r public.multiplayer_rooms%rowtype; pid uuid; participant_active boolean; begin
  select * into r from public.multiplayer_rooms where id=p_room_id for update;
  if not found or r.status<>'open' or r.phase<>'lobby' or now()>=r.expires_at then raise exception using errcode='P0001',message='Room is not open.'; end if;
  select id,left_at is null into pid,participant_active from public.multiplayer_participants where room_id=p_room_id and user_id=p_user_id;
  if pid is not null and participant_active then update public.multiplayer_participants set last_seen_at=now() where id=pid; return pid; end if;
  if (select count(*) from public.multiplayer_participants where room_id=p_room_id and left_at is null)>=r.max_players then raise exception using errcode='P0001',message='Room is full.'; end if;
  if pid is not null then update public.multiplayer_participants set left_at=null,is_ready=false,last_seen_at=now() where id=pid; return pid; end if;
  insert into public.multiplayer_participants(room_id,user_id) values(p_room_id,p_user_id) returning id into pid; return pid;
end $$;


ALTER FUNCTION "public"."join_multiplayer_room"("p_room_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."notify_adaptive_session_completed"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
begin
  if new.status='completed' and old.status is distinct from new.status and new.attempted>0 then
    insert into public.notifications(user_id,type,title,message,link,event_key)
    values(new.user_id,'adaptive_recommendation','Adaptive practice update',
      case when new.correct*100.0/new.attempted>=80 then 'Excellent work. Continue with harder practice.'
        when new.correct*100.0/new.attempted>=50 then 'Keep practicing this topic to strengthen mastery.'
        else 'Review this topic’s fundamentals before your next session.' end,
      '/app/adaptive','adaptive:'||new.id)
    on conflict(user_id,event_key) do nothing;
  end if;
  return new;
end; $$;


ALTER FUNCTION "public"."notify_adaptive_session_completed"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."reorder_exam_questions"("p_exam_id" "uuid", "p_question_ids" "uuid"[]) RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
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


ALTER FUNCTION "public"."reorder_exam_questions"("p_exam_id" "uuid", "p_question_ids" "uuid"[]) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


ALTER FUNCTION "public"."set_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."start_multiplayer_room"("p_room_id" "uuid", "p_actor_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$ declare r public.multiplayer_rooms%rowtype; begin
  select * into r from public.multiplayer_rooms where id=p_room_id for update;
  if not found or (r.host_id<>p_actor_id and not exists(select 1 from public.profiles where id=p_actor_id and role='admin')) then raise exception using errcode='P0001',message='Only the host or an admin can start.'; end if;
  if now()>=r.expires_at then raise exception using errcode='P0001',message='Room has expired.'; end if;
  if r.status<>'open' or (select count(*) from public.multiplayer_participants where room_id=r.id and left_at is null)<2 then raise exception using errcode='P0001',message='At least two active players are required.'; end if;
  if exists(select 1 from public.multiplayer_participants where room_id=r.id and user_id<>p_actor_id and left_at is null and not is_ready) then raise exception using errcode='P0001',message='All players must be ready.'; end if;
  update public.multiplayer_rooms set status='countdown',phase='countdown',current_question_index=0,starts_at=now()+interval '3 seconds',
    question_started_at=now()+interval '3 seconds',question_ends_at=now()+interval '3 seconds'+make_interval(secs=>question_time_seconds),started_at=now()+interval '3 seconds',updated_at=now() where id=r.id;
  insert into public.notifications(user_id,type,title,message,link,event_key)
    select user_id,'multiplayer_starting','Room starting',r.name||' is starting now.','/app/multiplayer/'||r.room_code,'mp-start:'||r.id
    from public.multiplayer_participants where room_id=r.id and left_at is null on conflict(user_id,event_key) do nothing;
end $$;


ALTER FUNCTION "public"."start_multiplayer_room"("p_room_id" "uuid", "p_actor_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."start_or_resume_exam_attempt"("p_exam_id" "uuid", "p_user_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
declare
  selected_exam public.exams%rowtype;
  existing_attempt public.exam_attempts%rowtype;
  created_attempt public.exam_attempts%rowtype;
  submitted_count integer;
  question_count integer;
  v_current_time timestamptz := now();
begin
  perform pg_advisory_xact_lock(hashtextextended(p_user_id::text || ':' || p_exam_id::text, 0));

  select * into selected_exam
  from public.exams
  where id = p_exam_id;

  if not found then
    raise exception using errcode = 'P0001', message = 'Exam not available';
  end if;

  select * into existing_attempt
  from public.exam_attempts
  where exam_id = p_exam_id
    and user_id = p_user_id
    and status = 'in_progress'
  order by started_at desc
  limit 1;

  if found then
    return jsonb_build_object('attempt', to_jsonb(existing_attempt), 'resumed', true);
  end if;

  if not selected_exam.is_published or selected_exam.status <> 'published'
    or not selected_exam.is_active then
    raise exception using errcode = 'P0001', message = 'Exam not available';
  end if;
  if selected_exam.start_date is not null and selected_exam.start_date > v_current_time then
    raise exception using errcode = 'P0001', message = 'This exam is not open yet';
  end if;
  if selected_exam.end_date is not null and selected_exam.end_date < v_current_time then
    raise exception using errcode = 'P0001', message = 'This exam is already closed';
  end if;

  select count(*) into submitted_count
  from public.exam_attempts
  where exam_id = p_exam_id
    and user_id = p_user_id
    and status = 'submitted';

  if submitted_count >= selected_exam.attempt_limit then
    raise exception using errcode = 'P0001', message = 'Attempt limit reached for this exam';
  end if;

  select count(*) into question_count
  from public.exam_questions eq
  join public.questions q on q.id = eq.question_id
  where eq.exam_id = p_exam_id and q.is_active;
  if question_count = 0 then
    raise exception using errcode = 'P0001', message = 'This exam has no questions';
  end if;

  insert into public.exam_attempts (
    exam_id, user_id, status, attempt_number, started_at, expires_at, last_saved_at
  ) values (
    p_exam_id,
    p_user_id,
    'in_progress',
    submitted_count + 1,
    v_current_time,
    v_current_time + make_interval(mins => selected_exam.duration_minutes),
    v_current_time
  )
  returning * into created_attempt;

  return jsonb_build_object('attempt', to_jsonb(created_attempt), 'resumed', false);
end;
$$;


ALTER FUNCTION "public"."start_or_resume_exam_attempt"("p_exam_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."submit_multiplayer_answer"("p_room_id" "uuid", "p_user_id" "uuid", "p_selected" integer) RETURNS integer
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$ declare r public.multiplayer_rooms%rowtype; p public.multiplayer_participants%rowtype; rq public.multiplayer_room_questions%rowtype; correct integer; elapsed integer; earned integer:=0; begin
  select * into r from public.multiplayer_rooms where id=p_room_id for update;
  if not found or r.phase<>'question' or now()<r.question_started_at or now()>=r.question_ends_at then raise exception using errcode='P0001',message='Question is not accepting answers.'; end if;
  select * into p from public.multiplayer_participants where room_id=r.id and user_id=p_user_id and left_at is null;
  if not found then raise exception using errcode='P0001',message='You are not an active room member.'; end if;
  select * into rq from public.multiplayer_room_questions where room_id=r.id and position=r.current_question_index;
  select correct_answer into correct from public.questions where id=rq.question_id;
  elapsed:=greatest(0,least(r.question_time_seconds*1000,floor(extract(epoch from(now()-r.question_started_at))*1000)::integer));
  if p_selected=correct then earned:=1000+floor(500.0*(r.question_time_seconds*1000-elapsed)/(r.question_time_seconds*1000)); end if;
  insert into public.multiplayer_answers(room_id,participant_id,room_question_id,selected_answer,response_time_ms,is_correct,score_earned)
    values(r.id,p.id,rq.id,p_selected,elapsed,p_selected=correct,earned);
  update public.multiplayer_participants set score=score+earned,correct_count=correct_count+(p_selected=correct)::integer,last_seen_at=now() where id=p.id;
  return earned;
exception when unique_violation then raise exception using errcode='P0001',message='Answer already submitted.'; end $$;


ALTER FUNCTION "public"."submit_multiplayer_answer"("p_room_id" "uuid", "p_user_id" "uuid", "p_selected" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."validate_question_topic_subject"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO ''
    AS $$
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


ALTER FUNCTION "public"."validate_question_topic_subject"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."adaptive_session_questions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "session_id" "uuid" NOT NULL,
    "question_id" "uuid" NOT NULL,
    "question_order" integer NOT NULL,
    "difficulty" "public"."question_difficulty" NOT NULL,
    "selected_answer" integer,
    "is_correct" boolean,
    "response_time_seconds" integer,
    "ability_before" numeric(5,2) NOT NULL,
    "ability_after" numeric(5,2),
    "question_snapshot" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "answered_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "adaptive_session_questions_ability_after_check" CHECK ((("ability_after" >= (0)::numeric) AND ("ability_after" <= (100)::numeric))),
    CONSTRAINT "adaptive_session_questions_ability_before_check" CHECK ((("ability_before" >= (0)::numeric) AND ("ability_before" <= (100)::numeric))),
    CONSTRAINT "adaptive_session_questions_question_order_check" CHECK (("question_order" > 0)),
    CONSTRAINT "adaptive_session_questions_question_snapshot_check" CHECK (("jsonb_typeof"("question_snapshot") = 'object'::"text")),
    CONSTRAINT "adaptive_session_questions_response_time_seconds_check" CHECK (("response_time_seconds" >= 0)),
    CONSTRAINT "adaptive_session_questions_selected_answer_check" CHECK ((("selected_answer" >= 0) AND ("selected_answer" <= 3)))
);


ALTER TABLE "public"."adaptive_session_questions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."adaptive_sessions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "subject_id" "uuid" NOT NULL,
    "topic_id" "uuid" NOT NULL,
    "target_questions" integer NOT NULL,
    "status" "text" DEFAULT 'in_progress'::"text" NOT NULL,
    "ability_before" numeric(5,2) NOT NULL,
    "ability_after" numeric(5,2),
    "attempted" integer DEFAULT 0 NOT NULL,
    "correct" integer DEFAULT 0 NOT NULL,
    "started_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "completed_at" timestamp with time zone,
    CONSTRAINT "adaptive_sessions_ability_after_check" CHECK ((("ability_after" >= (0)::numeric) AND ("ability_after" <= (100)::numeric))),
    CONSTRAINT "adaptive_sessions_ability_before_check" CHECK ((("ability_before" >= (0)::numeric) AND ("ability_before" <= (100)::numeric))),
    CONSTRAINT "adaptive_sessions_status_check" CHECK (("status" = ANY (ARRAY['in_progress'::"text", 'completed'::"text"]))),
    CONSTRAINT "adaptive_sessions_target_questions_check" CHECK ((("target_questions" >= 1) AND ("target_questions" <= 50)))
);


ALTER TABLE "public"."adaptive_sessions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."ai_question_drafts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_by" "uuid" NOT NULL,
    "subject_id" "uuid",
    "topic_id" "uuid",
    "question_type" "text" DEFAULT 'multiple_choice'::"text" NOT NULL,
    "question_text" "text" NOT NULL,
    "options" "jsonb" NOT NULL,
    "correct_answer" integer NOT NULL,
    "explanation" "text" NOT NULL,
    "difficulty" "public"."question_difficulty" NOT NULL,
    "status" "text" DEFAULT 'draft'::"text" NOT NULL,
    "provider" "text" NOT NULL,
    "approved_at" timestamp with time zone,
    "saved_question_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "ai_question_drafts_correct_answer_check" CHECK ((("correct_answer" >= 0) AND ("correct_answer" <= 3))),
    CONSTRAINT "ai_question_drafts_options_check" CHECK ((("jsonb_typeof"("options") = 'array'::"text") AND ("jsonb_array_length"("options") = 4))),
    CONSTRAINT "ai_question_drafts_status_check" CHECK (("status" = ANY (ARRAY['draft'::"text", 'approved'::"text", 'saved'::"text"])))
);


ALTER TABLE "public"."ai_question_drafts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."badges" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text" NOT NULL,
    "xp_required" integer DEFAULT 0 NOT NULL,
    "icon" "text" DEFAULT 'Award'::"text" NOT NULL,
    "image_url" "text",
    "criteria_type" "text" DEFAULT 'total_xp'::"text" NOT NULL,
    "criteria_value" numeric(10,2) DEFAULT 0 NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."badges" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."exam_attempts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "exam_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "status" "public"."exam_status" DEFAULT 'in_progress'::"public"."exam_status" NOT NULL,
    "started_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "submitted_at" timestamp with time zone,
    "score" numeric(8,2) DEFAULT 0 NOT NULL,
    "percentage" numeric(6,2) DEFAULT 0 NOT NULL,
    "correct_count" integer DEFAULT 0 NOT NULL,
    "incorrect_count" integer DEFAULT 0 NOT NULL,
    "unanswered_count" integer DEFAULT 0 NOT NULL,
    "attempt_number" integer DEFAULT 1 NOT NULL,
    "expires_at" timestamp with time zone,
    "last_saved_at" timestamp with time zone,
    "total_time_seconds" integer DEFAULT 0 NOT NULL,
    "average_response_time_seconds" numeric(8,2) DEFAULT 0 NOT NULL,
    "accuracy" numeric(6,2) DEFAULT 0 NOT NULL,
    "passed" boolean DEFAULT false NOT NULL,
    "marks_gained" numeric(8,2) DEFAULT 0 NOT NULL,
    "negative_marks_obtained" numeric(8,2) DEFAULT 0 NOT NULL,
    "submission_token" "uuid",
    "xp_earned" integer DEFAULT 0 NOT NULL,
    "reward_applied_at" timestamp with time zone,
    CONSTRAINT "exam_attempts_accuracy_check" CHECK ((("accuracy" >= (0)::numeric) AND ("accuracy" <= (100)::numeric))),
    CONSTRAINT "exam_attempts_attempt_number_check" CHECK (("attempt_number" >= 1)),
    CONSTRAINT "exam_attempts_avg_response_check" CHECK (("average_response_time_seconds" >= (0)::numeric)),
    CONSTRAINT "exam_attempts_marks_gained_check" CHECK (("marks_gained" >= (0)::numeric)),
    CONSTRAINT "exam_attempts_negative_marks_check" CHECK (("negative_marks_obtained" >= (0)::numeric)),
    CONSTRAINT "exam_attempts_total_time_check" CHECK (("total_time_seconds" >= 0)),
    CONSTRAINT "exam_attempts_xp_earned_check" CHECK (("xp_earned" >= 0))
);


ALTER TABLE "public"."exam_attempts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."exam_questions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "exam_id" "uuid" NOT NULL,
    "question_id" "uuid" NOT NULL,
    "display_order" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."exam_questions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."exams" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "title" "text" NOT NULL,
    "description" "text",
    "subject_id" "uuid",
    "duration_minutes" integer DEFAULT 30 NOT NULL,
    "total_marks" numeric(8,2) DEFAULT 0 NOT NULL,
    "is_published" boolean DEFAULT false NOT NULL,
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "passing_marks" numeric(8,2) DEFAULT 0 NOT NULL,
    "negative_marking" boolean DEFAULT false NOT NULL,
    "start_date" timestamp with time zone,
    "end_date" timestamp with time zone,
    "status" "public"."exam_publication_status" DEFAULT 'draft'::"public"."exam_publication_status" NOT NULL,
    "shuffle_questions" boolean DEFAULT false NOT NULL,
    "shuffle_options" boolean DEFAULT false NOT NULL,
    "allow_review" boolean DEFAULT true NOT NULL,
    "proctoring_enabled" boolean DEFAULT false NOT NULL,
    "fullscreen_required" boolean DEFAULT false NOT NULL,
    "max_tab_switches" integer DEFAULT 3 NOT NULL,
    "attempt_limit" integer DEFAULT 1 NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "instructions" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "webcam_required" boolean DEFAULT false NOT NULL,
    "camera_denied_action" "text" DEFAULT 'warn'::"text" NOT NULL,
    "seed_key" "text",
    CONSTRAINT "exams_attempt_limit_check" CHECK (("attempt_limit" >= 1)),
    CONSTRAINT "exams_camera_denied_action_check" CHECK (("camera_denied_action" = ANY (ARRAY['warn'::"text", 'block'::"text"]))),
    CONSTRAINT "exams_date_window_check" CHECK ((("end_date" IS NULL) OR ("start_date" IS NULL) OR ("end_date" >= "start_date"))),
    CONSTRAINT "exams_duration_minutes_check" CHECK (("duration_minutes" > 0)),
    CONSTRAINT "exams_max_tab_switches_check" CHECK (("max_tab_switches" >= 0)),
    CONSTRAINT "exams_passing_marks_check" CHECK (("passing_marks" >= (0)::numeric)),
    CONSTRAINT "exams_total_marks_check" CHECK (("total_marks" >= (0)::numeric))
);


ALTER TABLE "public"."exams" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."leaderboard_snapshots" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "scope" "text" NOT NULL,
    "period_key" "text" NOT NULL,
    "rank" integer NOT NULL,
    "metric_value" numeric(12,2) DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "leaderboard_snapshots_rank_check" CHECK (("rank" > 0))
);


ALTER TABLE "public"."leaderboard_snapshots" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."levels" (
    "level_number" integer NOT NULL,
    "name" "text" NOT NULL,
    "xp_required" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "levels_level_number_check" CHECK (("level_number" > 0)),
    CONSTRAINT "levels_xp_required_check" CHECK (("xp_required" >= 0))
);


ALTER TABLE "public"."levels" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."multiplayer_answers" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "room_id" "uuid" NOT NULL,
    "participant_id" "uuid" NOT NULL,
    "room_question_id" "uuid" NOT NULL,
    "selected_answer" integer NOT NULL,
    "answered_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "response_time_ms" integer NOT NULL,
    "is_correct" boolean NOT NULL,
    "score_earned" integer NOT NULL,
    CONSTRAINT "multiplayer_answers_response_time_ms_check" CHECK (("response_time_ms" >= 0)),
    CONSTRAINT "multiplayer_answers_score_earned_check" CHECK (("score_earned" >= 0)),
    CONSTRAINT "multiplayer_answers_selected_answer_check" CHECK ((("selected_answer" >= 0) AND ("selected_answer" <= 3)))
);


ALTER TABLE "public"."multiplayer_answers" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."multiplayer_participants" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "room_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "is_ready" boolean DEFAULT false NOT NULL,
    "score" integer DEFAULT 0 NOT NULL,
    "correct_count" integer DEFAULT 0 NOT NULL,
    "joined_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "last_seen_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "left_at" timestamp with time zone,
    CONSTRAINT "multiplayer_participants_correct_count_check" CHECK (("correct_count" >= 0)),
    CONSTRAINT "multiplayer_participants_score_check" CHECK (("score" >= 0))
);


ALTER TABLE "public"."multiplayer_participants" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."multiplayer_results" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "room_id" "uuid" NOT NULL,
    "participant_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "rank" integer NOT NULL,
    "score" integer NOT NULL,
    "correct_count" integer NOT NULL,
    "question_count" integer NOT NULL,
    "accuracy" numeric(6,2) NOT NULL,
    "average_response_ms" integer DEFAULT 0 NOT NULL,
    "xp_awarded" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "multiplayer_results_rank_check" CHECK (("rank" > 0))
);


ALTER TABLE "public"."multiplayer_results" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."multiplayer_room_questions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "room_id" "uuid" NOT NULL,
    "question_id" "uuid" NOT NULL,
    "position" integer NOT NULL,
    CONSTRAINT "multiplayer_room_questions_position_check" CHECK (("position" >= 0))
);


ALTER TABLE "public"."multiplayer_room_questions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."multiplayer_rooms" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "room_code" "text" NOT NULL,
    "name" "text" NOT NULL,
    "host_id" "uuid" NOT NULL,
    "subject_id" "uuid",
    "topic_id" "uuid",
    "exam_id" "uuid",
    "difficulty" "public"."question_difficulty",
    "question_count" integer NOT NULL,
    "question_time_seconds" integer NOT NULL,
    "max_players" integer NOT NULL,
    "is_public" boolean DEFAULT false NOT NULL,
    "status" "public"."multiplayer_room_status" DEFAULT 'open'::"public"."multiplayer_room_status" NOT NULL,
    "phase" "public"."multiplayer_phase" DEFAULT 'lobby'::"public"."multiplayer_phase" NOT NULL,
    "current_question_index" integer DEFAULT '-1'::integer NOT NULL,
    "starts_at" timestamp with time zone,
    "question_started_at" timestamp with time zone,
    "question_ends_at" timestamp with time zone,
    "reveal_ends_at" timestamp with time zone,
    "started_at" timestamp with time zone,
    "finished_at" timestamp with time zone,
    "closed_at" timestamp with time zone,
    "expires_at" timestamp with time zone DEFAULT ("now"() + '02:00:00'::interval) NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "multiplayer_rooms_max_players_check" CHECK ((("max_players" >= 2) AND ("max_players" <= 50))),
    CONSTRAINT "multiplayer_rooms_name_check" CHECK ((("length"("name") >= 2) AND ("length"("name") <= 80))),
    CONSTRAINT "multiplayer_rooms_question_count_check" CHECK ((("question_count" >= 1) AND ("question_count" <= 50))),
    CONSTRAINT "multiplayer_rooms_question_time_seconds_check" CHECK ((("question_time_seconds" >= 10) AND ("question_time_seconds" <= 180))),
    CONSTRAINT "multiplayer_rooms_room_code_check" CHECK (("room_code" ~ '^[A-Z0-9]{6}$'::"text"))
);


ALTER TABLE "public"."multiplayer_rooms" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."notifications" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "title" "text" NOT NULL,
    "message" "text" NOT NULL,
    "type" "text" DEFAULT 'info'::"text" NOT NULL,
    "is_read" boolean DEFAULT false NOT NULL,
    "link_url" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "link" "text",
    "event_key" "text"
);


ALTER TABLE "public"."notifications" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."performance_metrics" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "topic_id" "uuid" NOT NULL,
    "attempted" integer DEFAULT 0 NOT NULL,
    "correct" integer DEFAULT 0 NOT NULL,
    "accuracy" numeric(6,2) DEFAULT 0 NOT NULL,
    "total_time_seconds" integer DEFAULT 0 NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."performance_metrics" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."performance_predictions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "predicted_score" numeric(5,2) NOT NULL,
    "confidence" numeric(5,4) NOT NULL,
    "trend" "text" NOT NULL,
    "risk_level" "text" NOT NULL,
    "feature_snapshot" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "actual_score" numeric(5,2),
    "prediction_error" numeric(6,2),
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "performance_predictions_actual_score_check" CHECK ((("actual_score" >= (0)::numeric) AND ("actual_score" <= (100)::numeric))),
    CONSTRAINT "performance_predictions_confidence_check" CHECK ((("confidence" >= (0)::numeric) AND ("confidence" <= (1)::numeric))),
    CONSTRAINT "performance_predictions_predicted_score_check" CHECK ((("predicted_score" >= (0)::numeric) AND ("predicted_score" <= (100)::numeric))),
    CONSTRAINT "performance_predictions_risk_level_check" CHECK (("risk_level" = ANY (ARRAY['Low'::"text", 'Moderate'::"text", 'High'::"text"]))),
    CONSTRAINT "performance_predictions_trend_check" CHECK (("trend" = ANY (ARRAY['improving'::"text", 'stable'::"text", 'declining'::"text"])))
);


ALTER TABLE "public"."performance_predictions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."proctoring_events" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "attempt_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "event_type" "text" NOT NULL,
    "detail" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "severity" "text" DEFAULT 'low'::"text" NOT NULL,
    "details" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    CONSTRAINT "proctoring_events_severity_check" CHECK (("severity" = ANY (ARRAY['info'::"text", 'low'::"text", 'medium'::"text", 'high'::"text", 'critical'::"text"])))
);


ALTER TABLE "public"."proctoring_events" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."proctoring_reports" (
    "attempt_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "exam_id" "uuid" NOT NULL,
    "risk_score" integer DEFAULT 0 NOT NULL,
    "risk_level" "text" DEFAULT 'Low'::"text" NOT NULL,
    "event_counts" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "calculation" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "calculated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "proctoring_reports_risk_level_check" CHECK (("risk_level" = ANY (ARRAY['Low'::"text", 'Moderate'::"text", 'Suspicious'::"text", 'High Risk'::"text"]))),
    CONSTRAINT "proctoring_reports_risk_score_check" CHECK ((("risk_score" >= 0) AND ("risk_score" <= 100)))
);


ALTER TABLE "public"."proctoring_reports" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "full_name" "text" DEFAULT 'Student'::"text" NOT NULL,
    "college" "text",
    "role" "public"."user_role" DEFAULT 'student'::"public"."user_role" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "email" "text",
    "institution" "text",
    "avatar_url" "text",
    "last_login" timestamp with time zone,
    "account_status" "public"."account_status" DEFAULT 'active'::"public"."account_status" NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."questions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "exam_id" "uuid",
    "topic_id" "uuid",
    "question_text" "text" NOT NULL,
    "options" "jsonb" NOT NULL,
    "correct_answer" integer NOT NULL,
    "difficulty" "public"."question_difficulty" DEFAULT 'medium'::"public"."question_difficulty" NOT NULL,
    "marks" numeric(8,2) DEFAULT 1 NOT NULL,
    "negative_marks" numeric(8,2) DEFAULT 0 NOT NULL,
    "display_order" integer DEFAULT 1 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "subject_id" "uuid",
    "question_image_url" "text",
    "option_images" "jsonb",
    "explanation" "text",
    "created_by" "uuid",
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "seed_key" "text",
    CONSTRAINT "questions_correct_answer_check" CHECK ((("correct_answer" >= 0) AND ("correct_answer" <= 3))),
    CONSTRAINT "questions_marks_check" CHECK (("marks" > (0)::numeric)),
    CONSTRAINT "questions_negative_marks_check" CHECK (("negative_marks" >= (0)::numeric)),
    CONSTRAINT "questions_option_images_check" CHECK ((("option_images" IS NULL) OR (("jsonb_typeof"("option_images") = 'array'::"text") AND ("jsonb_array_length"("option_images") = 4)))),
    CONSTRAINT "questions_options_check" CHECK ((("jsonb_typeof"("options") = 'array'::"text") AND ("jsonb_array_length"("options") = 4)))
);


ALTER TABLE "public"."questions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."recommendations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "topic_id" "uuid",
    "priority" "text" NOT NULL,
    "accuracy" numeric(5,2) DEFAULT 0 NOT NULL,
    "reason" "text" NOT NULL,
    "recommendation" "text" NOT NULL,
    "suggested_questions" integer DEFAULT 10 NOT NULL,
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "performance_version" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "recommendations_priority_check" CHECK (("priority" = ANY (ARRAY['high'::"text", 'medium'::"text", 'low'::"text"]))),
    CONSTRAINT "recommendations_status_check" CHECK (("status" = ANY (ARRAY['active'::"text", 'completed'::"text", 'dismissed'::"text"]))),
    CONSTRAINT "recommendations_suggested_questions_check" CHECK (("suggested_questions" > 0))
);


ALTER TABLE "public"."recommendations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."revision_plan_tasks" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "plan_id" "uuid" NOT NULL,
    "topic_id" "uuid",
    "scheduled_date" "date" NOT NULL,
    "day_number" integer NOT NULL,
    "activity" "text" NOT NULL,
    "target_questions" integer DEFAULT 15 NOT NULL,
    "status" "text" DEFAULT 'pending'::"text" NOT NULL,
    "completed_at" timestamp with time zone,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "revision_plan_tasks_day_number_check" CHECK (("day_number" > 0)),
    CONSTRAINT "revision_plan_tasks_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'completed'::"text", 'skipped'::"text"]))),
    CONSTRAINT "revision_plan_tasks_target_questions_check" CHECK (("target_questions" > 0))
);


ALTER TABLE "public"."revision_plan_tasks" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."revision_plans" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "duration_days" integer NOT NULL,
    "starts_on" "date" DEFAULT CURRENT_DATE NOT NULL,
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "revision_plans_duration_days_check" CHECK (("duration_days" = ANY (ARRAY[7, 14, 30]))),
    CONSTRAINT "revision_plans_status_check" CHECK (("status" = ANY (ARRAY['active'::"text", 'completed'::"text", 'archived'::"text"])))
);


ALTER TABLE "public"."revision_plans" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."student_answers" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "attempt_id" "uuid" NOT NULL,
    "question_id" "uuid" NOT NULL,
    "selected_answer" integer,
    "is_correct" boolean DEFAULT false NOT NULL,
    "marks_awarded" numeric(8,2) DEFAULT 0 NOT NULL,
    "time_taken_seconds" integer DEFAULT 0 NOT NULL,
    "marked_for_review" boolean DEFAULT false NOT NULL,
    "visited" boolean DEFAULT false NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "display_order" integer,
    "option_order" "jsonb",
    "question_snapshot" "jsonb",
    CONSTRAINT "student_answers_option_order_check" CHECK ((("option_order" IS NULL) OR (("jsonb_typeof"("option_order") = 'array'::"text") AND ("jsonb_array_length"("option_order") = 4)))),
    CONSTRAINT "student_answers_question_snapshot_check" CHECK ((("question_snapshot" IS NULL) OR ("jsonb_typeof"("question_snapshot") = 'object'::"text"))),
    CONSTRAINT "student_answers_selected_answer_check" CHECK ((("selected_answer" >= 0) AND ("selected_answer" <= 3))),
    CONSTRAINT "student_answers_time_taken_seconds_check" CHECK (("time_taken_seconds" >= 0))
);


ALTER TABLE "public"."student_answers" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."student_badges" (
    "user_id" "uuid" NOT NULL,
    "badge_id" "uuid" NOT NULL,
    "earned_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."student_badges" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."student_stats" (
    "user_id" "uuid" NOT NULL,
    "total_xp" integer DEFAULT 0 NOT NULL,
    "quizzes_completed" integer DEFAULT 0 NOT NULL,
    "streak_days" integer DEFAULT 0 NOT NULL,
    "last_quiz_date" timestamp with time zone,
    "current_level" integer DEFAULT 1 NOT NULL,
    "longest_streak" integer DEFAULT 0 NOT NULL,
    "last_activity_date" "date",
    "questions_solved" integer DEFAULT 0 NOT NULL,
    "correct_answers" integer DEFAULT 0 NOT NULL,
    "total_response_seconds" bigint DEFAULT 0 NOT NULL,
    "perfect_scores" integer DEFAULT 0 NOT NULL
);


ALTER TABLE "public"."student_stats" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."student_topic_ability" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "topic_id" "uuid" NOT NULL,
    "ability_score" numeric(5,2) DEFAULT 50 NOT NULL,
    "status" "text" DEFAULT 'Moderate'::"text" NOT NULL,
    "attempted" integer DEFAULT 0 NOT NULL,
    "accuracy" numeric(5,2) DEFAULT 0 NOT NULL,
    "recent_trend" numeric(7,2) DEFAULT 0 NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "student_topic_ability_ability_score_check" CHECK ((("ability_score" >= (0)::numeric) AND ("ability_score" <= (100)::numeric))),
    CONSTRAINT "student_topic_ability_accuracy_check" CHECK ((("accuracy" >= (0)::numeric) AND ("accuracy" <= (100)::numeric))),
    CONSTRAINT "student_topic_ability_attempted_check" CHECK (("attempted" >= 0)),
    CONSTRAINT "student_topic_ability_status_check" CHECK (("status" = ANY (ARRAY['Strong'::"text", 'Moderate'::"text", 'Weak'::"text", 'Critical'::"text"])))
);


ALTER TABLE "public"."student_topic_ability" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."subjects" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."subjects" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."topics" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "subject_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."topics" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."xp_transactions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "amount" integer NOT NULL,
    "reason" "text" NOT NULL,
    "source_type" "text" NOT NULL,
    "source_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "xp_transactions_amount_check" CHECK (("amount" <> 0))
);


ALTER TABLE "public"."xp_transactions" OWNER TO "postgres";


ALTER TABLE ONLY "public"."adaptive_session_questions"
    ADD CONSTRAINT "adaptive_session_questions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."adaptive_session_questions"
    ADD CONSTRAINT "adaptive_session_questions_session_id_question_id_key" UNIQUE ("session_id", "question_id");



ALTER TABLE ONLY "public"."adaptive_session_questions"
    ADD CONSTRAINT "adaptive_session_questions_session_id_question_order_key" UNIQUE ("session_id", "question_order");



ALTER TABLE ONLY "public"."adaptive_sessions"
    ADD CONSTRAINT "adaptive_sessions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."ai_question_drafts"
    ADD CONSTRAINT "ai_question_drafts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."badges"
    ADD CONSTRAINT "badges_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."badges"
    ADD CONSTRAINT "badges_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."exam_attempts"
    ADD CONSTRAINT "exam_attempts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."exam_questions"
    ADD CONSTRAINT "exam_questions_exam_id_display_order_key" UNIQUE ("exam_id", "display_order");



ALTER TABLE ONLY "public"."exam_questions"
    ADD CONSTRAINT "exam_questions_exam_id_question_id_key" UNIQUE ("exam_id", "question_id");



ALTER TABLE ONLY "public"."exam_questions"
    ADD CONSTRAINT "exam_questions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."exams"
    ADD CONSTRAINT "exams_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."leaderboard_snapshots"
    ADD CONSTRAINT "leaderboard_snapshots_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."leaderboard_snapshots"
    ADD CONSTRAINT "leaderboard_snapshots_user_id_scope_period_key_key" UNIQUE ("user_id", "scope", "period_key");



ALTER TABLE ONLY "public"."levels"
    ADD CONSTRAINT "levels_pkey" PRIMARY KEY ("level_number");



ALTER TABLE ONLY "public"."levels"
    ADD CONSTRAINT "levels_xp_required_key" UNIQUE ("xp_required");



ALTER TABLE ONLY "public"."multiplayer_answers"
    ADD CONSTRAINT "multiplayer_answers_participant_id_room_question_id_key" UNIQUE ("participant_id", "room_question_id");



ALTER TABLE ONLY "public"."multiplayer_answers"
    ADD CONSTRAINT "multiplayer_answers_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."multiplayer_participants"
    ADD CONSTRAINT "multiplayer_participants_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."multiplayer_participants"
    ADD CONSTRAINT "multiplayer_participants_room_id_user_id_key" UNIQUE ("room_id", "user_id");



ALTER TABLE ONLY "public"."multiplayer_results"
    ADD CONSTRAINT "multiplayer_results_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."multiplayer_results"
    ADD CONSTRAINT "multiplayer_results_room_id_rank_key" UNIQUE ("room_id", "rank");



ALTER TABLE ONLY "public"."multiplayer_results"
    ADD CONSTRAINT "multiplayer_results_room_id_user_id_key" UNIQUE ("room_id", "user_id");



ALTER TABLE ONLY "public"."multiplayer_room_questions"
    ADD CONSTRAINT "multiplayer_room_questions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."multiplayer_room_questions"
    ADD CONSTRAINT "multiplayer_room_questions_room_id_position_key" UNIQUE ("room_id", "position");



ALTER TABLE ONLY "public"."multiplayer_room_questions"
    ADD CONSTRAINT "multiplayer_room_questions_room_id_question_id_key" UNIQUE ("room_id", "question_id");



ALTER TABLE ONLY "public"."multiplayer_rooms"
    ADD CONSTRAINT "multiplayer_rooms_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."multiplayer_rooms"
    ADD CONSTRAINT "multiplayer_rooms_room_code_key" UNIQUE ("room_code");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_user_event_unique" UNIQUE ("user_id", "event_key");



ALTER TABLE ONLY "public"."performance_metrics"
    ADD CONSTRAINT "performance_metrics_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."performance_metrics"
    ADD CONSTRAINT "performance_metrics_user_id_topic_id_key" UNIQUE ("user_id", "topic_id");



ALTER TABLE ONLY "public"."performance_predictions"
    ADD CONSTRAINT "performance_predictions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."proctoring_events"
    ADD CONSTRAINT "proctoring_events_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."proctoring_reports"
    ADD CONSTRAINT "proctoring_reports_pkey" PRIMARY KEY ("attempt_id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."questions"
    ADD CONSTRAINT "questions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."recommendations"
    ADD CONSTRAINT "recommendations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."revision_plan_tasks"
    ADD CONSTRAINT "revision_plan_tasks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."revision_plans"
    ADD CONSTRAINT "revision_plans_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."student_answers"
    ADD CONSTRAINT "student_answers_attempt_id_question_id_key" UNIQUE ("attempt_id", "question_id");



ALTER TABLE ONLY "public"."student_answers"
    ADD CONSTRAINT "student_answers_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."student_badges"
    ADD CONSTRAINT "student_badges_pkey" PRIMARY KEY ("user_id", "badge_id");



ALTER TABLE ONLY "public"."student_stats"
    ADD CONSTRAINT "student_stats_pkey" PRIMARY KEY ("user_id");



ALTER TABLE ONLY "public"."student_topic_ability"
    ADD CONSTRAINT "student_topic_ability_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."student_topic_ability"
    ADD CONSTRAINT "student_topic_ability_user_id_topic_id_key" UNIQUE ("user_id", "topic_id");



ALTER TABLE ONLY "public"."subjects"
    ADD CONSTRAINT "subjects_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."subjects"
    ADD CONSTRAINT "subjects_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."topics"
    ADD CONSTRAINT "topics_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."topics"
    ADD CONSTRAINT "topics_subject_id_name_key" UNIQUE ("subject_id", "name");



ALTER TABLE ONLY "public"."xp_transactions"
    ADD CONSTRAINT "xp_transactions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."xp_transactions"
    ADD CONSTRAINT "xp_transactions_user_id_source_type_source_id_reason_key" UNIQUE ("user_id", "source_type", "source_id", "reason");



CREATE INDEX "idx_ability_user_score" ON "public"."student_topic_ability" USING "btree" ("user_id", "ability_score");



CREATE INDEX "idx_adaptive_questions_session_order" ON "public"."adaptive_session_questions" USING "btree" ("session_id", "question_order");



CREATE INDEX "idx_adaptive_sessions_user" ON "public"."adaptive_sessions" USING "btree" ("user_id", "started_at" DESC);



CREATE INDEX "idx_ai_question_drafts_creator" ON "public"."ai_question_drafts" USING "btree" ("created_by", "status", "created_at" DESC);



CREATE INDEX "idx_answers_attempt" ON "public"."student_answers" USING "btree" ("attempt_id");



CREATE INDEX "idx_answers_attempt_display_order" ON "public"."student_answers" USING "btree" ("attempt_id", "display_order");



CREATE INDEX "idx_answers_attempt_updated" ON "public"."student_answers" USING "btree" ("attempt_id", "updated_at" DESC);



CREATE INDEX "idx_attempts_exam_user_status" ON "public"."exam_attempts" USING "btree" ("exam_id", "user_id", "status");



CREATE INDEX "idx_attempts_status_submitted" ON "public"."exam_attempts" USING "btree" ("status", "submitted_at" DESC);



CREATE INDEX "idx_attempts_submission_claim" ON "public"."exam_attempts" USING "btree" ("id", "user_id", "status", "submission_token");



CREATE INDEX "idx_attempts_user" ON "public"."exam_attempts" USING "btree" ("user_id", "submitted_at" DESC);



CREATE INDEX "idx_badges_active_criteria" ON "public"."badges" USING "btree" ("is_active", "criteria_type");



CREATE INDEX "idx_exam_questions_exam_order" ON "public"."exam_questions" USING "btree" ("exam_id", "display_order");



CREATE UNIQUE INDEX "idx_exams_seed_key_unique" ON "public"."exams" USING "btree" ("seed_key");



CREATE INDEX "idx_exams_status_created" ON "public"."exams" USING "btree" ("status", "created_at" DESC);



CREATE INDEX "idx_leaderboard_snapshots_scope" ON "public"."leaderboard_snapshots" USING "btree" ("scope", "period_key", "rank");



CREATE INDEX "idx_metrics_user" ON "public"."performance_metrics" USING "btree" ("user_id");



CREATE INDEX "idx_mp_answers_room_question" ON "public"."multiplayer_answers" USING "btree" ("room_id", "room_question_id");



CREATE INDEX "idx_mp_participants_room" ON "public"."multiplayer_participants" USING "btree" ("room_id", "left_at", "score" DESC);



CREATE INDEX "idx_mp_questions_room" ON "public"."multiplayer_room_questions" USING "btree" ("room_id", "position");



CREATE INDEX "idx_mp_results_user" ON "public"."multiplayer_results" USING "btree" ("user_id", "created_at" DESC);



CREATE INDEX "idx_mp_rooms_public" ON "public"."multiplayer_rooms" USING "btree" ("status", "is_public", "created_at" DESC);



CREATE INDEX "idx_notifications_unread" ON "public"."notifications" USING "btree" ("user_id", "is_read", "created_at" DESC);



CREATE INDEX "idx_notifications_user_created" ON "public"."notifications" USING "btree" ("user_id", "created_at" DESC);



CREATE INDEX "idx_predictions_user_created" ON "public"."performance_predictions" USING "btree" ("user_id", "created_at" DESC);



CREATE INDEX "idx_proctor_attempt" ON "public"."proctoring_events" USING "btree" ("attempt_id", "created_at");



CREATE INDEX "idx_proctor_events_type_created" ON "public"."proctoring_events" USING "btree" ("event_type", "created_at" DESC);



CREATE INDEX "idx_proctor_events_user_created" ON "public"."proctoring_events" USING "btree" ("user_id", "created_at" DESC);



CREATE INDEX "idx_proctor_reports_exam" ON "public"."proctoring_reports" USING "btree" ("exam_id", "calculated_at" DESC);



CREATE INDEX "idx_proctor_reports_risk" ON "public"."proctoring_reports" USING "btree" ("risk_score" DESC, "calculated_at" DESC);



CREATE INDEX "idx_proctor_reports_user" ON "public"."proctoring_reports" USING "btree" ("user_id", "calculated_at" DESC);



CREATE UNIQUE INDEX "idx_profiles_email_unique" ON "public"."profiles" USING "btree" ("lower"("email"));



CREATE INDEX "idx_profiles_role_status_created" ON "public"."profiles" USING "btree" ("role", "account_status", "created_at" DESC);



CREATE INDEX "idx_questions_exam" ON "public"."questions" USING "btree" ("exam_id", "display_order");



CREATE INDEX "idx_questions_filters" ON "public"."questions" USING "btree" ("is_active", "difficulty", "created_at" DESC);



CREATE UNIQUE INDEX "idx_questions_seed_key_unique" ON "public"."questions" USING "btree" ("seed_key");



CREATE INDEX "idx_questions_subject_topic" ON "public"."questions" USING "btree" ("subject_id", "topic_id");



CREATE INDEX "idx_recommendations_user_status" ON "public"."recommendations" USING "btree" ("user_id", "status", "priority");



CREATE INDEX "idx_revision_plans_user" ON "public"."revision_plans" USING "btree" ("user_id", "created_at" DESC);



CREATE INDEX "idx_revision_tasks_plan_date" ON "public"."revision_plan_tasks" USING "btree" ("plan_id", "scheduled_date");



CREATE INDEX "idx_student_badges_earned" ON "public"."student_badges" USING "btree" ("user_id", "earned_at" DESC);



CREATE INDEX "idx_student_stats_ranking" ON "public"."student_stats" USING "btree" ("total_xp" DESC, "quizzes_completed" DESC);



CREATE INDEX "idx_subjects_active_name" ON "public"."subjects" USING "btree" ("is_active", "name");



CREATE INDEX "idx_topics_subject_active_name" ON "public"."topics" USING "btree" ("subject_id", "is_active", "name");



CREATE INDEX "idx_xp_period" ON "public"."xp_transactions" USING "btree" ("created_at" DESC, "user_id");



CREATE INDEX "idx_xp_user_created" ON "public"."xp_transactions" USING "btree" ("user_id", "created_at" DESC);



CREATE OR REPLACE TRIGGER "adaptive_session_completed_notification" AFTER UPDATE OF "status" ON "public"."adaptive_sessions" FOR EACH ROW EXECUTE FUNCTION "public"."notify_adaptive_session_completed"();



CREATE OR REPLACE TRIGGER "ai_question_drafts_set_updated_at" BEFORE UPDATE ON "public"."ai_question_drafts" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "exams_set_updated_at" BEFORE UPDATE ON "public"."exams" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "profiles_set_updated_at" BEFORE UPDATE ON "public"."profiles" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "questions_set_updated_at" BEFORE UPDATE ON "public"."questions" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "questions_validate_topic_subject" BEFORE INSERT OR UPDATE OF "subject_id", "topic_id" ON "public"."questions" FOR EACH ROW EXECUTE FUNCTION "public"."validate_question_topic_subject"();



CREATE OR REPLACE TRIGGER "subjects_set_updated_at" BEFORE UPDATE ON "public"."subjects" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "topics_set_updated_at" BEFORE UPDATE ON "public"."topics" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



ALTER TABLE ONLY "public"."adaptive_session_questions"
    ADD CONSTRAINT "adaptive_session_questions_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "public"."questions"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."adaptive_session_questions"
    ADD CONSTRAINT "adaptive_session_questions_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "public"."adaptive_sessions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."adaptive_sessions"
    ADD CONSTRAINT "adaptive_sessions_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "public"."subjects"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."adaptive_sessions"
    ADD CONSTRAINT "adaptive_sessions_topic_id_fkey" FOREIGN KEY ("topic_id") REFERENCES "public"."topics"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."adaptive_sessions"
    ADD CONSTRAINT "adaptive_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."ai_question_drafts"
    ADD CONSTRAINT "ai_question_drafts_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."ai_question_drafts"
    ADD CONSTRAINT "ai_question_drafts_saved_question_id_fkey" FOREIGN KEY ("saved_question_id") REFERENCES "public"."questions"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."ai_question_drafts"
    ADD CONSTRAINT "ai_question_drafts_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "public"."subjects"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."ai_question_drafts"
    ADD CONSTRAINT "ai_question_drafts_topic_id_fkey" FOREIGN KEY ("topic_id") REFERENCES "public"."topics"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."exam_attempts"
    ADD CONSTRAINT "exam_attempts_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "public"."exams"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."exam_attempts"
    ADD CONSTRAINT "exam_attempts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."exam_questions"
    ADD CONSTRAINT "exam_questions_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "public"."exams"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."exam_questions"
    ADD CONSTRAINT "exam_questions_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "public"."questions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."exams"
    ADD CONSTRAINT "exams_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."exams"
    ADD CONSTRAINT "exams_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "public"."subjects"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."leaderboard_snapshots"
    ADD CONSTRAINT "leaderboard_snapshots_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."multiplayer_answers"
    ADD CONSTRAINT "multiplayer_answers_participant_id_fkey" FOREIGN KEY ("participant_id") REFERENCES "public"."multiplayer_participants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."multiplayer_answers"
    ADD CONSTRAINT "multiplayer_answers_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "public"."multiplayer_rooms"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."multiplayer_answers"
    ADD CONSTRAINT "multiplayer_answers_room_question_id_fkey" FOREIGN KEY ("room_question_id") REFERENCES "public"."multiplayer_room_questions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."multiplayer_participants"
    ADD CONSTRAINT "multiplayer_participants_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "public"."multiplayer_rooms"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."multiplayer_participants"
    ADD CONSTRAINT "multiplayer_participants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."multiplayer_results"
    ADD CONSTRAINT "multiplayer_results_participant_id_fkey" FOREIGN KEY ("participant_id") REFERENCES "public"."multiplayer_participants"("id");



ALTER TABLE ONLY "public"."multiplayer_results"
    ADD CONSTRAINT "multiplayer_results_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "public"."multiplayer_rooms"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."multiplayer_results"
    ADD CONSTRAINT "multiplayer_results_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id");



ALTER TABLE ONLY "public"."multiplayer_room_questions"
    ADD CONSTRAINT "multiplayer_room_questions_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "public"."questions"("id");



ALTER TABLE ONLY "public"."multiplayer_room_questions"
    ADD CONSTRAINT "multiplayer_room_questions_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "public"."multiplayer_rooms"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."multiplayer_rooms"
    ADD CONSTRAINT "multiplayer_rooms_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "public"."exams"("id");



ALTER TABLE ONLY "public"."multiplayer_rooms"
    ADD CONSTRAINT "multiplayer_rooms_host_id_fkey" FOREIGN KEY ("host_id") REFERENCES "public"."profiles"("id");



ALTER TABLE ONLY "public"."multiplayer_rooms"
    ADD CONSTRAINT "multiplayer_rooms_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "public"."subjects"("id");



ALTER TABLE ONLY "public"."multiplayer_rooms"
    ADD CONSTRAINT "multiplayer_rooms_topic_id_fkey" FOREIGN KEY ("topic_id") REFERENCES "public"."topics"("id");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."performance_metrics"
    ADD CONSTRAINT "performance_metrics_topic_id_fkey" FOREIGN KEY ("topic_id") REFERENCES "public"."topics"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."performance_metrics"
    ADD CONSTRAINT "performance_metrics_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."performance_predictions"
    ADD CONSTRAINT "performance_predictions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."proctoring_events"
    ADD CONSTRAINT "proctoring_events_attempt_id_fkey" FOREIGN KEY ("attempt_id") REFERENCES "public"."exam_attempts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."proctoring_events"
    ADD CONSTRAINT "proctoring_events_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."proctoring_reports"
    ADD CONSTRAINT "proctoring_reports_attempt_id_fkey" FOREIGN KEY ("attempt_id") REFERENCES "public"."exam_attempts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."proctoring_reports"
    ADD CONSTRAINT "proctoring_reports_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "public"."exams"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."proctoring_reports"
    ADD CONSTRAINT "proctoring_reports_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."questions"
    ADD CONSTRAINT "questions_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."questions"
    ADD CONSTRAINT "questions_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "public"."exams"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."questions"
    ADD CONSTRAINT "questions_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "public"."subjects"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."questions"
    ADD CONSTRAINT "questions_topic_id_fkey" FOREIGN KEY ("topic_id") REFERENCES "public"."topics"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."recommendations"
    ADD CONSTRAINT "recommendations_topic_id_fkey" FOREIGN KEY ("topic_id") REFERENCES "public"."topics"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."recommendations"
    ADD CONSTRAINT "recommendations_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."revision_plan_tasks"
    ADD CONSTRAINT "revision_plan_tasks_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "public"."revision_plans"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."revision_plan_tasks"
    ADD CONSTRAINT "revision_plan_tasks_topic_id_fkey" FOREIGN KEY ("topic_id") REFERENCES "public"."topics"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."revision_plans"
    ADD CONSTRAINT "revision_plans_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."student_answers"
    ADD CONSTRAINT "student_answers_attempt_id_fkey" FOREIGN KEY ("attempt_id") REFERENCES "public"."exam_attempts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."student_answers"
    ADD CONSTRAINT "student_answers_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "public"."questions"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."student_badges"
    ADD CONSTRAINT "student_badges_badge_id_fkey" FOREIGN KEY ("badge_id") REFERENCES "public"."badges"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."student_badges"
    ADD CONSTRAINT "student_badges_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."student_stats"
    ADD CONSTRAINT "student_stats_current_level_fkey" FOREIGN KEY ("current_level") REFERENCES "public"."levels"("level_number");



ALTER TABLE ONLY "public"."student_stats"
    ADD CONSTRAINT "student_stats_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."student_topic_ability"
    ADD CONSTRAINT "student_topic_ability_topic_id_fkey" FOREIGN KEY ("topic_id") REFERENCES "public"."topics"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."student_topic_ability"
    ADD CONSTRAINT "student_topic_ability_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."topics"
    ADD CONSTRAINT "topics_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "public"."subjects"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."xp_transactions"
    ADD CONSTRAINT "xp_transactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



CREATE POLICY "active badges readable" ON "public"."badges" FOR SELECT TO "authenticated" USING (("is_active" = true));



ALTER TABLE "public"."adaptive_session_questions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."adaptive_sessions" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "admin ai drafts" ON "public"."ai_question_drafts" FOR SELECT TO "authenticated" USING ("public"."is_admin"());



ALTER TABLE "public"."ai_question_drafts" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "answers readable by room members" ON "public"."multiplayer_answers" FOR SELECT TO "authenticated" USING ((("public"."is_multiplayer_member"("room_id") AND (EXISTS ( SELECT 1
   FROM "public"."multiplayer_rooms" "r"
  WHERE (("r"."id" = "multiplayer_answers"."room_id") AND ("r"."phase" = ANY (ARRAY['reveal'::"public"."multiplayer_phase", 'finished'::"public"."multiplayer_phase"])))))) OR "public"."is_admin"()));



ALTER TABLE "public"."badges" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "exam questions readable" ON "public"."exam_questions" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."exams"
  WHERE (("exams"."id" = "exam_questions"."exam_id") AND ("exams"."status" = 'published'::"public"."exam_publication_status") AND ("exams"."is_published" = true)))));



ALTER TABLE "public"."exam_attempts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."exam_questions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."exams" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "leaderboard snapshots readable" ON "public"."leaderboard_snapshots" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "leaderboard stats readable" ON "public"."student_stats" FOR SELECT TO "authenticated" USING (true);



ALTER TABLE "public"."leaderboard_snapshots" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."levels" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "levels readable" ON "public"."levels" FOR SELECT TO "authenticated" USING (true);



ALTER TABLE "public"."multiplayer_answers" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."multiplayer_participants" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."multiplayer_results" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."multiplayer_room_questions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."multiplayer_rooms" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."notifications" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "notifications self read" ON "public"."notifications" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "notifications self update" ON "public"."notifications" FOR UPDATE USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "own abilities read" ON "public"."student_topic_ability" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "own adaptive questions read" ON "public"."adaptive_session_questions" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."adaptive_sessions" "s"
  WHERE (("s"."id" = "adaptive_session_questions"."session_id") AND ("s"."user_id" = "auth"."uid"())))));



CREATE POLICY "own adaptive sessions read" ON "public"."adaptive_sessions" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "own attempts readable" ON "public"."exam_attempts" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "own metrics readable" ON "public"."performance_metrics" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "own predictions read" ON "public"."performance_predictions" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "own proctor events readable" ON "public"."proctoring_events" FOR SELECT TO "authenticated" USING ((("auth"."uid"() = "user_id") OR "public"."is_admin"()));



CREATE POLICY "own proctor reports readable" ON "public"."proctoring_reports" FOR SELECT TO "authenticated" USING ((("auth"."uid"() = "user_id") OR "public"."is_admin"()));



CREATE POLICY "own recommendations read" ON "public"."recommendations" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "own revision plans read" ON "public"."revision_plans" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "own revision tasks read" ON "public"."revision_plan_tasks" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."revision_plans" "p"
  WHERE (("p"."id" = "revision_plan_tasks"."plan_id") AND ("p"."user_id" = "auth"."uid"())))));



CREATE POLICY "own xp readable" ON "public"."xp_transactions" FOR SELECT USING (("auth"."uid"() = "user_id"));



ALTER TABLE "public"."performance_metrics" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."performance_predictions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."proctoring_events" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."proctoring_reports" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "profile self read" ON "public"."profiles" FOR SELECT USING (("auth"."uid"() = "id"));



ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "public rooms or member rooms readable" ON "public"."multiplayer_rooms" FOR SELECT TO "authenticated" USING (("is_public" OR ("host_id" = "auth"."uid"()) OR "public"."is_multiplayer_member"("id") OR "public"."is_admin"()));



CREATE POLICY "published exams readable" ON "public"."exams" FOR SELECT USING ((("status" = 'published'::"public"."exam_publication_status") AND ("is_published" = true)));



ALTER TABLE "public"."questions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."recommendations" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "results readable by authenticated" ON "public"."multiplayer_results" FOR SELECT TO "authenticated" USING (true);



ALTER TABLE "public"."revision_plan_tasks" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."revision_plans" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "room participants readable by members" ON "public"."multiplayer_participants" FOR SELECT TO "authenticated" USING (("public"."is_multiplayer_member"("room_id") OR "public"."is_admin"()));



CREATE POLICY "room question ids readable by members" ON "public"."multiplayer_room_questions" FOR SELECT TO "authenticated" USING (("public"."is_multiplayer_member"("room_id") OR "public"."is_admin"()));



CREATE POLICY "stats readable" ON "public"."student_stats" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "student badges readable" ON "public"."student_badges" FOR SELECT USING (("auth"."uid"() = "user_id"));



ALTER TABLE "public"."student_answers" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."student_badges" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."student_stats" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."student_topic_ability" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."subjects" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "subjects readable" ON "public"."subjects" FOR SELECT USING (("is_active" = true));



ALTER TABLE "public"."topics" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "topics readable" ON "public"."topics" FOR SELECT USING (("is_active" = true));



ALTER TABLE "public"."xp_transactions" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";






ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."multiplayer_answers";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."multiplayer_participants";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."multiplayer_results";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."multiplayer_rooms";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."notifications";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."student_stats";



GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";






















































































































































REVOKE ALL ON FUNCTION "public"."advance_multiplayer_room"("p_room_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."advance_multiplayer_room"("p_room_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."advance_multiplayer_room"("p_room_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."advance_multiplayer_room"("p_room_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."apply_attempt_rewards"("p_attempt_id" "uuid", "p_user_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."apply_attempt_rewards"("p_attempt_id" "uuid", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."apply_attempt_rewards"("p_attempt_id" "uuid", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."apply_attempt_rewards"("p_attempt_id" "uuid", "p_user_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."finish_multiplayer_room"("p_room_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."finish_multiplayer_room"("p_room_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."finish_multiplayer_room"("p_room_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."finish_multiplayer_room"("p_room_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_auth_user_updated"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_auth_user_updated"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_auth_user_updated"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."is_admin"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."is_admin"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."is_multiplayer_member"("p_room_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."is_multiplayer_member"("p_room_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_multiplayer_member"("p_room_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_multiplayer_member"("p_room_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."join_multiplayer_room"("p_room_id" "uuid", "p_user_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."join_multiplayer_room"("p_room_id" "uuid", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."join_multiplayer_room"("p_room_id" "uuid", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."join_multiplayer_room"("p_room_id" "uuid", "p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."notify_adaptive_session_completed"() TO "anon";
GRANT ALL ON FUNCTION "public"."notify_adaptive_session_completed"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."notify_adaptive_session_completed"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."reorder_exam_questions"("p_exam_id" "uuid", "p_question_ids" "uuid"[]) FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."reorder_exam_questions"("p_exam_id" "uuid", "p_question_ids" "uuid"[]) TO "anon";
GRANT ALL ON FUNCTION "public"."reorder_exam_questions"("p_exam_id" "uuid", "p_question_ids" "uuid"[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."reorder_exam_questions"("p_exam_id" "uuid", "p_question_ids" "uuid"[]) TO "service_role";



GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."start_multiplayer_room"("p_room_id" "uuid", "p_actor_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."start_multiplayer_room"("p_room_id" "uuid", "p_actor_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."start_multiplayer_room"("p_room_id" "uuid", "p_actor_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."start_multiplayer_room"("p_room_id" "uuid", "p_actor_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."start_or_resume_exam_attempt"("p_exam_id" "uuid", "p_user_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."start_or_resume_exam_attempt"("p_exam_id" "uuid", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."start_or_resume_exam_attempt"("p_exam_id" "uuid", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."start_or_resume_exam_attempt"("p_exam_id" "uuid", "p_user_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."submit_multiplayer_answer"("p_room_id" "uuid", "p_user_id" "uuid", "p_selected" integer) FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."submit_multiplayer_answer"("p_room_id" "uuid", "p_user_id" "uuid", "p_selected" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."submit_multiplayer_answer"("p_room_id" "uuid", "p_user_id" "uuid", "p_selected" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."submit_multiplayer_answer"("p_room_id" "uuid", "p_user_id" "uuid", "p_selected" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."validate_question_topic_subject"() TO "anon";
GRANT ALL ON FUNCTION "public"."validate_question_topic_subject"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."validate_question_topic_subject"() TO "service_role";


















GRANT ALL ON TABLE "public"."adaptive_session_questions" TO "anon";
GRANT ALL ON TABLE "public"."adaptive_session_questions" TO "authenticated";
GRANT ALL ON TABLE "public"."adaptive_session_questions" TO "service_role";



GRANT ALL ON TABLE "public"."adaptive_sessions" TO "anon";
GRANT ALL ON TABLE "public"."adaptive_sessions" TO "authenticated";
GRANT ALL ON TABLE "public"."adaptive_sessions" TO "service_role";



GRANT ALL ON TABLE "public"."ai_question_drafts" TO "anon";
GRANT ALL ON TABLE "public"."ai_question_drafts" TO "authenticated";
GRANT ALL ON TABLE "public"."ai_question_drafts" TO "service_role";



GRANT ALL ON TABLE "public"."badges" TO "anon";
GRANT ALL ON TABLE "public"."badges" TO "authenticated";
GRANT ALL ON TABLE "public"."badges" TO "service_role";



GRANT ALL ON TABLE "public"."exam_attempts" TO "anon";
GRANT ALL ON TABLE "public"."exam_attempts" TO "authenticated";
GRANT ALL ON TABLE "public"."exam_attempts" TO "service_role";



GRANT ALL ON TABLE "public"."exam_questions" TO "anon";
GRANT ALL ON TABLE "public"."exam_questions" TO "authenticated";
GRANT ALL ON TABLE "public"."exam_questions" TO "service_role";



GRANT ALL ON TABLE "public"."exams" TO "anon";
GRANT ALL ON TABLE "public"."exams" TO "authenticated";
GRANT ALL ON TABLE "public"."exams" TO "service_role";



GRANT ALL ON TABLE "public"."leaderboard_snapshots" TO "anon";
GRANT ALL ON TABLE "public"."leaderboard_snapshots" TO "authenticated";
GRANT ALL ON TABLE "public"."leaderboard_snapshots" TO "service_role";



GRANT ALL ON TABLE "public"."levels" TO "anon";
GRANT ALL ON TABLE "public"."levels" TO "authenticated";
GRANT ALL ON TABLE "public"."levels" TO "service_role";



GRANT ALL ON TABLE "public"."multiplayer_answers" TO "anon";
GRANT ALL ON TABLE "public"."multiplayer_answers" TO "authenticated";
GRANT ALL ON TABLE "public"."multiplayer_answers" TO "service_role";



GRANT ALL ON TABLE "public"."multiplayer_participants" TO "anon";
GRANT ALL ON TABLE "public"."multiplayer_participants" TO "authenticated";
GRANT ALL ON TABLE "public"."multiplayer_participants" TO "service_role";



GRANT ALL ON TABLE "public"."multiplayer_results" TO "anon";
GRANT ALL ON TABLE "public"."multiplayer_results" TO "authenticated";
GRANT ALL ON TABLE "public"."multiplayer_results" TO "service_role";



GRANT ALL ON TABLE "public"."multiplayer_room_questions" TO "anon";
GRANT ALL ON TABLE "public"."multiplayer_room_questions" TO "authenticated";
GRANT ALL ON TABLE "public"."multiplayer_room_questions" TO "service_role";



GRANT ALL ON TABLE "public"."multiplayer_rooms" TO "anon";
GRANT ALL ON TABLE "public"."multiplayer_rooms" TO "authenticated";
GRANT ALL ON TABLE "public"."multiplayer_rooms" TO "service_role";



GRANT ALL ON TABLE "public"."notifications" TO "anon";
GRANT ALL ON TABLE "public"."notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."notifications" TO "service_role";



GRANT ALL ON TABLE "public"."performance_metrics" TO "anon";
GRANT ALL ON TABLE "public"."performance_metrics" TO "authenticated";
GRANT ALL ON TABLE "public"."performance_metrics" TO "service_role";



GRANT ALL ON TABLE "public"."performance_predictions" TO "anon";
GRANT ALL ON TABLE "public"."performance_predictions" TO "authenticated";
GRANT ALL ON TABLE "public"."performance_predictions" TO "service_role";



GRANT ALL ON TABLE "public"."proctoring_events" TO "anon";
GRANT ALL ON TABLE "public"."proctoring_events" TO "authenticated";
GRANT ALL ON TABLE "public"."proctoring_events" TO "service_role";



GRANT ALL ON TABLE "public"."proctoring_reports" TO "anon";
GRANT ALL ON TABLE "public"."proctoring_reports" TO "authenticated";
GRANT ALL ON TABLE "public"."proctoring_reports" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."questions" TO "anon";
GRANT ALL ON TABLE "public"."questions" TO "authenticated";
GRANT ALL ON TABLE "public"."questions" TO "service_role";



GRANT ALL ON TABLE "public"."recommendations" TO "anon";
GRANT ALL ON TABLE "public"."recommendations" TO "authenticated";
GRANT ALL ON TABLE "public"."recommendations" TO "service_role";



GRANT ALL ON TABLE "public"."revision_plan_tasks" TO "anon";
GRANT ALL ON TABLE "public"."revision_plan_tasks" TO "authenticated";
GRANT ALL ON TABLE "public"."revision_plan_tasks" TO "service_role";



GRANT ALL ON TABLE "public"."revision_plans" TO "anon";
GRANT ALL ON TABLE "public"."revision_plans" TO "authenticated";
GRANT ALL ON TABLE "public"."revision_plans" TO "service_role";



GRANT ALL ON TABLE "public"."student_answers" TO "anon";
GRANT ALL ON TABLE "public"."student_answers" TO "authenticated";
GRANT ALL ON TABLE "public"."student_answers" TO "service_role";



GRANT ALL ON TABLE "public"."student_badges" TO "anon";
GRANT ALL ON TABLE "public"."student_badges" TO "authenticated";
GRANT ALL ON TABLE "public"."student_badges" TO "service_role";



GRANT ALL ON TABLE "public"."student_stats" TO "anon";
GRANT ALL ON TABLE "public"."student_stats" TO "authenticated";
GRANT ALL ON TABLE "public"."student_stats" TO "service_role";



GRANT ALL ON TABLE "public"."student_topic_ability" TO "anon";
GRANT ALL ON TABLE "public"."student_topic_ability" TO "authenticated";
GRANT ALL ON TABLE "public"."student_topic_ability" TO "service_role";



GRANT ALL ON TABLE "public"."subjects" TO "anon";
GRANT ALL ON TABLE "public"."subjects" TO "authenticated";
GRANT ALL ON TABLE "public"."subjects" TO "service_role";



GRANT ALL ON TABLE "public"."topics" TO "anon";
GRANT ALL ON TABLE "public"."topics" TO "authenticated";
GRANT ALL ON TABLE "public"."topics" TO "service_role";



GRANT ALL ON TABLE "public"."xp_transactions" TO "anon";
GRANT ALL ON TABLE "public"."xp_transactions" TO "authenticated";
GRANT ALL ON TABLE "public"."xp_transactions" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































