-- Doctor
INSERT INTO public.doctor(id, name)
VALUES
(1, 'Jacob Olsen'),
(2, 'Julius Heilmann');

-- Patient
INSERT INTO public.patient(cpr_nr, password, name)
VALUES
(1234567891, '$2y$12$U59..FmFDSE/evZt4aGV3.xszE0sV7kUHbQFiMvcuYR6.5nfnK0Yu', 'Søren Mulvad');

-- Secretary
INSERT INTO public.secretary(id, name)
VALUES
(1, 'Jesper Møller'),
(2, 'Mathias Heegaard');

-- Appointments
INSERT INTO public.appointment(id, date, time, doctor_id, patient_cpr_nr)
VALUES
(1, '2019-05-24', '11:00:00', 1, 1234567891),
(2, '2019-06-24', '10:00:00', 2, 1234567891),
(3, '2019-07-24', '12:00:00', 1, 1234567891);

-- Many2many_doctor_secretary
INSERT INTO public.many2many_doctor_secretary(secretary_id, doctor_id)
VALUES
(1, 1),
(2, 2);

-- Many2many_patient_doctor
INSERT INTO public.many2many_patient_doctor(patient_cpr_nr, doctor_id)
VALUES
(1234567891, 1);

-- Questionnaire
INSERT INTO public.questionnaire(id, name, deadline, filled_out, secretary_id, patient_cpr_nr)
VALUES
(1, 'First time', '2019-05-23', true, 1, 1234567891),
(2, 'Second time', '2019-06-23', false, 2, 1234567891);

-- Questionnaire row
INSERT INTO public.questionnaire_row(id, question)
VALUES
(1, 'Dato'),
(2, 'Navn'),
(3, 'CPR-nr.'),
(4, 'Har du problemer med at læse eller forstå dansk?'),
(5, 'Har du problemer med at tale, se eller høre?'),
(6, 'Årsag til at du er henvist til gynækologisk afdeling?'),
(7, 'Højde'),
(8, 'Allergier og dispositioner?'),
(9, 'Tidligere indlæggelse og sygdomme?'),
(10, 'Vægt?'),
(11, 'Har du svie ved vandladning?'),
(12, 'Lider du af blærebetændelse?'),
(13, 'Har du startbesvær ved vandladning?'),
(14, 'Har der været tilfælde, hvor du ikke kunne komme af med vandet?'),
(15, 'Hvor meget drikker du pr. døgn?'),
(16, 'Hvor mange gange i døgnet lader du vandet?'),
(17, 'Bruger du trusseindlæg/bind/bleer som følge af din ufrivillige vandladning?'),
(18, 'Lider du af ufrivillig afføring?'),
(19, 'Lider du af ufrivillig luftafgang?'),
(20, 'Har du fået fjernet livmoderen?'),
(21, 'Er du tidligere opereret for nedsynkning?'),
(22, 'Er du tidligere opereret for ufrivillig vandladning?'),
(23, 'Påvirker den ufrivillige vandladning dit seksualliv?'),
(24, 'Påvirker nedsynkningen dit seksualliv?');

-- Many2many_q_qrow
INSERT INTO public.many2many_q_qrow(id, questionnaire_id, questionnaire_row_id)
VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 4),
(5, 1 ,5),
(6, 1, 6),
(7, 1, 7),
(8, 1, 8),
(9, 1, 9),
(10, 1, 10),
(11, 2, 1),
(12, 2, 2),
(13, 2, 3),
(14, 2, 11),
(15, 2, 12),
(16, 2, 13),
(17, 2, 14),
(18, 2, 15),
(19, 2, 16),
(20, 2, 17),
(21, 2, 18),
(22, 2, 19),
(23, 2, 20),
(24, 2, 21),
(25, 2, 22),
(26, 2, 23),
(27, 2, 24);

-- Questionnaire_answer
INSERT INTO public.questionnaire_answer(value, many2many_q_qrow_id, patient_cpr_nr)
VALUES
('2019-05-20', 1, 1234567891),
('Søren Mulvad', 2, 1234567891),
('1234567891', 3, 1234567891),
('Nej', 4, 1234567891),
('Nej', 5, 1234567891),
('Ingen ved det', 6, 1234567891),
('1.82 cm', 7, 1234567891),
('Gluten', 8, 1234567891),
('Nej', 9, 1234567891),
('70 kg', 10, 1234567891),
('2019-06-22', 11, 1234567891),
('Søren Mulvad', 12, 1234567891),
('1234567891', 13, 1234567891);
