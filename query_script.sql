USE XYZElectronics;

-- Query 1 Total Orders Per Month
-- SELECT the year, month and total number of orders placed each month
-- Order the results by year and month, in ascending order

SELECT		YEAR(dbo.[order].created_at) AS year,
			MONTH(dbo.[order].created_at) AS month,
			COUNT(dbo.[order].order_id) AS total_orders
FROM		dbo.[order]
GROUP BY	YEAR(dbo.[order].created_at),
			MONTH(dbo.[order].created_at)
ORDER BY	year DESC, month DESC;



-- Query 2 Recent Unpaid Orders
-- SELECT the order ID, order status, total price of order, created date, updated date, and payment status of all orders in the last 30 days
-- WHERE: 
--    order status is "Unpaid"
-- Order the results by created date, in descending order

SELECT		dbo.[order].order_id,
			dbo.[order].order_status,
			dbo.[order].total_price,
			dbo.[order].created_at,
			dbo.[order].updated_at,
			dbo.payment.payment_status
FROM		dbo.[order] INNER JOIN
				dbo.payment ON dbo.[order].order_id = dbo.payment.order_id
WHERE		dbo.[order].order_status = 'Unpaid' AND dbo.[order].created_at >= DATEADD(day, -30, GETDATE())
ORDER BY	dbo.[order].created_at;



-- Query 3 Product Search
-- SELECT the name, description, unit price and category of all products that in stock
-- WHERE: 
--    "samsung" anywhere in the product name
-- Order the results by unit price, in ascending order

SELECT		dbo.v_product_list.product_name,
			dbo.v_product_list.product_description, 
			dbo.v_product_list.unit_price,
			dbo.v_product_list.status,
			dbo.v_product_list.category_name
FROM		dbo.v_product_list
WHERE		(dbo.v_product_list.product_name LIKE '%samsung%') AND (dbo.v_product_list.[status] = 'In Stock')
ORDER BY	unit_price;


-- Query 4  Low Stock Products
-- SELECT name, quantity and status of all products
-- WHERE:
--		quantity is less than 10
-- Order the results by quantity, in ascending order

SELECT		dbo.v_product_list.product_name,
			dbo.v_product_list.quantity,
			dbo.v_product_list.[status]
FROM		dbo.v_product_list
WHERE		dbo.v_product_list.quantity < 10
ORDER BY	dbo.v_product_list.quantity;


-- Query 5 High-Value Customers
-- SELECT customer name and total value of their orders
-- WHERE:
--		total value of orders is greater than $1,000
--		order status is not "Unpaid"
-- Order the results by total value of orders in descending order

SELECT		CONCAT(dbo.customer.first_name, ' ', dbo.customer.last_name) AS full_name,
			SUM(dbo.[order].total_price) AS total_order_value
FROM		dbo.customer INNER JOIN 
				dbo.[order] ON dbo.customer.customer_id = dbo.[order].customer_id
WHERE		dbo.[order].order_status != 'Unpaid'
GROUP BY	dbo.customer.customer_id,
			dbo.customer.first_name,
			dbo.customer.last_name
HAVING		SUM(dbo.[order].total_price) > 1000
ORDER BY	total_order_value DESC;



-- Query 6 Customers Order Stats
-- SELECT customer ID, full name (by concatenating their first name and last name), email, number of orders, total price and average order value of these orders for each customer
-- Order the results by total revenue, in descending order

SELECT		dbo.customer.customer_id,
			CONCAT(dbo.customer.first_name, ' ', dbo.customer.last_name) as full_name,
			COUNT(dbo.[order].order_id) AS total_orders,
			SUM(dbo.[order].total_price) AS total_spending,
			AVG(CAST(dbo.[order].total_price AS FLOAT(1))) AS average_spending
FROM		dbo.customer INNER JOIN
				dbo.[order] ON dbo.customer.customer_id = dbo.[order].customer_id
GROUP BY	dbo.customer.customer_id,
			CONCAT(dbo.customer.first_name, ' ', dbo.customer.last_name),
			dbo.[order].customer_id
ORDER BY	total_spending DESC;



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
GROUP BY	dbo.product.product_id,
			dbo.product.title,
			dbo.category.title
ORDER BY	total_quantity_sold DESC;


-- Query 8 Product Inventory Summary
-- SELECT category name, total number of products in each category and total stock value for each category (by summing the unit price and quantity)
-- Order the results by total value in stock, in descending order

SELECT		dbo.v_product_list.category_name,
			SUM(CASE 
					WHEN dbo.v_product_list.[status] = 'In stock' 
						THEN dbo.v_product_list.quantity 
						ELSE 0 
				END) AS total_quantity_in_stock,
			SUM(CASE 
					WHEN dbo.v_product_list.[status] = 'In stock' 
						THEN dbo.v_product_list.unit_price * dbo.v_product_list.quantity 
						ELSE 0 
				END) AS total_value_in_stock
FROM		dbo.v_product_list
GROUP BY	dbo.v_product_list.category_name
ORDER BY	total_value_in_stock DESC;



-- Query 9 Total Shipping Cost and Average Shipping Time
-- SELECT delivery method, total shipping cost and average shipping time (in days)
-- Order the results by average shipping time, in descending order

SELECT		dbo.v_order_shipment.delivery_method,
			SUM(dbo.v_order_shipment.shipping_cost) AS total_shipping_cost,
			ISNULL(AVG(DATEDIFF(day, dbo.v_order_shipment.shipping_date, dbo.v_order_shipment.arrival_date)), 0) AS average_shipping_days
FROM		dbo.v_order_shipment				
GROUP BY	dbo.v_order_shipment.delivery_method
ORDER BY	average_shipping_days DESC;




