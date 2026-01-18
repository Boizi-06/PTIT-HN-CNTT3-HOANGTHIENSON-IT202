DROP DATABASE IF EXISTS mini_social_network;
CREATE DATABASE mini_social_network;
USE mini_social_network;

-- =========================
-- 1. Bảng Users
-- =========================
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- 2. Bảng Posts
-- =========================
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_posts_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- =========================
-- 3. Bảng Comments
-- =========================
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comments_post
        FOREIGN KEY (post_id)
        REFERENCES Posts(post_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_comments_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- =========================
-- 4. Bảng Likes
-- =========================
CREATE TABLE Likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    CONSTRAINT fk_likes_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_likes_post
        FOREIGN KEY (post_id)
        REFERENCES Posts(post_id)
        ON DELETE CASCADE
);

-- =========================
-- 5. Bảng Friends
-- =========================
CREATE TABLE Friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, friend_id),
    CONSTRAINT chk_status
        CHECK (status IN ('pending', 'accepted')),
    CONSTRAINT fk_friends_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_friends_friend
        FOREIGN KEY (friend_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);



INSERT INTO Users(username,password,email)
VALUES ('son','123','son@gmail.com');

INSERT INTO Posts(user_id,content)
VALUES (1,'Hello');

INSERT INTO Likes VALUES (1,1,NOW());

INSERT INTO Friends(user_id,friend_id)
VALUES (1,1); -- sẽ bị lỗi PK nếu trùng

CREATE TABLE user_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);
DELIMITER $$

CREATE PROCEDURE sp_register_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE username = p_username OR email = p_email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username hoặc Email đã tồn tại';
    ELSE
        INSERT INTO Users(username,password,email)
        VALUES(p_username,p_password,p_email);
    END IF;
END$$
DELIMITER ;
DELIMITER $$

CREATE TRIGGER trg_user_register_log
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO user_log(user_id, action)
    VALUES (NEW.user_id, 'REGISTER');
END$$
DELIMITER ;
CALL sp_register_user('son','123','son@gmail.com');
CALL sp_register_user('an','123','an@gmail.com');

-- test trùng
CALL sp_register_user('son','123','x@gmail.com');

SELECT * FROM Users;
SELECT * FROM user_log;




CREATE TABLE post_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);



DELIMITER $$

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF p_content IS NULL OR LENGTH(TRIM(p_content)) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nội dung bài viết không được rỗng';
    ELSE
        INSERT INTO Posts(user_id, content)
        VALUES(p_user_id, p_content);
    END IF;
END$$
DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_post_log
AFTER INSERT ON Posts
FOR EACH ROW
BEGIN
    INSERT INTO post_log(post_id, action)
    VALUES(NEW.post_id,'CREATE_POST');
END$$
DELIMITER ;
DELIMITER $$

CREATE TRIGGER trg_post_log
AFTER INSERT ON Posts
FOR EACH ROW
BEGIN
    INSERT INTO post_log(post_id, action)
    VALUES(NEW.post_id,'CREATE_POST');
END$$
DELIMITER ;
CALL sp_create_post(1,'Bài viết số 1');
CALL sp_create_post(1,'Bài viết số 2');

CALL sp_create_post(1,''); -- lỗi

SELECT * FROM Posts;
SELECT * FROM post_log;
ALTER TABLE Posts ADD like_count INT DEFAULT 0;
DELIMITER $$

CREATE TRIGGER trg_like_add
AFTER INSERT ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END$$

CREATE TRIGGER trg_like_remove
AFTER DELETE ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END$$
DELIMITER ;
INSERT INTO Likes VALUES(1,1,NOW());
SELECT post_id, like_count FROM Posts;

DELETE FROM Likes WHERE user_id=1 AND post_id=1;
SELECT post_id, like_count FROM Posts;

-- Like trùng => lỗi PK
INSERT INTO Likes VALUES(1,1,NOW());
INSERT INTO Likes VALUES(1,1,NOW());
SELECT post_id, like_count FROM Posts;

DELETE FROM Likes WHERE user_id=1 AND post_id=1;
SELECT post_id, like_count FROM Posts;

-- Like trùng => lỗi PK
INSERT INTO Likes VALUES(1,1,NOW());
DELIMITER $$

CREATE PROCEDURE sp_send_friend_request(
    IN p_sender INT,
    IN p_receiver INT
)
BEGIN
    IF p_sender = p_receiver THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Không thể tự kết bạn';
    ELSEIF EXISTS (
        SELECT 1 FROM Friends
        WHERE user_id=p_sender AND friend_id=p_receiver
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Đã gửi lời mời rồi';
    ELSE
        INSERT INTO Friends(user_id,friend_id,status)
        VALUES(p_sender,p_receiver,'pending');
    END IF;
END$$
DELIMITER ;
CALL sp_send_friend_request(1,2);
CALL sp_send_friend_request(1,1); -- lỗi
CALL sp_send_friend_request(1,2); -- lỗi trùng

SELECT * FROM Friends;
DELIMITER $$

CREATE TRIGGER trg_accept_friend
AFTER UPDATE ON Friends
FOR EACH ROW
BEGIN
    IF NEW.status='accepted' THEN
        INSERT IGNORE INTO Friends(user_id,friend_id,status)
        VALUES(NEW.friend_id,NEW.user_id,'accepted');
    END IF;
END$$
DELIMITER ;
UPDATE Friends SET status='accepted'
WHERE user_id=1 AND friend_id=2;

SELECT * FROM Friends;
DELIMITER $$

CREATE PROCEDURE sp_remove_friend(
    IN u1 INT,
    IN u2 INT
)
BEGIN
    START TRANSACTION;

    DELETE FROM Friends WHERE user_id=u1 AND friend_id=u2;
    DELETE FROM Friends WHERE user_id=u2 AND friend_id=u1;

    COMMIT;
END$$
DELIMITER ;
CALL sp_remove_friend(1,2);
SELECT * FROM Friends;
DELIMITER $$

CREATE PROCEDURE sp_delete_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    START TRANSACTION;

    IF NOT EXISTS (
        SELECT 1 FROM Posts
        WHERE post_id=p_post_id AND user_id=p_user_id
    ) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Không có quyền xóa';
    END IF;

    DELETE FROM Posts WHERE post_id=p_post_id;

    COMMIT;
END$$
DELIMITER ;
CALL sp_delete_post(1,1);
CALL sp_delete_post(2,1); -- lỗi

SELECT * FROM Posts;
DELIMITER $$

CREATE PROCEDURE sp_delete_user(
    IN p_user_id INT
)
BEGIN
    START TRANSACTION;

    DELETE FROM Users WHERE user_id=p_user_id;

    COMMIT;
END$$
DELIMITER ;
CALL sp_delete_user(1);

SELECT * FROM Users;
SELECT * FROM Posts;
SELECT * FROM Friends;
