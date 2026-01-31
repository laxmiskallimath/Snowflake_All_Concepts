# Overview of data loading

## 1. Two Ways of Loading Data

Snowflake provides two main methods to load data into tables.

## Bulk Loading

This option enables loading batches of data from files already available in cloud storage, or copying (i.e. staging) data files from a local machine to an internal (i.e. Snowflake) cloud storage location before loading the data into tables using the COPY command.

This is the common and most important loading method. We use our own warehouse compute to load data.

### Compute resources :

Bulk loading relies on user-provided virtual warehouses, which are specified in the COPY statement. Users are required to size the warehouse appropriately to accommodate expected loads.

### Simple transformations during a load :

Snowflake supports transforming data while loading it into a table using the COPY command. Options include:

- Column reordering
- Column omission
- Casts
- Truncating text strings that exceed the target column length

There is no requirement for your data files to have the same number and ordering of columns as your target table.

### Key points

- Loads large volumes of data
- Uses stages as the source location
- Requires a running warehouse
- Uses the COPY INTO command
- Can apply small data transformations while loading

## Continuous Loading

This option is designed to load small volumes of data (i.e. micro-batches) and incrementally make them available for analysis. Snowpipe loads data within minutes after files are added to a stage and submitted for ingestion. This ensures users have the latest results, as soon as the raw data is available.Used when data must be available almost immediately.

### Compute resources :

Snowpipe uses compute resources provided by Snowflake (i.e. a serverless compute model). These Snowflake-provided resources are automatically resized and scaled up or down as required, and are charged and itemized using per-second billing. Data ingestion is charged based upon the actual workloads.

### Simple transformations during a load :

The COPY statement in a pipe definition supports the same COPY transformation options as when bulk loading data. In addition, data pipelines can leverage Snowpipe to continuously load micro-batches of data into staging tables for transformation and optimization using automated tasks and the change data capture (CDC) information in streams.

### Key points

- Loads small amounts of data continuously
- Uses Snowpipe
- Uses Snowflake Serverless compute
- Ideal for near real-time data updates

## 3. How Bulk Loading Works

- Put files into a stage
- Run COPY INTO table
- Snowflake warehouse reads data from the stage
- Data moves into the table

This is the most commonly used process in real projects.

## 4. Why COPY Command Is Important

The COPY INTO command controls the entire loading process.

It helps with:

- Reading files from stages
- Handling file formats (CSV, JSON, Parquet)
- Skipping bad rows if required
- Applying small transformations
- Loading large data efficiently

## 5. Continuous Loading with Snowpipe

Snowpipe loads data automatically as soon as files arrive in the stage.

- File lands in the stage
- Notification triggers Snowpipe
- Snowpipe loads data using serverless compute
- Data appears in the table within seconds or minutes

Useful when the business needs fresh data quickly.

## What Are Stages?

A stage is simply a storage location where our files sit before loading into Snowflake tables. In Snowflake, a stage is a database object that tells Snowflake where the source files are located before loading them into a table.

## Three types of stages

- Internal stage (inside Snowflake)
- External stage (AWS S3, GCP GCS, Azure Blob)
- Table stage (automatically created for each table)

We load data from a stage into a table.

## External stages

Loading data from any of the following cloud storage services is supported regardless of the cloud platform that hosts your Snowflake account:

- Amazon S3
- Google Cloud Storage
- Microsoft Azure

A named external stage is a database object created in a schema. This object stores the URL to files in cloud storage, the settings used to access the cloud storage account, and convenience settings such as the options that describe the format of staged files. Create stages using the CREATE STAGE command.

It contains properties such as:

- the storage URL
- credentials
- extra connection settings

## Internal stages :

Used when we do not rely on external storage.Files are uploaded into Snowflake managed storage.These are useful when no external cloud integration is available.

Snowflake maintains the following stage types in your account:

### User stage :

A user stage is allocated to each user for storing files. This stage type is designed to store files that are staged and managed by a single user but can be loaded into multiple tables. User stages cannot be altered or dropped.

### Table stage :

A table stage is available for each table created in Snowflake. This stage type is designed to store files that are staged and managed by one or more users but only loaded into a single table. Table stages cannot be altered or dropped.

Note that a table stage is not a separate database object; rather, it is an implicit stage tied to the table itself. A table stage has no grantable privileges of its own. To stage files to a table stage, list the files, query them on the stage, or drop them, you must be the table owner (have the role with the OWNERSHIP privilege on the table).

### Named internal stage :

A named internal stage is a database object created in a schema. This stage type can store files that are staged and managed by one or more users and loaded into one or more tables. Because named stages are database objects, the ability to create, modify, use, or drop them can be controlled using security access control privileges. Create stages using the CREATE STAGE command. Upload files to any of the internal stage types from your local file system using the PUT command.

## Why Stages Matter :

### To load data

- Create a stage
- Put files in the stage
- Run COPY INTO table

This is the foundation of bulk loading in Snowflake.

### To continuously load data using Snowpipe

- Files arrive in the external stage
- Snowpipe automatically detects new files
- Snowpipe loads the data into the table using serverless compute

This is the foundation of continuous loading in Snowflake.
