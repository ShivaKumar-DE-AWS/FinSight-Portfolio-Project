{% snapshot dim_accounts_snapshot %}

{{
    config(
        target_schema='ANALYTICS_DEV',
        unique_key='account_id',
        strategy='check',
        check_cols=[
            'total_transactions',
            'total_transaction_amount',
            'avg_transaction_amount',
            'fraud_transactions',
            'has_fraud_history',
            'max_velocity_24h',
            'max_risk_score',
            'account_risk_tier'
        ]
    )
}}

SELECT
    account_id,
    total_transactions,
    total_transaction_amount,
    avg_transaction_amount,
    fraud_transactions,
    has_fraud_history,
    last_transaction_timestamp,
    max_velocity_24h,
    max_risk_score,
    account_risk_tier

FROM {{ ref('dim_accounts') }}

{% endsnapshot %}