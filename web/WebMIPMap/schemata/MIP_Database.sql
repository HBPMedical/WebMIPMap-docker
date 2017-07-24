CREATE TABLE exams (
  patient_id varchar(45) NOT NULL references patients(id),
  exam_measurement varchar(45) DEFAULT NULL,
  exam_value varchar(45) DEFAULT NULL,
  exam_date date DEFAULT NULL,
  extraction_method varchar(45) DEFAULT NULL,
  record_creation datetime DEFAULT NULL
);

CREATE TABLE patients (
  id varchar(45) NOT NULL,
  name varchar(45) DEFAULT NULL,
  gender varchar(45) DEFAULT NULL,
  year_of_birth int(4) DEFAULT NULL,
  extraction_method varchar(45) DEFAULT NULL,
  PRIMARY KEY (id)
);


