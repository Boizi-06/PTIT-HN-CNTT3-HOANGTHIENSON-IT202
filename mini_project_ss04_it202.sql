CREATE DATABASE mini_project_ss04;
USE mini_project_ss04;

-- Teacher
CREATE TABLE teacher (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_name VARCHAR(100) NOT NULL,
    teacher_email VARCHAR(100) NOT NULL UNIQUE
);

-- Student
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth DATE
);

-- Course
CREATE TABLE subjects (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(100) NOT NULL,
    sub_description TEXT,
    total_sessions INT NOT NULL CHECK (total_sessions > 0),
    teacher_id INT NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);

-- Enrollment
CREATE TABLE enrollment (
    student_id INT,
    subject_id INT,
    regist_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- Score
CREATE TABLE score (
    student_id INT,
    subject_id INT,
    mid_score DECIMAL(4,2) CHECK (mid_score BETWEEN 0 AND 10),
    final_score DECIMAL(4,2) CHECK (final_score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);


