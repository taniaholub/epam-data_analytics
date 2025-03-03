USE WorldEvents
GO

SELECT  EventDetails  FROM tblEvent;

WITH ThisAndThat AS (
	SELECT 
        EventID, 
        EventDetails,
        CASE 
            WHEN EventDetails LIKE '%this%' THEN 1 
            ELSE 0 
        END AS IfThis,
        CASE 
            WHEN EventDetails LIKE '%that%' THEN 1 
            ELSE 0 
        END AS IfThat
    FROM tblEvent
)
SELECT IfThis, IfThat, COUNT(*) AS EventCount
FROM ThisAndThat
GROUP BY IfThis, IfThat
;

WITH ThisAndThat AS (
    SELECT 
        EventID, 
        EventDetails
    FROM tblEvent
    WHERE EventDetails LIKE '%this%' 
      AND EventDetails LIKE '%that%'
)

SELECT EventID, EventDetails
FROM ThisAndThat
ORDER BY EventID;