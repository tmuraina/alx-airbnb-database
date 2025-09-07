# SQL Joins - AirBnB Clone (Advanced Database Scripts)

This task demonstrates usage of SQL joins for the **AirBnB database project**.

## Queries Implemented

### 1. INNER JOIN - Users and Bookings
Retrieves all bookings and the users who made them.

```sql
SELECT b.id AS booking_id,
       b.property_id,
       b.start_date,
       b.end_date,
       u.id AS user_id,
       u.name AS user_name,
       u.email
FROM bookings b
INNER JOIN users u ON b.user_id = u.id;
