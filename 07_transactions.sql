START TRANSACTION;

UPDATE inventory
SET quantity = quantity - 1
WHERE product_id = 1
  AND warehouse_id = 1;

SELECT quantity
FROM inventory
WHERE product_id = 1
  AND warehouse_id = 1;

ROLLBACK;

SELECT quantity
FROM inventory
WHERE product_id = 1
  AND warehouse_id = 1;
  
START TRANSACTION;

UPDATE inventory
SET quantity = quantity + 1
WHERE product_id = 1
  AND warehouse_id = 1;

COMMIT;

SELECT quantity
FROM inventory
WHERE product_id = 1
  AND warehouse_id = 1;
  
START TRANSACTION;

UPDATE inventory
SET quantity = quantity + 1
WHERE product_id = 1
  AND warehouse_id = 1;

SELECT quantity
FROM inventory
WHERE product_id = 1
  AND warehouse_id = 1;
  
UPDATE inventory
SET quantity = quantity + 1
WHERE product_id = 1
  AND warehouse_id = 1;
  
SELECT quantity
FROM inventory
WHERE product_id = 1
  AND warehouse_id = 1;
  
START TRANSACTION;

UPDATE inventory
SET quantity = quantity - 1
WHERE product_id = 1
  AND warehouse_id = 1;

SELECT quantity
FROM inventory
WHERE product_id = 1
  AND warehouse_id = 1;

COMMIT;

START TRANSACTION;

INSERT INTO sales
(
    warehouse_id,
    sale_date,
    sale_status
)
VALUES
(
    1,
    CURDATE(),
    'Completed'
);

SET @sale_id = LAST_INSERT_ID();

INSERT INTO sale_items
(
    sale_id,
    product_id,
    quantity,
    unit_price
)
VALUES
(
    @sale_id,
    1,
    1,
    45000.00
);

COMMIT;

SELECT quantity
FROM inventory
WHERE product_id = 1
  AND warehouse_id = 1;
  
SELECT
    sale_id,
    warehouse_id,
    sale_date,
    sale_status
FROM sales
ORDER BY sale_id DESC
LIMIT 3;

SELECT *
FROM stock_movements
WHERE reference_type = 'SALE'
ORDER BY movement_id DESC
LIMIT 5;

SELECT MAX(sale_id) AS latest_sale_id
FROM sales;

SHOW TRIGGERS
WHERE `Table` = 'sale_items';

DROP TRIGGER BeforeSaleItemInsert;

DELIMITER //

CREATE TRIGGER BeforeSaleItemInsert
BEFORE INSERT ON sale_items
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;

    SELECT COALESCE(
        (
            SELECT i.quantity
            FROM inventory i
            JOIN sales s
                ON i.warehouse_id = s.warehouse_id
            WHERE i.product_id = NEW.product_id
              AND s.sale_id = NEW.sale_id
        ), -1
    )
    INTO v_stock;

    IF v_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for this sale';
    END IF;
END //

DELIMITER ;

START TRANSACTION;

INSERT INTO sales
(
    warehouse_id,
    sale_date,
    sale_status
)
VALUES
(
    1,
    CURDATE(),
    'Completed'
);

SET @sale_id = LAST_INSERT_ID();

INSERT INTO sale_items
(
    sale_id,
    product_id,
    quantity,
    unit_price
)
VALUES
(
    @sale_id,
    1,
    1,
    45000.00
);

SELECT quantity
FROM inventory
WHERE product_id = 1
  AND warehouse_id = 1;

COMMIT;

SELECT
    p.product_name,
    w.warehouse_name,
    i.quantity
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
WHERE i.product_id = 1
  AND i.warehouse_id = 1;
  
  SELECT *
FROM stock_movements
WHERE reference_type = 'SALE'
ORDER BY movement_id DESC
LIMIT 1;

SELECT *
FROM sales
ORDER BY sale_id DESC
LIMIT 3;

SELECT *
FROM sale_items
ORDER BY sale_item_id DESC
LIMIT 3;

START TRANSACTION;

INSERT INTO sales
(
    warehouse_id,
    sale_date,
    sale_status
)
VALUES
(
    1,
    CURDATE(),
    'Completed'
);

SET @sale_id = LAST_INSERT_ID();

INSERT INTO sale_items
(
    sale_id,
    product_id,
    quantity,
    unit_price
)
VALUES
(
    @sale_id,
    1,
    1,
    45000.00
);

SELECT quantity
FROM inventory
WHERE product_id = 1
  AND warehouse_id = 1;
  
COMMIT;

START TRANSACTION;

INSERT INTO sales
(
    warehouse_id,
    sale_date,
    sale_status
)
VALUES
(
    1,
    CURDATE(),
    'Completed'
);

SET @sale_id = LAST_INSERT_ID();

INSERT INTO sale_items
(
    sale_id,
    product_id,
    quantity,
    unit_price
)
VALUES
(
    @sale_id,
    1,
    100,
    45000.00
);

ROLLBACK;

SELECT *
FROM sales
ORDER BY sale_id DESC
LIMIT 3;