-- 01_schema/create_tables.sql
-- ============================================
-- UOC – Introduction to Databases
-- Schema definition (DDL)
-- Drop-in replacement (backbone refactor)
-- ============================================

-- Drop tables (safe reset) — drop children first
DROP TABLE IF EXISTS reservation_tables;
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS tables;
DROP TABLE IF EXISTS customers;

-- ============================================
-- Customers
-- ============================================
CREATE TABLE customers (
  customer_id BIGSERIAL PRIMARY KEY,
  full_name   VARCHAR(100) NOT NULL,
  phone       VARCHAR(30)  NOT NULL UNIQUE,
  email       VARCHAR(255) UNIQUE,
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- ============================================
-- Physical restaurant tables (configuration)
-- ============================================
CREATE TABLE tables (
  table_id    BIGSERIAL PRIMARY KEY,
  table_code  VARCHAR(10) NOT NULL UNIQUE,   -- e.g. T1, T2, TERR1
  capacity    INT         NOT NULL CHECK (capacity > 0),
  active      BOOLEAN     NOT NULL DEFAULT true
);

-- ============================================
-- Reservations
-- ============================================
CREATE TABLE reservations (
  reservation_id BIGSERIAL PRIMARY KEY,
  customer_id    BIGINT       NOT NULL,
  start_at       TIMESTAMPTZ  NOT NULL,
  end_at         TIMESTAMPTZ,
  party_size     INT          NOT NULL CHECK (party_size > 0),
  status         VARCHAR(20)  NOT NULL DEFAULT 'PENDING',
  notes          TEXT,
  created_at     TIMESTAMPTZ  NOT NULL DEFAULT now(),

  CONSTRAINT fk_reservation_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id),

  CONSTRAINT chk_reservation_status
    CHECK (status IN ('PENDING', 'CONFIRMED', 'CANCELLED', 'NO_SHOW')),

  CONSTRAINT chk_reservation_time_window
    CHECK (end_at IS NULL OR end_at > start_at)
);

-- ============================================
-- Reservation ↔ Tables (many-to-many)
-- One reservation can use multiple tables.
-- One table can be used by many reservations (at different times).
-- ============================================
CREATE TABLE reservation_tables (
  reservation_id BIGINT NOT NULL,
  table_id       BIGINT NOT NULL,

  CONSTRAINT pk_reservation_tables
    PRIMARY KEY (reservation_id, table_id),

  CONSTRAINT fk_rt_reservation
    FOREIGN KEY (reservation_id)
    REFERENCES reservations (reservation_id)
    ON DELETE CASCADE,

  CONSTRAINT fk_rt_table
    FOREIGN KEY (table_id)
    REFERENCES tables (table_id)
);

