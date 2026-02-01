-- 03_queries/joins.sql
-- ============================================
-- JOIN: reservations with customers
-- Purpose: show reservation details with customer names
-- ============================================

SELECT
  r.reservation_id,
  c.full_name,
  r.start_at,
  r.party_size,
  r.status
FROM reservations r
JOIN customers c
  ON c.customer_id = r.customer_id
ORDER BY r.start_at;
