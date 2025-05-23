-- E-Commerce Project Analysis

-- Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders AS o;

-- Orders by Brazilian State
SELECT customer_state, COUNT(*) AS orders
FROM customers
GROUP BY customer_state
ORDER BY orders DESC;

-- Number of orders placed each day
SELECT o.order_purchase_timestamp::date, COUNT(*) AS order_count
FROM orders AS o
GROUP BY o.order_purchase_timestamp::date
ORDER BY o.order_purchase_timestamp::date;

-- What were the most popular days?
SELECT o.order_purchase_timestamp::date, COUNT(*) AS order_count
FROM orders AS o
GROUP BY o.order_purchase_timestamp::date
ORDER BY order_count DESC;
-- Research showed 24th of November 2017 was a 'Black Friday'. That explains the spike in the number of orders

-- What product categories have had the most number of products ordered?
SELECT ct.product_category_name_english AS product_category_english, COUNT(oi.order_id) AS number_of_orders
FROM products AS p
JOIN order_items AS oi
ON p.product_id = oi.product_id
JOIN category_translation AS ct
ON p.product_category_name = ct.product_category_name
GROUP BY p.product_category_name, product_category_english
ORDER BY number_of_orders DESC;

-- Estimated delivery date vs Actual Delivery date
SELECT o.order_id, o.order_purchase_timestamp, 
o.order_delivered_customer_date::timestamp, 
o.order_estimated_delivery_date::timestamp, 
o.order_estimated_delivery_date::timestamp - o.order_delivered_customer_date::timestamp AS days_difference
FROM orders AS o
WHERE o.order_status = 'delivered';

-- Average delivery days difference by year and month
SELECT
	date_part('year', o.order_purchase_timestamp)::int AS order_year,
	date_part('month', o.order_purchase_timestamp)::int AS order_month,
	justify_interval(AVG(o.order_estimated_delivery_date::timestamp - o.order_delivered_customer_date::timestamp ))AS avg_days_difference
FROM orders AS o
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date <> ''
GROUP BY order_year, order_month;

-- Payment Type Distribution
SELECT op.payment_type, COUNT(*) AS payment_type_count, ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM order_payments AS op
GROUP BY op.payment_type
ORDER BY payment_type_count;

-- Average Review Score by Product Category
SELECT ct.product_category_name_english, ROUND(AVG(or2.review_score), 2) AS avg_review
FROM order_reviews or2
JOIN orders o ON or2.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation ct ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY avg_review DESC;

-- Total Spending Per Customer
SELECT c.customer_unique_id, ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC;

-- Review Score Distribution
SELECT or2.review_score, COUNT(*) AS score_count
FROM order_reviews AS or2
GROUP BY review_score
ORDER BY review_score;

-- Sellers with the highest number of orders
SELECT s.seller_id, COUNT(DISTINCT oi.order_id) AS total_orders
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY total_orders DESC;

-- Freight Cost vs Product Price (average by category)
-- To compare how much customers are paying for freight (shipping) versus the actual product price, on average, for each product category.
SELECT ct.product_category_name_english, ROUND(AVG(oi.price)::numeric, 2) AS avg_price, ROUND(AVG(oi.freight_value)::numeric, 2) AS avg_freight
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation ct ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY avg_freight DESC;
