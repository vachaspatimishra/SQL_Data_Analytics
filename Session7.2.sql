create schema subquery;
use subquery;
CREATE TABLE students (
    student_id INT,
    name VARCHAR(50),
    class VARCHAR(20)
);
INSERT INTO students VALUES
(1, 'Rahul', '10A'),
(2, 'Anita', '10A'),
(3, 'Amit', '10B'),
(4, 'Meena', '10B');


CREATE TABLE marks (
    student_id INT,
    subject VARCHAR(20),
    marks INT
);
INSERT INTO marks VALUES
(1, 'Math', 80),
(1, 'Science', 70),
(2, 'Math', 90),
(2, 'Science', 85),
(3, 'Math', 60),
(3, 'Science', 65),
(4, 'Math', 95),
(4, 'Science', 90);

select * from students;
select * from marks;

-- Subqueries (or nested queries)
-- Show students who scored more than the class average
select * from marks where marks > (select avg(marks) from marks);

-- Show student(s) who scored the highest marks
select * from marks where marks = (select max(marks) from marks);

-- Show students who scored below average
select * from marks where marks < (select avg(marks) from marks);

-- Show students who scored exactly the class average
select * from marks where marks = (select avg(marks) from marks);

-- updated query 1
select s.name, m.marks
from students s
left join marks m
on s.student_id = m.student_id
where marks > (select avg(marks) from marks);

-- updated query 2
select s.name, m.marks
from students s
left join marks m
on s.student_id = m.student_id
where marks = (select max(marks) from marks);

-- updated query 3
select s.name, m.marks
from students s
left join marks m
on s.student_id = m.student_id
where marks < (select avg(marks) from marks);

-- updated query 4
select s.name, m.marks
from students s
left join marks m
on s.student_id = m.student_id
where marks = (select avg(marks) from marks);



-- Cases
-- "agar marks >= 80 → Distinction
-- warna agar marks >= 60 → Pass
-- warna agar marks >= 40 → Average
-- warna → Fail"

-- "agar marks >= 40 → Pass
-- warna → Fail"

select *,
case
when marks >= 80 then "Distinction"
when marks >= 60 then "Pass"
when marks >= 40 then "Average"
else "Fail"
end as Result
from marks;

select *,
case
when marks >= 40 then "Pass"
else "Fail"
end as Result
from marks;

-- Views
create view student_grade as
select s.name, m.marks
from students s
left join marks m
on s.student_id = m.student_id
where marks > (select avg(marks) from marks);

select * from student_grade;

select * from zomato;


-- few columns
-- join
