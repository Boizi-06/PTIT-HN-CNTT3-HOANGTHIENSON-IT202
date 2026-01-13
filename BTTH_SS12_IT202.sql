/* =========================================================
   MINI PROJECT: SOCIAL NETWORK SYSTEM - FULL VERSION
   Bao gồm:
   - Schema
   - View, Index
   - Stored Procedures (14 bài)
   - Data mẫu
   - Test

   Tác giả: Sơn
========================================================= */

DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;

/* =======================
   BẢNG USERS
======================= */
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active'
);

/* =======================
   BẢNG POSTS
======================= */
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

/* =======================
   BẢNG COMMENTS
======================= */
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

/* =======================
   BẢNG FRIENDS
======================= */
CREATE TABLE Friends (
    user_id INT,
    friend_id INT,
    status VARCHAR(20),
    CHECK (status IN ('pending','accepted'))
);

/* =======================
   BẢNG LIKES
======================= */
CREATE TABLE Likes (
    user_id INT,
    post_id INT
);

/* =========================================================
   BÀI 2 – VIEW PUBLIC USERS
========================================================= */
CREATE VIEW vw_public_users AS
SELECT user_id, username, created_at
FROM Users;

/* =========================================================
   BÀI 3 – INDEX USERNAME
========================================================= */
CREATE INDEX idx_username ON Users(username);

/* =========================================================
   BÀI 4 – PROCEDURE ĐĂNG BÀI
========================================================= */
DELIMITER $$

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE cnt INT;

    SELECT COUNT(*) INTO cnt FROM Users WHERE user_id = p_user_id;

    IF cnt = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User khong ton tai';
    ELSE
        INSERT INTO Posts(user_id, content)
        VALUES (p_user_id, p_content);
    END IF;
END$$

DELIMITER ;

/* =========================================================
   BÀI 5 – VIEW NEWS FEED 7 NGÀY
========================================================= */
CREATE VIEW vw_recent_posts AS
SELECT *
FROM Posts
WHERE created_at >= NOW() - INTERVAL 7 DAY;

/* =========================================================
   BÀI 6 – INDEX POSTS
========================================================= */
CREATE INDEX idx_posts_user ON Posts(user_id);
CREATE INDEX idx_posts_user_time ON Posts(user_id, created_at);

/* =========================================================
   BÀI 7 – COUNT POSTS
========================================================= */
DELIMITER $$

CREATE PROCEDURE sp_count_posts(
    IN p_user_id INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM Posts
    WHERE user_id = p_user_id;
END$$

DELIMITER ;

/* =========================================================
   BÀI 8 – VIEW COMMENTS
========================================================= */
CREATE VIEW vw_post_comments AS
SELECT c.content, u.username, c.created_at
FROM Comments c
JOIN Users u ON c.user_id = u.user_id;

/* =========================================================
   BÀI 9 – KẾT BẠN
========================================================= */
DELIMITER $$

CREATE PROCEDURE sp_add_friend(
    IN p_user_id INT,
    IN p_friend_id INT
)
BEGIN
    DECLARE cnt INT;

    IF p_user_id = p_friend_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Khong the ket ban voi chinh minh';
    ELSE
        SELECT COUNT(*) INTO cnt
        FROM Friends
        WHERE (user_id=p_user_id AND friend_id=p_friend_id)
           OR (user_id=p_friend_id AND friend_id=p_user_id);

        IF cnt > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='Da ton tai';
        ELSE
            INSERT INTO Friends VALUES(p_user_id,p_friend_id,'pending');
        END IF;
    END IF;
END$$

DELIMITER ;

/* =========================================================
   BÀI 10 – GỢI Ý BẠN BÈ
========================================================= */
DELIMITER $$

CREATE PROCEDURE sp_suggest_friends(
    IN p_user_id INT,
    INOUT p_limit INT
)
BEGIN
    SELECT user_id, username
    FROM Users
    WHERE user_id <> p_user_id
    LIMIT p_limit;
END$$

DELIMITER ;

/* =========================================================
   BÀI 12 – THÊM COMMENT
========================================================= */
DELIMITER $$

CREATE PROCEDURE sp_add_comment(
    IN p_user_id INT,
    IN p_post_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE u_cnt INT;
    DECLARE p_cnt INT;

    SELECT COUNT(*) INTO u_cnt FROM Users WHERE user_id=p_user_id;
    SELECT COUNT(*) INTO p_cnt FROM Posts WHERE post_id=p_post_id;

    IF u_cnt = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='User khong ton tai';
    ELSEIF p_cnt = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Post khong ton tai';
    ELSE
        INSERT INTO Comments(user_id,post_id,content)
        VALUES(p_user_id,p_post_id,p_content);
    END IF;
END$$

DELIMITER ;

/* =========================================================
   BÀI 13 – LIKE POST
========================================================= */
DELIMITER $$

CREATE PROCEDURE sp_like_post(
    IN p_user_id INT,
    IN p_post_id INT
)
BEGIN
    DECLARE cnt INT;

    SELECT COUNT(*) INTO cnt
    FROM Likes
    WHERE user_id=p_user_id AND post_id=p_post_id;

    IF cnt > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Da like roi';
    ELSE
        INSERT INTO Likes VALUES(p_user_id,p_post_id);
    END IF;
END$$

DELIMITER ;

/* =========================================================
   BÀI 14 – SEARCH
========================================================= */
DELIMITER $$

CREATE PROCEDURE sp_search_social(
    IN p_option INT,
    IN p_keyword VARCHAR(100)
)
BEGIN
    IF p_option = 1 THEN
        SELECT * FROM Users
        WHERE username LIKE CONCAT('%',p_keyword,'%');

    ELSEIF p_option = 2 THEN
        SELECT * FROM Posts
        WHERE content LIKE CONCAT('%',p_keyword,'%');

    ELSE
        SELECT 'Lua chon khong hop le' AS message;
    END IF;
END$$

DELIMITER ;

/* =========================================================
   DATA MẪU
========================================================= */

INSERT INTO Users (username, password, email) VALUES
('an123','123','an@gmail.com'),
('binh456','123','binh@gmail.com'),
('chi789','123','chi@gmail.com'),
('dung001','123','dung@gmail.com'),
('emily02','123','emily@gmail.com');

INSERT INTO Posts (user_id, content) VALUES
(1,'Hom nay troi dep'),
(2,'Dang hoc SQL'),
(3,'Lap trinh rat vui'),
(1,'Database rat quan trong'),
(4,'Xin chao moi nguoi');

INSERT INTO Comments (post_id,user_id,content) VALUES
(1,2,'Dung vay'),
(1,3,'Chuan'),
(2,1,'Hoc kho'),
(3,4,'Hay'),
(4,5,'Rat dung');

INSERT INTO Friends VALUES
(1,2,'accepted'),
(1,3,'accepted'),
(2,3,'pending'),
(4,1,'pending');

INSERT INTO Likes VALUES
(1,1),(2,1),(3,1),
(1,2),(4,2),
(5,4),(2,4),(3,4);

/* =========================================================
   TEST
========================================================= */

CALL sp_create_post(1,'Post test procedure');

SET @total=0;
CALL sp_count_posts(1,@total);
SELECT @total AS tong_bai_viet_user1;

SET @limit=3;
CALL sp_suggest_friends(1,@limit);

CALL sp_add_comment(2,1,'Comment test');

CALL sp_search_social(1,'an');
CALL sp_search_social(2,'database');
