-- 03_queries/basic_selects.sql
-- ============================================
-- Basic SELECT queries (read-only)
-- ============================================

-- List customers
SELECT customer_id, full_name
FROM customers
ORDER BY customer_id;

-- (Note) Sequence behavior is demonstrated in 04_transactions/sequences.sql
