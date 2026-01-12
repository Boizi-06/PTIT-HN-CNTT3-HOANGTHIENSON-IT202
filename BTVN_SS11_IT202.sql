-- 1) Sử dụng lại database social_network_pro để thao tác
-- 2) Viết stored procedure tên CalculateBonusPoints nhận hai tham số:
-- p_user_id (INT, IN) – ID của user
-- p_bonus_points (INT, INOUT) – Điểm thưởng ban đầu (khi gọi procedure, bạn truyền vào một giá trị điểm khởi đầu, ví dụ 100).
-- Trong procedure:
-- Đếm số lượng bài viết (posts) của user đó.
-- Nếu số bài viết ≥ 10, cộng thêm 50 điểm vào p_bonus_points.
-- Nếu số bài viết ≥ 20, cộng thêm tổng cộng 100 điểm (thay vì chỉ 50).
-- Cuối cùng, tham số p_bonus_points sẽ được sửa đổi và trả ra giá trị mới.

DELIMITER //
create procedure CalculateBonusPoints(p_user_id int, inout p_bonus_points int)
begin
	declare total_posts int;
 	set total_posts = (select count(post_id) from posts where user_id = p_user_id);
    if total_posts >= 10 then
		set p_bonus_points = p_bonus_points + 50;
	elseif  total_posts >= 20 then
		set p_bonus_points = p_bonus_points + 100;
    else     
		set p_bonus_points = p_bonus_points + 150;
	end if;
end //
DELIMITER ;
set @p_bonus_point = 100;
call CalculateBonusPoints(1, @p_bonus_point);
select @p_bonus_point;

drop procedure if exists CalculateBonusPoints;


--  1) Sử dụng lại database social_network_pro để thực hành bài trên\
-- 2) Viết procedure tên CreatePostWithValidation nhận IN p_user_id (INT), IN p_content (TEXT). 
-- Nếu độ dài content < 5 ký tự thì không thêm bài viết và SET một biến thông báo lỗi 
-- (có thể dùng OUT result_message VARCHAR(255) để trả về thông báo “Nội dung quá ngắn” hoặc “Thêm bài viết thành công”).

delimiter //
create procedure CreatePostWithValidation(p_user_id int, p_content text, out result_message varchar(255))
begin
	if char_length(p_content) < 5 then
		set result_message = 'Nội dung quá ngắn';
	else
		insert into posts(user_id, content) values (p_user_id, p_content);
		set result_message = 'Thêm bài viết thành công';
    end if;
end //
delimiter ;

call CreatePostWithValidation(1, 'vvv', @rs);
select @rs;


-- Sử dụng db social_network_pro
use social_network_pro;

-- 2) Tạo stored procedure có tham số IN nhận vào p_user_id:
-- Tạo stored procedure nhận vào mã người dùng p_user_id và trả về danh sách bài viết của user đó.Thông tin trả về gồm:
-- PostID (post_id)
-- Nội dung (content)
-- Thời gian tạo (created_at)

DELIMITER //
create procedure getPostsOfUser(p_user_id int)
begin
	select post_id, content, created_at from posts 
    where user_id = p_user_id;
end //
DELIMITER ;

-- 3) Gọi lại thủ tục vừa tạo với user cụ thể
call getPostsOfUser(1);

-- 4) Xóa thủ tục vừa tạo.
drop procedure if exists getPostsOfUser;


--    1) Sử dụng lại database social_network_pro  để tiến hành thao tác
-- 2) Tính tổng like của bài viết
-- Viết stored procedure CalculatePostLikes nhận vào:
-- IN p_post_id: mã bài viết
-- OUT total_likes: tổng số lượt like nhận được trên tất cả bài viết của người dùng đó

DELIMITER //
create procedure CalculatePostLikes(p_post_id int, out total_likes int)
begin
	set total_likes = (select count(user_id) as total from likes 
							where post_id = p_post_id);
end //
DELIMITER ;
set @total_like  = 0;
call  CalculatePostLikes(103, @total_like);
select @total_like;

-- 4) Xóa thủ tục vừa mới tạo trên
drop procedure if exists CalculatePostLikes;









--  1) Sử dụng lại database social_network_pro để thực hành bài trên
-- 2)Viết procedure tên CalculateUserActivityScore nhận IN p_user_id (INT), trả về OUT activity_score (INT). 
-- Điểm được tính: mỗi post +10 điểm, mỗi comment +5 điểm, mỗi like nhận được +3 điểm. Sử dụng CASE hoặc IF để 
-- phân loại mức hoạt động (ví dụ: >500 “Rất tích cực”, 200-500 “Tích cực”, <200 “Bình thường”) 
-- và trả thêm OUT activity_level (VARCHAR(50)).

delimiter //
create procedure CalculateUserActivityScore(p_user_id int, out activity_score int, out activity_level varchar(50))
begin
	declare total_posts int; 
    declare total_cmts int;
    declare total_likes int;
	set total_posts = (select count(post_id) from posts where user_id = p_user_id);
	set total_cmts = (select count(comment_id) from comments where user_id = p_user_id);
	set total_likes = (select count(post_id) from posts where user_id = p_user_id);
    set activity_score = total_posts*10 + total_cmts*5 + total_likes*3 ;
    
    if activity_score > 500 then
		set activity_level = 'Rất tích cực';
	elseif activity_score >= 200 then
		set activity_level = 'Tích cực';
	else 
		set activity_level = 'Bình thường';
	end if;
end //
delimiter ;

call CalculateUserActivityScore(8, @score, @level);
select @score, @level;

drop procedure if exists CalculateUserActivityScore;













-- 1) Sử dụng lại database social_network_pro 
-- 2)  Viết stored procedure tên NotifyFriendsOnNewPost nhận hai tham số IN:
-- p_user_id (INT) – ID của người đăng bài
-- p_content (TEXT) – Nội dung bài viết
-- Procedure sẽ thực hiện hai việc:

-- Thêm một bài viết mới vào bảng posts với user_id và content được truyền vào.
-- Tự động gửi thông báo loại 'new_post' vào bảng notifications cho tất cả bạn bè đã accepted (cả hai chiều trong bảng friends).
-- Nội dung thông báo: “[full_name của người đăng] đã đăng một bài viết mới”.
-- Không gửi thông báo cho chính người đăng bài.

DELIMITER //
create procedure NotifyFriendsOnNewPost( p_user_id int, p_content text)
begin
	declare v_full_name varchar(100);
    select full_name into v_full_name from users where user_id = p_user_id;
    
	insert into posts(user_id, content) values (p_user_id, p_content);
    -- gui thong bao
    insert into notifications (user_id, type, content)
	select f.friend_id, 'new_post', concat(v_full_name, ' đã đăng một bài viết mới')
	from friends f
	where f.user_id = p_user_id and f.status = 'accepted'
 
	union

	select f.user_id, 'new_post', concat(v_full_name, ' đã đăng một bài viết mới')
	from friends f
	where f.friend_id = p_user_id and f.status = 'accepted';
end //
DELIMITER ;

call NotifyFriendsOnNewPost(1, 'chuyen khong qua bay gio mơi ke');

select * from notifications;

drop procedure if exists NotifyFriendsOnNewPost;