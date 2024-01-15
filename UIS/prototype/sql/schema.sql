-- Table: appointment
CREATE TABLE IF NOT EXISTS appointment (
    id serial  NOT NULL,
    date date  NOT NULL,
    time time  NOT NULL,
    doctor_id int  NOT NULL,
    patient_cpr_nr int  NOT NULL,
    CONSTRAINT appointment_pk PRIMARY KEY (id)
);

-- Table: doctor
CREATE TABLE IF NOT EXISTS doctor (
    id serial  NOT NULL,
    name varchar  NOT NULL,
    CONSTRAINT doctor_pk PRIMARY KEY (id)
);

-- Table: many2many_doctor_secretary
CREATE TABLE IF NOT EXISTS many2many_doctor_secretary (
    secretary_id int  NOT NULL,
    doctor_id int  NOT NULL,
    CONSTRAINT many2many_doctor_secretary_pk PRIMARY KEY (secretary_id,doctor_id)
);

-- Table: many2many_patient_doctor
CREATE TABLE many2many_patient_doctor (
    patient_cpr_nr int  NOT NULL,
    doctor_id int  NOT NULL,
    CONSTRAINT many2many_patient_doctor_pk PRIMARY KEY (patient_cpr_nr,doctor_id)
);

-- Table: many2many_q_qrow
CREATE TABLE IF NOT EXISTS many2many_q_qrow (
    id serial  NOT NULL,
    questionnaire_id int  NOT NULL,
    questionnaire_row_id int  NOT NULL,
    CONSTRAINT many2many_q_qrow_pk PRIMARY KEY (id)
);

-- Table: patient
CREATE TABLE IF NOT EXISTS patient (
    cpr_nr int  NOT NULL,
    password varchar(120),
    name varchar  NOT NULL,
    CONSTRAINT patient_pk PRIMARY KEY (cpr_nr)
);

-- Table: questionnaire
CREATE TABLE IF NOT EXISTS questionnaire (
    id serial  NOT NULL,
    name varchar  NOT NULL,
    deadline date NOT NULL,
    filled_out boolean  NOT NULL,
    secretary_id int  NOT NULL,
    patient_cpr_nr int  NOT NULL,
    CONSTRAINT questionnaire_pk PRIMARY KEY (id)
);

-- Table: questionnaire_answer
CREATE TABLE IF NOT EXISTS questionnaire_answer (
    value varchar  NOT NULL,
    many2many_q_qrow_id int  NOT NULL,
    patient_cpr_nr int  NOT NULL,
    CONSTRAINT questionnaire_answer_pk PRIMARY KEY (many2many_q_qrow_id, patient_cpr_nr)
);

-- Table: questionnaire_row
CREATE TABLE IF NOT EXISTS questionnaire_row (
    id serial  NOT NULL,
    question varchar  NOT NULL,
    CONSTRAINT questionnaire_row_pk PRIMARY KEY (id)
);

-- Table: secretary
CREATE TABLE IF NOT EXISTS secretary (
    id serial  NOT NULL,
    name varchar  NOT NULL,
    CONSTRAINT secretary_pk PRIMARY KEY (id)
);

-- foreign keys
-- Reference: many2many_doctor_secretary_doctor (table: many2many_doctor_secretary)
ALTER TABLE many2many_doctor_secretary ADD CONSTRAINT many2many_doctor_secretary_doctor
    FOREIGN KEY (doctor_id)
    REFERENCES doctor (id)
;

-- Reference: many2many_doctor_secretary_secretary (table: many2many_doctor_secretary)
ALTER TABLE many2many_doctor_secretary ADD CONSTRAINT many2many_doctor_secretary_secretary
    FOREIGN KEY (secretary_id)
    REFERENCES secretary (id)
;

-- Reference: many2many_patient_doctor_doctor (table: many2many_patient_doctor)
ALTER TABLE many2many_patient_doctor ADD CONSTRAINT many2many_patient_doctor_doctor
    FOREIGN KEY (doctor_id)
    REFERENCES doctor (id)
;

-- Reference: many2many_patient_doctor_patient (table: many2many_patient_doctor)
ALTER TABLE many2many_patient_doctor ADD CONSTRAINT many2many_patient_doctor_patient
    FOREIGN KEY (patient_cpr_nr)
    REFERENCES patient (cpr_nr)
;

-- Reference: appointment_doctor (table: appointment)
ALTER TABLE appointment ADD CONSTRAINT appointment_doctor
    FOREIGN KEY (doctor_id)
    REFERENCES doctor (id)
;

-- Reference: appointment_patient (table: appointment)
ALTER TABLE appointment ADD CONSTRAINT appointment_patient
    FOREIGN KEY (patient_cpr_nr)
    REFERENCES patient (cpr_nr)
;

-- Reference: many2many_questionnaire (table: many2many_q_qrow)
ALTER TABLE many2many_q_qrow ADD CONSTRAINT many2many_questionnaire
    FOREIGN KEY (questionnaire_id)
    REFERENCES questionnaire (id)
;

-- Reference: many2many_questionnaire_row (table: many2many_q_qrow)
ALTER TABLE many2many_q_qrow ADD CONSTRAINT many2many_questionnaire_row
    FOREIGN KEY (questionnaire_row_id)
    REFERENCES questionnaire_row (id)
;

-- Reference: questionnaire_answer_patient (table: questionnaire_answer)
ALTER TABLE questionnaire_answer ADD CONSTRAINT questionnaire_answer_patient
    FOREIGN KEY (patient_cpr_nr)
    REFERENCES patient (cpr_nr)
;

-- Reference: questionnaire_answer_questionnaire_row (table: questionnaire_answer)
ALTER TABLE questionnaire_answer ADD CONSTRAINT questionnaire_answer_many2many_q_qrow
    FOREIGN KEY (many2many_q_qrow_id)
    REFERENCES many2many_q_qrow (id)
;

-- Reference: questionnaire_secretary (table: questionnaire)
ALTER TABLE questionnaire ADD CONSTRAINT questionnaire_secretary
    FOREIGN KEY (secretary_id)
    REFERENCES secretary (id)
;

ALTER TABLE questionnaire ADD CONSTRAINT questionnaire_patient
    FOREIGN KEY (patient_cpr_nr)
    REFERENCES patient (cpr_nr)
;
