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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admins (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admins_id_seq OWNED BY admins.id;


--
-- Name: applications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE applications (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE applications_id_seq OWNED BY applications.id;


--
-- Name: applications_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE applications_users (
    user_id integer NOT NULL,
    application_id integer NOT NULL
);


--
-- Name: data_queries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_queries (
    id integer NOT NULL,
    content json,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(255)
);


--
-- Name: data_queries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE data_queries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE data_queries_id_seq OWNED BY data_queries.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    queue character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    delayed_reference_id integer,
    delayed_reference_type character varying(255)
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE documents (
    id integer NOT NULL,
    name character varying(255),
    data json,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE documents_id_seq OWNED BY documents.id;


--
-- Name: log_spreadsheets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE log_spreadsheets (
    id integer NOT NULL,
    user_id integer,
    status character varying(255),
    status_msg character varying(255),
    query text,
    file text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    all_columns boolean DEFAULT false NOT NULL,
    format character varying(255) DEFAULT 'csv'::character varying NOT NULL
);


--
-- Name: log_spreadsheets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE log_spreadsheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_spreadsheets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE log_spreadsheets_id_seq OWNED BY log_spreadsheets.id;


--
-- Name: logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE logs (
    id integer NOT NULL,
    session character varying(255),
    username character varying(255),
    application character varying(255),
    activity character varying(255),
    event character varying(255),
    "time" timestamp without time zone,
    parameters hstore DEFAULT ''::hstore NOT NULL,
    extras hstore DEFAULT ''::hstore NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    event_value character varying(255)
);


--
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE logs_id_seq OWNED BY logs.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY applications ALTER COLUMN id SET DEFAULT nextval('applications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_queries ALTER COLUMN id SET DEFAULT nextval('data_queries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents ALTER COLUMN id SET DEFAULT nextval('documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY log_spreadsheets ALTER COLUMN id SET DEFAULT nextval('log_spreadsheets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY logs ALTER COLUMN id SET DEFAULT nextval('logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (id);


--
-- Name: data_queries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_queries
    ADD CONSTRAINT data_queries_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: log_spreadsheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY log_spreadsheets
    ADD CONSTRAINT log_spreadsheets_pkey PRIMARY KEY (id);


--
-- Name: logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_delayed_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_delayed_reference_id ON delayed_jobs USING btree (delayed_reference_id);


--
-- Name: delayed_jobs_delayed_reference_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_delayed_reference_type ON delayed_jobs USING btree (delayed_reference_type);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_email ON admins USING btree (email);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON admins USING btree (reset_password_token);


--
-- Name: index_data_queries_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_data_queries_on_user_id ON data_queries USING btree (user_id);


--
-- Name: index_logs_on_activity; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_logs_on_activity ON logs USING btree (activity);


--
-- Name: index_logs_on_application; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_logs_on_application ON logs USING btree (application);


--
-- Name: index_logs_on_event; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_logs_on_event ON logs USING btree (event);


--
-- Name: index_logs_on_session; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_logs_on_session ON logs USING btree (session);


--
-- Name: index_logs_on_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_logs_on_time ON logs USING btree ("time");


--
-- Name: index_logs_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_logs_on_username ON logs USING btree (username);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140522153820');

INSERT INTO schema_migrations (version) VALUES ('20140601133436');

INSERT INTO schema_migrations (version) VALUES ('20140605110342');

INSERT INTO schema_migrations (version) VALUES ('20140619075945');

INSERT INTO schema_migrations (version) VALUES ('20140621125340');

INSERT INTO schema_migrations (version) VALUES ('20140703081856');

INSERT INTO schema_migrations (version) VALUES ('20140715105340');

INSERT INTO schema_migrations (version) VALUES ('20140717073258');

INSERT INTO schema_migrations (version) VALUES ('20140717215145');

INSERT INTO schema_migrations (version) VALUES ('20140720172125');

INSERT INTO schema_migrations (version) VALUES ('20140720172231');

INSERT INTO schema_migrations (version) VALUES ('20140726115354');

INSERT INTO schema_migrations (version) VALUES ('20140730074736');

INSERT INTO schema_migrations (version) VALUES ('20140731075753');

INSERT INTO schema_migrations (version) VALUES ('20150324202456');

INSERT INTO schema_migrations (version) VALUES ('20150828095855');

INSERT INTO schema_migrations (version) VALUES ('20150828110954');

INSERT INTO schema_migrations (version) VALUES ('20150915175057');

INSERT INTO schema_migrations (version) VALUES ('20151014141155');

INSERT INTO schema_migrations (version) VALUES ('20170217185700');

