USE master;
GO

--Drop the database if it already exists
IF EXISTS (SELECT name
           FROM sys.databases
           WHERE name = N'HotelDB')
    DROP DATABASE HotelDB;
GO

CREATE DATABASE HotelDB;
GO

ALTER DATABASE [HotelDB]
    SET QUERY_STORE = ON;
GO

USE HotelDB;
GO

-- -----------------------------------------------------
-- Table [Customer]
-- -----------------------------------------------------
-- Check if the table exists and drop it if necessary
IF OBJECT_ID('Customer', 'U') IS NOT NULL
    DROP TABLE Customer;
GO

-- Create the Customer table
CREATE TABLE Customer (
    id_customer INT IDENTITY(1,1) NOT NULL,
    customer_surname NVARCHAR(45) NOT NULL,
    customer_name NVARCHAR(40) NOT NULL,
    middle_name NVARCHAR(45) NULL DEFAULT NULL,
    passport_data NVARCHAR(45) NOT NULL,
    address NVARCHAR(255) NOT NULL,
    comments NVARCHAR(255) NULL DEFAULT NULL,
    CONSTRAINT PK_Customer PRIMARY KEY (id_customer),
    CONSTRAINT UQ_PassportData UNIQUE (passport_data)
);
GO

-- -----------------------------------------------------
-- Table [Discounts]
-- -----------------------------------------------------
-- Drop the table if it exists
IF OBJECT_ID('Discounts', 'U') IS NOT NULL
    DROP TABLE Discounts;
GO

-- Create the Discounts table
CREATE TABLE Discounts (
    id_discount INT IDENTITY(1,1) NOT NULL,
    discount_type NVARCHAR(155) NOT NULL,
    discount_percentage INT NOT NULL,
    discount_description NVARCHAR(255) NULL DEFAULT NULL,
    CONSTRAINT PK_discounts PRIMARY KEY (id_discount)
);
GO

-- -----------------------------------------------------
-- Table [Customer_has_discount]
-- -----------------------------------------------------
IF OBJECT_ID ('Customer_has_discount', 'U') IS NOT NULL
DROP TABLE Customer_has_discount;
GO

CREATE TABLE Customer_has_discount (
    id_customer_discount INT IDENTITY(1,1) NOT NULL,
    id_discount INT NOT NULL,
    id_customer INT NOT NULL,
    PRIMARY KEY (id_customer_discount),
    -- Indexes for speeding up queries
    INDEX idx_customer (id_customer),
    INDEX idx_discount (id_discount),
    -- Foreign keys
    CONSTRAINT FK_Customer FOREIGN KEY (id_customer)
        REFERENCES Customer (id_customer),
    CONSTRAINT FK_Discount FOREIGN KEY (id_discount)
        REFERENCES Discounts (id_discount)
);
GO

-- -----------------------------------------------------
-- Table [Rooms]
-- -----------------------------------------------------
IF OBJECT_ID('Rooms', 'U') IS NOT NULL
    DROP TABLE Rooms;
GO

CREATE TABLE Rooms (
    id_room INT IDENTITY(1,1) NOT NULL,
    room_type NVARCHAR(25) NOT NULL,
    capacity INT NOT NULL,
    price INT NOT NULL,
    availability NVARCHAR(10) NOT NULL DEFAULT 'Free',
    CONSTRAINT PK_room PRIMARY KEY (id_room),
    CONSTRAINT CHK_availability CHECK (availability IN ('Free', 'Occupied', 'Reserved'))
);
GO


-- -----------------------------------------------------
-- Table [Reservations]
-- -----------------------------------------------------
IF OBJECT_ID('Reservations', 'U') IS NOT NULL
    DROP TABLE Reservations;
GO

CREATE TABLE Reservations (
    id_reservation INT IDENTITY(1,1) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    id_customer INT NOT NULL,
    id_room INT NOT NULL,
    total_price INT NULL DEFAULT NULL,
    PRIMARY KEY (id_reservation),
    -- Indexes for speeding up queries
    INDEX idx_customer (id_customer),
    INDEX idx_room (id_room),
    -- Foreign keys
    CONSTRAINT FK_Reservations_Customer FOREIGN KEY (id_customer)
        REFERENCES Customer (id_customer),
    CONSTRAINT FK_Reservations_Room FOREIGN KEY (id_room)
        REFERENCES Rooms (id_room)
);
GO

-- -----------------------------------------------------
-- Table [Occupancies]
-- -----------------------------------------------------
IF OBJECT_ID('Occupancies', 'U') IS NOT NULL
    DROP TABLE Occupancies;
GO

CREATE TABLE Occupancies (
    id_occupancy INT IDENTITY(1,1) NOT NULL,
    id_reservation INT NOT NULL,
    check_in_date DATETIME NULL DEFAULT NULL,
    check_out_date DATETIME NULL DEFAULT NULL,
    PRIMARY KEY (id_occupancy),
    INDEX idx_reservation (id_reservation),
    CONSTRAINT FK_Occupancies_Reservations FOREIGN KEY (id_reservation)
        REFERENCES Reservations (id_reservation)
);
GO
