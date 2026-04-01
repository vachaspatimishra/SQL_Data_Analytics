use sales;
select * from employee_sales;

-- Select Queries
-- Display all records from the employee_sales table.
select * from employee_sales;

-- Display only employee_name, product, and sale_amount.
select employee_name, product, sale_amount from employee_sales;

-- Display employee_name and region for all sales.
select employee_name, region from employee_sales;

-- Display all records but rename sale_amount as Amount.
select sale_id, employee_name, department, product, region, sale_amount as amount, sale_date from employee_sales;

-- Display all sales where only product and sale date are shown.
select product, sale_date from employee_sales;


-- WHERE Clause – Basic Filtering
-- Show all sales from the Mumbai region.
select *  from employee_sales where region = "Mumbai";

-- Show all sales with sale_amount greater than 20,000.
select * from employee_sales where sale_amount > 20000;

-- Show all sales that happened on 2025-01-02.
select * from employee_sales where sale_date = "2025-01-02";

-- Show all sales with sale_amount between 10,000 and 30,000.
select * from employee_sales where sale_amount >= 10000 and sale_amount <= 30000;

-- Show all sales that are not from the Stationery department.
select * from employee_sales where department != "Stationery";


-- Logical Operators
-- Show all Electronics sales with amount greater than 30,000.
select * from employee_sales where department = "Electronics" and sale_amount > 30000;

-- Show all sales from Mumbai OR Delhi.
select * from employee_sales where region = "Mumbai" or region =  "Delhi";

-- Show all Electronics sales from Mumbai OR Delhi.
select * from employee_sales where department = "Electronics" and(region = "Mumbai" or region = "Delhi");

-- Show all sales from Furniture department in Pune.
select * from employee_sales where department = "Furniture" and region = "Pune";

-- Show all sales not happening in Pune.
select * from employee_sales where region != "Pune";


-- Wildcards
-- Find all employees whose name starts with ‘A’.
select * from employee_sales where employee_name like "A%";

-- Find all employees whose name ends with ‘i’.
select * from employee_sales where employee_name like "%i";

-- Find all products that contain the word ‘top’.
select * from employee_sales where product like "%top%";

-- Find all employee names with exactly 5 characters.
select * from employee_sales where employee_name like "_____";

-- Find all products whose name starts with ‘Lap’.
select * from employee_sales where product like "Lap%";


-- Distinct
-- Display all unique departments.
select distinct department from employee_sales;

-- Display all unique regions.
select distinct region from employee_sales;

-- Display all unique department–region combinations.
select distinct department, region from employee_sales;

-- Display all unique products sold.
select distinct product from employee_sales;


-- Sorting Records (ORDER BY)
-- Display all records sorted by sale_amount (lowest to highest).
select * from employee_sales order by sale_amount;

-- Display all records sorted by sale_amount (highest to lowest).
select * from employee_sales order by sale_amount desc;

-- Display all records sorted by sale_date (latest first).
select * from employee_sales order by sale_date desc;

-- Display all records sorted by department alphabetically.
select * from employee_sales order by  department ;

-- Display all records sorted by department, and within each department by highest sale amount.
select * from employee_sales order by department, sale_amount desc;


-- LIMIT
-- Display only the first 3 records.
select * from employee_sales limit 3;

-- Display the top 2  highest sales.
select * from employee_sales order by sale_amount desc limit 2;

-- Display the latest 3 sales records.
select * from employee_sales order by sale_date desc limit 3;

-- Display records 2 to 4 from the table.
select * from employee_sales limit 1, 3;


-- Add Columns
-- Add column - payment mode to the existing table with constraint not null
alter table employee_sales add payment_mode varchar(30) not null;

-- Add multiple columns - discount, remarks
alter table employee_sales add(discount float, remarks varchar(30));

-- Add column at a specific position - email after employee_name
alter table employee_sales add column email varchar(50) after employee_name;


-- Change
-- change datatype of sale_amount to decimal
alter table employee_sales modify sale_amount decimal;               -- decimal- default value as (10,0), decimal(10,2)- 10 total digits incl. after decimal values- 2.

-- increase column employee_name length to 100 size
alter table employee_sales modify employee_name varchar(100);

-- add not null constraint in department
alter table employee_sales modify department varchar(30) not null;
describe employee_sales;

-- Rename
-- rename employee_name to ename
alter table employee_sales rename column employee_name to ename;

-- rename sale_date to transaction_date
alter table employee_sales rename column sale_date to transaction_date;


-- Update
-- Update the total sales to 45,000 for the record with sale_id = 3
update employee_sales
set sale_amount = 45000
where sale_id = 3;

select * from employee_sales;

-- Update the region to Bangalore for ename Rohan.
update employee_sales
set region = "Bangalore"
where employee_name = "Rohan";

-- Update both sale_amount and region for the record with sale_id = 3
update employee_sales
set sale_amount = 50000, region = "Jaipur"
where sale_id = 3;

-- Increase the sale amount by 2,000 for all Electronics sales in Delhi.
update employee_sales
set sale_amount = sale_amount+2000
where department = "Electronics" and region = "Delhi";

-- Update the region to Pune for all employees whose name starts with ‘A’.
update employee_sales
set region = "Pune"
where employee_name like "A%";


-- Delete
-- Delete the record with sale_id = 4
delete
from employee_sales
where sale_id = 4;

-- Delete all sales from the Stationery department
delete
from employee_sales
where department = "Stationery";

-- Delete all sales from Pune where sale amount is less than 5,000.
delete
from employee_sales
where region = "Pune" and sale_amount < 5000;

-- Delete all records where employee name starts with ‘Test’.
delete
from employee_sales
where employee_name like "Test%";

-- Delete all records from the table.
delete
from employee_sales;

select * from employee_sales;
drop table employee_sales;

-- Drop column
-- drop column remarks
alter table employee_sales
drop column product;


-- truncate vs drop vs delete
truncate table employee_sales;      -- deletes entire schema of table and REFRESH index but delete command does not refresh index of table so that next insert of values starts with next indexing numbers.
                                    -- drop deletes entire table