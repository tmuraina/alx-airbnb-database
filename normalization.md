# Database Normalization Analysis - AirBnB

## Table of Contents
1. [Introduction](#introduction)
2. [Current Schema Analysis](#current-schema-analysis)
3. [Normalization Review](#normalization-review)
4. [First Normal Form (1NF)](#first-normal-form-1nf)
5. [Second Normal Form (2NF)](#second-normal-form-2nf)
6. [Third Normal Form (3NF)](#third-normal-form-3nf)
7. [Identified Issues and Solutions](#identified-issues-and-solutions)
8. [Final Normalized Schema](#final-normalized-schema)
9. [Recommendations](#recommendations)

---

## Introduction

This document analyzes the AirBnB database design for compliance with normalization principles up to the Third Normal Form (3NF). The goal is to eliminate data redundancy, reduce storage requirements, and maintain data integrity while ensuring optimal database performance.

## Current Schema Analysis

### Existing Tables Overview
1. **User** - Stores user information (guests, hosts, admins)
2. **Property** - Stores property listings
3. **Booking** - Stores reservation information
4. **Payment** - Stores payment transactions
5. **Review** - Stores property reviews
6. **Message** - Stores user communications

---

## Normalization Review

### What is Database Normalization?

Database normalization is the process of organizing data to minimize redundancy and dependency. The main goals are:
- **Eliminate redundant data** (storing the same data multiple times)
- **Ensure data dependencies make sense** (only storing related data together)
- **Reduce storage space** and **improve data integrity**

### Normal Forms Hierarchy
- **1NF**: Atomic values, no repeating groups
- **2NF**: 1NF + no partial dependencies on composite keys
- **3NF**: 2NF + no transitive dependencies

---

## First Normal Form (1NF)

### Definition
A table is in 1NF if:
- All attributes contain atomic (indivisible) values
- No repeating groups or arrays
- Each row is unique

### Analysis of Current Schema

#### ✅ **COMPLIANT TABLES**

**User Table**
```sql
✓ user_id: UUID (atomic)
✓ first_name: VARCHAR (atomic)
✓ last_name: VARCHAR (atomic)
✓ email: VARCHAR (atomic)
✓ password_hash: VARCHAR (atomic)
✓ phone_number: VARCHAR (atomic)
✓ role: ENUM (atomic)
✓ created_at: TIMESTAMP (atomic)
```

**Property Table**
```sql
✓ property_id: UUID (atomic)
✓ host_id: UUID (atomic)
✓ name: VARCHAR (atomic)
✓ description: TEXT (atomic)
✓ location: VARCHAR (atomic) - POTENTIAL ISSUE
✓ price_per_night: DECIMAL (atomic)
✓ created_at: TIMESTAMP (atomic)
✓ updated_at: TIMESTAMP (atomic)
```

**Booking Table**
```sql
✓ booking_id: UUID (atomic)
✓ property_id: UUID (atomic)
✓ user_id: UUID (atomic)
✓ start_date: DATE (atomic)
✓ end_date: DATE (atomic)
✓ total_price: DECIMAL (atomic)
✓ status: ENUM (atomic)
✓ created_at: TIMESTAMP (atomic)
```

**Payment Table**
```sql
✓ payment_id: UUID (atomic)
✓ booking_id: UUID (atomic)
✓ amount: DECIMAL (atomic)
✓ payment_date: TIMESTAMP (atomic)
✓ payment_method: ENUM (atomic)
```

**Review Table**
```sql
✓ review_id: UUID (atomic)
✓ property_id: UUID (atomic)
✓ user_id: UUID (atomic)
✓ rating: INTEGER (atomic)
✓ comment: TEXT (atomic)
✓ created_at: TIMESTAMP (atomic)
```

**Message Table**
```sql
✓ message_id: UUID (atomic)
✓ sender_id: UUID (atomic)
✓ recipient_id: UUID (atomic)
✓ message_body: TEXT (atomic)
✓ sent_at: TIMESTAMP (atomic)
```

#### ⚠️ **POTENTIAL 1NF VIOLATION**

**Property.location** field might contain composite data:
```
Example: "123 Main St, New York, NY, 10001, USA"
```

**SOLUTION**: Normalize location into separate fields or create a Location table.

---

## Second Normal Form (2NF)

### Definition
A table is in 2NF if:
- It's in 1NF
- No partial dependencies (non-key attributes depend on only part of a composite primary key)

### Analysis

#### ✅ **ALL TABLES COMPLIANT**

All our tables use **single-column primary keys** (UUIDs), so partial dependencies are impossible. Each table automatically satisfies 2NF because:

- **User**: Primary key is `user_id` (single column)
- **Property**: Primary key is `property_id` (single column)
- **Booking**: Primary key is `booking_id` (single column)
- **Payment**: Primary key is `payment_id` (single column)
- **Review**: Primary key is `review_id` (single column)
- **Message**: Primary key is `message_id` (single column)

**Result**: No changes needed for 2NF compliance.

---

## Third Normal Form (3NF)

### Definition
A table is in 3NF if:
- It's in 2NF
- No transitive dependencies (non-key attributes don't depend on other non-key attributes)

### Analysis and Issues Found

#### ⚠️ **TRANSITIVE DEPENDENCY ISSUES**

**1. Booking Table - Total Price Calculation**
```sql
booking_id | property_id | start_date | end_date | total_price
```

**Issue**: `total_price` can be calculated from:
- `Property.price_per_night`
- `(end_date - start_date)` 
- Potential discounts/fees

**Dependency Chain**: 
`booking_id → property_id → price_per_night → total_price`

**SOLUTION**: 
- Remove `total_price` from Booking table (make it calculated)
- OR keep it for historical accuracy (prices may change)

**2. Property Table - Location Normalization**
```sql
property_id | location
```

**Issue**: Location contains multiple components:
- Street address
- City
- State/Province  
- Country
- Postal code

**SOLUTION**: Create separate Location table or normalize location fields.

#### ✅ **COMPLIANT AREAS**

- **User Table**: No transitive dependencies
- **Payment Table**: All non-key attributes directly depend on payment_id
- **Review Table**: Rating and comment directly relate to the review
- **Message Table**: Message content directly relates to the message instance

---

## Identified Issues and Solutions

### Issue 1: Location Normalization

**Current Design**:
```sql
Property {
    property_id: UUID,
    location: VARCHAR  -- "123 Main St, New York, NY, 10001, USA"
}
```

**Problem**: Violates 1NF (composite data) and 3NF (city data repeated)

**Solution**: Create normalized location structure

### Issue 2: Total Price Storage

**Current Design**:
```sql
Booking {
    booking_id: UUID,
    property_id: UUID,
    total_price: DECIMAL  -- Calculated from property price * nights
}
```

**Problem**: Transitive dependency (total_price depends on property price)

**Solution**: Keep for historical accuracy but document the dependency

---

## Final Normalized Schema

### Proposed Changes

#### 1. **New Location Table** (Addresses 1NF and 3NF issues)
```sql
Location {
    location_id: UUID PRIMARY KEY,
    street_address: VARCHAR NOT NULL,
    city: VARCHAR NOT NULL,
    state_province: VARCHAR NOT NULL,
    country: VARCHAR NOT NULL,
    postal_code: VARCHAR,
    latitude: DECIMAL(10,8),
    longitude: DECIMAL(11,8),
    created_at: TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}
```

#### 2. **Updated Property Table**
```sql
Property {
    property_id: UUID PRIMARY KEY,
    host_id: UUID FOREIGN KEY REFERENCES User(user_id),
    location_id: UUID FOREIGN KEY REFERENCES Location(location_id),
    name: VARCHAR NOT NULL,
    description: TEXT NOT NULL,
    price_per_night: DECIMAL NOT NULL,
    created_at: TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at: TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
}
```

#### 3. **Enhanced Booking Table** (with price justification)
```sql
Booking {
    booking_id: UUID PRIMARY KEY,
    property_id: UUID FOREIGN KEY REFERENCES Property(property_id),
    user_id: UUID FOREIGN KEY REFERENCES User(user_id),
    start_date: DATE NOT NULL,
    end_date: DATE NOT NULL,
    price_per_night_at_booking: DECIMAL NOT NULL,  -- Historical price
    total_price: DECIMAL NOT NULL,                 -- Calculated but stored for history
    status: ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at: TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}
```

### Normalization Summary

#### **1NF Compliance**: ✅
- All atomic values
- Location normalized into separate table
- No repeating groups

#### **2NF Compliance**: ✅  
- All tables use single-column primary keys
- No partial dependencies possible

#### **3NF Compliance**: ✅
- Location data normalized to eliminate transitive dependencies
- Total price kept for business reasons but documented
- No other transitive dependencies identified

---

## New Relationships After Normalization

### Additional Relationship
- **Property → Location** (M:1): Multiple properties can share the same location

### Updated ER Relationships
1. **User → Property** (1:M): One user can host multiple properties
2. **Location → Property** (1:M): One location can have multiple properties  
3. **User → Booking** (1:M): One user can make multiple bookings
4. **Property → Booking** (1:M): One property can have multiple bookings
5. **Booking → Payment** (1:1): Each booking has exactly one payment
6. **User → Review** (1:M): One user can write multiple reviews
7. **Property → Review** (1:M): One property can receive multiple reviews
8. **User → Message (Sender)** (1:M): One user can send multiple messages
9. **User → Message (Recipient)** (1:M): One user can receive multiple messages

---

## Recommendations

### 1. **Implement Location Table**
- Reduces data redundancy for properties in same location
- Enables better location-based queries
- Supports future features like location analytics

### 2. **Consider Additional Normalizations**

#### **Property Amenities** (Future Enhancement)
```sql
PropertyAmenity {
    property_id: UUID FOREIGN KEY,
    amenity_id: UUID FOREIGN KEY,
    PRIMARY KEY (property_id, amenity_id)
}

Amenity {
    amenity_id: UUID PRIMARY KEY,
    name: VARCHAR NOT NULL,
    category: VARCHAR
}
```

#### **User Profiles** (Future Enhancement)
```sql
UserProfile {
    user_id: UUID PRIMARY KEY FOREIGN KEY REFERENCES User(user_id),
    bio: TEXT,
    profile_picture_url: VARCHAR,
    verification_status: ENUM('pending', 'verified', 'rejected'),
    date_of_birth: DATE,
    preferred_language: VARCHAR
}
```

### 3. **Database Integrity Measures**
- Add CHECK constraints for date ranges (end_date > start_date)
- Add triggers for automatic total_price calculation
- Implement soft deletes for audit trails
- Add created_by/updated_by fields for audit logging

### 4. **Performance Considerations**
- Index foreign key columns
- Consider partitioning large tables (Booking, Message) by date
- Implement database views for common queries
- Consider read replicas for reporting

---

## Conclusion

The current AirBnB database design is largely compliant with 3NF principles. The main improvement needed is **location normalization** to achieve full 1NF and 3NF compliance. The proposed changes will:

- ✅ Eliminate data redundancy
- ✅ Improve data consistency  
- ✅ Enable better location-based features
- ✅ Maintain referential integrity
- ✅ Support future scalability

The normalized design maintains all functional requirements while adhering to best practices for relational database design.
