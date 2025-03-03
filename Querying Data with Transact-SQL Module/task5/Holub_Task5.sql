USE WorldEvents;
GO


SELECT * FROM tblContinent;
SELECT * FROM tblCountry;
SELECT * FROM tblEvent;

WITH ManyCountries AS (
    SELECT ContinentID, COUNT(DISTINCT CountryID) AS CountryPerContinent
    FROM tblCountry
    GROUP BY ContinentID
    HAVING COUNT(DISTINCT CountryID) >= 3
),
FewEvents AS (
    SELECT ct.ContinentID, ct.ContinentName, COUNT(DISTINCT e.EventID) AS EventsPerContinent
    FROM tblEvent e
    JOIN tblCountry c ON c.CountryID = e.CountryID
    JOIN tblContinent ct ON ct.ContinentID = c.ContinentID
    GROUP BY ct.ContinentID, ct.ContinentName
    HAVING COUNT(DISTINCT e.EventID) <= 10
)

SELECT mc.ContinentID, fe.ContinentName, mc.CountryPerContinent, fe.EventsPerContinent
FROM ManyCountries mc
JOIN FewEvents fe ON mc.ContinentID = fe.ContinentID;

