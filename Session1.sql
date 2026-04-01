create database college;
use college;
create table student_details(
rno int,
name varchar(30),
email varchar(30)
);

create table marks(
rno int,
subject varchar(30),
marks int
);

show tables;

insert into student_details values(1, "Vachas", "v@gmail.com");
insert into student_details values(2, "priya", "p@gmail.com");
insert into student_details values(3, "gautam", "g@gmail.com");
insert into student_details values(4, "pushkar", "ps@gmail.com");

select * from student_details;

set sql_safe_updates = 0;
set sql_safe_updates = 1;

delete from student_details
where name = "Vachas";

select *from student_details;







