# Snowflake File Format Object

A Snowflake File Format object encapsulates information about data files, such as file type (CSV, JSON, etc.) and formatting options used for bulk loading or unloading.

```
CREATE [ OR REPLACE ] FILE FORMAT <name>

TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML }
```

### Example

```
CREATE OR REPLACE FILE FORMAT <db.name>.<schema.name>.stg_ACCOUNT_LOAD_FILE_FORMAT
TYPE = CSV
COMPRESSION = 'AUTO'
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'
SKIP_HEADER = 1;
```

---

# Snowflake File Format Examples

## Example 1: Create a CSV File Format in a Specific Database and Schema

``` sql
CREATE OR REPLACE FILE FORMAT MYDB.STAGING.STG_ACCOUNT_LOAD_FILE_FORMAT
TYPE = CSV
COMPRESSION = 'AUTO'
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'
SKIP_HEADER = 1;
```

## Example 2: Create a File Format With Additional CSV Options

``` sql
CREATE OR REPLACE FILE FORMAT MYDB.STAGING.STG_TRANSACTION_FILE_FORMAT
TYPE = CSV
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
NULL_IF = ('NULL', 'null', '');
```

## Example 3: Create a Simple File Format Inside PUBLIC Schema

``` sql
CREATE OR REPLACE FILE FORMAT MYDB.PUBLIC.SIMPLE_CSV_FORMAT
TYPE = CSV
FIELD_DELIMITER = ','
SKIP_HEADER = 1;
```

## Example Four: Create a File Format for Pipe/Copy Data Loads

``` sql
CREATE OR REPLACE FILE FORMAT RAW_DB.LOAD.STG_CUSTOMER_FILE_FORMAT
TYPE = CSV
COMPRESSION = 'GZIP'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
TRIM_SPACE = TRUE
EMPTY_FIELD_AS_NULL = TRUE;
```


# Supported File Formats

## Structured

| Type                       | Notes                                                                 |
| -------------------------- | --------------------------------------------------------------------- |
| Delimited (CSV, TSV, etc.) | Any valid single-byte delimiter is supported. Default is comma (CSV). |

## Semi-structured

| Type    | Notes                                                                                                                                                    |
| ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| JSON    | Supported natively.                                                                                                                                      |
| Avro    | Automatic detection and processing of compressed Avro files.                                                                                             |
| ORC     | Automatic detection and processing of compressed ORC files.                                                                                              |
| Parquet | Automatic detection and processing of compressed Parquet files. Snowflake supports schemas produced using Parquet writer v1. Writer v2 is not supported. |
| XML     | Supported natively.                                                                                                                                      |

Snowflake provides defaults for all file format options, and available options vary depending on the file type being loaded.

---

# Semi-Structured File Formats

Snowflake natively supports semi-structured data and allows loading such data into relational tables without defining a schema in advance. Semi-structured data can be loaded directly into **VARIANT** columns.

Supported semi-structured file formats:

* JSON
* Avro
* ORC
* Parquet
* XML

### Loading Behavior

**JSON, Avro, ORC, Parquet:**

* Each top-level complete object becomes a separate row.
* Objects may include newline characters and spaces.

**XML:**

* Each top-level element becomes a separate row.
* Elements are identified by matching start and end tags.

Most tables for semi-structured data include a single VARIANT column. After loading, data can be queried similarly to structured data, including extracting nested elements or flattening arrays.

> Note: Semi-structured data can also be loaded into tables with multiple columns if the semi-structured content is stored as a field in a structured file such as CSV.

---

# Named File Formats

Snowflake supports **named file formats**, which are database objects that encapsulate all required file format metadata.

Benefits:

* Reusable in COPY and other data loading commands.
* Streamlines loading when files share consistent formatting.
* Optional but recommended for repeated loading of similarly formatted files.

Named file formats can replace inline file format options in all relevant SQL commands.
