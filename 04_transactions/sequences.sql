-- 04_transactions/sequences.sql
-- ============================================
-- Sequence behavior demonstration
-- ============================================

-- Sequences (e.g., BIGSERIAL) are not rolled back.
-- If a transaction consumes a sequence value and then ROLLBACKs,
-- the ID gap remains.

-- Show the next value from the customers PK sequence
SELECT nextval('customers_customer_id_seq');

-- (Optional) Show the current sequence value in this session (if set)
-- SELECT currval('customers_customer_id_seq');
