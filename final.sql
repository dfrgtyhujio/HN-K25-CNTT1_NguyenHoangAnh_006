create database db_qlhv;
use db_qlhv;

-- PHẦN 1: DDL – THIẾT KẾ CSDL
-- 1. Bảng courses (Môn học):
create table courses(
	course_id int primary key auto_increment,
    course_name varchar(20) not null,
    course_code varchar(10) not null unique,
    department varchar(20) not null,
    creation_date date
);

-- 2. Bảng students (Sinh viên):
create table students(
	student_id int primary key auto_increment,
    full_name varchar(20) not null,
    major varchar(20) not null,
    phone_number int not null unique,
    gpa decimal(2,1) check(gpa between 0.0 and 4.0) default 4.0
);

-- 3. Bảng enrollments (Đăng ký học):
create table enrollments(
	enrollment_id int primary key auto_increment,
    course_id int,
    student_id int,
    enroll_time timestamp not null,
    credits int check (credits > 0),
    status enum('Pending', 'Completed', 'Dropped'),
    foreign key (course_id) references courses(course_id),
    foreign key (student_id) references students(student_id)
);

-- 4. Bảng enrollment_details (Chi tiết đánh giá):
create table enrollment_details(
	detail_id int primary key auto_increment,
    enrollment_id int,
    attendance_check varchar(20) not null,
    detail_date timestamp default current_timestamp,
    foreign key (enrollment_id) references enrollments(enrollment_id)
);

-- 5. Bảng academic_logs (Nhật ký học vụ):
create table academic_logs(
	log_id int primary key auto_increment,
    detail_id int,
    student_id int,
    log_time timestamp not null,
    note varchar(50)
);


-- PHẦN 2: DML – INSERT, UPDATE, DELETE
-- Câu 1 – INSERT
-- Bảng 1: courses
insert into courses values 
	(1, 'Lập trình Java', 'JAVA01', 'CNTT', '2023-12-03'),
    (2, 'Cấu trúc dữ liệu', 'DSA02', 'Khoa học máy tính', '1996-11-25'),
    (3, 'Cơ sở dữ liệu', 'SQL03', 'CNTT', '2001-07-08'),
    (4, 'Mạng máy tính', 'NET04', 'Truyền thông', '1998-01-19'),
    (5, 'Trí tuệ nhân tạo', 'AI05', 'Khoa học máy tính', '2000-09-30');
    
-- Bảng 2: students
insert into students values 
	(1, 'Nguyễn Văn Hải', 'Hệ thống TT', 0931112223, 3.8),
    (2, 'Trần Thu Hà', 'Kỹ thuật PM', 0932223334, 4.0),
    (3, 'Lê Quốc Tuấn', 'An toàn TT', 0933334445, 3.6),
    (4, 'Phạm Minh Châu', 'Dữ liệu lớn', 0934445556, 3.9),
    (5, 'Hoàng Gia Bảo', 'Kỹ thuật PM', 0935556667, 3.7);
    
-- Bảng 3: enrollments
insert into enrollments values 
	(7001, 1, 1, '2024-05-20 08:00', 3, 'Pending'),
    (7002, 2, 2, '2024-05-20 09:30', 4, 'Completed'),
    (7003, 3, 3, '2024-05-20 10:15', 3, 'Pending'),
    (7004, 4, 5, '2024-05-21 07:00', 3, 'Completed'),
    (7005, 5, 4, '2024-05-21 08:45', 4, 'Dropped');
    
-- Bảng 4: enrollment_details
insert into enrollment_details values 
	(8001, 7002, 'Đủ điều kiện thi', '2024-05-20 10:00'),
    (8002, 7004, 'Vắng 1 buổi', '2024-05-21 08:00'),
    (8003, 7001, 'Đang học', '2024-05-20 09:00'),
    (8004, 7003, 'Nghỉ phép', '2024-05-20 11:00'),
    (8005, 7005, 'Không đi học', '2024-05-21 09:00');
    
-- Bảng 5: academic_logs
insert into academic_logs values 
	(1, 8003, 1, '2024-05-20 09:05', 'Bắt đầu lớp học'),
    (2, 8001, 2, '2024-05-20 10:05', 'Hoàn tất môn học'),
    (3, 8004, 3, '2024-05-20 11:10', 'Đang sắp xếp lịch bù'),
    (4, 8002, 5, '2024-05-21 08:10', 'Chờ phê duyệt điểm'),
    (5, 8005, 4, '2024-05-21 09:05', 'Hủy do vắng quá số buổi');
    
-- Câu 2 – UPDATE & DELETE
-- 1
update enrollments as e
join courses as c on e.course_id = c.course_id
set e.credits = e.credits + 1 
where e.status = 'Completed'
	and year(c.creation_date) < 2000;
    
-- 2
delete from academic_logs where log_time < '2024-05-20';


-- PHẦN 3: TRUY VẤN CƠ BẢN
-- Câu 1 
select full_name, major, gpa
from students
where gpa > 3.8 or major = 'Kỹ thuật PM';

-- Câu 2
select course_name, course_code
from courses 
where creation_date between '1998-01-01' and '2001-12-31'
	and course_code like 'A%';
    
-- Câu 3 
select enrollment_id, enroll_time, credits
from enrollments
order by credits desc
limit 2 offset 2;


-- PHẦN 4: TRUY VẤN NÂNG CAO
-- Câu 1
select
	c.course_name,
    s.full_name,
    s.major,
    e.credits,
    e.enroll_time
from enrollments as e
join students as s on e.student_id = s.student_id
join courses as c on e.course_id = c.course_id;

-- Câu 2
select
	s.full_name,
    sum(e.credits) as total_credits
from students as s
left join enrollments as e on s.student_id = e.student_id
where status = 'Completed'
group by s.full_name
having sum(e.credits) > 120;

-- Câu 3
select student_id, full_name, gpa
from students
order by gpa desc
limit 1;


-- PHẦN 5: INDEX & VIEW
-- Câu 1
create index idx_enrollments on enrollments(credits, status);

-- Câu 2 
create view v_student as
select 
	s.full_name,
    count(distinct e.course_id) as total_courses,
    sum(e.credits) as total_credits
from students as s
left join enrollments as e on s.student_id = e.student_id
where e.status != 'Dropped'
group by s.full_name;


-- PHẦN 6: TRIGGER
-- Câu 1
delimiter //
create trigger trg_log_enrollments
	after update on enrollments 
    for each row
begin
	declare v_detail_id int;
    select detail_id into v_detail_id
    from enrollment_details
    where enrollment_id = new.enrollment_id;
    
	if (old.status != 'Completed' and new.status = 'Completed') then
		insert into academic_logs(detail_id, student_id, note, log_time) values
			(v_detail_id, new.student_id, 'Course completed', now());
	end if;
end //
delimiter ;

-- Câu 2
delimiter //
create trigger trg_increase_gpa
	after insert on enrollments
    for each row
begin
	declare v_gpa decimal(2,1);
    select gpa into v_gpa
    from students
    where student_id = new.student_id;
    
	if new.status = 'Completed' and v_gpa < 4.0 then
		update students 
        set gpa = gpa + 0.1
        where student_id = new.student_id;
	end if;
end //
delimiter ;


-- PHẦN 7: STORED PROCEDURE
-- Câu 1
delimiter //
create procedure sp_rating_student(
	in p_student_id int,
    out p_result varchar(20)
)
begin
	declare v_credits int;
    select sum(credits) into v_credits
	from enrollments
    where student_id = p_student_id;
	
    if v_credits > 100 then
		set p_result = 'Excellent progress';
	elseif v_credits = 100 then
		set p_result = 'Target met';
	else 
		set p_result = 'Normal progress';
	end if;
end //
delimiter ;

set @thongbao='';
call sp_rating_student(1, @thongbao);
select @thongbao;