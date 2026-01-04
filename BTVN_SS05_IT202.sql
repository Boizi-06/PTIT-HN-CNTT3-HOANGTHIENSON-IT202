-- create database ss05;
-- use ss05;

create database BTVN_SS05_it202;
use BTVN_SS05_it202;
-- Bai1

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255),
    price DECIMAL(10,2),
    stock INT,
    status ENUM('active', 'inactive')
);
INSERT INTO products (product_name, price, stock, status) VALUES
('Laptop Dell', 15000000, 10, 'active'),
('Chuột Logitech', 500000, 50, 'active'),
('Bàn phím cơ', 1200000, 20, 'active'),
('Tai nghe Bluetooth', 900000, 15, 'inactive');



SELECT * FROM products;

SELECT * FROM products
WHERE status = 'active';

SELECT * FROM products
WHERE price > 1000000;

SELECT * FROM products
WHERE status = 'active'
ORDER BY price ASC;

-- bai2


CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255),
    email VARCHAR(255),
    city VARCHAR(255),
    status ENUM('active', 'inactive')
);


INSERT INTO customers (full_name, email, city, status) VALUES
('Nguyễn Văn An', 'an@gmail.com', 'TP.HCM', 'active'),
('Trần Thị Bình', 'binh@gmail.com', 'Hà Nội', 'active'),
('Lê Văn Cường', 'cuong@gmail.com', 'Đà Nẵng', 'inactive'),
('Phạm Thị Hoa', 'hoa@gmail.com', 'Hà Nội', 'active'),
('Hoàng Văn Minh', 'minh@gmail.com', 'TP.HCM', 'inactive');



SELECT * FROM customers;


SELECT * 
FROM customers
WHERE city = 'TP.HCM';


SELECT * 
FROM customers
WHERE status = 'active'
AND city = 'Hà Nội';


SELECT * 
FROM customers
ORDER BY full_name ASC;


-- bai3


CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    total_amount DECIMAL(10,2),
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled')
);

INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES
(1, 3000000, '2024-10-01', 'pending'),
(2, 7500000, '2024-10-05', 'completed'),
(3, 12000000, '2024-10-10', 'completed'),
(1, 4500000, '2024-10-12', 'cancelled'),
(4, 9000000, '2024-10-15', 'completed'),
(2, 2000000, '2024-10-18', 'pending'),
(5, 15000000, '2024-10-20', 'completed');


INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES
(1, 6000000, '2024-10-22', 'completed'),
(2, 3500000, '2024-10-23', 'pending'),
(3, 8000000, '2024-10-24', 'completed'),
(4, 2500000, '2024-10-25', 'pending'),
(5, 11000000, '2024-10-26', 'completed'),
(1, 4000000, '2024-10-27', 'pending'),
(2, 9500000, '2024-10-28', 'completed'),
(3, 5000000, '2024-10-29', 'cancelled'),
(4, 7000000, '2024-10-30', 'completed'),
(5, 3000000, '2024-10-31', 'pending');


SELECT *
FROM orders
WHERE status = 'completed';


SELECT *
FROM orders
WHERE total_amount > 5000000;


SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 5;


SELECT *
FROM orders
WHERE status = 'completed'
ORDER BY total_amount DESC;

-- bai4
ALTER TABLE products
ADD sold_quantity INT;


UPDATE products SET sold_quantity = 120 WHERE product_id = 1;
UPDATE products SET sold_quantity = 300 WHERE product_id = 2;
UPDATE products SET sold_quantity = 180 WHERE product_id = 3;
UPDATE products SET sold_quantity = 90  WHERE product_id = 4;

select * from products;

SELECT *
FROM products
ORDER BY sold_quantity DESC
LIMIT 10;



SELECT *
FROM products
ORDER BY sold_quantity DESC
LIMIT 5 OFFSET 10;


SELECT *
FROM products
WHERE price < 2000000
ORDER BY sold_quantity DESC;


SELECT *
FROM products
WHERE price < 2000000
ORDER BY sold_quantity DESC;


-- bai5
SELECT *
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 0;



SELECT *
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;


SELECT *
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;

-- bai6

SELECT *
FROM products
WHERE status = 'active'
  AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 0;

SELECT *
FROM products
WHERE status = 'active'
  AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 10;














