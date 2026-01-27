-- Create research schema for all queries.
CREATE SCHEMA IF NOT EXISTS research;

--Main KPIs and Metrics.
-- Define highly engaged customers.ABORT
WITH engagement_thresholds AS (
    SELECT
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY time_spent_on_product_research_hours) AS high_research,
      	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY time_to_decision_in_minutes) AS high_decision_time
    FROM staging.cust_behaviour_staging
)
SELECT
    c.*
FROM staging.cust_behaviour_staging c
CROSS JOIN engagement_thresholds t
WHERE
    c.time_spent_on_product_research_hours>= t.high_research
    OR c.engagement_with_ads = 'High'
    OR c.time_to_decision_in_minutes >= t.high_decision_time;


-- Highly engaged but weakly converting customers.
WITH engaged_customers AS (
    SELECT *
    FROM staging.cust_behaviour_staging
    WHERE
        engagement_with_ads = 'High'
        OR time_spent_on_product_research_hours >= (
            SELECT PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY time_spent_on_product_research_hours)
            FROM staging.cust_behaviour_staging
        )
),
conversion_baseline AS (
    SELECT
        AVG(purchase_amount) AS avg_spend,
        AVG(frequency_of_purchase) AS avg_frequency
    FROM staging.cust_behaviour_staging
)
SELECT
    e.customer_id,
    e.time_spent_on_product_research_hours,
    e.engagement_with_ads,
    e.frequency_of_purchase,
    e.purchase_amount,
    e.time_to_decision_in_minutes,
    e.customer_satisfaction
FROM engaged_customers e
CROSS JOIN conversion_baseline b
WHERE
    e.purchase_amount < b.avg_spend
    AND e.frequency_of_purchase < b.avg_frequency;

-- Root cause analysis(Why are they not buying)
SELECT
    engagement_with_ads,
    ROUND(AVG(customer_satisfaction), 2) AS avg_satisfaction,
    ROUND(AVG(time_to_decision_in_minutes), 2) AS avg_decision_time,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM staging.cust_behaviour_staging
GROUP BY engagement_with_ads;


--Discount and Intent Mismatch
SELECT
    purchase_intent,
    discount_used,
    COUNT(*) AS customer_count,
    ROUND(AVG(purchase_amount), 2) AS avg_spend
FROM vw_customer_behavior_clean
GROUP BY purchase_intent, discount_used
ORDER BY customer_count DESC;

-- Revenue Leakage Estimate.
WITH engaged_low_conversion AS (
    SELECT
        purchase_amount
    FROM staging.cust_behaviour_staging
    WHERE
        engagement_with_ads = 'High'
        AND purchase_amount < (
            SELECT AVG(purchase_amount)
            FROM staging.cust_behaviour_staging
        )
)
SELECT
    COUNT(*) AS affected_customers,
    ROUND(SUM(purchase_amount), 2) AS current_revenue,
    ROUND(
        COUNT(*) *
        (SELECT AVG(purchase_amount) FROM staging.cust_behaviour_staging),
        2
    ) AS potential_revenue
FROM engaged_low_conversion;



