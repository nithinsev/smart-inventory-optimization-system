USE smart_inventory;

SELECT CURRENT_USER();

SHOW GRANTS;

CREATE ROLE 'inventory_viewer';

GRANT SELECT
ON smart_inventory.*
TO 'inventory_viewer';

CREATE ROLE 'inventory_manager';

GRANT SELECT, INSERT, UPDATE
ON smart_inventory.inventory
TO 'inventory_manager';

CREATE ROLE 'sales_analyst';

GRANT SELECT
ON smart_inventory.sales
TO 'sales_analyst';

GRANT SELECT
ON smart_inventory.sale_items
TO 'sales_analyst';

CREATE ROLE 'purchase_manager'; 

GRANT SELECT, INSERT, UPDATE
ON smart_inventory.purchases
TO 'purchase_manager';

GRANT SELECT, INSERT, UPDATE
ON smart_inventory.purchase_items
TO 'purchase_manager';

GRANT SELECT, INSERT, UPDATE
ON smart_inventory.purchases
TO 'purchase_manager';

CREATE ROLE 'inventory_admin';

GRANT ALL PRIVILEGES
ON smart_inventory.*
TO 'inventory_admin';

SELECT
    User,
    Host
FROM mysql.user
WHERE user IN (
    'inventory_viewer',
    'inventory_manager',
    'sales_analyst',
    'purchase_manager',
    'inventory_admin'
);

SHOW GRANTS FOR 'inventory_viewer';

SHOW GRANTS FOR 'inventory_manager';

SHOW GRANTS FOR 'sales_analyst';

SHOW GRANTS FOR 'sales_analyst';

SHOW GRANTS FOR 'purchase_manager';

SHOW GRANTS FOR 'inventory_admin';

CREATE USER 'viewer_user'@'localhost'
IDENTIFIED BY 'YourOwnStrongPassword';

GRANT 'inventory_viewer'
TO 'viewer_user'@'localhost';

SET DEFAULT ROLE 'inventory_viewer'
TO 'viewer_user'@'localhost';

CREATE USER 'manager_user'@'localhost'
IDENTIFIED BY 'YourOwnStrongPassword';

GRANT 'inventory_manager'
TO 'manager_user'@'localhost';

SET DEFAULT ROLE 'inventory_manager'
TO 'manager_user'@'localhost';

CREATE USER 'analyst_user'@'localhost'
IDENTIFIED BY 'YourOwnStrongPassword';

GRANT 'sales_analyst'
TO 'analyst_user'@'localhost';

SET DEFAULT ROLE 'sales_analyst'
TO 'analyst_user'@'localhost';

CREATE USER 'purchase_user'@'localhost'
IDENTIFIED BY 'YourOwnStrongPassword';

GRANT 'purchase_manager'
TO 'purchase_user'@'localhost';

SET DEFAULT ROLE 'purchase_manager'
TO 'purchase_user'@'localhost';

SELECT
    User,
    Host
FROM mysql.user
WHERE User IN (
    'viewer_user',
    'manager_user',
    'analyst_user',
    'purchase_user'
);

SELECT
    FROM_USER AS role_name,
    TO_USER AS assigned_user
FROM mysql.role_edges
WHERE TO_USER IN (
    'viewer_user',
    'manager_user',
    'analyst_user',
    'purchase_user'
)
ORDER BY TO_USER;

ALTER USER 'viewer_user'@'localhost'
IDENTIFIED BY 'NewPrivatePassword123!';

ALTER USER 'manager_user'@'localhost'
IDENTIFIED BY 'ManagerPrivatePass123!';

ALTER USER 'analyst_user'@'localhost'
IDENTIFIED BY 'YourNewPrivatePassword!';

GRANT SELECT
ON smart_inventory.sales
TO 'sales_analyst';

ALTER USER 'purchase_user'@'localhost'
IDENTIFIED BY 'ChooseYourPrivatePassword!';

CREATE USER 'admin_user'@'localhost'
IDENTIFIED BY 'ChooseYourPrivatePassword!';

GRANT 'inventory_admin' TO 'admin_user'@'localhost';

SET DEFAULT ROLE 'inventory_admin'
TO 'admin_user'@'localhost';

SHOW GRANTS FOR 'inventory_admin';

SHOW GRANTS FOR 'admin_user'@'localhost';

--------------------------------------------------------------------------------

USE smart_inventory;

SHOW TABLES;

SELECT 'categories' AS table_name, COUNT(*) AS total_rows FROM categories
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'warehouses', COUNT(*) FROM warehouses
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'purchases', COUNT(*) FROM purchases
UNION ALL
SELECT 'purchase_items', COUNT(*) FROM purchase_items
UNION ALL
SELECT 'sales', COUNT(*) FROM sales
UNION ALL
SELECT 'sale_items', COUNT(*) FROM sale_items
UNION ALL
SELECT 'stock_movements', COUNT(*) FROM stock_movements;


SHOW PROCEDURE STATUS
WHERE Db = 'smart_inventory';

SHOW FUNCTION STATUS
WHERE Db = 'smart_inventory';

SHOW TRIGGERS
FROM smart_inventory;

SHOW FULL TABLES
IN smart_inventory
WHERE TABLE_TYPE = 'VIEW';