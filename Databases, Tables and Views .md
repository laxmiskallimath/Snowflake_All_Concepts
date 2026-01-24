## Databases, Tables and Views 
All data in Snowflake is maintained in databases. Each database consists of one or more schemas, which are logical groupings of database objects, such as tables and views. Snowflake does not place any hard limits on 
the number of databases, schemas (within a database), or objects (within a schema) you can create.

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

The following comparison is based on official Snowflake behavior and the reference table provided:

| Table Type                        | Persistence              | Time Travel Retention (days)               | Fail Safe (days) | Use Case                                                 | Syntax                                 |
| --------------------------------- | ------------------------ | ------------------------------------------ | ---------------- | -------------------------------------------------------- | -------------------------------------- |
| Permanent (Enterprise and higher) | Until explicitly dropped | 0 to 90 (default 1, configurable up to 90) | 7                | Regular production tables                                | `CREATE TABLE table_name();`           |
| Permanent (Standard Edition)      | Until explicitly dropped | 0 or 1 (default is 1)                      | 7                | Regular production tables                                | `CREATE TABLE table_name();`           |
| Transient                         | Until explicitly dropped | 0 or 1 (default is 1)                      | 0                | Staging or processing when full recovery is not required | `CREATE TRANSIENT TABLE table_name();` |
| Temporary                         | Remainder of session     | 0 or 1 (default is 1)                      | 0                | Stored procedures, temporary workloads, dev tasks        | `CREATE TEMPORARY TABLE table_name();` |

---
