-- Tạo database
CREATE DATABASE session04_exam;
USE session04_exam;


-- Bảng Student

CREATE TABLE student (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15)
);

-- Bảng Course

CREATE TABLE course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credit INT NOT NULL CHECK (credit > 0)
);


-- Bảng Enrollment

CREATE TABLE enrollment (
    student_id INT,
    course_id INT,
    grade DECIMAL(4,2) DEFAULT 0,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);


INSERT INTO student VALUES
(1, 'Nguyen Van A', 'a@gmail.com', '0901111111'),
(2, 'Tran Thi B', 'b@gmail.com', '0902222222'),
(3, 'Le Van C', 'c@gmail.com', '0903333333'),
(4, 'Pham Thi D', 'd@gmail.com', '0904444444'),
(5, 'Hoang Van E', 'e@gmail.com', '0905555555');



INSERT INTO course VALUES
(101, 'Co so du lieu', 3),
(102, 'Lap trinh C', 4),
(103, 'Lap trinh Java', 3),
(104, 'Mang may tinh', 2),
(105, 'He dieu hanh', 3);




INSERT INTO enrollment VALUES
(1, 101, 7.5),
(2, 102, 8.0),
(2, 103, 6.5),
(3, 101, 9.0),
(4, 105, 0);




UPDATE enrollment
SET grade = 9.0
WHERE student_id = 2 AND course_id = 103;



SELECT full_name, email, phone
FROM student;


DELETE FROM course
WHERE course_id = 101;

-- Không xóa được vì khóa học có mã 101 đang được
-- tham chiếu bởi bảng Enrollment (ràng buộc khóa ngoại).
-- Việc xóa sẽ vi phạm toàn vẹn dữ liệu.

