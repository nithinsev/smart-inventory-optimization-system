DELIMITER //

CREATE PROCEDURE GetAllProducts()
BEGIN

    SELECT *
    FROM products;

END //

DELIMITER ;

CALL GetAllProducts();

DELIMITER //

CREATE PROCEDURE GetProductsByCategory(
    IN p_category_id INT
)
BEGIN

    SELECT
        product_id,
        product_name,
        category_id,
        unit_price,
        reorder_level
    FROM products
    WHERE category_id = p_category_id;

END //

DELIMITER ;

CALL GetProductsByCategory(3);

DELIMITER //

CREATE PROCEDURE GetStockByProductAndWarehouse(
    IN p_product_id INT,
    IN p_warehouse_id INT
)
BEGIN
    SELECT
        p.product_name,
        w.warehouse_name,
        i.quantity,
        i.last_updated
    FROM inventory i
    JOIN products p
        ON i.product_id = p.product_id
    JOIN warehouses w
        ON i.warehouse_id = w.warehouse_id
    WHERE i.product_id = p_product_id
      AND i.warehouse_id = p_warehouse_id;
END //

DELIMITER ;

CALL GetStockByProductAndWarehouse(1, 1);

DELIMITER //

CREATE PROCEDURE GetLowStockProducts()
BEGIN
    SELECT
        p.product_id,
        p.product_name,
        w.warehouse_name,
        i.quantity,
        p.reorder_level
    FROM inventory i
    JOIN products p
        ON i.product_id = p.product_id
    JOIN warehouses w
        ON i.warehouse_id = w.warehouse_id
    WHERE i.quantity <= p.reorder_level
    ORDER BY i.quantity ASC;
END //

DELIMITER ;

CALL GetLowStockProducts();

DELIMITER //

CREATE PROCEDURE GetSupplierPurchaseHistory(
    IN p_supplier_id INT
)
BEGIN
    SELECT
        pu.purchase_id,
        s.supplier_name,
        w.warehouse_name,
        pu.purchase_date,
        pu.purchase_status
    FROM purchases pu
    JOIN suppliers s
        ON pu.supplier_id = s.supplier_id
    JOIN warehouses w
        ON pu.warehouse_id = w.warehouse_id
    WHERE pu.supplier_id = p_supplier_id
    ORDER BY pu.purchase_date DESC;
END //

DELIMITER ;

CALL GetSupplierPurchaseHistory(1);

DELIMITER //

CREATE PROCEDURE GetSalesByWarehouse(
    IN p_warehouse_id INT
)
BEGIN
    SELECT
        s.sale_id,
        w.warehouse_name,
        s.sale_date,
        s.sale_status
    FROM sales s
    JOIN warehouses w
        ON s.warehouse_id = w.warehouse_id
    WHERE s.warehouse_id = p_warehouse_id
    ORDER BY s.sale_date DESC;
END //

DELIMITER ;

CALL GetSalesByWarehouse(1);

DELIMITER //

CREATE PROCEDURE GetProductSalesSummary()
BEGIN
    SELECT
        p.product_id,
        p.product_name,
        SUM(si.quantity) AS total_quantity_sold,
        SUM(si.quantity * si.unit_price) AS total_revenue
    FROM sale_items si
    JOIN products p
        ON si.product_id = p.product_id
    JOIN sales s
        ON si.sale_id = s.sale_id
    WHERE s.sale_status = 'Completed'
    GROUP BY
        p.product_id,
        p.product_name
    ORDER BY total_revenue DESC;
END //

DELIMITER ;

CALL GetProductSalesSummary();

DELIMITER //

CREATE PROCEDURE GetPurchaseSummaryBySupplier()
BEGIN
    SELECT
        s.supplier_id,
        s.supplier_name,
        COUNT(DISTINCT pu.purchase_id) AS total_purchases,
        SUM(pi.quantity) AS total_quantity,
        SUM(pi.quantity * pi.unit_cost) AS total_purchase_cost
    FROM suppliers s
    JOIN purchases pu
        ON s.supplier_id = pu.supplier_id
    JOIN purchase_items pi
        ON pu.purchase_id = pi.purchase_id
    WHERE pu.purchase_status = 'Received'
    GROUP BY
        s.supplier_id,
        s.supplier_name
    ORDER BY total_purchase_cost DESC;
END //

DELIMITER ;

CALL GetPurchaseSummaryBySupplier();

DELIMITER //

CREATE PROCEDURE GetWarehouseStockSummary()
BEGIN
    SELECT
        w.warehouse_id,
        w.warehouse_name,
        COUNT(i.product_id) AS total_products,
        SUM(i.quantity) AS total_stock
    FROM warehouses w
    LEFT JOIN inventory i
        ON w.warehouse_id = i.warehouse_id
    GROUP BY
        w.warehouse_id,
        w.warehouse_name
    ORDER BY total_stock DESC;
END //

DELIMITER ;

CALL GetWarehouseStockSummary();

DELIMITER //

CREATE PROCEDURE GetDailySalesReport()
BEGIN
    SELECT
        s.sale_date,
        COUNT(DISTINCT s.sale_id) AS total_sales,
        SUM(si.quantity) AS total_quantity_sold,
        SUM(si.quantity * si.unit_price) AS total_revenue
    FROM sales s
    JOIN sale_items si
        ON s.sale_id = si.sale_id
    WHERE s.sale_status = 'Completed'
    GROUP BY s.sale_date
    ORDER BY s.sale_date;
END //

DELIMITER ;

CALL GetDailySalesReport();