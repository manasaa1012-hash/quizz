--
-- PostgreSQL database dump
--

\restrict H9I4TOE8yjFKKrver9mmMuk9cpshcw2tzs7sfVHgGUanb9uVuvjn3lR2cTOGoLS

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.11

-- Started on 2026-10-13 14:22:13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 35 (class 2615 OID 16498)
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- TOC entry 21 (class 2615 OID 16392)
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- TOC entry 33 (class 2615 OID 16578)
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- TOC entry 32 (class 2615 OID 16567)
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- TOC entry 11 (class 2615 OID 16390)
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- TOC entry 10 (class 2615 OID 16559)
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- TOC entry 36 (class 2615 OID 16546)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- TOC entry 30 (class 2615 OID 16607)
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- TOC entry 2 (class 3079 OID 16393)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 4 (class 3079 OID 16447)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 5 (class 3079 OID 16608)
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- TOC entry 3 (class 3079 OID 16436)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1172 (class 1247 OID 16744)
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- TOC entry 1196 (class 1247 OID 16885)
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- TOC entry 1169 (class 1247 OID 16738)
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- TOC entry 1166 (class 1247 OID 16733)
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone',
    'recovery_code'
);


--
-- TOC entry 1214 (class 1247 OID 16988)
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- TOC entry 1226 (class 1247 OID 17061)
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- TOC entry 1208 (class 1247 OID 16966)
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- TOC entry 1217 (class 1247 OID 16998)
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- TOC entry 1202 (class 1247 OID 16927)
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- TOC entry 1337 (class 1247 OID 17740)
-- Name: account_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.account_status AS ENUM (
    'active',
    'pending_verification',
    'suspended'
);


--
-- TOC entry 1340 (class 1247 OID 17748)
-- Name: exam_publication_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.exam_publication_status AS ENUM (
    'draft',
    'published',
    'archived'
);


--
-- TOC entry 1295 (class 1247 OID 17490)
-- Name: exam_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.exam_status AS ENUM (
    'in_progress',
    'submitted'
);


--
-- TOC entry 1382 (class 1247 OID 18394)
-- Name: multiplayer_phase; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.multiplayer_phase AS ENUM (
    'lobby',
    'countdown',
    'question',
    'reveal',
    'finished'
);


--
-- TOC entry 1379 (class 1247 OID 18383)
-- Name: multiplayer_room_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.multiplayer_room_status AS ENUM (
    'open',
    'countdown',
    'in_progress',
    'finished',
    'closed'
);


--
-- TOC entry 1298 (class 1247 OID 17496)
-- Name: question_difficulty; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.question_difficulty AS ENUM (
    'easy',
    'medium',
    'hard'
);


--
-- TOC entry 1292 (class 1247 OID 17485)
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'student',
    'admin'
);


--
-- TOC entry 1241 (class 1247 OID 17177)
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- TOC entry 1244 (class 1247 OID 17188)
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in',
    'like',
    'ilike',
    'is',
    'match',
    'imatch',
    'isdistinct'
);


--
-- TOC entry 1247 (class 1247 OID 17217)
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text,
	negate boolean
);


--
-- TOC entry 1250 (class 1247 OID 17220)
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- TOC entry 1253 (class 1247 OID 17223)
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- TOC entry 1280 (class 1247 OID 17408)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- TOC entry 454 (class 1255 OID 16544)
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 454
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- TOC entry 467 (class 1255 OID 16715)
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- TOC entry 453 (class 1255 OID 16543)
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 453
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- TOC entry 452 (class 1255 OID 16542)
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 452
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- TOC entry 455 (class 1255 OID 16551)
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
    revoke trigger on cron.job_run_details from postgres;
  END IF;
END;
$$;


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 455
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- TOC entry 459 (class 1255 OID 16572)
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $_$
begin
    if not exists (
        select 1
        from pg_catalog.pg_event_trigger_ddl_commands() ev
        join pg_catalog.pg_extension e on ev.objid = e.oid
        where e.extname = 'pg_graphql'
    ) then
        return;
    end if;

    drop function if exists graphql_public.graphql;
    create or replace function graphql_public.graphql(
        "operationName" text default null,
        query text default null,
        variables jsonb default null,
        extensions jsonb default null
    )
        returns jsonb
        language sql
    as $$
        select graphql.resolve(
            query := query,
            variables := coalesce(variables, '{}'),
            "operationName" := "operationName",
            extensions := extensions
        );
    $$;

    -- Attach the wrapper to the extension so DROP EXTENSION cascades to it,
    -- which in turn triggers set_graphql_placeholder to reinstall the "not enabled" stub.
    alter extension pg_graphql add function graphql_public.graphql(text, text, jsonb, jsonb);

    grant usage on schema graphql to postgres, anon, authenticated, service_role;
    grant execute on function graphql.resolve to postgres, anon, authenticated, service_role;
    grant usage on schema graphql to postgres with grant option;
    grant usage on schema graphql_public to postgres with grant option;
end;
$_$;


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 459
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- TOC entry 456 (class 1255 OID 16553)
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8.0', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 456
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- TOC entry 457 (class 1255 OID 16563)
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- TOC entry 458 (class 1255 OID 16564)
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- TOC entry 460 (class 1255 OID 16574)
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
            set search_path to ''
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 460
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- TOC entry 466 (class 1255 OID 16665)
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: -
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


--
-- TOC entry 402 (class 1255 OID 16391)
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


--
-- TOC entry 508 (class 1255 OID 18564)
-- Name: advance_multiplayer_room(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.advance_multiplayer_room(p_room_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
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


--
-- TOC entry 501 (class 1255 OID 18029)
-- Name: apply_attempt_rewards(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.apply_attempt_rewards(p_attempt_id uuid, p_user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
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


--
-- TOC entry 507 (class 1255 OID 18563)
-- Name: finish_multiplayer_room(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.finish_multiplayer_room(p_room_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
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


--
-- TOC entry 496 (class 1255 OID 17839)
-- Name: handle_auth_user_updated(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_auth_user_updated() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
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


--
-- TOC entry 494 (class 1255 OID 17724)
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
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


--
-- TOC entry 497 (class 1255 OID 18004)
-- Name: is_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'admin'::public.user_role
      and account_status = 'active'::public.account_status
  );
$$;


--
-- TOC entry 503 (class 1255 OID 18554)
-- Name: is_multiplayer_member(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_multiplayer_member(p_room_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
  select exists(select 1 from public.multiplayer_participants where room_id=p_room_id and user_id=auth.uid() and left_at is null)
$$;


--
-- TOC entry 504 (class 1255 OID 18560)
-- Name: join_multiplayer_room(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.join_multiplayer_room(p_room_id uuid, p_user_id uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$ declare r public.multiplayer_rooms%rowtype; pid uuid; participant_active boolean; begin
  select * into r from public.multiplayer_rooms where id=p_room_id for update;
  if not found or r.status<>'open' or r.phase<>'lobby' or now()>=r.expires_at then raise exception using errcode='P0001',message='Room is not open.'; end if;
  select id,left_at is null into pid,participant_active from public.multiplayer_participants where room_id=p_room_id and user_id=p_user_id;
  if pid is not null and participant_active then update public.multiplayer_participants set last_seen_at=now() where id=pid; return pid; end if;
  if (select count(*) from public.multiplayer_participants where room_id=p_room_id and left_at is null)>=r.max_players then raise exception using errcode='P0001',message='Room is full.'; end if;
  if pid is not null then update public.multiplayer_participants set left_at=null,is_ready=false,last_seen_at=now() where id=pid; return pid; end if;
  insert into public.multiplayer_participants(room_id,user_id) values(p_room_id,p_user_id) returning id into pid; return pid;
end $$;


--
-- TOC entry 502 (class 1255 OID 18308)
-- Name: notify_adaptive_session_completed(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.notify_adaptive_session_completed() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
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


--
-- TOC entry 499 (class 1255 OID 18007)
-- Name: reorder_exam_questions(uuid, uuid[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.reorder_exam_questions(p_exam_id uuid, p_question_ids uuid[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
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


--
-- TOC entry 495 (class 1255 OID 17833)
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


--
-- TOC entry 505 (class 1255 OID 18561)
-- Name: start_multiplayer_room(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.start_multiplayer_room(p_room_id uuid, p_actor_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
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


--
-- TOC entry 500 (class 1255 OID 18028)
-- Name: start_or_resume_exam_attempt(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.start_or_resume_exam_attempt(p_exam_id uuid, p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
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


--
-- TOC entry 506 (class 1255 OID 18562)
-- Name: submit_multiplayer_answer(uuid, uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.submit_multiplayer_answer(p_room_id uuid, p_user_id uuid, p_selected integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
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


--
-- TOC entry 498 (class 1255 OID 18005)
-- Name: validate_question_topic_subject(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_question_topic_subject() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO ''
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


--
-- TOC entry 468 (class 1255 OID 17224)
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
    -- Regclass of the table e.g. public.notes
    entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

    -- I, U, D, T: insert, update ...
    action realtime.action = (
        case wal ->> 'action'
            when 'I' then 'INSERT'
            when 'U' then 'UPDATE'
            when 'D' then 'DELETE'
            else 'ERROR'
        end
    );

    -- Is row level security enabled for the table
    is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

    subscriptions realtime.subscription[] = array_agg(subs)
        from
            realtime.subscription subs
        where
            subs.entity = entity_
            -- Filter by action early - only get subscriptions interested in this action
            -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
            and (subs.action_filter = '*' or subs.action_filter = action::text);

    -- Subscription vars
    working_role regrole;
    working_selected_columns text[];
    claimed_role regrole;
    claims jsonb;

    subscription_id uuid;
    subscription_has_access bool;
    visible_to_subscription_ids uuid[] = '{}';

    -- structured info for wal's columns
    columns realtime.wal_column[];
    -- previous identity values for update/delete
    old_columns realtime.wal_column[];

    error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

    -- Primary jsonb output for record
    output jsonb;

    -- Loop record for iterating unique roles (outer loop)
    role_record record;
    -- Loop record for iterating unique selected_columns within a role (inner loop)
    cols_record record;
    -- Subscription ids visible at the role level (before fanning out by selected_columns)
    visible_role_sub_ids uuid[] = '{}';

begin
    perform set_config('role', null, true);

    columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'columns') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    old_columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'identity') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    for role_record in
        select claims_role
        from (select distinct claims_role from unnest(subscriptions)) t
        order by claims_role::text
    loop
        working_role := role_record.claims_role;

        -- Update `is_selectable` for columns and old_columns (once per role)
        columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(columns) c;

        old_columns =
                array_agg(
                    (
                        c.name,
                        c.type_name,
                        c.type_oid,
                        c.value,
                        c.is_pkey,
                        pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                    )::realtime.wal_column
                )
                from
                    unnest(old_columns) c;

        if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
            -- Fan out 400 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 400: Bad Request, no primary key']
                )::realtime.wal_rls;
            end loop;

        -- The claims role does not have SELECT permission to the primary key of entity
        elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
            -- Fan out 401 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 401: Unauthorized']
                )::realtime.wal_rls;
            end loop;

        else
            -- Create the prepared statement (once per role)
            if is_rls_enabled and action <> 'DELETE' then
                if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                    deallocate walrus_rls_stmt;
                end if;
                execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
            end if;

            -- Collect all visible subscription IDs for this role (filter check + RLS check)
            visible_role_sub_ids = '{}';

            for subscription_id, claims in (
                    select
                        subs.subscription_id,
                        subs.claims
                    from
                        unnest(subscriptions) subs
                    where
                        subs.entity = entity_
                        and subs.claims_role = working_role
                        and (
                            realtime.is_visible_through_filters(columns, subs.filters)
                            or (
                              action = 'DELETE'
                              and realtime.is_visible_through_filters(old_columns, subs.filters)
                            )
                        )
            ) loop

                if not is_rls_enabled or action = 'DELETE' then
                    visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                else
                    -- Check if RLS allows the role to see the record
                    perform
                        -- Trim leading and trailing quotes from working_role because set_config
                        -- doesn't recognize the role as valid if they are included
                        set_config('role', trim(both '"' from working_role::text), true),
                        set_config('request.jwt.claims', claims::text, true);

                    execute 'execute walrus_rls_stmt' into subscription_has_access;

                    -- Reset the role on every FOR..LOOP batch execution.
                    -- The first batch of 10 rows is pre-fetched using the current connection role (PG internal behaviour)
                    -- then we have to reset it again otherwise it would use the role defined in the `set_config` above
                    -- to fetch the remaining rows when rows>10, which could be a user-defined role that lacks execution grants.
                    -- The flow is:
                    --   1. run batch with conn role
                    --   2. set_config working_role
                    --   3. execute walrus
                    --   4. reset role (revert)
                    --   5. repeat
                    perform set_config('role', null, true);

                    if subscription_has_access then
                        visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                    end if;
                end if;
            end loop;

            perform set_config('role', null, true);

            -- Inner loop: per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;

                output = jsonb_build_object(
                    'schema', wal ->> 'schema',
                    'table', wal ->> 'table',
                    'type', action,
                    'commit_timestamp', to_char(
                        ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                        'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
                    ),
                    'columns', (
                        select
                            jsonb_agg(
                                jsonb_build_object(
                                    'name', pa.attname,
                                    'type', pt.typname
                                )
                                order by pa.attnum asc
                            )
                        from
                            pg_attribute pa
                            join pg_type pt
                                on pa.atttypid = pt.oid
                            left join (
                                select unnest(conkey) as pkey_attnum
                                from pg_constraint
                                where conrelid = entity_ and contype = 'p'
                            ) pk on pk.pkey_attnum = pa.attnum
                        where
                            attrelid = entity_
                            and attnum > 0
                            and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
                            and (working_selected_columns is null or pa.attname = any(working_selected_columns) or pk.pkey_attnum is not null)
                    )
                )
                -- Add "record" key for insert and update
                || case
                    when action in ('INSERT', 'UPDATE') then
                        jsonb_build_object(
                            'record',
                            (
                                select
                                    jsonb_object_agg(
                                        -- if unchanged toast, get column name and value from old record
                                        coalesce((c).name, (oc).name),
                                        case
                                            when (c).name is null then (oc).value
                                            else (c).value
                                        end
                                    )
                                from
                                    unnest(columns) c
                                    full outer join unnest(old_columns) oc
                                        on (c).name = (oc).name
                                where
                                    coalesce((c).is_selectable, (oc).is_selectable)
                                    and (working_selected_columns is null or coalesce((c).name, (oc).name) = any(working_selected_columns) or coalesce((c).is_pkey, (oc).is_pkey))
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            )
                        )
                    else '{}'::jsonb
                end
                -- Add "old_record" key for update and delete
                || case
                    when action = 'UPDATE' then
                        jsonb_build_object(
                                'old_record',
                                (
                                    select jsonb_object_agg((c).name, (c).value)
                                    from unnest(old_columns) c
                                    where
                                        (c).is_selectable
                                        and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                        and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                )
                            )
                    when action = 'DELETE' then
                        jsonb_build_object(
                            'old_record',
                            (
                                select jsonb_object_agg((c).name, (c).value)
                                from unnest(old_columns) c
                                where
                                    (c).is_selectable
                                    and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                    and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                            )
                        )
                    else '{}'::jsonb
                end;

                -- Filter visible_role_sub_ids to those matching the current selected_columns group
                visible_to_subscription_ids = coalesce(
                    (
                        select array_agg(s.subscription_id)
                        from unnest(subscriptions) s
                        where s.claims_role = working_role
                          and (s.selected_columns is not distinct from working_selected_columns)
                          and s.subscription_id = any(visible_role_sub_ids)
                    ),
                    '{}'::uuid[]
                );

                return next (
                    output,
                    is_rls_enabled,
                    visible_to_subscription_ids,
                    case
                        when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                        else '{}'
                    end
                )::realtime.wal_rls;
            end loop;

        end if;
    end loop;

    perform set_config('role', null, true);
end;
$$;


--
-- TOC entry 519 (class 1255 OID 25601)
-- Name: authorize(text, text, text, text, text, text[], text[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.authorize(role_name text, topic_name text, claims text, sub text, headers text, read_extensions text[], write_extensions text[], OUT read_allowed boolean[], OUT write_allowed boolean[]) RETURNS record
    LANGUAGE plpgsql
    AS $$
declare
  probe_ids uuid[];
  ext text;
  allowed boolean;
begin
  -- The probe inserts are rolled back, but they still give the transaction an xid, so it ends
  -- in a commit. Nothing durable was written, so skip waiting on the WAL flush and sync standbys.
  -- Set outside the block below, whose rollback would undo it.
  perform set_config('synchronous_commit', 'off', true);

  -- The RAISE at the end of this block rolls back everything in it.
  begin
    probe_ids := array(select gen_random_uuid() from unnest(read_extensions));

    insert into realtime.messages (id, topic, extension, inserted_at, updated_at)
    select p.id, topic_name, p.extension, now() at time zone 'utc', now() at time zone 'utc'
    from unnest(probe_ids, read_extensions) as p(id, extension);

    perform set_config('role', role_name, true),
            set_config('realtime.topic', topic_name, true),
            set_config('request.jwt.claims', claims, true),
            set_config('request.jwt.claim.sub', sub, true),
            set_config('request.jwt.claim.role', role_name, true),
            set_config('request.headers', headers, true);

    read_allowed := array(
      select exists(select 1 from realtime.messages m where m.id = p.id)
      from unnest(probe_ids) with ordinality as p(id, n)
      order by p.n);

    write_allowed := '{}';

    foreach ext in array write_extensions loop
      begin
        insert into realtime.messages (topic, extension, inserted_at, updated_at)
        values (topic_name, ext, now() at time zone 'utc', now() at time zone 'utc');

        allowed := true;
      exception when insufficient_privilege then
        allowed := false;
      end;

      write_allowed := write_allowed || allowed;
    end loop;

    raise sqlstate 'RTA01';
  exception when sqlstate 'RTA01' then
    null;
  end;
end;
$$;


--
-- TOC entry 469 (class 1255 OID 17227)
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- TOC entry 470 (class 1255 OID 17228)
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- TOC entry 471 (class 1255 OID 17229)
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


--
-- TOC entry 472 (class 1255 OID 17230)
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
/*
Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
*/
declare
    op_symbol text = (
        case
            when op = 'eq' then '='
            when op = 'neq' then '!='
            when op = 'lt' then '<'
            when op = 'lte' then '<='
            when op = 'gt' then '>'
            when op = 'gte' then '>='
            when op = 'in' then '= any'
            else 'UNKNOWN OP'
        end
    );
    res boolean;
begin
    execute format(
        'select %L::'|| type_::text || ' ' || op_symbol
        || ' ( %L::'
        || (
            case
                when op = 'in' then type_::text || '[]'
                else type_::text end
        )
        || ')', val_1, val_2) into res;
    return res;
end;
$$;


--
-- TOC entry 473 (class 1255 OID 17231)
-- Name: check_equality_op(realtime.equality_op, regtype, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
declare
    op_symbol text;
    res boolean;
begin
    -- IS DISTINCT FROM / IS NOT DISTINCT FROM: infix, both sides typed literals
    if op = 'isdistinct' then
        execute format(
            'select %L::%s %s %L::%s',
            val_1,
            type_::text,
            case when negate then 'IS NOT DISTINCT FROM' else 'IS DISTINCT FROM' end,
            val_2,
            type_::text
        ) into res;
        return res;
    end if;

    -- IS requires a keyword RHS (NULL, TRUE, FALSE, UNKNOWN), not a typed literal
    if op = 'is' then
        if val_2 not in ('null', 'true', 'false', 'unknown') then
            raise exception 'invalid value for is filter: must be null, true, false, or unknown';
        end if;
        execute format(
            'select %L::%s %s %s',
            val_1,
            type_::text,
            case when negate then 'IS NOT' else 'IS' end,
            upper(val_2)
        ) into res;
        return res;
    end if;

    op_symbol = case
        when op = 'eq'    then '='
        when op = 'neq'   then '!='
        when op = 'lt'    then '<'
        when op = 'lte'   then '<='
        when op = 'gt'    then '>'
        when op = 'gte'   then '>='
        when op = 'in'    then '= any'
        when op = 'like'   then 'LIKE'
        when op = 'ilike'  then 'ILIKE'
        when op = 'match'  then '~'
        when op = 'imatch' then '~*'
        else null
    end;

    if op_symbol is null then
        raise exception 'unsupported equality operator: %', op::text;
    end if;

    execute format(
        'select %L::%s %s (%L::%s)',
        val_1,
        type_::text,
        op_symbol,
        val_2,
        case when op = 'in' then type_::text || '[]' else type_::text end
    ) into res;

    return case when negate then not res else res end;
end;
$$;


--
-- TOC entry 474 (class 1255 OID 17232)
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
    select
        filters is null
        or array_length(filters, 1) is null
        or coalesce(
            count(col.name) = count(1)
            and sum(
                realtime.check_equality_op(
                    op:=f.op,
                    type_:=coalesce(col.type_oid::regtype, col.type_name::regtype),
                    val_1:=col.value #>> '{}',
                    val_2:=f.value,
                    negate:=coalesce(f.negate, false)
                )::int
            ) filter (where col.name is not null) = count(col.name),
            false
        )
    from
        unnest(filters) f
        left join unnest(columns) col
            on f.column_name = col.name;
$$;


--
-- TOC entry 475 (class 1255 OID 17233)
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


--
-- TOC entry 518 (class 1255 OID 25599)
-- Name: list_changes_sync(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes_sync(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures the slot is read exactly once.
  consumed AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         realtime.settled_changes(
           slot_name, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM consumed
    WHERE consumed.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM consumed,
         realtime.apply_rls(
           wal := consumed.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE consumed.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


--
-- TOC entry 476 (class 1255 OID 17234)
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  SELECT
    realtime.wal2json_escape_identifier(nsp.nspname::text)
    || '.'
    || realtime.wal2json_escape_identifier(pc.relname::text)
  FROM pg_class pc
  JOIN pg_namespace nsp ON pc.relnamespace = nsp.oid
  WHERE pc.oid = entity
$$;


--
-- TOC entry 477 (class 1255 OID 17235)
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- TOC entry 478 (class 1255 OID 17236)
-- Name: send_binary(bytea, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, binary_payload, event, topic, private, extension)
    VALUES (generated_id, payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- TOC entry 517 (class 1255 OID 25597)
-- Name: settled_changes(name, integer, text[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.settled_changes(slot_name name, max_changes integer, VARIADIC opts text[]) RETURNS TABLE(lsn pg_lsn, xid xid, data text)
    LANGUAGE plpgsql
    AS $$
declare
  upto pg_lsn;
  total bigint;
  xids xid[];
  starts bigint[];
  snapshot pg_snapshot;
  running_xids xid[];
  xmax_age int;
  cut bigint;
begin
  -- Each statement in a volatile function takes its own snapshot, which is what lets the
  -- check below see a writer that was still in flight when the peek ran. Under REPEATABLE
  -- READ the snapshot never advances, so a deferred change would never be released.
  if current_setting('transaction_isolation') <> 'read committed' then
    raise exception 'realtime.settled_changes requires READ COMMITTED';
  end if;

  -- The peek and the read below cover the same WAL, so the read cannot reach a commit the
  -- check never saw.
  upto := pg_current_wal_flush_lsn();

  -- One entry per transaction, in commit order: its xid and the position of its first
  -- change. The peek uses the caller's own options, so max_changes counts exactly what the
  -- read counts. A non-transactional logical message is emitted as soon as it is decoded,
  -- tagged with the xid of whatever transaction wrote it, so it does not mark where that
  -- transaction starts.
  select coalesce(sum(g.n), 0),
         array_agg(g.x order by g.first) filter (where g.first is not null),
         array_agg(g.first order by g.first) filter (where g.first is not null)
    into total, xids, starts
    from (
      select p.xid as x, count(*) as n,
             min(p.ord) filter (where not case
               when starts_with(p.data, '{"action":"M"') then (p.data::jsonb->>'transactional')::boolean is false
               else false
             end) as first
      from pg_logical_slot_peek_changes(slot_name, upto, max_changes, variadic opts)
           with ordinality as p(lsn, xid, data, ord)
      group by p.xid
    ) g;

  -- Nothing for the caller, but the slot still has to move past what the peek covered.
  if total = 0 then
    perform pg_replication_slot_advance(slot_name, upto);
    return;
  end if;

  if xids is not null then
    -- Taken after the peek is materialized, so a writer that was still in flight during
    -- decoding is guaranteed to show up here.
    snapshot := pg_current_snapshot();

    -- A commit record reaches the WAL before the writer leaves the proc array, so a change
    -- can be decoded while its row is invisible. apply_rls would resolve a policy against a
    -- row it cannot see and authorize it for nobody, while the read consumed it regardless.
    --
    -- xip lists transactions running when the snapshot was taken. It does not cover a writer
    -- whose xid sits at or beyond xmax, which never appears there, so the horizon is checked
    -- too. age() counts backwards from the current xid and so compares correctly across
    -- wraparound.
    select coalesce(array_agg(running.x::xid), array[]::xid[])
      into running_xids
      from pg_snapshot_xip(snapshot) running(x);
    xmax_age := age(pg_snapshot_xmax(snapshot)::xid);

    select min(u.s) into cut
      from unnest(xids, starts) as u(x, s)
      where u.x = any(running_xids) or age(u.x) <= xmax_age;
  end if;

  -- The read stops right after the commit that brings its count to upto_nchanges, so the
  -- count of changes in front of the first unsettled transaction stops it just before that
  -- transaction.
  if cut is null then
    return query
      select p.* from pg_logical_slot_get_changes(slot_name, upto, max_changes, variadic opts) p;
  elsif cut > 1 then
    return query
      select p.* from pg_logical_slot_get_changes(slot_name, upto, (cut - 1)::int, variadic opts) p;
  end if;
end;
$$;


--
-- TOC entry 479 (class 1255 OID 17237)
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    col_names text[] = coalesce(
            array_agg(a.attname order by a.attnum),
            '{}'::text[]
        )
        from
            pg_catalog.pg_attribute a
        where
            a.attrelid = new.entity
            and a.attnum > 0
            and not a.attisdropped
            and pg_catalog.has_column_privilege(
                (new.claims ->> 'role'),
                a.attrelid,
                a.attnum,
                'SELECT'
            );
    filter realtime.user_defined_filter;
    col_type regtype;
    in_val jsonb;
    selected_col text;
begin
    for filter in select * from unnest(new.filters) loop
        if not filter.column_name = any(col_names) then
            raise exception 'invalid column for filter %', filter.column_name;
        end if;

        col_type = (
            select atttypid::regtype
            from pg_catalog.pg_attribute
            where attrelid = new.entity
                  and attname = filter.column_name
        );
        if col_type is null then
            raise exception 'failed to lookup type for column %', filter.column_name;
        end if;

        if filter.op = 'in'::realtime.equality_op then
            in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
            if coalesce(jsonb_array_length(in_val), 0) > 100 then
                raise exception 'too many values for `in` filter. Maximum 100';
            end if;
        elsif filter.op = 'is'::realtime.equality_op then
            -- `is` requires a keyword RHS rather than a typed literal
            if filter.value not in ('null', 'true', 'false', 'unknown') then
                raise exception 'invalid value for is filter: must be null, true, false, or unknown';
            end if;
            -- IS NULL works for any type, but IS TRUE/FALSE/UNKNOWN require a boolean
            -- operand. Reject the non-null keywords on non-boolean columns here so they
            -- don't abort apply_rls at WAL time.
            if filter.value <> 'null' and col_type <> 'boolean'::regtype then
                raise exception 'is % filter requires a boolean column, got %', filter.value, col_type::text;
            end if;
        elsif filter.op in ('like'::realtime.equality_op, 'ilike'::realtime.equality_op) then
            -- like/ilike apply the text pattern operator (~~); reject column types that
            -- have no such operator instead of failing at WAL time
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = '~~' and oprleft = col_type
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
        elsif filter.op in ('match'::realtime.equality_op, 'imatch'::realtime.equality_op) then
            -- match/imatch apply the regex operators ~ / ~*; reject column types that have
            -- no such operator (e.g. integer) instead of failing at WAL time, mirroring the
            -- like/ilike guard above.
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = case when filter.op = 'imatch'::realtime.equality_op then '~*' else '~' end
                  and oprleft = col_type
                  and oprright = col_type
                  and oprresult = 'boolean'::regtype
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
            -- validate the regex eagerly so a bad pattern is rejected here, not inside
            -- apply_rls where it would abort the WAL stream for the entity
            begin
                perform '' ~ filter.value;
            exception when others then
                raise exception 'invalid regular expression for % filter: %', filter.op::text, sqlerrm;
            end;
        else
            -- eq/neq/lt/lte/gt/gte: value must be coercable to the type
            perform realtime.cast(filter.value, col_type);
        end if;
    end loop;

    if new.selected_columns is not null then
        for selected_col in select * from unnest(new.selected_columns) loop
            if not selected_col = any(col_names) then
                raise exception 'invalid column for select %', selected_col;
            end if;
        end loop;
    end if;

    -- Apply consistent order to filters so the unique constraint can't be tricked by a
    -- different filter order. negate is part of the sort key.
    new.filters = coalesce(
        array_agg(f order by f.column_name, f.op, f.value, f.negate),
        '{}'
    ) from unnest(new.filters) f;

    -- Normalize selected_columns order so ARRAY['a','b'] and ARRAY['b','a'] are treated
    -- as the same subscription group in apply_rls. Preserve an empty array as '{}'
    -- ("primary keys only") so it stays distinct from NULL ("all columns"); array_agg
    -- over an empty set would otherwise collapse '{}' back to NULL.
    if new.selected_columns is not null then
        new.selected_columns = coalesce(
            (
                select array_agg(c order by c)
                from unnest(new.selected_columns) c
            ),
            '{}'::text[]
        );
    end if;

    return new;
end;
$$;


--
-- TOC entry 480 (class 1255 OID 17240)
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- TOC entry 481 (class 1255 OID 17241)
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- TOC entry 482 (class 1255 OID 17242)
-- Name: wal2json_escape_identifier(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.wal2json_escape_identifier(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  -- Prefix `\`, `,`, `.`, and any whitespace with `\`
  SELECT regexp_replace(name, '([\\,.[:space:]])', '\\\1', 'g')
$$;


--
-- TOC entry 493 (class 1255 OID 17474)
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


--
-- TOC entry 492 (class 1255 OID 17473)
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


--
-- TOC entry 487 (class 1255 OID 17349)
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- TOC entry 510 (class 1255 OID 25485)
-- Name: enforce_bucket_lifecycle_service_role(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_lifecycle_service_role() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog'
    AS $$
BEGIN
  IF current_user::text IS DISTINCT FROM TG_ARGV[0]
     AND (
       OLD.lifecycle_configuration IS DISTINCT FROM NEW.lifecycle_configuration
       OR OLD.lifecycle_configuration_generation IS DISTINCT FROM NEW.lifecycle_configuration_generation
     ) THEN
    -- AFTER runs only after caller RLS has accepted the proposed row. The API
    -- recognizes this specific error after rolling back its permission probe;
    -- direct non-service writes still fail and cannot persist the change.
    RAISE EXCEPTION 'bucket control columns may only be changed by the configured storage service role'
      USING ERRCODE = 'PST01',
            SCHEMA = TG_TABLE_SCHEMA,
            TABLE = TG_TABLE_NAME,
            CONSTRAINT = TG_NAME;
  END IF;

  RETURN NULL;
END;
$$;


--
-- TOC entry 489 (class 1255 OID 17405)
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- TOC entry 485 (class 1255 OID 17324)
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- TOC entry 484 (class 1255 OID 17323)
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    RETURN _parts[array_length(_parts, 1)];
END
$$;


--
-- TOC entry 483 (class 1255 OID 17322)
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


--
-- TOC entry 490 (class 1255 OID 17462)
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN p_delimiter <> ''
         AND position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(
        p_key,
        length(p_prefix)
            + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1))
            + length(p_delimiter) - 1
    )
    ELSE NULL
END;
$$;


--
-- TOC entry 516 (class 1255 OID 25497)
-- Name: get_size_by_bucket(text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket(noncurrent_versions text DEFAULT 'include'::text, delete_markers text DEFAULT 'include'::text) RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'include');
    delete_markers := COALESCE(delete_markers, 'include');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'include';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'include';
    END IF;

    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        where (noncurrent_versions != 'exclude' OR obj.archived_at IS NULL)
          and (noncurrent_versions != 'only' OR obj.archived_at IS NOT NULL)
          and (delete_markers != 'exclude' OR NOT obj.is_delete_marker)
          and (delete_markers != 'only' OR obj.is_delete_marker)
        group by obj.bucket_id;
END
$$;


--
-- TOC entry 511 (class 1255 OID 25489)
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text, raw_prefix_param text DEFAULT NULL::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE sql STABLE
    AS $_$
WITH candidates AS (
    SELECT
        upload.key AS object_key,
        CASE
            WHEN position($3 IN substring(upload.key FROM length(coalesce($7, $2)) + 1)) > 0
            THEN left(
                upload.key,
                length(coalesce($7, $2))
                    + position($3 IN substring(upload.key FROM length(coalesce($7, $2)) + 1))
                    + length($3) - 1
            )
            ELSE upload.key
        END AS result_key,
        upload.id,
        upload.created_at,
        position($3 IN substring(upload.key FROM length(coalesce($7, $2)) + 1)) > 0 AS is_common_prefix
    FROM storage.s3_multipart_uploads AS upload
    WHERE upload.bucket_id = $1
      AND upload.key COLLATE "C" LIKE $2 || '%'
), filtered AS (
    SELECT candidate.*
    FROM candidates AS candidate
    WHERE $5 = ''
       OR candidate.result_key COLLATE "C" > $5
       OR (
           candidate.result_key COLLATE "C" = $5
           AND NOT candidate.is_common_prefix
           AND $6 <> ''
           -- A completed or aborted marker repeats the remaining same-key uploads.
           AND COALESCE(
               (candidate.created_at, candidate.id COLLATE "C") > (
                   SELECT marker.created_at, marker.id COLLATE "C"
                   FROM storage.s3_multipart_uploads AS marker
                   WHERE marker.bucket_id = $1
                     AND marker.key COLLATE "C" = $5
                     AND marker.id = $6
               ),
               TRUE
           )
       )
), ranked AS (
    SELECT
        filtered.*,
        row_number() OVER (
            PARTITION BY filtered.result_key COLLATE "C"
            ORDER BY filtered.created_at, filtered.id COLLATE "C"
        ) AS prefix_rank
    FROM filtered
)
SELECT ranked.result_key, ranked.id, ranked.created_at
FROM ranked
WHERE NOT ranked.is_common_prefix OR ranked.prefix_rank = 1
ORDER BY ranked.result_key COLLATE "C", ranked.created_at, ranked.id COLLATE "C"
LIMIT $4;
$_$;


--
-- TOC entry 512 (class 1255 OID 25490)
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text, text, text, timestamp with time zone, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text, next_token_archived_at timestamp with time zone DEFAULT NULL::timestamp with time zone, next_token_version text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_start_relative TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;
    v_version_filter TEXT;

    -- true when noncurrent_versions can return >1 row per name; keeps them
    -- ordered most-recent-first and lets pagination resume mid-key
    v_multi_row BOOLEAN;
    v_name_order TEXT;
    v_exact_range_predicate TEXT;
    v_strict_range_predicate TEXT;
    v_inclusive_range_predicate TEXT;

    -- Seek state for the current name. archived_at is normalized to JavaScript's
    -- millisecond precision and version breaks ties within the same millisecond.
    -- Current rows use 'infinity'; NULL means no tiebreak has been established.
    v_next_seek TEXT;
    v_next_seek_at TIMESTAMPTZ;
    v_next_seek_version TEXT;
    v_next_seek_strict BOOLEAN := false;
    v_cursor_is_folder BOOLEAN;
    v_count INT := 0;
    v_previous_seek TEXT;
    v_previous_seek_at TIMESTAMPTZ;
    v_previous_seek_version TEXT;
    v_previous_count INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;
    v_batch_query_strict TEXT;
    v_delete_marker_peek_query TEXT;
    v_delete_marker_peek_query_strict TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);
    v_next_seek_at := NULL;
    v_next_seek_version := '';

    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'exclude');
    delete_markers := COALESCE(delete_markers, 'exclude');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'exclude';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'exclude';
    END IF;

    v_multi_row := noncurrent_versions IN ('only', 'include');
    v_name_order := CASE WHEN v_is_asc THEN 'ASC' ELSE 'DESC' END;

    v_version_filter := '';
    IF noncurrent_versions = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NULL';
    ELSIF noncurrent_versions = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NOT NULL';
    END IF;
    IF delete_markers = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND NOT o.is_delete_marker';
    ELSIF delete_markers = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.is_delete_marker';
    END IF;

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Keep caller-provided cursors inside the requested prefix range.
    IF v_start <> '' AND v_upper_bound IS NOT NULL THEN
        IF v_is_asc THEN
            IF v_start COLLATE "C" < v_prefix COLLATE "C" THEN
                v_start := '';
            ELSIF v_start COLLATE "C" >= v_upper_bound COLLATE "C" THEN
                RETURN;
            END IF;
        ELSE
            IF v_start COLLATE "C" < v_prefix COLLATE "C" THEN
                RETURN;
            ELSIF v_start COLLATE "C" >= v_upper_bound COLLATE "C" THEN
                v_start := '';
            END IF;
        END IF;
    END IF;

    v_start_relative := substring(v_start FROM length(v_prefix) + 1);

    -- Direction affects only the indexed name range and its ordering. Cursor
    -- state transitions and within-key version ordering stay shared.
    IF v_is_asc THEN
        v_exact_range_predicate := 'TRUE';
        v_strict_range_predicate := 'o.name COLLATE "C" > $2';
        v_inclusive_range_predicate := 'o.name COLLATE "C" >= $2';
        IF v_upper_bound IS NOT NULL THEN
            v_exact_range_predicate := 'o.name COLLATE "C" < $3';
            v_strict_range_predicate := v_strict_range_predicate || ' AND o.name COLLATE "C" < $3';
            v_inclusive_range_predicate := v_inclusive_range_predicate || ' AND o.name COLLATE "C" < $3';
        END IF;
    ELSE
        v_exact_range_predicate := 'TRUE';
        v_strict_range_predicate := 'o.name COLLATE "C" < $2';
        v_inclusive_range_predicate := 'o.name COLLATE "C" < $2';
        IF v_prefix <> '' THEN
            v_exact_range_predicate := 'o.name COLLATE "C" >= $3';
            v_strict_range_predicate := v_strict_range_predicate || ' AND o.name COLLATE "C" >= $3';
            v_inclusive_range_predicate := v_inclusive_range_predicate || ' AND o.name COLLATE "C" >= $3';
        END IF;
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    -- The multi-row order matches the externally serialized cursor exactly:
    -- archived_at at millisecond precision, then version as the final tiebreak.
    --
    -- When v_multi_row, the seek is a keyset tuple comparison ("name > $2 OR
    -- (name = $2 AND tiebreak)") - Postgres won't split that OR into indexable
    -- form (confirmed even with fully literal values), so as one WHERE clause
    -- it forces a full bucket scan filtered row-by-row. Splitting it into two
    -- independently-indexable branches (exact name match with the tiebreak
    -- filter, vs. strictly-past names) combined with UNION ALL lets each
    -- branch keep name as a real index condition; the outer ORDER BY/LIMIT
    -- re-merges them into the same page the single query used to produce.
    IF v_multi_row THEN
        v_batch_query := format(
            $sql$
            SELECT *
            FROM (
                (
                    SELECT o.name, o.id, o.updated_at, o.created_at,
                           o.last_accessed_at, o.metadata, o.version,
                           o.archived_at, o.is_delete_marker, o.is_versioned
                    FROM storage.objects o
                    WHERE o.bucket_id = $1
                      AND o.name COLLATE "C" = $2
                      AND %s
                      AND NOT $7::boolean
                      AND (
                          $5::timestamptz IS NULL
                          OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < $5
                          OR (
                              COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = $5
                              AND COALESCE(o.version, '') > $6
                          )
                      )
                      %s
                    ORDER BY
                        COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC,
                        COALESCE(o.version, '') ASC
                    LIMIT $4
                )
                UNION ALL
                (
                    SELECT o.name, o.id, o.updated_at, o.created_at,
                           o.last_accessed_at, o.metadata, o.version,
                           o.archived_at, o.is_delete_marker, o.is_versioned
                    FROM storage.objects o
                    WHERE o.bucket_id = $1
                      AND %s
                      %s
                    ORDER BY
                        o.name COLLATE "C" %s,
                        COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC,
                        COALESCE(o.version, '') ASC
                    LIMIT $4
                )
            ) sub
            ORDER BY
                sub.name COLLATE "C" %s,
                COALESCE(date_trunc('milliseconds', sub.archived_at), 'infinity'::timestamptz) DESC,
                COALESCE(sub.version, '') ASC
            LIMIT $4
            $sql$,
            v_exact_range_predicate,
            v_version_filter,
            v_strict_range_predicate,
            v_version_filter,
            v_name_order,
            v_name_order
        );
    ELSE
        v_batch_query := format(
            $sql$
            SELECT o.name, o.id, o.updated_at, o.created_at,
                   o.last_accessed_at, o.metadata, o.version,
                   o.archived_at, o.is_delete_marker, o.is_versioned
            FROM storage.objects o
            WHERE o.bucket_id = $1
              AND %s
              %s
            ORDER BY o.name COLLATE "C" %s, o.archived_at DESC
            LIMIT $4
            $sql$,
            v_inclusive_range_predicate,
            v_version_filter,
            v_name_order
        );

        -- Strict counterpart of the query above: used once the single-row
        -- ASC batch advance (below) has left v_next_seek pointing at the
        -- last row already emitted, so an inclusive predicate would
        -- re-match it forever. Only single-row mode ever sets strict mode,
        -- so this variant is never needed when v_multi_row.
        v_batch_query_strict := format(
            $sql$
            SELECT o.name, o.id, o.updated_at, o.created_at,
                   o.last_accessed_at, o.metadata, o.version,
                   o.archived_at, o.is_delete_marker, o.is_versioned
            FROM storage.objects o
            WHERE o.bucket_id = $1
              AND %s
              %s
            ORDER BY o.name COLLATE "C" %s, o.archived_at DESC
            LIMIT $4
            $sql$,
            v_strict_range_predicate,
            v_version_filter,
            v_name_order
        );
    END IF;

    -- The static peek predicates cannot use the partial delete-marker index
    -- once PL/pgSQL switches to a generic plan because whether
    -- is_delete_marker is required remains parameter-dependent. Reuse the
    -- already-specialized batch query with a one-row limit for this sparse
    -- filter so the plan sees a literal `o.is_delete_marker` predicate.
    IF delete_markers = 'only' THEN
        v_delete_marker_peek_query :=
            'SELECT marker_page.name FROM (' || v_batch_query || ') marker_page LIMIT 1';
        IF NOT v_multi_row THEN
            v_delete_marker_peek_query_strict :=
                'SELECT marker_page.name FROM (' || v_batch_query_strict || ') marker_page LIMIT 1';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor performs one specialized initial seek so
            -- partial current-version and delete-marker indexes remain available.
            EXECUTE format(
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1%s%s ORDER BY o.name COLLATE "C" DESC LIMIT 1',
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND o.name COLLATE "C" >= $2 AND o.name COLLATE "C" < $3'
                    ELSE ''
                END,
                v_version_filter
            )
            INTO v_next_seek
            USING _bucket_id, v_prefix, v_upper_bound;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Folder continuation tokens retain their trailing delimiter. A
        -- delimiter-less startAfter is always a literal key boundary.
        v_cursor_is_folder := delimiter_param <> ''
            AND v_start_relative <> ''
            AND right(v_start_relative, length(delimiter_param)) = delimiter_param;

        IF v_cursor_is_folder THEN
            v_next_seek := CASE
                WHEN right(v_start, length(delimiter_param)) = delimiter_param
                    THEN v_start
                ELSE v_start || delimiter_param
            END;
            IF v_is_asc THEN
                v_next_seek := left(v_next_seek, -1)
                    || chr(ascii(right(v_next_seek, 1)) + 1);
            END IF;
            v_next_seek_strict := NOT v_is_asc;
        ELSE
            -- leaf object: when v_multi_row, stay on v_start with the
            -- caller-supplied tiebreak so a page boundary mid-key resumes
            -- that key's remaining rows instead of skipping them. Truncate
            -- to milliseconds like every other v_next_seek_at assignment -
            -- harmless today since object.ts's cursor always round-trips
            -- through JS Date first, but this shouldn't rely on that.
            IF v_multi_row THEN
                v_next_seek := v_start;
                v_next_seek_at := date_trunc('milliseconds', next_token_archived_at);
                v_next_seek_version := coalesce(next_token_version, '');
                v_next_seek_strict := coalesce(next_token, '') = '';
            ELSIF v_is_asc THEN
                v_next_seek := v_start;
                v_next_seek_strict := true;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        v_previous_seek := v_next_seek;
        v_previous_seek_at := v_next_seek_at;
        v_previous_seek_version := v_next_seek_version;
        v_previous_count := v_count;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        -- v_multi_row is branched here (rather than folded into the WHERE
        -- clause as a bound parameter) so each concrete query keeps an
        -- unconditional seek predicate - once PL/pgSQL switches to its
        -- cached generic plan (after 5 calls), a parameter-gated
        -- "(NOT v_multi_row AND name >= $x) OR (v_multi_row AND ...)"
        -- predicate stops the planner from using name as an index
        -- condition at all, degrading every subsequent peek to a full
        -- index scan filtered row-by-row instead of a bounded range scan.
        -- v_multi_row's seek predicate is a keyset tuple comparison
        -- ("name > x OR (name = x AND tiebreak)") - Postgres does not
        -- split this OR into indexable form even with fully literal
        -- values, so it falls back to a full scan filtered row-by-row.
        -- Splitting it into two independently-indexable branches (exact
        -- name match with the tiebreak filter, vs. strictly-past name)
        -- combined with UNION ALL lets each branch keep name as a real
        -- index condition; the outer ORDER BY/LIMIT picks whichever of
        -- the (at most 2) rows sorts first.
        IF delete_markers = 'only' THEN
            EXECUTE CASE WHEN v_next_seek_strict AND NOT v_multi_row
                THEN v_delete_marker_peek_query_strict
                ELSE v_delete_marker_peek_query
            END
                INTO v_peek_name
                USING _bucket_id, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END,
                    1, v_next_seek_at, v_next_seek_version, v_next_seek_strict;
        ELSIF v_multi_row THEN
            IF v_is_asc THEN
                IF v_upper_bound IS NOT NULL THEN
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND o.name COLLATE "C" < v_upper_bound
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" > v_next_seek AND o.name COLLATE "C" < v_upper_bound
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" ASC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" ASC LIMIT 1;
                ELSE
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" > v_next_seek
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" ASC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" ASC LIMIT 1;
                END IF;
            ELSE
                IF v_upper_bound IS NOT NULL THEN
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND o.name COLLATE "C" >= v_prefix
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" DESC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" DESC LIMIT 1;
                ELSE
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" DESC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" DESC LIMIT 1;
                END IF;
            END IF;
        ELSE
            -- Single-row mode is always noncurrent_versions='exclude'. Keep
            -- this predicate literal so generic plans use the current index.
            IF v_is_asc THEN
                IF v_next_seek_strict AND v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" > v_next_seek
                      AND o.name COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                ELSIF v_next_seek_strict THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" > v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                ELSIF v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" >= v_next_seek
                      AND o.name COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                ELSE
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" >= v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                END IF;
            ELSE
                IF v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" < v_next_seek
                      AND o.name COLLATE "C" >= v_prefix
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" DESC LIMIT 1;
                ELSE
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" < v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" DESC LIMIT 1;
                END IF;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := v_common_prefix;
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            version := NULL;
            archived_at := NULL;
            is_delete_marker := NULL;
            is_versioned := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1)
                    || chr(ascii(right(v_common_prefix, 1)) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
            v_next_seek_at := NULL;
            v_next_seek_version := '';
            v_next_seek_strict := NOT v_is_asc;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE CASE WHEN v_next_seek_strict AND NOT v_multi_row THEN v_batch_query_strict ELSE v_batch_query END
                USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size, v_next_seek_at, v_next_seek_version,
                v_next_seek_strict
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it. Reset
                    -- strict mode too it may have been set by an earlier
                    -- row in this same batch (see the single-row ASC advance
                    -- below), and v_next_seek here is the folder-triggering
                    -- row's own name, which the next peek must find inclusively.
                    v_next_seek := CASE
                        WHEN v_is_asc THEN v_current.name
                        ELSE v_current.name || delimiter_param
                    END;
                    v_next_seek_at := NULL;
                    v_next_seek_version := '';
                    v_next_seek_strict := false;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                version := v_current.version;
                archived_at := v_current.archived_at;
                is_delete_marker := v_current.is_delete_marker;
                is_versioned := v_current.is_versioned;
                RETURN NEXT;
                v_count := v_count + 1;

                -- when v_multi_row, stay on this name and record its
                -- archived_at as the new tiebreak so remaining rows for the
                -- same key are picked up before moving to the next name
                IF v_multi_row THEN
                    v_next_seek := v_current.name;
                    v_next_seek_at := COALESCE(date_trunc('milliseconds', v_current.archived_at), 'infinity'::timestamptz);
                    v_next_seek_version := COALESCE(v_current.version, '');
                    v_next_seek_strict := false;
                ELSIF v_is_asc THEN
                    -- Appending the delimiter as a fake lexical successor
                    -- would skip a real key like `name || '!'` (or any
                    -- character sorting below the delimiter), which sorts
                    -- between `name` and `name || delimiter`. Track the real
                    -- name and mark the next comparison strict instead.
                    v_next_seek := v_current.name;
                    v_next_seek_strict := true;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;

        IF v_count = v_previous_count
           AND v_next_seek IS NOT DISTINCT FROM v_previous_seek
           AND v_next_seek_at IS NOT DISTINCT FROM v_previous_seek_at
           AND v_next_seek_version IS NOT DISTINCT FROM v_previous_seek_version THEN
            RAISE EXCEPTION 'storage.list_objects_with_delimiter made no progress at seek (%, %, %)',
                v_next_seek, v_next_seek_at, v_next_seek_version;
        END IF;
    END LOOP;
END;
$_$;


--
-- TOC entry 488 (class 1255 OID 17404)
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- TOC entry 509 (class 1255 OID 25484)
-- Name: protect_bucket_control_columns(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_bucket_control_columns() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog'
    AS $$
DECLARE
  configuration_changed boolean;
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.lifecycle_configuration IS NOT NULL
       OR NEW.lifecycle_configuration_generation IS NOT NULL THEN
      IF NOT pg_has_role(current_user, TG_ARGV[0], 'MEMBER') THEN
        RAISE EXCEPTION 'only members of the configured storage service role may insert lifecycle policy state'
          USING ERRCODE = '42501',
                HINT = format(
                  'Insert with both lifecycle columns NULL and configure lifecycle through the Storage API afterward, or insert as a member of %I.',
                  TG_ARGV[0]
                );
      END IF;
    END IF;

    RETURN NEW;
  END IF;

  configuration_changed =
    OLD.lifecycle_configuration IS DISTINCT FROM NEW.lifecycle_configuration
    OR OLD.lifecycle_configuration_generation IS DISTINCT FROM NEW.lifecycle_configuration_generation;

  IF NOT configuration_changed THEN
    RETURN NEW;
  END IF;

  IF NEW.type IS DISTINCT FROM 'STANDARD' THEN
    RAISE EXCEPTION 'bucket versioning and lifecycle controls require a Standard bucket'
      USING ERRCODE = '0A000';
  END IF;

  IF NEW.lifecycle_configuration IS NULL
     AND NEW.lifecycle_configuration_generation IS NULL THEN
    RETURN NEW;
  END IF;

  IF NEW.lifecycle_configuration IS NULL
     OR NEW.lifecycle_configuration_generation IS NULL
     OR OLD.lifecycle_configuration IS NOT DISTINCT FROM NEW.lifecycle_configuration
     OR OLD.lifecycle_configuration_generation IS NOT DISTINCT FROM NEW.lifecycle_configuration_generation THEN
    RAISE EXCEPTION 'a changed lifecycle policy requires a new non-null generation'
      USING ERRCODE = '22023';
  END IF;

  RETURN NEW;
END;
$$;


--
-- TOC entry 491 (class 1255 OID 17469)
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- TOC entry 513 (class 1255 OID 25492)
-- Name: search(text, text, integer, integer, integer, text, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_prefix_len INT;
    v_prefix_start INT;
    v_combined_levels INT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;
    v_version_filter TEXT;
    v_multi_row BOOLEAN;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;
    v_delete_marker_peek_query TEXT;
    v_delete_marker_peek_query_strict TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_next_seek_at TIMESTAMPTZ;
    v_next_seek_version TEXT;
    v_next_seek_strict BOOLEAN := false;
    v_count INT := 0;
    v_skipped INT := 0;
    v_previous_seek TEXT;
    v_previous_seek_at TIMESTAMPTZ;
    v_previous_seek_version TEXT;
    v_previous_count INT;
    v_previous_skipped INT;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_prefix_len := length(coalesce(prefix, ''));
    v_prefix_start := coalesce(array_length(string_to_array(coalesce(prefix, ''), v_delimiter), 1), 1);
    v_combined_levels := coalesce(array_length(string_to_array(v_prefix, v_delimiter), 1), 1);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);
    v_next_seek_at := NULL;
    v_next_seek_version := '';

    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'exclude');
    delete_markers := COALESCE(delete_markers, 'exclude');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'exclude';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'exclude';
    END IF;

    v_multi_row := noncurrent_versions IN ('only', 'include');

    v_version_filter := '';
    IF noncurrent_versions = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NULL';
    ELSIF noncurrent_versions = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NOT NULL';
    END IF;
    IF delete_markers = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND NOT o.is_delete_marker';
    ELSIF delete_markers = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.is_delete_marker';
    END IF;

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT array_to_string(path_tokens[$1:$2], '/') AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $3 || '%%'
                  AND bucket_id = $4
                  AND array_length(objects.path_tokens, 1) <> $2
                  AND ($7 != 'exclude' OR objects.archived_at IS NULL)
                  AND ($7 != 'only' OR objects.archived_at IS NOT NULL)
                  AND ($8 != 'exclude' OR NOT objects.is_delete_marker)
                  AND ($8 != 'only' OR objects.is_delete_marker)
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata,
                   NULL::text AS version,
                   NULL::timestamptz AS archived_at,
                   NULL::boolean AS is_delete_marker,
                   NULL::boolean AS is_versioned FROM folders)
            UNION ALL
            (SELECT array_to_string(path_tokens[$1:$2], '/') AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata,
                   version, archived_at, is_delete_marker, is_versioned
             FROM storage.objects
             WHERE objects.name ILIKE $3 || '%%'
               AND bucket_id = $4
               AND array_length(objects.path_tokens, 1) = $2
               AND ($7 != 'exclude' OR objects.archived_at IS NULL)
               AND ($7 != 'only' OR objects.archived_at IS NOT NULL)
               AND ($8 != 'exclude' OR NOT objects.is_delete_marker)
               AND ($8 != 'only' OR objects.is_delete_marker)
             -- name, then version, as tiebreaks so two versions of the same
             -- key tying on the sort column still sort deterministically
             ORDER BY %I %s, name COLLATE "C" %s, COALESCE(version, '') %s)
            LIMIT $5 OFFSET $6
            $sql$, v_sort_order, v_order_by, v_sort_order, v_sort_order, v_sort_order
        ) USING v_prefix_start, v_combined_levels, v_prefix, bucketname, v_limit, offsets, noncurrent_versions, delete_markers;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build a resume-safe batch query. The exact-name branch returns remaining
    -- versions after the current (archived_at, version) boundary; the strict
    -- name branch returns subsequent keys. UNION ALL keeps both predicates
    -- independently indexable.
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" > $2 AND lower(o.name) COLLATE "C" < $3' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" ASC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" > $2' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" ASC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 AND lower(o.name) COLLATE "C" >= $3' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" DESC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" DESC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" DESC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" DESC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        END IF;
    END IF;

    -- Keep the delete-marker predicate literal so the cached generic
    -- plan can use idx_objects_delete_markers during the main-loop peek.
    IF delete_markers = 'only' THEN
        IF v_multi_row THEN
            v_delete_marker_peek_query :=
                'SELECT marker_page.name FROM (' || v_batch_query || ') marker_page LIMIT 1';
        ELSIF v_is_asc THEN
            -- Two separate literal query strings, not one gated by a bound
            -- boolean: folding "$n AND op1 OR NOT $n AND op2" into a single
            -- query defeats the generic plan's ability to push either
            -- comparison into the index. Branching in PL/pgSQL control flow
            -- instead keeps each query's index condition intact.
            v_delete_marker_peek_query :=
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1 ' ||
                'AND lower(o.name) COLLATE "C" >= $2' ||
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND lower(o.name) COLLATE "C" < $3'
                    ELSE ''
                END ||
                v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1';
            -- Strict variant: used once the single-row ASC batch advance
            -- (below) has left v_next_seek pointing at the last row already
            -- emitted, so a plain >= would re-match it forever.
            v_delete_marker_peek_query_strict :=
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1 ' ||
                'AND lower(o.name) COLLATE "C" > $2' ||
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND lower(o.name) COLLATE "C" < $3'
                    ELSE ''
                END ||
                v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1';
        ELSE
            v_delete_marker_peek_query :=
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1 ' ||
                'AND lower(o.name) COLLATE "C" < $2' ||
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND lower(o.name) COLLATE "C" >= $3'
                    ELSE ''
                END ||
                v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC performs one specialized initial seek so partial current-version
        -- and delete-marker indexes remain available.
        EXECUTE format(
            'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1%s%s ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1',
            CASE WHEN v_upper_bound IS NOT NULL
                THEN ' AND lower(o.name) COLLATE "C" >= $2 AND lower(o.name) COLLATE "C" < $3'
                ELSE ''
            END,
            v_version_filter
        )
        INTO v_peek_name
        USING bucketname, v_prefix_lower, v_upper_bound;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch and
    -- the delete-marker-only path
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        v_previous_seek := v_next_seek;
        v_previous_seek_at := v_next_seek_at;
        v_previous_seek_version := v_next_seek_version;
        v_previous_count := v_count;
        v_previous_skipped := v_skipped;

        -- STEP 1: PEEK
        v_peek_name := NULL;
        IF delete_markers = 'only' THEN
            EXECUTE CASE WHEN v_next_seek_strict
                THEN v_delete_marker_peek_query_strict
                ELSE v_delete_marker_peek_query
            END
                INTO v_peek_name
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END,
                    1, v_next_seek_at, v_next_seek_version;
        ELSIF v_multi_row AND v_next_seek_at IS NOT NULL THEN
            SELECT o.name INTO v_peek_name
            FROM storage.objects o
            WHERE o.bucket_id = bucketname
              AND lower(o.name) COLLATE "C" = v_next_seek
              AND (COALESCE(o.archived_at, 'infinity'::timestamptz) < v_next_seek_at
                   OR (COALESCE(o.archived_at, 'infinity'::timestamptz) = v_next_seek_at
                       AND COALESCE(o.version, '') > v_next_seek_version))
              AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
              AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
              AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
              AND (delete_markers != 'only' OR o.is_delete_marker)
            ORDER BY COALESCE(o.archived_at, 'infinity'::timestamptz) DESC,
                     COALESCE(o.version, '') ASC
            LIMIT 1;

            -- The current key is exhausted. Clear its version boundary and
            -- make the following ASC name peek strict. Appending '/' is not a
            -- valid lexical successor because keys ending in characters such
            -- as '!' sort between the exhausted name and name || '/'.
            IF v_peek_name IS NULL THEN
                IF v_is_asc THEN
                    v_next_seek_strict := true;
                END IF;
                v_next_seek_at := NULL;
                v_next_seek_version := '';
            END IF;
        END IF;

        -- Single-row mode is always noncurrent_versions='exclude'. Keep the
        -- current-row predicate literal so generic plans use the current index.
        IF delete_markers != 'only' AND v_peek_name IS NULL AND NOT v_multi_row THEN
            IF v_is_asc THEN
                IF v_next_seek_strict AND v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                ELSIF v_next_seek_strict THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                ELSIF v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                ELSE
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                END IF;
            ELSIF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                  AND o.archived_at IS NULL
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                  AND o.archived_at IS NULL
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        ELSIF delete_markers != 'only' AND v_peek_name IS NULL AND v_is_asc THEN
            IF v_next_seek_strict AND v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSIF v_next_seek_strict THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSIF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSIF delete_markers != 'only' AND v_peek_name IS NULL THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- If the peek landed on a different key than we were tracking, any
        -- version boundary belongs to the OLD key and must not leak into the
        -- new one - e.g. the deleteMarkers='only' peek doesn't know or care
        -- whether it's continuing the same key or jumping to a new one, so
        -- it never clears these itself.
        IF lower(v_peek_name) IS DISTINCT FROM v_next_seek THEN
            v_next_seek_at := NULL;
            v_next_seek_version := '';
        END IF;

        -- The peek is authoritative for the next key to process. This is
        -- especially important after exhausting a multi-version key: the
        -- version boundary has been cleared, so executing the batch against
        -- a stale v_next_seek would replay every version of that old key.
        v_next_seek := lower(v_peek_name);
        v_next_seek_strict := false;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := substring(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter) from v_prefix_len + 1);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                version := NULL;
                archived_at := NULL;
                is_delete_marker := NULL;
                is_versioned := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
            v_next_seek_at := NULL;
            v_next_seek_version := '';
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size,
                    v_next_seek_at, v_next_seek_version
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it. Reset
                    -- strict mode too - it may have been set by an earlier
                    -- row in this same batch (see the single-row ASC advance
                    -- below), and v_next_seek here is the folder-triggering
                    -- row's own name, which the next peek must find inclusively.
                    v_next_seek := CASE
                        WHEN v_is_asc THEN lower(v_current.name)
                        ELSE lower(v_current.name) || v_delimiter
                    END;
                    v_next_seek_at := NULL;
                    v_next_seek_version := '';
                    v_next_seek_strict := false;
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := substring(v_current.name from v_prefix_len + 1);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    version := v_current.version;
                    archived_at := v_current.archived_at;
                    is_delete_marker := v_current.is_delete_marker;
                    is_versioned := v_current.is_versioned;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Multi-row mode must remain on this key until all of its
                -- versions have crossed the internal batch boundary.
                IF v_multi_row THEN
                    v_next_seek := lower(v_current.name);
                    v_next_seek_at := COALESCE(v_current.archived_at, 'infinity'::timestamptz);
                    v_next_seek_version := COALESCE(v_current.version, '');
                ELSIF v_is_asc THEN
                    -- Appending the delimiter as a fake lexical successor would
                    -- skip a real key like `name || '!'` (or any character
                    -- sorting below the delimiter), which sorts between `name`
                    -- and `name || delimiter`. Track the real name and mark the
                    -- next comparison strict instead - same fix as the
                    -- exhausted-key case above.
                    v_next_seek := lower(v_current.name);
                    v_next_seek_strict := true;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;

        IF v_count = v_previous_count
           AND v_skipped = v_previous_skipped
           AND v_next_seek IS NOT DISTINCT FROM v_previous_seek
           AND v_next_seek_at IS NOT DISTINCT FROM v_previous_seek_at
           AND v_next_seek_version IS NOT DISTINCT FROM v_previous_seek_version THEN
            RAISE EXCEPTION 'storage.search made no progress at seek (%, %, %)',
                v_next_seek, v_next_seek_at, v_next_seek_version;
        END IF;
    END LOOP;
END;
$_$;


--
-- TOC entry 514 (class 1255 OID 25494)
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text, p_start_after_version text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
    v_prefix_pattern text;
    v_sort_order text;
    v_sort_column text;
    v_version_tiebreak text;
BEGIN
    v_prefix := coalesce(p_prefix, '');
    -- Keep the raw prefix for common-prefix calculations and escape only LIKE metacharacters.
    v_prefix_pattern := replace(v_prefix, chr(92), chr(92) || chr(92));
    v_prefix_pattern := replace(v_prefix_pattern, '%', chr(92) || '%');
    v_prefix_pattern := replace(v_prefix_pattern, '_', chr(92) || '_');

    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'exclude');
    delete_markers := COALESCE(delete_markers, 'exclude');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'exclude';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'exclude';
    END IF;

    -- $9 is only populated in multi-row mode; it's always '' otherwise, so
    -- only use each row's real version as a tiebreak in multi-row mode.
    v_version_tiebreak := CASE WHEN noncurrent_versions IN ('only', 'include') THEN 'COALESCE(version, '''')' ELSE '''''' END;

    -- Defense-in-depth: this function is independently reachable and must
    -- not trust p_sort_order/p_sort_column to already be validated by a
    -- caller. Normalize to the same strict allow-list storage.search_v2
    -- uses before interpolating anything into dynamic SQL below.
    v_sort_order := lower(coalesce(p_sort_order, 'asc'));
    IF v_sort_order NOT IN ('asc', 'desc') THEN
        v_sort_order := 'asc';
    END IF;

    v_sort_column := lower(coalesce(p_sort_column, 'updated_at'));
    IF v_sort_column NOT IN ('updated_at', 'created_at') THEN
        v_sort_column := 'updated_at';
    END IF;

    IF v_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                o.version AS obj_version,
                o.archived_at AS obj_archived_at,
                o.is_delete_marker AS obj_is_delete_marker,
                o.is_versioned AS obj_is_versioned,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $10 || '%%'
              AND ($7 != 'exclude' OR o.archived_at IS NULL)
              AND ($7 != 'only' OR o.archived_at IS NOT NULL)
              AND ($8 != 'exclude' OR NOT o.is_delete_marker)
              AND ($8 != 'only' OR o.is_delete_marker)
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                common_prefix AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                NULL::text AS version,
                NULL::timestamptz AS archived_at,
                NULL::boolean AS is_delete_marker,
                NULL::boolean AS is_versioned,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                obj_version AS version,
                obj_archived_at AS archived_at,
                obj_is_delete_marker AS is_delete_marker,
                obj_is_versioned AS is_versioned,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz),
                    name COLLATE "C",
                    %s
                ) %s ROW(
                    -- truncated the same way as the stored value above
                    date_trunc('milliseconds', COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz)),
                    $5,
                    $9
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata,
            version,
            archived_at,
            is_delete_marker,
            is_versioned
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s,
            COALESCE(version, '') %s
        LIMIT $4
    $sql$,
        v_sort_column,
        v_version_tiebreak,
        v_cursor_op,
        v_sort_column,
        v_sort_order,
        v_sort_order,
        v_sort_order
    );

    -- version is the third tiebreak component for two versions of the same
    -- key tying on both timestamp and name (see filtered CTE / ORDER BY above)
    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after, noncurrent_versions, delete_markers, coalesce(p_start_after_version, ''), v_prefix_pattern;
END;
$_$;


--
-- TOC entry 515 (class 1255 OID 25496)
-- Name: search_v2(text, text, integer, integer, text, text, text, text, text, text, timestamp with time zone, text, boolean); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text, start_after_archived_at timestamp with time zone DEFAULT NULL::timestamp with time zone, start_after_version text DEFAULT ''::text, start_after_is_continuation boolean DEFAULT false) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata,
            l.version,
            l.archived_at,
            l.is_delete_marker,
            l.is_versioned
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            CASE WHEN start_after_is_continuation THEN '' ELSE start_after END,
            CASE WHEN start_after_is_continuation THEN start_after ELSE '' END,
            v_sort_ord,
            noncurrent_versions,
            delete_markers,
            start_after_archived_at,
            start_after_version
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after,
            noncurrent_versions, delete_markers, start_after_version
        );
    END IF;
END;
$$;


--
-- TOC entry 486 (class 1255 OID 17339)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 313 (class 1259 OID 16529)
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 313
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- TOC entry 332 (class 1259 OID 17084)
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    custom_claims_allowlist text[] DEFAULT '{}'::text[] NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


--
-- TOC entry 326 (class 1259 OID 16889)
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 326
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- TOC entry 317 (class 1259 OID 16687)
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 317
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- TOC entry 312 (class 1259 OID 16522)
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 312
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- TOC entry 321 (class 1259 OID 16776)
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 321
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- TOC entry 320 (class 1259 OID 16764)
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 320
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- TOC entry 319 (class 1259 OID 16751)
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 319
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 319
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- TOC entry 383 (class 1259 OID 25551)
-- Name: mfa_recovery_code_sets; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_recovery_code_sets (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    mfa_factor_id uuid NOT NULL,
    failed_verification_count integer DEFAULT 0 NOT NULL,
    verification_locked_until timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mfa_recovery_code_sets_failed_verification_count_check CHECK ((failed_verification_count >= 0))
);


--
-- TOC entry 384 (class 1259 OID 25574)
-- Name: mfa_recovery_codes; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_recovery_codes (
    id uuid NOT NULL,
    mfa_recovery_code_set_id uuid NOT NULL,
    code_hash text NOT NULL,
    consumed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 329 (class 1259 OID 17001)
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


--
-- TOC entry 331 (class 1259 OID 17074)
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- TOC entry 328 (class 1259 OID 16971)
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


--
-- TOC entry 330 (class 1259 OID 17034)
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


--
-- TOC entry 327 (class 1259 OID 16939)
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- TOC entry 311 (class 1259 OID 16511)
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 311
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- TOC entry 310 (class 1259 OID 16510)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 310
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- TOC entry 324 (class 1259 OID 16818)
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 324
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- TOC entry 325 (class 1259 OID 16836)
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 325
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- TOC entry 314 (class 1259 OID 16537)
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 314
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- TOC entry 382 (class 1259 OID 25530)
-- Name: scim_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.scim_tokens (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    token_hash text NOT NULL,
    prefix text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    revoked_at timestamp with time zone,
    last_used_at timestamp with time zone,
    CONSTRAINT scim_tokens_expires_at_future CHECK (((expires_at IS NULL) OR (expires_at > created_at))),
    CONSTRAINT scim_tokens_revoked_after_created CHECK (((revoked_at IS NULL) OR (revoked_at >= created_at))),
    CONSTRAINT scim_tokens_token_hash_check CHECK ((token_hash ~ '^[0-9a-f]{64}$'::text))
);


--
-- TOC entry 381 (class 1259 OID 25499)
-- Name: scim_users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.scim_users (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    user_id uuid,
    resource jsonb NOT NULL,
    user_name text GENERATED ALWAYS AS (lower((resource ->> 'userName'::text))) STORED NOT NULL,
    external_id text GENERATED ALWAYS AS ((resource ->> 'externalId'::text)) STORED,
    active boolean GENERATED ALWAYS AS (COALESCE(((resource ->> 'active'::text))::boolean, true)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- TOC entry 318 (class 1259 OID 16717)
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 318
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- TOC entry 323 (class 1259 OID 16803)
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 323
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- TOC entry 322 (class 1259 OID 16794)
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 322
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 322
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- TOC entry 309 (class 1259 OID 16499)
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- TOC entry 334 (class 1259 OID 17149)
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


--
-- TOC entry 333 (class 1259 OID 17126)
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


--
-- TOC entry 370 (class 1259 OID 18181)
-- Name: adaptive_session_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adaptive_session_questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid NOT NULL,
    question_id uuid NOT NULL,
    question_order integer NOT NULL,
    difficulty public.question_difficulty NOT NULL,
    selected_answer integer,
    is_correct boolean,
    response_time_seconds integer,
    ability_before numeric(5,2) NOT NULL,
    ability_after numeric(5,2),
    question_snapshot jsonb DEFAULT '{}'::jsonb NOT NULL,
    answered_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT adaptive_session_questions_ability_after_check CHECK (((ability_after >= (0)::numeric) AND (ability_after <= (100)::numeric))),
    CONSTRAINT adaptive_session_questions_ability_before_check CHECK (((ability_before >= (0)::numeric) AND (ability_before <= (100)::numeric))),
    CONSTRAINT adaptive_session_questions_question_order_check CHECK ((question_order > 0)),
    CONSTRAINT adaptive_session_questions_question_snapshot_check CHECK ((jsonb_typeof(question_snapshot) = 'object'::text)),
    CONSTRAINT adaptive_session_questions_response_time_seconds_check CHECK ((response_time_seconds >= 0)),
    CONSTRAINT adaptive_session_questions_selected_answer_check CHECK (((selected_answer >= 0) AND (selected_answer <= 3)))
);


--
-- TOC entry 369 (class 1259 OID 18150)
-- Name: adaptive_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adaptive_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    topic_id uuid NOT NULL,
    target_questions integer NOT NULL,
    status text DEFAULT 'in_progress'::text NOT NULL,
    ability_before numeric(5,2) NOT NULL,
    ability_after numeric(5,2),
    attempted integer DEFAULT 0 NOT NULL,
    correct integer DEFAULT 0 NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    CONSTRAINT adaptive_sessions_ability_after_check CHECK (((ability_after >= (0)::numeric) AND (ability_after <= (100)::numeric))),
    CONSTRAINT adaptive_sessions_ability_before_check CHECK (((ability_before >= (0)::numeric) AND (ability_before <= (100)::numeric))),
    CONSTRAINT adaptive_sessions_status_check CHECK ((status = ANY (ARRAY['in_progress'::text, 'completed'::text]))),
    CONSTRAINT adaptive_sessions_target_questions_check CHECK (((target_questions >= 1) AND (target_questions <= 50)))
);


--
-- TOC entry 380 (class 1259 OID 18615)
-- Name: ai_question_drafts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_question_drafts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_by uuid NOT NULL,
    subject_id uuid,
    topic_id uuid,
    question_type text DEFAULT 'multiple_choice'::text NOT NULL,
    question_text text NOT NULL,
    options jsonb NOT NULL,
    correct_answer integer NOT NULL,
    explanation text NOT NULL,
    difficulty public.question_difficulty NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    provider text NOT NULL,
    approved_at timestamp with time zone,
    saved_question_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ai_question_drafts_correct_answer_check CHECK (((correct_answer >= 0) AND (correct_answer <= 3))),
    CONSTRAINT ai_question_drafts_options_check CHECK (((jsonb_typeof(options) = 'array'::text) AND (jsonb_array_length(options) = 4))),
    CONSTRAINT ai_question_drafts_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'approved'::text, 'saved'::text])))
);


--
-- TOC entry 360 (class 1259 OID 17697)
-- Name: badges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.badges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    xp_required integer DEFAULT 0 NOT NULL,
    icon text DEFAULT 'Award'::text NOT NULL,
    image_url text,
    criteria_type text DEFAULT 'total_xp'::text NOT NULL,
    criteria_value numeric(10,2) DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 355 (class 1259 OID 17596)
-- Name: exam_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exam_attempts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    exam_id uuid NOT NULL,
    user_id uuid NOT NULL,
    status public.exam_status DEFAULT 'in_progress'::public.exam_status NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    submitted_at timestamp with time zone,
    score numeric(8,2) DEFAULT 0 NOT NULL,
    percentage numeric(6,2) DEFAULT 0 NOT NULL,
    correct_count integer DEFAULT 0 NOT NULL,
    incorrect_count integer DEFAULT 0 NOT NULL,
    unanswered_count integer DEFAULT 0 NOT NULL,
    attempt_number integer DEFAULT 1 NOT NULL,
    expires_at timestamp with time zone,
    last_saved_at timestamp with time zone,
    total_time_seconds integer DEFAULT 0 NOT NULL,
    average_response_time_seconds numeric(8,2) DEFAULT 0 NOT NULL,
    accuracy numeric(6,2) DEFAULT 0 NOT NULL,
    passed boolean DEFAULT false NOT NULL,
    marks_gained numeric(8,2) DEFAULT 0 NOT NULL,
    negative_marks_obtained numeric(8,2) DEFAULT 0 NOT NULL,
    submission_token uuid,
    xp_earned integer DEFAULT 0 NOT NULL,
    reward_applied_at timestamp with time zone,
    CONSTRAINT exam_attempts_accuracy_check CHECK (((accuracy >= (0)::numeric) AND (accuracy <= (100)::numeric))),
    CONSTRAINT exam_attempts_attempt_number_check CHECK ((attempt_number >= 1)),
    CONSTRAINT exam_attempts_avg_response_check CHECK ((average_response_time_seconds >= (0)::numeric)),
    CONSTRAINT exam_attempts_marks_gained_check CHECK ((marks_gained >= (0)::numeric)),
    CONSTRAINT exam_attempts_negative_marks_check CHECK ((negative_marks_obtained >= (0)::numeric)),
    CONSTRAINT exam_attempts_total_time_check CHECK ((total_time_seconds >= 0)),
    CONSTRAINT exam_attempts_xp_earned_check CHECK ((xp_earned >= 0))
);


--
-- TOC entry 362 (class 1259 OID 17790)
-- Name: exam_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exam_questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    exam_id uuid NOT NULL,
    question_id uuid NOT NULL,
    display_order integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 353 (class 1259 OID 17545)
-- Name: exams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exams (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    subject_id uuid,
    duration_minutes integer DEFAULT 30 NOT NULL,
    total_marks numeric(8,2) DEFAULT 0 NOT NULL,
    is_published boolean DEFAULT false NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    passing_marks numeric(8,2) DEFAULT 0 NOT NULL,
    negative_marking boolean DEFAULT false NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    status public.exam_publication_status DEFAULT 'draft'::public.exam_publication_status NOT NULL,
    shuffle_questions boolean DEFAULT false NOT NULL,
    shuffle_options boolean DEFAULT false NOT NULL,
    allow_review boolean DEFAULT true NOT NULL,
    proctoring_enabled boolean DEFAULT false NOT NULL,
    fullscreen_required boolean DEFAULT false NOT NULL,
    max_tab_switches integer DEFAULT 3 NOT NULL,
    attempt_limit integer DEFAULT 1 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    instructions text,
    is_active boolean DEFAULT true NOT NULL,
    webcam_required boolean DEFAULT false NOT NULL,
    camera_denied_action text DEFAULT 'warn'::text NOT NULL,
    seed_key text,
    CONSTRAINT exams_attempt_limit_check CHECK ((attempt_limit >= 1)),
    CONSTRAINT exams_camera_denied_action_check CHECK ((camera_denied_action = ANY (ARRAY['warn'::text, 'block'::text]))),
    CONSTRAINT exams_date_window_check CHECK (((end_date IS NULL) OR (start_date IS NULL) OR (end_date >= start_date))),
    CONSTRAINT exams_duration_minutes_check CHECK ((duration_minutes > 0)),
    CONSTRAINT exams_max_tab_switches_check CHECK ((max_tab_switches >= 0)),
    CONSTRAINT exams_passing_marks_check CHECK ((passing_marks >= (0)::numeric)),
    CONSTRAINT exams_total_marks_check CHECK ((total_marks >= (0)::numeric))
);


--
-- TOC entry 373 (class 1259 OID 18274)
-- Name: leaderboard_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leaderboard_snapshots (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    scope text NOT NULL,
    period_key text NOT NULL,
    rank integer NOT NULL,
    metric_value numeric(12,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT leaderboard_snapshots_rank_check CHECK ((rank > 0))
);


--
-- TOC entry 371 (class 1259 OID 18226)
-- Name: levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.levels (
    level_number integer NOT NULL,
    name text NOT NULL,
    xp_required integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT levels_level_number_check CHECK ((level_number > 0)),
    CONSTRAINT levels_xp_required_check CHECK ((xp_required >= 0))
);


--
-- TOC entry 377 (class 1259 OID 18493)
-- Name: multiplayer_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.multiplayer_answers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    room_id uuid NOT NULL,
    participant_id uuid NOT NULL,
    room_question_id uuid NOT NULL,
    selected_answer integer NOT NULL,
    answered_at timestamp with time zone DEFAULT now() NOT NULL,
    response_time_ms integer NOT NULL,
    is_correct boolean NOT NULL,
    score_earned integer NOT NULL,
    CONSTRAINT multiplayer_answers_response_time_ms_check CHECK ((response_time_ms >= 0)),
    CONSTRAINT multiplayer_answers_score_earned_check CHECK ((score_earned >= 0)),
    CONSTRAINT multiplayer_answers_selected_answer_check CHECK (((selected_answer >= 0) AND (selected_answer <= 3)))
);


--
-- TOC entry 375 (class 1259 OID 18447)
-- Name: multiplayer_participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.multiplayer_participants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    room_id uuid NOT NULL,
    user_id uuid NOT NULL,
    is_ready boolean DEFAULT false NOT NULL,
    score integer DEFAULT 0 NOT NULL,
    correct_count integer DEFAULT 0 NOT NULL,
    joined_at timestamp with time zone DEFAULT now() NOT NULL,
    last_seen_at timestamp with time zone DEFAULT now() NOT NULL,
    left_at timestamp with time zone,
    CONSTRAINT multiplayer_participants_correct_count_check CHECK ((correct_count >= 0)),
    CONSTRAINT multiplayer_participants_score_check CHECK ((score >= 0))
);


--
-- TOC entry 378 (class 1259 OID 18520)
-- Name: multiplayer_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.multiplayer_results (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    room_id uuid NOT NULL,
    participant_id uuid NOT NULL,
    user_id uuid NOT NULL,
    rank integer NOT NULL,
    score integer NOT NULL,
    correct_count integer NOT NULL,
    question_count integer NOT NULL,
    accuracy numeric(6,2) NOT NULL,
    average_response_ms integer DEFAULT 0 NOT NULL,
    xp_awarded integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT multiplayer_results_rank_check CHECK ((rank > 0))
);


--
-- TOC entry 376 (class 1259 OID 18472)
-- Name: multiplayer_room_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.multiplayer_room_questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    room_id uuid NOT NULL,
    question_id uuid NOT NULL,
    "position" integer NOT NULL,
    CONSTRAINT multiplayer_room_questions_position_check CHECK (("position" >= 0))
);


--
-- TOC entry 374 (class 1259 OID 18405)
-- Name: multiplayer_rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.multiplayer_rooms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    room_code text NOT NULL,
    name text NOT NULL,
    host_id uuid NOT NULL,
    subject_id uuid,
    topic_id uuid,
    exam_id uuid,
    difficulty public.question_difficulty,
    question_count integer NOT NULL,
    question_time_seconds integer NOT NULL,
    max_players integer NOT NULL,
    is_public boolean DEFAULT false NOT NULL,
    status public.multiplayer_room_status DEFAULT 'open'::public.multiplayer_room_status NOT NULL,
    phase public.multiplayer_phase DEFAULT 'lobby'::public.multiplayer_phase NOT NULL,
    current_question_index integer DEFAULT '-1'::integer NOT NULL,
    starts_at timestamp with time zone,
    question_started_at timestamp with time zone,
    question_ends_at timestamp with time zone,
    reveal_ends_at timestamp with time zone,
    started_at timestamp with time zone,
    finished_at timestamp with time zone,
    closed_at timestamp with time zone,
    expires_at timestamp with time zone DEFAULT (now() + '02:00:00'::interval) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT multiplayer_rooms_max_players_check CHECK (((max_players >= 2) AND (max_players <= 50))),
    CONSTRAINT multiplayer_rooms_name_check CHECK (((length(name) >= 2) AND (length(name) <= 80))),
    CONSTRAINT multiplayer_rooms_question_count_check CHECK (((question_count >= 1) AND (question_count <= 50))),
    CONSTRAINT multiplayer_rooms_question_time_seconds_check CHECK (((question_time_seconds >= 10) AND (question_time_seconds <= 180))),
    CONSTRAINT multiplayer_rooms_room_code_check CHECK ((room_code ~ '^[A-Z0-9]{6}$'::text))
);


--
-- TOC entry 363 (class 1259 OID 17811)
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    type text DEFAULT 'info'::text NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    link_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    link text,
    event_key text
);


--
-- TOC entry 357 (class 1259 OID 17642)
-- Name: performance_metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.performance_metrics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    topic_id uuid NOT NULL,
    attempted integer DEFAULT 0 NOT NULL,
    correct integer DEFAULT 0 NOT NULL,
    accuracy numeric(6,2) DEFAULT 0 NOT NULL,
    total_time_seconds integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 365 (class 1259 OID 18060)
-- Name: performance_predictions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.performance_predictions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    predicted_score numeric(5,2) NOT NULL,
    confidence numeric(5,4) NOT NULL,
    trend text NOT NULL,
    risk_level text NOT NULL,
    feature_snapshot jsonb DEFAULT '{}'::jsonb NOT NULL,
    actual_score numeric(5,2),
    prediction_error numeric(6,2),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT performance_predictions_actual_score_check CHECK (((actual_score >= (0)::numeric) AND (actual_score <= (100)::numeric))),
    CONSTRAINT performance_predictions_confidence_check CHECK (((confidence >= (0)::numeric) AND (confidence <= (1)::numeric))),
    CONSTRAINT performance_predictions_predicted_score_check CHECK (((predicted_score >= (0)::numeric) AND (predicted_score <= (100)::numeric))),
    CONSTRAINT performance_predictions_risk_level_check CHECK ((risk_level = ANY (ARRAY['Low'::text, 'Moderate'::text, 'High'::text]))),
    CONSTRAINT performance_predictions_trend_check CHECK ((trend = ANY (ARRAY['improving'::text, 'stable'::text, 'declining'::text])))
);


--
-- TOC entry 359 (class 1259 OID 17678)
-- Name: proctoring_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.proctoring_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    attempt_id uuid NOT NULL,
    user_id uuid NOT NULL,
    event_type text NOT NULL,
    detail text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    severity text DEFAULT 'low'::text NOT NULL,
    details jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT proctoring_events_severity_check CHECK ((severity = ANY (ARRAY['info'::text, 'low'::text, 'medium'::text, 'high'::text, 'critical'::text])))
);


--
-- TOC entry 379 (class 1259 OID 18582)
-- Name: proctoring_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.proctoring_reports (
    attempt_id uuid NOT NULL,
    user_id uuid NOT NULL,
    exam_id uuid NOT NULL,
    risk_score integer DEFAULT 0 NOT NULL,
    risk_level text DEFAULT 'Low'::text NOT NULL,
    event_counts jsonb DEFAULT '{}'::jsonb NOT NULL,
    calculation jsonb DEFAULT '{}'::jsonb NOT NULL,
    calculated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT proctoring_reports_risk_level_check CHECK ((risk_level = ANY (ARRAY['Low'::text, 'Moderate'::text, 'Suspicious'::text, 'High Risk'::text]))),
    CONSTRAINT proctoring_reports_risk_score_check CHECK (((risk_score >= 0) AND (risk_score <= 100)))
);


--
-- TOC entry 350 (class 1259 OID 17503)
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    full_name text DEFAULT 'Student'::text NOT NULL,
    college text,
    role public.user_role DEFAULT 'student'::public.user_role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    email text,
    institution text,
    avatar_url text,
    last_login timestamp with time zone,
    account_status public.account_status DEFAULT 'active'::public.account_status NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 354 (class 1259 OID 17569)
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    exam_id uuid,
    topic_id uuid,
    question_text text NOT NULL,
    options jsonb NOT NULL,
    correct_answer integer NOT NULL,
    difficulty public.question_difficulty DEFAULT 'medium'::public.question_difficulty NOT NULL,
    marks numeric(8,2) DEFAULT 1 NOT NULL,
    negative_marks numeric(8,2) DEFAULT 0 NOT NULL,
    display_order integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    subject_id uuid,
    question_image_url text,
    option_images jsonb,
    explanation text,
    created_by uuid,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    seed_key text,
    CONSTRAINT questions_correct_answer_check CHECK (((correct_answer >= 0) AND (correct_answer <= 3))),
    CONSTRAINT questions_marks_check CHECK ((marks > (0)::numeric)),
    CONSTRAINT questions_negative_marks_check CHECK ((negative_marks >= (0)::numeric)),
    CONSTRAINT questions_option_images_check CHECK (((option_images IS NULL) OR ((jsonb_typeof(option_images) = 'array'::text) AND (jsonb_array_length(option_images) = 4)))),
    CONSTRAINT questions_options_check CHECK (((jsonb_typeof(options) = 'array'::text) AND (jsonb_array_length(options) = 4)))
);


--
-- TOC entry 366 (class 1259 OID 18080)
-- Name: recommendations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recommendations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    topic_id uuid,
    priority text NOT NULL,
    accuracy numeric(5,2) DEFAULT 0 NOT NULL,
    reason text NOT NULL,
    recommendation text NOT NULL,
    suggested_questions integer DEFAULT 10 NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    performance_version timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT recommendations_priority_check CHECK ((priority = ANY (ARRAY['high'::text, 'medium'::text, 'low'::text]))),
    CONSTRAINT recommendations_status_check CHECK ((status = ANY (ARRAY['active'::text, 'completed'::text, 'dismissed'::text]))),
    CONSTRAINT recommendations_suggested_questions_check CHECK ((suggested_questions > 0))
);


--
-- TOC entry 368 (class 1259 OID 18126)
-- Name: revision_plan_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revision_plan_tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    plan_id uuid NOT NULL,
    topic_id uuid,
    scheduled_date date NOT NULL,
    day_number integer NOT NULL,
    activity text NOT NULL,
    target_questions integer DEFAULT 15 NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    completed_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT revision_plan_tasks_day_number_check CHECK ((day_number > 0)),
    CONSTRAINT revision_plan_tasks_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'completed'::text, 'skipped'::text]))),
    CONSTRAINT revision_plan_tasks_target_questions_check CHECK ((target_questions > 0))
);


--
-- TOC entry 367 (class 1259 OID 18107)
-- Name: revision_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revision_plans (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    duration_days integer NOT NULL,
    starts_on date DEFAULT CURRENT_DATE NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT revision_plans_duration_days_check CHECK ((duration_days = ANY (ARRAY[7, 14, 30]))),
    CONSTRAINT revision_plans_status_check CHECK ((status = ANY (ARRAY['active'::text, 'completed'::text, 'archived'::text])))
);


--
-- TOC entry 356 (class 1259 OID 17619)
-- Name: student_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_answers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    attempt_id uuid NOT NULL,
    question_id uuid NOT NULL,
    selected_answer integer,
    is_correct boolean DEFAULT false NOT NULL,
    marks_awarded numeric(8,2) DEFAULT 0 NOT NULL,
    time_taken_seconds integer DEFAULT 0 NOT NULL,
    marked_for_review boolean DEFAULT false NOT NULL,
    visited boolean DEFAULT false NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    display_order integer,
    option_order jsonb,
    question_snapshot jsonb,
    CONSTRAINT student_answers_option_order_check CHECK (((option_order IS NULL) OR ((jsonb_typeof(option_order) = 'array'::text) AND (jsonb_array_length(option_order) = 4)))),
    CONSTRAINT student_answers_question_snapshot_check CHECK (((question_snapshot IS NULL) OR (jsonb_typeof(question_snapshot) = 'object'::text))),
    CONSTRAINT student_answers_selected_answer_check CHECK (((selected_answer >= 0) AND (selected_answer <= 3))),
    CONSTRAINT student_answers_time_taken_seconds_check CHECK ((time_taken_seconds >= 0))
);


--
-- TOC entry 361 (class 1259 OID 17708)
-- Name: student_badges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_badges (
    user_id uuid NOT NULL,
    badge_id uuid NOT NULL,
    earned_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 358 (class 1259 OID 17665)
-- Name: student_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_stats (
    user_id uuid NOT NULL,
    total_xp integer DEFAULT 0 NOT NULL,
    quizzes_completed integer DEFAULT 0 NOT NULL,
    streak_days integer DEFAULT 0 NOT NULL,
    last_quiz_date timestamp with time zone,
    current_level integer DEFAULT 1 NOT NULL,
    longest_streak integer DEFAULT 0 NOT NULL,
    last_activity_date date,
    questions_solved integer DEFAULT 0 NOT NULL,
    correct_answers integer DEFAULT 0 NOT NULL,
    total_response_seconds bigint DEFAULT 0 NOT NULL,
    perfect_scores integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 364 (class 1259 OID 18030)
-- Name: student_topic_ability; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_topic_ability (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    topic_id uuid NOT NULL,
    ability_score numeric(5,2) DEFAULT 50 NOT NULL,
    status text DEFAULT 'Moderate'::text NOT NULL,
    attempted integer DEFAULT 0 NOT NULL,
    accuracy numeric(5,2) DEFAULT 0 NOT NULL,
    recent_trend numeric(7,2) DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT student_topic_ability_ability_score_check CHECK (((ability_score >= (0)::numeric) AND (ability_score <= (100)::numeric))),
    CONSTRAINT student_topic_ability_accuracy_check CHECK (((accuracy >= (0)::numeric) AND (accuracy <= (100)::numeric))),
    CONSTRAINT student_topic_ability_attempted_check CHECK ((attempted >= 0)),
    CONSTRAINT student_topic_ability_status_check CHECK ((status = ANY (ARRAY['Strong'::text, 'Moderate'::text, 'Weak'::text, 'Critical'::text])))
);


--
-- TOC entry 351 (class 1259 OID 17518)
-- Name: subjects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subjects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 352 (class 1259 OID 17529)
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.topics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subject_id uuid NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 372 (class 1259 OID 18238)
-- Name: xp_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.xp_transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    amount integer NOT NULL,
    reason text NOT NULL,
    source_type text NOT NULL,
    source_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT xp_transactions_amount_check CHECK ((amount <> 0))
);


--
-- TOC entry 338 (class 1259 OID 17243)
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- TOC entry 385 (class 1259 OID 25619)
-- Name: messages_2026_10_12; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_10_12 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


--
-- TOC entry 386 (class 1259 OID 25633)
-- Name: messages_2026_10_13; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_10_13 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


--
-- TOC entry 387 (class 1259 OID 25647)
-- Name: messages_2026_10_14; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_10_14 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


--
-- TOC entry 388 (class 1259 OID 25661)
-- Name: messages_2026_10_15; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_10_15 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


--
-- TOC entry 389 (class 1259 OID 25675)
-- Name: messages_2026_10_16; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_10_16 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


--
-- TOC entry 339 (class 1259 OID 17250)
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone DEFAULT now()
);


--
-- TOC entry 340 (class 1259 OID 17253)
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    selected_columns text[],
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


--
-- TOC entry 341 (class 1259 OID 17263)
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 343 (class 1259 OID 17294)
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL,
    versioning_status text DEFAULT 'DISABLED'::text NOT NULL,
    lifecycle_configuration jsonb,
    lifecycle_configuration_generation uuid,
    CONSTRAINT buckets_lifecycle_configuration_pair_check CHECK (((lifecycle_configuration IS NULL) = (lifecycle_configuration_generation IS NULL))),
    CONSTRAINT buckets_lifecycle_configuration_shape_check CHECK (((lifecycle_configuration IS NULL) OR ((jsonb_typeof(lifecycle_configuration) = 'object'::text) AND (lifecycle_configuration ? 'rules'::text) AND
CASE
    WHEN (jsonb_typeof((lifecycle_configuration -> 'rules'::text)) = 'array'::text) THEN ((jsonb_array_length((lifecycle_configuration -> 'rules'::text)) >= 1) AND (jsonb_array_length((lifecycle_configuration -> 'rules'::text)) <= 1000))
    ELSE false
END))),
    CONSTRAINT buckets_lifecycle_configuration_standard_only_check CHECK (((type = 'STANDARD'::storage.buckettype) OR ((lifecycle_configuration IS NULL) AND (lifecycle_configuration_generation IS NULL)))),
    CONSTRAINT buckets_versioning_dark_check CHECK ((versioning_status = 'DISABLED'::text)),
    CONSTRAINT buckets_versioning_standard_only_check CHECK (((type = 'STANDARD'::storage.buckettype) OR (versioning_status = 'DISABLED'::text))),
    CONSTRAINT buckets_versioning_status_check CHECK ((versioning_status = ANY (ARRAY['DISABLED'::text, 'ENABLED'::text, 'SUSPENDED'::text])))
);


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 343
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 347 (class 1259 OID 17414)
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- TOC entry 348 (class 1259 OID 17427)
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 342 (class 1259 OID 17286)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 344 (class 1259 OID 17304)
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    archived_at timestamp with time zone,
    is_delete_marker boolean DEFAULT false NOT NULL,
    is_versioned boolean DEFAULT false NOT NULL
);


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 344
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 345 (class 1259 OID 17353)
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


--
-- TOC entry 346 (class 1259 OID 17367)
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 349 (class 1259 OID 17437)
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 3870 (class 0 OID 0)
-- Name: messages_2026_10_12; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_10_12 FOR VALUES FROM ('2026-10-12 00:00:00') TO ('2026-10-13 00:00:00');


--
-- TOC entry 3871 (class 0 OID 0)
-- Name: messages_2026_10_13; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_10_13 FOR VALUES FROM ('2026-10-13 00:00:00') TO ('2026-10-14 00:00:00');


--
-- TOC entry 3872 (class 0 OID 0)
-- Name: messages_2026_10_14; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_10_14 FOR VALUES FROM ('2026-10-14 00:00:00') TO ('2026-10-15 00:00:00');


--
-- TOC entry 3873 (class 0 OID 0)
-- Name: messages_2026_10_15; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_10_15 FOR VALUES FROM ('2026-10-15 00:00:00') TO ('2026-10-16 00:00:00');


--
-- TOC entry 3874 (class 0 OID 0)
-- Name: messages_2026_10_16; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_10_16 FOR VALUES FROM ('2026-10-16 00:00:00') TO ('2026-10-17 00:00:00');


--
-- TOC entry 3884 (class 2604 OID 16514)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 5031 (class 0 OID 16529)
-- Dependencies: 313
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- TOC entry 5048 (class 0 OID 17084)
-- Dependencies: 332
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at, custom_claims_allowlist) FROM stdin;
\.


--
-- TOC entry 5042 (class 0 OID 16889)
-- Dependencies: 326
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- TOC entry 5033 (class 0 OID 16687)
-- Dependencies: 317
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
d5ae212b-9a24-404c-a312-804a6572933e	d5ae212b-9a24-404c-a312-804a6572933e	{"sub": "d5ae212b-9a24-404c-a312-804a6572933e", "email": "chandan@gmail.com", "college": "College", "full_name": "Chandan", "institution": "College", "email_verified": false, "phone_verified": false}	email	2026-08-18 08:04:05.167856+00	2026-08-18 08:04:05.167897+00	2026-08-18 08:04:05.167897+00	ada3f3e7-eb49-4857-8808-68446a1908de
15068f40-e70b-44b1-82eb-28b9f885db37	15068f40-e70b-44b1-82eb-28b9f885db37	{"sub": "15068f40-e70b-44b1-82eb-28b9f885db37", "email": "chandangirish10@gmail.com", "college": "College", "full_name": "Chandan", "institution": "College", "email_verified": true, "phone_verified": false}	email	2026-08-18 08:04:20.72589+00	2026-08-18 08:04:20.726+00	2026-08-18 08:04:20.726+00	465098d6-5160-41b3-bb47-377aa1bb61ce
f19320d2-8560-46e4-9093-a1f9b2d35647	f19320d2-8560-46e4-9093-a1f9b2d35647	{"sub": "f19320d2-8560-46e4-9093-a1f9b2d35647", "email": "chandangitish10@gmail.com", "college": "AIT", "full_name": "Chandan", "institution": "AIT", "email_verified": false, "phone_verified": false}	email	2026-08-25 05:23:17.475222+00	2026-08-25 05:23:17.475271+00	2026-08-25 05:23:17.475271+00	02eaea7c-fd0c-4c48-a9e4-a04c34329462
97ad6c7c-6f13-4266-8241-a72deab8f86a	97ad6c7c-6f13-4266-8241-a72deab8f86a	{"sub": "97ad6c7c-6f13-4266-8241-a72deab8f86a", "email": "chandangirish95@gmail.com", "college": "JC", "full_name": "Chandan", "institution": "JC", "email_verified": true, "phone_verified": false}	email	2026-08-25 05:27:25.077965+00	2026-08-25 05:27:25.078005+00	2026-08-25 05:27:25.078005+00	d98c2922-f9f8-42ec-aa7d-3422839ed962
ce0fb583-4c15-43a5-b8af-e2b941589f86	ce0fb583-4c15-43a5-b8af-e2b941589f86	{"sub": "ce0fb583-4c15-43a5-b8af-e2b941589f86", "email": "hamsargowda702685@gmail.com", "college": "GSSS", "full_name": "Hamsa", "institution": "GSSS", "email_verified": true, "phone_verified": false}	email	2026-09-03 03:26:52.91062+00	2026-09-03 03:26:52.91066+00	2026-09-03 03:26:52.91066+00	7b620797-4b49-4d68-bf63-941be67433ea
456f5f52-36f2-4347-b9f7-f435927c9779	456f5f52-36f2-4347-b9f7-f435927c9779	{"sub": "456f5f52-36f2-4347-b9f7-f435927c9779", "email": "admin@example.com", "email_verified": false, "phone_verified": false}	email	2026-10-13 06:28:14.378061+00	2026-10-13 06:28:14.37814+00	2026-10-13 06:28:14.37814+00	2b4e9d1e-14f8-45cb-b606-e5e1f2ba2a2b
\.


--
-- TOC entry 5030 (class 0 OID 16522)
-- Dependencies: 312
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5037 (class 0 OID 16776)
-- Dependencies: 321
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
2bb87a97-0e89-43a9-83ad-a037779e6c87	2026-08-18 08:04:32.33751+00	2026-08-18 08:04:32.33751+00	otp	22ba9d2c-0456-4227-9612-0c8151b79141
e556f312-33bf-4f35-b9f9-0f6efd82c981	2026-08-18 08:04:38.175382+00	2026-08-18 08:04:38.175382+00	password	c1ab7b53-4535-4438-8236-8ca0f918cfad
41e412c1-8eeb-47fb-a3cb-d47627287ca8	2026-09-02 06:57:41.344974+00	2026-09-02 06:57:41.344974+00	password	430dedb9-a60a-432b-bb60-9c4192c01bda
\.


--
-- TOC entry 5036 (class 0 OID 16764)
-- Dependencies: 320
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- TOC entry 5035 (class 0 OID 16751)
-- Dependencies: 319
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- TOC entry 5095 (class 0 OID 25551)
-- Dependencies: 383
-- Data for Name: mfa_recovery_code_sets; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_recovery_code_sets (id, user_id, mfa_factor_id, failed_verification_count, verification_locked_until, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5096 (class 0 OID 25574)
-- Dependencies: 384
-- Data for Name: mfa_recovery_codes; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_recovery_codes (id, mfa_recovery_code_set_id, code_hash, consumed_at, created_at) FROM stdin;
\.


--
-- TOC entry 5045 (class 0 OID 17001)
-- Dependencies: 329
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- TOC entry 5047 (class 0 OID 17074)
-- Dependencies: 331
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- TOC entry 5044 (class 0 OID 16971)
-- Dependencies: 328
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- TOC entry 5046 (class 0 OID 17034)
-- Dependencies: 330
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- TOC entry 5043 (class 0 OID 16939)
-- Dependencies: 327
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at, expires_at) FROM stdin;
4647a993-82fd-41ca-af79-f81a18bc3e2e	d5ae212b-9a24-404c-a312-804a6572933e	confirmation_token	434597fabde164720538e0a56ccdfbddfdef8fe853ed5caad97f41cb	chandan@gmail.com	2026-08-18 08:04:08.008116	2026-08-18 08:04:08.008116	\N
27fc5f02-8b2f-449a-b6e3-9483be3a2952	f19320d2-8560-46e4-9093-a1f9b2d35647	confirmation_token	5e2a012bc10722e36d3b4b8995254e74edbf9f3abecabe172396c040	chandangitish10@gmail.com	2026-08-25 05:23:20.243753	2026-08-25 05:23:20.243753	\N
\.


--
-- TOC entry 5029 (class 0 OID 16511)
-- Dependencies: 311
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	3	ing6mksy5ozk	15068f40-e70b-44b1-82eb-28b9f885db37	f	2026-08-18 08:04:32.33606+00	2026-08-18 08:04:32.33606+00	\N	2bb87a97-0e89-43a9-83ad-a037779e6c87
00000000-0000-0000-0000-000000000000	4	6zmobjjpliso	15068f40-e70b-44b1-82eb-28b9f885db37	t	2026-08-18 08:04:38.173757+00	2026-08-18 10:28:06.810735+00	\N	e556f312-33bf-4f35-b9f9-0f6efd82c981
00000000-0000-0000-0000-000000000000	44	eog6hhludrkh	97ad6c7c-6f13-4266-8241-a72deab8f86a	t	2026-09-02 06:57:41.320232+00	2026-09-02 10:23:05.593974+00	\N	41e412c1-8eeb-47fb-a3cb-d47627287ca8
00000000-0000-0000-0000-000000000000	48	p3d5jmjsynvm	97ad6c7c-6f13-4266-8241-a72deab8f86a	f	2026-09-02 10:23:05.621677+00	2026-09-02 10:23:05.621677+00	eog6hhludrkh	41e412c1-8eeb-47fb-a3cb-d47627287ca8
00000000-0000-0000-0000-000000000000	5	noiy2rg5f4nw	15068f40-e70b-44b1-82eb-28b9f885db37	t	2026-08-18 10:28:06.826455+00	2026-08-28 10:47:42.667715+00	6zmobjjpliso	e556f312-33bf-4f35-b9f9-0f6efd82c981
00000000-0000-0000-0000-000000000000	31	ngjlqwiasi3g	15068f40-e70b-44b1-82eb-28b9f885db37	f	2026-08-28 10:47:42.681504+00	2026-08-28 10:47:42.681504+00	noiy2rg5f4nw	e556f312-33bf-4f35-b9f9-0f6efd82c981
\.


--
-- TOC entry 5040 (class 0 OID 16818)
-- Dependencies: 324
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- TOC entry 5041 (class 0 OID 16836)
-- Dependencies: 325
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- TOC entry 5032 (class 0 OID 16537)
-- Dependencies: 314
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
20260625000000
20260821000000
20260821010000
20260824000000
20260824000001
20260831180000
\.


--
-- TOC entry 5094 (class 0 OID 25530)
-- Dependencies: 382
-- Data for Name: scim_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.scim_tokens (id, sso_provider_id, token_hash, prefix, created_at, expires_at, revoked_at, last_used_at) FROM stdin;
\.


--
-- TOC entry 5093 (class 0 OID 25499)
-- Dependencies: 381
-- Data for Name: scim_users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.scim_users (id, sso_provider_id, user_id, resource, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 5034 (class 0 OID 16717)
-- Dependencies: 318
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
2bb87a97-0e89-43a9-83ad-a037779e6c87	15068f40-e70b-44b1-82eb-28b9f885db37	2026-08-18 08:04:32.335227+00	2026-08-18 08:04:32.335227+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36	49.238.55.169	\N	\N	\N	\N	\N
e556f312-33bf-4f35-b9f9-0f6efd82c981	15068f40-e70b-44b1-82eb-28b9f885db37	2026-08-18 08:04:38.172226+00	2026-08-28 10:47:42.717209+00	\N	aal1	\N	2026-08-28 10:47:42.717102	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	49.238.55.141	\N	\N	\N	\N	\N
41e412c1-8eeb-47fb-a3cb-d47627287ca8	97ad6c7c-6f13-4266-8241-a72deab8f86a	2026-09-02 06:57:41.310194+00	2026-09-02 10:23:05.706414+00	\N	aal1	\N	2026-09-02 10:23:05.706317	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36	49.238.56.232	\N	\N	\N	\N	\N
\.


--
-- TOC entry 5039 (class 0 OID 16803)
-- Dependencies: 323
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5038 (class 0 OID 16794)
-- Dependencies: 322
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- TOC entry 5027 (class 0 OID 16499)
-- Dependencies: 309
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	ce0fb583-4c15-43a5-b8af-e2b941589f86	authenticated	authenticated	hamsargowda702685@gmail.com	$2a$10$QiR1sfwuQ7JAjhLxTWVC1OQxMSYNvNiNtzjHVvRfrWf3Ms4DoIJNS	2026-09-03 03:27:33.511946+00	\N		2026-09-03 03:26:52.918854+00		\N			\N	2026-09-03 07:12:06.579819+00	{"provider": "email", "providers": ["email"]}	{"sub": "ce0fb583-4c15-43a5-b8af-e2b941589f86", "email": "hamsargowda702685@gmail.com", "college": "GSSS", "full_name": "Hamsa", "institution": "GSSS", "email_verified": true, "phone_verified": false}	\N	2026-09-03 03:26:52.876297+00	2026-09-03 07:12:06.634442+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	d5ae212b-9a24-404c-a312-804a6572933e	authenticated	authenticated	chandan@gmail.com	$2a$10$4zfN5TWKHFxgPwNLeurJT.Y/5o9HraLP5KgCaEW9p.iqBNw03gMHW	\N	\N	434597fabde164720538e0a56ccdfbddfdef8fe853ed5caad97f41cb	2026-08-18 08:04:05.173896+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "d5ae212b-9a24-404c-a312-804a6572933e", "email": "chandan@gmail.com", "college": "College", "full_name": "Chandan", "institution": "College", "email_verified": false, "phone_verified": false}	\N	2026-08-18 08:04:05.159979+00	2026-08-18 08:04:08.002583+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	456f5f52-36f2-4347-b9f7-f435927c9779	authenticated	authenticated	admin@example.com	$2a$10$5gfqG92whEENAzkb0lnFquuVBkcs4fCvtzyWEFk816jULFyF0j5sC	2026-10-13 06:28:14.382629+00	\N		\N		\N			\N	2026-10-13 06:30:25.104566+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-10-13 06:28:14.349551+00	2026-10-13 06:30:25.108176+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	f19320d2-8560-46e4-9093-a1f9b2d35647	authenticated	authenticated	chandangitish10@gmail.com	$2a$10$yrCsMXtIwt09OPHDwYbip.ahde3caH2dZIVUNbLs0RssN7ndrBWWe	\N	\N	5e2a012bc10722e36d3b4b8995254e74edbf9f3abecabe172396c040	2026-08-25 05:23:17.487421+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "f19320d2-8560-46e4-9093-a1f9b2d35647", "email": "chandangitish10@gmail.com", "college": "AIT", "full_name": "Chandan", "institution": "AIT", "email_verified": false, "phone_verified": false}	\N	2026-08-25 05:23:17.421735+00	2026-08-25 05:23:20.234646+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	15068f40-e70b-44b1-82eb-28b9f885db37	authenticated	authenticated	chandangirish10@gmail.com	$2a$10$dF5VEiC5GAduVEoLByzjD.v2WnUn4rerzJq5v4DaAUmU9o1xbXBPq	2026-08-18 08:04:32.330807+00	\N		2026-08-18 08:04:20.728334+00		\N			\N	2026-08-18 08:04:38.172116+00	{"provider": "email", "providers": ["email"]}	{"sub": "15068f40-e70b-44b1-82eb-28b9f885db37", "email": "chandangirish10@gmail.com", "college": "College", "full_name": "Chandan", "institution": "College", "email_verified": true, "phone_verified": false}	\N	2026-08-18 08:04:20.722844+00	2026-08-28 10:47:42.691211+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	97ad6c7c-6f13-4266-8241-a72deab8f86a	authenticated	authenticated	chandangirish95@gmail.com	$2a$10$71CORXL4jLuVsWz7Hice3efnONKmLHiOjcT0nwvrQInbWfj19yg.S	2026-08-25 05:27:58.281692+00	\N		2026-08-25 05:27:25.087054+00		\N			\N	2026-09-02 06:57:41.309463+00	{"provider": "email", "providers": ["email"]}	{"sub": "97ad6c7c-6f13-4266-8241-a72deab8f86a", "email": "chandangirish95@gmail.com", "college": "JC", "full_name": "Chandan", "institution": "JC", "email_verified": true, "phone_verified": false}	\N	2026-08-25 05:27:25.045542+00	2026-09-02 10:23:05.636917+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- TOC entry 5050 (class 0 OID 17149)
-- Dependencies: 334
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- TOC entry 5049 (class 0 OID 17126)
-- Dependencies: 333
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- TOC entry 5082 (class 0 OID 18181)
-- Dependencies: 370
-- Data for Name: adaptive_session_questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.adaptive_session_questions (id, session_id, question_id, question_order, difficulty, selected_answer, is_correct, response_time_seconds, ability_before, ability_after, question_snapshot, answered_at, created_at) FROM stdin;
d5b0428b-4a0e-4180-926b-02b8b8e9b8df	0a854b76-f77f-47df-8836-7b6082bbd226	1dad4c69-7d98-4807-b2a5-9852492eba87	1	medium	\N	\N	\N	50.00	\N	{"id": "1dad4c69-7d98-4807-b2a5-9852492eba87", "marks": 1, "options": ["(x-3)(x+3)", "(x-9)(x+1)", "(x-3)²", "(x+9)(x-1)"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": null, "option_images": null, "question_text": "Which expression factors x² - 9?", "correct_answer": 0, "question_image_url": null}	\N	2026-08-27 05:46:58.123545+00
b7bae605-9517-4655-b118-73874881342c	566ed9ba-5f8c-4f83-a6ea-a74b0299e985	8803d7cd-920d-4675-8057-8dd46a82d0ae	1	medium	\N	\N	\N	50.00	\N	{"id": "8803d7cd-920d-4675-8057-8dd46a82d0ae", "marks": 1, "options": ["2:3", "3:1", "4:3", "3:2"], "topic_id": "ddbc0300-a68e-4091-a663-baa86d6ee8d3", "difficulty": "medium", "explanation": "Simplify 18:12 by dividing by 6", "option_images": null, "question_text": "If a class has 18 boys and 12 girls, what is the ratio of boys to girls?", "correct_answer": 3, "question_image_url": null}	\N	2026-08-28 05:38:13.529287+00
c2ae1e25-d7c4-4434-a745-5b616cbd0380	48ccf295-8848-44e9-b47b-b35f28243097	a8bcb7b3-5494-4873-a6a9-5a9f7a6e4343	1	medium	1	f	3	50.00	39.50	{"id": "a8bcb7b3-5494-4873-a6a9-5a9f7a6e4343", "marks": 1, "options": ["Decomposers", "Carrying capacity", "Greenhouse gases", "Symbiosis"], "topic_id": "b6f7da6a-8454-4074-9713-ec2cfac0827a", "difficulty": "medium", "explanation": "Symbiosis fits because it is a close biological association between different species.", "option_images": null, "question_text": "Which term best matches this description: it is a close biological association between different species?", "correct_answer": 3, "question_image_url": null}	2026-08-28 06:08:41.595+00	2026-08-28 06:07:33.207367+00
cd6d27fc-5eda-4e1f-918d-0eab2ebc14a0	48ccf295-8848-44e9-b47b-b35f28243097	4b20328e-52d3-464e-a78f-dff379d75a7d	2	easy	0	t	3	39.50	52.24	{"id": "4b20328e-52d3-464e-a78f-dff379d75a7d", "marks": 1, "options": ["Ecosystem", "Producers", "Energy loss", "Symbiosis"], "topic_id": "b6f7da6a-8454-4074-9713-ec2cfac0827a", "difficulty": "easy", "explanation": "Ecosystem fits because it includes organisms and their physical environment interacting together.", "option_images": null, "question_text": "Which term best matches this description: it includes organisms and their physical environment interacting together?", "correct_answer": 0, "question_image_url": null}	2026-08-28 06:08:44.49+00	2026-08-28 06:07:36.835757+00
cac1dd0c-1dc0-46fe-99bf-acb0fbab0693	48ccf295-8848-44e9-b47b-b35f28243097	41cab20a-6347-40a4-b328-71d2ad824a8e	3	easy	\N	f	1	52.24	47.83	{"id": "41cab20a-6347-40a4-b328-71d2ad824a8e", "marks": 1, "options": ["Energy loss", "Producers", "Symbiosis", "Decomposers"], "topic_id": "b6f7da6a-8454-4074-9713-ec2cfac0827a", "difficulty": "easy", "explanation": "Producers fits because they make their own food, usually by photosynthesis.", "option_images": null, "question_text": "Which term best matches this description: they make their own food, usually by photosynthesis?", "correct_answer": 1, "question_image_url": null}	2026-08-28 06:08:45.411+00	2026-08-28 06:07:39.731242+00
6c376c52-fa5b-41c8-b614-0efc401702d1	48ccf295-8848-44e9-b47b-b35f28243097	9ef575cb-a502-4eb7-b8f0-a6c4549c6bab	4	easy	\N	f	1	47.83	45.64	{"id": "9ef575cb-a502-4eb7-b8f0-a6c4549c6bab", "marks": 1, "options": ["Symbiosis", "Decomposers", "Energy loss", "Carrying capacity"], "topic_id": "b6f7da6a-8454-4074-9713-ec2cfac0827a", "difficulty": "easy", "explanation": "Energy loss fits because it explains why less energy is available at higher trophic levels.", "option_images": null, "question_text": "Which term best matches this description: it explains why less energy is available at higher trophic levels?", "correct_answer": 2, "question_image_url": null}	2026-08-28 06:08:46.666+00	2026-08-28 06:07:40.655084+00
0a6bdfc2-b901-4417-991a-5af44333cba5	48ccf295-8848-44e9-b47b-b35f28243097	63d7a8ef-8fda-4d95-8cba-6fadb19fa3f1	5	medium	\N	f	0	45.64	44.27	{"id": "63d7a8ef-8fda-4d95-8cba-6fadb19fa3f1", "marks": 1, "options": ["Carrying capacity", "Decomposers", "Greenhouse gases", "Mutualism"], "topic_id": "b6f7da6a-8454-4074-9713-ec2cfac0827a", "difficulty": "medium", "explanation": "Decomposers fits because they recycle nutrients by breaking down dead organic matter.", "option_images": null, "question_text": "Which term best matches this description: they recycle nutrients by breaking down dead organic matter?", "correct_answer": 1, "question_image_url": null}	2026-08-28 06:08:47.013+00	2026-08-28 06:07:41.917589+00
a1b6f560-c02d-46bd-b63b-79f99e0fd37a	48ccf295-8848-44e9-b47b-b35f28243097	4c792ba0-f9d2-4b44-97ec-fcce8b335d8b	6	medium	0	f	3	44.27	43.56	{"id": "4c792ba0-f9d2-4b44-97ec-fcce8b335d8b", "marks": 1, "options": ["Greenhouse gases", "Mutualism", "Carrying capacity", "Biomagnification"], "topic_id": "b6f7da6a-8454-4074-9713-ec2cfac0827a", "difficulty": "medium", "explanation": "Carrying capacity fits because it is the maximum population size an environment can support.", "option_images": null, "question_text": "Which term best matches this description: it is the maximum population size an environment can support?", "correct_answer": 2, "question_image_url": null}	2026-08-28 06:08:50.219+00	2026-08-28 06:07:42.326136+00
b6fcdb29-dee4-4519-bdca-0b35518b86c8	48ccf295-8848-44e9-b47b-b35f28243097	fb185f4b-537e-47c7-8bef-80974ee70a84	7	medium	2	f	2	43.56	42.01	{"id": "fb185f4b-537e-47c7-8bef-80974ee70a84", "marks": 1, "options": ["Mutualism", "Biomagnification", "Nitrogen fixation", "Greenhouse gases"], "topic_id": "b6f7da6a-8454-4074-9713-ec2cfac0827a", "difficulty": "medium", "explanation": "Greenhouse gases fits because they contribute to global warming by trapping heat.", "option_images": null, "question_text": "Which term best matches this description: they contribute to global warming by trapping heat?", "correct_answer": 3, "question_image_url": null}	2026-08-28 06:08:52.07+00	2026-08-28 06:07:45.460377+00
0bfc7bc1-2384-4b59-bd3a-b86338c1ad77	48ccf295-8848-44e9-b47b-b35f28243097	16aabbdc-8900-471c-b75c-5caef90490d1	8	hard	1	f	1	42.01	41.62	{"id": "16aabbdc-8900-471c-b75c-5caef90490d1", "marks": 1, "options": ["Mutualism", "Biomagnification", "Nitrogen fixation", "Ecosystem"], "topic_id": "b6f7da6a-8454-4074-9713-ec2cfac0827a", "difficulty": "hard", "explanation": "Mutualism fits because it is the interaction shown by lichens in standard textbook examples.", "option_images": null, "question_text": "Which term best matches this description: it is the interaction shown by lichens in standard textbook examples?", "correct_answer": 0, "question_image_url": null}	2026-08-28 06:08:53.613+00	2026-08-28 06:07:47.328052+00
48540b2a-ef65-4c4f-b2a4-3036820b135f	48ccf295-8848-44e9-b47b-b35f28243097	8e4b0293-ed8e-49e6-b36e-d82470a7cef5	9	hard	\N	f	0	41.62	41.33	{"id": "8e4b0293-ed8e-49e6-b36e-d82470a7cef5", "marks": 1, "options": ["Nitrogen fixation", "Ecosystem", "Biomagnification", "Producers"], "topic_id": "b6f7da6a-8454-4074-9713-ec2cfac0827a", "difficulty": "hard", "explanation": "Biomagnification fits because it is the increase in toxin concentration at higher trophic levels.", "option_images": null, "question_text": "Which term best matches this description: it is the increase in toxin concentration at higher trophic levels?", "correct_answer": 2, "question_image_url": null}	2026-08-28 06:08:54.12+00	2026-08-28 06:07:48.856194+00
efc98440-650f-4234-9fe2-e98e4fe526e2	48ccf295-8848-44e9-b47b-b35f28243097	4c2cd1f1-59c9-4096-ac7f-625c6a990d95	10	hard	2	f	1	41.33	41.10	{"id": "4c2cd1f1-59c9-4096-ac7f-625c6a990d95", "marks": 1, "options": ["Ecosystem", "Nitrogen fixation", "Producers", "Energy loss"], "topic_id": "b6f7da6a-8454-4074-9713-ec2cfac0827a", "difficulty": "hard", "explanation": "Nitrogen fixation fits because it converts atmospheric nitrogen into forms usable by living organisms.", "option_images": null, "question_text": "Which term best matches this description: it converts atmospheric nitrogen into forms usable by living organisms?", "correct_answer": 1, "question_image_url": null}	2026-08-28 06:08:55.35+00	2026-08-28 06:07:49.371013+00
9c3f0c17-c957-4e80-a08f-81ef7c0c82b7	bd48ddc0-adc1-447d-ab79-37b396e9e3ff	8803d7cd-920d-4675-8057-8dd46a82d0ae	1	medium	\N	\N	\N	50.00	\N	{"id": "8803d7cd-920d-4675-8057-8dd46a82d0ae", "marks": 1, "options": ["2:3", "3:1", "4:3", "3:2"], "topic_id": "ddbc0300-a68e-4091-a663-baa86d6ee8d3", "difficulty": "medium", "explanation": "Simplify 18:12 by dividing by 6", "option_images": null, "question_text": "If a class has 18 boys and 12 girls, what is the ratio of boys to girls?", "correct_answer": 3, "question_image_url": null}	\N	2026-08-28 08:11:46.841547+00
9151425f-7a88-4535-a409-40f433ffce79	9d9efff2-162c-4e22-8d4e-8d7ed99a9741	8803d7cd-920d-4675-8057-8dd46a82d0ae	1	medium	\N	\N	\N	50.00	\N	{"id": "8803d7cd-920d-4675-8057-8dd46a82d0ae", "marks": 1, "options": ["2:3", "3:1", "4:3", "3:2"], "topic_id": "ddbc0300-a68e-4091-a663-baa86d6ee8d3", "difficulty": "medium", "explanation": "Simplify 18:12 by dividing by 6", "option_images": null, "question_text": "If a class has 18 boys and 12 girls, what is the ratio of boys to girls?", "correct_answer": 3, "question_image_url": null}	\N	2026-08-28 10:49:28.739409+00
5148bf49-067d-4225-96ab-76d6f69573b9	1932e223-2eb1-4dfe-a48f-413303132277	00ff9661-e0cd-4468-90f4-6b45a5383ab8	1	medium	\N	\N	\N	50.00	\N	{"id": "00ff9661-e0cd-4468-90f4-6b45a5383ab8", "marks": 1, "options": ["West", "South", "North", "East"], "topic_id": "0045e312-20fa-4ddf-ae9b-3f545fd19050", "difficulty": "medium", "explanation": "A right turn from north points east", "option_images": null, "question_text": "A person facing north turns right. Which direction does the person face now?", "correct_answer": 3, "question_image_url": null}	\N	2026-09-02 06:27:48.469289+00
\.


--
-- TOC entry 5081 (class 0 OID 18150)
-- Dependencies: 369
-- Data for Name: adaptive_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.adaptive_sessions (id, user_id, subject_id, topic_id, target_questions, status, ability_before, ability_after, attempted, correct, started_at, completed_at) FROM stdin;
0a854b76-f77f-47df-8836-7b6082bbd226	97ad6c7c-6f13-4266-8241-a72deab8f86a	fbff0f41-fe5f-42e7-aafa-d85df02568e0	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	10	in_progress	50.00	\N	0	0	2026-08-27 05:46:57.8455+00	\N
566ed9ba-5f8c-4f83-a6ea-a74b0299e985	97ad6c7c-6f13-4266-8241-a72deab8f86a	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	ddbc0300-a68e-4091-a663-baa86d6ee8d3	10	in_progress	50.00	\N	0	0	2026-08-28 05:38:13.235023+00	\N
48ccf295-8848-44e9-b47b-b35f28243097	97ad6c7c-6f13-4266-8241-a72deab8f86a	bdc56824-3354-4558-963e-94033af7162c	b6f7da6a-8454-4074-9713-ec2cfac0827a	10	completed	50.00	41.10	10	1	2026-08-28 06:07:32.894268+00	2026-08-28 06:08:55.383+00
bd48ddc0-adc1-447d-ab79-37b396e9e3ff	97ad6c7c-6f13-4266-8241-a72deab8f86a	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	ddbc0300-a68e-4091-a663-baa86d6ee8d3	10	in_progress	50.00	\N	0	0	2026-08-28 08:11:46.501295+00	\N
9d9efff2-162c-4e22-8d4e-8d7ed99a9741	97ad6c7c-6f13-4266-8241-a72deab8f86a	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	ddbc0300-a68e-4091-a663-baa86d6ee8d3	10	in_progress	50.00	\N	0	0	2026-08-28 10:49:28.372295+00	\N
1932e223-2eb1-4dfe-a48f-413303132277	97ad6c7c-6f13-4266-8241-a72deab8f86a	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	0045e312-20fa-4ddf-ae9b-3f545fd19050	10	in_progress	50.00	\N	0	0	2026-09-02 06:27:48.156239+00	\N
\.


--
-- TOC entry 5092 (class 0 OID 18615)
-- Dependencies: 380
-- Data for Name: ai_question_drafts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ai_question_drafts (id, created_by, subject_id, topic_id, question_type, question_text, options, correct_answer, explanation, difficulty, status, provider, approved_at, saved_question_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5072 (class 0 OID 17697)
-- Dependencies: 360
-- Data for Name: badges; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.badges (id, name, description, xp_required, icon, image_url, criteria_type, criteria_value, is_active, created_at, updated_at) FROM stdin;
88f2e7e6-1359-45c0-92c3-23fd74769ada	Getting Started	Complete your first quiz	0	Award	\N	total_xp	0.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
84c5ce19-e0e5-4e96-8902-fe49aecef08c	Rising Learner	Earn 500 XP	500	Award	\N	total_xp	0.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
e1cf76f1-f1ae-464f-a4ba-ece64deb6bfd	First Quiz	Complete your first quiz.	0	ClipboardCheck	\N	quizzes_completed	1.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
9eb593aa-74a9-48bb-b902-65e738c22c0f	100 Questions Solved	Answer 100 quiz questions.	0	ListChecks	\N	questions_solved	100.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
dba7875b-462d-4457-a519-7c58d0e8d20c	500 XP	Earn 500 total XP.	500	Sparkles	\N	total_xp	500.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
1f0d9ec4-66d5-4054-be51-4ff4327678fe	1000 XP	Earn 1000 total XP.	1000	Zap	\N	total_xp	1000.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
5ce3e08b-6302-4922-92fa-4d9363404a44	7-Day Streak	Learn for seven consecutive days.	0	Flame	\N	streak	7.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
a3b2962f-9a6f-4b81-a76a-9453a8224fb1	30-Day Streak	Learn for thirty consecutive days.	0	Flame	\N	streak	30.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
423dd089-0ded-433e-b66f-817f0069e9ee	Accuracy Master	Maintain at least 90% accuracy after 50 answers.	0	Target	\N	accuracy	90.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
faed99a1-6541-46dd-84e6-f58d81e8a0f9	Speed Master	Average at most 20 seconds after 50 answers.	0	Timer	\N	speed_under	20.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
37bf973c-cd05-4539-8425-11430dc4dee0	Quiz Champion	Complete 25 quizzes.	2000	Trophy	\N	quizzes_completed	25.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
1c6ac79f-7b19-434f-b82c-8475e4ac04d1	Subject Expert	Reach 85% average in a subject over at least three quizzes.	0	BookOpenCheck	\N	subject_accuracy	85.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
5e746f2d-1545-4e44-ad2f-2d0e0266ea1b	Top 10	Reach the global leaderboard top ten.	0	Crown	\N	global_rank	10.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
b557ecd3-6ddf-4577-bcc8-52d4b3707b71	Perfect Score	Earn a perfect quiz score.	0	BadgeCheck	\N	perfect_scores	1.00	t	2026-08-25 07:42:30.041952+00	2026-08-25 07:42:30.041952+00
\.


--
-- TOC entry 5067 (class 0 OID 17596)
-- Dependencies: 355
-- Data for Name: exam_attempts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.exam_attempts (id, exam_id, user_id, status, started_at, submitted_at, score, percentage, correct_count, incorrect_count, unanswered_count, attempt_number, expires_at, last_saved_at, total_time_seconds, average_response_time_seconds, accuracy, passed, marks_gained, negative_marks_obtained, submission_token, xp_earned, reward_applied_at) FROM stdin;
a29c21a4-bc82-48ec-94b0-df54043547dd	e33a8358-2129-4c48-bc70-5f61d53db42f	15068f40-e70b-44b1-82eb-28b9f885db37	in_progress	2026-08-18 08:05:50.432+00	\N	0.00	0.00	0	0	0	1	2026-08-18 08:15:50.432+00	2026-08-18 08:05:50.432+00	0	0.00	0.00	f	0.00	0.00	\N	0	\N
3855de6d-d91b-4e3f-add6-db0b41d18e7f	e33a8358-2129-4c48-bc70-5f61d53db42f	15068f40-e70b-44b1-82eb-28b9f885db37	in_progress	2026-08-18 08:05:50.55+00	\N	0.00	0.00	0	0	0	1	2026-08-18 08:15:50.55+00	2026-08-18 08:05:50.55+00	0	0.00	0.00	f	0.00	0.00	\N	0	\N
4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	d629708f-e6ba-4765-a561-016a3eb2662b	97ad6c7c-6f13-4266-8241-a72deab8f86a	submitted	2026-08-27 09:28:18.908748+00	2026-08-27 09:30:52.254+00	12.00	24.00	12	37	1	1	2026-08-27 10:28:18.908748+00	2026-08-27 09:30:52.254+00	150	3.00	24.00	f	12.00	0.00	\N	185	2026-08-27 09:29:48.642224+00
67c25cd4-5f62-4314-a262-be0aa48eba67	41e8530f-95df-4b05-8756-70e2a5d3c930	97ad6c7c-6f13-4266-8241-a72deab8f86a	in_progress	2026-08-28 06:05:18.201853+00	\N	0.00	0.00	0	0	0	1	2026-08-28 07:05:18.201853+00	2026-08-28 06:05:18.201853+00	0	0.00	0.00	f	0.00	0.00	\N	0	\N
918761bd-1936-45b3-8771-eef1dcd29c24	d629708f-e6ba-4765-a561-016a3eb2662b	97ad6c7c-6f13-4266-8241-a72deab8f86a	submitted	2026-08-28 06:16:20.155344+00	2026-08-28 11:21:39.822+00	0.00	0.00	0	0	50	2	2026-08-28 07:16:20.155344+00	2026-08-28 11:21:39.822+00	3600	72.00	0.00	f	0.00	0.00	\N	50	2026-08-28 11:20:34.779048+00
daac8f25-2982-4b66-b053-e4d2d1c783fc	d629708f-e6ba-4765-a561-016a3eb2662b	97ad6c7c-6f13-4266-8241-a72deab8f86a	in_progress	2026-09-02 06:26:37.829348+00	\N	0.00	0.00	0	0	0	3	2026-09-02 07:26:37.829348+00	2026-09-02 06:26:37.829348+00	0	0.00	0.00	f	0.00	0.00	\N	0	\N
d6e3620b-8354-4d82-a5c8-978811ed5728	dc6365ab-35e3-4186-8631-14faffe07840	ce0fb583-4c15-43a5-b8af-e2b941589f86	in_progress	2026-09-03 03:30:03.191+00	\N	0.00	0.00	0	0	0	1	2026-09-03 04:30:03.191+00	2026-09-03 03:30:03.191+00	0	0.00	0.00	f	0.00	0.00	\N	0	\N
04d0b31a-ad1c-4d2b-939c-443967e6c63b	dc6365ab-35e3-4186-8631-14faffe07840	ce0fb583-4c15-43a5-b8af-e2b941589f86	submitted	2026-09-03 03:30:03.273+00	2026-09-03 03:33:54.168+00	17.00	34.00	17	3	30	1	2026-09-03 04:30:03.273+00	2026-09-03 03:33:54.168+00	208	4.16	34.00	f	17.00	0.00	\N	0	\N
\.


--
-- TOC entry 5074 (class 0 OID 17790)
-- Dependencies: 362
-- Data for Name: exam_questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.exam_questions (id, exam_id, question_id, display_order, created_at) FROM stdin;
067327c5-9c80-4661-8d64-7d3e26befe57	e33a8358-2129-4c48-bc70-5f61d53db42f	789a38fa-ce25-4d90-839f-c170affba96e	1	2026-08-18 06:23:25.515222+00
bff1c8dc-392f-44e5-be12-e4bad40ba176	e33a8358-2129-4c48-bc70-5f61d53db42f	46728b85-c7f3-4a57-af0a-58b32be35bbe	2	2026-08-18 06:23:25.515222+00
40ee5865-83f4-4586-8e75-5ae350545bd4	e33a8358-2129-4c48-bc70-5f61d53db42f	c5de0b80-e33b-467b-8ee5-77a7c3a74b3d	3	2026-08-18 06:23:25.515222+00
00388db8-5fe4-4b17-bda6-7e8d6ca9798b	e33a8358-2129-4c48-bc70-5f61d53db42f	1dad4c69-7d98-4807-b2a5-9852492eba87	4	2026-08-18 06:23:25.515222+00
9ea36be5-ec99-486c-810f-7032d4875176	e33a8358-2129-4c48-bc70-5f61d53db42f	32c7fed8-9b85-4aba-a1c0-0cc9d95daaf0	5	2026-08-18 06:23:25.515222+00
46596c20-1784-4fea-bc86-e4b759be65fa	d629708f-e6ba-4765-a561-016a3eb2662b	8fe299d0-8f3f-409f-b623-19c369484421	1	2026-08-27 08:41:05.691727+00
b73df63b-efc2-49dd-9a23-f16d01491020	d629708f-e6ba-4765-a561-016a3eb2662b	b1704bf5-d1dd-449d-9b3b-02f150f49196	2	2026-08-27 08:41:05.691727+00
4f60fa4e-2d46-43e7-b020-75ca866bde5d	d629708f-e6ba-4765-a561-016a3eb2662b	3b2c7c17-25d8-46f7-8ffe-07f122794112	3	2026-08-27 08:41:05.691727+00
86c683d7-7a1e-4185-9810-b0556e96fc38	d629708f-e6ba-4765-a561-016a3eb2662b	436d20d2-2e1f-42e2-b4cf-c06445eea5d4	4	2026-08-27 08:41:05.691727+00
7d191189-d199-41a8-8ffd-a6336afe5ca0	d629708f-e6ba-4765-a561-016a3eb2662b	7a39e6f7-1122-48a5-a69e-21c07a7627ce	5	2026-08-27 08:41:05.691727+00
68fb4dd8-c704-4654-8a46-52aee60a20b2	d629708f-e6ba-4765-a561-016a3eb2662b	e06db5ea-8a41-45dc-94c5-f6930c8fca2f	6	2026-08-27 08:41:05.691727+00
ffe19165-033d-4eef-ab3f-0b0410a1409b	d629708f-e6ba-4765-a561-016a3eb2662b	887929bf-45c0-42f3-b88b-960c0ea69bc3	7	2026-08-27 08:41:05.691727+00
0a8b958d-0047-4942-802e-fcdd26422c7f	d629708f-e6ba-4765-a561-016a3eb2662b	4fdc905f-582a-4880-b97a-ab03f7a924dd	8	2026-08-27 08:41:05.691727+00
513bbee7-6ade-4587-9e9d-9defff2a2e52	d629708f-e6ba-4765-a561-016a3eb2662b	56f4b9ca-bc07-4d25-8ae6-4b84497a831b	9	2026-08-27 08:41:05.691727+00
fb4e430f-879d-4887-8616-4193c7be2f2f	d629708f-e6ba-4765-a561-016a3eb2662b	3773211f-6a96-47c7-b6d5-7124ca15bd2a	10	2026-08-27 08:41:05.691727+00
1ffb6d3b-e943-4eec-8b5e-b1f91028979b	d629708f-e6ba-4765-a561-016a3eb2662b	a67d367d-6064-439a-9820-1b559a314178	11	2026-08-27 08:41:05.691727+00
a0165d74-014a-406b-9772-2f2b8e105a4a	d629708f-e6ba-4765-a561-016a3eb2662b	2147f63d-ebff-4303-b492-aa1e53fd89a9	12	2026-08-27 08:41:05.691727+00
650924f0-4082-434b-8767-c829acfffa6b	d629708f-e6ba-4765-a561-016a3eb2662b	612e0882-184e-477d-9b07-68aebaf8f9db	13	2026-08-27 08:41:05.691727+00
765feb5c-cf1f-4484-bbc6-e56193614001	d629708f-e6ba-4765-a561-016a3eb2662b	3a0136aa-5a28-41c8-8a9d-0ca85988d517	14	2026-08-27 08:41:05.691727+00
5e6726e7-8fbd-4375-83b8-0ef67944f2b7	d629708f-e6ba-4765-a561-016a3eb2662b	669eddca-36e1-4eca-a191-a6de90cae4a9	15	2026-08-27 08:41:05.691727+00
dec45dde-160a-4abd-9c23-b8853d8385a2	d629708f-e6ba-4765-a561-016a3eb2662b	0e1543db-2ba4-47fe-8da4-a71f466dd331	16	2026-08-27 08:41:05.691727+00
03c36cfe-17c1-4e3e-b275-d9956b4b1f13	d629708f-e6ba-4765-a561-016a3eb2662b	823eeddf-be0c-456a-97e1-91054ad0c850	17	2026-08-27 08:41:05.691727+00
12f40cbd-5a23-4b9f-b389-29b5cb7aff73	d629708f-e6ba-4765-a561-016a3eb2662b	fab38afd-5f36-4bf8-8631-eb807028b069	18	2026-08-27 08:41:05.691727+00
fec625a7-3449-4976-9d89-41abcaec81b6	d629708f-e6ba-4765-a561-016a3eb2662b	d3b64a21-148e-48ef-86aa-ade2ce77951f	19	2026-08-27 08:41:05.691727+00
79196659-6979-414a-8126-4cd5cc8e8fed	d629708f-e6ba-4765-a561-016a3eb2662b	ef60efdd-9823-4570-9219-34bc0d49300e	20	2026-08-27 08:41:05.691727+00
aebd4f17-bfe2-4c7d-ba21-231a29718a53	d629708f-e6ba-4765-a561-016a3eb2662b	a6e11d00-ea90-4cb6-a2fd-88db3dc36f15	21	2026-08-27 08:41:05.691727+00
26b2e8c5-7d10-4065-b193-140e04fbd2cd	d629708f-e6ba-4765-a561-016a3eb2662b	686147bb-ee54-4ce4-99b2-903d80e977df	22	2026-08-27 08:41:05.691727+00
aadc00bc-a5ca-4733-a6a0-c0f00f8a3b8b	d629708f-e6ba-4765-a561-016a3eb2662b	d9ecd9dd-aa5c-4457-90d4-b2e8d26661f7	23	2026-08-27 08:41:05.691727+00
6a0648e9-ceb0-4f2d-a66a-634675391b3f	d629708f-e6ba-4765-a561-016a3eb2662b	7710b2c7-58fa-4e86-bc48-f5f1da3e3da5	24	2026-08-27 08:41:05.691727+00
62a9322a-c967-4897-bd08-8f7d557113e9	d629708f-e6ba-4765-a561-016a3eb2662b	47487c28-3d5e-44b6-a40e-c939fe00651b	25	2026-08-27 08:41:05.691727+00
2b8c55bc-f8e0-4020-beec-5743e1c81a85	d629708f-e6ba-4765-a561-016a3eb2662b	5393ef56-444a-407e-9f4f-063996681bdb	26	2026-08-27 08:41:05.691727+00
dee139de-3b5b-4ce4-9cdc-df6f0292dc7d	d629708f-e6ba-4765-a561-016a3eb2662b	a5f2c768-b4fb-4e20-b710-4c57ff9c5e12	27	2026-08-27 08:41:05.691727+00
a4f16afc-31b2-40e4-a635-46472897d1b8	d629708f-e6ba-4765-a561-016a3eb2662b	59b39e86-2deb-4625-beef-09c39c0f54a6	28	2026-08-27 08:41:05.691727+00
c2bef270-9140-4b41-a079-b523d7ad1cb7	d629708f-e6ba-4765-a561-016a3eb2662b	85f181e7-3e4c-49df-89d0-98d854126316	29	2026-08-27 08:41:05.691727+00
52cb7e4e-400d-4f5b-b4ed-0f754dcf1a02	d629708f-e6ba-4765-a561-016a3eb2662b	f525ad0a-65c3-4f8e-be97-3d65a44b80be	30	2026-08-27 08:41:05.691727+00
b28b8c6f-4933-48eb-affe-214996e613df	d629708f-e6ba-4765-a561-016a3eb2662b	17a23a4e-e918-49f1-8d37-0bb6b17b0258	31	2026-08-27 08:41:05.691727+00
845f57ad-2958-4089-a570-4e4fbde59706	d629708f-e6ba-4765-a561-016a3eb2662b	cdbf324f-990e-4759-8715-01cf087eb2c0	32	2026-08-27 08:41:05.691727+00
c5788418-68d1-44c0-a6a3-6c390d981cd2	d629708f-e6ba-4765-a561-016a3eb2662b	27a57025-3ef9-4c33-aa03-64b6b233ea8e	33	2026-08-27 08:41:05.691727+00
09828985-03b0-4e3a-be0d-91ec93407738	d629708f-e6ba-4765-a561-016a3eb2662b	c54e6779-0457-4d47-a64a-0267aae99b0f	34	2026-08-27 08:41:05.691727+00
1f54ca7c-f801-42d6-b829-fd6c72750902	d629708f-e6ba-4765-a561-016a3eb2662b	c54271c9-5a92-4b96-bed6-53862f0a7fcc	35	2026-08-27 08:41:05.691727+00
774b33d7-3512-407b-8c8d-3efaabdcfba4	d629708f-e6ba-4765-a561-016a3eb2662b	da02328f-d889-4100-a1fd-250b5e9a9848	36	2026-08-27 08:41:05.691727+00
a9bf2926-6c04-4ade-bafe-5e585b05765b	d629708f-e6ba-4765-a561-016a3eb2662b	d04ce9b1-15b1-4bb1-8753-e5dffd8bc3e2	37	2026-08-27 08:41:05.691727+00
bc3106d9-9cda-4f3e-8eab-cc25f32d0522	d629708f-e6ba-4765-a561-016a3eb2662b	c5386a27-4225-433e-8a5c-152ed1a59b20	38	2026-08-27 08:41:05.691727+00
e8fba077-2a2c-45a6-8256-74fa2060f441	d629708f-e6ba-4765-a561-016a3eb2662b	87e31772-f018-4825-9fa8-e80c79a3f7c2	39	2026-08-27 08:41:05.691727+00
d4f39f51-c2c3-44ac-bd3e-a3fa02ad27a2	d629708f-e6ba-4765-a561-016a3eb2662b	60471398-431a-487a-a636-0685c3f03cb8	40	2026-08-27 08:41:05.691727+00
9adeb306-da45-4d7b-aa33-4b08272007a3	d629708f-e6ba-4765-a561-016a3eb2662b	218fb4c0-cf10-46d9-9b02-4ce16ed00229	41	2026-08-27 08:41:05.691727+00
1f23ce43-cdcb-4a54-96f0-56e8069562d0	d629708f-e6ba-4765-a561-016a3eb2662b	288722fc-d2d7-4d5b-9190-3990f9a366c8	42	2026-08-27 08:41:05.691727+00
a6afb889-ca9f-498c-b2b5-3bee8e6f8019	d629708f-e6ba-4765-a561-016a3eb2662b	48ff2f62-05d2-4cec-bb51-e5396bfbe13f	43	2026-08-27 08:41:05.691727+00
0cc9fd29-4273-43ff-a5a1-23ef10fcf9ca	d629708f-e6ba-4765-a561-016a3eb2662b	9e68b749-d586-40fe-b64e-a2ab3b19516f	44	2026-08-27 08:41:05.691727+00
f73ce493-01ae-4dc7-95dc-0b46ce4f08e8	d629708f-e6ba-4765-a561-016a3eb2662b	a84366a8-692e-4ee7-98d4-5672b2aec7c8	45	2026-08-27 08:41:05.691727+00
5c95a84d-1a4c-40d9-8d0a-a4caa5fa468e	d629708f-e6ba-4765-a561-016a3eb2662b	171cbd6b-a9c4-4210-8f72-467cea0b80d9	46	2026-08-27 08:41:05.691727+00
6ae22f88-3ac8-42eb-87af-65783b3670b7	d629708f-e6ba-4765-a561-016a3eb2662b	cd593bb2-89b7-477f-a0ca-61725c1fb34f	47	2026-08-27 08:41:05.691727+00
6419935f-878b-4b69-8689-83823afb20b0	d629708f-e6ba-4765-a561-016a3eb2662b	7af86835-af29-4960-8e8b-8264de6842e1	48	2026-08-27 08:41:05.691727+00
2a032447-a6ed-46bf-8aa1-006b85369c45	d629708f-e6ba-4765-a561-016a3eb2662b	ed939a01-c9c4-42f6-bd6b-066eaff591ef	49	2026-08-27 08:41:05.691727+00
630a3d68-4e93-4702-934d-c03b7fe1987f	d629708f-e6ba-4765-a561-016a3eb2662b	16b2d359-e7ec-41cb-8da3-f96fc44109d8	50	2026-08-27 08:41:05.691727+00
bbd0da4b-f862-4980-a034-62670e12b569	41e8530f-95df-4b05-8756-70e2a5d3c930	d65b5a01-9245-43b3-97da-d52da023a630	1	2026-08-27 08:41:05.691727+00
c61e3f6d-8e3d-41f0-84e6-ba86b9c7d84f	41e8530f-95df-4b05-8756-70e2a5d3c930	997942ce-606e-42c9-869d-6af913e84e78	2	2026-08-27 08:41:05.691727+00
09c2d018-b90d-4a09-9cbb-e07b8cec2d17	41e8530f-95df-4b05-8756-70e2a5d3c930	92ef8a0d-49e6-4799-a366-3981e5c20bb8	3	2026-08-27 08:41:05.691727+00
f1d30edb-5da0-44d3-91a6-1017551821cf	41e8530f-95df-4b05-8756-70e2a5d3c930	f33a59c2-9803-4af4-8efb-2bca09643633	4	2026-08-27 08:41:05.691727+00
7b3c4d00-65d0-4f53-8b5a-bb9ffc90efcc	41e8530f-95df-4b05-8756-70e2a5d3c930	cdbfb31d-e1b4-4ab4-aa53-efc9ad2e191d	5	2026-08-27 08:41:05.691727+00
919b078d-7670-4113-a332-e2a8fd80797e	41e8530f-95df-4b05-8756-70e2a5d3c930	08f1d2ab-2646-40cc-83ec-ad1eac478a60	6	2026-08-27 08:41:05.691727+00
c7a451d1-0dad-4c86-99d0-875f06eacd59	41e8530f-95df-4b05-8756-70e2a5d3c930	4e7e0733-c100-478b-84b2-9f14018129a9	7	2026-08-27 08:41:05.691727+00
b59f9fdc-fe98-4bce-a0cb-dfb4c86efd5d	41e8530f-95df-4b05-8756-70e2a5d3c930	3afa34ea-0f65-488a-908f-9c46e7c17e93	8	2026-08-27 08:41:05.691727+00
313f9c12-23d0-46b9-a9c5-5e5f57c13d45	41e8530f-95df-4b05-8756-70e2a5d3c930	b6cbecc4-8bad-482b-9974-280d186b1574	9	2026-08-27 08:41:05.691727+00
592676df-139e-4b70-b664-4208b15e11b8	41e8530f-95df-4b05-8756-70e2a5d3c930	e5c327c2-aec2-4e1a-86b5-8200bec1dcb7	10	2026-08-27 08:41:05.691727+00
cc0578fe-d86a-41f7-a25a-b93fdc72ebc5	41e8530f-95df-4b05-8756-70e2a5d3c930	7025c6b5-273d-4cc5-af81-6e215a6ca160	11	2026-08-27 08:41:05.691727+00
5ecb0e0a-3f69-40a3-ba29-c22f5f1b78fd	41e8530f-95df-4b05-8756-70e2a5d3c930	0205247f-2114-4c4a-a09b-093dd76a7dd5	12	2026-08-27 08:41:05.691727+00
1c98ed2a-9ed0-4b72-a264-7e1d51b070c9	41e8530f-95df-4b05-8756-70e2a5d3c930	a68d59a7-47a1-4756-88c5-a67b466e1142	13	2026-08-27 08:41:05.691727+00
c1e38123-0125-46dd-9cc5-e528f17bc273	41e8530f-95df-4b05-8756-70e2a5d3c930	49e0467f-8a1f-45a6-a637-65cc5d52188a	14	2026-08-27 08:41:05.691727+00
1ac46be4-dcde-4f91-a590-a0edd32c4009	41e8530f-95df-4b05-8756-70e2a5d3c930	6ce3fadf-60c1-4b41-a0b5-0df18fc5f126	15	2026-08-27 08:41:05.691727+00
81d8d935-55f7-4aca-a2dd-1eea97c1a1aa	41e8530f-95df-4b05-8756-70e2a5d3c930	5c9687a5-c459-4b71-bf61-235b174cd6e6	16	2026-08-27 08:41:05.691727+00
d44c3806-1d9b-4dc2-a651-fbd9f54c64d7	41e8530f-95df-4b05-8756-70e2a5d3c930	c9c58182-e24f-4269-9cd3-c9e0d147ead3	17	2026-08-27 08:41:05.691727+00
0fb5f839-704d-4be6-a079-168bbe7d5f34	41e8530f-95df-4b05-8756-70e2a5d3c930	e4fd5293-83e9-45c7-9cec-3acac25b75a5	18	2026-08-27 08:41:05.691727+00
59d02bf8-fff6-4139-ae6e-00f05c289d8d	41e8530f-95df-4b05-8756-70e2a5d3c930	0d850214-41d2-4b5b-b427-a3167452a4cb	19	2026-08-27 08:41:05.691727+00
389a0381-09d0-459f-b3b2-5cbeeee36573	41e8530f-95df-4b05-8756-70e2a5d3c930	ad9c33b8-54dc-431c-9b46-370a0e5a0ab0	20	2026-08-27 08:41:05.691727+00
e2926031-bda8-4bd4-a5fc-08e8eecfdc02	41e8530f-95df-4b05-8756-70e2a5d3c930	370aa1f0-3655-4478-8399-69a26ef0f57f	21	2026-08-27 08:41:05.691727+00
e544c8f3-d362-4161-bbf0-f21e477a6897	41e8530f-95df-4b05-8756-70e2a5d3c930	bd24455f-64b9-4cda-be0a-a3714ea94872	22	2026-08-27 08:41:05.691727+00
5ca0f69d-a257-4d66-a9a0-d02ef0d5e7d4	41e8530f-95df-4b05-8756-70e2a5d3c930	c9ca0210-d86c-4873-a395-e538de59e252	23	2026-08-27 08:41:05.691727+00
3de5fb99-c520-4ef1-982e-f89c6d516c6a	41e8530f-95df-4b05-8756-70e2a5d3c930	eafa0d6a-06ee-4fbc-bd0f-f532525804cc	24	2026-08-27 08:41:05.691727+00
82e4f772-25d2-435a-86e0-81f7f39ef1e4	41e8530f-95df-4b05-8756-70e2a5d3c930	2b6c077c-b02a-465d-80ed-57545042558c	25	2026-08-27 08:41:05.691727+00
d6c08fce-b77a-40e5-86a2-a2ac08f55fdf	41e8530f-95df-4b05-8756-70e2a5d3c930	6e632619-65a5-481e-afb1-c035d75350d7	26	2026-08-27 08:41:05.691727+00
97e1ff42-cee3-41d2-9ce0-62c597c8a92d	41e8530f-95df-4b05-8756-70e2a5d3c930	16cf1a84-3ba3-4e26-80a1-9bf491cf37fd	27	2026-08-27 08:41:05.691727+00
2e1a27ea-9cb4-4a71-895b-7c16e1337d5d	41e8530f-95df-4b05-8756-70e2a5d3c930	72bb8096-7663-477e-b3ed-33efecc648f1	28	2026-08-27 08:41:05.691727+00
f1e1e49e-f5da-45fc-a490-134b22c5e21c	41e8530f-95df-4b05-8756-70e2a5d3c930	6675663b-3099-40b7-8680-b7c919fd4174	29	2026-08-27 08:41:05.691727+00
004ef977-969b-4763-bda7-e8daba6f8a94	41e8530f-95df-4b05-8756-70e2a5d3c930	9d0348a7-a85d-4e38-b7a0-7a9be1570806	30	2026-08-27 08:41:05.691727+00
4ca071b5-8b05-4e6f-bca4-973e8a452ffd	41e8530f-95df-4b05-8756-70e2a5d3c930	9194797b-a1d2-42aa-ab3d-401d7ff7f569	31	2026-08-27 08:41:05.691727+00
c4a779fa-8783-4c69-94cd-34a217207c53	41e8530f-95df-4b05-8756-70e2a5d3c930	c2e25563-7e7e-4897-b22d-55b29904bfda	32	2026-08-27 08:41:05.691727+00
aa5cd7eb-f511-4f25-a145-42ded2a3f1f0	41e8530f-95df-4b05-8756-70e2a5d3c930	462903f2-7cb5-483d-8d9e-f78ce48fbe58	33	2026-08-27 08:41:05.691727+00
5cb074f3-1f43-41b8-b05d-1c54f2ccd0a2	41e8530f-95df-4b05-8756-70e2a5d3c930	c0f643df-f3ca-4f8a-9486-7138e13f4c6f	34	2026-08-27 08:41:05.691727+00
87511ba6-6f1c-465f-ae41-cf79c256f5c4	41e8530f-95df-4b05-8756-70e2a5d3c930	3bd0f5f8-a41f-47af-aa4c-3b43fedd5a79	35	2026-08-27 08:41:05.691727+00
2b32ae73-a12b-472b-b87e-cea911688d0e	41e8530f-95df-4b05-8756-70e2a5d3c930	1d858725-4ed9-4c01-9703-892752fd7a3e	36	2026-08-27 08:41:05.691727+00
7ef39103-5a02-466b-9074-5277b811a0e0	41e8530f-95df-4b05-8756-70e2a5d3c930	f8fb3aa1-ab9b-4d54-8a64-ec7ffa0b23e9	37	2026-08-27 08:41:05.691727+00
9fd550a5-39da-4925-ab1a-9689ecfd3262	41e8530f-95df-4b05-8756-70e2a5d3c930	f3482d19-08be-495b-b50f-eb2f069671e3	38	2026-08-27 08:41:05.691727+00
19b44ce8-de64-46f3-b382-3f1989c661df	41e8530f-95df-4b05-8756-70e2a5d3c930	b9b54bef-3b2a-446d-9d6f-f99cea938fbe	39	2026-08-27 08:41:05.691727+00
5b54a304-842c-45e7-a561-4df9dba0b80b	41e8530f-95df-4b05-8756-70e2a5d3c930	697e2b46-acfc-42bf-abf3-74c4d6302b2d	40	2026-08-27 08:41:05.691727+00
0c90b317-04d8-4c0d-8abb-ba89f62ef7a5	41e8530f-95df-4b05-8756-70e2a5d3c930	40b3b1ec-d02d-4080-8afc-d5f1af5986f1	41	2026-08-27 08:41:05.691727+00
f1bbc753-afbe-4ff4-8bbf-c2eb6fa4b3b1	41e8530f-95df-4b05-8756-70e2a5d3c930	bcd5fd60-8d57-439b-bb22-f95b261981d7	42	2026-08-27 08:41:05.691727+00
b5e8309c-ba89-4e82-b908-ae007c596d4c	41e8530f-95df-4b05-8756-70e2a5d3c930	3119f83e-5ffc-43e9-9676-6578a52e8f1a	43	2026-08-27 08:41:05.691727+00
33a3b967-c558-4f9e-a1b1-30ce780ffb20	41e8530f-95df-4b05-8756-70e2a5d3c930	a487aca5-21e4-4030-a124-c04934636b65	44	2026-08-27 08:41:05.691727+00
9dcf6550-9d7c-403a-9432-fd172fb3d4a5	41e8530f-95df-4b05-8756-70e2a5d3c930	ce1c8d3d-7885-4ac9-a80e-f7e6b33a17da	45	2026-08-27 08:41:05.691727+00
accb5ee9-b14b-45cb-8564-4caa6a197b04	41e8530f-95df-4b05-8756-70e2a5d3c930	28a88db5-65f5-48cd-9b7f-407537b243c3	46	2026-08-27 08:41:05.691727+00
5bec592e-5faa-4dc7-a21f-bd964e00046c	41e8530f-95df-4b05-8756-70e2a5d3c930	d10cacfe-73d9-468c-a6d3-c1b8c914f5b8	47	2026-08-27 08:41:05.691727+00
d7dbcc57-4bc9-4a81-ae90-0bb8231da545	41e8530f-95df-4b05-8756-70e2a5d3c930	e6675ffe-0146-41be-bd2e-d92cac3c5536	48	2026-08-27 08:41:05.691727+00
1584b2f1-54ab-498c-b518-f250c2efe80a	41e8530f-95df-4b05-8756-70e2a5d3c930	22a09dab-66d3-46d1-8812-46c2ad1fb973	49	2026-08-27 08:41:05.691727+00
31c8393a-bc07-4f13-bb7b-feaa12a0c258	41e8530f-95df-4b05-8756-70e2a5d3c930	85128d8a-671f-4772-8378-483b00dd4d72	50	2026-08-27 08:41:05.691727+00
09e06317-e5c7-4e89-bcb7-1f71ca4ad9d8	4282a1ae-5f73-41f8-b4fb-af33942add78	30ec410c-0c2b-4ad0-9933-ae75bc178f74	1	2026-08-27 08:41:05.691727+00
af36d146-a2a2-44fd-9127-1d867e9d010d	4282a1ae-5f73-41f8-b4fb-af33942add78	37d697c2-c3f5-4225-8792-6965123293b1	2	2026-08-27 08:41:05.691727+00
e1b8e809-6178-4d81-b5cf-17d6011e3e84	4282a1ae-5f73-41f8-b4fb-af33942add78	24ef0920-7305-48d0-a4c8-ed88ad3633ce	3	2026-08-27 08:41:05.691727+00
7802f2eb-dcf3-41e0-aa86-22dea08a638a	4282a1ae-5f73-41f8-b4fb-af33942add78	df4889e9-77e4-425b-ae62-9d2baaff35a1	4	2026-08-27 08:41:05.691727+00
4bdf986e-4a01-4a42-8d6d-e91c4fdd5b30	4282a1ae-5f73-41f8-b4fb-af33942add78	0b89b1a1-9732-4f0b-9fd2-2fcb02b3411a	5	2026-08-27 08:41:05.691727+00
5686155e-3bc4-4f8e-a3b3-03c236fe5567	4282a1ae-5f73-41f8-b4fb-af33942add78	8882b642-064b-47de-9ff1-db2aea9432c5	6	2026-08-27 08:41:05.691727+00
36c98454-04b5-4c7c-8d7d-7b0841d0e40e	4282a1ae-5f73-41f8-b4fb-af33942add78	ec994a23-a617-4c4e-a2e3-6b891cf76c33	7	2026-08-27 08:41:05.691727+00
467a1001-3b57-471e-879b-6dda1ad68915	4282a1ae-5f73-41f8-b4fb-af33942add78	8ffded36-0e9d-4478-b7a9-e897dc9b2d61	8	2026-08-27 08:41:05.691727+00
5379a677-64d6-49ce-af6b-74217b4ee3da	4282a1ae-5f73-41f8-b4fb-af33942add78	2a41063c-d9a4-4b74-a36c-5c1574536d95	9	2026-08-27 08:41:05.691727+00
0a60994f-aa70-4a0f-af54-b0a620440a6d	4282a1ae-5f73-41f8-b4fb-af33942add78	f1446783-3a82-460e-b0cb-acaf28cdc736	10	2026-08-27 08:41:05.691727+00
decebaa2-0ede-4442-9346-f06fda609bb0	4282a1ae-5f73-41f8-b4fb-af33942add78	d51696bc-5f7c-4b04-99b8-d8503b08887a	11	2026-08-27 08:41:05.691727+00
05a4db34-b7d8-4db8-aad6-e675a82adb50	4282a1ae-5f73-41f8-b4fb-af33942add78	c41d4128-b9d6-4d58-abdc-f1a4fc63dae9	12	2026-08-27 08:41:05.691727+00
5c29ba0d-40d0-40e3-a61c-0aa417bc29d4	4282a1ae-5f73-41f8-b4fb-af33942add78	6f6ba2a3-7168-4d10-9c12-58c1a7f5d792	13	2026-08-27 08:41:05.691727+00
199b0e68-b989-4807-b059-a62ed331de12	4282a1ae-5f73-41f8-b4fb-af33942add78	d9676b4a-3fdd-496c-932d-f1f81217bd05	14	2026-08-27 08:41:05.691727+00
5294d5c9-8a9d-4944-86d0-e6aa48b1065e	4282a1ae-5f73-41f8-b4fb-af33942add78	097fd1d4-6f02-4169-884c-bc6dbf6a6171	15	2026-08-27 08:41:05.691727+00
5b603524-830e-43cd-af41-634cb03aedad	4282a1ae-5f73-41f8-b4fb-af33942add78	6a79a6ee-bae1-45c0-8494-a775721699fd	16	2026-08-27 08:41:05.691727+00
5ec15eaa-9c0d-42db-bd77-65a3f211bfb9	4282a1ae-5f73-41f8-b4fb-af33942add78	8a4f935c-8e71-46a4-9627-089a3633f440	17	2026-08-27 08:41:05.691727+00
42a22493-363c-4d29-a6d3-6a16ed61e047	4282a1ae-5f73-41f8-b4fb-af33942add78	698c972a-0e23-4bb7-959f-029379ee2149	18	2026-08-27 08:41:05.691727+00
58586c3b-d692-48af-8eda-5f78191f9d1b	4282a1ae-5f73-41f8-b4fb-af33942add78	39ca649f-869b-407c-a24e-e9acd1de7bbc	19	2026-08-27 08:41:05.691727+00
30a997f6-cddb-48b0-80bd-cbbddf9edf29	4282a1ae-5f73-41f8-b4fb-af33942add78	2e71f8e6-364b-4f10-9bf4-4e15294ee275	20	2026-08-27 08:41:05.691727+00
d294fbeb-452e-458b-a81a-8f6b4d2b9bf2	4282a1ae-5f73-41f8-b4fb-af33942add78	79422500-7fe4-4875-81ac-b55a690cc040	21	2026-08-27 08:41:05.691727+00
124ccd29-bfbe-49cc-9b37-351e4123f92c	4282a1ae-5f73-41f8-b4fb-af33942add78	69a3773f-4d98-495e-b375-6bfe09c931b8	22	2026-08-27 08:41:05.691727+00
75ceae8d-4b62-41fb-8255-f1201b3bea8c	4282a1ae-5f73-41f8-b4fb-af33942add78	185a74d8-59b0-4b70-b9ac-332f80d16286	23	2026-08-27 08:41:05.691727+00
9bd02042-f565-48fa-9d12-8beb818ca55f	4282a1ae-5f73-41f8-b4fb-af33942add78	f9931577-8614-454f-8bdf-b7c2ddb98ea9	24	2026-08-27 08:41:05.691727+00
cb900f1e-7308-4711-90f0-66e9bb8b4151	4282a1ae-5f73-41f8-b4fb-af33942add78	67cea1bf-d023-4541-a5d4-59995de2be39	25	2026-08-27 08:41:05.691727+00
fb768e1d-4d1f-4319-b09a-6e7412773245	4282a1ae-5f73-41f8-b4fb-af33942add78	64028004-4039-4d05-8d1e-4d656de4adb3	26	2026-08-27 08:41:05.691727+00
814d4968-5f81-4123-9cf2-3df140f5892d	4282a1ae-5f73-41f8-b4fb-af33942add78	0be81396-25a8-47d6-8a5d-95a9aafa5c49	27	2026-08-27 08:41:05.691727+00
74579f0f-3792-45ae-9a3a-972ded1fece1	4282a1ae-5f73-41f8-b4fb-af33942add78	e09b4f79-48e0-4e0d-a048-11233dfc888e	28	2026-08-27 08:41:05.691727+00
412d58ca-a984-48a7-99c1-d7e4edb3aa06	4282a1ae-5f73-41f8-b4fb-af33942add78	80747644-b79f-45fc-9c84-b0f60165eb61	29	2026-08-27 08:41:05.691727+00
ef608316-eb24-4a79-b810-8847fb3081de	4282a1ae-5f73-41f8-b4fb-af33942add78	73a6a06f-1423-412c-a51c-bcfc0238f910	30	2026-08-27 08:41:05.691727+00
9429973d-12b5-4d57-a6cb-c110e6e85f86	4282a1ae-5f73-41f8-b4fb-af33942add78	b66d4cb5-a80e-4ba8-9363-b713f55072aa	31	2026-08-27 08:41:05.691727+00
4358f235-d625-4fa4-aa91-12e17055a235	4282a1ae-5f73-41f8-b4fb-af33942add78	077eb448-e29d-48f5-a165-d695b7334e21	32	2026-08-27 08:41:05.691727+00
13e14c33-8580-406e-8b83-0fdd9d61d1ac	4282a1ae-5f73-41f8-b4fb-af33942add78	11c95ce0-8a96-4c1d-a054-fa7737b09033	33	2026-08-27 08:41:05.691727+00
da9c559f-3a36-4dd5-8deb-77416878c914	4282a1ae-5f73-41f8-b4fb-af33942add78	8025a1df-c823-4a5f-9a42-70d78fe585c3	34	2026-08-27 08:41:05.691727+00
6dd6c0c6-3df7-4921-90bf-6d34fea6de15	4282a1ae-5f73-41f8-b4fb-af33942add78	a0348f5a-5da5-4931-85a8-7532b5eb0f6e	35	2026-08-27 08:41:05.691727+00
3c501b7a-0b35-4e48-8deb-2e6cc355a1c6	4282a1ae-5f73-41f8-b4fb-af33942add78	19d6e45e-d975-4665-950f-9d91f1b41f15	36	2026-08-27 08:41:05.691727+00
7193b131-f772-475c-b7e9-2a2384071bf5	4282a1ae-5f73-41f8-b4fb-af33942add78	afc801e2-a942-4c00-8d65-08a87c88bff8	37	2026-08-27 08:41:05.691727+00
10b2460e-ee8e-46db-970e-fe293e7b443f	4282a1ae-5f73-41f8-b4fb-af33942add78	a710da7e-6adf-40de-bad0-55518f64474f	38	2026-08-27 08:41:05.691727+00
ccf5c480-c4b1-44ce-9a7f-f3c65850cc45	4282a1ae-5f73-41f8-b4fb-af33942add78	7158e79a-0f99-47c8-be17-2461e7ba1a0a	39	2026-08-27 08:41:05.691727+00
b872a49e-a152-45ac-a30d-9b7aa1c4e6b2	4282a1ae-5f73-41f8-b4fb-af33942add78	473083d5-34d3-4ed3-a2e9-8d532ddc3e0e	40	2026-08-27 08:41:05.691727+00
89adf291-47d4-4789-ab22-2c9fcceb111d	4282a1ae-5f73-41f8-b4fb-af33942add78	40000de8-de1c-463a-a658-252920df4f1f	41	2026-08-27 08:41:05.691727+00
0e20a6be-aad6-47f8-9b80-3ba50d20d830	4282a1ae-5f73-41f8-b4fb-af33942add78	00433d57-1d0c-4d96-b4c8-57781290aa47	42	2026-08-27 08:41:05.691727+00
faaadae5-0e73-492a-acbf-85a261401e77	4282a1ae-5f73-41f8-b4fb-af33942add78	909d0607-9aa6-4630-a92c-1424b2fad20b	43	2026-08-27 08:41:05.691727+00
67df441f-a82e-4cc3-ace3-5ec9e716bd7a	4282a1ae-5f73-41f8-b4fb-af33942add78	3ebcff01-56dc-43e6-bbeb-697812fb3ba4	44	2026-08-27 08:41:05.691727+00
d87c7e83-daf4-4571-87d4-ca6f9300db08	4282a1ae-5f73-41f8-b4fb-af33942add78	293bf7b0-3281-43a7-a32e-5673db2c55f1	45	2026-08-27 08:41:05.691727+00
9fdfbc73-761e-432a-a268-0cbc1e4f752d	4282a1ae-5f73-41f8-b4fb-af33942add78	0dcc338b-b3b1-4104-a697-b37599bd0e49	46	2026-08-27 08:41:05.691727+00
c5fe8fe6-019d-4dea-99ab-ccced583bafc	4282a1ae-5f73-41f8-b4fb-af33942add78	7b8dd8f7-34da-4fbd-8c75-03b263d58930	47	2026-08-27 08:41:05.691727+00
20248560-230d-4956-9b89-d1754fad19f9	4282a1ae-5f73-41f8-b4fb-af33942add78	3fca2c28-66c3-44c1-8135-25718e137a2e	48	2026-08-27 08:41:05.691727+00
2590c14e-91c0-4124-a849-dce7c388e074	4282a1ae-5f73-41f8-b4fb-af33942add78	ef1f4850-dcef-4bf3-9211-ed3b9d58bc30	49	2026-08-27 08:41:05.691727+00
effba756-843e-45e8-9198-7c506fc4835e	4282a1ae-5f73-41f8-b4fb-af33942add78	9b51ad95-e193-4075-9c86-474f971d8a82	50	2026-08-27 08:41:05.691727+00
2fc58cae-1025-4f3a-9450-eade25c89df1	222121d7-4b4e-4007-bf5e-3fb8a5400450	7d0113e4-e3a5-4158-aaf6-d53ad731657c	1	2026-08-27 08:41:05.691727+00
2223e814-7c84-4814-8829-49a7edc5cf8a	222121d7-4b4e-4007-bf5e-3fb8a5400450	aae368a6-a852-4561-a881-57784260bff6	2	2026-08-27 08:41:05.691727+00
4adb2ec0-e264-4c44-9987-5eb61af6d73f	222121d7-4b4e-4007-bf5e-3fb8a5400450	9e70c00a-5f52-4f70-bd37-13dc68fff842	3	2026-08-27 08:41:05.691727+00
dbfbb3ab-277a-4199-a5d9-9e52fbf09364	222121d7-4b4e-4007-bf5e-3fb8a5400450	95eb5c8c-a545-48bf-a37b-b3153ee43ef8	4	2026-08-27 08:41:05.691727+00
fd76602f-e91f-48c2-9e23-5f092075dab4	222121d7-4b4e-4007-bf5e-3fb8a5400450	47404c6d-0bef-4501-bc4e-b7728ef89709	5	2026-08-27 08:41:05.691727+00
d07da36c-156e-417c-8d52-c14f694134b6	222121d7-4b4e-4007-bf5e-3fb8a5400450	b00190a6-7a18-4755-8dc8-3b08491d59bb	6	2026-08-27 08:41:05.691727+00
f049e08d-5eb9-405e-90ee-b4ee46702d24	222121d7-4b4e-4007-bf5e-3fb8a5400450	cf6c5f7f-45b0-405b-b172-315bc4fab10e	7	2026-08-27 08:41:05.691727+00
72c76e7d-010b-4e56-aad9-0142b6b645f4	222121d7-4b4e-4007-bf5e-3fb8a5400450	5d20a457-0c05-42a5-9449-0f6c25cd8d08	8	2026-08-27 08:41:05.691727+00
90ddea38-c035-4471-8efc-1bf58bac5b49	222121d7-4b4e-4007-bf5e-3fb8a5400450	ebb7dc34-a985-4e40-a8af-7956e6c347c6	9	2026-08-27 08:41:05.691727+00
4bc36fea-e6f4-4d25-85bd-a79fec6b2135	222121d7-4b4e-4007-bf5e-3fb8a5400450	8cdbac2a-9730-4b03-9ec8-9c01346012f7	10	2026-08-27 08:41:05.691727+00
c9e721bd-692e-4048-9822-025703ffaa71	222121d7-4b4e-4007-bf5e-3fb8a5400450	86350298-a68d-4675-ae30-36e9e5e854e9	11	2026-08-27 08:41:05.691727+00
d83bfc6f-e9a2-4720-a3b6-967d8df2f86c	222121d7-4b4e-4007-bf5e-3fb8a5400450	ef2f76cd-8164-4c4d-afc0-c643f2539567	12	2026-08-27 08:41:05.691727+00
8cf22a52-94e5-47a5-a387-32fa329c3990	222121d7-4b4e-4007-bf5e-3fb8a5400450	b7950133-f1a2-4837-8386-b33f68d43885	13	2026-08-27 08:41:05.691727+00
7ef1ce63-8602-4579-aca1-18c69c0140a8	222121d7-4b4e-4007-bf5e-3fb8a5400450	c4161661-f155-4a0b-a0b4-d39649a0ae64	14	2026-08-27 08:41:05.691727+00
7db89af3-3236-461c-8666-e37081590fac	222121d7-4b4e-4007-bf5e-3fb8a5400450	793177de-2f9b-4508-ae76-65131ba1a8de	15	2026-08-27 08:41:05.691727+00
3ef6b1f3-1e74-4aa9-b220-33866b3c70c7	222121d7-4b4e-4007-bf5e-3fb8a5400450	de52162a-c31d-4664-81a3-c8fc9785584f	16	2026-08-27 08:41:05.691727+00
13e1781e-57ce-4b64-b24a-78da9535436d	222121d7-4b4e-4007-bf5e-3fb8a5400450	f4d6994c-4079-4ec3-8108-f93ed2b41a55	17	2026-08-27 08:41:05.691727+00
f8daaca4-cbd3-406c-aa97-052b75c22564	222121d7-4b4e-4007-bf5e-3fb8a5400450	0ccd5902-c94b-4125-9b53-6fa519e58610	18	2026-08-27 08:41:05.691727+00
9571e635-94dc-4960-b377-c4b2ba1d6b41	222121d7-4b4e-4007-bf5e-3fb8a5400450	1bccc684-d95f-4edd-b320-379ff84fc8e3	19	2026-08-27 08:41:05.691727+00
fde9b857-47ef-4989-b2da-730ee37e90a0	222121d7-4b4e-4007-bf5e-3fb8a5400450	3f09a20b-71fc-403f-8420-cd9e8f1b661d	20	2026-08-27 08:41:05.691727+00
176291be-53cf-4ca8-a1e9-14bd69dc2017	222121d7-4b4e-4007-bf5e-3fb8a5400450	643c49ac-3b76-474c-9c39-b7b2e2d55d50	21	2026-08-27 08:41:05.691727+00
e27980b0-04e0-4813-b9d7-f66ee894dbd2	222121d7-4b4e-4007-bf5e-3fb8a5400450	5cf4f9f4-9919-4f6c-87b0-e209278f6d0a	22	2026-08-27 08:41:05.691727+00
4d90916b-feb4-41e0-a6fe-71665b174855	222121d7-4b4e-4007-bf5e-3fb8a5400450	be7e0ccb-80c6-41c7-82a6-8275244a1736	23	2026-08-27 08:41:05.691727+00
844c8848-b252-4da1-a500-b586255d4c4d	222121d7-4b4e-4007-bf5e-3fb8a5400450	18628da1-1325-4dbc-a89c-546f628fe8ae	24	2026-08-27 08:41:05.691727+00
861f6556-bd76-4b4b-ac26-466dbd5a8892	222121d7-4b4e-4007-bf5e-3fb8a5400450	4207e598-5f51-4511-be1e-a08a8984c63f	25	2026-08-27 08:41:05.691727+00
6de083cc-6eee-40c8-ba9b-43d5a9ac6581	222121d7-4b4e-4007-bf5e-3fb8a5400450	2ba369a0-f4b5-4827-a48c-9d6ef65219e7	26	2026-08-27 08:41:05.691727+00
688b0082-5c5f-4166-867c-99d9ea32fcf4	222121d7-4b4e-4007-bf5e-3fb8a5400450	570088b6-9bef-42d0-850d-58ed31c6fc64	27	2026-08-27 08:41:05.691727+00
e8ae3d46-a96c-4c31-9562-74c1625e7dce	222121d7-4b4e-4007-bf5e-3fb8a5400450	33895a6f-227b-48d0-ad87-a1c0b5e6b123	28	2026-08-27 08:41:05.691727+00
21831966-ae3e-4cf5-88c2-03ad1573bcf1	222121d7-4b4e-4007-bf5e-3fb8a5400450	04156fee-9433-496a-94c2-b2d68afe1acf	29	2026-08-27 08:41:05.691727+00
1d5968e3-302c-475c-943a-7a96713c613e	222121d7-4b4e-4007-bf5e-3fb8a5400450	a6e76399-8ecd-4455-a6a3-2d90060a8d13	30	2026-08-27 08:41:05.691727+00
9d9da636-70af-4fcf-9d58-8757a26e1df9	222121d7-4b4e-4007-bf5e-3fb8a5400450	4b20328e-52d3-464e-a78f-dff379d75a7d	31	2026-08-27 08:41:05.691727+00
336c9818-a1c2-47e6-b6ad-9d4e2cbf0463	222121d7-4b4e-4007-bf5e-3fb8a5400450	41cab20a-6347-40a4-b328-71d2ad824a8e	32	2026-08-27 08:41:05.691727+00
42beb7db-8ba2-4870-babd-3207931becd0	222121d7-4b4e-4007-bf5e-3fb8a5400450	9ef575cb-a502-4eb7-b8f0-a6c4549c6bab	33	2026-08-27 08:41:05.691727+00
bce9f699-886a-486c-bdb0-8c22fbe1298e	222121d7-4b4e-4007-bf5e-3fb8a5400450	a8bcb7b3-5494-4873-a6a9-5a9f7a6e4343	34	2026-08-27 08:41:05.691727+00
1a578017-c55c-4ff4-9fe0-518b89dab5d3	222121d7-4b4e-4007-bf5e-3fb8a5400450	63d7a8ef-8fda-4d95-8cba-6fadb19fa3f1	35	2026-08-27 08:41:05.691727+00
bb292729-df0c-4259-8203-2ee58d8a9484	222121d7-4b4e-4007-bf5e-3fb8a5400450	4c792ba0-f9d2-4b44-97ec-fcce8b335d8b	36	2026-08-27 08:41:05.691727+00
334d6821-8b47-429d-8215-e6e2fd24fc34	222121d7-4b4e-4007-bf5e-3fb8a5400450	fb185f4b-537e-47c7-8bef-80974ee70a84	37	2026-08-27 08:41:05.691727+00
b20cad9b-1377-4549-8743-d8701cd200ba	222121d7-4b4e-4007-bf5e-3fb8a5400450	16aabbdc-8900-471c-b75c-5caef90490d1	38	2026-08-27 08:41:05.691727+00
c2ebef3d-6164-4b2d-9c24-c7c1de8b10b8	222121d7-4b4e-4007-bf5e-3fb8a5400450	8e4b0293-ed8e-49e6-b36e-d82470a7cef5	39	2026-08-27 08:41:05.691727+00
967055f9-4eb7-423b-a1c3-65e8de67f2ee	222121d7-4b4e-4007-bf5e-3fb8a5400450	4c2cd1f1-59c9-4096-ac7f-625c6a990d95	40	2026-08-27 08:41:05.691727+00
e0489a59-9bfb-4cd2-9a05-5d3ba732dfbc	222121d7-4b4e-4007-bf5e-3fb8a5400450	b9d88a02-7c7b-4a8a-a72e-83fa4bef1700	41	2026-08-27 08:41:05.691727+00
280c1c88-eb78-4f2d-8c22-6a0c7ca5488b	222121d7-4b4e-4007-bf5e-3fb8a5400450	a9ff3fc1-f97e-47c7-8197-a11b5159b9df	42	2026-08-27 08:41:05.691727+00
8aab70df-9868-40d0-a1e6-534d2f3e6120	222121d7-4b4e-4007-bf5e-3fb8a5400450	3f1297d9-6e49-418d-b15d-59e9cec6a9b1	43	2026-08-27 08:41:05.691727+00
11e596a3-c5ea-4f3a-b528-e33fe6e6d084	222121d7-4b4e-4007-bf5e-3fb8a5400450	8293d655-3f0e-4e41-aaef-1baca4261d0e	44	2026-08-27 08:41:05.691727+00
41f39263-7d25-4d19-8113-2b94a49d8ca1	222121d7-4b4e-4007-bf5e-3fb8a5400450	f2f5fe38-2d23-4b5c-8c78-49d46a5bb86f	45	2026-08-27 08:41:05.691727+00
f07cf19b-435f-4094-8acc-b8b8f1f9cc23	222121d7-4b4e-4007-bf5e-3fb8a5400450	39aad460-9feb-41fe-80ff-c7a82cf5689f	46	2026-08-27 08:41:05.691727+00
6538ad2f-df70-43be-bb65-a1868073a71a	222121d7-4b4e-4007-bf5e-3fb8a5400450	744c5ad0-735f-4c09-8897-5446c794156e	47	2026-08-27 08:41:05.691727+00
cbc4e4ea-d9cd-4516-abde-a698f18c7c3e	222121d7-4b4e-4007-bf5e-3fb8a5400450	55c4a4a5-146a-46b0-a220-f3f5de33d801	48	2026-08-27 08:41:05.691727+00
a307a792-21ab-4869-9056-e779e7202c76	222121d7-4b4e-4007-bf5e-3fb8a5400450	f803fde1-7370-4560-89c3-834d909fe08e	49	2026-08-27 08:41:05.691727+00
122cabec-5cce-4375-b661-732eaf908ae9	222121d7-4b4e-4007-bf5e-3fb8a5400450	218fc3bc-b712-4b00-a0ea-8579926c8fff	50	2026-08-27 08:41:05.691727+00
524e049f-8326-4d32-8a02-d2703f62892f	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	1a8e9c2b-8747-4960-8928-73ecda17b084	1	2026-08-27 08:41:05.691727+00
1c2789df-4d20-4980-96b3-bffc52da559d	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	76c6a9ad-d05f-47f3-8510-0054d1e03545	2	2026-08-27 08:41:05.691727+00
3f8d0e13-8ad6-470a-a730-8b75dd7e6d47	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	5f824616-e3f3-4f15-a8b6-0b4fa3e379f6	3	2026-08-27 08:41:05.691727+00
eccaba00-045c-4976-83ea-1b3a1f846bb0	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	b820af3c-d84f-46ad-852a-2629464c2ef7	4	2026-08-27 08:41:05.691727+00
e0b7cc31-cb9a-4d1f-821d-8f22299a14fa	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	dad206f7-f340-476f-8776-e8d44f8b1a2d	5	2026-08-27 08:41:05.691727+00
4a7af541-2567-48f2-b911-b5e4381c1ca9	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	29fe5079-6af0-46bd-85a0-5307fa0172f8	6	2026-08-27 08:41:05.691727+00
e22bb995-3650-4a19-9a2f-0f885c2efe43	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	59d8b4b0-bf94-4edf-ba80-b648e7068827	7	2026-08-27 08:41:05.691727+00
cead7edb-7bff-488c-a314-699de69d27f1	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	c78b5f04-1bd4-4198-be9e-10efd7db2c42	8	2026-08-27 08:41:05.691727+00
cd606332-c5ac-43a4-a8a9-44baae8cfbab	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	5f0845f2-e5f5-4ba3-a739-52f713ee6b2e	9	2026-08-27 08:41:05.691727+00
7b7103d8-8df8-4a60-a0bc-f86ea48f48ce	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	a575b35b-790a-4d6a-8056-4b7f3608054c	10	2026-08-27 08:41:05.691727+00
497e4b48-b815-4048-ac54-4125511bab65	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	11e6276d-517f-45ac-975c-0b4b93816e46	11	2026-08-27 08:41:05.691727+00
61e71057-0780-489a-b9d4-e1dfaafb2e51	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	f7180358-8ef2-4bf9-b661-c19227dbefef	12	2026-08-27 08:41:05.691727+00
73f7fa7a-6134-4f12-ad91-614ecd932777	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	acc3cac5-3ab3-4e37-a8c1-f3b11b2104d1	13	2026-08-27 08:41:05.691727+00
cb9e0ff2-d811-43f7-9f38-6249f9c60386	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	bda080c9-90e6-4d54-a211-264a9fcac2f3	14	2026-08-27 08:41:05.691727+00
b1f56d97-c4b0-4a6f-b831-7913c498c786	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	f8cca473-cf47-44da-89b3-76745dcbb011	15	2026-08-27 08:41:05.691727+00
0616e3c0-c5cd-4193-a3d8-1bc56c485e18	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	1d47a868-1630-4b61-b94c-3afa1c8c3087	16	2026-08-27 08:41:05.691727+00
ec179e9e-27f5-4f0e-8f99-838d4cc89ec6	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	548ec1ad-30fb-4d4a-a33c-3e4625831391	17	2026-08-27 08:41:05.691727+00
c982dd29-861f-4871-84e4-52a6d3ca4258	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	a18b414a-0eaf-4cf0-ba94-b327abe17dc4	18	2026-08-27 08:41:05.691727+00
5d997a27-c260-47fd-b346-43f747113eb1	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	ef348dfd-e958-4d1a-814e-d3606d9a5f34	19	2026-08-27 08:41:05.691727+00
cefa5740-065e-4ba7-ba9d-71f0f391e56f	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	4ad2dfb1-ff12-419d-8fc9-6a22644160d5	20	2026-08-27 08:41:05.691727+00
d3ff7b8c-e747-4cc8-a65d-6f209eaa13a1	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	de54431d-a948-483b-93ac-e826fccbe8a1	21	2026-08-27 08:41:05.691727+00
96196eb7-f509-4941-8682-8b34e7633f18	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	d1e47664-ae17-4246-8508-5d68c6f68e5f	22	2026-08-27 08:41:05.691727+00
ca0d6cf1-d2b7-4117-9f3b-fdb44228e4fd	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	de80210a-8fbe-48ff-91b5-8f4e985801fa	23	2026-08-27 08:41:05.691727+00
c499ce63-2e1e-448d-9ab0-8d543ee48e70	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	d16c44c9-7447-4180-9ca7-645d9c85fa86	24	2026-08-27 08:41:05.691727+00
a1515292-3985-489c-b628-fae9ad1b63a2	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	83ca8b14-4196-4d0e-aa05-31d3a91e0a8a	25	2026-08-27 08:41:05.691727+00
ca6ff966-c0ef-4258-b8d2-d095704eb909	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	fa9a021f-6aec-40ee-a2dd-8b113a4dfaff	26	2026-08-27 08:41:05.691727+00
60f84cda-e17a-4801-8e2b-104baf5a0ac7	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	13e4fc2f-75ff-495c-befb-c1f5dc68d8e0	27	2026-08-27 08:41:05.691727+00
1b10397f-5378-4b30-aad8-1caf0b47b1dc	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	d9a60269-4668-4264-8aec-6e01c778ae97	28	2026-08-27 08:41:05.691727+00
0888e254-15b5-4778-b9c7-fa8fb364c9a0	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	59338f9d-3680-4202-b514-b0adc8d90eb8	29	2026-08-27 08:41:05.691727+00
fbb408dc-a769-41d1-b7f1-55f07bab0313	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	1a453cc4-89de-42ff-a617-daba7254e905	30	2026-08-27 08:41:05.691727+00
e66ad894-ffb8-4894-95f3-d87e23f430ad	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	f705924a-b22f-4618-9f5d-817424c1b9d4	31	2026-08-27 08:41:05.691727+00
3c01d552-a846-4c51-91ed-cc3120292489	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	45815857-a7b3-48d8-a992-63facd607fd3	32	2026-08-27 08:41:05.691727+00
ede9f67c-f30a-44c4-982b-2cd60e72e18c	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	d10c14d0-6aa3-43f0-86d0-583027525345	33	2026-08-27 08:41:05.691727+00
cc34be68-c4b8-4d06-a21f-10f68ed50405	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	95b4be55-3518-4fe9-bee4-cddb93af5fea	34	2026-08-27 08:41:05.691727+00
ecd641cf-8d51-439a-9ebb-e1eeba3627ad	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	7fe384c6-2fa5-4beb-8be3-d380cbe1aa3e	35	2026-08-27 08:41:05.691727+00
34fad85a-44fd-4acd-8557-46377ac24136	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	c03f1f5c-3b36-4710-a2b2-f4f1093087df	36	2026-08-27 08:41:05.691727+00
fa199f88-d9d8-4a2b-afe2-64839dfe4b3a	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	2074d97e-db75-4e05-ae31-7f878887b964	37	2026-08-27 08:41:05.691727+00
d807a0cb-e634-472b-a2d1-85cd0125d7da	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	7593b8b4-8f8e-49b0-b597-9ec3a6590e3c	38	2026-08-27 08:41:05.691727+00
281abee2-75b7-4b53-abff-79011d6874f4	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	be9c202b-b257-43da-92b6-2573e320f988	39	2026-08-27 08:41:05.691727+00
75a5ca58-de2c-4d4d-9f56-f9ff33ac5460	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	2846d505-4deb-4150-a032-0a63638f2b0e	40	2026-08-27 08:41:05.691727+00
02cb0a80-5572-4d48-9ec7-b5772ed31f90	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	0f02549e-7b2e-4a46-89d5-2e86425704b9	41	2026-08-27 08:41:05.691727+00
57fb8d30-3ba4-46dc-80b4-7a5563100ad6	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	8bc408a4-3e39-4b2d-95bd-2871d6bf2ea7	42	2026-08-27 08:41:05.691727+00
ddfffdaa-d0a5-49a7-81d4-511111d4ab97	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	f643eb69-4619-4641-8a9d-5a8a92227c1a	43	2026-08-27 08:41:05.691727+00
224d8d50-2ef7-4aeb-ba37-09d0c05422ca	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	3a69ae81-ba40-4e75-aa29-82520d1574cf	44	2026-08-27 08:41:05.691727+00
d946b526-b950-45a7-8370-2dd7557b9a7f	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	5fcbd66b-6d35-41bc-8271-19a112780717	45	2026-08-27 08:41:05.691727+00
e3d35dad-8d6f-4c03-9250-fc170f88d903	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	18162b5d-82af-4ea8-9f87-8f5198e5ae8f	46	2026-08-27 08:41:05.691727+00
b0a760b1-0576-47ed-ac49-9dc02e39af74	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	790d1e73-d74b-4b88-8921-2813a9170dd0	47	2026-08-27 08:41:05.691727+00
f643c5aa-842d-4602-b71f-c2623d6654d4	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	155df444-c3b9-46c2-9135-3b2d2a113ea9	48	2026-08-27 08:41:05.691727+00
904f7f9a-65c8-4320-a325-7d63b8528e45	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	151f66ad-7808-4e1d-beb0-c3000fd8aa0e	49	2026-08-27 08:41:05.691727+00
9562b408-3058-417d-9226-74ba8e58cd36	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	4f97e9d8-1833-4e11-8e06-a22f8a0218c6	50	2026-08-27 08:41:05.691727+00
e61cbf5b-bbf4-4206-870c-00844e7aad0c	aad02091-b53f-4632-b423-0b555ce5064c	d5ac02bb-4287-40ff-adf8-80c2fc17cccd	1	2026-08-27 08:41:05.691727+00
ce6cf798-a8dc-4f52-9399-08bcccd4c999	aad02091-b53f-4632-b423-0b555ce5064c	65a6337e-6ffb-4eef-a3d9-5aadba5ee0e1	2	2026-08-27 08:41:05.691727+00
160e8149-29b3-4fa3-9a95-19a3f26105b4	aad02091-b53f-4632-b423-0b555ce5064c	b4a711fd-622b-4338-b121-d80ad068f01a	3	2026-08-27 08:41:05.691727+00
41b7f1ee-2ed9-46d9-891f-c2640b843679	aad02091-b53f-4632-b423-0b555ce5064c	6c2fdfe3-58c4-4d7b-aed6-5092e7415c43	4	2026-08-27 08:41:05.691727+00
c8943664-a42a-4706-812f-510ceb0c2708	aad02091-b53f-4632-b423-0b555ce5064c	d5626a3f-7894-48ea-8bbb-427408c6ed53	5	2026-08-27 08:41:05.691727+00
d4832b41-97ed-4849-9101-a6f1fc02ece2	aad02091-b53f-4632-b423-0b555ce5064c	72e3e95c-4bff-4c66-adf1-ba12b3553c55	6	2026-08-27 08:41:05.691727+00
4bd4f1f9-4dcb-41ed-a816-d896e6429ed4	aad02091-b53f-4632-b423-0b555ce5064c	064c1889-1279-4054-b194-6bfc5265898f	7	2026-08-27 08:41:05.691727+00
0e59a84f-16d1-4b33-acce-26eac05eb41c	aad02091-b53f-4632-b423-0b555ce5064c	08324c9b-5792-44f4-8947-b00aeef0944a	8	2026-08-27 08:41:05.691727+00
bb2c3cae-5325-4f83-8081-868829159bda	aad02091-b53f-4632-b423-0b555ce5064c	de3a57d0-03a5-422c-84c6-3d51cbea0ee2	9	2026-08-27 08:41:05.691727+00
c359d4f4-5093-496d-bddf-e39796f03560	aad02091-b53f-4632-b423-0b555ce5064c	4c6a18f1-3b83-416c-b8bd-213031b58845	10	2026-08-27 08:41:05.691727+00
911f9d15-98e5-4a75-9de5-559e9acb2e5b	aad02091-b53f-4632-b423-0b555ce5064c	896f514a-bdcb-4a17-8a31-94f039f66edb	11	2026-08-27 08:41:05.691727+00
cfbb6cad-f14f-4374-ad02-bb847cdb6b38	aad02091-b53f-4632-b423-0b555ce5064c	bd7ed27c-d5e7-4790-a58f-310a02b402cf	12	2026-08-27 08:41:05.691727+00
7643be97-72ed-4c71-9bee-bc0129621cbe	aad02091-b53f-4632-b423-0b555ce5064c	ea5f0c5c-a2a0-4589-981f-8f4e72b10f7b	13	2026-08-27 08:41:05.691727+00
40cfd0fa-38d3-476a-be89-8527635199b4	aad02091-b53f-4632-b423-0b555ce5064c	7be78a8d-72f2-4c8e-a5bf-505b0a7162fd	14	2026-08-27 08:41:05.691727+00
badc27d0-e104-48b4-9708-a70adefc09c7	aad02091-b53f-4632-b423-0b555ce5064c	44ef26fd-28cd-4e5d-98a3-e9d64a26d79f	15	2026-08-27 08:41:05.691727+00
11eefa17-5447-4703-ba79-3ad6d613c500	aad02091-b53f-4632-b423-0b555ce5064c	6a5e0ca3-ff0d-499d-8d8c-5f3f6045fe35	16	2026-08-27 08:41:05.691727+00
e67488c7-23c8-4748-8835-0907e765b0aa	aad02091-b53f-4632-b423-0b555ce5064c	3df51124-d70c-4cfd-95ba-dbe7daa9dcab	17	2026-08-27 08:41:05.691727+00
c3251fbf-c6b7-43a9-83a4-6ea780e79e54	aad02091-b53f-4632-b423-0b555ce5064c	c589eec6-7527-4921-8d0d-bcd6162511a8	18	2026-08-27 08:41:05.691727+00
206bccc1-d6fc-42d6-853e-fc7cb2dea63f	aad02091-b53f-4632-b423-0b555ce5064c	9868f0ff-744f-4f1b-aa04-f6ef2b11b8e5	19	2026-08-27 08:41:05.691727+00
ac4e1a1c-15bb-41fa-94c1-4d03b1af9bf0	aad02091-b53f-4632-b423-0b555ce5064c	7898f447-6b08-4400-8799-c04e653a5bac	20	2026-08-27 08:41:05.691727+00
45c5098c-de8d-492a-92dc-63d1365c069e	aad02091-b53f-4632-b423-0b555ce5064c	845221c5-7ca4-4dd6-8fea-56a278922d7a	21	2026-08-27 08:41:05.691727+00
12d18396-f5c0-4290-8fee-cd5c529cb5b9	aad02091-b53f-4632-b423-0b555ce5064c	f1acce65-34e9-4788-99ba-a2fe72aa0c6f	22	2026-08-27 08:41:05.691727+00
48e4e623-06e6-49b2-9dc5-85f401c48d27	aad02091-b53f-4632-b423-0b555ce5064c	dee7c18a-eee0-4daf-ae0c-529a0ecef01b	23	2026-08-27 08:41:05.691727+00
c575861d-cfb2-4ae9-ae2d-a3f6b11f07a9	aad02091-b53f-4632-b423-0b555ce5064c	e8cf911b-3882-4045-a384-581b54f4ffae	24	2026-08-27 08:41:05.691727+00
d00acc58-8ae5-4387-8461-50c6c8ce008d	aad02091-b53f-4632-b423-0b555ce5064c	7bfc220d-8e94-4521-adf0-688414744406	25	2026-08-27 08:41:05.691727+00
64a487a2-13dc-42aa-a5c1-e8cc34579c5c	aad02091-b53f-4632-b423-0b555ce5064c	b5286ce5-0899-4dda-b2ce-7bef55fdba33	26	2026-08-27 08:41:05.691727+00
8222e769-1c92-4fb4-9fe6-131c60ef4f5b	aad02091-b53f-4632-b423-0b555ce5064c	4a36abb7-7604-4735-a1fa-1a9f4939f4e7	27	2026-08-27 08:41:05.691727+00
c03df1df-4470-4722-a3c1-76b3976d1e74	aad02091-b53f-4632-b423-0b555ce5064c	6c7b7f16-b7f8-45ba-bee0-04150e7c801a	28	2026-08-27 08:41:05.691727+00
5c760555-4a1b-4448-a578-d5cc664f1434	aad02091-b53f-4632-b423-0b555ce5064c	f58958ae-f39b-49e0-a43a-47910932cb02	29	2026-08-27 08:41:05.691727+00
1ffea625-796f-41cc-9f63-c6e9d66470dd	aad02091-b53f-4632-b423-0b555ce5064c	4e322888-4c0e-41d9-aa57-2ae5827aa306	30	2026-08-27 08:41:05.691727+00
250c862e-ae4c-428f-ba49-9a1a93979d52	aad02091-b53f-4632-b423-0b555ce5064c	3b672ad7-90df-47de-9735-5459db384181	31	2026-08-27 08:41:05.691727+00
f7fd5ed6-2acb-457f-aa56-5f744be16a83	aad02091-b53f-4632-b423-0b555ce5064c	9c94147e-d51c-4f8f-b07b-96e08bb599c6	32	2026-08-27 08:41:05.691727+00
eee23427-7540-4892-8cc5-dea004068cbb	aad02091-b53f-4632-b423-0b555ce5064c	c2426140-d076-4480-93d4-94c4a74dbddb	33	2026-08-27 08:41:05.691727+00
854ae1d9-a48e-4611-bbdf-fdaa0000b460	aad02091-b53f-4632-b423-0b555ce5064c	d4984c95-1e49-43f5-968a-eb04d0a2b5d9	34	2026-08-27 08:41:05.691727+00
179bb616-f2dd-4914-ace5-b1250dcbb12d	aad02091-b53f-4632-b423-0b555ce5064c	b7e89237-65b4-487b-ad9d-50a6ec432be6	35	2026-08-27 08:41:05.691727+00
fc818970-9f76-4e85-91fd-013fc8d55d0d	aad02091-b53f-4632-b423-0b555ce5064c	f0bd7f52-7f4c-400a-9450-49a58c016160	36	2026-08-27 08:41:05.691727+00
ec383be7-72cb-4cfb-89b3-e2b95ca42c00	aad02091-b53f-4632-b423-0b555ce5064c	5989f968-40b5-4bee-a755-2c635fa9cdd8	37	2026-08-27 08:41:05.691727+00
288b8c1f-11c8-42ee-9f65-11eb5373e4d2	aad02091-b53f-4632-b423-0b555ce5064c	d22ba388-ab6c-4373-8bb6-4428410c7583	38	2026-08-27 08:41:05.691727+00
9e5a7051-014f-49d9-847c-f81280046c51	aad02091-b53f-4632-b423-0b555ce5064c	b3b2e57a-523d-42d4-9f03-76451bea6611	39	2026-08-27 08:41:05.691727+00
fa21ac8c-5d07-4677-ac09-2084ad3d0ddd	aad02091-b53f-4632-b423-0b555ce5064c	1b50b398-6bad-414c-a802-8511f2722baf	40	2026-08-27 08:41:05.691727+00
d6767d0f-1dd2-416d-93ed-8a9775d732c2	aad02091-b53f-4632-b423-0b555ce5064c	a44eb100-00d3-431a-b109-64f3ab677178	41	2026-08-27 08:41:05.691727+00
8282aa5b-ba37-4dfd-ac15-e9f2d8281757	aad02091-b53f-4632-b423-0b555ce5064c	9035d19f-745e-4b23-bd94-d5e21c41adf7	42	2026-08-27 08:41:05.691727+00
30ab087c-69d1-44ad-972d-2d5f50d14644	aad02091-b53f-4632-b423-0b555ce5064c	1486cc28-4e01-4489-8f63-84bb00422773	43	2026-08-27 08:41:05.691727+00
f8d0f1d0-2b69-4066-8681-3b040ad261fa	aad02091-b53f-4632-b423-0b555ce5064c	2a3e66d7-e053-4045-9690-4f094961d4b6	44	2026-08-27 08:41:05.691727+00
c16d5a8b-1e82-4eb5-bd92-89fb6bd94f20	aad02091-b53f-4632-b423-0b555ce5064c	9cef3f7e-1dfa-4d56-9b6f-5c9463ff6615	45	2026-08-27 08:41:05.691727+00
81dcb026-460d-4a09-a21b-3661c27813e4	aad02091-b53f-4632-b423-0b555ce5064c	db76ec51-1660-4151-adab-91ca959b8b4c	46	2026-08-27 08:41:05.691727+00
beaaf75e-dc55-4b56-9c02-d42387521893	aad02091-b53f-4632-b423-0b555ce5064c	1932a7a6-056f-40ab-86a1-3e819bb3dcaa	47	2026-08-27 08:41:05.691727+00
01c0f04d-7f55-496d-8054-afb2cc4b6e8f	aad02091-b53f-4632-b423-0b555ce5064c	3d9a0364-3472-49b4-83fd-ed21835369c6	48	2026-08-27 08:41:05.691727+00
e9d76912-a882-4cf9-aac5-26d9eb13052f	aad02091-b53f-4632-b423-0b555ce5064c	54833678-2e79-47f3-a8ec-48ececb82f6b	49	2026-08-27 08:41:05.691727+00
c8a7849c-6da7-487e-8475-ce05ceeec944	aad02091-b53f-4632-b423-0b555ce5064c	c68e74a1-ed98-4c9a-b5c2-79feb672fdf0	50	2026-08-27 08:41:05.691727+00
38af9b76-222f-4bb2-943e-a9af8e656548	d8084811-1a21-4e12-af30-4fecb20d0454	ce705aa3-20c8-40c3-8cab-9cf728e91e71	1	2026-08-27 08:41:05.691727+00
9c5914ca-7b16-45fa-b1c1-bb9c54fae7fd	d8084811-1a21-4e12-af30-4fecb20d0454	a8cba1e0-8529-4470-84d9-8eab1b8069a3	2	2026-08-27 08:41:05.691727+00
7af4b3cd-e8b4-4eec-a274-31cad331c412	d8084811-1a21-4e12-af30-4fecb20d0454	658577fa-60ea-4de3-8856-d6c48fd93318	3	2026-08-27 08:41:05.691727+00
77268c37-07e6-418a-850e-325952f30297	d8084811-1a21-4e12-af30-4fecb20d0454	3287276f-5fb3-4da7-a719-0930f4cbbdcb	4	2026-08-27 08:41:05.691727+00
bdb5bd5a-9451-45c8-8759-de03d79aca5b	d8084811-1a21-4e12-af30-4fecb20d0454	d65954f5-7b8c-4577-9e61-874129e2c817	5	2026-08-27 08:41:05.691727+00
93393a01-2ec9-480f-9766-6070ecddcae8	d8084811-1a21-4e12-af30-4fecb20d0454	88fe49fb-a0fd-4577-87b1-e883358beeab	6	2026-08-27 08:41:05.691727+00
09b187b6-5f01-4309-b317-ce263b1873fc	d8084811-1a21-4e12-af30-4fecb20d0454	0828b5d6-ad80-4429-839e-454c140e61ad	7	2026-08-27 08:41:05.691727+00
45b733fe-3cf2-4a90-92b7-88009ff82d30	d8084811-1a21-4e12-af30-4fecb20d0454	9e2e83f0-9ade-4c72-9747-b7407db460c9	8	2026-08-27 08:41:05.691727+00
56df0c69-879c-4d4a-96a5-320dd17c175a	d8084811-1a21-4e12-af30-4fecb20d0454	20cbaef6-04de-4fdd-b08b-867b27a0a56c	9	2026-08-27 08:41:05.691727+00
55c57192-4479-406b-94b6-8c5356e18a85	d8084811-1a21-4e12-af30-4fecb20d0454	78b6d7e1-7a70-4fca-bcce-b7028520715e	10	2026-08-27 08:41:05.691727+00
3aa84e1c-25d2-49ef-b762-a3beadd68f54	d8084811-1a21-4e12-af30-4fecb20d0454	b95611f9-dfa6-42c0-80bd-c4b09760ac55	11	2026-08-27 08:41:05.691727+00
6b14b077-3add-4026-b9f2-e3a3a8d50f8d	d8084811-1a21-4e12-af30-4fecb20d0454	90b52e05-95d3-46cb-9327-89111adbc9ac	12	2026-08-27 08:41:05.691727+00
d471be35-d4bf-49aa-a342-585402dda20d	d8084811-1a21-4e12-af30-4fecb20d0454	2971df77-12bb-4af5-be82-2724073704fb	13	2026-08-27 08:41:05.691727+00
731ec274-ed50-437a-8954-e8f023ab4a7a	d8084811-1a21-4e12-af30-4fecb20d0454	98512ed8-34a5-40b1-a3fe-866bf086707f	14	2026-08-27 08:41:05.691727+00
19663d35-f29f-4a2f-bae9-071abccb9bf8	d8084811-1a21-4e12-af30-4fecb20d0454	63284e2d-6401-487e-98d1-40e2b516c4b0	15	2026-08-27 08:41:05.691727+00
32c1536d-046d-4a7b-a7ff-07741bd19219	d8084811-1a21-4e12-af30-4fecb20d0454	39b37cd2-bea1-4964-b0f7-a7a0c7716072	16	2026-08-27 08:41:05.691727+00
16b27bb2-384f-4f2e-ab93-82bced540343	d8084811-1a21-4e12-af30-4fecb20d0454	a9b3090b-22a3-4b8b-98a1-caa3ee2030ab	17	2026-08-27 08:41:05.691727+00
9bc4b470-47ac-4cd3-9816-0e1013beebaf	d8084811-1a21-4e12-af30-4fecb20d0454	88df7d98-a8dc-49e0-abcb-33a94a9d6979	18	2026-08-27 08:41:05.691727+00
59b26c1d-2c76-42e4-9197-2ff234a1252f	d8084811-1a21-4e12-af30-4fecb20d0454	2aab2211-9340-457b-9269-f636ced55ade	19	2026-08-27 08:41:05.691727+00
bb487bdc-3f68-4c2d-928b-bbbac06af6d7	d8084811-1a21-4e12-af30-4fecb20d0454	4258d672-5b1a-4cd8-acfd-3446bb65faee	20	2026-08-27 08:41:05.691727+00
31ebc6f8-18bf-49df-a194-6e1fe523d496	d8084811-1a21-4e12-af30-4fecb20d0454	6b459dd5-af78-4b66-83b9-497609da7999	21	2026-08-27 08:41:05.691727+00
f3a48960-7d1f-4c22-a14c-0c70a04b65cd	d8084811-1a21-4e12-af30-4fecb20d0454	274381cb-1efd-4384-b1ca-eaf6d794ca92	22	2026-08-27 08:41:05.691727+00
e36cbb4c-0a53-4b84-8034-5f18fb1cf4cd	d8084811-1a21-4e12-af30-4fecb20d0454	40fddec0-dd67-44b9-80cd-28525b5f2b62	23	2026-08-27 08:41:05.691727+00
ec76e60d-db89-4853-83fe-e972d23f2d82	d8084811-1a21-4e12-af30-4fecb20d0454	63fbcc85-e024-46e5-8657-cb7a7f2196cc	24	2026-08-27 08:41:05.691727+00
8be9bc71-45d3-4f1d-bebb-e77d29899eed	d8084811-1a21-4e12-af30-4fecb20d0454	276c6fc9-a6ce-499d-8f1f-c421523e94f7	25	2026-08-27 08:41:05.691727+00
cec1c460-2d61-430e-944c-4ea604e81c9e	d8084811-1a21-4e12-af30-4fecb20d0454	92af63e2-0f41-4f21-9bf3-277bcfef2a58	26	2026-08-27 08:41:05.691727+00
4e4f966d-962e-4f25-9c11-152bb47174f2	d8084811-1a21-4e12-af30-4fecb20d0454	0b29f3b2-fcf5-4cc8-a17a-367c0fb215ab	27	2026-08-27 08:41:05.691727+00
bc427c0b-849a-4218-8938-778dfa09f75f	d8084811-1a21-4e12-af30-4fecb20d0454	3f20154e-304b-4b6d-97a6-417458047572	28	2026-08-27 08:41:05.691727+00
e32c1750-cb96-403d-ba7a-6d47f592d9cf	d8084811-1a21-4e12-af30-4fecb20d0454	098430f3-284f-4195-b6b0-4a8519aeb056	29	2026-08-27 08:41:05.691727+00
7e2deaa6-2cc0-4f49-b14c-e5592d94d4d4	d8084811-1a21-4e12-af30-4fecb20d0454	f2ba63a4-fdd0-4d9f-a4c8-bdca593056bb	30	2026-08-27 08:41:05.691727+00
e7207247-e4db-4fcb-9d2f-344a94f56b7b	d8084811-1a21-4e12-af30-4fecb20d0454	c8675f39-7a86-4ceb-b426-26d53da8069f	31	2026-08-27 08:41:05.691727+00
6a610590-1895-4177-8109-0145f9d3dd56	d8084811-1a21-4e12-af30-4fecb20d0454	cd319fc2-df22-4ca4-b516-d6486bd02446	32	2026-08-27 08:41:05.691727+00
c77dad46-61d7-45d5-8d7e-e1eb77988296	d8084811-1a21-4e12-af30-4fecb20d0454	516d11a9-8c8a-4cb8-9e26-fbf90fce073c	33	2026-08-27 08:41:05.691727+00
0340f074-66a1-4b47-8d3c-7e7bdb07fc6e	d8084811-1a21-4e12-af30-4fecb20d0454	8f458442-6883-4939-8757-36ebc9e1c8d1	34	2026-08-27 08:41:05.691727+00
09a206c4-a737-41b7-9402-a35b90ecb0f7	d8084811-1a21-4e12-af30-4fecb20d0454	c0863bee-48c4-4177-bd28-7badff5eb5b3	35	2026-08-27 08:41:05.691727+00
72b28a65-fa9e-4626-b465-ecd924e8edef	d8084811-1a21-4e12-af30-4fecb20d0454	cba99fc6-23e8-4f43-a4d4-98b6fdd9f16c	36	2026-08-27 08:41:05.691727+00
eee53c2d-c728-4396-b31d-641a4c7da87e	d8084811-1a21-4e12-af30-4fecb20d0454	5687b1b2-a471-4981-a00b-d414e2ad576a	37	2026-08-27 08:41:05.691727+00
2948491e-3bbc-4f0e-9ba8-d444ec1757a3	d8084811-1a21-4e12-af30-4fecb20d0454	750326f2-9b7d-46d6-b8e7-36ceafef3327	38	2026-08-27 08:41:05.691727+00
d6d3fb5e-70e5-4cd4-a41e-e81966b34e44	d8084811-1a21-4e12-af30-4fecb20d0454	9e7b7237-a63b-4c96-af2b-5ec751464add	39	2026-08-27 08:41:05.691727+00
1205ba7f-5c9a-4d20-a221-390c554f722f	d8084811-1a21-4e12-af30-4fecb20d0454	40814471-6cc9-4c68-b7da-3cea22ec7852	40	2026-08-27 08:41:05.691727+00
8925f4d3-4910-4c42-af2c-965c47df7eb3	d8084811-1a21-4e12-af30-4fecb20d0454	97a78ce0-d46a-4c4a-993a-0e31117b9889	41	2026-08-27 08:41:05.691727+00
93aabfc3-a85b-455f-8fcc-cca994de0465	d8084811-1a21-4e12-af30-4fecb20d0454	2f9659dc-8ba8-449b-8542-32f1384a9259	42	2026-08-27 08:41:05.691727+00
3a11c3d5-7e55-49f3-bde6-f936e818cf45	d8084811-1a21-4e12-af30-4fecb20d0454	8f08828e-0907-4ffc-a453-674a865246ca	43	2026-08-27 08:41:05.691727+00
867b83ec-30a1-49e8-9b57-954ee1d79518	d8084811-1a21-4e12-af30-4fecb20d0454	f295bd3d-54be-4e35-a558-f6014bcf3e92	44	2026-08-27 08:41:05.691727+00
82f77e77-8b1b-45e5-9402-782d922b3d6f	d8084811-1a21-4e12-af30-4fecb20d0454	39157742-b715-4cdd-b7c7-9fa56c49dab3	45	2026-08-27 08:41:05.691727+00
d6fb3265-4bb2-46aa-a87a-bdda35bdbe06	d8084811-1a21-4e12-af30-4fecb20d0454	6daf01d5-808b-473b-8d4c-3f411993bd39	46	2026-08-27 08:41:05.691727+00
5c98b417-31f2-4aba-bc1b-9156da71acaa	d8084811-1a21-4e12-af30-4fecb20d0454	4f7dbe0e-0f4d-4842-8d51-6198873794ed	47	2026-08-27 08:41:05.691727+00
3bba32e0-43f0-465f-bad3-985a5fbce386	d8084811-1a21-4e12-af30-4fecb20d0454	e3a1fbc6-54d1-43cd-8178-e9e1b8afdc99	48	2026-08-27 08:41:05.691727+00
bc2e96e9-00f8-4946-a3bb-4d730f1d66dd	d8084811-1a21-4e12-af30-4fecb20d0454	bdccea58-dbb2-45d7-8098-93af35c1e9aa	49	2026-08-27 08:41:05.691727+00
1726fcbd-2145-4427-9d97-8e4b6544ed17	d8084811-1a21-4e12-af30-4fecb20d0454	5a1ce0f1-69f5-41dd-970a-d242468c9ca2	50	2026-08-27 08:41:05.691727+00
778e9946-9e83-4a87-a3f7-cec9beaae26a	4544ad3c-9162-4d42-bbd7-9490220778f2	d874fd84-8816-4652-8286-3b9eade75fb0	1	2026-08-27 08:41:05.691727+00
a0496ca2-c2f7-4fa8-b5d5-910806fbb638	4544ad3c-9162-4d42-bbd7-9490220778f2	23620be0-216d-49fd-a95a-12a91432b8f1	2	2026-08-27 08:41:05.691727+00
f4821d64-08e5-4b13-a062-03b5f5db00ad	4544ad3c-9162-4d42-bbd7-9490220778f2	7c194a8b-ae96-4d52-95ee-1b281520f229	3	2026-08-27 08:41:05.691727+00
b2f29ef5-0123-4851-8644-875195ff8f1c	4544ad3c-9162-4d42-bbd7-9490220778f2	5e6c94c4-1c45-4436-be6a-11ed55026572	4	2026-08-27 08:41:05.691727+00
093d8ec3-d26d-4253-9aff-5e25acc06cf0	4544ad3c-9162-4d42-bbd7-9490220778f2	7b556bd6-1b81-443f-8377-8429a7b28328	5	2026-08-27 08:41:05.691727+00
12842b2a-803c-4816-a08c-dbd6ad69d25d	4544ad3c-9162-4d42-bbd7-9490220778f2	947b90b5-bb98-470b-b812-a8bc0d39abd2	6	2026-08-27 08:41:05.691727+00
2c0a49b0-8dee-473d-8b11-be26adbbb153	4544ad3c-9162-4d42-bbd7-9490220778f2	b695c73f-6e7b-4cfb-9da6-db8c0971964d	7	2026-08-27 08:41:05.691727+00
fe7dffcf-ad8f-4c22-bc2e-a007f8b002f8	4544ad3c-9162-4d42-bbd7-9490220778f2	6e99eb44-6658-4df6-9aa6-8cc21809c107	8	2026-08-27 08:41:05.691727+00
ac393b4c-caa6-4cc6-9ddf-e67eef9aa8a8	4544ad3c-9162-4d42-bbd7-9490220778f2	c32e1e98-519a-482c-926b-c72c0ab29f44	9	2026-08-27 08:41:05.691727+00
e4beab16-cef0-4492-8872-352c19bdb355	4544ad3c-9162-4d42-bbd7-9490220778f2	0ef3199d-76a2-49d5-8e4c-6e6022d22bd9	10	2026-08-27 08:41:05.691727+00
81f34efa-ced9-4fef-ad24-13cd2d3a62c0	4544ad3c-9162-4d42-bbd7-9490220778f2	a0366ec1-9f1b-400b-a81f-b546f6d8c5f6	11	2026-08-27 08:41:05.691727+00
392ed3f1-588d-46be-97f2-537951f54861	4544ad3c-9162-4d42-bbd7-9490220778f2	af3e112b-89d4-4a40-b59a-30366d21d929	12	2026-08-27 08:41:05.691727+00
fec5ba24-80c7-438a-8fbf-bef05337e0e8	4544ad3c-9162-4d42-bbd7-9490220778f2	61274aff-b364-4f42-92ac-756c8ddec657	13	2026-08-27 08:41:05.691727+00
1de85145-d8cc-4d1e-874f-8e1cafe74139	4544ad3c-9162-4d42-bbd7-9490220778f2	a80f822a-4d0a-4c32-9b0f-2424dd0b122c	14	2026-08-27 08:41:05.691727+00
4c6899be-401a-4844-8f35-dd4fb49a0df1	4544ad3c-9162-4d42-bbd7-9490220778f2	47ff798c-ff24-4f08-bb34-b19b2b0cdbab	15	2026-08-27 08:41:05.691727+00
8b181843-9f8f-44ee-9324-297d08963e7d	4544ad3c-9162-4d42-bbd7-9490220778f2	bd7614e4-a885-4228-8c84-b754d3d25d05	16	2026-08-27 08:41:05.691727+00
81466653-873e-4eea-845b-9eb9607051b1	4544ad3c-9162-4d42-bbd7-9490220778f2	112a5663-1b05-476b-8d02-ad7873556855	17	2026-08-27 08:41:05.691727+00
faab8dcf-7c97-493b-a0eb-23acc91021e8	4544ad3c-9162-4d42-bbd7-9490220778f2	94555bdd-107a-477b-ad82-cd83cd0b297a	18	2026-08-27 08:41:05.691727+00
3d034bed-d9e3-4b82-9258-08bd8ae60169	4544ad3c-9162-4d42-bbd7-9490220778f2	282f0de2-636d-4d1d-b403-63e6dc699bf7	19	2026-08-27 08:41:05.691727+00
9fd96b85-235f-4f0e-8c44-851f680d3b54	4544ad3c-9162-4d42-bbd7-9490220778f2	9ffa97ce-178d-4c35-b6d4-0c2d19a5982d	20	2026-08-27 08:41:05.691727+00
265f416a-3f7d-4e09-b41e-a414460633d2	4544ad3c-9162-4d42-bbd7-9490220778f2	2f22001c-33ab-4b3f-be8e-6442574d10e5	21	2026-08-27 08:41:05.691727+00
0c96c8cd-5e43-4fbd-87f0-1ac0bfd1146e	4544ad3c-9162-4d42-bbd7-9490220778f2	e53475e2-17b9-430f-add2-29e936f9e468	22	2026-08-27 08:41:05.691727+00
b6905a94-0c9f-4907-9667-dc2c036880d5	4544ad3c-9162-4d42-bbd7-9490220778f2	0636649a-182f-4513-8c08-5c26c8e2cd84	23	2026-08-27 08:41:05.691727+00
f87690c2-9ded-4468-a6cd-bbb34481a992	4544ad3c-9162-4d42-bbd7-9490220778f2	697d1dd1-d575-4c92-a6f1-5c5377137e90	24	2026-08-27 08:41:05.691727+00
c9b4c169-e34a-4e11-a0e2-f1c9c6e2e1bf	4544ad3c-9162-4d42-bbd7-9490220778f2	61d7c96c-e134-4da4-a7f4-db46431afbd3	25	2026-08-27 08:41:05.691727+00
a98b701d-e65f-4db6-8f3f-9993143f9e2a	4544ad3c-9162-4d42-bbd7-9490220778f2	33d6191c-38b4-4071-8fa5-a9ab35d88482	26	2026-08-27 08:41:05.691727+00
d76c364d-5ef4-4afd-926a-cd3d8b17f929	4544ad3c-9162-4d42-bbd7-9490220778f2	99caaf32-0a53-42ba-81a7-023d393d6ffb	27	2026-08-27 08:41:05.691727+00
95b81462-580a-43dc-9e4d-54e98b5521d5	4544ad3c-9162-4d42-bbd7-9490220778f2	63305f4a-f44e-4455-803c-71b1e2740885	28	2026-08-27 08:41:05.691727+00
c66c533b-ac78-44b1-9158-7d94f681f667	4544ad3c-9162-4d42-bbd7-9490220778f2	3db94cf4-a596-41ba-876b-d42f50bc54d9	29	2026-08-27 08:41:05.691727+00
3d1c5c01-7bf4-43c5-a11f-4fe3956e5d84	4544ad3c-9162-4d42-bbd7-9490220778f2	becf0504-ff30-4b26-a177-24bcb4080d2a	30	2026-08-27 08:41:05.691727+00
dc97a123-c291-4d59-a81a-a63e860a4e24	4544ad3c-9162-4d42-bbd7-9490220778f2	275378b5-2f15-4ab4-a159-267d3cdd36b2	31	2026-08-27 08:41:05.691727+00
939beb8a-87f3-4bfb-8b24-fe0075e54eb1	4544ad3c-9162-4d42-bbd7-9490220778f2	5f2394d4-c62a-4c4b-b4fb-c737566953d3	32	2026-08-27 08:41:05.691727+00
32c3e148-d836-4d29-a83a-6b3be48bfeab	4544ad3c-9162-4d42-bbd7-9490220778f2	93883a56-c6d4-44a7-87a4-2eb637ac3ab4	33	2026-08-27 08:41:05.691727+00
61699bdf-8be3-43c2-beb9-4f9e6b9a76f5	4544ad3c-9162-4d42-bbd7-9490220778f2	4d35ae49-2dfc-4547-a4b2-2e73615135e8	34	2026-08-27 08:41:05.691727+00
e6d264c6-a8fa-4e26-b8f3-9d960cef5dd6	4544ad3c-9162-4d42-bbd7-9490220778f2	d220ba0a-fc77-4788-a253-7b8043f406a5	35	2026-08-27 08:41:05.691727+00
fb44c23b-716c-4672-8561-4a74f31b7e14	4544ad3c-9162-4d42-bbd7-9490220778f2	e877815b-338b-4189-8455-9ab50ce70073	36	2026-08-27 08:41:05.691727+00
779dd89b-ca8e-43ec-816a-0b8e813619cf	4544ad3c-9162-4d42-bbd7-9490220778f2	f39a2a45-f8ce-4a01-934b-34090eff9477	37	2026-08-27 08:41:05.691727+00
e3af7cb7-527f-4c66-814e-87f95e2fd44a	4544ad3c-9162-4d42-bbd7-9490220778f2	2f2fcc38-4061-4ea1-a1a1-17bd625b5aaa	38	2026-08-27 08:41:05.691727+00
38c6e44b-94a1-40c0-91cf-64fb6ac0345f	4544ad3c-9162-4d42-bbd7-9490220778f2	19aa1b1a-ca95-4964-b44b-d61e1a358b03	39	2026-08-27 08:41:05.691727+00
d6a6f687-0728-4a65-bc60-97a9a0f9081d	4544ad3c-9162-4d42-bbd7-9490220778f2	789fb8a7-780a-4644-bd33-a30c25647ade	40	2026-08-27 08:41:05.691727+00
89b66a56-5528-483f-b08e-366e5ce345c3	4544ad3c-9162-4d42-bbd7-9490220778f2	e83d6dda-5d89-4bf5-9c41-40bd215e368e	41	2026-08-27 08:41:05.691727+00
a5cc10ce-c184-41f4-bb6b-a169895be76f	4544ad3c-9162-4d42-bbd7-9490220778f2	be183797-cf21-4b64-a431-c91040c16c12	42	2026-08-27 08:41:05.691727+00
bf91b7f5-ac57-4330-a3e5-71f95457a49f	4544ad3c-9162-4d42-bbd7-9490220778f2	160a265f-94f8-4ff3-8cce-777f3082e108	43	2026-08-27 08:41:05.691727+00
a39602ac-2773-4579-81f5-91b20d5516f9	4544ad3c-9162-4d42-bbd7-9490220778f2	b9b32dd9-63e4-4629-868f-9a96a632a071	44	2026-08-27 08:41:05.691727+00
2584e5d3-28c8-4758-92a8-6c3353a7cc22	4544ad3c-9162-4d42-bbd7-9490220778f2	bf793459-34ac-42d2-bdf5-9ede7d6e16d9	45	2026-08-27 08:41:05.691727+00
97dc3dfe-ea83-4272-862f-3abdd405d2fd	4544ad3c-9162-4d42-bbd7-9490220778f2	fe642870-3949-4ce2-a93d-8e426681b992	46	2026-08-27 08:41:05.691727+00
7a8ed016-9d9f-4bda-bbf7-97c7ad5b48c8	4544ad3c-9162-4d42-bbd7-9490220778f2	e92894d4-4660-488f-b78b-871f5819c72b	47	2026-08-27 08:41:05.691727+00
37cc7b13-89d0-4a58-ab41-340ab1a68541	4544ad3c-9162-4d42-bbd7-9490220778f2	87f031a4-c8e0-4dc8-bcd7-52ed2484c932	48	2026-08-27 08:41:05.691727+00
79bcd341-a32b-469f-b1cf-1ff3d7822900	4544ad3c-9162-4d42-bbd7-9490220778f2	10a22f29-df5d-4a1e-a9ac-420c9f834b23	49	2026-08-27 08:41:05.691727+00
df2b905b-10a2-400b-aa15-a5499c60fed3	4544ad3c-9162-4d42-bbd7-9490220778f2	307367e6-d466-4a02-83ec-bdf12175b19e	50	2026-08-27 08:41:05.691727+00
d5fb9cfc-b3e4-4eb6-818c-d852f8970f5f	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	718e7f31-ef34-4c76-afb8-185a4892f629	1	2026-08-27 08:41:05.691727+00
bbde1e1e-9410-4aca-81a9-47d4a8b554a1	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0ee7a716-7bf3-4df5-9b27-736213cc6113	2	2026-08-27 08:41:05.691727+00
f768fb91-14b1-4e7f-b5ec-386ab1576f3a	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	7dd44e5b-72d8-4690-838a-d14411861fa2	3	2026-08-27 08:41:05.691727+00
04833fcd-c42b-4ddd-9d31-84debfe4ad77	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	b6d4fb95-3519-4670-94e6-38224f669768	4	2026-08-27 08:41:05.691727+00
487044c5-5e05-48f8-802a-53a267bb3ab5	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	b36033c9-9dca-4b1e-8a53-6ddc868fe267	5	2026-08-27 08:41:05.691727+00
9d9575bf-3697-4db1-9483-9bd9fca1eb48	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	bec1a89a-0662-4f2c-9022-37d4b1d91541	6	2026-08-27 08:41:05.691727+00
4461dea2-68d4-45b5-a7e8-b0f3bd2b9e59	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	aeafe5cc-e9f3-4e8e-8324-62c398c056a7	7	2026-08-27 08:41:05.691727+00
cf69aaa9-033a-44b5-9260-32ae3cf4d3be	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	68a48d71-e60b-4dad-ad6f-f58817d34f91	8	2026-08-27 08:41:05.691727+00
1b9fcd4e-f876-4acb-8932-629237c23463	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	894c0e16-7517-442b-9e13-2b5d21682b0a	9	2026-08-27 08:41:05.691727+00
13b7c095-6386-4642-ac32-4105c5143562	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	98c24c47-3378-4f48-95a2-1cede6ff7e7a	10	2026-08-27 08:41:05.691727+00
24ca2d61-6176-462e-8704-62f068a146dc	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	c1bb1ee8-6521-4313-8885-331c9cc44c91	11	2026-08-27 08:41:05.691727+00
1abb0b9d-27f7-4216-b96e-1402129c0edf	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	4767667f-aebb-4427-8b9c-5843c2064482	12	2026-08-27 08:41:05.691727+00
529bab12-a81c-4f01-aee3-62a6ff76bf73	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	afbc5fcd-f25c-47eb-ab6f-9a4d05895edd	13	2026-08-27 08:41:05.691727+00
bf720c94-6ef3-4532-a75e-5d0f1fe50e12	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	00ff9661-e0cd-4468-90f4-6b45a5383ab8	14	2026-08-27 08:41:05.691727+00
0718a729-4613-4047-9256-88f96f3a50be	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	ffaeef36-ab77-4450-9e5d-b95863f8629d	15	2026-08-27 08:41:05.691727+00
ed3e2cb1-2401-44fb-ba8f-0c3cead2fb89	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	7447f396-078f-4f2b-ba95-3c3a2cba8299	16	2026-08-27 08:41:05.691727+00
683f98a3-213c-4683-b84a-df5443ff45e4	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	b53d1ef9-acdb-4941-8b2f-60f5d74c5e80	17	2026-08-27 08:41:05.691727+00
46071237-4fac-4506-8ff8-b73d8263a9c5	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	338d08e1-96f8-4bca-8a17-7506c26d83e5	18	2026-08-27 08:41:05.691727+00
e1d82f3f-c53d-4983-b7c4-eb4e4c2ff73d	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	b2f351c0-5c41-4bfb-99b5-9e21065b2e1e	19	2026-08-27 08:41:05.691727+00
5f3caca6-b146-4839-bffe-22c0ba6f183a	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	b9cb07dc-e326-44bf-b193-e7e2f0f429ff	20	2026-08-27 08:41:05.691727+00
c4421ffc-e737-4825-ad5a-4487c25992fd	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	62dfd123-df55-4cbf-8e98-e1ed8eb9821d	21	2026-08-27 08:41:05.691727+00
69f1a8e5-c41d-4f96-8f6a-caa571b70624	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	795d3f41-eb15-4991-bf47-3c4225c55ca5	22	2026-08-27 08:41:05.691727+00
0db9d11c-07fd-4841-9af1-ee0e78551f81	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	618368ee-2db6-4e80-805c-c96a0f508b85	23	2026-08-27 08:41:05.691727+00
d3028b50-3e31-4158-bf5b-89f9bb594710	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	e1499fce-a0df-408c-a927-29d69a4bf4ec	24	2026-08-27 08:41:05.691727+00
057db794-9c03-46c7-aab8-cd36b562d645	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	1333b565-ca8f-4fe2-8474-595b8e438bc8	25	2026-08-27 08:41:05.691727+00
e7e1f812-016c-421e-8cfd-a8e794dfb92a	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	9b921879-cdaa-4fe7-99ad-21d213c0d97a	26	2026-08-27 08:41:05.691727+00
2633b916-bef3-47d7-8c97-3d94f8379c6d	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	31d98d9b-d867-4ae4-b4f2-afe1c767dd20	27	2026-08-27 08:41:05.691727+00
c2764921-38bd-4e24-ac05-fe7819bd32af	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0075b70c-a141-4afe-bbbb-366d51a89817	28	2026-08-27 08:41:05.691727+00
7db70c71-767e-4847-afeb-592480c9cd11	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	1159af98-9ea9-467f-9528-297e82772ad2	29	2026-08-27 08:41:05.691727+00
4c9dc7c7-88f5-455c-8068-7097d39d458b	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	1235dca4-55aa-4d04-aa36-65ffdcca7d80	30	2026-08-27 08:41:05.691727+00
c79ac671-fbcc-47cb-a46e-df98e428b0ef	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	795a3176-0cdd-47c1-901c-2d3f29ab234d	31	2026-08-27 08:41:05.691727+00
0e9b5a91-60ba-482b-bb82-f1b370708c12	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	6a665500-9958-4993-859a-328db4878b7e	32	2026-08-27 08:41:05.691727+00
7351e557-8d79-4765-80d1-fd4a2c8f6756	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	de50ea2e-20d7-4ab5-9434-87de411ee58d	33	2026-08-27 08:41:05.691727+00
9fde0a49-a16e-4c29-8d00-13d4ae030d9d	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	8803d7cd-920d-4675-8057-8dd46a82d0ae	34	2026-08-27 08:41:05.691727+00
0a53a7ba-7e70-4a43-adda-d5ee193d602c	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	f1ca4cad-34e0-4438-8042-a934b74effc7	35	2026-08-27 08:41:05.691727+00
a4457d0d-57e0-4e7f-9417-5b51d92cb84e	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	a3eb1923-e13d-4a35-bdb9-32738920f19b	36	2026-08-27 08:41:05.691727+00
0eaaf813-7a7d-4187-8269-795a0339ae47	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	eb3e9910-5262-4ce2-a583-1ae472166a5a	37	2026-08-27 08:41:05.691727+00
193d7d34-09da-4d97-8bf5-870c9d45e218	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	fc18abf7-051e-428f-ac2c-8e0932411521	38	2026-08-27 08:41:05.691727+00
90c01c0a-82f0-4195-a3d5-179233eed0c6	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	a39c9474-de6b-4d74-9f24-f45f205f84df	39	2026-08-27 08:41:05.691727+00
ea731fe1-64c7-43ef-b620-bd4cd4f13c67	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0a061be0-29a5-4f8e-b0d6-1bdd7748d14b	40	2026-08-27 08:41:05.691727+00
11fb4134-4922-4aa5-9e1d-ba4b00e091e0	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	a4571d13-2a48-4799-acb2-11f4373659a3	41	2026-08-27 08:41:05.691727+00
b2e482d4-67ee-49f2-a890-636e6d94a320	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	933e19ec-b593-4aec-b6bc-8461c5d777a2	42	2026-08-27 08:41:05.691727+00
6641703a-6a44-42bf-9f90-87a3d417555a	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	98bf1b4f-6d03-4213-aba1-3afd89e7c44f	43	2026-08-27 08:41:05.691727+00
a35c4967-6104-4759-b14a-333e31f8b243	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	da038768-e6c7-42c8-ad3e-a259ec5fa89e	44	2026-08-27 08:41:05.691727+00
264a7ebe-34c3-46ee-89b4-81cf191cc20c	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	66951142-f13d-4eff-affa-f6cb40610512	45	2026-08-27 08:41:05.691727+00
c386f383-afbe-435f-b707-992b921fdd0f	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	8f72b15a-157f-40a1-a7ec-44a7d8c52c33	46	2026-08-27 08:41:05.691727+00
476b093a-2114-40d1-86df-49d0f2f58299	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	d4376eab-c639-4f16-8f1f-b641678b5811	47	2026-08-27 08:41:05.691727+00
91b04545-2da9-4413-8f07-95a6e307ce79	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	44fe23ba-2b0a-4ea5-95a3-5c97b9503c77	48	2026-08-27 08:41:05.691727+00
1b696631-4a65-4566-84a3-04f0d06e608f	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	61885617-0849-4ab7-948f-ef3c492fa867	49	2026-08-27 08:41:05.691727+00
3cdee59d-d33b-4556-8f20-fd2829b60dd4	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	b07eaf9a-d117-4ee4-884b-49bb0020294c	50	2026-08-27 08:41:05.691727+00
5e5a7a60-786f-4b42-a221-3d5e0cf98d16	dc6365ab-35e3-4186-8631-14faffe07840	1f699e70-db3a-4c35-aafd-f1275ee33413	1	2026-08-27 08:41:05.691727+00
7454d12d-b813-45de-bb1f-7efc7a107c31	dc6365ab-35e3-4186-8631-14faffe07840	2a2693a6-3245-4eda-a7ba-44dd65a5ca62	2	2026-08-27 08:41:05.691727+00
7a116a87-38e5-4e1c-b763-3ca3d2b53305	dc6365ab-35e3-4186-8631-14faffe07840	f1efce00-8f4b-4b71-b931-bc669b097769	3	2026-08-27 08:41:05.691727+00
cb781680-61ec-4325-b0cf-9be4de31a1f3	dc6365ab-35e3-4186-8631-14faffe07840	01f329bc-9738-45e2-a793-55bac1b4c93d	4	2026-08-27 08:41:05.691727+00
f23bdd2f-022e-4680-9b0e-df56b380a632	dc6365ab-35e3-4186-8631-14faffe07840	d216b6e5-4cda-4b0b-87db-ee5fcee52bc6	5	2026-08-27 08:41:05.691727+00
62dc6526-b123-4498-b655-701574f2dd2a	dc6365ab-35e3-4186-8631-14faffe07840	84324e80-a6c6-43b7-9110-717aa7dfd54d	6	2026-08-27 08:41:05.691727+00
c1e3b880-9f7b-4ee1-92ae-cf1780989577	dc6365ab-35e3-4186-8631-14faffe07840	7aa05be2-ce64-429c-a9d5-17c8a20e0090	7	2026-08-27 08:41:05.691727+00
c127c0c0-ded4-4ca7-b40f-f1b46257840c	dc6365ab-35e3-4186-8631-14faffe07840	f519a0dd-fd04-49cf-ad19-cf56cf5045dc	8	2026-08-27 08:41:05.691727+00
a99b54a9-a7e8-433b-94a2-9cdaab963df1	dc6365ab-35e3-4186-8631-14faffe07840	41bece5e-7018-4191-a9aa-9afc340831eb	9	2026-08-27 08:41:05.691727+00
4bc9e3a7-6493-4bff-a702-68d798a9d22e	dc6365ab-35e3-4186-8631-14faffe07840	85fd2adb-7e29-4600-8954-9bdff1cd76a4	10	2026-08-27 08:41:05.691727+00
f0588d59-fc9d-4739-bde5-98690c43fd57	dc6365ab-35e3-4186-8631-14faffe07840	0d3d1eeb-7d8f-4662-9977-94864f4040c9	11	2026-08-27 08:41:05.691727+00
58c53399-7cdb-4ea0-ba44-6f7f200e6417	dc6365ab-35e3-4186-8631-14faffe07840	449df994-b364-434f-abeb-51a02023d79f	12	2026-08-27 08:41:05.691727+00
7949b36a-b889-4d8a-89ee-b5588f031636	dc6365ab-35e3-4186-8631-14faffe07840	a154c20e-ac2c-4c9b-a267-265c8bc17b17	13	2026-08-27 08:41:05.691727+00
72a2c630-4241-42dd-8157-61bee20267cf	dc6365ab-35e3-4186-8631-14faffe07840	d69919b3-9d08-49b1-982a-b777d37bc6bf	14	2026-08-27 08:41:05.691727+00
70b2aac0-7323-4997-8aa5-40b9e5917fb1	dc6365ab-35e3-4186-8631-14faffe07840	c14e9586-5eea-42a6-a951-aca55ce75b68	15	2026-08-27 08:41:05.691727+00
ef7a944b-9d95-4be9-ab8f-4d8f9034bec6	dc6365ab-35e3-4186-8631-14faffe07840	02a47202-943f-4d7e-87b1-82476549a2d0	16	2026-08-27 08:41:05.691727+00
5da070c9-e56a-424f-88a1-4a6f6911e92c	dc6365ab-35e3-4186-8631-14faffe07840	3759f68d-fa81-475f-984c-e072d932ef86	17	2026-08-27 08:41:05.691727+00
90f96fca-2f81-41e3-bce2-12f40fe7e55a	dc6365ab-35e3-4186-8631-14faffe07840	69bd9912-cc2d-4359-9e0e-96c45f2a2dff	18	2026-08-27 08:41:05.691727+00
2ad10b0f-3fea-4358-a788-c97606381adf	dc6365ab-35e3-4186-8631-14faffe07840	d9f16d2a-32cb-4fe4-8458-6babcfc24f92	19	2026-08-27 08:41:05.691727+00
b5c7f7cc-c0c7-44f7-a33b-6f77fec52f6d	dc6365ab-35e3-4186-8631-14faffe07840	05c23db6-3fbc-442c-997b-a9d191581523	20	2026-08-27 08:41:05.691727+00
3f95e303-b9da-4a4f-97ba-a7ba26d57e07	dc6365ab-35e3-4186-8631-14faffe07840	3afe1a9d-4d26-4000-bc1b-51133a302f66	21	2026-08-27 08:41:05.691727+00
e149092e-9b0b-4115-8028-5b52f8b59884	dc6365ab-35e3-4186-8631-14faffe07840	80310cf0-3dac-418d-846f-664b177ae74e	22	2026-08-27 08:41:05.691727+00
19c5e274-0fb2-407c-9d5d-af2a280a7ac1	dc6365ab-35e3-4186-8631-14faffe07840	da565975-12e3-46ed-8bd9-2707a52994d0	23	2026-08-27 08:41:05.691727+00
fcc81113-2efd-474f-9136-fe46184ac713	dc6365ab-35e3-4186-8631-14faffe07840	0b07005f-2713-4ab0-9c58-8d48bedbe118	24	2026-08-27 08:41:05.691727+00
99caabf6-8757-4f49-a868-9b068a88833b	dc6365ab-35e3-4186-8631-14faffe07840	d2754d31-7f22-491d-a744-97d107a58206	25	2026-08-27 08:41:05.691727+00
f75a76ff-cc93-4119-90a9-15b8709225db	dc6365ab-35e3-4186-8631-14faffe07840	e9d55130-9b49-4ed6-860c-9648b790a309	26	2026-08-27 08:41:05.691727+00
17f24995-dc27-48fd-95d8-aee033b5fd5f	dc6365ab-35e3-4186-8631-14faffe07840	1cb593e7-b238-46e7-8640-41efd6e572a7	27	2026-08-27 08:41:05.691727+00
9d836982-f50b-495a-a14e-2d236f359dee	dc6365ab-35e3-4186-8631-14faffe07840	aab37b88-ea4a-445a-8e91-0fbe809eea80	28	2026-08-27 08:41:05.691727+00
b410d329-0e68-4187-a1b3-a90c8fd74904	dc6365ab-35e3-4186-8631-14faffe07840	9f0d50e3-95ef-4f6d-9f06-3e7c941f9a55	29	2026-08-27 08:41:05.691727+00
41254679-8f00-43bf-828c-b2d9630b443b	dc6365ab-35e3-4186-8631-14faffe07840	42b35a2c-82ad-4261-a23d-eb309b1102d8	30	2026-08-27 08:41:05.691727+00
aa04633f-4ced-4ac0-9e32-34cbecbe6808	dc6365ab-35e3-4186-8631-14faffe07840	dea6782e-a1a2-4507-a5f6-28b44adea81c	31	2026-08-27 08:41:05.691727+00
f991218f-2627-4741-8277-54a1d8186bd1	dc6365ab-35e3-4186-8631-14faffe07840	b96e6c5a-fb1d-40ae-b4df-536df551a675	32	2026-08-27 08:41:05.691727+00
959bcbb4-211e-405b-add0-11ddc6d31322	dc6365ab-35e3-4186-8631-14faffe07840	e4e4e355-5dc1-4e43-9a24-60c968845ed6	33	2026-08-27 08:41:05.691727+00
2d62a3df-182a-4e67-a49a-354a3fba56a4	dc6365ab-35e3-4186-8631-14faffe07840	feddce35-0aa8-4e17-a0f1-79ef4778e2f3	34	2026-08-27 08:41:05.691727+00
35f7f963-dd41-456a-b7a8-9c99b9115e00	dc6365ab-35e3-4186-8631-14faffe07840	b82dee4e-1452-42b6-bc65-b31e9237555b	35	2026-08-27 08:41:05.691727+00
28b08edf-43b6-4958-8e5b-7ecb821b4b13	dc6365ab-35e3-4186-8631-14faffe07840	a8e99c3e-4cda-4932-9679-7491977a2aab	36	2026-08-27 08:41:05.691727+00
0f990abb-333f-4b7e-ab6a-5d69c3fe0c40	dc6365ab-35e3-4186-8631-14faffe07840	1b10c6ea-dd08-44cb-9f21-5d6487feb6b8	37	2026-08-27 08:41:05.691727+00
0a92ec0f-86c1-401e-8897-10a700999454	dc6365ab-35e3-4186-8631-14faffe07840	fd6126a1-33a0-418c-9845-717b18ac5614	38	2026-08-27 08:41:05.691727+00
5fb3929d-15ee-499b-8d35-3c73977522a8	dc6365ab-35e3-4186-8631-14faffe07840	e7fe4ff2-0545-4d40-9dfe-10866fda3a08	39	2026-08-27 08:41:05.691727+00
bcf9aee0-eda1-4c01-b1c0-9d51e731a023	dc6365ab-35e3-4186-8631-14faffe07840	43d2aa04-f535-43e7-ad9b-eb89bada3899	40	2026-08-27 08:41:05.691727+00
fcbf14a3-4760-427b-a484-6ea7d972bf69	dc6365ab-35e3-4186-8631-14faffe07840	800c6667-7c18-479a-bc6a-1ecf92332133	41	2026-08-27 08:41:05.691727+00
174fa078-ab6a-4fd9-8b75-39a46e5ec58a	dc6365ab-35e3-4186-8631-14faffe07840	c0d43e2c-fc10-4cde-8b0e-e4bb6c465a03	42	2026-08-27 08:41:05.691727+00
723654bd-7d31-45e8-aa6a-9f753b41d809	dc6365ab-35e3-4186-8631-14faffe07840	67cd62c9-ee36-46c1-9e62-bd19144307b9	43	2026-08-27 08:41:05.691727+00
c4979c21-fb99-4949-adb6-c9bb57ff694f	dc6365ab-35e3-4186-8631-14faffe07840	94115216-7cd1-4fba-b659-9fac56268caf	44	2026-08-27 08:41:05.691727+00
1ac6f574-60b6-4dfb-a28b-3af13d0f9456	dc6365ab-35e3-4186-8631-14faffe07840	3a9a94a7-4485-4e8a-9bc2-da0dbd919745	45	2026-08-27 08:41:05.691727+00
5adc5c31-3e97-4a7e-8a39-6dc529ab4c5e	dc6365ab-35e3-4186-8631-14faffe07840	72d87f01-c4c8-4b10-93c1-d85a8bb9a376	46	2026-08-27 08:41:05.691727+00
8f5e23e9-495d-4f1b-bfba-6dffe9ae3949	dc6365ab-35e3-4186-8631-14faffe07840	917824ad-a2ad-4a71-8362-9800c11f2195	47	2026-08-27 08:41:05.691727+00
de14b27b-472b-4dad-905e-10c5785c92b0	dc6365ab-35e3-4186-8631-14faffe07840	8af020b8-2080-4042-b34f-94bedb9c81ae	48	2026-08-27 08:41:05.691727+00
7e6d315b-33a8-4d3c-9701-fad7ed0651d5	dc6365ab-35e3-4186-8631-14faffe07840	cc45a1f5-a62b-45b1-b4ae-bd2a5f5f7553	49	2026-08-27 08:41:05.691727+00
db1b798c-032a-41eb-a4a0-5917985d943b	dc6365ab-35e3-4186-8631-14faffe07840	7b8090a5-e005-4e1a-ac67-ae77218f6daa	50	2026-08-27 08:41:05.691727+00
\.


--
-- TOC entry 5065 (class 0 OID 17545)
-- Dependencies: 353
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.exams (id, title, description, subject_id, duration_minutes, total_marks, is_published, created_by, created_at, passing_marks, negative_marking, start_date, end_date, status, shuffle_questions, shuffle_options, allow_review, proctoring_enabled, fullscreen_required, max_tab_switches, attempt_limit, updated_at, instructions, is_active, webcam_required, camera_denied_action, seed_key) FROM stdin;
e33a8358-2129-4c48-bc70-5f61d53db42f	Algebra Fundamentals - Demo	Sample quiz included with the project.	fbff0f41-fe5f-42e7-aafa-d85df02568e0	10	5.00	f	\N	2026-08-18 05:57:42.719806+00	2.00	f	\N	\N	archived	f	f	t	f	f	3	1	2026-08-27 08:41:05.691727+00	\N	f	f	warn	\N
d629708f-e6ba-4765-a561-016a3eb2662b	Mathematics - Comprehensive Test	A 50-question demo paper spanning algebra, calculus, trigonometry, geometry, and probability.	fbff0f41-fe5f-42e7-aafa-d85df02568e0	60	50.00	t	\N	2026-08-27 08:41:05.691727+00	20.00	f	\N	\N	published	t	t	t	f	f	3	3	2026-08-27 08:41:05.691727+00	Demo comprehensive exam seeded from Supabase SQL content.	t	f	warn	demo:exam:mathematics
41e8530f-95df-4b05-8756-70e2a5d3c930	Physics - Comprehensive Test	A 50-question demo paper covering mechanics, thermodynamics, optics, electromagnetism, and modern physics.	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	60	50.00	t	\N	2026-08-27 08:41:05.691727+00	20.00	f	\N	\N	published	t	t	t	f	f	3	3	2026-08-27 08:41:05.691727+00	Demo comprehensive exam seeded from Supabase SQL content.	t	f	warn	demo:exam:physics
4282a1ae-5f73-41f8-b4fb-af33942add78	Chemistry - Comprehensive Test	A 50-question demo paper across physical, organic, inorganic, atomic, and bonding topics.	9481ac62-4ea8-48a2-8776-33ed020858bb	60	50.00	t	\N	2026-08-27 08:41:05.691727+00	20.00	f	\N	\N	published	t	t	t	f	f	3	3	2026-08-27 08:41:05.691727+00	Demo comprehensive exam seeded from Supabase SQL content.	t	f	warn	demo:exam:chemistry
222121d7-4b4e-4007-bf5e-3fb8a5400450	Biology - Comprehensive Test	A 50-question demo paper across cell biology, genetics, physiology, ecology, and evolution.	bdc56824-3354-4558-963e-94033af7162c	60	50.00	t	\N	2026-08-27 08:41:05.691727+00	20.00	f	\N	\N	published	t	t	t	f	f	3	3	2026-08-27 08:41:05.691727+00	Demo comprehensive exam seeded from Supabase SQL content.	t	f	warn	demo:exam:biology
b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	Computer Science - Comprehensive Test	A 50-question demo paper on programming, networks, software engineering, architecture, and security.	0516b2da-3ff8-4945-9c83-6850a4573fee	60	50.00	t	\N	2026-08-27 08:41:05.691727+00	20.00	f	\N	\N	published	t	t	t	f	f	3	3	2026-08-27 08:41:05.691727+00	Demo comprehensive exam seeded from Supabase SQL content.	t	f	warn	demo:exam:computer_science
aad02091-b53f-4632-b423-0b555ce5064c	Data Structures and Algorithms - Comprehensive Test	A 50-question demo paper on arrays, linked lists, stacks, trees, searching, and sorting.	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	60	50.00	t	\N	2026-08-27 08:41:05.691727+00	20.00	f	\N	\N	published	t	t	t	f	f	3	3	2026-08-27 08:41:05.691727+00	Demo comprehensive exam seeded from Supabase SQL content.	t	f	warn	demo:exam:data_structures_and_algorithms
d8084811-1a21-4e12-af30-4fecb20d0454	Database Management Systems - Comprehensive Test	A 50-question demo paper on SQL, normalization, transactions, ER modeling, and indexing.	0e626538-e950-4f50-a32e-ff8c38cb505f	60	50.00	t	\N	2026-08-27 08:41:05.691727+00	20.00	f	\N	\N	published	t	t	t	f	f	3	3	2026-08-27 08:41:05.691727+00	Demo comprehensive exam seeded from Supabase SQL content.	t	f	warn	demo:exam:database_management_systems
4544ad3c-9162-4d42-bbd7-9490220778f2	Operating Systems - Comprehensive Test	A 50-question demo paper on processes, scheduling, deadlocks, memory, and file systems.	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	60	50.00	t	\N	2026-08-27 08:41:05.691727+00	20.00	f	\N	\N	published	t	t	t	f	f	3	3	2026-08-27 08:41:05.691727+00	Demo comprehensive exam seeded from Supabase SQL content.	t	f	warn	demo:exam:operating_systems
3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	Aptitude and Reasoning - Comprehensive Test	A 50-question demo paper on quantitative aptitude, logic, verbal reasoning, DI, and number series.	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	60	50.00	t	\N	2026-08-27 08:41:05.691727+00	20.00	f	\N	\N	published	t	t	t	f	f	3	3	2026-08-27 08:41:05.691727+00	Demo comprehensive exam seeded from Supabase SQL content.	t	f	warn	demo:exam:aptitude_and_reasoning
dc6365ab-35e3-4186-8631-14faffe07840	English - Comprehensive Test	A 50-question demo paper on grammar, vocabulary, reading, correction, and word meaning.	1f77c53e-73f4-40e1-bf17-3d005994b9b4	60	50.00	t	\N	2026-08-27 08:41:05.691727+00	20.00	f	\N	\N	published	t	t	t	f	f	3	3	2026-08-27 08:41:05.691727+00	Demo comprehensive exam seeded from Supabase SQL content.	t	f	warn	demo:exam:english
\.


--
-- TOC entry 5085 (class 0 OID 18274)
-- Dependencies: 373
-- Data for Name: leaderboard_snapshots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.leaderboard_snapshots (id, user_id, scope, period_key, rank, metric_value, created_at) FROM stdin;
26a544a0-b6dc-4f8c-868c-1ba9ebeef661	97ad6c7c-6f13-4266-8241-a72deab8f86a	global	all-time	1	235.00	2026-08-28 11:20:34.779048+00
\.


--
-- TOC entry 5083 (class 0 OID 18226)
-- Dependencies: 371
-- Data for Name: levels; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.levels (level_number, name, xp_required, created_at) FROM stdin;
1	Starter	0	2026-08-25 07:42:30.041952+00
2	Explorer	200	2026-08-25 07:42:30.041952+00
3	Scholar	500	2026-08-25 07:42:30.041952+00
4	Achiever	1000	2026-08-25 07:42:30.041952+00
5	Expert	1800	2026-08-25 07:42:30.041952+00
6	Master	3000	2026-08-25 07:42:30.041952+00
7	Champion	5000	2026-08-25 07:42:30.041952+00
8	Legend	8000	2026-08-25 07:42:30.041952+00
\.


--
-- TOC entry 5089 (class 0 OID 18493)
-- Dependencies: 377
-- Data for Name: multiplayer_answers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.multiplayer_answers (id, room_id, participant_id, room_question_id, selected_answer, answered_at, response_time_ms, is_correct, score_earned) FROM stdin;
\.


--
-- TOC entry 5087 (class 0 OID 18447)
-- Dependencies: 375
-- Data for Name: multiplayer_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.multiplayer_participants (id, room_id, user_id, is_ready, score, correct_count, joined_at, last_seen_at, left_at) FROM stdin;
24710df9-6875-444f-a905-6cc10b0dac5b	55ca45e3-c0d8-412d-8648-308fb891e321	97ad6c7c-6f13-4266-8241-a72deab8f86a	t	0	0	2026-08-27 08:42:29.876416+00	2026-08-27 08:42:29.876416+00	\N
d2f44412-28bb-4ed3-a614-53c76718d740	ba4eb79d-5833-475a-8fe9-5cd7945dcaea	97ad6c7c-6f13-4266-8241-a72deab8f86a	t	0	0	2026-09-02 06:31:35.972637+00	2026-09-02 06:31:35.972637+00	\N
\.


--
-- TOC entry 5090 (class 0 OID 18520)
-- Dependencies: 378
-- Data for Name: multiplayer_results; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.multiplayer_results (id, room_id, participant_id, user_id, rank, score, correct_count, question_count, accuracy, average_response_ms, xp_awarded, created_at) FROM stdin;
\.


--
-- TOC entry 5088 (class 0 OID 18472)
-- Dependencies: 376
-- Data for Name: multiplayer_room_questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.multiplayer_room_questions (id, room_id, question_id, "position") FROM stdin;
36721e63-465b-4900-b98d-6a20b00e9df5	55ca45e3-c0d8-412d-8648-308fb891e321	f9931577-8614-454f-8bdf-b7c2ddb98ea9	0
8883637a-365c-41cf-8ee9-7482603dbac4	55ca45e3-c0d8-412d-8648-308fb891e321	df4889e9-77e4-425b-ae62-9d2baaff35a1	1
9bb43672-6231-40e5-ad7e-dcaa730b58c6	55ca45e3-c0d8-412d-8648-308fb891e321	097fd1d4-6f02-4169-884c-bc6dbf6a6171	2
572cf8d9-2700-4654-8c14-398a84eaba6e	55ca45e3-c0d8-412d-8648-308fb891e321	d9676b4a-3fdd-496c-932d-f1f81217bd05	3
ca7348f9-72d5-4bd0-9380-3a319a787d38	55ca45e3-c0d8-412d-8648-308fb891e321	6a79a6ee-bae1-45c0-8494-a775721699fd	4
4f4c14f5-adc4-466a-ab24-3f4a32d2ebc6	55ca45e3-c0d8-412d-8648-308fb891e321	0b89b1a1-9732-4f0b-9fd2-2fcb02b3411a	5
30711941-fc12-4624-a0ee-d9801e2153af	55ca45e3-c0d8-412d-8648-308fb891e321	8a4f935c-8e71-46a4-9627-089a3633f440	6
7f30dfa6-1f6d-4920-81ab-61308436a83c	55ca45e3-c0d8-412d-8648-308fb891e321	8882b642-064b-47de-9ff1-db2aea9432c5	7
b184b55b-85a1-4e2d-8124-ceadea9e74ee	55ca45e3-c0d8-412d-8648-308fb891e321	67cea1bf-d023-4541-a5d4-59995de2be39	8
5637e5bb-da05-44c2-a121-4a6e86784098	55ca45e3-c0d8-412d-8648-308fb891e321	ec994a23-a617-4c4e-a2e3-6b891cf76c33	9
cbc34152-fd1f-42a0-9085-aba13be3ed03	ba4eb79d-5833-475a-8fe9-5cd7945dcaea	7447f396-078f-4f2b-ba95-3c3a2cba8299	0
8aea8232-451e-482d-99c3-06d2f9f13f69	ba4eb79d-5833-475a-8fe9-5cd7945dcaea	b9cb07dc-e326-44bf-b193-e7e2f0f429ff	1
eb1637fe-d173-40cd-8505-a0e889ca86e5	ba4eb79d-5833-475a-8fe9-5cd7945dcaea	b53d1ef9-acdb-4941-8b2f-60f5d74c5e80	2
6d4d13ec-c761-49eb-9a63-4ad4ecec8584	ba4eb79d-5833-475a-8fe9-5cd7945dcaea	00ff9661-e0cd-4468-90f4-6b45a5383ab8	3
642c8650-b321-423c-a7bd-d092eba35552	ba4eb79d-5833-475a-8fe9-5cd7945dcaea	c1bb1ee8-6521-4313-8885-331c9cc44c91	4
bcd31133-ed70-4b99-81a5-994e936071e1	ba4eb79d-5833-475a-8fe9-5cd7945dcaea	ffaeef36-ab77-4450-9e5d-b95863f8629d	5
2381babe-0f66-4be6-881e-2f068485fe6d	ba4eb79d-5833-475a-8fe9-5cd7945dcaea	338d08e1-96f8-4bca-8a17-7506c26d83e5	6
9bf349da-9f44-46c0-a292-16594b72aeed	ba4eb79d-5833-475a-8fe9-5cd7945dcaea	b2f351c0-5c41-4bfb-99b5-9e21065b2e1e	7
2473ca4e-f7c7-4a06-b704-21e50faa6ab4	ba4eb79d-5833-475a-8fe9-5cd7945dcaea	afbc5fcd-f25c-47eb-ab6f-9a4d05895edd	8
a8a84afd-97f6-46db-93b9-6a3899143a24	ba4eb79d-5833-475a-8fe9-5cd7945dcaea	4767667f-aebb-4427-8b9c-5843c2064482	9
\.


--
-- TOC entry 5086 (class 0 OID 18405)
-- Dependencies: 374
-- Data for Name: multiplayer_rooms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.multiplayer_rooms (id, room_code, name, host_id, subject_id, topic_id, exam_id, difficulty, question_count, question_time_seconds, max_players, is_public, status, phase, current_question_index, starts_at, question_started_at, question_ends_at, reveal_ends_at, started_at, finished_at, closed_at, expires_at, created_at, updated_at) FROM stdin;
55ca45e3-c0d8-412d-8648-308fb891e321	JRBA57	Study showdown	97ad6c7c-6f13-4266-8241-a72deab8f86a	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	medium	10	30	8	t	open	lobby	-1	\N	\N	\N	\N	\N	\N	\N	2026-08-27 10:42:29.818137+00	2026-08-27 08:42:29.818137+00	2026-08-27 08:42:29.818137+00
ba4eb79d-5833-475a-8fe9-5cd7945dcaea	M3ZMY8	Study showdown	97ad6c7c-6f13-4266-8241-a72deab8f86a	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	0045e312-20fa-4ddf-ae9b-3f545fd19050	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	\N	10	30	6	t	open	lobby	-1	\N	\N	\N	\N	\N	\N	\N	2026-09-02 08:31:35.903586+00	2026-09-02 06:31:35.903586+00	2026-09-02 06:31:35.903586+00
\.


--
-- TOC entry 5075 (class 0 OID 17811)
-- Dependencies: 363
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, user_id, title, message, type, is_read, link_url, created_at, link, event_key) FROM stdin;
147d60bb-fe15-4ae2-b7a5-1d1c4782b200	97ad6c7c-6f13-4266-8241-a72deab8f86a	Revision task due	Review concepts and solve practice questions	revision_task	f	\N	2026-08-27 05:46:02.009412+00	/app/revision-plan	revision:5e45de23-5d1e-4f0a-b5e8-4cc81b8c5f40:2026-08-27
6cd98b76-81e1-4428-b732-b675020f67aa	97ad6c7c-6f13-4266-8241-a72deab8f86a	Revision task due	Review concepts and solve 15 practice questions	revision_task	f	\N	2026-08-27 09:28:05.60074+00	/app/revision-plan	revision:c64c307f-fa3f-4ce9-a3d5-800adf0cfbf9:2026-08-27
24bf18b1-f0eb-4d0c-89e9-3d496f9bde96	97ad6c7c-6f13-4266-8241-a72deab8f86a	Badge earned	Getting Started: Complete your first quiz	badge_earned	f	\N	2026-08-27 09:29:48.642224+00	/app/achievements	badge:88f2e7e6-1359-45c0-92c3-23fd74769ada
81399016-7f8f-4347-bd61-158901b4d9ac	97ad6c7c-6f13-4266-8241-a72deab8f86a	Badge earned	First Quiz: Complete your first quiz.	badge_earned	f	\N	2026-08-27 09:29:48.642224+00	/app/achievements	badge:e1cf76f1-f1ae-464f-a4ba-ece64deb6bfd
74dad7dc-a7ea-412a-82b3-3736ee21371e	97ad6c7c-6f13-4266-8241-a72deab8f86a	Badge earned	Top 10: Reach the global leaderboard top ten.	badge_earned	f	\N	2026-08-27 09:29:48.642224+00	/app/achievements	badge:5e746f2d-1545-4e44-ad2f-2d0e0266ea1b
67f24f60-744e-4fd0-ac0c-b096c6af06c1	97ad6c7c-6f13-4266-8241-a72deab8f86a	Badge earned	Rising Learner: Earn 500 XP	badge_earned	f	\N	2026-08-27 09:29:48.642224+00	/app/achievements	badge:84c5ce19-e0e5-4e96-8902-fe49aecef08c
b7310c6d-5d80-43a7-a540-4eb00605f53c	97ad6c7c-6f13-4266-8241-a72deab8f86a	Revision task due	Review concepts and solve 15 practice questions	revision_task	f	\N	2026-08-28 05:10:15.514347+00	/app/revision-plan	revision:b58b28e7-3e3e-4fcf-be59-88ad43a79c1e:2026-08-28
782e377c-fa91-41e1-9afd-2dbd904075d7	97ad6c7c-6f13-4266-8241-a72deab8f86a	Adaptive practice update	Review this topic’s fundamentals before your next session.	adaptive_recommendation	f	\N	2026-08-28 06:07:50.550379+00	/app/adaptive	adaptive:48ccf295-8848-44e9-b47b-b35f28243097
b8e11b0d-8b57-4e00-b662-cb4931e2ad88	97ad6c7c-6f13-4266-8241-a72deab8f86a	Revision task due	Relearn core concepts, make short notes, then solve 20-25 questions	revision_task	f	\N	2026-08-28 06:12:36.264854+00	/app/revision-plan	revision:95b0d3ed-675f-46d7-a2d2-7ecf7e9df14c:2026-08-28
2966be18-b7db-4600-95c5-682a33901d75	97ad6c7c-6f13-4266-8241-a72deab8f86a	Level up!	You reached Level 2.	level_up	f	\N	2026-08-28 11:20:34.779048+00	/app/achievements	level:2
983e9887-1bc0-4881-a25b-fcd258d10cc2	97ad6c7c-6f13-4266-8241-a72deab8f86a	Revision task due	Relearn core concepts, make short notes, then solve 20-25 questions	revision_task	f	\N	2026-08-31 05:38:32.175206+00	/app/revision-plan	revision:d845917b-c69b-48e1-a48a-e91818476ba3:2026-08-31
a0ececa6-7792-4bee-bbed-792e3a299b95	97ad6c7c-6f13-4266-8241-a72deab8f86a	Revision task due	Relearn core concepts, make short notes, then solve 20-25 questions	revision_task	f	\N	2026-09-02 06:25:41.209067+00	/app/revision-plan	revision:a73bacd0-e2fc-4538-b1bf-8abb8e9a5ddc:2026-09-02
049a712c-87ad-4651-b726-41191aca118c	97ad6c7c-6f13-4266-8241-a72deab8f86a	Revision task due	Relearn core concepts, make short notes, then solve 20-25 questions	revision_task	f	\N	2026-09-02 06:29:01.916416+00	/app/revision-plan	revision:56651b4d-7a2a-49d9-8d43-9270c6ae76e8:2026-09-02
\.


--
-- TOC entry 5069 (class 0 OID 17642)
-- Dependencies: 357
-- Data for Name: performance_metrics; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.performance_metrics (id, user_id, topic_id, attempted, correct, accuracy, total_time_seconds, updated_at) FROM stdin;
f72dfb32-2459-45a9-8d67-24cac68a5432	97ad6c7c-6f13-4266-8241-a72deab8f86a	965b5429-8685-4cc9-a7be-42858adcd165	10	4	40.00	17	2026-08-28 11:20:34.779048+00
3ceab99e-6528-4ac1-85e4-04a05e40f978	97ad6c7c-6f13-4266-8241-a72deab8f86a	6985fef8-92cf-47a8-aad8-88754030af2c	10	3	30.00	15	2026-08-28 11:20:34.779048+00
a1d0df2f-94e3-4833-953b-65a6f7445e2a	97ad6c7c-6f13-4266-8241-a72deab8f86a	68d8f6be-90c5-4893-84f0-afe6b5270631	9	2	22.22	19	2026-08-28 11:20:34.779048+00
a6441fce-5532-4f10-8b3f-3f0cac429a15	97ad6c7c-6f13-4266-8241-a72deab8f86a	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	10	1	10.00	11	2026-08-28 11:20:34.779048+00
dff2bbaf-e079-46b0-a7cb-92b0149840f9	97ad6c7c-6f13-4266-8241-a72deab8f86a	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	10	2	20.00	17	2026-08-28 11:20:34.779048+00
22e0bbd3-d83c-47ad-82e6-2e156829562b	ce0fb583-4c15-43a5-b8af-e2b941589f86	f42d3697-419c-4a1a-b588-5fd632ec965e	5	5	100.00	70	2026-09-03 03:33:54.713+00
1729daaa-0e75-4993-9590-12049761f6b1	ce0fb583-4c15-43a5-b8af-e2b941589f86	a3626561-314a-4325-8a8c-4a42863d9d48	5	5	100.00	59	2026-09-03 03:33:55.324+00
554f5f31-e37b-4ffc-9962-711fddf3be24	ce0fb583-4c15-43a5-b8af-e2b941589f86	69e0c2b4-1f30-49a0-914f-fd15a6840341	4	4	100.00	30	2026-09-03 03:33:55.733+00
012bb73f-d601-490d-b2f6-a2e73ea50c88	ce0fb583-4c15-43a5-b8af-e2b941589f86	d37077ae-8a72-4f2d-b230-22feaff498d6	3	3	100.00	22	2026-09-03 03:33:56.148+00
ef2ac00f-43c5-44f3-a08a-e6f63f44521d	ce0fb583-4c15-43a5-b8af-e2b941589f86	df2d8bd4-d592-4357-ae3c-4c0d976a4e53	3	0	0.00	27	2026-09-03 03:33:56.552+00
\.


--
-- TOC entry 5077 (class 0 OID 18060)
-- Dependencies: 365
-- Data for Name: performance_predictions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.performance_predictions (id, user_id, predicted_score, confidence, trend, risk_level, feature_snapshot, actual_score, prediction_error, created_at) FROM stdin;
4777f685-5450-489e-980f-9215d62f3eb5	97ad6c7c-6f13-4266-8241-a72deab8f86a	0.00	0.5500	stable	High	{"trend": 0, "accuracy": 0, "attempts": 0, "recent_score": 0, "average_score": 0, "topic_mastery": 0, "average_response_time": 0}	\N	\N	2026-08-25 14:06:15.875158+00
425fd114-5970-45be-89a9-fb0191ef8bd4	97ad6c7c-6f13-4266-8241-a72deab8f86a	16.32	0.5800	stable	High	{"trend": 0, "accuracy": 0, "attempts": 0, "recent_score": 0, "average_score": 0, "topic_mastery": 0, "average_response_time": 0}	24.00	7.68	2026-08-27 09:25:30.794913+00
130b07e9-e35c-484a-9eba-828c0e768828	97ad6c7c-6f13-4266-8241-a72deab8f86a	29.53	0.6100	stable	High	{"trend": 0, "accuracy": 24.49, "attempts": 1, "recent_score": 24, "average_score": 24, "topic_mastery": 24.444, "average_response_time": 1.59}	\N	\N	2026-08-28 05:38:32.549235+00
e2a20e25-e11b-4f81-8712-6c14b6372120	97ad6c7c-6f13-4266-8241-a72deab8f86a	29.53	0.6100	stable	High	{"trend": 0, "accuracy": 24.49, "attempts": 1, "recent_score": 24, "average_score": 24, "topic_mastery": 24.444, "average_response_time": 1.59}	\N	\N	2026-08-28 05:38:32.555082+00
d1119da5-6f34-4aea-8b8c-9d1bfad86379	97ad6c7c-6f13-4266-8241-a72deab8f86a	29.53	0.6100	stable	High	{"trend": 0, "accuracy": 24.49, "attempts": 1, "recent_score": 24, "average_score": 24, "topic_mastery": 24.444, "average_response_time": 1.59}	0.00	29.53	2026-08-28 06:15:58.044892+00
79892f0a-aff0-417b-9dad-94a72bee8a13	97ad6c7c-6f13-4266-8241-a72deab8f86a	12.00	0.5500	declining	High	{"trend": -24, "accuracy": 24.49, "attempts": 2, "recent_score": 12, "average_score": 12, "topic_mastery": 24.444, "average_response_time": 1.59}	\N	\N	2026-08-28 11:22:10.868072+00
\.


--
-- TOC entry 5071 (class 0 OID 17678)
-- Dependencies: 359
-- Data for Name: proctoring_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.proctoring_events (id, attempt_id, user_id, event_type, detail, created_at, severity, details) FROM stdin;
4d15631c-a844-494c-b5fc-d52d02746a2a	04d0b31a-ad1c-4d2b-939c-443967e6c63b	ce0fb583-4c15-43a5-b8af-e2b941589f86	window_blur		2026-09-03 03:31:28.45902+00	low	{}
1f066952-5ae2-40ba-a654-a8d6f9231abc	04d0b31a-ad1c-4d2b-939c-443967e6c63b	ce0fb583-4c15-43a5-b8af-e2b941589f86	window_blur		2026-09-03 03:33:33.109472+00	low	{}
10d71ab2-425d-4dda-ac77-227f7d07f27f	04d0b31a-ad1c-4d2b-939c-443967e6c63b	ce0fb583-4c15-43a5-b8af-e2b941589f86	window_blur		2026-09-03 03:33:54.80171+00	low	{}
346df584-83a4-4182-9fd9-437f83d5814f	04d0b31a-ad1c-4d2b-939c-443967e6c63b	ce0fb583-4c15-43a5-b8af-e2b941589f86	window_blur		2026-09-03 03:34:07.87947+00	low	{}
\.


--
-- TOC entry 5091 (class 0 OID 18582)
-- Dependencies: 379
-- Data for Name: proctoring_reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.proctoring_reports (attempt_id, user_id, exam_id, risk_score, risk_level, event_counts, calculation, calculated_at, created_at) FROM stdin;
\.


--
-- TOC entry 5062 (class 0 OID 17503)
-- Dependencies: 350
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.profiles (id, full_name, college, role, created_at, email, institution, avatar_url, last_login, account_status, updated_at) FROM stdin;
15068f40-e70b-44b1-82eb-28b9f885db37	Chandan	College	student	2026-08-18 08:04:20.722562+00	chandangirish10@gmail.com	College	\N	2026-08-18 08:04:38.172116+00	active	2026-08-28 10:47:44.186581+00
ce0fb583-4c15-43a5-b8af-e2b941589f86	Hamsa	GSSS	student	2026-09-03 03:26:52.873896+00	hamsargowda702685@gmail.com	GSSS	\N	2026-09-03 07:13:14.778+00	active	2026-09-03 07:13:14.723019+00
97ad6c7c-6f13-4266-8241-a72deab8f86a	Chandan	JC	student	2026-08-25 05:27:25.042637+00	chandangirish95@gmail.com	JC	https://lrkgumzcwilstdbusdqp.supabase.co/storage/v1/object/public/avatars/97ad6c7c-6f13-4266-8241-a72deab8f86a/1788158075585.jpg	2026-09-02 10:24:20.161+00	active	2026-09-02 10:23:06.282165+00
f19320d2-8560-46e4-9093-a1f9b2d35647	Chandan	AIT	student	2026-08-25 05:23:17.419938+00	chandangitish10@gmail.com	AIT	\N	2026-08-25 05:23:17.419938+00	pending_verification	2026-08-25 05:23:17.419938+00
d5ae212b-9a24-404c-a312-804a6572933e	Chandan	College	student	2026-08-18 08:04:05.159695+00	chandan@gmail.com	College	\N	2026-08-18 08:04:05.159695+00	pending_verification	2026-08-18 08:04:05.159695+00
456f5f52-36f2-4347-b9f7-f435927c9779	admin	\N	admin	2026-10-13 06:28:14.34718+00	admin@example.com	\N	\N	2026-10-13 06:30:25.104566+00	active	2026-10-13 06:34:36.436442+00
\.


--
-- TOC entry 5066 (class 0 OID 17569)
-- Dependencies: 354
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.questions (id, exam_id, topic_id, question_text, options, correct_answer, difficulty, marks, negative_marks, display_order, created_at, subject_id, question_image_url, option_images, explanation, created_by, updated_at, is_active, seed_key) FROM stdin;
789a38fa-ce25-4d90-839f-c170affba96e	e33a8358-2129-4c48-bc70-5f61d53db42f	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	What is the value of x if 2x + 6 = 14?	["2", "3", "4", "5"]	2	easy	1.00	0.00	1	2026-08-18 05:57:42.719806+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	\N	\N	2026-08-27 08:41:05.691727+00	f	\N
46728b85-c7f3-4a57-af0a-58b32be35bbe	e33a8358-2129-4c48-bc70-5f61d53db42f	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	Simplify: 3(a + 2) - 2a	["a + 6", "a + 2", "5a + 6", "a - 6"]	0	easy	1.00	0.00	2	2026-08-18 05:57:42.719806+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	\N	\N	2026-08-27 08:41:05.691727+00	f	\N
c5de0b80-e33b-467b-8ee5-77a7c3a74b3d	e33a8358-2129-4c48-bc70-5f61d53db42f	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	If x² = 49 and x is positive, x equals:	["5", "6", "7", "8"]	2	easy	1.00	0.00	3	2026-08-18 05:57:42.719806+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	\N	\N	2026-08-27 08:41:05.691727+00	f	\N
1dad4c69-7d98-4807-b2a5-9852492eba87	e33a8358-2129-4c48-bc70-5f61d53db42f	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	Which expression factors x² - 9?	["(x-3)(x+3)", "(x-9)(x+1)", "(x-3)²", "(x+9)(x-1)"]	0	medium	1.00	0.00	4	2026-08-18 05:57:42.719806+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	\N	\N	2026-08-27 08:41:05.691727+00	f	\N
32c7fed8-9b85-4aba-a1c0-0cc9d95daaf0	e33a8358-2129-4c48-bc70-5f61d53db42f	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	If f(x)=2x+1, what is f(4)?	["7", "8", "9", "10"]	2	medium	1.00	0.00	5	2026-08-18 05:57:42.719806+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	\N	\N	2026-08-27 08:41:05.691727+00	f	\N
8fe299d0-8f3f-409f-b623-19c369484421	d629708f-e6ba-4765-a561-016a3eb2662b	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	Solve 2x + 5 = 17.	["x = 6", "x = 4", "x = 5", "x = 7"]	0	easy	1.00	0.00	1	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Subtract 5 and divide by 2 to get x = 6	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:algebra:1
b1704bf5-d1dd-449d-9b3b-02f150f49196	d629708f-e6ba-4765-a561-016a3eb2662b	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	Which expression factors x^2 - 25?	["(x - 25)(x + 1)", "(x - 5)(x + 5)", "(x - 5)^2", "(x + 25)(x - 1)"]	1	easy	1.00	0.00	2	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	This is a difference of squares	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:algebra:2
3b2c7c17-25d8-46f7-8ffe-07f122794112	d629708f-e6ba-4765-a561-016a3eb2662b	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	Simplify 3a + 4a - 2.	["5a - 2", "7a + 2", "7a - 2", "12a"]	2	easy	1.00	0.00	3	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Combine like terms 3a and 4a first	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:algebra:3
436d20d2-2e1f-42e2-b4cf-c06445eea5d4	d629708f-e6ba-4765-a561-016a3eb2662b	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	If x + y = 10 and x - y = 2, what is x?	["4", "5", "8", "6"]	3	medium	1.00	0.00	4	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Adding the equations gives 2x = 12	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:algebra:4
7a39e6f7-1122-48a5-a69e-21c07a7627ce	d629708f-e6ba-4765-a561-016a3eb2662b	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	Expand (x + 3)^2.	["x^2 + 9", "x^2 + 6x + 9", "x^2 + 3x + 9", "x^2 + 6x + 3"]	1	medium	1.00	0.00	5	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Use (a + b)^2 = a^2 + 2ab + b^2	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:algebra:5
e06db5ea-8a41-45dc-94c5-f6930c8fca2f	d629708f-e6ba-4765-a561-016a3eb2662b	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	What are the roots of x^2 - 5x + 6 = 0?	["1 and 6", "3 and 5", "2 and 3", "2 and 6"]	2	medium	1.00	0.00	6	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	The quadratic factors as (x - 2)(x - 3)	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:algebra:6
887929bf-45c0-42f3-b88b-960c0ea69bc3	d629708f-e6ba-4765-a561-016a3eb2662b	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	If f(x) = 3x - 4, what is f(5)?	["9", "10", "15", "11"]	3	medium	1.00	0.00	7	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Substitute x = 5 into the function	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:algebra:7
4fdc905f-582a-4880-b97a-ab03f7a924dd	d629708f-e6ba-4765-a561-016a3eb2662b	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	Solve |2x - 7| = 5. Which is the larger solution?	["6", "1", "4", "5"]	0	hard	1.00	0.00	8	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	The two solutions are 1 and 6	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:algebra:8
56f4b9ca-bc07-4d25-8ae6-4b84497a831b	d629708f-e6ba-4765-a561-016a3eb2662b	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	If x + 1/x = 5, what is x^2 + 1/x^2?	["15", "21", "23", "25"]	2	hard	1.00	0.00	9	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Square the expression and subtract 2	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:algebra:9
3773211f-6a96-47c7-b6d5-7124ca15bd2a	d629708f-e6ba-4765-a561-016a3eb2662b	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	If 3^(x + 1) = 81, what is x?	["2", "3", "4", "5"]	1	hard	1.00	0.00	10	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Because 81 = 3^4, x + 1 = 4	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:algebra:10
a67d367d-6064-439a-9820-1b559a314178	d629708f-e6ba-4765-a561-016a3eb2662b	68d8f6be-90c5-4893-84f0-afe6b5270631	What is the derivative of x^2?	["2x", "x", "x^2", "2"]	0	easy	1.00	0.00	11	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Apply the power rule	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:calculus:1
2147f63d-ebff-4303-b492-aa1e53fd89a9	d629708f-e6ba-4765-a561-016a3eb2662b	68d8f6be-90c5-4893-84f0-afe6b5270631	What is the integral of 5 with respect to x?	["x^5 + C", "5x + C", "5 + C", "1 + C"]	1	easy	1.00	0.00	12	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	The integral of a constant k is kx + C	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:calculus:2
612e0882-184e-477d-9b07-68aebaf8f9db	d629708f-e6ba-4765-a561-016a3eb2662b	68d8f6be-90c5-4893-84f0-afe6b5270631	What is the slope of the line y = 3x + 1?	["1", "2", "3", "4"]	2	easy	1.00	0.00	13	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	In y = mx + c, the slope is m	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:calculus:3
3a0136aa-5a28-41c8-8a9d-0ca85988d517	d629708f-e6ba-4765-a561-016a3eb2662b	68d8f6be-90c5-4893-84f0-afe6b5270631	What is the derivative of sin x?	["-sin x", "-cos x", "tan x", "cos x"]	3	medium	1.00	0.00	14	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	The derivative of sin x is cos x	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:calculus:4
669eddca-36e1-4eca-a191-a6de90cae4a9	d629708f-e6ba-4765-a561-016a3eb2662b	68d8f6be-90c5-4893-84f0-afe6b5270631	What is the integral of 2x with respect to x?	["2x^2 + C", "x^2 + C", "x + C", "2 + C"]	1	medium	1.00	0.00	15	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	x^2 differentiates to 2x	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:calculus:5
0e1543db-2ba4-47fe-8da4-a71f466dd331	d629708f-e6ba-4765-a561-016a3eb2662b	68d8f6be-90c5-4893-84f0-afe6b5270631	Evaluate lim (x^2 - 1)/(x - 1) as x approaches 1.	["0", "1", "2", "3"]	2	medium	1.00	0.00	16	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Factor the numerator and cancel x - 1	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:calculus:6
823eeddf-be0c-456a-97e1-91054ad0c850	d629708f-e6ba-4765-a561-016a3eb2662b	68d8f6be-90c5-4893-84f0-afe6b5270631	What is the derivative of ln x?	["ln x", "x", "e^x", "1/x"]	3	medium	1.00	0.00	17	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	For x > 0, d/dx(ln x) = 1/x	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:calculus:7
fab38afd-5f36-4bf8-8631-eb807028b069	d629708f-e6ba-4765-a561-016a3eb2662b	68d8f6be-90c5-4893-84f0-afe6b5270631	What is the area under y = 1 from x = 0 to x = 3?	["3", "1", "2", "4"]	0	hard	1.00	0.00	18	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	A rectangle of height 1 and width 3 has area 3	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:calculus:8
d3b64a21-148e-48ef-86aa-ade2ce77951f	d629708f-e6ba-4765-a561-016a3eb2662b	68d8f6be-90c5-4893-84f0-afe6b5270631	What is the derivative of x^x for x > 0?	["x^(x-1)", "x^x", "x^x(ln x + 1)", "ln x + 1"]	2	hard	1.00	0.00	19	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Log differentiation gives x^x(ln x + 1)	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:calculus:9
ef60efdd-9823-4570-9219-34bc0d49300e	d629708f-e6ba-4765-a561-016a3eb2662b	68d8f6be-90c5-4893-84f0-afe6b5270631	Evaluate the integral from 1 to e of 1/x dx.	["0", "1", "e", "ln 2"]	1	hard	1.00	0.00	20	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	The antiderivative is ln x, so ln e - ln 1 = 1	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:calculus:10
a6e11d00-ea90-4cb6-a2fd-88db3dc36f15	d629708f-e6ba-4765-a561-016a3eb2662b	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	What is sin 30 degrees?	["1/2", "0", "sqrt(3)/2", "1"]	0	easy	1.00	0.00	41	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	sin 30 degrees equals one-half	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:trigonometry:1
686147bb-ee54-4ce4-99b2-903d80e977df	d629708f-e6ba-4765-a561-016a3eb2662b	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	What is cos 0 degrees?	["0", "1", "1/2", "-1"]	1	easy	1.00	0.00	42	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	cos 0 degrees equals 1	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:trigonometry:2
d9ecd9dd-aa5c-4457-90d4-b2e8d26661f7	d629708f-e6ba-4765-a561-016a3eb2662b	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	What is tan 45 degrees?	["0", "sqrt(2)", "1", "sqrt(3)"]	2	easy	1.00	0.00	43	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	At 45 degrees, sine and cosine are equal	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:trigonometry:3
7710b2c7-58fa-4e86-bc48-f5f1da3e3da5	d629708f-e6ba-4765-a561-016a3eb2662b	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	Which identity is always true?	["sin x + cos x = 1", "tan x = sin x cos x", "sec x = sin x", "sin^2 x + cos^2 x = 1"]	3	medium	1.00	0.00	44	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	This is the Pythagorean identity	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:trigonometry:4
47487c28-3d5e-44b6-a40e-c939fe00651b	d629708f-e6ba-4765-a561-016a3eb2662b	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	sec x is equal to which expression?	["1/sin x", "1/cos x", "sin x/cos x", "cos x/sin x"]	1	medium	1.00	0.00	45	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Secant is the reciprocal of cosine	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:trigonometry:5
5393ef56-444a-407e-9f4f-063996681bdb	d629708f-e6ba-4765-a561-016a3eb2662b	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	What is sin 90 degrees - cos 0 degrees?	["-1", "1", "0", "2"]	2	medium	1.00	0.00	46	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Both values are 1, so the difference is 0	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:trigonometry:6
a5f2c768-b4fb-4e20-b710-4c57ff9c5e12	d629708f-e6ba-4765-a561-016a3eb2662b	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	If tan theta = 3/4 and theta is acute, what is sin theta?	["4/5", "5/3", "5/4", "3/5"]	3	medium	1.00	0.00	47	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Use a 3-4-5 right triangle	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:trigonometry:7
59b39e86-2deb-4625-beef-09c39c0f54a6	d629708f-e6ba-4765-a561-016a3eb2662b	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	If 2 sin x = 1 and x is acute, what is x?	["30 degrees", "15 degrees", "45 degrees", "60 degrees"]	0	hard	1.00	0.00	48	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Then sin x = 1/2	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:trigonometry:8
85f181e7-3e4c-49df-89d0-98d854126316	d629708f-e6ba-4765-a561-016a3eb2662b	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	What is sin 75 degrees?	["(sqrt(6) - sqrt(2))/4", "sqrt(3)/2", "(sqrt(6) + sqrt(2))/4", "1/2"]	2	hard	1.00	0.00	49	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Use the angle addition formula	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:trigonometry:9
f525ad0a-65c3-4f8e-be97-3d65a44b80be	d629708f-e6ba-4765-a561-016a3eb2662b	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	If sin theta = 1/3 and theta is acute, what is cos 2theta?	["5/9", "7/9", "8/9", "1/9"]	1	hard	1.00	0.00	50	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Use cos 2theta = 1 - 2sin^2 theta	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:trigonometry:10
17a23a4e-e918-49f1-8d37-0bb6b17b0258	d629708f-e6ba-4765-a561-016a3eb2662b	6985fef8-92cf-47a8-aad8-88754030af2c	What is the slope of the line through (0, 0) and (2, 2)?	["1", "0", "2", "4"]	0	easy	1.00	0.00	21	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Slope is rise over run = 2/2	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:coordinate_geometry:1
cdbf324f-990e-4759-8715-01cf087eb2c0	d629708f-e6ba-4765-a561-016a3eb2662b	6985fef8-92cf-47a8-aad8-88754030af2c	What is the distance between (1, 2) and (1, 5)?	["2", "3", "4", "5"]	1	easy	1.00	0.00	22	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	The vertical distance is 5 - 2	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:coordinate_geometry:2
27a57025-3ef9-4c33-aa03-64b6b233ea8e	d629708f-e6ba-4765-a561-016a3eb2662b	6985fef8-92cf-47a8-aad8-88754030af2c	Which equation represents the x-axis?	["x = 0", "x = y", "y = 0", "x + y = 0"]	2	easy	1.00	0.00	23	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Points on the x-axis have y = 0	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:coordinate_geometry:3
c54e6779-0457-4d47-a64a-0267aae99b0f	d629708f-e6ba-4765-a561-016a3eb2662b	6985fef8-92cf-47a8-aad8-88754030af2c	What is the midpoint of (2, 4) and (6, 8)?	["(3, 5)", "(5, 7)", "(8, 12)", "(4, 6)"]	3	medium	1.00	0.00	24	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Average the x-values and y-values	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:coordinate_geometry:4
c54271c9-5a92-4b96-bed6-53862f0a7fcc	d629708f-e6ba-4765-a561-016a3eb2662b	6985fef8-92cf-47a8-aad8-88754030af2c	Which equation is the circle centered at the origin with radius 3?	["x^2 + y^2 = 3", "x^2 + y^2 = 9", "x^2 + y^2 = 6", "x + y = 9"]	1	medium	1.00	0.00	25	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	A circle centered at the origin has equation x^2 + y^2 = r^2	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:coordinate_geometry:5
da02328f-d889-4100-a1fd-250b5e9a9848	d629708f-e6ba-4765-a561-016a3eb2662b	6985fef8-92cf-47a8-aad8-88754030af2c	What is the slope of the line 2x + 3y = 6?	["2/3", "3/2", "-2/3", "-3/2"]	2	medium	1.00	0.00	26	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Rewrite in slope-intercept form	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:coordinate_geometry:6
d04ce9b1-15b1-4bb1-8753-e5dffd8bc3e2	d629708f-e6ba-4765-a561-016a3eb2662b	6985fef8-92cf-47a8-aad8-88754030af2c	What is the area of the triangle with vertices (0, 0), (4, 0), and (0, 3)?	["4", "5", "12", "6"]	3	medium	1.00	0.00	27	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Area = 1/2 x base x height	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:coordinate_geometry:7
c5386a27-4225-433e-8a5c-152ed1a59b20	d629708f-e6ba-4765-a561-016a3eb2662b	6985fef8-92cf-47a8-aad8-88754030af2c	Which equation is the line through (1, 2) with slope 3?	["y - 2 = 3(x - 1)", "y + 2 = 3(x - 1)", "y - 1 = 2(x - 3)", "y = 3x + 1"]	0	hard	1.00	0.00	28	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Use point-slope form	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:coordinate_geometry:8
87e31772-f018-4825-9fa8-e80c79a3f7c2	d629708f-e6ba-4765-a561-016a3eb2662b	6985fef8-92cf-47a8-aad8-88754030af2c	What is the distance from the point (3, 4) to the origin?	["4", "6", "5", "7"]	2	hard	1.00	0.00	29	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Use the distance formula	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:coordinate_geometry:9
60471398-431a-487a-a636-0685c3f03cb8	d629708f-e6ba-4765-a561-016a3eb2662b	6985fef8-92cf-47a8-aad8-88754030af2c	For the parabola y^2 = 4ax with a = 2, what is the focus?	["(0, 2)", "(2, 0)", "(4, 0)", "(0, 4)"]	1	hard	1.00	0.00	30	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	For y^2 = 4ax, the focus is (a, 0)	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:coordinate_geometry:10
218fb4c0-cf10-46d9-9b02-4ce16ed00229	d629708f-e6ba-4765-a561-016a3eb2662b	965b5429-8685-4cc9-a7be-42858adcd165	What is the probability of getting heads on a fair coin toss?	["1/2", "0", "1/4", "1"]	0	easy	1.00	0.00	31	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	A fair coin has two equally likely outcomes	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:probability:1
288722fc-d2d7-4d5b-9190-3990f9a366c8	d629708f-e6ba-4765-a561-016a3eb2662b	965b5429-8685-4cc9-a7be-42858adcd165	What is the probability of rolling a 6 on a fair die?	["1/3", "1/6", "1/4", "1/5"]	1	easy	1.00	0.00	32	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	One favorable outcome out of six	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:probability:2
48ff2f62-05d2-4cec-bb51-e5396bfbe13f	d629708f-e6ba-4765-a561-016a3eb2662b	965b5429-8685-4cc9-a7be-42858adcd165	What is the sum of probabilities of all outcomes in a sample space?	["0", "n", "1", "Depends on the event"]	2	easy	1.00	0.00	33	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	All outcomes in a complete sample space total 1	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:probability:3
9e68b749-d586-40fe-b64e-a2ab3b19516f	d629708f-e6ba-4765-a561-016a3eb2662b	965b5429-8685-4cc9-a7be-42858adcd165	If two fair coins are tossed, what is the probability of getting exactly one head?	["1/4", "3/4", "1", "1/2"]	3	medium	1.00	0.00	34	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	The favorable outcomes are HT and TH	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:probability:4
a84366a8-692e-4ee7-98d4-5672b2aec7c8	d629708f-e6ba-4765-a561-016a3eb2662b	965b5429-8685-4cc9-a7be-42858adcd165	What is the probability of drawing an ace from a standard 52-card deck?	["1/52", "1/13", "1/4", "4/13"]	1	medium	1.00	0.00	35	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	There are 4 aces in 52 cards	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:probability:5
171cbd6b-a9c4-4210-8f72-467cea0b80d9	d629708f-e6ba-4765-a561-016a3eb2662b	965b5429-8685-4cc9-a7be-42858adcd165	For independent events A and B, what is P(A and B)?	["P(A) + P(B)", "P(A) - P(B)", "P(A)P(B)", "P(A)/P(B)"]	2	medium	1.00	0.00	36	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Independent events multiply	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:probability:6
cd593bb2-89b7-477f-a0ca-61725c1fb34f	d629708f-e6ba-4765-a561-016a3eb2662b	965b5429-8685-4cc9-a7be-42858adcd165	What is the probability of getting at least one head when two fair coins are tossed?	["1/4", "1/2", "1", "3/4"]	3	medium	1.00	0.00	37	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Use the complement of getting no heads	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:probability:7
7af86835-af29-4960-8e8b-8264de6842e1	d629708f-e6ba-4765-a561-016a3eb2662b	965b5429-8685-4cc9-a7be-42858adcd165	A bag has 3 red and 2 blue balls. Without replacement, what is the probability of drawing a red then a blue?	["3/10", "1/5", "2/5", "3/5"]	0	hard	1.00	0.00	38	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Multiply 3/5 by 2/4	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:probability:8
ed939a01-c9c4-42f6-bd6b-066eaff591ef	d629708f-e6ba-4765-a561-016a3eb2662b	965b5429-8685-4cc9-a7be-42858adcd165	What is the expected value of a fair six-sided die roll?	["3", "4", "3.5", "4.5"]	2	hard	1.00	0.00	39	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Average the outcomes 1 through 6	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:probability:9
16b2d359-e7ec-41cb-8da3-f96fc44109d8	d629708f-e6ba-4765-a561-016a3eb2662b	965b5429-8685-4cc9-a7be-42858adcd165	If P(A) = 0.6 and P(B) = 0.5 and A and B are independent, what is P(A or B)?	["0.3", "0.8", "0.5", "1.1"]	1	hard	1.00	0.00	40	2026-08-27 08:41:05.691727+00	fbff0f41-fe5f-42e7-aafa-d85df02568e0	\N	\N	Add the probabilities and subtract the overlap	\N	2026-08-27 08:41:05.691727+00	t	demo:question:mathematics:probability:10
d65b5a01-9245-43b3-97da-d52da023a630	41e8530f-95df-4b05-8756-70e2a5d3c930	7b47c1c5-6ff8-411e-8f06-8a29719b6485	What is the SI unit of force?	["Newton", "Joule", "Watt", "Pascal"]	0	easy	1.00	0.00	11	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Force is measured in newtons	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:mechanics:1
997942ce-606e-42c9-869d-6af913e84e78	41e8530f-95df-4b05-8756-70e2a5d3c930	7b47c1c5-6ff8-411e-8f06-8a29719b6485	Newton's first law is also called the law of what?	["Momentum", "Inertia", "Gravitation", "Energy"]	1	easy	1.00	0.00	12	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	The first law describes resistance to change in motion	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:mechanics:2
92ef8a0d-49e6-4799-a366-3981e5c20bb8	41e8530f-95df-4b05-8756-70e2a5d3c930	7b47c1c5-6ff8-411e-8f06-8a29719b6485	What is the approximate acceleration due to gravity near Earth's surface?	["4.9 m/s^2", "8.0 m/s^2", "9.8 m/s^2", "12.0 m/s^2"]	2	easy	1.00	0.00	13	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	The standard value is about 9.8 m/s^2	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:mechanics:3
f33a59c2-9803-4af4-8efb-2bca09643633	41e8530f-95df-4b05-8756-70e2a5d3c930	7b47c1c5-6ff8-411e-8f06-8a29719b6485	Linear momentum is equal to which quantity?	["force x time", "mass x acceleration", "work x distance", "mass x velocity"]	3	medium	1.00	0.00	14	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Momentum is defined as p = mv	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:mechanics:4
cdbfb31d-e1b4-4ab4-aa53-efc9ad2e191d	41e8530f-95df-4b05-8756-70e2a5d3c930	7b47c1c5-6ff8-411e-8f06-8a29719b6485	Work done by a constant force equals what?	["mass x velocity", "force x displacement along the force", "power x time squared", "pressure x volume"]	1	medium	1.00	0.00	15	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Work is the component of force times displacement	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:mechanics:5
08f1d2ab-2646-40cc-83ec-ad1eac478a60	41e8530f-95df-4b05-8756-70e2a5d3c930	7b47c1c5-6ff8-411e-8f06-8a29719b6485	Which expression gives kinetic energy?	["mv", "mgh", "1/2 mv^2", "Fv"]	2	medium	1.00	0.00	16	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Kinetic energy depends on speed squared	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:mechanics:6
4e7e0733-c100-478b-84b2-9f14018129a9	41e8530f-95df-4b05-8756-70e2a5d3c930	7b47c1c5-6ff8-411e-8f06-8a29719b6485	In uniform circular motion, the acceleration is directed where?	["Along the tangent", "Away from the center", "Upward", "Toward the center"]	3	medium	1.00	0.00	17	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Centripetal acceleration points inward	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:mechanics:7
3afa34ea-0f65-488a-908f-9c46e7c17e93	41e8530f-95df-4b05-8756-70e2a5d3c930	7b47c1c5-6ff8-411e-8f06-8a29719b6485	A 2 kg object experiences a net force of 10 N. What is its acceleration?	["5 m/s^2", "2 m/s^2", "8 m/s^2", "12 m/s^2"]	0	hard	1.00	0.00	18	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Use F = ma	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:mechanics:8
b6cbecc4-8bad-482b-9974-280d186b1574	41e8530f-95df-4b05-8756-70e2a5d3c930	7b47c1c5-6ff8-411e-8f06-8a29719b6485	At the highest point of a projectile's path, what is its vertical velocity?	["Maximum", "Equal to horizontal velocity", "Zero", "Negative infinity"]	2	hard	1.00	0.00	19	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	The vertical component changes sign at the top	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:mechanics:9
e5c327c2-aec2-4e1a-86b5-8200bec1dcb7	41e8530f-95df-4b05-8756-70e2a5d3c930	7b47c1c5-6ff8-411e-8f06-8a29719b6485	If the net force on a moving body is zero, how does it continue to move?	["It must stop", "It moves with constant velocity", "It speeds up uniformly", "It reverses direction"]	1	hard	1.00	0.00	20	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Zero net force means zero acceleration	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:mechanics:10
7025c6b5-273d-4cc5-af81-6e215a6ca160	41e8530f-95df-4b05-8756-70e2a5d3c930	3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2	What is the SI unit of temperature?	["Kelvin", "Celsius", "Fahrenheit", "Joule"]	0	easy	1.00	0.00	41	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Kelvin is the SI base unit of temperature	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:thermodynamics:1
0205247f-2114-4c4a-a09b-093dd76a7dd5	41e8530f-95df-4b05-8756-70e2a5d3c930	3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2	Heat naturally flows from which body to which body?	["Cold to hot", "Hot to cold", "Higher mass to lower mass", "Lower pressure to higher pressure"]	1	easy	1.00	0.00	42	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Heat flows from higher temperature to lower temperature	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:thermodynamics:2
a68d59a7-47a1-4756-88c5-a67b466e1142	41e8530f-95df-4b05-8756-70e2a5d3c930	3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2	At constant pressure, heat supplied to a system equals the change in what quantity?	["Entropy", "Momentum", "Enthalpy", "Resistance"]	2	easy	1.00	0.00	43	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	At constant pressure, q equals delta H	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:thermodynamics:3
49e0467f-8a1f-45a6-a637-65cc5d52188a	41e8530f-95df-4b05-8756-70e2a5d3c930	3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2	Which equation represents the first law of thermodynamics?	["Q = U - W", "Q = P/V", "Q = mc", "Q = U + W"]	3	medium	1.00	0.00	44	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	With this sign convention, heat added equals internal energy change plus work done	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:thermodynamics:4
6ce3fadf-60c1-4b41-a0b5-0df18fc5f126	41e8530f-95df-4b05-8756-70e2a5d3c930	3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2	Absolute zero is equal to which temperature?	["0 C", "0 K", "-100 C", "273 K"]	1	medium	1.00	0.00	45	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Absolute zero is 0 kelvin	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:thermodynamics:5
5c9687a5-c459-4b71-bf61-235b174cd6e6	41e8530f-95df-4b05-8756-70e2a5d3c930	3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2	What remains constant in an isothermal process?	["Pressure", "Volume", "Temperature", "Mass density"]	2	medium	1.00	0.00	46	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Isothermal means constant temperature	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:thermodynamics:6
c9c58182-e24f-4269-9cd3-c9e0d147ead3	41e8530f-95df-4b05-8756-70e2a5d3c930	3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2	The efficiency of an ideal Carnot engine depends on what?	["Only working substance mass", "Only pressure", "Only volume", "Only reservoir temperatures"]	3	medium	1.00	0.00	47	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Carnot efficiency is determined by hot and cold reservoir temperatures	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:thermodynamics:7
e4fd5293-83e9-45c7-9cec-3acac25b75a5	41e8530f-95df-4b05-8756-70e2a5d3c930	3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2	In an adiabatic process, the heat transfer Q is what?	["Zero", "Positive", "Negative", "Maximum"]	0	hard	1.00	0.00	48	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	No heat is exchanged in an adiabatic process	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:thermodynamics:8
0d850214-41d2-4b5b-b427-a3167452a4cb	41e8530f-95df-4b05-8756-70e2a5d3c930	3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2	For an ideal gas, internal energy depends primarily on what?	["Pressure only", "Volume only", "Temperature only", "Number of moles only"]	2	hard	1.00	0.00	49	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Internal energy of an ideal gas is a function of temperature	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:thermodynamics:9
ad9c33b8-54dc-431c-9b46-370a0e5a0ab0	41e8530f-95df-4b05-8756-70e2a5d3c930	3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2	According to the second law, what happens to the entropy of an isolated system?	["It always decreases", "It never decreases", "It always stays zero", "It alternates"]	1	hard	1.00	0.00	50	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Entropy does not decrease for spontaneous change in an isolated system	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:thermodynamics:10
370aa1f0-3655-4478-8399-69a26ef0f57f	41e8530f-95df-4b05-8756-70e2a5d3c930	689f8270-2092-401a-933d-5204f62002ce	Parallel rays incident on a convex lens meet at which point?	["Principal focus", "Center of curvature", "Optical center only", "Pole"]	0	easy	1.00	0.00	31	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	A convex lens converges parallel rays to its focus	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:optics:1
bd24455f-64b9-4cda-be0a-a3714ea94872	41e8530f-95df-4b05-8756-70e2a5d3c930	689f8270-2092-401a-933d-5204f62002ce	What is the unit of lens power?	["Metre", "Dioptre", "Candela", "Tesla"]	1	easy	1.00	0.00	32	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Lens power is measured in dioptres	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:optics:2
c9ca0210-d86c-4873-a395-e538de59e252	41e8530f-95df-4b05-8756-70e2a5d3c930	689f8270-2092-401a-933d-5204f62002ce	In reflection, the angle of reflection is equal to what?	["Angle of deviation", "Angle of refraction", "Angle of incidence", "Angle of polarization"]	2	easy	1.00	0.00	33	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	The law of reflection makes these angles equal	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:optics:3
eafa0d6a-06ee-4fbc-bd0f-f532525804cc	41e8530f-95df-4b05-8756-70e2a5d3c930	689f8270-2092-401a-933d-5204f62002ce	A real image formed by a concave mirror can be what?	["Seen only in a microscope", "Always upright", "Always virtual", "Formed on a screen"]	3	medium	1.00	0.00	34	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Real images can be projected	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:optics:4
2b6c077c-b02a-465d-80ed-57545042558c	41e8530f-95df-4b05-8756-70e2a5d3c930	689f8270-2092-401a-933d-5204f62002ce	Refractive index of a medium is equal to which ratio?	["speed in medium / speed in vacuum", "speed in vacuum / speed in medium", "wavelength in vacuum / frequency", "frequency / wavelength"]	1	medium	1.00	0.00	35	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	The refractive index n equals c divided by v	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:optics:5
6e632619-65a5-481e-afb1-c035d75350d7	41e8530f-95df-4b05-8756-70e2a5d3c930	689f8270-2092-401a-933d-5204f62002ce	A rainbow is produced mainly due to what effects?	["Diffraction only", "Reflection only", "Dispersion and internal reflection", "Interference only"]	2	medium	1.00	0.00	36	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Raindrops disperse and internally reflect light	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:optics:6
16cf1a84-3ba3-4e26-80a1-9bf491cf37fd	41e8530f-95df-4b05-8756-70e2a5d3c930	689f8270-2092-401a-933d-5204f62002ce	In myopia, the image of distant objects forms where?	["Behind the retina", "On the retina", "On the cornea", "Before the retina"]	3	medium	1.00	0.00	37	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Short-sightedness forms the image before the retina	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:optics:7
72bb8096-7663-477e-b3ed-33efecc648f1	41e8530f-95df-4b05-8756-70e2a5d3c930	689f8270-2092-401a-933d-5204f62002ce	What is the power of a lens of focal length 20 cm?	["5 D", "2 D", "4 D", "10 D"]	0	hard	1.00	0.00	38	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Power is the reciprocal of focal length in metres	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:optics:8
6675663b-3099-40b7-8680-b7c919fd4174	41e8530f-95df-4b05-8756-70e2a5d3c930	689f8270-2092-401a-933d-5204f62002ce	What is the magnification of a plane mirror?	["0", "2", "1", "It varies with distance"]	2	hard	1.00	0.00	39	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	A plane mirror forms an image of equal size	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:optics:9
9d0348a7-a85d-4e38-b7a0-7a9be1570806	41e8530f-95df-4b05-8756-70e2a5d3c930	689f8270-2092-401a-933d-5204f62002ce	In Young's double-slit experiment, a bright fringe occurs when path difference is what?	["(2n + 1)lambda/2", "n lambda", "lambda/4", "Zero only"]	1	hard	1.00	0.00	40	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Constructive interference occurs for integer multiples of lambda	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:optics:10
9194797b-a1d2-42aa-ab3d-401d7ff7f569	41e8530f-95df-4b05-8756-70e2a5d3c930	296873c1-7eae-4ac6-af30-4e90e6c975cb	What is the SI unit of electric current?	["Ampere", "Volt", "Ohm", "Coulomb"]	0	easy	1.00	0.00	1	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Current is measured in amperes	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:electricity_and_magnetism:1
c2e25563-7e7e-4897-b22d-55b29904bfda	41e8530f-95df-4b05-8756-70e2a5d3c930	296873c1-7eae-4ac6-af30-4e90e6c975cb	Ohm's law is written as which equation?	["P = VI", "V = IR", "Q = It", "F = qE"]	1	easy	1.00	0.00	2	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Ohm's law relates voltage, current, and resistance	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:electricity_and_magnetism:2
462903f2-7cb5-483d-8d9e-f78ce48fbe58	41e8530f-95df-4b05-8756-70e2a5d3c930	296873c1-7eae-4ac6-af30-4e90e6c975cb	What is the charge on an electron?	["Positive", "Neutral", "Negative", "Variable"]	2	easy	1.00	0.00	3	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	An electron carries negative elementary charge	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:electricity_and_magnetism:3
c0f643df-f3ca-4f8a-9486-7138e13f4c6f	41e8530f-95df-4b05-8756-70e2a5d3c930	296873c1-7eae-4ac6-af30-4e90e6c975cb	In a series circuit, which quantity is the same through each component?	["Voltage", "Charge stored", "Resistance", "Current"]	3	medium	1.00	0.00	4	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Series components share the same current	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:electricity_and_magnetism:4
3bd0f5f8-a41f-47af-aa4c-3b43fedd5a79	41e8530f-95df-4b05-8756-70e2a5d3c930	296873c1-7eae-4ac6-af30-4e90e6c975cb	Electric power is given by which expression?	["P = IR", "P = VI", "P = V/R", "P = Q/t^2"]	1	medium	1.00	0.00	5	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Power equals voltage times current	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:electricity_and_magnetism:5
1d858725-4ed9-4c01-9703-892752fd7a3e	41e8530f-95df-4b05-8756-70e2a5d3c930	296873c1-7eae-4ac6-af30-4e90e6c975cb	What shape are the magnetic field lines around a long straight current-carrying wire?	["Straight radial lines", "Parabolas", "Concentric circles", "Ellipses"]	2	medium	1.00	0.00	6	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	The field wraps around the wire	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:electricity_and_magnetism:6
f8fb3aa1-ab9b-4d54-8a64-ec7ffa0b23e9	41e8530f-95df-4b05-8756-70e2a5d3c930	296873c1-7eae-4ac6-af30-4e90e6c975cb	A capacitor is primarily used to store what?	["Magnetic flux", "Heat", "Mechanical energy", "Electric charge"]	3	medium	1.00	0.00	7	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Capacitors store separated charge	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:electricity_and_magnetism:7
f3482d19-08be-495b-b50f-eb2f069671e3	41e8530f-95df-4b05-8756-70e2a5d3c930	296873c1-7eae-4ac6-af30-4e90e6c975cb	A 12 ohm resistor is connected across 24 V. What current flows?	["2 A", "0.5 A", "1 A", "12 A"]	0	hard	1.00	0.00	8	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Current equals voltage divided by resistance	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:electricity_and_magnetism:8
b9b54bef-3b2a-446d-9d6f-f99cea938fbe	41e8530f-95df-4b05-8756-70e2a5d3c930	296873c1-7eae-4ac6-af30-4e90e6c975cb	What magnetic force acts on a charge moving parallel to a magnetic field?	["Maximum force", "Half the force", "Zero force", "Infinite force"]	2	hard	1.00	0.00	9	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	The magnetic force depends on v cross B	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:electricity_and_magnetism:9
697e2b46-acfc-42bf-abf3-74c4d6302b2d	41e8530f-95df-4b05-8756-70e2a5d3c930	296873c1-7eae-4ac6-af30-4e90e6c975cb	What produces an induced emf in a circuit?	["Constant magnetic flux", "Changing magnetic flux", "Zero resistance", "Constant current only"]	1	hard	1.00	0.00	10	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Faraday's law links induced emf to changing flux	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:electricity_and_magnetism:10
40b3b1ec-d02d-4080-8afc-d5f1af5986f1	41e8530f-95df-4b05-8756-70e2a5d3c930	069e7811-b04d-43d6-b0f0-aed1011ac338	The atomic nucleus contains which particles?	["Protons and neutrons", "Only electrons", "Only neutrons", "Photons and protons"]	0	easy	1.00	0.00	21	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	The nucleus is made of protons and neutrons	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:modern_physics:1
bcd5fd60-8d57-439b-bb22-f95b261981d7	41e8530f-95df-4b05-8756-70e2a5d3c930	069e7811-b04d-43d6-b0f0-aed1011ac338	The photoelectric effect supports which idea about light?	["Light has no energy", "Light behaves as particles", "Light travels only in solids", "Light has infinite speed"]	1	easy	1.00	0.00	22	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Photoelectric emission depends on photon energy	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:modern_physics:2
3119f83e-5ffc-43e9-9676-6578a52e8f1a	41e8530f-95df-4b05-8756-70e2a5d3c930	069e7811-b04d-43d6-b0f0-aed1011ac338	Which scientist proposed E = mc^2?	["Newton", "Bohr", "Einstein", "Planck"]	2	easy	1.00	0.00	23	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Mass-energy equivalence was formulated by Einstein	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:modern_physics:3
a487aca5-21e4-4030-a124-c04934636b65	41e8530f-95df-4b05-8756-70e2a5d3c930	069e7811-b04d-43d6-b0f0-aed1011ac338	What is half-life?	["Time for all nuclei to decay", "Time for one nucleus to form", "Time for temperature to double", "Time for half the nuclei to decay"]	3	medium	1.00	0.00	24	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Half-life is defined for a radioactive sample	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:modern_physics:4
ce1c8d3d-7885-4ac9-a80e-f7e6b33a17da	41e8530f-95df-4b05-8756-70e2a5d3c930	069e7811-b04d-43d6-b0f0-aed1011ac338	Isotopes of an element have the same number of what?	["Neutrons", "Protons", "Electrons in ions", "Nucleons"]	1	medium	1.00	0.00	25	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	An element is defined by its atomic number	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:modern_physics:5
28a88db5-65f5-48cd-9b7f-407537b243c3	41e8530f-95df-4b05-8756-70e2a5d3c930	069e7811-b04d-43d6-b0f0-aed1011ac338	De Broglie proposed that moving particles have what associated property?	["Magnetic poles only", "No momentum", "A wavelength", "Infinite mass"]	2	medium	1.00	0.00	26	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Matter waves are described by de Broglie wavelength	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:modern_physics:6
d10cacfe-73d9-468c-a6d3-c1b8c914f5b8	41e8530f-95df-4b05-8756-70e2a5d3c930	069e7811-b04d-43d6-b0f0-aed1011ac338	In Bohr's model, electrons occupy what kind of orbits?	["Random classical paths", "Spiral paths into the nucleus", "Square paths", "Quantized energy levels"]	3	medium	1.00	0.00	27	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Bohr introduced discrete allowed orbits	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:modern_physics:7
e6675ffe-0146-41be-bd2e-d92cac3c5536	41e8530f-95df-4b05-8756-70e2a5d3c930	069e7811-b04d-43d6-b0f0-aed1011ac338	What is the energy of a photon?	["E = hf", "E = mv", "E = IR", "E = pV"]	0	hard	1.00	0.00	28	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Photon energy is proportional to frequency	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:modern_physics:8
22a09dab-66d3-46d1-8812-46c2ad1fb973	41e8530f-95df-4b05-8756-70e2a5d3c930	069e7811-b04d-43d6-b0f0-aed1011ac338	In beta minus decay, which particle is emitted?	["Proton", "Alpha particle", "Electron", "Photon only"]	2	hard	1.00	0.00	29	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Beta minus decay emits an electron	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:modern_physics:9
85128d8a-671f-4772-8378-483b00dd4d72	41e8530f-95df-4b05-8756-70e2a5d3c930	069e7811-b04d-43d6-b0f0-aed1011ac338	A smaller wavelength corresponds to what photon momentum?	["Lower momentum", "Higher momentum", "Zero momentum", "Unchanged momentum"]	1	hard	1.00	0.00	30	2026-08-27 08:41:05.691727+00	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	\N	\N	Photon momentum is inversely proportional to wavelength	\N	2026-08-27 08:41:05.691727+00	t	demo:question:physics:modern_physics:10
30ec410c-0c2b-4ad0-9933-ae75bc178f74	4282a1ae-5f73-41f8-b4fb-af33942add78	f9cdc792-675e-4765-97d9-7d594b0bbff9	A solution with pH 7 is generally considered what?	["Neutral", "Acidic", "Basic", "Supersaturated"]	0	easy	1.00	0.00	41	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	At room temperature, pH 7 indicates neutrality	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:physical_chemistry:1
37d697c2-c3f5-4225-8792-6965123293b1	4282a1ae-5f73-41f8-b4fb-af33942add78	f9cdc792-675e-4765-97d9-7d594b0bbff9	What is the approximate value of Avogadro's number?	["3.14 x 10^8", "6.022 x 10^23", "9.8 x 10^2", "1.6 x 10^-19"]	1	easy	1.00	0.00	42	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Avogadro's number gives particles per mole	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:physical_chemistry:2
24ef0920-7305-48d0-a4c8-ed88ad3633ce	4282a1ae-5f73-41f8-b4fb-af33942add78	f9cdc792-675e-4765-97d9-7d594b0bbff9	An exothermic reaction does what?	["Absorbs heat", "Stops at equilibrium", "Releases heat", "Forms only gases"]	2	easy	1.00	0.00	43	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Exothermic reactions transfer heat to the surroundings	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:physical_chemistry:3
df4889e9-77e4-425b-ae62-9d2baaff35a1	4282a1ae-5f73-41f8-b4fb-af33942add78	f9cdc792-675e-4765-97d9-7d594b0bbff9	Molarity is defined as moles of solute per what?	["Kilogram of solvent", "Litre of solvent", "Mole of water", "Litre of solution"]	3	medium	1.00	0.00	44	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Molarity measures concentration per litre of solution	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:physical_chemistry:4
0b89b1a1-9732-4f0b-9fd2-2fcb02b3411a	4282a1ae-5f73-41f8-b4fb-af33942add78	f9cdc792-675e-4765-97d9-7d594b0bbff9	What does a catalyst do in a reaction?	["Gets consumed permanently", "Speeds the reaction without being consumed", "Lowers reaction yield", "Changes the final equilibrium constant only"]	1	medium	1.00	0.00	45	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Catalysts lower activation energy and are regenerated	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:physical_chemistry:5
8882b642-064b-47de-9ff1-db2aea9432c5	4282a1ae-5f73-41f8-b4fb-af33942add78	f9cdc792-675e-4765-97d9-7d594b0bbff9	Which equation is the ideal gas law?	["E = mc^2", "V = IR", "PV = nRT", "pH = -log H"]	2	medium	1.00	0.00	46	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	The ideal gas law relates pressure, volume, amount, and temperature	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:physical_chemistry:6
ec994a23-a617-4c4e-a2e3-6b891cf76c33	4282a1ae-5f73-41f8-b4fb-af33942add78	f9cdc792-675e-4765-97d9-7d594b0bbff9	If temperature decreases, what usually happens to reaction rate?	["It increases sharply", "It becomes zero for every reaction", "It is unchanged", "It usually decreases"]	3	medium	1.00	0.00	47	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Lower temperature generally means fewer effective collisions	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:physical_chemistry:7
8ffded36-0e9d-4478-b7a9-e897dc9b2d61	4282a1ae-5f73-41f8-b4fb-af33942add78	f9cdc792-675e-4765-97d9-7d594b0bbff9	How many molecules are present in 2 moles of O2?	["2 x Avogadro's number", "Avogadro's number", "4 x Avogadro's number", "Half Avogadro's number"]	0	hard	1.00	0.00	48	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Each mole contains Avogadro's number of molecules	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:physical_chemistry:8
2a41063c-d9a4-4b74-a36c-5c1574536d95	4282a1ae-5f73-41f8-b4fb-af33942add78	f9cdc792-675e-4765-97d9-7d594b0bbff9	If Kc is much greater than 1, equilibrium tends to favor what?	["Reactants", "Only catalysts", "Products", "Only solids"]	2	hard	1.00	0.00	49	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	A large equilibrium constant indicates products are favored	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:physical_chemistry:9
f1446783-3a82-460e-b0cb-acaf28cdc736	4282a1ae-5f73-41f8-b4fb-af33942add78	f9cdc792-675e-4765-97d9-7d594b0bbff9	If delta G is negative under given conditions, the process is what?	["Non-spontaneous", "Spontaneous", "At absolute zero", "Impossible to measure"]	1	hard	1.00	0.00	50	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Negative Gibbs free energy indicates spontaneity	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:physical_chemistry:10
d51696bc-5f7c-4b04-99b8-d8503b08887a	4282a1ae-5f73-41f8-b4fb-af33942add78	a18ba18b-efed-4702-a760-a28adafa5b6d	Methane belongs to which hydrocarbon family?	["Alkane", "Alkene", "Alkyne", "Arene"]	0	easy	1.00	0.00	31	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Methane is a saturated hydrocarbon	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:organic_chemistry:1
c41d4128-b9d6-4d58-abdc-f1a4fc63dae9	4282a1ae-5f73-41f8-b4fb-af33942add78	a18ba18b-efed-4702-a760-a28adafa5b6d	Which functional group defines an alcohol?	["-CHO", "-OH", "-COOH", "-NH2"]	1	easy	1.00	0.00	32	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Alcohols contain the hydroxyl group	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:organic_chemistry:2
6f6ba2a3-7168-4d10-9c12-58c1a7f5d792	4282a1ae-5f73-41f8-b4fb-af33942add78	a18ba18b-efed-4702-a760-a28adafa5b6d	Ethene contains which type of carbon-carbon bond?	["Single bond only", "Triple bond", "Double bond", "Ionic bond"]	2	easy	1.00	0.00	33	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Ethene is an alkene	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:organic_chemistry:3
d9676b4a-3fdd-496c-932d-f1f81217bd05	4282a1ae-5f73-41f8-b4fb-af33942add78	a18ba18b-efed-4702-a760-a28adafa5b6d	What is the polymer formed from ethene called?	["Polystyrene", "PVC", "Nylon", "Polyethylene"]	3	medium	1.00	0.00	34	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Addition polymerization of ethene gives polyethylene	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:organic_chemistry:4
097fd1d4-6f02-4169-884c-bc6dbf6a6171	4282a1ae-5f73-41f8-b4fb-af33942add78	a18ba18b-efed-4702-a760-a28adafa5b6d	Saturated hydrocarbons contain which type of carbon-carbon bonds?	["At least one double bond", "Only single bonds", "At least one triple bond", "Only ionic bonds"]	1	medium	1.00	0.00	35	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Saturated hydrocarbons have only single bonds	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:organic_chemistry:5
6a79a6ee-bae1-45c0-8494-a775721699fd	4282a1ae-5f73-41f8-b4fb-af33942add78	a18ba18b-efed-4702-a760-a28adafa5b6d	What is the molecular formula of benzene?	["C6H12", "C5H6", "C6H6", "C7H8"]	2	medium	1.00	0.00	36	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Benzene is an aromatic ring compound	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:organic_chemistry:6
8a4f935c-8e71-46a4-9627-089a3633f440	4282a1ae-5f73-41f8-b4fb-af33942add78	a18ba18b-efed-4702-a760-a28adafa5b6d	Oxidation of a primary alcohol first commonly forms what?	["Ketone", "Ether", "Amide", "Aldehyde"]	3	medium	1.00	0.00	37	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Primary alcohols oxidize first to aldehydes	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:organic_chemistry:7
698c972a-0e23-4bb7-959f-029379ee2149	4282a1ae-5f73-41f8-b4fb-af33942add78	a18ba18b-efed-4702-a760-a28adafa5b6d	An ester is commonly formed by reacting a carboxylic acid with what?	["An alcohol", "An alkane", "A haloalkane", "A ketone"]	0	hard	1.00	0.00	38	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Esterification joins a carboxylic acid and an alcohol	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:organic_chemistry:8
39ca649f-869b-407c-a24e-e9acd1de7bbc	4282a1ae-5f73-41f8-b4fb-af33942add78	a18ba18b-efed-4702-a760-a28adafa5b6d	What is the IUPAC name of CH3CH2OH?	["Methanol", "Propanol", "Ethanol", "Ethanal"]	2	hard	1.00	0.00	39	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	The molecule has two carbons and an alcohol group	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:organic_chemistry:9
2e71f8e6-364b-4f10-9bf4-4e15294ee275	4282a1ae-5f73-41f8-b4fb-af33942add78	a18ba18b-efed-4702-a760-a28adafa5b6d	An SN1 reaction proceeds through which intermediate?	["Carbanion", "Carbocation", "Free radical", "Diazonium ion"]	1	hard	1.00	0.00	40	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	SN1 substitutions form a carbocation intermediate	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:organic_chemistry:10
79422500-7fe4-4875-81ac-b55a690cc040	4282a1ae-5f73-41f8-b4fb-af33942add78	0499253c-f5bf-4bef-bf4e-ce2064518718	NaCl is best classified as which type of compound?	["Ionic compound", "Covalent molecular compound", "Metal alloy", "Coordination complex"]	0	easy	1.00	0.00	21	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Sodium transfers an electron to chlorine	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:inorganic_chemistry:1
69a3773f-4d98-495e-b375-6bfe09c931b8	4282a1ae-5f73-41f8-b4fb-af33942add78	0499253c-f5bf-4bef-bf4e-ce2064518718	Which family of elements is known for low reactivity?	["Halogens", "Noble gases", "Alkali metals", "Lanthanides"]	1	easy	1.00	0.00	22	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Noble gases have stable valence shells	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:inorganic_chemistry:2
185a74d8-59b0-4b70-b9ac-332f80d16286	4282a1ae-5f73-41f8-b4fb-af33942add78	0499253c-f5bf-4bef-bf4e-ce2064518718	What is the correct name of Fe2O3?	["Iron(II) oxide", "Ferric chloride", "Iron(III) oxide", "Iron peroxide"]	2	easy	1.00	0.00	23	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Oxygen is -2, so iron must be +3	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:inorganic_chemistry:3
f9931577-8614-454f-8bdf-b7c2ddb98ea9	4282a1ae-5f73-41f8-b4fb-af33942add78	0499253c-f5bf-4bef-bf4e-ce2064518718	What is the usual oxidation state of oxygen in compounds?	["+2", "-1", "0", "-2"]	3	medium	1.00	0.00	24	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Oxygen is usually -2 except in peroxides and elemental form	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:inorganic_chemistry:4
67cea1bf-d023-4541-a5d4-59995de2be39	4282a1ae-5f73-41f8-b4fb-af33942add78	0499253c-f5bf-4bef-bf4e-ce2064518718	Aqueous HCl is classified as what?	["Weak acid", "Strong acid", "Strong base", "Neutral salt"]	1	medium	1.00	0.00	25	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Hydrochloric acid ionizes almost completely in water	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:inorganic_chemistry:5
64028004-4039-4d05-8d1e-4d656de4adb3	4282a1ae-5f73-41f8-b4fb-af33942add78	0499253c-f5bf-4bef-bf4e-ce2064518718	Which oxide is amphoteric?	["Na2O", "CO2", "Al2O3", "SO3"]	2	medium	1.00	0.00	26	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Aluminium oxide reacts with both acids and bases	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:inorganic_chemistry:6
0be81396-25a8-47d6-8a5d-95a9aafa5c49	4282a1ae-5f73-41f8-b4fb-af33942add78	0499253c-f5bf-4bef-bf4e-ce2064518718	Why do many transition elements show variable oxidation states?	["They never form ions", "They only form covalent bonds", "They always lose all electrons", "Their d and s electrons have similar energies"]	3	medium	1.00	0.00	27	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Small energy differences let them lose different numbers of electrons	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:inorganic_chemistry:7
e09b4f79-48e0-4e0d-a048-11233dfc888e	4282a1ae-5f73-41f8-b4fb-af33942add78	0499253c-f5bf-4bef-bf4e-ce2064518718	What are the products when CaCO3 is strongly heated?	["CaO and CO2", "Ca and CO3", "Ca(OH)2 and CO", "CaO2 and C"]	0	hard	1.00	0.00	28	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Calcium carbonate thermally decomposes to calcium oxide and carbon dioxide	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:inorganic_chemistry:8
80747644-b79f-45fc-9c84-b0f60165eb61	4282a1ae-5f73-41f8-b4fb-af33942add78	0499253c-f5bf-4bef-bf4e-ce2064518718	What is the coordination number of each ion in the NaCl crystal structure?	["4", "8", "6", "12"]	2	hard	1.00	0.00	29	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Each ion is surrounded by six oppositely charged ions	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:inorganic_chemistry:9
73a6a06f-1423-412c-a51c-bcfc0238f910	4282a1ae-5f73-41f8-b4fb-af33942add78	0499253c-f5bf-4bef-bf4e-ce2064518718	KMnO4 is commonly used as what type of reagent?	["Reducing agent", "Oxidizing agent", "Indicator only", "Buffer solution"]	1	hard	1.00	0.00	30	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Permanganate readily accepts electrons from other substances	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:inorganic_chemistry:10
b66d4cb5-a80e-4ba8-9363-b713f55072aa	4282a1ae-5f73-41f8-b4fb-af33942add78	a2ba3485-e243-49cb-8f76-97ebabfb7007	Which term best matches this description: it is the positively charged particle found in the nucleus?	["Proton", "Atomic number", "Orbital", "p subshell"]	0	easy	1.00	0.00	1	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Proton fits because it is the positively charged particle found in the nucleus.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:atomic_structure:1
077eb448-e29d-48f5-a165-d695b7334e21	4282a1ae-5f73-41f8-b4fb-af33942add78	a2ba3485-e243-49cb-8f76-97ebabfb7007	Which term best matches this description: it equals the number of protons in an atom?	["Orbital", "Atomic number", "p subshell", "Isotope"]	1	easy	1.00	0.00	2	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Atomic number fits because it equals the number of protons in an atom.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:atomic_structure:2
11c95ce0-8a96-4c1d-a054-fa7737b09033	4282a1ae-5f73-41f8-b4fb-af33942add78	a2ba3485-e243-49cb-8f76-97ebabfb7007	Which term best matches this description: it is the region where an electron is most likely to be found?	["p subshell", "Isotope", "Orbital", "Heisenberg uncertainty principle"]	2	easy	1.00	0.00	3	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Orbital fits because it is the region where an electron is most likely to be found.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:atomic_structure:3
8025a1df-c823-4a5f-9a42-70d78fe585c3	4282a1ae-5f73-41f8-b4fb-af33942add78	a2ba3485-e243-49cb-8f76-97ebabfb7007	Which term best matches this description: it can hold a maximum of six electrons?	["Isotope", "Heisenberg uncertainty principle", "Aufbau principle", "p subshell"]	3	medium	1.00	0.00	4	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	p subshell fits because it can hold a maximum of six electrons.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:atomic_structure:4
a0348f5a-5da5-4931-85a8-7532b5eb0f6e	4282a1ae-5f73-41f8-b4fb-af33942add78	a2ba3485-e243-49cb-8f76-97ebabfb7007	Which term best matches this description: it refers to atoms of the same element with different numbers of neutrons?	["Heisenberg uncertainty principle", "Isotope", "Aufbau principle", "d subshell"]	1	medium	1.00	0.00	5	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Isotope fits because it refers to atoms of the same element with different numbers of neutrons.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:atomic_structure:5
19d6e45e-d975-4665-950f-9d91f1b41f15	4282a1ae-5f73-41f8-b4fb-af33942add78	a2ba3485-e243-49cb-8f76-97ebabfb7007	Which term best matches this description: it states that exact position and exact momentum cannot both be known simultaneously?	["Aufbau principle", "d subshell", "Heisenberg uncertainty principle", "Emission spectrum"]	2	medium	1.00	0.00	6	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Heisenberg uncertainty principle fits because it states that exact position and exact momentum cannot both be known simultaneously.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:atomic_structure:6
afc801e2-a942-4c00-8d65-08a87c88bff8	4282a1ae-5f73-41f8-b4fb-af33942add78	a2ba3485-e243-49cb-8f76-97ebabfb7007	Which term best matches this description: it says electrons fill lower-energy orbitals before higher-energy ones?	["d subshell", "Emission spectrum", "Node", "Aufbau principle"]	3	medium	1.00	0.00	7	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Aufbau principle fits because it says electrons fill lower-energy orbitals before higher-energy ones.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:atomic_structure:7
a710da7e-6adf-40de-bad0-55518f64474f	4282a1ae-5f73-41f8-b4fb-af33942add78	a2ba3485-e243-49cb-8f76-97ebabfb7007	Which term best matches this description: it contains five orbitals?	["d subshell", "Emission spectrum", "Node", "Proton"]	0	hard	1.00	0.00	8	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	d subshell fits because it contains five orbitals.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:atomic_structure:8
7158e79a-0f99-47c8-be17-2461e7ba1a0a	4282a1ae-5f73-41f8-b4fb-af33942add78	a2ba3485-e243-49cb-8f76-97ebabfb7007	Which term best matches this description: it is produced when electrons fall from higher to lower energy levels?	["Node", "Proton", "Emission spectrum", "Atomic number"]	2	hard	1.00	0.00	9	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Emission spectrum fits because it is produced when electrons fall from higher to lower energy levels.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:atomic_structure:9
473083d5-34d3-4ed3-a2e9-8d532ddc3e0e	4282a1ae-5f73-41f8-b4fb-af33942add78	a2ba3485-e243-49cb-8f76-97ebabfb7007	Which term best matches this description: it is a region where the probability of finding an electron is zero?	["Proton", "Node", "Atomic number", "Orbital"]	1	hard	1.00	0.00	10	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Node fits because it is a region where the probability of finding an electron is zero.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:atomic_structure:10
40000de8-de1c-463a-a658-252920df4f1f	4282a1ae-5f73-41f8-b4fb-af33942add78	a62b5e09-c0be-4d50-92a1-966376b743f9	Which term best matches this description: it forms when atoms share electron pairs?	["Covalent bond", "Ionic bond", "Bent shape", "VSEPR theory"]	0	easy	1.00	0.00	11	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Covalent bond fits because it forms when atoms share electron pairs.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:chemical_bonding:1
00433d57-1d0c-4d96-b4c8-57781290aa47	4282a1ae-5f73-41f8-b4fb-af33942add78	a62b5e09-c0be-4d50-92a1-966376b743f9	Which term best matches this description: it forms when electrons are transferred between atoms?	["Bent shape", "Ionic bond", "VSEPR theory", "Sigma bond"]	1	easy	1.00	0.00	12	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Ionic bond fits because it forms when electrons are transferred between atoms.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:chemical_bonding:2
909d0607-9aa6-4630-a92c-1424b2fad20b	4282a1ae-5f73-41f8-b4fb-af33942add78	a62b5e09-c0be-4d50-92a1-966376b743f9	Which term best matches this description: it describes the molecular geometry of water?	["VSEPR theory", "Sigma bond", "Bent shape", "Hydrogen bond"]	2	easy	1.00	0.00	13	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Bent shape fits because it describes the molecular geometry of water.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:chemical_bonding:3
3ebcff01-56dc-43e6-bbeb-697812fb3ba4	4282a1ae-5f73-41f8-b4fb-af33942add78	a62b5e09-c0be-4d50-92a1-966376b743f9	Which term best matches this description: it predicts molecular shape from electron-pair repulsion?	["Sigma bond", "Hydrogen bond", "Trigonal planar", "VSEPR theory"]	3	medium	1.00	0.00	14	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	VSEPR theory fits because it predicts molecular shape from electron-pair repulsion.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:chemical_bonding:4
293bf7b0-3281-43a7-a32e-5673db2c55f1	4282a1ae-5f73-41f8-b4fb-af33942add78	a62b5e09-c0be-4d50-92a1-966376b743f9	Which term best matches this description: it is formed by head-on overlap along the internuclear axis?	["Hydrogen bond", "Sigma bond", "Trigonal planar", "Bond order 3"]	1	medium	1.00	0.00	15	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Sigma bond fits because it is formed by head-on overlap along the internuclear axis.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:chemical_bonding:5
0dcc338b-b3b1-4104-a697-b37599bd0e49	4282a1ae-5f73-41f8-b4fb-af33942add78	a62b5e09-c0be-4d50-92a1-966376b743f9	Which term best matches this description: it is the intermolecular attraction commonly found between water molecules?	["Trigonal planar", "Bond order 3", "Hydrogen bond", "sp3 hybridization"]	2	medium	1.00	0.00	16	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Hydrogen bond fits because it is the intermolecular attraction commonly found between water molecules.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:chemical_bonding:6
7b8dd8f7-34da-4fbd-8c75-03b263d58930	4282a1ae-5f73-41f8-b4fb-af33942add78	a62b5e09-c0be-4d50-92a1-966376b743f9	Which term best matches this description: it is the geometry of BF3?	["Bond order 3", "sp3 hybridization", "Bond polarity", "Trigonal planar"]	3	medium	1.00	0.00	17	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Trigonal planar fits because it is the geometry of bf3.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:chemical_bonding:7
3fca2c28-66c3-44c1-8135-25718e137a2e	4282a1ae-5f73-41f8-b4fb-af33942add78	a62b5e09-c0be-4d50-92a1-966376b743f9	Which term best matches this description: it describes the bond order in N2?	["Bond order 3", "sp3 hybridization", "Bond polarity", "Covalent bond"]	0	hard	1.00	0.00	18	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Bond order 3 fits because it describes the bond order in n2.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:chemical_bonding:8
ef1f4850-dcef-4bf3-9211-ed3b9d58bc30	4282a1ae-5f73-41f8-b4fb-af33942add78	a62b5e09-c0be-4d50-92a1-966376b743f9	Which term best matches this description: it is associated with a tetrahedral arrangement around the central atom?	["Bond polarity", "Covalent bond", "sp3 hybridization", "Ionic bond"]	2	hard	1.00	0.00	19	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	sp3 hybridization fits because it is associated with a tetrahedral arrangement around the central atom.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:chemical_bonding:9
9b51ad95-e193-4075-9c86-474f971d8a82	4282a1ae-5f73-41f8-b4fb-af33942add78	a62b5e09-c0be-4d50-92a1-966376b743f9	Which term best matches this description: it increases when the electronegativity difference between bonded atoms becomes larger?	["Covalent bond", "Bond polarity", "Ionic bond", "Bent shape"]	1	hard	1.00	0.00	20	2026-08-27 08:41:05.691727+00	9481ac62-4ea8-48a2-8776-33ed020858bb	\N	\N	Bond polarity fits because it increases when the electronegativity difference between bonded atoms becomes larger.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:chemistry:chemical_bonding:10
7d0113e4-e3a5-4158-aaf6-d53ad731657c	222121d7-4b4e-4007-bf5e-3fb8a5400450	555e4b81-5e7e-4ab5-8e0e-fb7509dac1e9	Which term best matches this description: they are commonly called the powerhouse of the cell because they generate ATP?	["Mitochondria", "Cell membrane", "Ribosomes", "Cell wall"]	0	easy	1.00	0.00	1	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Mitochondria fits because they are commonly called the powerhouse of the cell because they generate atp.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:cell_biology:1
aae368a6-a852-4561-a881-57784260bff6	222121d7-4b4e-4007-bf5e-3fb8a5400450	555e4b81-5e7e-4ab5-8e0e-fb7509dac1e9	Which term best matches this description: it is selectively permeable and regulates what enters and leaves the cell?	["Ribosomes", "Cell membrane", "Cell wall", "Osmosis"]	1	easy	1.00	0.00	2	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Cell membrane fits because it is selectively permeable and regulates what enters and leaves the cell.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:cell_biology:2
9e70c00a-5f52-4f70-bd37-13dc68fff842	222121d7-4b4e-4007-bf5e-3fb8a5400450	555e4b81-5e7e-4ab5-8e0e-fb7509dac1e9	Which term best matches this description: they are the organelles responsible for protein synthesis?	["Cell wall", "Osmosis", "Ribosomes", "Golgi apparatus"]	2	easy	1.00	0.00	3	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Ribosomes fits because they are the organelles responsible for protein synthesis.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:cell_biology:3
95eb5c8c-a545-48bf-a37b-b3153ee43ef8	222121d7-4b4e-4007-bf5e-3fb8a5400450	555e4b81-5e7e-4ab5-8e0e-fb7509dac1e9	Which term best matches this description: it is the rigid outer layer present in plant cells?	["Osmosis", "Golgi apparatus", "Lysosome", "Cell wall"]	3	medium	1.00	0.00	4	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Cell wall fits because it is the rigid outer layer present in plant cells.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:cell_biology:4
47404c6d-0bef-4501-bc4e-b7728ef89709	222121d7-4b4e-4007-bf5e-3fb8a5400450	555e4b81-5e7e-4ab5-8e0e-fb7509dac1e9	Which term best matches this description: it is the movement of water across a semipermeable membrane?	["Golgi apparatus", "Osmosis", "Lysosome", "Mitosis"]	1	medium	1.00	0.00	5	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Osmosis fits because it is the movement of water across a semipermeable membrane.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:cell_biology:5
b00190a6-7a18-4755-8dc8-3b08491d59bb	222121d7-4b4e-4007-bf5e-3fb8a5400450	555e4b81-5e7e-4ab5-8e0e-fb7509dac1e9	Which term best matches this description: it modifies, sorts, and packages proteins for transport?	["Lysosome", "Mitosis", "Golgi apparatus", "Rough endoplasmic reticulum"]	2	medium	1.00	0.00	6	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Golgi apparatus fits because it modifies, sorts, and packages proteins for transport.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:cell_biology:6
cf6c5f7f-45b0-405b-b172-315bc4fab10e	222121d7-4b4e-4007-bf5e-3fb8a5400450	555e4b81-5e7e-4ab5-8e0e-fb7509dac1e9	Which term best matches this description: it contains digestive enzymes used to break down materials?	["Mitosis", "Rough endoplasmic reticulum", "ATP", "Lysosome"]	3	medium	1.00	0.00	7	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Lysosome fits because it contains digestive enzymes used to break down materials.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:cell_biology:7
5d20a457-0c05-42a5-9449-0f6c25cd8d08	222121d7-4b4e-4007-bf5e-3fb8a5400450	555e4b81-5e7e-4ab5-8e0e-fb7509dac1e9	Which term best matches this description: it produces two genetically identical daughter cells?	["Mitosis", "Rough endoplasmic reticulum", "ATP", "Mitochondria"]	0	hard	1.00	0.00	8	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Mitosis fits because it produces two genetically identical daughter cells.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:cell_biology:8
ebb7dc34-a985-4e40-a8af-7956e6c347c6	222121d7-4b4e-4007-bf5e-3fb8a5400450	555e4b81-5e7e-4ab5-8e0e-fb7509dac1e9	Which term best matches this description: it is studded with ribosomes and helps process proteins?	["ATP", "Mitochondria", "Rough endoplasmic reticulum", "Cell membrane"]	2	hard	1.00	0.00	9	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Rough endoplasmic reticulum fits because it is studded with ribosomes and helps process proteins.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:cell_biology:9
8cdbac2a-9730-4b03-9ec8-9c01346012f7	222121d7-4b4e-4007-bf5e-3fb8a5400450	555e4b81-5e7e-4ab5-8e0e-fb7509dac1e9	Which term best matches this description: it is the cell's main immediate energy currency?	["Mitochondria", "ATP", "Cell membrane", "Ribosomes"]	1	hard	1.00	0.00	10	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	ATP fits because it is the cell's main immediate energy currency.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:cell_biology:10
86350298-a68d-4675-ae30-36e9e5e854e9	222121d7-4b4e-4007-bf5e-3fb8a5400450	3da0d169-98b8-4dbe-8d28-7a33f12b9b73	Which term best matches this description: it is the hereditary molecule arranged as a double helix?	["DNA", "Gene", "Dominant allele", "Homozygous"]	0	easy	1.00	0.00	31	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	DNA fits because it is the hereditary molecule arranged as a double helix.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:genetics:1
ef2f76cd-8164-4c4d-afc0-c643f2539567	222121d7-4b4e-4007-bf5e-3fb8a5400450	3da0d169-98b8-4dbe-8d28-7a33f12b9b73	Which term best matches this description: it is the basic unit of heredity?	["Dominant allele", "Gene", "Homozygous", "Pea plants"]	1	easy	1.00	0.00	32	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Gene fits because it is the basic unit of heredity.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:genetics:2
b7950133-f1a2-4837-8386-b33f68d43885	222121d7-4b4e-4007-bf5e-3fb8a5400450	3da0d169-98b8-4dbe-8d28-7a33f12b9b73	Which term best matches this description: it is expressed in the heterozygous state?	["Homozygous", "Pea plants", "Dominant allele", "Codon"]	2	easy	1.00	0.00	33	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Dominant allele fits because it is expressed in the heterozygous state.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:genetics:3
c4161661-f155-4a0b-a0b4-d39649a0ae64	222121d7-4b4e-4007-bf5e-3fb8a5400450	3da0d169-98b8-4dbe-8d28-7a33f12b9b73	Which term best matches this description: it means having two identical alleles for a trait?	["Pea plants", "Codon", "Meiosis", "Homozygous"]	3	medium	1.00	0.00	34	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Homozygous fits because it means having two identical alleles for a trait.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:genetics:4
793177de-2f9b-4508-ae76-65131ba1a8de	222121d7-4b4e-4007-bf5e-3fb8a5400450	3da0d169-98b8-4dbe-8d28-7a33f12b9b73	Which term best matches this description: they were used by Mendel in his classic inheritance experiments?	["Codon", "Pea plants", "Meiosis", "Crossing over"]	1	medium	1.00	0.00	35	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Pea plants fits because they were used by mendel in his classic inheritance experiments.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:genetics:5
de52162a-c31d-4664-81a3-c8fc9785584f	222121d7-4b4e-4007-bf5e-3fb8a5400450	3da0d169-98b8-4dbe-8d28-7a33f12b9b73	Which term best matches this description: it is a sequence of three nucleotides in genetic code?	["Meiosis", "Crossing over", "Codon", "X chromosome"]	2	medium	1.00	0.00	36	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Codon fits because it is a sequence of three nucleotides in genetic code.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:genetics:6
f4d6994c-4079-4ec3-8108-f93ed2b41a55	222121d7-4b4e-4007-bf5e-3fb8a5400450	3da0d169-98b8-4dbe-8d28-7a33f12b9b73	Which term best matches this description: it reduces chromosome number by half to form gametes?	["Crossing over", "X chromosome", "Tt offspring", "Meiosis"]	3	medium	1.00	0.00	37	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Meiosis fits because it reduces chromosome number by half to form gametes.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:genetics:7
78b6d7e1-7a70-4fca-bcce-b7028520715e	d8084811-1a21-4e12-af30-4fecb20d0454	6d1dcf73-7718-4bff-a9ea-e67912db5f6e	Which term best matches this description: it is a query nested inside another SQL statement?	["SELECT", "Subquery", "WHERE", "COUNT"]	1	hard	1.00	0.00	40	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Subquery fits because it is a query nested inside another sql statement.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:sql:10
0ccd5902-c94b-4125-9b53-6fa519e58610	222121d7-4b4e-4007-bf5e-3fb8a5400450	3da0d169-98b8-4dbe-8d28-7a33f12b9b73	Which term best matches this description: it occurs during prophase I of meiosis and exchanges genetic material?	["Crossing over", "X chromosome", "Tt offspring", "DNA"]	0	hard	1.00	0.00	38	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Crossing over fits because it occurs during prophase i of meiosis and exchanges genetic material.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:genetics:8
1bccc684-d95f-4edd-b320-379ff84fc8e3	222121d7-4b4e-4007-bf5e-3fb8a5400450	3da0d169-98b8-4dbe-8d28-7a33f12b9b73	Which term best matches this description: it often carries genes linked to many sex-linked disorders?	["Tt offspring", "DNA", "X chromosome", "Gene"]	2	hard	1.00	0.00	39	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	X chromosome fits because it often carries genes linked to many sex-linked disorders.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:genetics:9
3f09a20b-71fc-403f-8420-cd9e8f1b661d	222121d7-4b4e-4007-bf5e-3fb8a5400450	3da0d169-98b8-4dbe-8d28-7a33f12b9b73	Which term best matches this description: it is the genotype of every offspring from a TT x tt cross?	["DNA", "Tt offspring", "Gene", "Dominant allele"]	1	hard	1.00	0.00	40	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Tt offspring fits because it is the genotype of every offspring from a tt x tt cross.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:genetics:10
643c49ac-3b76-474c-9c39-b7b2e2d55d50	222121d7-4b4e-4007-bf5e-3fb8a5400450	a09782cd-2594-4ad1-8bb9-2cb0c474a2ee	Which term best matches this description: it pumps blood throughout the body?	["Heart", "Hemoglobin", "Nephron", "Insulin"]	0	easy	1.00	0.00	41	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Heart fits because it pumps blood throughout the body.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:human_physiology:1
5cf4f9f4-9919-4f6c-87b0-e209278f6d0a	222121d7-4b4e-4007-bf5e-3fb8a5400450	a09782cd-2594-4ad1-8bb9-2cb0c474a2ee	Which term best matches this description: it carries oxygen in red blood cells?	["Nephron", "Hemoglobin", "Insulin", "Trachea"]	1	easy	1.00	0.00	42	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Hemoglobin fits because it carries oxygen in red blood cells.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:human_physiology:2
be7e0ccb-80c6-41c7-82a6-8275244a1736	222121d7-4b4e-4007-bf5e-3fb8a5400450	a09782cd-2594-4ad1-8bb9-2cb0c474a2ee	Which term best matches this description: it is the functional unit of the kidney?	["Insulin", "Trachea", "Nephron", "Cerebellum"]	2	easy	1.00	0.00	43	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Nephron fits because it is the functional unit of the kidney.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:human_physiology:3
18628da1-1325-4dbc-a89c-546f628fe8ae	222121d7-4b4e-4007-bf5e-3fb8a5400450	a09782cd-2594-4ad1-8bb9-2cb0c474a2ee	Which term best matches this description: it lowers blood glucose concentration?	["Trachea", "Cerebellum", "Alveoli", "Insulin"]	3	medium	1.00	0.00	44	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Insulin fits because it lowers blood glucose concentration.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:human_physiology:4
4207e598-5f51-4511-be1e-a08a8984c63f	222121d7-4b4e-4007-bf5e-3fb8a5400450	a09782cd-2594-4ad1-8bb9-2cb0c474a2ee	Which term best matches this description: it carries air from the throat toward the lungs?	["Cerebellum", "Trachea", "Alveoli", "Four chambers"]	1	medium	1.00	0.00	45	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Trachea fits because it carries air from the throat toward the lungs.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:human_physiology:5
2ba369a0-f4b5-4827-a48c-9d6ef65219e7	222121d7-4b4e-4007-bf5e-3fb8a5400450	a09782cd-2594-4ad1-8bb9-2cb0c474a2ee	Which term best matches this description: it helps coordinate balance and fine movement?	["Alveoli", "Four chambers", "Cerebellum", "ADH"]	2	medium	1.00	0.00	46	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Cerebellum fits because it helps coordinate balance and fine movement.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:human_physiology:6
570088b6-9bef-42d0-850d-58ed31c6fc64	222121d7-4b4e-4007-bf5e-3fb8a5400450	a09782cd-2594-4ad1-8bb9-2cb0c474a2ee	Which term best matches this description: they are the tiny sacs where gas exchange occurs in the lungs?	["Four chambers", "ADH", "Thyroid gland", "Alveoli"]	3	medium	1.00	0.00	47	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Alveoli fits because they are the tiny sacs where gas exchange occurs in the lungs.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:human_physiology:7
33895a6f-227b-48d0-ad87-a1c0b5e6b123	222121d7-4b4e-4007-bf5e-3fb8a5400450	a09782cd-2594-4ad1-8bb9-2cb0c474a2ee	Which term best matches this description: it is the number of chambers in the human heart?	["Four chambers", "ADH", "Thyroid gland", "Heart"]	0	hard	1.00	0.00	48	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Four chambers fits because it is the number of chambers in the human heart.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:human_physiology:8
04156fee-9433-496a-94c2-b2d68afe1acf	222121d7-4b4e-4007-bf5e-3fb8a5400450	a09782cd-2594-4ad1-8bb9-2cb0c474a2ee	Which term best matches this description: it increases water reabsorption in the kidneys?	["Thyroid gland", "Heart", "ADH", "Hemoglobin"]	2	hard	1.00	0.00	49	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	ADH fits because it increases water reabsorption in the kidneys.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:human_physiology:9
a6e76399-8ecd-4455-a6a3-2d90060a8d13	222121d7-4b4e-4007-bf5e-3fb8a5400450	a09782cd-2594-4ad1-8bb9-2cb0c474a2ee	Which term best matches this description: it secretes the hormone thyroxine?	["Heart", "Thyroid gland", "Hemoglobin", "Nephron"]	1	hard	1.00	0.00	50	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Thyroid gland fits because it secretes the hormone thyroxine.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:human_physiology:10
4b20328e-52d3-464e-a78f-dff379d75a7d	222121d7-4b4e-4007-bf5e-3fb8a5400450	b6f7da6a-8454-4074-9713-ec2cfac0827a	Which term best matches this description: it includes organisms and their physical environment interacting together?	["Ecosystem", "Producers", "Energy loss", "Symbiosis"]	0	easy	1.00	0.00	11	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Ecosystem fits because it includes organisms and their physical environment interacting together.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:ecology:1
41cab20a-6347-40a4-b328-71d2ad824a8e	222121d7-4b4e-4007-bf5e-3fb8a5400450	b6f7da6a-8454-4074-9713-ec2cfac0827a	Which term best matches this description: they make their own food, usually by photosynthesis?	["Energy loss", "Producers", "Symbiosis", "Decomposers"]	1	easy	1.00	0.00	12	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Producers fits because they make their own food, usually by photosynthesis.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:ecology:2
9ef575cb-a502-4eb7-b8f0-a6c4549c6bab	222121d7-4b4e-4007-bf5e-3fb8a5400450	b6f7da6a-8454-4074-9713-ec2cfac0827a	Which term best matches this description: it explains why less energy is available at higher trophic levels?	["Symbiosis", "Decomposers", "Energy loss", "Carrying capacity"]	2	easy	1.00	0.00	13	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Energy loss fits because it explains why less energy is available at higher trophic levels.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:ecology:3
a8bcb7b3-5494-4873-a6a9-5a9f7a6e4343	222121d7-4b4e-4007-bf5e-3fb8a5400450	b6f7da6a-8454-4074-9713-ec2cfac0827a	Which term best matches this description: it is a close biological association between different species?	["Decomposers", "Carrying capacity", "Greenhouse gases", "Symbiosis"]	3	medium	1.00	0.00	14	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Symbiosis fits because it is a close biological association between different species.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:ecology:4
63d7a8ef-8fda-4d95-8cba-6fadb19fa3f1	222121d7-4b4e-4007-bf5e-3fb8a5400450	b6f7da6a-8454-4074-9713-ec2cfac0827a	Which term best matches this description: they recycle nutrients by breaking down dead organic matter?	["Carrying capacity", "Decomposers", "Greenhouse gases", "Mutualism"]	1	medium	1.00	0.00	15	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Decomposers fits because they recycle nutrients by breaking down dead organic matter.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:ecology:5
4c792ba0-f9d2-4b44-97ec-fcce8b335d8b	222121d7-4b4e-4007-bf5e-3fb8a5400450	b6f7da6a-8454-4074-9713-ec2cfac0827a	Which term best matches this description: it is the maximum population size an environment can support?	["Greenhouse gases", "Mutualism", "Carrying capacity", "Biomagnification"]	2	medium	1.00	0.00	16	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Carrying capacity fits because it is the maximum population size an environment can support.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:ecology:6
fb185f4b-537e-47c7-8bef-80974ee70a84	222121d7-4b4e-4007-bf5e-3fb8a5400450	b6f7da6a-8454-4074-9713-ec2cfac0827a	Which term best matches this description: they contribute to global warming by trapping heat?	["Mutualism", "Biomagnification", "Nitrogen fixation", "Greenhouse gases"]	3	medium	1.00	0.00	17	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Greenhouse gases fits because they contribute to global warming by trapping heat.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:ecology:7
16aabbdc-8900-471c-b75c-5caef90490d1	222121d7-4b4e-4007-bf5e-3fb8a5400450	b6f7da6a-8454-4074-9713-ec2cfac0827a	Which term best matches this description: it is the interaction shown by lichens in standard textbook examples?	["Mutualism", "Biomagnification", "Nitrogen fixation", "Ecosystem"]	0	hard	1.00	0.00	18	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Mutualism fits because it is the interaction shown by lichens in standard textbook examples.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:ecology:8
8e4b0293-ed8e-49e6-b36e-d82470a7cef5	222121d7-4b4e-4007-bf5e-3fb8a5400450	b6f7da6a-8454-4074-9713-ec2cfac0827a	Which term best matches this description: it is the increase in toxin concentration at higher trophic levels?	["Nitrogen fixation", "Ecosystem", "Biomagnification", "Producers"]	2	hard	1.00	0.00	19	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Biomagnification fits because it is the increase in toxin concentration at higher trophic levels.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:ecology:9
4c2cd1f1-59c9-4096-ac7f-625c6a990d95	222121d7-4b4e-4007-bf5e-3fb8a5400450	b6f7da6a-8454-4074-9713-ec2cfac0827a	Which term best matches this description: it converts atmospheric nitrogen into forms usable by living organisms?	["Ecosystem", "Nitrogen fixation", "Producers", "Energy loss"]	1	hard	1.00	0.00	20	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Nitrogen fixation fits because it converts atmospheric nitrogen into forms usable by living organisms.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:ecology:10
b9d88a02-7c7b-4a8a-a72e-83fa4bef1700	222121d7-4b4e-4007-bf5e-3fb8a5400450	5fc21423-3176-4ecf-a939-125ebe195ebb	Which term best matches this description: it is the mechanism proposed by Darwin to explain adaptation?	["Natural selection", "Variation", "Fossils", "Homologous structures"]	0	easy	1.00	0.00	21	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Natural selection fits because it is the mechanism proposed by darwin to explain adaptation.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:evolution:1
a9ff3fc1-f97e-47c7-8197-a11b5159b9df	222121d7-4b4e-4007-bf5e-3fb8a5400450	5fc21423-3176-4ecf-a939-125ebe195ebb	Which term best matches this description: it is necessary for selection to act within a population?	["Fossils", "Variation", "Homologous structures", "Adaptation"]	1	easy	1.00	0.00	22	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Variation fits because it is necessary for selection to act within a population.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:evolution:2
3f1297d9-6e49-418d-b15d-59e9cec6a9b1	222121d7-4b4e-4007-bf5e-3fb8a5400450	5fc21423-3176-4ecf-a939-125ebe195ebb	Which term best matches this description: they provide evidence of past life and evolutionary change?	["Homologous structures", "Adaptation", "Fossils", "Mutation"]	2	easy	1.00	0.00	23	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Fossils fits because they provide evidence of past life and evolutionary change.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:evolution:3
8293d655-3f0e-4e41-aaef-1baca4261d0e	222121d7-4b4e-4007-bf5e-3fb8a5400450	5fc21423-3176-4ecf-a939-125ebe195ebb	Which term best matches this description: they indicate common ancestry despite possible functional differences?	["Adaptation", "Mutation", "Antibiotic resistance", "Homologous structures"]	3	medium	1.00	0.00	24	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Homologous structures fits because they indicate common ancestry despite possible functional differences.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:evolution:4
f2f5fe38-2d23-4b5c-8c78-49d46a5bb86f	222121d7-4b4e-4007-bf5e-3fb8a5400450	5fc21423-3176-4ecf-a939-125ebe195ebb	Which term best matches this description: it increases an organism's chances of survival and reproduction?	["Mutation", "Adaptation", "Antibiotic resistance", "Hardy-Weinberg equilibrium"]	1	medium	1.00	0.00	25	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Adaptation fits because it increases an organism's chances of survival and reproduction.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:evolution:5
39aad460-9feb-41fe-80ff-c7a82cf5689f	222121d7-4b4e-4007-bf5e-3fb8a5400450	5fc21423-3176-4ecf-a939-125ebe195ebb	Which term best matches this description: it is a source of new genetic variation?	["Antibiotic resistance", "Hardy-Weinberg equilibrium", "Mutation", "Reproductive isolation"]	2	medium	1.00	0.00	26	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Mutation fits because it is a source of new genetic variation.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:evolution:6
744c5ad0-735f-4c09-8897-5446c794156e	222121d7-4b4e-4007-bf5e-3fb8a5400450	5fc21423-3176-4ecf-a939-125ebe195ebb	Which term best matches this description: it is a modern example of natural selection in action?	["Hardy-Weinberg equilibrium", "Reproductive isolation", "Analogous structures", "Antibiotic resistance"]	3	medium	1.00	0.00	27	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Antibiotic resistance fits because it is a modern example of natural selection in action.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:evolution:7
55c4a4a5-146a-46b0-a220-f3f5de33d801	222121d7-4b4e-4007-bf5e-3fb8a5400450	5fc21423-3176-4ecf-a939-125ebe195ebb	Which term best matches this description: it describes a population expected to show no evolution under ideal conditions?	["Hardy-Weinberg equilibrium", "Reproductive isolation", "Analogous structures", "Natural selection"]	0	hard	1.00	0.00	28	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Hardy-Weinberg equilibrium fits because it describes a population expected to show no evolution under ideal conditions.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:evolution:8
f803fde1-7370-4560-89c3-834d909fe08e	222121d7-4b4e-4007-bf5e-3fb8a5400450	5fc21423-3176-4ecf-a939-125ebe195ebb	Which term best matches this description: it often marks the beginning of speciation?	["Analogous structures", "Natural selection", "Reproductive isolation", "Variation"]	2	hard	1.00	0.00	29	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Reproductive isolation fits because it often marks the beginning of speciation.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:evolution:9
218fc3bc-b712-4b00-a0ea-8579926c8fff	222121d7-4b4e-4007-bf5e-3fb8a5400450	5fc21423-3176-4ecf-a939-125ebe195ebb	Which term best matches this description: they have similar function but do not imply common origin?	["Natural selection", "Analogous structures", "Variation", "Fossils"]	1	hard	1.00	0.00	30	2026-08-27 08:41:05.691727+00	bdc56824-3354-4558-963e-94033af7162c	\N	\N	Analogous structures fits because they have similar function but do not imply common origin.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:biology:evolution:10
1a8e9c2b-8747-4960-8928-73ecda17b084	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	bf000091-f969-4b71-8b1e-d1ee4fc86c5d	Which term best matches this description: it stores a value that a program can read or change?	["Variable", "Conditional statement", "Loop", "Array"]	0	easy	1.00	0.00	31	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Variable fits because it stores a value that a program can read or change.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:programming_fundamentals:1
76c6a9ad-d05f-47f3-8510-0054d1e03545	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	bf000091-f969-4b71-8b1e-d1ee4fc86c5d	Which term best matches this description: it lets a program choose between branches based on a test?	["Loop", "Conditional statement", "Array", "Function"]	1	easy	1.00	0.00	32	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Conditional statement fits because it lets a program choose between branches based on a test.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:programming_fundamentals:2
5f824616-e3f3-4f15-a8b6-0b4fa3e379f6	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	bf000091-f969-4b71-8b1e-d1ee4fc86c5d	Which term best matches this description: it repeats a block of instructions until a condition changes?	["Array", "Function", "Loop", "Compile-time error"]	2	easy	1.00	0.00	33	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Loop fits because it repeats a block of instructions until a condition changes.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:programming_fundamentals:3
98bf1b4f-6d03-4213-aba1-3afd89e7c44f	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	9b2053a5-dd87-43a2-9bb7-56c77e52b37f	What comes next in the series 1, 1, 2, 3, 5?	["6", "7", "8", "9"]	2	easy	1.00	0.00	23	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Each term is the sum of the previous two	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:number_series:3
b820af3c-d84f-46ad-852a-2629464c2ef7	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	bf000091-f969-4b71-8b1e-d1ee4fc86c5d	Which term best matches this description: it stores multiple values of the same type under one name?	["Function", "Compile-time error", "Recursion", "Array"]	3	medium	1.00	0.00	34	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Array fits because it stores multiple values of the same type under one name.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:programming_fundamentals:4
dad206f7-f340-476f-8776-e8d44f8b1a2d	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	bf000091-f969-4b71-8b1e-d1ee4fc86c5d	Which term best matches this description: it packages reusable logic into a callable unit?	["Compile-time error", "Function", "Recursion", "Stack overflow"]	1	medium	1.00	0.00	35	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Function fits because it packages reusable logic into a callable unit.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:programming_fundamentals:5
29fe5079-6af0-46bd-85a0-5307fa0172f8	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	bf000091-f969-4b71-8b1e-d1ee4fc86c5d	Which term best matches this description: it is detected before a program successfully runs?	["Recursion", "Stack overflow", "Compile-time error", "Linear search"]	2	medium	1.00	0.00	36	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Compile-time error fits because it is detected before a program successfully runs.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:programming_fundamentals:6
59d8b4b0-bf94-4edf-ba80-b648e7068827	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	bf000091-f969-4b71-8b1e-d1ee4fc86c5d	Which term best matches this description: it occurs when a function calls itself to solve subproblems?	["Stack overflow", "Linear search", "Immutable object", "Recursion"]	3	medium	1.00	0.00	37	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Recursion fits because it occurs when a function calls itself to solve subproblems.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:programming_fundamentals:7
c78b5f04-1bd4-4198-be9e-10efd7db2c42	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	bf000091-f969-4b71-8b1e-d1ee4fc86c5d	Which term best matches this description: it often happens when recursive calls never terminate properly?	["Stack overflow", "Linear search", "Immutable object", "Variable"]	0	hard	1.00	0.00	38	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Stack overflow fits because it often happens when recursive calls never terminate properly.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:programming_fundamentals:8
5f0845f2-e5f5-4ba3-a739-52f713ee6b2e	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	bf000091-f969-4b71-8b1e-d1ee4fc86c5d	Which term best matches this description: it checks elements one by one until a match is found?	["Immutable object", "Variable", "Linear search", "Conditional statement"]	2	hard	1.00	0.00	39	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Linear search fits because it checks elements one by one until a match is found.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:programming_fundamentals:9
a575b35b-790a-4d6a-8056-4b7f3608054c	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	bf000091-f969-4b71-8b1e-d1ee4fc86c5d	Which term best matches this description: it cannot be changed after it is created?	["Variable", "Immutable object", "Conditional statement", "Loop"]	1	hard	1.00	0.00	40	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Immutable object fits because it cannot be changed after it is created.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:programming_fundamentals:10
11e6276d-517f-45ac-975c-0b4b93816e46	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	62ab8bcc-63ac-4195-ab34-0105cf2454d0	Which term best matches this description: it identifies a host on a network?	["IP address", "Router", "HTTP", "TCP"]	0	easy	1.00	0.00	11	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	IP address fits because it identifies a host on a network.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_networks:1
f7180358-8ef2-4bf9-b661-c19227dbefef	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	62ab8bcc-63ac-4195-ab34-0105cf2454d0	Which term best matches this description: it forwards packets between different networks?	["HTTP", "Router", "TCP", "DNS"]	1	easy	1.00	0.00	12	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Router fits because it forwards packets between different networks.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_networks:2
acc3cac5-3ab3-4e37-a8c1-f3b11b2104d1	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	62ab8bcc-63ac-4195-ab34-0105cf2454d0	Which term best matches this description: it is an application-layer protocol for web communication?	["TCP", "DNS", "HTTP", "Switch"]	2	easy	1.00	0.00	13	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	HTTP fits because it is an application-layer protocol for web communication.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_networks:3
bda080c9-90e6-4d54-a211-264a9fcac2f3	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	62ab8bcc-63ac-4195-ab34-0105cf2454d0	Which term best matches this description: it is a reliable and connection-oriented transport protocol?	["DNS", "Switch", "HTTPS", "TCP"]	3	medium	1.00	0.00	14	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	TCP fits because it is a reliable and connection-oriented transport protocol.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_networks:4
f8cca473-cf47-44da-89b3-76745dcbb011	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	62ab8bcc-63ac-4195-ab34-0105cf2454d0	Which term best matches this description: it translates domain names into IP addresses?	["Switch", "DNS", "HTTPS", "Port 80"]	1	medium	1.00	0.00	15	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	DNS fits because it translates domain names into ip addresses.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_networks:5
1d47a868-1630-4b61-b94c-3afa1c8c3087	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	62ab8bcc-63ac-4195-ab34-0105cf2454d0	Which term best matches this description: it primarily forwards frames within a local network?	["HTTPS", "Port 80", "Switch", "Subnet mask"]	2	medium	1.00	0.00	16	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Switch fits because it primarily forwards frames within a local network.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_networks:6
548ec1ad-30fb-4d4a-a33c-3e4625831391	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	62ab8bcc-63ac-4195-ab34-0105cf2454d0	Which term best matches this description: it secures HTTP traffic using TLS encryption?	["Port 80", "Subnet mask", "Round-trip time", "HTTPS"]	3	medium	1.00	0.00	17	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	HTTPS fits because it secures http traffic using tls encryption.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_networks:7
a18b414a-0eaf-4cf0-ba94-b327abe17dc4	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	62ab8bcc-63ac-4195-ab34-0105cf2454d0	Which term best matches this description: it is the default port commonly associated with HTTP?	["Port 80", "Subnet mask", "Round-trip time", "IP address"]	0	hard	1.00	0.00	18	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Port 80 fits because it is the default port commonly associated with http.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_networks:8
ef348dfd-e958-4d1a-814e-d3606d9a5f34	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	62ab8bcc-63ac-4195-ab34-0105cf2454d0	Which term best matches this description: it separates the network portion of an address from the host portion?	["Round-trip time", "IP address", "Subnet mask", "Router"]	2	hard	1.00	0.00	19	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Subnet mask fits because it separates the network portion of an address from the host portion.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_networks:9
4ad2dfb1-ff12-419d-8fc9-6a22644160d5	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	62ab8bcc-63ac-4195-ab34-0105cf2454d0	Which term best matches this description: it measures how long a packet takes to go to a destination and back?	["IP address", "Round-trip time", "Router", "HTTP"]	1	hard	1.00	0.00	20	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Round-trip time fits because it measures how long a packet takes to go to a destination and back.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_networks:10
de54431d-a948-483b-93ac-e826fccbe8a1	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	e98c174b-2dd3-488d-9ee2-b8f3b76dcfc8	Which term best matches this description: it documents what a system must do?	["Requirement specification", "Version control", "Unit test", "Agile development"]	0	easy	1.00	0.00	41	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Requirement specification fits because it documents what a system must do.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:software_engineering:1
da038768-e6c7-42c8-ad3e-a259ec5fa89e	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	9b2053a5-dd87-43a2-9bb7-56c77e52b37f	What comes next in the series 5, 10, 17, 26?	["35", "38", "39", "37"]	3	medium	1.00	0.00	24	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	The differences are 5, 7, 9, so next is 11	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:number_series:4
d1e47664-ae17-4246-8508-5d68c6f68e5f	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	e98c174b-2dd3-488d-9ee2-b8f3b76dcfc8	Which term best matches this description: it tracks and manages changes to source code over time?	["Unit test", "Version control", "Agile development", "Code review"]	1	easy	1.00	0.00	42	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Version control fits because it tracks and manages changes to source code over time.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:software_engineering:2
de80210a-8fbe-48ff-91b5-8f4e985801fa	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	e98c174b-2dd3-488d-9ee2-b8f3b76dcfc8	Which term best matches this description: it verifies a small isolated piece of functionality?	["Agile development", "Code review", "Unit test", "Refactoring"]	2	easy	1.00	0.00	43	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Unit test fits because it verifies a small isolated piece of functionality.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:software_engineering:3
d16c44c9-7447-4180-9ca7-645d9c85fa86	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	e98c174b-2dd3-488d-9ee2-b8f3b76dcfc8	Which term best matches this description: it favors iterative delivery and feedback cycles?	["Code review", "Refactoring", "Continuous integration", "Agile development"]	3	medium	1.00	0.00	44	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Agile development fits because it favors iterative delivery and feedback cycles.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:software_engineering:4
83ca8b14-4196-4d0e-aa05-31d3a91e0a8a	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	e98c174b-2dd3-488d-9ee2-b8f3b76dcfc8	Which term best matches this description: it helps teams find defects before changes are merged?	["Refactoring", "Code review", "Continuous integration", "High cohesion"]	1	medium	1.00	0.00	45	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Code review fits because it helps teams find defects before changes are merged.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:software_engineering:5
fa9a021f-6aec-40ee-a2dd-8b113a4dfaff	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	e98c174b-2dd3-488d-9ee2-b8f3b76dcfc8	Which term best matches this description: it improves internal code structure without changing behavior?	["Continuous integration", "High cohesion", "Refactoring", "Regression testing"]	2	medium	1.00	0.00	46	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Refactoring fits because it improves internal code structure without changing behavior.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:software_engineering:6
13e4fc2f-75ff-495c-befb-c1f5dc68d8e0	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	e98c174b-2dd3-488d-9ee2-b8f3b76dcfc8	Which term best matches this description: it automatically builds and tests changes frequently?	["High cohesion", "Regression testing", "Design pattern", "Continuous integration"]	3	medium	1.00	0.00	47	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Continuous integration fits because it automatically builds and tests changes frequently.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:software_engineering:7
d9a60269-4668-4264-8aec-6e01c778ae97	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	e98c174b-2dd3-488d-9ee2-b8f3b76dcfc8	Which term best matches this description: it describes a module whose responsibilities are closely related?	["High cohesion", "Regression testing", "Design pattern", "Requirement specification"]	0	hard	1.00	0.00	48	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	High cohesion fits because it describes a module whose responsibilities are closely related.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:software_engineering:8
59338f9d-3680-4202-b514-b0adc8d90eb8	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	e98c174b-2dd3-488d-9ee2-b8f3b76dcfc8	Which term best matches this description: it checks that existing features still work after a change?	["Design pattern", "Requirement specification", "Regression testing", "Version control"]	2	hard	1.00	0.00	49	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Regression testing fits because it checks that existing features still work after a change.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:software_engineering:9
1a453cc4-89de-42ff-a617-daba7254e905	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	e98c174b-2dd3-488d-9ee2-b8f3b76dcfc8	Which term best matches this description: it is a reusable solution to a recurring design problem?	["Requirement specification", "Design pattern", "Version control", "Unit test"]	1	hard	1.00	0.00	50	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Design pattern fits because it is a reusable solution to a recurring design problem.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:software_engineering:10
f705924a-b22f-4618-9f5d-817424c1b9d4	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	3b29fb2d-6ca8-4e1d-9666-afe9029a37bd	Which term best matches this description: it executes instructions and is often called the brain of the computer?	["CPU", "RAM", "ALU", "Cache memory"]	0	easy	1.00	0.00	1	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	CPU fits because it executes instructions and is often called the brain of the computer.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_architecture:1
45815857-a7b3-48d8-a992-63facd607fd3	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	3b29fb2d-6ca8-4e1d-9666-afe9029a37bd	Which term best matches this description: it is volatile memory used for active data and programs?	["ALU", "RAM", "Cache memory", "Bit"]	1	easy	1.00	0.00	2	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	RAM fits because it is volatile memory used for active data and programs.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_architecture:2
d10c14d0-6aa3-43f0-86d0-583027525345	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	3b29fb2d-6ca8-4e1d-9666-afe9029a37bd	Which term best matches this description: it performs arithmetic and logical operations?	["Cache memory", "Bit", "ALU", "Pipelining"]	2	easy	1.00	0.00	3	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	ALU fits because it performs arithmetic and logical operations.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_architecture:3
95b4be55-3518-4fe9-bee4-cddb93af5fea	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	3b29fb2d-6ca8-4e1d-9666-afe9029a37bd	Which term best matches this description: it is faster than main memory and stores frequently used data?	["Bit", "Pipelining", "Hexadecimal", "Cache memory"]	3	medium	1.00	0.00	4	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Cache memory fits because it is faster than main memory and stores frequently used data.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_architecture:4
7fe384c6-2fa5-4beb-8be3-d380cbe1aa3e	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	3b29fb2d-6ca8-4e1d-9666-afe9029a37bd	Which term best matches this description: it is the smallest unit of digital information?	["Pipelining", "Bit", "Hexadecimal", "Byte"]	1	medium	1.00	0.00	5	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Bit fits because it is the smallest unit of digital information.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_architecture:5
c03f1f5c-3b36-4710-a2b2-f4f1093087df	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	3b29fb2d-6ca8-4e1d-9666-afe9029a37bd	Which term best matches this description: it overlaps instruction stages to improve throughput?	["Hexadecimal", "Byte", "Pipelining", "RISC"]	2	medium	1.00	0.00	6	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Pipelining fits because it overlaps instruction stages to improve throughput.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_architecture:6
2074d97e-db75-4e05-ae31-7f878887b964	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	3b29fb2d-6ca8-4e1d-9666-afe9029a37bd	Which term best matches this description: it is a base-16 numbering system?	["Byte", "RISC", "Little-endian order", "Hexadecimal"]	3	medium	1.00	0.00	7	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Hexadecimal fits because it is a base-16 numbering system.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_architecture:7
7593b8b4-8f8e-49b0-b597-9ec3a6590e3c	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	3b29fb2d-6ca8-4e1d-9666-afe9029a37bd	Which term best matches this description: it usually consists of eight bits?	["Byte", "RISC", "Little-endian order", "CPU"]	0	hard	1.00	0.00	8	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Byte fits because it usually consists of eight bits.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_architecture:8
be9c202b-b257-43da-92b6-2573e320f988	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	3b29fb2d-6ca8-4e1d-9666-afe9029a37bd	Which term best matches this description: it uses a relatively small and simple instruction set?	["Little-endian order", "CPU", "RISC", "RAM"]	2	hard	1.00	0.00	9	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	RISC fits because it uses a relatively small and simple instruction set.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_architecture:9
2846d505-4deb-4150-a032-0a63638f2b0e	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	3b29fb2d-6ca8-4e1d-9666-afe9029a37bd	Which term best matches this description: it stores the least significant byte at the lowest memory address?	["CPU", "Little-endian order", "RAM", "ALU"]	1	hard	1.00	0.00	10	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Little-endian order fits because it stores the least significant byte at the lowest memory address.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:computer_architecture:10
0f02549e-7b2e-4a46-89d5-2e86425704b9	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	cfccb319-176b-4fe6-8063-36a680133335	Which term best matches this description: it tricks users into revealing passwords or sensitive information?	["Phishing", "Strong password", "Malware", "Firewall"]	0	easy	1.00	0.00	21	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Phishing fits because it tricks users into revealing passwords or sensitive information.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:cyber_security_basics:1
8bc408a4-3e39-4b2d-95bd-2871d6bf2ea7	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	cfccb319-176b-4fe6-8063-36a680133335	Which term best matches this description: it combines length and character variety for better resistance?	["Malware", "Strong password", "Firewall", "Two-factor authentication"]	1	easy	1.00	0.00	22	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Strong password fits because it combines length and character variety for better resistance.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:cyber_security_basics:2
f643eb69-4619-4641-8a9d-5a8a92227c1a	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	cfccb319-176b-4fe6-8063-36a680133335	Which term best matches this description: it is malicious software designed to damage or exploit systems?	["Firewall", "Two-factor authentication", "Malware", "Hashing"]	2	easy	1.00	0.00	23	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Malware fits because it is malicious software designed to damage or exploit systems.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:cyber_security_basics:3
3a69ae81-ba40-4e75-aa29-82520d1574cf	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	cfccb319-176b-4fe6-8063-36a680133335	Which term best matches this description: it filters network traffic according to rules?	["Two-factor authentication", "Hashing", "Ransomware", "Firewall"]	3	medium	1.00	0.00	24	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Firewall fits because it filters network traffic according to rules.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:cyber_security_basics:4
5fcbd66b-6d35-41bc-8271-19a112780717	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	cfccb319-176b-4fe6-8063-36a680133335	Which term best matches this description: it adds a second verification step beyond the password?	["Hashing", "Two-factor authentication", "Ransomware", "SQL injection"]	1	medium	1.00	0.00	25	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Two-factor authentication fits because it adds a second verification step beyond the password.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:cyber_security_basics:5
18162b5d-82af-4ea8-9f87-8f5198e5ae8f	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	cfccb319-176b-4fe6-8063-36a680133335	Which term best matches this description: it is a one-way transformation commonly used for password storage?	["Ransomware", "SQL injection", "Hashing", "Least privilege"]	2	medium	1.00	0.00	26	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Hashing fits because it is a one-way transformation commonly used for password storage.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:cyber_security_basics:6
790d1e73-d74b-4b88-8921-2813a9170dd0	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	cfccb319-176b-4fe6-8063-36a680133335	Which term best matches this description: it encrypts files and demands payment for restoration?	["SQL injection", "Least privilege", "Man-in-the-middle attack", "Ransomware"]	3	medium	1.00	0.00	27	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Ransomware fits because it encrypts files and demands payment for restoration.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:cyber_security_basics:7
155df444-c3b9-46c2-9135-3b2d2a113ea9	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	cfccb319-176b-4fe6-8063-36a680133335	Which term best matches this description: it exploits unsafe database query construction?	["SQL injection", "Least privilege", "Man-in-the-middle attack", "Phishing"]	0	hard	1.00	0.00	28	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	SQL injection fits because it exploits unsafe database query construction.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:cyber_security_basics:8
151f66ad-7808-4e1d-beb0-c3000fd8aa0e	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	cfccb319-176b-4fe6-8063-36a680133335	Which term best matches this description: it gives a user or system only the access required to perform its task?	["Man-in-the-middle attack", "Phishing", "Least privilege", "Strong password"]	2	hard	1.00	0.00	29	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Least privilege fits because it gives a user or system only the access required to perform its task.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:cyber_security_basics:9
4f97e9d8-1833-4e11-8e06-a22f8a0218c6	b8449cc6-0a15-4895-9ed1-1ecdc7219fd8	cfccb319-176b-4fe6-8063-36a680133335	Which term best matches this description: it intercepts communication between two parties?	["Phishing", "Man-in-the-middle attack", "Strong password", "Malware"]	1	hard	1.00	0.00	30	2026-08-27 08:41:05.691727+00	0516b2da-3ff8-4945-9c83-6850a4573fee	\N	\N	Man-in-the-middle attack fits because it intercepts communication between two parties.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:computer_science:cyber_security_basics:10
d5ac02bb-4287-40ff-adf8-80c2fc17cccd	aad02091-b53f-4632-b423-0b555ce5064c	9355a1b9-2c44-4ae2-8a41-49da99eafd21	Which term best matches this description: it means the first element of an array is at position 0 in many languages?	["Zero-based indexing", "String", "Contiguous memory", "O(1) indexing"]	0	easy	1.00	0.00	1	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Zero-based indexing fits because it means the first element of an array is at position 0 in many languages.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:arrays_and_strings:1
65a6337e-6ffb-4eef-a3d9-5aadba5ee0e1	aad02091-b53f-4632-b423-0b555ce5064c	9355a1b9-2c44-4ae2-8a41-49da99eafd21	Which term best matches this description: it is a sequence of characters?	["Contiguous memory", "String", "O(1) indexing", "Two-pointer technique"]	1	easy	1.00	0.00	2	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	String fits because it is a sequence of characters.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:arrays_and_strings:2
b4a711fd-622b-4338-b121-d80ad068f01a	aad02091-b53f-4632-b423-0b555ce5064c	9355a1b9-2c44-4ae2-8a41-49da99eafd21	Which term best matches this description: it is a common property of array storage?	["O(1) indexing", "Two-pointer technique", "Contiguous memory", "Amortized append"]	2	easy	1.00	0.00	3	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Contiguous memory fits because it is a common property of array storage.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:arrays_and_strings:3
6c2fdfe3-58c4-4d7b-aed6-5092e7415c43	aad02091-b53f-4632-b423-0b555ce5064c	9355a1b9-2c44-4ae2-8a41-49da99eafd21	Which term best matches this description: it describes constant-time access to an array element by index?	["Two-pointer technique", "Amortized append", "Hash map frequency count", "O(1) indexing"]	3	medium	1.00	0.00	4	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	O(1) indexing fits because it describes constant-time access to an array element by index.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:arrays_and_strings:4
d5626a3f-7894-48ea-8bbb-427408c6ed53	aad02091-b53f-4632-b423-0b555ce5064c	9355a1b9-2c44-4ae2-8a41-49da99eafd21	Which term best matches this description: it is commonly used to reverse a string efficiently?	["Amortized append", "Two-pointer technique", "Hash map frequency count", "Reversal algorithm"]	1	medium	1.00	0.00	5	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Two-pointer technique fits because it is commonly used to reverse a string efficiently.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:arrays_and_strings:5
72e3e95c-4bff-4c66-adf1-ba12b3553c55	aad02091-b53f-4632-b423-0b555ce5064c	9355a1b9-2c44-4ae2-8a41-49da99eafd21	Which term best matches this description: it explains why appending to a dynamic array is often O(1) on average?	["Hash map frequency count", "Reversal algorithm", "Amortized append", "Prefix sum"]	2	medium	1.00	0.00	6	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Amortized append fits because it explains why appending to a dynamic array is often o(1) on average.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:arrays_and_strings:6
064c1889-1279-4054-b194-6bfc5265898f	aad02091-b53f-4632-b423-0b555ce5064c	9355a1b9-2c44-4ae2-8a41-49da99eafd21	Which term best matches this description: it is a common way to count character occurrences quickly?	["Reversal algorithm", "Prefix sum", "Longest common prefix", "Hash map frequency count"]	3	medium	1.00	0.00	7	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Hash map frequency count fits because it is a common way to count character occurrences quickly.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:arrays_and_strings:7
08324c9b-5792-44f4-8947-b00aeef0944a	aad02091-b53f-4632-b423-0b555ce5064c	9355a1b9-2c44-4ae2-8a41-49da99eafd21	Which term best matches this description: it can rotate an array by reversing sections and then the whole array?	["Reversal algorithm", "Prefix sum", "Longest common prefix", "Zero-based indexing"]	0	hard	1.00	0.00	8	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Reversal algorithm fits because it can rotate an array by reversing sections and then the whole array.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:arrays_and_strings:8
de3a57d0-03a5-422c-84c6-3d51cbea0ee2	aad02091-b53f-4632-b423-0b555ce5064c	9355a1b9-2c44-4ae2-8a41-49da99eafd21	Which term best matches this description: it helps answer range-sum queries efficiently?	["Longest common prefix", "Zero-based indexing", "Prefix sum", "String"]	2	hard	1.00	0.00	9	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Prefix sum fits because it helps answer range-sum queries efficiently.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:arrays_and_strings:9
4c6a18f1-3b83-416c-b8bd-213031b58845	aad02091-b53f-4632-b423-0b555ce5064c	9355a1b9-2c44-4ae2-8a41-49da99eafd21	Which term best matches this description: it is found by comparing characters until a mismatch appears?	["Zero-based indexing", "Longest common prefix", "String", "Contiguous memory"]	1	hard	1.00	0.00	10	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Longest common prefix fits because it is found by comparing characters until a mismatch appears.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:arrays_and_strings:10
896f514a-bdcb-4a17-8a31-94f039f66edb	aad02091-b53f-4632-b423-0b555ce5064c	e8314a21-3b96-40a1-88ea-27a5e851c884	Which term best matches this description: it stores data and a link to another node in a linked list?	["Node", "Singly linked list", "O(1) head insertion", "No random access"]	0	easy	1.00	0.00	11	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Node fits because it stores data and a link to another node in a linked list.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:linked_lists:1
bd7ed27c-d5e7-4790-a58f-310a02b402cf	aad02091-b53f-4632-b423-0b555ce5064c	e8314a21-3b96-40a1-88ea-27a5e851c884	Which term best matches this description: it supports traversal in only one direction?	["O(1) head insertion", "Singly linked list", "No random access", "Doubly linked list"]	1	easy	1.00	0.00	12	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Singly linked list fits because it supports traversal in only one direction.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:linked_lists:2
ea5f0c5c-a2a0-4589-981f-8f4e72b10f7b	aad02091-b53f-4632-b423-0b555ce5064c	e8314a21-3b96-40a1-88ea-27a5e851c884	Which term best matches this description: it describes inserting a new node at the head of a linked list?	["No random access", "Doubly linked list", "O(1) head insertion", "O(1) deletion after known node"]	2	easy	1.00	0.00	13	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	O(1) head insertion fits because it describes inserting a new node at the head of a linked list.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:linked_lists:3
7be78a8d-72f2-4c8e-a5bf-505b0a7162fd	aad02091-b53f-4632-b423-0b555ce5064c	e8314a21-3b96-40a1-88ea-27a5e851c884	Which term best matches this description: it explains why linked lists are slower than arrays for direct indexing?	["Doubly linked list", "O(1) deletion after known node", "Floyd cycle detection", "No random access"]	3	medium	1.00	0.00	14	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	No random access fits because it explains why linked lists are slower than arrays for direct indexing.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:linked_lists:4
44ef26fd-28cd-4e5d-98a3-e9d64a26d79f	aad02091-b53f-4632-b423-0b555ce5064c	e8314a21-3b96-40a1-88ea-27a5e851c884	Which term best matches this description: it stores both previous and next pointers?	["O(1) deletion after known node", "Doubly linked list", "Floyd cycle detection", "Middle pointer technique"]	1	medium	1.00	0.00	15	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Doubly linked list fits because it stores both previous and next pointers.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:linked_lists:5
6a5e0ca3-ff0d-499d-8d8c-5f3f6045fe35	aad02091-b53f-4632-b423-0b555ce5064c	e8314a21-3b96-40a1-88ea-27a5e851c884	Which term best matches this description: it describes removing the node after a given node in a singly linked list?	["Floyd cycle detection", "Middle pointer technique", "O(1) deletion after known node", "Pointer reversal"]	2	medium	1.00	0.00	16	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	O(1) deletion after known node fits because it describes removing the node after a given node in a singly linked list.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:linked_lists:6
3df51124-d70c-4cfd-95ba-dbe7daa9dcab	aad02091-b53f-4632-b423-0b555ce5064c	e8314a21-3b96-40a1-88ea-27a5e851c884	Which term best matches this description: it uses slow and fast pointers to detect a loop?	["Middle pointer technique", "Pointer reversal", "Merge in O(n + m)", "Floyd cycle detection"]	3	medium	1.00	0.00	17	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Floyd cycle detection fits because it uses slow and fast pointers to detect a loop.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:linked_lists:7
c589eec6-7527-4921-8d0d-bcd6162511a8	aad02091-b53f-4632-b423-0b555ce5064c	e8314a21-3b96-40a1-88ea-27a5e851c884	Which term best matches this description: it finds the middle of a linked list using slow and fast pointers?	["Middle pointer technique", "Pointer reversal", "Merge in O(n + m)", "Node"]	0	hard	1.00	0.00	18	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Middle pointer technique fits because it finds the middle of a linked list using slow and fast pointers.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:linked_lists:8
9868f0ff-744f-4f1b-aa04-f6ef2b11b8e5	aad02091-b53f-4632-b423-0b555ce5064c	e8314a21-3b96-40a1-88ea-27a5e851c884	Which term best matches this description: it is the core idea in reversing a linked list?	["Merge in O(n + m)", "Node", "Pointer reversal", "Singly linked list"]	2	hard	1.00	0.00	19	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Pointer reversal fits because it is the core idea in reversing a linked list.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:linked_lists:9
7898f447-6b08-4400-8799-c04e653a5bac	aad02091-b53f-4632-b423-0b555ce5064c	e8314a21-3b96-40a1-88ea-27a5e851c884	Which term best matches this description: it describes combining two sorted linked lists efficiently?	["Node", "Merge in O(n + m)", "Singly linked list", "O(1) head insertion"]	1	hard	1.00	0.00	20	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Merge in O(n + m) fits because it describes combining two sorted linked lists efficiently.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:linked_lists:10
845221c5-7ca4-4dd6-8fea-56a278922d7a	aad02091-b53f-4632-b423-0b555ce5064c	bb30514c-1656-41b6-a8d3-cd8de2be50b8	Which term best matches this description: it is the access rule followed by a stack?	["LIFO", "FIFO", "Push", "Dequeue"]	0	easy	1.00	0.00	31	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	LIFO fits because it is the access rule followed by a stack.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:stacks_and_queues:1
f1acce65-34e9-4788-99ba-a2fe72aa0c6f	aad02091-b53f-4632-b423-0b555ce5064c	bb30514c-1656-41b6-a8d3-cd8de2be50b8	Which term best matches this description: it is the access rule followed by a queue?	["Push", "FIFO", "Dequeue", "Call stack"]	1	easy	1.00	0.00	32	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	FIFO fits because it is the access rule followed by a queue.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:stacks_and_queues:2
dee7c18a-eee0-4daf-ae0c-529a0ecef01b	aad02091-b53f-4632-b423-0b555ce5064c	bb30514c-1656-41b6-a8d3-cd8de2be50b8	Which term best matches this description: it adds an element to the top of a stack?	["Dequeue", "Call stack", "Push", "Parenthesis matching stack"]	2	easy	1.00	0.00	33	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Push fits because it adds an element to the top of a stack.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:stacks_and_queues:3
e8cf911b-3882-4045-a384-581b54f4ffae	aad02091-b53f-4632-b423-0b555ce5064c	bb30514c-1656-41b6-a8d3-cd8de2be50b8	Which term best matches this description: it removes an element from the front of a queue?	["Call stack", "Parenthesis matching stack", "Circular queue", "Dequeue"]	3	medium	1.00	0.00	34	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Dequeue fits because it removes an element from the front of a queue.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:stacks_and_queues:4
7bfc220d-8e94-4521-adf0-688414744406	aad02091-b53f-4632-b423-0b555ce5064c	bb30514c-1656-41b6-a8d3-cd8de2be50b8	Which term best matches this description: it manages active function calls during execution?	["Parenthesis matching stack", "Call stack", "Circular queue", "BFS queue"]	1	medium	1.00	0.00	35	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Call stack fits because it manages active function calls during execution.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:stacks_and_queues:5
b5286ce5-0899-4dda-b2ce-7bef55fdba33	aad02091-b53f-4632-b423-0b555ce5064c	bb30514c-1656-41b6-a8d3-cd8de2be50b8	Which term best matches this description: it is a standard structure used to validate balanced brackets?	["Circular queue", "BFS queue", "Parenthesis matching stack", "Monotonic stack"]	2	medium	1.00	0.00	36	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Parenthesis matching stack fits because it is a standard structure used to validate balanced brackets.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:stacks_and_queues:6
4a36abb7-7604-4735-a1fa-1a9f4939f4e7	aad02091-b53f-4632-b423-0b555ce5064c	bb30514c-1656-41b6-a8d3-cd8de2be50b8	Which term best matches this description: it reuses freed positions by wrapping around the storage array?	["BFS queue", "Monotonic stack", "Deque", "Circular queue"]	3	medium	1.00	0.00	37	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Circular queue fits because it reuses freed positions by wrapping around the storage array.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:stacks_and_queues:7
6c7b7f16-b7f8-45ba-bee0-04150e7c801a	aad02091-b53f-4632-b423-0b555ce5064c	bb30514c-1656-41b6-a8d3-cd8de2be50b8	Which term best matches this description: it is the data structure typically used by breadth-first search?	["BFS queue", "Monotonic stack", "Deque", "LIFO"]	0	hard	1.00	0.00	38	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	BFS queue fits because it is the data structure typically used by breadth-first search.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:stacks_and_queues:8
f58958ae-f39b-49e0-a43a-47910932cb02	aad02091-b53f-4632-b423-0b555ce5064c	bb30514c-1656-41b6-a8d3-cd8de2be50b8	Which term best matches this description: it helps solve next greater element problems efficiently?	["Deque", "LIFO", "Monotonic stack", "FIFO"]	2	hard	1.00	0.00	39	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Monotonic stack fits because it helps solve next greater element problems efficiently.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:stacks_and_queues:9
4e322888-4c0e-41d9-aa57-2ae5827aa306	aad02091-b53f-4632-b423-0b555ce5064c	bb30514c-1656-41b6-a8d3-cd8de2be50b8	Which term best matches this description: it supports insertion and removal at both ends?	["LIFO", "Deque", "FIFO", "Push"]	1	hard	1.00	0.00	40	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Deque fits because it supports insertion and removal at both ends.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:stacks_and_queues:10
3b672ad7-90df-47de-9735-5459db384181	aad02091-b53f-4632-b423-0b555ce5064c	30f1cbee-75f3-4b9c-8745-0c405a5fb757	Which term best matches this description: it restricts each node to at most two children?	["Binary tree", "Root", "Leaf", "Inorder traversal"]	0	easy	1.00	0.00	41	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Binary tree fits because it restricts each node to at most two children.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:trees_and_graphs:1
9c94147e-d51c-4f8f-b07b-96e08bb599c6	aad02091-b53f-4632-b423-0b555ce5064c	30f1cbee-75f3-4b9c-8745-0c405a5fb757	Which term best matches this description: it is the topmost node of a tree?	["Leaf", "Root", "Inorder traversal", "Graph"]	1	easy	1.00	0.00	42	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Root fits because it is the topmost node of a tree.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:trees_and_graphs:2
c2426140-d076-4480-93d4-94c4a74dbddb	aad02091-b53f-4632-b423-0b555ce5064c	30f1cbee-75f3-4b9c-8745-0c405a5fb757	Which term best matches this description: it is a node with no children?	["Inorder traversal", "Graph", "Leaf", "Depth-first search"]	2	easy	1.00	0.00	43	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Leaf fits because it is a node with no children.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:trees_and_graphs:3
d4984c95-1e49-43f5-968a-eb04d0a2b5d9	aad02091-b53f-4632-b423-0b555ce5064c	30f1cbee-75f3-4b9c-8745-0c405a5fb757	Which term best matches this description: it visits a binary search tree in sorted order?	["Graph", "Depth-first search", "Breadth-first search", "Inorder traversal"]	3	medium	1.00	0.00	44	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Inorder traversal fits because it visits a binary search tree in sorted order.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:trees_and_graphs:4
b7e89237-65b4-487b-ad9d-50a6ec432be6	aad02091-b53f-4632-b423-0b555ce5064c	30f1cbee-75f3-4b9c-8745-0c405a5fb757	Which term best matches this description: it is a collection of vertices connected by edges?	["Depth-first search", "Graph", "Breadth-first search", "Balanced BST height"]	1	medium	1.00	0.00	45	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Graph fits because it is a collection of vertices connected by edges.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:trees_and_graphs:5
f0bd7f52-7f4c-400a-9450-49a58c016160	aad02091-b53f-4632-b423-0b555ce5064c	30f1cbee-75f3-4b9c-8745-0c405a5fb757	Which term best matches this description: it explores as far as possible along a branch before backtracking?	["Breadth-first search", "Balanced BST height", "Depth-first search", "Topological sort"]	2	medium	1.00	0.00	46	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Depth-first search fits because it explores as far as possible along a branch before backtracking.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:trees_and_graphs:6
5989f968-40b5-4bee-a755-2c635fa9cdd8	aad02091-b53f-4632-b423-0b555ce5064c	30f1cbee-75f3-4b9c-8745-0c405a5fb757	Which term best matches this description: it finds shortest paths in an unweighted graph?	["Balanced BST height", "Topological sort", "Spanning tree", "Breadth-first search"]	3	medium	1.00	0.00	47	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Breadth-first search fits because it finds shortest paths in an unweighted graph.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:trees_and_graphs:7
d22ba388-ab6c-4373-8bb6-4428410c7583	aad02091-b53f-4632-b423-0b555ce5064c	30f1cbee-75f3-4b9c-8745-0c405a5fb757	Which term best matches this description: it grows on the order of log n?	["Balanced BST height", "Topological sort", "Spanning tree", "Binary tree"]	0	hard	1.00	0.00	48	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Balanced BST height fits because it grows on the order of log n.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:trees_and_graphs:8
b3b2e57a-523d-42d4-9f03-76451bea6611	aad02091-b53f-4632-b423-0b555ce5064c	30f1cbee-75f3-4b9c-8745-0c405a5fb757	Which term best matches this description: it is defined only for directed acyclic graphs?	["Spanning tree", "Binary tree", "Topological sort", "Root"]	2	hard	1.00	0.00	49	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Topological sort fits because it is defined only for directed acyclic graphs.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:trees_and_graphs:9
1b50b398-6bad-414c-a802-8511f2722baf	aad02091-b53f-4632-b423-0b555ce5064c	30f1cbee-75f3-4b9c-8745-0c405a5fb757	Which term best matches this description: it connects n vertices using exactly n - 1 edges?	["Binary tree", "Spanning tree", "Root", "Leaf"]	1	hard	1.00	0.00	50	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Spanning tree fits because it connects n vertices using exactly n - 1 edges.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:trees_and_graphs:10
a44eb100-00d3-431a-b109-64f3ab677178	aad02091-b53f-4632-b423-0b555ce5064c	6356b823-bbea-4e6c-8514-e16c1dc56b0c	Which term best matches this description: it scans elements sequentially to find a target?	["Linear search", "Binary search", "Bubble sort", "Merge sort"]	0	easy	1.00	0.00	21	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Linear search fits because it scans elements sequentially to find a target.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:searching_and_sorting:1
9035d19f-745e-4b23-bd94-d5e21c41adf7	aad02091-b53f-4632-b423-0b555ce5064c	6356b823-bbea-4e6c-8514-e16c1dc56b0c	Which term best matches this description: it requires data to be sorted before halving the search space?	["Bubble sort", "Binary search", "Merge sort", "Average O(n log n) quicksort"]	1	easy	1.00	0.00	22	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Binary search fits because it requires data to be sorted before halving the search space.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:searching_and_sorting:2
1486cc28-4e01-4489-8f63-84bb00422773	aad02091-b53f-4632-b423-0b555ce5064c	6356b823-bbea-4e6c-8514-e16c1dc56b0c	Which term best matches this description: it repeatedly swaps adjacent out-of-order elements?	["Merge sort", "Average O(n log n) quicksort", "Bubble sort", "Worst-case O(log n) binary search"]	2	easy	1.00	0.00	23	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Bubble sort fits because it repeatedly swaps adjacent out-of-order elements.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:searching_and_sorting:3
2a3e66d7-e053-4045-9690-4f094961d4b6	aad02091-b53f-4632-b423-0b555ce5064c	6356b823-bbea-4e6c-8514-e16c1dc56b0c	Which term best matches this description: it is a divide-and-conquer sorting algorithm?	["Average O(n log n) quicksort", "Worst-case O(log n) binary search", "Stable sort", "Merge sort"]	3	medium	1.00	0.00	24	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Merge sort fits because it is a divide-and-conquer sorting algorithm.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:searching_and_sorting:4
9cef3f7e-1dfa-4d56-9b6f-5c9463ff6615	aad02091-b53f-4632-b423-0b555ce5064c	6356b823-bbea-4e6c-8514-e16c1dc56b0c	Which term best matches this description: it describes the average-case complexity of quicksort?	["Worst-case O(log n) binary search", "Average O(n log n) quicksort", "Stable sort", "Counting sort"]	1	medium	1.00	0.00	25	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Average O(n log n) quicksort fits because it describes the average-case complexity of quicksort.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:searching_and_sorting:5
db76ec51-1660-4151-adab-91ca959b8b4c	aad02091-b53f-4632-b423-0b555ce5064c	6356b823-bbea-4e6c-8514-e16c1dc56b0c	Which term best matches this description: it states the time complexity of binary search?	["Stable sort", "Counting sort", "Worst-case O(log n) binary search", "Heap sort"]	2	medium	1.00	0.00	26	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Worst-case O(log n) binary search fits because it states the time complexity of binary search.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:searching_and_sorting:6
1932a7a6-056f-40ab-86a1-3e819bb3dcaa	aad02091-b53f-4632-b423-0b555ce5064c	6356b823-bbea-4e6c-8514-e16c1dc56b0c	Which term best matches this description: it preserves the relative order of equal keys?	["Counting sort", "Heap sort", "Overflow-safe midpoint", "Stable sort"]	3	medium	1.00	0.00	27	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Stable sort fits because it preserves the relative order of equal keys.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:searching_and_sorting:7
3d9a0364-3472-49b4-83fd-ed21835369c6	aad02091-b53f-4632-b423-0b555ce5064c	6356b823-bbea-4e6c-8514-e16c1dc56b0c	Which term best matches this description: it is effective when keys come from a small bounded integer range?	["Counting sort", "Heap sort", "Overflow-safe midpoint", "Linear search"]	0	hard	1.00	0.00	28	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Counting sort fits because it is effective when keys come from a small bounded integer range.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:searching_and_sorting:8
54833678-2e79-47f3-a8ec-48ececb82f6b	aad02091-b53f-4632-b423-0b555ce5064c	6356b823-bbea-4e6c-8514-e16c1dc56b0c	Which term best matches this description: it uses a heap data structure to order the values?	["Overflow-safe midpoint", "Linear search", "Heap sort", "Binary search"]	2	hard	1.00	0.00	29	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Heap sort fits because it uses a heap data structure to order the values.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:searching_and_sorting:9
c68e74a1-ed98-4c9a-b5c2-79feb672fdf0	aad02091-b53f-4632-b423-0b555ce5064c	6356b823-bbea-4e6c-8514-e16c1dc56b0c	Which term best matches this description: it uses low + (high - low) / 2 in binary search implementations?	["Linear search", "Overflow-safe midpoint", "Binary search", "Bubble sort"]	1	hard	1.00	0.00	30	2026-08-27 08:41:05.691727+00	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	\N	\N	Overflow-safe midpoint fits because it uses low + (high - low) / 2 in binary search implementations.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:data_structures_and_algorithms:searching_and_sorting:10
ce705aa3-20c8-40c3-8cab-9cf728e91e71	d8084811-1a21-4e12-af30-4fecb20d0454	6d1dcf73-7718-4bff-a9ea-e67912db5f6e	Which term best matches this description: it retrieves data from a table or view?	["SELECT", "WHERE", "COUNT", "INNER JOIN"]	0	easy	1.00	0.00	31	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	SELECT fits because it retrieves data from a table or view.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:sql:1
a8cba1e0-8529-4470-84d9-8eab1b8069a3	d8084811-1a21-4e12-af30-4fecb20d0454	6d1dcf73-7718-4bff-a9ea-e67912db5f6e	Which term best matches this description: it filters rows before they are returned?	["COUNT", "WHERE", "INNER JOIN", "ORDER BY"]	1	easy	1.00	0.00	32	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	WHERE fits because it filters rows before they are returned.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:sql:2
658577fa-60ea-4de3-8856-d6c48fd93318	d8084811-1a21-4e12-af30-4fecb20d0454	6d1dcf73-7718-4bff-a9ea-e67912db5f6e	Which term best matches this description: it calculates the number of rows matching a query?	["INNER JOIN", "ORDER BY", "COUNT", "GROUP BY"]	2	easy	1.00	0.00	33	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	COUNT fits because it calculates the number of rows matching a query.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:sql:3
3287276f-5fb3-4da7-a719-0930f4cbbdcb	d8084811-1a21-4e12-af30-4fecb20d0454	6d1dcf73-7718-4bff-a9ea-e67912db5f6e	Which term best matches this description: it returns matching rows from both joined tables?	["ORDER BY", "GROUP BY", "HAVING", "INNER JOIN"]	3	medium	1.00	0.00	34	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	INNER JOIN fits because it returns matching rows from both joined tables.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:sql:4
d65954f5-7b8c-4577-9e61-874129e2c817	d8084811-1a21-4e12-af30-4fecb20d0454	6d1dcf73-7718-4bff-a9ea-e67912db5f6e	Which term best matches this description: it sorts query results?	["GROUP BY", "ORDER BY", "HAVING", "Primary key"]	1	medium	1.00	0.00	35	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	ORDER BY fits because it sorts query results.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:sql:5
88fe49fb-a0fd-4577-87b1-e883358beeab	d8084811-1a21-4e12-af30-4fecb20d0454	6d1dcf73-7718-4bff-a9ea-e67912db5f6e	Which term best matches this description: it groups rows for aggregate calculations?	["HAVING", "Primary key", "GROUP BY", "LEFT JOIN"]	2	medium	1.00	0.00	36	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	GROUP BY fits because it groups rows for aggregate calculations.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:sql:6
0828b5d6-ad80-4429-839e-454c140e61ad	d8084811-1a21-4e12-af30-4fecb20d0454	6d1dcf73-7718-4bff-a9ea-e67912db5f6e	Which term best matches this description: it filters grouped rows after aggregation?	["Primary key", "LEFT JOIN", "Subquery", "HAVING"]	3	medium	1.00	0.00	37	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	HAVING fits because it filters grouped rows after aggregation.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:sql:7
9e2e83f0-9ade-4c72-9747-b7407db460c9	d8084811-1a21-4e12-af30-4fecb20d0454	6d1dcf73-7718-4bff-a9ea-e67912db5f6e	Which term best matches this description: it uniquely identifies a row in a table?	["Primary key", "LEFT JOIN", "Subquery", "SELECT"]	0	hard	1.00	0.00	38	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Primary key fits because it uniquely identifies a row in a table.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:sql:8
20cbaef6-04de-4fdd-b08b-867b27a0a56c	d8084811-1a21-4e12-af30-4fecb20d0454	6d1dcf73-7718-4bff-a9ea-e67912db5f6e	Which term best matches this description: it keeps all rows from the left table even if no match exists on the right?	["Subquery", "SELECT", "LEFT JOIN", "WHERE"]	2	hard	1.00	0.00	39	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	LEFT JOIN fits because it keeps all rows from the left table even if no match exists on the right.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:sql:9
b95611f9-dfa6-42c0-80bd-c4b09760ac55	d8084811-1a21-4e12-af30-4fecb20d0454	eab339c3-acbc-4db7-b934-4f768eeb2ef3	Which term best matches this description: it requires atomic column values?	["First normal form", "Second normal form", "Third normal form", "Normalization"]	0	easy	1.00	0.00	21	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	First normal form fits because it requires atomic column values.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:normalization:1
90b52e05-95d3-46cb-9327-89111adbc9ac	d8084811-1a21-4e12-af30-4fecb20d0454	eab339c3-acbc-4db7-b934-4f768eeb2ef3	Which term best matches this description: it removes partial dependency on part of a composite key?	["Third normal form", "Second normal form", "Normalization", "Denormalization"]	1	easy	1.00	0.00	22	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Second normal form fits because it removes partial dependency on part of a composite key.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:normalization:2
2971df77-12bb-4af5-be82-2724073704fb	d8084811-1a21-4e12-af30-4fecb20d0454	eab339c3-acbc-4db7-b934-4f768eeb2ef3	Which term best matches this description: it removes transitive dependency among non-key attributes?	["Normalization", "Denormalization", "Third normal form", "Candidate key"]	2	easy	1.00	0.00	23	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Third normal form fits because it removes transitive dependency among non-key attributes.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:normalization:3
98512ed8-34a5-40b1-a3fe-866bf086707f	d8084811-1a21-4e12-af30-4fecb20d0454	eab339c3-acbc-4db7-b934-4f768eeb2ef3	Which term best matches this description: it reduces redundancy and update anomalies?	["Denormalization", "Candidate key", "BCNF", "Normalization"]	3	medium	1.00	0.00	24	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Normalization fits because it reduces redundancy and update anomalies.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:normalization:4
63284e2d-6401-487e-98d1-40e2b516c4b0	d8084811-1a21-4e12-af30-4fecb20d0454	eab339c3-acbc-4db7-b934-4f768eeb2ef3	Which term best matches this description: it may improve read performance by intentionally adding redundancy?	["Candidate key", "Denormalization", "BCNF", "Functional dependency"]	1	medium	1.00	0.00	25	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Denormalization fits because it may improve read performance by intentionally adding redundancy.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:normalization:5
39b37cd2-bea1-4964-b0f7-a7a0c7716072	d8084811-1a21-4e12-af30-4fecb20d0454	eab339c3-acbc-4db7-b934-4f768eeb2ef3	Which term best matches this description: it is a minimal attribute set that can uniquely identify a row?	["BCNF", "Functional dependency", "Candidate key", "Lossless decomposition"]	2	medium	1.00	0.00	26	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Candidate key fits because it is a minimal attribute set that can uniquely identify a row.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:normalization:6
a9b3090b-22a3-4b8b-98a1-caa3ee2030ab	d8084811-1a21-4e12-af30-4fecb20d0454	eab339c3-acbc-4db7-b934-4f768eeb2ef3	Which term best matches this description: it is a stronger form of normalization than 3NF?	["Functional dependency", "Lossless decomposition", "Fourth normal form", "BCNF"]	3	medium	1.00	0.00	27	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	BCNF fits because it is a stronger form of normalization than 3nf.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:normalization:7
88df7d98-a8dc-49e0-abcb-33a94a9d6979	d8084811-1a21-4e12-af30-4fecb20d0454	eab339c3-acbc-4db7-b934-4f768eeb2ef3	Which term best matches this description: it means one attribute set determines another?	["Functional dependency", "Lossless decomposition", "Fourth normal form", "First normal form"]	0	hard	1.00	0.00	28	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Functional dependency fits because it means one attribute set determines another.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:normalization:8
2aab2211-9340-457b-9269-f636ced55ade	d8084811-1a21-4e12-af30-4fecb20d0454	eab339c3-acbc-4db7-b934-4f768eeb2ef3	Which term best matches this description: it preserves the original information when a relation is split?	["Fourth normal form", "First normal form", "Lossless decomposition", "Second normal form"]	2	hard	1.00	0.00	29	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Lossless decomposition fits because it preserves the original information when a relation is split.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:normalization:9
4258d672-5b1a-4cd8-acfd-3446bb65faee	d8084811-1a21-4e12-af30-4fecb20d0454	eab339c3-acbc-4db7-b934-4f768eeb2ef3	Which term best matches this description: it addresses multivalued dependency problems?	["First normal form", "Fourth normal form", "Second normal form", "Third normal form"]	1	hard	1.00	0.00	30	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Fourth normal form fits because it addresses multivalued dependency problems.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:normalization:10
6b459dd5-af78-4b66-83b9-497609da7999	d8084811-1a21-4e12-af30-4fecb20d0454	f79b303d-8e07-4edc-9360-6ba26970aefe	Which term best matches this description: it names the core properties of database transactions?	["ACID", "Atomicity", "Consistency", "Isolation"]	0	easy	1.00	0.00	41	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	ACID fits because it names the core properties of database transactions.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:transactions:1
274381cb-1efd-4384-b1ca-eaf6d794ca92	d8084811-1a21-4e12-af30-4fecb20d0454	f79b303d-8e07-4edc-9360-6ba26970aefe	Which term best matches this description: it means a transaction happens completely or not at all?	["Consistency", "Atomicity", "Isolation", "Durability"]	1	easy	1.00	0.00	42	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Atomicity fits because it means a transaction happens completely or not at all.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:transactions:2
40fddec0-dd67-44b9-80cd-28525b5f2b62	d8084811-1a21-4e12-af30-4fecb20d0454	f79b303d-8e07-4edc-9360-6ba26970aefe	Which term best matches this description: it keeps the database in a valid state before and after a transaction?	["Isolation", "Durability", "Consistency", "COMMIT"]	2	easy	1.00	0.00	43	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Consistency fits because it keeps the database in a valid state before and after a transaction.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:transactions:3
63fbcc85-e024-46e5-8657-cb7a7f2196cc	d8084811-1a21-4e12-af30-4fecb20d0454	f79b303d-8e07-4edc-9360-6ba26970aefe	Which term best matches this description: it controls how concurrent transactions interact?	["Durability", "COMMIT", "ROLLBACK", "Isolation"]	3	medium	1.00	0.00	44	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Isolation fits because it controls how concurrent transactions interact.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:transactions:4
276c6fc9-a6ce-499d-8f1f-c421523e94f7	d8084811-1a21-4e12-af30-4fecb20d0454	f79b303d-8e07-4edc-9360-6ba26970aefe	Which term best matches this description: it ensures committed changes survive failures?	["COMMIT", "Durability", "ROLLBACK", "Dirty read"]	1	medium	1.00	0.00	45	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Durability fits because it ensures committed changes survive failures.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:transactions:5
92af63e2-0f41-4f21-9bf3-277bcfef2a58	d8084811-1a21-4e12-af30-4fecb20d0454	f79b303d-8e07-4edc-9360-6ba26970aefe	Which term best matches this description: it permanently saves a transaction's changes?	["ROLLBACK", "Dirty read", "COMMIT", "Serializable isolation"]	2	medium	1.00	0.00	46	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	COMMIT fits because it permanently saves a transaction's changes.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:transactions:6
0b29f3b2-fcf5-4cc8-a17a-367c0fb215ab	d8084811-1a21-4e12-af30-4fecb20d0454	f79b303d-8e07-4edc-9360-6ba26970aefe	Which term best matches this description: it undoes uncommitted changes in a transaction?	["Dirty read", "Serializable isolation", "Deadlock", "ROLLBACK"]	3	medium	1.00	0.00	47	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	ROLLBACK fits because it undoes uncommitted changes in a transaction.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:transactions:7
66951142-f13d-4eff-affa-f6cb40610512	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	9b2053a5-dd87-43a2-9bb7-56c77e52b37f	What comes next in the series 81, 27, 9, 3?	["0", "1", "2", "9"]	1	medium	1.00	0.00	25	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Each term is divided by 3	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:number_series:5
3f20154e-304b-4b6d-97a6-417458047572	d8084811-1a21-4e12-af30-4fecb20d0454	f79b303d-8e07-4edc-9360-6ba26970aefe	Which term best matches this description: it occurs when one transaction reads another transaction's uncommitted data?	["Dirty read", "Serializable isolation", "Deadlock", "ACID"]	0	hard	1.00	0.00	48	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Dirty read fits because it occurs when one transaction reads another transaction's uncommitted data.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:transactions:8
098430f3-284f-4195-b6b0-4a8519aeb056	d8084811-1a21-4e12-af30-4fecb20d0454	f79b303d-8e07-4edc-9360-6ba26970aefe	Which term best matches this description: it is the strongest commonly discussed isolation level?	["Deadlock", "ACID", "Serializable isolation", "Atomicity"]	2	hard	1.00	0.00	49	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Serializable isolation fits because it is the strongest commonly discussed isolation level.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:transactions:9
f2ba63a4-fdd0-4d9f-a4c8-bdca593056bb	d8084811-1a21-4e12-af30-4fecb20d0454	f79b303d-8e07-4edc-9360-6ba26970aefe	Which term best matches this description: it occurs when transactions wait cyclically for each other's resources?	["ACID", "Deadlock", "Atomicity", "Consistency"]	1	hard	1.00	0.00	50	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Deadlock fits because it occurs when transactions wait cyclically for each other's resources.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:transactions:10
c8675f39-7a86-4ceb-b426-26d53da8069f	d8084811-1a21-4e12-af30-4fecb20d0454	54c6f325-599a-45e7-b8ce-b17d50df37d0	Which term best matches this description: it represents a real-world object or concept in ER modeling?	["Entity", "Attribute", "Relationship", "Primary key"]	0	easy	1.00	0.00	1	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Entity fits because it represents a real-world object or concept in er modeling.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:er_model:1
cd319fc2-df22-4ca4-b516-d6486bd02446	d8084811-1a21-4e12-af30-4fecb20d0454	54c6f325-599a-45e7-b8ce-b17d50df37d0	Which term best matches this description: it is a property that describes an entity?	["Relationship", "Attribute", "Primary key", "One-to-many cardinality"]	1	easy	1.00	0.00	2	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Attribute fits because it is a property that describes an entity.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:er_model:2
516d11a9-8c8a-4cb8-9e26-fbf90fce073c	d8084811-1a21-4e12-af30-4fecb20d0454	54c6f325-599a-45e7-b8ce-b17d50df37d0	Which term best matches this description: it links entities together?	["Primary key", "One-to-many cardinality", "Relationship", "Weak entity"]	2	easy	1.00	0.00	3	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Relationship fits because it links entities together.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:er_model:3
8f458442-6883-4939-8757-36ebc9e1c8d1	d8084811-1a21-4e12-af30-4fecb20d0454	54c6f325-599a-45e7-b8ce-b17d50df37d0	Which term best matches this description: it uniquely identifies an entity instance?	["One-to-many cardinality", "Weak entity", "Participation constraint", "Primary key"]	3	medium	1.00	0.00	4	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Primary key fits because it uniquely identifies an entity instance.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:er_model:4
c0863bee-48c4-4177-bd28-7badff5eb5b3	d8084811-1a21-4e12-af30-4fecb20d0454	54c6f325-599a-45e7-b8ce-b17d50df37d0	Which term best matches this description: it means one instance of one entity can relate to many of another?	["Weak entity", "One-to-many cardinality", "Participation constraint", "Associative entity"]	1	medium	1.00	0.00	5	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	One-to-many cardinality fits because it means one instance of one entity can relate to many of another.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:er_model:5
cba99fc6-23e8-4f43-a4d4-98b6fdd9f16c	d8084811-1a21-4e12-af30-4fecb20d0454	54c6f325-599a-45e7-b8ce-b17d50df37d0	Which term best matches this description: it depends on another entity for its identification?	["Participation constraint", "Associative entity", "Weak entity", "Specialization"]	2	medium	1.00	0.00	6	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Weak entity fits because it depends on another entity for its identification.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:er_model:6
5687b1b2-a471-4981-a00b-d414e2ad576a	d8084811-1a21-4e12-af30-4fecb20d0454	54c6f325-599a-45e7-b8ce-b17d50df37d0	Which term best matches this description: it describes whether involvement in a relationship is total or partial?	["Associative entity", "Specialization", "Aggregation", "Participation constraint"]	3	medium	1.00	0.00	7	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Participation constraint fits because it describes whether involvement in a relationship is total or partial.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:er_model:7
750326f2-9b7d-46d6-b8e7-36ceafef3327	d8084811-1a21-4e12-af30-4fecb20d0454	54c6f325-599a-45e7-b8ce-b17d50df37d0	Which term best matches this description: it models a many-to-many relationship with its own attributes?	["Associative entity", "Specialization", "Aggregation", "Entity"]	0	hard	1.00	0.00	8	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Associative entity fits because it models a many-to-many relationship with its own attributes.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:er_model:8
9e7b7237-a63b-4c96-af2b-5ec751464add	d8084811-1a21-4e12-af30-4fecb20d0454	54c6f325-599a-45e7-b8ce-b17d50df37d0	Which term best matches this description: it is the top-down inheritance process in ER design?	["Aggregation", "Entity", "Specialization", "Attribute"]	2	hard	1.00	0.00	9	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Specialization fits because it is the top-down inheritance process in er design.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:er_model:9
40814471-6cc9-4c68-b7da-3cea22ec7852	d8084811-1a21-4e12-af30-4fecb20d0454	54c6f325-599a-45e7-b8ce-b17d50df37d0	Which term best matches this description: it treats a relationship set as a higher-level abstract entity?	["Entity", "Aggregation", "Attribute", "Relationship"]	1	hard	1.00	0.00	10	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Aggregation fits because it treats a relationship set as a higher-level abstract entity.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:er_model:10
97a78ce0-d46a-4c4a-993a-0e31117b9889	d8084811-1a21-4e12-af30-4fecb20d0454	44b802a1-7d25-40da-aa11-511dfd45d123	Which term best matches this description: it speeds up data retrieval by providing an alternate access path?	["Index", "B-tree", "Write overhead", "Clustered index"]	0	easy	1.00	0.00	11	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Index fits because it speeds up data retrieval by providing an alternate access path.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:indexing:1
2f9659dc-8ba8-449b-8542-32f1384a9259	d8084811-1a21-4e12-af30-4fecb20d0454	44b802a1-7d25-40da-aa11-511dfd45d123	Which term best matches this description: it is a very common index structure in databases?	["Write overhead", "B-tree", "Clustered index", "Full table scan"]	1	easy	1.00	0.00	12	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	B-tree fits because it is a very common index structure in databases.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:indexing:2
8f08828e-0907-4ffc-a453-674a865246ca	d8084811-1a21-4e12-af30-4fecb20d0454	44b802a1-7d25-40da-aa11-511dfd45d123	Which term best matches this description: it is a tradeoff created by maintaining too many indexes?	["Clustered index", "Full table scan", "Write overhead", "Composite index"]	2	easy	1.00	0.00	13	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Write overhead fits because it is a tradeoff created by maintaining too many indexes.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:indexing:3
f295bd3d-54be-4e35-a558-f6014bcf3e92	d8084811-1a21-4e12-af30-4fecb20d0454	44b802a1-7d25-40da-aa11-511dfd45d123	Which term best matches this description: it is an index closely tied to the physical order of table data in many systems?	["Full table scan", "Composite index", "High selectivity", "Clustered index"]	3	medium	1.00	0.00	14	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Clustered index fits because it is an index closely tied to the physical order of table data in many systems.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:indexing:4
8f72b15a-157f-40a1-a7ec-44a7d8c52c33	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	9b2053a5-dd87-43a2-9bb7-56c77e52b37f	What comes next in the series 2, 5, 10, 17?	["24", "25", "26", "27"]	2	medium	1.00	0.00	26	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	These are n^2 + 1 for n = 1, 2, 3, 4, 5	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:number_series:6
39157742-b715-4cdd-b7c7-9fa56c49dab3	d8084811-1a21-4e12-af30-4fecb20d0454	44b802a1-7d25-40da-aa11-511dfd45d123	Which term best matches this description: it reads every row because no selective index path is chosen?	["Composite index", "Full table scan", "High selectivity", "Leading-column prefix"]	1	medium	1.00	0.00	15	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Full table scan fits because it reads every row because no selective index path is chosen.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:indexing:5
6daf01d5-808b-473b-8d4c-3f411993bd39	d8084811-1a21-4e12-af30-4fecb20d0454	44b802a1-7d25-40da-aa11-511dfd45d123	Which term best matches this description: it is an index built on more than one column?	["High selectivity", "Leading-column prefix", "Composite index", "Hash index"]	2	medium	1.00	0.00	16	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Composite index fits because it is an index built on more than one column.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:indexing:6
4f7dbe0e-0f4d-4842-8d51-6198873794ed	d8084811-1a21-4e12-af30-4fecb20d0454	44b802a1-7d25-40da-aa11-511dfd45d123	Which term best matches this description: it means a predicate matches relatively few rows?	["Leading-column prefix", "Hash index", "Covering index", "High selectivity"]	3	medium	1.00	0.00	17	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	High selectivity fits because it means a predicate matches relatively few rows.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:indexing:7
e3a1fbc6-54d1-43cd-8178-e9e1b8afdc99	d8084811-1a21-4e12-af30-4fecb20d0454	44b802a1-7d25-40da-aa11-511dfd45d123	Which term best matches this description: it allows part of a composite index to remain useful for some queries?	["Leading-column prefix", "Hash index", "Covering index", "Index"]	0	hard	1.00	0.00	18	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Leading-column prefix fits because it allows part of a composite index to remain useful for some queries.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:indexing:8
bdccea58-dbb2-45d7-8098-93af35c1e9aa	d8084811-1a21-4e12-af30-4fecb20d0454	44b802a1-7d25-40da-aa11-511dfd45d123	Which term best matches this description: it is especially suited to equality lookups?	["Covering index", "Index", "Hash index", "B-tree"]	2	hard	1.00	0.00	19	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Hash index fits because it is especially suited to equality lookups.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:indexing:9
5a1ce0f1-69f5-41dd-970a-d242468c9ca2	d8084811-1a21-4e12-af30-4fecb20d0454	44b802a1-7d25-40da-aa11-511dfd45d123	Which term best matches this description: it can answer a query without consulting the main table rows?	["Index", "Covering index", "B-tree", "Write overhead"]	1	hard	1.00	0.00	20	2026-08-27 08:41:05.691727+00	0e626538-e950-4f50-a32e-ff8c38cb505f	\N	\N	Covering index fits because it can answer a query without consulting the main table rows.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:database_management_systems:indexing:10
d874fd84-8816-4652-8286-3b9eade75fb0	4544ad3c-9162-4d42-bbd7-9490220778f2	0cb45db0-4eeb-48ce-b9b0-cf1ac094ece8	Which term best matches this description: it is a program in execution?	["Process", "Process control block", "Address space", "Context switch"]	0	easy	1.00	0.00	41	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Process fits because it is a program in execution.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:processes:1
23620be0-216d-49fd-a95a-12a91432b8f1	4544ad3c-9162-4d42-bbd7-9490220778f2	0cb45db0-4eeb-48ce-b9b0-cf1ac094ece8	Which term best matches this description: it stores key information about a process for the operating system?	["Address space", "Process control block", "Context switch", "Thread"]	1	easy	1.00	0.00	42	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Process control block fits because it stores key information about a process for the operating system.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:processes:2
7c194a8b-ae96-4d52-95ee-1b281520f229	4544ad3c-9162-4d42-bbd7-9490220778f2	0cb45db0-4eeb-48ce-b9b0-cf1ac094ece8	Which term best matches this description: it is the private memory view typically owned by a process?	["Context switch", "Thread", "Address space", "Process state model"]	2	easy	1.00	0.00	43	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Address space fits because it is the private memory view typically owned by a process.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:processes:3
5e6c94c4-1c45-4436-be6a-11ed55026572	4544ad3c-9162-4d42-bbd7-9490220778f2	0cb45db0-4eeb-48ce-b9b0-cf1ac094ece8	Which term best matches this description: it occurs when the CPU changes from one running process or thread to another?	["Thread", "Process state model", "Zombie process", "Context switch"]	3	medium	1.00	0.00	44	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Context switch fits because it occurs when the cpu changes from one running process or thread to another.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:processes:4
7b556bd6-1b81-443f-8377-8429a7b28328	4544ad3c-9162-4d42-bbd7-9490220778f2	0cb45db0-4eeb-48ce-b9b0-cf1ac094ece8	Which term best matches this description: it is a lightweight unit of execution within a process?	["Process state model", "Thread", "Zombie process", "fork"]	1	medium	1.00	0.00	45	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Thread fits because it is a lightweight unit of execution within a process.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:processes:5
947b90b5-bb98-470b-b812-a8bc0d39abd2	4544ad3c-9162-4d42-bbd7-9490220778f2	0cb45db0-4eeb-48ce-b9b0-cf1ac094ece8	Which term best matches this description: it includes states such as ready, running, and waiting?	["Zombie process", "fork", "Process state model", "Pipe"]	2	medium	1.00	0.00	46	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Process state model fits because it includes states such as ready, running, and waiting.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:processes:6
b695c73f-6e7b-4cfb-9da6-db8c0971964d	4544ad3c-9162-4d42-bbd7-9490220778f2	0cb45db0-4eeb-48ce-b9b0-cf1ac094ece8	Which term best matches this description: it has finished execution but still has an entry waiting to be collected?	["fork", "Pipe", "Race condition", "Zombie process"]	3	medium	1.00	0.00	47	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Zombie process fits because it has finished execution but still has an entry waiting to be collected.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:processes:7
6e99eb44-6658-4df6-9aa6-8cc21809c107	4544ad3c-9162-4d42-bbd7-9490220778f2	0cb45db0-4eeb-48ce-b9b0-cf1ac094ece8	Which term best matches this description: it creates a new process in Unix-like systems?	["fork", "Pipe", "Race condition", "Process"]	0	hard	1.00	0.00	48	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	fork fits because it creates a new process in unix-like systems.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:processes:8
c32e1e98-519a-482c-926b-c72c0ab29f44	4544ad3c-9162-4d42-bbd7-9490220778f2	0cb45db0-4eeb-48ce-b9b0-cf1ac094ece8	Which term best matches this description: it is a classic interprocess communication mechanism?	["Race condition", "Process", "Pipe", "Process control block"]	2	hard	1.00	0.00	49	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Pipe fits because it is a classic interprocess communication mechanism.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:processes:9
0ef3199d-76a2-49d5-8e4c-6e6022d22bd9	4544ad3c-9162-4d42-bbd7-9490220778f2	0cb45db0-4eeb-48ce-b9b0-cf1ac094ece8	Which term best matches this description: it arises when shared data is accessed without proper synchronization?	["Process", "Race condition", "Process control block", "Address space"]	1	hard	1.00	0.00	50	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Race condition fits because it arises when shared data is accessed without proper synchronization.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:processes:10
a0366ec1-9f1b-400b-a81f-b546f6d8c5f6	4544ad3c-9162-4d42-bbd7-9490220778f2	b2005f40-4939-4392-8db0-5d522b278cac	Which term best matches this description: it serves processes in the order they arrive?	["FCFS scheduling", "Round robin", "Shortest job first", "Preemption"]	0	easy	1.00	0.00	1	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	FCFS scheduling fits because it serves processes in the order they arrive.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:cpu_scheduling:1
af3e112b-89d4-4a40-b59a-30366d21d929	4544ad3c-9162-4d42-bbd7-9490220778f2	b2005f40-4939-4392-8db0-5d522b278cac	Which term best matches this description: it allocates CPU time using a fixed time quantum?	["Shortest job first", "Round robin", "Preemption", "Turnaround time"]	1	easy	1.00	0.00	2	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Round robin fits because it allocates cpu time using a fixed time quantum.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:cpu_scheduling:2
61274aff-b364-4f42-92ac-756c8ddec657	4544ad3c-9162-4d42-bbd7-9490220778f2	b2005f40-4939-4392-8db0-5d522b278cac	Which term best matches this description: it chooses the process with the smallest CPU burst time?	["Preemption", "Turnaround time", "Shortest job first", "Waiting time"]	2	easy	1.00	0.00	3	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Shortest job first fits because it chooses the process with the smallest cpu burst time.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:cpu_scheduling:3
a80f822a-4d0a-4c32-9b0f-2424dd0b122c	4544ad3c-9162-4d42-bbd7-9490220778f2	b2005f40-4939-4392-8db0-5d522b278cac	Which term best matches this description: it allows the scheduler to interrupt a running process?	["Turnaround time", "Waiting time", "Context-switch overhead", "Preemption"]	3	medium	1.00	0.00	4	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Preemption fits because it allows the scheduler to interrupt a running process.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:cpu_scheduling:4
47ff798c-ff24-4f08-bb34-b19b2b0cdbab	4544ad3c-9162-4d42-bbd7-9490220778f2	b2005f40-4939-4392-8db0-5d522b278cac	Which term best matches this description: it measures time from submission to completion?	["Waiting time", "Turnaround time", "Context-switch overhead", "Aging"]	1	medium	1.00	0.00	5	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Turnaround time fits because it measures time from submission to completion.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:cpu_scheduling:5
bd7614e4-a885-4228-8c84-b754d3d25d05	4544ad3c-9162-4d42-bbd7-9490220778f2	b2005f40-4939-4392-8db0-5d522b278cac	Which term best matches this description: it measures how long a process spends in the ready queue?	["Context-switch overhead", "Aging", "Waiting time", "Throughput"]	2	medium	1.00	0.00	6	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Waiting time fits because it measures how long a process spends in the ready queue.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:cpu_scheduling:6
112a5663-1b05-476b-8d02-ad7873556855	4544ad3c-9162-4d42-bbd7-9490220778f2	b2005f40-4939-4392-8db0-5d522b278cac	Which term best matches this description: it rises when the time quantum becomes very small?	["Aging", "Throughput", "Multilevel feedback queue", "Context-switch overhead"]	3	medium	1.00	0.00	7	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Context-switch overhead fits because it rises when the time quantum becomes very small.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:cpu_scheduling:7
94555bdd-107a-477b-ad82-cd83cd0b297a	4544ad3c-9162-4d42-bbd7-9490220778f2	b2005f40-4939-4392-8db0-5d522b278cac	Which term best matches this description: it can reduce starvation in priority scheduling?	["Aging", "Throughput", "Multilevel feedback queue", "FCFS scheduling"]	0	hard	1.00	0.00	8	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Aging fits because it can reduce starvation in priority scheduling.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:cpu_scheduling:8
282f0de2-636d-4d1d-b403-63e6dc699bf7	4544ad3c-9162-4d42-bbd7-9490220778f2	b2005f40-4939-4392-8db0-5d522b278cac	Which term best matches this description: it counts the number of completed processes per unit time?	["Multilevel feedback queue", "FCFS scheduling", "Throughput", "Round robin"]	2	hard	1.00	0.00	9	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Throughput fits because it counts the number of completed processes per unit time.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:cpu_scheduling:9
9ffa97ce-178d-4c35-b6d4-0c2d19a5982d	4544ad3c-9162-4d42-bbd7-9490220778f2	b2005f40-4939-4392-8db0-5d522b278cac	Which term best matches this description: it adapts scheduling priority based on observed behavior?	["FCFS scheduling", "Multilevel feedback queue", "Round robin", "Shortest job first"]	1	hard	1.00	0.00	10	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Multilevel feedback queue fits because it adapts scheduling priority based on observed behavior.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:cpu_scheduling:10
2f22001c-33ab-4b3f-be8e-6442574d10e5	4544ad3c-9162-4d42-bbd7-9490220778f2	ea4aca81-c81e-4730-aa8b-c36d5ee0e4b1	Which term best matches this description: it is a state where processes wait forever for resources held by each other?	["Deadlock", "Mutual exclusion", "Hold and wait", "Circular wait"]	0	easy	1.00	0.00	11	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Deadlock fits because it is a state where processes wait forever for resources held by each other.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:deadlocks:1
e53475e2-17b9-430f-add2-29e936f9e468	4544ad3c-9162-4d42-bbd7-9490220778f2	ea4aca81-c81e-4730-aa8b-c36d5ee0e4b1	Which term best matches this description: it is one of the Coffman conditions for deadlock?	["Hold and wait", "Mutual exclusion", "Circular wait", "Safe state"]	1	easy	1.00	0.00	12	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Mutual exclusion fits because it is one of the coffman conditions for deadlock.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:deadlocks:2
0636649a-182f-4513-8c08-5c26c8e2cd84	4544ad3c-9162-4d42-bbd7-9490220778f2	ea4aca81-c81e-4730-aa8b-c36d5ee0e4b1	Which term best matches this description: it means a process holds resources while waiting for others?	["Circular wait", "Safe state", "Hold and wait", "Resource allocation graph"]	2	easy	1.00	0.00	13	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Hold and wait fits because it means a process holds resources while waiting for others.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:deadlocks:3
697d1dd1-d575-4c92-a6f1-5c5377137e90	4544ad3c-9162-4d42-bbd7-9490220778f2	ea4aca81-c81e-4730-aa8b-c36d5ee0e4b1	Which term best matches this description: it means there is a closed chain of processes waiting on each other?	["Safe state", "Resource allocation graph", "Deadlock prevention", "Circular wait"]	3	medium	1.00	0.00	14	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Circular wait fits because it means there is a closed chain of processes waiting on each other.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:deadlocks:4
61d7c96c-e134-4da4-a7f4-db46431afbd3	4544ad3c-9162-4d42-bbd7-9490220778f2	ea4aca81-c81e-4730-aa8b-c36d5ee0e4b1	Which term best matches this description: it is a state from which all processes can still complete in some order?	["Resource allocation graph", "Safe state", "Deadlock prevention", "Deadlock detection"]	1	medium	1.00	0.00	15	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Safe state fits because it is a state from which all processes can still complete in some order.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:deadlocks:5
33d6191c-38b4-4071-8fa5-a9ab35d88482	4544ad3c-9162-4d42-bbd7-9490220778f2	ea4aca81-c81e-4730-aa8b-c36d5ee0e4b1	Which term best matches this description: it models relationships between processes and resources?	["Deadlock prevention", "Deadlock detection", "Resource allocation graph", "Recovery by preemption"]	2	medium	1.00	0.00	16	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Resource allocation graph fits because it models relationships between processes and resources.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:deadlocks:6
99caaf32-0a53-42ba-81a7-023d393d6ffb	4544ad3c-9162-4d42-bbd7-9490220778f2	ea4aca81-c81e-4730-aa8b-c36d5ee0e4b1	Which term best matches this description: it avoids deadlock by denying at least one necessary condition?	["Deadlock detection", "Recovery by preemption", "Ostrich algorithm", "Deadlock prevention"]	3	medium	1.00	0.00	17	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Deadlock prevention fits because it avoids deadlock by denying at least one necessary condition.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:deadlocks:7
63305f4a-f44e-4455-803c-71b1e2740885	4544ad3c-9162-4d42-bbd7-9490220778f2	ea4aca81-c81e-4730-aa8b-c36d5ee0e4b1	Which term best matches this description: it checks whether a deadlock has already occurred?	["Deadlock detection", "Recovery by preemption", "Ostrich algorithm", "Deadlock"]	0	hard	1.00	0.00	18	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Deadlock detection fits because it checks whether a deadlock has already occurred.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:deadlocks:8
3db94cf4-a596-41ba-876b-d42f50bc54d9	4544ad3c-9162-4d42-bbd7-9490220778f2	ea4aca81-c81e-4730-aa8b-c36d5ee0e4b1	Which term best matches this description: it resolves some deadlocks by taking resources back?	["Ostrich algorithm", "Deadlock", "Recovery by preemption", "Mutual exclusion"]	2	hard	1.00	0.00	19	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Recovery by preemption fits because it resolves some deadlocks by taking resources back.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:deadlocks:9
becf0504-ff30-4b26-a177-24bcb4080d2a	4544ad3c-9162-4d42-bbd7-9490220778f2	ea4aca81-c81e-4730-aa8b-c36d5ee0e4b1	Which term best matches this description: it refers to the strategy of ignoring deadlocks when they are very rare?	["Deadlock", "Ostrich algorithm", "Mutual exclusion", "Hold and wait"]	1	hard	1.00	0.00	20	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Ostrich algorithm fits because it refers to the strategy of ignoring deadlocks when they are very rare.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:deadlocks:10
275378b5-2f15-4ab4-a159-267d3cdd36b2	4544ad3c-9162-4d42-bbd7-9490220778f2	fcd9e4e8-bd42-446e-9257-4413498b6e7b	Which term best matches this description: it stores active programs and data in primary memory?	["RAM", "Paging", "Virtual memory", "Page fault"]	0	easy	1.00	0.00	31	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	RAM fits because it stores active programs and data in primary memory.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:memory_management:1
5f2394d4-c62a-4c4b-b4fb-c737566953d3	4544ad3c-9162-4d42-bbd7-9490220778f2	fcd9e4e8-bd42-446e-9257-4413498b6e7b	Which term best matches this description: it divides memory into fixed-size blocks called pages and frames?	["Virtual memory", "Paging", "Page fault", "Fragmentation"]	1	easy	1.00	0.00	32	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Paging fits because it divides memory into fixed-size blocks called pages and frames.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:memory_management:2
93883a56-c6d4-44a7-87a4-2eb637ac3ab4	4544ad3c-9162-4d42-bbd7-9490220778f2	fcd9e4e8-bd42-446e-9257-4413498b6e7b	Which term best matches this description: it gives processes the illusion of a larger logical address space?	["Page fault", "Fragmentation", "Virtual memory", "Page table"]	2	easy	1.00	0.00	33	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Virtual memory fits because it gives processes the illusion of a larger logical address space.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:memory_management:3
4d35ae49-2dfc-4547-a4b2-2e73615135e8	4544ad3c-9162-4d42-bbd7-9490220778f2	fcd9e4e8-bd42-446e-9257-4413498b6e7b	Which term best matches this description: it occurs when a referenced page is not currently in main memory?	["Fragmentation", "Page table", "TLB", "Page fault"]	3	medium	1.00	0.00	34	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Page fault fits because it occurs when a referenced page is not currently in main memory.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:memory_management:4
d220ba0a-fc77-4788-a253-7b8043f406a5	4544ad3c-9162-4d42-bbd7-9490220778f2	fcd9e4e8-bd42-446e-9257-4413498b6e7b	Which term best matches this description: it is wasted memory that may be internal or external?	["Page table", "Fragmentation", "TLB", "Least recently used"]	1	medium	1.00	0.00	35	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Fragmentation fits because it is wasted memory that may be internal or external.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:memory_management:5
e877815b-338b-4189-8455-9ab50ce70073	4544ad3c-9162-4d42-bbd7-9490220778f2	fcd9e4e8-bd42-446e-9257-4413498b6e7b	Which term best matches this description: it maps virtual addresses to physical addresses?	["TLB", "Least recently used", "Page table", "Demand paging"]	2	medium	1.00	0.00	36	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Page table fits because it maps virtual addresses to physical addresses.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:memory_management:6
f39a2a45-f8ce-4a01-934b-34090eff9477	4544ad3c-9162-4d42-bbd7-9490220778f2	fcd9e4e8-bd42-446e-9257-4413498b6e7b	Which term best matches this description: it caches recent virtual-to-physical address translations?	["Least recently used", "Demand paging", "Thrashing", "TLB"]	3	medium	1.00	0.00	37	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	TLB fits because it caches recent virtual-to-physical address translations.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:memory_management:7
2f2fcc38-4061-4ea1-a1a1-17bd625b5aaa	4544ad3c-9162-4d42-bbd7-9490220778f2	fcd9e4e8-bd42-446e-9257-4413498b6e7b	Which term best matches this description: it is a page replacement policy that evicts the least recently accessed page?	["Least recently used", "Demand paging", "Thrashing", "RAM"]	0	hard	1.00	0.00	38	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Least recently used fits because it is a page replacement policy that evicts the least recently accessed page.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:memory_management:8
19aa1b1a-ca95-4964-b44b-d61e1a358b03	4544ad3c-9162-4d42-bbd7-9490220778f2	fcd9e4e8-bd42-446e-9257-4413498b6e7b	Which term best matches this description: it loads pages only when they are actually needed?	["Thrashing", "RAM", "Demand paging", "Paging"]	2	hard	1.00	0.00	39	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Demand paging fits because it loads pages only when they are actually needed.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:memory_management:9
789fb8a7-780a-4644-bd33-a30c25647ade	4544ad3c-9162-4d42-bbd7-9490220778f2	fcd9e4e8-bd42-446e-9257-4413498b6e7b	Which term best matches this description: it is excessive paging that severely reduces useful CPU work?	["RAM", "Thrashing", "Paging", "Virtual memory"]	1	hard	1.00	0.00	40	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Thrashing fits because it is excessive paging that severely reduces useful cpu work.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:memory_management:10
e83d6dda-5d89-4bf5-9c41-40bd215e368e	4544ad3c-9162-4d42-bbd7-9490220778f2	018301c5-569c-4193-865e-4472084bb962	Which term best matches this description: it organizes data on long-term storage devices?	["File system", "Directory", "Absolute path", "File permission"]	0	easy	1.00	0.00	21	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	File system fits because it organizes data on long-term storage devices.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:file_systems:1
be183797-cf21-4b64-a431-c91040c16c12	4544ad3c-9162-4d42-bbd7-9490220778f2	018301c5-569c-4193-865e-4472084bb962	Which term best matches this description: it stores file names and references to file metadata?	["Absolute path", "Directory", "File permission", "Inode"]	1	easy	1.00	0.00	22	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Directory fits because it stores file names and references to file metadata.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:file_systems:2
160a265f-94f8-4ff3-8cce-777f3082e108	4544ad3c-9162-4d42-bbd7-9490220778f2	018301c5-569c-4193-865e-4472084bb962	Which term best matches this description: it starts from the root of the directory tree?	["File permission", "Inode", "Absolute path", "Contiguous allocation"]	2	easy	1.00	0.00	23	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Absolute path fits because it starts from the root of the directory tree.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:file_systems:3
b9b32dd9-63e4-4629-868f-9a96a632a071	4544ad3c-9162-4d42-bbd7-9490220778f2	018301c5-569c-4193-865e-4472084bb962	Which term best matches this description: it controls who can read, write, or execute a file?	["Inode", "Contiguous allocation", "Journaling", "File permission"]	3	medium	1.00	0.00	24	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	File permission fits because it controls who can read, write, or execute a file.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:file_systems:4
bf793459-34ac-42d2-bdf5-9ede7d6e16d9	4544ad3c-9162-4d42-bbd7-9490220778f2	018301c5-569c-4193-865e-4472084bb962	Which term best matches this description: it stores Unix-like file metadata separate from the filename?	["Contiguous allocation", "Inode", "Journaling", "Hard link"]	1	medium	1.00	0.00	25	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Inode fits because it stores unix-like file metadata separate from the filename.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:file_systems:5
fe642870-3949-4ce2-a93d-8e426681b992	4544ad3c-9162-4d42-bbd7-9490220778f2	018301c5-569c-4193-865e-4472084bb962	Which term best matches this description: it can suffer from external fragmentation over time?	["Journaling", "Hard link", "Contiguous allocation", "Buffer cache"]	2	medium	1.00	0.00	26	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Contiguous allocation fits because it can suffer from external fragmentation over time.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:file_systems:6
e92894d4-4660-488f-b78b-871f5819c72b	4544ad3c-9162-4d42-bbd7-9490220778f2	018301c5-569c-4193-865e-4472084bb962	Which term best matches this description: it helps a file system recover after a crash?	["Hard link", "Buffer cache", "Mount operation", "Journaling"]	3	medium	1.00	0.00	27	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Journaling fits because it helps a file system recover after a crash.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:file_systems:7
87f031a4-c8e0-4dc8-bcd7-52ed2484c932	4544ad3c-9162-4d42-bbd7-9490220778f2	018301c5-569c-4193-865e-4472084bb962	Which term best matches this description: it gives another directory entry that points to the same inode?	["Hard link", "Buffer cache", "Mount operation", "File system"]	0	hard	1.00	0.00	28	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Hard link fits because it gives another directory entry that points to the same inode.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:file_systems:8
10a22f29-df5d-4a1e-a9ac-420c9f834b23	4544ad3c-9162-4d42-bbd7-9490220778f2	018301c5-569c-4193-865e-4472084bb962	Which term best matches this description: it reduces disk access by keeping recently used blocks in memory?	["Mount operation", "File system", "Buffer cache", "Directory"]	2	hard	1.00	0.00	29	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Buffer cache fits because it reduces disk access by keeping recently used blocks in memory.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:file_systems:9
307367e6-d466-4a02-83ec-bdf12175b19e	4544ad3c-9162-4d42-bbd7-9490220778f2	018301c5-569c-4193-865e-4472084bb962	Which term best matches this description: it attaches a file system into the directory tree?	["File system", "Mount operation", "Directory", "Absolute path"]	1	hard	1.00	0.00	30	2026-08-27 08:41:05.691727+00	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	\N	\N	Mount operation fits because it attaches a file system into the directory tree.	\N	2026-08-27 08:41:05.691727+00	t	demo:question:operating_systems:file_systems:10
718e7f31-ef34-4c76-afb8-185a4892f629	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	cdc0efe2-8c71-48a6-adf7-c989e4ce3525	What is 25% of 200?	["50", "25", "40", "75"]	0	easy	1.00	0.00	31	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	One-fourth of 200 is 50	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:quantitative_aptitude:1
0ee7a716-7bf3-4df5-9b27-736213cc6113	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	cdc0efe2-8c71-48a6-adf7-c989e4ce3525	What is the simple interest on 1000 at 10% per year for 2 years?	["100", "200", "150", "250"]	1	easy	1.00	0.00	32	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	SI = PRT/100 = 1000 x 10 x 2 / 100	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:quantitative_aptitude:2
7dd44e5b-72d8-4690-838a-d14411861fa2	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	cdc0efe2-8c71-48a6-adf7-c989e4ce3525	What is the average of 4, 6, and 8?	["5", "7", "6", "8"]	2	easy	1.00	0.00	33	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Add the numbers and divide by 3	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:quantitative_aptitude:3
b6d4fb95-3519-4670-94e6-38224f669768	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	cdc0efe2-8c71-48a6-adf7-c989e4ce3525	Which ratio is equivalent to 2:3?	["3:4", "4:5", "6:4", "4:6"]	3	medium	1.00	0.00	34	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Multiply both parts by 2	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:quantitative_aptitude:4
b36033c9-9dca-4b1e-8a53-6ddc868fe267	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	cdc0efe2-8c71-48a6-adf7-c989e4ce3525	After a 20% increase, what does 50 become?	["55", "60", "65", "70"]	1	medium	1.00	0.00	35	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	20% of 50 is 10	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:quantitative_aptitude:5
bec1a89a-0662-4f2c-9022-37d4b1d91541	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	cdc0efe2-8c71-48a6-adf7-c989e4ce3525	A train travels at 60 km/h for 2 hours. What distance does it cover?	["90 km", "100 km", "120 km", "140 km"]	2	medium	1.00	0.00	36	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Distance = speed x time	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:quantitative_aptitude:6
aeafe5cc-e9f3-4e8e-8324-62c398c056a7	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	cdc0efe2-8c71-48a6-adf7-c989e4ce3525	If cost price is 80 and selling price is 100, what is the profit percentage?	["20%", "22.5%", "30%", "25%"]	3	medium	1.00	0.00	37	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Profit is 20 on a cost of 80	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:quantitative_aptitude:7
68a48d71-e60b-4dad-ad6f-f58817d34f91	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	cdc0efe2-8c71-48a6-adf7-c989e4ce3525	A can finish a job in 5 days. What fraction of the job is done in 2 days?	["2/5", "1/5", "3/5", "4/5"]	0	hard	1.00	0.00	38	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Daily rate is 1/5 of the job	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:quantitative_aptitude:8
894c0e16-7517-442b-9e13-2b5d21682b0a	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	cdc0efe2-8c71-48a6-adf7-c989e4ce3525	What is the compound interest on 1000 at 10% for 1 year?	["90", "110", "100", "121"]	2	hard	1.00	0.00	39	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	For one year, compound interest equals simple interest	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:quantitative_aptitude:9
98c24c47-3378-4f48-95a2-1cede6ff7e7a	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	cdc0efe2-8c71-48a6-adf7-c989e4ce3525	A mixture has 3 litres of water and 2 litres of juice. What fraction is juice?	["1/5", "2/5", "3/5", "2/3"]	1	hard	1.00	0.00	40	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Juice is 2 litres out of a total of 5	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:quantitative_aptitude:10
c1bb1ee8-6521-4313-8885-331c9cc44c91	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0045e312-20fa-4ddf-ae9b-3f545fd19050	All squares are rectangles. Which conclusion is definitely true?	["All squares are rectangles", "All rectangles are squares", "Some squares are triangles", "No square is a rectangle"]	0	easy	1.00	0.00	11	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	The conclusion repeats the given universal statement	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:logical_reasoning:1
4767667f-aebb-4427-8b9c-5843c2064482	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0045e312-20fa-4ddf-ae9b-3f545fd19050	Some cats are black. Which conclusion is valid?	["All cats are black", "Some black things are cats", "No black thing is a cat", "Every black thing is a cat"]	1	easy	1.00	0.00	12	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	If some cats are black, then some black things must be cats	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:logical_reasoning:2
afbc5fcd-f25c-47eb-ab6f-9a4d05895edd	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0045e312-20fa-4ddf-ae9b-3f545fd19050	Which number is the odd one out: 2, 4, 6, 9?	["2", "4", "9", "6"]	2	easy	1.00	0.00	13	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	The others are even numbers	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:logical_reasoning:3
00ff9661-e0cd-4468-90f4-6b45a5383ab8	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0045e312-20fa-4ddf-ae9b-3f545fd19050	A person facing north turns right. Which direction does the person face now?	["West", "South", "North", "East"]	3	medium	1.00	0.00	14	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	A right turn from north points east	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:logical_reasoning:4
ffaeef36-ab77-4450-9e5d-b95863f8629d	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0045e312-20fa-4ddf-ae9b-3f545fd19050	All roses are flowers. Which conclusion is definitely true?	["Every flower is a rose", "Every rose is a flower", "No rose is a flower", "Some flowers are not flowers"]	1	medium	1.00	0.00	15	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	It restates the original premise	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:logical_reasoning:5
7447f396-078f-4f2b-ba95-3c3a2cba8299	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0045e312-20fa-4ddf-ae9b-3f545fd19050	What comes next in the sequence A, C, E, G?	["H", "J", "I", "K"]	2	medium	1.00	0.00	16	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	The letters advance by skipping one each time	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:logical_reasoning:6
b53d1ef9-acdb-4941-8b2f-60f5d74c5e80	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0045e312-20fa-4ddf-ae9b-3f545fd19050	If today is Monday, what day will it be after 10 days?	["Wednesday", "Friday", "Saturday", "Thursday"]	3	medium	1.00	0.00	17	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Ten days after Monday is three days ahead in the weekly cycle	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:logical_reasoning:7
338d08e1-96f8-4bca-8a17-7506c26d83e5	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0045e312-20fa-4ddf-ae9b-3f545fd19050	If CAT is coded as DBU by shifting each letter by one, how is DOG coded?	["EPH", "DNG", "EOH", "FPH"]	0	hard	1.00	0.00	18	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Shift D to E, O to P, and G to H	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:logical_reasoning:8
b2f351c0-5c41-4bfb-99b5-9e21065b2e1e	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0045e312-20fa-4ddf-ae9b-3f545fd19050	What is your mother's brother to you?	["Cousin", "Nephew", "Uncle", "Grandfather"]	2	hard	1.00	0.00	19	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Your mother's brother is your uncle	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:logical_reasoning:9
b9cb07dc-e326-44bf-b193-e7e2f0f429ff	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	0045e312-20fa-4ddf-ae9b-3f545fd19050	If all bloops are razzies and all razzies are lazzies, what follows?	["All lazzies are bloops", "All bloops are lazzies", "No bloops are lazzies", "Some lazzies are not razzies only"]	1	hard	1.00	0.00	20	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	The relationship is transitive	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:logical_reasoning:10
62dfd123-df55-4cbf-8e98-e1ed8eb9821d	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	d5e6e734-a122-4898-9ad7-c94915a2d1e2	Book is to read as music is to what?	["Listen", "Write", "Paint", "Dance"]	0	easy	1.00	0.00	41	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Books are read and music is listened to	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:verbal_reasoning:1
795d3f41-eb15-4991-bf47-3c4225c55ca5	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	d5e6e734-a122-4898-9ad7-c94915a2d1e2	Which word is a synonym of concise?	["Noisy", "Brief", "Costly", "Timid"]	1	easy	1.00	0.00	42	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Concise means brief and to the point	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:verbal_reasoning:2
618368ee-2db6-4e80-805c-c96a0f508b85	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	d5e6e734-a122-4898-9ad7-c94915a2d1e2	Which word is an antonym of expand?	["Stretch", "Grow", "Contract", "Broaden"]	2	easy	1.00	0.00	43	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Contract is the opposite of expand	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:verbal_reasoning:3
e1499fce-a0df-408c-a927-29d69a4bf4ec	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	d5e6e734-a122-4898-9ad7-c94915a2d1e2	Choose the word that best completes the sentence: The evidence was ___ to convict the suspect.	["Abundant", "Clear", "Final", "Insufficient"]	3	medium	1.00	0.00	44	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	The sentence requires a word meaning not enough	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:verbal_reasoning:4
1333b565-ca8f-4fe2-8474-595b8e438bc8	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	d5e6e734-a122-4898-9ad7-c94915a2d1e2	Rearrange the letters LPAEP to form a meaningful word.	["PAPER", "APPLE", "LAPSE", "PLEAT"]	1	medium	1.00	0.00	45	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	The letters can be reordered to spell APPLE	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:verbal_reasoning:5
9b921879-cdaa-4fe7-99ad-21d213c0d97a	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	d5e6e734-a122-4898-9ad7-c94915a2d1e2	What is the one-word term for fear of heights?	["Claustrophobia", "Hydrophobia", "Acrophobia", "Arachnophobia"]	2	medium	1.00	0.00	46	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Acrophobia means fear of heights	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:verbal_reasoning:6
31d98d9b-d867-4ae4-b4f2-afe1c767dd20	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	d5e6e734-a122-4898-9ad7-c94915a2d1e2	All finalists submitted the project. Mira is a finalist. What follows?	["Mira wrote every project", "No finalist submitted the project", "Mira is not a finalist", "Mira submitted the project"]	3	medium	1.00	0.00	47	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Apply the general statement to Mira	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:verbal_reasoning:7
0075b70c-a141-4afe-bbbb-366d51a89817	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	d5e6e734-a122-4898-9ad7-c94915a2d1e2	Choose the correct passive form of: The team completed the task.	["The task was completed by the team", "The task completed the team", "The team was completed by the task", "The task has completing the team"]	0	hard	1.00	0.00	48	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	The object becomes the subject in passive voice	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:verbal_reasoning:8
1159af98-9ea9-467f-9528-297e82772ad2	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	d5e6e734-a122-4898-9ad7-c94915a2d1e2	Doctor is to hospital as teacher is to what?	["Library", "Garden", "School", "Airport"]	2	hard	1.00	0.00	49	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	A teacher commonly works in a school	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:verbal_reasoning:9
1235dca4-55aa-4d04-aa36-65ffdcca7d80	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	d5e6e734-a122-4898-9ad7-c94915a2d1e2	Finger is to hand as toe is to what?	["Leg", "Foot", "Ankle", "Knee"]	1	hard	1.00	0.00	50	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	A toe is part of a foot	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:verbal_reasoning:10
795a3176-0cdd-47c1-901c-2d3f29ab234d	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	ddbc0300-a68e-4091-a663-baa86d6ee8d3	A store sold 120 units in Q1 and 150 units in Q2. What was the increase?	["25%", "20%", "22.5%", "30%"]	0	easy	1.00	0.00	1	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Increase is 30 on a base of 120	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:data_interpretation:1
6a665500-9958-4993-859a-328db4878b7e	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	ddbc0300-a68e-4091-a663-baa86d6ee8d3	A shop earned 200, 250, and 300 over three days. What was the total earning?	["700", "750", "800", "850"]	1	easy	1.00	0.00	2	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Add the three daily earnings	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:data_interpretation:2
de50ea2e-20d7-4ab5-9434-87de411ee58d	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	ddbc0300-a68e-4091-a663-baa86d6ee8d3	If 36 out of 60 students passed, how many failed?	["20", "22", "24", "26"]	2	easy	1.00	0.00	3	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Failed students equal total minus passed	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:data_interpretation:3
8803d7cd-920d-4675-8057-8dd46a82d0ae	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	ddbc0300-a68e-4091-a663-baa86d6ee8d3	If a class has 18 boys and 12 girls, what is the ratio of boys to girls?	["2:3", "3:1", "4:3", "3:2"]	3	medium	1.00	0.00	4	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Simplify 18:12 by dividing by 6	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:data_interpretation:4
f1ca4cad-34e0-4438-8042-a934b74effc7	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	ddbc0300-a68e-4091-a663-baa86d6ee8d3	A bus starts empty, 50 passengers board, and 15 leave. How many remain?	["30", "35", "40", "45"]	1	medium	1.00	0.00	5	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Subtract those who left from those who boarded	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:data_interpretation:5
a3eb1923-e13d-4a35-bdb9-32738920f19b	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	ddbc0300-a68e-4091-a663-baa86d6ee8d3	A library has 200 books and 40% are fiction. How many fiction books are there?	["60", "70", "80", "90"]	2	medium	1.00	0.00	6	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Forty percent of 200 is 80	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:data_interpretation:6
eb3e9910-5262-4ce2-a583-1ae472166a5a	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	ddbc0300-a68e-4091-a663-baa86d6ee8d3	The temperatures for three days are 28, 30, and 32 degrees. What is the average?	["29", "31", "32", "30"]	3	medium	1.00	0.00	7	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Average = (28 + 30 + 32) / 3	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:data_interpretation:7
fc18abf7-051e-428f-ac2c-8e0932411521	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	ddbc0300-a68e-4091-a663-baa86d6ee8d3	Revenue is 5000 and cost is 3500. What is the profit?	["1500", "1200", "1400", "1600"]	0	hard	1.00	0.00	8	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Profit equals revenue minus cost	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:data_interpretation:8
a39c9474-de6b-4d74-9f24-f45f205f84df	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	ddbc0300-a68e-4091-a663-baa86d6ee8d3	A population grows from 80,000 to 92,000. What is the percentage growth?	["10%", "12%", "15%", "20%"]	2	hard	1.00	0.00	9	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Growth is 12,000 on a base of 80,000	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:data_interpretation:9
0a061be0-29a5-4f8e-b0d6-1bdd7748d14b	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	ddbc0300-a68e-4091-a663-baa86d6ee8d3	Scores in five matches are 12, 18, 15, 25, and 20. What is the highest score?	["18", "25", "20", "22"]	1	hard	1.00	0.00	10	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Identify the maximum value in the set	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:data_interpretation:10
a4571d13-2a48-4799-acb2-11f4373659a3	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	9b2053a5-dd87-43a2-9bb7-56c77e52b37f	What comes next in the series 2, 4, 6, 8?	["10", "9", "11", "12"]	0	easy	1.00	0.00	21	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	The pattern adds 2 each time	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:number_series:1
933e19ec-b593-4aec-b6bc-8461c5d777a2	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	9b2053a5-dd87-43a2-9bb7-56c77e52b37f	What comes next in the series 3, 6, 12, 24?	["30", "48", "36", "42"]	1	easy	1.00	0.00	22	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	The pattern doubles each term	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:number_series:2
d4376eab-c639-4f16-8f1f-b641678b5811	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	9b2053a5-dd87-43a2-9bb7-56c77e52b37f	What comes next in the series 7, 14, 28, 56?	["96", "104", "120", "112"]	3	medium	1.00	0.00	27	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	The pattern doubles each term	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:number_series:7
44fe23ba-2b0a-4ea5-95a3-5c97b9503c77	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	9b2053a5-dd87-43a2-9bb7-56c77e52b37f	What comes next in the series 100, 95, 85, 70?	["50", "55", "60", "65"]	0	hard	1.00	0.00	28	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Subtract 5, then 10, then 15, then 20	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:number_series:8
61885617-0849-4ab7-948f-ef3c492fa867	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	9b2053a5-dd87-43a2-9bb7-56c77e52b37f	What comes next in the series 1, 4, 9, 16?	["20", "24", "25", "26"]	2	hard	1.00	0.00	29	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	These are perfect squares	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:number_series:9
b07eaf9a-d117-4ee4-884b-49bb0020294c	3d9c0b54-374d-4e1d-9d4e-9eb42cd1e51e	9b2053a5-dd87-43a2-9bb7-56c77e52b37f	What comes next in the series 2, 3, 5, 8, 13?	["18", "21", "20", "22"]	1	hard	1.00	0.00	30	2026-08-27 08:41:05.691727+00	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	\N	\N	Each term equals the sum of the previous two	\N	2026-08-27 08:41:05.691727+00	t	demo:question:aptitude_and_reasoning:number_series:10
1f699e70-db3a-4c35-aafd-f1275ee33413	dc6365ab-35e3-4186-8631-14faffe07840	f42d3697-419c-4a1a-b588-5fd632ec965e	In the sentence She sings, which word is the pronoun?	["She", "sings", "the", "sentence"]	0	easy	1.00	0.00	1	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	She replaces a noun and functions as a pronoun	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:grammar:1
2a2693a6-3245-4eda-a7ba-44dd65a5ca62	dc6365ab-35e3-4186-8631-14faffe07840	f42d3697-419c-4a1a-b588-5fd632ec965e	What is the past tense of go?	["goed", "went", "gone", "going"]	1	easy	1.00	0.00	2	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Went is the correct simple past form	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:grammar:2
f1efce00-8f4b-4b71-b931-bc669b097769	dc6365ab-35e3-4186-8631-14faffe07840	f42d3697-419c-4a1a-b588-5fd632ec965e	Which part of speech usually modifies a noun?	["Adverb", "Verb", "Adjective", "Preposition"]	2	easy	1.00	0.00	3	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Adjectives describe nouns	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:grammar:3
01f329bc-9738-45e2-a793-55bac1b4c93d	dc6365ab-35e3-4186-8631-14faffe07840	f42d3697-419c-4a1a-b588-5fd632ec965e	Choose the correct sentence: He ___ to school every day.	["go", "gone", "going", "goes"]	3	medium	1.00	0.00	4	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	A third-person singular subject takes goes	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:grammar:4
d216b6e5-4cda-4b0b-87db-ee5fcee52bc6	dc6365ab-35e3-4186-8631-14faffe07840	f42d3697-419c-4a1a-b588-5fd632ec965e	What is the plural form of child?	["childs", "children", "childes", "childrens"]	1	medium	1.00	0.00	5	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Children is the irregular plural	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:grammar:5
84324e80-a6c6-43b7-9110-717aa7dfd54d	dc6365ab-35e3-4186-8631-14faffe07840	f42d3697-419c-4a1a-b588-5fd632ec965e	Which article is correct before honest?	["a", "the", "an", "no article"]	2	medium	1.00	0.00	6	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Honest begins with a vowel sound	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:grammar:6
7aa05be2-ce64-429c-a9d5-17c8a20e0090	dc6365ab-35e3-4186-8631-14faffe07840	f42d3697-419c-4a1a-b588-5fd632ec965e	Choose the correct sentence.	["The list of items are on the desk", "The list of items be on the desk", "The list of items were on the desk", "The list of items is on the desk"]	3	medium	1.00	0.00	7	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	The subject list is singular	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:grammar:7
f519a0dd-fd04-49cf-ad19-cf56cf5045dc	dc6365ab-35e3-4186-8631-14faffe07840	f42d3697-419c-4a1a-b588-5fd632ec965e	Choose the correct passive form of They built a bridge.	["A bridge was built by them", "A bridge is built by them", "They were built by a bridge", "A bridge built them"]	0	hard	1.00	0.00	8	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Passive voice uses was built	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:grammar:8
41bece5e-7018-4191-a9aa-9afc340831eb	dc6365ab-35e3-4186-8631-14faffe07840	f42d3697-419c-4a1a-b588-5fd632ec965e	Complete the sentence: If I ___ time, I would travel.	["have", "has", "had", "having"]	2	hard	1.00	0.00	9	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	The second conditional uses if + past tense	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:grammar:9
85fd2adb-7e29-4600-8954-9bdff1cd76a4	dc6365ab-35e3-4186-8631-14faffe07840	f42d3697-419c-4a1a-b588-5fd632ec965e	Identify the adverb in the sentence She spoke softly.	["She", "softly", "spoke", "sentence"]	1	hard	1.00	0.00	10	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Softly modifies the verb spoke	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:grammar:10
0d3d1eeb-7d8f-4662-9977-94864f4040c9	dc6365ab-35e3-4186-8631-14faffe07840	69e0c2b4-1f30-49a0-914f-fd15a6840341	What does benevolent mean?	["Kind and generous", "Angry and violent", "Silent and shy", "Lazy and careless"]	0	easy	1.00	0.00	41	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Benevolent describes someone kind and well-meaning	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:vocabulary:1
449df994-b364-434f-abeb-51a02023d79f	dc6365ab-35e3-4186-8631-14faffe07840	69e0c2b4-1f30-49a0-914f-fd15a6840341	Choose a synonym of rapid.	["Heavy", "Fast", "Calm", "Late"]	1	easy	1.00	0.00	42	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Rapid means fast	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:vocabulary:2
a154c20e-ac2c-4c9b-a267-265c8bc17b17	dc6365ab-35e3-4186-8631-14faffe07840	69e0c2b4-1f30-49a0-914f-fd15a6840341	Choose an antonym of scarce.	["Rare", "Limited", "Abundant", "Insufficient"]	2	easy	1.00	0.00	43	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Scarce means not enough, so abundant is the opposite	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:vocabulary:3
d69919b3-9d08-49b1-982a-b777d37bc6bf	dc6365ab-35e3-4186-8631-14faffe07840	69e0c2b4-1f30-49a0-914f-fd15a6840341	What does diligent mean?	["Careless", "Noisy", "Forgetful", "Hardworking"]	3	medium	1.00	0.00	44	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Diligent describes steady effort and hard work	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:vocabulary:4
c14e9586-5eea-42a6-a951-aca55ce75b68	dc6365ab-35e3-4186-8631-14faffe07840	69e0c2b4-1f30-49a0-914f-fd15a6840341	What does obsolete mean?	["Flexible", "Outdated", "Bright", "Valuable"]	1	medium	1.00	0.00	45	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Obsolete means no longer in common use	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:vocabulary:5
02a47202-943f-4d7e-87b1-82476549a2d0	dc6365ab-35e3-4186-8631-14faffe07840	69e0c2b4-1f30-49a0-914f-fd15a6840341	What does fragile mean?	["Very heavy", "Highly polished", "Easily broken", "Always useful"]	2	medium	1.00	0.00	46	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Fragile items break easily	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:vocabulary:6
3759f68d-fa81-475f-984c-e072d932ef86	dc6365ab-35e3-4186-8631-14faffe07840	69e0c2b4-1f30-49a0-914f-fd15a6840341	What does vivid mean?	["Extremely dull", "Slightly hidden", "Randomly arranged", "Very clear and bright"]	3	medium	1.00	0.00	47	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Vivid language produces strong clear images	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:vocabulary:7
69bd9912-cc2d-4359-9e0e-96c45f2a2dff	dc6365ab-35e3-4186-8631-14faffe07840	69e0c2b4-1f30-49a0-914f-fd15a6840341	What does mitigate mean?	["Make less severe", "Increase sharply", "Ignore completely", "Measure exactly"]	0	hard	1.00	0.00	48	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Mitigate means reduce intensity or seriousness	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:vocabulary:8
d9f16d2a-32cb-4fe4-8458-6babcfc24f92	dc6365ab-35e3-4186-8631-14faffe07840	69e0c2b4-1f30-49a0-914f-fd15a6840341	What does ambiguous mean?	["Very short", "Completely honest", "Having more than one possible meaning", "Easy to count"]	2	hard	1.00	0.00	49	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Ambiguous language can be interpreted in multiple ways	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:vocabulary:9
05c23db6-3fbc-442c-997b-a9d191581523	dc6365ab-35e3-4186-8631-14faffe07840	69e0c2b4-1f30-49a0-914f-fd15a6840341	What does resilient mean?	["Unable to move", "Able to recover quickly", "Easy to offend", "Slow to learn"]	1	hard	1.00	0.00	50	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Resilient people or systems bounce back after difficulty	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:vocabulary:10
67cd62c9-ee36-46c1-9e62-bd19144307b9	dc6365ab-35e3-4186-8631-14faffe07840	a3626561-314a-4325-8a8c-4a42863d9d48	Choose a synonym of ancient.	["Modern", "Tiny", "Old", "Sharp"]	2	easy	1.00	0.00	33	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Ancient means very old	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:synonyms_and_antonyms:3
3afe1a9d-4d26-4000-bc1b-51133a302f66	dc6365ab-35e3-4186-8631-14faffe07840	df2d8bd4-d592-4357-ae3c-4c0d976a4e53	Passage: Riya studied in short daily sessions instead of one long session. Over a month, her recall improved and her stress decreased. What is the main idea?	["Consistent short study improved learning", "Long sessions always fail", "Stress is useful for memory", "Riya stopped studying"]	0	easy	1.00	0.00	11	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	The passage highlights the benefit of regular shorter study sessions	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:reading_comprehension:1
80310cf0-3dac-418d-846f-664b177ae74e	dc6365ab-35e3-4186-8631-14faffe07840	df2d8bd4-d592-4357-ae3c-4c0d976a4e53	In the same passage, what improved over the month?	["Travel time", "Recall", "Attendance", "Classroom size"]	1	easy	1.00	0.00	12	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	The passage explicitly says her recall improved	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:reading_comprehension:2
da565975-12e3-46ed-8bd9-2707a52994d0	dc6365ab-35e3-4186-8631-14faffe07840	df2d8bd4-d592-4357-ae3c-4c0d976a4e53	In the same passage, what happened to Riya's stress?	["It doubled", "It stayed exactly the same", "It decreased", "It became unimportant"]	2	easy	1.00	0.00	13	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	The passage says her stress decreased	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:reading_comprehension:3
0b07005f-2713-4ab0-9c58-8d48bedbe118	dc6365ab-35e3-4186-8631-14faffe07840	df2d8bd4-d592-4357-ae3c-4c0d976a4e53	Which method did Riya avoid?	["Daily revision", "Writing notes", "Taking practice tests", "One long study session"]	3	medium	1.00	0.00	14	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	She chose short daily sessions instead of one long session	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:reading_comprehension:4
d2754d31-7f22-491d-a744-97d107a58206	dc6365ab-35e3-4186-8631-14faffe07840	df2d8bd4-d592-4357-ae3c-4c0d976a4e53	What can be inferred from the passage?	["She studied only once", "Consistency supported her progress", "She stopped revising", "She changed schools"]	1	medium	1.00	0.00	15	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Improved recall and lower stress suggest the regular method helped	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:reading_comprehension:5
e9d55130-9b49-4ed6-860c-9648b790a309	dc6365ab-35e3-4186-8631-14faffe07840	df2d8bd4-d592-4357-ae3c-4c0d976a4e53	Passage: The city library introduced weekend workshops on coding and robotics. Attendance doubled within three months, especially among high school students. What topics were introduced?	["Music and dance", "History and law", "Coding and robotics", "Painting and drama"]	2	medium	1.00	0.00	16	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	The passage names coding and robotics directly	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:reading_comprehension:6
1cb593e7-b238-46e7-8640-41efd6e572a7	dc6365ab-35e3-4186-8631-14faffe07840	df2d8bd4-d592-4357-ae3c-4c0d976a4e53	What happened to workshop attendance?	["It halved", "It ended", "It stayed unchanged", "It doubled"]	3	medium	1.00	0.00	17	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	The passage states that attendance doubled	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:reading_comprehension:7
aab37b88-ea4a-445a-8e91-0fbe809eea80	dc6365ab-35e3-4186-8631-14faffe07840	df2d8bd4-d592-4357-ae3c-4c0d976a4e53	Within how much time did attendance double?	["Three months", "Three weeks", "Six months", "One year"]	0	hard	1.00	0.00	18	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	The timeframe is given directly in the passage	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:reading_comprehension:8
9f0d50e3-95ef-4f6d-9f06-3e7c941f9a55	dc6365ab-35e3-4186-8631-14faffe07840	df2d8bd4-d592-4357-ae3c-4c0d976a4e53	Which group showed special interest?	["Retired librarians", "Primary teachers only", "High school students", "Tourists"]	2	hard	1.00	0.00	19	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	The passage says especially among high school students	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:reading_comprehension:9
42b35a2c-82ad-4261-a23d-eb309b1102d8	dc6365ab-35e3-4186-8631-14faffe07840	df2d8bd4-d592-4357-ae3c-4c0d976a4e53	What is the best inference from the second passage?	["Libraries should close on weekends", "Interest in practical tech learning increased", "Only robots matter now", "Attendance always falls after workshops"]	1	hard	1.00	0.00	20	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	The attendance growth suggests demand for applied tech learning	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:reading_comprehension:10
dea6782e-a1a2-4507-a5f6-28b44adea81c	dc6365ab-35e3-4186-8631-14faffe07840	d37077ae-8a72-4f2d-b230-22feaff498d6	Choose the correct form: Neither of the boys ___ late.	["is", "are", "were", "be"]	0	easy	1.00	0.00	21	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Neither is treated as singular here	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:sentence_correction:1
b96e6c5a-fb1d-40ae-b4df-536df551a675	dc6365ab-35e3-4186-8631-14faffe07840	d37077ae-8a72-4f2d-b230-22feaff498d6	Choose the correct form: She ___ like coffee.	["don't", "doesn't", "isn't", "won't"]	1	easy	1.00	0.00	22	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Third-person singular takes does not	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:sentence_correction:2
e4e4e355-5dc1-4e43-9a24-60c968845ed6	dc6365ab-35e3-4186-8631-14faffe07840	d37077ae-8a72-4f2d-b230-22feaff498d6	Choose the correct form: Each of the players ___ ready.	["were", "are", "was", "have"]	2	easy	1.00	0.00	23	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Each is singular	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:sentence_correction:3
feddce35-0aa8-4e17-a0f1-79ef4778e2f3	dc6365ab-35e3-4186-8631-14faffe07840	d37077ae-8a72-4f2d-b230-22feaff498d6	Choose the correct sentence.	["I have less books than you", "I have lesser books than you", "I has fewer books than you", "I have fewer books than you"]	3	medium	1.00	0.00	24	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Countable nouns take fewer rather than less	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:sentence_correction:4
b82dee4e-1452-42b6-bc65-b31e9237555b	dc6365ab-35e3-4186-8631-14faffe07840	d37077ae-8a72-4f2d-b230-22feaff498d6	Choose the correct phrase.	["He is senior than me", "He is senior to me", "He is more senior than me only", "He is senior from me"]	1	medium	1.00	0.00	25	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Senior takes the preposition to	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:sentence_correction:5
a8e99c3e-4cda-4932-9679-7491977a2aab	dc6365ab-35e3-4186-8631-14faffe07840	d37077ae-8a72-4f2d-b230-22feaff498d6	Choose the correct sentence.	["The news are surprising", "The news be surprising", "The news is surprising", "The news were surprise"]	2	medium	1.00	0.00	26	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	News takes a singular verb	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:sentence_correction:6
1b10c6ea-dd08-44cb-9f21-5d6487feb6b8	dc6365ab-35e3-4186-8631-14faffe07840	d37077ae-8a72-4f2d-b230-22feaff498d6	Choose the correct sentence.	["One of the student have won", "One of the students have won", "One of the student has woned", "One of the students has won"]	3	medium	1.00	0.00	27	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	The subject one is singular	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:sentence_correction:7
fd6126a1-33a0-418c-9845-717b18ac5614	dc6365ab-35e3-4186-8631-14faffe07840	d37077ae-8a72-4f2d-b230-22feaff498d6	Choose the correct form: If I ___ you, I would apologize.	["were", "was", "am", "be"]	0	hard	1.00	0.00	28	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Formal subjunctive uses were	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:sentence_correction:8
e7fe4ff2-0545-4d40-9dfe-10866fda3a08	dc6365ab-35e3-4186-8631-14faffe07840	d37077ae-8a72-4f2d-b230-22feaff498d6	Choose the correct preposition: She is good ___ mathematics.	["in", "on", "at", "for"]	2	hard	1.00	0.00	29	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Good at is the standard expression	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:sentence_correction:9
43d2aa04-f535-43e7-ad9b-eb89bada3899	dc6365ab-35e3-4186-8631-14faffe07840	d37077ae-8a72-4f2d-b230-22feaff498d6	Choose the correct pair: No sooner did he arrive ___ it started raining.	["when", "than", "then", "and"]	1	hard	1.00	0.00	30	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	The fixed expression is no sooner...than	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:sentence_correction:10
800c6667-7c18-479a-bc6a-1ecf92332133	dc6365ab-35e3-4186-8631-14faffe07840	a3626561-314a-4325-8a8c-4a42863d9d48	Choose a synonym of honest.	["Truthful", "Cruel", "Slow", "Dim"]	0	easy	1.00	0.00	31	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Truthful is close in meaning to honest	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:synonyms_and_antonyms:1
c0d43e2c-fc10-4cde-8b0e-e4bb6c465a03	dc6365ab-35e3-4186-8631-14faffe07840	a3626561-314a-4325-8a8c-4a42863d9d48	Choose an antonym of expand.	["Grow", "Contract", "Stretch", "Multiply"]	1	easy	1.00	0.00	32	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Contract is the opposite of expand	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:synonyms_and_antonyms:2
94115216-7cd1-4fba-b659-9fac56268caf	dc6365ab-35e3-4186-8631-14faffe07840	a3626561-314a-4325-8a8c-4a42863d9d48	Choose an antonym of victory.	["Success", "Reward", "Effort", "Defeat"]	3	medium	1.00	0.00	34	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Defeat is the opposite of victory	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:synonyms_and_antonyms:4
3a9a94a7-4485-4e8a-9bc2-da0dbd919745	dc6365ab-35e3-4186-8631-14faffe07840	a3626561-314a-4325-8a8c-4a42863d9d48	Choose a synonym of assist.	["Delay", "Help", "Hide", "Argue"]	1	medium	1.00	0.00	35	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Assist means help	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:synonyms_and_antonyms:5
72d87f01-c4c8-4b10-93c1-d85a8bb9a376	dc6365ab-35e3-4186-8631-14faffe07840	a3626561-314a-4325-8a8c-4a42863d9d48	Choose an antonym of minor.	["Small", "Fewer", "Major", "Brief"]	2	medium	1.00	0.00	36	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Major is the opposite of minor	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:synonyms_and_antonyms:6
917824ad-a2ad-4a71-8362-9800c11f2195	dc6365ab-35e3-4186-8631-14faffe07840	a3626561-314a-4325-8a8c-4a42863d9d48	Choose a synonym of silent.	["Bright", "Rough", "Sudden", "Quiet"]	3	medium	1.00	0.00	37	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Quiet closely matches silent	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:synonyms_and_antonyms:7
8af020b8-2080-4042-b34f-94bedb9c81ae	dc6365ab-35e3-4186-8631-14faffe07840	a3626561-314a-4325-8a8c-4a42863d9d48	Choose an antonym of generous.	["Stingy", "Helpful", "Open", "Cheerful"]	0	hard	1.00	0.00	38	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Stingy is the opposite of generous	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:synonyms_and_antonyms:8
cc45a1f5-a62b-45b1-b4ae-bd2a5f5f7553	dc6365ab-35e3-4186-8631-14faffe07840	a3626561-314a-4325-8a8c-4a42863d9d48	Choose a synonym of commence.	["Finish", "Delay", "Begin", "Avoid"]	2	hard	1.00	0.00	39	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Commence means begin	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:synonyms_and_antonyms:9
7b8090a5-e005-4e1a-ac67-ae77218f6daa	dc6365ab-35e3-4186-8631-14faffe07840	a3626561-314a-4325-8a8c-4a42863d9d48	Choose an antonym of fragile.	["Thin", "Sturdy", "Tiny", "Dusty"]	1	hard	1.00	0.00	40	2026-08-27 08:41:05.691727+00	1f77c53e-73f4-40e1-bf17-3d005994b9b4	\N	\N	Sturdy means strong and not easily broken	\N	2026-08-27 08:41:05.691727+00	t	demo:question:english:synonyms_and_antonyms:10
\.


--
-- TOC entry 5078 (class 0 OID 18080)
-- Dependencies: 366
-- Data for Name: recommendations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.recommendations (id, user_id, topic_id, priority, accuracy, reason, recommendation, suggested_questions, status, performance_version, created_at, updated_at) FROM stdin;
5ed5adbc-f986-458a-a596-d10146bb1192	97ad6c7c-6f13-4266-8241-a72deab8f86a	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	high	10.00	Current accuracy is 10% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-27 10:12:28.266848+00	2026-08-27 10:12:28.266848+00	2026-08-27 10:13:32.202+00
47a8a55c-b56c-49d2-9432-b53357931fa2	97ad6c7c-6f13-4266-8241-a72deab8f86a	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	high	20.00	Current accuracy is 20% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-27 10:12:28.266848+00	2026-08-27 10:12:28.266848+00	2026-08-27 10:13:32.202+00
11db5afe-0295-4bde-b7c7-e8de645333b2	97ad6c7c-6f13-4266-8241-a72deab8f86a	68d8f6be-90c5-4893-84f0-afe6b5270631	high	22.22	Current accuracy is 22% across 9 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-27 10:12:28.266848+00	2026-08-27 10:12:28.266848+00	2026-08-27 10:13:32.202+00
97d8318d-e060-4b07-b132-ce4a4c702b30	97ad6c7c-6f13-4266-8241-a72deab8f86a	6985fef8-92cf-47a8-aad8-88754030af2c	high	30.00	Current accuracy is 30% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-27 10:12:28.266848+00	2026-08-27 10:12:28.266848+00	2026-08-27 10:13:32.202+00
633292d1-0c2c-4d0d-bb4a-b2493ac521ae	97ad6c7c-6f13-4266-8241-a72deab8f86a	965b5429-8685-4cc9-a7be-42858adcd165	high	40.00	Current accuracy is 40% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-27 10:12:28.266848+00	2026-08-27 10:12:28.266848+00	2026-08-27 10:13:32.202+00
4bafb4a4-56f0-45c7-8a6e-ffd1059aa382	97ad6c7c-6f13-4266-8241-a72deab8f86a	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	high	10.00	Current accuracy is 10% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-27 10:12:28.578957+00	2026-08-27 10:12:28.578957+00	2026-08-28 06:08:29.878+00
b2ad0229-0f3c-42c9-8810-490233680ba7	97ad6c7c-6f13-4266-8241-a72deab8f86a	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	high	20.00	Current accuracy is 20% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-27 10:12:28.578957+00	2026-08-27 10:12:28.578957+00	2026-08-28 06:08:29.878+00
a7ee02ca-c8f9-47b7-93d0-08650a67c14f	97ad6c7c-6f13-4266-8241-a72deab8f86a	68d8f6be-90c5-4893-84f0-afe6b5270631	high	22.22	Current accuracy is 22% across 9 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-27 10:12:28.578957+00	2026-08-27 10:12:28.578957+00	2026-08-28 06:08:29.878+00
891c0df7-b7bb-4c66-abef-c3d5a1a52f26	97ad6c7c-6f13-4266-8241-a72deab8f86a	6985fef8-92cf-47a8-aad8-88754030af2c	high	30.00	Current accuracy is 30% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-27 10:12:28.578957+00	2026-08-27 10:12:28.578957+00	2026-08-28 06:08:29.878+00
2e03cde4-a554-4ce7-bc2b-7b6c0b73f183	97ad6c7c-6f13-4266-8241-a72deab8f86a	965b5429-8685-4cc9-a7be-42858adcd165	high	40.00	Current accuracy is 40% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-27 10:12:28.578957+00	2026-08-27 10:12:28.578957+00	2026-08-28 06:08:29.878+00
431f71f6-2a10-49a2-bf85-898450f471c4	97ad6c7c-6f13-4266-8241-a72deab8f86a	965b5429-8685-4cc9-a7be-42858adcd165	high	40.00	Current accuracy is 40% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	completed	2026-08-28 06:07:25.080974+00	2026-08-28 06:07:25.080974+00	2026-08-28 10:50:10.891+00
9b49d8c5-8d8f-4ca3-bc56-50f0ca71e6e1	97ad6c7c-6f13-4266-8241-a72deab8f86a	6985fef8-92cf-47a8-aad8-88754030af2c	high	30.00	Current accuracy is 30% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	completed	2026-08-28 06:07:25.080974+00	2026-08-28 06:07:25.080974+00	2026-08-28 10:50:13.772+00
829393b1-9868-4d9e-9fd3-845d5f0b15bd	97ad6c7c-6f13-4266-8241-a72deab8f86a	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	high	10.00	Current accuracy is 10% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-28 06:07:25.080974+00	2026-08-28 06:07:25.080974+00	2026-08-28 11:25:21.369+00
df212dba-060e-4740-bbe1-77e2ebc830b0	97ad6c7c-6f13-4266-8241-a72deab8f86a	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	high	20.00	Current accuracy is 20% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-28 06:07:25.080974+00	2026-08-28 06:07:25.080974+00	2026-08-28 11:25:21.369+00
2deaa849-1e71-43d4-8d8c-06ecb59cc708	97ad6c7c-6f13-4266-8241-a72deab8f86a	68d8f6be-90c5-4893-84f0-afe6b5270631	high	22.22	Current accuracy is 22% across 9 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	dismissed	2026-08-28 06:07:25.080974+00	2026-08-28 06:07:25.080974+00	2026-08-28 11:25:21.369+00
45b1d91c-a3c0-45c9-b62d-1fd16bb56125	97ad6c7c-6f13-4266-8241-a72deab8f86a	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	high	10.00	Your current accuracy in Algebra is 10%.	Complete focused concept review and 25 practice questions.	25	dismissed	2026-08-28 11:24:16.331838+00	2026-08-28 11:24:16.331838+00	2026-08-28 11:25:23.366+00
914de3fe-1549-43d4-b554-e146faafd5af	97ad6c7c-6f13-4266-8241-a72deab8f86a	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	medium	20.00	Your current accuracy in Trigonometry is 20%.	Complete focused concept review and 25 practice questions.	25	dismissed	2026-08-28 11:24:16.331838+00	2026-08-28 11:24:16.331838+00	2026-08-28 11:25:23.366+00
e222880f-75b5-4a54-9f7f-dcfbe9e7441d	97ad6c7c-6f13-4266-8241-a72deab8f86a	68d8f6be-90c5-4893-84f0-afe6b5270631	medium	22.22	Your current accuracy in Calculus is 22%.	Complete focused concept review and 25 practice questions.	25	dismissed	2026-08-28 11:24:16.331838+00	2026-08-28 11:24:16.331838+00	2026-08-28 11:25:23.366+00
71cd2142-f135-4af2-9e63-8ac2c2d650e8	97ad6c7c-6f13-4266-8241-a72deab8f86a	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	high	10.00	Your current accuracy in Algebra is 10%.	Complete focused concept review and 25 practice questions.	25	dismissed	2026-08-28 11:24:18.34+00	2026-08-28 11:24:18.34+00	2026-08-28 11:25:25.097+00
7508caed-e29b-414f-bb92-99bce0c97f37	97ad6c7c-6f13-4266-8241-a72deab8f86a	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	medium	20.00	Your current accuracy in Trigonometry is 20%.	Complete focused concept review and 25 practice questions.	25	dismissed	2026-08-28 11:24:18.34+00	2026-08-28 11:24:18.34+00	2026-08-28 11:25:25.097+00
c2e6eec6-f585-4366-a87c-b55aed601673	97ad6c7c-6f13-4266-8241-a72deab8f86a	68d8f6be-90c5-4893-84f0-afe6b5270631	medium	22.22	Your current accuracy in Calculus is 22%.	Complete focused concept review and 25 practice questions.	25	dismissed	2026-08-28 11:24:18.34+00	2026-08-28 11:24:18.34+00	2026-08-28 11:25:25.097+00
758718e7-d33c-4ee0-b3eb-f5ae2f3cdd52	97ad6c7c-6f13-4266-8241-a72deab8f86a	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	high	10.00	Your current accuracy in Algebra is 10%.	Complete focused concept review and 25 practice questions.	25	dismissed	2026-08-28 11:24:20.055232+00	2026-08-28 11:24:20.055232+00	2026-09-02 06:28:29.518+00
5b6fdc9f-c483-4790-9c51-32d51f10f992	97ad6c7c-6f13-4266-8241-a72deab8f86a	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	medium	20.00	Your current accuracy in Trigonometry is 20%.	Complete focused concept review and 25 practice questions.	25	dismissed	2026-08-28 11:24:20.055232+00	2026-08-28 11:24:20.055232+00	2026-09-02 06:28:29.518+00
6126d61b-e767-4570-8c64-55ccc27d0252	97ad6c7c-6f13-4266-8241-a72deab8f86a	68d8f6be-90c5-4893-84f0-afe6b5270631	medium	22.22	Your current accuracy in Calculus is 22%.	Complete focused concept review and 25 practice questions.	25	dismissed	2026-08-28 11:24:20.055232+00	2026-08-28 11:24:20.055232+00	2026-09-02 06:28:29.518+00
bbe75b86-1d64-4058-a231-f96e831301dc	97ad6c7c-6f13-4266-8241-a72deab8f86a	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	high	20.00	Current accuracy is 20% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	active	2026-09-02 06:27:15.695877+00	2026-09-02 06:27:15.695877+00	2026-09-02 06:27:15.695877+00
a2717886-fadd-49e3-8d20-8452d68eeec2	97ad6c7c-6f13-4266-8241-a72deab8f86a	68d8f6be-90c5-4893-84f0-afe6b5270631	high	22.22	Current accuracy is 22% across 9 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	active	2026-09-02 06:27:15.695877+00	2026-09-02 06:27:15.695877+00	2026-09-02 06:27:15.695877+00
4c995983-5216-45f7-baf1-f41a42f83c76	97ad6c7c-6f13-4266-8241-a72deab8f86a	6985fef8-92cf-47a8-aad8-88754030af2c	high	30.00	Current accuracy is 30% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	active	2026-09-02 06:27:15.695877+00	2026-09-02 06:27:15.695877+00	2026-09-02 06:27:15.695877+00
fceabcaa-6417-460f-9c11-8046be43c7d8	97ad6c7c-6f13-4266-8241-a72deab8f86a	965b5429-8685-4cc9-a7be-42858adcd165	high	40.00	Current accuracy is 40% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	active	2026-09-02 06:27:15.695877+00	2026-09-02 06:27:15.695877+00	2026-09-02 06:27:15.695877+00
ff13584c-270d-45ae-9017-5ee5d7d0d37c	97ad6c7c-6f13-4266-8241-a72deab8f86a	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	high	10.00	Current accuracy is 10% across 10 attempted question(s).	Review core concepts, study recent mistakes, then complete targeted practice.	25	completed	2026-09-02 06:27:15.695877+00	2026-09-02 06:27:15.695877+00	2026-09-02 06:28:45.041+00
\.


--
-- TOC entry 5080 (class 0 OID 18126)
-- Dependencies: 368
-- Data for Name: revision_plan_tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.revision_plan_tasks (id, plan_id, topic_id, scheduled_date, day_number, activity, target_questions, status, completed_at, updated_at) FROM stdin;
3f7eaa44-ebba-412d-b7ba-541f569ac34d	30cad95f-4c65-4faf-a4c8-47cb7b721e85	\N	2026-08-25	1	Review concepts and solve practice questions	15	pending	\N	2026-08-25 14:06:08.757049+00
7ef2c85b-dfed-4f6e-8acc-275407fc9ea4	30cad95f-4c65-4faf-a4c8-47cb7b721e85	\N	2026-08-26	2	Review concepts and solve practice questions	15	pending	\N	2026-08-25 14:06:08.757049+00
5e45de23-5d1e-4f0a-b5e8-4cc81b8c5f40	30cad95f-4c65-4faf-a4c8-47cb7b721e85	\N	2026-08-27	3	Review concepts and solve practice questions	15	pending	\N	2026-08-25 14:06:08.757049+00
e18f63ec-8942-419f-9d6c-e79775497c7e	30cad95f-4c65-4faf-a4c8-47cb7b721e85	\N	2026-08-28	4	Review concepts and solve practice questions	15	pending	\N	2026-08-25 14:06:08.757049+00
97fce331-2092-4915-8c4d-ab3ccbb83647	30cad95f-4c65-4faf-a4c8-47cb7b721e85	\N	2026-08-29	5	Review concepts and solve practice questions	15	pending	\N	2026-08-25 14:06:08.757049+00
32fdac6f-a3b4-4f81-818c-8c29d6e4072d	30cad95f-4c65-4faf-a4c8-47cb7b721e85	\N	2026-08-30	6	Review concepts and solve practice questions	15	pending	\N	2026-08-25 14:06:08.757049+00
aeddbfb7-fbbc-4812-a371-d1be345d111a	30cad95f-4c65-4faf-a4c8-47cb7b721e85	\N	2026-08-31	7	Attempt a full mock quiz	15	pending	\N	2026-08-25 14:06:08.757049+00
c64c307f-fa3f-4ce9-a3d5-800adf0cfbf9	fa144527-fb67-44e1-b2c2-3fd5b6ddae25	\N	2026-08-27	1	Review concepts and solve 15 practice questions	15	pending	\N	2026-08-27 09:25:43.018705+00
b58b28e7-3e3e-4fcf-be59-88ad43a79c1e	fa144527-fb67-44e1-b2c2-3fd5b6ddae25	\N	2026-08-28	2	Review concepts and solve 15 practice questions	15	pending	\N	2026-08-27 09:25:43.018705+00
aa920cbe-a6c2-45e7-b466-b62b2eb2112a	fa144527-fb67-44e1-b2c2-3fd5b6ddae25	\N	2026-08-29	3	Review concepts and solve 15 practice questions	15	pending	\N	2026-08-27 09:25:43.018705+00
7acd9f5e-3e91-418f-90c3-6dc0c5209f59	fa144527-fb67-44e1-b2c2-3fd5b6ddae25	\N	2026-08-30	4	Review concepts and solve 15 practice questions	15	pending	\N	2026-08-27 09:25:43.018705+00
baadadd2-d3c9-43ee-83f1-bca4d50db13d	fa144527-fb67-44e1-b2c2-3fd5b6ddae25	\N	2026-08-31	5	Review concepts and solve 15 practice questions	15	pending	\N	2026-08-27 09:25:43.018705+00
e43213bc-b4dc-45bf-849f-981a5eb32169	fa144527-fb67-44e1-b2c2-3fd5b6ddae25	\N	2026-09-01	6	Review concepts and solve 15 practice questions	15	pending	\N	2026-08-27 09:25:43.018705+00
f3610950-b5b1-4ba8-9737-dfbcbe09e76e	fa144527-fb67-44e1-b2c2-3fd5b6ddae25	\N	2026-09-02	7	Review concepts and solve 15 practice questions	15	pending	\N	2026-08-27 09:25:43.018705+00
95b0d3ed-675f-46d7-a2d2-7ecf7e9df14c	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	2026-08-28	1	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-08-28 06:07:59.014945+00
3ef89a89-0c7c-450b-adc4-26e19ab634d5	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	2026-08-29	2	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-08-28 06:07:59.014945+00
6fa952e2-d81f-402d-8f35-5dd6e23580da	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	68d8f6be-90c5-4893-84f0-afe6b5270631	2026-08-30	3	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-08-28 06:07:59.014945+00
d845917b-c69b-48e1-a48a-e91818476ba3	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	6985fef8-92cf-47a8-aad8-88754030af2c	2026-08-31	4	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-08-28 06:07:59.014945+00
a9a83c50-134e-4cc8-9f02-5f4750c6fcaa	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	965b5429-8685-4cc9-a7be-42858adcd165	2026-09-01	5	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-08-28 06:07:59.014945+00
a73bacd0-e2fc-4538-b1bf-8abb8e9a5ddc	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	2026-09-02	6	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-08-28 06:07:59.014945+00
0c649ba6-dbf5-45de-afa7-9ee319bbc45f	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	2026-09-03	7	Attempt a timed mixed mock test and review mistakes	25	pending	\N	2026-08-28 06:07:59.014945+00
f17e4316-c7c2-4d2f-a53f-c2041fae0861	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	2026-09-04	8	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-08-28 06:07:59.014945+00
f530803b-6232-470f-8b46-96235a40fce4	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	2026-09-05	9	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-08-28 06:07:59.014945+00
ed7ae0eb-d0a1-41fb-b9b8-d2a54ab5b9c2	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	68d8f6be-90c5-4893-84f0-afe6b5270631	2026-09-06	10	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-08-28 06:07:59.014945+00
02b4f2da-7e8e-4a50-8170-8cd2f7e1fe65	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	6985fef8-92cf-47a8-aad8-88754030af2c	2026-09-07	11	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-08-28 06:07:59.014945+00
c09e651e-1507-42dd-b5d7-c80ab2faa4ec	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	965b5429-8685-4cc9-a7be-42858adcd165	2026-09-08	12	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-08-28 06:07:59.014945+00
7a14b9d9-a3c9-41c5-8260-a21ff1c4365a	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	2026-09-09	13	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-08-28 06:07:59.014945+00
a1bd54e4-5e57-422a-9b01-235fb68fe86f	42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	2026-09-10	14	Attempt a timed mixed mock test and review mistakes	25	pending	\N	2026-08-28 06:07:59.014945+00
7c925d24-0d7d-43a6-bfd3-233e9655913d	44be5086-16c7-47f9-8c33-80da26371cb3	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	2026-09-02	1	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-09-02 06:27:59.446087+00
4139b5cb-c050-45bf-9e0a-8a9c33b70f1e	44be5086-16c7-47f9-8c33-80da26371cb3	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	2026-09-03	2	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-09-02 06:27:59.446087+00
8089f3d1-4983-410d-854b-c6f7130de736	44be5086-16c7-47f9-8c33-80da26371cb3	68d8f6be-90c5-4893-84f0-afe6b5270631	2026-09-04	3	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-09-02 06:27:59.446087+00
a8b90c87-41ec-47cc-b20d-54e0e7d4ffb2	44be5086-16c7-47f9-8c33-80da26371cb3	6985fef8-92cf-47a8-aad8-88754030af2c	2026-09-05	4	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-09-02 06:27:59.446087+00
68bc7358-54db-42dd-adec-f1a5747ce2e4	44be5086-16c7-47f9-8c33-80da26371cb3	965b5429-8685-4cc9-a7be-42858adcd165	2026-09-06	5	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-09-02 06:27:59.446087+00
43bed7da-5095-40f9-9b11-210332ef560d	44be5086-16c7-47f9-8c33-80da26371cb3	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	2026-09-07	6	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-09-02 06:27:59.446087+00
5996b49f-76f2-4824-b754-97d8084ee338	44be5086-16c7-47f9-8c33-80da26371cb3	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	2026-09-08	7	Attempt a timed mixed mock test and review mistakes	25	pending	\N	2026-09-02 06:27:59.446087+00
56651b4d-7a2a-49d9-8d43-9270c6ae76e8	f233dd94-fa1c-4210-9cab-364cb266723f	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	2026-09-02	1	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-09-02 06:28:00.548786+00
e702493a-2e08-48e6-a285-10cbb4480cec	f233dd94-fa1c-4210-9cab-364cb266723f	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	2026-09-03	2	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-09-02 06:28:00.548786+00
169c080b-6690-424f-9b21-192b48e7a784	f233dd94-fa1c-4210-9cab-364cb266723f	68d8f6be-90c5-4893-84f0-afe6b5270631	2026-09-04	3	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-09-02 06:28:00.548786+00
0ccac2b9-8274-44de-adda-0af6317202a8	f233dd94-fa1c-4210-9cab-364cb266723f	6985fef8-92cf-47a8-aad8-88754030af2c	2026-09-05	4	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-09-02 06:28:00.548786+00
870b0e1e-b19e-47f1-9987-47c0ab402d5d	f233dd94-fa1c-4210-9cab-364cb266723f	965b5429-8685-4cc9-a7be-42858adcd165	2026-09-06	5	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-09-02 06:28:00.548786+00
f6a6d63c-9789-43dd-a0fa-76a62bb0f28b	f233dd94-fa1c-4210-9cab-364cb266723f	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	2026-09-07	6	Relearn core concepts, make short notes, then solve 20-25 questions	25	pending	\N	2026-09-02 06:28:00.548786+00
96de0025-f560-4e9c-b51f-578e3f0510e0	f233dd94-fa1c-4210-9cab-364cb266723f	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	2026-09-08	7	Attempt a timed mixed mock test and review mistakes	25	pending	\N	2026-09-02 06:28:00.548786+00
\.


--
-- TOC entry 5079 (class 0 OID 18107)
-- Dependencies: 367
-- Data for Name: revision_plans; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.revision_plans (id, user_id, duration_days, starts_on, status, created_at, updated_at) FROM stdin;
30cad95f-4c65-4faf-a4c8-47cb7b721e85	97ad6c7c-6f13-4266-8241-a72deab8f86a	7	2026-08-25	archived	2026-08-25 14:06:08.70996+00	2026-08-27 09:26:46.593+00
fa144527-fb67-44e1-b2c2-3fd5b6ddae25	97ad6c7c-6f13-4266-8241-a72deab8f86a	7	2026-08-27	archived	2026-08-27 09:25:42.965875+00	2026-08-28 06:09:03.757+00
42ae333a-dd1e-4bfa-8cfe-cbd5e6e082b9	97ad6c7c-6f13-4266-8241-a72deab8f86a	14	2026-08-28	archived	2026-08-28 06:07:58.957307+00	2026-09-02 06:29:13.215+00
44be5086-16c7-47f9-8c33-80da26371cb3	97ad6c7c-6f13-4266-8241-a72deab8f86a	7	2026-09-02	archived	2026-09-02 06:27:59.390616+00	2026-09-02 06:29:14.243+00
f233dd94-fa1c-4210-9cab-364cb266723f	97ad6c7c-6f13-4266-8241-a72deab8f86a	7	2026-09-02	active	2026-09-02 06:28:00.451675+00	2026-09-02 06:28:00.451675+00
\.


--
-- TOC entry 5068 (class 0 OID 17619)
-- Dependencies: 356
-- Data for Name: student_answers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.student_answers (id, attempt_id, question_id, selected_answer, is_correct, marks_awarded, time_taken_seconds, marked_for_review, visited, updated_at, display_order, option_order, question_snapshot) FROM stdin;
ef4846e7-5e1a-4e92-8889-8d4ae6d8527f	a29c21a4-bc82-48ec-94b0-df54043547dd	789a38fa-ce25-4d90-839f-c170affba96e	\N	f	0.00	0	f	f	2026-08-18 08:05:50.603+00	1	[0, 1, 2, 3]	\N
4b8b2701-1581-49a7-bd31-7d8e259f3805	a29c21a4-bc82-48ec-94b0-df54043547dd	46728b85-c7f3-4a57-af0a-58b32be35bbe	\N	f	0.00	0	f	f	2026-08-18 08:05:50.603+00	2	[0, 1, 2, 3]	\N
6d211607-5791-40c3-aeda-f197560f0fa6	a29c21a4-bc82-48ec-94b0-df54043547dd	c5de0b80-e33b-467b-8ee5-77a7c3a74b3d	\N	f	0.00	0	f	f	2026-08-18 08:05:50.603+00	3	[0, 1, 2, 3]	\N
b153e27c-3113-48a7-99ea-9ed344b5b0bc	a29c21a4-bc82-48ec-94b0-df54043547dd	1dad4c69-7d98-4807-b2a5-9852492eba87	\N	f	0.00	0	f	f	2026-08-18 08:05:50.603+00	4	[0, 1, 2, 3]	\N
c8c16851-b476-43cc-b70c-45557b24ea99	a29c21a4-bc82-48ec-94b0-df54043547dd	32c7fed8-9b85-4aba-a1c0-0cc9d95daaf0	\N	f	0.00	0	f	f	2026-08-18 08:05:50.603+00	5	[0, 1, 2, 3]	\N
f6671586-7467-4c16-8ef9-bdeb8d0ff433	3855de6d-d91b-4e3f-add6-db0b41d18e7f	789a38fa-ce25-4d90-839f-c170affba96e	\N	f	0.00	0	f	f	2026-08-18 08:05:50.647+00	1	[0, 1, 2, 3]	\N
4017ec5f-0df4-4869-be4a-bcae6fae19be	3855de6d-d91b-4e3f-add6-db0b41d18e7f	46728b85-c7f3-4a57-af0a-58b32be35bbe	\N	f	0.00	0	f	f	2026-08-18 08:05:50.647+00	2	[0, 1, 2, 3]	\N
72842976-ff1c-45e0-a379-7a148675169d	3855de6d-d91b-4e3f-add6-db0b41d18e7f	c5de0b80-e33b-467b-8ee5-77a7c3a74b3d	\N	f	0.00	0	f	f	2026-08-18 08:05:50.647+00	3	[0, 1, 2, 3]	\N
865223b5-75b9-428f-83e4-59f552c1aff3	3855de6d-d91b-4e3f-add6-db0b41d18e7f	1dad4c69-7d98-4807-b2a5-9852492eba87	\N	f	0.00	0	f	f	2026-08-18 08:05:50.647+00	4	[0, 1, 2, 3]	\N
02510613-c4cc-42f7-be66-4ff900f67b35	3855de6d-d91b-4e3f-add6-db0b41d18e7f	32c7fed8-9b85-4aba-a1c0-0cc9d95daaf0	\N	f	0.00	0	f	f	2026-08-18 08:05:50.647+00	5	[0, 1, 2, 3]	\N
a67d4dff-a2dc-4296-bdd8-699b194d2d51	67c25cd4-5f62-4314-a262-be0aa48eba67	85128d8a-671f-4772-8378-483b00dd4d72	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	1	[2, 3, 1, 0]	{"id": "85128d8a-671f-4772-8378-483b00dd4d72", "marks": 1, "options": ["Lower momentum", "Higher momentum", "Zero momentum", "Unchanged momentum"], "topic_id": "069e7811-b04d-43d6-b0f0-aed1011ac338", "difficulty": "hard", "explanation": "Photon momentum is inversely proportional to wavelength", "option_images": null, "question_text": "A smaller wavelength corresponds to what photon momentum?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
8fdaab00-a5ec-463b-aa9c-bc3a6613fe54	d6e3620b-8354-4d82-a5c8-978811ed5728	fd6126a1-33a0-418c-9845-717b18ac5614	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	23	[0, 2, 1, 3]	\N
71ec0264-946d-43a1-ac37-92d89e4edcf6	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	b1704bf5-d1dd-449d-9b3b-02f150f49196	2	f	0.00	2	f	t	2026-08-27 09:30:49.073+00	2	[0, 3, 2, 1]	{"id": "b1704bf5-d1dd-449d-9b3b-02f150f49196", "marks": 1, "options": ["(x - 25)(x + 1)", "(x - 5)(x + 5)", "(x - 5)^2", "(x + 25)(x - 1)"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "easy", "explanation": "This is a difference of squares", "option_images": null, "question_text": "Which expression factors x^2 - 25?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
c7e958d7-76de-44f4-9618-4f6de24b2506	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	686147bb-ee54-4ce4-99b2-903d80e977df	1	f	0.00	3	f	t	2026-08-27 09:30:49.123+00	3	[1, 3, 0, 2]	{"id": "686147bb-ee54-4ce4-99b2-903d80e977df", "marks": 1, "options": ["0", "1", "1/2", "-1"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "easy", "explanation": "cos 0 degrees equals 1", "option_images": null, "question_text": "What is cos 0 degrees?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
93709d48-8782-48ab-a259-39d8988ea3a8	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	d04ce9b1-15b1-4bb1-8753-e5dffd8bc3e2	1	t	1.00	1	f	t	2026-08-27 09:30:49.18+00	4	[0, 3, 1, 2]	{"id": "d04ce9b1-15b1-4bb1-8753-e5dffd8bc3e2", "marks": 1, "options": ["4", "5", "12", "6"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "medium", "explanation": "Area = 1/2 x base x height", "option_images": null, "question_text": "What is the area of the triangle with vertices (0, 0), (4, 0), and (0, 3)?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
0ebf54e5-f27a-494b-94c3-e930d18b3f27	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	ed939a01-c9c4-42f6-bd6b-066eaff591ef	1	f	0.00	4	f	t	2026-08-27 09:30:49.233+00	5	[1, 0, 3, 2]	{"id": "ed939a01-c9c4-42f6-bd6b-066eaff591ef", "marks": 1, "options": ["3", "4", "3.5", "4.5"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "hard", "explanation": "Average the outcomes 1 through 6", "option_images": null, "question_text": "What is the expected value of a fair six-sided die roll?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
67c5203d-3978-45b1-8d81-080b1350a4af	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	3b2c7c17-25d8-46f7-8ffe-07f122794112	2	f	0.00	1	f	t	2026-08-27 09:30:49.29+00	6	[0, 2, 3, 1]	{"id": "3b2c7c17-25d8-46f7-8ffe-07f122794112", "marks": 1, "options": ["5a - 2", "7a + 2", "7a - 2", "12a"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "easy", "explanation": "Combine like terms 3a and 4a first", "option_images": null, "question_text": "Simplify 3a + 4a - 2.", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
b989b135-789f-4bf4-83ee-eb8edf21b5b7	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	d9ecd9dd-aa5c-4457-90d4-b2e8d26661f7	1	t	1.00	2	f	t	2026-08-27 09:30:49.346+00	7	[0, 2, 1, 3]	{"id": "d9ecd9dd-aa5c-4457-90d4-b2e8d26661f7", "marks": 1, "options": ["0", "sqrt(2)", "1", "sqrt(3)"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "easy", "explanation": "At 45 degrees, sine and cosine are equal", "option_images": null, "question_text": "What is tan 45 degrees?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
eaba104a-894b-410b-9b0f-1a4b6dd0cbd0	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	2147f63d-ebff-4303-b492-aa1e53fd89a9	1	t	1.00	1	f	t	2026-08-27 09:30:49.4+00	8	[0, 1, 3, 2]	{"id": "2147f63d-ebff-4303-b492-aa1e53fd89a9", "marks": 1, "options": ["x^5 + C", "5x + C", "5 + C", "1 + C"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "easy", "explanation": "The integral of a constant k is kx + C", "option_images": null, "question_text": "What is the integral of 5 with respect to x?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
86be2a19-b118-4198-8379-3da4ffe45380	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	87e31772-f018-4825-9fa8-e80c79a3f7c2	2	f	0.00	2	f	t	2026-08-27 09:30:49.459+00	9	[2, 1, 0, 3]	{"id": "87e31772-f018-4825-9fa8-e80c79a3f7c2", "marks": 1, "options": ["4", "6", "5", "7"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "hard", "explanation": "Use the distance formula", "option_images": null, "question_text": "What is the distance from the point (3, 4) to the origin?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
a681f613-32b3-4e15-91ee-cb49c59cdb4b	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	171cbd6b-a9c4-4210-8f72-467cea0b80d9	1	f	0.00	2	f	t	2026-08-27 09:30:49.52+00	10	[1, 3, 0, 2]	{"id": "171cbd6b-a9c4-4210-8f72-467cea0b80d9", "marks": 1, "options": ["P(A) + P(B)", "P(A) - P(B)", "P(A)P(B)", "P(A)/P(B)"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "medium", "explanation": "Independent events multiply", "option_images": null, "question_text": "For independent events A and B, what is P(A and B)?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
2e8a6928-ba61-44e6-b8c8-31f2172b4516	67c25cd4-5f62-4314-a262-be0aa48eba67	e5c327c2-aec2-4e1a-86b5-8200bec1dcb7	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	2	[2, 1, 3, 0]	{"id": "e5c327c2-aec2-4e1a-86b5-8200bec1dcb7", "marks": 1, "options": ["It must stop", "It moves with constant velocity", "It speeds up uniformly", "It reverses direction"], "topic_id": "7b47c1c5-6ff8-411e-8f06-8a29719b6485", "difficulty": "hard", "explanation": "Zero net force means zero acceleration", "option_images": null, "question_text": "If the net force on a moving body is zero, how does it continue to move?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
6c090abd-b71d-41e9-b5cb-1585892be46e	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	d3b64a21-148e-48ef-86aa-ade2ce77951f	2	f	0.00	1	f	t	2026-08-27 09:30:49.638+00	12	[0, 2, 3, 1]	{"id": "d3b64a21-148e-48ef-86aa-ade2ce77951f", "marks": 1, "options": ["x^(x-1)", "x^x", "x^x(ln x + 1)", "ln x + 1"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "hard", "explanation": "Log differentiation gives x^x(ln x + 1)", "option_images": null, "question_text": "What is the derivative of x^x for x > 0?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
ef07d1e9-19a7-4446-9a5c-b7cf1cb95dda	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	cdbf324f-990e-4759-8715-01cf087eb2c0	1	f	0.00	2	f	t	2026-08-27 09:30:49.695+00	13	[0, 2, 1, 3]	{"id": "cdbf324f-990e-4759-8715-01cf087eb2c0", "marks": 1, "options": ["2", "3", "4", "5"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "easy", "explanation": "The vertical distance is 5 - 2", "option_images": null, "question_text": "What is the distance between (1, 2) and (1, 5)?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
539443e8-d582-4c00-96bc-7e9b6c2a00a3	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	669eddca-36e1-4eca-a191-a6de90cae4a9	0	t	1.00	1	f	t	2026-08-27 09:30:49.757+00	14	[1, 3, 2, 0]	{"id": "669eddca-36e1-4eca-a191-a6de90cae4a9", "marks": 1, "options": ["2x^2 + C", "x^2 + C", "x + C", "2 + C"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "medium", "explanation": "x^2 differentiates to 2x", "option_images": null, "question_text": "What is the integral of 2x with respect to x?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
8d5290c0-bb20-4e89-8eb9-93db23e90022	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	27a57025-3ef9-4c33-aa03-64b6b233ea8e	0	f	0.00	1	f	t	2026-08-27 09:30:49.808+00	15	[0, 2, 1, 3]	{"id": "27a57025-3ef9-4c33-aa03-64b6b233ea8e", "marks": 1, "options": ["x = 0", "x = y", "y = 0", "x + y = 0"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "easy", "explanation": "Points on the x-axis have y = 0", "option_images": null, "question_text": "Which equation represents the x-axis?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
f2aecb65-d8fd-457d-af0b-40a4dbcaeac1	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	218fb4c0-cf10-46d9-9b02-4ce16ed00229	1	t	1.00	1	f	t	2026-08-27 09:30:49.868+00	16	[3, 0, 2, 1]	{"id": "218fb4c0-cf10-46d9-9b02-4ce16ed00229", "marks": 1, "options": ["1/2", "0", "1/4", "1"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "easy", "explanation": "A fair coin has two equally likely outcomes", "option_images": null, "question_text": "What is the probability of getting heads on a fair coin toss?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
403db46d-1125-4d96-aa70-8ddb9e55ce5d	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	fab38afd-5f36-4bf8-8631-eb807028b069	2	f	0.00	2	f	t	2026-08-27 09:30:49.919+00	17	[3, 2, 1, 0]	{"id": "fab38afd-5f36-4bf8-8631-eb807028b069", "marks": 1, "options": ["3", "1", "2", "4"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "hard", "explanation": "A rectangle of height 1 and width 3 has area 3", "option_images": null, "question_text": "What is the area under y = 1 from x = 0 to x = 3?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
1b4251ed-190d-4a13-838f-14732027c2a5	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	48ff2f62-05d2-4cec-bb51-e5396bfbe13f	3	f	0.00	2	f	t	2026-08-27 09:30:49.974+00	18	[3, 2, 1, 0]	{"id": "48ff2f62-05d2-4cec-bb51-e5396bfbe13f", "marks": 1, "options": ["0", "n", "1", "Depends on the event"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "easy", "explanation": "All outcomes in a complete sample space total 1", "option_images": null, "question_text": "What is the sum of probabilities of all outcomes in a sample space?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
598a8f87-2b6e-4476-80a2-d4e4802731de	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	7a39e6f7-1122-48a5-a69e-21c07a7627ce	2	f	0.00	1	f	t	2026-08-27 09:30:50.026+00	19	[3, 0, 2, 1]	{"id": "7a39e6f7-1122-48a5-a69e-21c07a7627ce", "marks": 1, "options": ["x^2 + 9", "x^2 + 6x + 9", "x^2 + 3x + 9", "x^2 + 6x + 3"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": "Use (a + b)^2 = a^2 + 2ab + b^2", "option_images": null, "question_text": "Expand (x + 3)^2.", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
cf2a607f-6ece-4227-b11d-905513bac224	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	56f4b9ca-bc07-4d25-8ae6-4b84497a831b	1	t	1.00	1	f	t	2026-08-27 09:30:50.084+00	20	[3, 2, 0, 1]	{"id": "56f4b9ca-bc07-4d25-8ae6-4b84497a831b", "marks": 1, "options": ["15", "21", "23", "25"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "hard", "explanation": "Square the expression and subtract 2", "option_images": null, "question_text": "If x + 1/x = 5, what is x^2 + 1/x^2?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
cc174095-2580-40de-bc96-a3a0c61f671c	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	612e0882-184e-477d-9b07-68aebaf8f9db	0	f	0.00	2	f	t	2026-08-27 09:30:50.14+00	21	[3, 1, 0, 2]	{"id": "612e0882-184e-477d-9b07-68aebaf8f9db", "marks": 1, "options": ["1", "2", "3", "4"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "easy", "explanation": "In y = mx + c, the slope is m", "option_images": null, "question_text": "What is the slope of the line y = 3x + 1?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
0dfd05ef-3cc9-4834-ad26-c85ab182d274	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	7710b2c7-58fa-4e86-bc48-f5f1da3e3da5	0	f	0.00	2	f	t	2026-08-27 09:30:50.2+00	22	[0, 1, 3, 2]	{"id": "7710b2c7-58fa-4e86-bc48-f5f1da3e3da5", "marks": 1, "options": ["sin x + cos x = 1", "tan x = sin x cos x", "sec x = sin x", "sin^2 x + cos^2 x = 1"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "medium", "explanation": "This is the Pythagorean identity", "option_images": null, "question_text": "Which identity is always true?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
56348c63-d5c8-479d-8e22-2c657f3e4767	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	c5386a27-4225-433e-8a5c-152ed1a59b20	1	f	0.00	1	f	t	2026-08-27 09:30:50.251+00	23	[2, 3, 1, 0]	{"id": "c5386a27-4225-433e-8a5c-152ed1a59b20", "marks": 1, "options": ["y - 2 = 3(x - 1)", "y + 2 = 3(x - 1)", "y - 1 = 2(x - 3)", "y = 3x + 1"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "hard", "explanation": "Use point-slope form", "option_images": null, "question_text": "Which equation is the line through (1, 2) with slope 3?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
79fe3266-7fce-4393-8aa5-48fef4942ab9	67c25cd4-5f62-4314-a262-be0aa48eba67	d65b5a01-9245-43b3-97da-d52da023a630	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	3	[0, 3, 1, 2]	{"id": "d65b5a01-9245-43b3-97da-d52da023a630", "marks": 1, "options": ["Newton", "Joule", "Watt", "Pascal"], "topic_id": "7b47c1c5-6ff8-411e-8f06-8a29719b6485", "difficulty": "easy", "explanation": "Force is measured in newtons", "option_images": null, "question_text": "What is the SI unit of force?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
135bc509-0728-4368-9382-0ef6b6556b7f	d6e3620b-8354-4d82-a5c8-978811ed5728	0b07005f-2713-4ab0-9c58-8d48bedbe118	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	24	[2, 1, 3, 0]	\N
b9979bae-c8b5-4113-ba88-72b0c26d601d	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	8fe299d0-8f3f-409f-b623-19c369484421	2	f	0.00	1	f	t	2026-08-27 09:30:50.368+00	25	[3, 2, 1, 0]	{"id": "8fe299d0-8f3f-409f-b623-19c369484421", "marks": 1, "options": ["x = 6", "x = 4", "x = 5", "x = 7"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "easy", "explanation": "Subtract 5 and divide by 2 to get x = 6", "option_images": null, "question_text": "Solve 2x + 5 = 17.", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
9cf439d6-7170-4aee-a54c-5e5eaf09326c	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	a84366a8-692e-4ee7-98d4-5672b2aec7c8	2	t	1.00	1	f	t	2026-08-27 09:30:50.427+00	26	[0, 2, 1, 3]	{"id": "a84366a8-692e-4ee7-98d4-5672b2aec7c8", "marks": 1, "options": ["1/52", "1/13", "1/4", "4/13"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "medium", "explanation": "There are 4 aces in 52 cards", "option_images": null, "question_text": "What is the probability of drawing an ace from a standard 52-card deck?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
22cf70ec-aa1f-4266-8a2e-efe2c600aa1c	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	c54e6779-0457-4d47-a64a-0267aae99b0f	2	f	0.00	3	f	t	2026-08-27 09:30:50.479+00	27	[0, 3, 2, 1]	{"id": "c54e6779-0457-4d47-a64a-0267aae99b0f", "marks": 1, "options": ["(3, 5)", "(5, 7)", "(8, 12)", "(4, 6)"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "medium", "explanation": "Average the x-values and y-values", "option_images": null, "question_text": "What is the midpoint of (2, 4) and (6, 8)?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
45842ac7-4b9e-4412-88c1-cc9717bc83cb	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	a5f2c768-b4fb-4e20-b710-4c57ff9c5e12	3	f	0.00	1	f	t	2026-08-27 09:30:50.55+00	28	[2, 3, 0, 1]	{"id": "a5f2c768-b4fb-4e20-b710-4c57ff9c5e12", "marks": 1, "options": ["4/5", "5/3", "5/4", "3/5"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "medium", "explanation": "Use a 3-4-5 right triangle", "option_images": null, "question_text": "If tan theta = 3/4 and theta is acute, what is sin theta?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
eb8d95f9-78d6-470d-b6e0-fce02136a12c	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	60471398-431a-487a-a636-0685c3f03cb8	2	t	1.00	0	f	t	2026-08-27 09:30:50.601+00	29	[3, 0, 1, 2]	{"id": "60471398-431a-487a-a636-0685c3f03cb8", "marks": 1, "options": ["(0, 2)", "(2, 0)", "(4, 0)", "(0, 4)"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "hard", "explanation": "For y^2 = 4ax, the focus is (a, 0)", "option_images": null, "question_text": "For the parabola y^2 = 4ax with a = 2, what is the focus?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
cf062fde-d6a1-4ee2-97ff-cdb9a59da905	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	436d20d2-2e1f-42e2-b4cf-c06445eea5d4	2	f	0.00	1	f	t	2026-08-27 09:30:50.667+00	30	[0, 3, 2, 1]	{"id": "436d20d2-2e1f-42e2-b4cf-c06445eea5d4", "marks": 1, "options": ["4", "5", "8", "6"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": "Adding the equations gives 2x = 12", "option_images": null, "question_text": "If x + y = 10 and x - y = 2, what is x?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
98bb5360-512f-4972-b486-2529b0c41df9	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	3773211f-6a96-47c7-b6d5-7124ca15bd2a	3	f	0.00	1	f	t	2026-08-27 09:30:50.73+00	31	[3, 1, 2, 0]	{"id": "3773211f-6a96-47c7-b6d5-7124ca15bd2a", "marks": 1, "options": ["2", "3", "4", "5"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "hard", "explanation": "Because 81 = 3^4, x + 1 = 4", "option_images": null, "question_text": "If 3^(x + 1) = 81, what is x?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
99dec9b1-f068-44de-95de-121d09b4f252	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	cd593bb2-89b7-477f-a0ca-61725c1fb34f	2	t	1.00	1	f	t	2026-08-27 09:30:50.802+00	32	[0, 1, 3, 2]	{"id": "cd593bb2-89b7-477f-a0ca-61725c1fb34f", "marks": 1, "options": ["1/4", "1/2", "1", "3/4"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "medium", "explanation": "Use the complement of getting no heads", "option_images": null, "question_text": "What is the probability of getting at least one head when two fair coins are tossed?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
6bcf8a7a-0071-487a-8642-e648d7f3d1b2	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	4fdc905f-582a-4880-b97a-ab03f7a924dd	1	f	0.00	1	f	t	2026-08-27 09:30:50.883+00	33	[0, 2, 1, 3]	{"id": "4fdc905f-582a-4880-b97a-ab03f7a924dd", "marks": 1, "options": ["6", "1", "4", "5"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "hard", "explanation": "The two solutions are 1 and 6", "option_images": null, "question_text": "Solve |2x - 7| = 5. Which is the larger solution?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
b2a8b774-a6d1-4f9e-9aa0-0dfa3d29166c	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	288722fc-d2d7-4d5b-9190-3990f9a366c8	0	f	0.00	2	f	t	2026-08-27 09:30:50.992+00	34	[2, 1, 3, 0]	{"id": "288722fc-d2d7-4d5b-9190-3990f9a366c8", "marks": 1, "options": ["1/3", "1/6", "1/4", "1/5"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "easy", "explanation": "One favorable outcome out of six", "option_images": null, "question_text": "What is the probability of rolling a 6 on a fair die?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
ea9cd7e6-dab7-42a4-b9f5-443c17245e87	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	f525ad0a-65c3-4f8e-be97-3d65a44b80be	1	f	0.00	2	f	t	2026-08-27 09:30:51.092+00	35	[2, 3, 1, 0]	{"id": "f525ad0a-65c3-4f8e-be97-3d65a44b80be", "marks": 1, "options": ["5/9", "7/9", "8/9", "1/9"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "hard", "explanation": "Use cos 2theta = 1 - 2sin^2 theta", "option_images": null, "question_text": "If sin theta = 1/3 and theta is acute, what is cos 2theta?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
4ff8c206-025a-4f4b-b414-6e0f113d10ac	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	5393ef56-444a-407e-9f4f-063996681bdb	1	t	1.00	1	f	t	2026-08-27 09:30:51.167+00	36	[3, 2, 0, 1]	{"id": "5393ef56-444a-407e-9f4f-063996681bdb", "marks": 1, "options": ["-1", "1", "0", "2"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "medium", "explanation": "Both values are 1, so the difference is 0", "option_images": null, "question_text": "What is sin 90 degrees - cos 0 degrees?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
04f500c7-84d6-4350-bde9-24c041c60eed	67c25cd4-5f62-4314-a262-be0aa48eba67	f8fb3aa1-ab9b-4d54-8a64-ec7ffa0b23e9	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	4	[0, 1, 2, 3]	{"id": "f8fb3aa1-ab9b-4d54-8a64-ec7ffa0b23e9", "marks": 1, "options": ["Magnetic flux", "Heat", "Mechanical energy", "Electric charge"], "topic_id": "296873c1-7eae-4ac6-af30-4e90e6c975cb", "difficulty": "medium", "explanation": "Capacitors store separated charge", "option_images": null, "question_text": "A capacitor is primarily used to store what?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
f2899e5d-85d0-4466-bc1e-1b3a1fe5e639	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	59b39e86-2deb-4625-beef-09c39c0f54a6	1	f	0.00	1	f	t	2026-08-27 09:30:51.367+00	38	[3, 2, 0, 1]	{"id": "59b39e86-2deb-4625-beef-09c39c0f54a6", "marks": 1, "options": ["30 degrees", "15 degrees", "45 degrees", "60 degrees"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "hard", "explanation": "Then sin x = 1/2", "option_images": null, "question_text": "If 2 sin x = 1 and x is acute, what is x?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
39fabe51-1d6d-4b34-bea5-9199433ec0e7	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	9e68b749-d586-40fe-b64e-a2ab3b19516f	0	f	0.00	1	f	t	2026-08-27 09:30:51.457+00	39	[1, 0, 3, 2]	{"id": "9e68b749-d586-40fe-b64e-a2ab3b19516f", "marks": 1, "options": ["1/4", "3/4", "1", "1/2"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "medium", "explanation": "The favorable outcomes are HT and TH", "option_images": null, "question_text": "If two fair coins are tossed, what is the probability of getting exactly one head?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
7a457ccf-4234-432b-a96d-8c82de4b6730	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	0e1543db-2ba4-47fe-8da4-a71f466dd331	3	f	0.00	2	f	t	2026-08-27 09:30:51.554+00	40	[3, 0, 2, 1]	{"id": "0e1543db-2ba4-47fe-8da4-a71f466dd331", "marks": 1, "options": ["0", "1", "2", "3"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "medium", "explanation": "Factor the numerator and cancel x - 1", "option_images": null, "question_text": "Evaluate lim (x^2 - 1)/(x - 1) as x approaches 1.", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
d4cfe278-bd8e-4713-9b54-f3c0ab720445	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	da02328f-d889-4100-a1fd-250b5e9a9848	2	f	0.00	2	f	t	2026-08-27 09:30:51.642+00	41	[3, 2, 0, 1]	{"id": "da02328f-d889-4100-a1fd-250b5e9a9848", "marks": 1, "options": ["2/3", "3/2", "-2/3", "-3/2"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "medium", "explanation": "Rewrite in slope-intercept form", "option_images": null, "question_text": "What is the slope of the line 2x + 3y = 6?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
9666f734-10f8-43ad-885b-ef357f728a15	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	3a0136aa-5a28-41c8-8a9d-0ca85988d517	\N	f	0.00	1	f	t	2026-08-27 09:30:51.739+00	42	[3, 0, 1, 2]	{"id": "3a0136aa-5a28-41c8-8a9d-0ca85988d517", "marks": 1, "options": ["-sin x", "-cos x", "tan x", "cos x"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "medium", "explanation": "The derivative of sin x is cos x", "option_images": null, "question_text": "What is the derivative of sin x?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
eea446b3-e1a0-4862-826e-454705bf5c1e	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	887929bf-45c0-42f3-b88b-960c0ea69bc3	1	f	0.00	1	f	t	2026-08-27 09:30:51.801+00	43	[3, 1, 0, 2]	{"id": "887929bf-45c0-42f3-b88b-960c0ea69bc3", "marks": 1, "options": ["9", "10", "15", "11"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": "Substitute x = 5 into the function", "option_images": null, "question_text": "If f(x) = 3x - 4, what is f(5)?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
1ccacd02-b4f2-4a74-b88d-95c7a653b845	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	a6e11d00-ea90-4cb6-a2fd-88db3dc36f15	0	f	0.00	1	f	t	2026-08-27 09:30:51.859+00	44	[1, 3, 2, 0]	{"id": "a6e11d00-ea90-4cb6-a2fd-88db3dc36f15", "marks": 1, "options": ["1/2", "0", "sqrt(3)/2", "1"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "easy", "explanation": "sin 30 degrees equals one-half", "option_images": null, "question_text": "What is sin 30 degrees?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
d58d971f-32c9-4629-8d58-e8c4dd5595e3	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	e06db5ea-8a41-45dc-94c5-f6930c8fca2f	1	f	0.00	1	f	t	2026-08-27 09:30:51.913+00	45	[2, 3, 0, 1]	{"id": "e06db5ea-8a41-45dc-94c5-f6930c8fca2f", "marks": 1, "options": ["1 and 6", "3 and 5", "2 and 3", "2 and 6"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": "The quadratic factors as (x - 2)(x - 3)", "option_images": null, "question_text": "What are the roots of x^2 - 5x + 6 = 0?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
7713d1d9-24be-4c8e-a42a-4ef8a87172cc	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	ef60efdd-9823-4570-9219-34bc0d49300e	0	f	0.00	1	f	t	2026-08-27 09:30:51.974+00	46	[0, 1, 2, 3]	{"id": "ef60efdd-9823-4570-9219-34bc0d49300e", "marks": 1, "options": ["0", "1", "e", "ln 2"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "hard", "explanation": "The antiderivative is ln x, so ln e - ln 1 = 1", "option_images": null, "question_text": "Evaluate the integral from 1 to e of 1/x dx.", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
8da301dc-b645-4a27-b94b-a7d5385d1480	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	17a23a4e-e918-49f1-8d37-0bb6b17b0258	1	t	1.00	2	f	t	2026-08-27 09:30:52.025+00	47	[1, 0, 2, 3]	{"id": "17a23a4e-e918-49f1-8d37-0bb6b17b0258", "marks": 1, "options": ["1", "0", "2", "4"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "easy", "explanation": "Slope is rise over run = 2/2", "option_images": null, "question_text": "What is the slope of the line through (0, 0) and (2, 2)?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
e1f806ea-d876-4464-9e53-0e354a05a0e4	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	85f181e7-3e4c-49df-89d0-98d854126316	1	f	0.00	1	f	t	2026-08-27 09:30:52.091+00	48	[3, 1, 0, 2]	{"id": "85f181e7-3e4c-49df-89d0-98d854126316", "marks": 1, "options": ["(sqrt(6) - sqrt(2))/4", "sqrt(3)/2", "(sqrt(6) + sqrt(2))/4", "1/2"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "hard", "explanation": "Use the angle addition formula", "option_images": null, "question_text": "What is sin 75 degrees?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
96f2dca0-bb21-4e55-b2f3-63b402092cb2	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	7af86835-af29-4960-8e8b-8264de6842e1	2	t	1.00	0	f	t	2026-08-27 09:30:52.147+00	49	[2, 1, 0, 3]	{"id": "7af86835-af29-4960-8e8b-8264de6842e1", "marks": 1, "options": ["3/10", "1/5", "2/5", "3/5"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "hard", "explanation": "Multiply 3/5 by 2/4", "option_images": null, "question_text": "A bag has 3 red and 2 blue balls. Without replacement, what is the probability of drawing a red then a blue?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
9fe4bc1a-34f8-429e-86d9-34145dac6502	67c25cd4-5f62-4314-a262-be0aa48eba67	92ef8a0d-49e6-4799-a366-3981e5c20bb8	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	5	[0, 2, 1, 3]	{"id": "92ef8a0d-49e6-4799-a366-3981e5c20bb8", "marks": 1, "options": ["4.9 m/s^2", "8.0 m/s^2", "9.8 m/s^2", "12.0 m/s^2"], "topic_id": "7b47c1c5-6ff8-411e-8f06-8a29719b6485", "difficulty": "easy", "explanation": "The standard value is about 9.8 m/s^2", "option_images": null, "question_text": "What is the approximate acceleration due to gravity near Earth's surface?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
455632e7-033d-4e01-a775-0fa93180dab0	67c25cd4-5f62-4314-a262-be0aa48eba67	e4fd5293-83e9-45c7-9cec-3acac25b75a5	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	6	[2, 1, 0, 3]	{"id": "e4fd5293-83e9-45c7-9cec-3acac25b75a5", "marks": 1, "options": ["Zero", "Positive", "Negative", "Maximum"], "topic_id": "3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2", "difficulty": "hard", "explanation": "No heat is exchanged in an adiabatic process", "option_images": null, "question_text": "In an adiabatic process, the heat transfer Q is what?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
db368c8e-4e9e-40a0-be44-aa8749bd717c	67c25cd4-5f62-4314-a262-be0aa48eba67	a487aca5-21e4-4030-a124-c04934636b65	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	7	[2, 3, 0, 1]	{"id": "a487aca5-21e4-4030-a124-c04934636b65", "marks": 1, "options": ["Time for all nuclei to decay", "Time for one nucleus to form", "Time for temperature to double", "Time for half the nuclei to decay"], "topic_id": "069e7811-b04d-43d6-b0f0-aed1011ac338", "difficulty": "medium", "explanation": "Half-life is defined for a radioactive sample", "option_images": null, "question_text": "What is half-life?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
104de2ec-2422-439b-8fc9-f2650eca8ed5	67c25cd4-5f62-4314-a262-be0aa48eba67	bd24455f-64b9-4cda-be0a-a3714ea94872	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	8	[3, 0, 2, 1]	{"id": "bd24455f-64b9-4cda-be0a-a3714ea94872", "marks": 1, "options": ["Metre", "Dioptre", "Candela", "Tesla"], "topic_id": "689f8270-2092-401a-933d-5204f62002ce", "difficulty": "easy", "explanation": "Lens power is measured in dioptres", "option_images": null, "question_text": "What is the unit of lens power?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
2aaed1c4-2668-4a2a-b32c-cb91842e3f3c	67c25cd4-5f62-4314-a262-be0aa48eba67	462903f2-7cb5-483d-8d9e-f78ce48fbe58	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	9	[3, 2, 0, 1]	{"id": "462903f2-7cb5-483d-8d9e-f78ce48fbe58", "marks": 1, "options": ["Positive", "Neutral", "Negative", "Variable"], "topic_id": "296873c1-7eae-4ac6-af30-4e90e6c975cb", "difficulty": "easy", "explanation": "An electron carries negative elementary charge", "option_images": null, "question_text": "What is the charge on an electron?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
2996818f-2f7a-4dae-bed3-e7a5b11f64b0	67c25cd4-5f62-4314-a262-be0aa48eba67	0205247f-2114-4c4a-a09b-093dd76a7dd5	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	10	[2, 0, 3, 1]	{"id": "0205247f-2114-4c4a-a09b-093dd76a7dd5", "marks": 1, "options": ["Cold to hot", "Hot to cold", "Higher mass to lower mass", "Lower pressure to higher pressure"], "topic_id": "3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2", "difficulty": "easy", "explanation": "Heat flows from higher temperature to lower temperature", "option_images": null, "question_text": "Heat naturally flows from which body to which body?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
502e15bf-3329-4870-b88c-f9e48473afe6	67c25cd4-5f62-4314-a262-be0aa48eba67	ce1c8d3d-7885-4ac9-a80e-f7e6b33a17da	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	11	[0, 1, 2, 3]	{"id": "ce1c8d3d-7885-4ac9-a80e-f7e6b33a17da", "marks": 1, "options": ["Neutrons", "Protons", "Electrons in ions", "Nucleons"], "topic_id": "069e7811-b04d-43d6-b0f0-aed1011ac338", "difficulty": "medium", "explanation": "An element is defined by its atomic number", "option_images": null, "question_text": "Isotopes of an element have the same number of what?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
d5a7ab47-b74d-40a7-8a50-c5629a3e8d67	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	823eeddf-be0c-456a-97e1-91054ad0c850	0	f	0.00	7	f	t	2026-08-27 09:30:49.015+00	1	[0, 3, 2, 1]	{"id": "823eeddf-be0c-456a-97e1-91054ad0c850", "marks": 1, "options": ["ln x", "x", "e^x", "1/x"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "medium", "explanation": "For x > 0, d/dx(ln x) = 1/x", "option_images": null, "question_text": "What is the derivative of ln x?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
64ef3c81-ebb7-4b32-b4a9-777c4a3134c9	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	a67d367d-6064-439a-9820-1b559a314178	2	f	0.00	1	f	t	2026-08-27 09:30:49.574+00	11	[0, 3, 1, 2]	{"id": "a67d367d-6064-439a-9820-1b559a314178", "marks": 1, "options": ["2x", "x", "x^2", "2"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "easy", "explanation": "Apply the power rule", "option_images": null, "question_text": "What is the derivative of x^2?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
42777073-6911-49a5-a7fb-57a1cebe377a	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	c54271c9-5a92-4b96-bed6-53862f0a7fcc	2	f	0.00	1	f	t	2026-08-27 09:30:50.314+00	24	[3, 0, 2, 1]	{"id": "c54271c9-5a92-4b96-bed6-53862f0a7fcc", "marks": 1, "options": ["x^2 + y^2 = 3", "x^2 + y^2 = 9", "x^2 + y^2 = 6", "x + y = 9"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "medium", "explanation": "A circle centered at the origin has equation x^2 + y^2 = r^2", "option_images": null, "question_text": "Which equation is the circle centered at the origin with radius 3?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
35ef85bb-182f-48a4-bfff-7e522b13e6ba	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	47487c28-3d5e-44b6-a40e-c939fe00651b	0	f	0.00	3	f	t	2026-08-27 09:30:51.257+00	37	[3, 0, 2, 1]	{"id": "47487c28-3d5e-44b6-a40e-c939fe00651b", "marks": 1, "options": ["1/sin x", "1/cos x", "sin x/cos x", "cos x/sin x"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "medium", "explanation": "Secant is the reciprocal of cosine", "option_images": null, "question_text": "sec x is equal to which expression?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
40c21d94-0945-4c46-a525-c9b3f57a6a9d	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	16b2d359-e7ec-41cb-8da3-f96fc44109d8	2	f	0.00	3	f	t	2026-08-27 09:30:52.203+00	50	[3, 2, 0, 1]	{"id": "16b2d359-e7ec-41cb-8da3-f96fc44109d8", "marks": 1, "options": ["0.3", "0.8", "0.5", "1.1"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "hard", "explanation": "Add the probabilities and subtract the overlap", "option_images": null, "question_text": "If P(A) = 0.6 and P(B) = 0.5 and A and B are independent, what is P(A or B)?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
90331f7b-5162-4edc-9865-3fc143e91b3b	67c25cd4-5f62-4314-a262-be0aa48eba67	6e632619-65a5-481e-afb1-c035d75350d7	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	12	[1, 0, 2, 3]	{"id": "6e632619-65a5-481e-afb1-c035d75350d7", "marks": 1, "options": ["Diffraction only", "Reflection only", "Dispersion and internal reflection", "Interference only"], "topic_id": "689f8270-2092-401a-933d-5204f62002ce", "difficulty": "medium", "explanation": "Raindrops disperse and internally reflect light", "option_images": null, "question_text": "A rainbow is produced mainly due to what effects?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
7fb8502e-9c72-4fa4-8b53-c2090e3ac3cb	67c25cd4-5f62-4314-a262-be0aa48eba67	d10cacfe-73d9-468c-a6d3-c1b8c914f5b8	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	13	[1, 3, 2, 0]	{"id": "d10cacfe-73d9-468c-a6d3-c1b8c914f5b8", "marks": 1, "options": ["Random classical paths", "Spiral paths into the nucleus", "Square paths", "Quantized energy levels"], "topic_id": "069e7811-b04d-43d6-b0f0-aed1011ac338", "difficulty": "medium", "explanation": "Bohr introduced discrete allowed orbits", "option_images": null, "question_text": "In Bohr's model, electrons occupy what kind of orbits?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
6e14fd64-1ac8-465b-bfc5-6574be97f108	67c25cd4-5f62-4314-a262-be0aa48eba67	5c9687a5-c459-4b71-bf61-235b174cd6e6	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	14	[2, 3, 0, 1]	{"id": "5c9687a5-c459-4b71-bf61-235b174cd6e6", "marks": 1, "options": ["Pressure", "Volume", "Temperature", "Mass density"], "topic_id": "3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2", "difficulty": "medium", "explanation": "Isothermal means constant temperature", "option_images": null, "question_text": "What remains constant in an isothermal process?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
4c21eab0-9313-4d99-a222-2bfcc38c9a10	67c25cd4-5f62-4314-a262-be0aa48eba67	c9ca0210-d86c-4873-a395-e538de59e252	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	15	[3, 0, 1, 2]	{"id": "c9ca0210-d86c-4873-a395-e538de59e252", "marks": 1, "options": ["Angle of deviation", "Angle of refraction", "Angle of incidence", "Angle of polarization"], "topic_id": "689f8270-2092-401a-933d-5204f62002ce", "difficulty": "easy", "explanation": "The law of reflection makes these angles equal", "option_images": null, "question_text": "In reflection, the angle of reflection is equal to what?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
5fc95560-20fc-4dbc-80d9-f7478c0e6d08	67c25cd4-5f62-4314-a262-be0aa48eba67	3afa34ea-0f65-488a-908f-9c46e7c17e93	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	16	[3, 2, 0, 1]	{"id": "3afa34ea-0f65-488a-908f-9c46e7c17e93", "marks": 1, "options": ["5 m/s^2", "2 m/s^2", "8 m/s^2", "12 m/s^2"], "topic_id": "7b47c1c5-6ff8-411e-8f06-8a29719b6485", "difficulty": "hard", "explanation": "Use F = ma", "option_images": null, "question_text": "A 2 kg object experiences a net force of 10 N. What is its acceleration?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
defd0303-871d-4a4e-a369-6bd1d7923eba	67c25cd4-5f62-4314-a262-be0aa48eba67	08f1d2ab-2646-40cc-83ec-ad1eac478a60	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	17	[0, 2, 1, 3]	{"id": "08f1d2ab-2646-40cc-83ec-ad1eac478a60", "marks": 1, "options": ["mv", "mgh", "1/2 mv^2", "Fv"], "topic_id": "7b47c1c5-6ff8-411e-8f06-8a29719b6485", "difficulty": "medium", "explanation": "Kinetic energy depends on speed squared", "option_images": null, "question_text": "Which expression gives kinetic energy?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
109c6cf7-273e-43d2-bab3-7c4b78b57cec	67c25cd4-5f62-4314-a262-be0aa48eba67	16cf1a84-3ba3-4e26-80a1-9bf491cf37fd	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	18	[2, 1, 0, 3]	{"id": "16cf1a84-3ba3-4e26-80a1-9bf491cf37fd", "marks": 1, "options": ["Behind the retina", "On the retina", "On the cornea", "Before the retina"], "topic_id": "689f8270-2092-401a-933d-5204f62002ce", "difficulty": "medium", "explanation": "Short-sightedness forms the image before the retina", "option_images": null, "question_text": "In myopia, the image of distant objects forms where?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
73c72723-83c5-4653-8ea3-4f6bfdfe91a0	67c25cd4-5f62-4314-a262-be0aa48eba67	1d858725-4ed9-4c01-9703-892752fd7a3e	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	19	[2, 0, 3, 1]	{"id": "1d858725-4ed9-4c01-9703-892752fd7a3e", "marks": 1, "options": ["Straight radial lines", "Parabolas", "Concentric circles", "Ellipses"], "topic_id": "296873c1-7eae-4ac6-af30-4e90e6c975cb", "difficulty": "medium", "explanation": "The field wraps around the wire", "option_images": null, "question_text": "What shape are the magnetic field lines around a long straight current-carrying wire?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
7070639f-aaec-4912-ade8-32d5627366f6	67c25cd4-5f62-4314-a262-be0aa48eba67	c9c58182-e24f-4269-9cd3-c9e0d147ead3	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	20	[3, 2, 0, 1]	{"id": "c9c58182-e24f-4269-9cd3-c9e0d147ead3", "marks": 1, "options": ["Only working substance mass", "Only pressure", "Only volume", "Only reservoir temperatures"], "topic_id": "3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2", "difficulty": "medium", "explanation": "Carnot efficiency is determined by hot and cold reservoir temperatures", "option_images": null, "question_text": "The efficiency of an ideal Carnot engine depends on what?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
6c46f730-1a17-4c92-9878-7e6c780699b2	67c25cd4-5f62-4314-a262-be0aa48eba67	0d850214-41d2-4b5b-b427-a3167452a4cb	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	21	[3, 0, 1, 2]	{"id": "0d850214-41d2-4b5b-b427-a3167452a4cb", "marks": 1, "options": ["Pressure only", "Volume only", "Temperature only", "Number of moles only"], "topic_id": "3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2", "difficulty": "hard", "explanation": "Internal energy of an ideal gas is a function of temperature", "option_images": null, "question_text": "For an ideal gas, internal energy depends primarily on what?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
e17e0267-3356-4045-89a7-1f01f30fae92	67c25cd4-5f62-4314-a262-be0aa48eba67	bcd5fd60-8d57-439b-bb22-f95b261981d7	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	22	[0, 3, 2, 1]	{"id": "bcd5fd60-8d57-439b-bb22-f95b261981d7", "marks": 1, "options": ["Light has no energy", "Light behaves as particles", "Light travels only in solids", "Light has infinite speed"], "topic_id": "069e7811-b04d-43d6-b0f0-aed1011ac338", "difficulty": "easy", "explanation": "Photoelectric emission depends on photon energy", "option_images": null, "question_text": "The photoelectric effect supports which idea about light?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
8f488979-5787-49e1-9079-8d2705112f86	67c25cd4-5f62-4314-a262-be0aa48eba67	4e7e0733-c100-478b-84b2-9f14018129a9	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	23	[3, 1, 0, 2]	{"id": "4e7e0733-c100-478b-84b2-9f14018129a9", "marks": 1, "options": ["Along the tangent", "Away from the center", "Upward", "Toward the center"], "topic_id": "7b47c1c5-6ff8-411e-8f06-8a29719b6485", "difficulty": "medium", "explanation": "Centripetal acceleration points inward", "option_images": null, "question_text": "In uniform circular motion, the acceleration is directed where?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
6988b307-df40-45e7-9096-34e0b0c71902	67c25cd4-5f62-4314-a262-be0aa48eba67	697e2b46-acfc-42bf-abf3-74c4d6302b2d	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	24	[2, 3, 1, 0]	{"id": "697e2b46-acfc-42bf-abf3-74c4d6302b2d", "marks": 1, "options": ["Constant magnetic flux", "Changing magnetic flux", "Zero resistance", "Constant current only"], "topic_id": "296873c1-7eae-4ac6-af30-4e90e6c975cb", "difficulty": "hard", "explanation": "Faraday's law links induced emf to changing flux", "option_images": null, "question_text": "What produces an induced emf in a circuit?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
fe968047-e69a-439c-ab1f-6324456cffe9	67c25cd4-5f62-4314-a262-be0aa48eba67	40b3b1ec-d02d-4080-8afc-d5f1af5986f1	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	25	[2, 1, 0, 3]	{"id": "40b3b1ec-d02d-4080-8afc-d5f1af5986f1", "marks": 1, "options": ["Protons and neutrons", "Only electrons", "Only neutrons", "Photons and protons"], "topic_id": "069e7811-b04d-43d6-b0f0-aed1011ac338", "difficulty": "easy", "explanation": "The nucleus is made of protons and neutrons", "option_images": null, "question_text": "The atomic nucleus contains which particles?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
273f0193-7206-4a9f-9592-0d1402f62c0e	67c25cd4-5f62-4314-a262-be0aa48eba67	cdbfb31d-e1b4-4ab4-aa53-efc9ad2e191d	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	26	[1, 3, 2, 0]	{"id": "cdbfb31d-e1b4-4ab4-aa53-efc9ad2e191d", "marks": 1, "options": ["mass x velocity", "force x displacement along the force", "power x time squared", "pressure x volume"], "topic_id": "7b47c1c5-6ff8-411e-8f06-8a29719b6485", "difficulty": "medium", "explanation": "Work is the component of force times displacement", "option_images": null, "question_text": "Work done by a constant force equals what?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
75f7eb3b-da09-4531-85ac-f1806c64b8e7	67c25cd4-5f62-4314-a262-be0aa48eba67	49e0467f-8a1f-45a6-a637-65cc5d52188a	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	27	[2, 1, 3, 0]	{"id": "49e0467f-8a1f-45a6-a637-65cc5d52188a", "marks": 1, "options": ["Q = U - W", "Q = P/V", "Q = mc", "Q = U + W"], "topic_id": "3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2", "difficulty": "medium", "explanation": "With this sign convention, heat added equals internal energy change plus work done", "option_images": null, "question_text": "Which equation represents the first law of thermodynamics?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
82f1ad7c-fb33-4416-9a2a-7b6785f7ec39	67c25cd4-5f62-4314-a262-be0aa48eba67	3119f83e-5ffc-43e9-9676-6578a52e8f1a	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	28	[2, 0, 1, 3]	{"id": "3119f83e-5ffc-43e9-9676-6578a52e8f1a", "marks": 1, "options": ["Newton", "Bohr", "Einstein", "Planck"], "topic_id": "069e7811-b04d-43d6-b0f0-aed1011ac338", "difficulty": "easy", "explanation": "Mass-energy equivalence was formulated by Einstein", "option_images": null, "question_text": "Which scientist proposed E = mc^2?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
a7abc3fe-90fc-46d1-ae3f-87fb5ab3ad9c	67c25cd4-5f62-4314-a262-be0aa48eba67	9d0348a7-a85d-4e38-b7a0-7a9be1570806	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	29	[2, 1, 0, 3]	{"id": "9d0348a7-a85d-4e38-b7a0-7a9be1570806", "marks": 1, "options": ["(2n + 1)lambda/2", "n lambda", "lambda/4", "Zero only"], "topic_id": "689f8270-2092-401a-933d-5204f62002ce", "difficulty": "hard", "explanation": "Constructive interference occurs for integer multiples of lambda", "option_images": null, "question_text": "In Young's double-slit experiment, a bright fringe occurs when path difference is what?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
b5edd812-5827-467e-8872-e23a3c48787e	67c25cd4-5f62-4314-a262-be0aa48eba67	2b6c077c-b02a-465d-80ed-57545042558c	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	30	[2, 1, 0, 3]	{"id": "2b6c077c-b02a-465d-80ed-57545042558c", "marks": 1, "options": ["speed in medium / speed in vacuum", "speed in vacuum / speed in medium", "wavelength in vacuum / frequency", "frequency / wavelength"], "topic_id": "689f8270-2092-401a-933d-5204f62002ce", "difficulty": "medium", "explanation": "The refractive index n equals c divided by v", "option_images": null, "question_text": "Refractive index of a medium is equal to which ratio?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
ba5f8ff1-360c-4c91-ae7e-aad84e28605d	67c25cd4-5f62-4314-a262-be0aa48eba67	997942ce-606e-42c9-869d-6af913e84e78	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	31	[0, 3, 1, 2]	{"id": "997942ce-606e-42c9-869d-6af913e84e78", "marks": 1, "options": ["Momentum", "Inertia", "Gravitation", "Energy"], "topic_id": "7b47c1c5-6ff8-411e-8f06-8a29719b6485", "difficulty": "easy", "explanation": "The first law describes resistance to change in motion", "option_images": null, "question_text": "Newton's first law is also called the law of what?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
20af5be3-26a8-4c2b-a143-0c093bb89e24	67c25cd4-5f62-4314-a262-be0aa48eba67	9194797b-a1d2-42aa-ab3d-401d7ff7f569	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	32	[2, 0, 3, 1]	{"id": "9194797b-a1d2-42aa-ab3d-401d7ff7f569", "marks": 1, "options": ["Ampere", "Volt", "Ohm", "Coulomb"], "topic_id": "296873c1-7eae-4ac6-af30-4e90e6c975cb", "difficulty": "easy", "explanation": "Current is measured in amperes", "option_images": null, "question_text": "What is the SI unit of electric current?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
48f8b1a6-2c54-4eba-8dd7-554710f2a4c0	67c25cd4-5f62-4314-a262-be0aa48eba67	c0f643df-f3ca-4f8a-9486-7138e13f4c6f	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	33	[0, 3, 2, 1]	{"id": "c0f643df-f3ca-4f8a-9486-7138e13f4c6f", "marks": 1, "options": ["Voltage", "Charge stored", "Resistance", "Current"], "topic_id": "296873c1-7eae-4ac6-af30-4e90e6c975cb", "difficulty": "medium", "explanation": "Series components share the same current", "option_images": null, "question_text": "In a series circuit, which quantity is the same through each component?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
0496f6a6-c7e9-4909-881d-393781b7ba27	67c25cd4-5f62-4314-a262-be0aa48eba67	eafa0d6a-06ee-4fbc-bd0f-f532525804cc	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	34	[0, 1, 3, 2]	{"id": "eafa0d6a-06ee-4fbc-bd0f-f532525804cc", "marks": 1, "options": ["Seen only in a microscope", "Always upright", "Always virtual", "Formed on a screen"], "topic_id": "689f8270-2092-401a-933d-5204f62002ce", "difficulty": "medium", "explanation": "Real images can be projected", "option_images": null, "question_text": "A real image formed by a concave mirror can be what?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
39953956-f1b7-4308-a18d-89734f333583	67c25cd4-5f62-4314-a262-be0aa48eba67	c2e25563-7e7e-4897-b22d-55b29904bfda	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	35	[3, 0, 1, 2]	{"id": "c2e25563-7e7e-4897-b22d-55b29904bfda", "marks": 1, "options": ["P = VI", "V = IR", "Q = It", "F = qE"], "topic_id": "296873c1-7eae-4ac6-af30-4e90e6c975cb", "difficulty": "easy", "explanation": "Ohm's law relates voltage, current, and resistance", "option_images": null, "question_text": "Ohm's law is written as which equation?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
936ec006-d66e-4a1b-a6d8-72e980583a9f	d6e3620b-8354-4d82-a5c8-978811ed5728	917824ad-a2ad-4a71-8362-9800c11f2195	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	1	[0, 3, 1, 2]	\N
2a62aa0a-7078-44f8-9872-828e1f2feb98	67c25cd4-5f62-4314-a262-be0aa48eba67	22a09dab-66d3-46d1-8812-46c2ad1fb973	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	36	[3, 2, 1, 0]	{"id": "22a09dab-66d3-46d1-8812-46c2ad1fb973", "marks": 1, "options": ["Proton", "Alpha particle", "Electron", "Photon only"], "topic_id": "069e7811-b04d-43d6-b0f0-aed1011ac338", "difficulty": "hard", "explanation": "Beta minus decay emits an electron", "option_images": null, "question_text": "In beta minus decay, which particle is emitted?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
aff7d970-1832-4c59-8310-89a1b8c69adf	67c25cd4-5f62-4314-a262-be0aa48eba67	72bb8096-7663-477e-b3ed-33efecc648f1	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	37	[3, 2, 0, 1]	{"id": "72bb8096-7663-477e-b3ed-33efecc648f1", "marks": 1, "options": ["5 D", "2 D", "4 D", "10 D"], "topic_id": "689f8270-2092-401a-933d-5204f62002ce", "difficulty": "hard", "explanation": "Power is the reciprocal of focal length in metres", "option_images": null, "question_text": "What is the power of a lens of focal length 20 cm?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
76636e93-6de5-466d-a88c-b8401ad186d7	67c25cd4-5f62-4314-a262-be0aa48eba67	6675663b-3099-40b7-8680-b7c919fd4174	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	38	[3, 2, 0, 1]	{"id": "6675663b-3099-40b7-8680-b7c919fd4174", "marks": 1, "options": ["0", "2", "1", "It varies with distance"], "topic_id": "689f8270-2092-401a-933d-5204f62002ce", "difficulty": "hard", "explanation": "A plane mirror forms an image of equal size", "option_images": null, "question_text": "What is the magnification of a plane mirror?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
832ec965-151e-4db0-b3f7-f716a21502ff	67c25cd4-5f62-4314-a262-be0aa48eba67	3bd0f5f8-a41f-47af-aa4c-3b43fedd5a79	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	39	[2, 1, 0, 3]	{"id": "3bd0f5f8-a41f-47af-aa4c-3b43fedd5a79", "marks": 1, "options": ["P = IR", "P = VI", "P = V/R", "P = Q/t^2"], "topic_id": "296873c1-7eae-4ac6-af30-4e90e6c975cb", "difficulty": "medium", "explanation": "Power equals voltage times current", "option_images": null, "question_text": "Electric power is given by which expression?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
c74f511b-bc00-43c9-a922-4930702a67ee	67c25cd4-5f62-4314-a262-be0aa48eba67	f3482d19-08be-495b-b50f-eb2f069671e3	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	40	[1, 0, 2, 3]	{"id": "f3482d19-08be-495b-b50f-eb2f069671e3", "marks": 1, "options": ["2 A", "0.5 A", "1 A", "12 A"], "topic_id": "296873c1-7eae-4ac6-af30-4e90e6c975cb", "difficulty": "hard", "explanation": "Current equals voltage divided by resistance", "option_images": null, "question_text": "A 12 ohm resistor is connected across 24 V. What current flows?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
fe4a3e11-d788-443a-9fd6-1194f9a038b2	67c25cd4-5f62-4314-a262-be0aa48eba67	6ce3fadf-60c1-4b41-a0b5-0df18fc5f126	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	41	[3, 0, 1, 2]	{"id": "6ce3fadf-60c1-4b41-a0b5-0df18fc5f126", "marks": 1, "options": ["0 C", "0 K", "-100 C", "273 K"], "topic_id": "3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2", "difficulty": "medium", "explanation": "Absolute zero is 0 kelvin", "option_images": null, "question_text": "Absolute zero is equal to which temperature?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
08551ea3-d6ed-4a3f-a1f1-8d47a85ab462	67c25cd4-5f62-4314-a262-be0aa48eba67	7025c6b5-273d-4cc5-af81-6e215a6ca160	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	42	[0, 2, 1, 3]	{"id": "7025c6b5-273d-4cc5-af81-6e215a6ca160", "marks": 1, "options": ["Kelvin", "Celsius", "Fahrenheit", "Joule"], "topic_id": "3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2", "difficulty": "easy", "explanation": "Kelvin is the SI base unit of temperature", "option_images": null, "question_text": "What is the SI unit of temperature?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
4333a508-151a-4eac-ab36-c7294cc0cb47	67c25cd4-5f62-4314-a262-be0aa48eba67	28a88db5-65f5-48cd-9b7f-407537b243c3	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	43	[0, 2, 1, 3]	{"id": "28a88db5-65f5-48cd-9b7f-407537b243c3", "marks": 1, "options": ["Magnetic poles only", "No momentum", "A wavelength", "Infinite mass"], "topic_id": "069e7811-b04d-43d6-b0f0-aed1011ac338", "difficulty": "medium", "explanation": "Matter waves are described by de Broglie wavelength", "option_images": null, "question_text": "De Broglie proposed that moving particles have what associated property?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
7a02103b-e70e-47f6-a146-7fb04be69844	67c25cd4-5f62-4314-a262-be0aa48eba67	b6cbecc4-8bad-482b-9974-280d186b1574	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	44	[2, 3, 1, 0]	{"id": "b6cbecc4-8bad-482b-9974-280d186b1574", "marks": 1, "options": ["Maximum", "Equal to horizontal velocity", "Zero", "Negative infinity"], "topic_id": "7b47c1c5-6ff8-411e-8f06-8a29719b6485", "difficulty": "hard", "explanation": "The vertical component changes sign at the top", "option_images": null, "question_text": "At the highest point of a projectile's path, what is its vertical velocity?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
1911f950-349b-4464-85f8-3c256d1c6b9e	67c25cd4-5f62-4314-a262-be0aa48eba67	ad9c33b8-54dc-431c-9b46-370a0e5a0ab0	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	45	[2, 0, 1, 3]	{"id": "ad9c33b8-54dc-431c-9b46-370a0e5a0ab0", "marks": 1, "options": ["It always decreases", "It never decreases", "It always stays zero", "It alternates"], "topic_id": "3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2", "difficulty": "hard", "explanation": "Entropy does not decrease for spontaneous change in an isolated system", "option_images": null, "question_text": "According to the second law, what happens to the entropy of an isolated system?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
9a2428e3-ac9f-48ba-a476-41c6e1d26b6c	67c25cd4-5f62-4314-a262-be0aa48eba67	f33a59c2-9803-4af4-8efb-2bca09643633	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	46	[0, 1, 3, 2]	{"id": "f33a59c2-9803-4af4-8efb-2bca09643633", "marks": 1, "options": ["force x time", "mass x acceleration", "work x distance", "mass x velocity"], "topic_id": "7b47c1c5-6ff8-411e-8f06-8a29719b6485", "difficulty": "medium", "explanation": "Momentum is defined as p = mv", "option_images": null, "question_text": "Linear momentum is equal to which quantity?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
fd486ec5-7ab3-4b54-a6f1-96855e577a58	67c25cd4-5f62-4314-a262-be0aa48eba67	370aa1f0-3655-4478-8399-69a26ef0f57f	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	47	[2, 3, 0, 1]	{"id": "370aa1f0-3655-4478-8399-69a26ef0f57f", "marks": 1, "options": ["Principal focus", "Center of curvature", "Optical center only", "Pole"], "topic_id": "689f8270-2092-401a-933d-5204f62002ce", "difficulty": "easy", "explanation": "A convex lens converges parallel rays to its focus", "option_images": null, "question_text": "Parallel rays incident on a convex lens meet at which point?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
a067b786-77ce-4608-90fe-90593570e0a9	d6e3620b-8354-4d82-a5c8-978811ed5728	800c6667-7c18-479a-bc6a-1ecf92332133	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	2	[3, 1, 2, 0]	\N
40d6a885-c628-45d0-aadb-91de9e610e70	d6e3620b-8354-4d82-a5c8-978811ed5728	0d3d1eeb-7d8f-4662-9977-94864f4040c9	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	3	[0, 2, 3, 1]	\N
7f49a620-c4b1-4599-929a-da632faafe66	67c25cd4-5f62-4314-a262-be0aa48eba67	b9b54bef-3b2a-446d-9d6f-f99cea938fbe	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	48	[0, 1, 3, 2]	{"id": "b9b54bef-3b2a-446d-9d6f-f99cea938fbe", "marks": 1, "options": ["Maximum force", "Half the force", "Zero force", "Infinite force"], "topic_id": "296873c1-7eae-4ac6-af30-4e90e6c975cb", "difficulty": "hard", "explanation": "The magnetic force depends on v cross B", "option_images": null, "question_text": "What magnetic force acts on a charge moving parallel to a magnetic field?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
83b9a97e-feae-45e6-8e72-10dfa9b50c9d	67c25cd4-5f62-4314-a262-be0aa48eba67	a68d59a7-47a1-4756-88c5-a67b466e1142	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	49	[3, 0, 2, 1]	{"id": "a68d59a7-47a1-4756-88c5-a67b466e1142", "marks": 1, "options": ["Entropy", "Momentum", "Enthalpy", "Resistance"], "topic_id": "3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2", "difficulty": "easy", "explanation": "At constant pressure, q equals delta H", "option_images": null, "question_text": "At constant pressure, heat supplied to a system equals the change in what quantity?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
cbc3d1f1-bde8-4b7c-a540-96c8ed8b272f	67c25cd4-5f62-4314-a262-be0aa48eba67	e6675ffe-0146-41be-bd2e-d92cac3c5536	\N	f	0.00	0	f	f	2026-08-28 06:06:23.252+00	50	[2, 3, 0, 1]	{"id": "e6675ffe-0146-41be-bd2e-d92cac3c5536", "marks": 1, "options": ["E = hf", "E = mv", "E = IR", "E = pV"], "topic_id": "069e7811-b04d-43d6-b0f0-aed1011ac338", "difficulty": "hard", "explanation": "Photon energy is proportional to frequency", "option_images": null, "question_text": "What is the energy of a photon?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
ddfa594a-0f1c-4a6d-a898-55cbeb52ece1	918761bd-1936-45b3-8771-eef1dcd29c24	669eddca-36e1-4eca-a191-a6de90cae4a9	\N	f	0.00	0	f	f	2026-08-28 11:21:37.944+00	2	[3, 1, 0, 2]	{"id": "669eddca-36e1-4eca-a191-a6de90cae4a9", "marks": 1, "options": ["2x^2 + C", "x^2 + C", "x + C", "2 + C"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "medium", "explanation": "x^2 differentiates to 2x", "option_images": null, "question_text": "What is the integral of 2x with respect to x?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
0f3d6d77-a964-4d26-a074-12ce99b22543	918761bd-1936-45b3-8771-eef1dcd29c24	85f181e7-3e4c-49df-89d0-98d854126316	\N	f	0.00	0	f	f	2026-08-28 11:21:37.998+00	3	[2, 0, 1, 3]	{"id": "85f181e7-3e4c-49df-89d0-98d854126316", "marks": 1, "options": ["(sqrt(6) - sqrt(2))/4", "sqrt(3)/2", "(sqrt(6) + sqrt(2))/4", "1/2"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "hard", "explanation": "Use the angle addition formula", "option_images": null, "question_text": "What is sin 75 degrees?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
5cf41f8e-8b43-426a-bc42-c624bfd95d57	918761bd-1936-45b3-8771-eef1dcd29c24	8fe299d0-8f3f-409f-b623-19c369484421	\N	f	0.00	0	f	f	2026-08-28 11:21:38.043+00	4	[0, 1, 2, 3]	{"id": "8fe299d0-8f3f-409f-b623-19c369484421", "marks": 1, "options": ["x = 6", "x = 4", "x = 5", "x = 7"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "easy", "explanation": "Subtract 5 and divide by 2 to get x = 6", "option_images": null, "question_text": "Solve 2x + 5 = 17.", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
799dd7ca-8580-44a0-8f81-4c27ff38e5ff	918761bd-1936-45b3-8771-eef1dcd29c24	3b2c7c17-25d8-46f7-8ffe-07f122794112	\N	f	0.00	0	f	f	2026-08-28 11:21:38.08+00	5	[3, 0, 1, 2]	{"id": "3b2c7c17-25d8-46f7-8ffe-07f122794112", "marks": 1, "options": ["5a - 2", "7a + 2", "7a - 2", "12a"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "easy", "explanation": "Combine like terms 3a and 4a first", "option_images": null, "question_text": "Simplify 3a + 4a - 2.", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
9db4b8f6-a736-4737-a5ed-8f9ef5eb23e7	918761bd-1936-45b3-8771-eef1dcd29c24	a84366a8-692e-4ee7-98d4-5672b2aec7c8	\N	f	0.00	0	f	f	2026-08-28 11:21:38.121+00	6	[1, 2, 0, 3]	{"id": "a84366a8-692e-4ee7-98d4-5672b2aec7c8", "marks": 1, "options": ["1/52", "1/13", "1/4", "4/13"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "medium", "explanation": "There are 4 aces in 52 cards", "option_images": null, "question_text": "What is the probability of drawing an ace from a standard 52-card deck?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
56246d6f-8741-43df-861e-7551f07ba3fe	918761bd-1936-45b3-8771-eef1dcd29c24	47487c28-3d5e-44b6-a40e-c939fe00651b	\N	f	0.00	0	f	f	2026-08-28 11:21:38.157+00	7	[1, 3, 2, 0]	{"id": "47487c28-3d5e-44b6-a40e-c939fe00651b", "marks": 1, "options": ["1/sin x", "1/cos x", "sin x/cos x", "cos x/sin x"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "medium", "explanation": "Secant is the reciprocal of cosine", "option_images": null, "question_text": "sec x is equal to which expression?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
a4850001-498d-40e5-966c-5233ff3d1146	918761bd-1936-45b3-8771-eef1dcd29c24	171cbd6b-a9c4-4210-8f72-467cea0b80d9	\N	f	0.00	0	f	f	2026-08-28 11:21:38.198+00	8	[3, 1, 2, 0]	{"id": "171cbd6b-a9c4-4210-8f72-467cea0b80d9", "marks": 1, "options": ["P(A) + P(B)", "P(A) - P(B)", "P(A)P(B)", "P(A)/P(B)"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "medium", "explanation": "Independent events multiply", "option_images": null, "question_text": "For independent events A and B, what is P(A and B)?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
45dd07a0-9014-4ccb-bb51-14d1ccb3c2bd	918761bd-1936-45b3-8771-eef1dcd29c24	ef60efdd-9823-4570-9219-34bc0d49300e	\N	f	0.00	0	f	f	2026-08-28 11:21:38.234+00	9	[0, 3, 1, 2]	{"id": "ef60efdd-9823-4570-9219-34bc0d49300e", "marks": 1, "options": ["0", "1", "e", "ln 2"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "hard", "explanation": "The antiderivative is ln x, so ln e - ln 1 = 1", "option_images": null, "question_text": "Evaluate the integral from 1 to e of 1/x dx.", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
d4d6971a-51f3-4540-9c98-335cc800dfe8	918761bd-1936-45b3-8771-eef1dcd29c24	9e68b749-d586-40fe-b64e-a2ab3b19516f	\N	f	0.00	0	f	f	2026-08-28 11:21:38.276+00	10	[0, 2, 3, 1]	{"id": "9e68b749-d586-40fe-b64e-a2ab3b19516f", "marks": 1, "options": ["1/4", "3/4", "1", "1/2"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "medium", "explanation": "The favorable outcomes are HT and TH", "option_images": null, "question_text": "If two fair coins are tossed, what is the probability of getting exactly one head?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
37ec75cb-265e-4b49-a1ae-bc219935784f	918761bd-1936-45b3-8771-eef1dcd29c24	686147bb-ee54-4ce4-99b2-903d80e977df	\N	f	0.00	0	f	f	2026-08-28 11:21:38.349+00	12	[3, 2, 1, 0]	{"id": "686147bb-ee54-4ce4-99b2-903d80e977df", "marks": 1, "options": ["0", "1", "1/2", "-1"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "easy", "explanation": "cos 0 degrees equals 1", "option_images": null, "question_text": "What is cos 0 degrees?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
62d275de-4804-4d19-b0c4-74c208ef3e9a	918761bd-1936-45b3-8771-eef1dcd29c24	fab38afd-5f36-4bf8-8631-eb807028b069	\N	f	0.00	0	f	f	2026-08-28 11:21:38.386+00	13	[1, 0, 2, 3]	{"id": "fab38afd-5f36-4bf8-8631-eb807028b069", "marks": 1, "options": ["3", "1", "2", "4"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "hard", "explanation": "A rectangle of height 1 and width 3 has area 3", "option_images": null, "question_text": "What is the area under y = 1 from x = 0 to x = 3?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
d7ab9184-196f-404b-b02a-7e515a8ccd40	918761bd-1936-45b3-8771-eef1dcd29c24	d9ecd9dd-aa5c-4457-90d4-b2e8d26661f7	\N	f	0.00	0	f	f	2026-08-28 11:21:38.427+00	14	[0, 1, 3, 2]	{"id": "d9ecd9dd-aa5c-4457-90d4-b2e8d26661f7", "marks": 1, "options": ["0", "sqrt(2)", "1", "sqrt(3)"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "easy", "explanation": "At 45 degrees, sine and cosine are equal", "option_images": null, "question_text": "What is tan 45 degrees?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
c74704a6-a845-4d99-9249-0f1c90d8983c	918761bd-1936-45b3-8771-eef1dcd29c24	a6e11d00-ea90-4cb6-a2fd-88db3dc36f15	\N	f	0.00	0	f	f	2026-08-28 11:21:38.461+00	15	[2, 3, 1, 0]	{"id": "a6e11d00-ea90-4cb6-a2fd-88db3dc36f15", "marks": 1, "options": ["1/2", "0", "sqrt(3)/2", "1"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "easy", "explanation": "sin 30 degrees equals one-half", "option_images": null, "question_text": "What is sin 30 degrees?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
b0e572f6-5cbc-42cf-b603-c3f104daf14f	918761bd-1936-45b3-8771-eef1dcd29c24	3773211f-6a96-47c7-b6d5-7124ca15bd2a	\N	f	0.00	0	f	f	2026-08-28 11:21:38.502+00	16	[0, 2, 1, 3]	{"id": "3773211f-6a96-47c7-b6d5-7124ca15bd2a", "marks": 1, "options": ["2", "3", "4", "5"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "hard", "explanation": "Because 81 = 3^4, x + 1 = 4", "option_images": null, "question_text": "If 3^(x + 1) = 81, what is x?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
eb80876e-f703-45a1-8627-a9ec1c77407e	918761bd-1936-45b3-8771-eef1dcd29c24	b1704bf5-d1dd-449d-9b3b-02f150f49196	\N	f	0.00	0	f	f	2026-08-28 11:21:38.537+00	17	[2, 1, 0, 3]	{"id": "b1704bf5-d1dd-449d-9b3b-02f150f49196", "marks": 1, "options": ["(x - 25)(x + 1)", "(x - 5)(x + 5)", "(x - 5)^2", "(x + 25)(x - 1)"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "easy", "explanation": "This is a difference of squares", "option_images": null, "question_text": "Which expression factors x^2 - 25?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
49e21c23-75af-4c23-94d9-ee8229449fe0	918761bd-1936-45b3-8771-eef1dcd29c24	3a0136aa-5a28-41c8-8a9d-0ca85988d517	\N	f	0.00	0	f	f	2026-08-28 11:21:38.576+00	18	[1, 2, 3, 0]	{"id": "3a0136aa-5a28-41c8-8a9d-0ca85988d517", "marks": 1, "options": ["-sin x", "-cos x", "tan x", "cos x"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "medium", "explanation": "The derivative of sin x is cos x", "option_images": null, "question_text": "What is the derivative of sin x?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
ed727afc-eba8-4430-a8aa-cc76ac38203d	918761bd-1936-45b3-8771-eef1dcd29c24	218fb4c0-cf10-46d9-9b02-4ce16ed00229	\N	f	0.00	0	f	f	2026-08-28 11:21:38.616+00	19	[1, 3, 2, 0]	{"id": "218fb4c0-cf10-46d9-9b02-4ce16ed00229", "marks": 1, "options": ["1/2", "0", "1/4", "1"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "easy", "explanation": "A fair coin has two equally likely outcomes", "option_images": null, "question_text": "What is the probability of getting heads on a fair coin toss?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
b25e4b1b-f35a-49ca-9836-57dd842e121d	918761bd-1936-45b3-8771-eef1dcd29c24	d04ce9b1-15b1-4bb1-8753-e5dffd8bc3e2	\N	f	0.00	0	f	f	2026-08-28 11:21:38.657+00	20	[1, 2, 3, 0]	{"id": "d04ce9b1-15b1-4bb1-8753-e5dffd8bc3e2", "marks": 1, "options": ["4", "5", "12", "6"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "medium", "explanation": "Area = 1/2 x base x height", "option_images": null, "question_text": "What is the area of the triangle with vertices (0, 0), (4, 0), and (0, 3)?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
66cfd014-2a67-4c87-be5a-72d5b4203d18	918761bd-1936-45b3-8771-eef1dcd29c24	288722fc-d2d7-4d5b-9190-3990f9a366c8	\N	f	0.00	0	f	f	2026-08-28 11:21:38.689+00	21	[0, 2, 1, 3]	{"id": "288722fc-d2d7-4d5b-9190-3990f9a366c8", "marks": 1, "options": ["1/3", "1/6", "1/4", "1/5"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "easy", "explanation": "One favorable outcome out of six", "option_images": null, "question_text": "What is the probability of rolling a 6 on a fair die?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
3384ac1f-11cb-4001-bdf6-64dba32dcc6c	918761bd-1936-45b3-8771-eef1dcd29c24	cd593bb2-89b7-477f-a0ca-61725c1fb34f	\N	f	0.00	0	f	f	2026-08-28 11:21:38.728+00	22	[0, 3, 1, 2]	{"id": "cd593bb2-89b7-477f-a0ca-61725c1fb34f", "marks": 1, "options": ["1/4", "1/2", "1", "3/4"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "medium", "explanation": "Use the complement of getting no heads", "option_images": null, "question_text": "What is the probability of getting at least one head when two fair coins are tossed?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
67ea71dd-be71-4d1f-973f-013878e4a12e	918761bd-1936-45b3-8771-eef1dcd29c24	823eeddf-be0c-456a-97e1-91054ad0c850	\N	f	0.00	0	f	f	2026-08-28 11:21:38.761+00	23	[2, 0, 1, 3]	{"id": "823eeddf-be0c-456a-97e1-91054ad0c850", "marks": 1, "options": ["ln x", "x", "e^x", "1/x"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "medium", "explanation": "For x > 0, d/dx(ln x) = 1/x", "option_images": null, "question_text": "What is the derivative of ln x?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
36393835-8be5-427c-b6e1-a0fb7efd0064	d6e3620b-8354-4d82-a5c8-978811ed5728	a8e99c3e-4cda-4932-9679-7491977a2aab	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	4	[2, 3, 0, 1]	\N
07d20476-da3c-459c-9e3b-db377e1f08ea	d6e3620b-8354-4d82-a5c8-978811ed5728	2a2693a6-3245-4eda-a7ba-44dd65a5ca62	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	5	[1, 2, 0, 3]	\N
bddd3ecc-a6a4-4902-9208-8008a7067db7	d6e3620b-8354-4d82-a5c8-978811ed5728	42b35a2c-82ad-4261-a23d-eb309b1102d8	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	6	[3, 2, 1, 0]	\N
dc94f8a4-88d8-43bd-89a2-45b1233b2d23	d6e3620b-8354-4d82-a5c8-978811ed5728	f1efce00-8f4b-4b71-b931-bc669b097769	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	7	[0, 2, 3, 1]	\N
1f821232-31e4-4dc4-89b5-f71321d0abcd	d6e3620b-8354-4d82-a5c8-978811ed5728	e9d55130-9b49-4ed6-860c-9648b790a309	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	8	[1, 3, 0, 2]	\N
3a43817e-3b42-404f-bdaf-b039ede973ec	918761bd-1936-45b3-8771-eef1dcd29c24	ed939a01-c9c4-42f6-bd6b-066eaff591ef	\N	f	0.00	0	f	f	2026-08-28 11:21:38.833+00	25	[3, 1, 0, 2]	{"id": "ed939a01-c9c4-42f6-bd6b-066eaff591ef", "marks": 1, "options": ["3", "4", "3.5", "4.5"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "hard", "explanation": "Average the outcomes 1 through 6", "option_images": null, "question_text": "What is the expected value of a fair six-sided die roll?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
c940398a-0780-4a56-bb01-88833df79207	918761bd-1936-45b3-8771-eef1dcd29c24	56f4b9ca-bc07-4d25-8ae6-4b84497a831b	\N	f	0.00	0	f	f	2026-08-28 11:21:38.871+00	26	[0, 2, 1, 3]	{"id": "56f4b9ca-bc07-4d25-8ae6-4b84497a831b", "marks": 1, "options": ["15", "21", "23", "25"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "hard", "explanation": "Square the expression and subtract 2", "option_images": null, "question_text": "If x + 1/x = 5, what is x^2 + 1/x^2?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
605edddf-88da-4677-92c5-10731e5e33ff	918761bd-1936-45b3-8771-eef1dcd29c24	da02328f-d889-4100-a1fd-250b5e9a9848	\N	f	0.00	0	f	f	2026-08-28 11:21:38.906+00	27	[2, 1, 0, 3]	{"id": "da02328f-d889-4100-a1fd-250b5e9a9848", "marks": 1, "options": ["2/3", "3/2", "-2/3", "-3/2"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "medium", "explanation": "Rewrite in slope-intercept form", "option_images": null, "question_text": "What is the slope of the line 2x + 3y = 6?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
0e5d4eac-bc2e-4bac-93e3-d53e77a83eba	918761bd-1936-45b3-8771-eef1dcd29c24	7af86835-af29-4960-8e8b-8264de6842e1	\N	f	0.00	0	f	f	2026-08-28 11:21:38.947+00	28	[2, 3, 0, 1]	{"id": "7af86835-af29-4960-8e8b-8264de6842e1", "marks": 1, "options": ["3/10", "1/5", "2/5", "3/5"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "hard", "explanation": "Multiply 3/5 by 2/4", "option_images": null, "question_text": "A bag has 3 red and 2 blue balls. Without replacement, what is the probability of drawing a red then a blue?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
f5549ee8-32df-425f-96f0-017f96204b64	918761bd-1936-45b3-8771-eef1dcd29c24	e06db5ea-8a41-45dc-94c5-f6930c8fca2f	\N	f	0.00	0	f	f	2026-08-28 11:21:38.983+00	29	[2, 0, 3, 1]	{"id": "e06db5ea-8a41-45dc-94c5-f6930c8fca2f", "marks": 1, "options": ["1 and 6", "3 and 5", "2 and 3", "2 and 6"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": "The quadratic factors as (x - 2)(x - 3)", "option_images": null, "question_text": "What are the roots of x^2 - 5x + 6 = 0?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
3533d9cc-0d16-4003-8338-6849b3fa48bc	918761bd-1936-45b3-8771-eef1dcd29c24	a67d367d-6064-439a-9820-1b559a314178	\N	f	0.00	0	f	f	2026-08-28 11:21:39.023+00	30	[0, 2, 3, 1]	{"id": "a67d367d-6064-439a-9820-1b559a314178", "marks": 1, "options": ["2x", "x", "x^2", "2"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "easy", "explanation": "Apply the power rule", "option_images": null, "question_text": "What is the derivative of x^2?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
9ba2828d-c1b6-4734-b43d-1eb8dfda169e	918761bd-1936-45b3-8771-eef1dcd29c24	7a39e6f7-1122-48a5-a69e-21c07a7627ce	\N	f	0.00	0	f	f	2026-08-28 11:21:39.059+00	31	[3, 0, 1, 2]	{"id": "7a39e6f7-1122-48a5-a69e-21c07a7627ce", "marks": 1, "options": ["x^2 + 9", "x^2 + 6x + 9", "x^2 + 3x + 9", "x^2 + 6x + 3"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": "Use (a + b)^2 = a^2 + 2ab + b^2", "option_images": null, "question_text": "Expand (x + 3)^2.", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
fb457f8f-a471-40e8-908b-2aebe2958737	918761bd-1936-45b3-8771-eef1dcd29c24	48ff2f62-05d2-4cec-bb51-e5396bfbe13f	\N	f	0.00	0	f	f	2026-08-28 11:21:39.1+00	32	[3, 0, 2, 1]	{"id": "48ff2f62-05d2-4cec-bb51-e5396bfbe13f", "marks": 1, "options": ["0", "n", "1", "Depends on the event"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "easy", "explanation": "All outcomes in a complete sample space total 1", "option_images": null, "question_text": "What is the sum of probabilities of all outcomes in a sample space?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
29014c14-8005-429b-9f42-0e5142f563d0	918761bd-1936-45b3-8771-eef1dcd29c24	5393ef56-444a-407e-9f4f-063996681bdb	\N	f	0.00	0	f	f	2026-08-28 11:21:39.135+00	33	[2, 0, 3, 1]	{"id": "5393ef56-444a-407e-9f4f-063996681bdb", "marks": 1, "options": ["-1", "1", "0", "2"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "medium", "explanation": "Both values are 1, so the difference is 0", "option_images": null, "question_text": "What is sin 90 degrees - cos 0 degrees?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
a468454f-e656-4c87-ac21-4670540a4b9e	918761bd-1936-45b3-8771-eef1dcd29c24	4fdc905f-582a-4880-b97a-ab03f7a924dd	\N	f	0.00	0	f	f	2026-08-28 11:21:39.177+00	34	[0, 1, 2, 3]	{"id": "4fdc905f-582a-4880-b97a-ab03f7a924dd", "marks": 1, "options": ["6", "1", "4", "5"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "hard", "explanation": "The two solutions are 1 and 6", "option_images": null, "question_text": "Solve |2x - 7| = 5. Which is the larger solution?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
c3fcbd0f-0b28-40b9-be1b-9f41984ef8d8	918761bd-1936-45b3-8771-eef1dcd29c24	2147f63d-ebff-4303-b492-aa1e53fd89a9	\N	f	0.00	0	f	f	2026-08-28 11:21:39.212+00	35	[1, 0, 2, 3]	{"id": "2147f63d-ebff-4303-b492-aa1e53fd89a9", "marks": 1, "options": ["x^5 + C", "5x + C", "5 + C", "1 + C"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "easy", "explanation": "The integral of a constant k is kx + C", "option_images": null, "question_text": "What is the integral of 5 with respect to x?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
83689f3e-ba2b-41e1-b33b-4ea4ba9c72a0	918761bd-1936-45b3-8771-eef1dcd29c24	f525ad0a-65c3-4f8e-be97-3d65a44b80be	\N	f	0.00	0	f	f	2026-08-28 11:21:39.253+00	36	[0, 1, 2, 3]	{"id": "f525ad0a-65c3-4f8e-be97-3d65a44b80be", "marks": 1, "options": ["5/9", "7/9", "8/9", "1/9"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "hard", "explanation": "Use cos 2theta = 1 - 2sin^2 theta", "option_images": null, "question_text": "If sin theta = 1/3 and theta is acute, what is cos 2theta?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
9c4efc2e-1623-46d3-808e-695f675ecef9	d6e3620b-8354-4d82-a5c8-978811ed5728	1cb593e7-b238-46e7-8640-41efd6e572a7	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	9	[0, 2, 1, 3]	\N
175c5791-87a4-41ac-904c-896e2cafce0c	d6e3620b-8354-4d82-a5c8-978811ed5728	f519a0dd-fd04-49cf-ad19-cf56cf5045dc	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	10	[3, 1, 0, 2]	\N
fd929c8b-c6aa-4f83-85af-e14dbf149419	d6e3620b-8354-4d82-a5c8-978811ed5728	7aa05be2-ce64-429c-a9d5-17c8a20e0090	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	11	[0, 3, 2, 1]	\N
3fd3c0a1-7b63-4497-b701-6ca245a27d71	d6e3620b-8354-4d82-a5c8-978811ed5728	d69919b3-9d08-49b1-982a-b777d37bc6bf	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	12	[3, 0, 1, 2]	\N
8f256e02-3c78-478e-92ba-332f2976faec	d6e3620b-8354-4d82-a5c8-978811ed5728	80310cf0-3dac-418d-846f-664b177ae74e	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	13	[0, 3, 2, 1]	\N
191aa2df-6e97-4178-840d-e1a87d2d1ad3	918761bd-1936-45b3-8771-eef1dcd29c24	612e0882-184e-477d-9b07-68aebaf8f9db	\N	f	0.00	0	f	f	2026-08-28 11:21:39.325+00	38	[1, 2, 3, 0]	{"id": "612e0882-184e-477d-9b07-68aebaf8f9db", "marks": 1, "options": ["1", "2", "3", "4"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "easy", "explanation": "In y = mx + c, the slope is m", "option_images": null, "question_text": "What is the slope of the line y = 3x + 1?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
86f1a4f4-820b-4a59-9a3a-b9cebb77047c	918761bd-1936-45b3-8771-eef1dcd29c24	60471398-431a-487a-a636-0685c3f03cb8	\N	f	0.00	0	f	f	2026-08-28 11:21:39.361+00	39	[2, 1, 0, 3]	{"id": "60471398-431a-487a-a636-0685c3f03cb8", "marks": 1, "options": ["(0, 2)", "(2, 0)", "(4, 0)", "(0, 4)"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "hard", "explanation": "For y^2 = 4ax, the focus is (a, 0)", "option_images": null, "question_text": "For the parabola y^2 = 4ax with a = 2, what is the focus?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
51552782-6228-4577-9b8a-4567c78a7905	918761bd-1936-45b3-8771-eef1dcd29c24	0e1543db-2ba4-47fe-8da4-a71f466dd331	\N	f	0.00	0	f	f	2026-08-28 11:21:39.401+00	40	[1, 2, 0, 3]	{"id": "0e1543db-2ba4-47fe-8da4-a71f466dd331", "marks": 1, "options": ["0", "1", "2", "3"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "medium", "explanation": "Factor the numerator and cancel x - 1", "option_images": null, "question_text": "Evaluate lim (x^2 - 1)/(x - 1) as x approaches 1.", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
dbf817a2-401d-4553-8ae5-3bac0c416063	918761bd-1936-45b3-8771-eef1dcd29c24	a5f2c768-b4fb-4e20-b710-4c57ff9c5e12	\N	f	0.00	0	f	f	2026-08-28 11:21:39.436+00	41	[1, 0, 2, 3]	{"id": "a5f2c768-b4fb-4e20-b710-4c57ff9c5e12", "marks": 1, "options": ["4/5", "5/3", "5/4", "3/5"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "medium", "explanation": "Use a 3-4-5 right triangle", "option_images": null, "question_text": "If tan theta = 3/4 and theta is acute, what is sin theta?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
6a03c948-3224-42e5-83bb-87d4db5f92f2	918761bd-1936-45b3-8771-eef1dcd29c24	59b39e86-2deb-4625-beef-09c39c0f54a6	\N	f	0.00	0	f	f	2026-08-28 11:21:39.477+00	42	[1, 0, 3, 2]	{"id": "59b39e86-2deb-4625-beef-09c39c0f54a6", "marks": 1, "options": ["30 degrees", "15 degrees", "45 degrees", "60 degrees"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "hard", "explanation": "Then sin x = 1/2", "option_images": null, "question_text": "If 2 sin x = 1 and x is acute, what is x?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
6270ecce-25cf-4cf3-b8d8-3f95b5dce6a2	918761bd-1936-45b3-8771-eef1dcd29c24	17a23a4e-e918-49f1-8d37-0bb6b17b0258	\N	f	0.00	0	f	f	2026-08-28 11:21:39.513+00	43	[0, 2, 1, 3]	{"id": "17a23a4e-e918-49f1-8d37-0bb6b17b0258", "marks": 1, "options": ["1", "0", "2", "4"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "easy", "explanation": "Slope is rise over run = 2/2", "option_images": null, "question_text": "What is the slope of the line through (0, 0) and (2, 2)?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
4a0cbad2-2e01-4c5b-a12c-73b0df2cfe09	918761bd-1936-45b3-8771-eef1dcd29c24	c54271c9-5a92-4b96-bed6-53862f0a7fcc	\N	f	0.00	0	f	f	2026-08-28 11:21:39.554+00	44	[3, 1, 2, 0]	{"id": "c54271c9-5a92-4b96-bed6-53862f0a7fcc", "marks": 1, "options": ["x^2 + y^2 = 3", "x^2 + y^2 = 9", "x^2 + y^2 = 6", "x + y = 9"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "medium", "explanation": "A circle centered at the origin has equation x^2 + y^2 = r^2", "option_images": null, "question_text": "Which equation is the circle centered at the origin with radius 3?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
f7d782e4-a36b-4d37-ac53-9a1b4026d320	918761bd-1936-45b3-8771-eef1dcd29c24	87e31772-f018-4825-9fa8-e80c79a3f7c2	\N	f	0.00	0	f	f	2026-08-28 11:21:39.589+00	45	[3, 2, 1, 0]	{"id": "87e31772-f018-4825-9fa8-e80c79a3f7c2", "marks": 1, "options": ["4", "6", "5", "7"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "hard", "explanation": "Use the distance formula", "option_images": null, "question_text": "What is the distance from the point (3, 4) to the origin?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
64518c22-b7b5-4ae7-80bc-a33ac18dc8b8	918761bd-1936-45b3-8771-eef1dcd29c24	cdbf324f-990e-4759-8715-01cf087eb2c0	\N	f	0.00	0	f	f	2026-08-28 11:21:39.629+00	46	[1, 0, 3, 2]	{"id": "cdbf324f-990e-4759-8715-01cf087eb2c0", "marks": 1, "options": ["2", "3", "4", "5"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "easy", "explanation": "The vertical distance is 5 - 2", "option_images": null, "question_text": "What is the distance between (1, 2) and (1, 5)?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
08e6a1e5-457d-447c-bbac-048b7ef90166	918761bd-1936-45b3-8771-eef1dcd29c24	7710b2c7-58fa-4e86-bc48-f5f1da3e3da5	\N	f	0.00	0	f	f	2026-08-28 11:21:39.665+00	47	[2, 0, 3, 1]	{"id": "7710b2c7-58fa-4e86-bc48-f5f1da3e3da5", "marks": 1, "options": ["sin x + cos x = 1", "tan x = sin x cos x", "sec x = sin x", "sin^2 x + cos^2 x = 1"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "medium", "explanation": "This is the Pythagorean identity", "option_images": null, "question_text": "Which identity is always true?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
5673b0ec-32ad-49ca-8297-4f433b805217	918761bd-1936-45b3-8771-eef1dcd29c24	887929bf-45c0-42f3-b88b-960c0ea69bc3	\N	f	0.00	0	f	f	2026-08-28 11:21:39.708+00	48	[3, 1, 0, 2]	{"id": "887929bf-45c0-42f3-b88b-960c0ea69bc3", "marks": 1, "options": ["9", "10", "15", "11"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": "Substitute x = 5 into the function", "option_images": null, "question_text": "If f(x) = 3x - 4, what is f(5)?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
d90bfb77-b3ad-44e3-a32d-3d992c917038	918761bd-1936-45b3-8771-eef1dcd29c24	16b2d359-e7ec-41cb-8da3-f96fc44109d8	\N	f	0.00	0	f	f	2026-08-28 11:21:39.742+00	49	[3, 0, 1, 2]	{"id": "16b2d359-e7ec-41cb-8da3-f96fc44109d8", "marks": 1, "options": ["0.3", "0.8", "0.5", "1.1"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "hard", "explanation": "Add the probabilities and subtract the overlap", "option_images": null, "question_text": "If P(A) = 0.6 and P(B) = 0.5 and A and B are independent, what is P(A or B)?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
c28b0cfd-f9d4-4712-af05-2399ddb751d4	d6e3620b-8354-4d82-a5c8-978811ed5728	9f0d50e3-95ef-4f6d-9f06-3e7c941f9a55	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	14	[2, 3, 0, 1]	\N
e3f50aa2-c5a7-4fbe-b3cc-42ca17067410	d6e3620b-8354-4d82-a5c8-978811ed5728	449df994-b364-434f-abeb-51a02023d79f	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	15	[0, 3, 2, 1]	\N
4d24e08b-9208-479f-b012-b3b50b768d3e	d6e3620b-8354-4d82-a5c8-978811ed5728	cc45a1f5-a62b-45b1-b4ae-bd2a5f5f7553	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	16	[0, 3, 1, 2]	\N
b732cc32-db90-470d-a615-7e1f67981acb	d6e3620b-8354-4d82-a5c8-978811ed5728	85fd2adb-7e29-4600-8954-9bdff1cd76a4	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	17	[0, 2, 1, 3]	\N
8999ce29-9e82-4a84-9d6d-5d165fd5ae7d	918761bd-1936-45b3-8771-eef1dcd29c24	c5386a27-4225-433e-8a5c-152ed1a59b20	\N	f	0.00	0	f	f	2026-08-28 11:21:37.9+00	1	[0, 3, 2, 1]	{"id": "c5386a27-4225-433e-8a5c-152ed1a59b20", "marks": 1, "options": ["y - 2 = 3(x - 1)", "y + 2 = 3(x - 1)", "y - 1 = 2(x - 3)", "y = 3x + 1"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "hard", "explanation": "Use point-slope form", "option_images": null, "question_text": "Which equation is the line through (1, 2) with slope 3?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
58c763e2-de2e-4e2e-b074-fc561501c6db	918761bd-1936-45b3-8771-eef1dcd29c24	d3b64a21-148e-48ef-86aa-ade2ce77951f	\N	f	0.00	0	f	f	2026-08-28 11:21:38.31+00	11	[3, 2, 1, 0]	{"id": "d3b64a21-148e-48ef-86aa-ade2ce77951f", "marks": 1, "options": ["x^(x-1)", "x^x", "x^x(ln x + 1)", "ln x + 1"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "hard", "explanation": "Log differentiation gives x^x(ln x + 1)", "option_images": null, "question_text": "What is the derivative of x^x for x > 0?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
c7091bf2-1dc1-4c78-86d4-0cd3a026387c	918761bd-1936-45b3-8771-eef1dcd29c24	27a57025-3ef9-4c33-aa03-64b6b233ea8e	\N	f	0.00	0	f	f	2026-08-28 11:21:38.799+00	24	[3, 1, 2, 0]	{"id": "27a57025-3ef9-4c33-aa03-64b6b233ea8e", "marks": 1, "options": ["x = 0", "x = y", "y = 0", "x + y = 0"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "easy", "explanation": "Points on the x-axis have y = 0", "option_images": null, "question_text": "Which equation represents the x-axis?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
f3efc74a-69a7-4f9b-b754-ba82119e847c	918761bd-1936-45b3-8771-eef1dcd29c24	c54e6779-0457-4d47-a64a-0267aae99b0f	\N	f	0.00	0	f	f	2026-08-28 11:21:39.288+00	37	[2, 3, 1, 0]	{"id": "c54e6779-0457-4d47-a64a-0267aae99b0f", "marks": 1, "options": ["(3, 5)", "(5, 7)", "(8, 12)", "(4, 6)"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "medium", "explanation": "Average the x-values and y-values", "option_images": null, "question_text": "What is the midpoint of (2, 4) and (6, 8)?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
633d30d7-6eb7-4305-839b-458ffa4b525b	918761bd-1936-45b3-8771-eef1dcd29c24	436d20d2-2e1f-42e2-b4cf-c06445eea5d4	\N	f	0.00	0	f	f	2026-08-28 11:21:39.784+00	50	[2, 1, 0, 3]	{"id": "436d20d2-2e1f-42e2-b4cf-c06445eea5d4", "marks": 1, "options": ["4", "5", "8", "6"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": "Adding the equations gives 2x = 12", "option_images": null, "question_text": "If x + y = 10 and x - y = 2, what is x?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
cea05310-bce2-4318-8c78-eb30ebe30bfc	daac8f25-2982-4b66-b053-e4d2d1c783fc	a5f2c768-b4fb-4e20-b710-4c57ff9c5e12	\N	f	0.00	0	f	f	2026-09-02 06:27:51.897+00	1	[1, 3, 2, 0]	{"id": "a5f2c768-b4fb-4e20-b710-4c57ff9c5e12", "marks": 1, "options": ["4/5", "5/3", "5/4", "3/5"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "medium", "explanation": "Use a 3-4-5 right triangle", "option_images": null, "question_text": "If tan theta = 3/4 and theta is acute, what is sin theta?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
59c4c273-4769-41b8-842b-3b4bb7f8b7f1	daac8f25-2982-4b66-b053-e4d2d1c783fc	8fe299d0-8f3f-409f-b623-19c369484421	\N	f	0.00	0	f	f	2026-09-02 06:27:51.897+00	2	[3, 2, 0, 1]	{"id": "8fe299d0-8f3f-409f-b623-19c369484421", "marks": 1, "options": ["x = 6", "x = 4", "x = 5", "x = 7"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "easy", "explanation": "Subtract 5 and divide by 2 to get x = 6", "option_images": null, "question_text": "Solve 2x + 5 = 17.", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
9f1ceb5c-639e-4bdf-b95d-d271c774e663	daac8f25-2982-4b66-b053-e4d2d1c783fc	7af86835-af29-4960-8e8b-8264de6842e1	\N	f	0.00	0	f	f	2026-09-02 06:27:51.897+00	3	[0, 1, 2, 3]	{"id": "7af86835-af29-4960-8e8b-8264de6842e1", "marks": 1, "options": ["3/10", "1/5", "2/5", "3/5"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "hard", "explanation": "Multiply 3/5 by 2/4", "option_images": null, "question_text": "A bag has 3 red and 2 blue balls. Without replacement, what is the probability of drawing a red then a blue?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
3161c207-308f-4b2c-8a35-cb51309a5295	daac8f25-2982-4b66-b053-e4d2d1c783fc	56f4b9ca-bc07-4d25-8ae6-4b84497a831b	\N	f	0.00	0	f	f	2026-09-02 06:27:51.897+00	4	[0, 2, 1, 3]	{"id": "56f4b9ca-bc07-4d25-8ae6-4b84497a831b", "marks": 1, "options": ["15", "21", "23", "25"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "hard", "explanation": "Square the expression and subtract 2", "option_images": null, "question_text": "If x + 1/x = 5, what is x^2 + 1/x^2?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
67d324c9-270d-49e3-9e77-a261e9fff847	daac8f25-2982-4b66-b053-e4d2d1c783fc	288722fc-d2d7-4d5b-9190-3990f9a366c8	\N	f	0.00	0	f	f	2026-09-02 06:27:51.897+00	5	[2, 3, 1, 0]	{"id": "288722fc-d2d7-4d5b-9190-3990f9a366c8", "marks": 1, "options": ["1/3", "1/6", "1/4", "1/5"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "easy", "explanation": "One favorable outcome out of six", "option_images": null, "question_text": "What is the probability of rolling a 6 on a fair die?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
db461e21-54db-4ff7-8aeb-074f6eaaceb9	daac8f25-2982-4b66-b053-e4d2d1c783fc	60471398-431a-487a-a636-0685c3f03cb8	\N	f	0.00	0	f	f	2026-09-02 06:27:51.897+00	6	[3, 0, 1, 2]	{"id": "60471398-431a-487a-a636-0685c3f03cb8", "marks": 1, "options": ["(0, 2)", "(2, 0)", "(4, 0)", "(0, 4)"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "hard", "explanation": "For y^2 = 4ax, the focus is (a, 0)", "option_images": null, "question_text": "For the parabola y^2 = 4ax with a = 2, what is the focus?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
08021b0e-9980-4239-b37d-747cc2088889	daac8f25-2982-4b66-b053-e4d2d1c783fc	2147f63d-ebff-4303-b492-aa1e53fd89a9	\N	f	0.00	0	f	f	2026-09-02 06:27:51.897+00	7	[1, 2, 3, 0]	{"id": "2147f63d-ebff-4303-b492-aa1e53fd89a9", "marks": 1, "options": ["x^5 + C", "5x + C", "5 + C", "1 + C"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "easy", "explanation": "The integral of a constant k is kx + C", "option_images": null, "question_text": "What is the integral of 5 with respect to x?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
16dfdf71-b36b-4983-b38c-121e9e160211	daac8f25-2982-4b66-b053-e4d2d1c783fc	e06db5ea-8a41-45dc-94c5-f6930c8fca2f	\N	f	0.00	0	f	f	2026-09-02 06:27:51.897+00	8	[2, 0, 3, 1]	{"id": "e06db5ea-8a41-45dc-94c5-f6930c8fca2f", "marks": 1, "options": ["1 and 6", "3 and 5", "2 and 3", "2 and 6"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": "The quadratic factors as (x - 2)(x - 3)", "option_images": null, "question_text": "What are the roots of x^2 - 5x + 6 = 0?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
5c9462d5-85df-474f-8f3d-9eb26c114e33	daac8f25-2982-4b66-b053-e4d2d1c783fc	686147bb-ee54-4ce4-99b2-903d80e977df	\N	f	0.00	0	f	f	2026-09-02 06:27:51.897+00	9	[0, 3, 1, 2]	{"id": "686147bb-ee54-4ce4-99b2-903d80e977df", "marks": 1, "options": ["0", "1", "1/2", "-1"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "easy", "explanation": "cos 0 degrees equals 1", "option_images": null, "question_text": "What is cos 0 degrees?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
5326b5a2-79ed-45bc-9809-23b3255f3e81	daac8f25-2982-4b66-b053-e4d2d1c783fc	fab38afd-5f36-4bf8-8631-eb807028b069	\N	f	0.00	0	f	f	2026-09-02 06:27:51.897+00	10	[2, 0, 1, 3]	{"id": "fab38afd-5f36-4bf8-8631-eb807028b069", "marks": 1, "options": ["3", "1", "2", "4"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "hard", "explanation": "A rectangle of height 1 and width 3 has area 3", "option_images": null, "question_text": "What is the area under y = 1 from x = 0 to x = 3?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
29164d4b-6235-41f3-a7ec-4d6311267d18	daac8f25-2982-4b66-b053-e4d2d1c783fc	d3b64a21-148e-48ef-86aa-ade2ce77951f	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	11	[0, 3, 1, 2]	{"id": "d3b64a21-148e-48ef-86aa-ade2ce77951f", "marks": 1, "options": ["x^(x-1)", "x^x", "x^x(ln x + 1)", "ln x + 1"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "hard", "explanation": "Log differentiation gives x^x(ln x + 1)", "option_images": null, "question_text": "What is the derivative of x^x for x > 0?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
65fd9aec-2b06-49af-9057-8615055e9615	daac8f25-2982-4b66-b053-e4d2d1c783fc	669eddca-36e1-4eca-a191-a6de90cae4a9	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	12	[2, 3, 0, 1]	{"id": "669eddca-36e1-4eca-a191-a6de90cae4a9", "marks": 1, "options": ["2x^2 + C", "x^2 + C", "x + C", "2 + C"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "medium", "explanation": "x^2 differentiates to 2x", "option_images": null, "question_text": "What is the integral of 2x with respect to x?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
3ef73253-76d1-4537-bed1-8ef03eac7780	d6e3620b-8354-4d82-a5c8-978811ed5728	3afe1a9d-4d26-4000-bc1b-51133a302f66	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	18	[2, 0, 1, 3]	\N
792632d0-7072-4769-8cee-3733d6fd4ba9	d6e3620b-8354-4d82-a5c8-978811ed5728	aab37b88-ea4a-445a-8e91-0fbe809eea80	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	19	[2, 3, 0, 1]	\N
e302f247-4c23-46ad-996e-6a7cab18f2a6	daac8f25-2982-4b66-b053-e4d2d1c783fc	3b2c7c17-25d8-46f7-8ffe-07f122794112	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	13	[0, 3, 2, 1]	{"id": "3b2c7c17-25d8-46f7-8ffe-07f122794112", "marks": 1, "options": ["5a - 2", "7a + 2", "7a - 2", "12a"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "easy", "explanation": "Combine like terms 3a and 4a first", "option_images": null, "question_text": "Simplify 3a + 4a - 2.", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
beee1215-5f03-49ae-8d90-5f231cb19c68	daac8f25-2982-4b66-b053-e4d2d1c783fc	da02328f-d889-4100-a1fd-250b5e9a9848	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	14	[2, 1, 0, 3]	{"id": "da02328f-d889-4100-a1fd-250b5e9a9848", "marks": 1, "options": ["2/3", "3/2", "-2/3", "-3/2"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "medium", "explanation": "Rewrite in slope-intercept form", "option_images": null, "question_text": "What is the slope of the line 2x + 3y = 6?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
9c1b84c7-2f27-40ff-9995-f52c4d689bc7	daac8f25-2982-4b66-b053-e4d2d1c783fc	a67d367d-6064-439a-9820-1b559a314178	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	15	[1, 3, 2, 0]	{"id": "a67d367d-6064-439a-9820-1b559a314178", "marks": 1, "options": ["2x", "x", "x^2", "2"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "easy", "explanation": "Apply the power rule", "option_images": null, "question_text": "What is the derivative of x^2?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
547fc791-e49e-49b2-ae97-b8d4ff54bd28	daac8f25-2982-4b66-b053-e4d2d1c783fc	ed939a01-c9c4-42f6-bd6b-066eaff591ef	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	16	[1, 2, 3, 0]	{"id": "ed939a01-c9c4-42f6-bd6b-066eaff591ef", "marks": 1, "options": ["3", "4", "3.5", "4.5"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "hard", "explanation": "Average the outcomes 1 through 6", "option_images": null, "question_text": "What is the expected value of a fair six-sided die roll?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
84d74641-95e7-4f6b-adf2-789e18840fdd	daac8f25-2982-4b66-b053-e4d2d1c783fc	c54e6779-0457-4d47-a64a-0267aae99b0f	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	17	[1, 3, 0, 2]	{"id": "c54e6779-0457-4d47-a64a-0267aae99b0f", "marks": 1, "options": ["(3, 5)", "(5, 7)", "(8, 12)", "(4, 6)"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "medium", "explanation": "Average the x-values and y-values", "option_images": null, "question_text": "What is the midpoint of (2, 4) and (6, 8)?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
1443c4bb-ca1a-4b62-b7ba-1d333495cdbb	daac8f25-2982-4b66-b053-e4d2d1c783fc	823eeddf-be0c-456a-97e1-91054ad0c850	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	18	[3, 2, 1, 0]	{"id": "823eeddf-be0c-456a-97e1-91054ad0c850", "marks": 1, "options": ["ln x", "x", "e^x", "1/x"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "medium", "explanation": "For x > 0, d/dx(ln x) = 1/x", "option_images": null, "question_text": "What is the derivative of ln x?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
73d9ccdf-0689-43b8-b380-0e8c805384ba	daac8f25-2982-4b66-b053-e4d2d1c783fc	b1704bf5-d1dd-449d-9b3b-02f150f49196	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	19	[1, 2, 0, 3]	{"id": "b1704bf5-d1dd-449d-9b3b-02f150f49196", "marks": 1, "options": ["(x - 25)(x + 1)", "(x - 5)(x + 5)", "(x - 5)^2", "(x + 25)(x - 1)"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "easy", "explanation": "This is a difference of squares", "option_images": null, "question_text": "Which expression factors x^2 - 25?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
75f6f128-d0ed-4b9a-9d54-1f5fa873bf4a	daac8f25-2982-4b66-b053-e4d2d1c783fc	218fb4c0-cf10-46d9-9b02-4ce16ed00229	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	20	[3, 2, 0, 1]	{"id": "218fb4c0-cf10-46d9-9b02-4ce16ed00229", "marks": 1, "options": ["1/2", "0", "1/4", "1"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "easy", "explanation": "A fair coin has two equally likely outcomes", "option_images": null, "question_text": "What is the probability of getting heads on a fair coin toss?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
c9c26bd6-91c2-4624-9064-cc75aeb54f42	daac8f25-2982-4b66-b053-e4d2d1c783fc	cd593bb2-89b7-477f-a0ca-61725c1fb34f	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	21	[1, 0, 3, 2]	{"id": "cd593bb2-89b7-477f-a0ca-61725c1fb34f", "marks": 1, "options": ["1/4", "1/2", "1", "3/4"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "medium", "explanation": "Use the complement of getting no heads", "option_images": null, "question_text": "What is the probability of getting at least one head when two fair coins are tossed?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
20e74aec-b80d-40c2-a4b6-c82131728290	daac8f25-2982-4b66-b053-e4d2d1c783fc	7a39e6f7-1122-48a5-a69e-21c07a7627ce	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	22	[2, 3, 0, 1]	{"id": "7a39e6f7-1122-48a5-a69e-21c07a7627ce", "marks": 1, "options": ["x^2 + 9", "x^2 + 6x + 9", "x^2 + 3x + 9", "x^2 + 6x + 3"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": "Use (a + b)^2 = a^2 + 2ab + b^2", "option_images": null, "question_text": "Expand (x + 3)^2.", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
e5d36fa3-d433-47d6-96c7-ac3d95b74a48	daac8f25-2982-4b66-b053-e4d2d1c783fc	ef60efdd-9823-4570-9219-34bc0d49300e	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	23	[0, 3, 2, 1]	{"id": "ef60efdd-9823-4570-9219-34bc0d49300e", "marks": 1, "options": ["0", "1", "e", "ln 2"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "hard", "explanation": "The antiderivative is ln x, so ln e - ln 1 = 1", "option_images": null, "question_text": "Evaluate the integral from 1 to e of 1/x dx.", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
71e2bede-6f58-44fa-b78e-d6f03e9e8d77	daac8f25-2982-4b66-b053-e4d2d1c783fc	27a57025-3ef9-4c33-aa03-64b6b233ea8e	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	24	[3, 0, 2, 1]	{"id": "27a57025-3ef9-4c33-aa03-64b6b233ea8e", "marks": 1, "options": ["x = 0", "x = y", "y = 0", "x + y = 0"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "easy", "explanation": "Points on the x-axis have y = 0", "option_images": null, "question_text": "Which equation represents the x-axis?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
67052a29-321e-413f-af25-0bb0914fa6e1	daac8f25-2982-4b66-b053-e4d2d1c783fc	9e68b749-d586-40fe-b64e-a2ab3b19516f	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	25	[3, 2, 1, 0]	{"id": "9e68b749-d586-40fe-b64e-a2ab3b19516f", "marks": 1, "options": ["1/4", "3/4", "1", "1/2"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "medium", "explanation": "The favorable outcomes are HT and TH", "option_images": null, "question_text": "If two fair coins are tossed, what is the probability of getting exactly one head?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
c3b085d1-a455-44e4-a86f-e61551ccb75e	d6e3620b-8354-4d82-a5c8-978811ed5728	e4e4e355-5dc1-4e43-9a24-60c968845ed6	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	20	[0, 1, 3, 2]	\N
aee59bf7-7746-423d-adbe-6e269a159726	d6e3620b-8354-4d82-a5c8-978811ed5728	67cd62c9-ee36-46c1-9e62-bd19144307b9	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	21	[1, 0, 2, 3]	\N
bd81743d-d31c-4c68-8139-5de7555eadff	daac8f25-2982-4b66-b053-e4d2d1c783fc	c54271c9-5a92-4b96-bed6-53862f0a7fcc	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	26	[2, 0, 3, 1]	{"id": "c54271c9-5a92-4b96-bed6-53862f0a7fcc", "marks": 1, "options": ["x^2 + y^2 = 3", "x^2 + y^2 = 9", "x^2 + y^2 = 6", "x + y = 9"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "medium", "explanation": "A circle centered at the origin has equation x^2 + y^2 = r^2", "option_images": null, "question_text": "Which equation is the circle centered at the origin with radius 3?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
0aad5cd8-a0e8-468f-9be7-880d8ac03400	daac8f25-2982-4b66-b053-e4d2d1c783fc	4fdc905f-582a-4880-b97a-ab03f7a924dd	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	27	[2, 1, 3, 0]	{"id": "4fdc905f-582a-4880-b97a-ab03f7a924dd", "marks": 1, "options": ["6", "1", "4", "5"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "hard", "explanation": "The two solutions are 1 and 6", "option_images": null, "question_text": "Solve |2x - 7| = 5. Which is the larger solution?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
56788fca-fab1-4b62-8dc3-124a78b62955	daac8f25-2982-4b66-b053-e4d2d1c783fc	85f181e7-3e4c-49df-89d0-98d854126316	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	28	[2, 1, 0, 3]	{"id": "85f181e7-3e4c-49df-89d0-98d854126316", "marks": 1, "options": ["(sqrt(6) - sqrt(2))/4", "sqrt(3)/2", "(sqrt(6) + sqrt(2))/4", "1/2"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "hard", "explanation": "Use the angle addition formula", "option_images": null, "question_text": "What is sin 75 degrees?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
45000d18-89f0-43cd-9bfc-3c8690b2018e	daac8f25-2982-4b66-b053-e4d2d1c783fc	7710b2c7-58fa-4e86-bc48-f5f1da3e3da5	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	29	[2, 3, 0, 1]	{"id": "7710b2c7-58fa-4e86-bc48-f5f1da3e3da5", "marks": 1, "options": ["sin x + cos x = 1", "tan x = sin x cos x", "sec x = sin x", "sin^2 x + cos^2 x = 1"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "medium", "explanation": "This is the Pythagorean identity", "option_images": null, "question_text": "Which identity is always true?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
fc820047-4dba-413c-a218-643b44cdb318	daac8f25-2982-4b66-b053-e4d2d1c783fc	5393ef56-444a-407e-9f4f-063996681bdb	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	30	[0, 3, 1, 2]	{"id": "5393ef56-444a-407e-9f4f-063996681bdb", "marks": 1, "options": ["-1", "1", "0", "2"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "medium", "explanation": "Both values are 1, so the difference is 0", "option_images": null, "question_text": "What is sin 90 degrees - cos 0 degrees?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
a0c21b99-eb38-4d82-be55-fed9fc461f35	daac8f25-2982-4b66-b053-e4d2d1c783fc	d04ce9b1-15b1-4bb1-8753-e5dffd8bc3e2	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	31	[1, 0, 3, 2]	{"id": "d04ce9b1-15b1-4bb1-8753-e5dffd8bc3e2", "marks": 1, "options": ["4", "5", "12", "6"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "medium", "explanation": "Area = 1/2 x base x height", "option_images": null, "question_text": "What is the area of the triangle with vertices (0, 0), (4, 0), and (0, 3)?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
0984bfcb-65ff-4714-a5a6-eb266196d694	daac8f25-2982-4b66-b053-e4d2d1c783fc	3773211f-6a96-47c7-b6d5-7124ca15bd2a	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	32	[0, 1, 2, 3]	{"id": "3773211f-6a96-47c7-b6d5-7124ca15bd2a", "marks": 1, "options": ["2", "3", "4", "5"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "hard", "explanation": "Because 81 = 3^4, x + 1 = 4", "option_images": null, "question_text": "If 3^(x + 1) = 81, what is x?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
d3c9b696-74ee-46c8-baaf-7a7485688dfa	daac8f25-2982-4b66-b053-e4d2d1c783fc	d9ecd9dd-aa5c-4457-90d4-b2e8d26661f7	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	33	[1, 3, 2, 0]	{"id": "d9ecd9dd-aa5c-4457-90d4-b2e8d26661f7", "marks": 1, "options": ["0", "sqrt(2)", "1", "sqrt(3)"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "easy", "explanation": "At 45 degrees, sine and cosine are equal", "option_images": null, "question_text": "What is tan 45 degrees?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
a6a9f164-7768-4fc8-a4de-f308f0eab6a0	daac8f25-2982-4b66-b053-e4d2d1c783fc	47487c28-3d5e-44b6-a40e-c939fe00651b	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	34	[1, 3, 0, 2]	{"id": "47487c28-3d5e-44b6-a40e-c939fe00651b", "marks": 1, "options": ["1/sin x", "1/cos x", "sin x/cos x", "cos x/sin x"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "medium", "explanation": "Secant is the reciprocal of cosine", "option_images": null, "question_text": "sec x is equal to which expression?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
1794b66f-aef0-4c46-82c1-9f1573d97915	daac8f25-2982-4b66-b053-e4d2d1c783fc	0e1543db-2ba4-47fe-8da4-a71f466dd331	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	35	[2, 3, 1, 0]	{"id": "0e1543db-2ba4-47fe-8da4-a71f466dd331", "marks": 1, "options": ["0", "1", "2", "3"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "medium", "explanation": "Factor the numerator and cancel x - 1", "option_images": null, "question_text": "Evaluate lim (x^2 - 1)/(x - 1) as x approaches 1.", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
e2fdf60e-ef8c-4368-969b-c9b1c9dbf779	daac8f25-2982-4b66-b053-e4d2d1c783fc	f525ad0a-65c3-4f8e-be97-3d65a44b80be	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	36	[3, 1, 0, 2]	{"id": "f525ad0a-65c3-4f8e-be97-3d65a44b80be", "marks": 1, "options": ["5/9", "7/9", "8/9", "1/9"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "hard", "explanation": "Use cos 2theta = 1 - 2sin^2 theta", "option_images": null, "question_text": "If sin theta = 1/3 and theta is acute, what is cos 2theta?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
5cdb2b36-79c3-45aa-a09b-901e34020892	daac8f25-2982-4b66-b053-e4d2d1c783fc	a6e11d00-ea90-4cb6-a2fd-88db3dc36f15	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	37	[2, 1, 0, 3]	{"id": "a6e11d00-ea90-4cb6-a2fd-88db3dc36f15", "marks": 1, "options": ["1/2", "0", "sqrt(3)/2", "1"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "easy", "explanation": "sin 30 degrees equals one-half", "option_images": null, "question_text": "What is sin 30 degrees?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
155575f5-f039-4523-a69a-980898ab4659	daac8f25-2982-4b66-b053-e4d2d1c783fc	a84366a8-692e-4ee7-98d4-5672b2aec7c8	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	38	[1, 0, 2, 3]	{"id": "a84366a8-692e-4ee7-98d4-5672b2aec7c8", "marks": 1, "options": ["1/52", "1/13", "1/4", "4/13"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "medium", "explanation": "There are 4 aces in 52 cards", "option_images": null, "question_text": "What is the probability of drawing an ace from a standard 52-card deck?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
e7237943-bc27-42e4-9fe4-c4f04f926ad5	d6e3620b-8354-4d82-a5c8-978811ed5728	d9f16d2a-32cb-4fe4-8458-6babcfc24f92	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	22	[1, 0, 3, 2]	\N
1c36b6c4-7304-4b28-ac45-4a6fd3ef30ba	daac8f25-2982-4b66-b053-e4d2d1c783fc	c5386a27-4225-433e-8a5c-152ed1a59b20	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	39	[0, 2, 3, 1]	{"id": "c5386a27-4225-433e-8a5c-152ed1a59b20", "marks": 1, "options": ["y - 2 = 3(x - 1)", "y + 2 = 3(x - 1)", "y - 1 = 2(x - 3)", "y = 3x + 1"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "hard", "explanation": "Use point-slope form", "option_images": null, "question_text": "Which equation is the line through (1, 2) with slope 3?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
84afdf92-fd7c-4f8e-9f2c-99230957694c	daac8f25-2982-4b66-b053-e4d2d1c783fc	887929bf-45c0-42f3-b88b-960c0ea69bc3	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	40	[2, 0, 3, 1]	{"id": "887929bf-45c0-42f3-b88b-960c0ea69bc3", "marks": 1, "options": ["9", "10", "15", "11"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": "Substitute x = 5 into the function", "option_images": null, "question_text": "If f(x) = 3x - 4, what is f(5)?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
dcc707f2-6ff1-4806-b622-4a083deca381	daac8f25-2982-4b66-b053-e4d2d1c783fc	cdbf324f-990e-4759-8715-01cf087eb2c0	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	41	[2, 0, 3, 1]	{"id": "cdbf324f-990e-4759-8715-01cf087eb2c0", "marks": 1, "options": ["2", "3", "4", "5"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "easy", "explanation": "The vertical distance is 5 - 2", "option_images": null, "question_text": "What is the distance between (1, 2) and (1, 5)?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
b4a3a31c-eeaa-480f-acb3-ee11faef7baa	daac8f25-2982-4b66-b053-e4d2d1c783fc	17a23a4e-e918-49f1-8d37-0bb6b17b0258	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	42	[2, 0, 1, 3]	{"id": "17a23a4e-e918-49f1-8d37-0bb6b17b0258", "marks": 1, "options": ["1", "0", "2", "4"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "easy", "explanation": "Slope is rise over run = 2/2", "option_images": null, "question_text": "What is the slope of the line through (0, 0) and (2, 2)?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
28ea190b-f016-4868-aaef-c7cd68bb99b5	daac8f25-2982-4b66-b053-e4d2d1c783fc	16b2d359-e7ec-41cb-8da3-f96fc44109d8	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	43	[2, 0, 3, 1]	{"id": "16b2d359-e7ec-41cb-8da3-f96fc44109d8", "marks": 1, "options": ["0.3", "0.8", "0.5", "1.1"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "hard", "explanation": "Add the probabilities and subtract the overlap", "option_images": null, "question_text": "If P(A) = 0.6 and P(B) = 0.5 and A and B are independent, what is P(A or B)?", "correct_answer": 1, "negative_marks": 0, "question_image_url": null}
13ba58e2-9132-48ca-b52e-1a58bd790c0c	daac8f25-2982-4b66-b053-e4d2d1c783fc	87e31772-f018-4825-9fa8-e80c79a3f7c2	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	44	[2, 1, 0, 3]	{"id": "87e31772-f018-4825-9fa8-e80c79a3f7c2", "marks": 1, "options": ["4", "6", "5", "7"], "topic_id": "6985fef8-92cf-47a8-aad8-88754030af2c", "difficulty": "hard", "explanation": "Use the distance formula", "option_images": null, "question_text": "What is the distance from the point (3, 4) to the origin?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
82e5f1c9-989e-4a7d-abc4-cf0ddc58cfb7	daac8f25-2982-4b66-b053-e4d2d1c783fc	48ff2f62-05d2-4cec-bb51-e5396bfbe13f	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	45	[3, 2, 1, 0]	{"id": "48ff2f62-05d2-4cec-bb51-e5396bfbe13f", "marks": 1, "options": ["0", "n", "1", "Depends on the event"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "easy", "explanation": "All outcomes in a complete sample space total 1", "option_images": null, "question_text": "What is the sum of probabilities of all outcomes in a sample space?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
8eabbecf-6a51-4b8e-8d9e-c5532a15c153	daac8f25-2982-4b66-b053-e4d2d1c783fc	436d20d2-2e1f-42e2-b4cf-c06445eea5d4	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	46	[1, 2, 3, 0]	{"id": "436d20d2-2e1f-42e2-b4cf-c06445eea5d4", "marks": 1, "options": ["4", "5", "8", "6"], "topic_id": "d0cfb7df-7497-4408-b39f-7b0e37dad9e9", "difficulty": "medium", "explanation": "Adding the equations gives 2x = 12", "option_images": null, "question_text": "If x + y = 10 and x - y = 2, what is x?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
4a26fab4-ceeb-468f-921d-64600f8a2fb6	daac8f25-2982-4b66-b053-e4d2d1c783fc	171cbd6b-a9c4-4210-8f72-467cea0b80d9	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	47	[1, 2, 3, 0]	{"id": "171cbd6b-a9c4-4210-8f72-467cea0b80d9", "marks": 1, "options": ["P(A) + P(B)", "P(A) - P(B)", "P(A)P(B)", "P(A)/P(B)"], "topic_id": "965b5429-8685-4cc9-a7be-42858adcd165", "difficulty": "medium", "explanation": "Independent events multiply", "option_images": null, "question_text": "For independent events A and B, what is P(A and B)?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
b75d2480-06ee-45ff-a8e8-0d1bf7d0909f	daac8f25-2982-4b66-b053-e4d2d1c783fc	59b39e86-2deb-4625-beef-09c39c0f54a6	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	48	[1, 3, 0, 2]	{"id": "59b39e86-2deb-4625-beef-09c39c0f54a6", "marks": 1, "options": ["30 degrees", "15 degrees", "45 degrees", "60 degrees"], "topic_id": "8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c", "difficulty": "hard", "explanation": "Then sin x = 1/2", "option_images": null, "question_text": "If 2 sin x = 1 and x is acute, what is x?", "correct_answer": 0, "negative_marks": 0, "question_image_url": null}
527a133a-a928-4cac-85ec-dd15ed023527	daac8f25-2982-4b66-b053-e4d2d1c783fc	612e0882-184e-477d-9b07-68aebaf8f9db	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	49	[0, 1, 2, 3]	{"id": "612e0882-184e-477d-9b07-68aebaf8f9db", "marks": 1, "options": ["1", "2", "3", "4"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "easy", "explanation": "In y = mx + c, the slope is m", "option_images": null, "question_text": "What is the slope of the line y = 3x + 1?", "correct_answer": 2, "negative_marks": 0, "question_image_url": null}
c5fdcddf-3adb-41ab-a844-a2bdf60054c4	daac8f25-2982-4b66-b053-e4d2d1c783fc	3a0136aa-5a28-41c8-8a9d-0ca85988d517	\N	f	0.00	0	f	f	2026-09-02 06:27:51.898+00	50	[3, 0, 1, 2]	{"id": "3a0136aa-5a28-41c8-8a9d-0ca85988d517", "marks": 1, "options": ["-sin x", "-cos x", "tan x", "cos x"], "topic_id": "68d8f6be-90c5-4893-84f0-afe6b5270631", "difficulty": "medium", "explanation": "The derivative of sin x is cos x", "option_images": null, "question_text": "What is the derivative of sin x?", "correct_answer": 3, "negative_marks": 0, "question_image_url": null}
98db1fdc-c14e-4503-a1d4-c0b3e821f2ae	d6e3620b-8354-4d82-a5c8-978811ed5728	94115216-7cd1-4fba-b659-9fac56268caf	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	25	[1, 0, 3, 2]	\N
bc67ae2c-ff13-4e28-a905-6dbed78a77c6	d6e3620b-8354-4d82-a5c8-978811ed5728	41bece5e-7018-4191-a9aa-9afc340831eb	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	26	[3, 1, 2, 0]	\N
b30c4ac6-e1cd-4506-908a-cdd97aec0609	d6e3620b-8354-4d82-a5c8-978811ed5728	05c23db6-3fbc-442c-997b-a9d191581523	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	27	[0, 3, 2, 1]	\N
50c9f8b2-2017-42cd-8012-20506dfd981b	d6e3620b-8354-4d82-a5c8-978811ed5728	1b10c6ea-dd08-44cb-9f21-5d6487feb6b8	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	28	[1, 2, 0, 3]	\N
ada71153-cf05-4959-bf74-6a453070fcf4	d6e3620b-8354-4d82-a5c8-978811ed5728	01f329bc-9738-45e2-a793-55bac1b4c93d	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	29	[3, 2, 0, 1]	\N
ffc0bdd0-ccd3-49b3-8c4f-3a17ae928a41	d6e3620b-8354-4d82-a5c8-978811ed5728	dea6782e-a1a2-4507-a5f6-28b44adea81c	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	30	[1, 2, 0, 3]	\N
de7ee1bb-aec8-4a48-89f3-f9d522bff663	d6e3620b-8354-4d82-a5c8-978811ed5728	72d87f01-c4c8-4b10-93c1-d85a8bb9a376	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	31	[3, 1, 2, 0]	\N
617193b6-e262-4aa3-8d01-027f64f23141	d6e3620b-8354-4d82-a5c8-978811ed5728	8af020b8-2080-4042-b34f-94bedb9c81ae	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	32	[3, 1, 2, 0]	\N
a5c8b16d-7db0-4192-9b3a-199be870576a	d6e3620b-8354-4d82-a5c8-978811ed5728	02a47202-943f-4d7e-87b1-82476549a2d0	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	33	[0, 1, 3, 2]	\N
16fef318-e0c9-49bc-b582-53ce051811a9	d6e3620b-8354-4d82-a5c8-978811ed5728	3a9a94a7-4485-4e8a-9bc2-da0dbd919745	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	34	[1, 2, 3, 0]	\N
be826c4c-6c9c-4165-8a82-1b496e2a2a57	d6e3620b-8354-4d82-a5c8-978811ed5728	d216b6e5-4cda-4b0b-87db-ee5fcee52bc6	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	35	[1, 2, 3, 0]	\N
fbd52ac2-ce76-4f5b-a23d-88403fad4fa3	d6e3620b-8354-4d82-a5c8-978811ed5728	84324e80-a6c6-43b7-9110-717aa7dfd54d	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	36	[1, 2, 0, 3]	\N
0e016ca6-aafa-4449-bce3-b54b2af53ed1	d6e3620b-8354-4d82-a5c8-978811ed5728	b82dee4e-1452-42b6-bc65-b31e9237555b	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	37	[1, 2, 3, 0]	\N
d4ba1af6-3b1c-4b49-b2ff-69367ae21bdf	d6e3620b-8354-4d82-a5c8-978811ed5728	69bd9912-cc2d-4359-9e0e-96c45f2a2dff	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	38	[3, 0, 1, 2]	\N
bb496a4e-2716-411d-8ed4-0caac4f68a60	d6e3620b-8354-4d82-a5c8-978811ed5728	e7fe4ff2-0545-4d40-9dfe-10866fda3a08	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	39	[3, 1, 0, 2]	\N
c43d18a4-52a8-4b20-8842-14ed5a54e04d	d6e3620b-8354-4d82-a5c8-978811ed5728	7b8090a5-e005-4e1a-ac67-ae77218f6daa	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	40	[1, 0, 3, 2]	\N
04877ecd-2dcc-4525-9832-fde377d90c61	d6e3620b-8354-4d82-a5c8-978811ed5728	da565975-12e3-46ed-8bd9-2707a52994d0	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	41	[0, 2, 1, 3]	\N
bee737ae-80ec-4f37-a466-feb4d38bb44b	d6e3620b-8354-4d82-a5c8-978811ed5728	b96e6c5a-fb1d-40ae-b4df-536df551a675	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	42	[0, 3, 2, 1]	\N
97eb0d9f-2132-4d89-95ea-a202424d9ccc	d6e3620b-8354-4d82-a5c8-978811ed5728	43d2aa04-f535-43e7-ad9b-eb89bada3899	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	43	[2, 3, 0, 1]	\N
3e0bc481-ed2f-441b-a921-c09f1a1b44f3	d6e3620b-8354-4d82-a5c8-978811ed5728	3759f68d-fa81-475f-984c-e072d932ef86	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	44	[0, 2, 3, 1]	\N
8568986c-c63a-450b-be6c-487dc2f15734	d6e3620b-8354-4d82-a5c8-978811ed5728	c0d43e2c-fc10-4cde-8b0e-e4bb6c465a03	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	45	[3, 2, 0, 1]	\N
39fb1b41-a190-492e-92e3-8a0291713459	d6e3620b-8354-4d82-a5c8-978811ed5728	1f699e70-db3a-4c35-aafd-f1275ee33413	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	46	[3, 1, 2, 0]	\N
65a32fd4-a22b-4302-9e0a-9e8019b5ab6b	d6e3620b-8354-4d82-a5c8-978811ed5728	a154c20e-ac2c-4c9b-a267-265c8bc17b17	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	47	[1, 2, 3, 0]	\N
b17e331a-59f3-4e56-b066-4fe195a92178	d6e3620b-8354-4d82-a5c8-978811ed5728	d2754d31-7f22-491d-a744-97d107a58206	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	48	[2, 1, 3, 0]	\N
43ff82a6-faad-4ff1-8cd1-0fb79fece558	d6e3620b-8354-4d82-a5c8-978811ed5728	feddce35-0aa8-4e17-a0f1-79ef4778e2f3	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	49	[1, 0, 3, 2]	\N
4a25e62d-f068-4935-843a-a36f057d0f37	d6e3620b-8354-4d82-a5c8-978811ed5728	c14e9586-5eea-42a6-a951-aca55ce75b68	\N	f	0.00	0	f	f	2026-09-03 03:30:03.579+00	50	[1, 3, 0, 2]	\N
b6990bdc-63ce-4d12-8842-aebc06971245	04d0b31a-ad1c-4d2b-939c-443967e6c63b	449df994-b364-434f-abeb-51a02023d79f	1	t	1.00	6	f	t	2026-09-03 03:33:45.267+00	4	[3, 1, 0, 2]	\N
2d806b9c-a6e0-4750-864d-8d4734412f91	04d0b31a-ad1c-4d2b-939c-443967e6c63b	c0d43e2c-fc10-4cde-8b0e-e4bb6c465a03	2	t	1.00	6	f	t	2026-09-03 03:33:45.41+00	5	[2, 0, 1, 3]	\N
a1a46f0b-cfc4-4d59-a55c-ce819ddc64e1	04d0b31a-ad1c-4d2b-939c-443967e6c63b	d9f16d2a-32cb-4fe4-8458-6babcfc24f92	0	t	1.00	10	f	t	2026-09-03 03:33:45.592+00	6	[2, 0, 1, 3]	\N
d2d54ddc-cfd7-4bde-acd3-f75f15ef0b78	04d0b31a-ad1c-4d2b-939c-443967e6c63b	e4e4e355-5dc1-4e43-9a24-60c968845ed6	0	t	1.00	7	f	t	2026-09-03 03:33:45.797+00	7	[2, 1, 3, 0]	\N
28d10e35-b923-463d-8b7a-8a9d1791e972	04d0b31a-ad1c-4d2b-939c-443967e6c63b	3759f68d-fa81-475f-984c-e072d932ef86	2	t	1.00	7	f	t	2026-09-03 03:33:45.908+00	8	[0, 1, 3, 2]	\N
eb9a8639-193b-44e9-86c7-64e6858fd446	04d0b31a-ad1c-4d2b-939c-443967e6c63b	72d87f01-c4c8-4b10-93c1-d85a8bb9a376	1	t	1.00	34	f	t	2026-09-03 03:33:46.105+00	9	[1, 2, 0, 3]	\N
000fae52-3450-445d-b3d4-3cbcf680da54	04d0b31a-ad1c-4d2b-939c-443967e6c63b	f1efce00-8f4b-4b71-b931-bc669b097769	1	t	1.00	7	f	t	2026-09-03 03:33:46.309+00	10	[3, 2, 0, 1]	\N
5f4f932a-6805-45d8-9389-b47f9ee45569	04d0b31a-ad1c-4d2b-939c-443967e6c63b	9f0d50e3-95ef-4f6d-9f06-3e7c941f9a55	1	f	0.00	8	f	t	2026-09-03 03:33:46.52+00	11	[3, 1, 2, 0]	\N
e54fc13c-9751-4e4a-bb60-f6a2c512e5aa	04d0b31a-ad1c-4d2b-939c-443967e6c63b	feddce35-0aa8-4e17-a0f1-79ef4778e2f3	2	t	1.00	8	f	t	2026-09-03 03:33:46.718+00	12	[0, 1, 3, 2]	\N
ef0aff12-b059-41d3-94b0-8aeb35034b17	04d0b31a-ad1c-4d2b-939c-443967e6c63b	7b8090a5-e005-4e1a-ac67-ae77218f6daa	1	t	1.00	5	f	t	2026-09-03 03:33:46.924+00	13	[0, 1, 2, 3]	\N
2fade51f-faca-48f2-b09b-16c81c1304f2	04d0b31a-ad1c-4d2b-939c-443967e6c63b	8af020b8-2080-4042-b34f-94bedb9c81ae	3	t	1.00	7	f	t	2026-09-03 03:33:47.128+00	14	[3, 2, 1, 0]	\N
7fcbe250-3a16-4b47-bb61-3f7ebd7e55ff	04d0b31a-ad1c-4d2b-939c-443967e6c63b	da565975-12e3-46ed-8bd9-2707a52994d0	2	f	0.00	9	f	t	2026-09-03 03:33:47.333+00	15	[1, 2, 3, 0]	\N
558daf13-badf-4e50-af45-02ad8a31006b	04d0b31a-ad1c-4d2b-939c-443967e6c63b	a154c20e-ac2c-4c9b-a267-265c8bc17b17	1	t	1.00	7	f	t	2026-09-03 03:33:47.508+00	16	[0, 2, 1, 3]	\N
a2db10cc-cc8e-4016-a534-d1a4873e2ed3	04d0b31a-ad1c-4d2b-939c-443967e6c63b	fd6126a1-33a0-418c-9845-717b18ac5614	1	t	1.00	7	f	t	2026-09-03 03:33:47.743+00	17	[1, 0, 3, 2]	\N
8e9b84e0-aa94-4953-af2f-1321275596d9	04d0b31a-ad1c-4d2b-939c-443967e6c63b	85fd2adb-7e29-4600-8954-9bdff1cd76a4	2	t	1.00	6	f	t	2026-09-03 03:33:47.947+00	18	[2, 3, 1, 0]	\N
7ea0b367-4ca6-46b8-b3a8-04464614ef1e	04d0b31a-ad1c-4d2b-939c-443967e6c63b	0b07005f-2713-4ab0-9c58-8d48bedbe118	2	f	0.00	10	f	t	2026-09-03 03:33:48.033+00	19	[3, 2, 0, 1]	\N
307dab87-3d59-4493-85b1-57aa97bbae3f	04d0b31a-ad1c-4d2b-939c-443967e6c63b	2a2693a6-3245-4eda-a7ba-44dd65a5ca62	1	t	1.00	12	f	t	2026-09-03 03:33:48.259+00	20	[3, 1, 2, 0]	\N
e0082478-432e-4051-a0c5-4a0565f5fab3	04d0b31a-ad1c-4d2b-939c-443967e6c63b	f519a0dd-fd04-49cf-ad19-cf56cf5045dc	\N	f	0.00	0	f	f	2026-09-03 03:33:48.427+00	21	[0, 1, 2, 3]	\N
f33d03ea-6191-4974-8139-220ec4585532	04d0b31a-ad1c-4d2b-939c-443967e6c63b	d216b6e5-4cda-4b0b-87db-ee5fcee52bc6	\N	f	0.00	0	f	f	2026-09-03 03:33:48.67+00	22	[3, 0, 1, 2]	\N
15fcf809-12fb-4fac-a558-c01e8aa9e5db	04d0b31a-ad1c-4d2b-939c-443967e6c63b	dea6782e-a1a2-4507-a5f6-28b44adea81c	\N	f	0.00	0	f	f	2026-09-03 03:33:48.869+00	23	[0, 2, 3, 1]	\N
f2a686ed-777a-4df7-9b98-bed693aad69f	04d0b31a-ad1c-4d2b-939c-443967e6c63b	b82dee4e-1452-42b6-bc65-b31e9237555b	\N	f	0.00	0	f	f	2026-09-03 03:33:49.074+00	24	[0, 2, 1, 3]	\N
142d2a73-4c40-443c-879b-5bae2881ff9c	04d0b31a-ad1c-4d2b-939c-443967e6c63b	01f329bc-9738-45e2-a793-55bac1b4c93d	\N	f	0.00	0	f	f	2026-09-03 03:33:49.279+00	25	[2, 1, 3, 0]	\N
7fade9a2-00ae-4ab4-8dac-422ba6961ea5	04d0b31a-ad1c-4d2b-939c-443967e6c63b	d2754d31-7f22-491d-a744-97d107a58206	\N	f	0.00	0	f	f	2026-09-03 03:33:49.483+00	26	[0, 3, 2, 1]	\N
2cbb296f-2a99-4f77-8fab-a713a6d7e0d2	04d0b31a-ad1c-4d2b-939c-443967e6c63b	43d2aa04-f535-43e7-ad9b-eb89bada3899	\N	f	0.00	0	f	f	2026-09-03 03:33:49.585+00	27	[2, 0, 3, 1]	\N
ba070b7c-bbe7-4963-80ec-b9f4737274e0	04d0b31a-ad1c-4d2b-939c-443967e6c63b	c14e9586-5eea-42a6-a951-aca55ce75b68	\N	f	0.00	0	f	f	2026-09-03 03:33:49.679+00	28	[2, 3, 0, 1]	\N
a9fc8c0b-7f51-45fd-8f28-ca159d31d4d0	04d0b31a-ad1c-4d2b-939c-443967e6c63b	69bd9912-cc2d-4359-9e0e-96c45f2a2dff	\N	f	0.00	0	f	f	2026-09-03 03:33:49.893+00	29	[1, 2, 0, 3]	\N
3d7f8f1b-94e9-40ac-8280-da71e03ef720	04d0b31a-ad1c-4d2b-939c-443967e6c63b	02a47202-943f-4d7e-87b1-82476549a2d0	\N	f	0.00	0	f	f	2026-09-03 03:33:50.097+00	30	[2, 3, 0, 1]	\N
ed4dbbd1-9551-4a70-ba16-c6e7d5c2381a	04d0b31a-ad1c-4d2b-939c-443967e6c63b	cc45a1f5-a62b-45b1-b4ae-bd2a5f5f7553	\N	f	0.00	0	f	f	2026-09-03 03:33:50.232+00	31	[3, 1, 0, 2]	\N
ce3939ca-f7ea-4088-b9be-72332f2ecf80	04d0b31a-ad1c-4d2b-939c-443967e6c63b	94115216-7cd1-4fba-b659-9fac56268caf	\N	f	0.00	0	f	f	2026-09-03 03:33:50.507+00	32	[1, 2, 3, 0]	\N
5dff5bf1-e36c-4449-b853-7490d4ff99d3	04d0b31a-ad1c-4d2b-939c-443967e6c63b	d69919b3-9d08-49b1-982a-b777d37bc6bf	\N	f	0.00	0	f	f	2026-09-03 03:33:50.713+00	33	[0, 2, 1, 3]	\N
8b3db75b-a01f-4818-a76c-b33883460545	04d0b31a-ad1c-4d2b-939c-443967e6c63b	aab37b88-ea4a-445a-8e91-0fbe809eea80	\N	f	0.00	0	f	f	2026-09-03 03:33:50.917+00	34	[1, 2, 3, 0]	\N
ec0ae537-55e7-4efb-9c86-398605e43743	04d0b31a-ad1c-4d2b-939c-443967e6c63b	800c6667-7c18-479a-bc6a-1ecf92332133	\N	f	0.00	0	f	f	2026-09-03 03:33:51.122+00	35	[0, 2, 3, 1]	\N
893f7c05-7664-4f86-ad94-d8fe8dc981d3	04d0b31a-ad1c-4d2b-939c-443967e6c63b	1b10c6ea-dd08-44cb-9f21-5d6487feb6b8	\N	f	0.00	0	f	f	2026-09-03 03:33:51.216+00	36	[2, 0, 3, 1]	\N
37803f9e-4734-4c1e-b8af-1e19d779417b	04d0b31a-ad1c-4d2b-939c-443967e6c63b	42b35a2c-82ad-4261-a23d-eb309b1102d8	\N	f	0.00	0	f	f	2026-09-03 03:33:51.429+00	37	[0, 2, 3, 1]	\N
d8baa79e-6a8f-470e-91c7-b9cd25faeeb8	04d0b31a-ad1c-4d2b-939c-443967e6c63b	3a9a94a7-4485-4e8a-9bc2-da0dbd919745	\N	f	0.00	0	f	f	2026-09-03 03:33:51.634+00	38	[1, 0, 2, 3]	\N
77aa3551-e6f5-4bc8-b641-97f6fb67a1a1	04d0b31a-ad1c-4d2b-939c-443967e6c63b	a8e99c3e-4cda-4932-9679-7491977a2aab	\N	f	0.00	0	f	f	2026-09-03 03:33:51.839+00	39	[2, 1, 3, 0]	\N
cb40c6e1-18ca-4227-8dad-8566104d784d	04d0b31a-ad1c-4d2b-939c-443967e6c63b	b96e6c5a-fb1d-40ae-b4df-536df551a675	\N	f	0.00	0	f	f	2026-09-03 03:33:52.044+00	40	[0, 2, 3, 1]	\N
4a02cbbc-9bf0-48dc-a7ff-e5b574bbb410	04d0b31a-ad1c-4d2b-939c-443967e6c63b	e7fe4ff2-0545-4d40-9dfe-10866fda3a08	\N	f	0.00	0	f	f	2026-09-03 03:33:52.249+00	41	[1, 2, 0, 3]	\N
04483257-9937-402c-bb7d-380deef80486	04d0b31a-ad1c-4d2b-939c-443967e6c63b	05c23db6-3fbc-442c-997b-a9d191581523	\N	f	0.00	0	f	f	2026-09-03 03:33:52.452+00	42	[3, 0, 2, 1]	\N
9a0cd9d9-256e-4524-b144-af50fd946c49	04d0b31a-ad1c-4d2b-939c-443967e6c63b	41bece5e-7018-4191-a9aa-9afc340831eb	\N	f	0.00	0	f	f	2026-09-03 03:33:52.862+00	44	[3, 1, 2, 0]	\N
9d9b3260-204c-4f64-9efb-c64a0e2f20ad	04d0b31a-ad1c-4d2b-939c-443967e6c63b	0d3d1eeb-7d8f-4662-9977-94864f4040c9	\N	f	0.00	0	f	f	2026-09-03 03:33:53.067+00	45	[1, 3, 0, 2]	\N
429b0282-8530-4ec2-86f7-74b97a20c104	04d0b31a-ad1c-4d2b-939c-443967e6c63b	3afe1a9d-4d26-4000-bc1b-51133a302f66	\N	f	0.00	0	f	f	2026-09-03 03:33:53.376+00	47	[0, 2, 1, 3]	\N
1d018c3e-c2fc-42ba-b67c-591ee821917c	04d0b31a-ad1c-4d2b-939c-443967e6c63b	80310cf0-3dac-418d-846f-664b177ae74e	\N	f	0.00	0	f	f	2026-09-03 03:33:53.581+00	48	[3, 2, 0, 1]	\N
47602c99-6259-47b4-9ffa-02cf3cb2a262	04d0b31a-ad1c-4d2b-939c-443967e6c63b	917824ad-a2ad-4a71-8362-9800c11f2195	\N	f	0.00	0	f	f	2026-09-03 03:33:53.675+00	49	[1, 3, 0, 2]	\N
55255c02-9ce9-49ef-98d1-10b1d1c1873d	04d0b31a-ad1c-4d2b-939c-443967e6c63b	84324e80-a6c6-43b7-9110-717aa7dfd54d	1	t	1.00	41	f	t	2026-09-03 03:33:44.602+00	1	[3, 2, 0, 1]	\N
45110cf7-eaef-454f-89e4-d0e479a94def	04d0b31a-ad1c-4d2b-939c-443967e6c63b	7aa05be2-ce64-429c-a9d5-17c8a20e0090	0	t	1.00	4	f	t	2026-09-03 03:33:44.875+00	2	[3, 0, 1, 2]	\N
6ea658bd-cef5-4fa3-8759-51cf655d09b3	04d0b31a-ad1c-4d2b-939c-443967e6c63b	67cd62c9-ee36-46c1-9e62-bd19144307b9	0	t	1.00	7	f	t	2026-09-03 03:33:45.183+00	3	[2, 1, 0, 3]	\N
5697112d-825f-4c2c-bfc3-6db4dd433ab7	04d0b31a-ad1c-4d2b-939c-443967e6c63b	e9d55130-9b49-4ed6-860c-9648b790a309	\N	f	0.00	0	f	f	2026-09-03 03:33:52.633+00	43	[3, 0, 1, 2]	\N
3cab717f-4023-40ec-bb97-e2ef870089bb	04d0b31a-ad1c-4d2b-939c-443967e6c63b	1f699e70-db3a-4c35-aafd-f1275ee33413	\N	f	0.00	0	f	f	2026-09-03 03:33:53.17+00	46	[2, 1, 0, 3]	\N
7b4edd66-4245-4ce3-8eb3-4d95bdbb197c	04d0b31a-ad1c-4d2b-939c-443967e6c63b	1cb593e7-b238-46e7-8640-41efd6e572a7	\N	f	0.00	0	f	f	2026-09-03 03:33:53.934+00	50	[1, 0, 2, 3]	\N
\.


--
-- TOC entry 5073 (class 0 OID 17708)
-- Dependencies: 361
-- Data for Name: student_badges; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.student_badges (user_id, badge_id, earned_at) FROM stdin;
97ad6c7c-6f13-4266-8241-a72deab8f86a	88f2e7e6-1359-45c0-92c3-23fd74769ada	2026-08-27 09:29:48.642224+00
97ad6c7c-6f13-4266-8241-a72deab8f86a	e1cf76f1-f1ae-464f-a4ba-ece64deb6bfd	2026-08-27 09:29:48.642224+00
97ad6c7c-6f13-4266-8241-a72deab8f86a	5e746f2d-1545-4e44-ad2f-2d0e0266ea1b	2026-08-27 09:29:48.642224+00
97ad6c7c-6f13-4266-8241-a72deab8f86a	84c5ce19-e0e5-4e96-8902-fe49aecef08c	2026-08-27 09:29:48.642224+00
\.


--
-- TOC entry 5070 (class 0 OID 17665)
-- Dependencies: 358
-- Data for Name: student_stats; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.student_stats (user_id, total_xp, quizzes_completed, streak_days, last_quiz_date, current_level, longest_streak, last_activity_date, questions_solved, correct_answers, total_response_seconds, perfect_scores) FROM stdin;
d5ae212b-9a24-404c-a312-804a6572933e	0	0	0	\N	1	0	\N	0	0	0	0
15068f40-e70b-44b1-82eb-28b9f885db37	0	0	0	\N	1	0	\N	0	0	0	0
f19320d2-8560-46e4-9093-a1f9b2d35647	0	0	0	\N	1	0	\N	0	0	0	0
97ad6c7c-6f13-4266-8241-a72deab8f86a	235	2	2	2026-08-28 11:20:34.779048+00	2	2	2026-08-28	49	12	78	0
ce0fb583-4c15-43a5-b8af-e2b941589f86	187	1	1	2026-09-03 03:33:56.96+00	1	0	\N	0	0	0	0
456f5f52-36f2-4347-b9f7-f435927c9779	0	0	0	\N	1	0	\N	0	0	0	0
\.


--
-- TOC entry 5076 (class 0 OID 18030)
-- Dependencies: 364
-- Data for Name: student_topic_ability; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.student_topic_ability (id, user_id, topic_id, ability_score, status, attempted, accuracy, recent_trend, updated_at) FROM stdin;
33733b54-9dce-4943-b56f-ac829f70402d	97ad6c7c-6f13-4266-8241-a72deab8f86a	d0cfb7df-7497-4408-b39f-7b0e37dad9e9	25.46	Critical	10	10.00	-20.00	2026-09-02 06:30:42.259+00
5ba0fcc6-2cd0-4cee-b121-7bfe2243934e	97ad6c7c-6f13-4266-8241-a72deab8f86a	8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	33.55	Critical	10	20.00	0.00	2026-09-02 06:30:42.304+00
2b743936-0ceb-46f9-9962-69a75328aa89	97ad6c7c-6f13-4266-8241-a72deab8f86a	6985fef8-92cf-47a8-aad8-88754030af2c	43.22	Weak	10	30.00	20.00	2026-09-02 06:30:42.344+00
e60212eb-3445-4bdb-b8d0-69e7b7756d69	97ad6c7c-6f13-4266-8241-a72deab8f86a	965b5429-8685-4cc9-a7be-42858adcd165	49.53	Weak	10	40.00	0.00	2026-09-02 06:30:42.389+00
77724458-28e1-4842-b147-abab0c70b988	97ad6c7c-6f13-4266-8241-a72deab8f86a	68d8f6be-90c5-4893-84f0-afe6b5270631	31.86	Critical	9	22.22	-40.00	2026-09-02 06:30:42.435+00
73184741-0219-4618-8874-022ff39e19c6	97ad6c7c-6f13-4266-8241-a72deab8f86a	b6f7da6a-8454-4074-9713-ec2cfac0827a	41.10	Weak	10	10.00	0.00	2026-08-28 06:08:55.424+00
\.


--
-- TOC entry 5063 (class 0 OID 17518)
-- Dependencies: 351
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subjects (id, name, created_at, is_active, updated_at) FROM stdin;
fbff0f41-fe5f-42e7-aafa-d85df02568e0	Mathematics	2026-08-18 05:57:42.719806+00	t	2026-08-27 08:41:05.691727+00
36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	Physics	2026-08-18 05:57:42.719806+00	t	2026-08-27 08:41:05.691727+00
9481ac62-4ea8-48a2-8776-33ed020858bb	Chemistry	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
bdc56824-3354-4558-963e-94033af7162c	Biology	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
0516b2da-3ff8-4945-9c83-6850a4573fee	Computer Science	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	Data Structures and Algorithms	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
0e626538-e950-4f50-a32e-ff8c38cb505f	Database Management Systems	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	Operating Systems	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
d64b1e2a-d2fd-46e3-ad60-f6187df260fa	Aptitude and Reasoning	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
1f77c53e-73f4-40e1-bf17-3d005994b9b4	English	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
\.


--
-- TOC entry 5064 (class 0 OID 17529)
-- Dependencies: 352
-- Data for Name: topics; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.topics (id, subject_id, name, created_at, is_active, updated_at) FROM stdin;
d0cfb7df-7497-4408-b39f-7b0e37dad9e9	fbff0f41-fe5f-42e7-aafa-d85df02568e0	Algebra	2026-08-18 05:57:42.719806+00	t	2026-08-27 08:41:05.691727+00
68d8f6be-90c5-4893-84f0-afe6b5270631	fbff0f41-fe5f-42e7-aafa-d85df02568e0	Calculus	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
8e7a91eb-bf30-47fa-bd0e-bf95fcf5176c	fbff0f41-fe5f-42e7-aafa-d85df02568e0	Trigonometry	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
6985fef8-92cf-47a8-aad8-88754030af2c	fbff0f41-fe5f-42e7-aafa-d85df02568e0	Coordinate Geometry	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
965b5429-8685-4cc9-a7be-42858adcd165	fbff0f41-fe5f-42e7-aafa-d85df02568e0	Probability	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
7b47c1c5-6ff8-411e-8f06-8a29719b6485	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	Mechanics	2026-08-18 05:57:42.719806+00	t	2026-08-27 08:41:05.691727+00
3d1e90a1-ea0a-47e3-9c34-ef47eaef57b2	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	Thermodynamics	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
689f8270-2092-401a-933d-5204f62002ce	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	Optics	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
296873c1-7eae-4ac6-af30-4e90e6c975cb	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	Electricity and Magnetism	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
069e7811-b04d-43d6-b0f0-aed1011ac338	36e1aa2f-47e2-4c5f-a8c8-6e0058b407bb	Modern Physics	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
f9cdc792-675e-4765-97d9-7d594b0bbff9	9481ac62-4ea8-48a2-8776-33ed020858bb	Physical Chemistry	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
a18ba18b-efed-4702-a760-a28adafa5b6d	9481ac62-4ea8-48a2-8776-33ed020858bb	Organic Chemistry	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
0499253c-f5bf-4bef-bf4e-ce2064518718	9481ac62-4ea8-48a2-8776-33ed020858bb	Inorganic Chemistry	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
a2ba3485-e243-49cb-8f76-97ebabfb7007	9481ac62-4ea8-48a2-8776-33ed020858bb	Atomic Structure	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
a62b5e09-c0be-4d50-92a1-966376b743f9	9481ac62-4ea8-48a2-8776-33ed020858bb	Chemical Bonding	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
555e4b81-5e7e-4ab5-8e0e-fb7509dac1e9	bdc56824-3354-4558-963e-94033af7162c	Cell Biology	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
3da0d169-98b8-4dbe-8d28-7a33f12b9b73	bdc56824-3354-4558-963e-94033af7162c	Genetics	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
a09782cd-2594-4ad1-8bb9-2cb0c474a2ee	bdc56824-3354-4558-963e-94033af7162c	Human Physiology	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
b6f7da6a-8454-4074-9713-ec2cfac0827a	bdc56824-3354-4558-963e-94033af7162c	Ecology	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
5fc21423-3176-4ecf-a939-125ebe195ebb	bdc56824-3354-4558-963e-94033af7162c	Evolution	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
bf000091-f969-4b71-8b1e-d1ee4fc86c5d	0516b2da-3ff8-4945-9c83-6850a4573fee	Programming Fundamentals	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
62ab8bcc-63ac-4195-ab34-0105cf2454d0	0516b2da-3ff8-4945-9c83-6850a4573fee	Computer Networks	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
e98c174b-2dd3-488d-9ee2-b8f3b76dcfc8	0516b2da-3ff8-4945-9c83-6850a4573fee	Software Engineering	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
3b29fb2d-6ca8-4e1d-9666-afe9029a37bd	0516b2da-3ff8-4945-9c83-6850a4573fee	Computer Architecture	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
cfccb319-176b-4fe6-8063-36a680133335	0516b2da-3ff8-4945-9c83-6850a4573fee	Cyber Security Basics	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
9355a1b9-2c44-4ae2-8a41-49da99eafd21	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	Arrays and Strings	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
e8314a21-3b96-40a1-88ea-27a5e851c884	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	Linked Lists	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
bb30514c-1656-41b6-a8d3-cd8de2be50b8	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	Stacks and Queues	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
30f1cbee-75f3-4b9c-8745-0c405a5fb757	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	Trees and Graphs	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
6356b823-bbea-4e6c-8514-e16c1dc56b0c	e4e10e9a-ba58-4ddc-8782-dd3fb20662e9	Searching and Sorting	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
6d1dcf73-7718-4bff-a9ea-e67912db5f6e	0e626538-e950-4f50-a32e-ff8c38cb505f	SQL	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
eab339c3-acbc-4db7-b934-4f768eeb2ef3	0e626538-e950-4f50-a32e-ff8c38cb505f	Normalization	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
f79b303d-8e07-4edc-9360-6ba26970aefe	0e626538-e950-4f50-a32e-ff8c38cb505f	Transactions	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
54c6f325-599a-45e7-b8ce-b17d50df37d0	0e626538-e950-4f50-a32e-ff8c38cb505f	ER Model	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
44b802a1-7d25-40da-aa11-511dfd45d123	0e626538-e950-4f50-a32e-ff8c38cb505f	Indexing	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
0cb45db0-4eeb-48ce-b9b0-cf1ac094ece8	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	Processes	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
b2005f40-4939-4392-8db0-5d522b278cac	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	CPU Scheduling	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
ea4aca81-c81e-4730-aa8b-c36d5ee0e4b1	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	Deadlocks	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
fcd9e4e8-bd42-446e-9257-4413498b6e7b	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	Memory Management	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
018301c5-569c-4193-865e-4472084bb962	d9bf31b4-c3a6-4c40-9dbd-533698f6f47a	File Systems	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
cdc0efe2-8c71-48a6-adf7-c989e4ce3525	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	Quantitative Aptitude	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
0045e312-20fa-4ddf-ae9b-3f545fd19050	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	Logical Reasoning	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
d5e6e734-a122-4898-9ad7-c94915a2d1e2	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	Verbal Reasoning	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
ddbc0300-a68e-4091-a663-baa86d6ee8d3	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	Data Interpretation	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
9b2053a5-dd87-43a2-9bb7-56c77e52b37f	d64b1e2a-d2fd-46e3-ad60-f6187df260fa	Number Series	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
f42d3697-419c-4a1a-b588-5fd632ec965e	1f77c53e-73f4-40e1-bf17-3d005994b9b4	Grammar	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
69e0c2b4-1f30-49a0-914f-fd15a6840341	1f77c53e-73f4-40e1-bf17-3d005994b9b4	Vocabulary	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
df2d8bd4-d592-4357-ae3c-4c0d976a4e53	1f77c53e-73f4-40e1-bf17-3d005994b9b4	Reading Comprehension	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
d37077ae-8a72-4f2d-b230-22feaff498d6	1f77c53e-73f4-40e1-bf17-3d005994b9b4	Sentence Correction	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
a3626561-314a-4325-8a8c-4a42863d9d48	1f77c53e-73f4-40e1-bf17-3d005994b9b4	Synonyms and Antonyms	2026-08-27 08:41:05.691727+00	t	2026-08-27 08:41:05.691727+00
\.


--
-- TOC entry 5084 (class 0 OID 18238)
-- Dependencies: 372
-- Data for Name: xp_transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.xp_transactions (id, user_id, amount, reason, source_type, source_id, created_at) FROM stdin;
cae6f895-faf6-419a-9338-aa06f6de91d6	97ad6c7c-6f13-4266-8241-a72deab8f86a	120	correct_answers	exam_attempt	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	2026-08-27 09:29:48.642224+00
05eb14cb-f6bc-4b28-8f26-4e29617b67a5	97ad6c7c-6f13-4266-8241-a72deab8f86a	15	hard_answer_bonus	exam_attempt	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	2026-08-27 09:29:48.642224+00
df1ab6d6-ae23-41e9-8724-7b688fb904a2	97ad6c7c-6f13-4266-8241-a72deab8f86a	30	quiz_completed	exam_attempt	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	2026-08-27 09:29:48.642224+00
0346450c-39ea-47ed-beb3-0de3ef407f6e	97ad6c7c-6f13-4266-8241-a72deab8f86a	20	daily_streak_bonus	exam_attempt	4747e605-cd2c-439a-a6f0-b67bcd0fd2b1	2026-08-27 09:29:48.642224+00
90f3a451-826a-4bd0-93f7-a00c56b08df1	97ad6c7c-6f13-4266-8241-a72deab8f86a	30	quiz_completed	exam_attempt	918761bd-1936-45b3-8771-eef1dcd29c24	2026-08-28 11:20:34.779048+00
aa477390-9d26-42ad-921f-21bc62efe3e1	97ad6c7c-6f13-4266-8241-a72deab8f86a	20	daily_streak_bonus	exam_attempt	918761bd-1936-45b3-8771-eef1dcd29c24	2026-08-28 11:20:34.779048+00
\.


--
-- TOC entry 5097 (class 0 OID 25619)
-- Dependencies: 385
-- Data for Name: messages_2026_10_12; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_10_12 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload, skip_broadcast) FROM stdin;
\.


--
-- TOC entry 5098 (class 0 OID 25633)
-- Dependencies: 386
-- Data for Name: messages_2026_10_13; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_10_13 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload, skip_broadcast) FROM stdin;
\.


--
-- TOC entry 5099 (class 0 OID 25647)
-- Dependencies: 387
-- Data for Name: messages_2026_10_14; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_10_14 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload, skip_broadcast) FROM stdin;
\.


--
-- TOC entry 5100 (class 0 OID 25661)
-- Dependencies: 388
-- Data for Name: messages_2026_10_15; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_10_15 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload, skip_broadcast) FROM stdin;
\.


--
-- TOC entry 5101 (class 0 OID 25675)
-- Dependencies: 389
-- Data for Name: messages_2026_10_16; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_10_16 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload, skip_broadcast) FROM stdin;
\.


--
-- TOC entry 5051 (class 0 OID 17250)
-- Dependencies: 339
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-08-18 04:40:43
20211116045059	2026-08-18 04:40:43
20211116050929	2026-08-18 04:40:43
20211116051442	2026-08-18 04:40:43
20211116212300	2026-08-18 04:40:43
20211116213355	2026-08-18 04:40:43
20211116213934	2026-08-18 04:40:43
20211116214523	2026-08-18 04:40:43
20211122062447	2026-08-18 04:40:43
20211124070109	2026-08-18 04:40:43
20211202204204	2026-08-18 04:40:43
20211202204605	2026-08-18 04:40:43
20211210212804	2026-08-18 04:40:43
20211228014915	2026-08-18 04:40:43
20220107221237	2026-08-18 04:40:43
20220228202821	2026-08-18 04:40:43
20220312004840	2026-08-18 04:40:43
20220603231003	2026-08-18 04:40:43
20220603232444	2026-08-18 04:40:43
20220615214548	2026-08-18 04:40:43
20220712093339	2026-08-18 04:40:43
20220908172859	2026-08-18 04:40:43
20220916233421	2026-08-18 04:40:43
20230119133233	2026-08-18 04:40:43
20230128025114	2026-08-18 04:40:43
20230128025212	2026-08-18 04:40:43
20230227211149	2026-08-18 04:40:43
20230228184745	2026-08-18 04:40:43
20230308225145	2026-08-18 04:40:43
20230328144023	2026-08-18 04:40:43
20231018144023	2026-08-18 04:40:43
20231204144023	2026-08-18 04:40:43
20231204144024	2026-08-18 04:40:43
20231204144025	2026-08-18 04:40:43
20240108234812	2026-08-18 04:40:43
20240109165339	2026-08-18 04:40:43
20240227174441	2026-08-18 04:40:43
20240311171622	2026-08-18 04:40:43
20240321100241	2026-08-18 04:40:43
20240401105812	2026-08-18 04:40:43
20240418121054	2026-08-18 04:40:43
20240523004032	2026-08-18 04:40:43
20240618124746	2026-08-18 04:40:43
20240801235015	2026-08-18 04:40:43
20240805133720	2026-08-18 04:40:43
20240827160934	2026-08-18 04:40:43
20240919163303	2026-08-18 04:40:43
20240919163305	2026-08-18 04:40:43
20241019105805	2026-08-18 04:40:43
20241030150047	2026-08-18 04:40:43
20241108114728	2026-08-18 04:40:43
20241121104152	2026-08-18 04:40:43
20241130184212	2026-08-18 04:40:43
20241220035512	2026-08-18 04:40:43
20241220123912	2026-08-18 04:40:43
20241224161212	2026-08-18 04:40:43
20250107150512	2026-08-18 04:40:43
20250110162412	2026-08-18 04:40:43
20250123174212	2026-08-18 04:40:43
20250128220012	2026-08-18 04:40:43
20250506224012	2026-08-18 04:40:43
20250523164012	2026-08-18 04:40:43
20250714121412	2026-08-18 04:40:43
20250905041441	2026-08-18 04:40:43
20251103001201	2026-08-18 04:40:43
20251120212548	2026-08-18 04:40:43
20251120215549	2026-08-18 04:40:43
20260218120000	2026-08-18 04:40:43
20260326120000	2026-08-18 04:40:43
20260514120000	2026-08-18 04:40:43
20260527120000	2026-08-18 04:40:43
20260528120000	2026-08-18 04:40:43
20260603120000	2026-08-18 04:40:43
20260605120000	2026-08-18 04:40:43
20260606110000	2026-08-18 04:40:43
20260616120000	2026-08-18 04:40:43
20260624120000	2026-08-18 04:40:43
20260626120000	2026-08-18 04:40:43
20260706120000	2026-08-18 04:40:43
20260707120000	2026-08-18 04:40:43
20260709120000	2026-08-18 04:40:43
20260714120000	2026-10-13 06:21:32
20260827120000	2026-10-13 06:21:32
20260914120000	2026-10-13 06:21:32
20260916120000	2026-10-13 06:21:32
20260922120000	2026-10-13 06:21:32
20260925120000	2026-10-13 06:21:32
20260928120000	2026-10-13 06:21:32
20261002120000	2026-10-13 06:21:32
\.


--
-- TOC entry 5052 (class 0 OID 17253)
-- Dependencies: 340
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter, selected_columns) FROM stdin;
\.


--
-- TOC entry 5055 (class 0 OID 17294)
-- Dependencies: 343
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type, versioning_status, lifecycle_configuration, lifecycle_configuration_generation) FROM stdin;
avatars	avatars	\N	2026-08-18 06:23:25.515222+00	2026-08-18 06:23:25.515222+00	t	f	5242880	{image/jpeg,image/png,image/webp}	\N	STANDARD	DISABLED	\N	\N
question-media	question-media	\N	2026-08-18 06:23:25.515222+00	2026-08-18 06:23:25.515222+00	t	f	7340032	{image/jpeg,image/png,image/webp}	\N	STANDARD	DISABLED	\N	\N
\.


--
-- TOC entry 5059 (class 0 OID 17414)
-- Dependencies: 347
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- TOC entry 5060 (class 0 OID 17427)
-- Dependencies: 348
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5054 (class 0 OID 17286)
-- Dependencies: 342
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-08-18 04:40:45.907392
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-08-18 04:40:46.007539
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-08-18 04:40:46.011426
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-08-18 04:40:46.050389
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-08-18 04:40:46.065558
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-08-18 04:40:46.07094
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-08-18 04:40:46.079958
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-08-18 04:40:46.085863
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-08-18 04:40:46.09164
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-08-18 04:40:46.096101
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-08-18 04:40:46.100449
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-08-18 04:40:46.105211
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-08-18 04:40:46.11134
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-08-18 04:40:46.115599
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-08-18 04:40:46.120657
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-08-18 04:40:46.155492
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-08-18 04:40:46.159912
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-08-18 04:40:46.165152
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-08-18 04:40:46.169238
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-08-18 04:40:46.174984
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-08-18 04:40:46.179031
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-08-18 04:40:46.185112
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-08-18 04:40:46.206001
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-08-18 04:40:46.221667
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-08-18 04:40:46.226646
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-08-18 04:40:46.231494
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-08-18 04:40:46.236909
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-08-18 04:40:46.241356
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-08-18 04:40:46.246093
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-08-18 04:40:46.249864
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-08-18 04:40:46.253681
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-08-18 04:40:46.257894
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-08-18 04:40:46.261523
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-08-18 04:40:46.265323
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-08-18 04:40:46.269051
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-08-18 04:40:46.27289
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-08-18 04:40:46.276616
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-08-18 04:40:46.280877
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-08-18 04:40:46.285535
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-08-18 04:40:46.298899
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-08-18 04:40:46.302485
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-08-18 04:40:46.306584
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-08-18 04:40:46.310525
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-08-18 04:40:46.315635
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-08-18 04:40:46.319335
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-08-18 04:40:46.324845
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-08-18 04:40:46.337312
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-08-18 04:40:46.342452
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-08-18 04:40:46.346854
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-08-18 04:40:46.370773
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-08-18 04:40:46.376974
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-08-18 04:40:47.559291
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-08-18 04:40:47.582702
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-08-18 04:40:47.684464
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-08-18 04:40:47.687129
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-08-18 04:40:47.689527
56	fix-optimized-search-function	b823ed1e418101032fa01374edc9a436e54e3ed4	2026-08-18 04:40:47.697393
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-08-18 04:40:47.703592
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-08-18 04:40:47.708104
59	drop-unused-functions	38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4	2026-08-18 04:40:47.713048
60	optimize-existing-functions-again	db35e1c91a9201e59f4fef8d972c2f277d68b157	2026-08-18 04:40:47.717195
61	mark-filename-immutable	fe0096517ae9d60aaec1d110172ba9036dc66bb7	2026-08-18 04:40:47.722489
62	object-versioning-core	0b855f00ff3be0bfca91efee02a9858912491a9a	2026-08-25 05:23:47.564913
63	fix-search-name-relative-to-prefix	c7485e417624f795ce8bb2da21927f48e088904d	2026-08-25 05:23:47.591985
64	fix-search-by-timestamp-sqli	0af424ecd388a39bb1645184b222185a12149675	2026-08-25 05:23:47.600493
65	objects-key-version-index	da319c4b89ba800ce795d1b699f3a70675138058	2026-10-13 06:19:23.77399
66	objects-current-version-index	191466c93aa2c46a00e36505577c5fcab8d7cb4b	2026-10-13 06:19:23.790053
67	objects-null-version-index	15bfe8c35b66642b6c78ba60060fa8793bd2207a	2026-10-13 06:19:23.80232
68	bucket-lifecycle-configuration	3c08f6f889922f399519722a932b51007c11bebc	2026-10-13 06:19:23.806071
69	validate-bucket-lifecycle-constraints	4febacaaaa0e61e2b783bef081fe03a287e65eb3	2026-10-13 06:19:23.859825
70	list-objects-with-versions	5c17c3777616cd8d7b18b82835525fa3205af57b	2026-10-13 06:19:23.873437
71	objects-delete-marker-index	6d14858e66c66f8d6accf8a2630aefd1527fddba	2026-10-13 06:19:24.26707
72	drop-bucketid-objname-index	302beb09e1b469d7d4db19566f2389d280b64aa3	2026-10-13 06:19:24.298893
\.


--
-- TOC entry 5056 (class 0 OID 17304)
-- Dependencies: 344
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, archived_at, is_delete_marker, is_versioned) FROM stdin;
bf31b51f-d384-42c0-8507-991a2a7349fc	avatars	97ad6c7c-6f13-4266-8241-a72deab8f86a/1788158049439.jpg	97ad6c7c-6f13-4266-8241-a72deab8f86a	2026-08-31 06:32:59.767101+00	2026-08-31 06:32:59.767101+00	2026-08-31 06:32:59.767101+00	{"eTag": "\\"9a41aa442dfa73d9f9b32a6178f88812\\"", "size": 45783, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-08-31T06:33:00.000Z", "contentLength": 45783, "httpStatusCode": 200}	6145c690-d189-4bd9-bd0a-64d96654bc39	97ad6c7c-6f13-4266-8241-a72deab8f86a	{}	\N	f	f
47391c9a-6b4b-449d-bbd7-25e6b0c7f2de	avatars	97ad6c7c-6f13-4266-8241-a72deab8f86a/1788158064876.jpg	97ad6c7c-6f13-4266-8241-a72deab8f86a	2026-08-31 06:33:14.96343+00	2026-08-31 06:33:14.96343+00	2026-08-31 06:33:14.96343+00	{"eTag": "\\"9a41aa442dfa73d9f9b32a6178f88812\\"", "size": 45783, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-08-31T06:33:15.000Z", "contentLength": 45783, "httpStatusCode": 200}	e2c84fac-89ed-4427-bf2b-bea4c25a4c1c	97ad6c7c-6f13-4266-8241-a72deab8f86a	{}	\N	f	f
8731344d-6ee0-449f-b6f9-76aea16e1665	avatars	97ad6c7c-6f13-4266-8241-a72deab8f86a/1788158075585.jpg	97ad6c7c-6f13-4266-8241-a72deab8f86a	2026-08-31 06:33:25.677912+00	2026-08-31 06:33:25.677912+00	2026-08-31 06:33:25.677912+00	{"eTag": "\\"3c0b28a59b0c5ff7c08f8eb8df64db93\\"", "size": 2118, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-08-31T06:33:26.000Z", "contentLength": 2118, "httpStatusCode": 200}	bce42479-c699-4b1e-8d9a-d5aee249f029	97ad6c7c-6f13-4266-8241-a72deab8f86a	{}	\N	f	f
\.


--
-- TOC entry 5057 (class 0 OID 17353)
-- Dependencies: 345
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- TOC entry 5058 (class 0 OID 17367)
-- Dependencies: 346
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- TOC entry 5061 (class 0 OID 17437)
-- Dependencies: 349
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3869 (class 0 OID 16612)
-- Dependencies: 315
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 310
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 56, true);


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 341
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 140, true);


--
-- TOC entry 4363 (class 2606 OID 16789)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 4332 (class 2606 OID 16535)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4418 (class 2606 OID 17121)
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- TOC entry 4420 (class 2606 OID 17119)
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4386 (class 2606 OID 16895)
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- TOC entry 4341 (class 2606 OID 16913)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- TOC entry 4343 (class 2606 OID 16923)
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- TOC entry 4330 (class 2606 OID 16528)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 4365 (class 2606 OID 16782)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 4361 (class 2606 OID 16770)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4353 (class 2606 OID 16963)
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- TOC entry 4355 (class 2606 OID 16757)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 4636 (class 2606 OID 25563)
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_mfa_factor_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_mfa_factor_id_key UNIQUE (mfa_factor_id);


--
-- TOC entry 4638 (class 2606 OID 25559)
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_pkey PRIMARY KEY (id);


--
-- TOC entry 4640 (class 2606 OID 25561)
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_user_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_user_id_key UNIQUE (user_id);


--
-- TOC entry 4642 (class 2606 OID 25581)
-- Name: mfa_recovery_codes mfa_recovery_codes_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_codes
    ADD CONSTRAINT mfa_recovery_codes_pkey PRIMARY KEY (id);


--
-- TOC entry 4399 (class 2606 OID 17022)
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- TOC entry 4401 (class 2606 OID 17020)
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- TOC entry 4403 (class 2606 OID 17018)
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4413 (class 2606 OID 17080)
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4396 (class 2606 OID 16982)
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4407 (class 2606 OID 17044)
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 4409 (class 2606 OID 17046)
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- TOC entry 4390 (class 2606 OID 16948)
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4324 (class 2606 OID 16518)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4327 (class 2606 OID 16700)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4375 (class 2606 OID 16829)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 4377 (class 2606 OID 16827)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4382 (class 2606 OID 16843)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4335 (class 2606 OID 16541)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4631 (class 2606 OID 25540)
-- Name: scim_tokens scim_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.scim_tokens
    ADD CONSTRAINT scim_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4623 (class 2606 OID 25510)
-- Name: scim_users scim_users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.scim_users
    ADD CONSTRAINT scim_users_pkey PRIMARY KEY (id);


--
-- TOC entry 4348 (class 2606 OID 16721)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4372 (class 2606 OID 16810)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 4367 (class 2606 OID 16801)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4317 (class 2606 OID 16883)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 4319 (class 2606 OID 16505)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4428 (class 2606 OID 17158)
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4424 (class 2606 OID 17141)
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 4560 (class 2606 OID 18196)
-- Name: adaptive_session_questions adaptive_session_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptive_session_questions
    ADD CONSTRAINT adaptive_session_questions_pkey PRIMARY KEY (id);


--
-- TOC entry 4562 (class 2606 OID 18198)
-- Name: adaptive_session_questions adaptive_session_questions_session_id_question_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptive_session_questions
    ADD CONSTRAINT adaptive_session_questions_session_id_question_id_key UNIQUE (session_id, question_id);


--
-- TOC entry 4564 (class 2606 OID 18200)
-- Name: adaptive_session_questions adaptive_session_questions_session_id_question_order_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptive_session_questions
    ADD CONSTRAINT adaptive_session_questions_session_id_question_order_key UNIQUE (session_id, question_order);


--
-- TOC entry 4557 (class 2606 OID 18165)
-- Name: adaptive_sessions adaptive_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptive_sessions
    ADD CONSTRAINT adaptive_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4616 (class 2606 OID 18629)
-- Name: ai_question_drafts ai_question_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_question_drafts
    ADD CONSTRAINT ai_question_drafts_pkey PRIMARY KEY (id);


--
-- TOC entry 4519 (class 2606 OID 17707)
-- Name: badges badges_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_name_key UNIQUE (name);


--
-- TOC entry 4521 (class 2606 OID 17705)
-- Name: badges badges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_pkey PRIMARY KEY (id);


--
-- TOC entry 4493 (class 2606 OID 17608)
-- Name: exam_attempts exam_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_attempts
    ADD CONSTRAINT exam_attempts_pkey PRIMARY KEY (id);


--
-- TOC entry 4527 (class 2606 OID 17800)
-- Name: exam_questions exam_questions_exam_id_display_order_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_questions
    ADD CONSTRAINT exam_questions_exam_id_display_order_key UNIQUE (exam_id, display_order);


--
-- TOC entry 4529 (class 2606 OID 17798)
-- Name: exam_questions exam_questions_exam_id_question_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_questions
    ADD CONSTRAINT exam_questions_exam_id_question_id_key UNIQUE (exam_id, question_id);


--
-- TOC entry 4531 (class 2606 OID 17796)
-- Name: exam_questions exam_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_questions
    ADD CONSTRAINT exam_questions_pkey PRIMARY KEY (id);


--
-- TOC entry 4483 (class 2606 OID 17558)
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- TOC entry 4578 (class 2606 OID 18284)
-- Name: leaderboard_snapshots leaderboard_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaderboard_snapshots
    ADD CONSTRAINT leaderboard_snapshots_pkey PRIMARY KEY (id);


--
-- TOC entry 4580 (class 2606 OID 18286)
-- Name: leaderboard_snapshots leaderboard_snapshots_user_id_scope_period_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaderboard_snapshots
    ADD CONSTRAINT leaderboard_snapshots_user_id_scope_period_key_key UNIQUE (user_id, scope, period_key);


--
-- TOC entry 4567 (class 2606 OID 18235)
-- Name: levels levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.levels
    ADD CONSTRAINT levels_pkey PRIMARY KEY (level_number);


--
-- TOC entry 4569 (class 2606 OID 18237)
-- Name: levels levels_xp_required_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.levels
    ADD CONSTRAINT levels_xp_required_key UNIQUE (xp_required);


--
-- TOC entry 4600 (class 2606 OID 18504)
-- Name: multiplayer_answers multiplayer_answers_participant_id_room_question_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_answers
    ADD CONSTRAINT multiplayer_answers_participant_id_room_question_id_key UNIQUE (participant_id, room_question_id);


--
-- TOC entry 4602 (class 2606 OID 18502)
-- Name: multiplayer_answers multiplayer_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_answers
    ADD CONSTRAINT multiplayer_answers_pkey PRIMARY KEY (id);


--
-- TOC entry 4588 (class 2606 OID 18459)
-- Name: multiplayer_participants multiplayer_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_participants
    ADD CONSTRAINT multiplayer_participants_pkey PRIMARY KEY (id);


--
-- TOC entry 4590 (class 2606 OID 18461)
-- Name: multiplayer_participants multiplayer_participants_room_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_participants
    ADD CONSTRAINT multiplayer_participants_room_id_user_id_key UNIQUE (room_id, user_id);


--
-- TOC entry 4605 (class 2606 OID 18529)
-- Name: multiplayer_results multiplayer_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_results
    ADD CONSTRAINT multiplayer_results_pkey PRIMARY KEY (id);


--
-- TOC entry 4607 (class 2606 OID 18533)
-- Name: multiplayer_results multiplayer_results_room_id_rank_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_results
    ADD CONSTRAINT multiplayer_results_room_id_rank_key UNIQUE (room_id, rank);


--
-- TOC entry 4609 (class 2606 OID 18531)
-- Name: multiplayer_results multiplayer_results_room_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_results
    ADD CONSTRAINT multiplayer_results_room_id_user_id_key UNIQUE (room_id, user_id);


--
-- TOC entry 4593 (class 2606 OID 18478)
-- Name: multiplayer_room_questions multiplayer_room_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_room_questions
    ADD CONSTRAINT multiplayer_room_questions_pkey PRIMARY KEY (id);


--
-- TOC entry 4595 (class 2606 OID 18480)
-- Name: multiplayer_room_questions multiplayer_room_questions_room_id_position_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_room_questions
    ADD CONSTRAINT multiplayer_room_questions_room_id_position_key UNIQUE (room_id, "position");


--
-- TOC entry 4597 (class 2606 OID 18482)
-- Name: multiplayer_room_questions multiplayer_room_questions_room_id_question_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_room_questions
    ADD CONSTRAINT multiplayer_room_questions_room_id_question_id_key UNIQUE (room_id, question_id);


--
-- TOC entry 4583 (class 2606 OID 18424)
-- Name: multiplayer_rooms multiplayer_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_rooms
    ADD CONSTRAINT multiplayer_rooms_pkey PRIMARY KEY (id);


--
-- TOC entry 4585 (class 2606 OID 18426)
-- Name: multiplayer_rooms multiplayer_rooms_room_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_rooms
    ADD CONSTRAINT multiplayer_rooms_room_code_key UNIQUE (room_code);


--
-- TOC entry 4536 (class 2606 OID 17821)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4538 (class 2606 OID 18273)
-- Name: notifications notifications_user_event_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_event_unique UNIQUE (user_id, event_key);


--
-- TOC entry 4507 (class 2606 OID 17652)
-- Name: performance_metrics performance_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.performance_metrics
    ADD CONSTRAINT performance_metrics_pkey PRIMARY KEY (id);


--
-- TOC entry 4509 (class 2606 OID 17654)
-- Name: performance_metrics performance_metrics_user_id_topic_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.performance_metrics
    ADD CONSTRAINT performance_metrics_user_id_topic_id_key UNIQUE (user_id, topic_id);


--
-- TOC entry 4546 (class 2606 OID 18074)
-- Name: performance_predictions performance_predictions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.performance_predictions
    ADD CONSTRAINT performance_predictions_pkey PRIMARY KEY (id);


--
-- TOC entry 4517 (class 2606 OID 17686)
-- Name: proctoring_events proctoring_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proctoring_events
    ADD CONSTRAINT proctoring_events_pkey PRIMARY KEY (id);


--
-- TOC entry 4614 (class 2606 OID 18596)
-- Name: proctoring_reports proctoring_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proctoring_reports
    ADD CONSTRAINT proctoring_reports_pkey PRIMARY KEY (attempt_id);


--
-- TOC entry 4471 (class 2606 OID 17512)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 4491 (class 2606 OID 17585)
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- TOC entry 4549 (class 2606 OID 18096)
-- Name: recommendations recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendations
    ADD CONSTRAINT recommendations_pkey PRIMARY KEY (id);


--
-- TOC entry 4555 (class 2606 OID 18139)
-- Name: revision_plan_tasks revision_plan_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revision_plan_tasks
    ADD CONSTRAINT revision_plan_tasks_pkey PRIMARY KEY (id);


--
-- TOC entry 4552 (class 2606 OID 18120)
-- Name: revision_plans revision_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revision_plans
    ADD CONSTRAINT revision_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 4502 (class 2606 OID 17631)
-- Name: student_answers student_answers_attempt_id_question_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_attempt_id_question_id_key UNIQUE (attempt_id, question_id);


--
-- TOC entry 4504 (class 2606 OID 17629)
-- Name: student_answers student_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_pkey PRIMARY KEY (id);


--
-- TOC entry 4525 (class 2606 OID 17713)
-- Name: student_badges student_badges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_badges
    ADD CONSTRAINT student_badges_pkey PRIMARY KEY (user_id, badge_id);


--
-- TOC entry 4512 (class 2606 OID 17672)
-- Name: student_stats student_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_stats
    ADD CONSTRAINT student_stats_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4541 (class 2606 OID 18047)
-- Name: student_topic_ability student_topic_ability_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_topic_ability
    ADD CONSTRAINT student_topic_ability_pkey PRIMARY KEY (id);


--
-- TOC entry 4543 (class 2606 OID 18049)
-- Name: student_topic_ability student_topic_ability_user_id_topic_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_topic_ability
    ADD CONSTRAINT student_topic_ability_user_id_topic_id_key UNIQUE (user_id, topic_id);


--
-- TOC entry 4474 (class 2606 OID 17528)
-- Name: subjects subjects_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_name_key UNIQUE (name);


--
-- TOC entry 4476 (class 2606 OID 17526)
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- TOC entry 4479 (class 2606 OID 17537)
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- TOC entry 4481 (class 2606 OID 17539)
-- Name: topics topics_subject_id_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_subject_id_name_key UNIQUE (subject_id, name);


--
-- TOC entry 4573 (class 2606 OID 18247)
-- Name: xp_transactions xp_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.xp_transactions
    ADD CONSTRAINT xp_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 4575 (class 2606 OID 18249)
-- Name: xp_transactions xp_transactions_user_id_source_type_source_id_reason_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.xp_transactions
    ADD CONSTRAINT xp_transactions_user_id_source_type_source_id_reason_key UNIQUE (user_id, source_type, source_id, reason);


--
-- TOC entry 4432 (class 2606 OID 17266)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4646 (class 2606 OID 25629)
-- Name: messages_2026_10_12 messages_2026_10_12_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_10_12
    ADD CONSTRAINT messages_2026_10_12_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4649 (class 2606 OID 25643)
-- Name: messages_2026_10_13 messages_2026_10_13_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_10_13
    ADD CONSTRAINT messages_2026_10_13_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4652 (class 2606 OID 25657)
-- Name: messages_2026_10_14 messages_2026_10_14_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_10_14
    ADD CONSTRAINT messages_2026_10_14_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4655 (class 2606 OID 25671)
-- Name: messages_2026_10_15 messages_2026_10_15_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_10_15
    ADD CONSTRAINT messages_2026_10_15_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4658 (class 2606 OID 25685)
-- Name: messages_2026_10_16 messages_2026_10_16_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_10_16
    ADD CONSTRAINT messages_2026_10_16_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4214 (class 2606 OID 17264)
-- Name: messages messages_payload_exclusive; Type: CHECK CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages
    ADD CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL))) NOT VALID;


--
-- TOC entry 4437 (class 2606 OID 17268)
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- TOC entry 4434 (class 2606 OID 17270)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4461 (class 2606 OID 17460)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 4445 (class 2606 OID 17302)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4464 (class 2606 OID 17436)
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- TOC entry 4440 (class 2606 OID 17293)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4442 (class 2606 OID 17291)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4454 (class 2606 OID 17314)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4459 (class 2606 OID 17376)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4457 (class 2606 OID 17361)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4467 (class 2606 OID 17446)
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- TOC entry 4333 (class 1259 OID 16536)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 4303 (class 1259 OID 16710)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4414 (class 1259 OID 17125)
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- TOC entry 4415 (class 1259 OID 17124)
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- TOC entry 4416 (class 1259 OID 17122)
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- TOC entry 4421 (class 1259 OID 17123)
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- TOC entry 4304 (class 1259 OID 16712)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4305 (class 1259 OID 16713)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4351 (class 1259 OID 16791)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 4384 (class 1259 OID 16899)
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- TOC entry 4339 (class 1259 OID 16879)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 4339
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 4344 (class 1259 OID 16707)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 4387 (class 1259 OID 16896)
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- TOC entry 4411 (class 1259 OID 17081)
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- TOC entry 4388 (class 1259 OID 16897)
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- TOC entry 4306 (class 1259 OID 17168)
-- Name: idx_users_created_at_desc; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_users_created_at_desc ON auth.users USING btree (created_at DESC);


--
-- TOC entry 4307 (class 1259 OID 17167)
-- Name: idx_users_email; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_users_email ON auth.users USING btree (email);


--
-- TOC entry 4308 (class 1259 OID 17169)
-- Name: idx_users_last_sign_in_at_desc; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_users_last_sign_in_at_desc ON auth.users USING btree (last_sign_in_at DESC);


--
-- TOC entry 4309 (class 1259 OID 17170)
-- Name: idx_users_name; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_users_name ON auth.users USING btree (((raw_user_meta_data ->> 'name'::text))) WHERE ((raw_user_meta_data ->> 'name'::text) IS NOT NULL);


--
-- TOC entry 4359 (class 1259 OID 16902)
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- TOC entry 4356 (class 1259 OID 16763)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 4357 (class 1259 OID 16908)
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- TOC entry 4643 (class 1259 OID 25587)
-- Name: mfa_recovery_codes_set_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_recovery_codes_set_id_idx ON auth.mfa_recovery_codes USING btree (mfa_recovery_code_set_id);


--
-- TOC entry 4397 (class 1259 OID 17033)
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- TOC entry 4394 (class 1259 OID 16986)
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- TOC entry 4404 (class 1259 OID 17059)
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4405 (class 1259 OID 17057)
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4410 (class 1259 OID 17058)
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- TOC entry 4391 (class 1259 OID 16955)
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- TOC entry 4392 (class 1259 OID 16954)
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- TOC entry 4393 (class 1259 OID 16956)
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- TOC entry 4310 (class 1259 OID 16714)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4311 (class 1259 OID 16711)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4320 (class 1259 OID 16519)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 4321 (class 1259 OID 16520)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 4322 (class 1259 OID 16706)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 4325 (class 1259 OID 16793)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 4328 (class 1259 OID 16898)
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- TOC entry 4378 (class 1259 OID 16835)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 4379 (class 1259 OID 16900)
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- TOC entry 4380 (class 1259 OID 16850)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 4383 (class 1259 OID 16849)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 4629 (class 1259 OID 25548)
-- Name: scim_tokens_expires_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_tokens_expires_at_idx ON auth.scim_tokens USING btree (expires_at);


--
-- TOC entry 4632 (class 1259 OID 25549)
-- Name: scim_tokens_revoked_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_tokens_revoked_at_idx ON auth.scim_tokens USING btree (revoked_at);


--
-- TOC entry 4633 (class 1259 OID 25547)
-- Name: scim_tokens_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_tokens_sso_provider_id_idx ON auth.scim_tokens USING btree (sso_provider_id);


--
-- TOC entry 4634 (class 1259 OID 25546)
-- Name: scim_tokens_token_hash_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX scim_tokens_token_hash_key ON auth.scim_tokens USING btree (token_hash);


--
-- TOC entry 4618 (class 1259 OID 25526)
-- Name: scim_users_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_created_at_idx ON auth.scim_users USING btree (sso_provider_id, created_at, id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4619 (class 1259 OID 25529)
-- Name: scim_users_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_deleted_at_idx ON auth.scim_users USING btree (deleted_at);


--
-- TOC entry 4620 (class 1259 OID 25522)
-- Name: scim_users_external_id_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX scim_users_external_id_key ON auth.scim_users USING btree (sso_provider_id, external_id) WHERE ((external_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4621 (class 1259 OID 25524)
-- Name: scim_users_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_id_idx ON auth.scim_users USING btree (sso_provider_id, id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4624 (class 1259 OID 25528)
-- Name: scim_users_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_sso_provider_id_idx ON auth.scim_users USING btree (sso_provider_id);


--
-- TOC entry 4625 (class 1259 OID 25527)
-- Name: scim_users_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_updated_at_idx ON auth.scim_users USING btree (sso_provider_id, updated_at, id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4626 (class 1259 OID 25523)
-- Name: scim_users_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_user_id_idx ON auth.scim_users USING btree (user_id);


--
-- TOC entry 4627 (class 1259 OID 25525)
-- Name: scim_users_user_name_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX scim_users_user_name_idx ON auth.scim_users USING btree (sso_provider_id, user_name COLLATE "C", id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4628 (class 1259 OID 25521)
-- Name: scim_users_user_name_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX scim_users_user_name_key ON auth.scim_users USING btree (sso_provider_id, user_name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4345 (class 1259 OID 16901)
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- TOC entry 4346 (class 1259 OID 17071)
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- TOC entry 4349 (class 1259 OID 16792)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 4370 (class 1259 OID 16817)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 4373 (class 1259 OID 16816)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 4368 (class 1259 OID 16802)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 4369 (class 1259 OID 16964)
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- TOC entry 4358 (class 1259 OID 16961)
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- TOC entry 4350 (class 1259 OID 16790)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 4312 (class 1259 OID 16870)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 4312
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 4313 (class 1259 OID 16708)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 4314 (class 1259 OID 16509)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 4315 (class 1259 OID 16925)
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- TOC entry 4426 (class 1259 OID 17165)
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- TOC entry 4429 (class 1259 OID 17164)
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- TOC entry 4422 (class 1259 OID 17147)
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- TOC entry 4425 (class 1259 OID 17148)
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- TOC entry 4539 (class 1259 OID 18211)
-- Name: idx_ability_user_score; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ability_user_score ON public.student_topic_ability USING btree (user_id, ability_score);


--
-- TOC entry 4565 (class 1259 OID 18217)
-- Name: idx_adaptive_questions_session_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_adaptive_questions_session_order ON public.adaptive_session_questions USING btree (session_id, question_order);


--
-- TOC entry 4558 (class 1259 OID 18216)
-- Name: idx_adaptive_sessions_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_adaptive_sessions_user ON public.adaptive_sessions USING btree (user_id, started_at DESC);


--
-- TOC entry 4617 (class 1259 OID 18650)
-- Name: idx_ai_question_drafts_creator; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ai_question_drafts_creator ON public.ai_question_drafts USING btree (created_by, status, created_at DESC);


--
-- TOC entry 4498 (class 1259 OID 17736)
-- Name: idx_answers_attempt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_answers_attempt ON public.student_answers USING btree (attempt_id);


--
-- TOC entry 4499 (class 1259 OID 17947)
-- Name: idx_answers_attempt_display_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_answers_attempt_display_order ON public.student_answers USING btree (attempt_id, display_order);


--
-- TOC entry 4500 (class 1259 OID 17948)
-- Name: idx_answers_attempt_updated; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_answers_attempt_updated ON public.student_answers USING btree (attempt_id, updated_at DESC);


--
-- TOC entry 4494 (class 1259 OID 17946)
-- Name: idx_attempts_exam_user_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attempts_exam_user_status ON public.exam_attempts USING btree (exam_id, user_id, status);


--
-- TOC entry 4495 (class 1259 OID 18013)
-- Name: idx_attempts_status_submitted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attempts_status_submitted ON public.exam_attempts USING btree (status, submitted_at DESC);


--
-- TOC entry 4496 (class 1259 OID 18027)
-- Name: idx_attempts_submission_claim; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attempts_submission_claim ON public.exam_attempts USING btree (id, user_id, status, submission_token);


--
-- TOC entry 4497 (class 1259 OID 17735)
-- Name: idx_attempts_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attempts_user ON public.exam_attempts USING btree (user_id, submitted_at DESC);


--
-- TOC entry 4522 (class 1259 OID 18296)
-- Name: idx_badges_active_criteria; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_badges_active_criteria ON public.badges USING btree (is_active, criteria_type);


--
-- TOC entry 4532 (class 1259 OID 17831)
-- Name: idx_exam_questions_exam_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_exam_questions_exam_order ON public.exam_questions USING btree (exam_id, display_order);


--
-- TOC entry 4484 (class 1259 OID 18687)
-- Name: idx_exams_seed_key_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_exams_seed_key_unique ON public.exams USING btree (seed_key);


--
-- TOC entry 4485 (class 1259 OID 18012)
-- Name: idx_exams_status_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_exams_status_created ON public.exams USING btree (status, created_at DESC);


--
-- TOC entry 4576 (class 1259 OID 18298)
-- Name: idx_leaderboard_snapshots_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_leaderboard_snapshots_scope ON public.leaderboard_snapshots USING btree (scope, period_key, rank);


--
-- TOC entry 4505 (class 1259 OID 17737)
-- Name: idx_metrics_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_metrics_user ON public.performance_metrics USING btree (user_id);


--
-- TOC entry 4598 (class 1259 OID 18552)
-- Name: idx_mp_answers_room_question; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mp_answers_room_question ON public.multiplayer_answers USING btree (room_id, room_question_id);


--
-- TOC entry 4586 (class 1259 OID 18550)
-- Name: idx_mp_participants_room; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mp_participants_room ON public.multiplayer_participants USING btree (room_id, left_at, score DESC);


--
-- TOC entry 4591 (class 1259 OID 18551)
-- Name: idx_mp_questions_room; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mp_questions_room ON public.multiplayer_room_questions USING btree (room_id, "position");


--
-- TOC entry 4603 (class 1259 OID 18553)
-- Name: idx_mp_results_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mp_results_user ON public.multiplayer_results USING btree (user_id, created_at DESC);


--
-- TOC entry 4581 (class 1259 OID 18549)
-- Name: idx_mp_rooms_public; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mp_rooms_public ON public.multiplayer_rooms USING btree (status, is_public, created_at DESC);


--
-- TOC entry 4533 (class 1259 OID 18297)
-- Name: idx_notifications_unread; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_unread ON public.notifications USING btree (user_id, is_read, created_at DESC);


--
-- TOC entry 4534 (class 1259 OID 17832)
-- Name: idx_notifications_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_user_created ON public.notifications USING btree (user_id, created_at DESC);


--
-- TOC entry 4544 (class 1259 OID 18212)
-- Name: idx_predictions_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_predictions_user_created ON public.performance_predictions USING btree (user_id, created_at DESC);


--
-- TOC entry 4513 (class 1259 OID 17738)
-- Name: idx_proctor_attempt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_proctor_attempt ON public.proctoring_events USING btree (attempt_id, created_at);


--
-- TOC entry 4514 (class 1259 OID 18581)
-- Name: idx_proctor_events_type_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_proctor_events_type_created ON public.proctoring_events USING btree (event_type, created_at DESC);


--
-- TOC entry 4515 (class 1259 OID 18580)
-- Name: idx_proctor_events_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_proctor_events_user_created ON public.proctoring_events USING btree (user_id, created_at DESC);


--
-- TOC entry 4610 (class 1259 OID 18613)
-- Name: idx_proctor_reports_exam; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_proctor_reports_exam ON public.proctoring_reports USING btree (exam_id, calculated_at DESC);


--
-- TOC entry 4611 (class 1259 OID 18612)
-- Name: idx_proctor_reports_risk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_proctor_reports_risk ON public.proctoring_reports USING btree (risk_score DESC, calculated_at DESC);


--
-- TOC entry 4612 (class 1259 OID 18614)
-- Name: idx_proctor_reports_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_proctor_reports_user ON public.proctoring_reports USING btree (user_id, calculated_at DESC);


--
-- TOC entry 4468 (class 1259 OID 17757)
-- Name: idx_profiles_email_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_profiles_email_unique ON public.profiles USING btree (lower(email));


--
-- TOC entry 4469 (class 1259 OID 18011)
-- Name: idx_profiles_role_status_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_role_status_created ON public.profiles USING btree (role, account_status, created_at DESC);


--
-- TOC entry 4486 (class 1259 OID 17734)
-- Name: idx_questions_exam; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_questions_exam ON public.questions USING btree (exam_id, display_order);


--
-- TOC entry 4487 (class 1259 OID 17830)
-- Name: idx_questions_filters; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_questions_filters ON public.questions USING btree (is_active, difficulty, created_at DESC);


--
-- TOC entry 4488 (class 1259 OID 18688)
-- Name: idx_questions_seed_key_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_questions_seed_key_unique ON public.questions USING btree (seed_key);


--
-- TOC entry 4489 (class 1259 OID 17829)
-- Name: idx_questions_subject_topic; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_questions_subject_topic ON public.questions USING btree (subject_id, topic_id);


--
-- TOC entry 4547 (class 1259 OID 18213)
-- Name: idx_recommendations_user_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_recommendations_user_status ON public.recommendations USING btree (user_id, status, priority);


--
-- TOC entry 4550 (class 1259 OID 18214)
-- Name: idx_revision_plans_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_revision_plans_user ON public.revision_plans USING btree (user_id, created_at DESC);


--
-- TOC entry 4553 (class 1259 OID 18215)
-- Name: idx_revision_tasks_plan_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_revision_tasks_plan_date ON public.revision_plan_tasks USING btree (plan_id, scheduled_date);


--
-- TOC entry 4523 (class 1259 OID 18295)
-- Name: idx_student_badges_earned; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_student_badges_earned ON public.student_badges USING btree (user_id, earned_at DESC);


--
-- TOC entry 4510 (class 1259 OID 18294)
-- Name: idx_student_stats_ranking; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_student_stats_ranking ON public.student_stats USING btree (total_xp DESC, quizzes_completed DESC);


--
-- TOC entry 4472 (class 1259 OID 17827)
-- Name: idx_subjects_active_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_subjects_active_name ON public.subjects USING btree (is_active, name);


--
-- TOC entry 4477 (class 1259 OID 17828)
-- Name: idx_topics_subject_active_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_topics_subject_active_name ON public.topics USING btree (subject_id, is_active, name);


--
-- TOC entry 4570 (class 1259 OID 18293)
-- Name: idx_xp_period; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_xp_period ON public.xp_transactions USING btree (created_at DESC, user_id);


--
-- TOC entry 4571 (class 1259 OID 18292)
-- Name: idx_xp_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_xp_user_created ON public.xp_transactions USING btree (user_id, created_at DESC);


--
-- TOC entry 4435 (class 1259 OID 17271)
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- TOC entry 4430 (class 1259 OID 17272)
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4644 (class 1259 OID 25630)
-- Name: messages_2026_10_12_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_10_12_inserted_at_topic_idx ON realtime.messages_2026_10_12 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4647 (class 1259 OID 25644)
-- Name: messages_2026_10_13_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_10_13_inserted_at_topic_idx ON realtime.messages_2026_10_13 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4650 (class 1259 OID 25658)
-- Name: messages_2026_10_14_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_10_14_inserted_at_topic_idx ON realtime.messages_2026_10_14 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4653 (class 1259 OID 25672)
-- Name: messages_2026_10_15_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_10_15_inserted_at_topic_idx ON realtime.messages_2026_10_15 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4656 (class 1259 OID 25686)
-- Name: messages_2026_10_16_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_10_16_inserted_at_topic_idx ON realtime.messages_2026_10_16 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4438 (class 1259 OID 17273)
-- Name: subscription_subscription_id_entity_filters_action_filter_selec; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_selec ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter, COALESCE(selected_columns, '{}'::text[]));


--
-- TOC entry 4443 (class 1259 OID 17303)
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4462 (class 1259 OID 17461)
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4455 (class 1259 OID 17387)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4446 (class 1259 OID 17352)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4447 (class 1259 OID 17468)
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- TOC entry 4448 (class 1259 OID 25479)
-- Name: idx_objects_current_version; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_objects_current_version ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE (archived_at IS NULL);


--
-- TOC entry 4449 (class 1259 OID 25498)
-- Name: idx_objects_delete_markers; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_delete_markers ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE is_delete_marker;


--
-- TOC entry 4450 (class 1259 OID 25480)
-- Name: idx_objects_null_version; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_objects_null_version ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE (NOT is_versioned);


--
-- TOC entry 4451 (class 1259 OID 17321)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4452 (class 1259 OID 25478)
-- Name: objects_bucket_id_name_version_key; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX objects_bucket_id_name_version_key ON storage.objects USING btree (bucket_id, name COLLATE "C", version) NULLS NOT DISTINCT;


--
-- TOC entry 4465 (class 1259 OID 17452)
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- TOC entry 4659 (class 0 OID 0)
-- Name: messages_2026_10_12_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_10_12_inserted_at_topic_idx;


--
-- TOC entry 4660 (class 0 OID 0)
-- Name: messages_2026_10_12_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_10_12_pkey;


--
-- TOC entry 4661 (class 0 OID 0)
-- Name: messages_2026_10_13_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_10_13_inserted_at_topic_idx;


--
-- TOC entry 4662 (class 0 OID 0)
-- Name: messages_2026_10_13_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_10_13_pkey;


--
-- TOC entry 4663 (class 0 OID 0)
-- Name: messages_2026_10_14_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_10_14_inserted_at_topic_idx;


--
-- TOC entry 4664 (class 0 OID 0)
-- Name: messages_2026_10_14_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_10_14_pkey;


--
-- TOC entry 4665 (class 0 OID 0)
-- Name: messages_2026_10_15_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_10_15_inserted_at_topic_idx;


--
-- TOC entry 4666 (class 0 OID 0)
-- Name: messages_2026_10_15_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_10_15_pkey;


--
-- TOC entry 4667 (class 0 OID 0)
-- Name: messages_2026_10_16_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_10_16_inserted_at_topic_idx;


--
-- TOC entry 4668 (class 0 OID 0)
-- Name: messages_2026_10_16_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_10_16_pkey;


--
-- TOC entry 4757 (class 2620 OID 17725)
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: -
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- TOC entry 4758 (class 2620 OID 17840)
-- Name: users on_auth_user_updated; Type: TRIGGER; Schema: auth; Owner: -
--

CREATE TRIGGER on_auth_user_updated AFTER UPDATE ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_auth_user_updated();


--
-- TOC entry 4773 (class 2620 OID 18309)
-- Name: adaptive_sessions adaptive_session_completed_notification; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER adaptive_session_completed_notification AFTER UPDATE OF status ON public.adaptive_sessions FOR EACH ROW EXECUTE FUNCTION public.notify_adaptive_session_completed();


--
-- TOC entry 4774 (class 2620 OID 18651)
-- Name: ai_question_drafts ai_question_drafts_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ai_question_drafts_set_updated_at BEFORE UPDATE ON public.ai_question_drafts FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4770 (class 2620 OID 17837)
-- Name: exams exams_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER exams_set_updated_at BEFORE UPDATE ON public.exams FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4767 (class 2620 OID 17834)
-- Name: profiles profiles_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER profiles_set_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4771 (class 2620 OID 17838)
-- Name: questions questions_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER questions_set_updated_at BEFORE UPDATE ON public.questions FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4772 (class 2620 OID 18006)
-- Name: questions questions_validate_topic_subject; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER questions_validate_topic_subject BEFORE INSERT OR UPDATE OF subject_id, topic_id ON public.questions FOR EACH ROW EXECUTE FUNCTION public.validate_question_topic_subject();


--
-- TOC entry 4768 (class 2620 OID 17835)
-- Name: subjects subjects_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER subjects_set_updated_at BEFORE UPDATE ON public.subjects FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4769 (class 2620 OID 17836)
-- Name: topics topics_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER topics_set_updated_at BEFORE UPDATE ON public.topics FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4759 (class 2620 OID 17274)
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- TOC entry 4760 (class 2620 OID 17406)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4761 (class 2620 OID 25486)
-- Name: buckets protect_bucket_control_insert; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_bucket_control_insert BEFORE INSERT ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.protect_bucket_control_columns('service_role');


--
-- TOC entry 4762 (class 2620 OID 25487)
-- Name: buckets protect_bucket_control_update; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_bucket_control_update BEFORE UPDATE OF lifecycle_configuration, lifecycle_configuration_generation ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.protect_bucket_control_columns();


--
-- TOC entry 4763 (class 2620 OID 25488)
-- Name: buckets protect_bucket_control_update_role; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_bucket_control_update_role AFTER UPDATE OF lifecycle_configuration, lifecycle_configuration_generation ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_lifecycle_service_role('service_role');


--
-- TOC entry 4764 (class 2620 OID 17470)
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4765 (class 2620 OID 17471)
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4766 (class 2620 OID 17340)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4670 (class 2606 OID 16694)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4675 (class 2606 OID 16783)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4674 (class 2606 OID 16771)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4673 (class 2606 OID 16758)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4754 (class 2606 OID 25569)
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_mfa_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_mfa_factor_id_fkey FOREIGN KEY (mfa_factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4755 (class 2606 OID 25564)
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4756 (class 2606 OID 25582)
-- Name: mfa_recovery_codes mfa_recovery_codes_mfa_recovery_code_set_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_recovery_codes
    ADD CONSTRAINT mfa_recovery_codes_mfa_recovery_code_set_id_fkey FOREIGN KEY (mfa_recovery_code_set_id) REFERENCES auth.mfa_recovery_code_sets(id) ON DELETE CASCADE;


--
-- TOC entry 4681 (class 2606 OID 17023)
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4682 (class 2606 OID 17028)
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4683 (class 2606 OID 17052)
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4684 (class 2606 OID 17047)
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4680 (class 2606 OID 16949)
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4669 (class 2606 OID 16727)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4677 (class 2606 OID 16830)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4678 (class 2606 OID 16903)
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- TOC entry 4679 (class 2606 OID 16844)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4753 (class 2606 OID 25541)
-- Name: scim_tokens scim_tokens_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.scim_tokens
    ADD CONSTRAINT scim_tokens_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4751 (class 2606 OID 25511)
-- Name: scim_users scim_users_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.scim_users
    ADD CONSTRAINT scim_users_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4752 (class 2606 OID 25516)
-- Name: scim_users scim_users_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.scim_users
    ADD CONSTRAINT scim_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4671 (class 2606 OID 17066)
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4672 (class 2606 OID 16722)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4676 (class 2606 OID 16811)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4686 (class 2606 OID 17159)
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4685 (class 2606 OID 17142)
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4726 (class 2606 OID 18206)
-- Name: adaptive_session_questions adaptive_session_questions_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptive_session_questions
    ADD CONSTRAINT adaptive_session_questions_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE RESTRICT;


--
-- TOC entry 4727 (class 2606 OID 18201)
-- Name: adaptive_session_questions adaptive_session_questions_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptive_session_questions
    ADD CONSTRAINT adaptive_session_questions_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.adaptive_sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4723 (class 2606 OID 18171)
-- Name: adaptive_sessions adaptive_sessions_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptive_sessions
    ADD CONSTRAINT adaptive_sessions_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE RESTRICT;


--
-- TOC entry 4724 (class 2606 OID 18176)
-- Name: adaptive_sessions adaptive_sessions_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptive_sessions
    ADD CONSTRAINT adaptive_sessions_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE RESTRICT;


--
-- TOC entry 4725 (class 2606 OID 18166)
-- Name: adaptive_sessions adaptive_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptive_sessions
    ADD CONSTRAINT adaptive_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4747 (class 2606 OID 18630)
-- Name: ai_question_drafts ai_question_drafts_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_question_drafts
    ADD CONSTRAINT ai_question_drafts_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4748 (class 2606 OID 18645)
-- Name: ai_question_drafts ai_question_drafts_saved_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_question_drafts
    ADD CONSTRAINT ai_question_drafts_saved_question_id_fkey FOREIGN KEY (saved_question_id) REFERENCES public.questions(id) ON DELETE SET NULL;


--
-- TOC entry 4749 (class 2606 OID 18635)
-- Name: ai_question_drafts ai_question_drafts_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_question_drafts
    ADD CONSTRAINT ai_question_drafts_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE SET NULL;


--
-- TOC entry 4750 (class 2606 OID 18640)
-- Name: ai_question_drafts ai_question_drafts_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_question_drafts
    ADD CONSTRAINT ai_question_drafts_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE SET NULL;


--
-- TOC entry 4700 (class 2606 OID 18021)
-- Name: exam_attempts exam_attempts_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_attempts
    ADD CONSTRAINT exam_attempts_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id) ON DELETE RESTRICT;


--
-- TOC entry 4701 (class 2606 OID 17614)
-- Name: exam_attempts exam_attempts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_attempts
    ADD CONSTRAINT exam_attempts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4712 (class 2606 OID 17801)
-- Name: exam_questions exam_questions_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_questions
    ADD CONSTRAINT exam_questions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id) ON DELETE CASCADE;


--
-- TOC entry 4713 (class 2606 OID 17806)
-- Name: exam_questions exam_questions_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_questions
    ADD CONSTRAINT exam_questions_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- TOC entry 4694 (class 2606 OID 17564)
-- Name: exams exams_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4695 (class 2606 OID 17559)
-- Name: exams exams_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE SET NULL;


--
-- TOC entry 4729 (class 2606 OID 18287)
-- Name: leaderboard_snapshots leaderboard_snapshots_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaderboard_snapshots
    ADD CONSTRAINT leaderboard_snapshots_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4738 (class 2606 OID 18510)
-- Name: multiplayer_answers multiplayer_answers_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_answers
    ADD CONSTRAINT multiplayer_answers_participant_id_fkey FOREIGN KEY (participant_id) REFERENCES public.multiplayer_participants(id) ON DELETE CASCADE;


--
-- TOC entry 4739 (class 2606 OID 18505)
-- Name: multiplayer_answers multiplayer_answers_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_answers
    ADD CONSTRAINT multiplayer_answers_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.multiplayer_rooms(id) ON DELETE CASCADE;


--
-- TOC entry 4740 (class 2606 OID 18515)
-- Name: multiplayer_answers multiplayer_answers_room_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_answers
    ADD CONSTRAINT multiplayer_answers_room_question_id_fkey FOREIGN KEY (room_question_id) REFERENCES public.multiplayer_room_questions(id) ON DELETE CASCADE;


--
-- TOC entry 4734 (class 2606 OID 18462)
-- Name: multiplayer_participants multiplayer_participants_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_participants
    ADD CONSTRAINT multiplayer_participants_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.multiplayer_rooms(id) ON DELETE CASCADE;


--
-- TOC entry 4735 (class 2606 OID 18467)
-- Name: multiplayer_participants multiplayer_participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_participants
    ADD CONSTRAINT multiplayer_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4741 (class 2606 OID 18539)
-- Name: multiplayer_results multiplayer_results_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_results
    ADD CONSTRAINT multiplayer_results_participant_id_fkey FOREIGN KEY (participant_id) REFERENCES public.multiplayer_participants(id);


--
-- TOC entry 4742 (class 2606 OID 18534)
-- Name: multiplayer_results multiplayer_results_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_results
    ADD CONSTRAINT multiplayer_results_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.multiplayer_rooms(id) ON DELETE CASCADE;


--
-- TOC entry 4743 (class 2606 OID 18544)
-- Name: multiplayer_results multiplayer_results_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_results
    ADD CONSTRAINT multiplayer_results_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id);


--
-- TOC entry 4736 (class 2606 OID 18488)
-- Name: multiplayer_room_questions multiplayer_room_questions_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_room_questions
    ADD CONSTRAINT multiplayer_room_questions_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- TOC entry 4737 (class 2606 OID 18483)
-- Name: multiplayer_room_questions multiplayer_room_questions_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_room_questions
    ADD CONSTRAINT multiplayer_room_questions_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.multiplayer_rooms(id) ON DELETE CASCADE;


--
-- TOC entry 4730 (class 2606 OID 18442)
-- Name: multiplayer_rooms multiplayer_rooms_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_rooms
    ADD CONSTRAINT multiplayer_rooms_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- TOC entry 4731 (class 2606 OID 18427)
-- Name: multiplayer_rooms multiplayer_rooms_host_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_rooms
    ADD CONSTRAINT multiplayer_rooms_host_id_fkey FOREIGN KEY (host_id) REFERENCES public.profiles(id);


--
-- TOC entry 4732 (class 2606 OID 18432)
-- Name: multiplayer_rooms multiplayer_rooms_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_rooms
    ADD CONSTRAINT multiplayer_rooms_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id);


--
-- TOC entry 4733 (class 2606 OID 18437)
-- Name: multiplayer_rooms multiplayer_rooms_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multiplayer_rooms
    ADD CONSTRAINT multiplayer_rooms_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- TOC entry 4714 (class 2606 OID 17822)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4704 (class 2606 OID 17660)
-- Name: performance_metrics performance_metrics_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.performance_metrics
    ADD CONSTRAINT performance_metrics_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE CASCADE;


--
-- TOC entry 4705 (class 2606 OID 17655)
-- Name: performance_metrics performance_metrics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.performance_metrics
    ADD CONSTRAINT performance_metrics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4717 (class 2606 OID 18075)
-- Name: performance_predictions performance_predictions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.performance_predictions
    ADD CONSTRAINT performance_predictions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4708 (class 2606 OID 17687)
-- Name: proctoring_events proctoring_events_attempt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proctoring_events
    ADD CONSTRAINT proctoring_events_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES public.exam_attempts(id) ON DELETE CASCADE;


--
-- TOC entry 4709 (class 2606 OID 17692)
-- Name: proctoring_events proctoring_events_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proctoring_events
    ADD CONSTRAINT proctoring_events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4744 (class 2606 OID 18597)
-- Name: proctoring_reports proctoring_reports_attempt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proctoring_reports
    ADD CONSTRAINT proctoring_reports_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES public.exam_attempts(id) ON DELETE CASCADE;


--
-- TOC entry 4745 (class 2606 OID 18607)
-- Name: proctoring_reports proctoring_reports_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proctoring_reports
    ADD CONSTRAINT proctoring_reports_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id) ON DELETE CASCADE;


--
-- TOC entry 4746 (class 2606 OID 18602)
-- Name: proctoring_reports proctoring_reports_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proctoring_reports
    ADD CONSTRAINT proctoring_reports_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4692 (class 2606 OID 17513)
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4696 (class 2606 OID 17784)
-- Name: questions questions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4697 (class 2606 OID 17586)
-- Name: questions questions_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id) ON DELETE CASCADE;


--
-- TOC entry 4698 (class 2606 OID 17779)
-- Name: questions questions_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE SET NULL;


--
-- TOC entry 4699 (class 2606 OID 17591)
-- Name: questions questions_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE SET NULL;


--
-- TOC entry 4718 (class 2606 OID 18102)
-- Name: recommendations recommendations_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendations
    ADD CONSTRAINT recommendations_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE CASCADE;


--
-- TOC entry 4719 (class 2606 OID 18097)
-- Name: recommendations recommendations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendations
    ADD CONSTRAINT recommendations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4721 (class 2606 OID 18140)
-- Name: revision_plan_tasks revision_plan_tasks_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revision_plan_tasks
    ADD CONSTRAINT revision_plan_tasks_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.revision_plans(id) ON DELETE CASCADE;


--
-- TOC entry 4722 (class 2606 OID 18145)
-- Name: revision_plan_tasks revision_plan_tasks_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revision_plan_tasks
    ADD CONSTRAINT revision_plan_tasks_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE SET NULL;


--
-- TOC entry 4720 (class 2606 OID 18121)
-- Name: revision_plans revision_plans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revision_plans
    ADD CONSTRAINT revision_plans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4702 (class 2606 OID 17632)
-- Name: student_answers student_answers_attempt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES public.exam_attempts(id) ON DELETE CASCADE;


--
-- TOC entry 4703 (class 2606 OID 18016)
-- Name: student_answers student_answers_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE RESTRICT;


--
-- TOC entry 4710 (class 2606 OID 17719)
-- Name: student_badges student_badges_badge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_badges
    ADD CONSTRAINT student_badges_badge_id_fkey FOREIGN KEY (badge_id) REFERENCES public.badges(id) ON DELETE CASCADE;


--
-- TOC entry 4711 (class 2606 OID 17714)
-- Name: student_badges student_badges_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_badges
    ADD CONSTRAINT student_badges_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4706 (class 2606 OID 18261)
-- Name: student_stats student_stats_current_level_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_stats
    ADD CONSTRAINT student_stats_current_level_fkey FOREIGN KEY (current_level) REFERENCES public.levels(level_number);


--
-- TOC entry 4707 (class 2606 OID 17673)
-- Name: student_stats student_stats_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_stats
    ADD CONSTRAINT student_stats_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4715 (class 2606 OID 18055)
-- Name: student_topic_ability student_topic_ability_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_topic_ability
    ADD CONSTRAINT student_topic_ability_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE CASCADE;


--
-- TOC entry 4716 (class 2606 OID 18050)
-- Name: student_topic_ability student_topic_ability_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_topic_ability
    ADD CONSTRAINT student_topic_ability_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4693 (class 2606 OID 17540)
-- Name: topics topics_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- TOC entry 4728 (class 2606 OID 18250)
-- Name: xp_transactions xp_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.xp_transactions
    ADD CONSTRAINT xp_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4687 (class 2606 OID 17315)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4688 (class 2606 OID 17362)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4689 (class 2606 OID 17382)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4690 (class 2606 OID 17377)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4691 (class 2606 OID 17447)
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- TOC entry 4926 (class 0 OID 16529)
-- Dependencies: 313
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4937 (class 0 OID 16889)
-- Dependencies: 326
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4928 (class 0 OID 16687)
-- Dependencies: 317
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4925 (class 0 OID 16522)
-- Dependencies: 312
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4932 (class 0 OID 16776)
-- Dependencies: 321
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4931 (class 0 OID 16764)
-- Dependencies: 320
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4930 (class 0 OID 16751)
-- Dependencies: 319
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4938 (class 0 OID 16939)
-- Dependencies: 327
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4924 (class 0 OID 16511)
-- Dependencies: 311
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4935 (class 0 OID 16818)
-- Dependencies: 324
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4936 (class 0 OID 16836)
-- Dependencies: 325
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4927 (class 0 OID 16537)
-- Dependencies: 314
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4929 (class 0 OID 16717)
-- Dependencies: 318
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4934 (class 0 OID 16803)
-- Dependencies: 323
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4933 (class 0 OID 16794)
-- Dependencies: 322
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4923 (class 0 OID 16499)
-- Dependencies: 309
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5004 (class 3256 OID 18302)
-- Name: badges active badges readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "active badges readable" ON public.badges FOR SELECT TO authenticated USING ((is_active = true));


--
-- TOC entry 4968 (class 0 OID 18181)
-- Dependencies: 370
-- Name: adaptive_session_questions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.adaptive_session_questions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4967 (class 0 OID 18150)
-- Dependencies: 369
-- Name: adaptive_sessions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.adaptive_sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5014 (class 3256 OID 18654)
-- Name: ai_question_drafts admin ai drafts; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "admin ai drafts" ON public.ai_question_drafts FOR SELECT TO authenticated USING (public.is_admin());


--
-- TOC entry 4978 (class 0 OID 18615)
-- Dependencies: 380
-- Name: ai_question_drafts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_question_drafts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5010 (class 3256 OID 18558)
-- Name: multiplayer_answers answers readable by room members; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "answers readable by room members" ON public.multiplayer_answers FOR SELECT TO authenticated USING (((public.is_multiplayer_member(room_id) AND (EXISTS ( SELECT 1
   FROM public.multiplayer_rooms r
  WHERE ((r.id = multiplayer_answers.room_id) AND (r.phase = ANY (ARRAY['reveal'::public.multiplayer_phase, 'finished'::public.multiplayer_phase])))))) OR public.is_admin()));


--
-- TOC entry 4958 (class 0 OID 17697)
-- Dependencies: 360
-- Name: badges; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4988 (class 3256 OID 17851)
-- Name: exam_questions exam questions readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "exam questions readable" ON public.exam_questions FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.exams
  WHERE ((exams.id = exam_questions.exam_id) AND (exams.status = 'published'::public.exam_publication_status) AND (exams.is_published = true)))));


--
-- TOC entry 4953 (class 0 OID 17596)
-- Dependencies: 355
-- Name: exam_attempts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.exam_attempts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4960 (class 0 OID 17790)
-- Dependencies: 362
-- Name: exam_questions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.exam_questions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4951 (class 0 OID 17545)
-- Dependencies: 353
-- Name: exams; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.exams ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5005 (class 3256 OID 18303)
-- Name: leaderboard_snapshots leaderboard snapshots readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "leaderboard snapshots readable" ON public.leaderboard_snapshots FOR SELECT TO authenticated USING (true);


--
-- TOC entry 5003 (class 3256 OID 18301)
-- Name: student_stats leaderboard stats readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "leaderboard stats readable" ON public.student_stats FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4971 (class 0 OID 18274)
-- Dependencies: 373
-- Name: leaderboard_snapshots; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.leaderboard_snapshots ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4969 (class 0 OID 18226)
-- Dependencies: 371
-- Name: levels; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.levels ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5001 (class 3256 OID 18299)
-- Name: levels levels readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "levels readable" ON public.levels FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4975 (class 0 OID 18493)
-- Dependencies: 377
-- Name: multiplayer_answers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.multiplayer_answers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4973 (class 0 OID 18447)
-- Dependencies: 375
-- Name: multiplayer_participants; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.multiplayer_participants ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4976 (class 0 OID 18520)
-- Dependencies: 378
-- Name: multiplayer_results; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.multiplayer_results ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4974 (class 0 OID 18472)
-- Dependencies: 376
-- Name: multiplayer_room_questions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.multiplayer_room_questions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4972 (class 0 OID 18405)
-- Dependencies: 374
-- Name: multiplayer_rooms; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.multiplayer_rooms ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4961 (class 0 OID 17811)
-- Dependencies: 363
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4987 (class 3256 OID 17850)
-- Name: notifications notifications self read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "notifications self read" ON public.notifications FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 5006 (class 3256 OID 18304)
-- Name: notifications notifications self update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "notifications self update" ON public.notifications FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4994 (class 3256 OID 18218)
-- Name: student_topic_ability own abilities read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "own abilities read" ON public.student_topic_ability FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 5000 (class 3256 OID 18224)
-- Name: adaptive_session_questions own adaptive questions read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "own adaptive questions read" ON public.adaptive_session_questions FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.adaptive_sessions s
  WHERE ((s.id = adaptive_session_questions.session_id) AND (s.user_id = auth.uid())))));


--
-- TOC entry 4999 (class 3256 OID 18223)
-- Name: adaptive_sessions own adaptive sessions read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "own adaptive sessions read" ON public.adaptive_sessions FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4983 (class 3256 OID 17845)
-- Name: exam_attempts own attempts readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "own attempts readable" ON public.exam_attempts FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4984 (class 3256 OID 17846)
-- Name: performance_metrics own metrics readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "own metrics readable" ON public.performance_metrics FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4995 (class 3256 OID 18219)
-- Name: performance_predictions own predictions read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "own predictions read" ON public.performance_predictions FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 5012 (class 3256 OID 18652)
-- Name: proctoring_events own proctor events readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "own proctor events readable" ON public.proctoring_events FOR SELECT TO authenticated USING (((auth.uid() = user_id) OR public.is_admin()));


--
-- TOC entry 5013 (class 3256 OID 18653)
-- Name: proctoring_reports own proctor reports readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "own proctor reports readable" ON public.proctoring_reports FOR SELECT TO authenticated USING (((auth.uid() = user_id) OR public.is_admin()));


--
-- TOC entry 4996 (class 3256 OID 18220)
-- Name: recommendations own recommendations read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "own recommendations read" ON public.recommendations FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4997 (class 3256 OID 18221)
-- Name: revision_plans own revision plans read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "own revision plans read" ON public.revision_plans FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4998 (class 3256 OID 18222)
-- Name: revision_plan_tasks own revision tasks read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "own revision tasks read" ON public.revision_plan_tasks FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.revision_plans p
  WHERE ((p.id = revision_plan_tasks.plan_id) AND (p.user_id = auth.uid())))));


--
-- TOC entry 5002 (class 3256 OID 18300)
-- Name: xp_transactions own xp readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "own xp readable" ON public.xp_transactions FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4955 (class 0 OID 17642)
-- Dependencies: 357
-- Name: performance_metrics; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.performance_metrics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4963 (class 0 OID 18060)
-- Dependencies: 365
-- Name: performance_predictions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.performance_predictions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4957 (class 0 OID 17678)
-- Dependencies: 359
-- Name: proctoring_events; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.proctoring_events ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4977 (class 0 OID 18582)
-- Dependencies: 379
-- Name: proctoring_reports; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.proctoring_reports ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4979 (class 3256 OID 17841)
-- Name: profiles profile self read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "profile self read" ON public.profiles FOR SELECT USING ((auth.uid() = id));


--
-- TOC entry 4948 (class 0 OID 17503)
-- Dependencies: 350
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5007 (class 3256 OID 18555)
-- Name: multiplayer_rooms public rooms or member rooms readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "public rooms or member rooms readable" ON public.multiplayer_rooms FOR SELECT TO authenticated USING ((is_public OR (host_id = auth.uid()) OR public.is_multiplayer_member(id) OR public.is_admin()));


--
-- TOC entry 4980 (class 3256 OID 17842)
-- Name: exams published exams readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "published exams readable" ON public.exams FOR SELECT USING (((status = 'published'::public.exam_publication_status) AND (is_published = true)));


--
-- TOC entry 4952 (class 0 OID 17569)
-- Dependencies: 354
-- Name: questions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4964 (class 0 OID 18080)
-- Dependencies: 366
-- Name: recommendations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.recommendations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5011 (class 3256 OID 18559)
-- Name: multiplayer_results results readable by authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "results readable by authenticated" ON public.multiplayer_results FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4966 (class 0 OID 18126)
-- Dependencies: 368
-- Name: revision_plan_tasks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.revision_plan_tasks ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4965 (class 0 OID 18107)
-- Dependencies: 367
-- Name: revision_plans; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.revision_plans ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5008 (class 3256 OID 18556)
-- Name: multiplayer_participants room participants readable by members; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "room participants readable by members" ON public.multiplayer_participants FOR SELECT TO authenticated USING ((public.is_multiplayer_member(room_id) OR public.is_admin()));


--
-- TOC entry 5009 (class 3256 OID 18557)
-- Name: multiplayer_room_questions room question ids readable by members; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "room question ids readable by members" ON public.multiplayer_room_questions FOR SELECT TO authenticated USING ((public.is_multiplayer_member(room_id) OR public.is_admin()));


--
-- TOC entry 4985 (class 3256 OID 17847)
-- Name: student_stats stats readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "stats readable" ON public.student_stats FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4986 (class 3256 OID 17849)
-- Name: student_badges student badges readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "student badges readable" ON public.student_badges FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4954 (class 0 OID 17619)
-- Dependencies: 356
-- Name: student_answers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.student_answers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4959 (class 0 OID 17708)
-- Dependencies: 361
-- Name: student_badges; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.student_badges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4956 (class 0 OID 17665)
-- Dependencies: 358
-- Name: student_stats; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.student_stats ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4962 (class 0 OID 18030)
-- Dependencies: 364
-- Name: student_topic_ability; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.student_topic_ability ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4949 (class 0 OID 17518)
-- Dependencies: 351
-- Name: subjects; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4981 (class 3256 OID 17843)
-- Name: subjects subjects readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "subjects readable" ON public.subjects FOR SELECT USING ((is_active = true));


--
-- TOC entry 4950 (class 0 OID 17529)
-- Dependencies: 352
-- Name: topics; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.topics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4982 (class 3256 OID 17844)
-- Name: topics topics readable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "topics readable" ON public.topics FOR SELECT USING ((is_active = true));


--
-- TOC entry 4970 (class 0 OID 18238)
-- Dependencies: 372
-- Name: xp_transactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.xp_transactions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4939 (class 0 OID 17243)
-- Dependencies: 338
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4991 (class 3256 OID 17854)
-- Name: objects avatar delete own folder; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "avatar delete own folder" ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'avatars'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));


--
-- TOC entry 4992 (class 3256 OID 17855)
-- Name: objects avatar public read; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "avatar public read" ON storage.objects FOR SELECT USING ((bucket_id = 'avatars'::text));


--
-- TOC entry 4990 (class 3256 OID 17853)
-- Name: objects avatar update own folder; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "avatar update own folder" ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'avatars'::text) AND ((auth.uid())::text = (storage.foldername(name))[1]))) WITH CHECK (((bucket_id = 'avatars'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));


--
-- TOC entry 4989 (class 3256 OID 17852)
-- Name: objects avatar upload own folder; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "avatar upload own folder" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'avatars'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));


--
-- TOC entry 4941 (class 0 OID 17294)
-- Dependencies: 343
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4945 (class 0 OID 17414)
-- Dependencies: 347
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4946 (class 0 OID 17427)
-- Dependencies: 348
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4940 (class 0 OID 17286)
-- Dependencies: 342
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4942 (class 0 OID 17304)
-- Dependencies: 344
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5017 (class 3256 OID 18657)
-- Name: objects question media admin delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "question media admin delete" ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'question-media'::text) AND public.is_admin() AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- TOC entry 5016 (class 3256 OID 18656)
-- Name: objects question media admin update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "question media admin update" ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'question-media'::text) AND public.is_admin() AND ((storage.foldername(name))[1] = (auth.uid())::text))) WITH CHECK (((bucket_id = 'question-media'::text) AND public.is_admin() AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- TOC entry 5015 (class 3256 OID 18655)
-- Name: objects question media admin upload; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "question media admin upload" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'question-media'::text) AND public.is_admin() AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- TOC entry 4993 (class 3256 OID 17859)
-- Name: objects question media public read; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "question media public read" ON storage.objects FOR SELECT USING ((bucket_id = 'question-media'::text));


--
-- TOC entry 4943 (class 0 OID 17353)
-- Dependencies: 345
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4944 (class 0 OID 17367)
-- Dependencies: 346
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4947 (class 0 OID 17437)
-- Dependencies: 349
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5018 (class 6104 OID 16430)
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- TOC entry 5019 (class 6104 OID 18378)
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


--
-- TOC entry 5025 (class 6106 OID 18567)
-- Name: supabase_realtime multiplayer_answers; Type: PUBLICATION TABLE; Schema: public; Owner: -
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.multiplayer_answers;


--
-- TOC entry 5024 (class 6106 OID 18566)
-- Name: supabase_realtime multiplayer_participants; Type: PUBLICATION TABLE; Schema: public; Owner: -
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.multiplayer_participants;


--
-- TOC entry 5026 (class 6106 OID 18568)
-- Name: supabase_realtime multiplayer_results; Type: PUBLICATION TABLE; Schema: public; Owner: -
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.multiplayer_results;


--
-- TOC entry 5023 (class 6106 OID 18565)
-- Name: supabase_realtime multiplayer_rooms; Type: PUBLICATION TABLE; Schema: public; Owner: -
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.multiplayer_rooms;


--
-- TOC entry 5021 (class 6106 OID 18311)
-- Name: supabase_realtime notifications; Type: PUBLICATION TABLE; Schema: public; Owner: -
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.notifications;


--
-- TOC entry 5020 (class 6106 OID 18310)
-- Name: supabase_realtime student_stats; Type: PUBLICATION TABLE; Schema: public; Owner: -
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.student_stats;


--
-- TOC entry 5022 (class 6106 OID 18379)
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: -
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- TOC entry 3863 (class 3466 OID 16575)
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- TOC entry 3866 (class 3466 OID 16654)
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- TOC entry 3868 (class 3466 OID 16666)
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- TOC entry 3867 (class 3466 OID 16657)
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- TOC entry 3864 (class 3466 OID 16576)
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- TOC entry 3865 (class 3466 OID 16577)
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


-- Completed on 2026-10-13 14:22:33

--
-- PostgreSQL database dump complete
--

\unrestrict H9I4TOE8yjFKKrver9mmMuk9cpshcw2tzs7sfVHgGUanb9uVuvjn3lR2cTOGoLS

