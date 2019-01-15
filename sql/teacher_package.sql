CREATE OR REPLACE PACKAGE teacher_package AS
    TYPE teacher_row IS RECORD (
        teacher_id teacher.teacher_id%TYPE,
        id_code teacher.id_code%TYPE,
        degree teacher.degree%TYPE,
        start_date teacher.start_date%TYPE,
        end_date teacher.end_date%TYPE
    );
    TYPE teacher_table IS
        TABLE OF teacher_row;
    PROCEDURE add_teacher (
        status         OUT            VARCHAR2,
        p_id_code      IN             teacher.id_code%TYPE,
        p_degree       IN             teacher.degree%TYPE,
        p_start_date   IN             teacher.start_date%TYPE
    );

    FUNCTION get_teacher (
        p_teacher_id   IN           teacher.teacher_id%TYPE
    ) RETURN teacher_table
        PIPELINED;

    PROCEDURE add_end_date (
        status         OUT            VARCHAR2,
        p_teacher_id   IN             teacher.teacher_id%TYPE,
        p_end_date     IN             teacher.end_date%TYPE
    );

    PROCEDURE edit_degree (
        status         OUT            VARCHAR2,
        p_teacher_id   IN             teacher.teacher_id%TYPE,
        p_degree       IN             teacher.degree%TYPE
    );

END teacher_package;
/


CREATE OR REPLACE PACKAGE BODY teacher_package AS

    PROCEDURE add_teacher (
        status         OUT            VARCHAR2,
        p_id_code      IN             teacher.id_code%TYPE,
        p_degree       IN             teacher.degree%TYPE,
        p_start_date   IN             teacher.start_date%TYPE
    ) IS
        max_teacher_id   teacher.teacher_id%TYPE;
    BEGIN
        SELECT
            MAX(teacher.teacher_id)
        INTO max_teacher_id
        FROM
            teacher;

        INSERT INTO teacher (
            teacher_id,
            degree,
            id_code,
            start_date
        ) VALUES (
            max_teacher_id + 1,
            p_degree,
            p_id_code,
            TO_DATE(p_start_date, 'YYYY-MM-DD')
        );

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END add_teacher;

    FUNCTION get_teacher (
        p_teacher_id   IN           teacher.teacher_id%TYPE
    ) RETURN teacher_table
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                *
            FROM
                teacher
            WHERE
                teacher.teacher_id = p_teacher_id
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_teacher;

    PROCEDURE add_end_date (
        status         OUT            VARCHAR2,
        p_teacher_id   IN             teacher.teacher_id%TYPE,
        p_end_date     IN             teacher.end_date%TYPE
    ) IS
    BEGIN
        UPDATE teacher
        SET
            teacher.end_date = TO_DATE(p_end_date, 'YYYY-MM-DD')
        WHERE
            teacher.teacher_id = p_teacher_id;

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END add_end_date;

    PROCEDURE edit_degree (
        status         OUT            VARCHAR2,
        p_teacher_id   IN             teacher.teacher_id%TYPE,
        p_degree       IN             teacher.degree%TYPE
    ) IS
    BEGIN
        UPDATE teacher
        SET
            teacher.degree = p_degree
        WHERE
            teacher.teacher_id = p_teacher_id;

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END edit_degree;

END teacher_package;
/
