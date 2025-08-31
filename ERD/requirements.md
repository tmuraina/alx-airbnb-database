# AirBnB Database Entity-Relationship Diagram

## Project Overview
This document outlines the Entity-Relationship design for the AirBnB database system.

## Entities and Attributes

### 1. User Entity
- **user_id**: Primary Key, UUID, Indexed
- **first_name**: VARCHAR, NOT NULL
- **last_name**: VARCHAR, NOT NULL
- **email**: VARCHAR, UNIQUE, NOT NULL
- **password_hash**: VARCHAR, NOT NULL
- **phone_number**: VARCHAR, NULL
- **role**: ENUM (guest, host, admin), NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### 2. Property Entity
- **property_id**: Primary Key, UUID, Indexed
- **host_id**: Foreign Key, references User(user_id)
- **name**: VARCHAR, NOT NULL
- **description**: TEXT, NOT NULL
- **location**: VARCHAR, NOT NULL
- **price_per_night**: DECIMAL, NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
- **updated_at**: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

### 3. Booking Entity
- **booking_id**: Primary Key, UUID, Indexed
- **property_id**: Foreign Key, references Property(property_id)
- **user_id**: Foreign Key, references User(user_id)
- **start_date**: DATE, NOT NULL
- **end_date**: DATE, NOT NULL
- **total_price**: DECIMAL, NOT NULL
- **status**: ENUM (pending, confirmed, canceled), NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### 4. Payment Entity
- **payment_id**: Primary Key, UUID, Indexed
- **booking_id**: Foreign Key, references Booking(booking_id)
- **amount**: DECIMAL, NOT NULL
- **payment_date**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
- **payment_method**: ENUM (credit_card, paypal, stripe), NOT NULL

### 5. Review Entity
- **review_id**: Primary Key, UUID, Indexed
- **property_id**: Foreign Key, references Property(property_id)
- **user_id**: Foreign Key, references User(user_id)
- **rating**: INTEGER, CHECK: rating >= 1 AND rating <= 5, NOT NULL
- **comment**: TEXT, NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### 6. Message Entity
- **message_id**: Primary Key, UUID, Indexed
- **sender_id**: Foreign Key, references User(user_id)
- **recipient_id**: Foreign Key, references User(user_id)
- **message_body**: TEXT, NOT NULL
- **sent_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

## Relationships

### Primary Relationships
1. **User → Property** (1:M): One user can host multiple properties
2. **User → Booking** (1:M): One user can make multiple bookings
3. **Property → Booking** (1:M): One property can have multiple bookings
4. **Booking → Payment** (1:1): Each booking has exactly one payment
5. **User → Review** (1:M): One user can write multiple reviews
6. **Property → Review** (1:M): One property can receive multiple reviews
7. **User → Message** (1:M): One user can send multiple messages
8. **User → Message** (1:M): One user can receive multiple messages

## Database Constraints

### User Table
- Unique constraint on email
- Non-null constraints on required fields
- Role must be: guest, host, or admin

### Property Table
- Foreign key constraint on host_id
- Non-null constraints on essential attributes

### Booking Table
- Foreign key constraints on property_id and user_id
- Status must be: pending, confirmed, or canceled
- End date must be after start date

### Payment Table
- Foreign key constraint on booking_id
- Payment method must be: credit_card, paypal, or stripe

### Review Table
- Rating constraint (1-5)
- Foreign key constraints on property_id and user_id

### Message Table
- Foreign key constraints on sender_id and recipient_id
- Sender and recipient must be different users

## Indexing Strategy

### Primary Keys
- All primary keys (UUIDs) are automatically indexed

### Additional Indexes
- **User.email**: For quick user lookup and authentication
- **Property.property_id**: For property searches and filtering
- **Booking.property_id**: For booking history queries
- **Booking.user_id**: For user booking history
- **Booking.booking_id**: For payment processing
- **Review.property_id**: For property review aggregation
- **Message.sender_id** and **Message.recipient_id**: For message threading

## Files in this Directory
- `requirements.md`: This specification document
- `airbnb_er_diagram.html`: Interactive visual ER diagram
- `airbnb_er_diagram.drawio`: Draw.io source file (if created)
