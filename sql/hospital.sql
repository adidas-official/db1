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
-- Name: fn_check_cert(integer, integer); Type: FUNCTION; Schema: public; Owner: dev
--

CREATE FUNCTION public.fn_check_cert(performing_doctor_id integer, performing_operation integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM certification
        WHERE performing_doctor_id = certification.doctor_id
        AND performing_operation = certification.operation_id
    );
END;
$$;


ALTER FUNCTION public.fn_check_cert(performing_doctor_id integer, performing_operation integer) OWNER TO dev;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: certification; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.certification (
    doctor_id integer NOT NULL,
    operation_id integer NOT NULL
);


ALTER TABLE public.certification OWNER TO dev;

--
-- Name: doctor; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.doctor (
    id_doctor integer NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE public.doctor OWNER TO dev;

--
-- Name: doctor_id_doctor_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

ALTER TABLE public.doctor ALTER COLUMN id_doctor ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.doctor_id_doctor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: operation; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.operation (
    id_operation integer NOT NULL,
    title character varying(32) NOT NULL,
    op_description text
);


ALTER TABLE public.operation OWNER TO dev;

--
-- Name: operation_id_operation_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

ALTER TABLE public.operation ALTER COLUMN id_operation ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.operation_id_operation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: performing_operation; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.performing_operation (
    doctor_id integer NOT NULL,
    operation_id integer NOT NULL,
    datum date,
    CONSTRAINT can_operate CHECK (public.fn_check_cert(doctor_id, operation_id))
);


ALTER TABLE public.performing_operation OWNER TO dev;

--
-- Data for Name: certification; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.certification (doctor_id, operation_id) FROM stdin;
1	1
2	2
2	3
2	5
4	5
4	6
3	4
\.


--
-- Data for Name: doctor; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.doctor (id_doctor, name) FROM stdin;
1	Pavel Smutny
2	Martina Drobna
3	Petr Schmutz
4	Daniela Hrachova
\.


--
-- Data for Name: operation; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.operation (id_operation, title, op_description) FROM stdin;
1	Zlomenina	Vsechny ukony spojene s operovanim zlomenych koncetin a kosti
2	Transplantace	Vyjmuti poskozeneho organu a vymena za neporuseny
3	Laparoskopie	Chirurgie brisni dutiny
4	Vyjmuti zubu	Vytrzeni nemocneho zubu a osetreni rany
5	Operace kyly	Chirurgicke odstraneni a osetreni
6	Plastika prsou	Vlozeni silikonovych implantatu
7	Plastika obliceje	Uprava vzhledu podle predstav pacienta
\.


--
-- Data for Name: performing_operation; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.performing_operation (doctor_id, operation_id, datum) FROM stdin;
1	1	2024-01-04
4	6	2024-01-04
\.


--
-- Name: doctor_id_doctor_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.doctor_id_doctor_seq', 4, true);


--
-- Name: operation_id_operation_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.operation_id_operation_seq', 7, true);


--
-- Name: doctor doctor_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_pkey PRIMARY KEY (id_doctor);


--
-- Name: operation operation_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.operation
    ADD CONSTRAINT operation_pkey PRIMARY KEY (id_operation);


--
-- Name: certification uq_doctor_operation; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.certification
    ADD CONSTRAINT uq_doctor_operation UNIQUE (doctor_id, operation_id);


--
-- Name: performing_operation uq_operation; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.performing_operation
    ADD CONSTRAINT uq_operation UNIQUE (doctor_id, operation_id, datum);


--
-- Name: certification fk_doctor; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.certification
    ADD CONSTRAINT fk_doctor FOREIGN KEY (doctor_id) REFERENCES public.doctor(id_doctor) ON DELETE CASCADE;


--
-- Name: performing_operation fk_doctor_id; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.performing_operation
    ADD CONSTRAINT fk_doctor_id FOREIGN KEY (doctor_id) REFERENCES public.doctor(id_doctor);


--
-- Name: certification fk_operation; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.certification
    ADD CONSTRAINT fk_operation FOREIGN KEY (operation_id) REFERENCES public.operation(id_operation) ON DELETE CASCADE;


--
-- Name: performing_operation fk_operation_id; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.performing_operation
    ADD CONSTRAINT fk_operation_id FOREIGN KEY (operation_id) REFERENCES public.operation(id_operation);


--
-- PostgreSQL database dump complete
--

