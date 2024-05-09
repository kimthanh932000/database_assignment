
--******Create/Drop Databse******

-- if Ecommerce exists, kill current connections to Database
-- make single user
IF DB_ID('ecommerce') IS NOT NULL
	BEGIN
		USE [MASTER];

		ALTER	DATABASE ecommerce 
		SET 	SINGLE_USER
		WITH	ROLLBACK IMMEDIATE;

		DROP DATABASE ecommerce;
	END
GO

-- create new database called MovieTheatre
CREATE DATABASE ecommerce;
GO

USE ecommerce;
GO

--******Create Tables*******

--Category
DROP TABLE IF EXISTS category;
GO
CREATE TABLE category
(
	category_id INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	title VARCHAR(150) NOT NULL,
	description VARCHAR(MAX),
);
GO


--Product
DROP TABLE IF EXISTS product;
GO
CREATE TABLE product
(
	product_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	category_id INT NOT NULL,
	title VARCHAR(150) NOT NULL,
	description VARCHAR(MAX),
	price DECIMAL(10, 2) NOT NULL,
	brand VARCHAR(100),
	quantity SMALLINT NOT NULL DEFAULT 0,
	is_available BIT NOT NULL DEFAULT 1,
	CONSTRAINT fk_category  FOREIGN KEY (category_id) REFERENCES category(category_id)
);
GO


--Customer
DROP TABLE IF EXISTS customer
GO
CREATE TABLE customer
(
	customer_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(320) NOT NULL,
	phone VARCHAR(15) NOT NULL,
	address VARCHAR(MAX) NOT NULL
);
GO


--ShoppingCart
DROP TABLE IF EXISTS shopping_cart
GO
CREATE TABLE shopping_cart
(
	cart_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	customer_id INT NOT NULL,
	total_quantity SMALLINT NOT NULL,
	total_price DECIMAL(10, 2) NOT NULL,
	created_at DATETIME NOT NULL DEFAULT GETDATE(),
	updated_at DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
GO


--CartItem
DROP TABLE IF EXISTS cart_item
GO
CREATE TABLE cart_item
(
	item_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	cart_id INT NOT NULL,
	product_id INT NOT NULL,
	quantity SMALLINT NOT NULL,
	unit_price DECIMAL(10, 2) NOT NULL,
	CONSTRAINT fk_cart FOREIGN KEY (cart_id) REFERENCES shopping_cart(cart_id),
	CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES product(product_id)
);
GO


--DeliveryTYpe
DROP TABLE IF EXISTS delivery_type
GO
CREATE TABLE delivery_type
(
	item_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	cart_id INT NOT NULL,
	product_id INT NOT NULL,
	quantity SMALLINT NOT NULL,
	unit_price DECIMAL(10, 2) NOT NULL,
	CONSTRAINT fk_cart FOREIGN KEY (cart_id) REFERENCES shopping_cart(cart_id),
	CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES product(product_id)
);
GO

--******Database Population*******