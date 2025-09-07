-- Query 1: Aggregation with COUNT and GROUP BY
-- Find the total number of bookings made by each user

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
ORDER BY 
    total_bookings DESC, u.user_id;

-- Alternative version: Only users who have made bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM 
    User u
INNER JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
ORDER BY 
    total_bookings DESC;

-- =====================================================

-- Query 2: Window Functions - ROW_NUMBER and RANK
-- Rank properties based on the total number of bookings they have received

-- Using ROW_NUMBER() - Assigns unique sequential numbers
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank_row_number
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.location, p.pricepernight
ORDER BY 
    total_bookings DESC;

-- Using RANK() - Assigns same rank to ties, with gaps
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.location, p.pricepernight
ORDER BY 
    total_bookings DESC;

-- Combined query showing both ROW_NUMBER and RANK for comparison
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number_rank,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank_with_ties,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.location, p.pricepernight
ORDER BY 
    total_bookings DESC, p.property_id;

-- =====================================================
-- Additional Advanced Examples
-- =====================================================

-- Advanced Query 1: Partition by location to rank properties within each location
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (PARTITION BY p.location ORDER BY COUNT(b.booking_id) DESC) AS location_rank,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS overall_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.location, p.pricepernight
ORDER BY 
    p.location, total_bookings DESC;

-- Advanced Query 2: Running totals and percentiles for user bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS user_rank,
    SUM(COUNT(b.booking_id)) OVER (ORDER BY COUNT(b.booking_id) DESC) AS running_total_bookings,
    ROUND(
        PERCENT_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) * 100, 2
    ) AS percentile_rank
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name
HAVING 
    COUNT(b.booking_id) > 0
ORDER BY 
    total_bookings DESC;

-- Advanced Query 3: Monthly booking trends with window functions
SELECT 
    DATE_FORMAT(b.start_date, '%Y-%m') AS booking_month,
    COUNT(*) AS monthly_bookings,
    SUM(COUNT(*)) OVER (ORDER BY DATE_FORMAT(b.start_date, '%Y-%m')) AS cumulative_bookings,
    LAG(COUNT(*), 1) OVER (ORDER BY DATE_FORMAT(b.start_date, '%Y-%m')) AS previous_month_bookings,
    ROUND(
        (COUNT(*) - LAG(COUNT(*), 1) OVER (ORDER BY DATE_FORMAT(b.start_date, '%Y-%m'))) * 100.0 / 
        LAG(COUNT(*), 1) OVER (ORDER BY DATE_FORMAT(b.start_date, '%Y-%m')), 2
    ) AS month_over_month_growth_percent
FROM 
    Booking b
WHERE 
    b.status = 'confirmed'
GROUP BY 
    DATE_FORMAT(b.start_date, '%Y-%m')
ORDER BY 
    booking_month;

-- Advanced Query 4: Top performing properties by revenue with window functions
WITH property_revenue AS (
    SELECT 
        p.property_id,
        p.name AS property_name,
        p.location,
        COUNT(b.booking_id) AS total_bookings,
        SUM(
            DATEDIFF(b.end_date, b.start_date) * p.pricepernight
        ) AS total_revenue
    FROM 
        Property p
    LEFT JOIN 
        Booking b ON p.property_id = b.property_id 
        AND b.status = 'confirmed'
    GROUP BY 
        p.property_id, p.name, p.location
)
SELECT 
    property_id,
    property_name,
    location,
    total_bookings,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    RANK() OVER (ORDER BY total_bookings DESC) AS booking_rank,
    NTILE(4) OVER (ORDER BY total_revenue DESC) AS revenue_quartile,
    ROUND(
        total_revenue / SUM(total_revenue) OVER () * 100, 2
    ) AS revenue_percentage_of_total
FROM 
    property_revenue
WHERE 
    total_revenue > 0
ORDER BY 
    total_revenue DESC;
