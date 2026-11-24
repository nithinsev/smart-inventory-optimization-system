USE smart_inventory;

SELECT
    product_id,
    product_name,
    unit_price,
    RANK() OVER (
        ORDER BY unit_price DESC
    ) AS price_rank
FROM products;

SELECT
    product_id,
    product_name,
    unit_price,
    DENSE_RANK() OVER (
        ORDER BY unit_price DESC
    ) AS price_rank
FROM products;

SELECT
    product_id,
    product_name,
    unit_price,
    ROW_NUMBER() OVER (
        ORDER BY unit_price DESC
    ) AS row_num
FROM products;

SELECT
    product_id,
    product_name,
    unit_price,
    ROW_NUMBER() OVER (
        ORDER BY unit_price DESC, product_id ASC
    ) AS row_num
FROM products;

SELECT *
FROM
(
    SELECT
        product_id,
        product_name,
        unit_price,
        ROW_NUMBER() OVER (
            ORDER BY unit_price DESC, product_id ASC
        ) AS product_rank
    FROM products
) AS ranked_products
WHERE product_rank <= 3;

SELECT
    product_id,
    product_name,
    category_id,
    unit_price,
    RANK() OVER (
        PARTITION BY category_id
        ORDER BY unit_price DESC
    ) AS category_rank
FROM products;

SELECT
    product_id,
    product_name,
    category_id,
    unit_price,
    category_rank
FROM
(
    SELECT
        product_id,
        product_name,
        category_id,
        unit_price,
        RANK() OVER (
            PARTITION BY category_id
            ORDER BY unit_price DESC
        ) AS category_rank
    FROM products
) AS ranked_products
WHERE category_rank <= 2
ORDER BY category_id, category_rank;

SELECT
    product_id,
    product_name,
    unit_price,

    RANK() OVER (
        ORDER BY unit_price DESC
    ) AS price_rank,

    DENSE_RANK() OVER (
        ORDER BY unit_price DESC
    ) AS dense_position,

    ROW_NUMBER() OVER (
        ORDER BY unit_price DESC, product_id ASC
    ) AS row_num

FROM products
ORDER BY unit_price DESC, product_id ASC;

EXPLAIN
SELECT *
FROM products
WHERE category_id = 2;

EXPLAIN
SELECT *
FROM products
WHERE product_name = 'Laptop';

CREATE INDEX idx_product_name
ON products(product_name);

EXPLAIN
SELECT *
FROM products
WHERE product_name = 'Laptop';

EXPLAIN
SELECT *
FROM inventory
WHERE product_id = 1
AND warehouse_id = 1;

SHOW INDEX FROM inventory;

EXPLAIN
SELECT *
FROM inventory
WHERE warehouse_id = 1;

EXPLAIN ANALYZE
SELECT *
FROM products
WHERE product_name = 'Laptop';