/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     18.11.2018 19:35:22                          */
/*==============================================================*/


alter table dean
   drop constraint FK_DEAN_FACULTY_D_FACULTY;

alter table dean
   drop constraint FK_DEAN_USER_DEAN_CHEK_IN_;

alter table department
   drop constraint FK_DEPARTME_FACULTY_D_FACULTY;

alter table lesson
   drop constraint FK_LESSON_DISCIPLIN_DISCIPLI;

alter table lesson
   drop constraint FK_LESSON_LESSON_TY_LESSON_T;

alter table schedule
   drop constraint FK_SCHEDULE_SCHEDULE__LESSON;

alter table schedule
   drop constraint FK_SCHEDULE_STUDENT_S_STUDENT_;

alter table schedule
   drop constraint FK_SCHEDULE_TEACHER_S_TEACHER;

alter table student
   drop constraint FK_STUDENT_GROUP_STU_STUDENT_;

alter table student
   drop constraint FK_STUDENT_USER_STUD_CHEK_IN_;

alter table student_group
   drop constraint FK_STUDENT__DEPARTMEN_DEPARTME;

alter table student_presence
   drop constraint FK_STUDENT__STUDENT_L_STUDENT;

alter table student_presence
   drop constraint FK_STUDENT__STUDENT_P_LESSON;

alter table student_presence
   drop constraint FK_STUDENT__TEACHER_C_TEACHER;

alter table teacher
   drop constraint FK_TEACHER_FACULTY_T_FACULTY;

alter table teacher
   drop constraint FK_TEACHER_USER_TEAC_CHEK_IN_;

drop table check_in_user cascade constraints;

drop table student_group cascade constraints;

drop table student_presence cascade constraints;

drop table teacher cascade constraints;

drop table department cascade constraints;

drop table discipline cascade constraints;

drop table faculty cascade constraints;

drop table dean cascade constraints;

drop table lesson cascade constraints;

drop table lesson_type cascade constraints;

drop table schedule cascade constraints;

drop table student cascade constraints;

drop index FACULTY_DEAN_FK;

drop index user_dean_FK;

drop index faculty_has_departments_FK;

drop index discipline_lesson_FK;

drop index lesson_type_FK;

drop index student_schedule_FK;

drop index teacher_schedule_FK;

drop index schedule_lesson_FK;

drop index user_student_FK;

drop index group_student_FK;

drop index department_has_groups_FK;

drop index teacher_checks_presence_FK;

drop index student_presence_FK;

drop index student_has_lesson_FK;

drop index faculty_teacher_FK;

drop index user_teacher_FK;


/*==============================================================*/
/* Table: check_in_user                                          */
/*==============================================================*/
create table check_in_user 
(
   id_code              NUMBER(10)           not null,
   last_name            VARCHAR2(30)         not null,
   first_name           VARCHAR2(30)         not null,
   middle_name          VARCHAR2(30)         not null,
   login                VARCHAR2(30),
   password             VARCHAR2(30),
   email                VARCHAR2(30),
   constraint PK_check_in_user primary key (id_code),
   constraint user_id_code_constr check(regexp_like(id_code, '^[0-9]{10}$')),
   constraint user_last_name_constr check(regexp_like(last_name, '^([A-Z][a-z]+)$')),
   constraint user_first_name_constr check(regexp_like(first_name, '^([A-Z][a-z]+)$')),
   constraint user_middle_name_constr check(regexp_like(middle_name, '^([A-Z][a-z]+)$')),
   constraint user_email_constr check(regexp_like(email, '^[0-9a-z]{1,18}@[a-z]{1,8}\.[a-z]{2,3}$')),
   constraint user_login_constr check(regexp_like(login, '^[0-9a-zA-Z]{5,30}$')),
   constraint user_password_constr check(regexp_like(password, '^[A-Za-z0-9]{8,}$'))
);

/*==============================================================*/
/* Table: dean                                                  */
/*==============================================================*/
create table dean 
(
   dean_id              INTEGER              not null,
   faculty_id           INTEGER              not null,
   id_code              NUMBER(10)           not null,
   start_date           DATE                 not null,
   end_date             DATE,
   constraint PK_DEAN primary key (dean_id),
   constraint dean_dean_id_constr check(dean_id > 0),
   constraint dean_faculty_id_constr check(faculty_id > 0),
   constraint dean_start_date_constr check(start_date > date '1900-01-01'),
   constraint dean_end_date_constr check(end_date > date '1900-01-01'),
   constraint dean_id_code_constr check(regexp_like(id_code, '^[0-9]{10}$'))
);

/*==============================================================*/
/* Table: department                                            */
/*==============================================================*/
create table department 
(
   faculty_id           INTEGER              not null,
   department_name      VARCHAR2(50)         not null,
   constraint PK_DEPARTMENT primary key (faculty_id, department_name),
   constraint department_faculty_id_constr check(faculty_id > 0),
   constraint department_name_constr check(regexp_like(department_name, '^([A-Z]?[a-z]+[-\. ]?){1,}$'))
);

/*==============================================================*/
/* Table: discipline                                            */
/*==============================================================*/
create table discipline 
(
   discipline_number    INTEGER              not null,
   discipline_name      VARCHAR2(60)         not null,
   constraint PK_DISCIPLINE primary key (discipline_number),
   constraint discipline_number_constr check(discipline_number > 0),
   constraint discipline_name_constr check(regexp_like(discipline_name, '^([A-Z]?[a-z]+[-\. ]?){1,}$'))
);

/*==============================================================*/
/* Table: faculty                                               */
/*==============================================================*/
create table faculty 
(
   faculty_id           INTEGER              not null,
   faculty_name         VARCHAR2(50)         not null,
   constraint PK_FACULTY primary key (faculty_id),
   constraint faculty_faculty_id_constr check(faculty_id > 0),
   constraint faculty_faculty_name_constr check(regexp_like(faculty_name, '^([A-Z]?[a-z]+[-\. ]?){1,}$'))
);

/*==============================================================*/
/* Table: lesson                                                */
/*==============================================================*/
create table lesson 
(
   lesson_id            INTEGER              not null,
   discipline_number    INTEGER              not null,
   lesson_type          VARCHAR2(20)         not null,
   lesson_number        INTEGER              not null,
   week                 INTEGER              not null,
   week_day             INTEGER              not null,
   constraint PK_LESSON primary key (lesson_id),
   constraint lesson_lesson_id_constr check(lesson_id > 0),
   constraint lesson_discipl_number_constr check(discipline_number > 0),
   constraint lesson_week_constr check(regexp_like(week, '^[1-2]$')),
   constraint lesson_week_day_constr check(regexp_like(week_day, '^[1-6]$')),
   constraint lesson_number_constr check(regexp_like(lesson_number, '^[1-5]$')),
   constraint lesson_type_constr check(lesson_type in ('lecture', 'practical work', 'laboratory work'))
);

/*==============================================================*/
/* Table: lesson_type                                           */
/*==============================================================*/
create table lesson_type 
(
   lesson_type          VARCHAR2(20)         not null,
   constraint PK_LESSON_TYPE primary key (lesson_type),
   constraint lesson_type_lesson_type_constr check(lesson_type in ('lecture', 'practical work', 'laboratory work'))
);

/*==============================================================*/
/* Table: schedule                                              */
/*==============================================================*/
create table schedule 
(
   lesson_id            INTEGER              not null,
   group_id             INTEGER              not null,
   teacher_id           INTEGER              not null,
   constraint PK_SCHEDULE primary key (lesson_id, group_id, teacher_id),
   constraint schedule_lesson_id_constr check(lesson_id > 0),
   constraint schedule_group_id_constr check(group_id > 0),
   constraint schedule_teacher_id_constr check(teacher_id > 0)
);

/*==============================================================*/
/* Table: student                                               */
/*==============================================================*/
create table student 
(
   student_id           INTEGER              not null,
   student_card         VARCHAR2(10)         not null,
   group_id             INTEGER              not null,
   id_code              NUMBER(10)           not null,
   start_date           DATE                 not null,
   end_date             DATE                 not null,
   constraint PK_STUDENT primary key (student_id),
   constraint student_student_id_constr check(student_id > 0),
   constraint student_group_id_constr check(group_id > 0),
   constraint student_student_card_constr check(regexp_like(student_card, '^[A-Z]{2}[0-9]{8}$')),
   constraint student_start_date_constr check(start_date > date '1900-01-01'),
   constraint student_end_date_constr check(end_date > date '1900-01-01'),
   constraint student_id_code_constr check(regexp_like(id_code, '^[0-9]{10}$'))
);

/*==============================================================*/
/* Table: student_group                                         */
/*==============================================================*/
create table student_group 
(
   group_id             INTEGER              not null,
   faculty_id           INTEGER              not null,
   department_name      VARCHAR2(50)         not null,
   group_name           VARCHAR2(10)         not null,
   constraint PK_STUDENT_GROUP primary key (group_id),
   constraint group_group_id_constr check(group_id > 0),
   constraint group_faculty_id_constr check(faculty_id > 0),
   constraint group_department_name_constr check(regexp_like(department_name, '^([A-Z]?[a-z]+[-\. ]?){1,}$')),
   constraint group_group_name_constr check(regexp_like(group_name, '^[A-Z]{2}-[a-z]{0,1}\d{2}[a-z]{0,2}$'))
);

/*==============================================================*/
/* Table: student_presence                                      */
/*==============================================================*/
create table student_presence 
(
   lesson_id            INTEGER              not null,
   student_id           INTEGER              not null,
   presence_date        DATE                 not null,
   presence             SMALLINT             not null,
   teacher_id           INTEGER              not null,
   constraint PK_STUDENT_PRESENCE primary key (lesson_id, student_id, presence_date),
   constraint presence_lesson_id_constr check(lesson_id > 0),
   constraint presence_student_id_constr check(student_id > 0),
   constraint presence_teacher_id_constr check(teacher_id > 0),
   constraint presence_date_constr check(presence_date > date '1900-01-01'),
   constraint presence_presence_constr check(regexp_like(presence, '^[01]$'))
);

/*==============================================================*/
/* Table: teacher                                               */
/*==============================================================*/
create table teacher 
(
   teacher_id           INTEGER              not null,
   faculty_id           INTEGER              not null,
   id_code              NUMBER(10)           not null,
   start_date           DATE                 not null,
   end_date             DATE,
   degree               VARCHAR2(25)         not null,
   constraint PK_TEACHER primary key (teacher_id),
   constraint teacher_start_date_constr check(start_date > date '1900-01-01'),
   constraint teacher_end_date_constr check(end_date > date '1900-01-01'),
   constraint teacher_id_code_constr check(regexp_like(id_code, '^[0-9]{10}$')),
   constraint teacher_teacher_id_constr check(teacher_id > 0),
   constraint teacher_faculty_id_constr check(faculty_id > 0),
   constraint teacher_degree_constr check(regexp_like(degree, '^([A-Za-z]+[- ]?){1,}$'))
);







/*==============================================================*/
/* Index: user_dean_FK                                          */
/*==============================================================*/
create index user_dean_FK on dean (
   id_code ASC
);

/*==============================================================*/
/* Index: faculty_dean_FK                                       */
/*==============================================================*/
create index faculty_dean_FK on dean (
   faculty_id ASC
);

/*==============================================================*/
/* Index: faculty_has_departments_FK                            */
/*==============================================================*/
create index faculty_has_departments_FK on department (
   faculty_id ASC
);

/*==============================================================*/
/* Index: lesson_type_FK                                        */
/*==============================================================*/
create index lesson_type_FK on lesson (
   lesson_type ASC
);

/*==============================================================*/
/* Index: discipline_lesson_FK                                  */
/*==============================================================*/
create index discipline_lesson_FK on lesson (
   discipline_number ASC
);

/*==============================================================*/
/* Index: schedule_lesson_FK                                    */
/*==============================================================*/
create index schedule_lesson_FK on schedule (
   lesson_id ASC
);

/*==============================================================*/
/* Index: teacher_schedule_FK                                   */
/*==============================================================*/
create index teacher_schedule_FK on schedule (
   teacher_id ASC
);

/*==============================================================*/
/* Index: student_schedule_FK                                   */
/*==============================================================*/
create index student_schedule_FK on schedule (
   group_id ASC
);

/*==============================================================*/
/* Index: group_student_FK                                      */
/*==============================================================*/
create index group_student_FK on student (
   group_id ASC
);

/*==============================================================*/
/* Index: user_student_FK                                       */
/*==============================================================*/
create index user_student_FK on student (
   id_code ASC
);

/*==============================================================*/
/* Index: department_has_groups_FK                              */
/*==============================================================*/
create index department_has_groups_FK on student_group (
   faculty_id ASC,
   department_name ASC
);

/*==============================================================*/
/* Index: student_has_lesson_FK                                 */
/*==============================================================*/
create index student_has_lesson_FK on student_presence (
   student_id ASC
);

/*==============================================================*/
/* Index: student_presence_FK                                   */
/*==============================================================*/
create index student_presence_FK on student_presence (
   lesson_id ASC
);

/*==============================================================*/
/* Index: teacher_checks_presence_FK                            */
/*==============================================================*/
create index teacher_checks_presence_FK on student_presence (
   teacher_id ASC
);

/*==============================================================*/
/* Index: user_teacher_FK                                       */
/*==============================================================*/
create index user_teacher_FK on teacher (
   id_code ASC
);

/*==============================================================*/
/* Index: faculty_teacher_FK                                    */
/*==============================================================*/
create index faculty_teacher_FK on teacher (
   faculty_id ASC
);







alter table dean
   add constraint FK_DEAN_FACULTY_D_FACULTY foreign key (faculty_id)
      references faculty (faculty_id);

alter table dean
   add constraint FK_DEAN_USER_DEAN_CHEK_IN_ foreign key (id_code)
      references check_in_user (id_code);

alter table department
   add constraint FK_DEPARTME_FACULTY_D_FACULTY foreign key (faculty_id)
      references faculty (faculty_id);

alter table lesson
   add constraint FK_LESSON_DISCIPLIN_DISCIPLI foreign key (discipline_number)
      references discipline (discipline_number);

alter table lesson
   add constraint FK_LESSON_LESSON_TY_LESSON_T foreign key (lesson_type)
      references lesson_type (lesson_type);

alter table schedule
   add constraint FK_SCHEDULE_SCHEDULE__LESSON foreign key (lesson_id)
      references lesson (lesson_id);

alter table schedule
   add constraint FK_SCHEDULE_STUDENT_S_STUDENT_ foreign key (group_id)
      references student_group (group_id);

alter table schedule
   add constraint FK_SCHEDULE_TEACHER_S_TEACHER foreign key (teacher_id)
      references teacher (teacher_id);

alter table student
   add constraint FK_STUDENT_GROUP_STU_STUDENT_ foreign key (group_id)
      references student_group (group_id);

alter table student
   add constraint FK_STUDENT_USER_STUD_CHEK_IN_ foreign key (id_code)
      references check_in_user (id_code);

alter table student_group
   add constraint FK_STUDENT__DEPARTMEN_DEPARTME foreign key (faculty_id, department_name)
      references department (faculty_id, department_name);

alter table student_presence
   add constraint FK_STUDENT__STUDENT_L_STUDENT foreign key (student_id)
      references student (student_id);

alter table student_presence
   add constraint FK_STUDENT__STUDENT_P_LESSON foreign key (lesson_id)
      references lesson (lesson_id);

alter table student_presence
   add constraint FK_STUDENT__TEACHER_C_TEACHER foreign key (teacher_id)
      references teacher (teacher_id);

alter table teacher
   add constraint FK_TEACHER_FACULTY_T_FACULTY foreign key (faculty_id)
      references faculty (faculty_id);

alter table teacher
   add constraint FK_TEACHER_USER_TEAC_CHEK_IN_ foreign key (id_code)
      references check_in_user (id_code);

