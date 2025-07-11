----------------------- Describe Datasets -----------------------
desc ecommerce.customers;
desc ecommerce.orderdetails;
desc ecommerce.orders;
desc ecommerce.products;

----------------------- Showcase Datasets -----------------------
SELECT * FROM ecommerce.customers;
SELECT * FROM ecommerce.orderdetails;
SELECT * FROM ecommerce.orders;
SELECT * FROM ecommerce.products;

----------------------- Feature Engineering -----------------------

ALTER TABLE ecommerce.orderdetails
ADD COLUMN total_amount INT;

UPDATE ecommerce.orderdetails
SET total_amount = (quantity * price_per_unit);

ALTER TABLE ecommerce.orders
ADD COLUMN order_date_new DATE;

UPDATE ecommerce.orders
SET order_date_new = str_to_date(order_date, '%Y-%m-%d');

----------------------- 1.	What are the total number of customers in the dataset? -----------------------
SELECT COUNT(DISTINCT customer_id)
FROM ecommerce.customers;

----------------------- 2.	What is the total number of orders placed? -----------------------
SELECT COUNT(DISTINCT order_id)
FROM ecommerce.orders;

----------------------- 3.	What is the total revenue generated? -----------------------
SELECT SUM(total_amount)
FROM ecommerce.orders;

----------------------- 4.	List all unique product categories. -----------------------
SELECT distinct(category)
FROM ecommerce.products;

----------------------- 5.	What is the average order value (AOV)? -----------------------
SELECT AVG(total_amount)
FROM ecommerce.orders;

----------------------- 6.	Which customer has placed the most orders? -----------------------
SELECT customer_id, COUNT(order_id) AS NumberOfOrders
FROM ecommerce.orders
GROUP BY customer_id
ORDER BY NumberOfOrders DESC
LIMIT 1;

----------------------- 7.	What is the count of products sold per category? -----------------------
SELECT p.category, SUM(od.quantity) AS total_quantity_sold
FROM ecommerce.orderdetails od
JOIN ecommerce.products p 
ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY total_quantity_sold DESC;

----------------------- 8.	What is the most frequently purchased product? -----------------------
SELECT p.name AS ProductName, SUM(od.quantity) AS total_quantity_sold
FROM ecommerce.orderdetails od
JOIN ecommerce.products p 
ON od.product_id = p.product_id
GROUP BY ProductName
ORDER BY total_quantity_sold DESC;

----------------------- 9.	List customers from each location. -----------------------
SELECT DISTINCT(name), location
FROM ecommerce.customers
ORDER BY location DESC;

----------------------- 10.	What is the average price of products? -----------------------
SELECT p.name AS ProductName, ROUND(AVG(od.price_per_unit),2) AS AveragePrice
FROM ecommerce.orderdetails od
JOIN ecommerce.products p 
ON od.product_id = p.product_id
GROUP BY ProductName
ORDER BY AveragePrice DESC;

----------------------- 11.	List the top 5 customers by total spending. -----------------------
SELECT c.name AS Customer_Name, SUM(od.total_amount) AS TotalSpending
FROM ecommerce.orders od
JOIN ecommerce.customers c 
ON od.customer_id = c.customer_id
GROUP BY Customer_Name
ORDER BY TotalSpending DESC
LIMIT 5;

----------------------- 12.	Which product category generates the highest revenue? -----------------------
SELECT p.category, SUM(od.total_amount) AS Total_Revenue
FROM ecommerce.orderdetails od
JOIN ecommerce.products p
ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY Total_Revenue DESC
LIMIT 1;


----------------------- 13.	What is the total quantity sold per product? -----------------------
SELECT p.name as Product_Name, SUM(od.quantity) AS TotalSold
FROM ecommerce.orderdetails od
JOIN ecommerce.products p
ON od.product_id = p.product_id
GROUP BY Product_Name
ORDER BY TotalSold DESC;

----------------------- 14.	What is the revenue generated per customer location? -----------------------
SELECT c.location AS Location, SUM(od.total_amount) AS Total_Revenue
FROM ecommerce.orders od
JOIN ecommerce.customers c
ON c.customer_id = od.customer_id
GROUP BY Location
ORDER BY Total_Revenue DESC;

----------------------- 15.	Which products have never been ordered? -----------------------
SELECT p.name AS Product_Name
FROM ecommerce.orderdetails od
JOIN ecommerce.products p
ON od.product_id = p.product_id
GROUP BY Product_Name
HAVING SUM(quantity) = 0;

----------------------- 16.	What is the most recent order placed and by whom? -----------------------
SELECT c.name AS Customer_Name, max(od.order_date_new) AS Latest_Order_Date
FROM ecommerce.orders od
JOIN ecommerce.customers c
ON od.customer_id = c.customer_id
GROUP BY Customer_Name
ORDER BY Latest_Order_Date DESC;

----------------------- 17.	List products sold with an average unit price greater than ₹10000. -----------------------
SELECT p.name AS Product_Name, AVG(od.price_per_unit) AS Average_per_unit_Price
FROM ecommerce.orderdetails od
JOIN ecommerce.products p
ON od.product_id = p.product_id
GROUP BY Product_Name
HAVING AVG(od.price_per_unit) > 10000;

----------------------- 18.	Find the order with the highest total amount. -----------------------
SELECT order_id, total_amount
FROM ecommerce.orders
ORDER BY total_amount desc
LIMIT 10;

----------------------- 19.	Which day had the highest number of orders? -----------------------
SELECT COUNT(order_id) AS Counts, order_date_new
FROM ecommerce.orders
GROUP BY order_date_new
ORDER BY Counts DESC, order_date_new desc
LIMIT 5; 

----------------------- 20.	What is the distribution of orders per customer? -----------------------
SELECT c.name AS Customer_Name, COUNT(od.order_id) AS Total_Orders
FROM ecommerce.orders od
JOIN ecommerce.customers c
ON od.customer_id = c.customer_id
GROUP BY Customer_Name
ORDER BY Total_Orders DESC;

----------------------- 21.	Identify repeat customers (placed more than 1 order). -----------------------
SELECT cu.customer_id,cu.name,COUNT(o.order_id) AS total_orders
FROM ecommerce.orders o
JOIN ecommerce.customers cu ON o.customer_id = cu.customer_id
GROUP BY cu.customer_id, cu.name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

----------------------- 22.	Find products that contributed to 80% of revenue (Pareto analysis). -----------------------
SELECT p.name AS Product_Name, SUM(od.total_amount) AS Total_Sales,
	CASE
		WHEN (SUM(od.total_amount) / 19783000) THEN (SUM(od.total_amount) / 197830)
	END AS Percent_Share
FROM ecommerce.orderdetails od
JOIN ecommerce.products p
ON p.product_id = od.product_id
GROUP BY Product_Name
ORDER BY Total_Sales DESC;

----------------------- 23.	Which 5 products have the highest return on quantity sold vs revenue? -----------------------
SELECT 
    p.product_id,
    p.name,
    SUM(od.quantity) AS total_quantity,
    SUM(od.total_amount) AS total_revenue,
    SUM(od.total_amount) / SUM(od.quantity) AS revenue_per_unit
FROM ecommerce.orderdetails od
JOIN ecommerce.products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY revenue_per_unit DESC
LIMIT 5;

----------------------- 24.	List customers whose average order value is above the overall AOV. -----------------------
WITH customer_avg AS (
    SELECT customer_id, AVG(total_amount) AS avg_order_value
    FROM ecommerce.orders
    GROUP BY customer_id
),
overall_avg AS (
    SELECT AVG(total_amount) AS overall_avg_value
    FROM ecommerce.orders
)
SELECT c.customer_id, cu.name, c.avg_order_value
FROM customer_avg c
JOIN ecommerce.customers cu ON cu.customer_id = c.customer_id,
     overall_avg o
WHERE c.avg_order_value > o.overall_avg_value;


----------------------- 25.	Which location has the highest customer order frequency? -----------------------
SELECT cu.location, COUNT(o.order_id) AS total_orders
FROM ecommerce.orders o
JOIN ecommerce.customers cu ON o.customer_id = cu.customer_id
GROUP BY cu.location
ORDER BY total_orders DESC
LIMIT 1;


----------------------- 26.	Compare revenue trends month-over-month. -----------------------
SELECT 
    DATE_FORMAT(order_date_new, '%Y-%m') AS month,
    SUM(total_amount) AS total_revenue
FROM ecommerce.orders
GROUP BY month
ORDER BY month;

----------------------- 27.	Find the top 3 products by revenue in each category. -----------------------
SELECT *
FROM (
    SELECT 
        p.category,
        p.name AS product_name,
        SUM(od.total_amount) AS revenue,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(od.total_amount) DESC) AS rnk
    FROM ecommerce.orderdetails od
    JOIN ecommerce.products p ON od.product_id = p.product_id
    GROUP BY p.category, p.name
) ranked
WHERE rnk <= 3;


----------------------- 28.	What is the customer retention rate month-over-month? -----------------------
WITH first_orders AS (
    SELECT customer_id, MIN(order_date_new) AS first_order_date
    FROM ecommerce.orders
    GROUP BY customer_id
),
monthly_customers AS (
    SELECT DISTINCT customer_id, DATE_FORMAT(order_date_new, '%Y-%m') AS order_month
    FROM ecommerce.orders
),
retention_base AS (
    SELECT 
        DATE_FORMAT(first_order_date, '%Y-%m') AS cohort_month,
        order_month,
        COUNT(DISTINCT mc.customer_id) AS retained_customers
    FROM first_orders fo
    JOIN monthly_customers mc ON fo.customer_id = mc.customer_id
    GROUP BY cohort_month, order_month
)
SELECT * FROM retention_base
ORDER BY cohort_month, order_month;

----------------------- 29.	Find orders where more than 3 products were purchased. -----------------------
SELECT order_id
FROM ecommerce.orderdetails
GROUP BY order_id
HAVING COUNT(product_id) > 3;


----------------------- 30.	What’s the average order quantity for each category? -----------------------
SELECT 
    p.category,
    AVG(od.quantity) AS avg_quantity
FROM ecommerce.orderdetails od
JOIN ecommerce.products p ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY avg_quantity DESC;


----------------------- 31.	Identify the first product ordered by each customer. -----------------------
SELECT o.customer_id, c.name AS customer_name , p.name AS product_name, o.order_date_new
FROM ecommerce.orders o
JOIN ecommerce.orderdetails od ON o.order_id = od.order_id
JOIN ecommerce.products p ON od.product_id = p.product_id
JOIN ecommerce.customers c ON o.customer_id = c.customer_id
WHERE o.order_date_new = (
    SELECT MIN(o2.order_date_new)
    FROM ecommerce.orders o2
    WHERE o2.customer_id = o.customer_id
)
ORDER BY o.customer_id, o.order_date_new;


----------------------- 32.	List the top 3 selling products in each month. -----------------------
SELECT *
FROM (
    SELECT 
        DATE_FORMAT(o.order_date_new, '%Y-%m') AS order_month,
        p.name AS product_name,
        SUM(od.quantity) AS total_sold,
        RANK() OVER (PARTITION BY DATE_FORMAT(o.order_date_new, '%Y-%m') ORDER BY SUM(od.quantity) DESC) AS rnk
    FROM ecommerce.orders o
    JOIN ecommerce.orderdetails od ON o.order_id = od.order_id
    JOIN ecommerce.products p ON od.product_id = p.product_id
    GROUP BY order_month, product_name
) ranked
WHERE rnk <= 3;

----------------------- 33.	Find month-over-month revenue growth. -----------------------
WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(order_date_new, '%Y-%m') AS month,
        SUM(total_amount) AS revenue
    FROM ecommerce.orders
    GROUP BY month
),
growth AS (
    SELECT 
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT 
    month,
    revenue,
    previous_month_revenue,
    ROUND(((revenue - previous_month_revenue) / previous_month_revenue) * 100, 2) AS revenue_growth_percent
FROM growth
WHERE previous_month_revenue IS NOT NULL;


----------------------- 34.	Determine customer lifetime value (CLTV) by summing all order totals. -----------------------
SELECT 
    cu.customer_id,
    cu.name,
    SUM(o.total_amount) AS customer_lifetime_value
FROM ecommerce.orders o
JOIN ecommerce.customers cu ON o.customer_id = cu.customer_id
GROUP BY cu.customer_id, cu.name
ORDER BY customer_lifetime_value DESC;


----------------------- 35.	Identify customers who haven't ordered in the last 3 months. -----------------------
SELECT cu.customer_id, cu.name
FROM ecommerce.customers cu
JOIN ecommerce.orders o ON cu.customer_id = o.customer_id
GROUP BY cu.customer_id, cu.name
HAVING MAX(o.order_date_new) < CURDATE() - INTERVAL 3 MONTH;


----------------------- 36.	What is the average number of days between two purchases for each customer? -----------------------
WITH ranked_orders AS (
    SELECT 
        customer_id,
        order_date_new,
        LAG(order_date_new) OVER (PARTITION BY customer_id ORDER BY order_date_new) AS previous_order
    FROM ecommerce.orders
),
diffs AS (
    SELECT customer_id, DATEDIFF(order_date_new, previous_order) AS days_diff
    FROM ranked_orders
    WHERE previous_order IS NOT NULL
)
SELECT customer_id, AVG(days_diff) AS avg_days_between_orders
FROM diffs
GROUP BY customer_id;

----------------------- 37.	Flag high-value orders (top 5% based on total_amount). -----------------------
SELECT *
FROM ecommerce.orders
WHERE total_amount > (
    SELECT 
        total_amount
    FROM (
        SELECT 
            total_amount,
            NTILE(20) OVER (ORDER BY total_amount) AS percentile_bucket
        FROM ecommerce.orders
    ) ranked
    WHERE percentile_bucket = 19
    ORDER BY total_amount
    LIMIT 1
);


----------------------- 38.	Find the trend of average product prices over time. -----------------------
SELECT 
    DATE_FORMAT(o.order_date_new, '%Y-%m') AS month,
    AVG(od.price_per_unit) AS avg_product_price
FROM ecommerce.orders o
JOIN ecommerce.orderdetails od ON o.order_id = od.order_id
GROUP BY month
ORDER BY month;

----------------------- 39.	Identify top 5 customers contributing to 50% of revenue. -----------------------
WITH revenue_per_customer AS (
    SELECT customer_id, SUM(total_amount) AS total_revenue
    FROM ecommerce.orders
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT *,
           SUM(total_revenue) OVER (ORDER BY total_revenue DESC) AS running_total,
           SUM(total_revenue) OVER () AS overall_total
    FROM revenue_per_customer
)
SELECT rc.customer_id, cu.name, rc.total_revenue
FROM ranked_customers rc
JOIN ecommerce.customers cu ON rc.customer_id = cu.customer_id
WHERE running_total <= 0.5 * overall_total;

----------------------- 40.	Rank customers by total quantity of products purchased. -----------------------
SELECT 
    cu.customer_id,
    cu.name,
    SUM(od.quantity) AS total_quantity,
    RANK() OVER (ORDER BY SUM(od.quantity) DESC) AS customer_rank
FROM ecommerce.orders o
JOIN ecommerce.orderdetails od ON o.order_id = od.order_id
JOIN ecommerce.customers cu ON o.customer_id = cu.customer_id
GROUP BY cu.customer_id, cu.name
ORDER BY customer_rank;

----------------------- 41.	Calculate the average basket size (number of products per order). -----------------------
SELECT ROUND(AVG(product_count), 2) AS avg_basket_size
FROM ( SELECT order_id, COUNT(product_id) AS product_count
		FROM ecommerce.orderdetails
		GROUP BY order_id
) AS order_product_counts;

----------------------- 42.	Detect pricing anomalies — products whose unit price in an order deviates from the catalog price. -----------------------
SELECT 
    od.order_id,
    od.product_id,
    p.name AS product_name,
    p.price AS catalog_price,
    od.price_per_unit AS order_price,
    ABS(od.price_per_unit - p.price) AS price_difference
FROM ecommerce.orderdetails od
JOIN ecommerce.products p ON od.product_id = p.product_id
WHERE od.price_per_unit != p.price
ORDER BY price_difference DESC;

----------------------- 43.	Determine the best-selling product mix per region. -----------------------
SELECT 
    cu.location,
    p.category,
    p.name AS product_name,
    SUM(od.quantity) AS total_sold
FROM ecommerce.orders o
JOIN ecommerce.customers cu ON o.customer_id = cu.customer_id
JOIN ecommerce.orderdetails od ON o.order_id = od.order_id
JOIN ecommerce.products p ON od.product_id = p.product_id
GROUP BY cu.location, p.category, p.name
ORDER BY cu.location, p.category, total_sold DESC;

----------------------- 44.	Build a RFM (Recency, Frequency, Monetary) segmentation model using available tables. -----------------------
WITH rfm AS (
    SELECT 
        o.customer_id,
        MAX(DATEDIFF(CURDATE(), order_date_new)) AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(o.total_amount) AS monetary
    FROM ecommerce.orders o
    GROUP BY o.customer_id
)
SELECT 
    r.customer_id,
    cu.name,
    r.recency,
    r.frequency,
    r.monetary,
    CASE 
        WHEN r.recency <= 30 THEN 'Recent'
        WHEN r.recency <= 90 THEN 'Warm'
        ELSE 'Cold'
    END AS recency_segment,
    CASE 
        WHEN r.frequency >= 5 THEN 'Frequent'
        WHEN r.frequency >= 2 THEN 'Occasional'
        ELSE 'Rare'
    END AS frequency_segment,
    CASE 
        WHEN r.monetary >= 100000 THEN 'High Value'
        WHEN r.monetary >= 50000 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS monetary_segment
FROM rfm r
JOIN ecommerce.customers cu ON r.customer_id = cu.customer_id;

----------------------- 45.	Forecast next month's revenue using trailing 3-month average. -----------------------
WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(order_date_new, '%Y-%m') AS revenue_month,
        SUM(total_amount) AS revenue
    FROM ecommerce.orders
    GROUP BY revenue_month
),
forecast AS (
    SELECT 
        revenue_month,
        revenue,
        ROUND(AVG(revenue) OVER (
            ORDER BY revenue_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2) AS trailing_3mo_avg
    FROM monthly_revenue
)
SELECT * 
FROM forecast
ORDER BY revenue_month;

