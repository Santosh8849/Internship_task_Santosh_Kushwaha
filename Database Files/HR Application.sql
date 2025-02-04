CREATE DATABASE HR_Application;
USE HR_Application;
-- DROP DATABASE HR_Application;

--  Create Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL,
    ManagerID INT NULL -- Add foreign key later
);


--  Create Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    HireDate DATE NOT NULL,
    DepartmentID INT,
    ManagerID INT,
    Salary DECIMAL(10, 2),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

ALTER TABLE Departments
ADD CONSTRAINT FK_Manager
FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID);

-- PerformanceReviews Table
CREATE TABLE PerformanceReviews (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    ReviewDate DATE NOT NULL,
    PerformanceScore ENUM('Excellent', 'Good', 'Average', 'Poor') NOT NULL,
    Comments TEXT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


--  Payroll Table
CREATE TABLE Payroll (
    PayrollID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentMethod ENUM('Bank Transfer', 'Check') NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


-- Departments Data
INSERT INTO Departments (DepartmentName, ManagerID) VALUES
('HR', NULL),
('Engineering', NULL),
('Marketing', NULL),
('Sales', NULL);

-- Employees Data
INSERT INTO Employees (FirstName, LastName, Email, Phone, HireDate, DepartmentID, ManagerID, Salary) VALUES
('John', 'Doe', 'john.doe@example.com', '9876543210', '2023-02-15', 1, NULL, 50000),
('Jane', 'Smith', 'jane.smith@example.com', '9876543211', '2023-03-01', 2, 1, 80000),
('Emily', 'Davis', 'emily.davis@example.com', '9876543212', '2023-04-10', 3, 1, 60000),
('Michael', 'Brown', 'michael.brown@example.com', '9876543213', '2023-05-20', 2, 2, 70000),
('Chris', 'Taylor', 'chris.taylor@example.com', '9876543214', '2023-06-01', 4, 3, 55000);

-- PerformanceReviews Data
INSERT INTO PerformanceReviews (EmployeeID, ReviewDate, PerformanceScore, Comments) VALUES
(1, '2023-06-15', 'Excellent', 'Outstanding leadership skills'),
(2, '2023-06-20', 'Good', 'Solid performance overall'),
(3, '2023-06-25', 'Average', 'Room for improvement in marketing strategies'),
(4, '2023-07-01', 'Excellent', 'Exceptional coding skills'),
(5, '2023-07-05', 'Good', 'Consistent performance in sales targets');

-- Payroll Data
INSERT INTO Payroll (EmployeeID, PaymentDate, Amount, PaymentMethod) VALUES
(1, '2023-07-31', 50000, 'Bank Transfer'),
(2, '2023-07-31', 80000, 'Bank Transfer'),
(3, '2023-07-31', 60000, 'Check'),
(4, '2023-07-31', 70000, 'Bank Transfer'),
(5, '2023-07-31', 55000, 'Check');

-- 1. Retrieve the names and contact details of employees hired after January 1, 2023.
SELECT FirstName, LastName, Email, Phone 
FROM Employees 
WHERE HireDate > '2023-01-01';

-- 2. Find the total payroll amount paid to each department.
SELECT d.DepartmentName, SUM(p.Amount) AS TotalPayroll 
FROM Departments d 
JOIN Employees e ON d.DepartmentID = e.DepartmentID 
JOIN Payroll p ON e.EmployeeID = p.EmployeeID 
GROUP BY d.DepartmentID;

-- 3. List all employees who have not been assigned a manager.
SELECT EmployeeID, FirstName, LastName 
FROM Employees 
WHERE ManagerID IS NULL;

-- 4. Retrieve the highest salary in each department along with the employee’s name.
SELECT d.DepartmentName, e.FirstName, e.LastName, e.Salary AS HighestSalary
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
WHERE e.Salary = (
    SELECT MAX(Salary)
    FROM Employees e2
    WHERE e2.DepartmentID = d.DepartmentID
);


-- 5. Find the most recent performance review for each employee.
SELECT e.EmployeeID, e.FirstName, e.LastName, MAX(r.ReviewDate) AS MostRecentReview 
FROM Employees e 
JOIN PerformanceReviews r ON e.EmployeeID = r.EmployeeID 
GROUP BY e.EmployeeID;

-- 6. Count the number of employees in each department.
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS EmployeeCount 
FROM Departments d 
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID 
GROUP BY d.DepartmentID;

-- 7. List all employees who have received a performance score of "Excellent."
SELECT e.EmployeeID, e.FirstName, e.LastName 
FROM Employees e 
JOIN PerformanceReviews r ON e.EmployeeID = r.EmployeeID 
WHERE r.PerformanceScore = 'Excellent';

-- 8. Identify the most frequently used payment method in payroll.
SELECT PaymentMethod, COUNT(PaymentMethod) AS MethodCount 
FROM Payroll 
GROUP BY PaymentMethod 
ORDER BY MethodCount DESC 
LIMIT 1;

-- 9. Retrieve the top 5 highest-paid employees along with their departments.
SELECT e.FirstName, e.LastName, e.Salary, d.DepartmentName 
FROM Employees e 
JOIN Departments d ON e.DepartmentID = d.DepartmentID 
ORDER BY e.Salary DESC 
LIMIT 5;

-- 10. Show details of all employees who report directly to a specific manager (e.g., ManagerID = 101).
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Email, e.Phone 
FROM Employees e 
WHERE e.ManagerID = 101;
