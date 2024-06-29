-- Active: 1712004257750@@127.0.0.1@5432@tojz

-- stav
INSERT INTO stav_k (popis) VALUES ('pripravovano');
INSERT INTO stav_k (popis) VALUES ('realizovano');
INSERT INTO stav_k (popis) VALUES ('zruseno');
-- end stav

-- kurz
INSERT INTO kurz (delka, datum, misto, cena, sablona_id, lektor_id) VALUES (200, '6-3-2024', 'Praha 8', 50000.00, 1, 2);
INSERT INTO kurz (delka, datum, misto, cena, sablona_id, lektor_id) VALUES (100, '5-9-2024', 'Praha 1', 15000.00, 2, 1);
INSERT INTO kurz (delka, datum, misto, cena, sablona_id, lektor_id) VALUES (200, '8-1-2024', 'Praha 8', 45000.00, 1, 1);
-- end kurz

-- akreditace
INSERT INTO sablona (nazev) values ('html');
INSERT INTO sablona (nazev) values ('c++');
INSERT INTO sablona (nazev) values ('sql');
INSERT INTO sablona (nazev) values ('animation');
-- akreditace end

-- lektor
insert into lektor (jmeno, prijmeni, adresa) values ('Dominik', 'Ryba', 'Kratka 54, Praha 8');
insert into lektor (jmeno, prijmeni, adresa) values ('Klára', 'Berková', 'Otavova Olomoucký kraj 143 37 Frýdek-Místek');

-- lektor end

insert into ucast (kurz_id, zajemce_id, certifikat, uhrada) values (
    4, 12, '2024-06-12-certifikat.pdf', '2024-05-16'
);

select * from kurz join sablona on kurz.sablona_id = sablona.id_sablona join rezervace on rezervace.sablona_id = sablona.id_sablona join zajemce on zajemce.id_zajemce = rezervace.zajemce_id where kurz.stav_id = 1;