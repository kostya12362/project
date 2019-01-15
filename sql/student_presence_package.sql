CREATE OR REPLACE PACKAGE student_presence_package AS
    TYPE student_presence_row IS RECORD (
        student_presence_id student_presence.student_presence_id%TYPE,
        lesson_id student_presence.lesson_id%TYPE,
        student_id student_presence.student_id%TYPE,
        lesson_date student_presence.lesson_date%TYPE
    );
    TYPE student_presence_table IS
        TABLE OF student_presence_row;
 
    FUNCTION add_student_presence (
        p_lesson_id     IN            student_presence.lesson_id%TYPE,
        p_student_id    IN            student_presence.student_id%TYPE,
        p_lesson_date   IN            student_presence.lesson_date%TYPE
    ) RETURN NUMBER;


    FUNCTION delete_student_presence (
        p_student_presence_id   IN                    student_presence.student_presence_id%TYPE
    ) RETURN NUMBER ;



END student_presence_package;
/


CREATE OR REPLACE PACKAGE BODY student_presence_package AS

    FUNCTION add_student_presence (
        p_lesson_id     IN            student_presence.lesson_id%TYPE,
        p_student_id    IN            student_presence.student_id%TYPE,
        p_lesson_date   IN            student_presence.lesson_date%TYPE
    ) RETURN NUMBER
    is
    max_id student_presence.student_presence_id%TYPE ;
    begin
      SELECT
            MAX(student_presence.student_presence_id)
        INTO max_id
        FROM
            student_presence;
            
        insert into student_presence(student_presence_id ,LESSON_ID, STUDENT_ID, lesson_date)
    VALUES (max_id + 1 ,p_LESSON_ID, p_STUDENT_ID, TO_DATE(p_lesson_date));
    commit;
        return(0);
    EXCEPTION
        WHEN OTHERS THEN
            return(-1);

    end add_student_presence;


    FUNCTION delete_student_presence (
        p_student_presence_id   IN                    student_presence.student_presence_id%TYPE
    ) RETURN NUMBER IS
    BEGIN

                    DELETE FROM student_presence
        WHERE
            student_presence.student_presence_id = p_student_presence_id;

        COMMIT;
            return(0);
 EXCEPTION
        WHEN OTHERS THEN
            return(-1);
        END delete_student_presence;



END student_presence_package;
/
