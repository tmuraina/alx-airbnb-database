-- =====================================================

-- Query 1: Non-correlated subquery
-- Find all properties where the average rating is greater than 4.0
-- This uses a non-correlated subquery in the WHERE clause

SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    p.host_id
FROM 
    Property p
WHERE 
    p.property_id IN (
        SELECT 
            r.property_id
        FROM 
            Review r
        GROUP BY 
            r.property_id
        HAVING 
            AVG(r.rating) > 4.0
    );

-- Alternative approach using EXISTS (also non-correlated)
-- This version might be more efficient in some database systems
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    p.host_id
FROM 
    Property p
WHERE 
    EXISTS (
        SELECT 1
        FROM Review r
        WHERE r.property_id = p.property_id
        GROUP BY r.property_id
        HAVING AVG(r.rating) > 4.0
    );

-- =====================================================

-- Query 2: Correlated subquery
-- Find users who have made more than 3 bookings
-- This uses a correlated subquery where the inner query references the outer query

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.created_at
FROM 
    User u
WHERE 
    (SELECT COUNT(*) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) > 3;

-- Alternative correlated subquery using EXISTS
-- This version checks if there are more than 3 bookings for each user
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.created_at
FROM 
    User u
WHERE 
    EXISTS (
        SELECT b.user_id
        FROM Booking b
        WHERE b.user_id = u.user_id
        GROUP BY b.user_id
        HAVING COUNT(*) > 3
    );

-- =====================================================
-- Additional Complex Subquery Examples for Practice
-- =====================================================

-- Bonus Query 1: Find properties in locations where the average property price is above the overall average
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight
FROM 
    Property p
WHERE 
    p.location IN (
        SELECT 
            p2.location
        FROM 
            Property p2
        GROUP BY 
            p2.location
        HAVING 
            AVG(p2.pricepernight) > (
                SELECT AVG(pricepernight) 
                FROM Property
            )
    );

-- Bonus Query 2: Find users who have never made a booking (correlated subquery with NOT EXISTS)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM 
    User u
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM Booking b
        WHERE b.user_id = u.user_id
    );

-- Bonus Query 3: Find the most expensive property in each location (correlated subquery)
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight
FROM 
    Property p
WHERE 
    p.pricepernight = (
        SELECT MAX(p2.pricepernight)
        FROM Property p2
        WHERE p2.location = p.location
    );
