Snowflake Data Types and Objects
Snowflake Data Types

Snowflake supports most common SQL data types for use in columns, variables, expressions and function parameters.

Numeric Data Types

Snowflake supports numeric types including:

NUMBER

DECIMAL, NUMERIC (synonymous with NUMBER)

INT, INTEGER, BIGINT, SMALLINT, TINYINT, BYTEINT (aliases for NUMBER)

FLOAT, FLOAT4, FLOAT8

DOUBLE, DOUBLE PRECISION, REAL (synonymous with FLOAT)

DECFLOAT (high precision decimal)

The default precision for NUMBER is 38 with scale 0.

String and Binary Data Types

Snowflake supports character and binary data types:

VARCHAR (default max length ~16MB)

CHAR, CHARACTER (synonym for VARCHAR)

STRING, TEXT (synonyms for VARCHAR)

BINARY, VARBINARY (binary data)

Logical Data Type

BOOLEAN (supports TRUE, FALSE, and NULL)

Date and Time Data Types

Snowflake supports date and time types:

DATE

DATETIME (synonym for TIMESTAMP_NTZ)

TIME

TIMESTAMP_LTZ (local time zone)

TIMESTAMP_NTZ (no time zone)

TIMESTAMP_TZ (time zone stored)

Semi-structured Data Types

These types allow storing nested and flexible data structures:

VARIANT (can store any data type)

OBJECT (key/value pairs)

ARRAY (ordered list of values)

Variant, Object and Array are commonly used to work with formats such as JSON, Parquet and XML.

Geospatial Data Types

Snowflake supports geospatial types:

GEOGRAPHY

GEOMETRY

Vector Data Type

VECTOR (for vectorized data, e.g., ML embeddings)

Unsupported Data Types

Snowflake does not support the following:

Category	Type	Notes
LOB (Large Object)	BLOB	Use BINARY instead
CLOB	CLOB	Use VARCHAR instead
Other	ENUM	Not supported
Other	User-defined data types	Not supported
Snowflake Objects Overview

Snowflake organizes all data and metadata into a hierarchy of logical containers.

Object Hierarchy
Organization
    │
 Account
    ├── Users
    ├── Roles
    ├── Warehouses
    ├── Databases
    │     └── Schema
    │          └── Schema Objects
    └── Other Account Objects


Organization: Top level, can contain multiple accounts.

Account: Main administrative boundary with users, roles, warehouses and databases.

Schema: Inside a database, groups related objects.

Schema Level Objects

These are the primary objects that reside inside a schema:

Table – structured table for storing relational data

View – virtual table based on a query

Stage – location for file storage (internal or external)

File Format – defines file structure for loading/unloading

Sequence – generates unique sequence values

Pipe – continuous data loading definitions (Snowpipe)

Stream – tracks change data capture

Task – scheduled execution of SQL or procedural logic

Stored Procedure – encapsulated logic with parameters

User Defined Function (UDF) – custom scalar functions

Materialized View (optional performance view)

Tag – key/value labels assignable to many objects

Other Database and Account Objects

In addition to schema objects, Snowflake supports:

Warehouse – compute resources for executing queries

Database – logical collection of schemas

User – identity in Snowflake

Role – access control entity

Integration – external service integration object

Network Policy – IP and network controls

Resource Monitor – tracking and limiting resource usage

Secure Views – row/column level secure access controls

Data Share – shared data objects across accounts

Information Schema and Metadata

Snowflake includes:

INFORMATION_SCHEMA – read-only schema with metadata views about databases, schemas, tables, columns and more.

ACCOUNT_USAGE – views in the SNOWFLAKE database for historical usage and object metadata.

You can query these to discover object definitions, usage and structure.
