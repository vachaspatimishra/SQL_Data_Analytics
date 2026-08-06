-- Create Database
CREATE DATABASE EY_questions;
USE EY_questions;

---------------------------------------------------
-- Departments Table
---------------------------------------------------
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO departments VALUES
(101,'IT'),
(102,'HR'),
(103,'Finance'),
(104,'Sales'),
(105,'Marketing');

---------------------------------------------------
-- Employees Table
---------------------------------------------------
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    dept_id INT,
    manager_id INT
);

INSERT INTO employees VALUES
(1,'Amit',65000,'2026-06-10',101,NULL),
(2,'Rahul',45000,'2025-11-15',101,1),
(3,'Sneha',72000,'2026-04-12',102,1),
(4,'Priya',58000,'2026-02-20',103,3),
(5,'Vikas',82000,'2025-08-18',104,NULL),
(6,'Neha',39000,'2026-07-01',105,5),
(7,'Rohan',91000,'2024-09-25',101,1),
(8,'Anjali',52000,'2026-05-15',104,5),
(9,'Mohit',48000,'2025-12-01',102,3),
(10,'Karan',75000,'2026-01-10',101,7);

---------------------------------------------------
-- Duplicate Employee Table
---------------------------------------------------
CREATE TABLE employee_duplicate (
    id INT,
    emp_name VARCHAR(50),
    dept VARCHAR(50)
);

INSERT INTO employee_duplicate VALUES
(1,'Amit','IT'),
(1,'Amit','IT'),
(2,'Rahul','IT'),
(2,'Rahul','IT'),
(2,'Rahul','IT'),
(3,'Sneha','HR'),
(4,'Priya','Finance'),
(4,'Priya','Finance'),
(5,'Vikas','Sales'),
(5,'Vikas','Sales');

---------------------------------------------------
-- Employee Backup Table
---------------------------------------------------
CREATE TABLE employee_backup AS
SELECT * FROM employees;

---------------------------------------------------
-- Managers Table
---------------------------------------------------
CREATE TABLE managers (
    manager_id INT PRIMARY KEY,
    manager_name VARCHAR(50)
);

INSERT INTO managers VALUES
(1,'Amit'),
(3,'Sneha'),
(5,'Vikas'),
(7,'Rohan');

---------------------------------------------------
-- Revenue Table
---------------------------------------------------
CREATE TABLE company_revenue (
    company VARCHAR(50),
    year INT,
    revenue DECIMAL(12,2)
);

INSERT INTO company_revenue VALUES
('ABC Ltd',2021,120000),
('ABC Ltd',2022,150000),
('ABC Ltd',2023,180000),
('ABC Ltd',2024,220000),

('XYZ Ltd',2021,90000),
('XYZ Ltd',2022,95000),
('XYZ Ltd',2023,92000),
('XYZ Ltd',2024,98000),

('PQR Ltd',2021,50000),
('PQR Ltd',2022,70000),
('PQR Ltd',2023,85000),
('PQR Ltd',2024,95000),

('MNO Ltd',2021,100000),
('MNO Ltd',2022,95000),
('MNO Ltd',2023,110000),
('MNO Ltd',2024,120000);




----------------------------------------
-- Practice Questions
----------------------------------------

-- 1. Delete duplicate data so only the first record remains
select * from employee_duplicate;

-- first, generate unique row_id (because id is not unique in this table)
alter table employee_duplicate 
add row_id int auto_increment primary key;

delete e1
from employee_duplicate e1
join employee_duplicate e2
on e1.id = e2.id
and e1.row_id > e2.row_id;


-- 2. Employees hired in the last 6 months
select emp_id, emp_name, hire_date
from employees
where hire_date >= date_sub(curdate(), interval 6 month);

-- 3. Delete duplicate records (using MIN())
drop table employee_duplicate;    -- deleted updated employee_duplicate table, and again created to solve this question > create unique row_id

delete from employee_duplicate
where row_id not in (
select * from (
select min(row_id) 
from employee_duplicate
group by id
) t
);

select * from employee_duplicate;

-- 4. Employees having salary > 50000 and working in IT
select e.emp_name, e.salary, d.dept_name
from employees e
join departments d
on e.dept_id = d.dept_id
where e.salary > 50000 and d.dept_name = "IT";

-- 5. Employee name with Department ID (without JOIN)
select emp_name, dept_id from employees;

-- using subquery + two tables
select emp_name, dept_id from employees
where dept_id in (
select dept_id from departments
);

-- or --
select emp_name, (
select dept_id
from departments d
where d.dept_id = e.dept_id
) as department_id
from employees e;

-- 6. Create an empty table with same structure
create table employees_copy
like employees;

-- or --
create table employees_copy
as
select * from employees
where 1 = 0;                          -- ("where 1 = 0" to copy only table structure without data)

select * from employees_copy


-- 7. Fetch common records between two tables
select * from employees
where emp_id in (
select emp_id from employee_backup
);

-- or --
select e.*
from employees e
join employee_backup eb
on e.emp_id = eb.emp_id;


-- 8. Employees who are also managers
select e1.*
from employees e1
join employees e2
on e1.emp_id = e2.manager_id;

-- or --
select e.*
from employees e
join managers m
on e.emp_id = m.manager_id;


-- 9. How can we update a View?          (View is a virtual table)
-- create view --
create view employees_view as 
select emp_id, emp_name, salary
from employees;

-- update view --
update employees_view
set salary = 55000
where emp_id = 2;

select * from employees_view;


-- 10. Companies whose revenue continuously increased every year
with revenue_cte as (
select *, lag(revenue) over(partition by company order by year) as prev_revenue
from company_revenue
)

select company 
from revenue_cte
where prev_revenue is not null
group by company
having count(*) = sum(revenue > prev_revenue);
