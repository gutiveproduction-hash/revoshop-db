-- =====================================================================
-- RevoShop sample data (Checkpoint 1)
-- Run AFTER schema.sql. Safe to re-run: it empties the tables first and
-- restarts the id counters so that the ids used below always match.
-- Password hashes are dummy placeholders, not real credentials.
-- =====================================================================

TRUNCATE order_items, orders, products, categories, users RESTART IDENTITY CASCADE;

-- ---------------------------------------------------------------------
-- users (8)
-- ---------------------------------------------------------------------
INSERT INTO users (full_name, email, password_hash, phone_number, is_active, created_at) VALUES
('Budi Santoso',   'budi.santoso@example.com',   '$2b$12$dummyhash.budi.santoso.0000000000000000000000000001', '081234567801', TRUE,  '2026-01-15 09:00:00'),
('Siti Rahayu',    'siti.rahayu@example.com',    '$2b$12$dummyhash.siti.rahayu.00000000000000000000000000002', '081234567802', TRUE,  '2026-02-03 14:20:00'),
('Agus Wijaya',    'agus.wijaya@example.com',    '$2b$12$dummyhash.agus.wijaya.00000000000000000000000000003', '081234567803', TRUE,  '2026-02-18 10:45:00'),
('Dewi Lestari',   'dewi.lestari@example.com',   '$2b$12$dummyhash.dewi.lestari.0000000000000000000000000004', '081234567804', TRUE,  '2026-03-07 16:10:00'),
('Rizky Pratama',  'rizky.pratama@example.com',  '$2b$12$dummyhash.rizky.pratama.000000000000000000000000005', '081234567805', TRUE,  '2026-04-21 08:30:00'),
('Maya Anggraini', 'maya.anggraini@example.com', '$2b$12$dummyhash.maya.anggraini.00000000000000000000000006', NULL,           TRUE,  '2026-05-12 19:05:00'),
('Hendra Kusuma',  'hendra.kusuma@example.com',  '$2b$12$dummyhash.hendra.kusuma.000000000000000000000000007', '081234567807', FALSE, '2026-06-30 11:15:00'),
('Putri Ayu',      'putri.ayu@example.com',      '$2b$12$dummyhash.putri.ayu.00000000000000000000000000000008', '081234567808', TRUE,  '2026-09-09 13:40:00');

-- ---------------------------------------------------------------------
-- categories (5)
-- ---------------------------------------------------------------------
INSERT INTO categories (name, description) VALUES
('Electronics',        'Gadgets, computer accessories and audio equipment'),
('Fashion',            'Clothing and everyday wear for men and women'),
('Books',              'Fiction, non-fiction and technical books'),
('Home & Kitchen',     'Cookware, appliances and home essentials'),
('Sports & Outdoors',  'Sports gear, footwear and fitness equipment');

-- ---------------------------------------------------------------------
-- products (15) - category_id: 1 Electronics, 2 Fashion, 3 Books,
--                              4 Home & Kitchen, 5 Sports & Outdoors
-- ---------------------------------------------------------------------
INSERT INTO products (category_id, name, description, price, stock_quantity, is_active) VALUES
(1, 'Logitech M331 Silent Wireless Mouse',       'Quiet-click wireless mouse, 24-month battery life',          285000.00, 120, TRUE),
(1, 'Keychron K2 Mechanical Keyboard',           'Compact 75% wireless mechanical keyboard, brown switches',  1350000.00,  45, TRUE),
(1, 'Sony WH-CH720N Noise Cancelling Headphones','Wireless over-ear headphones with active noise cancelling',  1899000.00,  30, TRUE),
(1, 'USB-C Hub 7-in-1',                          'HDMI, SD card reader, 3x USB-A and USB-C power delivery',     349000.00,  80, TRUE),
(2, 'Kemeja Flanel Pria Kotak-Kotak',            'Long-sleeve plaid flannel shirt, cotton blend',               189000.00,  60, TRUE),
(2, 'Jaket Hoodie Unisex',                       'Fleece-lined pullover hoodie with kangaroo pocket',           249000.00,  75, TRUE),
(5, 'Nike Revolution 6 Running Shoes',           'Lightweight everyday running shoes',                          899000.00,  40, TRUE),
(3, 'Atomic Habits (Edisi Bahasa Indonesia)',    'Cara mudah dan terbukti untuk membentuk kebiasaan baik',       98000.00, 150, TRUE),
(3, 'Laskar Pelangi',                            'Novel karya Andrea Hirata',                                    85000.00, 200, TRUE),
(3, 'Clean Code',                                'A Handbook of Agile Software Craftsmanship',                  420000.00,  25, TRUE),
(4, 'Philips Rice Cooker 1.8L',                  'Digital rice cooker with 8 cooking programs',                 750000.00,  35, TRUE),
(4, 'Set Panci Stainless Steel 5 Pcs',           'Five-piece stainless steel cookware set with glass lids',     560000.00,  20, TRUE),
(5, 'Matras Yoga Anti-Slip 8mm',                 'Non-slip TPE yoga mat with carrying strap',                   175000.00,  90, TRUE),
(5, 'Dumbbell Adjustable 10kg',                  'Adjustable dumbbell with 4 weight plates',                    450000.00,  15, TRUE),
(4, 'Lampu Meja LED Dimmable',                   'Desk lamp with 3 colour temperatures (currently sold out)',   129000.00,   0, TRUE);

-- ---------------------------------------------------------------------
-- orders (10) - total_amount equals the sum of its order_items below
-- ---------------------------------------------------------------------
INSERT INTO orders (user_id, status, total_amount, shipping_address, ordered_at) VALUES
(1, 'delivered',  481000.00, 'Jl. Merdeka No. 12, Bandung, Jawa Barat',          '2026-10-02 10:15:00'),
(2, 'delivered',  627000.00, 'Jl. Sudirman Kav. 5, Jakarta Selatan',             '2026-10-05 14:30:00'),
(3, 'shipped',   1699000.00, 'Jl. Pemuda No. 88, Semarang, Jawa Tengah',         '2026-10-18 09:05:00'),
(4, 'delivered',  750000.00, 'Jl. Malioboro No. 3, Yogyakarta',                  '2026-10-21 16:45:00'),
(5, 'pending',   1074000.00, 'Jl. Diponegoro No. 21, Surabaya, Jawa Timur',      '2026-11-03 11:20:00'),
(1, 'shipped',   1899000.00, 'Jl. Merdeka No. 12, Bandung, Jawa Barat',          '2026-11-08 20:10:00'),
(6, 'delivered',  675000.00, 'Jl. Gatot Subroto No. 40, Medan, Sumatera Utara',  '2026-11-10 13:00:00'),
(7, 'cancelled',  900000.00, 'Jl. Ahmad Yani No. 7, Malang, Jawa Timur',         '2026-11-12 08:50:00'),
(2, 'paid',       818000.00, 'Jl. Sudirman Kav. 5, Jakarta Selatan',             '2026-11-19 15:25:00'),
(8, 'pending',    533000.00, 'Jl. Thamrin No. 15, Jakarta Pusat',                '2026-11-25 18:35:00');

-- ---------------------------------------------------------------------
-- order_items (18) - unit_price is the price at the time of purchase
-- ---------------------------------------------------------------------
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1,  1, 1,  285000.00),   -- Budi: mouse
(1,  8, 2,   98000.00),   -- Budi: 2x Atomic Habits
(2,  6, 1,  249000.00),   -- Siti: hoodie
(2,  5, 2,  189000.00),   -- Siti: 2x flannel shirt
(3,  2, 1, 1350000.00),   -- Agus: keyboard
(3,  4, 1,  349000.00),   -- Agus: USB-C hub
(4, 11, 1,  750000.00),   -- Dewi: rice cooker
(5,  7, 1,  899000.00),   -- Rizky: running shoes
(5, 13, 1,  175000.00),   -- Rizky: yoga mat
(6,  3, 1, 1899000.00),   -- Budi: headphones
(7,  9, 3,   85000.00),   -- Maya: 3x Laskar Pelangi
(7, 10, 1,  420000.00),   -- Maya: Clean Code
(8, 14, 2,  450000.00),   -- Hendra: 2x dumbbell (order cancelled)
(9, 12, 1,  560000.00),   -- Siti: cookware set
(9, 15, 2,  129000.00),   -- Siti: 2x desk lamp
(10, 8, 1,   98000.00),   -- Putri: Atomic Habits
(10, 9, 1,   85000.00),   -- Putri: Laskar Pelangi
(10,13, 2,  175000.00);   -- Putri: 2x yoga mat
