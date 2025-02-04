CREATE DATABASE Retail_store;
USE Retail_store;

--  Create Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    join_date DATE NOT NULL
);

--  Create Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL
);

-- Create Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2),
    order_status VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Create OrderDetails Table
CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Insert Customers Data
INSERT INTO Customers (first_name, last_name, email, phone, address, join_date) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', '123 Elm St, Springfield', '2023-01-10'),
('Jane', 'Smith', 'jane.smith@example.com', '0987654321', '456 Oak St, Springfield', '2023-02-15'),
('Emily', 'Davis', 'emily.davis@example.com', '5678901234', '789 Pine St, Springfield', '2023-03-01');

-- Insert Products Data
INSERT INTO Products (product_name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 800.00, 10),
('Phone', 'Electronics', 500.00, 20),
('Desk Chair', 'Furniture', 150.00, 15),
('Notebook', 'Stationery', 5.00, 100);

-- Insert Orders Data
INSERT INTO Orders (customer_id, order_date, total_amount, order_status) VALUES
(1, '2023-03-05', 1300.00, 'Shipped'),
(2, '2023-03-10', 150.00, 'Pending'),
(3, '2023-03-12', 505.00, 'Shipped');

-- Insert OrderDetails Data
INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 800.00),
(1, 2, 1, 500.00),
(2, 3, 1, 150.00),
(3, 4, 10, 5.00);

-- Insert Payments Data
INSERT INTO Payments (order_id, payment_date, payment_amount, payment_method) VALUES
(1, '2023-03-06', 1300.00, 'Credit Card'),
(3, '2023-03-13', 505.00, 'PayPal');

-- 1. Find the Total Number of Orders for Each Customer
SELECT c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 2. Find the Total Sales Amount for Each Product (Revenue per Product)
SELECT p.product_name, SUM(od.quantity * od.unit_price) AS total_sales
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.product_id;

-- 3. Find the Most Expensive Product Sold
SELECT p.product_name, od.unit_price AS highest_price
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
ORDER BY od.unit_price DESC
LIMIT 1;

-- 4. Get the List of Customers Who Have Placed Orders in the Last 30 Days
SELECT DISTINCT c.first_name, c.last_name, c.email
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;

-- 5. Calculate the Total Amount Paid by Each Customer
SELECT c.first_name, c.last_name, SUM(p.payment_amount) AS total_paid
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.customer_id;

-- 6. Get the Number of Products Sold by Category
SELECT p.category, SUM(od.quantity) AS total_products_sold
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.category;

-- 7. List All Orders That Are Pending (i.e., Orders that haven't been shipped yet)
SELECT o.order_id, o.total_amount, c.first_name, c.last_name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Pending';

-- 8. Find the Average Order Value (Total Order Amount / Number of Orders)
SELECT AVG(o.total_amount) AS average_order_value
FROM Orders o;

-- 9. List the Top 5 Customers Who Have Spent the Most Money
SELECT c.first_name, c.last_name, SUM(p.payment_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 10. Find the Products That Have Never Been Sold
SELECT p.product_name
FROM Products p
LEFT JOIN OrderDetails od ON p.product_id = od.product_id
WHERE od.order_id IS NULL;

