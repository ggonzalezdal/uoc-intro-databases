-- 01_schema/create_tables.sql
-- ============================================
-- UOC – Introduction to Databases
-- Schema definition (DDL)
-- ============================================

-- Drop tables if they exist (safe reset)
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS customers;

-- Customers table
CREATE TABLE customers (
  customer_id BIGSERIAL PRIMARY KEY,
  full_name   VARCHAR(100) NOT NULL,
  email       VARCHAR(255) UNIQUE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Reservations table
CREATE TABLE reservations (
  reservation_id BIGSERIAL PRIMARY KEY,
  customer_id    BIGINT NOT NULL,
  start_at       TIMESTAMPTZ NOT NULL,
  party_size     INT NOT NULL CHECK (party_size > 0),
  status         VARCHAR(20) NOT NULL DEFAULT 'PENDING',

  CONSTRAINT fk_reservation_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id)
);
