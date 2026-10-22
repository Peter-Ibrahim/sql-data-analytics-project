-- Explore All Countries our customers come from
SELECT DISTINCT country FROM gold.dim_customers;


-- Explore all product categories
SELECT DISTINCT category FROM gold.dim_products;

-- Explore all product category, subcategory combination
SELECT DISTINCT category, subcategory FROM gold.dim_products;

SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
ORDER BY 1,2,3;