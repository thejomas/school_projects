-- foreign keys
ALTER TABLE appointment
    DROP CONSTRAINT appointment_doctor;

ALTER TABLE appointment
    DROP CONSTRAINT appointment_patient;

ALTER TABLE many2many_doctor_secretary
    DROP CONSTRAINT many2many_doctor_secretary_doctor;

ALTER TABLE many2many_doctor_secretary
    DROP CONSTRAINT many2many_doctor_secretary_secretary;

ALTER TABLE many2many_patient_doctor
    DROP CONSTRAINT many2many_patient_doctor_doctor;

ALTER TABLE many2many_patient_doctor
    DROP CONSTRAINT many2many_patient_doctor_patient;

ALTER TABLE many2many_q_qrow
    DROP CONSTRAINT many2many_questionnaire;

ALTER TABLE many2many_q_qrow
    DROP CONSTRAINT many2many_questionnaire_row;

ALTER TABLE questionnaire_answer
    DROP CONSTRAINT questionnaire_answer_patient;

ALTER TABLE questionnaire_answer
    DROP CONSTRAINT questionnaire_answer_many2many_q_qrow;

ALTER TABLE questionnaire
    DROP CONSTRAINT questionnaire_secretary;

ALTER TABLE questionnaire
    DROP CONSTRAINT questionnaire_patient;

-- tables
DROP TABLE appointment;

DROP TABLE doctor;

DROP TABLE many2many_doctor_secretary;

DROP TABLE many2many_patient_doctor;

DROP TABLE many2many_q_qrow;

DROP TABLE patient;

DROP TABLE questionnaire;

DROP TABLE questionnaire_answer;

DROP TABLE questionnaire_row;

DROP TABLE secretary;
