--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE TABLE countries (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    iid integer NOT NULL,
    country_code text NOT NULL,
    country_name text,
    iso_numeric integer NOT NULL,
    iso_alpha3 text NOT NULL,
    fips_code text,
    continent text NOT NULL,
    continent_name text,
    capital text,
    area_in_sq_km double precision,
    population integer,
    currency_code text NOT NULL,
    languages text[],
    geoname_id integer,
    west double precision,
    north double precision,
    east double precision,
    south double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.countries OWNER TO mvilrokx;

--
-- Name: countries_iid_seq; Type: SEQUENCE; Schema: public; Owner: mvilrokx
--

CREATE SEQUENCE countries_iid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.countries_iid_seq OWNER TO mvilrokx;

--
-- Name: countries_iid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mvilrokx
--

ALTER SEQUENCE countries_iid_seq OWNED BY countries.iid;


--
-- Name: fixtures; Type: TABLE; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE TABLE fixtures (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    iid integer NOT NULL,
    home_tournament_participant_id uuid,
    away_tournament_participant_id uuid,
    kickoff timestamp with time zone,
    venue text,
    result json,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.fixtures OWNER TO mvilrokx;

--
-- Name: fixtures_iid_seq; Type: SEQUENCE; Schema: public; Owner: mvilrokx
--

CREATE SEQUENCE fixtures_iid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fixtures_iid_seq OWNER TO mvilrokx;

--
-- Name: fixtures_iid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mvilrokx
--

ALTER SEQUENCE fixtures_iid_seq OWNED BY fixtures.iid;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE TABLE groups (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    iid integer NOT NULL,
    name text,
    tournament_id uuid,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.groups OWNER TO mvilrokx;

--
-- Name: groups_iid_seq; Type: SEQUENCE; Schema: public; Owner: mvilrokx
--

CREATE SEQUENCE groups_iid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_iid_seq OWNER TO mvilrokx;

--
-- Name: groups_iid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mvilrokx
--

ALTER SEQUENCE groups_iid_seq OWNED BY groups.iid;


--
-- Name: picks; Type: TABLE; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE TABLE picks (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    iid integer NOT NULL,
    team_id uuid,
    tournament_participant_id uuid,
    tenant_id uuid,
    "position" integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.picks OWNER TO mvilrokx;

--
-- Name: picks_iid_seq; Type: SEQUENCE; Schema: public; Owner: mvilrokx
--

CREATE SEQUENCE picks_iid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.picks_iid_seq OWNER TO mvilrokx;

--
-- Name: picks_iid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mvilrokx
--

ALTER SEQUENCE picks_iid_seq OWNED BY picks.iid;


--
-- Name: schema_info; Type: TABLE; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE TABLE schema_info (
    version integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.schema_info OWNER TO mvilrokx;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE TABLE teams (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    iid integer NOT NULL,
    name text,
    user_id uuid,
    tournament_id uuid,
    tenant_id uuid,
    paid boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.teams OWNER TO mvilrokx;

--
-- Name: teams_iid_seq; Type: SEQUENCE; Schema: public; Owner: mvilrokx
--

CREATE SEQUENCE teams_iid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_iid_seq OWNER TO mvilrokx;

--
-- Name: teams_iid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mvilrokx
--

ALTER SEQUENCE teams_iid_seq OWNED BY teams.iid;


--
-- Name: tenants; Type: TABLE; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE TABLE tenants (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    iid integer NOT NULL,
    name text,
    subdomain text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.tenants OWNER TO mvilrokx;

--
-- Name: tenants_iid_seq; Type: SEQUENCE; Schema: public; Owner: mvilrokx
--

CREATE SEQUENCE tenants_iid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tenants_iid_seq OWNER TO mvilrokx;

--
-- Name: tenants_iid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mvilrokx
--

ALTER SEQUENCE tenants_iid_seq OWNED BY tenants.iid;


--
-- Name: tournament_participants; Type: TABLE; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE TABLE tournament_participants (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    iid integer NOT NULL,
    group_id uuid,
    country_id uuid,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.tournament_participants OWNER TO mvilrokx;

--
-- Name: tournament_participants_iid_seq; Type: SEQUENCE; Schema: public; Owner: mvilrokx
--

CREATE SEQUENCE tournament_participants_iid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tournament_participants_iid_seq OWNER TO mvilrokx;

--
-- Name: tournament_participants_iid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mvilrokx
--

ALTER SEQUENCE tournament_participants_iid_seq OWNED BY tournament_participants.iid;


--
-- Name: tournaments; Type: TABLE; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE TABLE tournaments (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    iid integer NOT NULL,
    name text,
    description text,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    host_countries text[],
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.tournaments OWNER TO mvilrokx;

--
-- Name: tournaments_iid_seq; Type: SEQUENCE; Schema: public; Owner: mvilrokx
--

CREATE SEQUENCE tournaments_iid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tournaments_iid_seq OWNER TO mvilrokx;

--
-- Name: tournaments_iid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mvilrokx
--

ALTER SEQUENCE tournaments_iid_seq OWNED BY tournaments.iid;


--
-- Name: users; Type: TABLE; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE TABLE users (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    iid integer NOT NULL,
    uid text,
    provider text,
    handle text,
    about text,
    email text,
    url text,
    twitter text,
    karma integer DEFAULT 0,
    name text,
    auth json,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    admin boolean DEFAULT false,
    registered boolean,
    tenant_id uuid,
    invites_count integer DEFAULT 0,
    github text,
    secret text,
    manifesto boolean DEFAULT false
);


ALTER TABLE public.users OWNER TO mvilrokx;

--
-- Name: users_iid_seq; Type: SEQUENCE; Schema: public; Owner: mvilrokx
--

CREATE SEQUENCE users_iid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_iid_seq OWNER TO mvilrokx;

--
-- Name: users_iid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mvilrokx
--

ALTER SEQUENCE users_iid_seq OWNED BY users.iid;


--
-- Name: iid; Type: DEFAULT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY countries ALTER COLUMN iid SET DEFAULT nextval('countries_iid_seq'::regclass);


--
-- Name: iid; Type: DEFAULT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY fixtures ALTER COLUMN iid SET DEFAULT nextval('fixtures_iid_seq'::regclass);


--
-- Name: iid; Type: DEFAULT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY groups ALTER COLUMN iid SET DEFAULT nextval('groups_iid_seq'::regclass);


--
-- Name: iid; Type: DEFAULT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY picks ALTER COLUMN iid SET DEFAULT nextval('picks_iid_seq'::regclass);


--
-- Name: iid; Type: DEFAULT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY teams ALTER COLUMN iid SET DEFAULT nextval('teams_iid_seq'::regclass);


--
-- Name: iid; Type: DEFAULT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY tenants ALTER COLUMN iid SET DEFAULT nextval('tenants_iid_seq'::regclass);


--
-- Name: iid; Type: DEFAULT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY tournament_participants ALTER COLUMN iid SET DEFAULT nextval('tournament_participants_iid_seq'::regclass);


--
-- Name: iid; Type: DEFAULT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY tournaments ALTER COLUMN iid SET DEFAULT nextval('tournaments_iid_seq'::regclass);


--
-- Name: iid; Type: DEFAULT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY users ALTER COLUMN iid SET DEFAULT nextval('users_iid_seq'::regclass);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: mvilrokx; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: fixtures_pkey; Type: CONSTRAINT; Schema: public; Owner: mvilrokx; Tablespace: 
--

ALTER TABLE ONLY fixtures
    ADD CONSTRAINT fixtures_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: mvilrokx; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: picks_pkey; Type: CONSTRAINT; Schema: public; Owner: mvilrokx; Tablespace: 
--

ALTER TABLE ONLY picks
    ADD CONSTRAINT picks_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: mvilrokx; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: mvilrokx; Tablespace: 
--

ALTER TABLE ONLY tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: tournament_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: mvilrokx; Tablespace: 
--

ALTER TABLE ONLY tournament_participants
    ADD CONSTRAINT tournament_participants_pkey PRIMARY KEY (id);


--
-- Name: tournaments_pkey; Type: CONSTRAINT; Schema: public; Owner: mvilrokx; Tablespace: 
--

ALTER TABLE ONLY tournaments
    ADD CONSTRAINT tournaments_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: mvilrokx; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: countries_country_code_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX countries_country_code_index ON countries USING btree (country_code);


--
-- Name: countries_iid_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX countries_iid_index ON countries USING btree (iid);


--
-- Name: countries_iso_alpha3_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX countries_iso_alpha3_index ON countries USING btree (iso_alpha3);


--
-- Name: countries_iso_numeric_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX countries_iso_numeric_index ON countries USING btree (iso_numeric);


--
-- Name: fixtures_home_tournament_participant_id_away_tournament_partici; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX fixtures_home_tournament_participant_id_away_tournament_partici ON fixtures USING btree (home_tournament_participant_id, away_tournament_participant_id);


--
-- Name: fixtures_iid_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX fixtures_iid_index ON fixtures USING btree (iid);


--
-- Name: groups_iid_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX groups_iid_index ON groups USING btree (iid);


--
-- Name: groups_tournament_id_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE INDEX groups_tournament_id_index ON groups USING btree (tournament_id);


--
-- Name: picks_iid_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX picks_iid_index ON picks USING btree (iid);


--
-- Name: picks_team_id_tournament_participant_id_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX picks_team_id_tournament_participant_id_index ON picks USING btree (team_id, tournament_participant_id);


--
-- Name: teams_iid_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX teams_iid_index ON teams USING btree (iid);


--
-- Name: tenants_iid_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX tenants_iid_index ON tenants USING btree (iid);


--
-- Name: tenants_name_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX tenants_name_index ON tenants USING btree (name);


--
-- Name: tenants_subdomain_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX tenants_subdomain_index ON tenants USING btree (subdomain);


--
-- Name: tournament_participants_group_id_country_id_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX tournament_participants_group_id_country_id_index ON tournament_participants USING btree (group_id, country_id);


--
-- Name: tournament_participants_iid_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX tournament_participants_iid_index ON tournament_participants USING btree (iid);


--
-- Name: tournaments_iid_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX tournaments_iid_index ON tournaments USING btree (iid);


--
-- Name: tournaments_name_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX tournaments_name_index ON tournaments USING btree (name);


--
-- Name: users_handle_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE INDEX users_handle_index ON users USING btree (handle);


--
-- Name: users_iid_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX users_iid_index ON users USING btree (iid);


--
-- Name: users_uid_index; Type: INDEX; Schema: public; Owner: mvilrokx; Tablespace: 
--

CREATE UNIQUE INDEX users_uid_index ON users USING btree (uid);


--
-- Name: fixtures_away_tournament_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY fixtures
    ADD CONSTRAINT fixtures_away_tournament_participant_id_fkey FOREIGN KEY (away_tournament_participant_id) REFERENCES tournament_participants(id) ON DELETE CASCADE;


--
-- Name: fixtures_home_tournament_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY fixtures
    ADD CONSTRAINT fixtures_home_tournament_participant_id_fkey FOREIGN KEY (home_tournament_participant_id) REFERENCES tournament_participants(id) ON DELETE CASCADE;


--
-- Name: groups_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES tournaments(id) ON DELETE CASCADE;


--
-- Name: picks_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY picks
    ADD CONSTRAINT picks_team_id_fkey FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE;


--
-- Name: picks_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY picks
    ADD CONSTRAINT picks_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE;


--
-- Name: picks_tournament_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY picks
    ADD CONSTRAINT picks_tournament_participant_id_fkey FOREIGN KEY (tournament_participant_id) REFERENCES tournament_participants(id) ON DELETE CASCADE;


--
-- Name: teams_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE;


--
-- Name: teams_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES tournaments(id) ON DELETE CASCADE;


--
-- Name: teams_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: tournament_participants_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY tournament_participants
    ADD CONSTRAINT tournament_participants_country_id_fkey FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE;


--
-- Name: tournament_participants_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY tournament_participants
    ADD CONSTRAINT tournament_participants_group_id_fkey FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE;


--
-- Name: users_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mvilrokx
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: mvilrokx
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM mvilrokx;
GRANT ALL ON SCHEMA public TO mvilrokx;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

