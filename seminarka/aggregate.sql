-- Active: 1712004257750@@127.0.0.1@5432@tojz
select count(*) from kurz;

select * from zajemce;

select * from ucast;

select avg(cena)/avg(delka) from kurz
join ucast on ucast.kurz_id = kurz.id_kurz
join zajemce on zajemce.id_zajemce = ucast.zajemce_id
join sablona on kurz.sablona_id = sablona.id_sablona
where sablona_id = 3;

select jmeno, prijmeni, count(*)
from ucast
join kurz on kurz.id_kurz = ucast.kurz_id
join lektor on kurz.lektor_id = lektor.id_lektor
GROUP BY id_lektor
having count(*) > 2
ORDER BY count(*) DESC;

select kurz_id, count(*)
from ucast
GROUP BY kurz_id;

select lektor.jmeno, lektor.prijmeni, count(*)
from lektor
join kurz on kurz.lektor_id = lektor.id_lektor
join ucast on kurz.id_kurz = ucast.kurz_id
GROUP BY lektor.id_lektor
ORDER BY count(*) DESC;

select zajemce_id, id_kurz, kurz.datum
from rezervace
join sablona on sablona.id_sablona = rezervace.sablona_id
join kurz on sablona.id_sablona = kurz.sablona_id;

