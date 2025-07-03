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


----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
----------------------- 20.	What is the distribution of orders per customer? -----------------------
