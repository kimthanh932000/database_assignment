USE MovieTheatre;
GO

-- Cinema View 
-- Create a view that selects the cinema ID number, cinema name, seating capacity and the name of the cinema type for all cinemas

DROP VIEW IF EXISTS vCinema
GO
CREATE VIEW vCinema AS
SELECT	dbo.Cinemas.cinemaId, 
		dbo.Cinemas.cinemaName, 
		dbo.Cinemas.cinemaSeatingCapacity, 
		dbo.CinemasTypes.cinemaTypeName
FROM	dbo.Cinemas INNER JOIN
			dbo.CinemasTypes ON dbo.Cinemas.cinemaTypeId = dbo.CinemasTypes.cinemaTypeId;
GO


-- Session View 
-- Create a view that selects the following details of all rows in the “session” table:
--		The session ID number, session date/time and cost of the session.
--		The movie ID number, movie name and classification of the movie (e.g. “PG”) being shown.
--		The cinema ID number, cinema name, seating capacity and cinema type name of the cinema that the session is in.

DROP VIEW IF EXISTS vSession
GO
CREATE VIEW vSession AS
SELECT	dbo.MovieSessions.sessionId, 
		dbo.MovieSessions.sessionDateTime, 
		dbo.MovieSessions.sessionTicketCost, 
		dbo.MovieSessions.movieId, 
		dbo.Movies.movieName, 
		dbo.Movies.classification, 
		dbo.vCinema.cinemaId, 
		dbo.vCinema.cinemaName, 
		dbo.vCinema.cinemaSeatingCapacity, 
		dbo.vCinema.cinemaTypeName
FROM	dbo.vCinema INNER JOIN
			dbo.MovieSessions ON dbo.vCinema.cinemaId = dbo.MovieSessions.cinemaId INNER JOIN
			dbo.Movies ON dbo.MovieSessions.movieId = dbo.Movies.movieId;
GO

