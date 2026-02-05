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

-- ============================================
-- Reservations overview (customer + assigned tables)
--
-- Purpose:
--   Returns one row per reservation, including:
--   - reservation time window (start_at, end_at)
--   - customer identity (name, phone)
--   - party size and status
--   - all assigned physical tables (combined if needed)
--
-- Notes:
--   - Uses LEFT JOIN to include reservations without tables assigned yet
--   - Aggregates multiple tables into a single comma-separated field
--   - Intended as a canonical "read model" query for UI / CLI display
--
-- ============================================

SELECT
  r.reservation_id,
  r.start_at,
  r.end_at,
  c.full_name,
  c.phone,
  r.party_size,
  r.status,
  COALESCE(string_agg(t.table_code, ', ' ORDER BY t.table_code), '-') AS tables
FROM reservations r
JOIN customers c ON c.customer_id = r.customer_id
LEFT JOIN reservation_tables rt ON rt.reservation_id = r.reservation_id
LEFT JOIN tables t ON t.table_id = rt.table_id
GROUP BY
  r.reservation_id, r.start_at, r.end_at,
  c.full_name, c.phone,
  r.party_size, r.status
ORDER BY r.start_at;

-- ============================================
-- Variant A: Operational schedule (exclude CANCELLED)
-- ============================================
SELECT
  r.reservation_id,
  r.start_at,
  r.end_at,
  c.full_name,
  c.phone,
  r.party_size,
  r.status,
  COALESCE(string_agg(t.table_code, ', ' ORDER BY t.table_code), '-') AS tables
FROM reservations r
JOIN customers c ON c.customer_id = r.customer_id
LEFT JOIN reservation_tables rt ON rt.reservation_id = r.reservation_id
LEFT JOIN tables t ON t.table_id = rt.table_id
WHERE r.status <> 'CANCELLED'
GROUP BY
  r.reservation_id, r.start_at, r.end_at,
  c.full_name, c.phone,
  r.party_size, r.status
ORDER BY r.start_at;


-- ============================================
-- Variant B: Add allocated_capacity (sum of assigned table capacities)
-- - Useful to compare allocation vs party_size
-- - Uses COALESCE so reservations without assigned tables show 0
-- ============================================
SELECT
  r.reservation_id,
  r.start_at,
  r.end_at,
  c.full_name,
  c.phone,
  r.party_size,
  r.status,
  COALESCE(string_agg(t.table_code, ', ' ORDER BY t.table_code), '-') AS tables,
  COALESCE(SUM(t.capacity), 0) AS allocated_capacity
FROM reservations r
JOIN customers c ON c.customer_id = r.customer_id
LEFT JOIN reservation_tables rt ON rt.reservation_id = r.reservation_id
LEFT JOIN tables t ON t.table_id = rt.table_id
GROUP BY
  r.reservation_id, r.start_at, r.end_at,
  c.full_name, c.phone,
  r.party_size, r.status
ORDER BY r.start_at;

