-- Active: 1712004257750@@127.0.0.1@5432@hospital
-- Doctors start
INSERT INTO doctor (name) VALUES ('Pavel Smutny');
INSERT INTO doctor (name) VALUES ('Martina Drobna');
INSERT INTO doctor (name) VALUES ('Petr Schmutz');
INSERT INTO doctor (name) VALUES ('Daniela Hrachova');
-- Doctors end

-- operations start
INSERT INTO operation (title, op_description)
VALUES ('Zlomenina', 'Vsechny ukony spojene s operovanim zlomenych koncetin a kosti');
INSERT INTO operation (title, op_description)
VALUES ('Transplantace', 'Vyjmuti poskozeneho organu a vymena za neporuseny');

INSERT INTO operation (title, op_description)
VALUES ('Laparoskopie', 'Chirurgie brisni dutiny');
INSERT INTO operation (title, op_description)
VALUES ('Vyjmuti zubu', 'Vytrzeni nemocneho zubu a osetreni rany');
INSERT INTO operation (title, op_description)
VALUES ('Operace kyly', 'Chirurgicke odstraneni a osetreni');
INSERT INTO operation (title, op_description)
VALUES ('Plastika obliceje', 'Uprava vzhledu podle predstav pacienta');
INSERT INTO operation (title, op_description)
VALUES ('Plastika prsou', 'Vlozeni silikonovych implantatu');
-- operations end

-- certification start
INSERT INTO certification (doctor_id, operation_id) VALUES (1, 1); -- zlomenina
INSERT INTO certification (doctor_id, operation_id) VALUES (2, 2); -- chirurgie
INSERT INTO certification (doctor_id, operation_id) VALUES (2, 3); -- chirurgie
INSERT INTO certification (doctor_id, operation_id) VALUES (2, 5); -- chirurgie
INSERT INTO certification (doctor_id, operation_id) VALUES (3, 4); -- zubar
INSERT INTO certification (doctor_id, operation_id) VALUES (4, 5); -- plastiky
INSERT INTO certification (doctor_id, operation_id) VALUES (4, 6); -- platiky
-- certification end

-- permorming operation start
INSERT INTO performing_operation (doctor_id, operation_id, datum)
VALUES (4, 6, '1-4-2024');
-- permorming operation end
