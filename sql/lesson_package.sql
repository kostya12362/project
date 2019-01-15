CREATE OR REPLACE PACKAGE lesson_package AS
    TYPE lesson_row IS RECORD (
        lesson_id lesson.lesson_id%TYPE,
        group_id lesson.group_id%TYPE,
        teacher_id lesson.teacher_id%TYPE,
        discipline_id lesson.discipline_id%TYPE,
        lesson_number lesson.lesson_number%TYPE,
        week_number lesson.week_number%TYPE,
        week_day lesson.week_day%TYPE,
        add_date lesson.add_date%TYPE
    );
    TYPE lesson_table IS
        TABLE OF lesson_row;
    FUNCTION get_lessons (
        p_lesson_id    IN             lesson.lesson_id%TYPE,
        p_group_id     IN             lesson.group_id%TYPE,
        p_teacher_id   IN             lesson.teacher_id%TYPE
    ) RETURN lesson_table
        PIPELINED;

    PROCEDURE add_lesson (
        status            OUT               VARCHAR2,
        p_lesson_id       OUT               lesson.lesson_id%TYPE,
        p_group_id        IN                lesson.group_id%TYPE,
        p_teacher_id      IN                lesson.teacher_id%TYPE,
        p_discipline_id   IN                lesson.discipline_id%TYPE,
        p_lesson_number   IN                lesson.lesson_number%TYPE,
        p_week_number     IN                lesson.week_number%TYPE,
        p_week_day        IN                lesson.week_day%TYPE
    );

    PROCEDURE delete_lesson (
        status        OUT           VARCHAR2,
        p_lesson_id   IN            lesson.lesson_id%TYPE
    );

    PROCEDURE edit_lesson (
        status            OUT               VARCHAR2,
        p_lesson_id       IN                lesson.lesson_id%TYPE,
        p_group_id        IN                lesson.group_id%TYPE,
        p_teacher_id      IN                lesson.teacher_id%TYPE,
        p_lesson_number   IN                lesson.lesson_number%TYPE,
        p_week_number     IN                lesson.week_number%TYPE,
        p_week_day        IN                lesson.week_day%TYPE
    );

END lesson_package;
/


CREATE OR REPLACE PACKAGE BODY lesson_package AS

    FUNCTION get_lessons (
        p_lesson_id    IN             lesson.lesson_id%TYPE,
        p_group_id     IN             lesson.group_id%TYPE,
        p_teacher_id   IN             lesson.teacher_id%TYPE
    ) RETURN lesson_table
        PIPELINED
    IS
    BEGIN
        IF p_group_id IS NOT NULL THEN
            FOR curr IN (
                SELECT DISTINCT
                    *
                FROM
                    lesson
                WHERE
                    lesson.group_id = p_group_id
            ) LOOP
                PIPE ROW ( curr );
            END LOOP;
        END IF;

        IF p_teacher_id IS NOT NULL THEN
            FOR curr IN (
                SELECT DISTINCT
                    *
                FROM
                    lesson
                WHERE
                    lesson.teacher_id = p_teacher_id
            ) LOOP
                PIPE ROW ( curr );
            END LOOP;

        END IF;

        IF p_lesson_id IS NOT NULL THEN
            FOR curr IN (
                SELECT DISTINCT
                    *
                FROM
                    lesson
                WHERE
                    lesson.lesson_id = p_lesson_id
            ) LOOP
                PIPE ROW ( curr );
            END LOOP;
        END IF;

    END get_lessons;

    PROCEDURE add_lesson (
        status            OUT               VARCHAR2,
        p_lesson_id       OUT               lesson.lesson_id%TYPE,
        p_group_id        IN                lesson.group_id%TYPE,
        p_teacher_id      IN                lesson.teacher_id%TYPE,
        p_discipline_id   IN                lesson.discipline_id%TYPE,
        p_lesson_number   IN                lesson.lesson_number%TYPE,
        p_week_number     IN                lesson.week_number%TYPE,
        p_week_day        IN                lesson.week_day%TYPE
    ) IS
        max_id               lesson.lesson_id%TYPE;
        p_add_date             lesson.add_date%TYPE;
        group_lesson_count   NUMBER;
    BEGIN
        SELECT
            MAX(lesson.lesson_id)
        INTO max_id
        FROM
            lesson;

        SELECT
            current_date
        INTO p_add_date
        FROM
            dual;

        INSERT INTO lesson (
            lesson_id,
            group_id,
            teacher_id,
            discipline_id,
            lesson_number,
            week_number,
            week_day,
            add_date
        ) VALUES (
            max_id + 1,
            p_group_id,
            p_teacher_id,
            p_discipline_id,
            p_lesson_number,
            p_week_number,
            p_week_day,
            p_add_date
        ) RETURNING lesson_id INTO p_lesson_id;

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END add_lesson;

    PROCEDURE delete_lesson (
        status        OUT           VARCHAR2,
        p_lesson_id   IN            lesson.lesson_id%TYPE
    ) IS
        lesson_count   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO lesson_count
        FROM
            student_presence
        WHERE
            student_presence.lesson_id = p_lesson_id;

        IF lesson_count = 0 THEN
            DELETE FROM lesson
            WHERE
                lesson.lesson_id = p_lesson_id;

            COMMIT;
            status := 'OK';
        ELSE
            status := 'CANT DELETE';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END delete_lesson;

    PROCEDURE edit_lesson (
        status            OUT               VARCHAR2,
        p_lesson_id       IN                lesson.lesson_id%TYPE,
        p_group_id        IN                lesson.group_id%TYPE,
        p_teacher_id      IN                lesson.teacher_id%TYPE,
        p_lesson_number   IN                lesson.lesson_number%TYPE,
        p_week_number     IN                lesson.week_number%TYPE,
        p_week_day        IN                lesson.week_day%TYPE
    ) IS
    BEGIN
        UPDATE lesson
        SET
            lesson.group_id = p_group_id,
            lesson.teacher_id = p_teacher_id,
            lesson.lesson_number = p_lesson_number,
            lesson.week_number = p_week_number,
            lesson.week_day = p_week_day
        WHERE
            lesson.lesson_id = p_lesson_id;

        COMMIT;
        status := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END edit_lesson;

END lesson_package;
/
