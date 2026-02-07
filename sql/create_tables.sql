-- Databricks notebook source
CREATE TABLE IF NOT EXISTS workspace.bronze_db.transactions_raw (
    transaction_id STRING,
    transaction_date DATE,
    partner_id STRING,
    amount DOUBLE,
    currency_code STRING,
    transaction_status STRING,
    source_system STRING,
    ingestion_date DATE,
    load_timestamp TIMESTAMP
)
USING DELTA;

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS silver_db.transactions_clean (
    transaction_id STRING,
    transaction_date DATE,
    partner_id STRING,
    amount DOUBLE,
    currency_code STRING,
    transaction_status STRING,
    source_system STRING,
    ingestion_date DATE,
    load_timestamp TIMESTAMP
)
USING DELTA;

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS silver_db.transactions_rejected (
    transaction_id STRING,
    transaction_date DATE,
    partner_id STRING,
    amount DOUBLE,
    currency_code STRING,
    transaction_status STRING,
    source_system STRING,
    ingestion_date DATE,
    load_timestamp TIMESTAMP,
    rejection_reason STRING
)
USING DELTA;

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS silver_db.pipeline_control (
    pipeline_name STRING,
    last_processed_date DATE,
    updated_at TIMESTAMP
)
USING DELTA;

INSERT INTO silver_db.pipeline_control
SELECT
    'transactions_pipeline',
    DATE('1900-01-01'),
    current_timestamp();

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS gold_db.daily_transaction_metrics (
    transaction_date DATE,
    currency_code STRING,
    total_transactions BIGINT,
    successful_transactions BIGINT,
    failed_transactions BIGINT,
    total_amount DOUBLE,
    success_amount DOUBLE
)
USING DELTA;

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS gold_db.partner_daily_summary (
    transaction_date DATE,
    partner_id STRING,
    total_transactions BIGINT,
    successful_transactions BIGINT,
    total_amount DOUBLE
)
USING DELTA;

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS gold_db.pipeline_control (
    pipeline_name STRING,
    last_processed_date DATE,
    updated_at TIMESTAMP
)
USING DELTA;

INSERT INTO gold_db.pipeline_control
SELECT
    'gold_aggregation_pipeline',
    DATE('1900-01-01'),
    current_timestamp();
