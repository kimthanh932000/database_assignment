USE ecommerce;
GO

-- Customer's Cart View 
-- Create a view that selects the following details from 3 tables "customer", "cart_item" and "product":
--		The customer ID, full name and email.
--		The cart item quantity and subtotal.
--		The product ID and product name.

DROP VIEW IF EXISTS customer_cart
GO
CREATE VIEW customer_cart AS
SELECT	dbo.customer.customer_id,
		CONCAT(dbo.customer.first_name, ' ', dbo.customer.last_name) AS full_name,
		dbo.customer.email,
		dbo.product.title as product_name,
		dbo.product.product_id,
		dbo.cart_item.quantity,
		dbo.cart_item.sub_total
FROM	dbo.customer INNER JOIN 
			dbo.shopping_cart ON dbo.customer.customer_id = dbo.shopping_cart.customer_id INNER JOIN
			dbo.cart_item ON dbo.cart_item.cart_id = dbo.shopping_cart.cart_id INNER JOIN
			dbo.product ON dbo.product.product_id = dbo.cart_item.product_id;
GO
