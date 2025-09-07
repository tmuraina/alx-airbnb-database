-- 1. INNER JOIN: Retrieve all bookings and the respective users who made those bookings
SELECT b.id AS booking_id,
       b.property_id,
       b.start_date,
       b.end_date,
       u.id AS user_id,
       u.name AS user_name,
       u.email
FROM bookings b
INNER JOIN users u ON b.user_id = u.id;

-- 2. LEFT JOIN: Retrieve all properties and their reviews, including properties with no reviews
SELECT p.id AS property_id,
       p.name AS property_name,
       p.location,
       r.id AS review_id,
       r.rating,
       r.comment
FROM properties p
LEFT JOIN reviews r ON p.id = r.property_id;

-- 3. FULL OUTER JOIN: Retrieve all users and all bookings
-- Note: MySQL does not support FULL OUTER JOIN directly.
-- If you’re using PostgreSQL, this works directly.
-- For MySQL, simulate with UNION of LEFT and RIGHT JOINs.

-- PostgreSQL:
SELECT u.id AS user_id,
       u.name AS user_name,
       b.id AS booking_id,
       b.property_id,
       b.start_date,
       b.end_date
FROM users u
FULL OUTER JOIN bookings b ON u.id = b.user_id;

-- MySQL (alternative using UNION):
SELECT u.id AS user_id,
       u.name AS user_name,
       b.id AS booking_id,
       b.property_id,
       b.start_date,
       b.end_date
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
UNION
SELECT u.id AS user_id,
       u.name AS user_name,
       b.id AS booking_id,
       b.property_id,
       b.start_date,
       b.end_date
FROM users u
RIGHT JOIN bookings b ON u.id = b.user_id;


-- 2. LEFT JOIN - Properties and Reviews

-- Retrieves all properties and their reviews, including properties with no reviews.

SELECT p.id AS property_id,
       p.name AS property_name,
       p.location,
       r.id AS review_id,
       r.rating,
       r.comment
FROM properties p
LEFT JOIN reviews r ON p.id = r.property_id;

-- 3. FULL OUTER JOIN - Users and Bookings

-- Retrieves all users and all bookings, even if:

-- A user has no booking

-- A booking has no linked user

PostgreSQL:

SELECT u.id AS user_id,
       u.name AS user_name,
       b.id AS booking_id,
       b.property_id,
       b.start_date,
       b.end_date
FROM users u
FULL OUTER JOIN bookings b ON u.id = b.user_id;


-- MySQL (simulated with UNION):
SELECT u.id AS user_id,
       u.name AS user_name,
       b.id AS booking_id,
       b.property_id,
       b.start_date,
       b.end_date
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
UNION
SELECT u.id AS user_id,
       u.name AS user_name,
       b.id AS booking_id,
       b.property_id,
       b.start_date,
       b.end_date
FROM users u
RIGHT JOIN bookings b ON u.id = b.user_id;

