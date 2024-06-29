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

CREATE TABLE public.lektor (
    id_lektor integer NOT NULL,
    jmeno character varying(255) NOT NULL,
    prijmeni character varying(255) NOT NULL,
    adresa character varying(255) NOT NULL
);

ALTER TABLE public.lektor ALTER COLUMN id_lektor ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.lektor_id_lektor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.kompetence (
    lektor_id integer NOT NULL,
    sablona_id integer NOT NULL
);

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

ALTER TABLE public.kurz ALTER COLUMN id_kurz ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kurz_id_kurz_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

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

CREATE TABLE public.zajemce (
    id_zajemce integer NOT NULL,
    jmeno character varying(255) NOT NULL,
    prijmeni character varying(255) NOT NULL,
    adresa character varying(255) NOT NULL
);

ALTER TABLE public.zajemce ALTER COLUMN id_zajemce ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.zajemce_id_zajemce_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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

CREATE TABLE public.rezervace (
    zajemce_id integer NOT NULL,
    sablona_id integer NOT NULL,
    datum date DEFAULT CURRENT_DATE
);


CREATE TABLE public.sablona (
    id_sablona integer NOT NULL,
    nazev character varying(255) NOT NULL
);


ALTER TABLE public.sablona ALTER COLUMN id_sablona ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sablona_id_sablona_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

SET default_tablespace = '';

SET default_table_access_method = heap;

CREATE TABLE public.stav_k (
    id_stav integer NOT NULL,
    popis character varying(255) NOT NULL
);

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

SELECT pg_catalog.setval('public.kurz_id_kurz_seq', 78, true);

SELECT pg_catalog.setval('public.lektor_id_lektor_seq', 23, true);

SELECT pg_catalog.setval('public.sablona_id_sablona_seq', 12, true);

SELECT pg_catalog.setval('public.stav_k_id_stav_seq', 3, true);

SELECT pg_catalog.setval('public.zajemce_id_zajemce_seq', 200, true);

ALTER TABLE ONLY public.kurz
    ADD CONSTRAINT kurz_pkey PRIMARY KEY (id_kurz);

ALTER TABLE ONLY public.lektor
    ADD CONSTRAINT lektor_pkey PRIMARY KEY (id_lektor);

ALTER TABLE ONLY public.sablona
    ADD CONSTRAINT sablona_pkey PRIMARY KEY (id_sablona);

ALTER TABLE ONLY public.stav_k
    ADD CONSTRAINT stav_k_pkey PRIMARY KEY (id_stav);

ALTER TABLE ONLY public.zajemce
    ADD CONSTRAINT uq_customer UNIQUE (jmeno, prijmeni, adresa);

ALTER TABLE ONLY public.lektor
    ADD CONSTRAINT uq_lektor UNIQUE (jmeno, prijmeni, adresa);

ALTER TABLE ONLY public.kompetence
    ADD CONSTRAINT uq_lektor_sablona UNIQUE (lektor_id, sablona_id);

ALTER TABLE ONLY public.rezervace
    ADD CONSTRAINT uq_reservation UNIQUE (zajemce_id, sablona_id, datum);

ALTER TABLE ONLY public.ucast
    ADD CONSTRAINT uq_zajemce_kurz UNIQUE (zajemce_id, kurz_id);

ALTER TABLE ONLY public.zajemce
    ADD CONSTRAINT zajemce_pkey PRIMARY KEY (id_zajemce);

ALTER TABLE ONLY public.kurz
    ADD CONSTRAINT fk_akreditace FOREIGN KEY (sablona_id) REFERENCES public.sablona(id_sablona) ON DELETE SET DEFAULT;

ALTER TABLE ONLY public.kompetence
    ADD CONSTRAINT fk_akreditace FOREIGN KEY (sablona_id) REFERENCES public.sablona(id_sablona) ON DELETE CASCADE;

ALTER TABLE ONLY public.ucast
    ADD CONSTRAINT fk_kurz FOREIGN KEY (kurz_id) REFERENCES public.kurz(id_kurz) ON DELETE RESTRICT;

ALTER TABLE ONLY public.kurz
    ADD CONSTRAINT fk_lektor FOREIGN KEY (lektor_id) REFERENCES public.lektor(id_lektor) ON DELETE SET DEFAULT;

ALTER TABLE ONLY public.kompetence
    ADD CONSTRAINT fk_lektor FOREIGN KEY (lektor_id) REFERENCES public.lektor(id_lektor) ON DELETE CASCADE;

ALTER TABLE ONLY public.rezervace
    ADD CONSTRAINT fk_sablona FOREIGN KEY (sablona_id) REFERENCES public.sablona(id_sablona);

ALTER TABLE ONLY public.kurz
    ADD CONSTRAINT fk_stav FOREIGN KEY (stav_id) REFERENCES public.stav_k(id_stav) ON DELETE RESTRICT;

ALTER TABLE ONLY public.rezervace
    ADD CONSTRAINT fk_zajemce FOREIGN KEY (zajemce_id) REFERENCES public.zajemce(id_zajemce) ON DELETE CASCADE;

ALTER TABLE ONLY public.ucast
    ADD CONSTRAINT fk_zajemce FOREIGN KEY (zajemce_id) REFERENCES public.zajemce(id_zajemce) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

