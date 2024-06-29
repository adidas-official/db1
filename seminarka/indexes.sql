-- Active: 1712004257750@@127.0.0.1@5432@tojz
CREATE INDEX idx_Kurzakreditace ON kurz(akreditace_id);
CREATE INDEX idx_KurzLektor ON kurz(lektor_id);
CREATE INDEX idx_KurzStav ON kurz(stav_id);

DROP INDEX idx_Kurzakreditace;
DROP INDEX idx_KurzLektor;
DROP INDEX idx_KurzStav;

CREATE INDEX idx_akreditace on akreditace(id_akreditace);
CREATE INDEX idx_lektor on lektor(id_lektor)