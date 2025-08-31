# ALX AirBnB Database - Seed Data

## 3. Seed the Database with Sample Data

### Objective
Create SQL scripts to populate the database with sample data that reflects real-world usage patterns for an AirBnB-like platform.

### Overview
This directory contains SQL scripts to seed the AirBnB database with realistic sample data. The seeding process populates all entities with interconnected data that demonstrates the relationships and constraints defined in the database schema.

### Files
- `seed.sql` - Main SQL script containing INSERT statements for all tables
- `README.md` - This documentation file

### Sample Data Structure

The seed data includes:

#### Users (Multiple Roles)
- **Guests**: Regular users who book properties
- **Hosts**: Users who own and rent out properties
- **Admins**: Administrative users with elevated privileges
- Realistic user profiles with valid email addresses, phone numbers, and proper role assignments

#### Properties
- Diverse property types across different locations
- Varied pricing structures reflecting market conditions
- Properties linked to host users with realistic descriptions
- Multiple properties per host to demonstrate scalability

#### Bookings
- Booking scenarios covering different statuses (pending, confirmed, canceled)
- Date ranges that don't overlap for the same property
- Realistic booking patterns with appropriate total price calculations
- Multiple bookings per user and property to show usage patterns

#### Payments
- Payment records linked to confirmed bookings
- Different payment methods (credit_card, paypal, stripe)
- Payment amounts matching booking total prices
- Realistic payment timestamps

#### Reviews
- Reviews for completed bookings only
- Rating distribution from 1-5 stars
- Detailed comments reflecting genuine user experiences
- Reviews from different users for the same properties

#### Messages
- Communication between guests and hosts
- Admin messages for system notifications
- Realistic message threads and timestamps
- Proper sender/recipient relationships

### Data Relationships
The sample data maintains referential integrity across all tables:
- All foreign key constraints are satisfied
- Users have appropriate roles for their actions (hosts own properties, guests make bookings)
- Bookings reference existing users and properties
- Payments are linked to valid bookings
- Reviews are from users who have bookings for the reviewed properties
- Messages flow between valid user accounts

### Usage Instructions

1. **Prerequisites**: Ensure the database schema has been created using the DDL scripts from `database-script-0x01/schema.sql`

2. **Execute the seed script**:
   ```sql
   source seed.sql;
   ```
   Or run directly in your SQL client:
   ```bash
   mysql -u [username] -p [database_name] < seed.sql
   ```

3. **Verify data insertion**:
   ```sql
   -- Check record counts
   SELECT 'Users' as table_name, COUNT(*) as count FROM User
   UNION ALL
   SELECT 'Properties', COUNT(*) FROM Property
   UNION ALL
   SELECT 'Bookings', COUNT(*) FROM Booking
   UNION ALL
   SELECT 'Payments', COUNT(*) FROM Payment
   UNION ALL
   SELECT 'Reviews', COUNT(*) FROM Review
   UNION ALL
   SELECT 'Messages', COUNT(*) FROM Message;
   ```

### Key Features of Sample Data

#### Realistic Scenarios
- Users with multiple bookings showing customer loyalty
- Properties with varying occupancy rates
- Seasonal booking patterns
- Mixed payment methods reflecting user preferences

#### Data Validation
- All UUIDs are properly formatted
- Email addresses follow standard format validation
- Phone numbers use consistent formatting
- Dates are logically consistent (end_date > start_date)
- Ratings are within valid range (1-5)

#### Business Logic Compliance
- Payments only exist for confirmed bookings
- Reviews are only from users who have completed stays
- Total prices reflect realistic market rates
- Property descriptions are detailed and varied

### Sample Data Statistics
- **Users**: ~15 records (5 guests, 8 hosts, 2 admins)
- **Properties**: ~12 records across various locations
- **Bookings**: ~20 records with mixed statuses
- **Payments**: ~15 records for confirmed bookings
- **Reviews**: ~10 records from completed stays
- **Messages**: ~25 records showing communication patterns

### Data Quality Assurance
- No orphaned records (all foreign keys reference existing records)
- Realistic data distribution across all fields
- Consistent naming conventions and formatting
- Proper timestamp progression (created_at < updated_at where applicable)
- Unique constraints respected (no duplicate emails)

### Future Enhancements
This seed data can be extended with:
- Additional property types and amenities
- More complex booking scenarios
- International user bases with different locales
- Seasonal pricing variations
- Property availability calendars

### Notes
- UUIDs are generated using proper UUID format for cross-platform compatibility
- All sensitive data (passwords) are represented as hashed values
- Sample data is designed for development and testing purposes
- Timestamps use realistic date ranges for current testing scenarios

### Related Files
- **Schema Definition**: `../database-script-0x01/schema.sql`
- **ER Diagram**: `../ERD/requirements.md`
- **Normalization Documentation**: `../normalization.md`

---

**Repository**: `alx-airbnb-database`  
**Directory**: `database-script-0x02`  
**Task**: Database Seeding and Sample Data Population
