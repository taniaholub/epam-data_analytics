USE WorldEvents
GO

SELECT e.EventName, e.EventDate, c.CountryName
FROM tblEvent e
JOIN tblCountry c ON c.CountryID = e.CountryID
WHERE EventDate >
	(
	SELECT MAX(EventDate)
	FROM tblEvent 
	WHERE CountryID = 21
	)
ORDER BY EventDate DESC;




