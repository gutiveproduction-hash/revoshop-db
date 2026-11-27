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
