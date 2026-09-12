{{ config(materialized='table') }}

WITH transactions AS (

    SELECT *
    FROM {{ ref('staging_transactions') }}

)

SELECT
    transaction_id,
    account_id,
    merchant_id,
    merchant_name,
    merchant_category,
    merchant_category_bucket,
    transaction_timestamp,
    transaction_date,
    transaction_hour,
    day_of_week,
    amount,
    currency,
    location,
    payment_method,
    velocity_24h,
    avg_ticket_size,
    high_value_flag,
    is_fraud,
    risk_score,
    risk_tier,
    source_file,
    ingestion_timestamp

FROM transactions