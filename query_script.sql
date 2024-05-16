USE ecommerce;

-- Query 1 [Low] (A.Dung)
-- Query 2 [Low] (A.Dung)
-- Query 3 [Low] (A.Dung)


-- Query 4  Customer's Orders Count (Vi)
-- SELECT customer ID, full name (by concatenating their first name and last name), email and total orders of each customer
-- Order the results by order count, in descending order

SELECT		dbo.customer.customer_id,
			dbo.customer.first_name +  ' ' + dbo.customer.last_name AS full_name,
			COUNT(dbo.[order].order_id) AS total_orders
FROM		dbo.customer INNER JOIN 
				dbo.[order] ON dbo.customer.customer_id = dbo.[order].customer_id
GROUP BY	dbo.customer.customer_id, dbo.customer.first_name +  ' ' + dbo.customer.last_name
ORDER BY	total_orders DESC;



-- Query 5 Recent Orders (Vi)
-- SELECT order ID, total price, order status and payment status of all orders in the last 30 days
-- Order the results by the created date, in descending order

SELECT		dbo.[order].order_id,
			dbo.[order].total_price,
			dbo.[order].order_status,
			dbo.payment.payment_status,
			dbo.[order].created_at
FROM		dbo.[order] INNER JOIN
				dbo.payment ON dbo.[order].order_id = dbo.payment.order_id
WHERE		dbo.[order].created_at >= DATEADD(day, -30, GETDATE())
ORDER BY	dbo.[order].created_at DESC;


-- Query 6 [Medium] (A.Dung)



-- Query 7 Customers Order Stats (Vi)
-- SELECT customer ID, full name (by concatenating their first name and last name), email, number of orders, total price of these orders for each customer
-- Order the results by total revenue, in descending order

SELECT		dbo.customer.customer_id,
			CONCAT(dbo.customer.first_name, ' ', dbo.customer.last_name) as full_name,
			COUNT(dbo.[order].order_id) AS total_orders,
			SUM(dbo.[order].total_price) AS total_price
FROM		dbo.customer INNER JOIN
				dbo.[order] ON dbo.customer.customer_id = dbo.[order].customer_id
GROUP BY	dbo.customer.customer_id, CONCAT(dbo.customer.first_name, ' ', dbo.customer.last_name), dbo.[order].customer_id
ORDER BY	total_price DESC;

-------------------------------------------------------
-- Query 7 Top Selling Products
-- SELECT product ID, product name, category ID, category name and total quantity sold of the FIVE most popular products (determine by total quantity sold)
-- Order the results by total quantity sold, in descending

SELECT		TOP (5) dbo.product.product_id, 
			dbo.product.title AS product_name, 
			dbo.category.title AS category_name, 
			SUM(dbo.order_item.quantity) AS total_quantity_sold
FROM		dbo.order_item INNER JOIN 
				dbo.product ON dbo.order_item.product_id = dbo.product.product_id INNER JOIN 
				dbo.category ON dbo.category.category_id = dbo.product.category_id
GROUP BY	dbo.product.product_id, dbo.product.title, dbo.category.title
ORDER BY	total_quantity_sold DESC;


-- Query 8 [High] (A.Dung)
-- Query 9 [High] (Vi)