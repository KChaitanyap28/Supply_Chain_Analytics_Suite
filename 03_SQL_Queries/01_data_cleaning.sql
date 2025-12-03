-- 1. Fix Dates in the 'orders' table
-- Pandas loaded these as text. We need them as TIMESTAMP to do math.
ALTER TABLE orders
ALTER COLUMN order_purchase_timestamp TYPE TIMESTAMP USING order_purchase_timestamp::TIMESTAMP,
ALTER COLUMN order_approved_at TYPE TIMESTAMP USING order_approved_at::TIMESTAMP,
ALTER COLUMN order_delivered_carrier_date TYPE TIMESTAMP USING order_delivered_carrier_date::TIMESTAMP,
ALTER COLUMN order_delivered_customer_date TYPE TIMESTAMP USING order_delivered_customer_date::TIMESTAMP,
ALTER COLUMN order_estimated_delivery_date TYPE TIMESTAMP USING order_estimated_delivery_date::TIMESTAMP;

-- 2. Drop rows where delivery date is null (Cancelled/Undelivered orders)
-- This ensures our analysis only looks at completed transactions
DELETE FROM orders 
WHERE order_delivered_customer_date IS NULL;

-- 3. Check for duplicates in the Payments table
-- (Good practice to verify Primary Keys)
SELECT order_id, payment_sequential, COUNT(*)
FROM payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

-- 4. Create a master view for easy analysis
-- Instead of joining 5 tables every time, we create a 'Virtual Table' (View)
CREATE OR REPLACE VIEW distinct_order_items AS
SELECT 
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    o.customer_id,
    o.order_purchase_timestamp,
    p.product_category_name,
    c.customer_state
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id;