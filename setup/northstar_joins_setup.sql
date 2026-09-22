/*
    Northstar Retail - SQL JOINs Project
    Database: NorthstarJoinsDB

    This script creates the relational training database and loads the starter data.
    Re-running the script resets the project tables.
*/

IF DB_ID('NorthstarJoinsDB') IS NULL
BEGIN
    CREATE DATABASE NorthstarJoinsDB;
END;
GO

USE NorthstarJoinsDB;
GO

-- Drop child tables first so foreign keys do not block the reset.
DROP TABLE IF EXISTS dbo.Returns;
DROP TABLE IF EXISTS dbo.Orders;
DROP TABLE IF EXISTS dbo.InventorySnapshot;
DROP TABLE IF EXISTS dbo.SalesReps;
DROP TABLE IF EXISTS dbo.Customers;
DROP TABLE IF EXISTS dbo.Products;
DROP TABLE IF EXISTS dbo.Regions;
GO

CREATE TABLE dbo.Regions (
    RegionID INT PRIMARY KEY,
    RegionName NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    State CHAR(2) NOT NULL,
    RegionID INT NOT NULL,
    CustomerType NVARCHAR(30) NOT NULL,
    CONSTRAINT FK_Customers_Regions
        FOREIGN KEY (RegionID) REFERENCES dbo.Regions(RegionID)
);

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    ProductCategory NVARCHAR(40) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL
);

CREATE TABLE dbo.SalesReps (
    SalesRepID INT PRIMARY KEY,
    SalesRepName NVARCHAR(100) NOT NULL,
    RegionID INT NOT NULL,
    CONSTRAINT FK_SalesReps_Regions
        FOREIGN KEY (RegionID) REFERENCES dbo.Regions(RegionID)
);

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    SalesRepID INT NOT NULL,
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    OrderStatus NVARCHAR(20) NOT NULL,
    PaymentMethod NVARCHAR(30) NOT NULL,
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),
    CONSTRAINT FK_Orders_Products
        FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID),
    CONSTRAINT FK_Orders_SalesReps
        FOREIGN KEY (SalesRepID) REFERENCES dbo.SalesReps(SalesRepID)
);

CREATE TABLE dbo.Returns (
    ReturnID INT PRIMARY KEY,
    OrderID INT NOT NULL UNIQUE,
    ReturnDate DATE NOT NULL,
    ReturnReason NVARCHAR(100) NOT NULL,
    CONSTRAINT FK_Returns_Orders
        FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID)
);

-- Imported legacy warehouse snapshot.
-- No foreign key is intentional: some snapshot ProductIDs represent retired SKUs
-- that are no longer present in dbo.Products.
CREATE TABLE dbo.InventorySnapshot (
    ProductID INT PRIMARY KEY,
    StockOnHand INT NOT NULL,
    WarehouseZone NVARCHAR(20) NOT NULL,
    SnapshotDate DATE NOT NULL
);
GO

INSERT INTO dbo.Regions (RegionID, RegionName)
VALUES
    (1, N'West'),
    (2, N'South'),
    (3, N'Central'),
    (4, N'East');

INSERT INTO dbo.Customers (CustomerID, CustomerName, City, State, RegionID, CustomerType)
VALUES
    (1, N'Avery Johnson', N'Sacramento', N'CA', 1, N'Consumer'),
    (2, N'Monica Reyes', N'Folsom', N'CA', 1, N'Consumer'),
    (3, N'Derek Chen', N'Seattle', N'WA', 1, N'Small Business'),
    (4, N'Priya Patel', N'Portland', N'OR', 1, N'Corporate'),
    (5, N'Jordan Williams', N'Phoenix', N'AZ', 1, N'Consumer'),
    (6, N'Taylor Morgan', N'Denver', N'CO', 1, N'Small Business'),
    (7, N'Sofia Martinez', N'Austin', N'TX', 2, N'Consumer'),
    (8, N'Marcus Reed', N'Dallas', N'TX', 2, N'Corporate'),
    (9, N'Nina Brooks', N'Atlanta', N'GA', 2, N'Small Business'),
    (10, N'Ethan Walker', N'Miami', N'FL', 2, N'Consumer'),
    (11, N'Olivia Bennett', N'Charlotte', N'NC', 2, N'Corporate'),
    (12, N'Caleb Foster', N'Nashville', N'TN', 2, N'Consumer'),
    (13, N'Grace Kim', N'Chicago', N'IL', 3, N'Corporate'),
    (14, N'Noah Thompson', N'Detroit', N'MI', 3, N'Consumer'),
    (15, N'Maya Robinson', N'Columbus', N'OH', 3, N'Small Business'),
    (16, N'Liam Carter', N'Minneapolis', N'MN', 3, N'Consumer'),
    (17, N'Emma Collins', N'Kansas City', N'MO', 3, N'Small Business'),
    (18, N'Henry Adams', N'Indianapolis', N'IN', 3, N'Corporate'),
    (19, N'Chloe Rivera', N'New York', N'NY', 4, N'Consumer'),
    (20, N'Daniel Lee', N'Boston', N'MA', 4, N'Corporate'),
    (21, N'Amelia Scott', N'Philadelphia', N'PA', 4, N'Small Business'),
    (22, N'Lucas Green', N'Baltimore', N'MD', 4, N'Consumer'),
    (23, N'Zoe Turner', N'Newark', N'NJ', 4, N'Small Business'),
    (24, N'Samuel King', N'Richmond', N'VA', 4, N'Corporate');

INSERT INTO dbo.Products (ProductID, ProductName, ProductCategory, UnitPrice)
VALUES
    (1, N'ApexBook 14 Laptop', N'Computers', 899.99),
    (2, N'ApexBook Pro 16', N'Computers', 1399.99),
    (3, N'MiniDesk PC', N'Computers', 649.99),
    (4, N'Wireless Pro Mouse', N'Accessories', 59.99),
    (5, N'Mechanical Keyboard', N'Accessories', 89.99),
    (6, N'USB-C Dock', N'Accessories', 119.99),
    (7, N'Laptop Stand', N'Accessories', 39.99),
    (8, N'Wireless Headphones', N'Audio', 149.99),
    (9, N'Studio Pro Headset', N'Audio', 199.99),
    (10, N'Bluetooth Speaker', N'Audio', 79.99),
    (11, N'24-inch Monitor', N'Displays', 179.99),
    (12, N'27-inch Pro Monitor', N'Displays', 329.99),
    (13, N'34-inch Gaming Monitor', N'Displays', 549.99),
    (14, N'Gaming Controller', N'Gaming', 69.99),
    (15, N'Gaming Keyboard', N'Gaming', 129.99),
    (16, N'WiFi 6 Router', N'Networking', 159.99),
    (17, N'1TB Portable SSD', N'Storage', 109.99),
    (18, N'2TB Pro SSD', N'Storage', 189.99),
    (19, N'4TB External Drive', N'Storage', 129.99),
    (20, N'10-Port USB Hub', N'Accessories', 49.99);

INSERT INTO dbo.SalesReps (SalesRepID, SalesRepName, RegionID)
VALUES
    (1, N'Alex Carter', 1),
    (2, N'Bianca Lopez', 2),
    (3, N'Chris Nguyen', 3),
    (4, N'Dana Brooks', 4),
    (5, N'Eric Foster', 1),
    (6, N'Mia Sanders', 4);

INSERT INTO dbo.Orders (OrderID, CustomerID, ProductID, SalesRepID, OrderDate, Quantity, OrderStatus, PaymentMethod)
VALUES
    (2001, 8, 2, 2, '2026-01-23', 7, N'Completed', N'Debit Card'),
    (2002, 13, 12, 2, '2026-07-07', 3, N'Completed', N'PayPal'),
    (2003, 10, 3, 4, '2026-05-28', 2, N'Pending', N'Credit Card'),
    (2004, 18, 17, 2, '2026-06-17', 7, N'Completed', N'PayPal'),
    (2005, 15, 17, 2, '2026-01-12', 7, N'Cancelled', N'Bank Transfer'),
    (2006, 2, 9, 2, '2026-08-24', 5, N'Completed', N'Bank Transfer'),
    (2007, 7, 6, 5, '2026-07-11', 2, N'Shipped', N'Debit Card'),
    (2008, 17, 11, 4, '2026-06-30', 4, N'Completed', N'Debit Card'),
    (2009, 2, 15, 1, '2026-07-29', 4, N'Shipped', N'Bank Transfer'),
    (2010, 10, 7, 4, '2026-02-07', 1, N'Completed', N'Bank Transfer'),
    (2011, 1, 1, 2, '2026-04-30', 7, N'Pending', N'Debit Card'),
    (2012, 6, 13, 2, '2026-02-19', 1, N'Completed', N'Debit Card'),
    (2013, 17, 13, 5, '2026-03-12', 4, N'Completed', N'Debit Card'),
    (2014, 1, 6, 2, '2026-08-16', 1, N'Pending', N'Debit Card'),
    (2015, 12, 4, 5, '2026-03-27', 3, N'Shipped', N'PayPal'),
    (2016, 21, 3, 2, '2026-06-27', 1, N'Completed', N'Bank Transfer'),
    (2017, 16, 5, 5, '2026-07-15', 3, N'Pending', N'PayPal'),
    (2018, 7, 3, 3, '2026-07-02', 6, N'Cancelled', N'Bank Transfer'),
    (2019, 6, 17, 3, '2026-06-03', 6, N'Shipped', N'PayPal'),
    (2020, 4, 2, 1, '2026-07-05', 1, N'Pending', N'Debit Card'),
    (2021, 18, 8, 2, '2026-03-13', 4, N'Shipped', N'Credit Card'),
    (2022, 13, 10, 3, '2026-07-07', 5, N'Cancelled', N'Debit Card'),
    (2023, 1, 8, 1, '2026-07-20', 4, N'Completed', N'Bank Transfer'),
    (2024, 7, 9, 5, '2026-04-26', 3, N'Shipped', N'Debit Card'),
    (2025, 16, 13, 3, '2026-04-12', 4, N'Pending', N'Credit Card'),
    (2026, 19, 6, 4, '2026-04-12', 7, N'Pending', N'Credit Card'),
    (2027, 12, 10, 1, '2026-08-26', 4, N'Pending', N'Bank Transfer'),
    (2028, 11, 8, 2, '2026-05-19', 5, N'Shipped', N'Credit Card'),
    (2029, 17, 2, 1, '2026-01-07', 6, N'Completed', N'PayPal'),
    (2030, 5, 16, 5, '2026-06-08', 2, N'Shipped', N'Debit Card'),
    (2031, 9, 6, 3, '2026-08-17', 1, N'Shipped', N'Credit Card'),
    (2032, 10, 11, 4, '2026-08-31', 6, N'Completed', N'Bank Transfer'),
    (2033, 14, 15, 5, '2026-01-09', 3, N'Completed', N'PayPal'),
    (2034, 13, 4, 4, '2026-01-21', 2, N'Shipped', N'Debit Card'),
    (2035, 8, 16, 3, '2026-01-21', 4, N'Cancelled', N'Credit Card'),
    (2036, 18, 6, 2, '2026-03-01', 7, N'Completed', N'Credit Card'),
    (2037, 5, 14, 2, '2026-06-13', 3, N'Pending', N'Credit Card'),
    (2038, 19, 5, 2, '2026-02-10', 1, N'Completed', N'Credit Card'),
    (2039, 6, 14, 1, '2026-07-04', 6, N'Completed', N'Credit Card'),
    (2040, 18, 16, 4, '2026-05-14', 7, N'Pending', N'Debit Card'),
    (2041, 5, 4, 3, '2026-04-09', 4, N'Completed', N'Bank Transfer'),
    (2042, 10, 10, 1, '2026-03-23', 6, N'Completed', N'PayPal'),
    (2043, 14, 2, 2, '2026-05-15', 4, N'Completed', N'Bank Transfer'),
    (2044, 19, 17, 3, '2026-08-20', 2, N'Pending', N'Debit Card'),
    (2045, 14, 6, 1, '2026-06-26', 7, N'Pending', N'Debit Card'),
    (2046, 18, 16, 1, '2026-04-30', 3, N'Completed', N'PayPal'),
    (2047, 1, 4, 5, '2026-01-15', 1, N'Completed', N'Bank Transfer'),
    (2048, 16, 6, 3, '2026-08-08', 5, N'Completed', N'PayPal'),
    (2049, 15, 4, 4, '2026-03-03', 4, N'Completed', N'Debit Card'),
    (2050, 21, 15, 5, '2026-02-07', 4, N'Completed', N'Bank Transfer'),
    (2051, 16, 15, 3, '2026-04-22', 7, N'Completed', N'Debit Card'),
    (2052, 19, 8, 1, '2026-04-18', 4, N'Pending', N'PayPal'),
    (2053, 13, 7, 2, '2026-01-12', 5, N'Pending', N'Credit Card'),
    (2054, 18, 4, 3, '2026-04-10', 5, N'Shipped', N'PayPal'),
    (2055, 9, 9, 4, '2026-02-28', 6, N'Completed', N'Bank Transfer'),
    (2056, 14, 14, 5, '2026-08-09', 3, N'Completed', N'Debit Card'),
    (2057, 17, 6, 2, '2026-01-09', 5, N'Cancelled', N'Bank Transfer'),
    (2058, 13, 16, 4, '2026-03-20', 4, N'Cancelled', N'Debit Card'),
    (2059, 16, 4, 3, '2026-03-20', 7, N'Shipped', N'Bank Transfer'),
    (2060, 14, 10, 2, '2026-07-08', 6, N'Cancelled', N'Bank Transfer'),
    (2061, 19, 6, 5, '2026-06-21', 6, N'Completed', N'Bank Transfer'),
    (2062, 13, 11, 2, '2026-01-12', 1, N'Pending', N'Bank Transfer'),
    (2063, 19, 9, 4, '2026-08-25', 1, N'Shipped', N'PayPal'),
    (2064, 9, 8, 4, '2026-06-17', 4, N'Pending', N'Credit Card'),
    (2065, 21, 1, 2, '2026-05-30', 4, N'Completed', N'Credit Card'),
    (2066, 9, 4, 4, '2026-05-13', 5, N'Completed', N'Debit Card'),
    (2067, 16, 16, 4, '2026-01-31', 5, N'Shipped', N'Debit Card'),
    (2068, 21, 3, 2, '2026-05-13', 3, N'Pending', N'Credit Card'),
    (2069, 10, 17, 5, '2026-08-17', 7, N'Completed', N'PayPal'),
    (2070, 19, 16, 4, '2026-07-19', 4, N'Completed', N'Bank Transfer'),
    (2071, 15, 2, 3, '2026-03-27', 3, N'Completed', N'Bank Transfer'),
    (2072, 3, 13, 4, '2026-03-21', 4, N'Completed', N'Debit Card'),
    (2073, 1, 2, 1, '2026-04-15', 2, N'Completed', N'Credit Card'),
    (2074, 2, 4, 5, '2026-05-02', 4, N'Shipped', N'PayPal'),
    (2075, 7, 8, 2, '2026-05-18', 3, N'Completed', N'Debit Card'),
    (2076, 13, 12, 3, '2026-06-07', 2, N'Pending', N'Credit Card'),
    (2077, 19, 9, 4, '2026-06-21', 1, N'Completed', N'Bank Transfer'),
    (2078, 4, 16, 1, '2026-07-10', 5, N'Cancelled', N'Credit Card'),
    (2079, 8, 13, 2, '2026-07-22', 2, N'Shipped', N'PayPal'),
    (2080, 20, 17, 4, '2026-08-11', 3, N'Completed', N'Debit Card');

INSERT INTO dbo.Returns (ReturnID, OrderID, ReturnDate, ReturnReason)
VALUES
    (3001, 2003, '2026-05-31', N'Changed mind'),
    (3002, 2008, '2026-07-04', N'Damaged item'),
    (3003, 2015, '2026-04-01', N'Wrong item'),
    (3004, 2021, '2026-03-19', N'Defective'),
    (3005, 2030, '2026-06-15', N'Arrived late'),
    (3006, 2038, '2026-02-18', N'Not as expected'),
    (3007, 2046, '2026-05-09', N'Changed mind'),
    (3008, 2055, '2026-03-10', N'Damaged item'),
    (3009, 2063, '2026-08-27', N'Wrong item'),
    (3010, 2074, '2026-05-05', N'Defective'),
    (3011, 2077, '2026-06-25', N'Arrived late'),
    (3012, 2079, '2026-07-27', N'Not as expected');

INSERT INTO dbo.InventorySnapshot (ProductID, StockOnHand, WarehouseZone, SnapshotDate)
VALUES
    (1, 24, N'A1', '2026-09-01'),
    (2, 8, N'A1', '2026-09-01'),
    (3, 15, N'A2', '2026-09-01'),
    (4, 63, N'B1', '2026-09-01'),
    (5, 42, N'B1', '2026-09-01'),
    (6, 19, N'B2', '2026-09-01'),
    (7, 51, N'B2', '2026-09-01'),
    (8, 28, N'C1', '2026-09-01'),
    (9, 13, N'C1', '2026-09-01'),
    (10, 34, N'C1', '2026-09-01'),
    (11, 18, N'D1', '2026-09-01'),
    (12, 9, N'D1', '2026-09-01'),
    (13, 6, N'D2', '2026-09-01'),
    (14, 37, N'E1', '2026-09-01'),
    (15, 29, N'E1', '2026-09-01'),
    (16, 12, N'F1', '2026-09-01'),
    (901, 4, N'LEGACY', '2026-09-01'),
    (902, 7, N'LEGACY', '2026-09-01');

GO

-- Basic verification only. These are not project answers.
SELECT 'Regions' AS TableName, COUNT(*) AS TotalCount FROM dbo.Regions
UNION ALL SELECT 'Customers', COUNT(*) FROM dbo.Customers
UNION ALL SELECT 'Products', COUNT(*) FROM dbo.Products
UNION ALL SELECT 'SalesReps', COUNT(*) FROM dbo.SalesReps
UNION ALL SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL SELECT 'Returns', COUNT(*) FROM dbo.Returns
UNION ALL SELECT 'InventorySnapshot', COUNT(*) FROM dbo.InventorySnapshot;
GO