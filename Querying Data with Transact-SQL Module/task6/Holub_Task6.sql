USE WorldEvents;
GO

SELECT * FROM tblEvent;

WITH EventEra AS (
		SELECT 
			CASE
				WHEN year(e.EventDate) < 1900 THEN
				'19th century and earlier'
				WHEN year(e.EventDate) < 2000 THEN
				'20th century'
				WHEN year(e.EventDate) < 2100 THEN
				'21th century'
			END AS Era,
			e.EventID
FROM tblEvent e
)
SELECT Era, COUNT(*) AS NumberOfEvents
FROM EventEra
GROUP BY Era
;