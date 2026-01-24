# Snowflake Data Types and Objects

This document provides a clear overview of Snowflake data types and Snowflake objects. Content is organized for easy reading and suitable for a GitHub repository.

---

## Snowflake Data Types

Snowflake supports a wide range of SQL data types for columns, expressions, variables and function parameters.

### 1. Numeric Data Types

Snowflake supports common numeric types:

* **NUMBER**
* **DECIMAL**, **NUMERIC**
* **INT**, **INTEGER**, **BIGINT**, **SMALLINT**, **TINYINT**, **BYTEINT**
* **FLOAT**, **FLOAT4**, **FLOAT8**
* **DOUBLE**, **DOUBLE PRECISION**, **REAL**
* **DECFLOAT** (high precision decimal)

The default precision for `NUMBER` is 38 with scale 0.

### 2. String and Binary Data Types

* **VARCHAR** (default max length ~16 MB)
* **CHAR**, **CHARACTER** (synonyms for VARCHAR)
* **STRING**, **TEXT** (synonyms for VARCHAR)
* **BINARY**, **VARBINARY**

### 3. Logical Data Type

* **BOOLEAN** (TRUE, FALSE, NULL)

### 4. Date and Time Data Types

* **DATE**
* **DATETIME** (synonym for TIMESTAMP_NTZ)
* **TIME**
* **TIMESTAMP_LTZ**
* **TIMESTAMP_NTZ**
* **TIMESTAMP_TZ**

### 5. Semi-structured Data Types

Used for flexible or nested data such as JSON, XML and Parquet.

* **VARIANT**
* **OBJECT**
* **ARRAY**

### 6. Geospatial Data Types

* **GEOGRAPHY**
* **GEOMETRY**

### 7. Vector Data Type

* **VECTOR** (useful for ML embeddings)

### 8. Unsupported Data Types

| Category | Type               | Replacement   |
| -------- | ------------------ | ------------- |
| LOB      | BLOB               | Use BINARY    |
| LOB      | CLOB               | Use VARCHAR   |
| Other    | ENUM               | Not supported |
| Other    | User-defined types | Not supported |

---

## Snowflake Objects Overview

Snowflake organizes data and metadata using a hierarchical structure.

### Object Hierarchy

```
Organization
    │
    └── Account
           ├── Users
           ├── Roles
           ├── Warehouses
           ├── Databases
           │      └── Schemas
           │             └── Schema Objects
           └── Other Account Objects
```

### Key Concepts

* **Organization**: Top level container for multiple accounts.
* **Account**: Contains warehouses, roles, users and databases.
* **Database**: Logical collection of schemas.
* **Schema**: Groups related objects.

---

## Schema-level Objects

Objects inside a schema include:

* **Table** – stores structured relational data
* **View** – virtual table based on a query
* **Stage** – internal or external storage location
* **File Format** – describes file structure for loading/unloading
* **Sequence** – generates unique numeric values
* **Pipe** – Snowpipe continuous load definition
* **Stream** – captures CDC (change data capture)
* **Task** – runs SQL or procedural logic on schedule
* **Stored Procedure** – encapsulated logic
* **User Defined Function (UDF)** – custom functions
* **Materialized View** – precomputed view for performance
* **Tag** – metadata labels

---

## Database and Account-level Objects

In addition to schema objects, Snowflake supports:

* **Warehouse** – compute layer for query execution
* **User / Role** – identity and access control
* **Integration** – external service configuration
* **Network Policy** – IP and network restrictions
* **Resource Monitor** – usage and cost controls
* **Secure Views** – secure access to sensitive data
* **Data Share** – share data across accounts

---

## Metadata and Information Schema

Snowflake provides built-in metadata views:

* **INFORMATION_SCHEMA** – metadata for objects within a database
* **ACCOUNT_USAGE** (in SNOWFLAKE database) – historical usage and object information

These views help analyze structures, permissions, usage patterns and data models.

---

