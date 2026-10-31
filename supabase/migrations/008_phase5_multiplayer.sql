-- Phase 5: realtime, server-authoritative multiplayer quizzes.
create type public.multiplayer_room_status as enum ('open','countdown','in_progress','finished','closed');
create type public.multiplayer_phase as enum ('lobby','countdown','question','reveal','finished');

create table public.multiplayer_rooms (
  id uuid primary key default gen_random_uuid(), room_code text not null unique check(room_code ~ '^[A-Z0-9]{6}$'),
  name text not null check(length(name) between 2 and 80), host_id uuid not null references public.profiles(id),
  subject_id uuid references public.subjects(id), topic_id uuid references public.topics(id), exam_id uuid references public.exams(id),
  difficulty public.question_difficulty, question_count integer not null check(question_count between 1 and 50),
  question_time_seconds integer not null check(question_time_seconds between 10 and 180), max_players integer not null check(max_players between 2 and 50),
  is_public boolean not null default false, status public.multiplayer_room_status not null default 'open', phase public.multiplayer_phase not null default 'lobby',
  current_question_index integer not null default -1, starts_at timestamptz, question_started_at timestamptz, question_ends_at timestamptz,
  reveal_ends_at timestamptz, started_at timestamptz, finished_at timestamptz, closed_at timestamptz,
  expires_at timestamptz not null default (now()+interval '2 hours'), created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table public.multiplayer_participants (
  id uuid primary key default gen_random_uuid(), room_id uuid not null references public.multiplayer_rooms(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade, is_ready boolean not null default false,
  score integer not null default 0 check(score>=0), correct_count integer not null default 0 check(correct_count>=0),
  joined_at timestamptz not null default now(), last_seen_at timestamptz not null default now(), left_at timestamptz,
  unique(room_id,user_id)
);
create table public.multiplayer_room_questions (
  id uuid primary key default gen_random_uuid(), room_id uuid not null references public.multiplayer_rooms(id) on delete cascade,
  question_id uuid not null references public.questions(id), position integer not null check(position>=0),
  unique(room_id,position), unique(room_id,question_id)
);
create table public.multiplayer_answers (
  id uuid primary key default gen_random_uuid(), room_id uuid not null references public.multiplayer_rooms(id) on delete cascade,
  participant_id uuid not null references public.multiplayer_participants(id) on delete cascade,
  room_question_id uuid not null references public.multiplayer_room_questions(id) on delete cascade,
  selected_answer integer not null check(selected_answer between 0 and 3), answered_at timestamptz not null default now(),
  response_time_ms integer not null check(response_time_ms>=0), is_correct boolean not null, score_earned integer not null check(score_earned>=0),
  unique(participant_id,room_question_id)
);
create table public.multiplayer_results (
  id uuid primary key default gen_random_uuid(), room_id uuid not null references public.multiplayer_rooms(id) on delete cascade,
  participant_id uuid not null references public.multiplayer_participants(id), user_id uuid not null references public.profiles(id),
  rank integer not null check(rank>0), score integer not null, correct_count integer not null, question_count integer not null,
  accuracy numeric(6,2) not null, average_response_ms integer not null default 0, xp_awarded integer not null default 0,
  created_at timestamptz not null default now(), unique(room_id,user_id), unique(room_id,rank)
);
create index idx_mp_rooms_public on public.multiplayer_rooms(status,is_public,created_at desc);
create index idx_mp_participants_room on public.multiplayer_participants(room_id,left_at,score desc);
create index idx_mp_questions_room on public.multiplayer_room_questions(room_id,position);
create index idx_mp_answers_room_question on public.multiplayer_answers(room_id,room_question_id);
create index idx_mp_results_user on public.multiplayer_results(user_id,created_at desc);

alter table public.multiplayer_rooms enable row level security;
alter table public.multiplayer_participants enable row level security;
alter table public.multiplayer_room_questions enable row level security;
alter table public.multiplayer_answers enable row level security;
alter table public.multiplayer_results enable row level security;
create or replace function public.is_multiplayer_member(p_room_id uuid) returns boolean language sql stable security definer set search_path='' as $$
  select exists(select 1 from public.multiplayer_participants where room_id=p_room_id and user_id=auth.uid() and left_at is null)
$$;
revoke all on function public.is_multiplayer_member(uuid) from public;
grant execute on function public.is_multiplayer_member(uuid) to authenticated;
create policy "public rooms or member rooms readable" on public.multiplayer_rooms for select to authenticated using
  (is_public or host_id=auth.uid() or public.is_multiplayer_member(id) or public.is_admin());
create policy "room participants readable by members" on public.multiplayer_participants for select to authenticated using
  (public.is_multiplayer_member(room_id) or public.is_admin());
create policy "room question ids readable by members" on public.multiplayer_room_questions for select to authenticated using
  (public.is_multiplayer_member(room_id) or public.is_admin());
create policy "answers readable by room members" on public.multiplayer_answers for select to authenticated using
  ((public.is_multiplayer_member(room_id) and exists(select 1 from public.multiplayer_rooms r where r.id=room_id and r.phase in ('reveal','finished'))) or public.is_admin());
create policy "results readable by authenticated" on public.multiplayer_results for select to authenticated using(true);

-- All mutations are service-role RPC/backend operations. Scoring: 1000 correct + floor(500 * remaining_ms / allotted_ms).
create or replace function public.join_multiplayer_room(p_room_id uuid,p_user_id uuid) returns uuid
language plpgsql security definer set search_path='' as $$ declare r public.multiplayer_rooms%rowtype; pid uuid; participant_active boolean; begin
  select * into r from public.multiplayer_rooms where id=p_room_id for update;
  if not found or r.status<>'open' or r.phase<>'lobby' or now()>=r.expires_at then raise exception using errcode='P0001',message='Room is not open.'; end if;
  select id,left_at is null into pid,participant_active from public.multiplayer_participants where room_id=p_room_id and user_id=p_user_id;
  if pid is not null and participant_active then update public.multiplayer_participants set last_seen_at=now() where id=pid; return pid; end if;
  if (select count(*) from public.multiplayer_participants where room_id=p_room_id and left_at is null)>=r.max_players then raise exception using errcode='P0001',message='Room is full.'; end if;
  if pid is not null then update public.multiplayer_participants set left_at=null,is_ready=false,last_seen_at=now() where id=pid; return pid; end if;
  insert into public.multiplayer_participants(room_id,user_id) values(p_room_id,p_user_id) returning id into pid; return pid;
end $$;

create or replace function public.start_multiplayer_room(p_room_id uuid,p_actor_id uuid) returns void
language plpgsql security definer set search_path='' as $$ declare r public.multiplayer_rooms%rowtype; begin
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

create or replace function public.submit_multiplayer_answer(p_room_id uuid,p_user_id uuid,p_selected integer) returns integer
language plpgsql security definer set search_path='' as $$ declare r public.multiplayer_rooms%rowtype; p public.multiplayer_participants%rowtype; rq public.multiplayer_room_questions%rowtype; correct integer; elapsed integer; earned integer:=0; begin
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

create or replace function public.finish_multiplayer_room(p_room_id uuid) returns void language plpgsql security definer set search_path='' as $$
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

create or replace function public.advance_multiplayer_room(p_room_id uuid) returns void language plpgsql security definer set search_path='' as $$
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
revoke all on function public.join_multiplayer_room(uuid,uuid),public.start_multiplayer_room(uuid,uuid),public.submit_multiplayer_answer(uuid,uuid,integer),public.finish_multiplayer_room(uuid),public.advance_multiplayer_room(uuid) from public;
grant execute on function public.join_multiplayer_room(uuid,uuid),public.start_multiplayer_room(uuid,uuid),public.submit_multiplayer_answer(uuid,uuid,integer),public.finish_multiplayer_room(uuid),public.advance_multiplayer_room(uuid) to service_role;

do $$ begin if exists(select 1 from pg_publication where pubname='supabase_realtime') then
  alter publication supabase_realtime add table public.multiplayer_rooms;
  alter publication supabase_realtime add table public.multiplayer_participants;
  alter publication supabase_realtime add table public.multiplayer_answers;
  alter publication supabase_realtime add table public.multiplayer_results;
end if; exception when duplicate_object then null; end $$;
