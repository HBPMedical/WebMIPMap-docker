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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: mipmapuser; Type: TABLE; Schema: public; Owner: webmipmap; Tablespace: 
--

CREATE TABLE mipmapuser (
    id serial NOT NULL,
    username text,
    role text,
    score double precision,
    mappings_accepted integer,
    mappings_total integer
);


ALTER TABLE public.mipmapuser OWNER TO webmipmap;

--
-- Name: user_user; Type: TABLE; Schema: public; Owner: webmipmap; Tablespace: 
--

CREATE TABLE user_user (
    "userA" integer NOT NULL,
    "userB" integer NOT NULL,
    status integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_user OWNER TO webmipmap;

--
-- Data for Name: mipmapuser; Type: TABLE DATA; Schema: public; Owner: webmipmap
--

COPY mipmapuser (id, username, role, score, mappings_accepted, mappings_total) FROM stdin;
3	simpleUserB	user	20	1	5
4	adminUser	admin	44.4444444444444429	4	9
5	Ioannis Xarchakos	admin	51.1000000000000014	8	10
1	Giannis Kazadeis	admin	2.54901960784313708	26	1020
2	simpleUser	user	90	18	20
\.


--
-- Data for Name: user_user; Type: TABLE DATA; Schema: public; Owner: webmipmap
--

COPY user_user ("userA", "userB", status) FROM stdin;
1	5	1
4	5	1
5	4	1
5	2	0
\.


--
-- Name: id_pk; Type: CONSTRAINT; Schema: public; Owner: webmipmap; Tablespace: 
--

ALTER TABLE ONLY mipmapuser
    ADD CONSTRAINT id_pk PRIMARY KEY (id);


--
-- Name: user_user_pkey; Type: CONSTRAINT; Schema: public; Owner: webmipmap; Tablespace: 
--

ALTER TABLE ONLY user_user
    ADD CONSTRAINT user_user_pkey PRIMARY KEY ("userA", "userB");


--
-- Name: userAFK; Type: FK CONSTRAINT; Schema: public; Owner: webmipmap
--

ALTER TABLE ONLY user_user
    ADD CONSTRAINT "userAFK" FOREIGN KEY ("userA") REFERENCES mipmapuser(id);


--
-- Name: userBFK; Type: FK CONSTRAINT; Schema: public; Owner: webmipmap
--

ALTER TABLE ONLY user_user
    ADD CONSTRAINT "userBFK" FOREIGN KEY ("userB") REFERENCES mipmapuser(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: mipmapuser; Type: ACL; Schema: public; Owner: webmipmap
--

REVOKE ALL ON TABLE mipmapuser FROM PUBLIC;
REVOKE ALL ON TABLE mipmapuser FROM webmipmap;
GRANT ALL ON TABLE mipmapuser TO webmipmap;
GRANT ALL ON TABLE mipmapuser TO postgres;


--
-- Name: user_user; Type: ACL; Schema: public; Owner: webmipmap
--

REVOKE ALL ON TABLE user_user FROM PUBLIC;
REVOKE ALL ON TABLE user_user FROM webmipmap;
GRANT ALL ON TABLE user_user TO webmipmap;
GRANT ALL ON TABLE user_user TO postgres;


--
-- PostgreSQL database dump complete
--

