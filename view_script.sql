USE XYZElectronics;
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
        dbo.product.price AS unit_price,
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

DROP VIEW IF EXISTS v_order_shipment
GO
CREATE VIEW v_order_shipment AS
SELECT	dbo.[order].order_id,
		dbo.shipment.shipping_cost,
		dbo.shipment.shipping_date,
		dbo.shipment.arrival_date,
		dbo.delivery_type.title AS delivery_method
FROM	dbo.[order] INNER JOIN 
			dbo.[shipment] ON dbo.[order].order_id = dbo.[shipment].order_id INNER JOIN
			dbo.delivery_type ON dbo.[order].delivery_type = dbo.delivery_type.[type_id]
GO