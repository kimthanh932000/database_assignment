-- View 1 (A.Dung)
-- db.Pruduct && db.Category
USE ecommerce
GO

DROP VIEW IF EXISTS product_list
GO

CREATE VIEW product_list AS
SELECT  dbo.product.product_id,
        dbo.product.brand,
        dbo.product.title AS Product_name,
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