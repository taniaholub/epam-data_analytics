USE master;
GO

--Drop the database if it already exists
IF EXISTS (SELECT name
           FROM sys.databases
           WHERE name = N'ProjectManagementDB')
    DROP DATABASE ProjectManagementDB;
GO

CREATE DATABASE ProjectManagementDB;
GO

ALTER DATABASE [ProjectManagementDB]
    SET QUERY_STORE = ON;
GO

USE ProjectManagementDB;
GO

-- -----------------------------------------------------
-- Table [Employee]
-- -----------------------------------------------------
-- Check if the table exists and drop it if necessary
IF OBJECT_ID('Employee', 'U') IS NOT NULL
    DROP TABLE Employee;
GO

-- Create the Employee table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    JobTitle NVARCHAR(50) NOT NULL
);
GO

-- -----------------------------------------------------
-- Table [Project]
-- -----------------------------------------------------
-- Check if the table exists and drop it if necessary
IF OBJECT_ID('Project', 'U') IS NOT NULL
    DROP TABLE Project;
GO

-- Create the Project table
CREATE TABLE Project (
    ProjectID INT PRIMARY KEY IDENTITY(1,1),
    ProjectName NVARCHAR(100) NOT NULL,
    CreationDate DATE NOT NULL,
    IsOpen BIT NOT NULL,
    CloseDate DATE NULL
);
GO

-- -----------------------------------------------------
-- Table [EmployeeProject]
-- -----------------------------------------------------
-- Check if the table exists and drop it if necessary
IF OBJECT_ID('EmployeeProject', 'U') IS NOT NULL
    DROP TABLE EmployeeProject;
GO

-- Create the EmployeeProject table
CREATE TABLE EmployeeProject (
    EmployeeID INT NOT NULL,
    ProjectID INT NOT NULL,
    Role NVARCHAR(50) NOT NULL,
    PRIMARY KEY (EmployeeID, ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);
GO

-- -----------------------------------------------------
-- Table [Task]
-- -----------------------------------------------------
-- Check if the table exists and drop it if necessary
IF OBJECT_ID('Task', 'U') IS NOT NULL
    DROP TABLE Task;
GO

-- Create the Task table
CREATE TABLE Task (
 TaskID INT PRIMARY KEY IDENTITY(1,1),
    TaskName NVARCHAR(100) NOT NULL,
    ProjectID INT NOT NULL,
    AssignedEmployeeID INT NOT NULL,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('open', 'done', 'need work', 'accepted')),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID),
    FOREIGN KEY (AssignedEmployeeID) REFERENCES Employee(EmployeeID)
);
GO

-- -----------------------------------------------------
-- Table [StatusChange]
-- -----------------------------------------------------
-- Check if the table exists and drop it if necessary
IF OBJECT_ID('StatusChange', 'U') IS NOT NULL
    DROP TABLE StatusChange;
GO

-- Create the StatusChange table
CREATE TABLE StatusChange (
    StatusChangeID INT PRIMARY KEY IDENTITY(1,1),
    TaskID INT NOT NULL,
    ChangeDate DATETIME NOT NULL,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('open', 'done', 'need work', 'accepted')),
    ChangedByEmployeeID INT NOT NULL,
    FOREIGN KEY (TaskID) REFERENCES Task(TaskID),
    FOREIGN KEY (ChangedByEmployeeID) REFERENCES Employee(EmployeeID)
);
GO

