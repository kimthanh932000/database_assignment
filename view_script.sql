USE ecommerce;
GO

-- Products View
-- Create a view that slects the following details from 2 tables "product" and "category":
--		The product ID, brand, name, description, unit price and current status (whether the product is available).
--		The category ID, name and description.
DROP VIEW IF EXISTS v_product_list
GO
CREATE VIEW v_product_list AS
SELECT  dbo.product.product_id,
        dbo.product.brand,
        dbo.product.title AS product_name,
        dbo.product.[description] AS product_description,
        dbo.product.price,
        dbo.product.category_id,
        dbo.product.quantity,
        CASE 
				WHEN dbo.product.is_available = '1'
					THEN 'In stock'
					ELSE 'Out of Stock'
        END AS [status],
        dbo.category.title AS category_name,
        dbo.category.[description] AS category_description
FROM dbo.product JOIN dbo.category ON dbo.product.category_id = dbo.category.category_id;
GO



-- Customer's Cart View 
-- Create a view that selects the following details from 3 tables "customer", "cart_item" and "product":
--		The customer ID, full name and email.
--		The cart item quantity and subtotal.
--		The product ID and product name.

DROP VIEW IF EXISTS v_customer_cart
GO
CREATE VIEW v_customer_cart AS
SELECT	dbo.customer.customer_id,
		CONCAT(dbo.customer.first_name, ' ', dbo.customer.last_name) AS full_name,
		dbo.customer.email,
		dbo.product.title as product_name,
		dbo.product.product_id,
		dbo.shopping_cart.cart_id,
		dbo.cart_item.quantity,
		dbo.cart_item.sub_total
FROM	dbo.customer INNER JOIN 
			dbo.shopping_cart ON dbo.customer.customer_id = dbo.shopping_cart.customer_id INNER JOIN
			dbo.cart_item ON dbo.cart_item.cart_id = dbo.shopping_cart.cart_id INNER JOIN
			dbo.product ON dbo.product.product_id = dbo.cart_item.product_id;
GO
