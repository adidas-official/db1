-- Active: 1712004257750@@127.0.0.1@5432@tojz
CREATE OR REPLACE FUNCTION fn_check_kompetence(fn_lektor_id INT, fn_sablona_id INT)
RETURNS BOOL
AS
$$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM kompetence
        JOIN lektor ON fn_lektor_id = lektor.id_lektor
        JOIN sablona ON fn_sablona_id = sablona.id_sablona
        WHERE fn_lektor_id = lektor.id_lektor
        AND fn_sablona_id = sablona.id_sablona
    );
END;
$$
LANGUAGE PLPGSQL;

-- CREATE OR REPLACE FUNCTION fn_check_kompetence_template(fn_lektor_id INT, fn_kurz_id INT)
-- RETURNS BOOL
-- AS
-- $$
-- BEGIN
--     RETURN EXISTS (
--         SELECT 1 FROM kompetence
--         JOIN lektor ON fn_lektor_id = lektor.id_lektor
--         JOIN sablona ON fn_kurz_id = sablona.id_sablona
--         WHERE fn_lektor_id = lektor.id_lektor
--         AND fn_sablona_id = sablona.id_sablona
--     );
-- END;
-- $$
-- LANGUAGE PLPGSQL;

-- CREATE OR REPLACE FUNCTION fn_date_kurz(fn_date DATE, fn_kurz_id INT)
-- RETURNS BOOL
-- AS
-- $$
-- BEGIN
--     RETURN EXISTS (
--         SELECT 1 from kurz
--         WHERE fn_kurz_id = id_kurz
--         AND fn_date = datum
--     );
-- END
-- $$
-- LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION fn_kurz_started(fn_kurz_id INT)
RETURNS DATE
AS
$$
DECLARE
    kurz_date DATE;
BEGIN
    SELECT datum INTO kurz_date FROM kurz
    WHERE fn_kurz_id = id_kurz;
    RETURN kurz_date;
END
$$
LANGUAGE PLPGSQL;

-- CREATE OR REPLACE FUNCTION fn_reserved(var_kurz_id INT, var_zajemce_id INT)
-- RETURNS BOOL
-- AS
-- $$
-- BEGIN
--     RETURN EXISTS (
--         SELECT 1 FROM rezervace
--         WHERE zajemce_id = var_zajemce_id
--         AND var_kurz_id = var_kurz_id
--     );
-- END
-- $$
-- LANGUAGE PLPGSQL;