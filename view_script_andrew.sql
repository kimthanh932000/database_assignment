-- View 1 (A.Dung)
-- db.Customer && db.Order
USE ecommerce
GO

DROP VIEW IF EXISTS order_list
GO

CREATE VIEW order_list AS
SELECT  dbo.customer.customer_id, 
        dbo.customer.first_name, 
        dbo.customer.last_name, 
        dbo.customer.email, 
        dbo.customer.phone, 
        dbo.[order].total_price,
        dbo.[order].updated_at
FROM dbo.customer Inner JOIN dbo.[order] ON dbo.customer.customer_id = dbo.[order].customer_id;
GO