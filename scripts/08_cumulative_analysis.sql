-- Cumulative Analysis
-- Calculate the total sales per month
-- moving average of price
-- and the running total of sales over time
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) running_total_sales,
AVG(avg_price) OVER(ORDER BY order_date) moving_average_price
FROM
(
	SELECT
	DATETRUNC(month,order_date) AS order_date,
	SUM(sales_amount) total_sales,
	AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month,order_date)
	)t;

-- Calculate the total sales per month of each year
-- and the running total of sales over time
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) running_total_sales
FROM
(
	SELECT
	DATETRUNC(month,order_date) AS order_date,
	SUM(sales_amount) total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month,order_date)
	)t;

-- Cumulative metric over the years
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) running_total_sales
FROM
(
	SELECT
	DATETRUNC(year,order_date) AS order_date,
	SUM(sales_amount) total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(year,order_date)
	)t;
