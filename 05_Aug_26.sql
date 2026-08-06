create database payments_db;
use payments_db;

create table payment (
order_id int primary key,
payment_date date,
amount_paid decimal(10,2),
method varchar(20)
);

insert into payment (order_id, payment_date, amount_paid, method)
values
(1001, '2025-01-05', 1200.00, 'UPI'),
(1002, '2025-01-06', 2500.00, 'Credit Card'),
(1003, '2025-01-07', 1800.00, 'Net Banking'),
(1004, '2025-01-08', 3200.00, 'UPI'),
(1005, '2025-01-09', 1500.00, 'Debit Card'),
(1006, '2025-01-10', 4500.00, 'Credit Card'),
(1007, '2025-01-11', 2200.00, 'Cash'),
(1008, '2025-01-12', 2800.00, 'UPI'),
(1009, '2025-01-13', 3900.00, 'Net Banking'),
(1010, '2025-01-14', 5100.00, 'Credit Card'),
(1011, '2025-01-15', 1700.00, 'Cash'),
(1012, '2025-01-16', 4200.00, 'Debit Card'),
(1013, '2025-01-17', 2400.00, 'UPI'),
(1014, '2025-01-18', 3100.00, 'Credit Card'),
(1015, '2025-01-19', 2700.00, 'Net Banking'),
(1016, '2025-01-20', 4800.00, 'UPI'),
(1017, '2025-01-21', 2100.00, 'Debit Card'),
(1018, '2025-01-22', 3600.00, 'Cash'),
(1019, '2025-01-23', 5200.00, 'Credit Card'),
(1020, '2025-01-24', 3400.00, 'Net Banking');



-- Questions
-- 1. Select the database and display all records from the payment table.
use payments_db;
select * from payment;

-- 2. Find the second-highest payment amount for each payment method.
select method, amount_paid
from (
select method, amount_paid,
dense_rank() over (partition by method order by amount_paid desc) as rnk
from payment
) t
where rnk = 2;

-- 3. Create a new column and increase the amount paid by ₹100 for all UPI payments.
select *,
case
when method = "UPI" then amount_paid + 100
else amount_paid
end as updated_amount
from payment;


-- 4. Find the total amount paid for each payment method.
select method, sum(amount_paid) as total_amount
from payment
group by method
order by total_amount desc;

-- 5. Find the average payment amount for each payment method.
select method, avg(amount_paid) as avg_amount
from payment
group by method;

-- 6. Find the highest payment made by each payment method.
select method, max(amount_paid) as highest_amount
from payment
group by method;

-- 7. Find the lowest payment made by each payment method.
select method, min(amount_paid) as lowest_amount
from payment
group by method;

-- 8. Find the total number of payments for each payment method.
select method, count(amount_paid) as total_payments
from payment
group by method;

-- 9. Display only those payment methods where the total payment amount is greater than ₹10,000.
select method, sum(amount_paid) as total_amount
from payment
group by method
having total_amount > 10000;

-- 10. Find the payment methods whose average payment is greater than ₹3000.
select method, avg(amount_paid) as avg_amount
from payment
group by method
having avg_amount > 3000;

-- 11. Display the payment records in descending order of amount within each payment method.
select * from payment
order by method, amount_paid desc;


-- Window function questions

-- 12. Assign a rank to each payment based on the payment amount (highest first).
select *, dense_rank() over (order by amount_paid desc) as rnk
from payment;

-- 13. Assign row numbers within each payment method.
select *, row_number() over (partition by method) as row_numbers
from payment;

-- 14. Find the highest payment for every payment method using ROW_NUMBER().
select method, amount_paid from
(
select method, amount_paid, row_number() over (partition by method order by amount_paid desc) as rnk
from payment
) t
where rnk = 1;

-- 15. Find the third-highest payment amount for each payment method.
select method, amount_paid, rnk from
(
select method, amount_paid, dense_rank() over (partition by method order by amount_paid desc) as rnk
from payment
) t
where rnk = 3;

-- 16. Display the cumulative payment amount ordered by payment date.
select order_id, payment_date, amount_paid, sum(amount_paid) over (order by payment_date, order_id) as cumulative_amount
from payment
order by payment_date, order_id;



-- Advanced questions ************************************************************************************************************************************

-- 17. Find payment methods whose total payment amount is above the overall average total payment across all methods.
select method, sum(amount_paid) as total_payment from payment
group by method 
having sum(amount_paid) > (
select avg(total_payment) from (
select sum(amount_paid) as total_payment
from payment 
group by method
) as t
);

-- 18. Display payments that are above the overall average payment amount.
select amount_paid from payment
where amount_paid > (
select avg(amount_paid) from payment
);

-- 19. Find the percentage contribution of each payment method to the total payment amount.
select method, sum(amount_paid) as total_payment, round(
(sum(amount_paid) * 100) / 
(select sum(amount_paid) from payment), 1) as percentage_contribution
from payment 
group by method
order by percentage_contribution desc;

-- 20. Categorize payments using a CASE statement:
-- Less than ₹2000 → Low
-- ₹2000–₹4000 → Medium
-- Greater than ₹4000 → High

select amount_paid, 
case
when amount_paid < 2000 then "Low"
when amount_paid between 2000 and 4000 then "Medium"
else "High"
end as Category
from payment;

-- 21. Find the number of days between the first and last payment date.
select datediff(max(payment_date), min(payment_date)) as days_difference
from payment;



-- Bonus Interview questions *************************************************************************************************************

-- 1. Find duplicate payment amounts (if any).
select distinct p1.amount_paid                 -- self join
from payment p1
join payment p2
on p1.amount_paid = p2.amount_paid
and p1.order_id <> p2.order_id;


select amount_paid, count(*) as frequency       -- group by
from payment
group by amount_paid
having count(*) > 1;

-- 2. Display the payment made immediately after 2025-01-15.
select * from payment 
where payment_date > "2025-01-15"
order by payment_date asc
limit 1;

-- find the next payment date only --
select min(payment_date) from payment 
where payment_date > "2025-01-15";

-- 3. Find the latest payment made using each payment method.
select method, max(payment_date)         -- only payment date
from payment
group by method;


select * from (
select *, row_number() over (partition by method order by payment_date desc) as rnk
from payment ) t
where rnk = 1;

-- Other Methods > CTE + Window function | CTE + Join

with latest_payments as (
select method, max(payment_date) as latest_date
from payment group by method
)

select * from latest_payments;

-- 4. Find the payment amount closest to ₹3000.
select amount_paid
from payment
order by abs(amount_paid - 3000)
limit 1;

-- 5. Find the difference between each payment amount and the average payment amount.
select *, amount_paid - (
select avg(amount_paid) from payment ) as difference
from payment;

-- Method 2
select *, amount_paid - avg(amount_paid) over() as difference
from payment;


-- 6. Show the running total of payments ordered by date.
select *, sum(amount_paid) over(order by payment_date asc) as running_total
from payment;

-- 7. Display only the top 2 highest payments for each payment method.
-- Method 1 (Sub-Query)
select * from
(
select *, dense_rank() over(partition by method order by amount_paid desc) as rnk
from payment
) t
where rnk <= 2;

-- Method 2 (CTE)
with highest_payments as (
select *, dense_rank() over(partition by method order by amount_paid desc) as rnk
from payment
)

select * from highest_payments
where rnk <= 2;

-- 8. Find the payment method that generated the highest total revenue.
select method, sum(amount_paid) as total_amount
from payment
group by method
order by sum(amount_paid) desc
limit 1;

-- 9. Find the payment method having the maximum number of transactions.
select  method, count(*) as total_transactions
from payment
group by method
order by count(amount_paid) desc
limit 1;

-- 10. Create a report showing:
-- | Method | Transactions | Total Amount | Average Amount | Highest | Lowest |
-- using a single query.

select method, 
count(*) as transactions, 
sum(amount_paid) as total_amount, 
avg(amount_paid) as avg_amount, 
max(amount_paid) as highest,
min(amount_paid) as lowest

from payment 
group by method
order by transactions desc;
