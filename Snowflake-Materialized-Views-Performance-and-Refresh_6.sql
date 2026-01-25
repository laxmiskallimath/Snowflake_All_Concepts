/*=====================================================================
    MATERIALIZED_VIEW_DEMO
    Step by step implementation of Snowflake materialized views
=====================================================================*/


-- Step 1: Disable Cache for Fair Performance Comparison
-- Snowflake stores query results in cache. To measure real performance,we disable cache so that every query scans actual data.
-----------------------------------------------------------------------
ALTER SESSION SET use_cached_result = FALSE;

-- Restart warehouse to clear memory cache
ALTER WAREHOUSE compute_wh SUSPEND;
ALTER WAREHOUSE compute_wh RESUME;

-----------------------------------------------------------------------
-- Step 2: Prepare Database, Schema, and Table
-- We create a new transient database and schema. Then we copy the large sample Orders table (millions of rows) into our own location to run materialized view tests.
-----------------------------------------------------------------------
CREATE OR REPLACE TRANSIENT DATABASE orders;
CREATE OR REPLACE SCHEMA orders.tpch_sf100;

-- Copy sample data from public Snowflake datasets
CREATE OR REPLACE TABLE orders.tpch_sf100.orders AS
SELECT *
FROM snowflake_sample_data.tpch_sf100.orders;

-- Confirm data copy
SELECT COUNT(*) AS row_count
FROM orders.tpch_sf100.orders;

SELECT *
FROM orders.tpch_sf100.orders
LIMIT 10;

-----------------------------------------------------------------------
-- Step 3: Baseline Aggregation Query on Base Table
-- This query scans the full table and performs aggregation. This gives us a baseline performance measure before creating the materialized view.
-----------------------------------------------------------------------
SELECT
    YEAR(o_orderdate) AS year,
    MAX(o_comment) AS max_comment,
    MIN(o_comment) AS min_comment,
    MAX(o_clerk) AS max_clerk,
    MIN(o_clerk) AS min_clerk
FROM orders.tpch_sf100.orders
GROUP BY YEAR(o_orderdate)
ORDER BY year;

-----------------------------------------------------------------------
-- Step 4: Create Materialized View
-- The materialized view stores precomputed aggregated values so that future queries run faster. Snowflake automatically maintains and refreshes the materialized view when data changes.
-----------------------------------------------------------------------
CREATE OR REPLACE MATERIALIZED VIEW orders_mv AS
SELECT
    YEAR(o_orderdate) AS year,
    MAX(o_comment) AS max_comment,
    MIN(o_comment) AS min_comment,
    MAX(o_clerk) AS max_clerk,
    MIN(o_clerk) AS min_clerk
FROM orders.tpch_sf100.orders
GROUP BY YEAR(o_orderdate);

-- Check MV details such as refresh time and status
SHOW MATERIALIZED VIEWS IN SCHEMA orders.tpch_sf100;

-----------------------------------------------------------------------
-- Step 5: Query the Materialized View
-- Since results are precomputed and stored physically, this query will run much faster compared to the baseline query on the base table.
-----------------------------------------------------------------------
SELECT *
FROM orders_mv
ORDER BY year;

-----------------------------------------------------------------------
-- Step 6: Update Base Table to Trigger MV Refresh
-- Any update to the base table will require Snowflake to refresh the materialized view. Updates refresh incrementally instead of full scan.
-----------------------------------------------------------------------
UPDATE orders.tpch_sf100.orders
SET o_clerk = 'Clerk#99900000'
WHERE o_orderdate = '1992-01-01';

-----------------------------------------------------------------------
-- Step 7: Validate Update on Base Table
-- This confirms that the update was applied to the underlying dataset.
-----------------------------------------------------------------------
SELECT
    YEAR(o_orderdate) AS year,
    MAX(o_comment) AS max_comment,
    MIN(o_comment) AS min_comment,
    MAX(o_clerk) AS max_clerk,
    MIN(o_clerk) AS min_clerk
FROM orders.tpch_sf100.orders
GROUP BY YEAR(o_orderdate)
ORDER BY year;

-----------------------------------------------------------------------
-- Step 8: Query Materialized View Again
-- Even if REFRESHED_ON is not updated immediately, Snowflake provides correct values because it uses on demand lookups for changed data.
-----------------------------------------------------------------------
SELECT *
FROM orders_mv
ORDER BY year;

-----------------------------------------------------------------------
-- Step 9: Check Materialized View Status
-- REFRESHED_ON tells when the view was last refreshed.
-- BEHIND_BY shows how much delay exists.
-- COMPACTED_ON shows maintenance of deleted rows.
-----------------------------------------------------------------------
SHOW MATERIALIZED VIEWS IN SCHEMA orders.tpch_sf100;

-----------------------------------------------------------------------
-- Step 10: Check Materialized View Refresh History
-- Snowflake records background refresh operations and credit usage.
-----------------------------------------------------------------------
SELECT *
FROM TABLE(
    INFORMATION_SCHEMA.MATERIALIZED_VIEW_REFRESH_HISTORY(
        DATE_RANGE_START => DATEADD('hour', -24, CURRENT_TIMESTAMP),
        DATE_RANGE_END   => CURRENT_TIMESTAMP,
        MATERIALIZED_VIEW_NAME => 'ORDERS_MV'
    )
);

-----------------------------------------------------------------------
-- Additional Reference Queries
-----------------------------------------------------------------------
SHOW MATERIALIZED VIEWS;

SELECT *
FROM TABLE(information_schema.materialized_view_refresh_history());
