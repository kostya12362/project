CREATE OR REPLACE PACKAGE student_package AS
    TYPE student_row IS RECORD (
        student_id student.student_id%TYPE,
        group_id student.group_id%TYPE,
        id_code student.id_code%TYPE,
        start_date student.start_date%TYPE,
        end_date student.end_date%TYPE
    );
    TYPE student_table IS
        TABLE OF student_row;
    PROCEDURE add_student (
        status         OUT            VARCHAR2,
        p_student_id   OUT            student.student_id%TYPE,
        p_id_code      IN             student.id_code%TYPE,
        p_group_id     IN             student.group_id%TYPE,
        p_start_date   IN             student.start_date%TYPE
    );

    FUNCTION get_student (
        p_student_id   IN             student.student_id%TYPE
    ) RETURN student_table
        PIPELINED;

    FUNCTION get_student_group (
        p_group_id   IN           student.group_id%TYPE
    ) RETURN student_table
        PIPELINED;

    PROCEDURE add_end_date (
        status         OUT            VARCHAR2,
        p_student_id   IN             student.student_id%TYPE,
        p_end_date     IN             student.end_date%TYPE
    );

    PROCEDURE edit_group (
        status         OUT            VARCHAR2,
        p_student_id   IN             student.student_id%TYPE,
        p_group_id     IN             student.group_id%TYPE
    );

END student_package;
/


CREATE OR REPLACE PACKAGE BODY student_package AS

    PROCEDURE add_student (
        status         OUT            VARCHAR2,
        p_student_id   OUT            student.student_id%TYPE,
        p_id_code      IN             student.id_code%TYPE,
        p_group_id     IN             student.group_id%TYPE,
        p_start_date   IN             student.start_date%TYPE
    ) IS
        max_student_id   student.student_id%TYPE;
    BEGIN
        SELECT
            MAX(student_id)
        INTO max_student_id
        FROM
            student;

        INSERT INTO student (
            student_id,
            group_id,
            id_code,
            start_date
        ) VALUES (
            max_student_id + 1,
            p_group_id,
            p_id_code,
            TO_DATE(p_start_date, 'YYYY-MM-DD')
        ) RETURNING student_id INTO p_student_id;

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END add_student;

    FUNCTION get_student (
        p_student_id   IN             student.student_id%TYPE
    ) RETURN student_table
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                *
            FROM
                student
            WHERE
                student.student_id = p_student_id
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_student;

    FUNCTION get_student_group (
        p_group_id   IN           student.group_id%TYPE
    ) RETURN student_table
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                *
            FROM
                student
            WHERE
                student.group_id = p_group_id
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_student_group;

    PROCEDURE add_end_date (
        status         OUT            VARCHAR2,
        p_student_id   IN             student.student_id%TYPE,
        p_end_date     IN             student.end_date%TYPE
    ) IS
    BEGIN
        UPDATE student
        SET
            student.end_date = TO_DATE(p_end_date, 'YYYY-MM-DD')
        WHERE
            student.student_id = p_student_id;

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END add_end_date;

    PROCEDURE edit_group (
        status         OUT            VARCHAR2,
        p_student_id   IN             student.student_id%TYPE,
        p_group_id     IN             student.group_id%TYPE
    ) IS
    BEGIN
        UPDATE student
        SET
            student.group_id = p_group_id
        WHERE
            student.student_id = p_student_id;

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END edit_group;

END student_package;
/
