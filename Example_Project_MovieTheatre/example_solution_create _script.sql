
--******Create/Drop Databse******

-- if MovieTheatre exists, kill current connections to Database
-- make single user
IF DB_ID('MovieTheatre') IS NOT NULL
	BEGIN
		USE [MASTER];

		ALTER	DATABASE [MovieTheatre] 
		SET 	SINGLE_USER
		WITH	ROLLBACK IMMEDIATE;

		DROP DATABASE MovieTheatre;
	END
GO

-- create new database called MovieTheatre
CREATE DATABASE MovieTheatre;
GO

USE MovieTheatre;
GO

--******Create Tables*******

--Classifications
DROP TABLE IF EXISTS Classifications
GO
CREATE TABLE Classifications
(
	classification CHAR(2) NOT NULL PRIMARY KEY,
	classificationName VARCHAR(150) NOT NULL,
	classificationMinimumAge CHAR(14) NOT NULL,
);
GO


--Movies Tbl
DROP TABLE IF EXISTS Movies
GO
CREATE TABLE Movies
(
	movieId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	movieName VARCHAR(150) NOT NULL,
	movieDuration SMALLINT NOT NULL,
	movieDescription VARCHAR(MAX) NOT NULL,
	classification CHAR(2) NOT NULL FOREIGN KEY REFERENCES Classifications(classification),
);
GO


-- Genres 
DROP TABLE IF EXISTS Genres
GO
CREATE TABLE Genres
(
	genresId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	genresType VARCHAR(40) NOT NULL
);
GO


-- MoviesGenres
DROP TABLE IF EXISTS MoviesGenres
GO
CREATE TABLE MoviesGenres
(
	movieId INT NOT NULL	FOREIGN KEY  REFERENCES Movies(movieId),
	genresId INT NOT NULL	FOREIGN KEY  REFERENCES Genres(genresId),
	PRIMARY KEY (movieId, genresId),
);
GO


-- CinemasTypes 
DROP TABLE IF EXISTS CinemasTypes
GO
CREATE TABLE CinemasTypes
(
	cinemaTypeId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	cinemaTypeName VARCHAR(40) NOT NULL
);
GO


-- Cinemas 
DROP TABLE IF EXISTS Cinemas
GO
CREATE TABLE Cinemas
(
	cinemaId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	cinemaName VARCHAR(40) NOT NULL,
	cinemaSeatingCapacity INT NOT NULL DEFAULT 0,
	cinemaTypeId INT NOT NULL   FOREIGN KEY  REFERENCES CinemasTypes(cinemaTypeId),
);
GO


-- Sessions
DROP TABLE IF EXISTS MovieSessions
GO
CREATE TABLE MovieSessions
(
	sessionId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	sessionDateTime DATETIME NOT NULL,
	sessionTicketCost MONEY NOT NULL DEFAULT 0,
	cinemaId INT NOT NULL FOREIGN KEY  REFERENCES Cinemas(cinemaId),
	movieId INT NOT NULL  FOREIGN KEY  REFERENCES Movies(movieId),
);
GO


-- Customers
DROP TABLE IF EXISTS Customers
GO
CREATE TABLE Customers
(
	customerEmail VARCHAR(100) NOT NULL PRIMARY KEY,
	customerPassword VARCHAR(70) NOT NULL,
	customerFirstName VARCHAR(70) NOT NULL,
	customerLastName VARCHAR(70) NOT NULL,
	customerDOB DATE NOT NULL,
);
GO


-- TicketPurchases
DROP TABLE IF EXISTS TicketPurchases
GO
CREATE TABLE TicketPurchases
(
	ticketPurchaseId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	ticketPurchaseNumberPurchased INT NOT NULL,
	customerEmail VARCHAR(100) NOT NULL FOREIGN KEY  REFERENCES Customers(customerEmail),
	sessionId INT NOT NULL FOREIGN KEY  REFERENCES MovieSessions(sessionId),
);
GO


-- CustomersReviews
DROP TABLE IF EXISTS CustomersReviews
GO
CREATE TABLE CustomersReviews -- customer Can only review a movie ONCE
(
	customersReviewId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	customersReviewText VARCHAR(MAX) NOT NULL,
	customersReviewRating SMALLINT NOT NULL CHECK (customersReviewRating > -1 AND customersReviewRating < 6),
	customersReviewDateTime DATETIME DEFAULT Getdate(),
	customerEmail VARCHAR(100) NOT NULL FOREIGN KEY  REFERENCES Customers(customerEmail),
	movieId INT NOT NULL FOREIGN KEY  REFERENCES Movies(movieId),
);
GO


--******Database Population*******

INSERT INTO Classifications
VALUES ('G',  'General', 'Not Applicable'),
       ('PG', 'Parental Guidance', 'Not Applicable'),
       ('M',  'Mature', 'Not Applicable'),
       ('MA', 'Mature Audiences', '15'),
       ('R',  'Restricted', '18');


INSERT INTO Genres (genresType)
VALUES ('Action'),     -- Genre 1
       ('Adventure'),  -- Genre 2
       ('Animation'),  -- Genre 3
       ('Comedy'),     -- Genre 4
       ('Crime'),      -- Genre 5
       ('Drama'),      -- Genre 6
       ('Fantasy'),    -- Genre 7
       ('Horror'),     -- Genre 8
       ('Romance'),    -- Genre 9
       ('Sci-Fi');     -- Genre 10


INSERT INTO Movies
VALUES ('The Shawshank Redemption', 142, 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.', 'MA'),
       ('Pulp Fiction', 154, 'The lives of two mob hit men, a boxer, a gangster''s wife, and a pair of diner bandits intertwine in four tales of violence and redemption.', 'R'),
       ('Forrest Gump', 142, 'Forrest Gump, while not intelligent, has accidentally been present at many historic moments, but his true love, Jenny Curran, eludes him.', 'M'),
       ('Star Wars: Episode IV - A New Hope', 121, 'Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a wookiee and two droids to save the universe from the Empire''s world-destroying battle-station.', 'PG'),
       ('WALL-E', 98, 'In the distant future, a small waste collecting robot inadvertently embarks on a space journey that will ultimately decide the fate of mankind.', 'G'),
       ('Eternal Sunshine of the Spotless Mind', 108, 'When their relationship turns sour, a couple undergoes a procedure to have each other erased from their memories. But it is only through the process of loss that they discover what they had to begin with.', 'M'),
       ('Monty Python and the Holy Grail', 91, 'King Arthur and his knights embark on a low-budget search for the Grail, encountering many very silly obstacles.', 'PG'),
       ('Up', 96, 'Seventy-eight year old Carl Fredricksen travels to Paradise Falls in his home equipped with balloons, inadvertently taking a young stowaway.', 'PG'),
       ('Gran Torino', 116, 'Disgruntled Korean War veteran Walt Kowalski sets out to reform his neighbor, a Hmong teenager who tried to steal Kowalski''s prized possession: a 1972 Gran Torino.', 'M'),
       ('Metropolis', 153, 'In a futuristic city sharply divided between the working class and the city planners, the son of the city''s mastermind falls in love with a working class prophet who predicts the coming of a savior to mediate their differences.', 'PG');


INSERT INTO MoviesGenres
VALUES (1, 5), (1, 6),           -- Shawshank: Crime & Drama
       (2, 5), (2, 6),           -- Pulp Fiction: Crime & Drama
       (3, 6), (3, 9),           -- Forrest Gump: Drama & Romance
       (4, 1), (4, 2), (4, 7),   -- Star Wars: Action & Adventure & Fantasy
       (5, 2), (5, 3),           -- Wall-E: Adventure & Animation
       (6, 6), (6, 9), (6, 10),  -- Eternal Sunshine: Drama & Romance & Sci-Fi
       (7, 2), (7, 4), (7, 7),   -- Holy Grail: Adventure & Comedy & Fantasy
       (8, 2), (8, 3),           -- Up: Adventure & Animation
       (9, 6),                   -- Gran Torino: Drama
       (10, 6), (10, 10);        -- Metropolis: Drama & Sci-Fi

INSERT INTO CinemasTypes
VALUES	('2D'),
		('3D'),
		('Gold Class 2D'),
		('Gold Class 3D');	   


INSERT INTO Cinemas
VALUES	('Cinema 1',250,1),		--2D
		('Cinema 2',80,2),		--3D
		('Cinema 3',65,1),		--2D
		('Cinema 4',25,4),		--Gold Class 3D
		('Cinema 5',90,3),		--Gold Class 2D
		('Cinema 6',30,2),		--3D
		('Cinema 7',80,1);		--2D


INSERT INTO Customers
VALUES	('fredNurk@gmail.com','123test','Fred','Nurk',convert(datetime,'20/10/2000', 103)),
		('darthVader@hotmail.com','deathstar','Darth','Vader',convert(datetime,'2/10/1892',103)),
		('joeBloggs@gmail.com','testp@wagain','Joe','Bloggs',convert(datetime,'24/5/1974', 103)),
		('sallyHatsumitsu@goofy.com.jp','afst%32k+','Sally','Hatsumitsu',convert(datetime,'13/9/2002', 103)),
		('email@email.com.au','resfjgt&dhfk++','Santa','Cruz',convert(datetime,'31/1/1983', 103)),
		('pattyYikes@gmail.com','password','Joanne','Lumney',convert(datetime,'3/10/1948', 103)),
		('HR@cinemas.com.au','gdgdgdg3549%^','Hettie','Blowfeld',convert(datetime,'14/2/1990', 103));


INSERT INTO CustomersReviews 
		(customersReviewText, 
		 customersReviewRating,
		 customerEmail,
		 movieId) 
VALUES	('This movie was soo good! I loved the very bad ending. Please have more like this',4,'sallyHatsumitsu@goofy.com.jp',5),
		('Worst depiction of me EVER!',0,'darthVader@hotmail.com',4),
		('Pulp is a good word to describe this film. So much in need of a good tree mulching machine to turn it into pulp.',1,'email@email.com.au',2),
		('Loved this film. I can watch it over and over',5,'joeBloggs@gmail.com',4),
		('I felt a real wally watching this film, but I enjoyed it enough to not walk out before the end.',3,'HR@cinemas.com.au',5),
		('I nearly fell asleep in the first five minutes. I will only see again if I am too tired from completing Uni assignments. Sorry Forest - you bored me to sleep.',2,'joeBloggs@gmail.com',3);

INSERT INTO MovieSessions
VALUES	(convert(datetime,'1/12/2019 10:00:000', 103),12.50,1,1),
		(convert(datetime,'1/12/2019 22:00:000', 103),16.50,2,2),
		(convert(datetime,'1/12/2019 20:30:000', 103),12.50,3,4),
		(convert(datetime,'1/12/2019 22:00:000', 103),32.50,4,6),
		(convert(datetime,'23/1/2020 22:00:000', 103),24.00,5,1),
		(convert(datetime,'4/11/2019 22:00:000', 103),16.50,6,10),
		(convert(datetime,'1/12/2019 22:00:000', 103),12.50,7,7),
		(convert(datetime,'12/12/2019 22:00:000', 103),16.50,1,5),
		(convert(datetime,'12/12/2019 22:00:000', 103),16.50,2,6),
		(convert(datetime,'12/12/2019 22:00:000', 103),16.50,3,2),
		(convert(datetime,'12/12/2019 22:00:000', 103),32.50,4,9),
		(convert(datetime,'12/12/2019 22:00:000', 103),24.00,5,8),
		(convert(datetime,'13/12/2019 22:00:000', 103),16.50,6,3),
		(convert(datetime,'13/12/2019 22:00:000', 103),12.50,7,4);


INSERT INTO TicketPurchases
VALUES	(2,'darthVader@hotmail.com',3),
		(1,'email@email.com.au',2),
		(10,'joeBloggs@gmail.com',3),
		(1,'joeBloggs@gmail.com',9),
		(3,'pattyYikes@gmail.com',6),
		(1,'fredNurk@gmail.com',14),
		(2,'sallyHatsumitsu@goofy.com.jp',8);