{{ config(materialized='table') }}

WITH daily_metrics AS (

    SELECT
        transaction_date,
        COUNT(*) AS total_transactions,
        SUM(amount) AS total_transaction_amount,
        SUM(is_fraud) AS fraud_transactions,

        SUM(
            CASE
                WHEN risk_tier = 'HIGH' THEN 1
                ELSE 0
            END
        ) AS high_risk_transactions,

        SUM(
            CASE
                WHEN risk_tier = 'MEDIUM' THEN 1
                ELSE 0
            END
        ) AS medium_risk_transactions,

        SUM(
            CASE
                WHEN risk_tier = 'LOW' THEN 1
                ELSE 0
            END
        ) AS low_risk_transactions,

        AVG(amount) AS avg_transaction_amount,
        AVG(risk_score) AS avg_risk_score

    FROM {{ ref('fact_transactions') }}

    GROUP BY transaction_date

)

SELECT
    transaction_date,
    total_transactions,
    ROUND(total_transaction_amount, 2) AS total_transaction_amount,
    fraud_transactions,

    ROUND(
        100.0 * fraud_transactions / NULLIF(total_transactions, 0),
        2
    ) AS fraud_rate_pct,

    high_risk_transactions,
    medium_risk_transactions,
    low_risk_transactions,

    ROUND(avg_transaction_amount, 2) AS avg_transaction_amount,
    ROUND(avg_risk_score, 2) AS avg_risk_score

FROM daily_metrics

ORDER BY transaction_date