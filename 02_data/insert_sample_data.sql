-- 02_data/insert_sample_data.sql
-- ============================================
-- Sample data
-- ============================================

INSERT INTO customers (full_name, email)
VALUES
  ('Alice Smith', 'alice@example.com'),
  ('Bob Johnson', 'bob@example.com');

INSERT INTO reservations (customer_id, start_at, party_size)
VALUES
  (1, '2026-02-20 20:00+01', 2),
  (2, '2026-02-20 21:00+01', 4);

-- 02_data/insert_sample_data.sql
-- Insert physical restaurant tables (configuration)

INSERT INTO tables (table_code, capacity, active)
VALUES
  ('T1', 2, true),
  ('T2', 2, true),
  ('T3', 2, true),
  ('T4', 4, true),
  ('T5', 4, true),
  ('T6', 4, true),
  ('T7', 6, true),
  ('T8', 8, true);

-- Quick check
SELECT table_id, table_code, capacity, active
FROM tables
ORDER BY table_code;
