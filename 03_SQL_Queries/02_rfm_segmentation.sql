-- STEP 1: Calculate the Metrics for each customer
WITH rfm_base AS (
    SELECT 
        customer_unique_id,
        -- Recency: Days since last order
        -- We use '2018-09-01' as the reference date because the dataset ends in Aug 2018
        ('2018-09-01'::DATE - MAX(order_purchase_timestamp)::DATE) as recency_days,
        
        -- Frequency: Total count of orders
        COUNT(DISTINCT order_id) as frequency,
        
        -- Monetary: Total spend
        SUM(payment_value) as monetary
    FROM (
        SELECT 
            c.customer_unique_id, 
            o.order_id, 
            o.order_purchase_timestamp, 
            p.payment_value
        FROM orders o
        JOIN customers c ON o.customer_id = c.customer_id
        JOIN payments p ON o.order_id = p.order_id
        WHERE o.order_status = 'delivered'
    ) sub
    GROUP BY customer_unique_id
),

-- STEP 2: Score the customers from 1 to 5 using NTILE (Window Function)
rfm_scored AS (
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) as r_score, -- 5 is worst (oldest), 1 is best (newest) logic inverted later
        NTILE(5) OVER (ORDER BY frequency ASC) as f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) as m_score
    FROM rfm_base
)

-- STEP 3: Create the Final Table for Power BI
-- We cast r_score to flip it so 5 becomes "Best" (Recent) and 1 becomes "Worst"
SELECT 
    customer_unique_id,
    recency_days,
    frequency,
    monetary,
    (6 - r_score) as r_score, -- Flip so 5 is recent
    f_score,
    m_score,
    (6 - r_score)::text || f_score::text || m_score::text as rfm_cell,
    CASE 
        WHEN (6 - r_score) >= 5 AND f_score >= 5 AND m_score >= 5 THEN 'Champions'
        WHEN (6 - r_score) >= 4 AND f_score >= 4 THEN 'Loyal'
        WHEN (6 - r_score) <= 2 AND f_score >= 4 THEN 'At Risk'
        WHEN (6 - r_score) <= 2 AND f_score <= 2 THEN 'Hibernating'
        ELSE 'Potential' 
    END as customer_segment
INTO rfm_analysis -- <--- This creates a physical table in the database
FROM rfm_scored;