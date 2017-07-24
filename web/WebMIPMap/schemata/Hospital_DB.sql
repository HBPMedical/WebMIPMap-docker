-----------------------
drop table if exists provenance_source;
create table provenance_source (
    id integer not null primary key,
    extracted_from varchar(32),
    extraction_method varchar(32),
    extraction_method_version varchar(16),
    anonymization_method varchar(16),
    anonymization_method_version varchar(16),
    description varchar
);
-- this table is not a real provenance, just simple book keeping
drop table if exists provenance cascade;
create table provenance (
    id integer not null primary key,
    description varchar,
    record_creation timestamp default current_timestamp,
    provenance_source_id integer references provenance_source(id),
    reference varchar(32)
);



--this table just has information for the user
create table ontologies(
    id integer not null primary key,
    name varchar(32),
    description varchar(32),
    reference varchar,
    provenance_id integer references provenance(id),
	record_creation timestamp default current_timestamp

);

--table for subjects, patients or research subjects
drop table if exists demographics cascade;
create table demographics (
	subject_id varchar(32) not null primary key,
	year_of_birth int,
	gender varchar(16),
	city varchar(32),
	country varchar(32),
    description  varchar(128),
    provenance_id integer references provenance(id),	    
	record_creation timestamp default current_timestamp
);

---------------------- tables for exam values---------------------------------
drop table if exists exam_measurements cascade;
create table exam_measurements (
	id integer primary key,
	variable_name varchar(32),	
	ontology_code varchar(10),  --references loinc(loinc_num)
	ontology_table varchar(32), 
	ontology_id integer references ontologies(id),
	unit varchar(10),
	accuracy varchar(16),
	value_range varchar(64),
	error_range varchar(64),
	result_type varchar(16),        --numeric or text
	reference_value varchar(32),
	description varchar(128),
    provenance_id integer references provenance(id),	
	record_creation timestamp default current_timestamp
);

drop table if exists exam_values cascade;
create table exam_values(
    id integer primary key,
	subject_id varchar(32) references demographics(subject_id),
	exam_measurement_id integer references exam_measurements(id),
	value varchar,
	value_type varchar(16),
	variable_name varchar(32),
	status varchar(32),             -- This is seen many times in hospitals, I have to understand if this makes sense here 
	exam_date date,
	description varchar(128),
    provenance_id integer references provenance(id),		
	record_creation timestamp default current_timestamp
	
);


----------------Tables for brain features-------------------------------
drop table if exists brain_atlases cascade;
create table brain_atlases(
	id integer primary key,
	name varchar(32),
	description varchar(128),
    provenance_id integer references provenance(id),		
	ontology_id integer references ontologies(id)
);

drop table if exists brain_anatomy_sets cascade;
create table brain_anatomy_sets(
	id integer not null primary key,
	brain_atlas_id integer references brain_atlases(id),
	subject_id varchar(32) references demographics(subject_id),
	exam_date date,
	pipeline_name varchar(64),
	pipeline_version varchar(32),
	description varchar(128),
    provenance_id integer references provenance(id),		
	record_creation timestamp default current_timestamp
);

drop table if exists brain_anatomies cascade;
create table brain_anatomies(
	subject_id varchar(32) references demographics(subject_id),
	brain_anatomy_set_id integer references brain_anatomy_sets(id),
	name varchar(64),
	brain_region_id integer, --references brain_regions(brain_region_id),
	feature_name varchar,
	tissue1_volume float,
	tissue2_volume float,
	tissue3_volume float,
	record_creation timestamp default current_timestamp,
	-- check if composite primary keys are enough or we need a id,
	-- it also can be made using brain_region_id instead of feature_name but the brain region table is not filled all the time
	primary key (brain_anatomy_set_id , name) 
);

drop table if exists brain_regions cascade;
create table brain_regions(
	id integer primary key,
	brain_atlas_id integer references brain_atlases(id),
	parent_region_id varchar(16),
	name varchar,
	description varchar(128),
	record_creation timestamp default current_timestamp
);

drop table if exists brain_scan cascade;
create table brain_scan(
	id integer primary key,
	subject_id varchar(32) references demographics(subject_id),
	brain_anatomy_set_id integer, --references brain_anatomy_sets(id),
	scan_type varchar(16),
	number_of_images integer,
	magnetic_field numeric,
	scan_machine varchar(128),
	FDG_PET float,
	PIB float,
	scan_date date,
	record_creation timestamp default current_timestamp
);

-----------------------------tables for genetic data --------------------------------
drop table if exists genetic_snp_sets cascade;
create table genetic_sets(
	genetic_set_id integer primary key,
	subject_id varchar(32) references demographics(subject_id),
	collection_date date,
    provenance_id integer references provenance(id),		
	record_creation timestamp default current_timestamp
);

drop table if exists genetic_snp cascade;
create table genetic_snp(
    id integer not null primary key,
    amino_acid1_acid2 varchar(6),
    chromosome_name varchar(4) not null,
    coding_status varchar(6),
    exon_location varchar(24),
    gene_location varchar(16) not null,
    gene_symbol varchar(40) not null,
    snp_code varchar(16) not null,
    snp_coordinate integer not null,
    provenance_id integer not null references provenance(id),
    subject_id varchar(32) not null references demographics(subject_id)
);

-----------------------------tables for diagnostics --------------------------------
drop table if exists diagnostic_info cascade;
create table diagnostic_info(
    id integer primary key,
    ontology_id integer not null,
    ontology_table varchar(64),
    description varchar(512)
);

drop table if exists diagnostics cascade;
create table diagnostics(
    id integer primary key,
	subject_id varchar(32) references demographics(subject_id),
	diagnostic_code varchar(32),
	diagnostic_type varchar(32),           --this can be PRINCIPAL / SECONDAIRE / COMPLEMENTAIRE (as in the CHUV)
	diagnostic_date date,
    diagnostic_info_id integer not null references diagnostic_info(id),
	record_creation timestamp default current_timestamp
);

--tables for icd10 diagnostics codes, 
-- more ontologies or coding 
--this should be on the federation level 
drop table if exists icd10;
create table icd10(
	diagnostic_code varchar(16) primary key, --CHUV uses ICD10-10 as standard for diagnostic codes,				
	valid_for_coding varchar(1),             --Y or N
	category  varchar(16),
	sub_category  varchar(16),
	description varchar(1024), --probably do not need both name and description
	record_creation timestamp default current_timestamp	
);


/* Tables to be reviewed 
    -- WE need to understand this type of data and know where can we get it  
    create table HBP.public.brain_function (
        id binary not null,
        brain_region varchar(64),
        rest_state float,
        task float,
        provenance_id integer not null,
        subject_id varchar(32) not null,
        record_description_id integer,
        primary key (id)
    );

    -- the same for symptoms, we need to understand better this data
    -- Also we do not have anyway to get it from our system 

    create table HBP.public.symptom (
        id binary not null,
        rating integer not null,
        severity float not null,
        class varchar(32) not null,
        subclass varchar(32),
        provenance_id integer not null,
        subject_id varchar(32) not null,
        ontology_id integer not null,
        primary key (id)
    );

    -- It looks like we could just add a direct link in exam_valuesa and diagnosis directly instead of having two more tables
    create table HBP.public.exam_value_symptom (
        examValues_id binary not null,
        symptoms_id binary not null
    );

    create table HBP.public.diagnostic_symptom (
        diagnostics_id binary not null,
        symptoms_id binary not null
    );


    create table HBP.public.record_description (
        id integer not null,
        description varchar(255) not null,
        name varchar(255) not null,
        primary key (id)
    );

    create table HBP.public.record_description_ontology (
        record_description_id integer not null,
        ontologyList_id integer not null
    );


 */
 
