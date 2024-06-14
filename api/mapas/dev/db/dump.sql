--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Debian 14.9-1.pgdg110+1)
-- Dumped by pg_dump version 14.12

-- Started on 2024-06-04 20:51:11 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: mapas
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO mapas;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: mapas
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO mapas;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: mapas
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO mapas;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: mapas
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: frequency; Type: DOMAIN; Schema: public; Owner: mapas
--

CREATE DOMAIN public.frequency AS character varying
	CONSTRAINT frequency_check CHECK (((VALUE)::text = ANY (ARRAY[('once'::character varying)::text, ('daily'::character varying)::text, ('weekly'::character varying)::text, ('monthly'::character varying)::text, ('yearly'::character varying)::text])));


ALTER DOMAIN public.frequency OWNER TO mapas;

--
-- TOC entry 2064 (class 1247 OID 18051)
-- Name: object_type; Type: TYPE; Schema: public; Owner: mapas
--

CREATE TYPE public.object_type AS ENUM (
    'MapasCulturais\Entities\Agent',
    'MapasCulturais\Entities\EvaluationMethodConfiguration',
    'MapasCulturais\Entities\Event',
    'MapasCulturais\Entities\Notification',
    'MapasCulturais\Entities\Opportunity',
    'MapasCulturais\Entities\Project',
    'MapasCulturais\Entities\Registration',
    'MapasCulturais\Entities\RegistrationFileConfiguration',
    'MapasCulturais\Entities\Request',
    'MapasCulturais\Entities\Seal',
    'MapasCulturais\Entities\Space',
    'MapasCulturais\Entities\Subsite',
    'MapasCulturais\Entities\ChatMessage',
    'MapasCulturais\Entities\ChatThread',
    'MapasCulturais\Entities\RegistrationEvaluation',
    'MapasCulturais\Entities\User',
    'UserManagement\Entities\SystemRole'
);


ALTER TYPE public.object_type OWNER TO mapas;

--
-- TOC entry 2067 (class 1247 OID 18076)
-- Name: permission_action; Type: TYPE; Schema: public; Owner: mapas
--

CREATE TYPE public.permission_action AS ENUM (
    'approve',
    'archive',
    'changeOwner',
    'changeStatus',
    'changePassword',
    '@control',
    'create',
    'createAgentRelation',
    'createAgentRelationWithControl',
    'createEvents',
    'createSealRelation',
    'createSpaceRelation',
    'destroy',
    'evaluate',
    'evaluateRegistrations',
    'modify',
    'modifyRegistrationFields',
    'modifyValuers',
    'publish',
    'publishRegistrations',
    'register',
    'reject',
    'remove',
    'removeAgentRelation',
    'removeAgentRelationWithControl',
    'removeSealRelation',
    'removeSpaceRelation',
    'reopenValuerEvaluations',
    'requestEventRelation',
    'send',
    'sendUserEvaluations',
    'unpublish',
    'view',
    'viewConsolidatedResult',
    'viewEvaluations',
    'viewPrivateData',
    'viewPrivateFiles',
    'viewRegistrations',
    'viewUserEvaluation',
    'changeType',
    'changeUserProfile',
    'deleteAccount',
    'evaluateOnTime',
    'post',
    'support',
    'unarchive'
);


ALTER TYPE public.permission_action OWNER TO mapas;

--
-- TOC entry 1328 (class 1255 OID 18153)
-- Name: days_in_month(date); Type: FUNCTION; Schema: public; Owner: mapas
--

CREATE FUNCTION public.days_in_month(check_date date) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
  first_of_month DATE := check_date - ((extract(day from check_date) - 1)||' days')::interval;
BEGIN
  RETURN extract(day from first_of_month + '1 month'::interval - first_of_month);
END;
$$;


ALTER FUNCTION public.days_in_month(check_date date) OWNER TO mapas;

--
-- TOC entry 1336 (class 1255 OID 19107)
-- Name: fn_clean_orphans(); Type: FUNCTION; Schema: public; Owner: mapas
--

CREATE FUNCTION public.fn_clean_orphans() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
                        DECLARE _p_type VARCHAR;
                    BEGIN
                        _p_type=TG_ARGV[0];
                        DELETE FROM agent_relation WHERE
                            object_type::varchar=_p_type AND object_id=OLD.id;
                        DELETE FROM seal_relation WHERE
                            object_type=_p_type AND object_id=OLD.id;   
                        DELETE FROM space_relation WHERE
                            object_type=_p_type AND object_id=OLD.id;
                        DELETE FROM term_relation WHERE
                            object_type::varchar=_p_type AND object_id=OLD.id;
                        DELETE FROM metalist WHERE
                            object_type=_p_type AND object_id=OLD.id;
                        DELETE FROM file WHERE
                            object_type::varchar=_p_type AND object_id=OLD.id;
                        DELETE FROM chat_thread WHERE
                            object_type=_p_type AND object_id=OLD.id;
                        DELETE FROM pcache WHERE
                            object_type::varchar=_p_type AND object_id=OLD.id;
                        DELETE FROM request WHERE
                            (origin_type=_p_type AND origin_id=OLD.id) OR
                            (destination_type=_p_type AND destination_id=OLD.id);
                        RETURN NULL;
                    END; $$;


ALTER FUNCTION public.fn_clean_orphans() OWNER TO mapas;

--
-- TOC entry 1338 (class 1255 OID 19127)
-- Name: fn_propagate_opportunity_update(); Type: FUNCTION; Schema: public; Owner: mapas
--

CREATE FUNCTION public.fn_propagate_opportunity_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
                    BEGIN
                        UPDATE opportunity
                        SET 
                            registration_ranges = NEW.registration_ranges,
                            registration_categories = NEW.registration_categories,
                            registration_proponent_types = NEW.registration_proponent_types
                        WHERE (parent_id = OLD.id OR id = OLD.parent_id)
                        AND (
                            registration_ranges::jsonb IS DISTINCT FROM NEW.registration_ranges::jsonb OR
                            registration_categories::jsonb IS DISTINCT FROM NEW.registration_categories::jsonb OR
                            registration_proponent_types::jsonb IS DISTINCT FROM NEW.registration_proponent_types::jsonb
                        );
                        RETURN NEW;
                    END; $$;


ALTER FUNCTION public.fn_propagate_opportunity_update() OWNER TO mapas;

--
-- TOC entry 1329 (class 1255 OID 18154)
-- Name: generate_recurrences(interval, date, date, date, date, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: mapas
--

CREATE FUNCTION public.generate_recurrences(duration interval, original_start_date date, original_end_date date, range_start date, range_end date, repeat_month integer, repeat_week integer, repeat_day integer) RETURNS SETOF date
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
  start_date DATE := original_start_date;
  next_date DATE;
  intervals INT := FLOOR(intervals_between(original_start_date, range_start, duration));
  current_month INT;
  current_week INT;
BEGIN
  IF repeat_month IS NOT NULL THEN
    start_date := start_date + (((12 + repeat_month - cast(extract(month from start_date) as int)) % 12) || ' months')::interval;
  END IF;
  IF repeat_week IS NULL AND repeat_day IS NOT NULL THEN
    IF duration = '7 days'::interval THEN
      start_date := start_date + (((7 + repeat_day - cast(extract(dow from start_date) as int)) % 7) || ' days')::interval;
    ELSE
      start_date := start_date + (repeat_day - extract(day from start_date) || ' days')::interval;
    END IF;
  END IF;
  LOOP
    next_date := start_date + duration * intervals;
    IF repeat_week IS NOT NULL AND repeat_day IS NOT NULL THEN
      current_month := extract(month from next_date);
      next_date := next_date + (((7 + repeat_day - cast(extract(dow from next_date) as int)) % 7) || ' days')::interval;
      IF extract(month from next_date) != current_month THEN
        next_date := next_date - '7 days'::interval;
      END IF;
      IF repeat_week > 0 THEN
        current_week := CEIL(extract(day from next_date) / 7);
      ELSE
        current_week := -CEIL((1 + days_in_month(next_date) - extract(day from next_date)) / 7);
      END IF;
      next_date := next_date + (repeat_week - current_week) * '7 days'::interval;
    END IF;
    EXIT WHEN next_date > range_end;

    IF next_date >= range_start AND next_date >= original_start_date THEN
      RETURN NEXT next_date;
    END IF;

    if original_end_date IS NOT NULL AND range_start >= original_start_date + (duration*intervals) AND range_start <= original_end_date + (duration*intervals) THEN
      RETURN NEXT next_date;
    END IF;
    intervals := intervals + 1;
  END LOOP;
END;
$$;


ALTER FUNCTION public.generate_recurrences(duration interval, original_start_date date, original_end_date date, range_start date, range_end date, repeat_month integer, repeat_week integer, repeat_day integer) OWNER TO mapas;

--
-- TOC entry 1330 (class 1255 OID 18155)
-- Name: interval_for(public.frequency); Type: FUNCTION; Schema: public; Owner: mapas
--

CREATE FUNCTION public.interval_for(recurs public.frequency) RETURNS interval
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF recurs = 'daily' THEN
    RETURN '1 day'::interval;
  ELSIF recurs = 'weekly' THEN
    RETURN '7 days'::interval;
  ELSIF recurs = 'monthly' THEN
    RETURN '1 month'::interval;
  ELSIF recurs = 'yearly' THEN
    RETURN '1 year'::interval;
  ELSE
    RAISE EXCEPTION 'Recurrence % not supported by generate_recurrences()', recurs;
  END IF;
END;
$$;


ALTER FUNCTION public.interval_for(recurs public.frequency) OWNER TO mapas;

--
-- TOC entry 1331 (class 1255 OID 18156)
-- Name: intervals_between(date, date, interval); Type: FUNCTION; Schema: public; Owner: mapas
--

CREATE FUNCTION public.intervals_between(start_date date, end_date date, duration interval) RETURNS double precision
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
  count FLOAT := 0;
  multiplier INT := 512;
BEGIN
  IF start_date > end_date THEN
    RETURN 0;
  END IF;
  LOOP
    WHILE start_date + (count + multiplier) * duration < end_date LOOP
      count := count + multiplier;
    END LOOP;
    EXIT WHEN multiplier = 1;
    multiplier := multiplier / 2;
  END LOOP;
  count := count + (extract(epoch from end_date) - extract(epoch from (start_date + count * duration))) / (extract(epoch from end_date + duration) - extract(epoch from end_date))::int;
  RETURN count;
END
$$;


ALTER FUNCTION public.intervals_between(start_date date, end_date date, duration interval) OWNER TO mapas;

--
-- TOC entry 1332 (class 1255 OID 18157)
-- Name: pseudo_random_id_generator(); Type: FUNCTION; Schema: public; Owner: mapas
--

CREATE FUNCTION public.pseudo_random_id_generator() RETURNS integer
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
                DECLARE
                    l1 int;
                    l2 int;
                    r1 int;
                    r2 int;
                    VALUE int;
                    i int:=0;
                BEGIN
                    VALUE:= nextval('pseudo_random_id_seq');
                    l1:= (VALUE >> 16) & 65535;
                    r1:= VALUE & 65535;
                    WHILE i < 3 LOOP
                        l2 := r1;
                        r2 := l1 # ((((1366 * r1 + 150889) % 714025) / 714025.0) * 32767)::int;
                        l1 := l2;
                        r1 := r2;
                        i := i + 1;
                    END LOOP;
                    RETURN ((r1 << 16) + l1);
                END;
            $$;


ALTER FUNCTION public.pseudo_random_id_generator() OWNER TO mapas;

--
-- TOC entry 1333 (class 1255 OID 18158)
-- Name: random_id_generator(character varying, bigint); Type: FUNCTION; Schema: public; Owner: mapas
--

CREATE FUNCTION public.random_id_generator(table_name character varying, initial_range bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$DECLARE
              rand_int INTEGER;
              count INTEGER := 1;
              statement TEXT;
            BEGIN
              WHILE count > 0 LOOP
                initial_range := initial_range * 10;

                rand_int := (RANDOM() * initial_range)::BIGINT + initial_range / 10;

                statement := CONCAT('SELECT count(id) FROM ', table_name, ' WHERE id = ', rand_int);

                EXECUTE statement;
                IF NOT FOUND THEN
                  count := 0;
                END IF;

              END LOOP;
              RETURN rand_int;
            END;
            $$;


ALTER FUNCTION public.random_id_generator(table_name character varying, initial_range bigint) OWNER TO mapas;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 281 (class 1259 OID 18159)
-- Name: event_occurrence; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.event_occurrence (
    id integer NOT NULL,
    space_id integer NOT NULL,
    event_id integer NOT NULL,
    rule text,
    starts_on date,
    ends_on date,
    starts_at timestamp without time zone,
    ends_at timestamp without time zone,
    frequency public.frequency,
    separation integer DEFAULT 1 NOT NULL,
    count integer,
    until date,
    timezone_name text DEFAULT 'Etc/UTC'::text NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    description text,
    price text,
    priceinfo text,
    CONSTRAINT positive_separation CHECK ((separation > 0))
);


ALTER TABLE public.event_occurrence OWNER TO mapas;

--
-- TOC entry 1334 (class 1255 OID 18168)
-- Name: recurrences_for(public.event_occurrence, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: mapas
--

CREATE FUNCTION public.recurrences_for(event public.event_occurrence, range_start timestamp without time zone, range_end timestamp without time zone) RETURNS SETOF date
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  recurrence event_occurrence_recurrence;
  recurrences_start DATE := COALESCE(event.starts_at::date, event.starts_on);
  recurrences_end DATE := range_end;
  duration INTERVAL := interval_for(event.frequency) * event.separation;
  next_date DATE;
BEGIN
  IF event.until IS NOT NULL AND event.until < recurrences_end THEN
    recurrences_end := event.until;
  END IF;
  IF event.count IS NOT NULL AND recurrences_start + (event.count - 1) * duration < recurrences_end THEN
    recurrences_end := recurrences_start + (event.count - 1) * duration;
  END IF;

  FOR recurrence IN
    SELECT event_occurrence_recurrence.*
      FROM (SELECT NULL) AS foo
      LEFT JOIN event_occurrence_recurrence
        ON event_occurrence_id = event.id
  LOOP
    FOR next_date IN
      SELECT *
        FROM generate_recurrences(
          duration,
          recurrences_start,
          COALESCE(event.ends_at::date, event.ends_on),
          range_start::date,
          recurrences_end,
          recurrence.month,
          recurrence.week,
          recurrence.day
        )
    LOOP
      RETURN NEXT next_date;
    END LOOP;
  END LOOP;
  RETURN;
END;
$$;


ALTER FUNCTION public.recurrences_for(event public.event_occurrence, range_start timestamp without time zone, range_end timestamp without time zone) OWNER TO mapas;

--
-- TOC entry 1335 (class 1255 OID 18169)
-- Name: recurring_event_occurrence_for(timestamp without time zone, timestamp without time zone, character varying, integer); Type: FUNCTION; Schema: public; Owner: mapas
--

CREATE FUNCTION public.recurring_event_occurrence_for(range_start timestamp without time zone, range_end timestamp without time zone, time_zone character varying, event_occurrence_limit integer) RETURNS SETOF public.event_occurrence
    LANGUAGE plpgsql STABLE
    AS $$
            DECLARE
              event event_occurrence;
              original_date DATE;
              original_date_in_zone DATE;
              start_time TIME;
              start_time_in_zone TIME;
              next_date DATE;
              next_time_in_zone TIME;
              duration INTERVAL;
              time_offset INTERVAL;
              r_start DATE := (timezone('UTC', range_start) AT TIME ZONE time_zone)::DATE;
              r_end DATE := (timezone('UTC', range_end) AT TIME ZONE time_zone)::DATE;

              recurrences_start DATE := CASE WHEN r_start < range_start THEN r_start ELSE range_start END;
              recurrences_end DATE := CASE WHEN r_end > range_end THEN r_end ELSE range_end END;

              inc_interval INTERVAL := '2 hours'::INTERVAL;

              ext_start TIMESTAMP := range_start::TIMESTAMP - inc_interval;
              ext_end   TIMESTAMP := range_end::TIMESTAMP   + inc_interval;
            BEGIN
              FOR event IN
                SELECT *
                  FROM event_occurrence
                  WHERE
                    status > 0
                    AND
                    (
                      (frequency = 'once' AND
                      ((starts_on IS NOT NULL AND ends_on IS NOT NULL AND starts_on <= r_end AND ends_on >= r_start) OR
                       (starts_on IS NOT NULL AND starts_on <= r_end AND starts_on >= r_start) OR
                       (starts_at <= range_end AND ends_at >= range_start)))

                      OR

                      (
                        frequency <> 'once' AND
                        (
                          ( starts_on IS NOT NULL AND starts_on <= ext_end ) OR
                          ( starts_at IS NOT NULL AND starts_at <= ext_end )
                        ) AND (
                          (until IS NULL AND ends_at IS NULL AND ends_on IS NULL) OR
                          (until IS NOT NULL AND until >= ext_start) OR
                          (ends_on IS NOT NULL AND ends_on >= ext_start) OR
                          (ends_at IS NOT NULL AND ends_at >= ext_start)
                        )
                      )
                    )

              LOOP
                IF event.frequency = 'once' THEN
                  RETURN NEXT event;
                  CONTINUE;
                END IF;

                -- All-day event
                IF event.starts_on IS NOT NULL AND event.ends_on IS NULL THEN
                  original_date := event.starts_on;
                  duration := '1 day'::interval;
                -- Multi-day event
                ELSIF event.starts_on IS NOT NULL AND event.ends_on IS NOT NULL THEN
                  original_date := event.starts_on;
                  duration := timezone(time_zone, event.ends_on) - timezone(time_zone, event.starts_on);
                -- Timespan event
                ELSE
                  original_date := event.starts_at::date;
                  original_date_in_zone := (timezone('UTC', event.starts_at) AT TIME ZONE event.timezone_name)::date;
                  start_time := event.starts_at::time;
                  start_time_in_zone := (timezone('UTC', event.starts_at) AT time ZONE event.timezone_name)::time;
                  duration := event.ends_at - event.starts_at;
                END IF;

                IF event.count IS NOT NULL THEN
                  recurrences_start := original_date;
                END IF;

                FOR next_date IN
                  SELECT occurrence
                    FROM (
                      SELECT * FROM recurrences_for(event, recurrences_start, recurrences_end) AS occurrence
                      UNION SELECT original_date
                      LIMIT event.count
                    ) AS occurrences
                    WHERE
                      occurrence::date <= recurrences_end AND
                      (occurrence + duration)::date >= recurrences_start AND
                      occurrence NOT IN (SELECT date FROM event_occurrence_cancellation WHERE event_occurrence_id = event.id)
                    LIMIT event_occurrence_limit
                LOOP
                  -- All-day event
                  IF event.starts_on IS NOT NULL AND event.ends_on IS NULL THEN
                    CONTINUE WHEN next_date < r_start OR next_date > r_end;
                    event.starts_on := next_date;

                  -- Multi-day event
                  ELSIF event.starts_on IS NOT NULL AND event.ends_on IS NOT NULL THEN
                    event.starts_on := next_date;
                    CONTINUE WHEN event.starts_on > r_end;
                    event.ends_on := next_date + duration;
                    CONTINUE WHEN event.ends_on < r_start;

                  -- Timespan event
                  ELSE
                    next_time_in_zone := (timezone('UTC', (next_date + start_time)) at time zone event.timezone_name)::time;
                    time_offset := (original_date_in_zone + next_time_in_zone) - (original_date_in_zone + start_time_in_zone);
                    event.starts_at := next_date + start_time - time_offset;

                    CONTINUE WHEN event.starts_at > range_end;
                    event.ends_at := event.starts_at + duration;
                    CONTINUE WHEN event.ends_at < range_start;
                  END IF;

                  RETURN NEXT event;
                END LOOP;
              END LOOP;
              RETURN;
            END;
            $$;


ALTER FUNCTION public.recurring_event_occurrence_for(range_start timestamp without time zone, range_end timestamp without time zone, time_zone character varying, event_occurrence_limit integer) OWNER TO mapas;

--
-- TOC entry 282 (class 1259 OID 18170)
-- Name: _mesoregiao; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public._mesoregiao (
    gid integer NOT NULL,
    id double precision,
    nm_meso character varying(100),
    cd_geocodu character varying(2),
    geom public.geometry(MultiPolygon,4326)
);


ALTER TABLE public._mesoregiao OWNER TO mapas;

--
-- TOC entry 283 (class 1259 OID 18175)
-- Name: _mesoregiao_gid_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public._mesoregiao_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._mesoregiao_gid_seq OWNER TO mapas;

--
-- TOC entry 5347 (class 0 OID 0)
-- Dependencies: 283
-- Name: _mesoregiao_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public._mesoregiao_gid_seq OWNED BY public._mesoregiao.gid;


--
-- TOC entry 284 (class 1259 OID 18176)
-- Name: _microregiao; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public._microregiao (
    gid integer NOT NULL,
    id double precision,
    nm_micro character varying(100),
    cd_geocodu character varying(2),
    geom public.geometry(MultiPolygon,4326)
);


ALTER TABLE public._microregiao OWNER TO mapas;

--
-- TOC entry 285 (class 1259 OID 18181)
-- Name: _microregiao_gid_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public._microregiao_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._microregiao_gid_seq OWNER TO mapas;

--
-- TOC entry 5348 (class 0 OID 0)
-- Dependencies: 285
-- Name: _microregiao_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public._microregiao_gid_seq OWNED BY public._microregiao.gid;


--
-- TOC entry 286 (class 1259 OID 18182)
-- Name: _municipios; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public._municipios (
    gid integer NOT NULL,
    id double precision,
    cd_geocodm character varying(20),
    nm_municip character varying(60),
    geom public.geometry(MultiPolygon,4326)
);


ALTER TABLE public._municipios OWNER TO mapas;

--
-- TOC entry 287 (class 1259 OID 18187)
-- Name: _municipios_gid_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public._municipios_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._municipios_gid_seq OWNER TO mapas;

--
-- TOC entry 5349 (class 0 OID 0)
-- Dependencies: 287
-- Name: _municipios_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public._municipios_gid_seq OWNED BY public._municipios.gid;


--
-- TOC entry 288 (class 1259 OID 18188)
-- Name: agent_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.agent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agent_id_seq OWNER TO mapas;

--
-- TOC entry 289 (class 1259 OID 18189)
-- Name: agent; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.agent (
    id integer DEFAULT nextval('public.agent_id_seq'::regclass) NOT NULL,
    parent_id integer,
    user_id integer NOT NULL,
    type smallint NOT NULL,
    name character varying(255) NOT NULL,
    location point,
    _geo_location public.geography,
    short_description text,
    long_description text,
    create_timestamp timestamp without time zone NOT NULL,
    status smallint NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    public_location boolean,
    update_timestamp timestamp(0) without time zone,
    subsite_id integer
);


ALTER TABLE public.agent OWNER TO mapas;

--
-- TOC entry 5350 (class 0 OID 0)
-- Dependencies: 289
-- Name: COLUMN agent.location; Type: COMMENT; Schema: public; Owner: mapas
--

COMMENT ON COLUMN public.agent.location IS 'type=POINT';


--
-- TOC entry 290 (class 1259 OID 18196)
-- Name: agent_meta; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.agent_meta (
    object_id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text,
    id integer NOT NULL
);


ALTER TABLE public.agent_meta OWNER TO mapas;

--
-- TOC entry 291 (class 1259 OID 18201)
-- Name: agent_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.agent_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agent_meta_id_seq OWNER TO mapas;

--
-- TOC entry 5351 (class 0 OID 0)
-- Dependencies: 291
-- Name: agent_meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.agent_meta_id_seq OWNED BY public.agent_meta.id;


--
-- TOC entry 292 (class 1259 OID 18202)
-- Name: agent_relation; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.agent_relation (
    id integer NOT NULL,
    agent_id integer NOT NULL,
    object_type public.object_type NOT NULL,
    object_id integer NOT NULL,
    type character varying(64),
    has_control boolean DEFAULT false NOT NULL,
    create_timestamp timestamp without time zone,
    status smallint,
    metadata json
);


ALTER TABLE public.agent_relation OWNER TO mapas;

--
-- TOC entry 293 (class 1259 OID 18206)
-- Name: agent_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.agent_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agent_relation_id_seq OWNER TO mapas;

--
-- TOC entry 5352 (class 0 OID 0)
-- Dependencies: 293
-- Name: agent_relation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.agent_relation_id_seq OWNED BY public.agent_relation.id;


--
-- TOC entry 386 (class 1259 OID 19069)
-- Name: chat_message; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.chat_message (
    id integer NOT NULL,
    chat_thread_id integer NOT NULL,
    parent_id integer,
    user_id integer NOT NULL,
    payload text NOT NULL,
    create_timestamp timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.chat_message OWNER TO mapas;

--
-- TOC entry 385 (class 1259 OID 19068)
-- Name: chat_message_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.chat_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chat_message_id_seq OWNER TO mapas;

--
-- TOC entry 384 (class 1259 OID 19060)
-- Name: chat_thread; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.chat_thread (
    id integer NOT NULL,
    object_id integer NOT NULL,
    object_type character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    identifier character varying(255) NOT NULL,
    description text,
    create_timestamp timestamp(0) without time zone NOT NULL,
    last_message_timestamp timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    status integer NOT NULL
);


ALTER TABLE public.chat_thread OWNER TO mapas;

--
-- TOC entry 5353 (class 0 OID 0)
-- Dependencies: 384
-- Name: COLUMN chat_thread.object_type; Type: COMMENT; Schema: public; Owner: mapas
--

COMMENT ON COLUMN public.chat_thread.object_type IS '(DC2Type:object_type)';


--
-- TOC entry 383 (class 1259 OID 19059)
-- Name: chat_thread_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.chat_thread_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chat_thread_id_seq OWNER TO mapas;

--
-- TOC entry 294 (class 1259 OID 18207)
-- Name: db_update; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.db_update (
    name character varying(255) NOT NULL,
    exec_time timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.db_update OWNER TO mapas;

--
-- TOC entry 295 (class 1259 OID 18211)
-- Name: entity_revision; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.entity_revision (
    id integer NOT NULL,
    user_id integer,
    object_id integer NOT NULL,
    object_type public.object_type NOT NULL,
    create_timestamp timestamp(0) without time zone NOT NULL,
    action character varying(255) NOT NULL,
    message text NOT NULL
);


ALTER TABLE public.entity_revision OWNER TO mapas;

--
-- TOC entry 296 (class 1259 OID 18216)
-- Name: entity_revision_data; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.entity_revision_data (
    id integer NOT NULL,
    "timestamp" timestamp(0) without time zone NOT NULL,
    key character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.entity_revision_data OWNER TO mapas;

--
-- TOC entry 297 (class 1259 OID 18221)
-- Name: entity_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.entity_revision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entity_revision_id_seq OWNER TO mapas;

--
-- TOC entry 298 (class 1259 OID 18222)
-- Name: entity_revision_revision_data; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.entity_revision_revision_data (
    revision_id integer NOT NULL,
    revision_data_id integer NOT NULL
);


ALTER TABLE public.entity_revision_revision_data OWNER TO mapas;

--
-- TOC entry 299 (class 1259 OID 18225)
-- Name: evaluation_method_configuration; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.evaluation_method_configuration (
    id integer NOT NULL,
    opportunity_id integer NOT NULL,
    type character varying(255) NOT NULL,
    evaluation_from timestamp without time zone,
    evaluation_to timestamp without time zone,
    name character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.evaluation_method_configuration OWNER TO mapas;

--
-- TOC entry 300 (class 1259 OID 18228)
-- Name: evaluation_method_configuration_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.evaluation_method_configuration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.evaluation_method_configuration_id_seq OWNER TO mapas;

--
-- TOC entry 5354 (class 0 OID 0)
-- Dependencies: 300
-- Name: evaluation_method_configuration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.evaluation_method_configuration_id_seq OWNED BY public.evaluation_method_configuration.id;


--
-- TOC entry 301 (class 1259 OID 18229)
-- Name: evaluationmethodconfiguration_meta; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.evaluationmethodconfiguration_meta (
    id integer NOT NULL,
    object_id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.evaluationmethodconfiguration_meta OWNER TO mapas;

--
-- TOC entry 302 (class 1259 OID 18234)
-- Name: evaluationmethodconfiguration_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.evaluationmethodconfiguration_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.evaluationmethodconfiguration_meta_id_seq OWNER TO mapas;

--
-- TOC entry 303 (class 1259 OID 18235)
-- Name: pcache_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.pcache_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pcache_id_seq OWNER TO mapas;

--
-- TOC entry 304 (class 1259 OID 18236)
-- Name: pcache; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.pcache (
    id integer DEFAULT nextval('public.pcache_id_seq'::regclass) NOT NULL,
    user_id integer NOT NULL,
    action public.permission_action NOT NULL,
    create_timestamp timestamp(0) without time zone NOT NULL,
    object_type public.object_type NOT NULL,
    object_id integer
);


ALTER TABLE public.pcache OWNER TO mapas;

--
-- TOC entry 305 (class 1259 OID 18240)
-- Name: registration; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.registration (
    id integer DEFAULT public.pseudo_random_id_generator() NOT NULL,
    opportunity_id integer NOT NULL,
    category character varying(255),
    agent_id integer NOT NULL,
    create_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    sent_timestamp timestamp without time zone,
    status smallint NOT NULL,
    agents_data text,
    subsite_id integer,
    consolidated_result character varying(255) DEFAULT NULL::character varying,
    number character varying(24),
    valuers_exceptions_list text DEFAULT '{"include": [], "exclude": []}'::text NOT NULL,
    space_data text,
    proponent_type character varying(255),
    range character varying(255),
    score double precision,
    eligible boolean
);


ALTER TABLE public.registration OWNER TO mapas;

--
-- TOC entry 306 (class 1259 OID 18249)
-- Name: registration_evaluation; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.registration_evaluation (
    id integer NOT NULL,
    registration_id integer DEFAULT public.pseudo_random_id_generator() NOT NULL,
    user_id integer NOT NULL,
    result character varying(255) DEFAULT NULL::character varying,
    evaluation_data text NOT NULL,
    status smallint,
    create_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    update_timestamp timestamp without time zone
);


ALTER TABLE public.registration_evaluation OWNER TO mapas;

--
-- TOC entry 307 (class 1259 OID 18256)
-- Name: usr_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.usr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usr_id_seq OWNER TO mapas;

--
-- TOC entry 308 (class 1259 OID 18257)
-- Name: usr; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.usr (
    id integer DEFAULT nextval('public.usr_id_seq'::regclass) NOT NULL,
    auth_provider smallint NOT NULL,
    auth_uid character varying(512) NOT NULL,
    email character varying(255) NOT NULL,
    last_login_timestamp timestamp without time zone NOT NULL,
    create_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    status smallint NOT NULL,
    profile_id integer
);


ALTER TABLE public.usr OWNER TO mapas;

--
-- TOC entry 5355 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN usr.auth_provider; Type: COMMENT; Schema: public; Owner: mapas
--

COMMENT ON COLUMN public.usr.auth_provider IS '1=openid';


--
-- TOC entry 382 (class 1259 OID 19045)
-- Name: evaluations; Type: VIEW; Schema: public; Owner: mapas
--

CREATE VIEW public.evaluations AS
 SELECT evaluations_view.registration_id,
    evaluations_view.registration_sent_timestamp,
    evaluations_view.registration_number,
    evaluations_view.registration_category,
    evaluations_view.registration_agent_id,
    evaluations_view.opportunity_id,
    evaluations_view.valuer_user_id,
    evaluations_view.valuer_agent_id,
    max(evaluations_view.evaluation_id) AS evaluation_id,
    max((evaluations_view.evaluation_result)::text) AS evaluation_result,
    max(evaluations_view.evaluation_status) AS evaluation_status
   FROM ( SELECT r.id AS registration_id,
            r.sent_timestamp AS registration_sent_timestamp,
            r.number AS registration_number,
            r.category AS registration_category,
            r.agent_id AS registration_agent_id,
            re.user_id AS valuer_user_id,
            u.profile_id AS valuer_agent_id,
            r.opportunity_id,
            re.id AS evaluation_id,
            re.result AS evaluation_result,
            re.status AS evaluation_status
           FROM ((public.registration r
             JOIN public.registration_evaluation re ON ((re.registration_id = r.id)))
             JOIN public.usr u ON ((u.id = re.user_id)))
          WHERE (r.status > 0)
        UNION
         SELECT r2.id AS registration_id,
            r2.sent_timestamp AS registration_sent_timestamp,
            r2.number AS registration_number,
            r2.category AS registration_category,
            r2.agent_id AS registration_agent_id,
            p2.user_id AS valuer_user_id,
            u2.profile_id AS valuer_agent_id,
            r2.opportunity_id,
            NULL::integer AS evaluation_id,
            NULL::character varying AS evaluation_result,
            NULL::smallint AS evaluation_status
           FROM (((public.registration r2
             JOIN public.pcache p2 ON (((p2.object_id = r2.id) AND (p2.object_type = 'MapasCulturais\Entities\Registration'::public.object_type) AND (p2.action = 'evaluateOnTime'::public.permission_action))))
             JOIN public.usr u2 ON ((u2.id = p2.user_id)))
             JOIN public.evaluation_method_configuration emc ON ((emc.opportunity_id = r2.opportunity_id)))
          WHERE (r2.status > 0)) evaluations_view
  GROUP BY evaluations_view.registration_id, evaluations_view.registration_sent_timestamp, evaluations_view.registration_number, evaluations_view.registration_category, evaluations_view.registration_agent_id, evaluations_view.valuer_user_id, evaluations_view.valuer_agent_id, evaluations_view.opportunity_id;


ALTER TABLE public.evaluations OWNER TO mapas;

--
-- TOC entry 309 (class 1259 OID 18269)
-- Name: event; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.event (
    id integer NOT NULL,
    project_id integer,
    name character varying(255) NOT NULL,
    short_description text NOT NULL,
    long_description text,
    rules text,
    create_timestamp timestamp without time zone NOT NULL,
    status smallint NOT NULL,
    agent_id integer,
    is_verified boolean DEFAULT false NOT NULL,
    type smallint NOT NULL,
    update_timestamp timestamp(0) without time zone,
    subsite_id integer
);


ALTER TABLE public.event OWNER TO mapas;

--
-- TOC entry 310 (class 1259 OID 18275)
-- Name: event_attendance; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.event_attendance (
    id integer NOT NULL,
    user_id integer NOT NULL,
    event_occurrence_id integer NOT NULL,
    event_id integer NOT NULL,
    space_id integer NOT NULL,
    type character varying(255) NOT NULL,
    reccurrence_string text,
    start_timestamp timestamp(0) without time zone NOT NULL,
    end_timestamp timestamp(0) without time zone NOT NULL,
    create_timestamp timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.event_attendance OWNER TO mapas;

--
-- TOC entry 311 (class 1259 OID 18280)
-- Name: event_attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.event_attendance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_attendance_id_seq OWNER TO mapas;

--
-- TOC entry 312 (class 1259 OID 18281)
-- Name: event_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_id_seq OWNER TO mapas;

--
-- TOC entry 5356 (class 0 OID 0)
-- Dependencies: 312
-- Name: event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.event_id_seq OWNED BY public.event.id;


--
-- TOC entry 313 (class 1259 OID 18282)
-- Name: event_meta; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.event_meta (
    key character varying(255) NOT NULL,
    object_id integer NOT NULL,
    value text,
    id integer NOT NULL
);


ALTER TABLE public.event_meta OWNER TO mapas;

--
-- TOC entry 314 (class 1259 OID 18287)
-- Name: event_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.event_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_meta_id_seq OWNER TO mapas;

--
-- TOC entry 5357 (class 0 OID 0)
-- Dependencies: 314
-- Name: event_meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.event_meta_id_seq OWNED BY public.event_meta.id;


--
-- TOC entry 315 (class 1259 OID 18288)
-- Name: event_occurrence_cancellation; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.event_occurrence_cancellation (
    id integer NOT NULL,
    event_occurrence_id integer,
    date date
);


ALTER TABLE public.event_occurrence_cancellation OWNER TO mapas;

--
-- TOC entry 316 (class 1259 OID 18291)
-- Name: event_occurrence_cancellation_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.event_occurrence_cancellation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_occurrence_cancellation_id_seq OWNER TO mapas;

--
-- TOC entry 5358 (class 0 OID 0)
-- Dependencies: 316
-- Name: event_occurrence_cancellation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.event_occurrence_cancellation_id_seq OWNED BY public.event_occurrence_cancellation.id;


--
-- TOC entry 317 (class 1259 OID 18292)
-- Name: event_occurrence_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.event_occurrence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_occurrence_id_seq OWNER TO mapas;

--
-- TOC entry 5359 (class 0 OID 0)
-- Dependencies: 317
-- Name: event_occurrence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.event_occurrence_id_seq OWNED BY public.event_occurrence.id;


--
-- TOC entry 318 (class 1259 OID 18293)
-- Name: event_occurrence_recurrence; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.event_occurrence_recurrence (
    id integer NOT NULL,
    event_occurrence_id integer,
    month integer,
    day integer,
    week integer
);


ALTER TABLE public.event_occurrence_recurrence OWNER TO mapas;

--
-- TOC entry 319 (class 1259 OID 18296)
-- Name: event_occurrence_recurrence_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.event_occurrence_recurrence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_occurrence_recurrence_id_seq OWNER TO mapas;

--
-- TOC entry 5360 (class 0 OID 0)
-- Dependencies: 319
-- Name: event_occurrence_recurrence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.event_occurrence_recurrence_id_seq OWNED BY public.event_occurrence_recurrence.id;


--
-- TOC entry 320 (class 1259 OID 18297)
-- Name: file_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.file_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.file_id_seq OWNER TO mapas;

--
-- TOC entry 321 (class 1259 OID 18298)
-- Name: file; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.file (
    id integer DEFAULT nextval('public.file_id_seq'::regclass) NOT NULL,
    md5 character varying(32) NOT NULL,
    mime_type character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    object_type public.object_type NOT NULL,
    object_id integer NOT NULL,
    create_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    grp character varying(32) NOT NULL,
    description text,
    parent_id integer,
    path character varying(1024) DEFAULT NULL::character varying,
    private boolean DEFAULT false NOT NULL
);


ALTER TABLE public.file OWNER TO mapas;

--
-- TOC entry 322 (class 1259 OID 18307)
-- Name: geo_division_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.geo_division_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.geo_division_id_seq OWNER TO mapas;

--
-- TOC entry 323 (class 1259 OID 18308)
-- Name: geo_division; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.geo_division (
    id integer DEFAULT nextval('public.geo_division_id_seq'::regclass) NOT NULL,
    parent_id integer,
    type character varying(32) NOT NULL,
    cod character varying(32),
    name character varying(128) NOT NULL,
    geom public.geometry,
    CONSTRAINT enforce_dims_geom CHECK ((public.st_ndims(geom) = 2)),
    CONSTRAINT enforce_geotype_geom CHECK (((public.geometrytype(geom) = 'MULTIPOLYGON'::text) OR (public.geometrytype(geom) = 'POLYGON'::text) OR (geom IS NULL))),
    CONSTRAINT enforce_srid_geom CHECK ((public.st_srid(geom) = 4326))
);


ALTER TABLE public.geo_division OWNER TO mapas;

--
-- TOC entry 387 (class 1259 OID 19094)
-- Name: job; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.job (
    id character varying(255) NOT NULL,
    name character varying(32) NOT NULL,
    iterations integer NOT NULL,
    iterations_count integer NOT NULL,
    interval_string character varying(255) NOT NULL,
    create_timestamp timestamp(0) without time zone NOT NULL,
    next_execution_timestamp timestamp(0) without time zone NOT NULL,
    last_execution_timestamp timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    metadata json NOT NULL,
    status smallint NOT NULL
);


ALTER TABLE public.job OWNER TO mapas;

--
-- TOC entry 5361 (class 0 OID 0)
-- Dependencies: 387
-- Name: COLUMN job.metadata; Type: COMMENT; Schema: public; Owner: mapas
--

COMMENT ON COLUMN public.job.metadata IS '(DC2Type:json)';


--
-- TOC entry 324 (class 1259 OID 18317)
-- Name: metadata; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.metadata (
    object_id integer NOT NULL,
    object_type public.object_type NOT NULL,
    key character varying(32) NOT NULL,
    value text
);


ALTER TABLE public.metadata OWNER TO mapas;

--
-- TOC entry 325 (class 1259 OID 18322)
-- Name: metalist_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.metalist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metalist_id_seq OWNER TO mapas;

--
-- TOC entry 326 (class 1259 OID 18323)
-- Name: metalist; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.metalist (
    id integer DEFAULT nextval('public.metalist_id_seq'::regclass) NOT NULL,
    object_type character varying(255) NOT NULL,
    object_id integer NOT NULL,
    grp character varying(32) NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    value text NOT NULL,
    create_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    "order" smallint
);


ALTER TABLE public.metalist OWNER TO mapas;

--
-- TOC entry 327 (class 1259 OID 18330)
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_id_seq OWNER TO mapas;

--
-- TOC entry 328 (class 1259 OID 18331)
-- Name: notification; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.notification (
    id integer DEFAULT nextval('public.notification_id_seq'::regclass) NOT NULL,
    user_id integer NOT NULL,
    request_id integer,
    message text NOT NULL,
    create_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    action_timestamp timestamp without time zone,
    status smallint NOT NULL
);


ALTER TABLE public.notification OWNER TO mapas;

--
-- TOC entry 329 (class 1259 OID 18338)
-- Name: notification_meta; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.notification_meta (
    id integer NOT NULL,
    object_id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.notification_meta OWNER TO mapas;

--
-- TOC entry 330 (class 1259 OID 18343)
-- Name: notification_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.notification_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_meta_id_seq OWNER TO mapas;

--
-- TOC entry 331 (class 1259 OID 18344)
-- Name: occurrence_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.occurrence_id_seq
    START WITH 100000
    INCREMENT BY 1
    MINVALUE 100000
    NO MAXVALUE
    CACHE 1
    CYCLE;


ALTER TABLE public.occurrence_id_seq OWNER TO mapas;

--
-- TOC entry 332 (class 1259 OID 18345)
-- Name: opportunity_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.opportunity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.opportunity_id_seq OWNER TO mapas;

--
-- TOC entry 333 (class 1259 OID 18346)
-- Name: opportunity; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.opportunity (
    id integer DEFAULT nextval('public.opportunity_id_seq'::regclass) NOT NULL,
    parent_id integer,
    agent_id integer NOT NULL,
    type smallint,
    name character varying(255) NOT NULL,
    short_description text,
    long_description text,
    registration_from timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    registration_to timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    published_registrations boolean NOT NULL,
    registration_categories text,
    create_timestamp timestamp(0) without time zone NOT NULL,
    update_timestamp timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    status smallint NOT NULL,
    subsite_id integer,
    object_type character varying(255) NOT NULL,
    object_id integer NOT NULL,
    avaliable_evaluation_fields json,
    publish_timestamp timestamp without time zone,
    auto_publish boolean DEFAULT false NOT NULL,
    registration_proponent_types json,
    registration_ranges json
);


ALTER TABLE public.opportunity OWNER TO mapas;

--
-- TOC entry 334 (class 1259 OID 18355)
-- Name: opportunity_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.opportunity_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.opportunity_meta_id_seq OWNER TO mapas;

--
-- TOC entry 335 (class 1259 OID 18356)
-- Name: opportunity_meta; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.opportunity_meta (
    id integer DEFAULT nextval('public.opportunity_meta_id_seq'::regclass) NOT NULL,
    object_id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.opportunity_meta OWNER TO mapas;

--
-- TOC entry 336 (class 1259 OID 18362)
-- Name: permission_cache_pending; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.permission_cache_pending (
    id integer NOT NULL,
    object_id integer NOT NULL,
    object_type character varying(255) NOT NULL,
    status smallint DEFAULT 0,
    usr_id integer
);


ALTER TABLE public.permission_cache_pending OWNER TO mapas;

--
-- TOC entry 337 (class 1259 OID 18366)
-- Name: permission_cache_pending_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.permission_cache_pending_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permission_cache_pending_seq OWNER TO mapas;

--
-- TOC entry 338 (class 1259 OID 18367)
-- Name: procuration; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.procuration (
    token character varying(32) NOT NULL,
    usr_id integer NOT NULL,
    attorney_user_id integer NOT NULL,
    action character varying(255) NOT NULL,
    create_timestamp timestamp(0) without time zone NOT NULL,
    valid_until_timestamp timestamp(0) without time zone DEFAULT NULL::timestamp without time zone
);


ALTER TABLE public.procuration OWNER TO mapas;

--
-- TOC entry 339 (class 1259 OID 18371)
-- Name: project; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.project (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    short_description text,
    long_description text,
    create_timestamp timestamp without time zone NOT NULL,
    status smallint NOT NULL,
    agent_id integer,
    is_verified boolean DEFAULT false NOT NULL,
    type smallint NOT NULL,
    parent_id integer,
    starts_on timestamp without time zone,
    ends_on timestamp without time zone,
    update_timestamp timestamp(0) without time zone,
    subsite_id integer
);


ALTER TABLE public.project OWNER TO mapas;

--
-- TOC entry 340 (class 1259 OID 18377)
-- Name: project_event; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.project_event (
    id integer NOT NULL,
    event_id integer NOT NULL,
    project_id integer NOT NULL,
    type smallint NOT NULL,
    status smallint NOT NULL
);


ALTER TABLE public.project_event OWNER TO mapas;

--
-- TOC entry 341 (class 1259 OID 18380)
-- Name: project_event_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.project_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_event_id_seq OWNER TO mapas;

--
-- TOC entry 5362 (class 0 OID 0)
-- Dependencies: 341
-- Name: project_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.project_event_id_seq OWNED BY public.project_event.id;


--
-- TOC entry 342 (class 1259 OID 18381)
-- Name: project_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_id_seq OWNER TO mapas;

--
-- TOC entry 5363 (class 0 OID 0)
-- Dependencies: 342
-- Name: project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.project_id_seq OWNED BY public.project.id;


--
-- TOC entry 343 (class 1259 OID 18382)
-- Name: project_meta; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.project_meta (
    object_id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text,
    id integer NOT NULL
);


ALTER TABLE public.project_meta OWNER TO mapas;

--
-- TOC entry 344 (class 1259 OID 18387)
-- Name: project_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.project_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_meta_id_seq OWNER TO mapas;

--
-- TOC entry 5364 (class 0 OID 0)
-- Dependencies: 344
-- Name: project_meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.project_meta_id_seq OWNED BY public.project_meta.id;


--
-- TOC entry 345 (class 1259 OID 18388)
-- Name: pseudo_random_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.pseudo_random_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pseudo_random_id_seq OWNER TO mapas;

--
-- TOC entry 346 (class 1259 OID 18389)
-- Name: registration_evaluation_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.registration_evaluation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registration_evaluation_id_seq OWNER TO mapas;

--
-- TOC entry 347 (class 1259 OID 18390)
-- Name: registration_field_configuration; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.registration_field_configuration (
    id integer NOT NULL,
    opportunity_id integer,
    title character varying(255) NOT NULL,
    description text,
    categories text,
    required boolean NOT NULL,
    field_type character varying(255) NOT NULL,
    field_options text NOT NULL,
    max_size text,
    display_order smallint DEFAULT 255,
    config text,
    conditional boolean,
    conditional_field character varying(255),
    conditional_value character varying(255),
    registration_ranges json,
    proponent_types json
);


ALTER TABLE public.registration_field_configuration OWNER TO mapas;

--
-- TOC entry 5365 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN registration_field_configuration.categories; Type: COMMENT; Schema: public; Owner: mapas
--

COMMENT ON COLUMN public.registration_field_configuration.categories IS '(DC2Type:array)';


--
-- TOC entry 348 (class 1259 OID 18396)
-- Name: registration_field_configuration_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.registration_field_configuration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registration_field_configuration_id_seq OWNER TO mapas;

--
-- TOC entry 349 (class 1259 OID 18397)
-- Name: registration_file_configuration; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.registration_file_configuration (
    id integer NOT NULL,
    opportunity_id integer,
    title character varying(255) NOT NULL,
    description text,
    required boolean NOT NULL,
    categories text,
    display_order smallint DEFAULT 255,
    conditional boolean,
    conditional_field character varying(255),
    conditional_value character varying(255),
    registration_ranges json,
    proponent_types json
);


ALTER TABLE public.registration_file_configuration OWNER TO mapas;

--
-- TOC entry 5366 (class 0 OID 0)
-- Dependencies: 349
-- Name: COLUMN registration_file_configuration.categories; Type: COMMENT; Schema: public; Owner: mapas
--

COMMENT ON COLUMN public.registration_file_configuration.categories IS '(DC2Type:array)';


--
-- TOC entry 350 (class 1259 OID 18403)
-- Name: registration_file_configuration_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.registration_file_configuration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registration_file_configuration_id_seq OWNER TO mapas;

--
-- TOC entry 5367 (class 0 OID 0)
-- Dependencies: 350
-- Name: registration_file_configuration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.registration_file_configuration_id_seq OWNED BY public.registration_file_configuration.id;


--
-- TOC entry 351 (class 1259 OID 18404)
-- Name: registration_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registration_id_seq OWNER TO mapas;

--
-- TOC entry 352 (class 1259 OID 18405)
-- Name: registration_meta; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.registration_meta (
    object_id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text,
    id integer NOT NULL
);


ALTER TABLE public.registration_meta OWNER TO mapas;

--
-- TOC entry 353 (class 1259 OID 18410)
-- Name: registration_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.registration_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registration_meta_id_seq OWNER TO mapas;

--
-- TOC entry 5368 (class 0 OID 0)
-- Dependencies: 353
-- Name: registration_meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.registration_meta_id_seq OWNED BY public.registration_meta.id;


--
-- TOC entry 354 (class 1259 OID 18411)
-- Name: request_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.request_id_seq OWNER TO mapas;

--
-- TOC entry 355 (class 1259 OID 18412)
-- Name: request; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.request (
    id integer DEFAULT nextval('public.request_id_seq'::regclass) NOT NULL,
    request_uid character varying(32) NOT NULL,
    requester_user_id integer NOT NULL,
    origin_type character varying(255) NOT NULL,
    origin_id integer NOT NULL,
    destination_type character varying(255) NOT NULL,
    destination_id integer NOT NULL,
    metadata text,
    type character varying(255) NOT NULL,
    create_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    action_timestamp timestamp without time zone,
    status smallint NOT NULL
);


ALTER TABLE public.request OWNER TO mapas;

--
-- TOC entry 356 (class 1259 OID 18419)
-- Name: revision_data_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.revision_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.revision_data_id_seq OWNER TO mapas;

--
-- TOC entry 357 (class 1259 OID 18420)
-- Name: role; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.role (
    id integer NOT NULL,
    usr_id integer,
    name character varying(32) NOT NULL,
    subsite_id integer
);


ALTER TABLE public.role OWNER TO mapas;

--
-- TOC entry 358 (class 1259 OID 18423)
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_id_seq OWNER TO mapas;

--
-- TOC entry 5369 (class 0 OID 0)
-- Dependencies: 358
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;


--
-- TOC entry 359 (class 1259 OID 18424)
-- Name: seal; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.seal (
    id integer NOT NULL,
    agent_id integer NOT NULL,
    name character varying(255) NOT NULL,
    short_description text,
    long_description text,
    valid_period smallint NOT NULL,
    create_timestamp timestamp(0) without time zone NOT NULL,
    status smallint NOT NULL,
    certificate_text text,
    update_timestamp timestamp(0) without time zone,
    subsite_id integer,
    locked_fields json DEFAULT '[]'::json
);


ALTER TABLE public.seal OWNER TO mapas;

--
-- TOC entry 360 (class 1259 OID 18429)
-- Name: seal_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.seal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seal_id_seq OWNER TO mapas;

--
-- TOC entry 361 (class 1259 OID 18430)
-- Name: seal_meta; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.seal_meta (
    id integer NOT NULL,
    object_id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.seal_meta OWNER TO mapas;

--
-- TOC entry 362 (class 1259 OID 18435)
-- Name: seal_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.seal_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seal_meta_id_seq OWNER TO mapas;

--
-- TOC entry 363 (class 1259 OID 18436)
-- Name: seal_relation; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.seal_relation (
    id integer NOT NULL,
    seal_id integer,
    object_id integer NOT NULL,
    create_timestamp timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    status smallint,
    object_type character varying(255) NOT NULL,
    agent_id integer NOT NULL,
    owner_id integer,
    validate_date date,
    renovation_request boolean
);


ALTER TABLE public.seal_relation OWNER TO mapas;

--
-- TOC entry 364 (class 1259 OID 18440)
-- Name: seal_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.seal_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seal_relation_id_seq OWNER TO mapas;

--
-- TOC entry 365 (class 1259 OID 18441)
-- Name: space; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.space (
    id integer NOT NULL,
    parent_id integer,
    location point,
    _geo_location public.geography,
    name character varying(255) NOT NULL,
    short_description text,
    long_description text,
    create_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    status smallint NOT NULL,
    type smallint NOT NULL,
    agent_id integer,
    is_verified boolean DEFAULT false NOT NULL,
    public boolean DEFAULT false NOT NULL,
    update_timestamp timestamp(0) without time zone,
    subsite_id integer
);


ALTER TABLE public.space OWNER TO mapas;

--
-- TOC entry 5370 (class 0 OID 0)
-- Dependencies: 365
-- Name: COLUMN space.location; Type: COMMENT; Schema: public; Owner: mapas
--

COMMENT ON COLUMN public.space.location IS 'type=POINT';


--
-- TOC entry 366 (class 1259 OID 18449)
-- Name: space_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.space_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.space_id_seq OWNER TO mapas;

--
-- TOC entry 5371 (class 0 OID 0)
-- Dependencies: 366
-- Name: space_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.space_id_seq OWNED BY public.space.id;


--
-- TOC entry 367 (class 1259 OID 18450)
-- Name: space_meta; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.space_meta (
    object_id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text,
    id integer NOT NULL
);


ALTER TABLE public.space_meta OWNER TO mapas;

--
-- TOC entry 368 (class 1259 OID 18455)
-- Name: space_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.space_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.space_meta_id_seq OWNER TO mapas;

--
-- TOC entry 5372 (class 0 OID 0)
-- Dependencies: 368
-- Name: space_meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.space_meta_id_seq OWNED BY public.space_meta.id;


--
-- TOC entry 369 (class 1259 OID 18456)
-- Name: space_relation; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.space_relation (
    id integer NOT NULL,
    space_id integer,
    object_id integer NOT NULL,
    create_timestamp timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    status smallint,
    object_type character varying(255) NOT NULL
);


ALTER TABLE public.space_relation OWNER TO mapas;

--
-- TOC entry 370 (class 1259 OID 18460)
-- Name: space_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.space_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.space_relation_id_seq OWNER TO mapas;

--
-- TOC entry 371 (class 1259 OID 18461)
-- Name: subsite; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.subsite (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    create_timestamp timestamp(0) without time zone NOT NULL,
    status smallint NOT NULL,
    agent_id integer NOT NULL,
    url character varying(255) NOT NULL,
    namespace character varying(50) NOT NULL,
    alias_url character varying(255) DEFAULT NULL::character varying,
    verified_seals character varying(512) DEFAULT '[]'::character varying
);


ALTER TABLE public.subsite OWNER TO mapas;

--
-- TOC entry 372 (class 1259 OID 18468)
-- Name: subsite_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.subsite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subsite_id_seq OWNER TO mapas;

--
-- TOC entry 373 (class 1259 OID 18469)
-- Name: subsite_meta; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.subsite_meta (
    object_id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text,
    id integer NOT NULL
);


ALTER TABLE public.subsite_meta OWNER TO mapas;

--
-- TOC entry 374 (class 1259 OID 18474)
-- Name: subsite_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.subsite_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subsite_meta_id_seq OWNER TO mapas;

--
-- TOC entry 389 (class 1259 OID 19148)
-- Name: system_role; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.system_role (
    id integer NOT NULL,
    slug character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    subsite_context boolean NOT NULL,
    permissions json,
    create_timestamp timestamp(0) without time zone NOT NULL,
    update_timestamp timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    status smallint NOT NULL
);


ALTER TABLE public.system_role OWNER TO mapas;

--
-- TOC entry 5373 (class 0 OID 0)
-- Dependencies: 389
-- Name: COLUMN system_role.permissions; Type: COMMENT; Schema: public; Owner: mapas
--

COMMENT ON COLUMN public.system_role.permissions IS '(DC2Type:json)';


--
-- TOC entry 388 (class 1259 OID 19147)
-- Name: system_role_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.system_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.system_role_id_seq OWNER TO mapas;

--
-- TOC entry 375 (class 1259 OID 18475)
-- Name: term; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.term (
    id integer NOT NULL,
    taxonomy character varying(64) NOT NULL,
    term character varying(255) NOT NULL,
    description text
);


ALTER TABLE public.term OWNER TO mapas;

--
-- TOC entry 5374 (class 0 OID 0)
-- Dependencies: 375
-- Name: COLUMN term.taxonomy; Type: COMMENT; Schema: public; Owner: mapas
--

COMMENT ON COLUMN public.term.taxonomy IS '1=tag';


--
-- TOC entry 376 (class 1259 OID 18480)
-- Name: term_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.term_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.term_id_seq OWNER TO mapas;

--
-- TOC entry 5375 (class 0 OID 0)
-- Dependencies: 376
-- Name: term_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.term_id_seq OWNED BY public.term.id;


--
-- TOC entry 377 (class 1259 OID 18481)
-- Name: term_relation; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.term_relation (
    term_id integer NOT NULL,
    object_type public.object_type NOT NULL,
    object_id integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.term_relation OWNER TO mapas;

--
-- TOC entry 378 (class 1259 OID 18484)
-- Name: term_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.term_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.term_relation_id_seq OWNER TO mapas;

--
-- TOC entry 5376 (class 0 OID 0)
-- Dependencies: 378
-- Name: term_relation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapas
--

ALTER SEQUENCE public.term_relation_id_seq OWNED BY public.term_relation.id;


--
-- TOC entry 379 (class 1259 OID 18485)
-- Name: user_app; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.user_app (
    public_key character varying(64) NOT NULL,
    private_key character varying(128) NOT NULL,
    user_id integer NOT NULL,
    name text NOT NULL,
    status integer NOT NULL,
    create_timestamp timestamp without time zone NOT NULL,
    subsite_id integer
);


ALTER TABLE public.user_app OWNER TO mapas;

--
-- TOC entry 380 (class 1259 OID 18490)
-- Name: user_meta; Type: TABLE; Schema: public; Owner: mapas
--

CREATE TABLE public.user_meta (
    object_id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text,
    id integer NOT NULL
);


ALTER TABLE public.user_meta OWNER TO mapas;

--
-- TOC entry 381 (class 1259 OID 18495)
-- Name: user_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: mapas
--

CREATE SEQUENCE public.user_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_meta_id_seq OWNER TO mapas;

--
-- TOC entry 4723 (class 2604 OID 18496)
-- Name: _mesoregiao gid; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public._mesoregiao ALTER COLUMN gid SET DEFAULT nextval('public._mesoregiao_gid_seq'::regclass);


--
-- TOC entry 4724 (class 2604 OID 18497)
-- Name: _microregiao gid; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public._microregiao ALTER COLUMN gid SET DEFAULT nextval('public._microregiao_gid_seq'::regclass);


--
-- TOC entry 4725 (class 2604 OID 18498)
-- Name: _municipios gid; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public._municipios ALTER COLUMN gid SET DEFAULT nextval('public._municipios_gid_seq'::regclass);


--
-- TOC entry 4729 (class 2604 OID 18499)
-- Name: agent_relation id; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.agent_relation ALTER COLUMN id SET DEFAULT nextval('public.agent_relation_id_seq'::regclass);


--
-- TOC entry 4731 (class 2604 OID 18500)
-- Name: evaluation_method_configuration id; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.evaluation_method_configuration ALTER COLUMN id SET DEFAULT nextval('public.evaluation_method_configuration_id_seq'::regclass);


--
-- TOC entry 4744 (class 2604 OID 18501)
-- Name: event id; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event ALTER COLUMN id SET DEFAULT nextval('public.event_id_seq'::regclass);


--
-- TOC entry 4721 (class 2604 OID 18502)
-- Name: event_occurrence id; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_occurrence ALTER COLUMN id SET DEFAULT nextval('public.event_occurrence_id_seq'::regclass);


--
-- TOC entry 4745 (class 2604 OID 18503)
-- Name: event_occurrence_cancellation id; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_occurrence_cancellation ALTER COLUMN id SET DEFAULT nextval('public.event_occurrence_cancellation_id_seq'::regclass);


--
-- TOC entry 4746 (class 2604 OID 18504)
-- Name: event_occurrence_recurrence id; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_occurrence_recurrence ALTER COLUMN id SET DEFAULT nextval('public.event_occurrence_recurrence_id_seq'::regclass);


--
-- TOC entry 4768 (class 2604 OID 18505)
-- Name: project id; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.project ALTER COLUMN id SET DEFAULT nextval('public.project_id_seq'::regclass);


--
-- TOC entry 4769 (class 2604 OID 18506)
-- Name: project_event id; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.project_event ALTER COLUMN id SET DEFAULT nextval('public.project_event_id_seq'::regclass);


--
-- TOC entry 4779 (class 2604 OID 18507)
-- Name: space id; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.space ALTER COLUMN id SET DEFAULT nextval('public.space_id_seq'::regclass);


--
-- TOC entry 4783 (class 2604 OID 18508)
-- Name: term id; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.term ALTER COLUMN id SET DEFAULT nextval('public.term_id_seq'::regclass);


--
-- TOC entry 4784 (class 2604 OID 18509)
-- Name: term_relation id; Type: DEFAULT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.term_relation ALTER COLUMN id SET DEFAULT nextval('public.term_relation_id_seq'::regclass);


--
-- TOC entry 5234 (class 0 OID 18170)
-- Dependencies: 282
-- Data for Name: _mesoregiao; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public._mesoregiao (gid, id, nm_meso, cd_geocodu, geom) FROM stdin;
\.


--
-- TOC entry 5236 (class 0 OID 18176)
-- Dependencies: 284
-- Data for Name: _microregiao; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public._microregiao (gid, id, nm_micro, cd_geocodu, geom) FROM stdin;
\.


--
-- TOC entry 5238 (class 0 OID 18182)
-- Dependencies: 286
-- Data for Name: _municipios; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public._municipios (gid, id, cd_geocodm, nm_municip, geom) FROM stdin;
\.


--
-- TOC entry 5241 (class 0 OID 18189)
-- Dependencies: 289
-- Data for Name: agent; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.agent (id, parent_id, user_id, type, name, location, _geo_location, short_description, long_description, create_timestamp, status, is_verified, public_location, update_timestamp, subsite_id) FROM stdin;
1	\N	1	1	Admin@local	\N	\N	\N	\N	2019-03-07 00:00:00	1	f	\N	2024-06-04 17:38:58	\N
\.


--
-- TOC entry 5242 (class 0 OID 18196)
-- Dependencies: 290
-- Data for Name: agent_meta; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.agent_meta (object_id, key, value, id) FROM stdin;
1	sentNotification	1	1
\.


--
-- TOC entry 5244 (class 0 OID 18202)
-- Dependencies: 292
-- Data for Name: agent_relation; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.agent_relation (id, agent_id, object_type, object_id, type, has_control, create_timestamp, status, metadata) FROM stdin;
\.


--
-- TOC entry 5337 (class 0 OID 19069)
-- Dependencies: 386
-- Data for Name: chat_message; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.chat_message (id, chat_thread_id, parent_id, user_id, payload, create_timestamp) FROM stdin;
\.


--
-- TOC entry 5335 (class 0 OID 19060)
-- Dependencies: 384
-- Data for Name: chat_thread; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.chat_thread (id, object_id, object_type, type, identifier, description, create_timestamp, last_message_timestamp, status) FROM stdin;
\.


--
-- TOC entry 5246 (class 0 OID 18207)
-- Dependencies: 294
-- Data for Name: db_update; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.db_update (name, exec_time) FROM stdin;
alter tablel term taxonomy type	2019-03-07 23:54:06.885661
new random id generator	2019-03-07 23:54:06.885661
migrate gender	2019-03-07 23:54:06.885661
create table user apps	2019-03-07 23:54:06.885661
create table user_meta	2019-03-07 23:54:06.885661
create seal and seal relation tables	2019-03-07 23:54:06.885661
resize entity meta key columns	2019-03-07 23:54:06.885661
create registration field configuration table	2019-03-07 23:54:06.885661
alter table registration_file_configuration add categories	2019-03-07 23:54:06.885661
create saas tables	2019-03-07 23:54:06.885661
rename saas tables to subsite	2019-03-07 23:54:06.885661
remove parent_url and add alias_url	2019-03-07 23:54:06.885661
verified seal migration	2019-03-07 23:54:06.885661
create update timestamp entities	2019-03-07 23:54:06.885661
alter table role add column subsite_id	2019-03-07 23:54:06.885661
Fix field options field type from registration field configuration	2019-03-07 23:54:06.885661
ADD columns subsite_id	2019-03-07 23:54:06.885661
remove subsite slug column	2019-03-07 23:54:06.885661
add subsite verified_seals column	2019-03-07 23:54:06.885661
update entities last_update_timestamp with user last log timestamp	2019-03-07 23:54:06.885661
Created owner seal relation field	2019-03-07 23:54:06.885661
create table pcache	2019-03-07 23:54:06.885661
function create pcache id sequence 2	2019-03-07 23:54:06.885661
Add field for maximum size from registration field configuration	2019-03-07 23:54:06.885661
Add notification type for compliant and suggestion messages	2019-03-07 23:54:06.885661
create entity revision tables	2019-03-07 23:54:06.885661
ALTER TABLE file ADD COLUMN path	2019-03-07 23:54:06.885661
*_meta drop all indexes again	2019-03-07 23:54:06.885661
recreate *_meta indexes	2019-03-07 23:54:06.885661
create permission cache pending table2	2019-03-07 23:54:06.885661
create opportunity tables	2019-03-07 23:54:06.885661
DROP CONSTRAINT registration_project_fk");	2019-03-07 23:54:06.885661
fix opportunity parent FK	2019-03-07 23:54:06.885661
fix opportunity type 35	2019-03-07 23:54:06.885661
create opportunity sequence	2019-03-07 23:54:06.885661
update opportunity_meta_id sequence	2019-03-07 23:54:06.885661
rename opportunity_meta key isProjectPhase to isOpportunityPhase	2019-03-07 23:54:06.885661
migrate introInscricoes value to shortDescription	2019-03-07 23:54:06.885661
ALTER TABLE registration ADD consolidated_result	2019-03-07 23:54:06.885661
create evaluation methods tables	2019-03-07 23:54:06.885661
create registration_evaluation table	2019-03-07 23:54:06.885661
ALTER TABLE opportunity ALTER type DROP NOT NULL;	2019-03-07 23:54:06.885661
create seal relation renovation flag field	2019-03-07 23:54:06.885661
create seal relation validate date	2019-03-07 23:54:06.885661
update seal_relation set validate_date	2019-03-07 23:54:06.885661
refactor of entity meta keky value indexes	2019-03-07 23:54:06.885661
DROP index registration_meta_value_idx	2019-03-07 23:54:06.885661
altertable registration_file_and_files_add_order	2019-03-07 23:54:06.885661
replace subsite entidades_habilitadas values	2019-03-07 23:54:06.885661
replace subsite cor entidades values	2019-03-07 23:54:06.885661
ALTER TABLE file ADD private and update	2019-03-07 23:54:06.885661
move private files	2019-03-07 23:54:06.885661
create permission cache sequence	2019-03-07 23:54:06.885661
create evaluation methods sequence	2019-03-07 23:54:06.885661
change opportunity field agent_id not null	2019-03-07 23:54:06.885661
alter table registration add column number	2019-03-07 23:54:06.885661
update registrations set number fixed	2019-03-07 23:54:06.885661
alter table registration add column valuers_exceptions_list	2019-03-07 23:54:06.885661
update taxonomy slug tag	2019-03-07 23:54:06.885661
update taxonomy slug area	2019-03-07 23:54:06.885661
update taxonomy slug linguagem	2019-03-07 23:54:06.885661
recreate pcache	2019-03-07 23:54:19.344941
generate file path	2019-03-07 23:54:19.352266
create entities history entries	2019-03-07 23:54:19.357385
create entities updated revision	2019-03-07 23:54:19.362878
fix update timestamp of revisioned entities	2019-03-07 23:54:19.367904
consolidate registration result	2019-03-07 23:54:19.3728
create avatar thumbs	2019-03-07 23:55:16.963658
CREATE SEQUENCE REGISTRATION SPACE RELATION registration_space_relation_id_seq	2021-02-04 13:50:37.698794
CREATE TABLE spacerelation	2021-02-04 13:50:37.698794
ALTER TABLE registration	2021-02-04 13:50:37.698794
create event attendance table	2021-02-04 13:50:37.698794
create procuration table	2021-02-04 13:50:37.698794
alter table registration_field_configuration add column config	2021-02-04 13:50:37.698794
recreate ALL FKs	2021-02-04 13:50:37.698794
create object_type enum type	2021-02-04 13:50:37.698794
create permission_action enum type	2021-02-04 13:50:37.698794
alter tables to use enum types	2021-02-04 13:50:37.698794
alter table permission_cache_pending add column status	2021-02-04 13:50:37.698794
CREATE VIEW evaluation	2021-02-04 13:50:37.698794
valuer disabling refactor	2021-02-04 13:50:37.698794
remove orphan events again	2024-06-04 20:34:15.091009
fix subsite verifiedSeals array	2024-06-04 20:34:15.091009
RECREATE VIEW evaluations AGAIN!!!!!	2024-06-04 20:34:15.091009
adiciona oportunidades na fila de reprocessamento de cache	2024-06-04 20:34:15.091009
adiciona novos indices a tabela agent_relation	2024-06-04 20:34:15.091009
ALTER TABLE metalist ALTER value TYPE TEXT	2024-06-04 20:34:15.091009
Add metadata to Agent Relation	2024-06-04 20:34:15.091009
add timestamp columns to registration_evaluation	2024-06-04 20:34:15.091009
create chat tables	2024-06-04 20:34:15.091009
create table job	2024-06-04 20:34:15.091009
alter job.metadata comment	2024-06-04 20:34:15.091009
clean existing orphans	2024-06-04 20:34:15.091009
add triggers for orphan cleanup	2024-06-04 20:34:15.091009
Remove lixo angular registration_meta	2024-06-04 20:34:15.091009
Adiciona coluna avaliableEvaluationFields na tabela opportunity	2024-06-04 20:34:15.091009
Adiciona coluna publish_timestamp na tabela opportunity	2024-06-04 20:34:15.091009
Adiciona coluna auto_publish na tabela opportunity	2024-06-04 20:34:15.091009
Adiciona coluna evaluation_from e evaluation_to na tabela evaluation_method_configuration	2024-06-04 20:34:15.091009
adiciona coluna name na tabela evaluation_method_configuration	2024-06-04 20:34:15.091009
popula as colunas name, evaluation_from e evaluation_to da tabela evaluation_method_configuration	2024-06-04 20:34:15.091009
cria funções para o cast automático de ponto para varchar	2024-06-04 20:34:15.091009
Renomeia colunas registrationFrom e registrationTo da tabela de projetod	2024-06-04 20:34:15.091009
Adiciona novas coluna na tabela registration_field_configuration	2024-06-04 20:34:15.091009
Adiciona novas coluna na tabela registration_file_configuration	2024-06-04 20:34:15.091009
alter seal add column locked_fields	2024-06-04 20:34:15.091009
Consede permissão em todos os campo para todos os avaliadores da oportunidade	2024-06-04 20:34:15.091009
corrige metadados criados por erro em inscricoes de fases	2024-06-04 20:34:15.091009
Adiciona a coluna description para a descrição da ocorrência	2024-06-04 20:34:15.091009
Adiciona a coluna price para a o valor de entrada da ocorrência	2024-06-04 20:34:15.091009
Adiciona a coluna priceInfo para a informações sobre o valor de entrada da ocorrência	2024-06-04 20:34:15.091009
Apaga registro do db-update de "Definição dos cammpos cpf e cnpj com base no documento" para que rode novamente	2024-06-04 20:34:15.091009
Corrige config dos campos na entidade registration_fields_configurarion	2024-06-04 20:34:15.091009
seta como vazio campo escolaridade do agent caso esteja com valor não informado	2024-06-04 20:34:15.091009
altera tipo da coluna description na tabela file	2024-06-04 20:34:15.091009
faz com que o updateTimestamp seja igual ao createTimestamp na criacão da entidade	2024-06-04 20:34:15.091009
migra valores das colunas do tipo array para do tipo json	2024-06-04 20:34:15.091009
corrige permissão de avaliadores que tem avaliação mas não possui permissão de avaliar pela regra configurada	2024-06-04 20:34:15.091009
adiciona coluna user_id à tabela pending_permission_cache	2024-06-04 20:34:15.091009
limpeza da tabela de pcache	2024-06-04 20:34:15.091009
Cria colunas proponent_type e registration na tabela registration	2024-06-04 20:34:15.091009
Cria colunas registration_proponent_types e registration_ranges na tabela opportunity	2024-06-04 20:34:15.091009
Cria colunas registration_ranges e proponent_types na tabela registration_field_configuration	2024-06-04 20:34:15.091009
Cria colunas registration_ranges e proponent_types na tabela registration_file_configuration	2024-06-04 20:34:15.091009
trigger to update children and parent opportunities	2024-06-04 20:34:15.091009
renomeia metadados da funcionalidade AffirmativePollices	2024-06-04 20:34:15.091009
Cria colunas score e eligible na entidade Registration	2024-06-04 20:34:15.091009
corrige os valores da distribuição de avaliação por categorias	2024-06-04 20:34:15.091009
adiciona índices nas tabelas de revisões de entidades	2024-06-04 20:34:15.091009
adiciona índice para a coluna action da tabela pcache	2024-06-04 20:34:15.091009
adiciona novos índices na tabela registration	2024-06-04 20:34:15.091009
adiciona novos índices na tabela file	2024-06-04 20:34:15.091009
Corrige constraint enforce_geotype_geom da tabela geo_division	2024-06-04 20:34:15.091009
update taxonomy slug funcao	2024-06-04 20:34:15.091009
define metadado isDataCollection = 0 nas fases sem campos configurados	2024-06-04 20:34:15.091009
create table system_role	2024-06-04 20:34:15.091009
alter system_role.permissions comment	2024-06-04 20:34:15.091009
create registrations history entries	2024-06-04 20:34:16.359929
create evaluations history entries	2024-06-04 20:34:16.368111
corrige registration_metadada dos campos @	2024-06-04 20:34:16.375454
Definição dos cammpos cpf e cnpj com base no documento	2024-06-04 20:34:16.38169
Atualiza os campos das ocorrencias para o novo padrao	2024-06-04 20:34:16.388787
create permission cache for users	2024-06-04 20:34:16.395181
Atualiza campos condicionados para funcionar na nova estrutura	2024-06-04 20:34:16.401478
corrige campos arroba	2024-06-04 20:34:16.407198
Padronização dos campos de rede social	2024-06-04 20:34:16.412998
create opportunities history entries	2024-06-04 20:34:16.418741
sync last opportunity phases registrations	2024-06-04 20:34:16.425071
criando fases de resultado final para as oportunidades existentes sem fase final	2024-06-04 20:34:16.431156
\.


--
-- TOC entry 5247 (class 0 OID 18211)
-- Dependencies: 295
-- Data for Name: entity_revision; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.entity_revision (id, user_id, object_id, object_type, create_timestamp, action, message) FROM stdin;
1	1	1	MapasCulturais\\Entities\\Agent	2019-03-07 00:00:00	created	Registro criado.
2	1	1	MapasCulturais\\Entities\\Agent	2024-06-04 17:38:58	modified	Registro atualizado.
3	1	2	MapasCulturais\\Entities\\Opportunity	2024-06-04 17:39:20	created	Registro criado.
4	1	1	MapasCulturais\\Entities\\Opportunity	2024-06-04 17:39:19	created	Registro criado.
5	1	1	MapasCulturais\\Entities\\Opportunity	2024-06-04 17:39:32	modified	Registro atualizado.
6	1	1	MapasCulturais\\Entities\\Opportunity	2024-06-04 17:39:36	modified	Registro atualizado.
7	1	1	MapasCulturais\\Entities\\Opportunity	2024-06-04 17:39:36	publish	Registro publicado.
8	1	561465857	MapasCulturais\\Entities\\Registration	2024-06-04 17:40:04	created	Registro criado.
9	1	561465857	MapasCulturais\\Entities\\Registration	2024-06-04 17:40:10	publish	Registro publicado.
\.


--
-- TOC entry 5248 (class 0 OID 18216)
-- Dependencies: 296
-- Data for Name: entity_revision_data; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.entity_revision_data (id, "timestamp", key, value) FROM stdin;
1	2019-03-07 23:54:19	_type	1
2	2019-03-07 23:54:19	name	"Admin@local"
3	2019-03-07 23:54:19	publicLocation	null
4	2019-03-07 23:54:19	location	{"latitude":0,"longitude":0}
5	2019-03-07 23:54:19	shortDescription	null
6	2019-03-07 23:54:19	longDescription	null
7	2019-03-07 23:54:19	createTimestamp	{"date":"2019-03-07 00:00:00.000000","timezone_type":3,"timezone":"UTC"}
8	2019-03-07 23:54:19	status	1
9	2019-03-07 23:54:19	updateTimestamp	{"date":"2019-03-07 00:00:00.000000","timezone_type":3,"timezone":"UTC"}
10	2019-03-07 23:54:19	_subsiteId	null
11	2024-06-04 17:38:58	createTimestamp	{"date":"2019-03-07 00:00:00.000000","timezone_type":3,"timezone":"Etc\\/GMT+3"}
12	2024-06-04 17:38:58	updateTimestamp	{"date":"2024-06-04 17:38:58.315303","timezone_type":3,"timezone":"Etc\\/GMT+3"}
13	2024-06-04 17:39:20	_type	1
14	2024-06-04 17:39:20	name	"Publica\\u00e7\\u00e3o final do resultado"
15	2024-06-04 17:39:20	shortDescription	null
16	2024-06-04 17:39:20	registrationFrom	null
17	2024-06-04 17:39:20	registrationTo	null
18	2024-06-04 17:39:20	publishedRegistrations	false
19	2024-06-04 17:39:20	registrationCategories	[]
20	2024-06-04 17:39:20	createTimestamp	{"date":"2024-06-04 17:39:20.000000","timezone_type":3,"timezone":"Etc\\/GMT+3"}
21	2024-06-04 17:39:20	updateTimestamp	{"date":"2024-06-04 17:39:20.000000","timezone_type":3,"timezone":"Etc\\/GMT+3"}
22	2024-06-04 17:39:20	publishTimestamp	null
23	2024-06-04 17:39:20	autoPublish	false
24	2024-06-04 17:39:20	status	-1
25	2024-06-04 17:39:20	registrationProponentTypes	null
26	2024-06-04 17:39:20	registrationRanges	null
27	2024-06-04 17:39:20	_subsiteId	null
28	2024-06-04 17:39:20	longDescription	null
29	2024-06-04 17:39:20	avaliableEvaluationFields	[]
30	2024-06-04 17:39:20	owner	{"@entityType":"agent","id":1,"name":"Admin@local","shortDescription":null,"revision":2}
31	2024-06-04 17:39:20	parent	{"@entityType":"opportunity","id":1,"name":"teste","revision":0}
32	2024-06-04 17:39:20	isDataCollection	"0"
33	2024-06-04 17:39:20	isLastPhase	"1"
34	2024-06-04 17:39:20	isOpportunityPhase	true
35	2024-06-04 17:39:20	_type	1
36	2024-06-04 17:39:20	name	"teste"
37	2024-06-04 17:39:20	shortDescription	null
38	2024-06-04 17:39:20	registrationFrom	null
39	2024-06-04 17:39:20	registrationTo	null
40	2024-06-04 17:39:20	publishedRegistrations	false
41	2024-06-04 17:39:20	registrationCategories	[]
42	2024-06-04 17:39:20	createTimestamp	{"date":"2024-06-04 17:39:19.000000","timezone_type":3,"timezone":"Etc\\/GMT+3"}
43	2024-06-04 17:39:20	updateTimestamp	{"date":"2024-06-04 17:39:19.000000","timezone_type":3,"timezone":"Etc\\/GMT+3"}
44	2024-06-04 17:39:20	publishTimestamp	null
45	2024-06-04 17:39:20	autoPublish	false
46	2024-06-04 17:39:20	status	0
47	2024-06-04 17:39:20	registrationProponentTypes	null
48	2024-06-04 17:39:20	registrationRanges	null
49	2024-06-04 17:39:20	_subsiteId	null
50	2024-06-04 17:39:20	longDescription	null
51	2024-06-04 17:39:20	avaliableEvaluationFields	[]
52	2024-06-04 17:39:20	owner	{"@entityType":"agent","id":1,"name":"Admin@local","shortDescription":null,"revision":2}
53	2024-06-04 17:39:32	registrationFrom	{"date":"2024-06-06 17:39:00.000000","timezone_type":3,"timezone":"Etc\\/GMT+3"}
54	2024-06-04 17:39:32	registrationTo	{"date":"2024-06-30 17:39:00.000000","timezone_type":3,"timezone":"Etc\\/GMT+3"}
55	2024-06-04 17:39:32	updateTimestamp	{"date":"2024-06-04 17:39:32.435881","timezone_type":3,"timezone":"Etc\\/GMT+3"}
56	2024-06-04 17:39:32	_terms	{"":["Antropologia"]}
57	2024-06-04 17:39:36	shortDescription	"fdsafdsa"
58	2024-06-04 17:39:36	updateTimestamp	{"date":"2024-06-04 17:39:36.434736","timezone_type":3,"timezone":"Etc\\/GMT+3"}
59	2024-06-04 17:39:36	updateTimestamp	{"date":"2024-06-04 17:39:36.783307","timezone_type":3,"timezone":"Etc\\/GMT+3"}
60	2024-06-04 17:39:36	status	1
61	2024-06-04 17:40:04	number	"on-561465857"
62	2024-06-04 17:40:04	category	null
63	2024-06-04 17:40:04	createTimestamp	{"date":"2024-06-04 17:40:04.000000","timezone_type":3,"timezone":"Etc\\/GMT+3"}
64	2024-06-04 17:40:04	sentTimestamp	null
65	2024-06-04 17:40:04	agentsData	[]
66	2024-06-04 17:40:04	consolidatedResult	"0"
67	2024-06-04 17:40:04	_spaceData	[]
68	2024-06-04 17:40:04	status	0
69	2024-06-04 17:40:04	proponentType	null
70	2024-06-04 17:40:04	range	null
71	2024-06-04 17:40:04	__valuersExceptionsList	"{\\"include\\": [], \\"exclude\\": []}"
72	2024-06-04 17:40:04	_subsiteId	null
73	2024-06-04 17:40:04	score	null
74	2024-06-04 17:40:04	eligible	null
75	2024-06-04 17:40:04	owner	{"@entityType":"agent","id":1,"name":"Admin@local","shortDescription":null,"revision":2}
76	2024-06-04 17:40:10	sentTimestamp	{"date":"2024-06-04 17:40:10.721535","timezone_type":3,"timezone":"Etc\\/GMT+3"}
77	2024-06-04 17:40:10	agentsData	{"owner":{"id":1,"name":"Admin@local","publicLocation":null,"location":{"latitude":0,"longitude":0},"shortDescription":null,"longDescription":null,"createTimestamp":{"date":"2019-03-07 00:00:00.000000","timezone_type":3,"timezone":"Etc\\/GMT+3"},"status":1,"parent":null,"userId":1,"updateTimestamp":{"date":"2024-06-04 17:38:58.000000","timezone_type":3,"timezone":"Etc\\/GMT+3"},"subsite":null,"nomeCompleto":null,"nomeSocial":null,"escolaridade":null,"pessoaDeficiente":null,"comunidadesTradicional":null,"comunidadesTradicionalOutros":null,"documento":null,"cnpj":"","cpf":"","raca":null,"dataDeNascimento":null,"idoso":null,"localizacao":null,"genero":null,"orientacaoSexual":null,"agenteItinerante":null,"emailPublico":null,"emailPrivado":null,"telefonePublico":null,"telefone1":null,"telefone2":null,"endereco":null,"En_CEP":null,"En_Nome_Logradouro":null,"En_Num":null,"En_Complemento":null,"En_Bairro":null,"En_Municipio":null,"En_Estado":null,"En_Pais":"BR","site":null,"facebook":null,"twitter":null,"instagram":null,"linkedin":null,"vimeo":null,"spotify":null,"youtube":null,"pinterest":null,"payment_bank_account_type":null,"payment_bank_account_number":null,"payment_bank_branch":null,"payment_bank_number":null,"payment_bank_dv_branch":null,"payment_bank_dv_account_number":null,"geoPais":null,"geoPais_cod":null,"geoEstado":null,"geoEstado_cod":null,"geoMesorregiao":null,"geoMesorregiao_cod":null,"geoMicrorregiao":null,"geoMicrorregiao_cod":null,"geoMunicipio":null,"geoMunicipio_cod":null,"type":1,"terms":{"tag":[],"area":[],"funcao":[]}}}
78	2024-06-04 17:40:10	status	1
\.


--
-- TOC entry 5250 (class 0 OID 18222)
-- Dependencies: 298
-- Data for Name: entity_revision_revision_data; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.entity_revision_revision_data (revision_id, revision_data_id) FROM stdin;
1	1
1	2
1	3
1	4
1	5
1	6
1	7
1	8
1	9
1	10
2	1
2	2
2	3
2	4
2	5
2	6
2	11
2	8
2	12
2	10
3	13
3	14
3	15
3	16
3	17
3	18
3	19
3	20
3	21
3	22
3	23
3	24
3	25
3	26
3	27
3	28
3	29
3	30
3	31
3	32
3	33
3	34
4	35
4	36
4	37
4	38
4	39
4	40
4	41
4	42
4	43
4	44
4	45
4	46
4	47
4	48
4	49
4	50
4	51
4	52
5	35
5	36
5	37
5	53
5	54
5	40
5	41
5	42
5	55
5	44
5	45
5	46
5	47
5	48
5	49
5	50
5	51
5	52
5	56
6	35
6	36
6	57
6	53
6	54
6	40
6	41
6	42
6	58
6	44
6	45
6	46
6	47
6	48
6	49
6	50
6	51
6	52
6	56
7	35
7	36
7	57
7	53
7	54
7	40
7	41
7	42
7	59
7	44
7	45
7	60
7	47
7	48
7	49
7	50
7	51
7	52
7	56
8	61
8	62
8	63
8	64
8	65
8	66
8	67
8	68
8	69
8	70
8	71
8	72
8	73
8	74
8	75
9	61
9	62
9	63
9	76
9	77
9	66
9	67
9	78
9	69
9	70
9	71
9	72
9	73
9	74
9	75
\.


--
-- TOC entry 5251 (class 0 OID 18225)
-- Dependencies: 299
-- Data for Name: evaluation_method_configuration; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.evaluation_method_configuration (id, opportunity_id, type, evaluation_from, evaluation_to, name) FROM stdin;
\.


--
-- TOC entry 5253 (class 0 OID 18229)
-- Dependencies: 301
-- Data for Name: evaluationmethodconfiguration_meta; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.evaluationmethodconfiguration_meta (id, object_id, key, value) FROM stdin;
\.


--
-- TOC entry 5261 (class 0 OID 18269)
-- Dependencies: 309
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.event (id, project_id, name, short_description, long_description, rules, create_timestamp, status, agent_id, is_verified, type, update_timestamp, subsite_id) FROM stdin;
\.


--
-- TOC entry 5262 (class 0 OID 18275)
-- Dependencies: 310
-- Data for Name: event_attendance; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.event_attendance (id, user_id, event_occurrence_id, event_id, space_id, type, reccurrence_string, start_timestamp, end_timestamp, create_timestamp) FROM stdin;
\.


--
-- TOC entry 5265 (class 0 OID 18282)
-- Dependencies: 313
-- Data for Name: event_meta; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.event_meta (key, object_id, value, id) FROM stdin;
\.


--
-- TOC entry 5233 (class 0 OID 18159)
-- Dependencies: 281
-- Data for Name: event_occurrence; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.event_occurrence (id, space_id, event_id, rule, starts_on, ends_on, starts_at, ends_at, frequency, separation, count, until, timezone_name, status, description, price, priceinfo) FROM stdin;
\.


--
-- TOC entry 5267 (class 0 OID 18288)
-- Dependencies: 315
-- Data for Name: event_occurrence_cancellation; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.event_occurrence_cancellation (id, event_occurrence_id, date) FROM stdin;
\.


--
-- TOC entry 5270 (class 0 OID 18293)
-- Dependencies: 318
-- Data for Name: event_occurrence_recurrence; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.event_occurrence_recurrence (id, event_occurrence_id, month, day, week) FROM stdin;
\.


--
-- TOC entry 5273 (class 0 OID 18298)
-- Dependencies: 321
-- Data for Name: file; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.file (id, md5, mime_type, name, object_type, object_id, create_timestamp, grp, description, parent_id, path, private) FROM stdin;
\.


--
-- TOC entry 5275 (class 0 OID 18308)
-- Dependencies: 323
-- Data for Name: geo_division; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.geo_division (id, parent_id, type, cod, name, geom) FROM stdin;
\.


--
-- TOC entry 5338 (class 0 OID 19094)
-- Dependencies: 387
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.job (id, name, iterations, iterations_count, interval_string, create_timestamp, next_execution_timestamp, last_execution_timestamp, metadata, status) FROM stdin;
8c80ebd7232823f0f78daafd21b3fda7	StartDataCollectionPhase	1	0		2024-06-04 17:39:36	2024-06-06 17:39:00	\N	{"opportunity":"@entity:MapasCulturais\\\\Entities\\\\Opportunity:1"}	0
563973f8f6f05c92309bba5f8c25710c	FinishDataCollectionPhase	1	0		2024-06-04 17:39:36	2024-06-30 17:39:00	\N	{"opportunity":"@entity:MapasCulturais\\\\Entities\\\\Opportunity:1"}	0
2e7f2741ad225fe73085369b66449e15	sendmailnotification	1	0		2024-06-04 17:40:04	2024-06-04 17:40:04	\N	{"template":"start_registration","registrationId":561465857}	1
ed2d76f32c0578a2136924b9ed17a696	sendmailnotification	1	0		2024-06-04 17:40:10	2024-06-04 17:40:10	\N	{"template":"send_registration","registrationId":561465857}	1
\.


--
-- TOC entry 5276 (class 0 OID 18317)
-- Dependencies: 324
-- Data for Name: metadata; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.metadata (object_id, object_type, key, value) FROM stdin;
\.


--
-- TOC entry 5278 (class 0 OID 18323)
-- Dependencies: 326
-- Data for Name: metalist; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.metalist (id, object_type, object_id, grp, title, description, value, create_timestamp, "order") FROM stdin;
\.


--
-- TOC entry 5280 (class 0 OID 18331)
-- Dependencies: 328
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.notification (id, user_id, request_id, message, create_timestamp, action_timestamp, status) FROM stdin;
1	1	\N	Seu último acesso foi em <b>08/03/2019</b>, atualize suas informações se necessário.	2024-06-04 17:38:58	\N	1
2	1	\N	O agente <b>Admin@local</b> não é atualizado desde de <b>07/03/2019</b>, atualize as informações se necessário. <a class='btn btn-small btn-primary' href='http://localhost/edicao-de-agente/1/' rel='noopener noreferrer'>editar</a>'	2024-06-04 17:38:58	\N	1
\.


--
-- TOC entry 5281 (class 0 OID 18338)
-- Dependencies: 329
-- Data for Name: notification_meta; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.notification_meta (id, object_id, key, value) FROM stdin;
\.


--
-- TOC entry 5285 (class 0 OID 18346)
-- Dependencies: 333
-- Data for Name: opportunity; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.opportunity (id, parent_id, agent_id, type, name, short_description, long_description, registration_from, registration_to, published_registrations, registration_categories, create_timestamp, update_timestamp, status, subsite_id, object_type, object_id, avaliable_evaluation_fields, publish_timestamp, auto_publish, registration_proponent_types, registration_ranges) FROM stdin;
2	1	1	1	Publicação final do resultado	\N	\N	\N	\N	f	[]	2024-06-04 17:39:20	2024-06-04 17:39:20	-1	\N	MapasCulturais\\Entities\\Agent	1	[]	\N	f	\N	\N
1	\N	1	1	teste	fdsafdsa	\N	2024-06-06 17:39:00	2024-06-30 17:39:00	f	[]	2024-06-04 17:39:19	2024-06-04 17:39:36	1	\N	MapasCulturais\\Entities\\Agent	1	[]	\N	f	\N	\N
\.


--
-- TOC entry 5287 (class 0 OID 18356)
-- Dependencies: 335
-- Data for Name: opportunity_meta; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.opportunity_meta (id, object_id, key, value) FROM stdin;
1	2	isLastPhase	1
2	2	isOpportunityPhase	1
3	2	isDataCollection	0
\.


--
-- TOC entry 5256 (class 0 OID 18236)
-- Dependencies: 304
-- Data for Name: pcache; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.pcache (id, user_id, action, create_timestamp, object_type, object_id) FROM stdin;
\.


--
-- TOC entry 5288 (class 0 OID 18362)
-- Dependencies: 336
-- Data for Name: permission_cache_pending; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.permission_cache_pending (id, object_id, object_type, status, usr_id) FROM stdin;
\.


--
-- TOC entry 5290 (class 0 OID 18367)
-- Dependencies: 338
-- Data for Name: procuration; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.procuration (token, usr_id, attorney_user_id, action, create_timestamp, valid_until_timestamp) FROM stdin;
\.


--
-- TOC entry 5291 (class 0 OID 18371)
-- Dependencies: 339
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.project (id, name, short_description, long_description, create_timestamp, status, agent_id, is_verified, type, parent_id, starts_on, ends_on, update_timestamp, subsite_id) FROM stdin;
\.


--
-- TOC entry 5292 (class 0 OID 18377)
-- Dependencies: 340
-- Data for Name: project_event; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.project_event (id, event_id, project_id, type, status) FROM stdin;
\.


--
-- TOC entry 5295 (class 0 OID 18382)
-- Dependencies: 343
-- Data for Name: project_meta; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.project_meta (object_id, key, value, id) FROM stdin;
\.


--
-- TOC entry 5257 (class 0 OID 18240)
-- Dependencies: 305
-- Data for Name: registration; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.registration (id, opportunity_id, category, agent_id, create_timestamp, sent_timestamp, status, agents_data, subsite_id, consolidated_result, number, valuers_exceptions_list, space_data, proponent_type, range, score, eligible) FROM stdin;
561465857	1	\N	1	2024-06-04 17:40:04	2024-06-04 17:40:10	1	{"owner":{"id":1,"name":"Admin@local","publicLocation":null,"location":{"latitude":0,"longitude":0},"shortDescription":null,"longDescription":null,"createTimestamp":{"date":"2019-03-07 00:00:00.000000","timezone_type":3,"timezone":"Etc\\/GMT+3"},"status":1,"parent":null,"userId":1,"updateTimestamp":{"date":"2024-06-04 17:38:58.000000","timezone_type":3,"timezone":"Etc\\/GMT+3"},"subsite":null,"nomeCompleto":null,"nomeSocial":null,"escolaridade":null,"pessoaDeficiente":null,"comunidadesTradicional":null,"comunidadesTradicionalOutros":null,"documento":null,"cnpj":"","cpf":"","raca":null,"dataDeNascimento":null,"idoso":null,"localizacao":null,"genero":null,"orientacaoSexual":null,"agenteItinerante":null,"emailPublico":null,"emailPrivado":null,"telefonePublico":null,"telefone1":null,"telefone2":null,"endereco":null,"En_CEP":null,"En_Nome_Logradouro":null,"En_Num":null,"En_Complemento":null,"En_Bairro":null,"En_Municipio":null,"En_Estado":null,"En_Pais":"BR","site":null,"facebook":null,"twitter":null,"instagram":null,"linkedin":null,"vimeo":null,"spotify":null,"youtube":null,"pinterest":null,"payment_bank_account_type":null,"payment_bank_account_number":null,"payment_bank_branch":null,"payment_bank_number":null,"payment_bank_dv_branch":null,"payment_bank_dv_account_number":null,"geoPais":null,"geoPais_cod":null,"geoEstado":null,"geoEstado_cod":null,"geoMesorregiao":null,"geoMesorregiao_cod":null,"geoMicrorregiao":null,"geoMicrorregiao_cod":null,"geoMunicipio":null,"geoMunicipio_cod":null,"type":1,"terms":{"tag":[],"area":[],"funcao":[]}}}	\N	0	on-561465857	{"include": [], "exclude": []}	[]	\N	\N	\N	\N
\.


--
-- TOC entry 5258 (class 0 OID 18249)
-- Dependencies: 306
-- Data for Name: registration_evaluation; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.registration_evaluation (id, registration_id, user_id, result, evaluation_data, status, create_timestamp, update_timestamp) FROM stdin;
\.


--
-- TOC entry 5299 (class 0 OID 18390)
-- Dependencies: 347
-- Data for Name: registration_field_configuration; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.registration_field_configuration (id, opportunity_id, title, description, categories, required, field_type, field_options, max_size, display_order, config, conditional, conditional_field, conditional_value, registration_ranges, proponent_types) FROM stdin;
\.


--
-- TOC entry 5301 (class 0 OID 18397)
-- Dependencies: 349
-- Data for Name: registration_file_configuration; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.registration_file_configuration (id, opportunity_id, title, description, required, categories, display_order, conditional, conditional_field, conditional_value, registration_ranges, proponent_types) FROM stdin;
\.


--
-- TOC entry 5304 (class 0 OID 18405)
-- Dependencies: 352
-- Data for Name: registration_meta; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.registration_meta (object_id, key, value, id) FROM stdin;
\.


--
-- TOC entry 5307 (class 0 OID 18412)
-- Dependencies: 355
-- Data for Name: request; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.request (id, request_uid, requester_user_id, origin_type, origin_id, destination_type, destination_id, metadata, type, create_timestamp, action_timestamp, status) FROM stdin;
\.


--
-- TOC entry 5309 (class 0 OID 18420)
-- Dependencies: 357
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.role (id, usr_id, name, subsite_id) FROM stdin;
2	1	saasSuperAdmin	\N
\.


--
-- TOC entry 5311 (class 0 OID 18424)
-- Dependencies: 359
-- Data for Name: seal; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.seal (id, agent_id, name, short_description, long_description, valid_period, create_timestamp, status, certificate_text, update_timestamp, subsite_id, locked_fields) FROM stdin;
1	1	Selo Mapas	Descrição curta Selo Mapas	Descrição longa Selo Mapas	0	2019-03-07 23:54:04	1	\N	2019-03-07 00:00:00	\N	[]
\.


--
-- TOC entry 5313 (class 0 OID 18430)
-- Dependencies: 361
-- Data for Name: seal_meta; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.seal_meta (id, object_id, key, value) FROM stdin;
\.


--
-- TOC entry 5315 (class 0 OID 18436)
-- Dependencies: 363
-- Data for Name: seal_relation; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.seal_relation (id, seal_id, object_id, create_timestamp, status, object_type, agent_id, owner_id, validate_date, renovation_request) FROM stdin;
\.


--
-- TOC entry 5317 (class 0 OID 18441)
-- Dependencies: 365
-- Data for Name: space; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.space (id, parent_id, location, _geo_location, name, short_description, long_description, create_timestamp, status, type, agent_id, is_verified, public, update_timestamp, subsite_id) FROM stdin;
\.


--
-- TOC entry 5319 (class 0 OID 18450)
-- Dependencies: 367
-- Data for Name: space_meta; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.space_meta (object_id, key, value, id) FROM stdin;
\.


--
-- TOC entry 5321 (class 0 OID 18456)
-- Dependencies: 369
-- Data for Name: space_relation; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.space_relation (id, space_id, object_id, create_timestamp, status, object_type) FROM stdin;
\.


--
-- TOC entry 4716 (class 0 OID 16718)
-- Dependencies: 220
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- TOC entry 5323 (class 0 OID 18461)
-- Dependencies: 371
-- Data for Name: subsite; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.subsite (id, name, create_timestamp, status, agent_id, url, namespace, alias_url, verified_seals) FROM stdin;
\.


--
-- TOC entry 5325 (class 0 OID 18469)
-- Dependencies: 373
-- Data for Name: subsite_meta; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.subsite_meta (object_id, key, value, id) FROM stdin;
\.


--
-- TOC entry 5340 (class 0 OID 19148)
-- Dependencies: 389
-- Data for Name: system_role; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.system_role (id, slug, name, subsite_context, permissions, create_timestamp, update_timestamp, status) FROM stdin;
\.


--
-- TOC entry 5327 (class 0 OID 18475)
-- Dependencies: 375
-- Data for Name: term; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.term (id, taxonomy, term, description) FROM stdin;
1	area	Antropologia	
\.


--
-- TOC entry 5329 (class 0 OID 18481)
-- Dependencies: 377
-- Data for Name: term_relation; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.term_relation (term_id, object_type, object_id, id) FROM stdin;
1	MapasCulturais\\Entities\\Opportunity	2	1
1	MapasCulturais\\Entities\\Opportunity	1	2
\.


--
-- TOC entry 5331 (class 0 OID 18485)
-- Dependencies: 379
-- Data for Name: user_app; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.user_app (public_key, private_key, user_id, name, status, create_timestamp, subsite_id) FROM stdin;
\.


--
-- TOC entry 5332 (class 0 OID 18490)
-- Dependencies: 380
-- Data for Name: user_meta; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.user_meta (object_id, key, value, id) FROM stdin;
1	localAuthenticationPassword	$2y$10$iIXeqhX.4fEAAVZPsbtRde7CFw1ChduCi8NsnXGnJc6TlelY6gf3e	2
1	deleteAccountToken	279df393e2791dd35f78da0dc9771f804575652f	1
\.


--
-- TOC entry 5260 (class 0 OID 18257)
-- Dependencies: 308
-- Data for Name: usr; Type: TABLE DATA; Schema: public; Owner: mapas
--

COPY public.usr (id, auth_provider, auth_uid, email, last_login_timestamp, create_timestamp, status, profile_id) FROM stdin;
1	1	1	Admin@local	2024-06-04 17:38:58	2019-03-07 00:00:00	1	1
\.


--
-- TOC entry 5377 (class 0 OID 0)
-- Dependencies: 283
-- Name: _mesoregiao_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public._mesoregiao_gid_seq', 1, false);


--
-- TOC entry 5378 (class 0 OID 0)
-- Dependencies: 285
-- Name: _microregiao_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public._microregiao_gid_seq', 1, false);


--
-- TOC entry 5379 (class 0 OID 0)
-- Dependencies: 287
-- Name: _municipios_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public._municipios_gid_seq', 1, false);


--
-- TOC entry 5380 (class 0 OID 0)
-- Dependencies: 288
-- Name: agent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.agent_id_seq', 1, true);


--
-- TOC entry 5381 (class 0 OID 0)
-- Dependencies: 291
-- Name: agent_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.agent_meta_id_seq', 1, true);


--
-- TOC entry 5382 (class 0 OID 0)
-- Dependencies: 293
-- Name: agent_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.agent_relation_id_seq', 1, false);


--
-- TOC entry 5383 (class 0 OID 0)
-- Dependencies: 385
-- Name: chat_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.chat_message_id_seq', 1, false);


--
-- TOC entry 5384 (class 0 OID 0)
-- Dependencies: 383
-- Name: chat_thread_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.chat_thread_id_seq', 1, false);


--
-- TOC entry 5385 (class 0 OID 0)
-- Dependencies: 297
-- Name: entity_revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.entity_revision_id_seq', 9, true);


--
-- TOC entry 5386 (class 0 OID 0)
-- Dependencies: 300
-- Name: evaluation_method_configuration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.evaluation_method_configuration_id_seq', 1, false);


--
-- TOC entry 5387 (class 0 OID 0)
-- Dependencies: 302
-- Name: evaluationmethodconfiguration_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.evaluationmethodconfiguration_meta_id_seq', 1, false);


--
-- TOC entry 5388 (class 0 OID 0)
-- Dependencies: 311
-- Name: event_attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.event_attendance_id_seq', 1, false);


--
-- TOC entry 5389 (class 0 OID 0)
-- Dependencies: 312
-- Name: event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.event_id_seq', 1, false);


--
-- TOC entry 5390 (class 0 OID 0)
-- Dependencies: 314
-- Name: event_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.event_meta_id_seq', 1, false);


--
-- TOC entry 5391 (class 0 OID 0)
-- Dependencies: 316
-- Name: event_occurrence_cancellation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.event_occurrence_cancellation_id_seq', 1, false);


--
-- TOC entry 5392 (class 0 OID 0)
-- Dependencies: 317
-- Name: event_occurrence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.event_occurrence_id_seq', 1, false);


--
-- TOC entry 5393 (class 0 OID 0)
-- Dependencies: 319
-- Name: event_occurrence_recurrence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.event_occurrence_recurrence_id_seq', 1, false);


--
-- TOC entry 5394 (class 0 OID 0)
-- Dependencies: 320
-- Name: file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.file_id_seq', 1, false);


--
-- TOC entry 5395 (class 0 OID 0)
-- Dependencies: 322
-- Name: geo_division_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.geo_division_id_seq', 1, false);


--
-- TOC entry 5396 (class 0 OID 0)
-- Dependencies: 325
-- Name: metalist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.metalist_id_seq', 1, false);


--
-- TOC entry 5397 (class 0 OID 0)
-- Dependencies: 327
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.notification_id_seq', 2, true);


--
-- TOC entry 5398 (class 0 OID 0)
-- Dependencies: 330
-- Name: notification_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.notification_meta_id_seq', 1, false);


--
-- TOC entry 5399 (class 0 OID 0)
-- Dependencies: 331
-- Name: occurrence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.occurrence_id_seq', 100000, false);


--
-- TOC entry 5400 (class 0 OID 0)
-- Dependencies: 332
-- Name: opportunity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.opportunity_id_seq', 2, true);


--
-- TOC entry 5401 (class 0 OID 0)
-- Dependencies: 334
-- Name: opportunity_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.opportunity_meta_id_seq', 3, true);


--
-- TOC entry 5402 (class 0 OID 0)
-- Dependencies: 303
-- Name: pcache_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.pcache_id_seq', 1, false);


--
-- TOC entry 5403 (class 0 OID 0)
-- Dependencies: 337
-- Name: permission_cache_pending_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.permission_cache_pending_seq', 5, true);


--
-- TOC entry 5404 (class 0 OID 0)
-- Dependencies: 341
-- Name: project_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.project_event_id_seq', 1, false);


--
-- TOC entry 5405 (class 0 OID 0)
-- Dependencies: 342
-- Name: project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.project_id_seq', 1, false);


--
-- TOC entry 5406 (class 0 OID 0)
-- Dependencies: 344
-- Name: project_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.project_meta_id_seq', 1, false);


--
-- TOC entry 5407 (class 0 OID 0)
-- Dependencies: 345
-- Name: pseudo_random_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.pseudo_random_id_seq', 1, true);


--
-- TOC entry 5408 (class 0 OID 0)
-- Dependencies: 346
-- Name: registration_evaluation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.registration_evaluation_id_seq', 1, false);


--
-- TOC entry 5409 (class 0 OID 0)
-- Dependencies: 348
-- Name: registration_field_configuration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.registration_field_configuration_id_seq', 1, false);


--
-- TOC entry 5410 (class 0 OID 0)
-- Dependencies: 350
-- Name: registration_file_configuration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.registration_file_configuration_id_seq', 1, false);


--
-- TOC entry 5411 (class 0 OID 0)
-- Dependencies: 351
-- Name: registration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.registration_id_seq', 1, false);


--
-- TOC entry 5412 (class 0 OID 0)
-- Dependencies: 353
-- Name: registration_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.registration_meta_id_seq', 1, false);


--
-- TOC entry 5413 (class 0 OID 0)
-- Dependencies: 354
-- Name: request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.request_id_seq', 1, false);


--
-- TOC entry 5414 (class 0 OID 0)
-- Dependencies: 356
-- Name: revision_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.revision_data_id_seq', 78, true);


--
-- TOC entry 5415 (class 0 OID 0)
-- Dependencies: 358
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.role_id_seq', 2, true);


--
-- TOC entry 5416 (class 0 OID 0)
-- Dependencies: 360
-- Name: seal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.seal_id_seq', 1, false);


--
-- TOC entry 5417 (class 0 OID 0)
-- Dependencies: 362
-- Name: seal_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.seal_meta_id_seq', 1, false);


--
-- TOC entry 5418 (class 0 OID 0)
-- Dependencies: 364
-- Name: seal_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.seal_relation_id_seq', 1, false);


--
-- TOC entry 5419 (class 0 OID 0)
-- Dependencies: 366
-- Name: space_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.space_id_seq', 1, false);


--
-- TOC entry 5420 (class 0 OID 0)
-- Dependencies: 368
-- Name: space_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.space_meta_id_seq', 1, false);


--
-- TOC entry 5421 (class 0 OID 0)
-- Dependencies: 370
-- Name: space_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.space_relation_id_seq', 1, false);


--
-- TOC entry 5422 (class 0 OID 0)
-- Dependencies: 372
-- Name: subsite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.subsite_id_seq', 1, false);


--
-- TOC entry 5423 (class 0 OID 0)
-- Dependencies: 374
-- Name: subsite_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.subsite_meta_id_seq', 1, false);


--
-- TOC entry 5424 (class 0 OID 0)
-- Dependencies: 388
-- Name: system_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.system_role_id_seq', 1, false);


--
-- TOC entry 5425 (class 0 OID 0)
-- Dependencies: 376
-- Name: term_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.term_id_seq', 1, true);


--
-- TOC entry 5426 (class 0 OID 0)
-- Dependencies: 378
-- Name: term_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.term_relation_id_seq', 2, true);


--
-- TOC entry 5427 (class 0 OID 0)
-- Dependencies: 381
-- Name: user_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.user_meta_id_seq', 2, true);


--
-- TOC entry 5428 (class 0 OID 0)
-- Dependencies: 307
-- Name: usr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mapas
--

SELECT pg_catalog.setval('public.usr_id_seq', 1, true);


--
-- TOC entry 4794 (class 2606 OID 18511)
-- Name: _mesoregiao _mesoregiao_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public._mesoregiao
    ADD CONSTRAINT _mesoregiao_pkey PRIMARY KEY (gid);


--
-- TOC entry 4796 (class 2606 OID 18513)
-- Name: _microregiao _microregiao_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public._microregiao
    ADD CONSTRAINT _microregiao_pkey PRIMARY KEY (gid);


--
-- TOC entry 4798 (class 2606 OID 18515)
-- Name: _municipios _municipios_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public._municipios
    ADD CONSTRAINT _municipios_pkey PRIMARY KEY (gid);


--
-- TOC entry 4806 (class 2606 OID 18517)
-- Name: agent_meta agent_meta_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.agent_meta
    ADD CONSTRAINT agent_meta_pk PRIMARY KEY (id);


--
-- TOC entry 4800 (class 2606 OID 18519)
-- Name: agent agent_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_pk PRIMARY KEY (id);


--
-- TOC entry 4813 (class 2606 OID 18521)
-- Name: agent_relation agent_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.agent_relation
    ADD CONSTRAINT agent_relation_pkey PRIMARY KEY (id);


--
-- TOC entry 4996 (class 2606 OID 19075)
-- Name: chat_message chat_message_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT chat_message_pkey PRIMARY KEY (id);


--
-- TOC entry 4994 (class 2606 OID 19067)
-- Name: chat_thread chat_thread_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.chat_thread
    ADD CONSTRAINT chat_thread_pkey PRIMARY KEY (id);


--
-- TOC entry 4816 (class 2606 OID 18523)
-- Name: db_update db_update_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.db_update
    ADD CONSTRAINT db_update_pk PRIMARY KEY (name);


--
-- TOC entry 4825 (class 2606 OID 18525)
-- Name: entity_revision_data entity_revision_data_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.entity_revision_data
    ADD CONSTRAINT entity_revision_data_pkey PRIMARY KEY (id);


--
-- TOC entry 4821 (class 2606 OID 18527)
-- Name: entity_revision entity_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.entity_revision
    ADD CONSTRAINT entity_revision_pkey PRIMARY KEY (id);


--
-- TOC entry 4828 (class 2606 OID 18529)
-- Name: entity_revision_revision_data entity_revision_revision_data_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.entity_revision_revision_data
    ADD CONSTRAINT entity_revision_revision_data_pkey PRIMARY KEY (revision_id, revision_data_id);


--
-- TOC entry 4831 (class 2606 OID 18531)
-- Name: evaluation_method_configuration evaluation_method_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.evaluation_method_configuration
    ADD CONSTRAINT evaluation_method_configuration_pkey PRIMARY KEY (id);


--
-- TOC entry 4836 (class 2606 OID 18533)
-- Name: evaluationmethodconfiguration_meta evaluationmethodconfiguration_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.evaluationmethodconfiguration_meta
    ADD CONSTRAINT evaluationmethodconfiguration_meta_pkey PRIMARY KEY (id);


--
-- TOC entry 4867 (class 2606 OID 18535)
-- Name: event_attendance event_attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_attendance
    ADD CONSTRAINT event_attendance_pkey PRIMARY KEY (id);


--
-- TOC entry 4877 (class 2606 OID 18537)
-- Name: event_meta event_meta_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_meta
    ADD CONSTRAINT event_meta_pk PRIMARY KEY (id);


--
-- TOC entry 4879 (class 2606 OID 18539)
-- Name: event_occurrence_cancellation event_occurrence_cancellation_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_occurrence_cancellation
    ADD CONSTRAINT event_occurrence_cancellation_pkey PRIMARY KEY (id);


--
-- TOC entry 4791 (class 2606 OID 18541)
-- Name: event_occurrence event_occurrence_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_occurrence
    ADD CONSTRAINT event_occurrence_pkey PRIMARY KEY (id);


--
-- TOC entry 4881 (class 2606 OID 18543)
-- Name: event_occurrence_recurrence event_occurrence_recurrence_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_occurrence_recurrence
    ADD CONSTRAINT event_occurrence_recurrence_pkey PRIMARY KEY (id);


--
-- TOC entry 4864 (class 2606 OID 18545)
-- Name: event event_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pk PRIMARY KEY (id);


--
-- TOC entry 4888 (class 2606 OID 18547)
-- Name: file file_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.file
    ADD CONSTRAINT file_pk PRIMARY KEY (id);


--
-- TOC entry 4891 (class 2606 OID 18549)
-- Name: geo_division geo_divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.geo_division
    ADD CONSTRAINT geo_divisions_pkey PRIMARY KEY (id);


--
-- TOC entry 5002 (class 2606 OID 19101)
-- Name: job job_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (id);


--
-- TOC entry 4893 (class 2606 OID 18551)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (object_id, object_type, key);


--
-- TOC entry 4895 (class 2606 OID 18553)
-- Name: metalist metalist_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.metalist
    ADD CONSTRAINT metalist_pk PRIMARY KEY (id);


--
-- TOC entry 4902 (class 2606 OID 18555)
-- Name: notification_meta notification_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.notification_meta
    ADD CONSTRAINT notification_meta_pkey PRIMARY KEY (id);


--
-- TOC entry 4897 (class 2606 OID 18557)
-- Name: notification notification_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pk PRIMARY KEY (id);


--
-- TOC entry 4911 (class 2606 OID 18559)
-- Name: opportunity_meta opportunity_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.opportunity_meta
    ADD CONSTRAINT opportunity_meta_pkey PRIMARY KEY (id);


--
-- TOC entry 4907 (class 2606 OID 18561)
-- Name: opportunity opportunity_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.opportunity
    ADD CONSTRAINT opportunity_pkey PRIMARY KEY (id);


--
-- TOC entry 4844 (class 2606 OID 18563)
-- Name: pcache pcache_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.pcache
    ADD CONSTRAINT pcache_pkey PRIMARY KEY (id);


--
-- TOC entry 4913 (class 2606 OID 18565)
-- Name: permission_cache_pending permission_cache_pending_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.permission_cache_pending
    ADD CONSTRAINT permission_cache_pending_pkey PRIMARY KEY (id);


--
-- TOC entry 4916 (class 2606 OID 18567)
-- Name: procuration procuration_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.procuration
    ADD CONSTRAINT procuration_pkey PRIMARY KEY (token);


--
-- TOC entry 4922 (class 2606 OID 18569)
-- Name: project_event project_event_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.project_event
    ADD CONSTRAINT project_event_pk PRIMARY KEY (id);


--
-- TOC entry 4927 (class 2606 OID 18571)
-- Name: project_meta project_meta_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.project_meta
    ADD CONSTRAINT project_meta_pk PRIMARY KEY (id);


--
-- TOC entry 4920 (class 2606 OID 18573)
-- Name: project project_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pk PRIMARY KEY (id);


--
-- TOC entry 4860 (class 2606 OID 18575)
-- Name: registration_evaluation registration_evaluation_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration_evaluation
    ADD CONSTRAINT registration_evaluation_pkey PRIMARY KEY (id);


--
-- TOC entry 4931 (class 2606 OID 18577)
-- Name: registration_field_configuration registration_field_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration_field_configuration
    ADD CONSTRAINT registration_field_configuration_pkey PRIMARY KEY (id);


--
-- TOC entry 4934 (class 2606 OID 18579)
-- Name: registration_file_configuration registration_file_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration_file_configuration
    ADD CONSTRAINT registration_file_configuration_pkey PRIMARY KEY (id);


--
-- TOC entry 4938 (class 2606 OID 18581)
-- Name: registration_meta registration_meta_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration_meta
    ADD CONSTRAINT registration_meta_pk PRIMARY KEY (id);


--
-- TOC entry 4852 (class 2606 OID 18583)
-- Name: registration registration_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration
    ADD CONSTRAINT registration_pkey PRIMARY KEY (id);


--
-- TOC entry 4940 (class 2606 OID 18585)
-- Name: request request_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.request
    ADD CONSTRAINT request_pk PRIMARY KEY (id);


--
-- TOC entry 4945 (class 2606 OID 18587)
-- Name: role role_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pk PRIMARY KEY (id);


--
-- TOC entry 4972 (class 2606 OID 18589)
-- Name: subsite saas_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.subsite
    ADD CONSTRAINT saas_pkey PRIMARY KEY (id);


--
-- TOC entry 4953 (class 2606 OID 18591)
-- Name: seal_meta seal_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.seal_meta
    ADD CONSTRAINT seal_meta_pkey PRIMARY KEY (id);


--
-- TOC entry 4948 (class 2606 OID 18593)
-- Name: seal seal_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.seal
    ADD CONSTRAINT seal_pkey PRIMARY KEY (id);


--
-- TOC entry 4955 (class 2606 OID 18595)
-- Name: seal_relation seal_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.seal_relation
    ADD CONSTRAINT seal_relation_pkey PRIMARY KEY (id);


--
-- TOC entry 4965 (class 2606 OID 18597)
-- Name: space_meta space_meta_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.space_meta
    ADD CONSTRAINT space_meta_pk PRIMARY KEY (id);


--
-- TOC entry 4959 (class 2606 OID 18599)
-- Name: space space_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.space
    ADD CONSTRAINT space_pk PRIMARY KEY (id);


--
-- TOC entry 4969 (class 2606 OID 18601)
-- Name: space_relation space_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.space_relation
    ADD CONSTRAINT space_relation_pkey PRIMARY KEY (id);


--
-- TOC entry 4978 (class 2606 OID 18603)
-- Name: subsite_meta subsite_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.subsite_meta
    ADD CONSTRAINT subsite_meta_pkey PRIMARY KEY (id);


--
-- TOC entry 5005 (class 2606 OID 19155)
-- Name: system_role system_role_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.system_role
    ADD CONSTRAINT system_role_pkey PRIMARY KEY (id);


--
-- TOC entry 4981 (class 2606 OID 18605)
-- Name: term term_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.term
    ADD CONSTRAINT term_pk PRIMARY KEY (id);


--
-- TOC entry 4984 (class 2606 OID 18607)
-- Name: term_relation term_relation_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.term_relation
    ADD CONSTRAINT term_relation_pk PRIMARY KEY (id);


--
-- TOC entry 4987 (class 2606 OID 18609)
-- Name: user_app user_app_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.user_app
    ADD CONSTRAINT user_app_pk PRIMARY KEY (public_key);


--
-- TOC entry 4992 (class 2606 OID 18611)
-- Name: user_meta user_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.user_meta
    ADD CONSTRAINT user_meta_pkey PRIMARY KEY (id);


--
-- TOC entry 4862 (class 2606 OID 18613)
-- Name: usr usr_pk; Type: CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.usr
    ADD CONSTRAINT usr_pk PRIMARY KEY (id);


--
-- TOC entry 4802 (class 1259 OID 18614)
-- Name: agent_meta_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX agent_meta_key_idx ON public.agent_meta USING btree (key);


--
-- TOC entry 4803 (class 1259 OID 18615)
-- Name: agent_meta_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX agent_meta_owner_idx ON public.agent_meta USING btree (object_id);


--
-- TOC entry 4804 (class 1259 OID 18616)
-- Name: agent_meta_owner_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX agent_meta_owner_key_idx ON public.agent_meta USING btree (object_id, key);


--
-- TOC entry 4807 (class 1259 OID 19054)
-- Name: agent_relation_has_control; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX agent_relation_has_control ON public.agent_relation USING btree (has_control);


--
-- TOC entry 4808 (class 1259 OID 19052)
-- Name: agent_relation_owner; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX agent_relation_owner ON public.agent_relation USING btree (object_type, object_id);


--
-- TOC entry 4809 (class 1259 OID 19053)
-- Name: agent_relation_owner_agent; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX agent_relation_owner_agent ON public.agent_relation USING btree (object_type, object_id, agent_id);


--
-- TOC entry 4810 (class 1259 OID 19051)
-- Name: agent_relation_owner_id; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX agent_relation_owner_id ON public.agent_relation USING btree (object_id);


--
-- TOC entry 4811 (class 1259 OID 19050)
-- Name: agent_relation_owner_type; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX agent_relation_owner_type ON public.agent_relation USING btree (object_type);


--
-- TOC entry 4814 (class 1259 OID 19055)
-- Name: agent_relation_status; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX agent_relation_status ON public.agent_relation USING btree (status);


--
-- TOC entry 4970 (class 1259 OID 18618)
-- Name: alias_url_index; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX alias_url_index ON public.subsite USING btree (alias_url);


--
-- TOC entry 4822 (class 1259 OID 19134)
-- Name: entity_revision_data_id; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX entity_revision_data_id ON public.entity_revision_data USING btree (id);


--
-- TOC entry 4823 (class 1259 OID 19135)
-- Name: entity_revision_data_key; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX entity_revision_data_key ON public.entity_revision_data USING btree (key);


--
-- TOC entry 4817 (class 1259 OID 19131)
-- Name: entity_revision_object; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX entity_revision_object ON public.entity_revision USING btree (object_type, object_id);


--
-- TOC entry 4818 (class 1259 OID 19130)
-- Name: entity_revision_object_id; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX entity_revision_object_id ON public.entity_revision USING btree (object_id);


--
-- TOC entry 4819 (class 1259 OID 19129)
-- Name: entity_revision_object_type; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX entity_revision_object_type ON public.entity_revision USING btree (object_type);


--
-- TOC entry 4826 (class 1259 OID 19132)
-- Name: entity_revision_revision_data_data_id; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX entity_revision_revision_data_data_id ON public.entity_revision_revision_data USING btree (revision_data_id);


--
-- TOC entry 4829 (class 1259 OID 19133)
-- Name: entity_revision_revision_data_revision_id; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX entity_revision_revision_data_revision_id ON public.entity_revision_revision_data USING btree (revision_id);


--
-- TOC entry 4833 (class 1259 OID 18619)
-- Name: evaluationmethodconfiguration_meta_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX evaluationmethodconfiguration_meta_owner_idx ON public.evaluationmethodconfiguration_meta USING btree (object_id);


--
-- TOC entry 4834 (class 1259 OID 18620)
-- Name: evaluationmethodconfiguration_meta_owner_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX evaluationmethodconfiguration_meta_owner_key_idx ON public.evaluationmethodconfiguration_meta USING btree (object_id, key);


--
-- TOC entry 4868 (class 1259 OID 18621)
-- Name: event_attendance_type_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX event_attendance_type_idx ON public.event_attendance USING btree (type);


--
-- TOC entry 4873 (class 1259 OID 18622)
-- Name: event_meta_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX event_meta_key_idx ON public.event_meta USING btree (key);


--
-- TOC entry 4874 (class 1259 OID 18623)
-- Name: event_meta_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX event_meta_owner_idx ON public.event_meta USING btree (object_id);


--
-- TOC entry 4875 (class 1259 OID 18624)
-- Name: event_meta_owner_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX event_meta_owner_key_idx ON public.event_meta USING btree (object_id, key);


--
-- TOC entry 4792 (class 1259 OID 18625)
-- Name: event_occurrence_status_index; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX event_occurrence_status_index ON public.event_occurrence USING btree (status);


--
-- TOC entry 4882 (class 1259 OID 18626)
-- Name: file_group_index; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX file_group_index ON public.file USING btree (grp);


--
-- TOC entry 4883 (class 1259 OID 18627)
-- Name: file_owner_grp_index; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX file_owner_grp_index ON public.file USING btree (object_type, object_id, grp);


--
-- TOC entry 4884 (class 1259 OID 18628)
-- Name: file_owner_index; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX file_owner_index ON public.file USING btree (object_type, object_id);


--
-- TOC entry 4885 (class 1259 OID 19144)
-- Name: file_parent_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX file_parent_idx ON public.file USING btree (parent_id);


--
-- TOC entry 4886 (class 1259 OID 19145)
-- Name: file_parent_object_type_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX file_parent_object_type_idx ON public.file USING btree (parent_id, object_type);


--
-- TOC entry 4889 (class 1259 OID 18629)
-- Name: geo_divisions_geom_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX geo_divisions_geom_idx ON public.geo_division USING gist (geom);


--
-- TOC entry 4966 (class 1259 OID 18630)
-- Name: idx_1a0e9a30232d562b; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_1a0e9a30232d562b ON public.space_relation USING btree (object_id);


--
-- TOC entry 4967 (class 1259 OID 18631)
-- Name: idx_1a0e9a3023575340; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_1a0e9a3023575340 ON public.space_relation USING btree (space_id);


--
-- TOC entry 4932 (class 1259 OID 18632)
-- Name: idx_209c792e9a34590f; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_209c792e9a34590f ON public.registration_file_configuration USING btree (opportunity_id);


--
-- TOC entry 4985 (class 1259 OID 18633)
-- Name: idx_22781144c79c849a; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_22781144c79c849a ON public.user_app USING btree (subsite_id);


--
-- TOC entry 4801 (class 1259 OID 18634)
-- Name: idx_268b9c9dc79c849a; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_268b9c9dc79c849a ON public.agent USING btree (subsite_id);


--
-- TOC entry 4956 (class 1259 OID 18635)
-- Name: idx_2972c13ac79c849a; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_2972c13ac79c849a ON public.space USING btree (subsite_id);


--
-- TOC entry 4857 (class 1259 OID 18636)
-- Name: idx_2e186c5c833d8f43; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_2e186c5c833d8f43 ON public.registration_evaluation USING btree (registration_id);


--
-- TOC entry 4858 (class 1259 OID 18637)
-- Name: idx_2e186c5ca76ed395; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_2e186c5ca76ed395 ON public.registration_evaluation USING btree (user_id);


--
-- TOC entry 4946 (class 1259 OID 18638)
-- Name: idx_2e30ae30c79c849a; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_2e30ae30c79c849a ON public.seal USING btree (subsite_id);


--
-- TOC entry 4918 (class 1259 OID 18639)
-- Name: idx_2fb3d0eec79c849a; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_2fb3d0eec79c849a ON public.project USING btree (subsite_id);


--
-- TOC entry 4869 (class 1259 OID 18640)
-- Name: idx_350dd4be140e9f00; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_350dd4be140e9f00 ON public.event_attendance USING btree (event_occurrence_id);


--
-- TOC entry 4870 (class 1259 OID 18641)
-- Name: idx_350dd4be23575340; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_350dd4be23575340 ON public.event_attendance USING btree (space_id);


--
-- TOC entry 4871 (class 1259 OID 18642)
-- Name: idx_350dd4be71f7e88b; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_350dd4be71f7e88b ON public.event_attendance USING btree (event_id);


--
-- TOC entry 4872 (class 1259 OID 18643)
-- Name: idx_350dd4bea76ed395; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_350dd4bea76ed395 ON public.event_attendance USING btree (user_id);


--
-- TOC entry 4865 (class 1259 OID 18644)
-- Name: idx_3bae0aa7c79c849a; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_3bae0aa7c79c849a ON public.event USING btree (subsite_id);


--
-- TOC entry 4837 (class 1259 OID 18645)
-- Name: idx_3d853098232d562b; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_3d853098232d562b ON public.pcache USING btree (object_id);


--
-- TOC entry 4838 (class 1259 OID 18646)
-- Name: idx_3d853098a76ed395; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_3d853098a76ed395 ON public.pcache USING btree (user_id);


--
-- TOC entry 4943 (class 1259 OID 18647)
-- Name: idx_57698a6ac79c849a; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_57698a6ac79c849a ON public.role USING btree (subsite_id);


--
-- TOC entry 4928 (class 1259 OID 18648)
-- Name: idx_60c85cb1166d1f9c; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_60c85cb1166d1f9c ON public.registration_field_configuration USING btree (opportunity_id);


--
-- TOC entry 4929 (class 1259 OID 18649)
-- Name: idx_60c85cb19a34590f; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_60c85cb19a34590f ON public.registration_field_configuration USING btree (opportunity_id);


--
-- TOC entry 4845 (class 1259 OID 18650)
-- Name: idx_62a8a7a73414710b; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_62a8a7a73414710b ON public.registration USING btree (agent_id);


--
-- TOC entry 4846 (class 1259 OID 18651)
-- Name: idx_62a8a7a79a34590f; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_62a8a7a79a34590f ON public.registration USING btree (opportunity_id);


--
-- TOC entry 4847 (class 1259 OID 18652)
-- Name: idx_62a8a7a7c79c849a; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_62a8a7a7c79c849a ON public.registration USING btree (subsite_id);


--
-- TOC entry 4997 (class 1259 OID 19077)
-- Name: idx_fab3fc16727aca70; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_fab3fc16727aca70 ON public.chat_message USING btree (parent_id);


--
-- TOC entry 4998 (class 1259 OID 19078)
-- Name: idx_fab3fc16a76ed395; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_fab3fc16a76ed395 ON public.chat_message USING btree (user_id);


--
-- TOC entry 4999 (class 1259 OID 19076)
-- Name: idx_fab3fc16c47d5262; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX idx_fab3fc16c47d5262 ON public.chat_message USING btree (chat_thread_id);


--
-- TOC entry 5000 (class 1259 OID 19102)
-- Name: job_next_execution_timestamp_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX job_next_execution_timestamp_idx ON public.job USING btree (next_execution_timestamp);


--
-- TOC entry 5003 (class 1259 OID 19103)
-- Name: job_search_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX job_search_idx ON public.job USING btree (next_execution_timestamp, iterations_count, status);


--
-- TOC entry 4898 (class 1259 OID 18653)
-- Name: notification_meta_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX notification_meta_key_idx ON public.notification_meta USING btree (key);


--
-- TOC entry 4899 (class 1259 OID 18654)
-- Name: notification_meta_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX notification_meta_owner_idx ON public.notification_meta USING btree (object_id);


--
-- TOC entry 4900 (class 1259 OID 18655)
-- Name: notification_meta_owner_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX notification_meta_owner_key_idx ON public.notification_meta USING btree (object_id, key);


--
-- TOC entry 4903 (class 1259 OID 18656)
-- Name: opportunity_entity_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX opportunity_entity_idx ON public.opportunity USING btree (object_type, object_id);


--
-- TOC entry 4908 (class 1259 OID 18657)
-- Name: opportunity_meta_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX opportunity_meta_owner_idx ON public.opportunity_meta USING btree (object_id);


--
-- TOC entry 4909 (class 1259 OID 18658)
-- Name: opportunity_meta_owner_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX opportunity_meta_owner_key_idx ON public.opportunity_meta USING btree (object_id, key);


--
-- TOC entry 4904 (class 1259 OID 18659)
-- Name: opportunity_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX opportunity_owner_idx ON public.opportunity USING btree (agent_id);


--
-- TOC entry 4905 (class 1259 OID 18660)
-- Name: opportunity_parent_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX opportunity_parent_idx ON public.opportunity USING btree (parent_id);


--
-- TOC entry 4982 (class 1259 OID 18661)
-- Name: owner_index; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX owner_index ON public.term_relation USING btree (object_type, object_id);


--
-- TOC entry 4839 (class 1259 OID 19136)
-- Name: pcache_action_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX pcache_action_idx ON public.pcache USING btree (action);


--
-- TOC entry 4840 (class 1259 OID 18662)
-- Name: pcache_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX pcache_owner_idx ON public.pcache USING btree (object_type, object_id);


--
-- TOC entry 4841 (class 1259 OID 18663)
-- Name: pcache_permission_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX pcache_permission_idx ON public.pcache USING btree (object_type, object_id, action);


--
-- TOC entry 4842 (class 1259 OID 18664)
-- Name: pcache_permission_user_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX pcache_permission_user_idx ON public.pcache USING btree (object_type, object_id, action, user_id);


--
-- TOC entry 4914 (class 1259 OID 18665)
-- Name: procuration_attorney_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX procuration_attorney_idx ON public.procuration USING btree (attorney_user_id);


--
-- TOC entry 4917 (class 1259 OID 18666)
-- Name: procuration_usr_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX procuration_usr_idx ON public.procuration USING btree (usr_id);


--
-- TOC entry 4923 (class 1259 OID 18667)
-- Name: project_meta_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX project_meta_key_idx ON public.project_meta USING btree (key);


--
-- TOC entry 4924 (class 1259 OID 18668)
-- Name: project_meta_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX project_meta_owner_idx ON public.project_meta USING btree (object_id);


--
-- TOC entry 4925 (class 1259 OID 18669)
-- Name: project_meta_owner_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX project_meta_owner_key_idx ON public.project_meta USING btree (object_id, key);


--
-- TOC entry 4848 (class 1259 OID 19138)
-- Name: registration_category_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX registration_category_idx ON public.registration USING btree (category);


--
-- TOC entry 4849 (class 1259 OID 19143)
-- Name: registration_eligible_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX registration_eligible_idx ON public.registration USING btree (eligible);


--
-- TOC entry 4935 (class 1259 OID 18670)
-- Name: registration_meta_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX registration_meta_owner_idx ON public.registration_meta USING btree (object_id);


--
-- TOC entry 4936 (class 1259 OID 18671)
-- Name: registration_meta_owner_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX registration_meta_owner_key_idx ON public.registration_meta USING btree (object_id, key);


--
-- TOC entry 4850 (class 1259 OID 19137)
-- Name: registration_number_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX registration_number_idx ON public.registration USING btree (number);


--
-- TOC entry 4853 (class 1259 OID 19140)
-- Name: registration_proponent_type_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX registration_proponent_type_idx ON public.registration USING btree (proponent_type);


--
-- TOC entry 4854 (class 1259 OID 19139)
-- Name: registration_range_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX registration_range_idx ON public.registration USING btree (range);


--
-- TOC entry 4855 (class 1259 OID 19142)
-- Name: registration_score_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX registration_score_idx ON public.registration USING btree (score);


--
-- TOC entry 4856 (class 1259 OID 19141)
-- Name: registration_status_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX registration_status_idx ON public.registration USING btree (status);


--
-- TOC entry 4941 (class 1259 OID 18672)
-- Name: request_uid; Type: INDEX; Schema: public; Owner: mapas
--

CREATE UNIQUE INDEX request_uid ON public.request USING btree (request_uid);


--
-- TOC entry 4942 (class 1259 OID 18673)
-- Name: requester_user_index; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX requester_user_index ON public.request USING btree (requester_user_id, origin_type, origin_id);


--
-- TOC entry 4949 (class 1259 OID 18674)
-- Name: seal_meta_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX seal_meta_key_idx ON public.seal_meta USING btree (key);


--
-- TOC entry 4950 (class 1259 OID 18675)
-- Name: seal_meta_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX seal_meta_owner_idx ON public.seal_meta USING btree (object_id);


--
-- TOC entry 4951 (class 1259 OID 18676)
-- Name: seal_meta_owner_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX seal_meta_owner_key_idx ON public.seal_meta USING btree (object_id, key);


--
-- TOC entry 4957 (class 1259 OID 18677)
-- Name: space_location; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX space_location ON public.space USING gist (_geo_location);


--
-- TOC entry 4961 (class 1259 OID 18678)
-- Name: space_meta_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX space_meta_key_idx ON public.space_meta USING btree (key);


--
-- TOC entry 4962 (class 1259 OID 18679)
-- Name: space_meta_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX space_meta_owner_idx ON public.space_meta USING btree (object_id);


--
-- TOC entry 4963 (class 1259 OID 18680)
-- Name: space_meta_owner_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX space_meta_owner_key_idx ON public.space_meta USING btree (object_id, key);


--
-- TOC entry 4960 (class 1259 OID 18681)
-- Name: space_type; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX space_type ON public.space USING btree (type);


--
-- TOC entry 4974 (class 1259 OID 18682)
-- Name: subsite_meta_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX subsite_meta_key_idx ON public.subsite_meta USING btree (key);


--
-- TOC entry 4975 (class 1259 OID 18683)
-- Name: subsite_meta_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX subsite_meta_owner_idx ON public.subsite_meta USING btree (object_id);


--
-- TOC entry 4976 (class 1259 OID 18684)
-- Name: subsite_meta_owner_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX subsite_meta_owner_key_idx ON public.subsite_meta USING btree (object_id, key);


--
-- TOC entry 4979 (class 1259 OID 18685)
-- Name: taxonomy_term_unique; Type: INDEX; Schema: public; Owner: mapas
--

CREATE UNIQUE INDEX taxonomy_term_unique ON public.term USING btree (taxonomy, term);


--
-- TOC entry 4832 (class 1259 OID 18686)
-- Name: uniq_330cb54c9a34590f; Type: INDEX; Schema: public; Owner: mapas
--

CREATE UNIQUE INDEX uniq_330cb54c9a34590f ON public.evaluation_method_configuration USING btree (opportunity_id);


--
-- TOC entry 4973 (class 1259 OID 18687)
-- Name: url_index; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX url_index ON public.subsite USING btree (url);


--
-- TOC entry 4988 (class 1259 OID 18688)
-- Name: user_meta_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX user_meta_key_idx ON public.user_meta USING btree (key);


--
-- TOC entry 4989 (class 1259 OID 18689)
-- Name: user_meta_owner_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX user_meta_owner_idx ON public.user_meta USING btree (object_id);


--
-- TOC entry 4990 (class 1259 OID 18690)
-- Name: user_meta_owner_key_idx; Type: INDEX; Schema: public; Owner: mapas
--

CREATE INDEX user_meta_owner_key_idx ON public.user_meta USING btree (object_id, key);


--
-- TOC entry 5075 (class 2620 OID 19108)
-- Name: agent trigger_clean_orphans_agent; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_clean_orphans_agent AFTER DELETE ON public.agent FOR EACH ROW EXECUTE FUNCTION public.fn_clean_orphans('MapasCulturais\Entities\Agent');


--
-- TOC entry 5087 (class 2620 OID 19109)
-- Name: chat_message trigger_clean_orphans_chat_message; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_clean_orphans_chat_message AFTER DELETE ON public.chat_message FOR EACH ROW EXECUTE FUNCTION public.fn_clean_orphans('MapasCulturais\Entities\ChatMessage');


--
-- TOC entry 5086 (class 2620 OID 19110)
-- Name: chat_thread trigger_clean_orphans_chat_thread; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_clean_orphans_chat_thread AFTER DELETE ON public.chat_thread FOR EACH ROW EXECUTE FUNCTION public.fn_clean_orphans('MapasCulturais\Entities\ChatThread');


--
-- TOC entry 5076 (class 2620 OID 19111)
-- Name: evaluation_method_configuration trigger_clean_orphans_evaluation_method_configuration; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_clean_orphans_evaluation_method_configuration AFTER DELETE ON public.evaluation_method_configuration FOR EACH ROW EXECUTE FUNCTION public.fn_clean_orphans('MapasCulturais\Entities\EvaluationMethodConfiguration');


--
-- TOC entry 5078 (class 2620 OID 19112)
-- Name: event trigger_clean_orphans_event; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_clean_orphans_event AFTER DELETE ON public.event FOR EACH ROW EXECUTE FUNCTION public.fn_clean_orphans('MapasCulturais\Entities\Event');


--
-- TOC entry 5079 (class 2620 OID 19113)
-- Name: notification trigger_clean_orphans_notification; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_clean_orphans_notification AFTER DELETE ON public.notification FOR EACH ROW EXECUTE FUNCTION public.fn_clean_orphans('MapasCulturais\Entities\Notification');


--
-- TOC entry 5080 (class 2620 OID 19114)
-- Name: opportunity trigger_clean_orphans_opportunity; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_clean_orphans_opportunity AFTER DELETE ON public.opportunity FOR EACH ROW EXECUTE FUNCTION public.fn_clean_orphans('MapasCulturais\Entities\Opportunity');


--
-- TOC entry 5082 (class 2620 OID 19115)
-- Name: project trigger_clean_orphans_project; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_clean_orphans_project AFTER DELETE ON public.project FOR EACH ROW EXECUTE FUNCTION public.fn_clean_orphans('MapasCulturais\Entities\Project');


--
-- TOC entry 5077 (class 2620 OID 19116)
-- Name: registration trigger_clean_orphans_registration; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_clean_orphans_registration AFTER DELETE ON public.registration FOR EACH ROW EXECUTE FUNCTION public.fn_clean_orphans('MapasCulturais\Entities\Registration');


--
-- TOC entry 5083 (class 2620 OID 19117)
-- Name: registration_file_configuration trigger_clean_orphans_registration_file_configuration; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_clean_orphans_registration_file_configuration AFTER DELETE ON public.registration_file_configuration FOR EACH ROW EXECUTE FUNCTION public.fn_clean_orphans('MapasCulturais\Entities\RegistrationFileConfiguration');


--
-- TOC entry 5084 (class 2620 OID 19118)
-- Name: space trigger_clean_orphans_space; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_clean_orphans_space AFTER DELETE ON public.space FOR EACH ROW EXECUTE FUNCTION public.fn_clean_orphans('MapasCulturais\Entities\Space');


--
-- TOC entry 5085 (class 2620 OID 19119)
-- Name: subsite trigger_clean_orphans_subsite; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_clean_orphans_subsite AFTER DELETE ON public.subsite FOR EACH ROW EXECUTE FUNCTION public.fn_clean_orphans('MapasCulturais\Entities\Subsite');


--
-- TOC entry 5081 (class 2620 OID 19128)
-- Name: opportunity trigger_propagate_opportunity_update; Type: TRIGGER; Schema: public; Owner: mapas
--

CREATE TRIGGER trigger_propagate_opportunity_update AFTER UPDATE ON public.opportunity FOR EACH ROW EXECUTE FUNCTION public.fn_propagate_opportunity_update();


--
-- TOC entry 5024 (class 2606 OID 18691)
-- Name: usr fk_1762498cccfa12b8; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.usr
    ADD CONSTRAINT fk_1762498cccfa12b8 FOREIGN KEY (profile_id) REFERENCES public.agent(id) ON DELETE SET NULL;


--
-- TOC entry 5050 (class 2606 OID 18696)
-- Name: registration_meta fk_18cc03e9232d562b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration_meta
    ADD CONSTRAINT fk_18cc03e9232d562b FOREIGN KEY (object_id) REFERENCES public.registration(id) ON DELETE CASCADE;


--
-- TOC entry 5064 (class 2606 OID 18701)
-- Name: space_relation fk_1a0e9a30232d562b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.space_relation
    ADD CONSTRAINT fk_1a0e9a30232d562b FOREIGN KEY (object_id) REFERENCES public.registration(id) ON DELETE CASCADE;


--
-- TOC entry 5065 (class 2606 OID 18706)
-- Name: space_relation fk_1a0e9a3023575340; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.space_relation
    ADD CONSTRAINT fk_1a0e9a3023575340 FOREIGN KEY (space_id) REFERENCES public.space(id) ON DELETE CASCADE;


--
-- TOC entry 5049 (class 2606 OID 18711)
-- Name: registration_file_configuration fk_209c792e9a34590f; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration_file_configuration
    ADD CONSTRAINT fk_209c792e9a34590f FOREIGN KEY (opportunity_id) REFERENCES public.opportunity(id) ON DELETE CASCADE;


--
-- TOC entry 5069 (class 2606 OID 18716)
-- Name: user_app fk_22781144a76ed395; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.user_app
    ADD CONSTRAINT fk_22781144a76ed395 FOREIGN KEY (user_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5070 (class 2606 OID 18721)
-- Name: user_app fk_22781144bddfbe89; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.user_app
    ADD CONSTRAINT fk_22781144bddfbe89 FOREIGN KEY (subsite_id) REFERENCES public.subsite(id) ON DELETE CASCADE;


--
-- TOC entry 5008 (class 2606 OID 18726)
-- Name: agent fk_268b9c9d727aca70; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT fk_268b9c9d727aca70 FOREIGN KEY (parent_id) REFERENCES public.agent(id) ON DELETE SET NULL;


--
-- TOC entry 5009 (class 2606 OID 18731)
-- Name: agent fk_268b9c9da76ed395; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT fk_268b9c9da76ed395 FOREIGN KEY (user_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5010 (class 2606 OID 18736)
-- Name: agent fk_268b9c9dbddfbe89; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT fk_268b9c9dbddfbe89 FOREIGN KEY (subsite_id) REFERENCES public.subsite(id) ON DELETE SET NULL;


--
-- TOC entry 5060 (class 2606 OID 18741)
-- Name: space fk_2972c13a3414710b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.space
    ADD CONSTRAINT fk_2972c13a3414710b FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 5061 (class 2606 OID 18746)
-- Name: space fk_2972c13a727aca70; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.space
    ADD CONSTRAINT fk_2972c13a727aca70 FOREIGN KEY (parent_id) REFERENCES public.space(id) ON DELETE CASCADE;


--
-- TOC entry 5062 (class 2606 OID 18751)
-- Name: space fk_2972c13abddfbe89; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.space
    ADD CONSTRAINT fk_2972c13abddfbe89 FOREIGN KEY (subsite_id) REFERENCES public.subsite(id) ON DELETE SET NULL;


--
-- TOC entry 5041 (class 2606 OID 18756)
-- Name: opportunity_meta fk_2bb06d08232d562b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.opportunity_meta
    ADD CONSTRAINT fk_2bb06d08232d562b FOREIGN KEY (object_id) REFERENCES public.opportunity(id) ON DELETE CASCADE;


--
-- TOC entry 5022 (class 2606 OID 18761)
-- Name: registration_evaluation fk_2e186c5c833d8f43; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration_evaluation
    ADD CONSTRAINT fk_2e186c5c833d8f43 FOREIGN KEY (registration_id) REFERENCES public.registration(id) ON DELETE CASCADE;


--
-- TOC entry 5023 (class 2606 OID 18766)
-- Name: registration_evaluation fk_2e186c5ca76ed395; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration_evaluation
    ADD CONSTRAINT fk_2e186c5ca76ed395 FOREIGN KEY (user_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5054 (class 2606 OID 18771)
-- Name: seal fk_2e30ae303414710b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.seal
    ADD CONSTRAINT fk_2e30ae303414710b FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 5055 (class 2606 OID 18776)
-- Name: seal fk_2e30ae30bddfbe89; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.seal
    ADD CONSTRAINT fk_2e30ae30bddfbe89 FOREIGN KEY (subsite_id) REFERENCES public.subsite(id) ON DELETE CASCADE;


--
-- TOC entry 5044 (class 2606 OID 18781)
-- Name: project fk_2fb3d0ee3414710b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT fk_2fb3d0ee3414710b FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 5045 (class 2606 OID 18786)
-- Name: project fk_2fb3d0ee727aca70; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT fk_2fb3d0ee727aca70 FOREIGN KEY (parent_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- TOC entry 5046 (class 2606 OID 18791)
-- Name: project fk_2fb3d0eebddfbe89; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT fk_2fb3d0eebddfbe89 FOREIGN KEY (subsite_id) REFERENCES public.subsite(id) ON DELETE SET NULL;


--
-- TOC entry 5016 (class 2606 OID 18796)
-- Name: evaluation_method_configuration fk_330cb54c9a34590f; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.evaluation_method_configuration
    ADD CONSTRAINT fk_330cb54c9a34590f FOREIGN KEY (opportunity_id) REFERENCES public.opportunity(id) ON DELETE CASCADE;


--
-- TOC entry 5028 (class 2606 OID 18801)
-- Name: event_attendance fk_350dd4be140e9f00; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_attendance
    ADD CONSTRAINT fk_350dd4be140e9f00 FOREIGN KEY (event_occurrence_id) REFERENCES public.event_occurrence(id) ON DELETE CASCADE;


--
-- TOC entry 5029 (class 2606 OID 18806)
-- Name: event_attendance fk_350dd4be23575340; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_attendance
    ADD CONSTRAINT fk_350dd4be23575340 FOREIGN KEY (space_id) REFERENCES public.space(id) ON DELETE CASCADE;


--
-- TOC entry 5030 (class 2606 OID 18811)
-- Name: event_attendance fk_350dd4be71f7e88b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_attendance
    ADD CONSTRAINT fk_350dd4be71f7e88b FOREIGN KEY (event_id) REFERENCES public.event(id) ON DELETE CASCADE;


--
-- TOC entry 5031 (class 2606 OID 18816)
-- Name: event_attendance fk_350dd4bea76ed395; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_attendance
    ADD CONSTRAINT fk_350dd4bea76ed395 FOREIGN KEY (user_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5034 (class 2606 OID 18821)
-- Name: event_occurrence_recurrence fk_388eccb140e9f00; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_occurrence_recurrence
    ADD CONSTRAINT fk_388eccb140e9f00 FOREIGN KEY (event_occurrence_id) REFERENCES public.event_occurrence(id) ON DELETE CASCADE;


--
-- TOC entry 5051 (class 2606 OID 18826)
-- Name: request fk_3b978f9fba78f12a; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.request
    ADD CONSTRAINT fk_3b978f9fba78f12a FOREIGN KEY (requester_user_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5025 (class 2606 OID 18831)
-- Name: event fk_3bae0aa7166d1f9c; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT fk_3bae0aa7166d1f9c FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE SET NULL;


--
-- TOC entry 5026 (class 2606 OID 18836)
-- Name: event fk_3bae0aa73414710b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT fk_3bae0aa73414710b FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 5027 (class 2606 OID 18841)
-- Name: event fk_3bae0aa7bddfbe89; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT fk_3bae0aa7bddfbe89 FOREIGN KEY (subsite_id) REFERENCES public.subsite(id) ON DELETE SET NULL;


--
-- TOC entry 5018 (class 2606 OID 18846)
-- Name: pcache fk_3d853098a76ed395; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.pcache
    ADD CONSTRAINT fk_3d853098a76ed395 FOREIGN KEY (user_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5057 (class 2606 OID 18851)
-- Name: seal_relation fk_487af6513414710b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.seal_relation
    ADD CONSTRAINT fk_487af6513414710b FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 5058 (class 2606 OID 18856)
-- Name: seal_relation fk_487af65154778145; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.seal_relation
    ADD CONSTRAINT fk_487af65154778145 FOREIGN KEY (seal_id) REFERENCES public.seal(id) ON DELETE CASCADE;


--
-- TOC entry 5059 (class 2606 OID 18861)
-- Name: seal_relation fk_487af6517e3c61f9; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.seal_relation
    ADD CONSTRAINT fk_487af6517e3c61f9 FOREIGN KEY (owner_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 5012 (class 2606 OID 18866)
-- Name: agent_relation fk_54585edd3414710b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.agent_relation
    ADD CONSTRAINT fk_54585edd3414710b FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 5052 (class 2606 OID 18871)
-- Name: role fk_57698a6abddfbe89; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT fk_57698a6abddfbe89 FOREIGN KEY (subsite_id) REFERENCES public.subsite(id) ON DELETE CASCADE;


--
-- TOC entry 5053 (class 2606 OID 18876)
-- Name: role fk_57698a6ac69d3fb; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT fk_57698a6ac69d3fb FOREIGN KEY (usr_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5048 (class 2606 OID 18881)
-- Name: registration_field_configuration fk_60c85cb19a34590f; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration_field_configuration
    ADD CONSTRAINT fk_60c85cb19a34590f FOREIGN KEY (opportunity_id) REFERENCES public.opportunity(id) ON DELETE CASCADE;


--
-- TOC entry 5019 (class 2606 OID 18886)
-- Name: registration fk_62a8a7a73414710b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration
    ADD CONSTRAINT fk_62a8a7a73414710b FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 5020 (class 2606 OID 18891)
-- Name: registration fk_62a8a7a79a34590f; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration
    ADD CONSTRAINT fk_62a8a7a79a34590f FOREIGN KEY (opportunity_id) REFERENCES public.opportunity(id) ON DELETE CASCADE;


--
-- TOC entry 5021 (class 2606 OID 18896)
-- Name: registration fk_62a8a7a7bddfbe89; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.registration
    ADD CONSTRAINT fk_62a8a7a7bddfbe89 FOREIGN KEY (subsite_id) REFERENCES public.subsite(id) ON DELETE SET NULL;


--
-- TOC entry 5038 (class 2606 OID 18901)
-- Name: notification_meta fk_6fce5f0f232d562b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.notification_meta
    ADD CONSTRAINT fk_6fce5f0f232d562b FOREIGN KEY (object_id) REFERENCES public.notification(id) ON DELETE CASCADE;


--
-- TOC entry 5067 (class 2606 OID 18906)
-- Name: subsite_meta fk_780702f5232d562b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.subsite_meta
    ADD CONSTRAINT fk_780702f5232d562b FOREIGN KEY (object_id) REFERENCES public.subsite(id) ON DELETE CASCADE;


--
-- TOC entry 5011 (class 2606 OID 18911)
-- Name: agent_meta fk_7a69aed6232d562b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.agent_meta
    ADD CONSTRAINT fk_7a69aed6232d562b FOREIGN KEY (object_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 5039 (class 2606 OID 18916)
-- Name: opportunity fk_8389c3d73414710b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.opportunity
    ADD CONSTRAINT fk_8389c3d73414710b FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 5040 (class 2606 OID 18921)
-- Name: opportunity fk_8389c3d7727aca70; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.opportunity
    ADD CONSTRAINT fk_8389c3d7727aca70 FOREIGN KEY (parent_id) REFERENCES public.opportunity(id) ON DELETE CASCADE;


--
-- TOC entry 5035 (class 2606 OID 18926)
-- Name: file fk_8c9f3610727aca70; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.file
    ADD CONSTRAINT fk_8c9f3610727aca70 FOREIGN KEY (parent_id) REFERENCES public.file(id) ON DELETE CASCADE;


--
-- TOC entry 5014 (class 2606 OID 18931)
-- Name: entity_revision_revision_data fk_9977a8521dfa7c8f; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.entity_revision_revision_data
    ADD CONSTRAINT fk_9977a8521dfa7c8f FOREIGN KEY (revision_id) REFERENCES public.entity_revision(id) ON DELETE CASCADE;


--
-- TOC entry 5015 (class 2606 OID 18936)
-- Name: entity_revision_revision_data fk_9977a852b4906f58; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.entity_revision_revision_data
    ADD CONSTRAINT fk_9977a852b4906f58 FOREIGN KEY (revision_data_id) REFERENCES public.entity_revision_data(id) ON DELETE CASCADE;


--
-- TOC entry 5033 (class 2606 OID 18941)
-- Name: event_occurrence_cancellation fk_a5506736140e9f00; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_occurrence_cancellation
    ADD CONSTRAINT fk_a5506736140e9f00 FOREIGN KEY (event_occurrence_id) REFERENCES public.event_occurrence(id) ON DELETE CASCADE;


--
-- TOC entry 5056 (class 2606 OID 18946)
-- Name: seal_meta fk_a92e5e22232d562b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.seal_meta
    ADD CONSTRAINT fk_a92e5e22232d562b FOREIGN KEY (object_id) REFERENCES public.seal(id) ON DELETE CASCADE;


--
-- TOC entry 5071 (class 2606 OID 18951)
-- Name: user_meta fk_ad7358fc232d562b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.user_meta
    ADD CONSTRAINT fk_ad7358fc232d562b FOREIGN KEY (object_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5066 (class 2606 OID 18956)
-- Name: subsite fk_b0f67b6f3414710b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.subsite
    ADD CONSTRAINT fk_b0f67b6f3414710b FOREIGN KEY (agent_id) REFERENCES public.agent(id);


--
-- TOC entry 5063 (class 2606 OID 18961)
-- Name: space_meta fk_bc846ebf232d562b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.space_meta
    ADD CONSTRAINT fk_bc846ebf232d562b FOREIGN KEY (object_id) REFERENCES public.space(id) ON DELETE CASCADE;


--
-- TOC entry 5036 (class 2606 OID 18966)
-- Name: notification fk_bf5476ca427eb8a5; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT fk_bf5476ca427eb8a5 FOREIGN KEY (request_id) REFERENCES public.request(id) ON DELETE CASCADE;


--
-- TOC entry 5037 (class 2606 OID 18971)
-- Name: notification fk_bf5476caa76ed395; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT fk_bf5476caa76ed395 FOREIGN KEY (user_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5032 (class 2606 OID 18976)
-- Name: event_meta fk_c839589e232d562b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_meta
    ADD CONSTRAINT fk_c839589e232d562b FOREIGN KEY (object_id) REFERENCES public.event(id) ON DELETE CASCADE;


--
-- TOC entry 5013 (class 2606 OID 18981)
-- Name: entity_revision fk_cf97a98ca76ed395; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.entity_revision
    ADD CONSTRAINT fk_cf97a98ca76ed395 FOREIGN KEY (user_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5042 (class 2606 OID 18986)
-- Name: procuration fk_d7bae7f3aeb2ed7; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.procuration
    ADD CONSTRAINT fk_d7bae7f3aeb2ed7 FOREIGN KEY (attorney_user_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5043 (class 2606 OID 18991)
-- Name: procuration fk_d7bae7fc69d3fb; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.procuration
    ADD CONSTRAINT fk_d7bae7fc69d3fb FOREIGN KEY (usr_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5017 (class 2606 OID 18996)
-- Name: evaluationmethodconfiguration_meta fk_d7edf8b2232d562b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.evaluationmethodconfiguration_meta
    ADD CONSTRAINT fk_d7edf8b2232d562b FOREIGN KEY (object_id) REFERENCES public.evaluation_method_configuration(id) ON DELETE CASCADE;


--
-- TOC entry 5006 (class 2606 OID 19001)
-- Name: event_occurrence fk_e61358dc23575340; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_occurrence
    ADD CONSTRAINT fk_e61358dc23575340 FOREIGN KEY (space_id) REFERENCES public.space(id) ON DELETE CASCADE;


--
-- TOC entry 5007 (class 2606 OID 19006)
-- Name: event_occurrence fk_e61358dc71f7e88b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.event_occurrence
    ADD CONSTRAINT fk_e61358dc71f7e88b FOREIGN KEY (event_id) REFERENCES public.event(id) ON DELETE CASCADE;


--
-- TOC entry 5068 (class 2606 OID 19011)
-- Name: term_relation fk_eddf39fde2c35fc; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.term_relation
    ADD CONSTRAINT fk_eddf39fde2c35fc FOREIGN KEY (term_id) REFERENCES public.term(id) ON DELETE CASCADE;


--
-- TOC entry 5047 (class 2606 OID 19016)
-- Name: project_meta fk_ee63dc2d232d562b; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.project_meta
    ADD CONSTRAINT fk_ee63dc2d232d562b FOREIGN KEY (object_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- TOC entry 5073 (class 2606 OID 19084)
-- Name: chat_message fk_fab3fc16727aca70; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT fk_fab3fc16727aca70 FOREIGN KEY (parent_id) REFERENCES public.chat_message(id) ON DELETE CASCADE;


--
-- TOC entry 5074 (class 2606 OID 19089)
-- Name: chat_message fk_fab3fc16a76ed395; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT fk_fab3fc16a76ed395 FOREIGN KEY (user_id) REFERENCES public.usr(id) ON DELETE CASCADE;


--
-- TOC entry 5072 (class 2606 OID 19079)
-- Name: chat_message fk_fab3fc16c47d5262; Type: FK CONSTRAINT; Schema: public; Owner: mapas
--

ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT fk_fab3fc16c47d5262 FOREIGN KEY (chat_thread_id) REFERENCES public.chat_thread(id) ON DELETE CASCADE;


-- Completed on 2024-06-04 20:51:11 UTC

--
-- PostgreSQL database dump complete
--

