SELECT *
FROM {{ ref('fact_transactions') }}
WHERE is_fraud NOT IN (0, 1)