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

--
-- Name: fn_check_kompetence(integer, integer); Type: FUNCTION; Schema: public; Owner: dev
--

CREATE FUNCTION public.fn_check_kompetence(fn_lektor_id integer, fn_sablona_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM kompetence
        JOIN lektor ON fn_lektor_id = lektor.id_lektor
        JOIN sablona ON fn_sablona_id = sablona.id_sablona
        WHERE fn_lektor_id = lektor.id_lektor
        AND fn_sablona_id = sablona.id_sablona
    );
END;
$$;


ALTER FUNCTION public.fn_check_kompetence(fn_lektor_id integer, fn_sablona_id integer) OWNER TO dev;

--
-- Name: fn_kurz_started(integer); Type: FUNCTION; Schema: public; Owner: dev
--

CREATE FUNCTION public.fn_kurz_started(fn_kurz_id integer) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
    kurz_date DATE;
BEGIN
    SELECT datum INTO kurz_date FROM kurz
    WHERE fn_kurz_id = id_kurz;
    RETURN kurz_date;
END
$$;


ALTER FUNCTION public.fn_kurz_started(fn_kurz_id integer) OWNER TO dev;

--
-- Name: fn_reserved(integer, integer); Type: FUNCTION; Schema: public; Owner: dev
--

CREATE FUNCTION public.fn_reserved(var_kurz_id integer, var_zajemce_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM rezervace
        WHERE zajemce_id = var_zajemce_id
        AND var_kurz_id = var_kurz_id
    );
END
$$;


ALTER FUNCTION public.fn_reserved(var_kurz_id integer, var_zajemce_id integer) OWNER TO dev;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: kompetence; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.kompetence (
    lektor_id integer NOT NULL,
    sablona_id integer NOT NULL
);


ALTER TABLE public.kompetence OWNER TO dev;

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
-- Name: lektor; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.lektor (
    id_lektor integer NOT NULL,
    jmeno character varying(255) NOT NULL,
    prijmeni character varying(255) NOT NULL,
    adresa character varying(255) NOT NULL
);


ALTER TABLE public.lektor OWNER TO dev;

--
-- Name: lektor_id_lektor_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

ALTER TABLE public.lektor ALTER COLUMN id_lektor ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.lektor_id_lektor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rezervace; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.rezervace (
    zajemce_id integer NOT NULL,
    sablona_id integer NOT NULL,
    datum date DEFAULT CURRENT_DATE
);


ALTER TABLE public.rezervace OWNER TO dev;

--
-- Name: sablona; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.sablona (
    id_sablona integer NOT NULL,
    nazev character varying(255) NOT NULL
);


ALTER TABLE public.sablona OWNER TO dev;

--
-- Name: sablona_id_sablona_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

ALTER TABLE public.sablona ALTER COLUMN id_sablona ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sablona_id_sablona_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stav_k; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.stav_k (
    id_stav integer NOT NULL,
    popis character varying(255) NOT NULL
);


ALTER TABLE public.stav_k OWNER TO dev;

--
-- Name: stav_k_id_stav_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

ALTER TABLE public.stav_k ALTER COLUMN id_stav ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.stav_k_id_stav_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ucast; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.ucast (
    kurz_id integer NOT NULL,
    zajemce_id integer NOT NULL,
    certifikat character varying(255) NOT NULL,
    uhrada date NOT NULL,
    CONSTRAINT ch_paid CHECK ((uhrada < public.fn_kurz_started(kurz_id))),
    CONSTRAINT ch_reserved CHECK (public.fn_reserved(kurz_id, zajemce_id))
);


ALTER TABLE public.ucast OWNER TO dev;

--
-- Name: zajemce; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.zajemce (
    id_zajemce integer NOT NULL,
    jmeno character varying(255) NOT NULL,
    prijmeni character varying(255) NOT NULL,
    adresa character varying(255) NOT NULL
);


ALTER TABLE public.zajemce OWNER TO dev;

--
-- Name: zajemce_id_zajemce_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

ALTER TABLE public.zajemce ALTER COLUMN id_zajemce ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.zajemce_id_zajemce_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: kompetence; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.kompetence (lektor_id, sablona_id) FROM stdin;
2	5
2	2
2	10
2	7
2	9
2	11
3	8
3	4
3	6
3	5
3	3
3	9
4	10
4	11
4	5
4	6
4	3
4	8
5	3
5	9
5	8
5	4
6	4
6	9
7	3
7	6
8	2
8	10
9	3
9	2
9	6
9	7
10	4
10	10
10	6
11	9
11	8
11	11
11	2
13	7
13	10
13	3
13	11
13	4
13	9
14	8
14	2
15	7
15	4
15	3
15	5
15	11
15	10
16	10
16	4
17	5
17	3
18	2
18	5
18	8
19	2
19	9
19	4
19	10
20	5
20	10
21	7
21	3
\.


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
-- Data for Name: lektor; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.lektor (id_lektor, jmeno, prijmeni, adresa) FROM stdin;
1	bude	upresneno	-
2	Anna	Koudelka	U Silnice 2/332 406 36 Hradec Králové
3	Klára	Berková	Otavova Olomoucký kraj 143 37 Frýdek-Místek
4	Jitka	Slavík	N. A. Někrasova 430 50 Tábor
5	Vlasta	Ečerová	U Silnice 9/413 719 38 Kroměříž
6	Eva	Kučera	Kukelská 65670 Uherské Hradiště
7	Stanislav	Matoušek	Za Pekárnou 75 676 57 Frýdek-Místek Česká republika
8	Anežka	Polcrová	Nad Klikovkou 287 29 Sokolov
9	Ludmila	Černíková	N. A. Někrasova 430 50 Tábor
10	Danuše	Lorenzová	Kukelská 65670 Uherské Hradiště
11	Barbora	Linková	Radbuzská 8 70129 Kolín
13	Zdeňka	Polcrová	Rozkošného 9 06003 Děčín
14	Ilona	Hůlková	Rozkošného 9 06003 Děčín
15	Vladislav	Černíková	Za Pekárnou 75 676 57 Frýdek-Místek Česká republika
16	Šárka	Meyerová	Za Pekárnou 75 676 57 Frýdek-Místek Česká republika
17	Lenka	Vrba	Rozkošného 9 06003 Děčín
18	Renata	Žák	Hrachovská 82 Karlovarský kraj 91899 Děčín
19	Zdeněk	Nesslerová	U Silnice 2/332 406 36 Hradec Králové
20	Filip	Bezděkovská	U Kamýku 7/95 Jihomoravský kraj 95727 Jihlava
21	Renata	Matoušek	Školní 17/31 Karlovarský kraj 381 58 Prostějov
22	Zlata	Šilar	Pohledná Jihomoravský kraj 29446 Ústí nad Labem
\.


--
-- Data for Name: rezervace; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.rezervace (zajemce_id, sablona_id, datum) FROM stdin;
50	7	2024-04-21
50	8	2024-04-21
50	4	2024-04-21
28	3	2024-04-21
28	2	2024-04-21
28	11	2024-04-21
78	8	2024-04-21
78	5	2024-04-21
78	2	2024-04-21
78	3	2024-04-21
15	6	2024-04-21
15	3	2024-04-21
15	7	2024-04-21
119	9	2024-04-21
119	11	2024-04-21
119	5	2024-04-21
102	7	2024-04-21
102	9	2024-04-21
140	3	2024-04-21
5	9	2024-04-21
5	11	2024-04-21
5	7	2024-04-21
118	8	2024-04-21
118	4	2024-04-21
45	6	2024-04-21
45	10	2024-04-21
81	5	2024-04-21
7	8	2024-04-21
7	2	2024-04-21
7	10	2024-04-21
36	8	2024-04-21
36	9	2024-04-21
36	11	2024-04-21
159	7	2024-04-21
144	4	2024-04-21
144	9	2024-04-21
144	10	2024-04-21
144	6	2024-04-21
108	6	2024-04-21
172	9	2024-04-21
172	11	2024-04-21
104	5	2024-04-21
104	10	2024-04-21
104	3	2024-04-21
55	7	2024-04-21
155	2	2024-04-21
124	2	2024-04-21
124	8	2024-04-21
69	8	2024-04-21
69	3	2024-04-21
69	10	2024-04-21
69	2	2024-04-21
79	9	2024-04-21
79	5	2024-04-21
123	11	2024-04-21
123	5	2024-04-21
111	6	2024-04-21
111	2	2024-04-21
111	8	2024-04-21
111	11	2024-04-21
134	6	2024-04-21
134	9	2024-04-21
145	11	2024-04-21
106	11	2024-04-21
133	11	2024-04-21
133	9	2024-04-21
133	10	2024-04-21
191	5	2024-04-21
191	6	2024-04-21
191	9	2024-04-21
191	3	2024-04-21
112	9	2024-04-21
112	5	2024-04-21
179	8	2024-04-21
179	9	2024-04-21
179	2	2024-04-21
179	11	2024-04-21
127	9	2024-04-21
127	6	2024-04-21
135	7	2024-04-21
88	8	2024-04-21
88	3	2024-04-21
59	7	2024-04-21
59	2	2024-04-21
59	4	2024-04-21
59	9	2024-04-21
113	3	2024-04-21
113	11	2024-04-21
157	10	2024-04-21
157	3	2024-04-21
115	8	2024-04-21
115	7	2024-04-21
82	5	2024-04-21
82	9	2024-04-21
188	7	2024-04-21
188	10	2024-04-21
188	11	2024-04-21
188	8	2024-04-21
92	4	2024-04-21
92	7	2024-04-21
92	2	2024-04-21
92	11	2024-04-21
1	3	2024-04-21
1	7	2024-04-21
1	9	2024-04-21
72	7	2024-04-21
72	5	2024-04-21
72	6	2024-04-21
72	4	2024-04-21
177	6	2024-04-21
121	5	2024-04-21
19	10	2024-04-21
19	2	2024-04-21
75	10	2024-04-21
75	7	2024-04-21
75	6	2024-04-21
110	2	2024-04-21
110	3	2024-04-21
110	8	2024-04-21
93	3	2024-04-21
93	8	2024-04-21
93	6	2024-04-21
10	2	2024-04-21
10	7	2024-04-21
10	6	2024-04-21
152	2	2024-04-21
84	10	2024-04-21
84	7	2024-04-21
84	11	2024-04-21
84	9	2024-04-21
62	7	2024-04-21
62	5	2024-04-21
62	9	2024-04-21
62	8	2024-04-21
20	6	2024-04-21
20	11	2024-04-21
20	8	2024-04-21
20	5	2024-04-21
103	8	2024-04-21
24	10	2024-04-21
24	9	2024-04-21
56	7	2024-04-21
56	3	2024-04-21
56	10	2024-04-21
64	2	2024-04-21
64	8	2024-04-21
64	10	2024-04-21
64	9	2024-04-21
185	4	2024-04-21
185	7	2024-04-21
185	5	2024-04-21
35	3	2024-04-21
182	3	2024-04-21
182	7	2024-04-21
182	4	2024-04-21
182	5	2024-04-21
148	9	2024-04-21
148	6	2024-04-21
184	5	2024-04-21
184	8	2024-04-21
184	4	2024-04-21
37	4	2024-04-21
37	8	2024-04-21
139	2	2024-04-21
165	5	2024-04-21
165	10	2024-04-21
165	11	2024-04-21
138	4	2024-04-21
138	11	2024-04-21
163	6	2024-04-21
163	8	2024-04-21
163	4	2024-04-21
163	9	2024-04-21
18	3	2024-04-21
18	4	2024-04-21
18	11	2024-04-21
71	8	2024-04-21
71	2	2024-04-21
71	10	2024-04-21
30	3	2024-04-21
27	3	2024-04-21
27	4	2024-04-21
27	2	2024-04-21
27	9	2024-04-21
141	11	2024-04-21
141	7	2024-04-21
141	6	2024-04-21
173	3	2024-04-21
173	6	2024-04-21
173	5	2024-04-21
90	2	2024-04-21
68	11	2024-04-21
68	7	2024-04-21
68	3	2024-04-21
21	9	2024-04-21
21	4	2024-04-21
21	6	2024-04-21
21	8	2024-04-21
86	8	2024-04-21
94	6	2024-04-21
94	3	2024-04-21
94	8	2024-04-21
128	4	2024-04-21
128	5	2024-04-21
128	3	2024-04-21
43	11	2024-04-21
117	10	2024-04-21
89	11	2024-04-21
89	10	2024-04-21
89	8	2024-04-21
89	9	2024-04-21
199	8	2024-04-21
199	10	2024-04-21
199	5	2024-04-21
131	11	2024-04-21
131	8	2024-04-21
131	9	2024-04-21
131	4	2024-04-21
150	3	2024-04-21
150	10	2024-04-21
150	4	2024-04-21
150	8	2024-04-21
49	3	2024-04-21
49	11	2024-04-21
174	4	2024-04-21
160	8	2024-04-21
160	3	2024-04-21
60	9	2024-04-21
114	2	2024-04-21
130	4	2024-04-21
130	2	2024-04-21
130	10	2024-04-21
130	8	2024-04-21
74	6	2024-04-21
74	10	2024-04-21
74	2	2024-04-21
74	9	2024-04-21
85	10	2024-04-21
85	2	2024-04-21
85	9	2024-04-21
85	11	2024-04-21
122	10	2024-04-21
122	8	2024-04-21
196	2	2024-04-21
196	9	2024-04-21
196	6	2024-04-21
12	4	2024-04-21
12	8	2024-04-21
12	10	2024-04-21
12	3	2024-04-21
100	11	2024-04-21
100	7	2024-04-21
100	3	2024-04-21
100	5	2024-04-21
197	11	2024-04-21
197	9	2024-04-21
197	3	2024-04-21
\.


--
-- Data for Name: sablona; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.sablona (id_sablona, nazev) FROM stdin;
1	Bude upresneno
2	html
3	css
4	php
5	javascript
6	python
7	c++
8	sql
9	TCP/IP
10	social networks
11	photo editing
12	animation
\.


--
-- Data for Name: stav_k; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.stav_k (id_stav, popis) FROM stdin;
1	pripravovano
2	realizovano
3	zruseno
\.


--
-- Data for Name: ucast; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.ucast (kurz_id, zajemce_id, certifikat, uhrada) FROM stdin;
62	182	2024-10-01-certifikat.pdf	2024-09-14
4	64	2024-06-04-certifikat.pdf	2024-05-13
71	74	2024-10-08-certifikat.pdf	2024-09-09
24	112	2025-01-15-certifikat.pdf	2025-01-06
53	56	2024-05-31-certifikat.pdf	2024-05-06
66	182	2024-07-05-certifikat.pdf	2024-06-18
10	88	2024-06-08-certifikat.pdf	2024-05-27
23	59	2025-01-15-certifikat.pdf	2024-12-29
10	78	2024-06-08-certifikat.pdf	2024-05-10
68	139	2024-11-21-certifikat.pdf	2024-10-27
67	144	2024-11-21-certifikat.pdf	2024-10-26
12	12	2024-06-08-certifikat.pdf	2024-06-01
65	62	2024-07-05-certifikat.pdf	2024-06-13
66	191	2024-07-05-certifikat.pdf	2024-06-23
7	133	2024-06-04-certifikat.pdf	2024-05-22
12	188	2024-06-08-certifikat.pdf	2024-05-29
54	94	2024-05-31-certifikat.pdf	2024-05-16
26	128	2024-06-20-certifikat.pdf	2024-06-04
37	90	2024-11-25-certifikat.pdf	2024-11-11
77	69	2024-05-09-certifikat.pdf	2024-04-22
65	199	2024-07-05-certifikat.pdf	2024-06-11
20	196	2024-05-07-certifikat.pdf	2024-04-09
39	43	2024-11-25-certifikat.pdf	2024-11-07
19	128	2024-05-07-certifikat.pdf	2024-04-08
36	179	2024-11-25-certifikat.pdf	2024-11-13
68	27	2024-11-21-certifikat.pdf	2024-11-14
4	1	2024-06-04-certifikat.pdf	2024-05-26
58	104	2024-05-31-certifikat.pdf	2024-05-21
23	148	2025-01-15-certifikat.pdf	2025-01-10
43	69	2024-09-06-certifikat.pdf	2024-08-25
62	123	2024-10-01-certifikat.pdf	2024-09-26
44	93	2024-09-06-certifikat.pdf	2024-08-18
22	59	2025-01-15-certifikat.pdf	2025-01-03
22	191	2025-01-15-certifikat.pdf	2024-12-31
70	133	2024-10-08-certifikat.pdf	2024-09-20
12	118	2024-06-08-certifikat.pdf	2024-05-14
4	134	2024-06-04-certifikat.pdf	2024-05-10
6	172	2024-06-04-certifikat.pdf	2024-05-11
21	20	2024-05-07-certifikat.pdf	2024-04-10
45	35	2024-09-21-certifikat.pdf	2024-08-28
22	163	2025-01-15-certifikat.pdf	2025-01-01
37	78	2024-11-25-certifikat.pdf	2024-11-19
16	141	2024-07-20-certifikat.pdf	2024-06-24
5	121	2024-06-04-certifikat.pdf	2024-05-29
50	119	2024-09-21-certifikat.pdf	2024-09-16
13	72	2024-07-20-certifikat.pdf	2024-07-12
23	27	2025-01-15-certifikat.pdf	2024-12-31
39	28	2024-11-25-certifikat.pdf	2024-11-17
49	199	2024-09-21-certifikat.pdf	2024-09-16
3	138	2024-06-04-certifikat.pdf	2024-05-13
36	78	2024-11-25-certifikat.pdf	2024-11-20
51	12	2024-12-22-certifikat.pdf	2024-12-06
8	7	2024-06-08-certifikat.pdf	2024-05-20
36	115	2024-11-25-certifikat.pdf	2024-11-01
35	45	2024-10-02-certifikat.pdf	2024-09-29
12	78	2024-06-08-certifikat.pdf	2024-05-13
30	196	2024-11-08-certifikat.pdf	2024-10-22
55	20	2024-05-31-certifikat.pdf	2024-05-02
24	27	2025-01-15-certifikat.pdf	2024-12-20
71	144	2024-10-08-certifikat.pdf	2024-09-29
7	144	2024-06-04-certifikat.pdf	2024-05-15
51	122	2024-12-22-certifikat.pdf	2024-12-19
21	103	2024-05-07-certifikat.pdf	2024-04-21
24	89	2025-01-15-certifikat.pdf	2025-01-11
56	188	2024-05-31-certifikat.pdf	2024-05-08
50	84	2024-09-21-certifikat.pdf	2024-08-29
68	28	2024-11-21-certifikat.pdf	2024-10-29
50	131	2024-09-21-certifikat.pdf	2024-09-18
29	74	2024-05-23-certifikat.pdf	2024-05-16
62	62	2024-10-01-certifikat.pdf	2024-09-19
36	160	2024-11-25-certifikat.pdf	2024-11-13
50	113	2024-09-21-certifikat.pdf	2024-08-25
68	69	2024-11-21-certifikat.pdf	2024-11-02
30	74	2024-11-08-certifikat.pdf	2024-11-02
36	88	2024-11-25-certifikat.pdf	2024-11-21
44	89	2024-09-06-certifikat.pdf	2024-08-11
57	113	2024-05-31-certifikat.pdf	2024-05-10
56	43	2024-05-31-certifikat.pdf	2024-05-11
42	188	2024-09-06-certifikat.pdf	2024-08-09
35	157	2024-10-02-certifikat.pdf	2024-09-17
14	165	2024-07-20-certifikat.pdf	2024-07-11
8	188	2024-06-08-certifikat.pdf	2024-05-11
73	104	2024-05-14-certifikat.pdf	2024-04-22
64	20	2024-07-05-certifikat.pdf	2024-06-14
63	94	2024-10-01-certifikat.pdf	2024-09-24
56	28	2024-05-31-certifikat.pdf	2024-05-04
5	185	2024-06-04-certifikat.pdf	2024-05-30
51	88	2024-12-22-certifikat.pdf	2024-12-15
15	163	2024-07-20-certifikat.pdf	2024-06-29
23	196	2025-01-15-certifikat.pdf	2024-12-29
27	165	2024-05-23-certifikat.pdf	2024-04-27
7	165	2024-06-04-certifikat.pdf	2024-05-20
72	12	2024-10-08-certifikat.pdf	2024-09-26
42	160	2024-09-06-certifikat.pdf	2024-09-01
20	24	2024-05-07-certifikat.pdf	2024-04-14
47	12	2024-09-21-certifikat.pdf	2024-09-04
67	174	2024-11-21-certifikat.pdf	2024-11-01
4	89	2024-06-04-certifikat.pdf	2024-05-06
4	24	2024-06-04-certifikat.pdf	2024-05-23
38	148	2024-11-25-certifikat.pdf	2024-11-06
6	5	2024-06-04-certifikat.pdf	2024-05-11
14	117	2024-07-20-certifikat.pdf	2024-07-03
28	196	2024-05-23-certifikat.pdf	2024-04-23
18	30	2024-05-07-certifikat.pdf	2024-04-25
47	184	2024-09-21-certifikat.pdf	2024-08-25
3	84	2024-06-04-certifikat.pdf	2024-06-01
21	179	2024-05-07-certifikat.pdf	2024-04-07
39	84	2024-11-25-certifikat.pdf	2024-10-27
20	163	2024-05-07-certifikat.pdf	2024-04-27
46	148	2024-09-21-certifikat.pdf	2024-08-22
5	79	2024-06-04-certifikat.pdf	2024-05-24
53	35	2024-05-31-certifikat.pdf	2024-05-28
49	75	2024-09-21-certifikat.pdf	2024-09-08
73	100	2024-05-14-certifikat.pdf	2024-04-28
72	64	2024-10-08-certifikat.pdf	2024-09-19
28	74	2024-05-23-certifikat.pdf	2024-04-25
18	69	2024-05-07-certifikat.pdf	2024-04-23
53	1	2024-05-31-certifikat.pdf	2024-05-26
17	89	2024-05-07-certifikat.pdf	2024-05-01
51	111	2024-12-22-certifikat.pdf	2024-11-25
29	104	2024-05-23-certifikat.pdf	2024-05-16
73	113	2024-05-14-certifikat.pdf	2024-04-14
26	113	2024-06-20-certifikat.pdf	2024-06-10
60	144	2024-12-19-certifikat.pdf	2024-12-13
15	173	2024-07-20-certifikat.pdf	2024-07-03
4	144	2024-06-04-certifikat.pdf	2024-05-26
46	21	2024-09-21-certifikat.pdf	2024-08-30
73	150	2024-05-14-certifikat.pdf	2024-04-29
43	114	2024-09-06-certifikat.pdf	2024-08-26
8	88	2024-06-08-certifikat.pdf	2024-05-30
61	112	2024-10-01-certifikat.pdf	2024-09-01
7	89	2024-06-04-certifikat.pdf	2024-05-19
4	79	2024-06-04-certifikat.pdf	2024-05-19
62	78	2024-10-01-certifikat.pdf	2024-09-26
44	36	2024-09-06-certifikat.pdf	2024-08-07
59	165	2024-12-19-certifikat.pdf	2024-12-07
9	118	2024-06-08-certifikat.pdf	2024-05-09
44	37	2024-09-06-certifikat.pdf	2024-08-20
7	19	2024-06-04-certifikat.pdf	2024-05-21
20	1	2024-05-07-certifikat.pdf	2024-04-10
20	191	2024-05-07-certifikat.pdf	2024-04-08
58	119	2024-05-31-certifikat.pdf	2024-05-03
74	100	2024-05-14-certifikat.pdf	2024-05-06
72	130	2024-10-08-certifikat.pdf	2024-09-18
39	119	2024-11-25-certifikat.pdf	2024-11-22
37	59	2024-11-25-certifikat.pdf	2024-10-28
39	100	2024-11-25-certifikat.pdf	2024-11-09
48	138	2024-09-21-certifikat.pdf	2024-09-13
10	1	2024-06-08-certifikat.pdf	2024-05-29
7	56	2024-06-04-certifikat.pdf	2024-05-15
17	197	2024-05-07-certifikat.pdf	2024-04-30
34	184	2024-10-02-certifikat.pdf	2024-09-20
9	131	2024-06-08-certifikat.pdf	2024-05-24
44	188	2024-09-06-certifikat.pdf	2024-08-11
50	179	2024-09-21-certifikat.pdf	2024-09-14
65	150	2024-07-05-certifikat.pdf	2024-06-10
35	64	2024-10-02-certifikat.pdf	2024-09-27
37	71	2024-11-25-certifikat.pdf	2024-10-26
43	85	2024-09-06-certifikat.pdf	2024-08-16
69	138	2024-11-21-certifikat.pdf	2024-11-07
21	118	2024-05-07-certifikat.pdf	2024-05-01
32	165	2024-10-02-certifikat.pdf	2024-09-14
35	144	2024-10-02-certifikat.pdf	2024-09-06
77	130	2024-05-09-certifikat.pdf	2024-04-16
21	89	2024-05-07-certifikat.pdf	2024-05-01
57	12	2024-05-31-certifikat.pdf	2024-05-24
25	20	2024-06-20-certifikat.pdf	2024-06-11
66	20	2024-07-05-certifikat.pdf	2024-06-27
55	106	2024-05-31-certifikat.pdf	2024-05-06
24	144	2025-01-15-certifikat.pdf	2024-12-18
36	93	2024-11-25-certifikat.pdf	2024-11-06
30	152	2024-11-08-certifikat.pdf	2024-10-22
12	103	2024-06-08-certifikat.pdf	2024-05-21
52	131	2024-12-22-certifikat.pdf	2024-12-14
47	18	2024-09-21-certifikat.pdf	2024-09-08
50	100	2024-09-21-certifikat.pdf	2024-08-27
61	100	2024-10-01-certifikat.pdf	2024-09-25
10	18	2024-06-08-certifikat.pdf	2024-05-28
22	148	2025-01-15-certifikat.pdf	2025-01-02
8	122	2024-06-08-certifikat.pdf	2024-05-21
24	119	2025-01-15-certifikat.pdf	2024-12-23
4	127	2024-06-04-certifikat.pdf	2024-05-11
22	74	2025-01-15-certifikat.pdf	2025-01-09
14	199	2024-07-20-certifikat.pdf	2024-07-15
50	106	2024-09-21-certifikat.pdf	2024-09-11
56	179	2024-05-31-certifikat.pdf	2024-05-13
16	196	2024-07-20-certifikat.pdf	2024-07-09
70	188	2024-10-08-certifikat.pdf	2024-09-26
63	157	2024-10-01-certifikat.pdf	2024-09-13
28	10	2024-05-23-certifikat.pdf	2024-04-25
3	85	2024-06-04-certifikat.pdf	2024-05-16
21	188	2024-05-07-certifikat.pdf	2024-04-15
29	144	2024-05-23-certifikat.pdf	2024-04-23
60	150	2024-12-19-certifikat.pdf	2024-12-06
33	184	2024-10-02-certifikat.pdf	2024-09-28
68	111	2024-11-21-certifikat.pdf	2024-11-08
57	15	2024-05-31-certifikat.pdf	2024-05-06
43	59	2024-09-06-certifikat.pdf	2024-08-23
21	71	2024-05-07-certifikat.pdf	2024-04-18
4	36	2024-06-04-certifikat.pdf	2024-05-06
59	144	2024-12-19-certifikat.pdf	2024-12-15
18	28	2024-05-07-certifikat.pdf	2024-04-25
52	115	2024-12-22-certifikat.pdf	2024-12-17
64	165	2024-07-05-certifikat.pdf	2024-06-11
11	111	2024-06-08-certifikat.pdf	2024-05-18
8	86	2024-06-08-certifikat.pdf	2024-05-18
38	82	2024-11-25-certifikat.pdf	2024-11-03
16	127	2024-07-20-certifikat.pdf	2024-07-08
55	145	2024-05-31-certifikat.pdf	2024-05-06
45	69	2024-09-21-certifikat.pdf	2024-08-22
53	191	2024-05-31-certifikat.pdf	2024-05-01
40	182	2024-09-06-certifikat.pdf	2024-09-03
6	21	2024-06-04-certifikat.pdf	2024-06-01
3	188	2024-06-04-certifikat.pdf	2024-05-17
38	5	2024-11-25-certifikat.pdf	2024-11-11
51	124	2024-12-22-certifikat.pdf	2024-12-14
16	21	2024-07-20-certifikat.pdf	2024-07-10
54	113	2024-05-31-certifikat.pdf	2024-05-25
49	165	2024-09-21-certifikat.pdf	2024-08-27
57	68	2024-05-31-certifikat.pdf	2024-05-20
26	35	2024-06-20-certifikat.pdf	2024-06-04
33	182	2024-10-02-certifikat.pdf	2024-09-13
64	123	2024-07-05-certifikat.pdf	2024-06-17
50	111	2024-09-21-certifikat.pdf	2024-08-30
62	82	2024-10-01-certifikat.pdf	2024-09-16
73	12	2024-05-14-certifikat.pdf	2024-05-06
16	134	2024-07-20-certifikat.pdf	2024-07-11
55	123	2024-05-31-certifikat.pdf	2024-05-13
35	19	2024-10-02-certifikat.pdf	2024-09-06
4	59	2024-06-04-certifikat.pdf	2024-05-09
59	12	2024-12-19-certifikat.pdf	2024-11-27
57	94	2024-05-31-certifikat.pdf	2024-05-01
46	24	2024-09-21-certifikat.pdf	2024-08-22
14	64	2024-07-20-certifikat.pdf	2024-07-11
54	15	2024-05-31-certifikat.pdf	2024-05-14
18	68	2024-05-07-certifikat.pdf	2024-04-29
9	37	2024-06-08-certifikat.pdf	2024-05-25
38	21	2024-11-25-certifikat.pdf	2024-11-02
73	128	2024-05-14-certifikat.pdf	2024-04-30
4	27	2024-06-04-certifikat.pdf	2024-05-05
36	122	2024-11-25-certifikat.pdf	2024-11-10
63	113	2024-10-01-certifikat.pdf	2024-09-12
3	5	2024-06-04-certifikat.pdf	2024-06-01
45	68	2024-09-21-certifikat.pdf	2024-09-05
45	182	2024-09-21-certifikat.pdf	2024-09-03
52	160	2024-12-22-certifikat.pdf	2024-12-15
29	45	2024-05-23-certifikat.pdf	2024-05-09
73	35	2024-05-14-certifikat.pdf	2024-05-04
6	84	2024-06-04-certifikat.pdf	2024-05-21
72	104	2024-10-08-certifikat.pdf	2024-09-11
32	199	2024-10-02-certifikat.pdf	2024-09-11
10	69	2024-06-08-certifikat.pdf	2024-06-03
23	144	2025-01-15-certifikat.pdf	2025-01-03
38	85	2024-11-25-certifikat.pdf	2024-11-12
4	131	2024-06-04-certifikat.pdf	2024-05-07
69	37	2024-11-21-certifikat.pdf	2024-11-17
63	160	2024-10-01-certifikat.pdf	2024-09-15
5	128	2024-06-04-certifikat.pdf	2024-05-21
46	102	2024-09-21-certifikat.pdf	2024-09-11
11	150	2024-06-08-certifikat.pdf	2024-05-14
59	133	2024-12-19-certifikat.pdf	2024-11-22
43	155	2024-09-06-certifikat.pdf	2024-09-03
7	150	2024-06-04-certifikat.pdf	2024-05-15
43	27	2024-09-06-certifikat.pdf	2024-08-27
27	117	2024-05-23-certifikat.pdf	2024-05-19
34	18	2024-10-02-certifikat.pdf	2024-09-17
32	104	2024-10-02-certifikat.pdf	2024-09-04
13	78	2024-07-20-certifikat.pdf	2024-07-05
47	185	2024-09-21-certifikat.pdf	2024-09-01
50	85	2024-09-21-certifikat.pdf	2024-08-29
65	188	2024-07-05-certifikat.pdf	2024-06-27
21	111	2024-05-07-certifikat.pdf	2024-04-09
65	163	2024-07-05-certifikat.pdf	2024-06-26
16	191	2024-07-20-certifikat.pdf	2024-06-26
12	130	2024-06-08-certifikat.pdf	2024-05-31
19	12	2024-05-07-certifikat.pdf	2024-04-12
27	24	2024-05-23-certifikat.pdf	2024-04-30
11	93	2024-06-08-certifikat.pdf	2024-06-01
45	93	2024-09-21-certifikat.pdf	2024-08-27
58	184	2024-05-31-certifikat.pdf	2024-05-07
16	20	2024-07-20-certifikat.pdf	2024-07-16
69	59	2024-11-21-certifikat.pdf	2024-10-29
51	62	2024-12-22-certifikat.pdf	2024-12-12
15	141	2024-07-20-certifikat.pdf	2024-06-25
54	110	2024-05-31-certifikat.pdf	2024-05-13
45	197	2024-09-21-certifikat.pdf	2024-09-12
57	35	2024-05-31-certifikat.pdf	2024-05-28
65	36	2024-07-05-certifikat.pdf	2024-06-15
18	18	2024-05-07-certifikat.pdf	2024-05-03
69	185	2024-11-21-certifikat.pdf	2024-10-29
40	59	2024-09-06-certifikat.pdf	2024-08-09
11	69	2024-06-08-certifikat.pdf	2024-05-27
15	21	2024-07-20-certifikat.pdf	2024-07-10
38	89	2024-11-25-certifikat.pdf	2024-10-28
43	179	2024-09-06-certifikat.pdf	2024-09-03
12	179	2024-06-08-certifikat.pdf	2024-05-10
32	24	2024-10-02-certifikat.pdf	2024-09-05
19	72	2024-05-07-certifikat.pdf	2024-04-19
39	106	2024-11-25-certifikat.pdf	2024-11-06
66	165	2024-07-05-certifikat.pdf	2024-06-23
67	27	2024-11-21-certifikat.pdf	2024-10-27
39	197	2024-11-25-certifikat.pdf	2024-11-05
6	144	2024-06-04-certifikat.pdf	2024-05-24
37	74	2024-11-25-certifikat.pdf	2024-11-13
54	173	2024-05-31-certifikat.pdf	2024-05-16
52	150	2024-12-22-certifikat.pdf	2024-12-18
51	188	2024-12-22-certifikat.pdf	2024-12-07
73	160	2024-05-14-certifikat.pdf	2024-04-17
65	21	2024-07-05-certifikat.pdf	2024-06-19
50	188	2024-09-21-certifikat.pdf	2024-09-16
44	163	2024-09-06-certifikat.pdf	2024-08-08
42	78	2024-09-06-certifikat.pdf	2024-08-22
52	69	2024-12-22-certifikat.pdf	2024-12-01
48	144	2024-09-21-certifikat.pdf	2024-09-01
26	49	2024-06-20-certifikat.pdf	2024-06-01
26	173	2024-06-20-certifikat.pdf	2024-06-01
6	62	2024-06-04-certifikat.pdf	2024-05-13
36	37	2024-11-25-certifikat.pdf	2024-11-03
32	89	2024-10-02-certifikat.pdf	2024-09-09
43	152	2024-09-06-certifikat.pdf	2024-08-13
52	88	2024-12-22-certifikat.pdf	2024-11-28
31	72	2024-11-08-certifikat.pdf	2024-10-25
17	27	2024-05-07-certifikat.pdf	2024-05-04
40	163	2024-09-06-certifikat.pdf	2024-08-25
31	93	2024-11-08-certifikat.pdf	2024-10-26
46	36	2024-09-21-certifikat.pdf	2024-09-09
67	184	2024-11-21-certifikat.pdf	2024-10-24
53	12	2024-05-31-certifikat.pdf	2024-05-20
12	199	2024-06-08-certifikat.pdf	2024-05-18
44	150	2024-09-06-certifikat.pdf	2024-08-24
29	64	2024-05-23-certifikat.pdf	2024-05-05
54	104	2024-05-31-certifikat.pdf	2024-05-10
26	182	2024-06-20-certifikat.pdf	2024-05-24
60	12	2024-12-19-certifikat.pdf	2024-12-16
4	60	2024-06-04-certifikat.pdf	2024-05-08
54	88	2024-05-31-certifikat.pdf	2024-05-02
12	64	2024-06-08-certifikat.pdf	2024-06-04
46	196	2024-09-21-certifikat.pdf	2024-09-06
65	124	2024-07-05-certifikat.pdf	2024-06-20
68	196	2024-11-21-certifikat.pdf	2024-10-24
21	130	2024-05-07-certifikat.pdf	2024-04-08
69	131	2024-11-21-certifikat.pdf	2024-10-27
51	130	2024-12-22-certifikat.pdf	2024-12-09
21	163	2024-05-07-certifikat.pdf	2024-04-22
44	12	2024-09-06-certifikat.pdf	2024-08-12
65	103	2024-07-05-certifikat.pdf	2024-06-24
51	50	2024-12-22-certifikat.pdf	2024-12-17
74	5	2024-05-14-certifikat.pdf	2024-04-21
72	117	2024-10-08-certifikat.pdf	2024-10-01
74	182	2024-05-14-certifikat.pdf	2024-04-24
5	165	2024-06-04-certifikat.pdf	2024-05-27
58	165	2024-05-31-certifikat.pdf	2024-05-18
74	56	2024-05-14-certifikat.pdf	2024-04-29
45	56	2024-09-21-certifikat.pdf	2024-09-05
42	50	2024-09-06-certifikat.pdf	2024-08-31
48	130	2024-09-21-certifikat.pdf	2024-08-24
30	90	2024-11-08-certifikat.pdf	2024-10-20
14	122	2024-07-20-certifikat.pdf	2024-06-25
77	196	2024-05-09-certifikat.pdf	2024-04-30
10	104	2024-06-08-certifikat.pdf	2024-05-22
3	36	2024-06-04-certifikat.pdf	2024-05-20
46	82	2024-09-21-certifikat.pdf	2024-09-13
44	88	2024-09-06-certifikat.pdf	2024-08-12
42	69	2024-09-06-certifikat.pdf	2024-08-17
50	123	2024-09-21-certifikat.pdf	2024-09-08
66	185	2024-07-05-certifikat.pdf	2024-06-20
68	110	2024-11-21-certifikat.pdf	2024-11-04
58	79	2024-05-31-certifikat.pdf	2024-05-22
14	89	2024-07-20-certifikat.pdf	2024-07-15
71	7	2024-10-08-certifikat.pdf	2024-09-11
71	75	2024-10-08-certifikat.pdf	2024-09-26
12	37	2024-06-08-certifikat.pdf	2024-05-14
40	185	2024-09-06-certifikat.pdf	2024-08-29
49	64	2024-09-21-certifikat.pdf	2024-09-11
15	15	2024-07-20-certifikat.pdf	2024-07-12
57	150	2024-05-31-certifikat.pdf	2024-05-13
23	21	2025-01-15-certifikat.pdf	2025-01-02
23	60	2025-01-15-certifikat.pdf	2025-01-10
33	18	2024-10-02-certifikat.pdf	2024-09-15
22	84	2025-01-15-certifikat.pdf	2025-01-09
13	100	2024-07-20-certifikat.pdf	2024-07-14
3	49	2024-06-04-certifikat.pdf	2024-05-23
4	148	2024-06-04-certifikat.pdf	2024-05-31
51	21	2024-12-22-certifikat.pdf	2024-11-22
46	27	2024-09-21-certifikat.pdf	2024-09-03
41	37	2024-09-06-certifikat.pdf	2024-08-15
34	21	2024-10-02-certifikat.pdf	2024-09-04
21	160	2024-05-07-certifikat.pdf	2024-04-09
47	92	2024-09-21-certifikat.pdf	2024-08-22
22	82	2025-01-15-certifikat.pdf	2025-01-06
31	108	2024-11-08-certifikat.pdf	2024-11-04
41	21	2024-09-06-certifikat.pdf	2024-08-13
5	78	2024-06-04-certifikat.pdf	2024-06-01
16	72	2024-07-20-certifikat.pdf	2024-06-30
16	163	2024-07-20-certifikat.pdf	2024-07-03
50	138	2024-09-21-certifikat.pdf	2024-09-03
74	115	2024-05-14-certifikat.pdf	2024-04-30
54	157	2024-05-31-certifikat.pdf	2024-05-27
8	62	2024-06-08-certifikat.pdf	2024-05-11
28	27	2024-05-23-certifikat.pdf	2024-05-20
46	179	2024-09-21-certifikat.pdf	2024-09-06
45	113	2024-09-21-certifikat.pdf	2024-08-30
36	118	2024-11-25-certifikat.pdf	2024-11-03
67	128	2024-11-21-certifikat.pdf	2024-11-18
15	108	2024-07-20-certifikat.pdf	2024-07-17
24	179	2025-01-15-certifikat.pdf	2025-01-07
55	43	2024-05-31-certifikat.pdf	2024-05-20
61	123	2024-10-01-certifikat.pdf	2024-09-24
3	18	2024-06-04-certifikat.pdf	2024-05-28
24	59	2025-01-15-certifikat.pdf	2024-12-25
24	172	2025-01-15-certifikat.pdf	2025-01-06
10	28	2024-06-08-certifikat.pdf	2024-06-03
25	134	2024-06-20-certifikat.pdf	2024-05-31
28	155	2024-05-23-certifikat.pdf	2024-05-09
3	141	2024-06-04-certifikat.pdf	2024-05-27
53	197	2024-05-31-certifikat.pdf	2024-05-14
29	69	2024-05-23-certifikat.pdf	2024-05-04
71	157	2024-10-08-certifikat.pdf	2024-09-12
6	64	2024-06-04-certifikat.pdf	2024-05-16
27	133	2024-05-23-certifikat.pdf	2024-05-08
33	185	2024-10-02-certifikat.pdf	2024-09-04
22	60	2025-01-15-certifikat.pdf	2024-12-28
63	182	2024-10-01-certifikat.pdf	2024-09-20
20	27	2024-05-07-certifikat.pdf	2024-04-29
44	131	2024-09-06-certifikat.pdf	2024-08-16
64	184	2024-07-05-certifikat.pdf	2024-06-07
65	130	2024-07-05-certifikat.pdf	2024-06-22
43	64	2024-09-06-certifikat.pdf	2024-08-17
24	191	2025-01-15-certifikat.pdf	2024-12-23
27	144	2024-05-23-certifikat.pdf	2024-05-16
71	89	2024-10-08-certifikat.pdf	2024-09-11
47	182	2024-09-21-certifikat.pdf	2024-09-18
13	184	2024-07-20-certifikat.pdf	2024-07-08
10	68	2024-06-08-certifikat.pdf	2024-05-26
70	150	2024-10-08-certifikat.pdf	2024-09-10
46	62	2024-09-21-certifikat.pdf	2024-08-27
22	27	2025-01-15-certifikat.pdf	2024-12-21
6	36	2024-06-04-certifikat.pdf	2024-05-20
27	19	2024-05-23-certifikat.pdf	2024-05-16
53	69	2024-05-31-certifikat.pdf	2024-05-15
13	82	2024-07-20-certifikat.pdf	2024-07-09
55	84	2024-05-31-certifikat.pdf	2024-05-09
3	68	2024-06-04-certifikat.pdf	2024-05-12
30	69	2024-11-08-certifikat.pdf	2024-11-04
49	84	2024-09-21-certifikat.pdf	2024-09-11
71	188	2024-10-08-certifikat.pdf	2024-09-20
36	103	2024-11-25-certifikat.pdf	2024-10-27
35	84	2024-10-02-certifikat.pdf	2024-09-04
28	64	2024-05-23-certifikat.pdf	2024-05-14
57	110	2024-05-31-certifikat.pdf	2024-05-18
17	5	2024-05-07-certifikat.pdf	2024-04-20
10	197	2024-06-08-certifikat.pdf	2024-05-17
11	179	2024-06-08-certifikat.pdf	2024-05-26
32	130	2024-10-02-certifikat.pdf	2024-09-18
19	27	2024-05-07-certifikat.pdf	2024-05-03
15	93	2024-07-20-certifikat.pdf	2024-06-20
73	110	2024-05-14-certifikat.pdf	2024-04-24
30	85	2024-11-08-certifikat.pdf	2024-10-16
22	1	2025-01-15-certifikat.pdf	2025-01-10
24	64	2025-01-15-certifikat.pdf	2025-01-06
31	177	2024-11-08-certifikat.pdf	2024-10-12
30	92	2024-11-08-certifikat.pdf	2024-10-11
11	124	2024-06-08-certifikat.pdf	2024-05-13
48	131	2024-09-21-certifikat.pdf	2024-08-30
55	36	2024-05-31-certifikat.pdf	2024-05-09
74	141	2024-05-14-certifikat.pdf	2024-04-22
57	56	2024-05-31-certifikat.pdf	2024-05-02
51	64	2024-12-22-certifikat.pdf	2024-11-25
17	127	2024-05-07-certifikat.pdf	2024-04-13
74	75	2024-05-14-certifikat.pdf	2024-05-11
49	150	2024-09-21-certifikat.pdf	2024-08-31
61	199	2024-10-01-certifikat.pdf	2024-09-09
49	69	2024-09-21-certifikat.pdf	2024-09-03
59	74	2024-12-19-certifikat.pdf	2024-11-27
37	155	2024-11-25-certifikat.pdf	2024-10-29
39	113	2024-11-25-certifikat.pdf	2024-11-04
37	27	2024-11-25-certifikat.pdf	2024-11-01
55	68	2024-05-31-certifikat.pdf	2024-05-17
51	93	2024-12-22-certifikat.pdf	2024-12-09
74	59	2024-05-14-certifikat.pdf	2024-05-01
13	20	2024-07-20-certifikat.pdf	2024-07-06
23	134	2025-01-15-certifikat.pdf	2024-12-18
61	165	2024-10-01-certifikat.pdf	2024-09-03
42	118	2024-09-06-certifikat.pdf	2024-08-12
50	28	2024-09-21-certifikat.pdf	2024-09-15
68	85	2024-11-21-certifikat.pdf	2024-11-04
56	131	2024-05-31-certifikat.pdf	2024-05-25
23	89	2025-01-15-certifikat.pdf	2024-12-19
5	191	2024-06-04-certifikat.pdf	2024-05-17
42	20	2024-09-06-certifikat.pdf	2024-08-23
17	179	2024-05-07-certifikat.pdf	2024-04-21
43	196	2024-09-06-certifikat.pdf	2024-08-18
8	110	2024-06-08-certifikat.pdf	2024-05-31
74	1	2024-05-14-certifikat.pdf	2024-04-18
36	50	2024-11-25-certifikat.pdf	2024-10-31
27	71	2024-05-23-certifikat.pdf	2024-04-30
71	56	2024-10-08-certifikat.pdf	2024-09-14
12	163	2024-06-08-certifikat.pdf	2024-05-14
11	36	2024-06-08-certifikat.pdf	2024-05-11
36	20	2024-11-25-certifikat.pdf	2024-11-19
5	182	2024-06-04-certifikat.pdf	2024-05-26
77	179	2024-05-09-certifikat.pdf	2024-04-10
17	21	2024-05-07-certifikat.pdf	2024-04-08
59	117	2024-12-19-certifikat.pdf	2024-11-23
31	191	2024-11-08-certifikat.pdf	2024-10-09
77	139	2024-05-09-certifikat.pdf	2024-04-25
23	79	2025-01-15-certifikat.pdf	2024-12-18
11	20	2024-06-08-certifikat.pdf	2024-05-12
21	131	2024-05-07-certifikat.pdf	2024-04-28
77	155	2024-05-09-certifikat.pdf	2024-04-27
21	36	2024-05-07-certifikat.pdf	2024-04-29
6	27	2024-06-04-certifikat.pdf	2024-05-15
10	191	2024-06-08-certifikat.pdf	2024-05-31
38	191	2024-11-25-certifikat.pdf	2024-11-05
25	75	2024-06-20-certifikat.pdf	2024-06-08
64	128	2024-07-05-certifikat.pdf	2024-06-21
58	112	2024-05-31-certifikat.pdf	2024-05-06
60	18	2024-12-19-certifikat.pdf	2024-12-11
41	174	2024-09-06-certifikat.pdf	2024-08-24
18	15	2024-05-07-certifikat.pdf	2024-04-26
77	71	2024-05-09-certifikat.pdf	2024-04-25
30	155	2024-11-08-certifikat.pdf	2024-10-13
7	117	2024-06-04-certifikat.pdf	2024-05-08
23	191	2025-01-15-certifikat.pdf	2025-01-01
3	179	2024-06-04-certifikat.pdf	2024-05-22
28	59	2024-05-23-certifikat.pdf	2024-04-28
22	89	2025-01-15-certifikat.pdf	2025-01-04
5	72	2024-06-04-certifikat.pdf	2024-05-26
71	130	2024-10-08-certifikat.pdf	2024-10-02
9	27	2024-06-08-certifikat.pdf	2024-05-18
11	163	2024-06-08-certifikat.pdf	2024-06-01
14	19	2024-07-20-certifikat.pdf	2024-06-28
23	163	2025-01-15-certifikat.pdf	2025-01-03
53	110	2024-05-31-certifikat.pdf	2024-05-04
26	69	2024-06-20-certifikat.pdf	2024-06-12
53	28	2024-05-31-certifikat.pdf	2024-05-12
49	19	2024-09-21-certifikat.pdf	2024-09-09
73	27	2024-05-14-certifikat.pdf	2024-04-20
9	150	2024-06-08-certifikat.pdf	2024-05-23
10	56	2024-06-08-certifikat.pdf	2024-05-29
52	89	2024-12-22-certifikat.pdf	2024-12-09
77	74	2024-05-09-certifikat.pdf	2024-04-13
6	179	2024-06-04-certifikat.pdf	2024-05-18
70	144	2024-10-08-certifikat.pdf	2024-09-16
17	82	2024-05-07-certifikat.pdf	2024-04-12
36	7	2024-11-25-certifikat.pdf	2024-11-01
59	130	2024-12-19-certifikat.pdf	2024-11-24
21	122	2024-05-07-certifikat.pdf	2024-05-03
12	69	2024-06-08-certifikat.pdf	2024-05-17
40	18	2024-09-06-certifikat.pdf	2024-08-19
49	24	2024-09-21-certifikat.pdf	2024-08-23
10	27	2024-06-08-certifikat.pdf	2024-05-15
14	75	2024-07-20-certifikat.pdf	2024-06-20
38	60	2024-11-25-certifikat.pdf	2024-10-29
69	27	2024-11-21-certifikat.pdf	2024-11-06
31	75	2024-11-08-certifikat.pdf	2024-10-20
52	50	2024-12-22-certifikat.pdf	2024-12-16
54	100	2024-05-31-certifikat.pdf	2024-05-18
52	130	2024-12-22-certifikat.pdf	2024-12-15
21	62	2024-05-07-certifikat.pdf	2024-04-07
63	18	2024-10-01-certifikat.pdf	2024-09-01
72	69	2024-10-08-certifikat.pdf	2024-09-25
21	184	2024-05-07-certifikat.pdf	2024-04-29
22	79	2025-01-15-certifikat.pdf	2025-01-05
42	86	2024-09-06-certifikat.pdf	2024-08-30
50	36	2024-09-21-certifikat.pdf	2024-09-09
42	62	2024-09-06-certifikat.pdf	2024-09-02
53	27	2024-05-31-certifikat.pdf	2024-05-13
34	174	2024-10-02-certifikat.pdf	2024-09-27
73	28	2024-05-14-certifikat.pdf	2024-04-17
8	89	2024-06-08-certifikat.pdf	2024-06-04
60	184	2024-12-19-certifikat.pdf	2024-12-07
6	112	2024-06-04-certifikat.pdf	2024-05-08
35	199	2024-10-02-certifikat.pdf	2024-09-14
60	163	2024-12-19-certifikat.pdf	2024-11-22
15	127	2024-07-20-certifikat.pdf	2024-07-14
14	12	2024-07-20-certifikat.pdf	2024-07-02
63	197	2024-10-01-certifikat.pdf	2024-09-12
9	50	2024-06-08-certifikat.pdf	2024-05-19
29	71	2024-05-23-certifikat.pdf	2024-04-23
44	71	2024-09-06-certifikat.pdf	2024-09-02
68	64	2024-11-21-certifikat.pdf	2024-11-04
49	71	2024-09-21-certifikat.pdf	2024-09-17
17	36	2024-05-07-certifikat.pdf	2024-04-24
17	74	2024-05-07-certifikat.pdf	2024-04-17
35	133	2024-10-02-certifikat.pdf	2024-09-09
18	94	2024-05-07-certifikat.pdf	2024-04-26
30	10	2024-11-08-certifikat.pdf	2024-10-14
44	115	2024-09-06-certifikat.pdf	2024-08-25
4	74	2024-06-04-certifikat.pdf	2024-05-17
11	199	2024-06-08-certifikat.pdf	2024-05-18
14	85	2024-07-20-certifikat.pdf	2024-07-13
9	184	2024-06-08-certifikat.pdf	2024-05-16
14	188	2024-07-20-certifikat.pdf	2024-07-17
48	27	2024-09-21-certifikat.pdf	2024-08-26
48	12	2024-09-21-certifikat.pdf	2024-08-27
58	82	2024-05-31-certifikat.pdf	2024-05-10
67	138	2024-11-21-certifikat.pdf	2024-10-27
61	82	2024-10-01-certifikat.pdf	2024-09-03
44	111	2024-09-06-certifikat.pdf	2024-08-28
29	12	2024-05-23-certifikat.pdf	2024-05-11
8	50	2024-06-08-certifikat.pdf	2024-05-15
22	197	2025-01-15-certifikat.pdf	2024-12-23
34	131	2024-10-02-certifikat.pdf	2024-09-28
18	104	2024-05-07-certifikat.pdf	2024-04-25
56	89	2024-05-31-certifikat.pdf	2024-05-05
51	115	2024-12-22-certifikat.pdf	2024-12-07
64	185	2024-07-05-certifikat.pdf	2024-06-30
42	150	2024-09-06-certifikat.pdf	2024-08-22
33	131	2024-10-02-certifikat.pdf	2024-09-10
56	197	2024-05-31-certifikat.pdf	2024-05-24
38	196	2024-11-25-certifikat.pdf	2024-11-14
58	78	2024-05-31-certifikat.pdf	2024-05-13
31	144	2024-11-08-certifikat.pdf	2024-10-29
65	12	2024-07-05-certifikat.pdf	2024-06-10
17	163	2024-05-07-certifikat.pdf	2024-04-18
18	160	2024-05-07-certifikat.pdf	2024-05-01
52	118	2024-12-22-certifikat.pdf	2024-12-16
69	92	2024-11-21-certifikat.pdf	2024-10-24
29	122	2024-05-23-certifikat.pdf	2024-05-06
71	12	2024-10-08-certifikat.pdf	2024-10-04
25	191	2024-06-20-certifikat.pdf	2024-06-15
19	37	2024-05-07-certifikat.pdf	2024-04-13
67	182	2024-11-21-certifikat.pdf	2024-10-24
27	85	2024-05-23-certifikat.pdf	2024-04-23
74	135	2024-05-14-certifikat.pdf	2024-04-22
50	172	2024-09-21-certifikat.pdf	2024-09-18
65	69	2024-07-05-certifikat.pdf	2024-06-26
38	62	2024-11-25-certifikat.pdf	2024-11-01
14	45	2024-07-20-certifikat.pdf	2024-07-14
15	10	2024-07-20-certifikat.pdf	2024-07-11
77	28	2024-05-09-certifikat.pdf	2024-05-02
20	60	2024-05-07-certifikat.pdf	2024-04-30
49	122	2024-09-21-certifikat.pdf	2024-08-29
45	49	2024-09-21-certifikat.pdf	2024-08-30
69	150	2024-11-21-certifikat.pdf	2024-11-09
47	118	2024-09-21-certifikat.pdf	2024-09-17
19	131	2024-05-07-certifikat.pdf	2024-05-03
42	7	2024-09-06-certifikat.pdf	2024-08-13
23	85	2025-01-15-certifikat.pdf	2024-12-22
10	150	2024-06-08-certifikat.pdf	2024-05-20
38	133	2024-11-25-certifikat.pdf	2024-11-05
25	72	2024-06-20-certifikat.pdf	2024-06-03
74	84	2024-05-14-certifikat.pdf	2024-05-08
49	117	2024-09-21-certifikat.pdf	2024-09-13
61	184	2024-10-01-certifikat.pdf	2024-09-01
64	82	2024-07-05-certifikat.pdf	2024-06-23
52	179	2024-12-22-certifikat.pdf	2024-12-11
12	115	2024-06-08-certifikat.pdf	2024-05-27
15	45	2024-07-20-certifikat.pdf	2024-07-06
20	112	2024-05-07-certifikat.pdf	2024-04-24
55	179	2024-05-31-certifikat.pdf	2024-05-15
8	21	2024-06-08-certifikat.pdf	2024-05-19
70	199	2024-10-08-certifikat.pdf	2024-09-25
48	174	2024-09-21-certifikat.pdf	2024-09-15
66	112	2024-07-05-certifikat.pdf	2024-06-25
32	84	2024-10-02-certifikat.pdf	2024-09-29
60	50	2024-12-19-certifikat.pdf	2024-12-05
29	157	2024-05-23-certifikat.pdf	2024-04-27
3	106	2024-06-04-certifikat.pdf	2024-05-26
60	21	2024-12-19-certifikat.pdf	2024-11-27
57	191	2024-05-31-certifikat.pdf	2024-05-05
7	199	2024-06-04-certifikat.pdf	2024-05-21
47	144	2024-09-21-certifikat.pdf	2024-08-26
48	92	2024-09-21-certifikat.pdf	2024-08-29
61	121	2024-10-01-certifikat.pdf	2024-09-24
36	131	2024-11-25-certifikat.pdf	2024-11-04
6	196	2024-06-04-certifikat.pdf	2024-05-06
28	28	2024-05-23-certifikat.pdf	2024-05-16
25	21	2024-06-20-certifikat.pdf	2024-05-23
73	93	2024-05-14-certifikat.pdf	2024-04-21
6	133	2024-06-04-certifikat.pdf	2024-05-27
74	62	2024-05-14-certifikat.pdf	2024-05-04
71	71	2024-10-08-certifikat.pdf	2024-09-21
55	85	2024-05-31-certifikat.pdf	2024-05-12
22	179	2025-01-15-certifikat.pdf	2025-01-04
9	130	2024-06-08-certifikat.pdf	2024-06-01
10	160	2024-06-08-certifikat.pdf	2024-05-22
35	24	2024-10-02-certifikat.pdf	2024-09-29
57	30	2024-05-31-certifikat.pdf	2024-05-02
20	102	2024-05-07-certifikat.pdf	2024-04-21
61	119	2024-10-01-certifikat.pdf	2024-09-01
61	81	2024-10-01-certifikat.pdf	2024-09-08
5	82	2024-06-04-certifikat.pdf	2024-05-07
77	92	2024-05-09-certifikat.pdf	2024-04-23
73	30	2024-05-14-certifikat.pdf	2024-04-29
\.


--
-- Data for Name: zajemce; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.zajemce (id_zajemce, jmeno, prijmeni, adresa) FROM stdin;
1	Mykhaylo	Bezděkovská	Školní 17/31 Karlovarský kraj 381 58 Prostějov
2	Mykhaylo	Novotná	Kaňkova 8/92 45880 Děčín
3	Simona	Kadlecová	Rozkošného 9 06003 Děčín
4	Marta	Hamplová	Nad Nuslemi 27/737 66290 Příbram
5	Jakub	Literová	Na Jezerce 59956 Vsetín
6	Jitka	Hubička	Na Úbočí 48/58 24216 Prostějov
7	Oldřich	Dolejší	Rozkošného 9 06003 Děčín
8	Jarmila	Hubička	Radbuzská 8 70129 Kolín
9	Markéta	Ečerová	Na Jezerce 59956 Vsetín
10	Věra	Novák	Kaňkova 8/92 45880 Děčín
11	Iva	Berková	Kaňkova 8/92 45880 Děčín
12	Božena	Ečerová	K Návsi 98/33 256 37 Ostrava
13	Renata	Fučíková	Ruzyňská 77/393 14949 Jihlava
14	Jana	Kloud	N. A. Někrasova 430 50 Tábor
15	Josef	Berková	U Kamýku 7/95 Jihomoravský kraj 95727 Jihlava
16	Lenka	Hora	Rozkošného 9 06003 Děčín
17	Zdeňka	Šturmová	Antonínská 9 89334 Vsetín
18	Petr	Hanušová	Školní 17/31 Karlovarský kraj 381 58 Prostějov
19	Šárka	Dufková	Široká 15/353 933 54 Litoměřice
20	Jan	Fajstlová	Mečíková 6/442 911 12 Karlovy Vary
21	Miloslava	Brichová	Nad Nuslemi 27/737 66290 Příbram
22	David	Janatka	Nad Nuslemi 27/737 66290 Příbram
23	Josef	Vrba	Stadionová 681 53 Litoměřice
24	Petr	Hamplová	Radbuzská 8 70129 Kolín
25	Lukáš	Navrátil	Do Vršku 35/612 559 15 Jablonec nad Nisou
26	Adéla	Procházková	U Kamýku 7/95 Jihomoravský kraj 95727 Jihlava
27	Božena	Meyerová	Nad Nuslemi 27/737 66290 Příbram
28	Karel	Navrátil	Otavova Olomoucký kraj 143 37 Frýdek-Místek
29	Petra	Dufková	N. A. Někrasova 430 50 Tábor
30	Gabriela	Bolfová	Antonínská 9 89334 Vsetín
31	Vladimír	Kloud	Stadionová 681 53 Litoměřice
32	Miroslav	Kučera	U Silnice 2/332 406 36 Hradec Králové
33	Lenka	Hénik	Nad Klikovkou 287 29 Sokolov
34	Iveta	Palánová	U Silnice 9/413 719 38 Kroměříž
35	Barbora	Koudelka	Stadionová 681 53 Litoměřice
36	Radim	Šlajerová	Pohledná Jihomoravský kraj 29446 Ústí nad Labem
37	Rudolf	Svoboda	Nad Nuslemi 27/737 66290 Příbram
38	Josef	Žák	U Silnice 2/332 406 36 Hradec Králové
39	Radim	Chromá	U Silnice 2/332 406 36 Hradec Králové
40	David	Majerová	U Silnice 2/332 406 36 Hradec Králové
41	Veronika	Rybárová	Otavova Olomoucký kraj 143 37 Frýdek-Místek
42	Petra	Kalandříková	U Silnice 2/332 406 36 Hradec Králové
43	Anna	Skopečková	Do Vršku 35/612 559 15 Jablonec nad Nisou
44	Blanka	Kloud	Široká 15/353 933 54 Litoměřice
45	Richard	Bolfová	U Kamýku 7/95 Jihomoravský kraj 95727 Jihlava
46	Veronika	Konečný	Nad Klikovkou 287 29 Sokolov
47	Zdeňka	Kabelka	Školní 17/31 Karlovarský kraj 381 58 Prostějov
48	Július	Svoboda	Kukelská 65670 Uherské Hradiště
49	Miloslav	Hora	Na Jezerce 59956 Vsetín
50	Zdeněk	Vrba	Otavova Olomoucký kraj 143 37 Frýdek-Místek
51	Roman	Chromá	Do Vršku 35/612 559 15 Jablonec nad Nisou
52	Jaroslava	Zhejbal	Kukelská 65670 Uherské Hradiště
53	Zlata	Pokorný	U Silnice 9/413 719 38 Kroměříž
54	Miroslav	Černík	Antonínská 9 89334 Vsetín
55	Iveta	Dobrovolná	K Návsi 98/33 256 37 Ostrava
56	Jaroslava	Vančo	Ruzyňská 77/393 14949 Jihlava
57	Markéta	Šturmová	Rozkošného 9 06003 Děčín
58	Arnošt	Žák	Školní 17/31 Karlovarský kraj 381 58 Prostějov
59	Pavel	Polcrová	N. A. Někrasova 430 50 Tábor
60	Miluše	Bohušová	K Návsi 98/33 256 37 Ostrava
61	Božena	Brunclíková	Stadionová 681 53 Litoměřice
62	Arnošt	Šturmová	Na Úbočí 48/58 24216 Prostějov
63	Jiřina	Žaludová	Nad Nuslemi 27/737 66290 Příbram
64	Eva	Lorenzová	Kukelská 65670 Uherské Hradiště
65	Evženie	Polcrová	U Kamýku 7/95 Jihomoravský kraj 95727 Jihlava
66	Jiří	Ečerová	Nad Klikovkou 287 29 Sokolov
67	Alena	Dobrovolná	Hrachovská 82 Karlovarský kraj 91899 Děčín
68	Veronika	Tretter	Ruzyňská 77/393 14949 Jihlava
69	Alena	Nesslerová	N. A. Někrasova 430 50 Tábor
70	Milan	Konečný	Do Vršku 35/612 559 15 Jablonec nad Nisou
71	Leoš	Stojka	Mečíková 6/442 911 12 Karlovy Vary
72	Karel	Tretter	N. A. Někrasova 430 50 Tábor
73	Blanka	Novotná	Za Pekárnou 75 676 57 Frýdek-Místek Česká republika
74	Zlata	Konečný	Široká 15/353 933 54 Litoměřice
75	Adéla	Tománková	Na Jezerce 59956 Vsetín
76	Radim	Hubička	U Kamýku 17868 Liberec
77	Roman	Konečný	Hrachovská 82 Karlovarský kraj 91899 Děčín
78	Marie	Svoboda	Kukelská 65670 Uherské Hradiště
79	Alena	Skopečková	U Silnice 2/332 406 36 Hradec Králové
80	Karel	Rybárová	Do Vršku 35/612 559 15 Jablonec nad Nisou
81	Alena	Rounová	Kaňkova 8/92 45880 Děčín
82	Stanislav	Šlajerová	Radbuzská 8 70129 Kolín
83	Šárka	Procházková	Kaňkova 8/92 45880 Děčín
84	Jaroslava	Novotná	Pohledná Jihomoravský kraj 29446 Ústí nad Labem
85	Lukáš	Dolejší	Za Pekárnou 75 676 57 Frýdek-Místek Česká republika
86	Roman	Koudelka	Antonínská 9 89334 Vsetín
87	Zlata	Šusta	Mečíková 6/442 911 12 Karlovy Vary
88	Jindřich	Fučíková	Do Vršku 35/612 559 15 Jablonec nad Nisou
89	Tomáš	Kabelka	Rozkošného 9 06003 Děčín
90	Jaroslav	Dolejší	Kukelská 65670 Uherské Hradiště
91	Naděžda	Berková	Hrachovská 82 Karlovarský kraj 91899 Děčín
92	Josef	Katona	Do Vršku 35/612 559 15 Jablonec nad Nisou
93	Marcela	Hamplová	U Kamýku 17868 Liberec
94	Zdeněk	Bohušová	Otavova Olomoucký kraj 143 37 Frýdek-Místek
95	Evženie	Žaludová	Kaňkova 8/92 45880 Děčín
96	Mykhaylo	Žaludová	Otavova Olomoucký kraj 143 37 Frýdek-Místek
97	Renata	Hora	Nad Klikovkou 287 29 Sokolov
98	Věra	Ečerová	U Silnice 2/332 406 36 Hradec Králové
99	Miroslav	Procházková	Pohledná Jihomoravský kraj 29446 Ústí nad Labem
100	Šárka	Vrba	Do Vršku 35/612 559 15 Jablonec nad Nisou
101	Monika	Ečerová	Hrachovská 82 Karlovarský kraj 91899 Děčín
102	Jana	Ečerová	Antonínská 9 89334 Vsetín
103	Tomáš	Písařík	Stadionová 681 53 Litoměřice
104	Tomáš	Černík	Školní 17/31 Karlovarský kraj 381 58 Prostějov
105	Iva	Literová	Hrachovská 82 Karlovarský kraj 91899 Děčín
106	Lucie	Kotorová	U Silnice 9/413 719 38 Kroměříž
107	Martina	Nguyenová	Nad Klikovkou 287 29 Sokolov
108	Jindřich	Písařík	U Silnice 9/413 719 38 Kroměříž
109	Petra	Müllerová	Nad Nuslemi 27/737 66290 Příbram
110	Jakub	Vařeková	U Silnice 2/332 406 36 Hradec Králové
111	Barbora	Tománková	Za Pekárnou 75 676 57 Frýdek-Místek Česká republika
112	Tereza	Španinger	Otavova Olomoucký kraj 143 37 Frýdek-Místek
113	Jakub	Hůlková	U Silnice 2/332 406 36 Hradec Králové
114	Pavlína	Wimmer	U Silnice 2/332 406 36 Hradec Králové
115	Antonín	Černíková	Ruzyňská 77/393 14949 Jihlava
116	Kateřina	Černík	Pohledná Jihomoravský kraj 29446 Ústí nad Labem
117	Július	Müller	Nad Klikovkou 287 29 Sokolov
118	Vlasta	Vařeková	U Silnice 9/413 719 38 Kroměříž
119	Barbora	Látal	U Silnice 2/332 406 36 Hradec Králové
120	Milan	Dufková	Hrachovská 82 Karlovarský kraj 91899 Děčín
121	Július	Kučera	U Kamýku 17868 Liberec
122	Miloš	Hénik	Otavova Olomoucký kraj 143 37 Frýdek-Místek
123	Anežka	Katona	U Silnice 9/413 719 38 Kroměříž
124	Kateřina	Hubička	U Kamýku 7/95 Jihomoravský kraj 95727 Jihlava
125	Zuzana	Bolfová	Antonínská 9 89334 Vsetín
126	Antonín	Šusta	Radbuzská 8 70129 Kolín
127	Miloš	Müllerová	Kukelská 65670 Uherské Hradiště
128	Žaneta	Wildung	Široká 15/353 933 54 Litoměřice
129	Lukáš	Černíková	Nad Nuslemi 27/737 66290 Příbram
130	Iva	Hůlková	Nad Klikovkou 287 29 Sokolov
131	Iveta	Janatka	U Silnice 9/413 719 38 Kroměříž
132	Evženie	Majerová	Rozkošného 9 06003 Děčín
133	František	Svoboda	N. A. Někrasova 430 50 Tábor
134	Rudolf	Müllerová	Na Úbočí 48/58 24216 Prostějov
135	Žaneta	Kloud	Otavova Olomoucký kraj 143 37 Frýdek-Místek
136	Vlasta	Bolfová	Rozkošného 9 06003 Děčín
137	Vlasta	Kloud	Mečíková 6/442 911 12 Karlovy Vary
138	Ilona	Koudelka	U Silnice 2/332 406 36 Hradec Králové
139	Naděžda	Linková	U Silnice 2/332 406 36 Hradec Králové
140	Božena	Pokorný	N. A. Někrasova 430 50 Tábor
141	Jitka	Španinger	U Silnice 9/413 719 38 Kroměříž
142	Gabriela	Svoboda	Rozkošného 9 06003 Děčín
143	Ladislav	Hlobilová	Kukelská 65670 Uherské Hradiště
144	Simona	Vrba	Školní 17/31 Karlovarský kraj 381 58 Prostějov
145	Helena	Jeklová	Do Vršku 35/612 559 15 Jablonec nad Nisou
146	Jitka	Kovářová	Nad Nuslemi 27/737 66290 Příbram
147	Zuzana	Holásková	Do Vršku 35/612 559 15 Jablonec nad Nisou
148	Jaroslav	Řezaninová	Široká 15/353 933 54 Litoměřice
149	David	Štanglerová	Radbuzská 8 70129 Kolín
150	Leoš	Kurš	Mečíková 6/442 911 12 Karlovy Vary
151	Zdeněk	Šilar	U Silnice 2/332 406 36 Hradec Králové
152	Alena	Kloud	Antonínská 9 89334 Vsetín
153	Ivana	Rybárová	U Kamýku 17868 Liberec
154	Žaneta	Svoboda	K Návsi 98/33 256 37 Ostrava
155	Táňa	Slavík	Ruzyňská 77/393 14949 Jihlava
156	Vladislav	Brunclíková	Široká 15/353 933 54 Litoměřice
157	Iva	Pospíšek	Mečíková 6/442 911 12 Karlovy Vary
158	Martin	Hubička	Kaňkova 8/92 45880 Děčín
159	Zdeňka	Rybárová	Kaňkova 8/92 45880 Děčín
160	Pavel	Pavelková	Na Úbočí 48/58 24216 Prostějov
161	Monika	Wimmer	U Silnice 2/332 406 36 Hradec Králové
162	Ján	Žaludová	Hrachovská 82 Karlovarský kraj 91899 Děčín
163	Martin	Matochová	Mečíková 6/442 911 12 Karlovy Vary
164	Renata	Stojka	U Kamýku 17868 Liberec
165	Vladimír	Hénik	Nad Nuslemi 27/737 66290 Příbram
166	David	Wimmer	U Silnice 2/332 406 36 Hradec Králové
167	Anna	Řezaninová	K Návsi 98/33 256 37 Ostrava
168	Jarmila	Dobrovolná	Na Úbočí 48/58 24216 Prostějov
169	Zuzana	Hora	Za Pekárnou 75 676 57 Frýdek-Místek Česká republika
170	Šárka	Látal	U Silnice 2/332 406 36 Hradec Králové
171	Veronika	Hénik	Mečíková 6/442 911 12 Karlovy Vary
172	Helena	Hlobilová	Do Vršku 35/612 559 15 Jablonec nad Nisou
173	Iveta	Štanglerová	Stadionová 681 53 Litoměřice
174	Radim	Tůmová	U Kamýku 7/95 Jihomoravský kraj 95727 Jihlava
175	Věra	Matochová	Kaňkova 8/92 45880 Děčín
176	Miluše	Vančo	Nad Klikovkou 287 29 Sokolov
177	Jarmila	Kučera	Nad Nuslemi 27/737 66290 Příbram
178	Arnošt	Katona	U Kamýku 7/95 Jihomoravský kraj 95727 Jihlava
179	Vladislav	Svoboda	Radbuzská 8 70129 Kolín
180	Ivana	Žák	Za Pekárnou 75 676 57 Frýdek-Místek Česká republika
181	Andrea	Šusta	Nad Nuslemi 27/737 66290 Příbram
182	Tomáš	Zhejbal	Na Úbočí 48/58 24216 Prostějov
183	Anežka	Štanglerová	Rozkošného 9 06003 Děčín
184	Jan	Literová	Hrachovská 82 Karlovarský kraj 91899 Děčín
185	Zlata	Brichová	Za Pekárnou 75 676 57 Frýdek-Místek Česká republika
186	Zdeněk	Šturmová	Ruzyňská 77/393 14949 Jihlava
187	Miloslava	Kovářová	Kaňkova 8/92 45880 Děčín
188	Jarmila	Hůlková	Antonínská 9 89334 Vsetín
189	Helena	Matochová	U Silnice 2/332 406 36 Hradec Králové
190	Monika	Skopečková	U Silnice 9/413 719 38 Kroměříž
191	Iveta	Kovářová	K Návsi 98/33 256 37 Ostrava
192	Vlasta	Kotorová	N. A. Někrasova 430 50 Tábor
193	Dana	Cukerová	U Kamýku 7/95 Jihomoravský kraj 95727 Jihlava
194	Jana	Toman	Na Jezerce 59956 Vsetín
195	Anna	Humlová	K Návsi 98/33 256 37 Ostrava
196	Michaela	Majerová	Školní 17/31 Karlovarský kraj 381 58 Prostějov
197	Dana	Matochová	Nad Nuslemi 27/737 66290 Příbram
198	Marek	Hanušová	Otavova Olomoucký kraj 143 37 Frýdek-Místek
199	Monika	Šturmová	Kaňkova 8/92 45880 Děčín
200	Anežka	Cukerová	Ruzyňská 77/393 14949 Jihlava
\.


--
-- Name: kurz_id_kurz_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.kurz_id_kurz_seq', 78, true);


--
-- Name: lektor_id_lektor_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.lektor_id_lektor_seq', 23, true);


--
-- Name: sablona_id_sablona_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.sablona_id_sablona_seq', 12, true);


--
-- Name: stav_k_id_stav_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.stav_k_id_stav_seq', 3, true);


--
-- Name: zajemce_id_zajemce_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.zajemce_id_zajemce_seq', 200, true);


--
-- Name: kurz kurz_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.kurz
    ADD CONSTRAINT kurz_pkey PRIMARY KEY (id_kurz);


--
-- Name: lektor lektor_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.lektor
    ADD CONSTRAINT lektor_pkey PRIMARY KEY (id_lektor);


--
-- Name: sablona sablona_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.sablona
    ADD CONSTRAINT sablona_pkey PRIMARY KEY (id_sablona);


--
-- Name: stav_k stav_k_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.stav_k
    ADD CONSTRAINT stav_k_pkey PRIMARY KEY (id_stav);


--
-- Name: zajemce uq_customer; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.zajemce
    ADD CONSTRAINT uq_customer UNIQUE (jmeno, prijmeni, adresa);


--
-- Name: lektor uq_lektor; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.lektor
    ADD CONSTRAINT uq_lektor UNIQUE (jmeno, prijmeni, adresa);


--
-- Name: kompetence uq_lektor_sablona; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.kompetence
    ADD CONSTRAINT uq_lektor_sablona UNIQUE (lektor_id, sablona_id);


--
-- Name: rezervace uq_reservation; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.rezervace
    ADD CONSTRAINT uq_reservation UNIQUE (zajemce_id, sablona_id, datum);


--
-- Name: ucast uq_zajemce_kurz; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.ucast
    ADD CONSTRAINT uq_zajemce_kurz UNIQUE (zajemce_id, kurz_id);


--
-- Name: zajemce zajemce_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.zajemce
    ADD CONSTRAINT zajemce_pkey PRIMARY KEY (id_zajemce);


--
-- Name: kurz fk_akreditace; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.kurz
    ADD CONSTRAINT fk_akreditace FOREIGN KEY (sablona_id) REFERENCES public.sablona(id_sablona) ON DELETE SET DEFAULT;


--
-- Name: kompetence fk_akreditace; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.kompetence
    ADD CONSTRAINT fk_akreditace FOREIGN KEY (sablona_id) REFERENCES public.sablona(id_sablona) ON DELETE CASCADE;


--
-- Name: ucast fk_kurz; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.ucast
    ADD CONSTRAINT fk_kurz FOREIGN KEY (kurz_id) REFERENCES public.kurz(id_kurz) ON DELETE RESTRICT;


--
-- Name: kurz fk_lektor; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.kurz
    ADD CONSTRAINT fk_lektor FOREIGN KEY (lektor_id) REFERENCES public.lektor(id_lektor) ON DELETE SET DEFAULT;


--
-- Name: kompetence fk_lektor; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.kompetence
    ADD CONSTRAINT fk_lektor FOREIGN KEY (lektor_id) REFERENCES public.lektor(id_lektor) ON DELETE CASCADE;


--
-- Name: rezervace fk_sablona; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.rezervace
    ADD CONSTRAINT fk_sablona FOREIGN KEY (sablona_id) REFERENCES public.sablona(id_sablona);


--
-- Name: kurz fk_stav; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.kurz
    ADD CONSTRAINT fk_stav FOREIGN KEY (stav_id) REFERENCES public.stav_k(id_stav) ON DELETE RESTRICT;


--
-- Name: rezervace fk_zajemce; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.rezervace
    ADD CONSTRAINT fk_zajemce FOREIGN KEY (zajemce_id) REFERENCES public.zajemce(id_zajemce) ON DELETE CASCADE;


--
-- Name: ucast fk_zajemce; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.ucast
    ADD CONSTRAINT fk_zajemce FOREIGN KEY (zajemce_id) REFERENCES public.zajemce(id_zajemce) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

