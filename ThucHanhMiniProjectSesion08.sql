CREATE DATABASE mini_project_ss08;
USE mini_project_ss08;

-- Xóa bảng nếu đã tồn tại (để chạy lại nhiều lần)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS guests;

-- Bảng khách hàng
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone VARCHAR(20)
);

-- Bảng phòng
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50),
    price_per_day DECIMAL(10,0)
);

-- Bảng đặt phòng
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

INSERT INTO guests (guest_name, phone) VALUES
('Nguyễn Văn An', '0901111111'),
('Trần Thị Bình', '0902222222'),
('Lê Văn Cường', '0903333333'),
('Phạm Thị Dung', '0904444444'),
('Hoàng Văn Em', '0905555555');

INSERT INTO rooms (room_type, price_per_day) VALUES
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000);

INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(1, 1, '2024-01-10', '2024-01-12'), -- 2 ngày
(1, 3, '2024-03-05', '2024-03-10'), -- 5 ngày
(2, 2, '2024-02-01', '2024-02-03'), -- 2 ngày
(2, 5, '2024-04-15', '2024-04-18'), -- 3 ngày
(3, 4, '2023-12-20', '2023-12-25'), -- 5 ngày
(3, 6, '2024-05-01', '2024-05-06'), -- 5 ngày
(4, 1, '2024-06-10', '2024-06-11'); -- 1 ngày


INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(4, 2, '2025-06-10', '2025-06-11'); -- 1 ngày
INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(1, 2, '2025-07-10', '2025-07-11'); -- 1 ngày


INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(2, 3, '2025-11-10', '2025-11-11'); -- 1 ngày

select guest_name as TenKhachHang , phone as SoDienThoai from guests;


select room_type as LoaiPhong from rooms;


select  room_type as LoaiPhong ,price_per_day as GiaThueTheoNgay from rooms order by price_per_day ;


select room_type as LoaiPhong, price_per_day as GiaThueTheoNgay from rooms where price_per_day > 1000000;


SELECT *
FROM bookings
WHERE YEAR(check_in) = 2024;

SELECT room_type as kieuPhong, COUNT(room_id) AS so_luong_phong
FROM rooms
GROUP BY room_type;


SELECT g.guest_name as TenkhachHang, r.room_type as KieuPhong, b.check_in as NgayCheckin 
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
JOIN rooms r ON b.room_id = r.room_id;


SELECT g.guest_name as TenKhachHang , COUNT(b.booking_id) AS so_lan_dat
FROM guests g
LEFT JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_id, g.guest_name;


SELECT r.room_id,
       SUM((b.check_out - b.check_in) * r.price_per_day) AS doanhThu
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
GROUP BY r.room_id;



SELECTSELECT r.room_type,
       SUM((b.check_out - b.check_in) * r.price_per_day) AS tong_DoanhThu
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
GROUP BY r.room_type;





SELECT g.guest_name as tenKhachHang, COUNT(b.booking_id) AS so_lan_dat
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_id, g.guest_name
HAVING COUNT(b.booking_id) >= 2;



SELECT r.room_type, COUNT(b.booking_id) AS so_luot_dat
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
GROUP BY r.room_type
ORDER BY so_luot_dat DESC
LIMIT 1;



SELECT room_id , room_type as KieuPhong, price_per_day as GiaTien
FROM rooms
WHERE price_per_day > (
    SELECT AVG(price_per_day)
    FROM rooms
);


SELECT *
FROM guests
WHERE guest_id NOT IN (
    SELECT DISTINCT guest_id
    FROM bookings
);


SELECT r.room_id, r.room_type, COUNT(b.booking_id) AS so_luot_dat
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
GROUP BY r.room_type, r.room_id
ORDER BY so_luot_dat DESC;

