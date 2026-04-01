create database hotel;
use hotel;

create database hotels;

use hotels;

CREATE TABLE hotel_bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_name VARCHAR(50),
    room_type VARCHAR(30),
    city VARCHAR(30),
    price_per_night INT,
    nights INT,
    booking_date DATE
);

INSERT INTO hotel_bookings
(guest_name, room_type, city, price_per_night, nights, booking_date)
VALUES
('Aarav', 'Deluxe', 'Mumbai', 6500, 2, '2025-02-01'),
('Ankit', 'Standard', 'Pune', 3200, 1, '2025-02-02'),
('Rohan', 'Suite', 'Delhi', 9000, 3, '2025-02-01'),
('Kiran', 'Deluxe', 'Bangalore', 7000, 2, '2025-02-03'),
('Meena', 'Standard', 'Mumbai', 3500, 1, '2025-02-04'),
('Aman', 'Suite', 'Bangalore', 9500, 2, '2025-02-02'),
('Pooja', 'Deluxe', 'Pune', 6000, 1, '2025-02-05'),
('Suman', 'Standard', 'Delhi', 3000, 2, '2025-02-03'),
('Ritesh', 'Suite', 'Mumbai', 8800, 3, '2025-02-04'),
('Arjun', 'Deluxe', 'Delhi', 6800, 1, '2025-02-06'),
('Kunal', 'Standard', 'Bangalore', 3400, 2, '2025-02-05'),
('Aditi', 'Suite', 'Pune', 9200, 2, '2025-02-06'),
('Bhavin', 'Deluxe', 'Mumbai', 6300, 1, '2025-02-07'),
('Nitin', 'Standard', 'Pune', 3100, 1, '2025-02-07'),
('Ayaan', 'Suite', 'Delhi', 9700, 3, '2025-02-08');

select * from hotel_bookings;

