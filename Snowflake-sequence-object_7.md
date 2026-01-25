# Snowflake Sequence Object

A sequence object is a special type of object in Snowflake that is used to generate unique numbers. Sequence objects are similar to an auto incrementing field in a database table but they are more flexible.

A sequence object can be used to generate numbers in a specific range,with a specific increment, and with a specific starting point. Sequences are used to generate unique numbers across sessions and statements,
including concurrent statements.

Sequences can be used to generate values for a primary key or for any column that requires a unique value. Snowflake does not guarantee that sequence numbers are generated without gaps. The numbers are not necessarily contiguous.

## Example

### Generate Values with NEXTVAL

``` sql
CREATE OR REPLACE SEQUENCE seq_01 
START = 1 INCREMENT = 1;
```

Every execution returns the next number in the sequence. Sequence numbers continue to increase across sessions, tasks, or inserts.

## Step 1: Create a Sequence

``` sql
CREATE DATABASE my_db;

CREATE OR REPLACE SEQUENCE seq_emp 
START = 1 
INCREMENT = 1;
```

## Step 2: Create a Table

``` sql
CREATE OR REPLACE TABLE employees (
    emp_id NUMBER,
    emp_name STRING
);
```

## Step 3: Insert Values Using the Sequence

``` sql
INSERT INTO employees VALUES (seq_emp.NEXTVAL, 'John');
INSERT INTO employees VALUES (seq_emp.NEXTVAL, 'Maria');
INSERT INTO employees VALUES (seq_emp.NEXTVAL, 'Angelina');
INSERT INTO employees VALUES (seq_emp.NEXTVAL, 'Pallavi');
INSERT INTO employees VALUES (seq_emp.NEXTVAL, 'Julie');
```

## Step 4: Check the Result

``` sql
SELECT * FROM employees;
```

## Output

``` text
EMP_ID   EMP_NAME
1        John
101      Maria
2        Angelina
3        Pallavi
4        Pallavi
5        Julie
102      Julie
```

## Why Are We Getting 101 and 102 in Between?

Snowflake sequences do not guarantee continuous numbers.

### 1. Pre-allocated Internally

Snowflake allocates sequence values in advance inside micro partitions.

### 2. Multi-Cluster and Parallel Execution

Different nodes may preallocate chunks such as 1--100, 101--200.

### 3. Sequences Guarantee Uniqueness, Not Continuity

## Purpose of Sequences

-   Surrogate primary keys
-   Unique row identifiers
-   Merge keys
-   Event tracking
-   Auto-generated IDs

## If we Need Perfect 1,2,3,4,5 Numbers

Use:

``` sql
ROW_NUMBER() OVER (ORDER BY <column>)
```
