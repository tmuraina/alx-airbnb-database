# AirBnB Database Schema (DDL Scripts)

## Overview
This directory contains the Data Definition Language (DDL) scripts for creating the complete AirBnB database schema. The schema implements a normalized relational database design following 3NF principles.

## Files in This Directory
- `schema.sql` - Complete database schema with tables, constraints, indexes, and stored procedures
- `README.md` - This documentation file

## Database Schema Components

### Core Tables
1. **User** - User accounts (guests, hosts, admins)
2. **Location** - Normalized location data for properties
3. **Property** - Property listings
4. **Booking** - Reservation records
5. **Payment** - Payment transactions
6. **Review** - Property reviews and ratings
7. **Message** - User-to-user communications
8. **AuditLog** - Change tracking and audit trail

### Database Features

#### 🔑 **Primary Keys**
- All tables use UUID primary keys for scalability
- UUIDs are automatically generated using `UUID()` function

#### 🔗 **Foreign Key Relationships**
- **Property.host_id** → **User.user_id**
- **Property.location_id** → **Location.location_id**
- **Booking.property_id** → **Property.property_id**
- **Booking.user_id** → **User.user_id**
- **Payment.booking_id** → **Booking.booking_id**
- **Review.property_id** → **Property.property_id**
- **Review.user_id** → **User.user_id**
- **Review.booking_id** → **Booking.booking_id**
- **Message.sender_id** → **User.user_id**
- **Message.recipient_id** → **User.user_id**

#### ⚡ **Performance Optimizations**
- Strategic indexes on frequently queried columns
- Composite indexes for common query patterns
- Full-text search indexes for property and review content
- Optimized foreign key constraints

#### 🛡️ **Data Integrity Constraints**
- Email format validation
- Phone number format validation
- Rating bounds (1-5)
- Date validation (end_date > start_date)
- Price validation (> 0)
- Booking overlap prevention
- Self-messaging prevention

## Installation Instructions

### Prerequisites
- MySQL 8.0+ or MariaDB 10.5+
- Database user with CREATE, INSERT, UPDATE, DELETE privileges
- Recommended: MySQL Workbench or similar database management tool

### Quick Setup
```bash
# 1. Connect to MySQL
mysql -u your_username -p

# 2. Run the schema script
source /path/to/schema.sql

# 3. Verify installation
USE airbnb_db;
SHOW TABLES;
```

### Step-by-Step Setup
```sql
-- 1. Create database
CREATE DATABASE airbnb_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Use database
USE airbnb_db;

-- 3. Execute schema.sql file
-- (Copy and paste the entire schema.sql content, or use source command)

-- 4. Verify tables
SHOW TABLES;

-- 5. Check sample data
SELECT * FROM User LIMIT 5;
```

## Schema Highlights

### Normalization Compliance
- ✅ **1NF**: All atomic values, no repeating groups
- ✅ **2NF**: No partial dependencies (single-column primary keys)
- ✅ **3NF**: No transitive dependencies (Location table normalized)

### Business Logic Implementation

#### **Booking System**
- Prevents overlapping bookings for same property
- Automatically calculates total price
- Maintains price history for accurate billing
- Supports booking status workflow

#### **Review System**
- Links reviews to actual bookings (prevents fake reviews)
- Enforces rating constraints (1-5 scale)
- Allows only one review per booking
- Tracks review timestamps

#### **Payment Processing**
- One-to-one relationship with bookings
- Supports multiple payment methods
- Tracks payment status changes
- Handles refunds through status updates

#### **Messaging System**
- Enables host-guest communication
- Prevents self-messaging
- Tracks read status and timestamps
- Supports conversation threading

### Advanced Features

#### **Stored Procedures**
- `CreateBooking()` - Automated booking creation with price calculation
- `CalculateBookingTotal()` - Function for price calculations

#### **Database Views**
- `PropertyDetails` - Complete property information with location and host
- `BookingDetails` - Comprehensive booking information
- `PropertyReviews` - Aggregated review statistics

#### **Triggers**
- Automatic total price updates
- Booking overlap prevention
- Payment status automation
- Audit trail maintenance

#### **Audit System**
- Tracks all changes to critical tables
- Stores old and new values in JSON format
- Links changes to responsible users
- Automatic cleanup of old audit records

## Usage Examples

### Creating a New Property
```sql
-- 1. First, create location
INSERT INTO Location (street_address, city, state_province, country, postal_code)
VALUES ('123 Beach Road', 'Miami', 'Florida', 'USA', '33139');

-- 2. Then create property
INSERT INTO Property (host_id, location_id, name, description, price_per_night)
VALUES (
    'user-uuid-here',
    'location-uuid-here', 
    'Luxury Beach Condo',
    'Beautiful oceanfront condo with stunning views',
    250.00
);
```

### Making a Booking
```sql
-- Use the stored procedure for automatic price calculation
CALL CreateBooking(
    'property-uuid-here',
    'guest-uuid-here',
    '2025-09-15',
    '2025-09-20',
    @booking_id,
    @total_price
);

SELECT @booking_id, @total_price;
```

### Querying Property Details
```sql
-- Use the view for comprehensive property information
SELECT * FROM PropertyDetails 
WHERE city = 'Miami' 
AND price_per_night BETWEEN 100 AND 300
ORDER BY price_per_night;
```

## Maintenance and Monitoring

### Performance Monitoring
```sql
-- Check slow queries
SELECT * FROM mysql.slow_log WHERE start_time > DATE_SUB(NOW(), INTERVAL 1 DAY);

-- Monitor index usage
SELECT * FROM performance_schema.table_io_waits_summary_by_index_usage
WHERE object_schema = 'airbnb_db';
```

### Data Integrity Checks
```sql
-- Verify all bookings have payments
SELECT COUNT(*) FROM Booking b 
LEFT JOIN Payment p ON b.booking_id = p.booking_id 
WHERE p.payment_id IS NULL;

-- Check for orphaned records
SELECT COUNT(*) FROM Review r
LEFT JOIN Booking b ON r.booking_id = b.booking_id
WHERE b.booking_id IS NULL;
```

## Security Considerations

### Implemented Security Features
- Password hashing (application-level implementation required)
- Email uniqueness enforcement
- Role-based access control structure
- Audit logging for accountability
- Input validation through constraints

### Recommended Additional Security
- Implement row-level security for multi-tenant access
- Add encryption for sensitive data (PII, payment info)
- Regular security audits and penetration testing
- Database connection encryption (SSL/TLS)

## Future Enhancements

### Potential Schema Extensions
- **PropertyAmenity** table for property features
- **UserProfile** table for extended user information
- **BookingModification** table for change history
- **PropertyPhoto** table for image management
- **UserNotification** table for system notifications

### Scalability Considerations
- Table partitioning for large tables (Booking, Message)
- Read replicas for reporting queries
- Caching layer for frequently accessed data
- Database sharding for global distribution

## Support and Documentation

### Related Files
- `../normalization.md` - Database normalization analysis
- `../ERD/requirements.md` - Entity-relationship documentation
- `../ERD/airbnb_er_diagram.html` - Interactive ER diagram

### Database Administration
- Regular backups recommended (daily full, hourly incremental)
- Monitor disk space and query performance
- Update statistics regularly for query optimization
- Review and optimize indexes based on usage patterns

---

**Last Updated**: August 31, 2025  
**Schema Version**: 1.0  
**Compatible With**: MySQL 8.0+, MariaDB 10.5+
