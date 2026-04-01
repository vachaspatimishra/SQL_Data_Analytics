-- Select 
-- Display all records from the hotel bookings table.
select * from hotel_bookings;
 
-- Display only guest_name and city for all bookings.
select guest_name, city from hotel_bookings;

-- Display all records but rename price_per_night as Price.
select booking_id, guest_name, room_type, city, price_per_night as price, nights, booking_date from hotel_bookings;

-- Display all bookings where only room_type and booking_date are shown.
select room_type, booking_date from hotel_bookings;


-- Where
-- Show all bookings from the Mumbai city.
select * from hotel_bookings where city = "Mumbai";

-- Show all bookings where price_per_night is greater than 5000.
select * from hotel_bookings where price_per_night > 5000;

-- Show all bookings made on 2025-02-01.
select * from hotel_bookings where booking_date = "2025-02-01";

-- Show all bookings where price_per_night is between 3000 and 7000.
select * from hotel_bookings where price_per_night >= 3000 and price_per_night <= 7000;

-- Show all bookings that are not from the Deluxe room type.
select * from hotel_bookings where room_type != "deluxe";


-- Logical Operators
-- Show all Deluxe room bookings with price greater than 6000.
select * from hotel_bookings where room_type = "deluxe" and  price_per_night > 6000;

-- Show all bookings from Mumbai OR Pune.
select * from hotel_bookings where city = "Mumbai" or city = "Pune";

-- Show all Suite bookings from Delhi OR Bangalore.
select * from hotel_bookings where room_type = "Suite" and (city = "Delhi" or city = "Mumbai");

-- Show all Standard room bookings in Pune.
select * from hotel_bookings where room_type = "Standard" and city = "Pune";

-- Show all bookings not made in Delhi.
select * from hotel_bookings where city != "Delhi";


-- Wildcards
-- Find all guest names that start with ‘A’.
select * from hotel_bookings where guest_name like "A%";

-- Find all guest names that end with ‘n’.
select * from hotel_bookings where guest_name like "%n";

-- Find all room types that contain the word ‘Suite’.
select * from hotel_bookings where room_type like "%Suite%";

-- Find all guest names with exactly 6 characters.
select * from hotel_bookings where guest_name like "______";

-- Find all cities whose name starts with ‘B’.
select * from hotel_bookings where city like "B%";

use hotel;
select * from hotel_bookings;

-- Distinct
-- Display all unique room types.
select distinct room_type from hotel_bookings;

-- Display all unique cities.
select distinct city from hotel_bookings;

-- Display all unique room type–city combinations.
select distinct room_type, city from hotel_bookings;

-- Display all unique booking dates.
select distinct booking_date from hotel_bookings;


-- Sort
-- Display all records sorted by price_per_night (lowest to highest).
select * from hotel_bookings order by price_per_night;

-- Display all records sorted by price_per_night (highest to lowest).
select * from hotel_bookings order by price_per_night desc;

-- Display all records sorted by booking_date (latest first).
select * from hotel_bookings order by booking_date desc;

-- Display all records sorted by city alphabetically.
select * from hotel_bookings order by city;

-- Display all records sorted by room_type, and within each room type by highest price.
select * from hotel_bookings order by room_type, price_per_night desc;


-- Limit
-- Display only the first 5 records.
select * from hotel_bookings limit 5;

-- Display the top 3 most expensive bookings.
select * from hotel_bookings order by price_per_night desc limit 3;

-- Display the latest 4 bookings.
select * from hotel_bookings order by booking_date desc limit 4;

-- Display records 6 to 12 from the table
select * from hotel_bookings booking_id limit 5, 7;

