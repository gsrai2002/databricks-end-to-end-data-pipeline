# End-to-End Databricks Data Pipeline (Bronze–Silver–Gold)

## Overview
This project implements an end-to-end data engineering pipeline on Databricks using Delta Lake and the Bronze–Silver–Gold (Medallion) architecture.

The pipeline simulates an enterprise batch ingestion workflow and demonstrates incremental processing, idempotent writes, data quality enforcement, and analytics-ready aggregations. It mirrors real-world data pipelines used for automated reporting, management dashboards, and compliance use cases.

---

## Architecture
The pipeline is designed using three logical layers:

### Bronze Layer
- Raw batch ingestion of transaction data
- Append-only Delta tables
- Ingestion metadata for traceability (`ingestion_date`, `load_timestamp`)
- Preserves raw data for auditability

### Silver Layer
- Data validation and schema enforcement
- Deduplication logic
- Incremental processing using a high-watermark control table
- Idempotent writes using Delta Lake MERGE
- Separate handling of rejected records

### Gold Layer
- Business-ready aggregated tables
- Incremental aggregations
- Supports late-arriving data through MERGE-based updates
- Optimized for analytics and BI consumption

---

## Tech Stack
- Databricks
- Apache Spark (PySpark)
- Delta Lake
- SQL
- Databricks Jobs (orchestration)

---

## Data Flow
1. Batch transaction data is ingested into the Bronze layer with ingestion metadata.
2. Silver layer applies data quality checks, deduplication, and incremental logic.
3. Gold layer generates aggregated business metrics.
4. The entire pipeline is orchestrated using Databricks Jobs with task dependencies and scheduling.

---

## Incremental Processing & Idempotency
- High-watermark control tables track the last processed date.
- Only new data is processed on each run.
- Delta Lake MERGE operations ensure safe re-runs without duplicate data.
- Silver layer preserves immutable cleaned facts.
- Gold layer supports updates for late-arriving data.

---

## Gold Tables
- `daily_transaction_metrics`
  - Daily transaction counts and amounts by currency
- `partner_daily_summary`
  - Partner-level daily metrics

These tables are designed for direct consumption by BI tools such as Power BI.

---

## Orchestration
The pipeline is operationalized using a Databricks Job with:
- Task dependencies (Bronze → Silver → Gold)
- Daily scheduling
- Retry logic
- Failure notifications

A sample job configuration is included in the `jobs/` directory.

---

## Repository Structure
databricks-end-to-end-data-pipeline/
├── notebooks/
│ ├── 01_bronze_ingestion.ipynb
│ ├── 02_silver_incremental_processing.ipynb
│ ├── 03_gold_aggregation.ipynb
├── sql/
│ ├── create_schemas.sql
│ ├── create_tables.sql
├── jobs/
│ └── transactions_data_pipeline_job.json
├── architecture/
│ └── pipeline_architecture.png
└── README.md

---

## Notes
- This project uses simulated batch data to demonstrate production-grade data engineering patterns.
- The design can be extended to cloud storage systems such as ADLS or S3 and enterprise governance tools such as Unity Catalog.
