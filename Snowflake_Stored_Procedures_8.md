# Stored Procedures in Snowflake

Stored procedures allow us to write procedural code that includes SQL statements, conditional statements, looping statements, and cursors. Their logic typically performs database operations by executing SQL statements.

With stored procedures, we can dynamically create SQL statements and execute them.

Snowflake supports five languages for writing procedures:
- Snowflake Scripting (SQL)
- JavaScript
- Java
- Scala
- Python

Stored procedures allow us to extend Snowflake with procedural code, including branching, looping, and other programmatic constructs. A stored procedure can be reused by calling it multiple times from different SQL scripts or processes.

Stored procedures help automate recurring tasks that require multiple database operations. We can dynamically create and execute SQL statements inside a stored procedure.

Stored procedures run with the privileges of the procedure owner (owner's rights), not the caller. This allows the owner to delegate permissions indirectly. Some limitations apply to owner’s rights procedures.

Stored procedures are useful for centralizing complex logic. Instead of writing many DELETE or UPDATE statements across multiple scripts, we can put them in one stored procedure and call it using parameters. When database structure changes, we update the stored procedure once.

Stored procedures are different from UDFs:
- UDFs return values and are used inside SQL expressions.
- Stored procedures perform multi-step operations and include procedural logic.

Common use case example: cleaning old data across multiple tables by passing a cutoff date parameter to the stored procedure.

---

## Step-by-Step Example

### 1. Creating the SALES_DATA Table
```sql
CREATE OR REPLACE TABLE SALES_DATA (
    ORDER_ID INTEGER,
    ORDER_DATE DATE,
    AMOUNT NUMBER
);
```

### 2. Creating the CUSTOMER_LOGS Table
```sql
CREATE OR REPLACE TABLE CUSTOMER_LOGS (
    LOG_ID INTEGER,
    LOG_DATE DATE,
    DETAILS STRING
);
```

### 3. Inserting Sample Data into SALES_DATA
```sql
INSERT INTO SALES_DATA VALUES
    (1, '2021-01-10', 500),
    (2, '2023-03-15', 700),
    (3, '2020-11-05', 300);
```

### 4. Inserting Sample Data into CUSTOMER_LOGS
```sql
INSERT INTO CUSTOMER_LOGS VALUES
    (101, '2020-12-01', 'Login event'),
    (102, '2023-05-21', 'Purchase event'),
    (103, '2021-02-12', 'Password reset');
```

### 5. Checking Data Before Cleanup
```sql
SELECT * FROM SALES_DATA;
SELECT * FROM CUSTOMER_LOGS;
```

### 6. Creating the Stored Procedure
```sql
CREATE OR REPLACE PROCEDURE CLEANUP_OLD_DATA(CUTOFF_DATE DATE)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    DELETE FROM SALES_DATA
    WHERE ORDER_DATE < :CUTOFF_DATE;

    DELETE FROM CUSTOMER_LOGS
    WHERE LOG_DATE < :CUTOFF_DATE;

    RETURN 'Cleanup completed for date: ' || :CUTOFF_DATE;
END;
$$;
```

Inside the procedure, parameters must be referenced as `:CUTOFF_DATE`.

### 7. Calling the Procedure
```sql
CALL CLEANUP_OLD_DATA('2022-01-01');
```

Rows earlier than the cutoff date are deleted.

---
## Result of Calling the Procedure
<img width="1805" height="696" alt="image" src="https://github.com/user-attachments/assets/966c5b95-97aa-4663-b3e8-4edacdbd0c46" />

## Owner’s Rights vs Caller’s Rights Stored Procedures

### 1. Caller’s Rights Stored Procedure
Runs using the privileges of the caller. The procedure cannot do anything beyond what the caller is allowed to do.

**Advantages:**
- Can access caller-specific information such as session variables and caller's context.

**Use Case:**
- When behavior must depend on who is calling the procedure.

### 2. Owner’s Rights Stored Procedure (Default)
Runs using the privileges of the procedure owner, not the caller.

**Advantages:**
- Delegates limited administrative tasks without granting broader privileges.
- Caller does not need DELETE or UPDATE privileges.

**Use Case:**
- Cleaning old data
- Updating secured tables
- Performing privileged operations without exposing permissions

### Changing Rights
```sql
ALTER PROCEDURE my_proc()
SET EXECUTE AS OWNER;   -- or CALLER
```

