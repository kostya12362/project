/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     23.11.2018 0:09:47                           */
/*==============================================================*/


alter table lesson
   drop constraint FK_LESSON_DISCIPLINE;

alter table lesson
   drop constraint FK_GROUP_LESSON;

alter table lesson
   drop constraint FK_TEACHER_LESSON;

alter table student
   drop constraint FK_STUDENT_GROUP;

alter table student
   drop constraint FK_USER_STUDENT;

alter table student_presence
   drop constraint FK_LESSON_PRESENCE;

alter table student_presence
   drop constraint FK_STUDENT_PRESENCE;

alter table teacher
   drop constraint FK_USER_TEACHER;

drop table check_in_user cascade constraints;

drop table discipline cascade constraints;

drop table lesson cascade constraints;

drop table student cascade constraints;

drop table student_group cascade constraints;

drop table student_presence cascade constraints;

drop table teacher cascade constraints;


/*==============================================================*/
/* Table: check_in_user                                       */
/*==============================================================*/
create table check_in_user 
(
   id_code            NUMBER(10)           not null,
   last_name          VARCHAR2(30)         not null,
   first_name         VARCHAR2(30)         not null,
   login              VARCHAR2(30)         not null,
   password           VARCHAR2(30)         not null,
   email              VARCHAR2(30)         not null,
   constraint PK_CHECK_IN_USER primary key (id_code),
   constraint un_user_login unique (login),
   constraint un_user_email unique (email),
   constraint user_id_code_constr check(regexp_like(id_code, '^[0-9]{10}$')),
   constraint user_last_name_constr check(regexp_like(last_name, '^([A-Z][a-z]+)$')),
   constraint user_first_name_constr check(regexp_like(first_name, '^([A-Z][a-z]+)$')),
   constraint user_email_constr check(regexp_like(email, '^[0-9a-zA-Z\.]{1,18}@[a-z]{1,8}\.[a-z]{2,3}$')),
   constraint user_login_constr check(regexp_like(login, '^[0-9a-zA-Z]{5,30}$')),
   constraint user_password_constr check(regexp_like(password, '.{8,}'))
);

/*==============================================================*/
/* Table: discipline                                          */
/*==============================================================*/
create table discipline 
(
   discipline_id      INTEGER              not null,
   discipline_name    VARCHAR2(50)         not null,
   constraint PK_DISCIPLINE primary key (discipline_id),
   constraint un_discipline_name unique (discipline_name),
   constraint discipline_number_constr check(discipline_id > 0),
   constraint discipline_name_constr check(regexp_like(discipline_name, '^([A-Z]?[a-z]+[-\. ]?){1,}$'))
);

/*==============================================================*/
/* Table: lesson                                              */
/*==============================================================*/
create table lesson 
(
   lesson_id          INTEGER              not null,
   group_id           INTEGER              not null,
   teacher_id         INTEGER              not null,
   discipline_id      INTEGER              not null,
   lesson_number      INTEGER              not null,
   week_number        INTEGER              not null,
   week_day           INTEGER              not null,
   add_date           DATE                 not null,
   constraint PK_LESSON primary key (lesson_id),
   constraint un_group_lesson unique (group_id, lesson_number , week_number, week_day, add_date ),
   constraint lesson_lesson_id_constr check(lesson_id > 0),
   constraint lesson_week_constr check(regexp_like(week_number, '^[1-2]$')),
   constraint lesson_week_day_constr check(regexp_like(week_day, '^[1-6]$')),
   constraint lesson_number_constr check(regexp_like(lesson_number, '^[1-5]$'))
);

/*==============================================================*/
/* Table: student                                             */
/*==============================================================*/
create table student 
(
   student_id         INTEGER              not null,
   group_id           INTEGER              not null,
   id_code            NUMBER(10)           not null,
   start_date         DATE                 not null,
   end_date           DATE,
   constraint PK_STUDENT primary key (student_id),
   constraint student_student_id_constr check(student_id > 0),
   constraint student_start_date_constr check(start_date > date '1900-01-01'),
   constraint student_end_date_constr check(end_date > date '1900-01-01')
);

/*==============================================================*/
/* Table: student_group                                       */
/*==============================================================*/
create table student_group 
(
   group_id           INTEGER              not null,
   group_name         VARCHAR2(10)         not null,
   constraint PK_STUDENT_GROUP primary key (group_id),
   constraint group_group_id_constr check(group_id > 0),
   constraint group_group_name_constr check(regexp_like(group_name, '^[A-Z]{2}-[a-z]{0,1}\d{2}[a-z]{0,2}$'))
);

/*==============================================================*/
/* Table: student_presence                                    */
/*==============================================================*/
create table student_presence 
(
   student_presence_id INTEGER              not null,
   lesson_id          INTEGER              not null,
   student_id         INTEGER              not null,
   lesson_date        DATE                 not null,
   constraint PK_STUDENT_PRESENCE primary key (student_presence_id),
   constraint presence_lesson_id_constr check(lesson_id > 0),
   constraint presence_date_constr check(lesson_date > date '1900-01-01')
);

/*==============================================================*/
/* Table: teacher                                             */
/*==============================================================*/
create table teacher 
(
   teacher_id         INTEGER              not null,
   id_code            NUMBER(10)           not null,
   degree             VARCHAR2(30)         not null,
   start_date         DATE                 not null,
   end_date           DATE,
   constraint PK_TEACHER primary key (teacher_id),
   constraint teacher_start_date_constr check(start_date > date '1900-01-01'),
   constraint teacher_end_date_constr check(end_date > date '1900-01-01'),
   constraint teacher_teacher_id_constr check(teacher_id > 0),
   constraint teacher_degree_constr check(regexp_like(degree, '^([A-Za-z]+[- ]?){1,}$'))
);


alter table lesson
   add constraint FK_LESSON_DISCIPLINE foreign key (discipline_id)
      references discipline (discipline_id);

alter table lesson
   add constraint FK_GROUP_LESSON foreign key (group_id)
      references student_group (group_id);

alter table lesson
   add constraint FK_TEACHER_LESSON foreign key (teacher_id)
      references teacher (teacher_id);

alter table student
   add constraint FK_STUDENT_GROUP foreign key (group_id)
      references student_group (group_id);

alter table student
   add constraint FK_USER_STUDENT foreign key (id_code)
      references check_in_user (id_code);

alter table student_presence
   add constraint FK_LESSON_PRESENCE foreign key (lesson_id)
      references lesson (lesson_id);

alter table student_presence
   add constraint FK_STUDENT_PRESENCE foreign key (student_id)
      references student (student_id);

alter table teacher
   add constraint FK_USER_TEACHER foreign key (id_code)
      references check_in_user (id_code);
