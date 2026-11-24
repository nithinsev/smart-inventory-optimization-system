USE smart_inventory;

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

DELIMITER //

CREATE TRIGGER AfterSaleItemInsert
AFTER INSERT ON sale_items
FOR EACH ROW
BEGIN
    DECLARE v_warehouse_id INT;
    DECLARE v_sale_status VARCHAR(30);

    SELECT warehouse_id, sale_status
    INTO v_warehouse_id, v_sale_status
    FROM sales
    WHERE sale_id = NEW.sale_id;

    IF v_sale_status = 'Completed' THEN

        UPDATE inventory
        SET quantity = quantity - NEW.quantity
        WHERE product_id = NEW.product_id
          AND warehouse_id = v_warehouse_id;

        INSERT INTO stock_movements
        (
            product_id,
            warehouse_id,
            movement_type,
            quantity,
            reference_type,
            reference_id
        )
        VALUES
        (
            NEW.product_id,
            v_warehouse_id,
            'OUT',
            NEW.quantity,
            'SALE',
            NEW.sale_id
        );

    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforePurchaseItemInsert
BEFORE INSERT ON purchase_items
FOR EACH ROW
BEGIN
    IF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Purchase quantity must be greater than zero';
    END IF;

    IF NEW.unit_cost <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Purchase cost must be greater than zero';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER AfterPurchaseItemInsert
AFTER INSERT ON purchase_items
FOR EACH ROW
BEGIN
    DECLARE v_warehouse_id INT;
    DECLARE v_purchase_status VARCHAR(30);

    SELECT warehouse_id, purchase_status
    INTO v_warehouse_id, v_purchase_status
    FROM purchases
    WHERE purchase_id = NEW.purchase_id;

    IF v_purchase_status = 'Received' THEN

        INSERT INTO inventory
        (
            product_id,
            warehouse_id,
            quantity
        )
        VALUES
        (
            NEW.product_id,
            v_warehouse_id,
            NEW.quantity
        )
        ON DUPLICATE KEY UPDATE
            quantity = inventory.quantity + NEW.quantity;

        INSERT INTO stock_movements
        (
            product_id,
            warehouse_id,
            movement_type,
            quantity,
            reference_type,
            reference_id
        )
        VALUES
        (
            NEW.product_id,
            v_warehouse_id,
            'IN',
            NEW.quantity,
            'PURCHASE',
            NEW.purchase_id
        );

    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER BeforeInventoryUpdate
BEFORE UPDATE ON inventory
FOR EACH ROW
BEGIN
    IF NEW.quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inventory quantity cannot be negative';
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

SET @test_sale_id = LAST_INSERT_ID();

INSERT INTO sale_items
(
    sale_id,
    product_id,
    quantity,
    unit_price
)
VALUES
(
    @test_sale_id,
    1,
    2,
    45000.00
);

SELECT quantity
FROM inventory
WHERE product_id = 1
  AND warehouse_id = 1;

SELECT *
FROM stock_movements
WHERE reference_id = @test_sale_id
  AND reference_type = 'SALE';

ROLLBACK;

START TRANSACTION;

INSERT INTO purchases
(
    supplier_id,
    warehouse_id,
    purchase_date,
    purchase_status
)
VALUES
(
    1,
    1,
    CURDATE(),
    'Received'
);

SET @test_purchase_id = LAST_INSERT_ID();

INSERT INTO purchase_items
(
    purchase_id,
    product_id,
    quantity,
    unit_cost
)
VALUES
(
    @test_purchase_id,
    1,
    3,
    40000.00
);

SELECT quantity
FROM inventory
WHERE product_id = 1
  AND warehouse_id = 1;

SELECT *
FROM stock_movements
WHERE reference_id = @test_purchase_id
  AND reference_type = 'PURCHASE';

ROLLBACK;