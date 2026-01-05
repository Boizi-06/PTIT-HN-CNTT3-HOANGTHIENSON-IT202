create database ss06;
use ss06;
-- drop database ss06;
-- bai1
create table customers (
	customer_id int primary key auto_increment,
    full_name varchar(255) not null,
    city varchar(255) not null
);

create table orders (
	order_id int primary key auto_increment,
    order_date date not null,
    status enum ('pending','completd','cancelled') not null,
    customer_id int not null,
    foreign key (customer_id) references customers (customer_id)
);


INSERT INTO customers (full_name, city) VALUES
('Nguyễn Văn An', 'Hà Nội'),
('Trần Thị Bình', 'Hải Phòng'),
('Lê Văn Cường', 'Đà Nẵng'),
('Phạm Thị Dung', 'TP.HCM'),
('Hoàng Văn Em', 'Cần Thơ'),
('Trinh Khac Hung','Thanh Hoa'),
('Nguyen Minh Duy','Thanh Hoa');

INSERT INTO orders (order_date, status, customer_id) VALUES
('2025-01-11', 'pending', 1),
('2025-01-01', 'pending', 1),
('2025-01-02', 'completd', 2),
('2025-01-03', 'cancelled', 3),
('2025-01-14', 'pending', 3),
('2025-01-04', 'pending', 4),
('2025-01-05', 'completd', 5),
('2025-01-06', 'completd', 6);




select * from customers;


select * from orders;

SELECT 
    orders.order_id as ma_hoa_don,
    orders.order_date as ngay_thanh_toan,
    orders.status as trang_thai ,
    customers.full_name as ten_khach_hang
FROM orders
JOIN customers 
ON orders.customer_id = customers.customer_id;


SELECT 
    customers.customer_id,
    customers.full_name,
    COUNT(orders.order_id) AS total_orders
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name;



SELECT 
    customers.customer_id,
    customers.full_name,
    COUNT(orders.order_id) AS total_orders
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name
HAVING COUNT(orders.order_id) = 1;



-- bai 2

ALTER TABLE orders
ADD total_amount DECIMAL(10,2);

UPDATE orders SET total_amount = 1500000 WHERE order_id = 1;
UPDATE orders SET total_amount = 2000000 WHERE order_id = 2;
UPDATE orders SET total_amount = 1800000 WHERE order_id = 3;
UPDATE orders SET total_amount = 900000  WHERE order_id = 4;
UPDATE orders SET total_amount = 1200000 WHERE order_id = 5;
UPDATE orders SET total_amount = 2500000 WHERE order_id = 6;
UPDATE orders SET total_amount = 3000000 WHERE order_id = 7;
UPDATE orders SET total_amount = 1700000 WHERE order_id = 8;



SELECT
    customers.customer_id,
    customers.full_name,
    SUM(orders.total_amount) AS tong_tien_da_chi
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name;



SELECT
    customers.customer_id,
    customers.full_name,
    MAX(orders.total_amount) AS don_hang_cao_nhat
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name;



SELECT
    customers.customer_id,
    customers.full_name,
    SUM(orders.total_amount) AS tong_tien_da_chi
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name
ORDER BY tong_tien_da_chi DESC;





-- bai 3

INSERT INTO orders (order_date, status, customer_id, total_amount) VALUES
('2025-01-11', 'completd', 2, 4500000),
('2025-01-11', 'completd', 3, 3800000),
('2025-01-11', 'completd', 4, 2900000);

SELECT
    order_date,
    SUM(total_amount) AS tong_doanh_thu
FROM orders
GROUP BY order_date;



SELECT
    order_date,
    COUNT(order_id) AS so_luong_don
FROM orders
GROUP BY order_date;


SELECT
    order_date,
    SUM(total_amount) AS tong_doanh_thu
FROM orders
GROUP BY order_date
HAVING SUM(total_amount) > 10000000;







-- bai 4 
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);



CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


INSERT INTO products (product_name, price) VALUES
('Laptop Dell', 15000000),
('Chuột Logitech', 500000),
('Bàn phím cơ', 1200000),
('Tai nghe Sony', 2500000),
('Màn hình LG', 7000000);




INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 1, 1),
(3, 3, 3),
(4, 4, 2),
(5, 5, 1),
(6, 1, 1),
(6, 5, 1);



SELECT
    products.product_id,
    products.product_name,
    SUM(order_items.quantity) AS tong_so_luong_ban
FROM products
JOIN order_items
ON products.product_id = order_items.product_id
GROUP BY products.product_id, products.product_name;


SELECT
    products.product_id,
    products.product_name,
    SUM(order_items.quantity * products.price) AS doanh_thu
FROM products
JOIN order_items
ON products.product_id = order_items.product_id
GROUP BY products.product_id, products.product_name;


SELECT
    products.product_id,
    products.product_name,
    SUM(order_items.quantity * products.price) AS doanh_thu
FROM products
JOIN order_items
ON products.product_id = order_items.product_id
GROUP BY products.product_id, products.product_name
HAVING SUM(order_items.quantity * products.price) > 5000000;


-- bai 5

INSERT INTO orders (order_date, status, customer_id, total_amount) VALUES
('2025-02-01', 'completd', 1, 3200000),
('2025-02-05', 'completd', 1, 2800000),
('2025-02-10', 'completd', 1, 4100000),
('2025-02-15', 'completd', 1, 1500000),
('2025-02-02', 'completd', 2, 2200000),
('2025-02-08', 'completd', 2, 3500000),
('2025-02-18', 'completd', 2, 3000000),
('2025-02-03', 'completd', 3, 800000),
('2025-02-07', 'completd', 3, 900000),
('2025-02-20', 'completd', 3, 1000000),
('2025-02-04', 'completd', 4, 2500000),
('2025-02-06', 'completd', 5, 4200000),
('2025-02-12', 'completd', 5, 3900000),
('2025-02-22', 'completd', 5, 2100000),
('2025-02-09', 'completd', 6, 6000000),
('2025-02-11', 'completd', 7, 1800000),
('2025-02-17', 'completd', 7, 2200000);





SELECT
    customers.customer_id,
    customers.full_name,
    COUNT(orders.order_id) AS tong_so_don,
    SUM(orders.total_amount) AS tong_tien_da_chi,
    AVG(orders.total_amount) AS gia_tri_don_trung_binh
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name
HAVING 
    COUNT(orders.order_id) >= 3
    AND SUM(orders.total_amount) > 10000000
ORDER BY tong_tien_da_chi DESC;

-- bai 6

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(9, 1, 2),
(10, 1, 3),
(11, 1, 2),
(12, 1, 1),
(13, 1, 2),
(14, 1, 3),
(9, 2, 5),
(10, 2, 4),
(11, 2, 3),
(12, 3, 4),
(13, 3, 5),
(14, 3, 3),
(15, 4, 2),
(16, 4, 3),
(17, 4, 2),
(15, 5, 1),
(16, 5, 2),
(17, 5, 2),
(18, 5, 3);


SELECT
    p.product_name AS ten_san_pham,
    SUM(oi.quantity) AS tong_so_luong_ban,
    SUM(oi.quantity * p.price) AS tong_doanh_thu,
    AVG(p.price) AS gia_ban_trung_binh
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) >= 10
ORDER BY tong_doanh_thu DESC
LIMIT 5;


