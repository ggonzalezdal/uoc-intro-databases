# uoc-reservations-db

Educational PostgreSQL database repository for the **UOC – Introduction to Databases** learning path.

This repo contains the **canonical schema (DDL)**, **sample seed data**, and a small set of **canonical JOIN queries** for a restaurant reservations domain.

The goal is to build a clean, realistic “backbone” database that a Java JDBC application can use and evolve step by step.

---

## What this repository includes

### Schema (DDL)
Location: `01_schema/create_tables.sql`

Tables:

- `customers`
  - `customer_id` (PK)
  - `full_name` (required)
  - `phone` (required, unique)
  - `email` (optional, unique)
  - `created_at` (default now)

- `tables` (physical restaurant tables / configuration)
  - `table_id` (PK)
  - `table_code` (required, unique) — e.g. `T1`, `T2`, `TERR1`
  - `capacity` (required, > 0)
  - `active` (default true)

- `reservations`
  - `reservation_id` (PK)
  - `customer_id` (FK → `customers.customer_id`)
  - `start_at` (required)
  - `end_at` (optional; if present must be > `start_at`)
  - `party_size` (required, > 0)
  - `status` (default `PENDING`, constrained to allowed values)
  - `notes` (optional)
  - `created_at` (default now)

- `reservation_tables` (junction table; many-to-many)
  - `(reservation_id, table_id)` composite PK
  - `reservation_id` (FK → `reservations.reservation_id`, `ON DELETE CASCADE`)
  - `table_id` (FK → `tables.table_id`)

---

## Relationship overview

- One `customer` can have many `reservations`
- One `reservation` belongs to exactly one `customer`
- One `reservation` can be assigned to many physical `tables`
- One physical `table` can be assigned to many `reservations` (at different times)

`reservation_tables` exists to support:
- combined tables (e.g. large parties)
- flexible allocation decisions
- future availability logic

---

## Seed data (development)

Location: `02_data/insert_sample_data.sql`

The seed is designed to be:
- easy to read
- safe to rerun (idempotent patterns for config + assignments)
- aligned with the schema constraints (phone required, status constrained, etc.)

Typical seed flow (in order):
1. insert physical restaurant tables (`tables`)
2. insert customers (`customers`)
3. insert reservations (`reservations`)
4. assign tables to reservations (`reservation_tables`)

---

## Canonical queries

Location: `03_queries/`

This repo includes “canonical” JOIN queries that return one row per reservation, enriched with:
- customer details
- time window (start/end)
- assigned table codes (aggregated)
- optional computed fields (e.g. allocated capacity)

These queries are intended as:
- learning examples for JOINs and aggregation
- a stable “read model” foundation for a CLI, UI, or API later

---

## What is intentionally NOT implemented yet

This is a backbone repo. It focuses on structure and correctness, not “full restaurant rules”.

Examples of deferred logic (to be implemented in application/service layer later):
- preventing overlapping reservations on the same table
- capacity optimization (“best table combination”)
- availability search
- automatic table assignment
- cancellation policies and auditing beyond `created_at`

---

## How to use

### 1) Create schema
Run `01_schema/create_tables.sql` in your SQL client.

### 2) Insert sample data
Run `02_data/insert_sample_data.sql`.

### 3) Explore queries
Run the files under `03_queries/`.

---

## Notes on design choices

- `status` uses a CHECK constraint to avoid typos and invalid values.
- `end_at` is optional to keep early inserts simple; if present, it must be after `start_at`.
- The DB stores “facts” (what was assigned), while “decision rules” (how to assign) are handled later in the application.

---

## Companion project

This database repo is intended to be used by a separate Java JDBC backend project (IntelliJ/Gradle), where:
- DAOs map rows to domain models
- services orchestrate transactions
- a CLI (or later API/UI) exercises end-to-end flows
