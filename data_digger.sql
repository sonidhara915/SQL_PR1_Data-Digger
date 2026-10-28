CREATE DATABASE datadigger;
USE datadigger;

DROP TABLE customer;

-- 1. CUSTOMERS TABLE 
CREATE TABLE customer(
    cus_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(200)
);

INSERT INTO customer VALUES
(1, 'Alice', 'alice@example.com', 'Surat'),
(2, 'Rahul', 'rahul@example.com', 'Ahmedabad'),
(3, 'Priya', 'priya@example.com', 'Vadodara'),
(4, 'Amit', 'amit@example.com', 'Rajkot'),
(5, 'Neha', 'neha@example.com', 'Gandhinagar');

-- Resive all customer details

SELECT * FROM customer;

-- update customers address

UPDATE customer SET address = "Mumbai" WHERE cus_id = 2;

-- Delete customer

DELETE FROM customer WHERE cus_id = 5;

-- Display custoer who name is Alice

SELECT * FROM customer WHERE name = "Alice";

-- 2. Order Table

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    cus_id INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (cus_id)
        REFERENCES Customer(cus_id)
);

INSERT INTO Orders VALUES
(101, 1, CURRENT_DATE, 2500.00),
(102, 2, DATE_SUB(CURRENT_DATE, INTERVAL 3 DAY), 1200.00),
(103, 1, DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY), 3500.00),
(104, 3, DATE_SUB(CURRENT_DATE, INTERVAL 15 DAY), 800.00),
(105, 4, DATE_SUB(CURRENT_DATE, INTERVAL 25 DAY), 4200.00);

-- Retrieve orders made by a specific customer

SELECT * FROM Orders
WHERE cus_id = 1;

-- Update an order's total amount

UPDATE Orders
SET TotalAmount = 2600.00
WHERE OrderID = 101;

-- Delete an order using OrderID
-- Execute separately if no OrderDetails reference it.

-- DELETE FROM Orders WHERE OrderID = 105;

-- Retrieve orders placed in the last 30 days

SELECT * FROM Orders
WHERE OrderDate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
AND OrderDate <= CURRENT_DATE;

-- Highest, lowest and average order amount

SELECT
    MAX(TotalAmount) AS HighestAmount,
    MIN(TotalAmount) AS LowestAmount,
    AVG(TotalAmount) AS AverageAmount
FROM Orders;

-- 3. Products Table

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL
);

-- Insert sample products

INSERT INTO Products
(ProductID, ProductName, Price, Stock)
VALUES
(201, 'Wireless Mouse', 750.00, 40),
(202, 'Keyboard', 1500.00, 25),
(203, 'USB Cable', 250.00, 100),
(204, 'Headphones', 1800.00, 15),
(205, 'Laptop Stand', 1200.00, 0),
(206, 'Notebook', 100.00, 0);

-- Retrieve products by descending price

SELECT * FROM Products
ORDER BY ProductID;

-- Update the price of a specific product

UPDATE Products
SET Price = 800.00
WHERE ProductID = 201;

-- Delete a product if it is out of stock.
-- Product 206 is not referenced by OrderDetails.

DELETE FROM Products
WHERE ProductID = 206
  AND Stock = 0;

-- Retrieve products priced between Rs.500 and Rs.2000

SELECT *
FROM Products
WHERE Price BETWEEN 500 AND 2000;

-- Retrieve the most expensive and cheapest prices

SELECT
    MAX(Price) AS HighestPrice,
    MIN(Price) AS LowestPrice
FROM Products;

-- 4. OrderDetail Table

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    SubTotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);

-- Insert at least 5 sample records

INSERT INTO OrderDetails
(OrderDetailID, OrderID, ProductID, Quantity, SubTotal)
VALUES
(301, 101, 201, 2, 1600.00),
(302, 101, 202, 1, 1500.00),
(303, 102, 203, 2, 500.00),
(304, 103, 204, 2, 3600.00),
(305, 104, 201, 1, 800.00),
(306, 105, 205, 2, 2400.00);

-- Retrieve all details for a specific order

SELECT * FROM OrderDetails
WHERE OrderID = 101;

-- Calculate total revenue using SUM()

SELECT SUM(SubTotal) AS TotalRevenue
FROM OrderDetails;

-- Retrieve the top 3 most ordered products

SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantity
FROM OrderDetails od
JOIN Products p
ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalQuantity DESC
LIMIT 3;

-- Count how many times a specific product
-- appears in order details using COUNT()

SELECT COUNT(*) AS TimesSold
FROM OrderDetails
WHERE ProductID = 201;


-- =====================================
-- FINAL VERIFICATION
-- =====================================

SELECT * FROM customer;
SELECT * FROM Orders;
SELECT * FROM Products;
SELECT * FROM OrderDetails;