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



# ALX Airbnb Database - Task 1: Practice Subqueries

## Overview
This task focuses on implementing both correlated and non-correlated subqueries to retrieve complex data from an Airbnb database. The queries demonstrate advanced SQL techniques for filtering and analyzing data based on aggregate conditions and cross-table relationships.

## Database Schema Assumptions
The queries assume the following table structure:
- `User` (user_id, first_name, last_name, email, created_at)
- `Property` (property_id, name, location, pricepernight, host_id)
- `Booking` (booking_id, user_id, property_id, start_date, end_date, status)
- `Review` (review_id, property_id, user_id, rating, comment, created_at)

## Query Implementations

### 1. Non-Correlated Subquery
**Objective:** Find all properties where the average rating is greater than 4.0

```sql
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    p.host_id
FROM 
    Property p
WHERE 
    p.property_id IN (
        SELECT 
            r.property_id
        FROM 
            Review r
        GROUP BY 
            r.property_id
        HAVING 
            AVG(r.rating) > 4.0
    );
```

**Explanation:** This query uses a non-correlated subquery in the WHERE clause. The inner query executes independently of the outer query, calculating average ratings for all properties and returning those with ratings > 4.0. The outer query then filters properties based on these results.

### 2. Correlated Subquery
**Objective:** Find users who have made more than 3 bookings

```sql
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.created_at
FROM 
    User u
WHERE 
    (SELECT COUNT(*) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) > 3;
```

**Explanation:** This is a correlated subquery where the inner query references the outer query's table (`u.user_id`). For each user in the outer query, the inner query counts their bookings. The correlation makes this query execute the subquery once for each row in the outer query.

## Key Concepts

### Non-Correlated Subqueries
- Execute independently of the outer query
- Run once and return results used by the outer query
- Generally more efficient for large datasets
- Can often be optimized by the database engine

### Correlated Subqueries
- Reference columns from the outer query
- Execute once for each row in the outer query
- More flexible but potentially less efficient
- Useful when you need row-by-row comparisons

## Performance Considerations

1. **Indexing:** Ensure proper indexes on:
   - `Review.property_id` and `Review.rating` for the rating subquery
   - `Booking.user_id` for the booking count subquery

2. **Alternative Approaches:** Consider using JOINs with GROUP BY clauses for better performance in some cases

3. **Query Optimization:** Modern database engines can often optimize EXISTS clauses better than IN clauses with subqueries

## Alternative Implementations

The script also includes alternative approaches using:
- `EXISTS` instead of `IN` for better performance
- Additional complex subqueries for practice
- Various subquery patterns (scalar, table, correlated)

## Usage Instructions

1. Ensure your database contains the required tables with appropriate data
2. Execute the queries in the provided order
3. Verify results match expected business logic
4. Monitor query performance and adjust indexes as needed

## Files
- `subqueries.sql` - Contains all subquery implementations
- `README.md` - This documentation file

## Learning Outcomes
After completing this task, you should understand:
- The difference between correlated and non-correlated subqueries
- When to use each type of subquery
- Performance implications of different subquery approaches
- How subqueries integrate with aggregate functions and filtering conditions
