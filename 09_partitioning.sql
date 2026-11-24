USE smart_inventory;

CREATE TABLE sales_archive (
    sale_id INT NOT NULL,
    sale_date DATE NOT NULL,
    total_amount DECIMAL(10,2),
    PRIMARY KEY (sale_id, sale_date)
)
PARTITION BY RANGE (YEAR(sale_date)) (
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p2026 VALUES LESS THAN (2027),
    PARTITION p2027 VALUES LESS THAN (2028),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

INSERT INTO sales_archive
    (sale_id, sale_date, total_amount)
VALUES
    (1, '2025-03-15', 45000.00),
    (2, '2025-08-20', 32000.00),
    (3, '2026-01-10', 55000.00),
    (4, '2026-06-25', 28000.00),
    (5, '2027-02-14', 75000.00),
    (6, '2028-04-05', 18000.00);
    
SELECT * FROM sales_archive PARTITION (p2025);

SELECT *
FROM sales_archive PARTITION (p2026);

SELECT *
FROM sales_archive PARTITION (p2027);

SELECT *
FROM sales_archive PARTITION (p_future);

EXPLAIN
SELECT *
FROM sales_archive
WHERE sale_date >= '2026-01-01'
  AND sale_date < '2027-01-01';