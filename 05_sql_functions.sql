DELIMITER //

CREATE FUNCTION CalculateLineTotal(
    p_quantity INT,
    p_unit_price DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN p_quantity * p_unit_price;
END //

DELIMITER ;

SELECT CalculateLineTotal(5, 800.00) AS total_amount;

DELIMITER //

CREATE FUNCTION GetStockStatus(
    p_quantity INT,
    p_reorder_level INT
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_quantity = 0 THEN
        RETURN 'OUT OF STOCK';
    ELSEIF p_quantity <= p_reorder_level THEN
        RETURN 'LOW STOCK';
    ELSE
        RETURN 'IN STOCK';
    END IF;
END //

DELIMITER ;

SELECT GetStockStatus(5, 10) AS stock_status;

DELIMITER //

CREATE FUNCTION CalculateProfit(
    p_selling_price DECIMAL(10,2),
    p_purchase_cost DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN p_selling_price - p_purchase_cost;
END //

DELIMITER ;

SELECT CalculateProfit(800.00, 600.00) AS profit;

DELIMITER //

CREATE FUNCTION CalculateDiscountedPrice(
    p_original_price DECIMAL(10,2),
    p_discount_percentage DECIMAL(5,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN p_original_price -
           (p_original_price * p_discount_percentage / 100);
END //

DELIMITER ;

SELECT CalculateDiscountedPrice(1000.00, 10.00)
AS discounted_price;

DELIMITER //

CREATE FUNCTION CalculateInventoryValue(
    p_quantity INT,
    p_unit_price DECIMAL(10,2)
)
RETURNS DECIMAL(14,2)
DETERMINISTIC
BEGIN
    RETURN p_quantity * p_unit_price;
END //

DELIMITER ;

SELECT CalculateInventoryValue(10, 800.00)
AS inventory_value;

DELIMITER //

CREATE FUNCTION GetSaleCategory(
    p_sale_amount DECIMAL(12,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_sale_amount < 5000 THEN
        RETURN 'SMALL SALE';
    ELSEIF p_sale_amount <= 20000 THEN
        RETURN 'MEDIUM SALE';
    ELSE
        RETURN 'LARGE SALE';
    END IF;
END //

DELIMITER ;

SELECT GetSaleCategory(15000.00) AS sale_category;

DELIMITER //

CREATE FUNCTION CalculateTax(
    p_amount DECIMAL(12,2),
    p_tax_rate DECIMAL(5,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN p_amount * p_tax_rate / 100;
END //

DELIMITER ;

SELECT CalculateTax(10000.00, 18.00) AS tax_amount;

DELIMITER //

CREATE FUNCTION CalculateFinalAmount(
    p_amount DECIMAL(12,2),
    p_tax_rate DECIMAL(5,2)
)
RETURNS DECIMAL(14,2)
DETERMINISTIC
BEGIN
    RETURN p_amount + (p_amount * p_tax_rate / 100);
END //

DELIMITER ;

SELECT CalculateFinalAmount(10000.00, 18.00)
AS final_amount;

DELIMITER //

CREATE FUNCTION GetProductStockValue(
    p_product_id INT
)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_stock_value DECIMAL(14,2);

    SELECT COALESCE(SUM(i.quantity * p.unit_price), 0)
    INTO v_stock_value
    FROM inventory i
    JOIN products p
        ON i.product_id = p.product_id
    WHERE i.product_id = p_product_id;

    RETURN v_stock_value;
END //

DELIMITER ;

SELECT GetProductStockValue(1) AS total_stock_value;

DELIMITER //

CREATE FUNCTION GetTotalStockQuantity(
    p_product_id INT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total_quantity INT;

    SELECT COALESCE(SUM(quantity), 0)
    INTO v_total_quantity
    FROM inventory
    WHERE product_id = p_product_id;

    RETURN v_total_quantity;
END //

DELIMITER ;

SELECT GetTotalStockQuantity(1) AS total_stock;