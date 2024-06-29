--
-- PostgreSQL database dump
--

-- Dumped from database version 14.11 (Ubuntu 14.11-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.11 (Ubuntu 14.11-0ubuntu0.22.04.1)

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
-- Name: kurz; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.kurz (
    id_kurz integer NOT NULL,
    delka integer NOT NULL,
    datum date NOT NULL,
    misto character varying(255) NOT NULL,
    cena numeric(8,2) NOT NULL,
    sablona_id integer DEFAULT 1 NOT NULL,
    lektor_id integer DEFAULT 1 NOT NULL,
    stav_id integer DEFAULT 1 NOT NULL,
    CONSTRAINT ch_date CHECK ((datum > CURRENT_DATE)),
    CONSTRAINT ch_kompetence CHECK (public.fn_check_kompetence(lektor_id, sablona_id))
);


ALTER TABLE public.kurz OWNER TO dev;

--
-- Name: kurz_id_kurz_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

ALTER TABLE public.kurz ALTER COLUMN id_kurz ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kurz_id_kurz_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: kurz; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.kurz (id_kurz, delka, datum, misto, cena, sablona_id, lektor_id, stav_id) FROM stdin;
3	110	2024-06-04	Zlin	20400.00	11	2	3
4	100	2024-06-04	Karlovy Vary	20100.00	9	2	1
5	100	2024-06-04	Brno	17800.00	5	2	3
6	110	2024-06-04	Brno	19300.00	9	2	1
7	140	2024-06-04	Karlovy Vary	24800.00	10	2	2
8	160	2024-06-08	Zlin	29500.00	8	3	2
9	120	2024-06-08	Brno	17300.00	4	3	3
10	130	2024-06-08	Praha	23700.00	3	3	1
11	140	2024-06-08	Karlovy Vary	22800.00	8	3	2
12	190	2024-06-08	Ostrava	25900.00	8	3	3
13	190	2024-07-20	Brno	27100.00	5	4	2
14	150	2024-07-20	Karlovy Vary	18500.00	10	4	1
15	140	2024-07-20	Karlovy Vary	29500.00	6	4	1
16	140	2024-07-20	Praha	16000.00	6	4	3
17	180	2024-05-07	Zlin	24600.00	9	5	2
18	140	2024-05-07	Brno	24900.00	3	5	1
19	140	2024-05-07	Zlin	29200.00	4	5	1
20	160	2024-05-07	Ostrava	18900.00	9	5	3
21	200	2024-05-07	Zlin	24900.00	8	5	2
22	120	2025-01-15	Praha	29000.00	9	6	2
23	170	2025-01-15	Zlin	19200.00	9	6	3
24	120	2025-01-15	Ostrava	22200.00	9	6	1
25	150	2024-06-20	Ostrava	22900.00	6	7	2
26	170	2024-06-20	Karlovy Vary	21300.00	3	7	2
27	150	2024-05-23	Ostrava	23200.00	10	8	2
28	120	2024-05-23	Zlin	16100.00	2	8	2
29	110	2024-05-23	Zlin	15600.00	10	8	2
30	190	2024-11-08	Karlovy Vary	20100.00	2	9	2
31	180	2024-11-08	Ostrava	16900.00	6	9	1
32	130	2024-10-02	Karlovy Vary	26800.00	10	10	3
33	160	2024-10-02	Zlin	19200.00	4	10	2
34	200	2024-10-02	Ostrava	23300.00	4	10	2
35	110	2024-10-02	Ostrava	21900.00	10	10	3
36	150	2024-11-25	Karlovy Vary	19200.00	8	11	1
37	150	2024-11-25	Brno	24500.00	2	11	2
38	200	2024-11-25	Karlovy Vary	15000.00	9	11	1
39	170	2024-11-25	Praha	18300.00	11	11	3
45	120	2024-09-21	Karlovy Vary	20600.00	3	13	1
46	160	2024-09-21	Karlovy Vary	18900.00	9	13	1
47	200	2024-09-21	Ostrava	19000.00	4	13	2
48	160	2024-09-21	Ostrava	21900.00	4	13	2
49	110	2024-09-21	Brno	18300.00	10	13	1
50	160	2024-09-21	Ostrava	27200.00	11	13	3
51	160	2024-12-22	Karlovy Vary	30000.00	8	14	1
52	180	2024-12-22	Praha	26700.00	8	14	2
53	130	2024-05-31	Brno	16400.00	3	15	2
54	170	2024-05-31	Ostrava	27100.00	3	15	2
55	150	2024-05-31	Ostrava	23800.00	11	15	2
56	100	2024-05-31	Karlovy Vary	15400.00	11	15	3
57	150	2024-05-31	Zlin	16600.00	3	15	2
58	100	2024-05-31	Zlin	28300.00	5	15	3
59	120	2024-12-19	Ostrava	18500.00	10	16	1
60	180	2024-12-19	Karlovy Vary	27600.00	4	16	2
61	200	2024-10-01	Ostrava	23600.00	5	17	1
62	120	2024-10-01	Zlin	25900.00	5	17	2
63	100	2024-10-01	Ostrava	25400.00	3	17	3
64	190	2024-07-05	Brno	16900.00	5	18	2
65	150	2024-07-05	Zlin	15500.00	8	18	1
66	100	2024-07-05	Praha	26100.00	5	18	2
67	170	2024-11-21	Ostrava	16500.00	4	19	1
68	160	2024-11-21	Zlin	28500.00	2	19	1
69	200	2024-11-21	Karlovy Vary	18300.00	4	19	1
70	180	2024-10-08	Zlin	25600.00	10	20	2
71	150	2024-10-08	Ostrava	22600.00	10	20	1
72	150	2024-10-08	Karlovy Vary	25900.00	10	20	3
73	180	2024-05-14	Zlin	15100.00	3	21	3
74	130	2024-05-14	Karlovy Vary	26200.00	7	21	3
76	200	2024-06-03	Praha 8	50000.00	1	2	1
77	100	2024-05-09	Praha 1	15000.00	2	1	1
78	200	2024-08-01	Praha 8	45000.00	1	1	1
40	180	2024-09-06	Zlin	22000.00	4	1	1
41	200	2024-09-06	Ostrava	17900.00	4	1	2
42	140	2024-09-06	Zlin	22300.00	8	1	3
43	140	2024-09-06	Karlovy Vary	16300.00	2	1	3
44	170	2024-09-06	Praha	29600.00	8	1	3
\.


--
-- Name: kurz_id_kurz_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.kurz_id_kurz_seq', 78, true);


--
-- Name: kurz kurz_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.kurz
    ADD CONSTRAINT kurz_pkey PRIMARY KEY (id_kurz);


--
-- Name: kurz fk_akreditace; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.kurz
    ADD CONSTRAINT fk_akreditace FOREIGN KEY (sablona_id) REFERENCES public.sablona(id_sablona) ON DELETE SET DEFAULT;


--
-- Name: kurz fk_lektor; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.kurz
    ADD CONSTRAINT fk_lektor FOREIGN KEY (lektor_id) REFERENCES public.lektor(id_lektor) ON DELETE SET DEFAULT;


--
-- Name: kurz fk_stav; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.kurz
    ADD CONSTRAINT fk_stav FOREIGN KEY (stav_id) REFERENCES public.stav_k(id_stav) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

