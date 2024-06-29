-- Active: 1712004257750@@127.0.0.1@5432@tojz
DROP TABLE zajemce;
delete from zajemce;
delete from lektor;

drop table lektor;
DROP TABLE sablona;
delete from sablona;
DROP TABLE stav_k;
delete from stav_k;

drop table kurz;
drop table kompetence;
delete from kurz;
drop Table rezervace;

alter table rezervace drop constraint fk_kurz;
delete from rezervace;
alter table rezervace add constraint fk_sablona FOREIGN KEY (sablona_id) REFERENCES sablona(id_sablona);