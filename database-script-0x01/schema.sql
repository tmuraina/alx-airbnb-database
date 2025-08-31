-- ============================================================================
-- AirBnB Database Schema (DDL)
-- Version: 1.0
-- Author: Database Design Team
-- Created: 2025-08-31
-- Description: Complete database schema for AirBnB-like platform
-- ============================================================================

-- Set SQL mode and character set
SET SQL_MODE = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO';
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS airbnb_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE airbnb_db;

-- ============================================================================
-- 1. USER TABLE
-- ============================================================================
CREATE TABLE User (
    user_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NULL,
    role ENUM('guest', 'host', 'admin') NOT NULL DEFAULT 'guest',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_email_format CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_phone_format CHECK (phone_number IS NULL OR phone_number REGEXP '^[+]?[0-9\s\-\(\)]{10,20}$'),
    CONSTRAINT chk_name_length CHECK (CHAR_LENGTH(first_name) >= 2 AND CHAR_LENGTH(last_name) >= 2)
);

-- User table indexes
CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_user_role ON User(role);
CREATE INDEX idx_user_created_at ON User(created_at);
CREATE INDEX idx_user_full_name ON User(first_name, last_name);

-- ============================================================================
-- 2. LOCATION TABLE (Normalized from Property.location)
-- ============================================================================
CREATE TABLE Location (
    location_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state_province VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NULL,
    latitude DECIMAL(10,8) NULL,
    longitude DECIMAL(11,8) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_latitude CHECK (latitude IS NULL OR (latitude >= -90 AND latitude <= 90)),
    CONSTRAINT chk_longitude CHECK (longitude IS NULL OR (longitude >= -180 AND longitude <= 180)),
    CONSTRAINT chk_location_required CHECK (CHAR_LENGTH(street_address) >= 5 AND CHAR_LENGTH(city) >= 2)
);

-- Location table indexes
CREATE INDEX idx_location_city_country ON Location(city, country);
CREATE INDEX idx_location_coordinates ON Location(latitude, longitude);
CREATE INDEX idx_location_postal_code ON Location(postal_code);

-- ============================================================================
-- 3. PROPERTY TABLE
-- ============================================================================
CREATE TABLE Property (
    property_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    host_id CHAR(36) NOT NULL,
    location_id CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT fk_property_host FOREIGN KEY (host_id) REFERENCES User(user_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_property_location FOREIGN KEY (location_id) REFERENCES Location(location_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Business constraints
    CONSTRAINT chk_property_price CHECK (price_per_night > 0),
    CONSTRAINT chk_property_name CHECK (CHAR_LENGTH(name) >= 5),
    CONSTRAINT chk_property_description CHECK (CHAR_LENGTH(description) >= 20)
);

-- Property table indexes
CREATE INDEX idx_property_host_id ON Property(host_id);
CREATE INDEX idx_property_location_id ON Property(location_id);
CREATE INDEX idx_property_price ON Property(price_per_night);
CREATE INDEX idx_property_created_at ON Property(created_at);
CREATE INDEX idx_property_name ON Property(name);

-- ============================================================================
-- 4. BOOKING TABLE
-- ============================================================================
CREATE TABLE Booking (
    booking_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price_per_night_at_booking DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES Property(property_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES User(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Business constraints
    CONSTRAINT chk_booking_dates CHECK (end_date > start_date),
    CONSTRAINT chk_booking_future_dates CHECK (start_date >= CURDATE()),
    CONSTRAINT chk_booking_price CHECK (price_per_night_at_booking > 0 AND total_price > 0),
    
    -- Prevent double booking
    CONSTRAINT uk_property_dates UNIQUE (property_id, start_date, end_date)
);

-- Booking table indexes
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);
CREATE INDEX idx_booking_status ON Booking(status);
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- ============================================================================
-- 5. PAYMENT TABLE
-- ============================================================================
CREATE TABLE Payment (
    payment_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    booking_id CHAR(36) NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') NOT NULL DEFAULT 'pending',
    transaction_id VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Business constraints
    CONSTRAINT chk_payment_amount CHECK (amount > 0),
    CONSTRAINT chk_transaction_id CHECK (transaction_id IS NULL OR CHAR_LENGTH(transaction_id) >= 5)
);

-- Payment table indexes
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);
CREATE INDEX idx_payment_status ON Payment(payment_status);
CREATE INDEX idx_payment_method ON Payment(payment_method);
CREATE INDEX idx_payment_date ON Payment(payment_date);
CREATE INDEX idx_payment_transaction_id ON Payment(transaction_id);

-- ============================================================================
-- 6. REVIEW TABLE
-- ============================================================================
CREATE TABLE Review (
    review_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    booking_id CHAR(36) NOT NULL,
    rating INTEGER NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT fk_review_property FOREIGN KEY (property_id) REFERENCES Property(property_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES User(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_review_booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Business constraints
    CONSTRAINT chk_review_rating CHECK (rating >= 1 AND rating <= 5),
    CONSTRAINT chk_review_comment CHECK (CHAR_LENGTH(comment) >= 10),
    
    -- Ensure user can only review properties they've booked
    CONSTRAINT uk_user_booking_review UNIQUE (user_id, booking_id)
);

-- Review table indexes
CREATE INDEX idx_review_property_id ON Review(property_id);
CREATE INDEX idx_review_user_id ON Review(user_id);
CREATE INDEX idx_review_booking_id ON Review(booking_id);
CREATE INDEX idx_review_rating ON Review(rating);
CREATE INDEX idx_review_created_at ON Review(created_at);

-- ============================================================================
-- 7. MESSAGE TABLE
-- ============================================================================
CREATE TABLE Message (
    message_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    sender_id CHAR(36) NOT NULL,
    recipient_id CHAR(36) NOT NULL,
    message_body TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    
    -- Foreign key constraints
    CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES User(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_message_recipient FOREIGN KEY (recipient_id) REFERENCES User(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Business constraints
    CONSTRAINT chk_message_not_self CHECK (sender_id != recipient_id),
    CONSTRAINT chk_message_body CHECK (CHAR_LENGTH(message_body) >= 1 AND CHAR_LENGTH(message_body) <= 2000)
);

-- Message table indexes
CREATE INDEX idx_message_sender_id ON Message(sender_id);
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);
CREATE INDEX idx_message_sent_at ON Message(sent_at);
CREATE INDEX idx_message_is_read ON Message(is_read);
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- ============================================================================
-- 8. AUDIT TABLE (Optional - for tracking changes)
-- ============================================================================
CREATE TABLE AuditLog (
    audit_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    table_name VARCHAR(50) NOT NULL,
    record_id CHAR(36) NOT NULL,
    operation ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    old_values JSON NULL,
    new_values JSON NULL,
    user_id CHAR(36) NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES User(user_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Audit table indexes
CREATE INDEX idx_audit_table_record ON AuditLog(table_name, record_id);
CREATE INDEX idx_audit_timestamp ON AuditLog(timestamp);
CREATE INDEX idx_audit_user_id ON AuditLog(user_id);

-- ============================================================================
-- 9. DATABASE VIEWS (for common queries)
-- ============================================================================

-- View: Property details with location and host information
CREATE VIEW PropertyDetails AS
SELECT 
    p.property_id,
    p.name AS property_name,
    p.description,
    p.price_per_night,
    CONCAT(l.street_address, ', ', l.city, ', ', l.state_province, ', ', l.country) AS full_address,
    l.city,
    l.country,
    l.latitude,
    l.longitude,
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    u.email AS host_email,
    p.created_at,
    p.updated_at
FROM Property p
JOIN Location l ON p.location_id = l.location_id
JOIN User u ON p.host_id = u.user_id
WHERE u.role IN ('host', 'admin');

-- View: Booking details with user and property information
CREATE VIEW BookingDetails AS
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    p.name AS property_name,
    CONCAT(l.city, ', ', l.country) AS property_location,
    CONCAT(h.first_name, ' ', h.last_name) AS host_name,
    DATEDIFF(b.end_date, b.start_date) AS nights,
    b.created_at
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
JOIN Location l ON p.location_id = l.location_id
JOIN User h ON p.host_id = h.user_id;

-- View: Property reviews with ratings summary
CREATE VIEW PropertyReviews AS
SELECT 
    p.property_id,
    p.name AS property_name,
    COUNT(r.review_id) AS total_reviews,
    AVG(r.rating) AS average_rating,
    MIN(r.rating) AS min_rating,
    MAX(r.rating) AS max_rating,
    MAX(r.created_at) AS latest_review_date
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id, p.name;

-- ============================================================================
-- 10. STORED PROCEDURES AND FUNCTIONS
-- ============================================================================

DELIMITER //

-- Function: Calculate booking total price
CREATE FUNCTION CalculateBookingTotal(
    p_property_id CHAR(36),
    p_start_date DATE,
    p_end_date DATE
) RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_price_per_night DECIMAL(10,2);
    DECLARE v_nights INT;
    DECLARE v_total DECIMAL(10,2);
    
    -- Get price per night
    SELECT price_per_night INTO v_price_per_night
    FROM Property 
    WHERE property_id = p_property_id;
    
    -- Calculate nights
    SET v_nights = DATEDIFF(p_end_date, p_start_date);
    
    -- Calculate total
    SET v_total = v_price_per_night * v_nights;
    
    RETURN v_total;
END //

-- Procedure: Create booking with automatic price calculation
CREATE PROCEDURE CreateBooking(
    IN p_property_id CHAR(36),
    IN p_user_id CHAR(36),
    IN p_start_date DATE,
    IN p_end_date DATE,
    OUT p_booking_id CHAR(36),
    OUT p_total_price DECIMAL(10,2)
)
BEGIN
    DECLARE v_price_per_night DECIMAL(10,2);
    DECLARE v_calculated_total DECIMAL(10,2);
    
    -- Generate booking ID
    SET p_booking_id = UUID();
    
    -- Get current price per night
    SELECT price_per_night INTO v_price_per_night
    FROM Property 
    WHERE property_id = p_property_id;
    
    -- Calculate total price
    SET v_calculated_total = CalculateBookingTotal(p_property_id, p_start_date, p_end_date);
    SET p_total_price = v_calculated_total;
    
    -- Insert booking
    INSERT INTO Booking (
        booking_id, property_id, user_id, start_date, end_date,
        price_per_night_at_booking, total_price, status
    ) VALUES (
        p_booking_id, p_property_id, p_user_id, p_start_date, p_end_date,
        v_price_per_night, v_calculated_total, 'pending'
    );
END //

DELIMITER ;

-- ============================================================================
-- 11. TRIGGERS
-- ============================================================================

DELIMITER //

-- Trigger: Update booking total price when dates change
CREATE TRIGGER trg_booking_update_total
BEFORE UPDATE ON Booking
FOR EACH ROW
BEGIN
    IF NEW.start_date != OLD.start_date OR NEW.end_date != OLD.end_date THEN
        SET NEW.total_price = NEW.price_per_night_at_booking * DATEDIFF(NEW.end_date, NEW.start_date);
    END IF;
END //

-- Trigger: Validate booking dates don't overlap for same property
CREATE TRIGGER trg_booking_no_overlap
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count
    FROM Booking
    WHERE property_id = NEW.property_id
    AND status IN ('pending', 'confirmed')
    AND (
        (NEW.start_date BETWEEN start_date AND end_date) OR
        (NEW.end_date BETWEEN start_date AND end_date) OR
        (start_date BETWEEN NEW.start_date AND NEW.end_date)
    );
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking dates overlap with existing booking';
    END IF;
END //

-- Trigger: Auto-update payment status when booking is canceled
CREATE TRIGGER trg_booking_cancel_payment
AFTER UPDATE ON Booking
FOR EACH ROW
BEGIN
    IF NEW.status = 'canceled' AND OLD.status != 'canceled' THEN
        UPDATE Payment 
        SET payment_status = 'refunded'
        WHERE booking_id = NEW.booking_id;
    END IF;
END //

-- Trigger: Audit log for important table changes
CREATE TRIGGER trg_user_audit
AFTER UPDATE ON User
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (table_name, record_id, operation, old_values, new_values, user_id)
    VALUES ('User', NEW.user_id, 'UPDATE', 
           JSON_OBJECT('email', OLD.email, 'role', OLD.role),
           JSON_OBJECT('email', NEW.email, 'role', NEW.role),
           NEW.user_id);
END //

DELIMITER ;

-- ============================================================================
-- 12. SAMPLE DATA INSERTION (for testing)
-- ============================================================================

-- Insert sample users
INSERT INTO User (user_id, first_name, last_name, email, role) VALUES
(UUID(), 'John', 'Doe', 'john.doe@email.com', 'guest'),
(UUID(), 'Jane', 'Smith', 'jane.smith@email.com', 'host'),
(UUID(), 'Admin', 'User', 'admin@airbnb.com', 'admin');

-- Insert sample locations
INSERT INTO Location (location_id, street_address, city, state_province, country, postal_code) VALUES
(UUID(), '123 Ocean Drive', 'Miami', 'Florida', 'USA', '33139'),
(UUID(), '456 Times Square', 'New York', 'New York', 'USA', '10036'),
(UUID(), '789 Golden Gate Ave', 'San Francisco', 'California', 'USA', '94102');

-- Note: Additional sample data would require actual UUIDs from the inserted records above

-- ============================================================================
-- 13. PERFORMANCE OPTIMIZATION
-- ============================================================================

-- Create composite indexes for common query patterns
CREATE INDEX idx_booking_user_status ON Booking(user_id, status);
CREATE INDEX idx_property_host_price ON Property(host_id, price_per_night);
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);
CREATE INDEX idx_message_recipient_read ON Message(recipient_id, is_read, sent_at);

-- Create full-text search indexes
CREATE FULLTEXT INDEX idx_property_search ON Property(name, description);
CREATE FULLTEXT INDEX idx_review_search ON Review(comment);

-- ============================================================================
-- 14. DATABASE MAINTENANCE
-- ============================================================================

-- Event scheduler for cleanup (run daily)
DELIMITER //
CREATE EVENT IF NOT EXISTS cleanup_old_data
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Delete old audit logs (older than 1 year)
    DELETE FROM AuditLog WHERE timestamp < DATE_SUB(NOW(), INTERVAL 1 YEAR);
    
    -- Update read_at timestamp for read messages
    UPDATE Message 
    SET read_at = CURRENT_TIMESTAMP 
    WHERE is_read = TRUE AND read_at IS NULL;
END //
DELIMITER ;

-- Enable event scheduler
SET GLOBAL event_scheduler = ON;

-- ============================================================================
-- 15. FINAL VERIFICATION QUERIES
-- ============================================================================

-- Verify table creation
SHOW TABLES;

-- Check table structures
DESCRIBE User;
DESCRIBE Location;
DESCRIBE Property;
DESCRIBE Booking;
DESCRIBE Payment;
DESCRIBE Review;
DESCRIBE Message;

-- Verify indexes
SHOW INDEX FROM User;
SHOW INDEX FROM Property;
SHOW INDEX FROM Booking;

-- Verify foreign key constraints
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_SCHEMA = 'airbnb_db'
AND REFERENCED_TABLE_NAME IS NOT NULL;

-- ============================================================================
-- END OF SCHEMA DEFINITION
-- ============================================================================
