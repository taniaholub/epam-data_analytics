USE WorldEvents;
GO

SELECT * FROM tblCountry;
SELECT * FROM tblEvent;

--Write a query which lists out countries which have more than 8 events

SELECT c.CountryName
FROM tblCountry c
WHERE (SELECT COUNT(*) FROM tblEvent e WHERE e.CountryID = c.CountryID) > 8
ORDER BY c.CountryName;
