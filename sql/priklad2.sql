--
-- PostgreSQL database dump
--

-- Dumped from database version 14.12 (Ubuntu 14.12-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.12 (Ubuntu 14.12-0ubuntu0.22.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: zamestnec; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.zamestnec (
    c_zam integer NOT NULL,
    jmeno character varying(100) NOT NULL,
    vede integer,
    CONSTRAINT zamestnec_check CHECK ((vede <> c_zam))
);


ALTER TABLE public.zamestnec OWNER TO dev;

--
-- Name: zamestnec_c_zam_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.zamestnec_c_zam_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.zamestnec_c_zam_seq OWNER TO dev;

--
-- Name: zamestnec_c_zam_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.zamestnec_c_zam_seq OWNED BY public.zamestnec.c_zam;


--
-- Name: zamestnec c_zam; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.zamestnec ALTER COLUMN c_zam SET DEFAULT nextval('public.zamestnec_c_zam_seq'::regclass);


--
-- Data for Name: zamestnec; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.zamestnec (c_zam, jmeno, vede) FROM stdin;
1	pepa	\N
3	tonda	1
5	matej	3
6	zuzka	\N
8	lenka	6
\.


--
-- Name: zamestnec_c_zam_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.zamestnec_c_zam_seq', 8, true);


--
-- Name: zamestnec zamestnec_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.zamestnec
    ADD CONSTRAINT zamestnec_pkey PRIMARY KEY (c_zam);


--
-- PostgreSQL database dump complete
--

