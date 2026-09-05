CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    phone VARCHAR(25) NOT NULL,
    city VARCHAR(100) NOT NULL,
    segment VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    is_active BOOLEAN NOT NULL,
    deleted_at TIMESTAMP
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    sku VARCHAR(50) NOT NULL UNIQUE,
    product_name VARCHAR(200) NOT NULL,
    category VARCHAR(50) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    unit_price NUMERIC(12,2) NOT NULL,
    unit_cost NUMERIC(12,2) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    is_active BOOLEAN NOT NULL,
    deleted_at TIMESTAMP
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_datetime TIMESTAMP NOT NULL,
    channel VARCHAR(20) NOT NULL,
    currency VARCHAR(10) NOT NULL,
    current_status VARCHAR(20) NOT NULL,
    is_active BOOLEAN NOT NULL,
    deleted_at TIMESTAMP,
    order_total NUMERIC(12,2) NOT NULL,
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(12,2) NOT NULL,
    discount_rate NUMERIC(5,4) NOT NULL,
    line_total NUMERIC(12,2) NOT NULL,
    CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    payment_datetime TIMESTAMP NOT NULL,
    method VARCHAR(20) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    currency VARCHAR(10) NOT NULL,
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE order_status_history (
    status_history_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    status VARCHAR(20) NOT NULL,
    changed_at TIMESTAMP NOT NULL,
    changed_by VARCHAR(30) NOT NULL,
    reason VARCHAR(30),
    CONSTRAINT fk_status_history_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE order_audit (
    audit_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    field_name VARCHAR(50) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    changed_at TIMESTAMP NOT NULL,
    changed_by VARCHAR(30) NOT NULL,
    CONSTRAINT fk_audit_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Reglas de valores validos (CHECK)
ALTER TABLE products ADD CONSTRAINT chk_products_price CHECK (unit_price > 0);
ALTER TABLE products ADD CONSTRAINT chk_products_cost CHECK (unit_cost > 0);
ALTER TABLE orders ADD CONSTRAINT chk_orders_total CHECK (order_total >= 0);
ALTER TABLE order_items ADD CONSTRAINT chk_items_quantity CHECK (quantity > 0);
ALTER TABLE order_items ADD CONSTRAINT chk_items_price CHECK (unit_price > 0);
ALTER TABLE order_items ADD CONSTRAINT chk_items_discount CHECK (discount_rate >= 0 AND discount_rate <= 0.25);
ALTER TABLE order_items ADD CONSTRAINT chk_items_total CHECK (line_total >= 0);
ALTER TABLE payments ADD CONSTRAINT chk_payments_amount CHECK (amount >= 0);

-- Indices sobre las relaciones (FOREIGN KEY)
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_items_order_id ON order_items(order_id);
CREATE INDEX idx_items_product_id ON order_items(product_id);
CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_status_history_order_id ON order_status_history(order_id);