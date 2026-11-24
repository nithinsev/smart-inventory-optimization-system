# Smart Inventory Optimization System using SQL Analytics

## 1. Project Overview

The Smart Inventory Optimization System is a database-driven inventory management project developed using MySQL.

It is designed for an electronics retail business that purchases products from suppliers, stores them in multiple warehouses and sells them to customers.

The system manages product details, supplier information, warehouse inventory, purchase records, sales transactions and stock movement history.

It uses advanced SQL concepts to manage inventory operations, maintain data consistency and generate useful business reports.

## 2. Project Objectives

- Maintain product, supplier and warehouse information.
- Track inventory quantities across multiple warehouses.
- Record purchases and sales transactions.
- Automatically update stock using triggers.
- Identify low-stock products.
- Analyze sales and product performance.
- Generate daily sales and inventory reports.
- Apply database security through roles and permissions.
- Improve query performance using indexes and query optimization.

## 3. Technologies Used

- **Database:** MySQL 8.0
- **Database Tool:** MySQL Workbench
- **Query Language:** SQL
- **Operating System:** Windows

## 4. Database Structure

The project contains the following main tables:

1. categories
2. products
3. suppliers
4. warehouses
5. inventory
6. purchases
7. purchase_items
8. sales
9. sale_items
10. stock_movements

An additional `sales_archive` table is used to demonstrate table partitioning.

## 5. Advanced SQL Concepts Implemented

### Stored Procedures
Created 10 stored procedures for retrieving product details, stock information, supplier purchase history, warehouse summaries and daily sales reports.

### SQL Functions
Created 10 user-defined functions for calculating line totals, profit, discounts, tax, inventory value and stock status.

### Triggers
Implemented 5 triggers to validate sales and purchase entries, update inventory automatically and prevent negative stock quantities.

### Transactions
Demonstrated transaction management using START TRANSACTION, COMMIT and ROLLBACK, including successful and failed sales scenarios.

### Window Functions
Used RANK(), DENSE_RANK() and ROW_NUMBER() for product ranking, category-wise ranking and top-product analysis.

### Query Optimization
Used indexes, EXPLAIN and EXPLAIN ANALYZE to study query execution and improve product search performance.

### Partitioning
Implemented RANGE partitioning on the `sales_archive` table based on the year of the sale date.

### User Roles and Permissions
Created five roles:
- inventory_viewer
- inventory_manager
- sales_analyst
- purchase_manager
- inventory_admin

Created separate database users and tested their access permissions.

### Views
Created `vw_daily_sales_report` to display daily completed sales counts and revenue.

### Replication
Enabled and inspected binary logging, server ID and binary log status. A second replica server was not configured, so actual replication remains a future enhancement.

## 6. Project Workflow

1. Products and suppliers are maintained in the database.
2. Purchase records are created for incoming products.
3. Purchase triggers update warehouse inventory when purchases are received.
4. Sales records are created for customer transactions.
5. Sales triggers check available stock and update inventory after completed sales.
6. Stock movements maintain a record of inventory operations.
7. SQL reports and analytical queries help monitor inventory and sales performance.

## 7. Project Folder Structure

```text
Smart_Inventory_Optimization_System/
│
├── schema/
│   └── 01_create_tables.sql
│
├── seed_data/
│   └── 02_insert_sample_data.sql
│
├── analysis/
│   └── 03_data_validation.sql
│
├── procedures/
│   └── 04_stored_procedures.sql
│
├── functions/
│   └── 05_sql_functions.sql
│
├── triggers/
│   └── 06_triggers.sql
│
├── transactions/
│   └── 07_transactions.sql
│
├── window_functions/
│   └── 08_window_functions.sql
│
├── partitioning/
│   └── 09_partitioning.sql
│
├── replication/
│   └── 10_replication.sql
│
├── security/
│   └── 11_user_roles_permissions.sql
│
├── views/
│   └── 12_views.sql
│
└── README.md
```

## 8. Conclusion

The Smart Inventory Optimization System demonstrates how MySQL and advanced SQL concepts can be used to develop a practical inventory management database.

The project provides structured data management, automated stock updates, transaction handling, analytical reporting and role-based access control.

It helps an electronics retail business monitor inventory, analyze sales performance and make better purchasing decisions.
