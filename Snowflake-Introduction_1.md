# What is Snowflake?

Snowflake is a cloud-based data warehousing and analytics solution that runs on AWS, Microsoft Azure, and Google Cloud. It is offered as a fully managed SaaS platform, meaning there is no need for hardware or software installation, configuration, or ongoing maintenance. Snowflake enables fast, flexible, and scalable data storage, processing, and analytics. It includes built‑in security features such as end‑to‑end encryption for data in transit and at rest.

---

## On-Premise Data Warehouse vs Cloud Data Warehouse

### Simple Analogy
- **Buying a Car → On-Premise Database** (MySQL, SQL Server, Oracle)  
  You own the full setup and infrastructure, with high upfront and maintenance costs.

- **Renting a Car → Cloud Data Warehouse** (AWS, Azure, GCP)  
  You use cloud infrastructure without owning it and pay for usage during the rental period.

- **Pay Per Trip → Serverless Cloud (Snowflake)**  
  You pay only for each trip (query/job), no continuous cost when not in use.

### On-Premise
- High upfront cost
- High maintenance cost
- Dedicated team required
- Tight control over security & compliance

### Serverless Snowflake
- No upfront cost
- Almost zero maintenance
- Pay-as-you-go model

---

## Challenges With Traditional Databases
- Handle only structured data
- Performance issues with large datasets
- Heavy maintenance (backup, restore, patching, security, memory, workloads)

---

## Why Snowflake?
- Fully managed SaaS-based analytical data warehouse
- Faster, easy to use, and more flexible than traditional systems
- Runs on cloud infrastructure (AWS, Azure, GCP)
- Pay only for what is used
- Separate compute and storage billing
- No infrastructure setup (hardware/software)
- Supports semi-structured data (JSON, Parquet, Avro)
- Zero-copy cloning
- Data protection with Time Travel (1–90 days) & Fail-safe
- Columnar storage
- Automatic micro-partitioning

---

## Snowflake Differentiators
- **Infrastructure:** Easy-to-use SaaS service
- **Scalability:** Highly scalable compute clusters
- **Data Backup:** Zero-copy cloning without extra cost
- **Data Recovery:** Time Travel feature
- **Data Sharing:** Built-in secure data sharing
- **Data Security:** Dynamic Data Masking and Row Access Policies

---

## Snowflake Architecture
Snowflake’s architecture is a hybrid of traditional shared-disk and shared-nothing database architectures.
Like shared-disk systems, Snowflake uses a central data repository accessible to all compute nodes.
Like shared-nothing systems, Snowflake uses MPP compute clusters, where each node works on part of the data.
This hybrid model gives Snowflake the simplicity of shared-disk + performance and scale-out power of shared-nothing.

### Shared-Disk
- Central data repository accessible by all compute nodes

### Shared-Nothing
- Query processing through MPP clusters
- Each node works on a portion of data

This hybrid model offers simplicity of shared-disk systems plus the performance
and scalability of shared-nothing systems.

Think of Snowflake like this: we have VW1 and VW2. Query 1 runs on VW1 and Query 2 runs on VW2. Both queries read the same data from Snowflake’s central storage, but they use separate compute, so they never disturb each other. VW1 and VW2 work independently, but the data they use is still the same. Compute is independent, storage is shared.

Snowflake uses a simple three layer architecture:

- **Cloud Services Layer(C):** Manages security, metadata, optimization, and system operations.
- **Query Processing Layer(Q):** Uses Virtual Warehouses for compute and processing.
- **Database Storage Layer(D):** Stores and manages all data in a centralized location.

**1. Database Storage**

The Database Storage layer is where all Snowflake data is stored in one central place. Snowflake manages everything on its own, so we do not have to worry about partitions, indexes, or file layouts. Data is stored in a compressed, columnar format, and Snowflake automatically organizes it into micro partitions to improve performance.

This layer supports multiple data types. Structured data is stored in tables with a defined schema. Semi structured data like JSON, XML, Avro, and Parquet is supported without needing to set a strict structure. Snowflake can also store unstructured files such as documents, images, and audio using the FILE data type.

Because Snowflake handles all storage internally, we get features like Time Travel, Fail Safe protection, and zero copy cloning without extra configuration.

**2. Compute (Virtual Warehouses)**

The Compute layer is responsible for running queries and processing data. In Snowflake, this work is done by Virtual Warehouses, which are clusters of compute resources dedicated to executing workloads.

Virtual Warehouses can run SQL queries, Snowpark programs written in Java, Python, or Scala, and even Apache Spark workloads through Snowpark Connect for Spark. Each warehouse operates independently and does not share CPU or memory with others, so workloads never impact each other.

We can scale a warehouse up or down at any time, or start and stop it when needed. Since compute is separate from storage, we only pay for the warehouse when it is running.

**3. Cloud Services**

The Cloud Services layer acts like the central coordinator for Snowflake. It manages everything from authentication to query optimization. This layer runs on Snowflake managed infrastructure across cloud providers like AWS, Azure, and GCP.

It handles security and access control, manages metadata (including the SNOWFLAKE database and Information Schema), performs query parsing and optimization, and coordinates the Snowflake Horizon catalog. It also supports platform features such as data sharing, dynamic masking, and row access policies, along with compliance and integration across the cloud environment.
