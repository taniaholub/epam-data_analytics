USE DoctorWho;
GO

SELECT * FROM tblEpisode;
SELECT * FROM tblCompanion;
SELECT * FROM tblEpisodeCompanion;

SELECT c.CompanionId, c.CompanionName 
FROM tblCompanion c
LEFT JOIN tblEpisodeCompanion ec ON ec.CompanionId = c.CompanionId
WHERE ec.CompanionId IS NULL;