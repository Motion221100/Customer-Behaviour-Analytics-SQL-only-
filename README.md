# .📊Customer-Behaviour-Analytics-SQL-only-

## Project Overview
This project analyzes customer purchasing behavior for an e-commerce company to evaluate the effectiveness of discounting strategies, customer segmentation, and revenue growth drivers. Despite high customer engagement, the business experienced flat revenue growth, prompting a deeper investigation into whether promotions were generating incremental value or eroding margins.

Using PostgreSQL, the analysis explores how discount usage, age, location, loyalty status, and purchase intent influence revenue, purchase frequency, and customer value. The project mirrors a real-world stakeholder request, translating raw transactional data into actionable business insights.

## Key Business Sub-Questions
- Are discounts driving incremental revenue or simply reducing margins? <br>
- Which customer segments respond positively to discounts?<br>
- Is the business unintentionally cannibalizing revenue from loyal or high-intent customers?<br>
- How do age and location impact revenue growth and customer value?<br>

## Analytical Approach
- Cleaned and transformed raw transaction data using Postgres SQL<br>
- Segmented customers by age, income level, loyalty membership, and discount usage<br>
- Compared discounted vs non-discounted behavior across revenue, frequency, and satisfaction<br>
- Identified cannibalization risk and low-ROI discount patterns<br>
- Quantified revenue contribution and efficiency using rates, percentages, and per-customer metrics<br>

## Tools and Technologies
-RDBMS: PGAdmin 4 version 13+(PostgreSQL).<br>
-GenAI: ChatGPT for anomly detection, code evaluation and code generation, ClaudeAI for report and drafts generation.<br>
-Github: for version control and updates.<br>
-CVS Dataset.<br>

## 📊Key Performance Indicators (KPIs) Measured
This project measures end-to-end customer value, from engagement quality to revenue efficiency and pricing effectiveness. KPIs are grouped to reflect how real analytics teams diagnose growth problems.

### 1️⃣ Engagement & Conversion Efficiency KPIs (Part 1)
These KPIs evaluate whether customer engagement translates into revenue.

#### Engagement Quality
 Highly Engaged Customer Rate<br>
  - 32.2% of customers (322 / 1,000<br>
  - Defined as top 25% research time + high ad engagement<br>

Ad Engagement Penetration
- 67% of customers actively engage with ads

Conversion Friction Indicators
- Highly engaged customers generate below-average revenue

Decision Time vs Revenue Indicator
- Longer research time correlates with:
- Lower satisfaction
- Lower purchase value

Low-Value Engagement Rate
- High research + high engagement + low spend

Funnel Health Signals

Engagement Inflation Risk
- Engagement KPIs overstate business performance

Revenue per Engaged Customer (Relative KPI)
-Lower than overall customer average

### 📌 Insight: The growth problem is not traffic or engagement — it is conversion efficiency.

2️⃣ Revenue & Pricing Effectiveness KPIs

These KPIs assess whether pricing and discounts generate incremental value.

Total Revenue

$275,064

Average Order Value (AOV)

Discounted: $273.99

Non-discounted: $276.23

0.8% AOV decline with discounts

Revenue per Customer

Discount users: $274.0

Non-discount users: $276.2

0.8% lower revenue per customer for discount users

Discount Revenue Share

51.9% of total revenue

Discount users = 52.1% of customers

📌 Insight: Discounts do not outperform full-price sales in revenue efficiency.

3️⃣ Customer Behavior & Engagement KPIs

These KPIs measure whether discounts improve customer behavior meaningfully.

Average Purchase Frequency

Discount users: 7.06

Non-discount users: 6.82

+3.4% frequency uplift

Return Rate

Discount users: 93.9%

Non-discount users: 97.1%

–3.2 percentage points

Customer Satisfaction Score

Discount users: 5.43

Non-discount users: 5.37

+1.1% improvement

📌 Insight: Engagement improves slightly, but not enough to offset margin erosion.

4️⃣ Customer Segmentation & Growth KPIs

These KPIs identify where sustainable revenue comes from.

Revenue by Age Group

25–34: 31.0%

35–44: 31.5%

Under 25: 19.5%

45–54: 18.0%

➡ 62.5% of total revenue comes from customers aged 25–44

Revenue per Customer by Age

Under 25: $282.13 (highest)

25–34: $275.04

35–44: $273.63

45–54: $270.25

📌 Insight: Growth is demographic-driven, not geographic.

5️⃣ Geographic Performance KPIs

969 unique locations

Each location contributes ~0.1–0.2% of total revenue

No geographic concentration of growth

📌 Insight: Location-based growth strategies offer minimal ROI.

6️⃣ Promotion Risk & Cannibalization KPIs

These KPIs measure margin risk.

Incremental Revenue Indicator

Revenue per customer is nearly identical between discount and non-discount users

Cannibalization Signal

Discount users ≈ customer share but underperform in revenue share

Low-ROI Promotion Rate

Frequency ↑ 3.4%

AOV ↓ 0.8%

📌 Insight: Discounts are partially cannibalizing margin rather than creating demand.

KPI-Driven Business Conclusion

Engagement metrics mask revenue leakage. Discounts improve activity, not efficiency.
Sustainable growth requires conversion optimization and targeted promotions, not more traffic or broader discounting.
