CREATE DATABASE Ride_Application;
USE Ride_Application;

--  Create Drivers Table
CREATE TABLE Drivers (
    DriverID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) UNIQUE NOT NULL,
    City VARCHAR(50),
    VehicleType VARCHAR(20),
    Rating DECIMAL(2, 1)
);

--  Create Riders Table
CREATE TABLE Riders (
    RiderID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) UNIQUE NOT NULL,
    City VARCHAR(50),
    JoinDate DATE
);

--  Create Rides Table
CREATE TABLE Rides (
    RideID INT PRIMARY KEY AUTO_INCREMENT,
    RiderID INT,
    DriverID INT,
    RideDate DATE NOT NULL,
    PickupLocation VARCHAR(100),
    DropLocation VARCHAR(100),
    Distance DECIMAL(5, 2),
    Fare DECIMAL(10, 2),
    RideStatus ENUM('Completed', 'Cancelled', 'Ongoing') NOT NULL,
    FOREIGN KEY (RiderID) REFERENCES Riders(RiderID),
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

--  Create Payments Table
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    RideID INT,
    PaymentMethod ENUM('Card', 'Cash', 'Wallet') NOT NULL,
    Amount DECIMAL(10, 2),
    PaymentDate DATE,
    FOREIGN KEY (RideID) REFERENCES Rides(RideID)
);


-- Insert Drivers Data
INSERT INTO Drivers (FirstName, LastName, Phone, City, VehicleType, Rating) VALUES
('John', 'Doe', '1234567890', 'Mumbai', 'Sedan', 4.8),
('Jane', 'Smith', '0987654321', 'Delhi', 'SUV', 4.6),
('Emily', 'Davis', '5678901234', 'Bangalore', 'Hatchback', 4.2);

-- Insert Riders Data
INSERT INTO Riders (FirstName, LastName, Phone, City, JoinDate) VALUES
('Michael', 'Brown', '9876543210', 'Mumbai', '2023-01-10'),
('Chris', 'Taylor', '8765432109', 'Delhi', '2023-02-15'),
('Emma', 'Wilson', '7654321098', 'Bangalore', '2023-03-01');

-- Insert Rides Data
INSERT INTO Rides (RiderID, DriverID, RideDate, PickupLocation, DropLocation, Distance, Fare, RideStatus) VALUES
(1, 1, '2023-03-05', 'Andheri', 'Bandra', 12.5, 250.00, 'Completed'),
(2, 2, '2023-03-10', 'Connaught Place', 'Dwarka', 30.0, 500.00, 'Completed'),
(3, 1, '2023-03-15', 'HSR Layout', 'Whitefield', 20.5, 400.00, 'Cancelled');

-- Insert Payments Data
INSERT INTO Payments (RideID, PaymentMethod, Amount, PaymentDate) VALUES
(1, 'Card', 250.00, '2023-03-06'),
(2, 'Cash', 500.00, '2023-03-11');

-- 1. Retrieve the names and contact details of all drivers with a rating of 4.5 or higher
SELECT FirstName, LastName, Phone, Rating
FROM Drivers
WHERE Rating >= 4.5;

-- 2. Find the total number of rides completed by each driver
SELECT d.DriverID, d.FirstName, d.LastName, COUNT(r.RideID) AS TotalRides
FROM Drivers d
JOIN Rides r ON d.DriverID = r.DriverID
WHERE r.RideStatus = 'Completed'
GROUP BY d.DriverID;

-- 3. List all riders who have never booked a ride
SELECT r.FirstName, r.LastName
FROM Riders r
LEFT JOIN Rides rd ON r.RiderID = rd.RiderID
WHERE rd.RideID IS NULL;

-- 4. Calculate the total earnings of each driver from completed rides
SELECT d.DriverID, d.FirstName, d.LastName, SUM(r.Fare) AS TotalEarnings
FROM Drivers d
JOIN Rides r ON d.DriverID = r.DriverID
WHERE r.RideStatus = 'Completed'
GROUP BY d.DriverID;

-- 5. Retrieve the most recent ride for each rider
SELECT r.RiderID, r.FirstName, r.LastName, MAX(rd.RideDate) AS MostRecentRide
FROM Riders r
JOIN Rides rd ON r.RiderID = rd.RiderID
GROUP BY r.RiderID;

-- 6. Count the number of rides taken in each city
SELECT d.City, COUNT(r.RideID) AS TotalRides
FROM Drivers d
JOIN Rides r ON d.DriverID = r.DriverID
GROUP BY d.City;

-- 7. List all rides where the distance was greater than 20 km
SELECT RideID, RiderID, DriverID, Distance, Fare
FROM Rides
WHERE Distance > 20;

-- 8. Identify the most preferred payment method
SELECT PaymentMethod, COUNT(PaymentID) AS MethodCount
FROM Payments
GROUP BY PaymentMethod
ORDER BY MethodCount DESC
LIMIT 1;

-- 9. Find the top 3 highest-earning drivers
SELECT d.FirstName, d.LastName, SUM(r.Fare) AS TotalEarnings
FROM Drivers d
JOIN Rides r ON d.DriverID = r.DriverID
WHERE r.RideStatus = 'Completed'
GROUP BY d.DriverID
ORDER BY TotalEarnings DESC
LIMIT 3;

-- 10. Retrieve details of all cancelled rides along with the rider's and driver's names
SELECT r.RideID, ri.FirstName AS RiderFirstName, ri.LastName AS RiderLastName,
       d.FirstName AS DriverFirstName, d.LastName AS DriverLastName, r.RideDate
FROM Rides r
JOIN Riders ri ON r.RiderID = ri.RiderID
JOIN Drivers d ON r.DriverID = d.DriverID
WHERE r.RideStatus = 'Cancelled';
