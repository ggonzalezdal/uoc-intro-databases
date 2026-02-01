# UOC – Introduction to Databases (Preparation Workspace)

This repository is a personal preparation workspace for the course
**Introduction to Databases** (BSc in Techniques for Software Application Development – UOC).

The goal is to practice and understand:
- Relational schema design
- SQL data definition and manipulation
- JOIN queries and relational thinking
- Transaction management (COMMIT / ROLLBACK)
- Database internal behavior (sequences, autocommit)

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

## Notes

- SQL scripts are written to be executed either in `psql` or DBeaver.
- The structure mirrors the conceptual separation used in the course:
  schema, data, queries, and transaction behavior.
- This workspace is intentionally simple and framework-free.
