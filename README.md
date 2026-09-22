# Northstar Retail SQL JOINs Project

## Project 2

This is the second Northstar Retail SQL mini project.

**Project 1** focused on foundational filtering.  
**Project 2** focuses on combining relational data with SQL JOINs.

You are a junior data analyst supporting **Northstar Retail**, a fictional technology retailer. The company has moved away from one flat order table. Customer, order, product, sales-representative, return, region, and inventory data are now stored separately.

Your job is to combine the correct tables to answer business requests.

---

## Skills Practiced

This project is designed around:

- `INNER JOIN`
- `LEFT JOIN`
- `RIGHT JOIN`
- `FULL OUTER JOIN`
- LEFT anti-join pattern
- RIGHT anti-join pattern
- FULL anti-join pattern
- `CROSS JOIN`
- Multiple-table JOINs
- Reusing Project 1 filtering skills:
  - `WHERE`
  - `AND`
  - `OR`
  - `NOT`
  - `BETWEEN`
  - `IN`
  - `LIKE`
  - `ORDER BY`

The project intentionally avoids aggregation, subqueries, CTEs, and window functions so you can focus on JOINs.

---

## Database

The setup script creates:

```text
NorthstarJoinsDB
```

### Tables

| Table | Purpose |
| --- | --- |
| `dbo.Customers` | Customer information |
| `dbo.Orders` | Order transactions and foreign keys |
| `dbo.Products` | Current product catalog |
| `dbo.SalesReps` | Sales representatives |
| `dbo.Regions` | Region lookup |
| `dbo.Returns` | Returned-order information |
| `dbo.InventorySnapshot` | Legacy warehouse inventory snapshot |

---

## Relationship Map

```text
Regions
  │
  ├────< Customers
  │         │
  │         └────< Orders >──── Products
  │                   │
  │                   ├──── SalesReps >──── Regions
  │                   │
  │                   └──── Returns
  │
  └─────────────────────────────

Products  ─ ─ ─  InventorySnapshot
           ProductID
```

Primary relationships:

```text
Customers.CustomerID   → Orders.CustomerID
Products.ProductID     → Orders.ProductID
SalesReps.SalesRepID   → Orders.SalesRepID
Regions.RegionID       → Customers.RegionID
Regions.RegionID       → SalesReps.RegionID
Orders.OrderID         → Returns.OrderID
```

`InventorySnapshot` is intentionally different.

It represents an imported **legacy warehouse snapshot**, so there is no foreign-key constraint between it and `Products`. The file intentionally contains some retired ProductIDs that no longer exist in the current product catalog. The current catalog also contains products that are missing from the snapshot.

That mismatch is there specifically so your `FULL JOIN` and anti-join exercises have something meaningful to find.

---

## Intentional Unmatched Data

Do not "fix" these records. They are part of the exercise.

The dataset intentionally contains:

- customers who have never placed an order
- products that have never been ordered
- a sales representative with no orders
- products missing from the inventory snapshot
- legacy inventory ProductIDs missing from the current product table
- orders with no return record

These differences are what make OUTER JOINs useful.

---

## Repository Structure

```text
northstar-retail-sql-joins-project/
├── .gitignore
├── README.md
├── data/
│   ├── customers.csv
│   ├── inventory_snapshot.csv
│   ├── orders.csv
│   ├── products.csv
│   ├── regions.csv
│   ├── returns.csv
│   └── sales_reps.csv
├── setup/
│   └── northstar_joins_setup.sql
└── sql/
    └── analyst_tickets.sql
```

---

## Setup

1. Create or clone your GitHub repository.
2. Add the starter files to the repository.
3. Open SQL Server Management Studio.
4. Open:

```text
setup/northstar_joins_setup.sql
```

5. Execute the entire script.

The script creates `NorthstarJoinsDB`, creates the tables, establishes the relational keys, and loads the training data.

You only need to rerun the setup script if you want to reset the project database.

---

## Working the Tickets

Open:

```text
sql/analyst_tickets.sql
```

Treat each section as if it were a ticket from a business team.

Recommended workflow:

```text
Read request
   ↓
Identify required output columns
   ↓
Determine which table contains each column
   ↓
Identify the relationship / matching key
   ↓
Choose the JOIN type
   ↓
Write query
   ↓
Validate results
   ↓
Clean up query
   ↓
Commit to Git
```

For each ticket:

- write the SQL yourself
- end the final query with a semicolon
- include a short result/validation comment
- remove unnecessary scratch queries before committing
- do not modify the source CSV files to solve a ticket

---

## JOIN Thinking Checklist

Before writing a JOIN, ask:

1. **What is my starting table?**
2. **Which table has the missing information I need?**
3. **Which columns connect those tables?**
4. **Do I want only matches, or must unmatched rows remain?**
5. **Could the JOIN create multiple rows because of a one-to-many relationship?**
6. **If I filter after an OUTER JOIN, could my `WHERE` clause accidentally remove the unmatched rows?**

That last question becomes especially important as your JOINs get more complex.

---

## Git Workflow

A reasonable starting commit:

```text
Add Northstar JOINs project starter files
```

Then commit in logical chunks rather than after every keystroke. Examples:

```text
Complete introductory INNER JOIN tickets
Complete outer JOIN practice tickets
Complete anti JOIN exercises
Complete multi-table JOIN reports
Complete Northstar JOINs project
```

Your commit history is part of the project. It shows how the work developed.

---

## Project Goal

The goal is not merely to memorize JOIN syntax.

By the end of the project, you should be able to look at a business request and determine:

- which tables contain the needed data
- how those tables relate
- which JOIN preserves the rows the requester cares about
- how multiple JOINs work together in one report

That decision-making is the real skill being practiced.
