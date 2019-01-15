CREATE OR REPLACE PACKAGE user_package AS
    TYPE user_row IS RECORD (
        id_code check_in_user.id_code%TYPE,
        last_name check_in_user.last_name%TYPE,
        first_name check_in_user.first_name%TYPE,
        login check_in_user.login%TYPE,
        password check_in_user.password%TYPE,
        email check_in_user.email%TYPE
    );
    TYPE user_table IS
        TABLE OF user_row;
    FUNCTION get_user (
        p_login   IN          check_in_user.login%TYPE
    ) RETURN user_table
        PIPELINED;

    PROCEDURE authorization (
        status       OUT          VARCHAR2,
        p_login      IN           check_in_user.login%TYPE,
        p_password   IN           check_in_user.password%TYPE
    );

    PROCEDURE registration (
        status          OUT             VARCHAR2,
        p_id_code       IN              check_in_user.id_code%TYPE,
        p_last_name     IN              check_in_user.last_name%TYPE,
        p_first_name    IN              check_in_user.first_name%TYPE,
        p_login         IN              check_in_user.login%TYPE,
        p_password      IN              check_in_user.password%TYPE,
        p_email         IN              check_in_user.email%TYPE
    );

    PROCEDURE delete_user (
        status      OUT         VARCHAR2,
        p_id_code   IN          check_in_user.id_code%TYPE
    );

    PROCEDURE edit_user_info (
        status           OUT              VARCHAR2,
        p_id_code        IN               check_in_user.id_code%TYPE,
        p_last_name      IN               check_in_user.last_name%TYPE,
        p_first_name     IN               check_in_user.first_name%TYPE,
        p_email          IN               check_in_user.email%TYPE,
        p_login          IN               check_in_user.login%TYPE,
        p_password       IN               check_in_user.password%TYPE,
        p_new_password   IN               check_in_user.password%TYPE
    );

END user_package;
/


CREATE OR REPLACE PACKAGE BODY user_package AS

    FUNCTION get_user (
        p_login   IN          check_in_user.login%TYPE
    ) RETURN user_table
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                id_code,
                last_name,
                first_name,
                login,
                password,
                email
            FROM
                check_in_user
            WHERE
                check_in_user.login = p_login
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_user;

    PROCEDURE authorization (
        status       OUT          VARCHAR2,
        p_login      IN           check_in_user.login%TYPE,
        p_password   IN           check_in_user.password%TYPE
    ) IS
        user_count   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO user_count
        FROM
            check_in_user
        WHERE
            check_in_user.login = p_login
            AND check_in_user.password = p_password;

        IF user_count > 0 THEN
            status := 'OK';
        ELSE
            status := 'NOT FOUND';
        END IF;

    END authorization;

    PROCEDURE registration (
        status         OUT            VARCHAR2,
        p_id_code      IN             check_in_user.id_code%TYPE,
        p_last_name    IN             check_in_user.last_name%TYPE,
        p_first_name   IN             check_in_user.first_name%TYPE,
        p_login        IN             check_in_user.login%TYPE,
        p_password     IN             check_in_user.password%TYPE,
        p_email        IN             check_in_user.email%TYPE
    ) IS
    BEGIN
        INSERT INTO check_in_user (
            id_code,
            last_name,
            first_name,
            login,
            password,
            email
        ) VALUES (
            p_id_code,
            p_last_name,
            p_first_name,
            p_login,
            p_password,
            p_email
        );

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END registration;

    PROCEDURE delete_user (
        status      OUT         VARCHAR2,
        p_id_code   IN          check_in_user.id_code%TYPE
    ) IS
        teacher_count   NUMBER;
        student_count   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO teacher_count
        FROM
            lesson left
            JOIN teacher ON lesson.teacher_id = teacher.teacher_id
        WHERE
            teacher.id_code = p_id_code;

        SELECT
            COUNT(*)
        INTO student_count
        FROM
            student left
            JOIN student_presence ON student.student_id = student_presence.student_id
        WHERE
            student.id_code = p_id_code;

        IF ( student_count + teacher_count ) = 0 THEN
            DELETE FROM check_in_user
            WHERE
                check_in_user.id_code = p_id_code;

            status := 'OK';
        ELSE
            status := 'CANT DELETE';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END delete_user;

    PROCEDURE edit_user_info (
        status           OUT              VARCHAR2,
        p_id_code        IN               check_in_user.id_code%TYPE,
        p_last_name      IN               check_in_user.last_name%TYPE,
        p_first_name     IN               check_in_user.first_name%TYPE,
        p_email          IN               check_in_user.email%TYPE,
        p_login          IN               check_in_user.login%TYPE,
        p_password       IN               check_in_user.password%TYPE,
        p_new_password   IN               check_in_user.password%TYPE
    ) IS
        user_count   NUMBER;
    BEGIN
        IF p_last_name IS NOT NULL THEN
            UPDATE check_in_user
            SET
                check_in_user.last_name = p_last_name,
                check_in_user.first_name = p_first_name,
                check_in_user.email = p_email,
                check_in_user.login = p_login
            WHERE
                check_in_user.id_code = p_id_code;

            COMMIT;
            status := 'OK';
        END IF;

        IF p_new_password IS NOT NULL AND p_password IS NOT NULL THEN
            SELECT
                COUNT(*)
            INTO user_count
            FROM
                check_in_user
            WHERE
                check_in_user.id_code = p_id_code
                AND check_in_user.password = p_password;

            IF user_count > 0 THEN
                UPDATE check_in_user
                SET
                    check_in_user.password = p_new_password
                WHERE
                    check_in_user.id_code = p_id_code;

                COMMIT;
                status := 'OK';
            ELSE
                status := 'INVALID PASSWORD';
            END IF;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END edit_user_info;

END user_package;
/
