CREATE OR REPLACE VIEW vw_daily_sales_report AS
SELECT
    s.sale_date,
    COUNT(DISTINCT s.sale_id) AS total_sales,
    SUM(si.quantity * si.unit_price) AS total_revenue
FROM sales s
JOIN sale_items si
    ON s.sale_id = si.sale_id
WHERE s.sale_status = 'Completed'
GROUP BY s.sale_date;

SELECT *
FROM vw_daily_sales_report;

SELECT
    COUNT(*) AS total_inventory_records,
    SUM(quantity < 0) AS negative_stock_records,
    COUNT(*) - COUNT(DISTINCT product_id, warehouse_id)
        AS duplicate_records
FROM inventory;