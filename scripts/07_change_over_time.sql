-- Analyze Sales Performance over Time (year)

SELECT
YEAR(order_date) order_year,
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Analyze Sales Performance over Time (month)
SELECT
MONTH(order_date) order_month,
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY order_month;

-- Analyze Sales Performance over Time (month & year)
SELECT
YEAR(order_date) order_year,
MONTH(order_date) order_month,
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

SELECT
DATETRUNC(month,order_date) order_date,
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
ORDER BY DATETRUNC(month,order_date);

SELECT
FORMAT(order_date, 'yyyy-MM') order_date,
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY FORMAT(order_date, 'yyyy-MM');

-- How many new customers were added each year

SELECT
YEAR(create_date) AS create_year,
COUNT(customer_key) AS total_customer
FROM gold.dim_customers
GROUP BY YEAR(create_date)
ORDER BY YEAR(create_date);