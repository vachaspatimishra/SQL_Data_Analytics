create schema groupby;    -- create database or schema are same in mysql.
use groupby;

CREATE TABLE sales (
    order_id INT,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    amount INT
);
INSERT INTO sales VALUES
(1, 'Rahul', 'Mumbai', 500),
(2, 'Rahul', 'Mumbai', 300),
(3, 'Anita', 'Pune', 700),
(4, 'Anita', 'Pune', 200),
(5, 'Amit', 'Delhi', 400),
(6, 'Meena', 'Delhi', 600),
(7, 'Meena', 'Delhi', 100);


-- Aggregate Functions
-- How many total orders are there?
select count(order_id) as total_orders from sales;

-- What is the total sales amount?
select sum(amount) as total_amount from sales;

-- What is the average order amount?
select avg(amount) as avg_amount from sales;

-- What is the highest and lowest order amount?
select min(amount) as lowest_amount, max(amount) as highest_amount from sales;

select *from sales;


-- Groupby
-- Total amount spent by each customer
select customer_name, sum(amount) as total_amount from sales
group by customer_name;

-- Number of orders placed by each customer
select customer_name, count(amount) as total_orders
from sales
group by customer_name;

-- Average order amount per city
select city, avg(amount) as avg_amount
from sales
group by city;

-- Maximum order amount per city
select city, max(amount)
from sales
group by city;


-- Groupby + Having  (where and having command are same but where command does NOT work with group by, so we use having command)
-- Customers whose total spending is more than 700
select customer_name, sum(amount) as total_spending
from sales
group by customer_name
having sum(amount)>700;

-- Cities where total sales are more than 1,000
select city, sum(amount) as total_sales
from sales
group by city
having sum(amount)>1000;

-- Customers who placed more than 1 order
select customer_name, count(order_id) as total_orders
from sales
group by customer_name
having count(order_id)>1;

-- Cities with average order value greater than 400
select city, avg(amount) as avg_sales
from sales
group by city
having avg(amount)>400;



