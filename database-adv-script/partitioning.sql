-- =====================================================
-- ALX Airbnb Database - Table Partitioning Implementation
-- Task 5: Partitioning Large Tables
-- File: partitioning.sql
-- =====================================================

-- =====================================================
-- PERFORMANCE TESTING - BEFORE PARTITIONING
-- =====================================================

-- Test query performance on the original (non-partitioned) Booking table
-- Run these queries to establish baseline performance metrics

-- Query 1: Date range query for recent bookings
EXPLAIN ANALYZE SELECT 
    booking_id, 
    user_id, 
    property_id, 
    start_date, 
    end_date, 
    total_price, 
    status
FROM Booking 
WHERE start_date BETWEEN '2024-06-01' AND '2024-06-30'
    AND status = 'confirmed';

-- Query 2: Monthly booking analysis
EXPLAIN ANALYZE SELECT 
    DATE_FORMAT(start_date, '%Y-%m') as booking_month,
    COUNT(*) as booking_count,
    SUM(total_price) as total_revenue
FROM Booking 
WHERE start_date >= '2024-01-01' 
    AND start_date < '2025-01-01'
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY booking_month;

-- Query 3: Property availability in date range
EXPLAIN ANALYZE SELECT 
    property_id,
    COUNT(*) as booking_count,
    MIN(start_date) as first_booking,
    MAX(end_date) as last_booking
FROM Booking 
WHERE start_date BETWEEN '2024-07-01' AND '2024-09-30'
    AND status IN ('confirmed', 'completed')
GROUP BY property_id
HAVING COUNT(*) > 5;

-- Query 4: User booking history by date
EXPLAIN ANALYZE SELECT 
    b.booking_id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price
FROM Booking b
WHERE b.user_id = 1001
    AND b.start_date >= '2024-01-01'
ORDER BY b.start_date DESC;

-- =====================================================
-- BACKUP ORIGINAL TABLE STRUCTURE
-- =====================================================

-- Create backup of original Booking table structure and data
CREATE TABLE Booking_backup AS SELECT * FROM Booking;

-- Document original table structure
SHOW CREATE TABLE Booking;

-- Check original table statistics
SELECT 
    COUNT(*) as total_bookings,
    MIN(start_date) as earliest_booking,
    MAX(start_date) as latest_booking,
    AVG(DATEDIFF(end_date, start_date)) as avg_stay_duration
FROM Booking;

-- =====================================================
-- PARTITIONING STRATEGY ANALYSIS
-- =====================================================

-- Analyze booking distribution by month to determine optimal partitioning
SELECT 
    YEAR(start_date) as booking_year,
    MONTH(start_date) as booking_month,
    COUNT(*) as booking_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Booking), 2) as percentage
FROM Booking
GROUP BY YEAR(start_date), MONTH(start_date)
ORDER BY booking_year, booking_month;

-- Check date range coverage
SELECT 
    MIN(start_date) as min_date,
    MAX(start_date) as max_date,
    DATEDIFF(MAX(start_date), MIN(start_date)) as date_span_days
FROM Booking;

-- =====================================================
-- IMPLEMENTATION 1: RANGE PARTITIONING BY MONTH
-- =====================================================

-- Drop existing table (after backup)
DROP TABLE IF EXISTS Booking_partitioned;

-- Create partitioned Booking table with RANGE partitioning by start_date
CREATE TABLE Booking_partitioned (
    booking_id INT AUTO_INCREMENT,
    property_id INT NOT NULL,
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (booking_id, start_date),  -- Must include partition key in PRIMARY KEY
    INDEX idx_user_id (user_id),
    INDEX idx_property_id (property_id),
    INDEX idx_status (status),
    INDEX idx_start_date (start_date),
    INDEX idx_date_range (start_date, end_date)
) 
PARTITION BY RANGE (YEAR(start_date) * 100 + MONTH(start_date)) (
    -- 2023 partitions
    PARTITION p202301 VALUES LESS THAN (202302),
    PARTITION p202302 VALUES LESS THAN (202303),
    PARTITION p202303 VALUES LESS THAN (202304),
    PARTITION p202304 VALUES LESS THAN (202305),
    PARTITION p202305 VALUES LESS THAN (202306),
    PARTITION p202306 VALUES LESS THAN (202307),
    PARTITION p202307 VALUES LESS THAN (202308),
    PARTITION p202308 VALUES LESS THAN (202309),
    PARTITION p202309 VALUES LESS THAN (202310),
    PARTITION p202310 VALUES LESS THAN (202311),
    PARTITION p202311 VALUES LESS THAN (202312),
    PARTITION p202312 VALUES LESS THAN (202401),
    
    -- 2024 partitions
    PARTITION p202401 VALUES LESS THAN (202402),
    PARTITION p202402 VALUES LESS THAN (202403),
    PARTITION p202403 VALUES LESS THAN (202404),
    PARTITION p202404 VALUES LESS THAN (202405),
    PARTITION p202405 VALUES LESS THAN (202406),
    PARTITION p202406 VALUES LESS THAN (202407),
    PARTITION p202407 VALUES LESS THAN (202408),
    PARTITION p202408 VALUES LESS THAN (202409),
    PARTITION p202409 VALUES LESS THAN (202410),
    PARTITION p202410 VALUES LESS THAN (202411),
    PARTITION p202411 VALUES LESS THAN (202412),
    PARTITION p202412 VALUES LESS THAN (202501),
    
    -- 2025 partitions (future)
    PARTITION p202501 VALUES LESS THAN (202502),
    PARTITION p202502 VALUES LESS THAN (202503),
    PARTITION p202503 VALUES LESS THAN (202504),
    PARTITION p202504 VALUES LESS THAN (202505),
    PARTITION p202505 VALUES LESS THAN (202506),
    PARTITION p202506 VALUES LESS THAN (202507),
    PARTITION p202507 VALUES LESS THAN (202508),
    PARTITION p202508 VALUES LESS THAN (202509),
    PARTITION p202509 VALUES LESS THAN (202510),
    PARTITION p202510 VALUES LESS THAN (202511),
    PARTITION p202511 VALUES LESS THAN (202512),
    PARTITION p202512 VALUES LESS THAN (202601),
    
    -- Catch-all partition for future dates
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- =====================================================
-- DATA MIGRATION TO PARTITIONED TABLE
-- =====================================================

-- Insert data from backup table to partitioned table
INSERT INTO Booking_partitioned (
    property_id, user_id, start_date, end_date, 
    total_price, status, created_at, updated_at
)
SELECT 
    property_id, user_id, start_date, end_date,
    total_price, status, created_at, updated_at
FROM Booking_backup;

-- Verify data migration
SELECT 
    COUNT(*) as migrated_records,
    MIN(start_date) as earliest_date,
    MAX(start_date) as latest_date
FROM Booking_partitioned;

-- Compare record counts
SELECT 
    'Original' as table_type, COUNT(*) as record_count FROM Booking_backup
UNION ALL
SELECT 
    'Partitioned' as table_type, COUNT(*) as record_count FROM Booking_partitioned;

-- =====================================================
-- PARTITION INFORMATION AND STATISTICS
-- =====================================================

-- View partition information
SELECT 
    PARTITION_NAME,
    PARTITION_EXPRESSION,
    PARTITION_DESCRIPTION,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH,
    PARTITION_COMMENT
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'Booking_partitioned'
ORDER BY PARTITION_ORDINAL_POSITION;

-- Check data distribution across partitions
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) as DATA_SIZE_MB,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) as INDEX_SIZE_MB
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'Booking_partitioned'
    AND PARTITION_NAME IS NOT NULL
ORDER BY PARTITION_ORDINAL_POSITION;

-- =====================================================
-- PERFORMANCE TESTING - AFTER PARTITIONING
-- =====================================================

-- Test the same queries on partitioned table and compare performance

-- Query 1: Date range query for recent bookings (AFTER partitioning)
EXPLAIN ANALYZE SELECT 
    booking_id, 
    user_id, 
    property_id, 
    start_date, 
    end_date, 
    total_price, 
    status
FROM Booking_partitioned 
WHERE start_date BETWEEN '2024-06-01' AND '2024-06-30'
    AND status = 'confirmed';

-- Show which partitions are accessed
EXPLAIN PARTITIONS SELECT 
    booking_id, 
    user_id, 
    property_id, 
    start_date, 
    end_date, 
    total_price, 
    status
FROM Booking_partitioned 
WHERE start_date BETWEEN '2024-06-01' AND '2024-06-30'
    AND status = 'confirmed';

-- Query 2: Monthly booking analysis (AFTER partitioning)
EXPLAIN ANALYZE SELECT 
    DATE_FORMAT(start_date, '%Y-%m') as booking_month,
    COUNT(*) as booking_count,
    SUM(total_price) as total_revenue
FROM Booking_partitioned 
WHERE start_date >= '2024-01-01' 
    AND start_date < '2025-01-01'
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY booking_month;

-- Query 3: Property availability in date range (AFTER partitioning)
EXPLAIN ANALYZE SELECT 
    property_id,
    COUNT(*) as booking_count,
    MIN(start_date) as first_booking,
    MAX(end_date) as last_booking
FROM Booking_partitioned 
WHERE start_date BETWEEN '2024-07-01' AND '2024-09-30'
    AND status IN ('confirmed', 'completed')
GROUP BY property_id
HAVING COUNT(*) > 5;

-- Query 4: User booking history by date (AFTER partitioning)
EXPLAIN ANALYZE SELECT 
    b.booking_id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price
FROM Booking_partitioned b
WHERE b.user_id = 1001
    AND b.start_date >= '2024-01-01'
ORDER BY b.start_date DESC;

-- =====================================================
-- PARTITION PRUNING DEMONSTRATION
-- =====================================================

-- Demonstrate partition pruning effectiveness

-- Query that accesses single partition
EXPLAIN PARTITIONS SELECT * FROM Booking_partitioned 
WHERE start_date BETWEEN '2024-06-01' AND '2024-06-30';

-- Query that accesses multiple partitions
EXPLAIN PARTITIONS SELECT * FROM Booking_partitioned 
WHERE start_date BETWEEN '2024-05-15' AND '2024-07-15';

-- Query that accesses all partitions (no date filter)
EXPLAIN PARTITIONS SELECT COUNT(*) FROM Booking_partitioned 
WHERE status = 'confirmed';

-- Query with partition elimination
EXPLAIN PARTITIONS SELECT * FROM Booking_partitioned 
WHERE start_date = '2024-06-15' AND user_id = 1001;

-- =====================================================
-- PARTITION MAINTENANCE OPERATIONS
-- =====================================================

-- Add new partition for future dates
ALTER TABLE Booking_partitioned 
ADD PARTITION (PARTITION p202601 VALUES LESS THAN (202602));

-- Drop old partition (after archiving data if needed)
-- ALTER TABLE Booking_partitioned DROP PARTITION p202301;

-- Reorganize partition (split existing partition)
-- ALTER TABLE Booking_partitioned 
-- REORGANIZE PARTITION p_future INTO (
--     PARTITION p202601 VALUES LESS THAN (202602),
--     PARTITION p202602 VALUES LESS THAN (202603),
--     PARTITION p_future_new VALUES LESS THAN MAXVALUE
-- );

-- Check partition after maintenance
SELECT 
    PARTITION_NAME,
    PARTITION_DESCRIPTION,
    TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'Booking_partitioned'
    AND PARTITION_NAME IS NOT NULL
ORDER BY PARTITION_ORDINAL_POSITION;

-- =====================================================
-- PERFORMANCE COMPARISON QUERIES
-- =====================================================

-- Compare query performance between original and partitioned tables

-- Benchmark 1: Single month query
SET @start_time = NOW(6);
SELECT COUNT(*) FROM Booking_backup 
WHERE start_date BETWEEN '2024-06-01' AND '2024-06-30';
SET @original_time = TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6));

SET @start_time = NOW(6);
SELECT COUNT(*) FROM Booking_partitioned 
WHERE start_date BETWEEN '2024-06-01' AND '2024-06-30';
SET @partitioned_time = TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6));

SELECT 
    @original_time as original_microseconds,
    @partitioned_time as partitioned_microseconds,
    ROUND((@original_time - @partitioned_time) * 100.0 / @original_time, 2) as improvement_percentage;

-- Benchmark 2: Range query across multiple months
SET @start_time = NOW(6);
SELECT COUNT(*) FROM Booking_backup 
WHERE start_date BETWEEN '2024-01-01' AND '2024-06-30'
    AND status = 'confirmed';
SET @original_time = TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6));

SET @start_time = NOW(6);
SELECT COUNT(*) FROM Booking_partitioned 
WHERE start_date BETWEEN '2024-01-01' AND '2024-06-30'
    AND status = 'confirmed';
SET @partitioned_time = TIMESTAMPDIFF(MICROSECOND, @start_time, NOW(6));

SELECT 
    @original_time as original_microseconds,
    @partitioned_time as partitioned_microseconds,
    ROUND((@original_time - @partitioned_time) * 100.0 / @original_time, 2) as improvement_percentage;

-- =====================================================
-- ALTERNATIVE PARTITIONING STRATEGIES
-- =====================================================

-- Example: Hash partitioning for even distribution
-- (Uncomment to test alternative approach)

/*
DROP TABLE IF EXISTS Booking_hash_partitioned;

CREATE TABLE Booking_hash_partitioned (
    booking_id INT AUTO_INCREMENT,
    property_id INT NOT NULL,
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (booking_id, user_id),
    INDEX idx_start_date (start_date),
    INDEX idx_property_id (property_id),
    INDEX idx_status (status)
) 
PARTITION BY HASH(user_id)
PARTITIONS 12;
*/

-- =====================================================
-- CLEANUP AND RECOVERY PROCEDURES
-- =====================================================

-- Script to restore original table if needed
/*
DROP TABLE Booking;
RENAME TABLE Booking_backup TO Booking;
*/

-- Script to switch to partitioned table
/*
RENAME TABLE Booking TO Booking_old;
RENAME TABLE Booking_partitioned TO Booking;
*/

-- =====================================================
-- MONITORING AND MAINTENANCE QUERIES
-- =====================================================

-- Monitor partition sizes over time
CREATE VIEW partition_stats AS
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) as DATA_MB,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) as INDEX_MB,
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) as TOTAL_MB,
    UPDATE_TIME,
    CHECK_TIME
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'Booking_partitioned'
    AND PARTITION_NAME IS NOT NULL;

-- Query to identify partitions needing maintenance
SELECT * FROM partition_stats 
WHERE DATA_MB > 1000  -- Partitions larger than 1GB
   OR TABLE_ROWS = 0  -- Empty partitions
ORDER BY TOTAL_MB DESC;
