
-- Insert data into the Employee table
INSERT INTO Employee (FirstName, LastName, JobTitle)
VALUES 
('John', 'Doe', 'Project Manager'),
('Jane', 'Smith', 'Software Developer'),
('Michael', 'Johnson', 'UX Designer'),
('Emily', 'Davis', 'QA Engineer'),
('David', 'Miller', 'Software Developer'),
('Sarah', 'Wilson', 'Project Manager'),
('James', 'Brown', 'QA Engineer');

-- Insert data into the Project table
INSERT INTO Project (ProjectName, CreationDate, IsOpen, CloseDate)
VALUES
('Website Redesign', '2024-01-15', 1, NULL),
('Mobile App Development', '2024-02-01', 1, NULL),
('Cloud Migration', '2024-01-25', 1, NULL),
('Internal System Update', '2023-12-15', 0, '2024-01-10'),
('Customer Portal', '2024-01-05', 1, NULL);

-- Insert data into the EmployeeProject table
INSERT INTO EmployeeProject (EmployeeID, ProjectID, Role)
VALUES
(1, 1, 'Project Manager'),
(2, 1, 'Software Developer'),
(3, 1, 'UX Designer'),
(4, 2, 'QA Engineer'),
(5, 2, 'Software Developer'),
(1, 3, 'Project Manager'),
(6, 4, 'Project Manager');

-- Insert data into the Task table
INSERT INTO Task (TaskName, ProjectID, AssignedEmployeeID, Status)
VALUES
('Design Mockups', 1, 3, 'open'),
('Develop Backend', 2, 5, 'open'),
('Write Unit Tests', 2, 4, 'open'),
('Prepare Deployment', 3, 2, 'open'),
('Update Internal Docs', 4, 6, 'done'),
('Develop Frontend', 5, 2, 'need work'),
('Test Features', 5, 4, 'accepted');

-- Insert data into the StatusChange table
INSERT INTO StatusChange (TaskID, ChangeDate, Status, ChangedByEmployeeID)
VALUES
(1, '2024-01-16 10:00', 'done', 3),
(2, '2024-02-05 12:30', 'need work', 4),
(3, '2024-02-03 14:00', 'accepted', 6),
(4, '2024-01-09 09:15', 'done', 1),
(5, '2024-01-10 16:45', 'open', 2),
(6, '2024-01-12 11:30', 'open', 4),
(7, '2024-01-14 15:00', 'need work', 5);
