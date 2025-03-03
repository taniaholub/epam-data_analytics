USE HotelDB;

SELECT * FROM Customer;

SELECT * FROM Discounts;

SELECT * FROM Customer_has_discount;

SELECT * FROM Rooms;

SELECT * FROM Reservations;

SELECT * FROM Occupancies;


-- Retrieve all distinct room types in the hotel
SELECT DISTINCT room_type
FROM Rooms;

-- -----------------------------------------------------
-- JOIN
-- -----------------------------------------------------

-- Selects customers who have made a reservation and room information
SELECT c.id_customer, c.customer_surname, rs.id_reservation, r.room_type
FROM Reservations rs
INNER JOIN Customer c ON c.id_customer = rs.id_customer
INNER JOIN Rooms r ON r.id_room = rs.id_room
ORDER BY id_customer ASC;

-- LEFT JOIN: Selects all customers and corresponding reservation records, even if there is no reservation
SELECT c.id_customer, c.customer_surname, rs.id_reservation, rs.total_price
FROM Customer c
LEFT JOIN Reservations rs ON c.id_customer = rs.id_customer;

-- RIGHT JOIN: Selects all reservations and matching customers, even if the customer does not have a record
SELECT c.id_customer, c.customer_surname, rs.id_reservation, rs.total_price
FROM Customer c
RIGHT  JOIN Reservations rs ON c.id_customer = rs.id_customer
ORDER BY id_customer ASC;


-- -----------------------------------------------------
-- UNION, UNION ALL
-- -----------------------------------------------------
-- Select customer names and surnames where id_customer is 1, 2, or 3
SELECT customer_name, customer_surname
FROM Customer
WHERE id_customer IN (1, 2, 3)

-- Select customer names and surnames where address contains 'USA'
UNION -- Using UNION to combine results and eliminate duplicate records
SELECT customer_name, customer_surname
FROM Customer
WHERE address LIKE '%USA%';


-- Select customer names and addresses where the address contains 'Ukraine'
SELECT customer_name, address
FROM Customer
WHERE address LIKE '%Ukraine%'

-- Select customer names and passport data where customer_name starts with 'M'
UNION ALL 
SELECT customer_name, passport_data
FROM Customer
WHERE customer_name LIKE 'M%';



-- -----------------------------------------------------
-- GROUP BY, HAVING, COUNT, AVG, SUM
-- -----------------------------------------------------

-- Find the total number of reservations and the average price per room type
SELECT r.room_type, COUNT(*) AS total_reservations, AVG(r.price) AS average_price
FROM Rooms r
JOIN Reservations res ON r.id_room = res.id_room
GROUP BY r.room_type
HAVING COUNT(*) >= 1;  -- Only show room types with more than or = 1 reservation

-- Find the total price for reservations made by a specific customer 
SELECT SUM(r.total_price) AS total_spent
FROM Reservations r
WHERE r.id_customer = 6;


-- -----------------------------------------------------
-- More Queries
-- -----------------------------------------------------

-- Get a list of rooms that have been reserved or occupied (not free)
SELECT room_type, availability
FROM Rooms
WHERE availability IN ('Occupied', 'Reserved');


SELECT TOP 5 c.customer_surname, c.customer_name
FROM Customer c
JOIN Reservations r ON c.id_customer = r.id_customer
ORDER BY c.customer_name;

-- -----------------------------------------------------
-- Subqueries
-- -----------------------------------------------------

-- Find customers who have reservations in a room with a price higher than the average price of all rooms.
SELECT customer_surname, customer_name
FROM Customer
WHERE id_customer IN (
    SELECT id_customer
    FROM Reservations
    JOIN Rooms ON Reservations.id_room = Rooms.id_room
    WHERE Rooms.price > (SELECT AVG(price) FROM Rooms)
);


-- Find all customers with their total number of reservations.
SELECT customer_surname, customer_name,
       (SELECT COUNT(*) FROM Reservations WHERE Reservations.id_customer = Customer.id_customer) AS total_reservations
FROM Customer;


-- Find customers who have never made a reservation.
SELECT customer_surname, customer_name
FROM Customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM Reservations r
    WHERE r.id_customer = c.id_customer
);
