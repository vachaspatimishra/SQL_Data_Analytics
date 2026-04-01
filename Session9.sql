create schema session7;
use session7;

CREATE TABLE students1 (
    id INT,
    name VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO students1 VALUES
(1,'asha','mumbai'),
(2,'ravi','delhi'),
(3,'neha','bangalore'),
(4,'aman','pune'),
(5,'kiran','chennai');

select * from students1;

select *, left(name, 3) as left_fun from students1;
select *, right(name, 3) as right_fun from students1;
select *, mid(name, 2, 3) as mid_fun from students1;
select *, trim(name) as trim_name from students1;
select *, replace(city, "bangalore", "Bengaluru") from students1;
select *, lower(city)as lower_fun from students1;
select *, upper(city) as upper_fun from students1;
select * , concat(name,"-", city) as concat_fun from students1;
select *, length(name) as length_fun from students1;

CREATE TABLE students3 (
    id INT,
    name VARCHAR(50),
    marks INT
);


CREATE TABLE students3 (
    id INT,
    name VARCHAR(50),
    marks int
);

INSERT INTO students3 VALUES
(1,'Asha',85),
(2,'Ravi',90),
(3,'Neha',88),
(4,'Ravi',90),
(5,'Asha',85),
(6,'Aman',75);

select * from students3;

-- Find Duplicates
select name, marks, count(name) from students3 group by name, marks having count(name)>1;

-- Delete Duplicates
-- using row_number window function
delete                               -- yeh to sabkuch delete kar rha hai
from students3
where id in (select id from (select id, row_number() over(partition by name, marks order by id) as m
from students3) t
where m > 1
);

-- delete duplicates using joins
delete s1
from students3 s1
join students3 s2
on s1.name = s2.name
and s1.marks = s2.marks
and s1.id>s2.id;

select * from students3;

-- Find the 3rd highest rank student
select * from
(select *, dense_rank() over(order by marks desc) as rank1 from students3) t
where rank1 = 3;



CREATE TABLE exam_scores (
    student_id INT,
    student_name VARCHAR(50),
    subject VARCHAR(50),
    exam_date DATE,
    marks INT
);

INSERT INTO exam_scores VALUES
(1,'Asha','Math','2024-01-10',85),
(1,'Asha','Science','2024-01-12',88),

(2,'Ravi','Math','2024-01-10',78),
(2,'Ravi','Science','2024-01-12',82),

(3,'Neha','Math','2024-01-10',92),
(3,'Neha','Science','2024-01-12',89),

(4,'Aman','Math','2024-01-10',85),
(4,'Aman','Science','2024-01-12',80),

(5,'Kiran','Math','2024-01-10',75),
(5,'Kiran','Science','2024-01-12',77);


select * from exam_scores;

select subject, sum(marks) from exam_scores group by subject;


-- Window Functions (here, partition means grouping)
select *, sum(marks) over(partition by subject) as total_marks from exam_scores;

select *, rank() over(partition by student_name order by marks desc) as rank1, 
dense_rank() over(order by marks desc) as dense_rank1, 
row_number() over(order by marks desc) as row_number1 
from exam_scores;

-- Ranking with total marks
-- Method 1 (by using subquery, alias needed for subquery temporary table reference)

select student_name, total_marks, rank() over(order by total_marks desc) as rank1 
from (select student_name, sum(marks) as total_marks from exam_scores group by student_name) as t;

-- Method 2
select student_name, sum(marks) as total_marks, rank() over(order by sum(marks) desc) as rank2 
from exam_scores group by student_name;



CREATE TABLE numbers (
    id INT,
    value INT
);

INSERT INTO numbers VALUES
(1, 10),
(2, 20),
(3, 30),
(4, 40),
(5, 50);

select * from numbers;

select *, lead(value) over(order by id) as lead1 from numbers;
select *, lag(value) over(order by id) as lag1 from numbers;

select *, lead(value) over(order by id) as lead1, lag(value) over(order by id) as lag1 from numbers;