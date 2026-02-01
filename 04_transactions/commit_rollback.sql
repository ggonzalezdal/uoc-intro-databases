-- 04_transactions/commit_rollback.sql
-- ============================================
-- Transaction demo: COMMIT vs ROLLBACK
-- ============================================

-- 1) Start a transaction
BEGIN;

-- Insert a temporary customer
INSERT INTO customers (full_name, email)
VALUES ('Charlie Temp', 'charlie.temp@example.com');

-- Check: Charlie is visible inside this transaction
SELECT customer_id, full_name, email
FROM customers
ORDER BY customer_id;

-- 2) Undo everything done since BEGIN
ROLLBACK;

-- Check: Charlie should be gone now
SELECT customer_id, full_name, email
FROM customers
ORDER BY customer_id;

-- 3) Start another transaction
BEGIN;

-- Insert a permanent customer
INSERT INTO customers (full_name, email)
VALUES ('Diana Permanent', 'diana.permanent@example.com');

-- Make it permanent
COMMIT;

-- Check: Diana should still be here
SELECT customer_id, full_name, email
FROM customers
ORDER BY customer_id;
