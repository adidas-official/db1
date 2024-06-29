-- Active: 1712004257750@@127.0.0.1@5432@tojz
CREATE TABLE lektor (
    id_lektor INT GENERATED ALWAYS AS IDENTITY,
    jmeno VARCHAR(255) NOT NULL,
    prijmeni VARCHAR(255) NOT NULL,
    adresa VARCHAR(255) NOT NULL,
    PRIMARY KEY(id_lektor)
);

ALTER TABLE lektor ADD constraint uq_lektor UNIQUE (jmeno, prijmeni, adresa);

CREATE TABLE sablona (
    id_sablona INT GENERATED ALWAYS AS IDENTITY,
    nazev VARCHAR(255) NOT NULL,
    PRIMARY KEY(id_sablona)
);

CREATE TABLE kompetence (
    lektor_id INT NOT NULL,
    sablona_id INT NOT NULL,
    CONSTRAINT fk_lektor
        Foreign Key (lektor_id) REFERENCES lektor(id_lektor) ON DELETE CASCADE,
    CONSTRAINT fk_akreditace
        Foreign Key (sablona_id) REFERENCES sablona(id_sablona) ON DELETE CASCADE,
    CONSTRAINT uq_lektor_sablona UNIQUE (lektor_id, sablona_id)
);


CREATE Table stav_k (
    id_stav INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    popis VARCHAR(255) NOT NULL
);

CREATE TABLE kurz (
    id_kurz INT GENERATED ALWAYS AS IDENTITY,
    delka INT NOT NULL,
    datum DATE NOT NULL,
    misto VARCHAR(255) NOT NULL,
    cena DECIMAL(8, 2) NOT NULL,
    sablona_id INT NOT NULL DEFAULT 1,
    lektor_id INT NOT NULL DEFAULT 1,
    stav_id INT NOT NULL DEFAULT 1,
    PRIMARY KEY(id_kurz),
    CONSTRAINT fk_akreditace
        FOREIGN KEY (sablona_id)
        REFERENCES sablona(id_sablona)
        ON DELETE SET DEFAULT, -- akreditace id = 1 bude mit hodnotu "ceka na vytvoreni"
    CONSTRAINT fk_lektor
        FOREIGN KEY (lektor_id)
        REFERENCES lektor(id_lektor)
        ON DELETE SET DEFAULT, -- lektor id = 1 bude mit hodnotu "suplujici"
    CONSTRAINT fk_stav
        FOREIGN KEY (stav_id)
        REFERENCES stav_k(id_stav)
        ON DELETE RESTRICT,
    CONSTRAINT ch_kompetence
        CHECK ( fn_check_kompetence (lektor_id, sablona_id) ),
    CONSTRAINT ch_date
        CHECK (datum > CURRENT_DATE)
);

CREATE TABLE zajemce (
    id_zajemce INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    jmeno VARCHAR(255) NOT NULL,
    prijmeni VARCHAR(255) NOT NULL,
    adresa VARCHAR(255) NOT NULL,
    CONSTRAINT uq_customer
        UNIQUE (jmeno, prijmeni, adresa)
);

CREATE Table rezervace (
    zajemce_id INT NOT NULL,
    sablona_id INT NOT NULL,
    datum DATE DEFAULT CURRENT_DATE,
    CONSTRAINT fk_zajemce
        Foreign Key (zajemce_id)
        REFERENCES zajemce(id_zajemce)
        ON DELETE CASCADE,
    CONSTRAINT fk_sablona
        Foreign Key (sablona_id)
        REFERENCES sablona(id_sablona)
        ON DELETE CASCADE,
    CONSTRAINT uq_reservation
        UNIQUE (zajemce_id, sablona_id, datum)
);

CREATE Table ucast (
    kurz_id INT NOT NULL, -- constraint kurz_id + zajemce_id v rezervaci
    zajemce_id INT NOT NULL,
    certifikat VARCHAR(255) NOT NULL,
    uhrada DATE NOT NULL, -- constraint nez zacne kurz
    CONSTRAINT fk_kurz
        Foreign Key (kurz_id)
        REFERENCES kurz(id_kurz)
        ON DELETE RESTRICT,
    CONSTRAINT fk_zajemce
        Foreign Key (zajemce_id)
        REFERENCES zajemce(id_zajemce)
        ON DELETE CASCADE,
    CONSTRAINT uq_zajemce_kurz
        UNIQUE (zajemce_id, kurz_id),
    CONSTRAINT ch_paid
        CHECK ( uhrada < fn_kurz_started(kurz_id))
);
