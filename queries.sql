-- =====================================================================
-- RevoShop example queries (Checkpoint 1)
-- Run AFTER schema.sql and seed.sql.
-- Clause order: SELECT ... FROM ... WHERE ... ORDER BY ... LIMIT
-- =====================================================================

-- 1. The 5 cheapest products that are in stock and still on sale.
--    Combines WHERE + ORDER BY + LIMIT.
SELECT id, name, price, stock_quantity
FROM products
WHERE stock_quantity > 0
  AND is_active = TRUE
ORDER BY price ASC
LIMIT 5;

-- 2. The 3 most expensive electronics (category_id 1).
SELECT id, name, price
FROM products
WHERE category_id = 1
ORDER BY price DESC
LIMIT 3;

-- 3. The 5 most recent orders that are not cancelled.
SELECT id, user_id, status, total_amount, ordered_at
FROM orders
WHERE status <> 'cancelled'
ORDER BY ordered_at DESC
LIMIT 5;

-- 4. Products that need restocking (fewer than 30 units), lowest stock first.
SELECT id, name, stock_quantity
FROM products
WHERE stock_quantity < 30
ORDER BY stock_quantity ASC, name ASC
LIMIT 10;

-- 5. Open orders (pending or paid), largest first.
SELECT id, user_id, status, total_amount
FROM orders
WHERE status IN ('pending', 'paid')
ORDER BY total_amount DESC
LIMIT 5;

-- 6. Sanity check: row count per table.
SELECT 'users' AS table_name, COUNT(*) AS total_rows FROM users
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'products',   COUNT(*) FROM products
UNION ALL SELECT 'orders',     COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;
