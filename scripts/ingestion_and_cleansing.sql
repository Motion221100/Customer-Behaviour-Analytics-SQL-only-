SET search_path TO staging;

-- 2. Create ENUM types
CREATE TYPE INCOME AS ENUM ('Middle', 'High');
CREATE TYPE MARITAL AS ENUM ('Married', 'Single', 'Divorced', 'Widowed');
CREATE TYPE EDUCATION AS ENUM ('Bachelor''s', 'High School', 'Master''s');
CREATE TYPE OCCUPATION AS ENUM ('Middle', 'High', 'Low');
CREATE TYPE CHANNEL AS ENUM ('In-Store', 'Online', 'Mixed');
CREATE TYPE INFLUENCE AS ENUM ('None','Low', 'High', 'Medium');
CREATE TYPE SENSITIVITY AS ENUM ('Not Sensitive', 'Somewhat Sensitive', 'Very Sensitive');
CREATE TYPE ADS AS ENUM ('None', 'Low', 'Medium', 'High');
CREATE TYPE DEVICE AS ENUM ('Tablet', 'Smartphone', 'Desktop');
CREATE TYPE PAYMENT AS ENUM ('Other', 'Credit Card', 'Debit Card', 'PayPal', 'Cash');
CREATE TYPE INTENT AS ENUM ('Planned', 'Impulsive', 'Wants-based', 'Need-based');
CREATE TYPE SHIPPING AS ENUM ('No Preference', 'Standard', 'Express');

-- 3. Create table
CREATE TABLE staging.cust_behaviour_staging (
    customer_id            VARCHAR(25) PRIMARY KEY,
    age                    INT,
    gender                 VARCHAR(20),
    income_level           INCOME,
    marital_status         MARITAL,
    education_level        EDUCATION,
    occupation             OCCUPATION,
    location               VARCHAR(255),
    purchase_category      VARCHAR(255),
    purchase_amount        DECIMAL(8,2),
    frequency_of_purchase  SMALLINT,
    purchase_channel       CHANNEL,
    brand_loyalty          SMALLINT,
    product_rating         SMALLINT,
    time_spent_on_product_research_hours DECIMAL(3, 1),
    social_media_influence INFLUENCE,
    discount_sensitivity   SENSITIVITY,
    return_rate            SMALLINT,
    customer_satisfaction  SMALLINT,
    engagement_with_ads    ADS,
    device_used_for_shopping DEVICE,
    payment_method         PAYMENT,
    time_of_purchase       VARCHAR(15),
    discount_used          BOOLEAN,
    customer_loyalty_program_member BOOLEAN,
    purchase_intent        INTENT,
    shipping_preference    SHIPPING,
    time_to_decision_in_minutes SMALLINT
);

-- 4. Insert data from raw table with casting
INSERT INTO staging.cust_behaviour_staging (
    customer_id,
    age,
    gender,
    income_level,
    marital_status,
    education_level,
    occupation,
    location,
    purchase_category,
    purchase_amount,
    frequency_of_purchase,
    purchase_channel,
    brand_loyalty,
    product_rating,
    time_spent_on_product_research_hours,
    social_media_influence,
    discount_sensitivity,
    return_rate,
    customer_satisfaction,
    engagement_with_ads,
    device_used_for_shopping,
    payment_method,
    time_of_purchase,
    discount_used,
    customer_loyalty_program_member,
    purchase_intent,
    shipping_preference,
    time_to_decision_in_minutes
)
SELECT
    customer_id,
    CAST(age AS INT),
    CAST(gender AS VARCHAR(20)),
    CAST(income_level AS INCOME),
    CAST(marital_status AS MARITAL),
    CAST(education_level AS EDUCATION),
    CAST(occupation AS OCCUPATION),
    location,
    purchase_category,
    CAST(SUBSTRING(purchase_amount, 2) AS DECIMAL(8,2)), -- strip currency symbol
    CAST(frequency_of_purchase AS SMALLINT),
    CAST(purchase_channel AS CHANNEL),
    CAST(brand_loyalty AS SMALLINT),
    CAST(product_rating AS SMALLINT),
    CAST(time_spent_on_product_research_hours AS DECIMAL(3, 1)),
    CAST(social_media_influence AS INFLUENCE),
    CAST(discount_sensitivity AS SENSITIVITY),
    CAST(return_rate AS SMALLINT),
    CAST(customer_satisfaction AS SMALLINT),
    CAST(engagement_with_ads AS ADS),
    CAST(device_used_for_shopping AS DEVICE),
    CAST(payment_method AS PAYMENT),
    time_of_purchase,
    CAST(discount_used AS BOOLEAN),
    CAST(customer_loyalty_program_member AS BOOLEAN),
    CAST(purchase_intent AS INTENT),
    CAST(shipping_preference AS SHIPPING),
    CAST(time_to_decision AS SMALLINT)
FROM staging.cust_behaviour_raw;

-- change time of purchase to date type.
UPDATE staging.cust_behaviour_staging
SET time_of_purchase = TO_DATE(time_of_purchase, 'MM-DD-YYYY');

ALTER TABLE staging.cust_behaviour_staging
ALTER COLUMN time_of_purchase TYPE DATE
USING time_of_purchase::date


-- 2. Convert empty numeric values to NULL
UPDATE staging.cust_behaviour_staging
SET
    age = NULLIF(age, 0),
    purchase_amount = NULLIF(purchase_amount, 0),
    frequency_of_purchase = NULLIF(frequency_of_purchase, 0),
    brand_loyalty = NULLIF(brand_loyalty, 0),
    product_rating = NULLIF(product_rating, 0),
    time_spent_on_product_research_hours = NULLIF(time_spent_on_product_research_hours, 0),
    return_rate = NULLIF(return_rate, 0),
    customer_satisfaction = NULLIF(customer_satisfaction, 0),
    time_to_decision_in_minutes = NULLIF(time_to_decision_in_minutes, 0);

-- 3. Remove duplicate records based on customer_id
DELETE FROM staging.cust_behaviour_staging a
USING staging.cust_behaviour_staging b
WHERE a.ctid < b.ctid
  AND a.customer_id = b.customer_id;

