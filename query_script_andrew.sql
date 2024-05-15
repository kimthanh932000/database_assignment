-- Query 1 [Low] (A.Dung)
SELECT  dbo.product.title, 
        dbo.product.[description], 
        dbo.product.price, 
        dbo.product.brand,
        dbo.order_item.product_id, 
        dbo.order_item.order_id, 
        dbo.order_item.quantity,
        dbo.order_item.unit_price
FROM dbo.order_item
INNER JOIN dbo.product ON dbo.order_item.product_id = dbo.product.product_id;

-- Query 2 [Low] (A.Dung)
SELECT  dbo.cart_item.cart_id,
        dbo.cart_item.item_id,
        dbo.cart_item.product_id,
        dbo.cart_item.quantity,
        dbo.cart_item.unit_price,
        dbo.shopping_cart.created_at,
        dbo.shopping_cart.updated_at,
        dbo.shopping_cart.customer_id
FROM dbo.shopping_cart
INNER JOIN dbo.cart_item ON dbo.shopping_cart.cart_id = dbo.cart_item.cart_id
WHERE product_id = 1

-- Query 3 [Low] (A.Dung)
SELECT  dbo.[order].customer_id,
        dbo.[order].order_id,
        dbo.[order].order_status,
        dbo.[order].payment_status,
        dbo.[order].total_price,
        dbo.[order].delivery_type,
        dbo.[order].created_at,
        dbo.[order].updated_at,
        dbo.payment.payment_id,
        dbo.payment.payment_date
FROM dbo.[order] 
INNER JOIN dbo.payment ON dbo.[order].order_id = dbo.payment.order_id

-- Query 6 [Medium] (A.Dung)

-- Query 8 [High] (A.Dung)
