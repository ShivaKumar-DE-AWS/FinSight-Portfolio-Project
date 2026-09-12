{{ config(materialized='view') }}

WITH source_data AS (

    SELECT *
    FROM {{ source('finsight_raw', 'raw_transactions') }}

)

SELECT
    "transaction_id" AS transaction_id,
    "account_id" AS account_id,
    "merchant_id" AS merchant_id,
    "merchant_name" AS merchant_name,
    "merchant_category" AS merchant_category,
    "merchant_category_bucket" AS merchant_category_bucket,
    "transaction_timestamp" AS transaction_timestamp,
    "transaction_date" AS transaction_date,
    "transaction_hour" AS transaction_hour,
    "day_of_week" AS day_of_week,
    "amount" AS amount,
    "currency" AS currency,
    "location" AS location,
    "payment_method" AS payment_method,
    "velocity_24h" AS velocity_24h,
    "avg_ticket_size" AS avg_ticket_size,
    "high_value_flag" AS high_value_flag,
    "is_fraud" AS is_fraud,
    "risk_score" AS risk_score,
    "risk_tier" AS risk_tier,
    "_source_file" AS source_file,
    "_ingestion_timestamp" AS ingestion_timestamp

FROM source_data
