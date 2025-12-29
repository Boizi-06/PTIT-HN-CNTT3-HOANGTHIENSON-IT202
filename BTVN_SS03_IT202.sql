

create database ss03;
use ss03;

-- bai 1

create table students (
	student_id int primary key auto_increment,
    fullname varchar(100) not null,
    date_of_birth date ,
    email varchar (100) not null
);

insert into students 
value 
(1,'Hoang Thien Son','2006-11-01','son666727@gmail.com'),
(2,'Nguyen Hoang Nhat','2006-11-02','nhat666727@gmail.com'),
(3,'Ha Quang Huy','2006-11-03','hahuy666727@gmail.com'),
(4,'Trinh Khac Hung','2006-11-04','hung666727@gmail.com'),
(7,'Le Thanh Long','2006-11-05','longle666727@gmail.com'),
(6,'Nguyen Minh Duy','2006-11-06','mdoe666727@gmail.com'),
(5,'Do Thao Minh','2006-11-07','tMinh666727@gmail.com');


select * from students;
select student_id , fullname from students;

-- bai 2

update students 
set email = 'nhatNguyen@gmail.com'
where student_id =2;

update students 
set date_of_birth = '2006-10-02'
where student_id = 2;

delete  from students
where student_id = 5;


select * from students;




-- bai 3



create table subjects (
	subject_id int primary key auto_increment,
    subject_name varchar(100) not null unique,
    credit int not null
);


insert into subjects values
(1,'hoc lap trinh c co ban',2),
(2,'hoc lap trinh front end co ban',4),
(3,'cau truc du lieu va giai thuat',2),
(4,'lap trinh front end voi react ts',6),
(5,' co so du lieu',2),
(6,'quy trinh phat trien phan mem',2);


update subjects 
set credit = 3
where subject_id =1;

update subjects 
set subject_name = 'tieng anh a12'
where subject_id =6;


-- bai 4

 create table enrollment (
	student_id int,
    subject_id int,
	enroll_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
 );
 
 
 insert into enrollment (student_id,subject_id) values 
 (1,1),(1,2),(3,4),(1,4),(2,1),(1,3),(5,1),(5,2);

select * from enrollment;
select * from enrollment where student_id =1;


-- bai5
create table score (
	student_id int,
    subject_id int,
    mid_score float not null check (mid_score >= 0 and mid_score <= 10),
    final_score float not null check(final_score >= 0 and final_score <= 10),
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

insert into score values 
(1,2,7,8),(1,3,9,9),(1,1,10,10),(2,1,6,6),(2,2,10,9),(2,3,7,6),(3,1,9,9),(3,2,6,6);



select * from score;


select student_id from score where final_score > 8; 

-- bai6

INSERT INTO students (fullname, date_of_birth, email)
VALUES ('Pham Duc Anh', '2006-12-10', 'ducanh@gmail.com');
select * from students;

INSERT INTO enrollment (student_id, subject_id)
VALUES 
(8, 1),
(8, 2);

select * from enrollment;

INSERT INTO score (student_id, subject_id, mid_score, final_score)
VALUES
(8, 1, 8, 9),
(8, 2, 7, 8);


UPDATE score
SET final_score = 9
WHERE student_id = 8 AND subject_id = 2;
select * from score;



DELETE FROM enrollment
WHERE student_id = 5 AND subject_id = 2;
select * from enrollment;


SELECT 
    students.student_id,
    students.fullname,
    score.subject_id,
    score.mid_score,
    score.final_score
FROM students, score
WHERE students.student_id = score.student_id;






