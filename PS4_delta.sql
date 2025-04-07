--Michael Murphy ps4
CREATE TABLE zipcode (
    zip           VARCHAR2(5) NOT NULL,
    city          VARCHAR2(25),
    state         CHAR(2),
    created_by    VARCHAR2(30) NOT NULL,
    created_date  DATE NOT NULL,
    modified_by   VARCHAR2(30) NOT NULL,
    modified_date DATE NOT NULL,
    CONSTRAINT zip_pk PRIMARY KEY ( zip ) ENABLE
);

--need fk from section to instructor
CREATE TABLE instructor (
    school_id      NUMBER NOT NULL,
    instructor_id  NUMBER NOT NULL,
    salutation     VARCHAR2(5),
    first_name     VARCHAR2(25) NOT NULL,
    last_name      VARCHAR2(25) NOT NULL,
    street_address VARCHAR2(50) NOT NULL,
    zip            VARCHAR2(50) NOT NULL,
    phone          VARCHAR2(15),
    created_by     VARCHAR2(30) NOT NULL,
    created_date   DATE NOT NULL,
    modified_by    VARCHAR2(30) NOT NULL,
    modified_date  DATE NOT NULL,
    CONSTRAINT instructor_pk PRIMARY KEY ( school_id,
                                           instructor_id ) ENABLE,
    CONSTRAINT instructor_fk1 FOREIGN KEY ( school_id )
        REFERENCES school ( school_id )
    ENABLE,
    CONSTRAINT instructor_fk2 FOREIGN KEY ( zip )
        REFERENCES zipcode ( zip )
    ENABLE
);

CREATE TABLE grade_conversion (
    school_id     NUMBER NOT NULL,
    letter_grade  VARCHAR2(2) NOT NULL,
    grade_point   NUMBER(3, 2) NOT NULL,
    max_grade     NUMBER(3) NOT NULL,
    min_grade     NUMBER(3) NOT NULL,
    created_by    VARCHAR2(30) NOT NULL,
    created_date  DATE NOT NULL,
    modified_by   VARCHAR2(30) NOT NULL,
    modified_date DATE NOT NULL,
    CONSTRAINT grade_conversion_pk PRIMARY KEY ( school_id,
                                                 letter_grade ) ENABLE,
    CONSTRAINT grade_conversion_fk1 FOREIGN KEY ( school_id )
        REFERENCES school ( school_id )
    ENABLE
);

CREATE TABLE grade_type (
    school_id       NUMBER NOT NULL,
    grade_type_code CHAR(2) NOT NULL,
    description     VARCHAR2(50) NOT NULL,
    created_by      VARCHAR2(30) NOT NULL,
    created_date    DATE NOT NULL,
    modified_by     VARCHAR2(30) NOT NULL,
    modified_date   DATE NOT NULL,
    CONSTRAINT grade_type_pk PRIMARY KEY ( school_id,
                                           grade_type_code ) ENABLE,
    CONSTRAINT grade_type_fk1 FOREIGN KEY ( school_id )
        REFERENCES school ( school_id )
    ENABLE
);

CREATE TABLE grade_type_weight (
    school_id              NUMBER NOT NULL,
    section_id             NUMBER(8) NOT NULL,
    grade_type_code        CHAR(2) NOT NULL,
    number_per_section     NUMBER(3) NOT NULL,
    percent_of_final_grade NUMBER(3) NOT NULL,
    drop_lowest            NUMBER(1) NOT NULL,
    created_by             VARCHAR2(30) NOT NULL,
    created_date           DATE NOT NULL,
    modified_by            VARCHAR2(30) NOT NULL,
    modified_date          DATE NOT NULL,
    CONSTRAINT grade_type_weight_pk PRIMARY KEY ( school_id,
                                                  section_id,
                                                  grade_type_code ) ENABLE,
    CONSTRAINT grade_type_weight_fk1 FOREIGN KEY ( school_id )
        REFERENCES school ( school_id )
    ENABLE,
    CONSTRAINT grade_type_weight_fk2 FOREIGN KEY ( school_id,
                                                   grade_type_code )
        REFERENCES grade_type ( school_id,
                                grade_type_code )
    ENABLE,
    CONSTRAINT grade_type_weight_fk3 FOREIGN KEY ( section_id,
                                                   school_id )
        REFERENCES section ( section_id,
                             school_id )
    ENABLE
);

CREATE TABLE grade (
    school_id             NUMBER NOT NULL,
    student_id            NUMBER(8) NOT NULL,
    section_id            NUMBER(8) NOT NULL,
    grade_type_code       CHAR(2) NOT NULL,
    grade_code_occurrence NUMBER(3) NOT NULL,
    numeric_grade         NUMBER(5, 2) NOT NULL,
    comments              CLOB,
    created_by            VARCHAR2(30) NOT NULL,
    created_date          DATE NOT NULL,
    modified_by           VARCHAR2(30) NOT NULL,
    modified_date         DATE NOT NULL,
    CONSTRAINT grade_pk PRIMARY KEY ( school_id,
                                      student_id,
                                      section_id,
                                      grade_type_code,
                                      grade_code_occurrence ) ENABLE,
    CONSTRAINT grade_fk1 FOREIGN KEY ( school_id )
        REFERENCES school ( school_id ),
    CONSTRAINT grade_fk2 FOREIGN KEY ( section_id,
                                       student_id,
                                       school_id )
        REFERENCES enrollment ( section_id,
                                student_id,
                                school_id )
    ENABLE,
    CONSTRAINT grade_fk3 FOREIGN KEY ( school_id,
                                       section_id,
                                       grade_type_code )
        REFERENCES grade_type_weight ( school_id,
                                       section_id,
                                       grade_type_code )
    ENABLE
);

--run alter table section after loading data with tables
ALTER TABLE section
    ADD CONSTRAINT section_fk3 FOREIGN KEY ( school_id,
                                             instructor_id )
        REFERENCES instructor ( school_id,
                                instructor_id )
    ENABLE;

CREATE SEQUENCE instructor_trg;

CREATE OR REPLACE TRIGGER trg02_instructor BEFORE
    INSERT ON instructor
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.created_by := user;
        :new.created_date := sysdate;
    END IF;

    :new.modified_by := user;
    :new.modified_date := sysdate;
END;
/