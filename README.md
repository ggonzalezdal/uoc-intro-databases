# UOC – Introduction to Databases (Preparation Workspace)

This repository is a personal preparation workspace for the course
**Introduction to Databases** (BSc in Techniques for Software Application Development – UOC).

The goal is to practice and understand:
- Relational schema design
- SQL data definition and manipulation
- JOIN queries and relational thinking
- Transaction management (COMMIT / ROLLBACK)
- Database internal behavior (sequences, autocommit)
- ACID properties and concurrency (blocking/locking)

## Folder structure

### 01_schema/
Contains Data Definition Language (DDL) scripts.
- Table creation
- Primary keys, foreign keys, and constraints

### 02_data/
Contains sample data insertion scripts.
- INSERT statements for testing queries and transactions

### 03_queries/
Contains read-only queries.
- SELECT statements
- JOINs
- Queries useful for revision and exams

### 04_transactions/
Contains scripts related to database behavior.
- Manual transactions
- COMMIT vs ROLLBACK
- Sequence behavior
- Autocommit demonstrations
- Concurrency behavior (blocking/locks)

## How to run (psql)

1) Connect to the database:
- \c uoc_databases

2) Create/reset schema:
- \i 'C:/Users/Usuario/dev/uoc_databases/01_schema/create_tables.sql'

3) Insert sample data:
- \i 'C:/Users/Usuario/dev/uoc_databases/02_data/insert_sample_data.sql'

4) Run queries:
- \i 'C:/Users/Usuario/dev/uoc_databases/03_queries/joins.sql'
- \i 'C:/Users/Usuario/dev/uoc_databases/03_queries/basic_selects.sql'

5) Run transaction demos:
- \i 'C:/Users/Usuario/dev/uoc_databases/04_transactions/commit_rollback.sql'
- \i 'C:/Users/Usuario/dev/uoc_databases/04_transactions/sequences.sql'

Windows tip: in psql, prefer forward slashes (/) in file paths.

## Checking database state (psql)

- List tables:
  - \dt

- Describe table structure (columns, constraints):
  - \d customers
  - \d reservations

- Quick metadata checks (SQL):
  - SELECT current_database();
  - SELECT current_user;

- Quick data checks (SQL):
  - SELECT customer_id, full_name FROM customers ORDER BY customer_id;
  - SELECT reservation_id, customer_id, start_at, party_size, status FROM reservations ORDER BY reservation_id;

## ACID and Transaction Management (Key Concepts)

During this preparation, several transaction scenarios were tested to understand why databases use transactions and what guarantees they provide.

### Atomicity
A transaction is executed as an all-or-nothing unit.
If any statement fails, the entire transaction is aborted and all previous changes are rolled back.

Observed when:
- Multiple UPDATE statements were executed inside a transaction
- One statement failed (e.g., wrong quoting or constraint violation)
- PostgreSQL marked the transaction as aborted and required a ROLLBACK

### Consistency
Transactions preserve database integrity constraints.
After a transaction completes, the database remains in a valid state.

Examples in this repo:
- NOT NULL constraints prevent invalid updates
- CHECK constraints avoid invalid values
- Foreign keys enforce referential integrity

### Isolation
Concurrent transactions are isolated from each other.
Changes made by one transaction are not visible to others until committed.
When two sessions update the same row, one of them will block until the other COMMITs or ROLLBACKs.

Observed when:
- Session A updated a row (locking it)
- Session B tried to update the same row and was blocked
- Session B continued only after Session A finished its transaction

### Durability
Once a transaction is committed, its changes persist permanently.
Committed data should remain available even after system failures or restarts.

### Conclusion
Transactions are necessary not only for concurrent access, but also to prevent partial updates and guarantee data consistency.
The ACID properties explain why transactions are a fundamental mechanism in relational database systems.

## Notes

- SQL scripts are written to be executed either in `psql` or DBeaver.
- DBeaver typically uses auto-commit by default; psql is more manual/transaction-friendly for learning.
- This workspace is intentionally simple and framework-free.
