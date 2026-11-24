CREATE DATABASE smart_inventory;
USE smart_inventory;
SELECT DATABASE();

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    category_id INT,
    unit_price DECIMAL(10,2) NOT NULL,
    reorder_level INT DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (category_id)
    REFERENCES categories(category_id)
);

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(150),
    city VARCHAR(100)
);

CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id),

    UNIQUE (product_id, warehouse_id)
);

CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    purchase_date DATE NOT NULL,
    purchase_status VARCHAR(30) DEFAULT 'Pending',

    FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id),

    FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id)
);

CREATE TABLE purchase_items (
    purchase_item_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (purchase_id)
        REFERENCES purchases(purchase_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    UNIQUE (purchase_id, product_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_id INT NOT NULL,
    sale_date DATE NOT NULL,
    sale_status VARCHAR(30) DEFAULT 'Completed',

    FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id)
);

CREATE TABLE sale_items (
    sale_item_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (sale_id)
        REFERENCES sales(sale_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    UNIQUE (sale_id, product_id)
);

CREATE TABLE stock_movements (
    movement_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    movement_type VARCHAR(20) NOT NULL,
    quantity INT NOT NULL,
    movement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_type VARCHAR(20),
    reference_id INT,

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id)
);


