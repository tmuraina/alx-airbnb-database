-- ============================================================================
-- AirBnB Database Sample Data (Seed Script)
-- Version: 1.0
-- Created: 2025-08-31
-- Description: Realistic sample data for AirBnB database testing
-- ============================================================================

USE airbnb_db;

-- Disable foreign key checks for initial data loading
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- 1. SEED USER TABLE
-- ============================================================================

INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
-- Admins
('550e8400-e29b-41d4-a716-446655440001', 'Alice', 'Johnson', 'alice.admin@airbnb.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3F', '+1-555-0101', 'admin', '2024-01-15 08:00:00'),
('550e8400-e29b-41d4-a716-446655440002', 'Bob', 'Wilson', 'bob.admin@airbnb.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3G', '+1-555-0102', 'admin', '2024-01-20 09:30:00'),

-- Hosts
('550e8400-e29b-41d4-a716-446655440003', 'Sarah', 'Thompson', 'sarah.host@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3H', '+1-555-0201', 'host', '2024-02-01 10:15:00'),
('550e8400-e29b-41d4-a716-446655440004', 'Michael', 'Chen', 'michael.chen@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3I', '+1-555-0202', 'host', '2024-02-05 14:20:00'),
('550e8400-e29b-41d4-a716-446655440005', 'Emily', 'Rodriguez', 'emily.rodriguez@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3J', '+1-555-0203', 'host', '2024-02-10 16:45:00'),
('550e8400-e29b-41d4-a716-446655440006', 'David', 'Kim', 'david.kim@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3K', '+1-555-0204', 'host', '2024-02-15 11:30:00'),
('550e8400-e29b-41d4-a716-446655440007', 'Lisa', 'Anderson', 'lisa.anderson@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3L', '+1-555-0205', 'host', '2024-02-20 13:15:00'),

-- Guests
('550e8400-e29b-41d4-a716-446655440008', 'John', 'Smith', 'john.smith@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3M', '+1-555-0301', 'guest', '2024-03-01 09:00:00'),
('550e8400-e29b-41d4-a716-446655440009', 'Emma', 'Davis', 'emma.davis@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3N', '+1-555-0302', 'guest', '2024-03-05 12:30:00'),
('550e8400-e29b-41d4-a716-446655440010', 'James', 'Brown', 'james.brown@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3O', '+1-555-0303', 'guest', '2024-03-10 15:45:00'),
('550e8400-e29b-41d4-a716-446655440011', 'Olivia', 'Garcia', 'olivia.garcia@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3P', '+1-555-0304', 'guest', '2024-03-15 08:20:00'),
('550e8400-e29b-41d4-a716-446655440012', 'William', 'Miller', 'william.miller@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3Q', '+1-555-0305', 'guest', '2024-03-20 17:10:00'),
('550e8400-e29b-41d4-a716-446655440013', 'Sophia', 'Wilson', 'sophia.wilson@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3R', '+1-555-0306', 'guest', '2024-03-25 19:30:00'),
('550e8400-e29b-41d4-a716-446655440014', 'Alexander', 'Moore', 'alex.moore@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3S', '+1-555-0307', 'guest', '2024-04-01 10:45:00'),
('550e8400-e29b-41d4-a716-446655440015', 'Isabella', 'Taylor', 'isabella.taylor@email.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3T', '+1-555-0308', 'guest', '2024-04-05 14:15:00'),

-- International users
('550e8400-e29b-41d4-a716-446655440016', 'Pierre', 'Dubois', 'pierre.dubois@email.fr', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3U', '+33-1-55-55-0401', 'host', '2024-04-10 16:20:00'),
('550e8400-e29b-41d4-a716-446655440017', 'Yuki', 'Tanaka', 'yuki.tanaka@email.jp', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3V', '+81-3-5555-0501', 'host', '2024-04-15 11:30:00'),
('550e8400-e29b-41d4-a716-446655440018', 'Hans', 'Mueller', 'hans.mueller@email.de', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeNFNL/6F3/3K4F3W', '+49-30-555-0601', 'guest', '2024-04-20 13:40:00');

-- ============================================================================
-- 2. SEED LOCATION TABLE
-- ============================================================================

INSERT INTO Location (location_id, street_address, city, state_province, country, postal_code, latitude, longitude, created_at) VALUES
-- US Locations
('660e8400-e29b-41d4-a716-446655440001', '1234 Ocean Drive', 'Miami', 'Florida', 'USA', '33139', 25.7617, -80.1918, '2024-01-15 10:00:00'),
('660e8400-e29b-41d4-a716-446655440002', '567 Times Square', 'New York', 'New York', 'USA', '10036', 40.7589, -73.9851, '2024-01-20 11:15:00'),
('660e8400-e29b-41d4-a716-446655440003', '789 Golden Gate Ave', 'San Francisco', 'California', 'USA', '94102', 37.7749, -122.4194, '2024-01-25 12:30:00'),
('660e8400-e29b-41d4-a716-446655440004', '321 Hollywood Blvd', 'Los Angeles', 'California', 'USA', '90028', 34.0522, -118.2437, '2024-02-01 14:45:00'),
('660e8400-e29b-41d4-a716-446655440005', '456 Michigan Ave', 'Chicago', 'Illinois', 'USA', '60611', 41.8781, -87.6298, '2024-02-05 16:00:00'),
('660e8400-e29b-41d4-a716-446655440006', '890 Bourbon Street', 'New Orleans', 'Louisiana', 'USA', '70116', 29.9511, -90.0715, '2024-02-10 17:15:00'),
('660e8400-e29b-41d4-a716-446655440007', '123 Music Row', 'Nashville', 'Tennessee', 'USA', '37203', 36.1627, -86.7816, '2024-02-15 18:30:00'),

-- International Locations
('660e8400-e29b-41d4-a716-446655440008', '45 Rue de Rivoli', 'Paris', 'Île-de-France', 'France', '75001', 48.8566, 2.3522, '2024-02-20 19:45:00'),
('660e8400-e29b-41d4-a716-446655440009', '67 Shibuya Crossing', 'Tokyo', 'Tokyo', 'Japan', '150-0002', 35.6762, 139.6503, '2024-02-25 20:00:00'),
('660e8400-e29b-41d4-a716-446655440010', '89 Unter den Linden', 'Berlin', 'Berlin', 'Germany', '10117', 52.5200, 13.4050, '2024-03-01 21:15:00'),
('660e8400-e29b-41d4-a716-446655440011', '234 Oxford Street', 'London', 'England', 'United Kingdom', 'W1C 1DE', 51.5074, -0.1278, '2024-03-05 22:30:00'),
('660e8400-e29b-41d4-a716-446655440012', '345 Harbour Bridge Rd', 'Sydney', 'New South Wales', 'Australia', '2000', -33.8688, 151.2093, '2024-03-10 23:45:00');

-- ============================================================================
-- 3. SEED PROPERTY TABLE
-- ============================================================================

INSERT INTO Property (property_id, host_id, location_id, name, description, price_per_night, created_at, updated_at) VALUES
-- Miami Properties
('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', 
 'Luxury Ocean View Condo', 
 'Stunning oceanfront condo with panoramic views of Miami Beach. Features modern amenities, private balcony, and direct beach access. Perfect for couples or small families seeking a premium Miami experience.',
 285.00, '2024-02-15 10:00:00', '2024-08-15 14:30:00'),

('770e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440001',
 'Art Deco Studio Apartment',
 'Charming studio in the heart of South Beach. Authentic Art Deco building with modern renovations. Walking distance to restaurants, nightlife, and beach. Ideal for solo travelers or couples.',
 125.00, '2024-02-20 11:15:00', '2024-07-20 16:45:00'),

-- New York Properties
('770e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440002',
 'Manhattan Penthouse Suite',
 'Exclusive penthouse overlooking Central Park. 3 bedrooms, 2.5 baths, floor-to-ceiling windows, and private rooftop terrace. Luxury furnishings and concierge service. Perfect for business travelers or special occasions.',
 650.00, '2024-02-25 12:30:00', '2024-08-01 18:20:00'),

('770e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440002',
 'Cozy Brooklyn Loft',
 'Industrial-chic loft in trendy Williamsburg. Exposed brick, high ceilings, and vintage decor. Easy subway access to Manhattan. Great for creative professionals and young couples seeking authentic NYC experience.',
 180.00, '2024-03-01 13:45:00', '2024-07-15 12:10:00'),

-- San Francisco Properties
('770e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440003',
 'Victorian House with Bay Views',
 'Beautifully restored Victorian home with stunning San Francisco Bay views. 4 bedrooms, 3 baths, original hardwood floors, and modern kitchen. Perfect for families or groups exploring the city.',
 420.00, '2024-03-05 14:00:00', '2024-08-10 15:30:00'),

('770e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440003',
 'Tech Hub Apartment',
 'Modern apartment in SOMA district, close to tech companies. High-speed internet, ergonomic workspace, and smart home features. Ideal for business travelers and digital nomads.',
 220.00, '2024-03-10 15:15:00', '2024-08-05 17:45:00'),

-- Los Angeles Properties
('770e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440004',
 'Hollywood Hills Villa',
 'Luxurious villa in the Hollywood Hills with infinity pool and city views. 5 bedrooms, 4 baths, gourmet kitchen, and entertainment room. Celebrity-style living for groups and events.',
 580.00, '2024-03-15 16:30:00', '2024-08-20 19:15:00'),

('770e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440004',
 'Venice Beach Cottage',
 'Charming beach cottage steps from Venice Beach boardwalk. Bohemian decor, private patio, and bike rentals included. Perfect for beach lovers and those seeking the authentic Venice vibe.',
 195.00, '2024-03-20 17:45:00', '2024-07-25 20:30:00'),

-- Chicago Property
('770e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440005',
 'Magnificent Mile High-Rise',
 'Luxury high-rise apartment on Michigan Avenue. Floor-to-ceiling windows with city and lake views. 2 bedrooms, 2 baths, marble finishes, and building amenities. Prime location for shopping and dining.',
 275.00, '2024-03-25 18:00:00', '2024-08-12 21:45:00'),

-- New Orleans Property
('770e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440006',
 'French Quarter Historic Home',
 'Authentic Creole cottage in the heart of the French Quarter. Original architecture with modern comforts. Private courtyard, antique furnishings, and walking distance to jazz clubs and restaurants.',
 240.00, '2024-04-01 19:15:00', '2024-08-08 23:00:00'),

-- International Properties
('770e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440016', '660e8400-e29b-41d4-a716-446655440008',
 'Parisian Apartment Near Louvre',
 'Elegant Haussmanian apartment in the 1st arrondissement. High ceilings, period details, and modern amenities. Walking distance to Louvre, Notre-Dame, and finest restaurants. Perfect Parisian experience.',
 320.00, '2024-04-05 20:30:00', '2024-08-03 10:15:00'),

('770e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440017', '660e8400-e29b-41d4-a716-446655440009',
 'Tokyo Modern Minimalist',
 'Ultra-modern apartment in Shibuya district. Japanese minimalist design with high-tech amenities. Panoramic city views, smart home features, and easy access to subway. Experience modern Tokyo living.',
 295.00, '2024-04-10 21:45:00', '2024-08-18 11:30:00');

-- ============================================================================
-- 4. SEED BOOKING TABLE
-- ============================================================================

INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, price_per_night_at_booking, total_price, status, created_at) VALUES
-- Confirmed bookings (past and current)
('880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440008', 
 '2024-06-15', '2024-06-20', 285.00, 1425.00, 'confirmed', '2024-05-15 14:30:00'),

('880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440009',
 '2024-07-01', '2024-07-07', 650.00, 3900.00, 'confirmed', '2024-06-01 16:45:00'),

('880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440010',
 '2024-07-20', '2024-07-25', 420.00, 2100.00, 'confirmed', '2024-06-20 18:20:00'),

('880e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440011',
 '2024-08-05', '2024-08-12', 125.00, 875.00, 'confirmed', '2024-07-05 20:15:00'),

('880e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440012',
 '2024-08-15', '2024-08-22', 580.00, 4060.00, 'confirmed', '2024-07-15 09:30:00'),

-- Pending bookings (future)
('880e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440013',
 '2025-09-10', '2025-09-15', 275.00, 1375.00, 'pending', '2025-08-10 11:45:00'),

('880e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440014',
 '2025-10-01', '2025-10-08', 320.00, 2240.00, 'pending', '2025-08-15 13:20:00'),

('880e8400-e29b-41d4-a716-446655440008', '770e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440015',
 '2025-11-20', '2025-11-27', 295.00, 2065.00, 'pending', '2025-08-20 15:10:00'),

-- Canceled bookings
('880e8400-e29b-41d4-a716-446655440009', '770e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440008',
 '2024-09-01', '2024-09-05', 220.00, 880.00, 'canceled', '2024-08-01 10:20:00'),

('880e8400-e29b-41d4-a716-446655440010', '770e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440018',
 '2024-09-15', '2024-09-20', 195.00, 975.00, 'canceled', '2024-08-15 12:45:00');

-- ============================================================================
-- 5. SEED PAYMENT TABLE
-- ============================================================================

INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method, payment_status, transaction_id, created_at) VALUES
-- Completed payments
('990e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', 1425.00, '2024-05-15 14:35:00', 'credit_card', 'completed', 'stripe_txn_1234567890', '2024-05-15 14:35:00'),
('990e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440002', 3900.00, '2024-06-01 16:50:00', 'stripe', 'completed', 'stripe_txn_2345678901', '2024-06-01 16:50:00'),
('990e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440003', 2100.00, '2024-06-20 18:25:00', 'paypal', 'completed', 'paypal_txn_3456789012', '2024-06-20 18:25:00'),
('990e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440004', 875.00, '2024-07-05 20:20:00', 'credit_card', 'completed', 'stripe_txn_4567890123', '2024-07-05 20:20:00'),
('990e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440005', 4060.00, '2024-07-15 09:35:00', 'stripe', 'completed', 'stripe_txn_5678901234', '2024-07-15 09:35:00'),

-- Pending payments
('990e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655440006', 1375.00, '2025-08-10 11:50:00', 'credit_card', 'pending', 'stripe_txn_6789012345', '2025-08-10 11:50:00'),
('990e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655440007', 2240.00, '2025-08-15 13:25:00', 'paypal', 'pending', 'paypal_txn_7890123456', '2025-08-15 13:25:00'),
('990e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440008', 2065.00, '2025-08-20 15:15:00', 'stripe', 'pending', 'stripe_txn_8901234567', '2025-08-20 15:15:00'),

-- Refunded payments (for canceled bookings)
('990e8400-e29b-41d4-a716-446655440009', '880e8400-e29b-41d4-a716-446655440009', 880.00, '2024-08-01 10:25:00', 'credit_card', 'refunded', 'stripe_txn_9012345678', '2024-08-01 10:25:00'),
('990e8400-e29b-41d4-a716-446655440010', '880e8400-e29b-41d4-a716-446655440010', 975.00, '2024-08-15 12:50:00', 'paypal', 'refunded', 'paypal_txn_0123456789', '2024-08-15 12:50:00');

-- ============================================================================
-- 6. SEED REVIEW TABLE
-- ============================================================================

INSERT INTO Review (review_id, property_id, user_id, booking_id, rating, comment, created_at) VALUES
-- Reviews for completed bookings
('aa0e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440001',
 5, 'Absolutely stunning property! The ocean views were breathtaking and the condo was immaculate. Sarah was an excellent host - very responsive and provided great local recommendations. The beach access was perfect and the amenities exceeded our expectations. Will definitely book again!', '2024-06-22 10:30:00'),

('aa0e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440009', '880e8400-e29b-41d4-a716-446655440002',
 4, 'Amazing penthouse with incredible Central Park views! The space was luxurious and well-appointed. Only minor issue was noise from the street below, but the overall experience was fantastic. Emily was very helpful with check-in and provided excellent restaurant recommendations.', '2024-07-09 16:45:00'),

('aa0e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440010', '880e8400-e29b-41d4-a716-446655440003',
 5, 'Perfect family vacation home! The Victorian house was beautifully maintained with all the character and charm we hoped for. The bay views were spectacular, especially at sunset. David was an exceptional host - very welcoming and knowledgeable about the area. Highly recommended!', '2024-07-27 12:20:00'),

('aa0e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440011', '880e8400-e29b-41d4-a716-446655440004',
 3, 'Good location and clean apartment, but smaller than expected. The Art Deco building has character but could use some updates. Michael was responsive to questions. Overall decent value for the price, but not exceptional.', '2024-08-14 14:10:00'),

('aa0e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440012', '880e8400-e29b-41d4-a716-446655440005',
 5, 'Incredible Hollywood Hills experience! The villa exceeded all expectations - stunning views, amazing pool, and top-notch amenities. Perfect for our group celebration. Michael went above and beyond to ensure our stay was memorable. Worth every penny!', '2024-08-24 18:55:00'),

-- Additional reviews from different users
('aa0e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440013', 'booking_id_placeholder_1',
 4, 'Great oceanfront location with beautiful views. The condo was clean and well-equipped. Sarah provided excellent communication throughout our stay. The only downside was limited parking, but overall a wonderful Miami Beach experience.', '2024-05-10 09:15:00'),

('aa0e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440014', 'booking_id_placeholder_2',
 5, 'Loved the Brooklyn loft! Authentic NYC vibe with great character. The industrial design was perfect and the location in Williamsburg was ideal for exploring both Brooklyn and Manhattan. Lisa was a fantastic host with great local tips.', '2024-04-25 20:30:00'),

('aa0e8400-e29b-41d4-a716-446655440008', '770e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440015', 'booking_id_placeholder_3',
 4, 'Perfect location for business travel! The apartment had everything needed for remote work, including excellent WiFi and a dedicated workspace. Sarah was very accommodating with early check-in. Great value for money in San Francisco.', '2024-03-30 11:40:00');

-- ============================================================================
-- 7. SEED MESSAGE TABLE
-- ============================================================================

INSERT INTO Message (message_id, sender_id, recipient_id, message_body, is_read, sent_at, read_at) VALUES
-- Guest inquiries and host responses
('bb0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440003',
 'Hi Sarah! I\'m interested in booking your Miami Ocean View Condo for June 15-20. Is it available? Also, do you allow pets?', TRUE, '2024-05-10 14:20:00', '2024-05-10 15:30:00'),

('bb0e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440008',
 'Hello John! Yes, the condo is available for those dates. Unfortunately, we don\'t allow pets due to building regulations. The space is perfect for couples and the ocean views are amazing! Would you like to proceed with the booking?', TRUE, '2024-05-10 15:45:00', '2024-05-10 16:10:00'),

('bb0e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440003',
 'Perfect! I\'ll go ahead and book it. What time is check-in and do you have any restaurant recommendations?', TRUE, '2024-05-10 16:15:00', '2024-05-10 17:00:00'),

('bb0e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440008',
 'Wonderful! Check-in is at 3 PM. For restaurants, I highly recommend Joe\'s Stone Crab for seafood and Versailles for authentic Cuban cuisine. Both are local favorites! I\'ll send you the full welcome guide closer to your arrival.', TRUE, '2024-05-10 17:15:00', '2024-05-10 17:45:00'),

-- Business inquiry
('bb0e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440005',
 'Hi Emily, I need accommodation for a business trip to NYC July 1-7. Your penthouse looks perfect. Can you confirm availability and if there\'s a workspace suitable for video calls?', TRUE, '2024-05-25 09:30:00', '2024-05-25 10:15:00'),

('bb0e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440009',
 'Hello Emma! Yes, it\'s available and perfect for business travelers. There\'s a dedicated office space with excellent lighting for video calls, plus high-speed internet throughout. The building also has a business center if needed.', TRUE, '2024-05-25 10:30:00', '2024-05-25 11:00:00'),

-- Group booking inquiry
('bb0e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440004',
 'Hi Michael! Planning a group celebration in LA for 7 people. Your Hollywood Hills Villa looks amazing! Is it available August 15-22? Any restrictions on events or noise?', TRUE, '2024-07-01 13:20:00', '2024-07-01 14:45:00'),

('bb0e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440012',
 'Hi Sophia! The villa is perfect for groups and available for your dates. Small gatherings are welcome, but please keep noise levels reasonable after 10 PM for neighbors. The space can comfortably accommodate 7 guests with amazing entertainment areas!', TRUE, '2024-07-01 15:00:00', '2024-07-01 15:30:00'),

-- International guest inquiry
('bb0e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440018', '550e8400-e29b-41d4-a716-446655440016',
 'Bonjour Pierre! I\'m visiting Paris for the first time and your apartment near the Louvre looks perfect. Do you have any tips for first-time visitors? Also, is breakfast included?', TRUE, '2024-07-20 16:40:00', '2024-07-20 18:20:00'),

('bb0e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440016', '550e8400-e29b-41d4-a716-446655440018',
 'Bonjour Hans! Welcome to Paris! The location is perfect for first-time visitors - you can walk to major attractions. Breakfast isn\'t included, but there\'s a wonderful café downstairs. I\'ll prepare a welcome packet with my favorite local spots!', TRUE, '2024-07-20 19:00:00', '2024-07-20 19:30:00'),

-- Unread messages
('bb0e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440013', '550e8400-e29b-41d4-a716-446655440006',
 'Hi David! I just booked your Chicago apartment for September. Could you recommend some good deep-dish pizza places? I\'ve heard so much about Chicago pizza!', FALSE, '2025-08-29 14:20:00', NULL),

('bb0e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440014', '550e8400-e29b-41d4-a716-446655440016',
 'Bonjour! I\'m excited about my October booking in Paris. Is there anything special I should know about the building or neighborhood? Merci!', FALSE, '2025-08-30 11:55:00', NULL);

-- ============================================================================
-- 8. ADDITIONAL SAMPLE DATA FOR TESTING
-- ============================================================================

-- More properties to test various scenarios
INSERT INTO Property (property_id, host_id, location_id, name, description, price_per_night, created_at) VALUES
('770e8400-e29b-41d4-a716-446655440013', '550e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440007',
 'Music City Downtown Loft', 
 'Stylish loft in downtown Nashville, walking distance to honky-tonk bars and music venues. Industrial design with modern amenities. Perfect for music lovers and nightlife enthusiasts.',
 165.00, '2024-04-15 12:00:00'),

('770e8400-e29b-41d4-a716-446655440014', '550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440010',
 'Berlin Modern Apartment',
 'Contemporary apartment in trendy Mitte district. Minimalist design, high-speed internet, and easy access to museums, galleries, and nightlife. Great for digital nomads and culture enthusiasts.',
 145.00, '2024-04-20 14:30:00');

-- More bookings for comprehensive testing
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, price_per_night_at_booking, total_price, status, created_at) VALUES
-- Historical bookings (for review purposes)
('880e8400-e29b-41d4-a716-446655440011', '770e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440013', 
 '2024-04-15', '2024-04-20', 180.00, 900.00, 'confirmed', '2024-03-15 11:20:00'),

('880e8400-e29b-41d4-a716-446655440012', '770e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440014',
 '2024-05-01', '2024-05-06', 220.00, 1100.00, 'confirmed', '2024-04-01 13:45:00'),

('880e8400-e29b-41d4-a716-446655440013', '770e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440015',
 '2024-05-20', '2024-05-25', 195.00, 975.00, 'confirmed', '2024-04-20 15:30:00');

-- Additional payments for new bookings
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method, payment_status, transaction_id, created_at) VALUES
('990e8400-e29b-41d4-a716-446655440011', '880e8400-e29b-41d4-a716-446655440011', 900.00, '2024-03-15 11:25:00', 'credit_card', 'completed', 'stripe_txn_1122334455', '2024-03-15 11:25:00'),
('990e8400-e29b-41d4-a716-446655440012', '880e8400-e29b-41d4-a716-446655440012', 1100.00, '2024-04-01 13:50:00', 'paypal', 'completed', 'paypal_txn_2233445566', '2024-04-01 13:50:00'),
('990e8400-e29b-41d4-a716-446655440013', '880e8400-e29b-41d4-a716-446655440013', 975.00, '2024-04-20 15:35:00', 'stripe', 'completed', 'stripe_txn_3344556677', '2024-04-20 15:35:00');

-- More reviews to establish patterns
INSERT INTO Review (review_id, property_id, user_id, booking_id, rating, comment, created_at) VALUES
('aa0e8400-e29b-41d4-a716-446655440009', '770e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440013', '880e8400-e29b-41d4-a716-446655440011',
 4, 'Great Brooklyn location with easy Manhattan access! The loft had tons of character and David was very helpful. The neighborhood is vibrant with excellent restaurants and bars. Would definitely stay again when visiting NYC.', '2024-04-22 16:30:00'),

('aa0e8400-e29b-41d4-a716-446655440010', '770e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440014', '880e8400-e29b-41d4-a716-446655440012',
 5, 'Outstanding workspace setup for remote work! The apartment had everything needed for productivity, plus the SOMA location was perfect for tech meetups. Sarah thought of every detail. Highly recommend for business travelers to SF.', '2024-05-08 10:45:00'),

('aa0e8400-e29b-41d4-a716-446655440011', '770e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440015', '880e8400-e29b-41d4-a716-446655440013',
 5, 'Perfect Venice Beach experience! The cottage captured the bohemian spirit perfectly. Being steps from the boardwalk and beach was incredible. Emily provided bikes which made exploring so much fun. Truly authentic LA experience!', '2024-05-27 14:20:00'),

-- Mixed ratings for realistic distribution
('aa0e8400-e29b-41d4-a716-446655440012', '770e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440011', 'booking_id_placeholder_4',
 3, 'Nice apartment with good city views, but the building elevator was frequently out of service. The location on Michigan Avenue was excellent for shopping and dining. David was responsive but could improve building maintenance.', '2024-06-15 13:25:00'),

('aa0e8400-e29b-41d4-a716-446655440013', '770e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440012', 'booking_id_placeholder_5',
 5, 'Magical French Quarter experience! The historic cottage was beautifully preserved with modern comforts. Lisa provided wonderful insights into New Orleans culture and the best jazz clubs. The courtyard was a peaceful retreat from the bustling streets.', '2024-07-10 18:40:00');

-- ============================================================================
-- 9. AUDIT LOG SAMPLE DATA
-- ============================================================================

INSERT INTO AuditLog (audit_id, table_name, record_id, operation, old_values, new_values, user_id, timestamp) VALUES
('cc0e8400-e29b-41d4-a716-446655440001', 'User', '550e8400-e29b-41d4-a716-446655440008', 'UPDATE', 
 '{"phone_number": null}', '{"phone_number": "+1-555-0301"}', '550e8400-e29b-41d4-a716-446655440008', '2024-03-05 15:20:00'),

('cc0e8400-e29b-41d4-a716-446655440002', 'Property', '770e8400-e29b-41d4-a716-446655440001', 'UPDATE',
 '{"price_per_night": "275.00"}', '{"price_per_night": "285.00"}', '550e8400-e29b-41d4-a716-446655440003', '2024-08-15 14:30:00'),

('cc0e8400-e29b-41d4-a716-446655440003', 'Booking', '880e8400-e29b-41d4-a716-446655440009', 'UPDATE',
 '{"status": "pending"}', '{"status": "canceled"}', '550e8400-e29b-41d4-a716-446655440008', '2024-08-01 10:25:00'),

('cc0e8400-e29b-41d4-a716-446655440004', 'Payment', '990e8400-e29b-41d4-a716-446655440009', 'UPDATE',
 '{"payment_status": "completed"}', '{"payment_status": "refunded"}', '550e8400-e29b-41d4-a716-446655440001', '2024-08-01 10:30:00');

-- ============================================================================
-- 10. DATA VALIDATION AND VERIFICATION
-- ============================================================================

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Verify data integrity
SELECT 'User Count:' AS Description, COUNT(*) AS Count FROM User
UNION ALL
SELECT 'Location Count:', COUNT(*) FROM Location
UNION ALL
SELECT 'Property Count:', COUNT(*) FROM Property
UNION ALL
SELECT 'Booking Count:', COUNT(*) FROM Booking
UNION ALL
SELECT 'Payment Count:', COUNT(*) FROM Payment
UNION ALL
SELECT 'Review Count:', COUNT(*) FROM Review
UNION ALL
SELECT 'Message Count:', COUNT(*) FROM Message;

-- Check foreign key integrity
SELECT 'Orphaned Properties:' AS Check_Type, COUNT(*) AS Count 
FROM Property p LEFT JOIN User u ON p.host_id = u.user_id WHERE u.user_id IS NULL
UNION ALL
SELECT 'Orphaned Bookings (Property):', COUNT(*)
FROM Booking b LEFT JOIN Property p ON b.property_id = p.property_id WHERE p.property_id IS NULL
UNION ALL
SELECT 'Orphaned Bookings (User):', COUNT(*)
FROM Booking b LEFT JOIN User u ON b.user_id = u.user_id WHERE u.user_id IS NULL
UNION ALL
SELECT 'Orphaned Payments:', COUNT(*)
FROM Payment p LEFT JOIN Booking b ON p.booking_id = b.booking_id WHERE b.booking_id IS NULL
UNION ALL
SELECT 'Orphaned Reviews (Property):', COUNT(*)
FROM Review r LEFT JOIN Property p ON r.property_id = p.property_id WHERE p.property_id IS NULL
UNION ALL
SELECT 'Orphaned Reviews (User):', COUNT(*)
FROM Review r LEFT JOIN User u ON r.user_id = u.user_id WHERE u.user_id IS NULL;

-- ============================================================================
-- 11. SAMPLE ANALYTICAL QUERIES (for testing)
-- ============================================================================

-- Top-rated properties
SELECT 
    p.name AS property_name,
    l.city,
    l.country,
    AVG(r.rating) AS avg_rating,
    COUNT(r.review_id) AS review_count,
    p.price_per_night
FROM Property p
JOIN Location l ON p.location_id = l.location_id
LEFT JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id, p.name, l.city, l.country, p.price_per_night
HAVING review_count > 0
ORDER BY avg_rating DESC, review_count DESC;

-- Host performance summary
SELECT 
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    COUNT(DISTINCT p.property_id) AS properties_count,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    COUNT(CASE WHEN b.status = 'confirmed' THEN 1 END) AS confirmed_bookings,
    SUM(CASE WHEN b.status = 'confirmed' THEN b.total_price ELSE 0 END) AS total_revenue,
    AVG(r.rating) AS avg_rating
FROM User u
JOIN Property p ON u.user_id = p.host_id
LEFT JOIN Booking b ON p.property_id = b.property_id
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE u.role = 'host'
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_revenue DESC;

-- Booking trends by month
SELECT 
    YEAR(created_at) AS booking_year,
    MONTH(created_at) AS booking_month,
    COUNT(*) AS total_bookings,
    COUNT(CASE WHEN status = 'confirmed' THEN 1 END) AS confirmed_bookings,
    COUNT(CASE WHEN status = 'canceled' THEN 1 END) AS canceled_bookings,
    SUM(CASE WHEN status = 'confirmed' THEN total_price ELSE 0 END) AS monthly_revenue
FROM Booking
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY booking_year DESC, booking_month DESC;

-- Popular destinations
SELECT 
    l.city,
    l.country,
    COUNT(DISTINCT p.property_id) AS properties_available,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    AVG(p.price_per_night) AS avg_price_per_night,
    AVG(r.rating) AS avg_rating
FROM Location l
JOIN Property p ON l.location_id = p.location_id
LEFT JOIN Booking b ON p.property_id = b.property_id
LEFT JOIN Review r ON p.property_id = r.property_id
GROUP BY l.location_id, l.city, l.country
ORDER BY total_bookings DESC;

-- ============================================================================
-- 12. SAMPLE DATA STATISTICS
-- ============================================================================

-- Display comprehensive data summary
SELECT '=== DATABASE POPULATION SUMMARY ===' AS Info;

SELECT 
    'Total Users' AS Metric,
    COUNT(*) AS Value,
    CONCAT(
        COUNT(CASE WHEN role = 'admin' THEN 1 END), ' Admins, ',
        COUNT(CASE WHEN role = 'host' THEN 1 END), ' Hosts, ',
        COUNT(CASE WHEN role = 'guest' THEN 1 END), ' Guests'
    ) AS Breakdown
FROM User;

SELECT 
    'Total Properties' AS Metric,
    COUNT(*) AS Value,
    CONCAT('Avg Price: , ROUND(AVG(price_per_night), 2)) AS Breakdown
FROM Property;

SELECT 
    'Total Bookings' AS Metric,
    COUNT(*) AS Value,
    CONCAT(
        COUNT(CASE WHEN status = 'confirmed' THEN 1 END), ' Confirmed, ',
        COUNT(CASE WHEN status = 'pending' THEN 1 END), ' Pending, ',
        COUNT(CASE WHEN status = 'canceled' THEN 1 END), ' Canceled'
    ) AS Breakdown
FROM Booking;

SELECT 
    'Total Revenue' AS Metric,
    CONCAT(', FORMAT(SUM(CASE WHEN status = 'confirmed' THEN total_price ELSE 0 END), 2)) AS Value,
    'From Confirmed Bookings' AS Breakdown
FROM Booking;

SELECT 
    'Average Rating' AS Metric,
    ROUND(AVG(rating), 2) AS Value,
    CONCAT('From ', COUNT(*), ' Reviews') AS Breakdown
FROM Review;

-- ============================================================================
-- 13. TEST DATA SCENARIOS
-- ============================================================================

-- Scenario 1: Popular property with multiple bookings
UPDATE Property SET description = CONCAT(description, ' [POPULAR - Multiple Bookings]')
WHERE property_id = '770e8400-e29b-41d4-a716-446655440001';

-- Scenario 2: New property with no bookings yet
INSERT INTO Property (property_id, host_id, location_id, name, description, price_per_night, created_at) VALUES
('770e8400-e29b-41d4-a716-446655440015', '550e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440011',
 'Brand New London Flat',
 'Just listed! Modern flat in central London with contemporary design and all amenities. First guests will receive special welcome package and personalized city guide.',
 200.00, '2025-08-30 12:00:00');

-- Scenario 3: High-value luxury booking
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, price_per_night_at_booking, total_price, status, created_at) VALUES
('880e8400-e29b-41d4-a716-446655440014', '770e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440014',
 '2025-12-25', '2026-01-02', 580.00, 4640.00, 'pending', '2025-08-25 10:30:00');

INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method, payment_status, transaction_id, created_at) VALUES
('990e8400-e29b-41d4-a716-446655440014', '880e8400-e29b-41d4-a716-446655440014', 4640.00, '2025-08-25 10:35:00', 'credit_card', 'pending', 'stripe_txn_holiday_2025', '2025-08-25 10:35:00');

-- ============================================================================
-- 14. UPDATE PLACEHOLDER REVIEW BOOKING IDs
-- ============================================================================

-- Update reviews with correct booking IDs
UPDATE Review SET booking_id = '880e8400-e29b-41d4-a716-446655440011' WHERE review_id = 'aa0e8400-e29b-41d4-a716-446655440006';
UPDATE Review SET booking_id = '880e8400-e29b-41d4-a716-446655440011' WHERE review_id = 'aa0e8400-e29b-41d4-a716-446655440007';
UPDATE Review SET booking_id = '880e8400-e29b-41d4-a716-446655440012' WHERE review_id = 'aa0e8400-e29b-41d4-a716-446655440008';
UPDATE Review SET booking_id = '880e8400-e29b-41d4-a716-446655440013' WHERE review_id = 'aa0e8400-e29b-41d4-a716-446655440012';
UPDATE Review SET booking_id = '880e8400-e29b-41d4-a716-446655440012' WHERE review_id = 'aa0e8400-e29b-41d4-a716-446655440013';

-- ============================================================================
-- 15. FINAL VERIFICATION QUERIES
-- ============================================================================

SELECT '=== FINAL DATA VERIFICATION ===' AS Status;

-- Verify all tables have data
SELECT 
    table_name,
    table_rows
FROM information_schema.tables 
WHERE table_schema = 'airbnb_db' 
AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Check data relationships
SELECT 'Properties per Host:' AS Metric, host_id, COUNT(*) AS Count
FROM Property 
GROUP BY host_id
ORDER BY Count DESC;

SELECT 'Bookings per Status:' AS Metric, status, COUNT(*) AS Count
FROM Booking
GROUP BY status;

SELECT 'Payments per Method:' AS Metric, payment_method, COUNT(*) AS Count
FROM Payment
