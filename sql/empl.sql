-- Active: 1712004257750@@127.0.0.1@5432@priklad2
CREATE TABLE zamestnec(
c_zam serial PRIMARY KEY,
jmeno VARCHAR (100) NOT NULL,
vede int check (vede <> c_zam)
);

insert into zamestnec (jmeno) values ('pepa');
insert into zamestnec (jmeno, vede) VALUES ('tonda', 1);
insert into zamestnec (jmeno, vede) VALUES ('matej', 3);
insert into zamestnec (jmeno) VALUES ('zuzka');
insert into zamestnec (jmeno, vede) VALUES ('lenka', 6);