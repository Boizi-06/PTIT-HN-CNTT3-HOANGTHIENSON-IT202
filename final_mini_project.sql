
create database srs_ss04;
use srs_ss04;


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
    student_id int not null,
    subject_id int not null,
    regist_date datetime default current_timestamp,
    primary key (student_id, subject_id),
    foreign key (student_id) references students(student_id),
    foreign key (subject_id) references subjects(subject_id)
);


create table score (
    student_id int not null,
    subject_id int not null,
    mid_score decimal(5,2) check (mid_score >=0 and mid_score <= 10),
    final_score decimal(5,2) check (final_score >=0 and final_score <= 10),	
    primary key (student_id, subject_id),
    foreign key (student_id) references students(student_id),
    foreign key (subject_id) references subjects(subject_id)
);


INSERT INTO teacher (teacher_name, teacher_email) VALUES
('Tran Minh Cuong', 'cuong@gmail.com'),
('Pham Tuan Binh', 'binh@gmail.com'),
('Nguyen Duy Quang', 'quang@gmail.com'),
('Trinh Quoc Hai', 'haitrinh@gmail.com'),
('Luong Quoc Tuan', 'tuan@gmail.com');


INSERT INTO students (student_name, email, date_of_birth) VALUES
('Hoang Thien Son', 'son@gmail.com', '2003-01-15'),
('Trinh Khac Hung', 'hung@gmail.com', '2003-03-20'),
('Nguyen Minh Duy', 'duy@gmail.com', '2002-11-05'),
('Le Thanh Long', 'long@gmail.com', '2003-07-18'),
('Nguyen Hoang Nhat', 'nhat@gmail.com', '2002-09-30'),
('Ha Quang Huy', 'hhuy@gmail.com', '2003-09-30');



INSERT INTO subjects (subject_name, sub_description, credit, teacher_id) VALUES
('Co so du lieu', 'Mon hoc ve co so du lieu', 3, 1),
('Lap trinh C', 'Lap trinh co ban voi C', 4, 2),
('lap trinh font-end voi react-ts', 'Lap trinh huong doi tuong', 3, 3),
('phan tich va thiet ke he thong', 'Kien thuc ve mang', 2, 4),
('lap trinh font-end co ban', 'Nguyen ly he dieu hanh', 3, 5);



INSERT INTO enrollment (student_id, subject_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(3, 4),
(4, 5),
(5, 2),
(6, 1),
(6, 3);

INSERT INTO score (student_id, subject_id, mid_score, final_score) VALUES
(6,3,5,5);
INSERT INTO score (student_id, subject_id, mid_score, final_score) VALUES
(1, 1, 7.5, 8.0),
(1, 2, 6.0, 7.0),
(2, 1, 8.0, 8.5),
(2, 3, 5.5, 6.5),
(3, 4, 9.0, 9.5),
(4, 5, 7.0, 8.0),
(5, 2, 6.5, 7.5),
(6, 1, 2.5, 1.5);



SELECT 
    students.student_id,
    students.student_name,
    score.subject_id,
    score.mid_score,
    score.final_score
FROM students, score
WHERE students.student_id = score.student_id;



