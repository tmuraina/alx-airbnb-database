````markdown
# SQL Joins - AirBnB Clone (Advanced Database Scripts)

This project is part of the AirBnB clone backend.  
The objective is to practice SQL joins by writing complex queries to combine data from multiple tables.

---

## 📂 Files
- `joins_queries.sql` → Contains the SQL queries for this task.
- `README.md` → Documentation and explanations of the queries.

---

## 🔑 Task Objectives
Write queries using different types of SQL joins:

1. INNER JOIN → Retrieve all bookings and the respective users who made those bookings.
2. LEFT JOIN → Retrieve all properties and their reviews, including properties that have no reviews.
3. FULL OUTER JOIN → Retrieve all users and all bookings, even if:
   - A user has no booking.
   - A booking is not linked to a user.

---

## 📝 Queries

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
INNER JOIN users u ON b.user_id = u.id
ORDER BY b.id;
````

---

### 2. LEFT JOIN - Properties and Reviews

Retrieves all properties and their reviews, including properties with no reviews.
The results are sorted by `property_id` to ensure consistency.

```sql
SELECT p.id AS property_id,
       p.name AS property_name,
       p.location,
       r.id AS review_id,
       r.rating,
       r.comment
FROM properties p
LEFT JOIN reviews r ON p.id = r.property_id
ORDER BY p.id;
```

---

### 3. FULL OUTER JOIN - Users and Bookings

Retrieves all users and all bookings, even if there is no match between them.

#### PostgreSQL:

```sql
SELECT u.id AS user_id,
       u.name AS user_name,
       b.id AS booking_id,
       b.property_id,
       b.start_date,
       b.end_date
FROM users u
FULL OUTER JOIN bookings b ON u.id = b.user_id
ORDER BY u.id;
```

#### MySQL (since it does not support FULL OUTER JOIN natively, we use UNION):

```sql
SELECT u.id AS user_id,
       u.name AS user_name,
       b.id AS booking_id,
       b.property_id,
       b.start_date,
       b.end_date
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
UNION
SELECT u.id AS user_id,
       u.name AS user_name,
       b.id AS booking_id,
       b.property_id,
       b.start_date,
       b.end_date
FROM users u
RIGHT JOIN bookings b ON u.id = b.user_id
ORDER BY user_id;
```
