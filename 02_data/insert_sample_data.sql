-- 02_data/insert_sample_data.sql
-- ============================================
-- Sample data for development
-- Must be run AFTER 01_schema/create_tables.sql
-- ============================================

-- ============================================
-- 1) Physical restaurant tables (configuration)
-- ============================================
INSERT INTO tables (table_code, capacity, active)
VALUES
  ('T1', 2, true),
  ('T2', 2, true),
  ('T3', 2, true),
  ('T4', 4, true),
  ('T5', 4, true),
  ('T6', 6, true),
  ('T7', 6, true),
  ('T8', 8, true)
ON CONFLICT (table_code) DO UPDATE
SET capacity = EXCLUDED.capacity,
    active   = EXCLUDED.active;

-- Quick check
SELECT table_id, table_code, capacity, active
FROM tables
ORDER BY table_code;

-- ============================================
-- 2) Customers
-- ============================================
INSERT INTO customers (full_name, phone, email)
VALUES
  ('Alice Smith', '+34 600 000 001', 'alice@example.com'),
  ('Bob Martin',  '+34 600 000 002', 'bob@example.com'),
  ('Carla Nunez', '+34 600 000 003', 'carla@example.com'),
  ('Dani Gomez',  '+34 600 000 004', 'dani@example.com')
ON CONFLICT (phone) DO NOTHING;

-- Quick check
SELECT customer_id, full_name, phone, email
FROM customers
ORDER BY customer_id;

-- ============================================
-- 3) Reservations
-- ============================================
INSERT INTO reservations (customer_id, start_at, end_at, party_size, status, notes)
VALUES
  (
    (SELECT customer_id FROM customers WHERE phone = '+34 600 000 001'),
    '2026-02-20 20:00+01',
    '2026-02-20 22:00+01',
    2,
    'CONFIRMED',
    'Window seat if possible'
  ),
  (
    (SELECT customer_id FROM customers WHERE phone = '+34 600 000 002'),
    '2026-02-20 21:00+01',
    '2026-02-20 23:00+01',
    4,
    'CONFIRMED',
    'Birthday'
  ),
  (
    (SELECT customer_id FROM customers WHERE phone = '+34 600 000 004'),
    '2026-02-21 14:00+01',
    '2026-02-21 16:00+01',
    6,
    'PENDING',
    NULL
  );

-- Quick check
SELECT reservation_id, customer_id, start_at, end_at, party_size, status, notes, created_at
FROM reservations
ORDER BY start_at;

-- ============================================
-- 4) Reservation ↔ tables assignments
-- ============================================
INSERT INTO reservation_tables (reservation_id, table_id)
VALUES
  -- Alice (2p) -> T1
  (
    (SELECT r.reservation_id
     FROM reservations r
     JOIN customers c ON c.customer_id = r.customer_id
     WHERE c.phone = '+34 600 000 001'
       AND r.start_at = '2026-02-20 20:00+01'::timestamptz),
    (SELECT table_id FROM tables WHERE table_code = 'T1')
  ),

  -- Bob (4p) -> T4
  (
    (SELECT r.reservation_id
     FROM reservations r
     JOIN customers c ON c.customer_id = r.customer_id
     WHERE c.phone = '+34 600 000 002'
       AND r.start_at = '2026-02-20 21:00+01'::timestamptz),
    (SELECT table_id FROM tables WHERE table_code = 'T4')
  ),

  -- Dani (6p) -> T6 + T2 (combined)
  (
    (SELECT r.reservation_id
     FROM reservations r
     JOIN customers c ON c.customer_id = r.customer_id
     WHERE c.phone = '+34 600 000 004'
       AND r.start_at = '2026-02-21 14:00+01'::timestamptz),
    (SELECT table_id FROM tables WHERE table_code = 'T6')
  ),
  (
    (SELECT r.reservation_id
     FROM reservations r
     JOIN customers c ON c.customer_id = r.customer_id
     WHERE c.phone = '+34 600 000 004'
       AND r.start_at = '2026-02-21 14:00+01'::timestamptz),
    (SELECT table_id FROM tables WHERE table_code = 'T2')
  )
ON CONFLICT DO NOTHING;

-- Quick check
SELECT *
FROM reservation_tables
ORDER BY reservation_id, table_id;
