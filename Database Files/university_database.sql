CREATE DATABASE University_database ;
use University_database;
-- drop database University_database;


-- Students Departments...............
CREATE TABLE Departments (
department_id INT PRIMARY KEY,
department_name VARCHAR(100) NOT NULL 
);

-- Students table...............
CREATE TABLE Students (
student_id INT PRIMARY KEY,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE,
phone_no VARCHAR(20) NOT NULL,
date_of_birth DATE NOT NULL,
Enrollment_date DATE NOT NULL,
department_id INT, -- Foreign key (references Departments)
FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL
);

-- Students Teachers...............
CREATE TABLE Professors (
professor_id INT PRIMARY KEY,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE,
phone_no VARCHAR(20) NOT NULL,
department_id INT, -- Foreign key (references Departments)
FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL
);

-- Students Courses...............
CREATE TABLE Courses (
course_id INT PRIMARY KEY,
course_name VARCHAR(100) NOT NULL,
department_id INT, -- Foreign key (references Departments)
professor_id INT, -- Foreign key (references Professors)
credits INT, -- Number of credits for the course
FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL,
FOREIGN KEY (professor_id) REFERENCES Professors(professor_id) ON DELETE SET NULL
);

-- Students Enrollments...............
CREATE TABLE Enrollments (
Enrollment_id INT PRIMARY KEY, 
student_id INT, -- Foreign key (references Students)
course_id INT, -- Foreign key (references Courses)
Enrollment_date DATE, -- Date the student enrolled in the course
grade VARCHAR(5), -- Grade received in the course
FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE SET NULL,
FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE SET NULL
);

INSERT INTO Departments (department_id, department_name) VALUES
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'Physics'),
(4, 'English');

INSERT INTO Students (student_id, first_name, last_name, email, phone_no, date_of_birth, enrollment_date, department_id) VALUES
(201, 'Alice', 'Smith', 'alice@university.edu', '9876543210', '2002-05-10', '2022-08-15', 1),
(202, 'Bob', 'Johnson', 'bob@university.edu', '9876543211', '2001-11-20', '2022-08-15', 2),
(203, 'Charlie', 'Brown', 'charlie@university.edu', '9876543212', '2000-07-18', '2021-08-15', 3),
(204, 'Daisy', 'Evans', 'daisy@university.edu', '9876543213', '2003-09-25', '2023-08-15', 4);

INSERT INTO Professors (professor_id, first_name, last_name, email, phone_no, department_id) VALUES
(101, 'Alan', 'Turing', 'turing@university.edu', '1234567890', 1),
(102, 'Isaac', 'Newton', 'newton@university.edu', '1234567891', 2),
(103, 'Albert', 'Einstein', 'einstein@university.edu', '1234567892', 3),
(104, 'William', 'Shakespeare', 'shakespeare@university.edu', '1234567893', 4);

INSERT INTO Courses (course_id, course_name, department_id, professor_id, credits) VALUES
(301, 'Data Structures', 1, 101, 4),
(302, 'Calculus', 2, 102, 3),
(303, 'Quantum Physics', 3, 103, 4),
(304, 'English Literature', 4, 104, 3);

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date, grade) VALUES
(401, 201, 301, '2022-08-20', 'A'),
(402, 202, 302, '2022-08-21', 'B+'),
(403, 203, 303, '2021-08-22', 'A'),
(404, 204, 304, '2023-08-23', 'B');

-- 1. Find the Total Number of Students in Each Department.
SELECT d.department_name, COUNT(s.student_id) AS total_students
FROM Departments d
LEFT JOIN Students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;

-- 2. List All Courses Taught by a Specific Professor.
SELECT professor_id,course_id, course_name 
FROM Courses;
SELECT course_id, course_name 
FROM Courses 
WHERE professor_id = 101;

-- 3. Find the Average Grade of Students in Each Course.
SELECT course_id, AVG(grade) AS average_grade
FROM Enrollments
GROUP BY course_id;

-- 4. List All Students Who Have Not Enrolled in Any Courses.
SELECT student_id, first_name, last_name
FROM Students
WHERE student_id NOT IN (SELECT DISTINCT student_id FROM Enrollments);

-- 5. Find the Number of Courses Offered by Each Department
SELECT department_id, COUNT(course_id) AS total_courses
FROM Courses
GROUP BY department_id;

-- 6. List All Students Who Have Taken a Specific Course (e.g., 'Database Systems')
SELECT s.student_id, s.first_name, s.last_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Database Systems';

-- 7. Find the Most Popular Course Based on Enrollment Numbers
SELECT c.course_id, c.course_name, COUNT(e.student_id) AS total_enrollments
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY total_enrollments DESC
LIMIT 1;

-- 8. Find the Average Number of Credits Per Student in a Department.
SELECT s.department_id, AVG(c.credits) AS avg_credits_per_student
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
GROUP BY s.department_id;

-- 9. List All Professors Who Teach in More Than One Department.
SELECT professor_id
FROM Courses
GROUP BY professor_id
HAVING COUNT(DISTINCT department_id) > 1;

-- 10. Get the Highest and Lowest Grade in a Specific Course (e.g., '')
SELECT course_id, 
       MAX(grade) AS highest_grade, 
       MIN(grade) AS lowest_grade
FROM Enrollments
WHERE course_id = (SELECT course_id FROM Courses WHERE course_name = 'Operating Systems')
GROUP BY course_id;