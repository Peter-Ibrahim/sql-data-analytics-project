/*
==============================================================================
Product Report
==============================================================================
Purpose:
	-This report consolidates key product metrics and behaviors

Highlights:
	1. Gathers essential fileds such as product name, category, subcategory, and cost.
	2. Segments products by revenue to identify Gigh-Performers, Mid-Range or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value (AOR)
		- average monthly revenue
==============================================================================
*/

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS
WITH base_query AS(
/*--------------------------------------------------------------
Base Query: Retrieves core columns from tables
--------------------------------------------------------------*/
	SELECT
		f.order_number,
		f.order_date,
		f.customer_key,
		f.sales_amount,
		f.quantity,
		p.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.cost
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
	WHERE f.order_date IS NOT NULL
)

, product_aggregation AS (
/*------------------------------------------------------------------------
2) Product Aggregation: Summarizes key metrics at the product level
------------------------------------------------------------------------*/
	SELECT
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT customer_key) AS total_customers,
		MAX(order_date) last_order_date,
		DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
		ROUND(AVG(CAST(sales_amount AS FLOAT)/ NULLIF(quantity,0)),1) AS avg_selling_price
	FROM base_query
		GROUP BY
		product_key,
		product_name,
		category,
		subcategory,
		cost
)

SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	total_orders,
	total_sales,
	CASE WHEN total_sales>=50000 THEN 'High-Performer'
		 WHEN total_sales >= 10000 THEN 'Mid-Range'
		 ELSE 'Low-Performer'
	END AS product_segment,
	total_quantity,
	total_customers,
	last_order_date,
	lifespan,
	avg_selling_price,
	DATEDIFF(month, last_order_date, GETDATE()) AS recency_in_months,
	-- Average Order Value
	CASE WHEN total_orders=0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_value,
	-- Average monthly revenue
	CASE WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END avg_monthly_revenue
FROM product_aggregation;