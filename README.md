# UOC – Introduction to Databases (Preparation Workspace)

This repository is a **personal preparation workspace** for the course **Introduction to Databases**  
(BSc in Techniques for Software Application Development – UOC).

The goal of this repository is to **learn and internalize relational database concepts** through hands-on SQL practice, focusing on structure, integrity, and behavior rather than frameworks or tooling.

This is an **educational repository**, intentionally simple and incremental.

---

## Learning objectives

This workspace is used to practice and understand:

- Relational schema design
- Normalization and entity relationships
- SQL Data Definition Language (DDL)
- SQL Data Manipulation Language (DML)
- JOIN queries and relational thinking
- Transaction management (COMMIT / ROLLBACK)
- Database internal behavior (sequences, autocommit)
- ACID properties and concurrency (locking / blocking)

---

## Domain model used for practice

To make the exercises concrete and realistic, the database models a **simple restaurant reservation system**.

The domain includes:

- Customers
- Reservations (time-based)
- Physical restaurant tables (capacity, availability)
- A many-to-many relationship between reservations and tables

Business rules such as availability checks, overlapping reservations, or capacity validation are **intentionally not implemented yet**, as they are introduced progressively later in the learning process.

---

## Folder structure

### 01_schema/

Contains **schema definition scripts (DDL)**.

- Table creation
- Primary keys and foreign keys
- CHECK, NOT NULL, and UNIQUE constraints
- Physical restaurant tables configuration
- Many-to-many relationship between reservations and tables

### 02_data/

Contains **sample data insertion scripts**.

- INSERT statements for testing
- Data used to validate queries and constraints

### 03_queries/

Contains **read-only queries**.

- SELECT statements
- JOIN queries
- Queries useful for revision and exams

### 04_transactions/

Contains scripts related to **database behavior and transactions**.

- Manual transactions
- COMMIT vs ROLLBACK
- Sequence behavior
- Autocommit demonstrations
- Concurrency behavior (blocking / locks)

---

## How to run (psql)

Connect to the database:

- `\c uoc_databases`

Create or reset the schema:

- `\i 'C:/Users/Usuario/dev/uoc_databases/01_schema/create_tables.sql'`

Insert sample data:

- `\i 'C:/Users/Usuario/dev/uoc_databases/02_data/insert_sample_data.sql'`

Run queries:

- `\i 'C:/Users/Usuario/dev/uoc_databases/03_queries/basic_selects.sql'`
- `\i 'C:/Users/Usuario/dev/uoc_databases/03_queries/joins.sql'`

Run transaction demonstrations:

- `\i 'C:/Users/Usuario/dev/uoc_databases/04_transactions/commit_rollback.sql'`
- `\i 'C:/Users/Usuario/dev/uoc_databases/04_transactions/sequences.sql'`

**Windows tip:**  
In `psql`, prefer forward slashes (`/`) instead of backslashes in file paths.

---

## Checking database state (psql)

List tables:

- `\dt`

Describe table structure (columns and constraints):

- `\d customers`
- `\d reservations`
- `\d tables`
- `\d reservation_tables`

Quick metadata checks (SQL):

- `SELECT current_database();`
- `SELECT current_user;`

Quick data checks (SQL):

- `SELECT customer_id, full_name FROM customers ORDER BY customer_id;`
- `SELECT reservation_id, customer_id, start_at, party_size, status FROM reservations ORDER BY reservation_id;`

---

## ACID and transaction management (key concepts)

During this preparation, several transaction scenarios were tested to understand why databases use transactions and what guarantees they provide.

### Atomicity

A transaction is executed as an all-or-nothing unit.  
If any statement fails, the entire transaction is aborted and all previous changes are rolled back.

Observed when:

- Multiple UPDATE statements were executed inside a transaction
- One statement failed due to a constraint violation
- PostgreSQL marked the transaction as aborted and required a ROLLBACK

### Consistency

Transactions preserve database integrity constraints.  
After a transaction completes, the database remains in a valid state.

Examples in this repository:

- NOT NULL constraints prevent invalid updates
- CHECK constraints avoid invalid values
- Foreign keys enforce referential integrity

### Isolation

Concurrent transactions are isolated from each other.  
Changes made by one transaction are not visible to others until committed.

Observed when:

- Session A updated a row (locking it)
- Session B attempted to update the same row and was blocked
- Session B continued only after Session A COMMITted or ROLLBACKed

### Durability

Once a transaction is committed, its changes persist permanently.  
Committed data remains available even after system failures or restarts.

---

## Notes

- SQL scripts are written to be executed using either `psql` or DBeaver
- DBeaver typically uses auto-commit by default
- `psql` is more suitable for learning explicit transaction control
- This workspace is intentionally framework-free and focused on fundamentals
