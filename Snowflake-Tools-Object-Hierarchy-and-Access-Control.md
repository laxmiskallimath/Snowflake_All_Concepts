# Snowflake Tools
1. Snowsight : The Snowflake web user interface(UI) for interacting with data.Snowsight provides a unified experience for working with Snowflake data by using SQL or Python.

2. SnowSQL (CLI client): SnowSQL is Snowflake’s command line client for connecting to Snowflake and executing SQL queries (DML, DDL), data loading, and more, while the Snowflake CLI is an open source, developer focused command line tool designed for broader workloads beyond SQL operations.

3. Snowflake Connectors and Drivers:Tools for connecting to Snowflake from various programming languages and environments.

4. Snowpark : Snowpark is a unified platform that provides libraries and runtimes for securely deploying and processing Python, Java, and Scala code inside Snowflake, enabling users to build data pipelines, machine learning models, and applications without moving data out of Snowflake. 
The Snowpark API offers an intuitive DataFrame based library for querying and processing data at scale using these languages,
leveraging Snowflake’s elastic and serverless engine for computation.

5. SnowCD (Connectivity Diagnostic Tool): SnowCD (i.e. Snowflake Connectivity Diagnostic Tool) helps users to diagnose and troubleshoot their network connection to Snowflake.SnowCD leverages the Snowflake hostname IP addresses and ports listed by either the SYSTEM$ALLOWLIST() or SYSTEM$ALLOWLIST_PRIVATELINK() functions to run a series of connection checks to evaluate and help troubleshoot the network connection to Snowflake.

# Snowflake Objects Hierarchy

## Securable objects
Every securable object resides within a logical container in a hierarchy of containers.Each level controls how objects are created, managed and secured.

The top-most container is the customer organization. 

Securable objects such as tables, views, functions, and stages are contained in a schema object, which are in turn contained in a database. 

All databases for our Snowflake account are contained in the account object.

```
                    Organization
                          |
                       Account
        ------------------------------------------------
        |                    |                     |
      User                 Role              Virtual Warehouse
        |                    |                     |
        ------------------------------------------------
                          |
                       Database
                          |
                       Schema
 -------------------------------------------------------------------
 |            |            |               |              |         |
Table        View        Stage     Stored Procedure       UDF   Other Objects
```

## Organization
An organization is the top level in Snowflake. It can contain multiple Snowflake accounts that belong to the same company. For example, separate accounts may be used for development, testing or production.

## Account
A Snowflake account is the main administrative boundary. It contains users, roles, warehouses, databases and other account level objects. Access control and resource management operate at the account level.

## Users, Roles and Warehouses
Users represent individual identities.
Roles define access privileges.
Virtual warehouses provide compute resources for executing queries and performing data loading or transformation tasks.

## Database
A database is a logical collection of schemas used for organizing data. An account can have many databases to separate applications, environments or departments.

## Schema
A schema exists inside a database. It is used to logically organize related objects such as tables, views, stages and procedures. A database may contain multiple schemas for grouping objects by project or domain.

## Schema Objects
Schema level objects include tables, views, external and internal stages, stored procedures, user defined functions and other objects used for storing or processing data.

## Object Limits
Snowflake does not impose fixed limits on the number of databases, schemas or objects that can be created within an account.
The hierarchy is designed to scale with organizational needs.

# Overview of Snowflake Access Control
Snowflake uses a role-based access control model. All permissions are granted to roles, and users receive access by being assigned to roles.This design allows scalable, secure and manageable access control across databases, schemas and warehouses.

## Access control framework
Snowflake’s approach to access control combines aspects from the following models:

Discretionary Access Control (DAC): Each object has an owner, who can in turn grant access to that object.

Role-based Access Control (RBAC): Access privileges are assigned to roles, which are in turn assigned to users.

User-based Access Control (UBAC): Access privileges are assigned directly to users. Access control considers privileges assigned directly to users only when USE SECONDARY ROLE is set to ALL.

### Key Concepts
Securable object: An entity to which access can be granted. Unless allowed by a grant, access is denied.
Role: An entity to which privileges can be granted.
Privilege: A defined level of access to an object.
User: A user identity recognized by Snowflake.

Privileges are managed using:
```
GRANT <privileges> … TO ROLE
REVOKE <privileges> … FROM ROLE
GRANT <privileges> … TO USER
REVOKE <privileges> … FROM USER
```

# System Defined Roles

## ORGADMIN (Organization Administrator)
Role at the organization level.
Can create accounts inside the organization such as development, test or production accounts.
Can view all accounts within the organization.
Can view usage information across the organization.

## ACCOUNTADMIN (Account Administrator)
Top level role within an account.
Can view and manage account-level information such as usage, billing, roles, users and sessions.
Should be assigned to only a limited number of users.
Can enable multi factor authentication.
Includes the SYSADMIN and SECURITYADMIN roles.

## SECURITYADMIN (Security Administrator)
Used for user, role and custom role creation based on Snowflake best practices.
Responsible for assigning custom roles to users.
Can manage object grants across the account.
Inherits all privileges of USERADMIN.

## USERADMIN (User and Role Administrator)
Responsible for managing users and roles.
Handles tasks such as creating users, resetting passwords and managing sessions.
Can manage and monitor roles including modifying or revoking assignments.

## SYSADMIN (System Administrator)
Used to create warehouses, databases, schemas and other objects.
Can grant privileges on warehouses and databases to other roles.
Recommended as the parent role for all custom roles created inside an account.

## PUBLIC
Role automatically assigned to all users.
Objects owned by this role are accessible to every user in the account.
Useful when explicit access control is not required.

# Custom Roles
Custom roles are created based on functional requirements of teams or departments.
Roles can be grouped into hierarchies where higher roles inherit privileges from lower ones.

### Example workflow
```
CREATE ROLE data_analyst;
GRANT USAGE ON WAREHOUSE compute_wh TO ROLE data_analyst;
GRANT SELECT ON DATABASE mydb TO ROLE data_analyst;

CREATE USER user1;
GRANT ROLE data_analyst TO USER user1;

CREATE ROLE data_scientist;
GRANT WRITE ON DATABASE mydb TO ROLE data_scientist;

CREATE USER user2;
GRANT ROLE data_scientist TO USER user2;

GRANT ROLE data_analyst TO ROLE data_scientist;

```

# Role Hierarchy and Privilege Inheritance
Snowflake recommends building a hierarchy of custom roles.
The topmost custom role is assigned to SYSADMIN.
This allows SYSADMIN to manage all objects created within the account.

A typical hierarchy:
```
ACCOUNTADMIN
     |
--------------------------------
|                              |
SECURITYADMIN               SYSADMIN
     |                          |
USERADMIN                 Custom Role (Top)
                              |
                        Custom Role
                              |
                        Custom Role
                              |
                            PUBLIC
```

Role hierarchy enables privilege inheritance.
Higher-level roles automatically inherit privileges from roles below them.
This simplifies permission management across environments.
