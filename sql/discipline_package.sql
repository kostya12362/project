CREATE OR REPLACE PACKAGE discipline_package AS
    TYPE discipline_row IS RECORD (
        discipline_id discipline.discipline_id%TYPE,
        discipline_name discipline.discipline_name%TYPE
    );
    TYPE discipline_table IS
        TABLE OF discipline_row;
    FUNCTION get_discipline (
        p_discipline_id   IN                discipline.discipline_id%TYPE
    ) RETURN discipline_table
        PIPELINED;
    FUNCTION get_disciplines 
    RETURN discipline_table
        PIPELINED;

    FUNCTION search_discipline (
        discipline_name   IN                discipline.discipline_name%TYPE
    ) RETURN discipline_table
        PIPELINED;

    PROCEDURE add_discipline (
        status              OUT                 VARCHAR2,
        p_discipline_id     OUT                 discipline.discipline_id%TYPE,
        p_discipline_name   IN                  discipline.discipline_name%TYPE
    );

    PROCEDURE delete_discipline (
        status          OUT             VARCHAR2,
        discipline_id   IN              discipline.discipline_id%TYPE
    );

    PROCEDURE edit_discipline (
        status            OUT               VARCHAR2,
        discipline_id     IN                discipline.discipline_id%TYPE,
        discipline_name   IN                discipline.discipline_name%TYPE
    );

END discipline_package;
/


CREATE OR REPLACE PACKAGE BODY discipline_package AS

    FUNCTION get_discipline (
        p_discipline_id   IN                discipline.discipline_id%TYPE
    ) RETURN discipline_table
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                *
            FROM
                discipline
            WHERE
                discipline.discipline_id = p_discipline_id
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_discipline;
    
    FUNCTION get_disciplines 
    RETURN discipline_table
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                DISCIPLINE_ID ,
DISCIPLINE_NAME 
            FROM
                discipline
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_disciplines;

    FUNCTION search_discipline (
        discipline_name   IN                discipline.discipline_name%TYPE
    ) RETURN discipline_table
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                *
            FROM
                discipline
            WHERE
                discipline.discipline_name LIKE concat(discipline_name, '%')
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END search_discipline;

    PROCEDURE add_discipline (
        status              OUT                 VARCHAR2,
        p_discipline_id     OUT                 discipline.discipline_id%TYPE,
        p_discipline_name   IN                  discipline.discipline_name%TYPE
    ) IS
        max_id   discipline.discipline_id%TYPE;
    BEGIN
        SELECT
            MAX(discipline.discipline_id)
        INTO max_id
        FROM
            discipline;

        INSERT INTO discipline (
            discipline_id,
            discipline_name
        ) VALUES (
            max_id + 1,
            p_discipline_name
        ) RETURNING discipline_id INTO p_discipline_id;

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END add_discipline;

    PROCEDURE delete_discipline (
        status          OUT             VARCHAR2,
        discipline_id   IN              discipline.discipline_id%TYPE
    ) IS
        lesson_count   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO lesson_count
        FROM
            lesson
        WHERE
            lesson.discipline_id = discipline_id;

        IF lesson_count = 0 THEN
            DELETE FROM discipline
            WHERE
                discipline.discipline_id = discipline_id;

            COMMIT;
            status := 'OK';
        ELSE
            status := 'CANT DELETE';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END delete_discipline;

    PROCEDURE edit_discipline (
        status            OUT               VARCHAR2,
        discipline_id     IN                discipline.discipline_id%TYPE,
        discipline_name   IN                discipline.discipline_name%TYPE
    ) IS
    BEGIN
        UPDATE discipline
        SET
            discipline.discipline_name = discipline_name
        WHERE
            discipline.discipline_id = discipline_id;

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END edit_discipline;

END discipline_package;
/
