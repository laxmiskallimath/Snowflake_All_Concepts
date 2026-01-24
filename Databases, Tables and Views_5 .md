## Databases, Tables and Views 
All data in Snowflake is maintained in databases. Each database consists of one or more schemas, which are logical groupings of database objects, such as tables and views. Snowflake does not place any hard limits on the number of databases, schemas (within a database), or objects (within a schema) you can create.

Snowflake mainly has three core table types, and the rest are specialized or extended table types.

Snowflake provides different table types to support various storage, retention, and cost requirements. Every table type serves a specific purpose in data engineering and data warehousing workloads.

## Permanent Tables
Permanent tables are the default table type in Snowflake. These tables support full Time Travel and Fail Safe retention. They are used for long term storage of production data.
* Default table type when no keyword is specified.
* Supports complete Time Travel retention period.
* Includes Fail Safe for additional data protection.
* Suitable for production and business critical datasets.

### Syntax

```sql
CREATE TABLE EMP (
 ID INT,
  ...
);
```

## Transient Tables
Transient tables are used for storing temporary or intermediate data where long term protection is not needed.

* Supports Time Travel with a shorter retention period.
* No Fail Safe, which reduces storage cost.
* Suitable for staging or intermediate processing.

### Syntax

```sql
CREATE TRANSIENT TABLE EMP_TR (
  ID INT,
  ...
);
```

## Temporary Tables
Temporary tables exist only for the duration of the user session.

* Automatically dropped at the end of the session.
* No Fail Safe.
* Lower cost for temporary workloads.

### Syntax

```sql
CREATE TEMPORARY TABLE EMP_TMP (
  ID INT,
  ...
);
```

---

## External Tables
External tables allow Snowflake to query data stored outside Snowflake, such as in Amazon S3, Google Cloud Storage, or Azure Blob.

* Snowflake stores only metadata.
* Supports querying external cloud storage.
* Used for data lake and ELT workflows.

### Syntax

```sql
CREATE EXTERNAL TABLE table_name
WITH LOCATION = 's3://bucket/path/'
FILE_FORMAT = my_format;
```

---

## Hybrid Tables
Hybrid tables support transactional workloads with fast queries and inserts. They follow ACID properties and are suitable for mixed analytical and transactional scenarios.

* Combines OLTP and OLAP experiences.
* Supports row level transactional operations.

---

## Iceberg Tables
Snowflake supports Apache Iceberg tables for managing large scale data lake workloads.

* Uses Iceberg table format.
* Allows interoperability with other engines that support Iceberg.
* Supports metadata managed either by Snowflake or externally.

---

## Comparison of Table Types

| Table Type                        | Persistence              | Time Travel Retention (days)               | Fail Safe (days) | Use Case                                                 | Syntax                                   |
| --------------------------------- | ------------------------ | ------------------------------------------ | ---------------- | -------------------------------------------------------- | ---------------------------------------- |
| Permanent (Enterprise and higher) | Until explicitly dropped | 0 to 90 (default 1, configurable up to 90) | 7                | Regular production tables                                | `CREATE TABLE table_name();`             |
| Permanent (Standard Edition)      | Until explicitly dropped | 0 or 1 (default is 1)                      | 7                | Regular production tables                                | `CREATE TABLE table_name();`             |
| Transient                         | Until explicitly dropped | 0 or 1 (default is 1)                      | 0                | Staging or processing when full recovery is not required | `CREATE TRANSIENT TABLE table_name();`   |
| Temporary                         | Remainder of session     | 0 or 1 (default is 1)                      | 0                | Stored procedures, temporary workloads, dev tasks        | `CREATE TEMPORARY TABLE table_name();`   |

---

## Views in Snowflake

A view is a schema level object that contains an SQL query built over one or multiple tables. A view behaves like a virtual table and can be used wherever a table is used. When a view is queried, Snowflake executes the underlying SQL each time and fetches data from the base tables.

Views help in combining, aggregating, and protecting data.

### Syntax to Create a View

```sql
CREATE OR REPLACE VIEW VIEW_NAME AS
SELECT ...
```

### Types of Views

* Non materialized views
* Materialized views
* Secure views

Both non materialized and materialized views can be defined as secure.

---

## Materialized Views

A materialized view is a pre computed dataset derived from a SQL query. It refreshes automatically when the base table changes. Since the data is pre computed, querying a materialized view is faster than querying the base table.

### Key Points

* Can be created only on a single table
* Useful when the same dataset is queried repeatedly
* Helps improve performance for complex queries and large datasets
* Snowflake maintains materialized views automatically
* Updates may take some time to reflect
* Available in Enterprise edition and above

### Syntax to Create a Materialized View

```sql
CREATE OR REPLACE MATERIALIZED VIEW VIEW_NAME AS
SELECT ...
```

---

## Secure Views

A secure view does not allow users to see the definition of the view. Users cannot view the underlying SQL query.

The definition of a secure view is exposed only to authorized users who have been granted the role that owns the view.

### Advantages

* Protects the data by hiding it from other users
* Useful when you do not want users to access underlying tables
* Recommended for datasets where privacy is required

### Syntax

```sql
CREATE OR REPLACE SECURE VIEW VIEW_NAME AS
SELECT Statement;
```
## Advantages of Views

### Views Enable Writing More Modular Code
* Views help break down complex SQL into smaller, readable parts.
* They improve code clarity by organizing logic into reusable units.
* You can build hierarchies of views (one view referencing another).
* Views increase code reuse because multiple queries can reference the same view.
* Debugging becomes easier because each view can be tested independently.

### Example
```sql
CREATE TABLE employees (id INTEGER, title VARCHAR);
INSERT INTO employees (id, title) VALUES
    (1, 'doctor'),
    (2, 'nurse'),
    (3, 'janitor');

CREATE VIEW doctors AS SELECT * FROM employees WHERE title = 'doctor';
CREATE VIEW nurses AS SELECT * FROM employees WHERE title = 'nurse';

CREATE VIEW medical_staff AS
    SELECT * FROM doctors
    UNION
    SELECT * FROM nurses;

SELECT * FROM medical_staff ORDER BY id;
```

---

### Views Allow Granting Access to a Subset of a Table
* Views help enforce data privacy by exposing only selected columns to users.
* Roles can be granted access to a view without granting access to the underlying table.
* Useful in sensitive domains such as medical, financial, or HR datasets.
* Secure views provide an additional privacy layer by hiding the underlying SQL definition.

---

## Materialized Views Can Improve Performance
* Materialized views store pre computed subsets of table data.
* Querying a materialized view is often faster than querying the base table.
* Supports clustering keys for better performance.
* Multiple materialized views can be created on the same table for different query patterns.

---

## Limitations of Views
* A view definition cannot be modified using ALTER VIEW the view must be recreated.
* Views are read-only but can be used inside subqueries of DML statements.
* If a base table changes (e.g., a column is dropped), dependent views may break.
* Changes to base tables do not automatically update view definitions.

