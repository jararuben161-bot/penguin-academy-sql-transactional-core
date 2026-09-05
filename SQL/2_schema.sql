CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    phone VARCHAR (25) NOT NULL,
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
