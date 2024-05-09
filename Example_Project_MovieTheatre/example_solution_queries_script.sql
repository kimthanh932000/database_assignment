
USE MovieTheatre;

-- Query 1  Child Friendly Movies
-- SELECT movie name, duration and classification of all movies 
-- WHERE:
--    duration of less than 100 minutes 
--    a classification of G or PG.  
-- Order the results by duration. 

SELECT		movieName, 
			movieDuration, 
			classification
FROM		dbo.Movies
WHERE		(movieDuration < 100) AND 
			(classification IN ('G', 'PG'))
ORDER BY	movieDuration;



-- Query 2  Movie Search 
-- SELECT the movie name, session date/time, cinema type name and cost of all upcoming sessions (i.e. session date/time is later than the current date/time) 
-- WHERE: 
--    star wars anywhere in the movie name  
-- Order the results by session date/time

SELECT		dbo.Movies.movieName, 
			dbo.vSession.sessionDateTime, 
			dbo.vSession.sessionTicketCost,
			dbo.vSession.cinemaTypeName
FROM		dbo.vSession INNER JOIN
				dbo.Movies ON dbo.vSession.movieId = dbo.Movies.movieId
WHERE		(dbo.Movies.movieName LIKE '%star wars%') AND (dbo.vSession.sessionDateTime > GETDATE())
ORDER BY	dbo.vSession.sessionDateTime;



-- Query 3  Review Details
-- SELECT text of the reviewdetails,date/time the review was posted, the rating given, the first name,  age (calculated from the date of birth)
-- WHERE:
--    movie ID number of 5
-- Order the results by the review date, in descending order

SELECT		dbo.CustomersReviews.customersReviewText, 
			dbo.CustomersReviews.customersReviewDateTime, 
			dbo.CustomersReviews.customersReviewRating, 
			dbo.Customers.customerFirstName, 
			FLOOR(DATEDIFF(DAY, dbo.Customers.customerDOB, GETDATE()) / 365.25) AS Age
FROM		dbo.CustomersReviews INNER JOIN
				dbo.Customers ON dbo.CustomersReviews.customerEmail = dbo.Customers.customerEmail
WHERE		(dbo.CustomersReviews.movieId = 5)
ORDER BY	dbo.CustomersReviews.customersReviewDateTime DESC;



-- Query 4  Genre Count
-- SELECT the name of all genres in the genre table, and the number of movies of each genre
--    show all genres, even if there are no movies of that genre in the database

SELECT		dbo.Genres.genresType AS Genres, 
			COUNT(dbo.MoviesGenres.movieId) AS MovieCount
FROM		dbo.Genres LEFT OUTER JOIN
				dbo.MoviesGenres ON dbo.Genres.genresId = dbo.MoviesGenres.genresId
GROUP BY	dbo.Genres.genresType;



-- Query 5  Movie Review Stats
-- SELECT names of all movies in the movie table, how many reviews have been posted per movie, and the average star rating of the reviews per movie
--    include all movies, even if they have not been reviewed
--    Round the average rating to one decimal place
--  order the results by the average rating, in descending order

SELECT		dbo.Movies.movieName, 
			COUNT(dbo.CustomersReviews.movieId) AS MovieReviewCount, 
			AVG(CAST(dbo.CustomersReviews.customersReviewRating AS FLOAT(1))) AS AverageStarRating
FROM		dbo.Movies LEFT OUTER JOIN
				dbo.CustomersReviews ON dbo.Movies.movieId = dbo.CustomersReviews.movieId
GROUP BY	dbo.Movies.movieName
ORDER BY	AVG(CAST(dbo.CustomersReviews.customersReviewRating AS FLOAT(1))) DESC;



-- Query 6  Top Selling Movies
-- SELECT name and total number of tickets sold of the THREE most popular movies (determined by total ticket sales)

SELECT		TOP (3) dbo.vSession.movieName, 
			SUM(dbo.TicketPurchases.ticketPurchaseNumberPurchased) AS TotalTicketsSold
FROM		dbo.vSession INNER JOIN
				dbo.TicketPurchases ON dbo.vSession.sessionId = dbo.TicketPurchases.sessionId
GROUP BY	dbo.vSession.movieName
ORDER BY	TotalTicketsSold DESC;



-- Query 7  Customer Ticket Stats
-- SELECT full names (by concatenating their first name and last name) of all customers in the customer table, how many tickets they have each purchased, and the total cost of these tickets
--    include all customers, even if they have never purchased a ticket
-- Order the results by total ticket cost, in descending order

SELECT		dbo.Customers.customerFirstName + ' ' + dbo.Customers.customerLastName AS CustomerName, 
			ISNULL(SUM(dbo.TicketPurchases.ticketPurchaseNumberPurchased),0) AS TicketsPurchased, 
            ISNULL(SUM(dbo.TicketPurchases.ticketPurchaseNumberPurchased * dbo.MovieSessions.sessionTicketCost),0) AS TotalSpent
FROM		dbo.MovieSessions RIGHT OUTER JOIN
				dbo.TicketPurchases ON dbo.MovieSessions.sessionId = dbo.TicketPurchases.sessionId RIGHT OUTER JOIN
				dbo.Customers ON dbo.TicketPurchases.customerEmail = dbo.Customers.customerEmail
GROUP BY	dbo.Customers.customerFirstName + ' ' + dbo.Customers.customerLastName
ORDER BY	TotalSpent DESC;



-- Query 8  Age Appropriate Movies
-- SELECT movie name, duration and description of all movies that a certain customer (chosen by you) can legally watch, 
-- WHERE:
--	 based on the customers date of birth and the minimum age required by the movies classification
-- SUB QUERY:
--	 SELECT a customer 
--   WHERE:
--      whose date of birth makes them 15-17 years old
--        so that the results include all movies except those classified R

--***** Please note: I have limited the result to a single customer as the sub query requirements stated: SELECT a customer
--*****              if we wanted to return all customers that suit between the age limit, I would remove the customer email where clause in the sub query

SELECT		dbo.Movies.movieName, dbo.Movies.movieDuration, dbo.Movies.movieDescription
FROM		dbo.Movies INNER JOIN
				dbo.Classifications ON dbo.Movies.classification = dbo.Classifications.classification
WHERE		(CAST(CASE dbo.Classifications.classificationMinimumAge WHEN 'Not Applicable' THEN '0' ELSE classificationMinimumAge END AS int) <=
                             (SELECT	FLOOR(DATEDIFF(DAY, customerDOB, GETDATE()) / 365.25) AS Age
                              FROM		dbo.Customers
                              WHERE		(customerEmail = 'sallyHatsumitsu@goofy.com.jp') AND (FLOOR(DATEDIFF(DAY, customerDOB, GETDATE()) / 365.25) IN (15, 16, 17))));



-- Query 9  Session Revenue
-- SELECT session ID, session date/time, movie name, cinema name, tickets sold and total revenue of all sessions that occurred in the past
--    Total revenue is the session cost multiplied by the number of tickets sold
--    Ensure that sessions that had no tickets sold appear in the results (with 0 tickets sold and 0 revenue)
-- Order the results by total revenue, in descending order

SELECT		dbo.vSession.sessionId, 
			dbo.vSession.sessionDateTime, 
			dbo.vSession.movieName, 
			dbo.vSession.cinemaName, 
			SUM(ISNULL(dbo.TicketPurchases.ticketPurchaseNumberPurchased, 0)) AS TotalTicketsSold, 
			ISNULL(dbo.TicketPurchases.ticketPurchaseNumberPurchased * dbo.vSession.sessionTicketCost, 0) AS TotalTicketRevenue
FROM		dbo.vSession LEFT OUTER JOIN
				dbo.TicketPurchases ON dbo.vSession.sessionId = dbo.TicketPurchases.sessionId
GROUP BY	dbo.vSession.sessionId, 
			dbo.vSession.sessionDateTime, 
			dbo.vSession.movieName, 
			dbo.vSession.cinemaName, 
			ISNULL(dbo.TicketPurchases.ticketPurchaseNumberPurchased * dbo.vSession.sessionTicketCost, 0)
ORDER BY	ISNULL(dbo.TicketPurchases.ticketPurchaseNumberPurchased * dbo.vSession.sessionTicketCost, 0) DESC;


