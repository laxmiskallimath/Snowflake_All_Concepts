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
Snowflake uses a hybrid architecture combining shared-disk and shared-nothing designs.
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

### Core Components
- **C – Cloud Services Layer** (Infrastructure, Optimizer, Metadata, Security)
- **Q – Query Processing Layer** (Virtual Warehouses)
- **D – Database Storage Layer** (Centralized storage)

Snowflake’s architecture consists of:
1. Database Storage  
2. Query Processing  
3. Cloud Services

**1. Database Storage**

The Database Storage layer is the place where all Snowflake data is stored centrally. Snowflake manages everything internally, so we don’t need to take care of partitions, indexes, or file organization. All data is stored in a compressed, columnar format, and Snowflake automatically divides it into micro-partitions to improve performance.

This layer supports different types of data. Structured data is stored in tables with a fixed schema. Semi-structured formats like JSON, XML, Avro, and Parquet are also supported without needing to predefine a strict structure. Snowflake can also store unstructured files such as documents, images, and audio using the FILE data type.

Because storage is fully handled by Snowflake, we get features like Time Travel, Fail-safe protection, and zero-copy cloning without any additional setup.

**2. Compute (Virtual Warehouses)**

The Compute layer is responsible for running queries and processing data. In Snowflake, this is handled by Virtual Warehouses, which are clusters of compute resources dedicated to query execution.

Virtual Warehouses run SQL queries, Snowpark programs written in languages such as Java, Python, and Scala, and even Apache Spark workloads through Snowpark Connect for Spark. Each warehouse works independently and does not share CPU or memory with others, so one workload never interferes with another.

We can scale a warehouse up or down at any time, or start and stop it whenever needed. Since compute and storage are completely separate, we only pay for compute when the warehouse is running.

**3. Cloud Services**

The Cloud Services layer acts as the overall coordinator for everything happening inside Snowflake. It handles all activities from authentication to query optimization and dispatching. This layer runs on infrastructure managed by Snowflake across cloud providers like AWS, Azure, and GCP.

It is responsible for managing security and access control, maintaining metadata (including the SNOWFLAKE database and Information Schema), handling query parsing and optimization, and managing the Snowflake Horizon Catalog. It also covers compliance, infrastructure integration, and several built-in platform features such as data sharing, dynamic masking, and row access policies.

