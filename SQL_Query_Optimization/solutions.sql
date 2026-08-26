-- =========================================================
-- SQL Query Optimization: Inefficient vs Optimized
-- Run against ecommerce_practice (see dataset.sql)
-- =========================================================

USE ecommerce_practice;

-- =========================================================
-- 1. Avoid SELECT * and unnecessary columns
-- =========================================================
-- Inefficient: pulls every column even though only a few are needed
SELECT * FROM orders WHERE customer_id = 5;

-- Optimized: only the columns actually used downstream
SELECT order_id, order_date, total_amount
FROM orders
WHERE customer_id = 5;


-- =========================================================
-- 2. Filter early, before aggregation
-- =========================================================
-- Inefficient: aggregates every order for every customer, then filters
-- customers down to one region using a subquery in HAVING/WHERE
SELECT o.customer_id, SUM(o.total_amount) AS total_spent
FROM orders o
WHERE o.customer_id IN (SELECT customer_id FROM customers WHERE region = 'North')
GROUP BY o.customer_id
HAVING SUM(o.total_amount) > 1000;

-- Optimized: narrow the customer set first via a CTE/join, so GROUP BY
-- only ever touches orders belonging to North region customers
WITH north_customers AS (
    SELECT customer_id FROM customers WHERE region = 'North'
)
SELECT o.customer_id, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN north_customers nc ON o.customer_id = nc.customer_id
GROUP BY o.customer_id
HAVING SUM(o.total_amount) > 1000;


-- =========================================================
-- 3. Avoid functions on indexed filter columns
-- =========================================================
-- Inefficient: wrapping session_date in YEAR() prevents the optimizer from
-- doing a range scan on idx_sessions_session_date
SELECT session_id, customer_id, session_date
FROM sessions
WHERE YEAR(session_date) = 2026;

-- Optimized: rewrite as a sargable range so the index can be used
SELECT session_id, customer_id, session_date
FROM sessions
WHERE session_date >= '2026-01-01' AND session_date < '2027-01-01';

-- ALTERNATIVE: filter by YEAR(session_date) constantly,
-- functional indexes:
-- CREATE INDEX idx_sessions_year ON sessions ((YEAR(session_date)));
-- But the range rewrite above is the better default -- it needs no
-- special index and works with the existing idx_sessions_session_date.


-- =========================================================
-- 4. Replace correlated subqueries with window functions
-- =========================================================
-- Inefficient: this subquery re-runs once per row of the outer query
SELECT customer_id, order_id, total_amount
FROM orders o
WHERE total_amount = (
    SELECT MAX(total_amount) FROM orders o2 WHERE o2.customer_id = o.customer_id
);

-- Optimized: compute the ranking in a single pass with a window function
SELECT customer_id, order_id, total_amount
FROM (
    SELECT customer_id, order_id, total_amount,
           RANK() OVER (PARTITION BY customer_id ORDER BY total_amount DESC) AS rnk
    FROM orders
) ranked
WHERE rnk = 1;
-- Why: RANK() keeps every tied row at rank 1, so this returns the
-- exact same rows as the correlated subquery (the dataset includes
-- 10 customers with a deliberate tie at their max order amount --
-- try both versions and confirm the row counts match).
-- If you only want ONE row per customer even when there's a tie,
-- swap RANK() for ROW_NUMBER().


-- =========================================================
-- 5. Understand how MySQL handles CTEs
-- =========================================================
-- A CTE referenced ONCE is merged into the outer query like a view:
WITH customer_totals AS (
    SELECT customer_id, SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT ct.customer_id, ct.total_spent, c.name
FROM customer_totals ct
JOIN customers c ON ct.customer_id = c.customer_id
WHERE ct.total_spent > 500;

-- A CTE referenced MORE THAN ONCE gets materialized automatically
-- as an internal temp table
WITH customer_totals AS (
    SELECT customer_id, SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT
    (SELECT AVG(total_spent) FROM customer_totals) AS avg_spent,
    ct.customer_id,
    ct.total_spent
FROM customer_totals ct
WHERE ct.total_spent > (SELECT AVG(total_spent) FROM customer_totals);
-- Run EXPLAIN ANALYZE on this one and confirm a temp table appears
-- for customer_totals since it's referenced three times.


-- =========================================================
-- 6. Optimize window functions with proper partitioning
-- =========================================================
-- Inefficient: missing PARTITION BY treats the whole table as one window,
-- so the running total bleeds across different customers
SELECT customer_id, order_date, total_amount,
       SUM(total_amount) OVER (ORDER BY order_date) AS running_total
FROM orders;

-- Optimized: partition by customer so each customer gets their own
-- independent running total
SELECT customer_id, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM orders;
-- Why: PARTITION BY resets the window per group. Without it, every
-- row's running total includes every other customer's orders too --
-- correct syntax, wrong answer.


-- =========================================================
-- 7. EXISTS vs IN
-- =========================================================
-- These two should produce very similar (often identical) plans on
-- Run EXPLAIN ANALYZE on both against this dataset.

-- Version A: EXISTS
SELECT c.customer_id, c.name
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- Version B: IN
SELECT customer_id, name
FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);
-- Why check both: on a well-indexed subquery (idx_orders_customer_id
-- exists here) EXISTS becomes the clearer winner mainly when the subquery
-- has no supporting index or returns a very large unfiltered result set.


-- =========================================================
-- 8. UNION ALL instead of UNION when you don't need dedup
-- =========================================================
-- Inefficient: UNION forces a sort + dedup pass across 2025 and 2026 orders
-- even though duplicate customer_ids across years are expected and fine
SELECT customer_id FROM orders WHERE order_date < '2026-01-01'
UNION
SELECT customer_id FROM orders WHERE order_date >= '2026-01-01';

-- Optimized: skip the dedup step if duplicates are acceptable
SELECT customer_id FROM orders WHERE order_date < '2026-01-01'
UNION ALL
SELECT customer_id FROM orders WHERE order_date >= '2026-01-01';
-- Why: UNION ALL just concatenates result sets. UNION additionally
-- sorts and removes duplicates, which is wasted work if you didn't
-- need deduplication in the first place.


-- =========================================================
-- 9. Match join column types
-- =========================================================
-- Both sides of this join are INT (customer_id in both orders and
-- customers), so the index on orders.customer_id is usable as-is:
SELECT o.order_id, c.name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Check column types before joining on unfamiliar tables:
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'ecommerce_practice'
  AND TABLE_NAME IN ('orders', 'customers')
  AND COLUMN_NAME = 'customer_id';
-- Why this matters: if one side were INT and the other VARCHAR,
-- MySQL would implicitly cast one side on every comparison, which
-- silently prevents the index on that column from being used.


-- =========================================================
-- 10. Read execution plans
-- =========================================================
-- Full timing + actual row counts
EXPLAIN ANALYZE
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > 1000;

-- Planned execution path without running the query
EXPLAIN FORMAT=TREE
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > 1000;
-- What to look for: full table scans on orders (should be using
-- idx_orders_customer_id or a covering index), and large gaps
-- between estimated and actual row counts, which usually means
-- stale statistics (fix with ANALYZE TABLE orders;).


-- =========================================================
-- 11. Keyset pagination instead of OFFSET
-- =========================================================
-- Inefficient: MySQL has to scan and discard the first 100 rows before
-- returning the next 20 -- gets worse as the offset grows
SELECT event_id, customer_id, event_time, event_type
FROM events
ORDER BY event_time
LIMIT 20 OFFSET 100;

-- Optimized: keyset pagination -- jump straight to where you left off
-- using the last seen event_time from the previous page
SELECT event_id, customer_id, event_time, event_type
FROM events
WHERE event_time > '2026-08-15 00:00:00'
ORDER BY event_time
LIMIT 20;
-- Why: OFFSET cost grows linearly with the offset value because
-- MySQL still has to read and count every skipped row. Keyset
-- pagination uses the index on event_time to seek directly to the
-- right spot regardless of how deep into the table you are.


-- =========================================================
-- 12. Aggregate before joining
-- =========================================================
-- Inefficient: joins first, so customers with many orders get duplicated
-- many times before any aggregation happens
SELECT c.customer_id, c.name, o.total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

-- Optimized: aggregate orders down to one row per customer first,
-- then join once against a much smaller result set
WITH order_totals AS (
    SELECT customer_id, SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT c.customer_id, c.name, ot.total_spent
FROM customers c
JOIN order_totals ot ON c.customer_id = ot.customer_id;
-- Why: aggregating first means the join only ever combines
-- 200 customer rows with 200 (or fewer) summarized order rows,
-- instead of 200 customers against 620 raw order rows.


SHOW TABLE STATUS
WHERE Name IN ('customers', 'orders', 'sessions', 'events');
