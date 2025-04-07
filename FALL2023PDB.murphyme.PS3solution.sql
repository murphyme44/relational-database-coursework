CREATE TABLE school (
    school_id     NUMBER(8, 0) NOT NULL,
    school_name   VARCHAR2(30) NOT NULL,
    created_by    VARCHAR2(30) NOT NULL,
    created_date  DATE NOT NULL,
    modified_by   VARCHAR2(30) NOT NULL,
    modified_date DATE NOT NULL,
    CONSTRAINT school_pk PRIMARY KEY ( school_id ) ENABLE
);

INSERT INTO school (
    school_id,
    school_name,
    created_by,
    created_date,
    modified_by,
    modified_date
) VALUES (
    1,
    'UD',
    'SYSTEM',
    TO_DATE('09-OCT-23', 'DD-MON-RR'),
    'SYSTEM',
    TO_DATE('09-OCT-23', 'DD-MON-RR')
);

ALTER TABLE course ADD (
    school_id NUMBER(8, 0)
);

ALTER TABLE course ADD (
    prerequisite_school_id NUMBER(8, 0)
);

ALTER TABLE section ADD (
    school_id NUMBER(8, 0)
);

ALTER TABLE enrollment ADD (
    school_id NUMBER(8, 0)
);

ALTER TABLE student ADD (
    school_id NUMBER(8, 0)
);

UPDATE course
SET
    school_id = 1;

UPDATE course
SET
    prerequisite_school_id = 1;

UPDATE section
SET
    school_id = 1;

UPDATE enrollment
SET
    school_id = 1;

UPDATE student
SET
    school_id = 1;

ALTER TABLE course MODIFY (
    school_id NOT NULL
);

ALTER TABLE section MODIFY (
    school_id NOT NULL
);

ALTER TABLE enrollment MODIFY (
    school_id NOT NULL
);

ALTER TABLE student MODIFY (
    school_id NOT NULL
);

--declare
--    v_sql varchar2(2000);
--cursor c_cons(cons_type_in varchar2) is
--select * from user_constraints
--where constraint_type = cons_type_in;
--begin
--    for r_cons in c_cons('R')
--    loop
--        v_sql := 'drop constraint ' || r_cons.constraint_name;
--        execute immediate v_sql;
--    end loop;
--    
--    for r_cons in c_cons('P')
--    loop
--        v_sql := 'drop constraint ' || r_cons.constraint_name;
--        execute immediate v_sql;
--    end loop;
--end;

--DROP FOREIGN KEYS

ALTER TABLE course DROP CONSTRAINT crse_crse_fk;

ALTER TABLE enrollment DROP CONSTRAINT enr_sect_fk;

ALTER TABLE enrollment DROP CONSTRAINT enr_stu_fk;

ALTER TABLE section DROP CONSTRAINT sect_crse_fk;

--DROP PRIMARY KEYS

ALTER TABLE course DROP CONSTRAINT crse_pk;

ALTER TABLE enrollment DROP CONSTRAINT enr_pk;

ALTER TABLE section DROP CONSTRAINT sect_pk;

ALTER TABLE student DROP CONSTRAINT stu_pk;

ALTER TABLE school DROP CONSTRAINT school_pk;


--ADDING KEYS

ALTER TABLE school ADD CONSTRAINT school_pk PRIMARY KEY ( school_id ) ENABLE;

ALTER TABLE course
    ADD CONSTRAINT course_pk PRIMARY KEY ( course_no,
                                           school_id ) ENABLE;

ALTER TABLE section
    ADD CONSTRAINT section_pk PRIMARY KEY ( section_id,
                                            school_id ) ENABLE;

ALTER TABLE student
    ADD CONSTRAINT student_pk PRIMARY KEY ( student_id,
                                            school_id ) ENABLE;

ALTER TABLE enrollment
    ADD CONSTRAINT enrollment_pk PRIMARY KEY ( section_id,
                                               student_id,
                                               school_id ) ENABLE;

ALTER TABLE course
    ADD CONSTRAINT course_fk1 FOREIGN KEY ( prerequisite,
                                            prerequisite_school_id )
        REFERENCES course ( course_no,
                            school_id )
    ENABLE;

ALTER TABLE section
    ADD CONSTRAINT section_fk1 FOREIGN KEY ( course_no,
                                             school_id )
        REFERENCES course ( course_no,
                            school_id )
    ENABLE;

ALTER TABLE enrollment
    ADD CONSTRAINT enrollment_fk1 FOREIGN KEY ( section_id,
                                                school_id )
        REFERENCES section ( section_id,
                             school_id )
    ENABLE;

ALTER TABLE enrollment
    ADD CONSTRAINT enrollment_fk2 FOREIGN KEY ( student_id,
                                                school_id )
        REFERENCES student ( student_id,
                             school_id )
    ENABLE;

ALTER TABLE course
    ADD CONSTRAINT course_fk2 FOREIGN KEY ( school_id )
        REFERENCES school ( school_id )
    ENABLE;

ALTER TABLE enrollment
    ADD CONSTRAINT enrollment_fk3 FOREIGN KEY ( school_id )
        REFERENCES school ( school_id )
    ENABLE;

ALTER TABLE section
    ADD CONSTRAINT section_fk2 FOREIGN KEY ( school_id )
        REFERENCES school ( school_id )
    ENABLE;

ALTER TABLE student
    ADD CONSTRAINT student_fk1 FOREIGN KEY ( school_id )
        REFERENCES school ( school_id )
    ENABLE;

CREATE OR REPLACE PROCEDURE footprint_trigger (
    table_name_in VARCHAR2
) AS
    v_sql VARCHAR2(2000);
BEGIN
    v_sql := ' CREATE OR REPLACE TRIGGER TRG02_'
             || table_name_in
             || ' BEFORE';
    v_sql := v_sql
             || ' INSERT OR UPDATE ON '
             || table_name_in;
    v_sql := v_sql || ' FOR EACH ROW ';
    v_sql := v_sql || ' BEGIN ';
    v_sql := v_sql || ' IF inserting THEN ';
    v_sql := v_sql || ' :new.created_by := user;';
    v_sql := v_sql || ' :new.created_date := sysdate;';
    v_sql := v_sql || ' END IF;';
    v_sql := v_sql || ' :new.modified_by := user;';
    v_sql := v_sql || ' :new.modified_date := sysdate;';
    v_sql := v_sql || ' END; ';
    EXECUTE IMMEDIATE v_sql;
END;
/

BEGIN
    footprint_trigger('COURSE');
    footprint_trigger('SECTION');
    footprint_trigger('STUDENT');
    footprint_trigger('ENROLLMENT');
END;
/