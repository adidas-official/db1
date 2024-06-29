-- Active: 1712004257750@@127.0.0.1@5432@hospital
CREATE TABLE doctor (id_doctor
    INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(64) NOT NULL,
    PRIMARY KEY (id_doctor));
CREATE Table operation (
    id_operation INT GENERATED ALWAYS AS IDENTITY,
    title VARCHAR(32) NOT NULL,
    op_description TEXT,
    PRIMARY KEY (id_operation));

CREATE Table certification (
    doctor_id INT NOT NULL,
    operation_id INT NOT NULL,
    constraint fk_doctor
        Foreign Key (doctor_id) REFERENCES doctor(id_doctor) ON DELETE CASCADE,
    CONSTRAINT fk_operation
        Foreign Key (operation_id) REFERENCES operation(id_operation) ON DELETE CASCADE,
    constraint uq_doctor_operation
        UNIQUE (doctor_id, operation_id)
);
CREATE Table pacient (
    id_pacient generated always as identity,
    name varchar(64) not null,
    insurance_code INT NOT NULL,
    PRIMARY KEY (id_pacient)
);
CREATE Table insurance (
    id_insurance INT NOT NULL,
    title VARCHAR(32) NOT NULL,
    PRIMARY KEY (id_insurance)
);
CREATE Table insurance_covers (
    operation_id INT NOT NULL,
    insurance_id INT NOT NULL,
    CONSTRAINT fk_operation
        Foreign Key (operation_id)
        REFERENCES operation(id_operation) ON DELETE CASCADE,
    CONSTRAINT fk_insurance
        Foreign Key (insurance_id)
        REFERENCES insurance(id_insurance) ON DELETE CASCADE,
    CONSTRAINT uq_operation_insurance
        UNIQUE (operation_id, insurance_id)
);
CREATE Table performing_operation (
    doctor_id INT NOT NULL,
    operation_id INT NOT NULL,
    datum DATE,
    CONSTRAINT fk_doctor_id
        Foreign Key (doctor_id) REFERENCES doctor(id_doctor),
    CONSTRAINT fk_operation_id
        Foreign Key (operation_id) REFERENCES operation(id_operation),
    CONSTRAINT can_operate
        CHECK ( fn_check_cert(doctor_id, operation_id) ),
    CONSTRAINT uq_operation
        UNIQUE (doctor_id, operation_id, datum)
);

CREATE OR REPLACE FUNCTION fn_check_cert(performing_doctor_id INT, performing_operation INT)
RETURNS BOOL
as
$$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM certification
        WHERE performing_doctor_id = certification.doctor_id
        AND performing_operation = certification.operation_id
    );
END;
$$
LANGUAGE PLPGSQL;

select fn_check_cert(3, 4);