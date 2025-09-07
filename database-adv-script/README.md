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




# ALX Airbnb Database - Task 2: Apply Aggregations and Window Functions

## Overview
This task focuses on implementing SQL aggregation functions with GROUP BY clauses and advanced window functions to analyze booking patterns and property performance. The queries demonstrate how to extract meaningful business insights from relational data using modern SQL analytical capabilities.

## Database Schema Assumptions
The queries assume the following table structure:
- `User` (user_id, first_name, last_name, email, created_at)
- `Property` (property_id, name, location, pricepernight, host_id)
- `Booking` (booking_id, user_id, property_id, start_date, end_date, status)

## Query Implementations

### 1. Aggregation with COUNT and GROUP BY
**Objective:** Find the total number of bookings made by each user

```sql
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
ORDER BY 
    total_bookings DESC, u.user_id;
```

**Key Features:**
- Uses `LEFT JOIN` to include users with zero bookings
- Groups by all non-aggregate columns to avoid SQL errors
- Orders results by booking count (descending) for business insights
- Includes alternative INNER JOIN version for users with bookings only

### 2. Window Functions - ROW_NUMBER and RANK
**Objective:** Rank properties based on total number of bookings

```sql
-- Using ROW_NUMBER()
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank_row_number
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.location, p.pricepernight
ORDER BY 
    total_bookings DESC;

-- Using RANK()
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.location, p.pricepernight
ORDER BY 
    total_bookings DESC;
```

## Window Function Concepts

### ROW_NUMBER()
- Assigns unique sequential numbers to each row
- No ties - each row gets a different number
- Useful for pagination and creating unique identifiers

### RANK()
- Assigns the same rank to rows with identical values
- Leaves gaps in ranking after ties (e.g., 1, 2, 2, 4)
- Best for competitive rankings where ties matter

### DENSE_RANK()
- Similar to RANK() but without gaps
- After ties, continues with next consecutive number (e.g., 1, 2, 2, 3)
- Useful when you want consecutive ranking numbers

## Advanced Window Function Examples

### 1. Partitioned Rankings
```sql
-- Rank properties within each location
RANK() OVER (PARTITION BY p.location ORDER BY COUNT(b.booking_id) DESC) AS location_rank
```

### 2. Running Totals
```sql
-- Cumulative sum of bookings
SUM(COUNT(b.booking_id)) OVER (ORDER BY COUNT(b.booking_id) DESC) AS running_total
```

### 3. Lag/Lead Functions
```sql
-- Previous month's booking count
LAG(COUNT(*), 1) OVER (ORDER BY booking_month) AS previous_month_bookings
```

### 4. Percentiles and Quartiles
```sql
-- Divide properties into 4 revenue quartiles
NTILE(4) OVER (ORDER BY total_revenue DESC) AS revenue_quartile
```

## Business Applications

### User Analysis
- **Customer Segmentation**: Identify power users vs. occasional users
- **Retention Analysis**: Track booking patterns over time
- **Marketing Targets**: Focus on users with specific booking behaviors

### Property Performance
- **Revenue Optimization**: Identify top-performing properties
- **Location Analysis**: Compare performance across different areas
- **Pricing Strategy**: Correlate booking volume with pricing

### Operational Insights
- **Seasonal Trends**: Monthly booking patterns with growth rates
- **Capacity Planning**: Cumulative booking trends
- **Performance Benchmarking**: Percentile rankings for properties

## Performance Considerations

### Indexing Strategies
1. **Booking Analysis**: Index on `(user_id, booking_id)` and `(property_id, booking_id)`
2. **Date Range Queries**: Index on `(start_date, status)` for temporal analysis
3. **Location Analysis**: Index on `(location, property_id)` for partitioned queries

### Query Optimization
1. **Window Functions**: More efficient than self-joins for ranking
2. **LEFT JOIN vs INNER JOIN**: Choose based on business requirements
3. **GROUP BY Optimization**: Include all selected non-aggregate columns
4. **PARTITION BY**: Use to limit window function scope and improve performance

## Common Patterns and Best Practices

### 1. Handling NULL Values
```sql
-- Use COALESCE for default values
COALESCE(COUNT(b.booking_id), 0) AS total_bookings
```

### 2. Multiple Window Functions
```sql
-- Combine different ranking methods in one query
ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS row_num,
RANK() OVER (ORDER BY total_bookings DESC) AS rank_with_ties
```

### 3. Conditional Aggregation
```sql
-- Count only confirmed bookings
COUNT(CASE WHEN b.status = 'confirmed' THEN b.booking_id END) AS confirmed_bookings
```

## Files Structure
```
database-adv-script/
├── aggregations_and_window_functions.sql
└── README_Task2.md
```

## Learning Outcomes
After completing this task, you should understand:
- How to use GROUP BY with aggregate functions effectively
- The differences between ROW_NUMBER(), RANK(), and DENSE_RANK()
- When and how to use PARTITION BY in window functions
- Advanced window functions like LAG, LEAD, and NTILE
- Performance implications of window functions vs. traditional approaches
- Real-world business applications of analytical SQL queries

## Usage Instructions
1. Execute queries sequentially to understand concept progression
2. Modify PARTITION BY clauses to analyze different business dimensions
3. Experiment with different ORDER BY criteria in window functions
4. Use EXPLAIN PLAN to understand query execution and optimization opportunities
