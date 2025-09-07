
-- =====================================================
-- INITIAL COMPLEX QUERY (BEFORE OPTIMIZATION)
-- =====================================================

-- Query: Retrieve all bookings with user details, property details, and payment details
-- This is the initial, unoptimized version that we'll analyze and improve

SELECT 
    -- Booking details
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_created,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.date_of_birth,
    u.created_at AS user_created,
    
    -- Property details
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created,
    
    -- Host details (additional join)
    h.user_id AS host_id,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    h.email AS host_email,
    
    -- Payment details
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
    
FROM Booking b
    -- Join with User table for guest details
    JOIN User u ON b.user_id = u.user_id
    
    -- Join with Property table for property details
    JOIN Property p ON b.property_id = p.property_id
    
    -- Join with User table again for host details (inefficient)
    JOIN User h ON p.host_id = h.user_id
    
    -- Join with Payment table for payment details
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
    
ORDER BY b.created_at DESC, b.booking_id;

-- =====================================================
-- PERFORMANCE ANALYSIS QUERIES
-- =====================================================

-- Query to check execution plan for the initial query
EXPLAIN FORMAT=JSON
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    u.first_name,
    u.last_name,
    u.email,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    pay.amount,
    pay.payment_method
FROM Booking b
    JOIN User u ON b.user_id = u.user_id
    JOIN Property p ON b.property_id = p.property_id
    JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC
LIMIT 100;

-- =====================================================
-- OPTIMIZED QUERIES (AFTER ANALYSIS)
-- =====================================================

-- OPTIMIZATION 1: Selective Column Retrieval
-- Only select necessary columns to reduce data transfer and memory usage

SELECT 
    -- Essential booking information only
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    
    -- Key user details only
    u.first_name,
    u.last_name,
    u.email,
    
    -- Essential property details only
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    -- Host name only (most commonly needed)
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    
    -- Payment summary only
    pay.amount,
    pay.payment_method
    
FROM Booking b
    JOIN User u ON b.user_id = u.user_id
    JOIN Property p ON b.property_id = p.property_id
    JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
    
WHERE b.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)  -- Recent bookings only
ORDER BY b.created_at DESC
LIMIT 100;  -- Pagination

-- =====================================================

-- OPTIMIZATION 2: Using Subqueries to Reduce Join Complexity
-- Break down complex joins into smaller, more efficient operations

-- First, get the main booking data with user and property info
WITH booking_base AS (
    SELECT 
        b.booking_id,
        b.user_id,
        b.property_id,
        b.start_date,
        b.end_date,
        b.total_price,
        b.status AS booking_status,
        b.created_at,
        u.first_name,
        u.last_name,
        u.email,
        p.name AS property_name,
        p.location,
        p.pricepernight,
        p.host_id
    FROM Booking b
        JOIN User u ON b.user_id = u.user_id
        JOIN Property p ON b.property_id = p.property_id
    WHERE b.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
),
-- Then get host information separately
host_info AS (
    SELECT 
        u.user_id AS host_id,
        CONCAT(u.first_name, ' ', u.last_name) AS host_name
    FROM User u
    WHERE u.user_id IN (SELECT DISTINCT host_id FROM booking_base)
)
-- Combine the results
SELECT 
    bb.*,
    hi.host_name,
    pay.amount,
    pay.payment_method
FROM booking_base bb
    LEFT JOIN host_info hi ON bb.host_id = hi.host_id
    LEFT JOIN Payment pay ON bb.booking_id = pay.booking_id
ORDER BY bb.created_at DESC
LIMIT 100;

-- =====================================================

-- OPTIMIZATION 3: Index-Optimized Query
-- Leverage indexes created in Task 3 for maximum performance

SELECT /*+ USE_INDEX(b, idx_booking_created_at) */
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    
    -- User details with covering index consideration
    u.first_name,
    u.last_name,
    u.email,
    
    -- Property details optimized for index usage
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    -- Host details (minimal to reduce join cost)
    CONCAT(h.first_name, ' ', h.last_name) AS host_name,
    
    -- Payment details
    pay.amount,
    pay.payment_method
    
FROM Booking b
    INNER JOIN User u ON b.user_id = u.user_id
    INNER JOIN Property p ON b.property_id = p.property_id
    INNER JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
    
WHERE 
    b.status IN ('confirmed', 'completed')  -- Use index on status
    AND b.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)  -- Use index on created_at
    
ORDER BY b.created_at DESC  -- Leverage index for sorting
LIMIT 100;

-- =====================================================

-- OPTIMIZATION 4: Materialized View Approach
-- For frequently accessed booking summaries

CREATE VIEW booking_summary_view AS
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at,
    
    -- Pre-computed user info
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    
    -- Pre-computed property info
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    -- Pre-computed host info
    CONCAT(h.first_name, ' ', h.last_name) AS host_name,
    
    -- Payment info
    pay.amount AS payment_amount,
    pay.payment_method
    
FROM Booking b
    JOIN User u ON b.user_id = u.user_id
    JOIN Property p ON b.property_id = p.property_id
    JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id;

-- Query using the materialized view (much faster)
SELECT * FROM booking_summary_view
WHERE booking_status IN ('confirmed', 'completed')
    AND created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY created_at DESC
LIMIT 100;

-- =====================================================

-- OPTIMIZATION 5: Paginated Query with Cursor-based Pagination
-- More efficient than OFFSET for large datasets

-- First page
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at,
    
    u.first_name,
    u.last_name,
    u.email,
    
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    CONCAT(h.first_name, ' ', h.last_name) AS host_name,
    
    pay.amount,
    pay.payment_method
    
FROM Booking b
    JOIN User u ON b.user_id = u.user_id
    JOIN Property p ON b.property_id = p.property_id
    JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
    
WHERE b.status IN ('confirmed', 'completed')
    AND b.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    
ORDER BY b.created_at DESC, b.booking_id DESC
LIMIT 50;

-- Subsequent pages (using cursor from previous page)
-- Replace @last_created_at and @last_booking_id with actual values
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at,
    
    u.first_name,
    u.last_name,
    u.email,
    
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    CONCAT(h.first_name, ' ', h.last_name) AS host_name,
    
    pay.amount,
    pay.payment_method
    
FROM Booking b
    JOIN User u ON b.user_id = u.user_id
    JOIN Property p ON b.property_id = p.property_id
    JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
    
WHERE b.status IN ('confirmed', 'completed')
    AND b.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    AND (
        b.created_at < @last_created_at 
        OR (b.created_at = @last_created_at AND b.booking_id < @last_booking_id)
    )
    
ORDER BY b.created_at DESC, b.booking_id DESC
LIMIT 50;

-- =====================================================
-- PERFORMANCE COMPARISON QUERIES
-- =====================================================

-- Query to test different optimization approaches
-- Run these with EXPLAIN to compare execution plans

-- Test 1: Original query performance
EXPLAIN FORMAT=JSON
SELECT COUNT(*) as total_joins
FROM Booking b
    JOIN User u ON b.user_id = u.user_id
    JOIN Property p ON b.property_id = p.property_id
    JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id;

-- Test 2: Optimized query performance
EXPLAIN FORMAT=JSON
SELECT COUNT(*) as total_optimized
FROM Booking b
    JOIN User u ON b.user_id = u.user_id
    JOIN Property p ON b.property_id = p.property_id
    JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status IN ('confirmed', 'completed')
    AND b.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Test 3: View-based query performance
EXPLAIN FORMAT=JSON
SELECT COUNT(*) FROM booking_summary_view
WHERE booking_status IN ('confirmed', 'completed')
    AND created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- =====================================================
-- CLEANUP COMMANDS
-- =====================================================

-- Drop the view if needed for testing
-- DROP VIEW IF EXISTS booking_summary_view;
