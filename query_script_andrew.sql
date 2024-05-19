-- Query 1 [Low] (A.Dung)
-- Select product and order items, 
SELECT  dbo.product.title, 
        dbo.product.[description], 
        dbo.product.price, 
        dbo.product.brand,
        dbo.order_item.product_id, 
        dbo.order_item.order_id, 
        dbo.order_item.quantity,
        dbo.order_item.sub_total
FROM dbo.order_item
INNER JOIN dbo.product ON dbo.order_item.product_id = dbo.product.product_id
WHERE brand = 'Apple'
ORDER BY title;

-- Query 2 [Low] (A.Dung)
SELECT  dbo.cart_item.cart_id,
        dbo.cart_item.item_id,
        dbo.cart_item.product_id,
        dbo.cart_item.quantity,
        dbo.cart_item.sub_total,
        dbo.shopping_cart.created_at,
        dbo.shopping_cart.updated_at,
        dbo.shopping_cart.customer_id
FROM dbo.shopping_cart
INNER JOIN dbo.cart_item ON dbo.shopping_cart.cart_id = dbo.cart_item.cart_id
WHERE product_id = 1
ORDER BY customer_id;

-- Query 3 [Low] (A.Dung)
SELECT  dbo.[order].customer_id,
        dbo.[order].order_id,
        dbo.[order].order_status,
        dbo.[order].total_price,
        dbo.[order].delivery_type,
        dbo.[order].created_at,
        dbo.[order].updated_at,
        dbo.payment.payment_id,
        dbo.payment.payment_date
FROM dbo.[order] 
INNER JOIN dbo.payment ON dbo.[order].order_id = dbo.payment.order_id
WHERE dbo.[order].order_status = 'Processing'
ORDER BY customer_id;

-- Query 6 [Medium] (A.Dung)
SELECT  dbo.[order].order_id,
        dbo.[order].created_at,
        dbo.shipment.shipping_date,
        CONCAT(dbo.shipper.first_name, ' ', dbo.shipper.last_name) AS shipper_name
FROM [order]
JOIN shipment ON dbo.[order].order_id = dbo.shipment.order_id
JOIN shipper ON dbo.shipment.shipper_id = dbo.shipper.shipper_id
ORDER BY dbo.[order].created_at DESC;

-- -- Query 8 [High] (A.Dung)
-- -- Get a list of tables and views in the current database
-- SELECT *
-- FROM dbo.product_list;
-- GO

-- SELECT
--     dbo.category_name,
--     COUNT(product_id) AS total_products,
--     SUM(price * quantity) AS total_stock_value,
--     SUM(CASE WHEN status = 'In stock' THEN quantity ELSE 0 END) AS total_quantity_in_stock,
--     SUM(CASE WHEN status = 'In stock' THEN price * quantity ELSE 0 END) AS total_value_in_stock
-- FROM
--     dbo..product_list
-- GROUP BY
--     category_name
-- ORDER BY
--     total_value_in_stock DESC;
