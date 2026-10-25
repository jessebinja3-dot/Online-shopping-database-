-- 1. TABLE CREATION AND CONSTRAINTS
CREATE TABLE customers (
    customer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    phone       VARCHAR(20),
    city        VARCHAR(50),
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name   VARCHAR(100) NOT NULL,
    category       VARCHAR(50),
    price          DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL
);

CREATE TABLE orders (
    order_id     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id  INT NOT NULL,
    order_date   DATE NOT NULL,
    status       VARCHAR(20) NOT NULL,
    total_amount DECIMAL(12,2),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

CREATE TABLE order_items (
    order_item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id) REFERENCES orders (order_id),
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id) REFERENCES products (product_id)
);


-- 2. INITIAL DATA INSERTION
INSERT INTO customers (full_name, email, phone, city) VALUES
('Alice Uwase',       'alice.uwase@example.com',      '+250788100001', 'Kigali'),
('Eric Mugabo',       'eric.mugabo@example.com',      '+250788100002', 'Musanze'),
('Grace Ingabire',    'grace.ingabire@example.com',   '+250788100003', 'Huye'),
('David Nkurunziza',  'david.nkurunziza@example.com', '+250788100004', 'Kigali'),
('Sandrine Mukamana', 'sandrine.mukamana@example.com','+250788100005', 'Rubavu'),
('Patrick Habimana',  'patrick.habimana@example.com', '+250788100006', 'Kigali');

INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('Laptop 15 inch',      'Electronics', 650000.00, 12),
('Smartphone',          'Electronics', 280000.00, 25),
('Wireless Headphones', 'Electronics',  45000.00, 40),
('Running Shoes',       'Fashion',      35000.00, 30),
('Backpack',            'Fashion',      18000.00, 50),
('Desk Lamp',           'Home',         12000.00, 20);

INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
(1, '2026-10-01', 'Delivered', 695000.00),
(2, '2026-10-03', 'Delivered', 280000.00),
(3, '2026-10-10', 'Shipped',    88000.00),
(1, '2026-10-15', 'Pending',    24000.00),
(4, '2026-10-18', 'Pending',    63000.00),
(5, '2026-10-20', 'Cancelled', 280000.00);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 650000.00),
(1, 3, 1,  45000.00),
(2, 2, 1, 280000.00),
(3, 4, 2,  35000.00),
(3, 5, 1,  18000.00),
(4, 6, 2,  12000.00),
    
-- 3b. VERIFICATION OF INITIAL DATA
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL SELECT 'products',    COUNT(*) FROM products
UNION ALL SELECT 'orders',      COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

SELECT o.order_id, c.full_name, o.status
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id;


-- 4. SELECT TASKS
-- Q1.1 Basic retrieval: product catalogue
SELECT product_name, category, price
FROM products;

-- Q1.2 Conditional retrieval: customers living in Kigali
SELECT full_name, email, city
FROM customers
WHERE city = 'Kigali';

-- Q1.3 Sorted retrieval: products from most to least expensive
SELECT product_name, price
FROM products
ORDER BY price DESC;


-- 5. JOIN TASKS
-- Q2.1 INNER JOIN: orders with the customer who placed them
SELECT o.order_id, c.full_name, o.order_date, o.status, o.total_amount
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_id;

-- Q2.2 LEFT JOIN: all customers, with their orders where they exist
SELECT c.customer_id, c.full_name, o.order_id, o.status
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_id;

-- Q2.3 Multi-table JOIN: full order report
SELECT c.full_name, o.order_id, p.product_name,
       oi.quantity, oi.unit_price, oi.quantity * oi.unit_price AS line_total
FROM customers c
JOIN orders o       ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id   = o.order_id
JOIN products p     ON p.product_id  = oi.product_id
ORDER BY o.order_id, p.product_name;
(5, 3, 1,  45000.00),
(5, 5, 1,  18000.00),
(6, 2, 1, 280000.00);

