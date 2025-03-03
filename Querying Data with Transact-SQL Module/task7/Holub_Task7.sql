USE DoctorWho;
GO


WITH EpisodeInfo AS (
	SELECT YEAR(EpisodeDate) AS EpisodeYear, 
	SeriesNumber, 
	EpisodeId 
	FROM tblEpisode
	WHERE SeriesNumber BETWEEN 1 AND 5
)
SELECT * 
FROM (
    SELECT EpisodeYear, SeriesNumber, EpisodeId
    FROM EpisodeInfo
) AS SourceTable
PIVOT (
    COUNT(EpisodeId) FOR SeriesNumber IN ([1], [2], [3], [4], [5])
) AS PivotTable
ORDER BY EpisodeYear;