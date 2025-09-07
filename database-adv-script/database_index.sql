
-- =====================================================
-- ANALYSIS OF HIGH-USAGE COLUMNS
-- =====================================================

-- Based on common Airbnb clone query patterns, the following columns
-- are frequently used in WHERE, JOIN, and ORDER BY clauses:

-- USER TABLE:
-- - user_id (PRIMARY KEY - already indexed)
-- - email (login queries, user lookup)
-- - created_at (user registration analysis, date range queries)

-- PROPERTY TABLE:
-- - property_id (PRIMARY KEY - already indexed) 
-- - host_id (host-related queries, JOIN operations)
-- - location (location-based searches, filtering)
-- - pricepernight (price range filtering, ORDER BY price)
-- - created_at (property listing analysis)

-- BOOKING TABLE:
-- - booking_id (PRIMARY KEY - already indexed)
-- - user_id (JOIN with User table, user booking history)
-- - property_id (JOIN with Property table, property booking history)
-- - start_date (date range searches, availability queries)
-- - end_date (date range searches, availability queries)
-- - status (filtering by booking status)
-- - created_at (booking analysis, temporal queries)

-- REVIEW TABLE:
-- - review_id (PRIMARY KEY - already indexed)
-- - property_id (JOIN with Property table, property reviews)
-- - user_id (JOIN with User table, user reviews)
-- - rating (filtering by rating, ORDER BY rating)
-- - created_at (recent reviews, temporal analysis)

-- =====================================================
-- INDEX CREATION COMMANDS
-- =====================================================

-- USER TABLE INDEXES
-- =====================================================

-- Index for email lookups (login, user search)
CREATE INDEX idx_user_email ON User(email);

-- Index for user registration analysis and date-based queries
CREATE INDEX idx_user_created_at ON User(created_at);

-- Composite index for email and status queries (if applicable)
-- CREATE INDEX idx_user_email_status ON User(email, status);

-- PROPERTY TABLE INDEXES
-- =====================================================

-- Index for host-related queries and JOIN operations
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index for location-based searches (most common filter)
CREATE INDEX idx_property_location ON Property(location);

-- Index for price-based filtering and sorting
CREATE INDEX idx_property_pricepernight ON Property(pricepernight);

-- Index for temporal analysis of property listings
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Composite index for location and price queries (common combination)
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);

-- Composite index for host and status queries
-- CREATE INDEX idx_property_host_status ON Property(host_id, status);

-- BOOKING TABLE INDEXES
-- =====================================================

-- Index for user booking history and JOIN operations
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index for property booking history and JOIN operations  
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index for date range queries (availability searches)
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Index for status-based filtering
CREATE INDEX idx_booking_status ON Booking(status);

-- Index for temporal booking analysis
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Composite index for date range queries (most critical for availability)
CREATE INDEX idx_booking_date_range ON Booking(start_date, end_date);

-- Composite index for property availability queries
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- Composite index for user booking status queries
CREATE INDEX idx_booking_user_status ON Booking(user_id, status);

-- Composite index for property booking status queries
CREATE INDEX idx_booking_property_status ON Booking(property_id, status);

-- REVIEW TABLE INDEXES
-- =====================================================

-- Index for property reviews and JOIN operations
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Index for user reviews and JOIN operations
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Index for rating-based filtering and sorting
CREATE INDEX idx_review_rating ON Review(rating);

-- Index for temporal review analysis
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Composite index for property rating queries
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- Composite index for recent property reviews
CREATE INDEX idx_review_property_date ON Review(property_id, created_at);

-- =====================================================
-- SPECIALIZED INDEXES FOR COMMON QUERY PATTERNS
-- =====================================================

-- Full-text search index for property names and descriptions (MySQL/PostgreSQL specific)
-- ALTER TABLE Property ADD FULLTEXT(name, description);

-- Partial index for active bookings only (PostgreSQL specific)
-- CREATE INDEX idx_booking_active ON Booking(property_id, start_date) 
-- WHERE status = 'confirmed';

-- Covering index for booking summary queries
CREATE INDEX idx_booking_summary ON Booking(property_id, user_id, status, start_date, end_date);

-- Covering index for property search results
CREATE INDEX idx_property_search ON Property(location, pricepernight, host_id, created_at);

-- =====================================================
-- INDEXES FOR ANALYTICAL QUERIES
-- =====================================================

-- Index for monthly booking analysis
CREATE INDEX idx_booking_monthly ON Booking(DATE_FORMAT(created_at, '%Y-%m'), status);

-- Index for user activity analysis  
CREATE INDEX idx_user_booking_analysis ON Booking(user_id, created_at, status);

-- Index for property performance analysis
CREATE INDEX idx_property_performance ON Booking(property_id, created_at, status);

-- =====================================================
-- INDEX MAINTENANCE COMMANDS
-- =====================================================

-- Commands to analyze index usage (MySQL specific)
-- SHOW INDEX FROM User;
-- SHOW INDEX FROM Property;
-- SHOW INDEX FROM Booking;
-- SHOW INDEX FROM Review;

-- Commands to check index statistics (PostgreSQL specific)
-- SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch 
-- FROM pg_stat_user_indexes ORDER BY idx_scan DESC;

-- =====================================================
-- PERFORMANCE TESTING QUERIES
-- =====================================================

-- Test queries to measure performance improvements
-- These should be run with EXPLAIN before and after index creation

-- Query 1: User login lookup
-- EXPLAIN SELECT * FROM User WHERE email = 'user@example.com';

-- Query 2: Property search by location and price
-- EXPLAIN SELECT * FROM Property 
-- WHERE location = 'New York' AND pricepernight BETWEEN 100 AND 300
-- ORDER BY pricepernight;

-- Query 3: Booking availability check
-- EXPLAIN SELECT property_id FROM Booking 
-- WHERE property_id = 123 
-- AND start_date <= '2024-12-31' AND end_date >= '2024-12-01'
-- AND status = 'confirmed';

-- Query 4: User booking history
-- EXPLAIN SELECT b.*, p.name FROM Booking b 
-- JOIN Property p ON b.property_id = p.property_id
-- WHERE b.user_id = 456 ORDER BY b.start_date DESC;

-- Query 5: Property reviews with rating
-- EXPLAIN SELECT AVG(rating), COUNT(*) FROM Review 
-- WHERE property_id = 789 AND rating >= 4;

-- =====================================================
-- NOTES ON INDEX STRATEGY
-- =====================================================

-- 1. Primary keys are automatically indexed
-- 2. Foreign keys should generally be indexed for JOIN performance
-- 3. Columns in WHERE clauses are prime candidates for indexes
-- 4. Composite indexes should put most selective columns first
-- 5. Consider covering indexes for frequently accessed column combinations
-- 6. Monitor index usage and remove unused indexes
-- 7. Balance between query performance and storage/maintenance overhead
-- 8. Update statistics regularly for optimal query planning

-- =====================================================
-- DROPPING INDEXES (if needed for testing)
-- =====================================================

-- Uncomment these if you need to drop indexes for testing
/*
DROP INDEX idx_user_email ON User;
DROP INDEX idx_user_created_at ON User;
DROP INDEX idx_property_host_id ON Property;
DROP INDEX idx_property_location ON Property;
DROP INDEX idx_property_pricepernight ON Property;
DROP INDEX idx_property_created_at ON Property;
DROP INDEX idx_property_location_price ON Property;
DROP INDEX idx_booking_user_id ON Booking;
DROP INDEX idx_booking_property_id ON Booking;
DROP INDEX idx_booking_start_date ON Booking;
DROP INDEX idx_booking_end_date ON Booking;
DROP INDEX idx_booking_status ON Booking;
DROP INDEX idx_booking_created_at ON Booking;
DROP INDEX idx_booking_date_range ON Booking;
DROP INDEX idx_booking_property_dates ON Booking;
DROP INDEX idx_booking_user_status ON Booking;
DROP INDEX idx_booking_property_status ON Booking;
DROP INDEX idx_review_property_id ON Review;
DROP INDEX idx_review_user_id ON Review;
DROP INDEX idx_review_rating ON Review;
DROP INDEX idx_review_created_at ON Review;
DROP INDEX idx_review_property_rating ON Review;
DROP INDEX idx_review_property_date ON Review;
*/
