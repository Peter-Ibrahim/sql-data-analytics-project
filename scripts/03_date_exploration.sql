-- Find the date of the first and last order
-- How many years of sales are available
SELECT 
MIN(order_date) first_order_date,
MAX(order_date) last_order_date,
DATEDIFF(year,MIN(order_date),MAX(order_date)) AS order_range_years
FROM gold.fact_sales;


-- Find the youngest and oldest customer
SELECT
MAX(birthdate) youngest_birthdate,
DATEDIFF(year,MAX(birthdate),GETDATE()) youngest_age,
MIN(birthdate) oldest_birthdate,
DATEDIFF(year,MIN(birthdate),GETDATE()) oldest_age
FROM gold.dim_customers;