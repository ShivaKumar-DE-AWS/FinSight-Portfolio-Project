{{ config(materialized='table') }}

WITH account_metrics AS (

    SELECT
        account_id,
        COUNT(*) AS total_transactions,
        SUM(amount) AS total_transaction_amount,
        AVG(amount) AS avg_transaction_amount,
        SUM(is_fraud) AS fraud_transactions,
        MAX(transaction_timestamp) AS last_transaction_timestamp,
        MAX(velocity_24h) AS max_velocity_24h,
        MAX(risk_score) AS max_risk_score
    FROM {{ ref('fact_transactions') }}
    GROUP BY account_id

)

SELECT
    account_id,
    total_transactions,
    ROUND(total_transaction_amount, 2) AS total_transaction_amount,
    ROUND(avg_transaction_amount, 2) AS avg_transaction_amount,
    fraud_transactions,

    CASE
        WHEN fraud_transactions > 0 THEN 1
        ELSE 0
    END AS has_fraud_history,

    last_transaction_timestamp,
    max_velocity_24h,
    max_risk_score,

    CASE
        WHEN max_risk_score >= 3 THEN 'HIGH'
        WHEN max_risk_score >= 1 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS account_risk_tier

FROM account_metrics