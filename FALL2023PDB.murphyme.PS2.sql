CREATE SEQUENCE course_trg START WITH 451;

CREATE SEQUENCE section_trg START WITH 157;

CREATE SEQUENCE student_trg START WITH 400;

CREATE OR REPLACE TRIGGER trg01_course BEFORE
    INSERT OR UPDATE ON course
    FOR EACH ROW
BEGIN
    IF inserting THEN
        SELECT
            course_trg.NEXTVAL
        INTO :new.course_no
        FROM
            dual;

    END IF;
    IF updating THEN
        :new.course_no := :old.course_no;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg01_SECTION BEFORE
    INSERT OR UPDATE ON SECTION
    FOR EACH ROW
BEGIN
    IF inserting THEN
        SELECT
            SECTION_trg.NEXTVAL
        INTO :new.SECTION_ID
        FROM
            dual;

    END IF;
    IF updating THEN
        :new.SECTION_ID := :old.SECTION_ID;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg01_STUDENT BEFORE
    INSERT OR UPDATE ON STUDENT
    FOR EACH ROW
BEGIN
    IF inserting THEN
        SELECT
            STUDENT_trg.NEXTVAL
        INTO :new.STUDENT_ID
        FROM
            dual;

    END IF;
    IF updating THEN
        :new.STUDENT_ID := :old.STUDENT_ID;
    END IF;
END;
/