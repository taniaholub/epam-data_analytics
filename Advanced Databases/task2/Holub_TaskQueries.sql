use ProjectManagementDB;

GO

SELECT * FROM Employee;
SELECT * FROM Project;
SELECT * FROM EmployeeProject;
SELECT * FROM Task;
SELECT * FROM StatusChange;
SELECT * FROM Project;


-- 1. Retrieve a list of all roles in the company, 
-- which should include the number of employees for each of role assigned

SELECT JobTitle, Count(JobTitle) AS NumberOfEmployees
FROM Employee
Group by JobTitle;


-- 2. Get roles which has no employees assigned 

SELECT DISTINCT Role
FROM EmployeeProject
WHERE EmployeeID IS NULL
   OR EmployeeID NOT IN (SELECT EmployeeID FROM Employee);


-- 3. Get projects list where every project has list of roles 
-- supplied with number of employees

SELECT * FROM Project;
SELECT * FROM EmployeeProject;

SELECT 
    p.ProjectID, 
    p.ProjectName, 
    ep.Role, 
    COUNT(ep.EmployeeID) AS EmployeeNumber
FROM 
    Project p
JOIN 
    EmployeeProject ep ON ep.ProjectID = p.ProjectID
GROUP BY 
    p.ProjectID, p.ProjectName, ep.Role
ORDER BY 
    p.ProjectID, ep.Role;



-- 4. For every project count how many tasks there are assigned for every
-- employee in average


SELECT * FROM Task;
SELECT * FROM Project;

SELECT 
    ts.ProjectID, 
    p.ProjectName,  
    AVG(ts.TaskCount) AS AvgTasksPerEmployee
FROM (
    SELECT 
        ProjectID,
        AssignedEmployeeID,
        COUNT(TaskID) AS TaskCount
    FROM 
        Task
    GROUP BY 
        ProjectID, AssignedEmployeeID
) AS ts
JOIN Project p ON ts.ProjectID = p.ProjectID
GROUP BY 
    ts.ProjectID, p.ProjectName;



-- 5. Determine duration for each project

SELECT * FROM Project;

SELECT 
ProjectID, 
ProjectName, 
DATEDIFF(DAY, CreationDate, 
        CASE 
            WHEN IsOpen = 1 THEN GETDATE() 
            ELSE CloseDate 
        END
    ) AS DurationInDays
FROM Project;



-- 6. Identify which employees has the lowest number tasks with non-closed statuses.
SELECT * FROM Task;
SELECT * FROM Employee;

WITH NonClosedTasks AS (
    SELECT t.TaskID,
           t.AssignedEmployeeID,
           t.TaskName,
           t.Status
    FROM Task t
    WHERE t.Status IN ('open', 'need work', 'accepted') -- непідтверджені статуси
)

SELECT e.EmployeeID,
       e.FirstName,
       e.LastName,
       COALESCE(COUNT(nt.TaskID), 0) AS NonClosedTasksCount
FROM Employee e
	LEFT JOIN NonClosedTasks nt ON e.EmployeeID = nt.AssignedEmployeeID
	GROUP BY e.EmployeeID, e.FirstName, e.LastName
	ORDER BY NonClosedTasksCount ASC;  -- Сортуємо за кількістю завдань по зростанню
;



-- 7. Identify which employees has the most tasks with non-closed statuses with failed deadlines.

SELECT * FROM Task;
SELECT * FROM Employee;
SELECT * FROM StatusChange;


ALTER TABLE Task
ADD DeadLine DATE;

UPDATE Task 
SET DeadLine = CASE
                    WHEN t.TaskName = 'Design Mockups' THEN DATEADD(DAY, 10, p.CreationDate)
                    WHEN t.TaskName = 'Develop Backend' THEN DATEADD(DAY, 5, p.CreationDate)
                    WHEN t.TaskName = 'Write Unit Tests' THEN DATEADD(DAY, 7, p.CreationDate)
                    WHEN t.TaskName = 'Prepare Deployment' THEN DATEADD(DAY, 10, p.CreationDate)
                    WHEN t.TaskName = 'Update Internal Docs' THEN DATEADD(DAY, 7, p.CreationDate)
                    WHEN t.TaskName = 'Develop Frontend' THEN DATEADD(DAY, 12, p.CreationDate)
                    WHEN t.TaskName = 'Test Features' THEN DATEADD(DAY, 8, p.CreationDate)
                END
FROM Task t
JOIN Project p ON t.ProjectID = p.ProjectID;


WITH FailedDeadlineTasks AS (
    SELECT t.TaskID,
           t.AssignedEmployeeID,
           t.TaskName,
           t.Status,
           t.DeadLine,
           p.CreationDate
    FROM Task t
    JOIN Project p ON t.ProjectID = p.ProjectID
    WHERE t.Status IN ('open', 'need work', 'accepted') 
      AND t.DeadLine < GETDATE() -- дедлайн минув
) 
SELECT e.EmployeeID,
       e.FirstName,
       e.LastName,
       COUNT(fd.TaskID) AS FailedTasksCount
FROM Employee e
	LEFT JOIN FailedDeadlineTasks fd ON e.EmployeeID = fd.AssignedEmployeeID
	GROUP BY e.EmployeeID, e.FirstName, e.LastName
	ORDER BY FailedTasksCount DESC;
;




-- 8. Move forward deadline for non-closed tasks in 5 days.

UPDATE Task
SET Deadline =  DATEADD(DAY, 5, Deadline)
	WHERE Status NOT IN ('done', 'accepted')
	  AND DeadLine IS NOT NULL;


-- 9. For each project count how many there are tasks which were not started yet.
SELECT * FROM Task;
SELECT * FROM Project;

SELECT p.ProjectID, p.ProjectName, COUNT(t.TaskID) AS NotStartedTasks 
FROM Project p
	LEFT JOIN Task t ON p.ProjectID = t.ProjectID
	WHERE t.Status NOT IN ('done','accepted', 'need work')
	GROUP BY p.ProjectID, p.ProjectName
;



-- 10. For each project which has all tasks marked as closed move status to closed.
-- Close date for such project should match close date for the last accepted task.

ALTER TABLE Project
ADD Status AS (
    CASE 
        WHEN IsOpen = 1 THEN 'open'
        WHEN IsOpen = 0 THEN 'closed'
    END
);

UPDATE Project
SET CloseDate = CASE
                    WHEN ProjectID = 1 THEN '2024-02-24'
                    ELSE CloseDate 
                END;


SELECT * FROM Task;
SELECT * FROM Project;


UPDATE Project 
SET IsOpen = 0,
    CloseDate = (
        SELECT MAX(sc.ChangeDate)  
        FROM Task t
        JOIN StatusChange sc ON t.TaskID = sc.TaskID
        WHERE t.ProjectID = Project.ProjectID
        AND (t.Status = 'accepted' OR t.Status = 'done')
    )
WHERE ProjectID IN (
    SELECT p.ProjectID
    FROM Project p
    JOIN Task t ON t.ProjectID = p.ProjectID
    GROUP BY p.ProjectID
    HAVING COUNT(CASE WHEN t.Status NOT IN ('done', 'accepted') THEN 1 END) = 0
);



-- 11. Determine employees across all projects which has not non-closed tasks assigned.

SELECT * FROM Employee;
SELECT * FROM Project;
SELECT * FROM EmployeeProject;

SELECT e.EmployeeID, e.FirstName, e.LastName, p.ProjectID, p.ProjectName
FROM Employee e
	JOIN EmployeeProject ep ON e.EmployeeID = ep.EmployeeID
	JOIN Project p ON p.ProjectID = ep.ProjectID
	WHERE NOT EXISTS (
		SELECT 1
		FROM Task t
		 WHERE t.AssignedEmployeeID = e.EmployeeID
		AND t.Status NOT IN ('done', 'accepted')
);



-- 12. Assign given project task (using task name as identifier) to an employee which
-- has minimum tasks with open status.

SELECT * FROM Employee;
SELECT * FROM Task;


WITH OpenTasksNumber AS (
	SELECT t.AssignedEmployeeID, COUNT(t.TaskID) AS OpenTaskCount
	FROM Task t
    WHERE Status IN ('open', 'need work')
    GROUP BY AssignedEmployeeID
),
MinTasksNumber AS (
	SELECT TOP 1 AssignedEmployeeID
	FROM OpenTasksNumber
	ORDER BY OpenTaskCount ASC
)

INSERT INTO Task (TaskName, ProjectID, AssignedEmployeeID, Status, DeadLine)
VALUES (
    'New Assigned Task',                             
    1,                                     
    (SELECT AssignedEmployeeID FROM MinTasksNumber), 
    'open',                                 
    '2024-03-01'                            
);
;
