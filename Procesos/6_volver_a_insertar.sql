INSERT INTO customers (customer_id, full_name, email, phone, city, segment, created_at, is_active, deleted_at)
SELECT customer_id::INTEGER, TRIM(full_name), TRIM(email), TRIM(phone), TRIM(city), TRIM(segment),
    created_at::TIMESTAMP, CASE WHEN is_active = '1' THEN TRUE ELSE FALSE END, NULLIF(TRIM(deleted_at), '')::TIMESTAMP
FROM staging_customers;

INSERT INTO products (product_id, sku, product_name, category, brand, unit_price, unit_cost, created_at, is_active, deleted_at)
SELECT product_id::INTEGER, TRIM(sku), TRIM(product_name), TRIM(category), TRIM(brand),
    unit_price::NUMERIC(12,2), unit_cost::NUMERIC(12,2), created_at::TIMESTAMP,
    CASE WHEN is_active = '1' THEN TRUE ELSE FALSE END, NULLIF(TRIM(deleted_at), '')::TIMESTAMP
FROM staging_products;

INSERT INTO orders (order_id, customer_id, order_datetime, channel, currency, current_status, is_active, deleted_at, order_total)
SELECT order_id::INTEGER, customer_id::INTEGER, order_datetime::TIMESTAMP, TRIM(channel), TRIM(currency), TRIM(current_status),
    CASE WHEN is_active = '1' THEN TRUE ELSE FALSE END, NULLIF(TRIM(deleted_at), '')::TIMESTAMP, order_total::NUMERIC(12,2)
FROM staging_orders;

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount_rate, line_total)
SELECT order_item_id::INTEGER, order_id::INTEGER, product_id::INTEGER, quantity::INTEGER,
    unit_price::NUMERIC(12,2), discount_rate::NUMERIC(5,4), line_total::NUMERIC(12,2)
FROM staging_order_items;

INSERT INTO payments (payment_id, order_id, payment_datetime, method, payment_status, amount, currency)
SELECT payment_id::INTEGER, order_id::INTEGER, payment_datetime::TIMESTAMP, TRIM(method), TRIM(payment_status),
    amount::NUMERIC(12,2), TRIM(currency)
FROM staging_payments;

INSERT INTO order_status_history (status_history_id, order_id, status, changed_at, changed_by, reason)
SELECT status_history_id::INTEGER, order_id::INTEGER, TRIM(status), changed_at::TIMESTAMP, TRIM(changed_by), NULLIF(TRIM(reason), '')
FROM staging_order_status_history;

INSERT INTO order_audit (audit_id, order_id, field_name, old_value, new_value, changed_at, changed_by)
SELECT audit_id::INTEGER, order_id::INTEGER, TRIM(field_name), NULLIF(TRIM(old_value), ''), NULLIF(TRIM(new_value), ''),
    changed_at::TIMESTAMP, TRIM(changed_by)
FROM staging_order_audit;

-- Verificacion final
SELECT 'customers' AS tabla, COUNT(*) AS filas FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'order_status_history', COUNT(*) FROM order_status_history
UNION ALL SELECT 'order_audit', COUNT(*) FROM order_audit;