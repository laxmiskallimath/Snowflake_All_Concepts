------------------------------------------------------------
-- 1. What is a Stage?
-- A stage is a location Snowflake uses to access files.
-- Snowflake loads data from stages only.
-- Types of stages:
--   1. External Stage – points to AWS S3, GCS, Azure.
--   2. Internal Stage – storage inside Snowflake.
--
-- Stages are required for loading and unloading data.
-----------------------------------------------------------

------------------------------------------------------------
-- STEP 1: Create a database to manage admin objects to Keep stages, file formats, integrations inside a separate admin database.
------------------------------------------------------------
CREATE OR REPLACE DATABASE MANAGE_DB;


------------------------------------------------------------
-- STEP 2: Create schema for organizing external stages
-- This schema will contain all external stages.
------------------------------------------------------------
CREATE OR REPLACE SCHEMA MANAGE_DB.external_stages;


------------------------------------------------------------
-- STEP 3: Create an external stage with AWS credentials
-- This stage connects Snowflake to an S3 bucket.
-- url = bucket location
-- credentials = AWS key + secret (used for private buckets)
------------------------------------------------------------
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3'
    credentials=(aws_key_id='ABCD_DUMMY_ID' aws_secret_key='1234abcd_key');



------------------------------------------------------------
-- STEP 4: Describe the stage
-- DESC STAGE displays properties like:
--   * URL
--   * AWS key id
--   * file format defaults
--   * region, encoding, delimiters
-- Used to verify the stage configuration.
------------------------------------------------------------
DESC STAGE MANAGE_DB.external_stages.aws_stage;


------------------------------------------------------------
-- STEP 5: Alter the stage
-- Used when credentials change or file format needs updates.
------------------------------------------------------------
ALTER STAGE MANAGE_DB.external_stages.aws_stage
    SET credentials=(aws_key_id='XYZ_DUMMY_ID' aws_secret_key='987xyz');


------------------------------------------------------------
-- STEP 6: Recreate stage WITHOUT credentials
-- If S3 bucket is public: No AWS keys required.
------------------------------------------------------------
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3';



------------------------------------------------------------
-- STEP 7: List files inside the stage
-- LIST shows:
--   * filenames
--   * size
--   * last modified timestamp
-- @ represents the stage reference.
------------------------------------------------------------
LIST @MANAGE_DB.external_stages.aws_stage;



------------------------------------------------------------
-- STEP 8: Load data from stage into a table using COPY INTO
-- COPY INTO loads data from S3 → Stage → Table.
-- file_format:
--     type = csv
--     field_delimiter = ','
--     skip_header = 1 (ignore header)
-- pattern:
--     loads only files containing “Order” in the name
------------------------------------------------------------
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format = (type = csv field_delimiter = ',' skip_header = 1)
    pattern = '.*Order.*';


