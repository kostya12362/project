CREATE OR REPLACE PACKAGE group_package AS
    TYPE group_row IS RECORD (
        group_id student_group.group_id%TYPE,
        group_name student_group.group_name%TYPE
    );
    TYPE group_table IS
        TABLE OF group_row;
    FUNCTION get_group (
        p_group_id   IN           student_group.group_id%TYPE
    ) RETURN group_table
        PIPELINED;
            
    FUNCTION get_groups
     RETURN group_table
        PIPELINED;

    FUNCTION search_group (
        p_group_name   IN             student_group.group_name%TYPE
    ) RETURN group_table
        PIPELINED;

    PROCEDURE add_group (
        status         OUT            VARCHAR2,
        p_group_id     OUT            student_group.group_id%TYPE,
        p_group_name   IN             student_group.group_name%TYPE
    );

    PROCEDURE delete_group (
        status       OUT          VARCHAR2,
        p_group_id   IN           student_group.group_id%TYPE
    );

    PROCEDURE edit_group (
        status       OUT          VARCHAR2,
        p_group_id     IN           student_group.group_id%TYPE,
        p_group_name   IN           student_group.group_name%TYPE
    );

END group_package;
/


CREATE OR REPLACE PACKAGE BODY group_package AS

    FUNCTION get_group (
        p_group_id   IN           student_group.group_id%TYPE
    ) RETURN group_table
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                GROUP_ID ,
                GROUP_NAME 
            FROM
                student_group
            WHERE
                student_group.group_id = p_group_id
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_group;
    
     FUNCTION get_groups
     RETURN group_table
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                GROUP_ID ,
                GROUP_NAME 
            FROM
                student_group
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_groups;

    FUNCTION search_group (
        p_group_name   IN             student_group.group_name%TYPE
    ) RETURN group_table
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                *
            FROM
                student_group
            WHERE
                student_group.group_name LIKE concat(p_group_name, '%')
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END search_group;

    PROCEDURE add_group (
        status         OUT            VARCHAR2,
        p_group_id     OUT            student_group.group_id%TYPE,
        p_group_name   IN             student_group.group_name%TYPE
    ) IS
        max_id   student_group.group_id%TYPE;
    BEGIN
        SELECT
            MAX(student_group.group_id)
        INTO max_id
        FROM
            student_group;

        INSERT INTO student_group (
            group_id,
            group_name
        ) VALUES (
            max_id + 1,
            p_group_name
        ) RETURNING group_id INTO p_group_id;

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END add_group;

    PROCEDURE delete_group (
        status       OUT          VARCHAR2,
        p_group_id   IN           student_group.group_id%TYPE
    ) IS
        student_count   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO student_count
        FROM
            student
        WHERE
            student.group_id = p_group_id;

        IF student_count = 0 THEN
            DELETE FROM student_group
            WHERE
                student_group.group_id = p_group_id;

            COMMIT;
            status := 'OK';
        ELSE
            status := 'CANT DELETE';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END delete_group;

    PROCEDURE edit_group (
        status       OUT          VARCHAR2,
        p_group_id     IN           student_group.group_id%TYPE,
        p_group_name   IN           student_group.group_name%TYPE
    ) IS
    BEGIN
        UPDATE student_group
        SET
            student_group.group_name = p_group_name
        WHERE
            student_group.group_id = p_group_id;

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END edit_group;

END group_package;
/
