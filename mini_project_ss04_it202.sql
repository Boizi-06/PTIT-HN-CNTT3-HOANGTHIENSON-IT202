create database mini_project_ss04;
use mini_project_ss04;


create table teacher (
    teacher_id int primary key auto_increment,
    teacher_name varchar(100) not null,
    teacher_email varchar(100) not null unique
);


create table students (
    student_id int primary key auto_increment,
    student_name varchar(100) not null,
    email varchar(100) not null unique,
    date_of_birth date
);


create table subjects (
    subject_id int primary key auto_increment,
    subject_name varchar(100) not null,
    sub_description text,
    credit int not null check(credit >0),
    teacher_id int not null,
    foreign key (teacher_id) references teacher(teacher_id)
);


create table enrollment (
    student_id int,
    subject_id int,
    regist_date datetime default current_timestamp,
    primary key (student_id, subject_id),
    foreign key (student_id) references students(student_id),
    foreign key (subject_id) references subjects(subject_id)
);


create table score (
    student_id int,
    subject_id int,
    mid_score float check (mid_score >=0 and mid_score <= 10),
    final_score float check (final_score >=0 and final_score <= 10),
    primary key (student_id, subject_id),
    foreign key (student_id) references students(student_id),
    foreign key (subject_id) references subjects(subject_id)
);



