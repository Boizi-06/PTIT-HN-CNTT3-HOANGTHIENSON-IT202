drop database if exists Session07_01;
create database Session07_01;
use Session07_01;

create table customers (
	id int primary key,
    name varchar(255),
    email varchar(255)
);

create table orders (
	id int primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2),
    constraint fk_customer foreign key (customer_id) references customers(id)
);
insert into customers values
(1, 'Nguyen Van A', 'nguyenvana@example.com'),
(2, 'Tran Thi B', 'tranthib@example.com'),
(3, 'Le Van C', 'levanc@example.com'),
(4, 'Pham Thi D', 'phamthid@example.com'),
(5, 'Hoang Van E', 'hoangvane@example.com'),
(6, 'Doan Manh Duy', 'duymanh@example.com'),
(7, 'Vu Thi F', 'vuthif@example.com'),
(8, 'Dang Van G', 'dangvang@example.com'),
(9, 'Bui Thi H', 'buithih@example.com'),
(10, 'Ngo Van I', 'ngovani@example.com');

insert into orders values
(101, 1, '2024-01-01', 500000),  
(102, 2, '2024-01-02', 1200000), 
(103, 1, '2024-01-03', 250000),   
(104, 3, '2024-01-05', 3000000),
(105, 4, '2024-01-07', 150000),   
(106, 5, '2024-01-10', 5000000),  
(107, 6, '2024-01-12', 450000),  
(108, 2, '2024-01-15', 800000), 
(109, 8, '2024-01-20', 2000000),  
(110, 10, '2024-01-25', 100000);

-- Lấy danh sách khách hàng đã từng đặt đơn hàng
select c.*, (select count(*) from orders o where o) as "Số đơn đặt" from customers c where id in (select c.customer_id from orders o);


drop database if exists Session07_02;
create database Session07_02;
use Session07_02;

create table products (
	id int primary key,
    name varchar(255),
    price decimal(10,2)
);

create table order_items (
	order_id int primary key,
    product_id int,
    quantity int,
    constraint fk_product foreign key (product_id) references products(id)
);

insert into products values
(1, 'Laptop Gaming Asus', 25000000),
(2, 'Chuot Logitech G102', 450000),
(3, 'Ban phim Keychron', 1800000),
(4, 'Man hinh Dell Ultrasharp', 9500000),
(5, 'Tai nghe Sony WH-1000XM5', 6500000),
(6, 'Ghe Cong Thai Hoc', 3500000),
(7, 'Lot Chuot Size XXL', 150000);

insert into order_items values
(101, 1, 1),  
(102, 2, 2), 
(103, 1, 1), 
(104, 5, 1),  
(105, 3, 5),  
(106, 7, 10), 
(107, 4, 2); 
-- Viết 1 câu SQL để:
-- Lấy danh sách sản phẩm đã từng được bán
-- Subquery lấy product_id từ bảng order_items
-- Sử dụng IN
-- KHÔNG dùng JOIN



drop database if exists Session07_03;
create database Session07_03;
use Session07_03;

create table products (
	id int primary key,
    name varchar(255),
    price decimal(10,2)
);

create table order_items (
	order_id int primary key,
    product_id int,
    quantity int,
    constraint fk_product foreign key (product_id) references products(id)
);

insert into products values
(1, 'Laptop Gaming Asus', 25000000),
(2, 'Chuot Logitech G102', 450000),
(3, 'Ban phim Keychron', 1800000),
(4, 'Man hinh Dell Ultrasharp', 9500000),
(5, 'Tai nghe Sony WH-1000XM5', 6500000),
(6, 'Ghe Cong Thai Hoc', 3500000),
(7, 'Lot Chuot Size XXL', 150000);

insert into order_items values
(101, 1, 1),  
(102, 2, 2), 
(103, 1, 1), 
(104, 5, 1),  
(105, 3, 5),  
(106, 7, 10), 
(107, 4, 2);

-- Lấy danh sách đơn hàng có giá trị lớn hơn giá trị trung bình của tất cả đơn hàng
select 
    o.order_id, 
    o.product_id, 
    o.quantity,
    (o.quantity * (select price from products where id = o.product_id)) as total_value
from order_items o
where 
    (o.quantity * (select price from products where id = o.product_id)) 
    > 
    (select avg(price) from products);



drop database if exists Session07_04;
create database Session07_04;
use Session07_04;
create table customers (
	id int primary key,
    name varchar(255),
    email varchar(255)
);

create table orders (
	id int primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2),
    
    constraint fk_customers foreign key (customer_id) references customers(id)
);

 insert into customers values
(1, 'Nguyen Van A', 'ana@test.com'),
(2, 'Tran Thi B', 'btran@test.com'),
(3, 'Le Van C', 'cle@test.com'),
(4, 'Pham Thi D', 'dpham@test.com'),
(5, 'Hoang Van E', 'ehoang@test.com'),
(6, 'Doan Manh Duy', 'duy@test.com'),
(7, 'Vu Thi F', 'fvu@test.com');

insert into orders values
(101, 1, '2024-01-01', 500000), 
(102, 2, '2024-01-02', 1200000),  
(103, 1, '2024-01-05', 250000),  
(104, 6, '2024-01-10', 5000000),  
(105, 3, '2024-01-12', 150000),   
(106, 7, '2024-01-15', 3000000),
(107, 2, '2024-01-20', 800000);

-- Hiển thị tên khách hàng
select c.id, c.name
from customers c;
-- Hiển thị số lượng đơn hàng của từng khách
select c.id, c.name, (select count(*) from orders o where o.customer_id = c.id) as "so_luong_don"
from customers c;





drop database if exists Session07_05;
create database Session07_05;
use Session07_05;
create table customers (
	id int primary key,
    name varchar(255),
    email varchar(255)
);

create table orders (
	id int primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2),
    
    constraint fk_customers foreign key (customer_id) references customers(id)
);
 insert into customers values
(1, 'Nguyen Van A', 'ana@test.com'),
(2, 'Tran Thi B', 'btran@test.com'),
(3, 'Le Van C', 'cle@test.com'),
(4, 'Pham Thi D', 'dpham@test.com'),
(5, 'Hoang Van E', 'ehoang@test.com'),
(6, 'Doan Manh Duy', 'duy@test.com'),
(7, 'Vu Thi F', 'fvu@test.com');

insert into orders values
(101, 1, '2024-01-01', 500000), 
(102, 2, '2024-01-02', 1200000),  
(103, 1, '2024-01-05', 250000),  
(104, 6, '2024-01-10', 5000000),  
(105, 3, '2024-01-12', 150000),   
(106, 7, '2024-01-15', 3000000),
(107, 2, '2024-01-20', 800000);

-- Tìm khách hàng có tổng số tiền mua hàng lớn nhất
select c.id, c.name, (select sum(total_amount) from orders o where o.customer_id = c.id) as "Tong tien"
from customers c
where (select sum(total_amount) from orders o where o.customer_id = c.id) 
= (select max(tong_tien_tung_nguoi)from (select sum(total_amount) as tong_tien_tung_nguoi from orders group by customer_id) as bang_tam);


drop database if exists Session07_06;
create database Session07_06;
use Session07_06;

create table customers (
    id int primary key,
    name varchar(255),
    email varchar(255)
);

create table orders (
    id int primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2),
    constraint fk_customer foreign key (customer_id) references customers(id)
);

insert into customers values
(1, 'Nguyen Van A', 'a@test.com'),
(2, 'Tran Thi B', 'b@test.com'),
(3, 'Le Van C', 'c@test.com'),
(4, 'Pham Thi D', 'd@test.com'),
(5, 'Hoang Van E', 'e@test.com');

insert into orders values
(101, 1, '2024-01-01', 1000000), 
(102, 1, '2024-01-02', 2000000), 
(103, 2, '2024-01-03', 150000),  
(104, 3, '2024-01-04', 5000000), 
(105, 4, '2024-01-05', 500000),  
(106, 5, '2024-01-06', 1200000), 
(107, 2, '2024-01-07', 50000);   

-- Lấy danh sách khách hàng (id) có tổng tiền mua > trung bình cộng đơn hàng
select customer_id, sum(total_amount) as "Tong tien mua"
from orders
group by customer_id
having sum(total_amount) > (select avg(total_amount) from orders);
