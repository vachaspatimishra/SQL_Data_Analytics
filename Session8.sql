create database abc;
use abc;
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    city VARCHAR(50)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    instructor VARCHAR(50)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    marks INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Students VALUES
(1,'Rahul',20,'Mumbai'),
(2,'Sneha',21,'Pune'),
(3,'Amit',19,'Delhi'),
(4,'Priya',22,'Mumbai'),
(5,'Karan',20,'Bangalore'),
(6,'Anjali',21,'Delhi'),
(7,'Rohan',23,'Pune'),
(8,'Neha',20,'Mumbai'),
(9,'Vikas',24,'Chennai'),
(10,'Simran',22,'Delhi');

INSERT INTO Courses VALUES
(101,'SQL','Dr. Sharma'),
(102,'Python','Dr. Mehta'),
(103,'Machine Learning','Dr. Rao'),
(104,'Data Science','Dr. Gupta'),
(105,'Cyber Security','Dr. Iyer');

INSERT INTO Enrollments VALUES
(1,1,101,85),
(2,2,101,78),
(3,3,102,90),
(4,4,101,65),
(5,5,103,88),
(6,6,102,72),
(7,7,104,91),
(8,8,103,67),
(9,9,105,80),
(10,10,101,74),
(11,1,102,82),
(12,2,103,76),
(13,3,104,89),
(14,4,105,70),
(15,5,101,84);

select * from students;
select * from courses;
select * from enrollments;


-- Show all students who live in Mumbai.
select * from students where city = "Mumbai";

-- Display students whose age is greater than 21.
select * from students where age > 21;

-- Show students whose age is between 20 and 22.
select * from students where age >=20 and age <=22;
select * from students where age between 20 and 22;

-- Display students whose name starts with 'A'.
select * from students where name like "A%";

-- Show student names with their marks.
select s.name, e.marks
from students s
left join enrollments e
on s.student_id = e.student_id;

-- Display student name and course_id they enrolled in.
select s.name, e.course_id
from students s
left join enrollments e
on s.student_id = e.student_id;

-- Show students who enrolled in course 101.
select s.name, e.course_id
from students s
left join enrollments e
on s.student_id = e.student_id
where course_id = "101";

-- Display students with marks greater than 80.
select s.name, e.marks
from students s
left join enrollments e
on s.student_id = e.student_id
where marks > 80;

-- Show students who live in Mumbai and their marks.
select s.name, s.city, e.marks
from students s
left join enrollments e
on s.student_id = e.student_id
where s.city = "Mumbai";

-- Show student name with course name.
select s.name, c.course_name
from students s
join enrollments e
on s.student_id = e.student_id
join courses c
on e.course_id = c.course_id;

-- Display student name, course name, and marks.
select s.name, c.course_name, e.marks
from students s
join enrollments e
on s.student_id = e.student_id
join courses c
on e.course_id = c.course_id;

-- Show students who enrolled in SQL course.
select s.name, c.course_name
from students s
join enrollments e 
on s.student_id = s.student_id
join courses c
on e.course_id = c.course_id
where course_name = "SQL";

-- Show student name, course name, instructor, and marks.
select s.name, c.course_name, c.instructor, e.marks
from students s
join enrollments e 
on s.student_id = s.student_id
join courses c
on e.course_id = c.course_id;

-- Find students whose age is greater than the average age.
select * from students where age > (select avg(age) from students);

-- Find the student with the maximum age.
select * from students where age = (select max(age) from students);

-- Find students who are the same age as Rahul.
select * from students where age = (select age from students where name = "Rahul");

-- Find the student who scored the highest marks scored.
select s.name, e.marks
from students s
left join enrollments e
on s.student_id = e.student_id
where marks = (select max(marks) from enrollments);

-- Find students who scored more than the average marks.
select s.name, e.marks
from students s
left join enrollments e
on s.student_id = e.student_id
where marks > (select avg(marks) from enrollments);

-- Find students who scored the minimum marks.
select s.name, e.marks
from students s
left join enrollments e
on s.student_id = e.student_id
where marks = (select min(marks) from enrollments);

-- Find names of students who scored more than 85 marks.
select s.name, e.marks
from students s
left join enrollments e
on s.student_id = e.student_id
where marks > 85;

-- Display all students sorted by age in ascending order.
select * from students order by age;

-- Display students sorted by age in descending order.
select * from students order by age desc;

-- Show all enrollments sorted by marks (highest first).
select * from enrollments order by marks desc;

-- Display students sorted alphabetically by name.
select * from students order by name;

-- Show students sorted first by city and then by age.
select * from students order by city, age;

-- Find the average marks for each course.
select course_id, avg(marks) from enrollments group by course_id;

-- Find the maximum marks scored in each course.
select course_id, max(marks) from enrollments group by course_id;

-- Find the minimum marks scored in each course.
select course_id, min(marks) from enrollments group by course_id;

-- Find total students enrolled in each course.
select course_id, count(student_id) as student_count from enrollments group by course_id;

-- Show courses where average marks are greater than 80.
select course_id, avg(marks) from enrollments group by course_id having avg(marks) > 80;

-- Show courses where more than 2 students are enrolled.
select course_id, count(student_id) as student_count from enrollments group by course_id having count(student_id) > 2;

-- Show cities with more than 2 students.
select city, count(name) from students group by city having count(name)>2;

-- Show average marks of courses sorted by highest average marks.
select avg(marks) from enrollments group by course_id order by avg(marks) desc;

-- Show number of students in each city sorted by highest count.
select city, count(student_id) as student_count from students group by city order by count(student_id) desc;
