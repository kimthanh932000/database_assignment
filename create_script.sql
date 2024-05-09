
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

-- create new database called ecommerce
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
	[description] VARCHAR(MAX),
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
	[description] VARCHAR(MAX),
	price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
	brand VARCHAR(100),
	quantity SMALLINT NOT NULL DEFAULT 0,
	is_available BIT NOT NULL DEFAULT 1,
	CONSTRAINT fk_product_category  FOREIGN KEY (category_id) REFERENCES category(category_id)
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
	email VARCHAR(320) NOT NULL UNIQUE CHECK (email LIKE '%@%'),
	phone VARCHAR(15) NOT NULL,
	[address] VARCHAR(MAX) NOT NULL
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
	CONSTRAINT fk_cart_custumer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
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
	CONSTRAINT fk_cart_item_cart FOREIGN KEY (cart_id) REFERENCES shopping_cart(cart_id),
	CONSTRAINT fk_cart_item_product FOREIGN KEY (product_id) REFERENCES product(product_id)
);
GO


--DeliveryType
DROP TABLE IF EXISTS delivery_type
GO
CREATE TABLE delivery_type
(
	[type_id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	title VARCHAR(50) NOT NULL,
	[description] VARCHAR(MAX),
	is_active BIT NOT NULL DEFAULT 1
);
GO


--Order
DROP TABLE IF EXISTS [order]
GO
CREATE TABLE [order]
(
	order_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	customer_id INT NOT NULL,
	delivery_type INT NOT NULL,
	total_price DECIMAL(10, 2) NOT NULL,
	order_status VARCHAR(20) NOT NULL CHECK (order_status IN ('Pending', 'Processing', 'Out for Delivery', 'Delivered', 'Failed Delivery', 'Cancelled')),
	payment_status VARCHAR(20) NOT NULL DEFAULT 'Unpaid',
	created_at DATETIME NOT NULL DEFAULT GETDATE(),
	updated_at DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
	CONSTRAINT fk_order_delivery_type FOREIGN KEY (delivery_type) REFERENCES delivery_type(type_id)
);
GO


--OrderItem
DROP TABLE IF EXISTS order_item
GO
CREATE TABLE order_item
(
	item_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	product_id INT NOT NULL,
	order_id INT NOT NULL,
	quantity SMALLINT NOT NULL,
	unit_price DECIMAL(10, 2) NOT NULL,
	CONSTRAINT fk_order_item_product FOREIGN KEY (product_id) REFERENCES product(product_id),
	CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) REFERENCES [order](order_id)
);
GO


--Payment
DROP TABLE IF EXISTS payment
GO
CREATE TABLE payment
(
	payment_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	order_id INT NOT NULL,
	transaction_id VARCHAR(255) NOT NULL UNIQUE,
	amount DECIMAL(10, 2) NOT NULL,
	payment_status VARCHAR(20) NOT NULL,
	payment_date DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES [order](order_id)
);
GO


--Shipper
DROP TABLE IF EXISTS shipper
GO
CREATE TABLE shipper
(
	shipper_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	phone VARCHAR(15) NOT NULL,
	[address] VARCHAR(MAX) NOT NULL,
	is_available BIT NOT NULL DEFAULT 1
);
GO


--Shipment
DROP TABLE IF EXISTS shipment
GO
CREATE TABLE shipment
(
	shipment_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	order_id INT NOT NULL,
    shipper_id INT,
    tracking_number VARCHAR(50),
    shipping_date DATETIME,
    arrival_date DATETIME,
    shipping_cost DECIMAL(10, 2),
    contact_name VARCHAR(100) NOT NULL,
    shipping_address VARCHAR(MAX),
    phone VARCHAR(15) NOT NULL,
    pickup_code VARCHAR(20),
    pickup_location VARCHAR(50),
    scheduled_pickup_date DATETIME,
    CONSTRAINT fk_shipment_order FOREIGN KEY (order_id) REFERENCES [order](order_id),
    CONSTRAINT fk_shipment_shipper FOREIGN KEY (shipper_id) REFERENCES shipper(shipper_id)
);
GO
--******Database Population*******