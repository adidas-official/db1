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
-- Name: osoba; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.osoba (
    id_osoba integer NOT NULL,
    jmeno character varying(255) NOT NULL,
    vede_projekt integer
);


ALTER TABLE public.osoba OWNER TO dev;

--
-- Name: osoba_id_osoba_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

ALTER TABLE public.osoba ALTER COLUMN id_osoba ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.osoba_id_osoba_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: projekt; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.projekt (
    id_proj integer NOT NULL,
    nazev_proj character varying(64) NOT NULL,
    utv_id integer
);


ALTER TABLE public.projekt OWNER TO dev;

--
-- Name: projekt_id_proj_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

ALTER TABLE public.projekt ALTER COLUMN id_proj ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.projekt_id_proj_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: resi; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.resi (
    osoba_id integer NOT NULL,
    projekt_id integer NOT NULL
);


ALTER TABLE public.resi OWNER TO dev;

--
-- Name: utvar; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.utvar (
    id_utv integer NOT NULL,
    nazev character varying(64) NOT NULL
);


ALTER TABLE public.utvar OWNER TO dev;

--
-- Name: utvar_id_utv_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

ALTER TABLE public.utvar ALTER COLUMN id_utv ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.utvar_id_utv_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: osoba; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.osoba (id_osoba, jmeno, vede_projekt) FROM stdin;
1	destruktor	\N
2	terminator	\N
3	catalyst	\N
4	leviathan	\N
5	balthazaar	\N
\.


--
-- Data for Name: projekt; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.projekt (id_proj, nazev_proj, utv_id) FROM stdin;
2	world domination	9
3	cure	7
4	peace	7
5	terror	10
\.


--
-- Data for Name: resi; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.resi (osoba_id, projekt_id) FROM stdin;
\.


--
-- Data for Name: utvar; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.utvar (id_utv, nazev) FROM stdin;
7	love
8	truth
9	punishment
10	hate
\.


--
-- Name: osoba_id_osoba_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.osoba_id_osoba_seq', 10, true);


--
-- Name: projekt_id_proj_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.projekt_id_proj_seq', 5, true);


--
-- Name: utvar_id_utv_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.utvar_id_utv_seq', 10, true);


--
-- Name: osoba osoba_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.osoba
    ADD CONSTRAINT osoba_pkey PRIMARY KEY (id_osoba);


--
-- Name: projekt projekt_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.projekt
    ADD CONSTRAINT projekt_pkey PRIMARY KEY (id_proj);


--
-- Name: resi resi_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.resi
    ADD CONSTRAINT resi_pkey PRIMARY KEY (osoba_id, projekt_id);


--
-- Name: utvar utvar_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.utvar
    ADD CONSTRAINT utvar_pkey PRIMARY KEY (id_utv);


--
-- Name: resi fk_osoba; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.resi
    ADD CONSTRAINT fk_osoba FOREIGN KEY (osoba_id) REFERENCES public.osoba(id_osoba);


--
-- Name: resi fk_projekt; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.resi
    ADD CONSTRAINT fk_projekt FOREIGN KEY (projekt_id) REFERENCES public.projekt(id_proj);


--
-- Name: osoba fk_projekt; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.osoba
    ADD CONSTRAINT fk_projekt FOREIGN KEY (vede_projekt) REFERENCES public.projekt(id_proj);


--
-- Name: projekt fk_utv; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.projekt
    ADD CONSTRAINT fk_utv FOREIGN KEY (utv_id) REFERENCES public.utvar(id_utv);


--
-- PostgreSQL database dump complete
--

