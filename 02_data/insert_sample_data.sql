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
