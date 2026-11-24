SELECT 'categories' AS table_name, COUNT(*) AS total_records FROM categories
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

SELECT
    movement_type,
    COUNT(*) AS total_movements,
    SUM(quantity) AS total_quantity
FROM stock_movements
GROUP BY movement_type;

SELECT
    product_id,
    warehouse_id,
    SUM(
        CASE
            WHEN movement_type = 'IN' THEN quantity
            WHEN movement_type = 'OUT' THEN -quantity
            ELSE 0
        END
    ) AS net_movement
FROM stock_movements
GROUP BY product_id, warehouse_id
ORDER BY product_id, warehouse_id;

SELECT
    i.product_id,
    i.warehouse_id,
    i.quantity AS current_stock,
    COALESCE(
        SUM(
            CASE
                WHEN sm.movement_type = 'IN' THEN sm.quantity
                WHEN sm.movement_type = 'OUT' THEN -sm.quantity
                ELSE 0
            END
        ), 0
    ) AS net_movement
FROM inventory i
LEFT JOIN stock_movements sm
    ON i.product_id = sm.product_id
    AND i.warehouse_id = sm.warehouse_id
GROUP BY
    i.product_id,
    i.warehouse_id,
    i.quantity
ORDER BY i.product_id, i.warehouse_id;

SELECT COUNT(*) AS opening_movements
FROM stock_movements
WHERE movement_type = 'OPENING';

INSERT INTO stock_movements
(
    product_id,
    warehouse_id,
    movement_type,
    quantity,
    reference_type
)
SELECT
    product_id,
    warehouse_id,
    'OPENING',
    quantity,
    'BASELINE'
FROM inventory;

SELECT COUNT(*) AS opening_movements
FROM stock_movements
WHERE movement_type = 'OPENING';