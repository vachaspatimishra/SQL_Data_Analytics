create database joins;
use joins;

create table students(
rno int,
name varchar(30));

create table marks(
rno int,
marks int);

insert into students values
(1, "Reena"),
(2, "Meena"),
(3, "Teena"),
(4, "Heena");

insert into marks values
(2, 50),
(3,55),
(4,60),
(5, 66);

select * from students;
select * from marks;

-- left join (keeps all the data from left table and matching from right table) (s and m are nickname and its mandatory to give)
select s.rno, s.name, m.marks
from students s
left join marks m
on s.rno = m.rno;

-- right join (keeps all the data from right table and matching from left table)
select m.rno, s.name, m.marks
from students s
right join marks m
on s.rno=m.rno;

-- inner join (common values in both tables)
select s.rno, s.name, m.marks
from students s
inner join marks m
on s.rno = m.rno;

-- full outer join (joins all the data)
select s.rno, s.name, m.marks
from students s
left join marks m
on s.rno = m.rno

union

select s.rno, s.name, m.marks
from students s
right join marks m
on s.rno=m.rno;



