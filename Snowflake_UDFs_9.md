# User Defined Functions (UDF) in Snowflake

User Defined Functions (UDF) are used to extend the system and perform operations that are not available through the built in system defined functions provided by Snowflake.

A UDF allows us to encapsulate functionality so that we can call it repeatedly from multiple places in code.

Snowflake supports five languages for writing UDFs:
1. SQL
2. JavaScript
3. Java
4. Python
5. Scala

---

## Understanding UDFs

- UDFs allow us to write custom logic that Snowflake does not provide by default.
- They return a single value and can be used inside SQL expressions like built in functions.
- UDFs help simplify complex calculations by centralizing logic.


## Defining a UDF
Below is the example shown in the screenshot for creating a Python UDF.

```sql
CREATE OR REPLACE FUNCTION addone(i int)
RETURNS int
LANGUAGE python
RUNTIME_VERSION = '3.8'
HANDLER = 'addone_py'
AS
$$
def addone_py(i):
    return i + 1
$$;
```

### Calling the UDF
```sql
SELECT addone(5);
```

---

## UDF Output

<img width="1807" height="550" alt="image" src="https://github.com/user-attachments/assets/9778b85a-cbcd-4b3e-95f1-08eb1fe6099e" />


