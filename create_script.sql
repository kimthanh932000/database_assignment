
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

INSERT INTO category (title, description) 
VALUES ('Smartphones', 'Mobile devices with smart capabilities such as internet connectivity and app support.'),
	   ('Laptops', 'Portable computers suitable for mobile use and equipped with advanced capabilities.'),
	   ('Tablets', 'Touchscreen devices that combine the capabilities of a smartphone and a laptop.'),
	   ('Desktop Computers', 'Personal computers designed for regular use at a single location.'),
	   ('Smart Watches', 'Wearable technology that offers smartphone-like capabilities on your wrist.'),
	   ('Gaming Consoles', 'Electronic devices designed to play video games that connect to a display device.'),
	   ('Audio Devices', 'Devices for personal or home entertainment that reproduce sound, such as headphones and speakers.'),
	   ('Cameras', 'Devices used to capture photographs and videos digitally.'),
	   ('Drones', 'Unmanned aerial vehicles controlled by remote or onboard computers, used for entertainment or photography.'),
	   ('Home Appliances', 'Electronic devices that assist in household functions such as cooking, cleaning, and food preservation.');


INSERT INTO product 
VALUES (1, 'iPhone 13', 'Latest model of Apple iPhone with improved camera and battery life.', 799.00, 'Apple', 150, 1),
	   (1, 'Samsung Galaxy S21', 'High-end smartphone with Android operating system and advanced photography capabilities.', 699.00, 'Samsung', 200, 1),
	   (2, 'Dell XPS 13', 'Compact and powerful ultrabook from Dell, known for its sleek design and performance.', 999.00, 'Dell', 100, 1),
	   (2, 'MacBook Air', 'Light and durable Apple laptop, ideal for professionals and students.', 1099.00, 'Apple', 120, 1),
	   (3, 'iPad Pro', 'High-performance tablet with liquid retina display, suitable for professionals and artists.', 799.00, 'Apple', 80, 1),
	   (4, 'Alienware Aurora', 'High-end gaming desktop with customizable RGB lighting and powerful components.', 1500.00, 'Alienware', 50, 1),
	   (5, 'Apple Watch Series 6', 'Latest generation smartwatch with health monitoring features and integration with iOS.', 399.00, 'Apple', 180, 1),
	   (6, 'PlayStation 5', 'The latest home video game console from Sony with advanced graphics and performance.', 499.00, 'Sony', 200, 1),
	   (7, 'Bose QuietComfort', 'Noise-cancelling headphones that provide an unparalleled audio experience.', 299.00, 'Bose', 300, 1),
	   (8, 'Nikon D3500', 'Entry-level DSLR camera with great image quality and easy to use for beginners.', 449.99, 'Nikon', 90, 1),
	   (9, 'DJI Mavic Air 2', 'Compact drone with 4K video capability and 34-minute flight time.', 799.99, 'DJI', 60, 1),
	   (10, 'Samsung Smart Fridge', 'Refrigerator with Wi-Fi connectivity and a touch screen for managing groceries and household tasks.', 1200.00, 'Samsung', 40, 1);


INSERT INTO customer
VALUES ('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Elm Street, Springfield, IL'),
	   ('Jane', 'Smith', 'jane.smith@example.com', '321-654-0987', '456 Oak Avenue, Anytown, CA'),
	   ('Alice', 'Johnson', 'alice.johnson@example.com', '231-564-8970', '789 Pine Road, Smallville, TX'),
	   ('Bob', 'Brown', 'bob.brown@example.com', '132-465-7980', '101 Maple Lane, Centerville, MA'),
	   ('Carol', 'Davis', 'carol.davis@example.com', '312-546-7098', '213 Spruce Blvd, Liberty City, FL'),
	   ('David', 'Miller', 'david.miller@example.com', '213-546-9807', '321 Birch Street, Metropolis, NY'),
	   ('Eva', 'Wilson', 'eva.wilson@example.com', '123-456-7891', '654 Cedar Place, Gotham, NJ'),
       ('Grace', 'Taylor', 'grace.taylor@example.com', '231-564-8971', '567 Fir Court, King Landing, NV'),
	   ('Henry', 'Anderson', 'henry.anderson@example.com', '132-465-7981', '234 White Pine Alley, Sunnydale, UT'),
	   ('Isabella', 'Martinez', 'isabella.martinez@example.com', '143-256-7890', '432 Elm Street, Rivertown, WA');


INSERT INTO shopping_cart
VALUES (1, 2, 150.00, GETDATE(), GETDATE()),
	   (2, 5, 450.00, GETDATE(), GETDATE()),
	   (3, 3, 220.00, GETDATE(), GETDATE()),
	   (4, 1, 799.00, GETDATE(), GETDATE()),
	   (5, 4, 360.00, GETDATE(), GETDATE()),
	   (6, 1, 999.00, GETDATE(), GETDATE()),
	   (7, 7, 525.00, GETDATE(), GETDATE()),
	   (8, 2, 198.00, GETDATE(), GETDATE()),
	   (9, 3, 289.00, GETDATE(), GETDATE()),
	   (10, 6, 1200.00, GETDATE(), GETDATE());


INSERT INTO cart_item 
VALUES (1, 1, 1, 799.00),   -- iPhone 13 in cart 1
	   (1, 2, 1, 699.00),   -- Samsung Galaxy S21 in cart 1
	   (1, 16, 1, 999.00),  -- another high-cost item in cart 1
	   (2, 3, 1, 999.00),   -- Dell XPS 13 in cart 2
	   (2, 4, 1, 1099.00),  -- MacBook Air in cart 2
	   (2, 5, 2, 799.00),   -- 2 iPad Pros in cart 2
	   (3, 6, 1, 1500.00),  -- Alienware Aurora in cart 3
	   (3, 5, 1, 799.00),   -- iPad Pro in cart 3
       (4, 7, 1, 399.00),   -- Apple Watch Series 6 in cart 4
	   (5, 8, 1, 499.00),   -- PlayStation 5 in cart 5
	   (5, 9, 2, 299.00),   -- 2 Bose QuietComfort in cart 5
	   (6, 10, 1, 449.99),  -- Nikon D3500 in cart 6
	   (6, 11, 1, 799.99),  -- DJI Mavic Air 2 in cart 6
	   (7, 12, 1, 1200.00), -- Samsung Smart Fridge in cart 7
	   (8, 5, 2, 799.00),   -- 2 iPad Pros in cart 8
	   (9, 1, 1, 799.00),   -- iPhone 13 in in cart 9
	   (10, 4, 1, 1099.00); -- MacBook Air in cart 10


INSERT INTO delivery_type 
VALUES ('Delivery', 'Delivers in 3-5 business days.', 1),
	   ('In-store Pickup', 'Order online and pick up in store. Ready within 24 hours.', 1);


INSERT INTO [order]
VALUES (1, 1, 250.00, 'Processing', 'Unpaid', GETDATE(), GETDATE()),
	   (2, 2, 150.00, 'Pending', 'Unpaid', GETDATE(), GETDATE()),
	   (3, 1, 450.00, 'Out for Delivery', 'Paid', GETDATE(), GETDATE()),
	   (4, 1, 125.00, 'Delivered', 'Paid', GETDATE(), GETDATE()),
	   (5, 2, 300.00, 'Failed Delivery', 'Paid', GETDATE(), GETDATE()),
	   (6, 1, 200.00, 'Cancelled', 'Unpaid', GETDATE(), GETDATE()),
	   (7, 1, 500.00, 'Processing', 'Paid', GETDATE(), GETDATE()),
	   (8, 1, 120.00, 'Pending', 'Unpaid', GETDATE(), GETDATE()),
	   (9, 2, 600.00, 'Delivered', 'Paid', GETDATE(), GETDATE()),
	   (10, 1, 350.00, 'Out for Delivery', 'Paid', GETDATE(), GETDATE());
