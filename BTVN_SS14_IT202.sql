create database ss13_Bai1;
use ss13_Bai1;
create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

-- tạo bảng posts
create table posts (
    post_id int auto_increment primary key,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- thêm dữ liệu mẫu vào users
insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

-- trigger sau khi thêm bài viết
delimiter $$
create trigger trg_after_insert_posts after insert on posts for each row
begin
    update users
    set post_count = post_count + 1
    where user_id = new.user_id;
end$$
delimiter ;

-- trigger sau khi xóa bài viết
delimiter $$
create trigger trg_after_delete_posts after delete on posts for each row
begin
    update users
    set post_count = post_count - 1
    where user_id = old.user_id;
end$$
delimiter ;

insert into posts (user_id, content, created_at) values
(1, 'hello world from alice!', '2025-01-10 10:00:00'),
(1, 'second post by alice', '2025-01-10 12:00:00'),
(2, 'bob first post', '2025-01-11 09:00:00'),
(3, 'charlie sharing thoughts', '2025-01-12 15:00:00');

-- kiểm tra bảng users
select * from users;

-- xóa một bài đăng (post_id = 2)
delete from posts where post_id = 2;

-- kiểm tra lại bảng users
select * from users;






create database ss13_bai2;
use ss13_bai2;
create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

-- posts
create table posts (
    post_id int auto_increment primary key,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- dữ liệu users
insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

-- dữ liệu posts
insert into posts (user_id, content, created_at) values
(1, 'hello world from alice', '2025-01-10 10:00:00'),
(1, 'second post by alice', '2025-01-10 12:00:00'),
(2, 'bob first post', '2025-01-11 09:00:00'),
(3, 'charlie sharing thoughts', '2025-01-12 15:00:00');
create table likes (
    like_id int auto_increment primary key,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade
);
-- thêm dữ liệu mẫu vào likes
insert into likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

--  trigger cập nhật like_count trong posts

delimiter $$
create trigger trg_after_insert_likes after insert on likes for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end$$
delimiter ;

delimiter $$
create trigger trg_after_delete_likes after delete on likes for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end$$
delimiter ;
-- tạo view user_statistics
drop view if exists user_statistics;

create view user_statistics as
select u.user_id,u.username,u.post_count,ifnull(sum(p.like_count), 0) as total_likes from users u left join posts p on u.user_id = p.user_id group by u.user_id, u.username, u.post_count;

--  thêm lượt thích và kiểm chứng
insert into likes (user_id, post_id, liked_at) values (2, 4, now());

select * from posts where post_id = 4;

select * from user_statistics;

delete from likes
where user_id = 2 and post_id = 4;
select * from posts where post_id = 4;

select * from user_statistics;





use ss13_bai2;
select * from users;
select * from posts;
select * from likes;
drop trigger if exists trg_before_insert_likes;
drop trigger if exists trg_after_insert_likes;
drop trigger if exists trg_after_delete_likes;
drop trigger if exists trg_after_update_likes;

delimiter $$
create trigger trg_before_insert_likes
before insert on likes
for each row
begin
    declare post_owner int;
    select user_id
    into post_owner
    from posts
    where post_id = new.post_id;
    if post_owner = new.user_id then
        signal sqlstate '45000'
        set message_text = 'khong duoc like bai dang cua chinh minh';
    end if;
end$$
delimiter ;

delimiter $$
-- 3.2 after insert: tăng like_count
create trigger trg_after_insert_likes
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end$$
delimiter ;

delimiter $$
-- giảm like_count
create trigger trg_after_delete_likes after delete on likes for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end$$
delimiter ;

delimiter $$
-- đổi like sang post khác
create trigger trg_after_update_likes after update on likes for each row
begin
    -- giảm like
    if old.post_id <> new.post_id then
        update posts
        set like_count = like_count - 1
        where post_id = old.post_id;

        -- tăng like
        update posts
        set like_count = like_count + 1
        where post_id = new.post_id;
    end if;
end$$
delimiter ;

-- thêm like hợp lệ
insert into likes (user_id, post_id) values (2, 1);
select post_id, like_count from posts where post_id = 1;

-- update like sang post khác
update likes set post_id = 3 where user_id = 2 and post_id = 1;
select post_id, like_count from posts where post_id in (1, 3);

-- xóa like
delete from likes where user_id = 2 and post_id = 3;

select post_id, like_count from posts where post_id = 3;

-- 5. kiểm chứng bằng select
select * from posts;

select * from user_statistics;





create database ex4_ss13;
use ex4_ss13;
set foreign_key_checks = 0;
create table users (
	user_id int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(50) not null unique,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

create table posts(
	post_id int auto_increment primary key,
    user_id int ,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id)
);

CREATE TABLE post_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME,
    changed_by_user_id INT,
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
);

create table likes(
	like_id INT PRIMARY KEY auto_increment,
    user_id INT,
    post_id INT,
    liked_at DATETIME default(current_time()),
    foreign key(user_id) references
    users(user_id),
    foreign key(post_id) references
    posts(post_id)
); 

INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

INSERT INTO post_history 
(post_id, old_content, new_content, changed_at, changed_by_user_id)
VALUES
(1,
 'Hello world from Alice!',
 'Hello world from Alice! (edited)',
 '2025-01-15 10:30:00',
 1),

(2,
 'Second post by Alice',
 'Second post by Alice - updated content',
 '2025-01-16 14:00:00',
 1),

(3,
 'Bob first post',
 'Bob first post (fixed typo)',
 '2025-01-17 09:15:00',
 2),

(4,
 'Charlie sharing thoughts',
 'Charlie sharing thoughts - add hashtag #life',
 '2025-01-18 20:45:00',
 3);
-- before update trên posts: nếu content thay đổi, insert bản ghi vào post_history với old_content (old.content), new_content (new.content), changed_at now(), và giả sử changed_by_user_id là user_id của post.
delimiter //
create trigger tg_before_update_post
before update
on posts
for each row
begin
	if old.content <> new.content then
		insert into post_history(post_id,old_content,new_content,changed_at,changed_by_user_id) value
		(old.post_id,old.content,new.content,curdate(),old.user_id);
	end if;
end //
delimiter ;

-- after delete trên posts: có thể ghi log hoặc để cascade.
delimiter //
create trigger tg_after_delete_posts
after delete on posts
for each row
begin
	insert into post_history(post_id,old_content,new_content,changed_at,changed_by_user_id) value
    (old.post_id,old.content,'đã xoá',curdate(),old.user_id);
end //

delimiter ;

-- 4) thực hiện update nội dung một số bài đăng, sau đó select từ post_history để xem lịch sử.
update posts
set content = 'nội dung lần 3: chào mọi người, mình mới sửa bài!' 
where post_id = 1;

-- 5) kiểm tra kết hợp với trigger like_count từ bài trước vẫn hoạt động khi update post.
insert into likes (user_id, post_id) values (1, 3);

select * from posts;
select * from post_history;








create database ex5_ss13;
use ex5_ss13;
set foreign_key_checks = 0;
create table users (
	user_id int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(50) not null unique,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

create table posts(
	post_id int auto_increment primary key,
    user_id int ,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id)
);

CREATE TABLE post_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME,
    changed_by_user_id INT,
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
);

create table likes(
	like_id INT PRIMARY KEY auto_increment,
    user_id INT,
    post_id INT,
    liked_at DATETIME default(current_time()),
    foreign key(user_id) references
    users(user_id),
    foreign key(post_id) references
    posts(post_id)
); 

INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

INSERT INTO post_history 
(post_id, old_content, new_content, changed_at, changed_by_user_id)
VALUES
(1,
 'Hello world from Alice!',
 'Hello world from Alice! (edited)',
 '2025-01-15 10:30:00',
 1),

(2,
 'Second post by Alice',
 'Second post by Alice - updated content',
 '2025-01-16 14:00:00',
 1),

(3,
 'Bob first post',
 'Bob first post (fixed typo)',
 '2025-01-17 09:15:00',
 2),

(4,
 'Charlie sharing thoughts',
 'Charlie sharing thoughts - add hashtag #life',
 '2025-01-18 20:45:00',
 3);
delimiter //
create procedure add_user(username varchar(50), email varchar(50))
begin
	insert into users(username, email, created_at) values
    (username, email, now());
end //
create trigger trigger_before_insert
    before insert on users
    for each row
    begin
		if ((new.email not like '%@%' and new.email not like '%.%') or new.username not REGEXP '^[A-Za-z0-9]+$') 
        then
			 signal sqlstate '45000'
        set message_text = 'Data not valid';
        end if;
	end;
delimiter ;
select * from users;








drop database if exists ex6_ss13;
create database ex6_ss13;
use ex6_ss13;

create table users (
    user_id int primary key auto_increment,
    username varchar(50) unique not null,
    email varchar(100) unique not null,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

create table posts (
    post_id int primary key auto_increment,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id)
        on delete cascade
);

create table friendships (
    follower_id int,
    followee_id int,
    status enum('pending', 'accepted') default 'accepted',
    primary key (follower_id, followee_id),
    foreign key (follower_id) references users(user_id)
        on delete cascade,
    foreign key (followee_id) references users(user_id)
        on delete cascade
);

insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

delimiter $$

create trigger trg_post_insert
after insert on posts
for each row
begin
    update users
    set post_count = post_count + 1
    where user_id = new.user_id;
end $$

create trigger trg_post_delete
after delete on posts
for each row
begin
    update users
    set post_count = post_count - 1
    where user_id = old.user_id;
end $$

delimiter ;

delimiter $$

create trigger trg_follow_insert
after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users
        set follower_count = follower_count + 1
        where user_id = new.followee_id;
    end if;
end $$

create trigger trg_follow_delete
after delete on friendships
for each row
begin
    if old.status = 'accepted' then
        update users
        set follower_count = follower_count - 1
        where user_id = old.followee_id;
    end if;
end $$

delimiter ;

delimiter $$

create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    in p_status enum('pending','accepted')
)
begin
    -- không cho tự follow
    if p_follower_id = p_followee_id then
        signal sqlstate '45000'
        set message_text = 'cannot follow yourself';
    end if;

    -- tránh follow trùng
    if exists (
        select 1 from friendships
        where follower_id = p_follower_id
          and followee_id = p_followee_id
    ) then
        signal sqlstate '45000'
        set message_text = 'already followed or pending';
    end if;

    -- thêm quan hệ follow
    insert into friendships (follower_id, followee_id, status)
    values (p_follower_id, p_followee_id, p_status);
end $$

delimiter ;

create view user_profile as
select 
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    ifnull(sum(p.like_count), 0) as total_likes,
    group_concat(
        concat('[', p.created_at, '] ', p.content)
        order by p.created_at desc
        separator ' | '
    ) as recent_posts
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count;

insert into posts (user_id, content, created_at, like_count) values
(1, 'alice first post', '2025-01-10 10:00:00', 5),
(1, 'alice second post', '2025-01-11 11:00:00', 3),
(2, 'bob post', '2025-01-12 09:00:00', 10),
(3, 'charlie post', '2025-01-13 15:00:00', 1);

call follow_user(2, 1, 'accepted');   
call follow_user(3, 1, 'accepted'); 
call follow_user(1, 2, 'pending');    

-- kiểm tra follower_count
select user_id, username, follower_count from users;

delete from friendships
where follower_id = 3 and followee_id = 1;

-- kiểm tra lại
select user_id, username, follower_count from users;

select * from user_profile;