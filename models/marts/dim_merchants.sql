{{ config(materialized='table') }}

WITH merchant_metrics AS (

    SELECT
        merchant_id,
        merchant_name,
        merchant_category,
        merchant_category_bucket,
        COUNT(*) AS total_transactions,
        SUM(amount) AS total_transaction_amount,
        AVG(amount) AS avg_transaction_amount,
        SUM(is_fraud) AS fraud_transactions,
        MAX(risk_score) AS max_risk_score
    FROM {{ ref('fact_transactions') }}
    GROUP BY
        merchant_id,
        merchant_name,
        merchant_category,
        merchant_category_bucket

)

SELECT
    merchant_id,
    merchant_name,
    merchant_category,
    merchant_category_bucket,
    total_transactions,
    ROUND(total_transaction_amount, 2) AS total_transaction_amount,
    ROUND(avg_transaction_amount, 2) AS avg_transaction_amount,
    fraud_transactions,

    ROUND(
        100.0 * fraud_transactions / NULLIF(total_transactions, 0),
        2
    ) AS fraud_rate_pct,

    max_risk_score,

    CASE
        WHEN max_risk_score >= 3 THEN 'HIGH'
        WHEN max_risk_score >= 1 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS merchant_risk_tier

FROM merchant_metrics