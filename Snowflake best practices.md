# Snowflake Best Practices

Snowflake best practices are smart habits that help us use Snowflake faster, cheaper, safer, and with fewer problems. Best practices are recommended ways of doing things so that systems become more cost efficient, faster, secure, and easier to manage.

## Main Best Practice Areas
- Warehouse configuration
- Table design
- Monitoring compute and storage
- Retention management

## 1. Warehouse Best Practices

A warehouse is the compute engine in Snowflake. Recommended settings include:

- Auto suspend enabled  
- Auto resume enabled  
- Correct warehouse size based on workload  
- Purpose based warehouse usage pattern

### Implementation

```
CREATE OR REPLACE WAREHOUSE ANALYTICS_WH
WAREHOUSE_SIZE = 'SMALL'
AUTO_SUSPEND = 300
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;
```

Auto suspend saves cost by stopping compute when idle.  
Auto resume ensures the warehouse wakes up automatically when queries run.  
A small size is cost efficient for light workloads and can be increased later.

## 2. Table Design Best Practices

We design tables using correct data types and only add clustering when necessary.

- Use DATE for date fields  
- Use NUMBER for numeric fields  
- Avoid VARCHAR for everything  
- Avoid clustering unless the table is large and heavily filtered  

### Example

```
CREATE OR REPLACE TABLE STG_CUSTOMER (
    CUSTOMER_ID NUMBER,
    CUSTOMER_NAME STRING,
    SIGNUP_DATE DATE,
    REGION STRING
);
```

Staging tables should be transient with zero retention.

## 3. Monitoring Best Practices

Monitoring helps us understand compute and storage usage. Important views include:

- TABLE_STORAGE_METRICS  
- QUERY_HISTORY  
- WAREHOUSE_METERING_HISTORY  

### Example Queries

Storage usage:

```
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS;
```

Most queried databases:

```
SELECT DATABASE_NAME, COUNT(*) AS NUMBER_OF_QUERIES
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
GROUP BY DATABASE_NAME;
```

Warehouse credit usage:

```
SELECT WAREHOUSE_NAME, SUM(CREDITS_USED)
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
GROUP BY WAREHOUSE_NAME;
```

Monitoring can be exported to BI dashboards.

## 4. Retention and Time Travel Best Practices

Retention affects storage cost. Recommended settings:

### Staging
- Use transient tables  
- Retention period = 0 days  

### Production
- Retention period = 1 to 7 days  

### High churn tables
- Use transient tables  
- Retention period = 0 days  

### Example

```
CREATE OR REPLACE TRANSIENT TABLE STG_SALES (
    ORDER_ID NUMBER,
    ORDER_DATE DATE,
    AMOUNT NUMBER
);

ALTER TABLE STG_SALES 
SET DATA_RETENTION_TIME_IN_DAYS = 0;
```

---

# Summary of Other Snowflake Recommended Practices

## 1. Use the right warehouse size
Small jobs use small warehouses. Heavy queries use larger warehouses. Resize as needed.

## 2. Turn on auto-suspend and auto-resume
Auto-suspend after a few minutes and auto-resume on query execution to save credits.

## 3. Separate compute from storage
Use different warehouses for different workloads so one team does not impact another.

## 4. Design tables for how they are queried
Use proper data types and avoid storing everything as TEXT. Avoid over-normalization.

## 5. Use clustering only when needed
Apply clustering only for large, heavily filtered tables because clustering has maintenance cost.

## 6. Control access with roles
Give minimum access required. Read-only users should not have write access.

## 7. Monitor usage and costs
Regularly check query history, warehouse credits, and use alerts to avoid unexpected charges.

## 8. Use Time Travel and Fail-safe wisely
Keep enough history to recover data but avoid unnecessary retention that increases cost.

## 9. Optimize SQL queries
Write efficient SQL.  
Avoid SELECT *.  
Filter early.  
Avoid unnecessary joins.  
Efficient SQL reduces cost and improves performance.
