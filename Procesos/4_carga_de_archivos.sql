///Carga masiva de los CSV a las tablas de staging.///
///Nota: se cargo en la practica con la herramienta "Import/Export Data" de pgAdmin,///
///porque el comando COPY necesita que el proceso del servidor tenga permiso de///
///lectura sobre la carpeta, y en Windows eso falla si el archivo esta en la carpeta///
///personal del usuario. Se documenta el comando equivalente.///

COPY staging_customers (customer_id, full_name, email, phone, city, segment, created_at, is_active, deleted_at)
FROM 'C:/Users/ruben/OneDrive/Escritorio/challenges/challenger_5/data/customers.csv' WITH CSV HEADER DELIMITER ',';

COPY staging_products (product_id, sku, product_name, category, brand, unit_price, unit_cost, created_at, is_active, deleted_at)
FROM 'C:/Users/ruben/OneDrive/Escritorio/challenges/challenger_5/data/products.csv' WITH CSV HEADER DELIMITER ',';

COPY staging_orders (order_id, customer_id, order_datetime, channel, currency, current_status, is_active, deleted_at, order_total)
FROM 'C:/Users/ruben/OneDrive/Escritorio/challenges/challenger_5/data/orders.csv' WITH CSV HEADER DELIMITER ',';

COPY staging_order_items (order_item_id, order_id, product_id, quantity, unit_price, discount_rate, line_total)
FROM 'C:/Users/ruben/OneDrive/Escritorio/challenges/challenger_5/data/order_items.csv' WITH CSV HEADER DELIMITER ',';

COPY staging_payments (payment_id, order_id, payment_datetime, method, payment_status, amount, currency)
FROM 'C:/Users/ruben/OneDrive/Escritorio/challenges/challenger_5/data/payments.csv' WITH CSV HEADER DELIMITER ',';

COPY staging_order_status_history (status_history_id, order_id, status, changed_at, changed_by, reason)
FROM 'C:/Users/ruben/OneDrive/Escritorio/challenges/challenger_5/data/order_status_history.csv' WITH CSV HEADER DELIMITER ',';

COPY staging_order_audit (audit_id, order_id, field_name, old_value, new_value, changed_at, changed_by)
FROM 'C:/Users/ruben/OneDrive/Escritorio/challenges/challenger_5/data/order_audit.csv' WITH CSV HEADER DELIMITER ',';

Verificacion de filas cargadas
SELECT 'customers' AS tabla, COUNT(*) AS filas FROM staging_customers
UNION ALL SELECT 'products', COUNT(*) FROM staging_products
UNION ALL SELECT 'orders', COUNT(*) FROM staging_orders
UNION ALL SELECT 'order_items', COUNT(*) FROM staging_order_items
UNION ALL SELECT 'payments', COUNT(*) FROM staging_payments
UNION ALL SELECT 'order_status_history', COUNT(*) FROM staging_order_status_history
UNION ALL SELECT 'order_audit', COUNT(*) FROM staging_order_audit;