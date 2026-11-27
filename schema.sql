-- =====================================================================
-- RevoShop database schema (Checkpoint 1)
-- Target: PostgreSQL 16, database: revoshop_db
--
-- Conventions
--   * snake_case for every table and column name
--   * plural table names, primary key column is always "id"
--   * foreign keys are named <referenced_table_singular>_id (user_id)
--   * constraints are named: pk_ / fk_ / uq_ / ck_ + table + column
-- =====================================================================

-- Drop in child-to-parent order so the script can be re-run safely.
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders      CASCADE;
DROP TABLE IF EXISTS products    CASCADE;
DROP TABLE IF EXISTS categories  CASCADE;
DROP TABLE IF EXISTS users       CASCADE;

-- ---------------------------------------------------------------------
-- users: account records (no role column yet; added in Checkpoint 2)
-- ---------------------------------------------------------------------
CREATE TABLE users (
    id            SERIAL,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number  VARCHAR(20),
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP    NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_users       PRIMARY KEY (id),
    CONSTRAINT uq_users_email UNIQUE (email)
);

-- ---------------------------------------------------------------------
-- categories: product categories
-- ---------------------------------------------------------------------
CREATE TABLE categories (
    id          SERIAL,
    name        VARCHAR(100) NOT NULL,
    description TEXT,
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_categories      PRIMARY KEY (id),
    CONSTRAINT uq_categories_name UNIQUE (name)
);

-- ---------------------------------------------------------------------
-- products: store items, each linked to one category
-- ---------------------------------------------------------------------
CREATE TABLE products (
    id             SERIAL,
    category_id    INTEGER,
    name           VARCHAR(200)  NOT NULL,
    description    TEXT,
    price          NUMERIC(12,2) NOT NULL,
    stock_quantity INTEGER       NOT NULL DEFAULT 0,
    is_active      BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMP     NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_products          PRIMARY KEY (id),
    -- A product may be kept (uncategorised) if its category is removed.
    CONSTRAINT fk_products_category FOREIGN KEY (category_id)
        REFERENCES categories (id) ON DELETE SET NULL,
    CONSTRAINT ck_products_price    CHECK (price > 0),
    CONSTRAINT ck_products_stock    CHECK (stock_quantity >= 0)
);

-- PostgreSQL does not index foreign keys automatically.
CREATE INDEX idx_products_category_id ON products (category_id);

-- ---------------------------------------------------------------------
-- orders: placed by a user
-- ---------------------------------------------------------------------
CREATE TABLE orders (
    id               SERIAL,
    user_id          INTEGER       NOT NULL,
    status           VARCHAR(20)   NOT NULL DEFAULT 'pending',
    total_amount     NUMERIC(12,2) NOT NULL,
    shipping_address TEXT          NOT NULL,
    ordered_at       TIMESTAMP     NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_orders        PRIMARY KEY (id),
    -- Order history must survive: a user with orders cannot be deleted.
    CONSTRAINT fk_orders_user   FOREIGN KEY (user_id)
        REFERENCES users (id) ON DELETE RESTRICT,
    CONSTRAINT ck_orders_status CHECK (status IN
        ('pending', 'paid', 'shipped', 'delivered', 'cancelled')),
    CONSTRAINT ck_orders_total  CHECK (total_amount >= 0)
);

CREATE INDEX idx_orders_user_id ON orders (user_id);

-- ---------------------------------------------------------------------
-- order_items: junction table (many-to-many between orders and products)
-- unit_price stores the price at purchase time, so history never changes.
-- ---------------------------------------------------------------------
CREATE TABLE order_items (
    id         SERIAL,
    order_id   INTEGER       NOT NULL,
    product_id INTEGER       NOT NULL,
    quantity   INTEGER       NOT NULL,
    unit_price NUMERIC(12,2) NOT NULL,

    CONSTRAINT pk_order_items         PRIMARY KEY (id),
    -- Items disappear together with their order.
    CONSTRAINT fk_order_items_order   FOREIGN KEY (order_id)
        REFERENCES orders (id) ON DELETE CASCADE,
    -- A product that was ever ordered cannot be deleted.
    CONSTRAINT fk_order_items_product FOREIGN KEY (product_id)
        REFERENCES products (id) ON DELETE RESTRICT,
    -- The same product appears at most once per order (change quantity instead).
    CONSTRAINT uq_order_items_order_product UNIQUE (order_id, product_id),
    CONSTRAINT ck_order_items_quantity   CHECK (quantity > 0),
    CONSTRAINT ck_order_items_unit_price CHECK (unit_price > 0)
);

CREATE INDEX idx_order_items_order_id   ON order_items (order_id);
CREATE INDEX idx_order_items_product_id ON order_items (product_id);
