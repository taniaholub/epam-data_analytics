use HotelDB;


-- Insert customer data into the Customer table
INSERT INTO Customer (customer_surname, customer_name, middle_name, passport_data, address, comments)
VALUES
-- Ukrainian clients
('Коваленко', 'Олена', 'Петрівна', 'GH234567', 'Dnipro, Ukraine', NULL),  -- No additional comments
('Шевченко', 'Тарас', 'Григорович', 'UA123456', 'Kyiv, Ukraine', 'Regular customer'),  -- Frequent client
('Бондаренко', 'Ірина', 'Олександрівна', 'KH567890', 'Odesa, Ukraine', 'Prefers luxury rooms'),  -- Preference for luxury rooms
('Мельник', 'Андрій', 'Васильович', 'LV890123', 'Lviv, Ukraine', NULL),  -- No comments provided
('Сидоренко', 'Марія', 'Іванівна', 'PL456789', 'Kharkiv, Ukraine', 'Booked an extra bed for a child'),  -- Family booking

-- Foreign clients
('Doe', 'Jane', NULL, 'IJ345678', 'New York, USA', 'Returning customer'),  -- Regular guest from the USA
('Brown', 'Michael', NULL, 'KL456789', 'Sydney, Australia', 'Requested a quiet room'),  -- Special request for a quiet environment
('Gonzalez', 'Maria', NULL, 'MN567890', 'Barcelona, Spain', NULL),  -- No additional comments
('Lee', 'Min', 'Ho', 'OP678901', 'Seoul, South Korea', 'VIP guest'),  -- High-profile guest
('Wang', 'Li', 'Hua', 'QR789012', 'Beijing, China', 'Prefers high floors');  -- Specific preference for room location


-- Insert data into the Discounts table
INSERT INTO Discounts (discount_type, discount_percentage, discount_description)
VALUES
('Corporate', 20, 'Discount for corporate partnerships'), -- Corporate partnership discount
('Early Booking', 10, 'Booking made 30+ days before arrival'), -- Early booking discount
('Weekend Special Offer', 15, 'Discount for weekend stays'), -- Discount for weekend stays
('Long Stay', 25, 'Discount for stays longer than 7 days'); -- Long-stay discount

-- Insert data into the Customer_has_discount table
INSERT INTO Customer_has_discount (id_discount, id_customer)
VALUES
(1, 4), -- Corporate discount applied to customer with ID 4
(2, 5), -- Early booking discount applied to customer with ID 5
(3, 6), -- Weekend special offer applied to customer with ID 6
(4, 7), -- Long stay discount applied to customer with ID 7
(1, 8), -- Corporate discount applied to customer with ID 8
(2, 9); -- Early booking discount applied to customer with ID 9


-- Insert data into the Rooms table
INSERT INTO Rooms (room_type, capacity, price, availability)
VALUES
('Deluxe', 2, 200, 'Free'),
('Suite', 4, 500, 'Occupied'),
('Single', 1, 80, 'Free'),
('Double', 2, 120, 'Reserved'),
('Penthouse', 6, 1000, 'Free'),
('Standard', 3, 250, 'Occupied'),
('Economy', 1, 60, 'Reserved');

-- Insert data into the Reservations table
INSERT INTO Reservations (startDate, endDate, id_customer, id_room, total_price)
VALUES
('2024-12-01', '2024-12-07', 4, 1, 1200),
('2024-12-10', '2024-12-15', 5, 2, 750),
('2024-11-22', '2024-11-29', 6, 3, 560),
('2024-11-20', '2024-11-25', 7, 4, 800),
('2024-12-05', '2024-12-12', 8, 5, 1750);

-- Insert data into the Occupancies table
INSERT INTO Occupancies (id_reservation, check_in_date, check_out_date)
VALUES
(3, '2024-11-22 14:00:00', '2024-11-29 11:00:00'),
(4, '2024-11-20 14:00:00', NULL), -- Customer not checked out yet
(5, '2024-12-05 15:00:00', '2024-12-05 16:00:00'), -- Short stay, checked out after 1 hour
(1, '2024-12-01 14:00:00', '2024-12-07 12:00:00'),
(3, '2024-11-20 16:00:00', NULL), -- Customer not checked out yet
(2, '2024-12-10 14:30:00', '2024-12-12 11:00:00');
