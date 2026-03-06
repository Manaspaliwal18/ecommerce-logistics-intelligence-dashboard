/*
================================================================================
PROJECT: Olist E-Commerce Logistics Analysis
AUTHOR:  [Your Name]
DATE:    December 2025
PURPOSE: This script analyzes delivery performance and seller reliability 
         to identify bottlenecks and improve customer satisfaction.
================================================================================
*/

-- -----------------------------------------------------------------------------
-- 1. GEOGRAPHIC PERFORMANCE ANALYSIS
-- -----------------------------------------------------------------------------
-- Goal: Identify states with the highest average delivery delays to prioritize 
-- regional distribution hub placement.
SELECT 
    customer_state, 
    COUNT(order_id) AS total_orders,
    ROUND(AVG(actual_wait_time), 2) AS avg_delivery_days,
    ROUND(AVG(delay_days), 2) AS avg_delay_vs_estimate
FROM delivery_performance
GROUP BY customer_state
HAVING total_orders > 100
ORDER BY avg_delay_vs_estimate DESC;


-- -----------------------------------------------------------------------------
-- 2. SELLER RELIABILITY AUDIT
-- -----------------------------------------------------------------------------
-- Goal: Identify the top 10 sellers with a high volume of orders (>50) 
-- that have a late delivery rate exceeding 15%.
SELECT 
    seller_id, 
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN is_late = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id) AS late_rate_pct
FROM delivery_performance
GROUP BY seller_id
HAVING total_orders > 50
ORDER BY late_rate_pct DESC
LIMIT 10;


-- -----------------------------------------------------------------------------
-- 3. LOGISTICS TRENDS OVER TIME
-- -----------------------------------------------------------------------------
-- Goal: Analyze if the delivery gap (actual vs estimate) is improving 
-- month-over-month.
SELECT 
    strftime('%Y-%m', order_purchase_timestamp) AS purchase_month,
    ROUND(AVG(actual_wait_time), 2) AS avg_wait,
    ROUND(AVG(delay_days), 2) AS avg_delay_offset
FROM delivery_performance
GROUP BY purchase_month
ORDER BY purchase_month;