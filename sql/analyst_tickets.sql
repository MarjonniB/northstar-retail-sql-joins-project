USE NorthstarJoinsDB

/*
Northstar Retail - SQL JOINs Project
File: analyst_tickets.sql

Scenario:
You are continuing as a junior data analyst for Northstar Retail.
The company has moved from one flat order table to a relational database.

Rules:
- Use only concepts you have learned so far.
- End each completed query with a semicolon.
- Add a short comment describing what the query returns.
- Validate your results before committing.
- Do NOT use GROUP BY, aggregate functions, subqueries, CTEs, or window functions.
- The early tickets include stronger JOIN hints. Later tickets make you decide.
- SQL Server does not have a literal LEFT ANTI JOIN keyword; use the anti-join
  pattern you learned in the course.

USE NorthstarJoinsDB;
GO
*/


/* ============================================================
TICKET 01 — Customer Order Lookup

From: Customer Service

Request:
"Show orders alongside the customer who placed them.

Return:
OrderID, OrderDate, CustomerID, CustomerName, State, OrderStatus.

Sort by OrderID."

Practice focus: INNER JOIN
============================================================ */

-- Write your query below:
SELECT 
	o.OrderID,
	o.OrderDate,
	c.CustomerID,
	c.CustomerName,
	c.State,
	o.OrderStatus
FROM dbo.Orders as o
INNER JOIN dbo.Customers AS c
ON o.CustomerID = c.CustomerID
ORDER BY o.OrderID;

-- Joined Orders to Customers using CustomerID.
-- Returned 80 matching order records with customer details.
-- Sorted by OrderID ascending.




/* ============================================================
TICKET 02 — Product Order Detail

From: Product Team

Request:
"Show each order with the product information attached.

Return:
OrderID, ProductID, ProductName, ProductCategory,
Quantity, UnitPrice.

Sort by OrderID."

Practice focus: INNER JOIN
============================================================ */

-- Write your query below:

SELECT 
	o.OrderID,
	p.ProductID,
	p.ProductName,
	p.ProductCategory,
	o.Quantity,
	p.UnitPrice
FROM dbo.Orders AS o
INNER JOIN dbo.Products AS p
ON o.ProductID = p.ProductID
ORDER BY o.OrderID;

--Joined Orders to Products using ProductID.
--Returned 80 matching orders with order details. 
--Sorted by OrderID ascending.


/* ============================================================
TICKET 03 — Customer Coverage Review

From: Marketing

Request:
"Give me every customer and any orders they have placed.
Customers who have never placed an order MUST still appear.

Return:
CustomerID, CustomerName, CustomerType, OrderID, OrderDate,
OrderStatus.

Sort by CustomerID, then OrderID."

Practice focus: LEFT JOIN
============================================================ */

-- Write your query below:

SELECT 
	c.CustomerID,
	c.CustomerName,
	C.CustomerType,
	o.OrderID,
	o.OrderDate,
	o.OrderStatus
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerID, o.OrderID;

-- Joined all customers with any matching orders.
-- Customers without orders are still included with NULL order fields.
-- Validation: 83 rows returned.
-- Sorted by CustomerID, then OrderID.




/* ============================================================
TICKET 04 — Legacy Inventory Review

From: Warehouse Operations

Request:
"Our legacy inventory snapshot may contain retired ProductIDs
that no longer exist in the current Products table.

Show EVERY record from InventorySnapshot and attach the current
ProductName and ProductCategory when a match exists.

Return:
Inventory ProductID, ProductName, ProductCategory,
StockOnHand, WarehouseZone.

Sort by ProductID."

Practice focus: RIGHT JOIN
Note: Build the query so InventorySnapshot is the RIGHT table.
============================================================ */

-- Write your query below:

SELECT 
	i.ProductID AS InventoryProductID,
	p.ProductName,
	p.ProductCategory,
	i.StockOnHand,
	i.WarehouseZone
FROM  dbo.Products as p
RIGHT JOIN dbo.InventorySnapshot AS i
ON i.ProductID	= p.ProductID
ORDER BY i.ProductID;

--Joined Products with InventorySnapshot using ProductID
--Returned 18 records to include all records from InventorySnapshot
--Sorted by Inventory ProductID


/* ============================================================
TICKET 05 — Product / Inventory Reconciliation

From: Inventory Control

Request:
"Compare the current product catalog with the legacy inventory
snapshot. I need ALL records from BOTH sides, even when there
is no matching ProductID.

Return:
ProductID from Products,
ProductName,
ProductID from InventorySnapshot,
StockOnHand,
WarehouseZone.

Sort by Products.ProductID, then InventorySnapshot.ProductID."

Practice focus: FULL OUTER JOIN
============================================================ */

-- Write your query below:
SELECT 
	p.ProductID AS ProductCatelogID,
	p.ProductName,
	i.ProductID AS InventoryProductID,
	i.StockOnHand,
	i.WarehouseZone
FROM dbo.Products AS p
FULL JOIN dbo.InventorySnapshot AS i
ON p.ProductID = i.ProductID
ORDER BY p.ProductID, i.ProductID;

-- Joined the current Products table with the legacy InventorySnapshot table.
-- Returned 22 rows, including matched and unmatched ProductIDs from both tables.
-- Sorted by Products.ProductID, then InventorySnapshot.ProductID.


/* ============================================================
TICKET 06 — Customers With No Orders

From: Retention Marketing

Request:
"Find customers who have never placed an order.

Return:
CustomerID, CustomerName, State, CustomerType.

Sort alphabetically by CustomerName."

Practice focus: LEFT ANTI JOIN pattern
============================================================ */

-- Write your query below:
SELECT 
	c.CustomerID,
	c.CustomerName,
	c.State,
	c.CustomerType
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL
ORDER BY c.CustomerName;

-- Returned customers with no matching orders.
-- Validation: 3 customers returned.
-- Sorted alphabetically by CustomerName.


/* ============================================================
TICKET 07 — Retired Inventory IDs

From: Warehouse Operations

Request:
"Find inventory snapshot records whose ProductID no longer
exists in the current Products table.

Return:
ProductID, StockOnHand, WarehouseZone, SnapshotDate.

Sort by ProductID."

Practice focus: RIGHT ANTI JOIN pattern
Note: Practice this using RIGHT JOIN.
============================================================ */

-- Write your query below:
SELECT 
	i.ProductID AS InventoryProductID,
	i.StockOnHand,
	i.WarehouseZone,
	i.SnapshotDate
FROM dbo.Products AS p
RIGHT JOIN dbo.InventorySnapshot AS i
	ON i.ProductID = p.ProductID
WHERE p.ProductID IS NULL
ORDER BY i.ProductID;

-- Returned inventory snapshot records with no matching current ProductID.
--Validation: 2 snapshot records returned
--Sorted by Inventory Product ID

/* ============================================================
TICKET 08 — Unmatched Product Records

From: Data Quality

Request:
"Show anything that exists on only ONE side of the current
Products table and the legacy InventorySnapshot.

In other words:
- current products missing from the snapshot
- legacy snapshot ProductIDs missing from current products

Return:
Products.ProductID,
ProductName,
InventorySnapshot.ProductID,
StockOnHand,
WarehouseZone."

Practice focus: FULL ANTI JOIN pattern
============================================================ */

-- Write your query below:
SELECT 
	p.ProductID,
	p.ProductName,
	i.ProductID AS LegacyProductID,
	i.StockOnHand,
	i.WarehouseZone
FROM dbo.Products AS p
FULL JOIN dbo.InventorySnapshot AS i
	ON p.ProductID = i.ProductID
WHERE i.ProductID IS NULL
	OR p.ProductID IS NULL;

-- Returned records that exist on only one side of Products and InventorySnapshot.
-- Validation: 6 unmatched records returned.


/* ============================================================
TICKET 09 — Territory Planning Matrix

From: Sales Leadership

Request:
"We are planning future territory coverage. Create every
possible combination of SalesRep and Region.

Return:
SalesRepID, SalesRepName, RegionID, RegionName.

Sort by SalesRepID, then RegionID."

Practice focus: CROSS JOIN
============================================================ */

-- Write your query below:
SELECT 
	s.SalesRepID,
	s.SalesRepName,
	r.RegionID,
	r.RegionName
FROM dbo.SalesReps AS s
CROSS JOIN dbo.Regions AS r
ORDER BY s.SalesRepID, r.RegionID;

-- Created every possible SalesRep and Region combination.
-- Validation: 24 combinations returned.
-- Sorted by SalesRepID, then RegionID.


/* ============================================================
TICKET 10 — Regional Order Investigation

From: Regional Director

Request:
"Show West-region customers and their orders that are either
Pending or Shipped.

Return:
OrderID, CustomerName, State, RegionName,
OrderDate, OrderStatus.

Sort by OrderDate from newest to oldest."

Practice focus:
You decide which JOIN(s) are needed.
Also reuse your filtering skills from Project 1.
============================================================ */

-- Write your query below:
SELECT 
	o.OrderID,
	c.CustomerName,
	c.State,
	r.RegionName,
	o.OrderDate,
	o.OrderStatus
FROM dbo.Customers AS c
INNER JOIN dbo.Regions AS r
	ON c.RegionID = r.RegionID
INNER JOIN dbo.Orders AS o
	ON c.CustomerID = o.CustomerID
WHERE (o.OrderStatus = 'Pending' OR o.OrderStatus = 'Shipped') 
	AND r.RegionName = 'WEST'
ORDER BY o.OrderDate DESC;

--Created west-region customers only with orders pending or shipped
--Validation: 8 records returned 
--Sorted by OrderDate newest to oldest
--INNER JOINED used to find matching orders


/* ============================================================
TICKET 11 — Sales Detail Report

From: Sales Operations

Request:
"Create an order-detail report that combines the order with
the customer, product, and sales representative.

Return:
OrderID,
OrderDate,
CustomerName,
State,
ProductName,
ProductCategory,
Quantity,
UnitPrice,
SalesRepName,
OrderStatus.

Sort by OrderID."

Practice focus: MULTIPLE TABLE JOINs
============================================================ */

-- Write your query below:

SELECT 
	o.OrderID,
	o.OrderDate,
	c.CustomerName,
	c.State,
	p.ProductName,
	p.ProductCategory,
	o.Quantity,
	p.UnitPrice,
	s.SalesRepName,
	o.OrderStatus
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c
	ON c.CustomerID = o.CustomerID
INNER JOIN dbo.Products AS p
	ON o.ProductID = p.ProductID
INNER JOIN dbo.SalesReps AS s
	ON o.SalesRepID = s.SalesRepID
ORDER BY o.OrderID;

--Created an Order report with Customers, Products, and the Sales Reps
--Validation: 80 records returned 
--Sorted by Ascending order by the Order ID



/* ============================================================
TICKET 12 — Returned Order Investigation

From: Customer Experience

Request:
"Show every returned order with the customer and product
involved.

Return:
ReturnID,
OrderID,
ReturnDate,
ReturnReason,
CustomerName,
ProductName,
Quantity,
OrderStatus.

Sort by ReturnDate from newest to oldest."

Practice focus: MULTIPLE TABLE JOINs
============================================================ */

-- Write your query below:
SELECT 
	r.ReturnID,
	o.OrderID,
	r.ReturnDate,
	r.ReturnReason,
	c.CustomerName,
	p.ProductName,
	o.Quantity,
	o.OrderStatus
FROM dbo.Returns AS r
INNER JOIN dbo.Orders AS o
	ON r.OrderID = o.OrderID	
INNER JOIN dbo.Customers AS c
	ON c.CustomerID = o.CustomerID
INNER JOIN dbo.Products AS p
	ON o.ProductID = p.ProductID
ORDER BY r.ReturnDate DESC;

--Returned orders that have been returned.
--Validation: 12 records returned. 
--Ordered by Return Date, newest to oldest.
--Complete returned order investigation

--DEBUGGING--
/*
SELECT COUNT(*)
FROM dbo.Returns AS r
INNER JOIN dbo.Orders AS o
    ON r.OrderID = o.OrderID
INNER JOIN dbo.Customers AS c
	ON c.CustomerID = o.CustomerID
INNER JOIN dbo.Products AS p
	ON o.ProductID = p.ProductID 
*/
	



/* ============================================================
FINAL CHALLENGE — Q2 Sales & Returns Review

From: Director of Operations

Request:
"For orders placed from April 1, 2026 through June 30, 2026,
show orders that are Completed or Shipped.

I need:
OrderID,
OrderDate,
CustomerName,
State,
RegionName,
ProductName,
ProductCategory,
Quantity,
UnitPrice,
SalesRepName,
OrderStatus,
ReturnDate,
ReturnReason.

IMPORTANT:
Orders that were NOT returned must still appear.
If an order has no return, ReturnDate and ReturnReason may be NULL.

Sort by OrderDate from earliest to latest, then OrderID."

Practice focus:
- Multiple INNER JOINs
- One OUTER JOIN
- Filtering
- IN
- BETWEEN
- ORDER BY

Do not use concepts beyond what you have learned.
============================================================ */

-- Write your query below:

SELECT 
	o.OrderID,
	o.OrderDate,
	c.CustomerName,
	c.State,
	re.RegionName,
	p.ProductName,
	p.ProductCategory,
	o.Quantity,
	p.UnitPrice,
	s.SalesRepName,
	o.OrderStatus,
	r.ReturnDate,
	r.ReturnReason
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c
	ON o.CustomerID = c.CustomerID
LEFT JOIN dbo.Returns AS r
	ON o.OrderID = r.OrderID
INNER JOIN dbo.Products AS p
	ON o.ProductID = p.ProductID
INNER JOIN dbo.SalesReps AS s
	ON s.SalesRepID = o.SalesRepID
INNER JOIN dbo.Regions as re
	ON c.RegionID = re.RegionID
WHERE o.OrderStatus IN ('Shipped', 'Completed')
AND o.OrderDate BETWEEN '2026-04-01' AND '2026-06-30'
ORDER BY o.OrderDate, o.OrderID;

--Returned orders between April 1st, through June 30th 2026 showing completed or shipped with orders returned or not returned. 
--Validation: 19 records returned
--Ascending Order By Order Date and ID
