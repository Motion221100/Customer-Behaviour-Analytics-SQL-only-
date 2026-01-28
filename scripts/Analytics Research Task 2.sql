--Revenue Impact.

SELECT
    discount_used,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(purchase_amount) AS total_revenue,
	CONCAT(ROUND((SUM(purchase_amount)/
		(SELECT SUM(purchase_amount) FROM staging.cust_behaviour_staging ))*100,0)::INTEGER, '%') AS revenue_percentage_contribution,
    AVG(purchase_amount) AS avg_order_value,
    SUM(purchase_amount)
        / COUNT(DISTINCT customer_id) AS revenue_per_customer
FROM staging.cust_behaviour_staging
GROUP BY discount_used;
--Discount users make up 52% percent of both the customer population and revenue generation(because of discounts).
--Non discount users have a better AOV even though they have 42 customers less thatn discount users.
--discount users spend less money.


--Is average purchase amount lower for discounted purchases?
SELECT
    discount_used,
    AVG(purchase_amount) AS avg_purchase_amount
FROM staging.cust_behaviour_staging
GROUP BY discount_used;
--AOV for discount users is less, even though event though they make up 52% of the population.

--Do discounts increase purchase frequency.
SELECT
    discount_used,
    AVG(frequency_of_purchase) AS avg_purchase_frequency,
	(
		Select
			AVG(frequency_of_purchase)
		FROM staging.cust_behaviour_staging	
	) AS total_avg_purchasing_frequency
FROM staging.cust_behaviour_staging
GROUP BY discount_used;
--Discounts do increase purchaseing frequency by a slight margin.


--Are discount users more likely to churn.
SELECT
    discount_used,
    AVG(return_rate) AS avg_return_rate,
	(
		Select
			AVG(return_rate)
		FROM staging.cust_behaviour_staging	
	) AS total_avg_return_rate,
    AVG(customer_satisfaction) AS avg_satisfaction
FROM staging.cust_behaviour_staging
GROUP BY discount_used;
--A Discount user is or likely to return a product(s) than a non discount user.	



-- BUSINESS CONTEXT:
-- Discounts may be essential for price-sensitive segments
-- but unnecessary for high-income customers.

SELECT
    income_level,
    discount_used,
    COUNT(DISTINCT customer_id) AS customers,
    AVG(purchase_amount) AS avg_purchase_amount,
    SUM(purchase_amount) AS total_revenue
FROM staging.cust_behaviour_staging
GROUP BY income_level, discount_used
ORDER BY income_level, discount_used;


-- BUSINESS CONTEXT:
-- If discounts mainly attract low-frequency buyers,
-- they may not be building long-term value.

SELECT
    discount_used,
    CASE
        WHEN frequency_of_purchase <= 2 THEN 'Low Frequency'
        WHEN frequency_of_purchase <= 5 THEN 'Medium Frequency'
        ELSE 'High Frequency'
    END AS customer_type,
    COUNT(*) AS customers,
    AVG(purchase_amount) AS avg_purchase_amount
FROM staging.cust_behaviour_staging
GROUP BY discount_used, customer_type
ORDER BY discount_used, customer_type;


-- BUSINESS CONTEXT:
-- Critical cannibalization check:
-- Are loyal customers buying at discounted prices unnecessarily?

SELECT
    customer_loyalty_program_member,
    discount_used,
    COUNT(DISTINCT customer_id) AS customers,
    AVG(purchase_amount) AS avg_purchase_amount,
    AVG(frequency_of_purchase) AS avg_frequency
FROM staging.cust_behaviour_staging
GROUP BY customer_loyalty_program_member, discount_used;




-- BUSINESS CONTEXT:
-- Purchase_Intent indicates readiness to buy.
-- If high-intent customers use discounts heavily,
-- the business is likely giving away margin.

SELECT
    purchase_intent,
    discount_used,
    COUNT(*) AS purchases,
    AVG(purchase_amount) AS avg_purchase_amount
FROM staging.cust_behaviour_staging
GROUP BY purchase_intent, discount_used
ORDER BY purchase_intent, discount_used;
