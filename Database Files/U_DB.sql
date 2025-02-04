CREATE DATABASE college;
USE college;
drop database college;

CREATE TABLE Departments (
    department_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

DELIMITER $$
CREATE TRIGGER before_insert_departments
BEFORE INSERT ON Departments
FOR EACH ROW
BEGIN
    DECLARE new_id INT;
    SELECT IFNULL(MAX(CAST(SUBSTRING(department_id, 7, 3) AS UNSIGNED)), 0) + 1 INTO new_id FROM Departments;
    SET NEW.department_id = CONCAT('161245', LPAD(new_id, 3, '0'));
END $$
DELIMITER ;

CREATE TABLE Professors (
    professor_id VARCHAR(15) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    phone_no VARCHAR(20) NOT NULL,
    department_id VARCHAR(10), -- Match Departments table
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL
);

DELIMITER $$

CREATE TRIGGER before_insert_professors
BEFORE INSERT ON Professors
FOR EACH ROW
BEGIN
    DECLARE new_id INT;
    SELECT IFNULL(MAX(CAST(SUBSTRING(professor_id, 13, 3) AS UNSIGNED)), 0) + 1 INTO new_id FROM Professors;
    SET NEW.professor_id = CONCAT('183310590023', LPAD(new_id, 3, '0'));
END $$

DELIMITER ;

CREATE TABLE Students (
    student_id VARCHAR(15) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    phone_no VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    Enrollment_date DATE NOT NULL,
    department_id VARCHAR(10), -- Match Departments table
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL
);

DELIMITER $$

CREATE TRIGGER before_insert_students
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
    DECLARE new_id INT;
    SELECT IFNULL(MAX(CAST(SUBSTRING(student_id, 8, 3) AS UNSIGNED)), 0) + 1 INTO new_id FROM Students;
    SET NEW.student_id = CONCAT('25CA231', LPAD(new_id, 3, '0'));
END $$

DELIMITER ;

CREATE TABLE Courses (
    course_id VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    department_id VARCHAR(10),
    professor_id VARCHAR(15),
    credits INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL,
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id) ON DELETE SET NULL
);

DELIMITER $$

CREATE TRIGGER before_insert_courses
BEFORE INSERT ON Courses
FOR EACH ROW
BEGIN
    DECLARE new_id INT;
    SELECT IFNULL(MAX(CAST(SUBSTRING(course_id, 4, 3) AS UNSIGNED)), 0) + 1 INTO new_id FROM Courses;
    SET NEW.course_id = CONCAT('101', LPAD(new_id, 3, '0'));
END $$

DELIMITER ;

CREATE TABLE Enrollments (
    Enrollment_id VARCHAR(15) PRIMARY KEY, 
    student_id VARCHAR(15),
    course_id VARCHAR(10),
    Enrollment_date DATE,
    grade VARCHAR(5),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE SET NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE SET NULL
);

DELIMITER $$

CREATE TRIGGER before_insert_enrollments
BEFORE INSERT ON Enrollments
FOR EACH ROW
BEGIN
    DECLARE new_id INT;
    SELECT IFNULL(MAX(CAST(SUBSTRING(enrollment_id, 9, 3) AS UNSIGNED)), 0) + 1 INTO new_id FROM Enrollments;
    SET NEW.enrollment_id = CONCAT('0901CA25', LPAD(new_id, 3, '0'));
END $$

DELIMITER ;

        
-- Insert Departments
INSERT INTO Departments (department_name) VALUES 
('Computer Science'),
('Electrical Engineering'),
('Mechanical Engineering'),
('Civil Engineering'),
('Mathematics'),
('Physics'),
('Biotechnology'),
('Chemical Engineering'),
('Information Technology'),
('Artificial Intelligence');

-- Insert Professors
INSERT INTO Professors (first_name, last_name, email, phone_no, department_id) VALUES 
('Amit', 'Sharma', 'amit.sharma@example.com', '9876543210', '161245001'),
('Neha', 'Singh', 'neha.singh@example.com', '9898989898', '161245002'),
('Rajesh', 'Kumar', 'rajesh.kumar@example.com', '9765432109', '161245003'),
('Pooja', 'Mehta', 'pooja.mehta@example.com', '9123456789', '161245004'),
('Vikram', 'Rathore', 'vikram.rathore@example.com', '9988776655', '161245005'),
('Sonia', 'Agarwal', 'sonia.agarwal@example.com', '9876512345', '161245006'),
('Anil', 'Verma', 'anil.verma@example.com', '9876543123', '161245007'),
('Priya', 'Das', 'priya.das@example.com', '9876987654', '161245008'),
('Suresh', 'Gupta', 'suresh.gupta@example.com', '9786543210', '161245009'),
('Kavita', 'Yadav', 'kavita.yadav@example.com', '9876234567', '161245010');

-- Insert Students
INSERT INTO Students (first_name, last_name, email, phone_no, date_of_birth, enrollment_date, department_id) VALUES 
('Rahul', 'Verma', 'rahul.verma@example.com', '9234567890', '2000-05-15', CURDATE(), '161245001'),
('Sneha', 'Joshi', 'sneha.joshi@example.com', '9123456780', '2001-08-21', CURDATE(), '161245002'),
('Rohan', 'Gupta', 'rohan.gupta@example.com', '9345678901', '2002-01-12', CURDATE(), '161245003'),
('Megha', 'Patel', 'megha.patel@example.com', '9456789012', '1999-09-18', CURDATE(), '161245004'),
('Arjun', 'Tiwari', 'arjun.tiwari@example.com', '9567890123', '2000-11-30', CURDATE(), '161245005'),
('Deepika', 'Singh', 'deepika.singh@example.com', '9001234567', '2001-07-10', CURDATE(), '161245006'),
('Manish', 'Kumar', 'manish.kumar@example.com', '9087654321', '2000-03-25', CURDATE(), '161245007'),
('Kritika', 'Saxena', 'kritika.saxena@example.com', '9045678901', '1999-12-05', CURDATE(), '161245008'),
('Ankur', 'Pandey', 'ankur.pandey@example.com', '9182736450', '2001-06-14', CURDATE(), '161245009'),
('Priyanshu', 'Rana', 'priyanshu.rana@example.com', '9012345678', '2000-09-23', CURDATE(), '161245010');

-- Insert Courses
INSERT INTO Courses (course_name, department_id, professor_id, credits) VALUES 
('Data Structures', '161245001', '183310590023001', 4),
('Digital Circuits', '161245002', '183310590023002', 3),
('Thermodynamics', '161245003', '183310590023003', 4),
('Structural Analysis', '161245004', '183310590023004', 4),
('Linear Algebra', '161245005', '183310590023005', 3),
('Quantum Mechanics', '161245006', '183310590023006', 4),
('Bioprocess Engineering', '161245007', '183310590023007', 3),
('Chemical Reaction Engineering', '161245008', '183310590023008', 4),
('Database Management Systems', '161245009', '183310590023009', 4),
('Machine Learning', '161245010', '183310590023010', 5);

-- Insert Enrollments
INSERT INTO Enrollments (student_id, course_id, enrollment_date, grade) VALUES 
('25CA231001', '101001', CURDATE(), 'A'),
('25CA231002', '101002', CURDATE(), 'B'),
('25CA231003', '101003', CURDATE(), 'A'),
('25CA231004', '101004', CURDATE(), 'B+'),
('25CA231005', '101005', CURDATE(), 'A'),
('25CA231006', '101006', CURDATE(), 'A-'),
('25CA231007', '101007', CURDATE(), 'B'),
('25CA231008', '101008', CURDATE(), 'B+'),
('25CA231009', '101009', CURDATE(), 'A'),
('25CA231010', '101010', CURDATE(), 'A+');
        

SELECT * FROM Departments;
SELECT * FROM Professors;
SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM Enrollments;
select first_name, substring(first_name, 1, 2) as firstTwoLetter from students;
(select	LPAD(RPAD(first_name, 30, '*'),40, '.') as First_name from students);
select RTRIM(LTRIM(first_name, '.'), '*') as First_name from students;
SELECT 
    TRIM(TRAILING '*' FROM TRIM(LEADING '.' FROM padded_name)) AS First_name
FROM (
    SELECT LPAD(RPAD(first_name, 30, '*'), 40, '.') AS padded_name 
    FROM students
) AS subquery;
select upper(first_name) from students;
select ltrim("   santosh******");
select ltrim("***santosh     ");
select trim('*' from '***santosh****');
select concat('santosh ', ' kushwaha');
select concat(first_name, ' ', last_name) as Full_name from students;
select instr("this is my name", 'my');
select * from (SELECT students.student_id, students.first_name, students.last_name, departments.department_name 
FROM students JOIN departments ON students.department_id = departments.department_id) as info where instr(student_id, '25CA231010')>0;
-- SELECT students.student_id, students.first_name, students.last_name, departments.department_name 
-- FROM students
-- JOIN departments ON students.department_id = departments.department_id;
select first_name, last_name, length(first_name) as charCount_firstName, length(last_name) as charCount_secondName from students;
select replace("this is my house", "house", "pen");
select left("this is mysql", 5);
select right("this is mysql", 5);
select substring("santosh", -7, 8)






