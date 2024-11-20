-- Zomato Data Analysis

-- Importing Dataset
SELECT * FROM customers;
SELECT * FROM restaurants;

ALTER TABLE restaurants
ALTER COLUMN restaurant_name TYPE VARCHAR(50);

SELECT * FROM riders;
SELECT * FROM orders;
SELECT * FROM deliveries;

-- Null Values Check

SELECT * FROM customers
WHERE customer_id IS NULL;

-- Key Performance Indicators

-- 1. Revenue Contribution of top 5 dishes

-- Total revenue calculation
WITH total_revenue AS (
	SELECT SUM(total_amount) AS total_revenue
	FROM orders
	WHERE order_date >= CURRENT_DATE - INTERVAL '1 year'
),	
-- Revenue from top 5 dishes
top_dishes_revenue AS (
 	SELECT SUM(total_amount) AS top_5_revenue
	 FROM (
    	SELECT order_item,
       	 SUM(total_amount) AS total_amount
   		FROM orders
		WHERE order_date >= CURRENT_DATE - INTERVAL '1 year'
   		GROUP BY 1
    	ORDER BY total_amount DESC 
    	LIMIT 5
	) AS top_orders
)	
-- Percentage distribution
SELECT 
	top_5_revenue,
	total_revenue,
	ROUND((top_5_revenue::decimal/total_revenue::decimal * 100),2) AS top_revenue_percent
FROM top_dishes_revenue, total_revenue;


-- 2. Top dishes ordered by different customer segments- Frequent and Infrequent

-- Method: using quartiles

-- Count of total orders for each customer
WITH order_counts AS (
	SELECT 
		customer_id,                   
 		COUNT(order_id) AS total_orders 
	FROM orders
	GROUP BY 1                       
), 

-- Segment customers into quartiles based on their total orders
customer_segmentation AS (
	SELECT 
		customer_id,                 
		total_orders,                 
		NTILE(4) OVER (ORDER BY total_orders) AS quartile_rank -- Divides customers into 4 equal groups based on order frequency
	FROM order_counts
), 

-- Customer segmentation (Frequent or Infrequent) based on quartile ranks
segmented_customers AS (
	SELECT 
		customer_id,                
		total_orders,               
		CASE 
			WHEN quartile_rank IN (1,2) THEN 'Infrequent'  -- Bottom 50% customers
			WHEN quartile_rank IN (3,4) THEN 'Frequent'   -- Top 50% customers
		END AS customer_segment    
	FROM customer_segmentation
	ORDER BY total_orders DESC   
), 

-- Ranked dishes ordered by each customer segment
ranked_dish AS (
	SELECT
		sc.customer_segment,     
		o.order_item,              
		COUNT(o.order_id) AS dish_count, 
		RANK() OVER(PARTITION BY customer_segment ORDER BY COUNT(o.order_id) DESC) AS ranking 
	FROM orders o 
	JOIN segmented_customers sc 
		ON o.customer_id = sc.customer_id 
	GROUP BY 1, 2                    
	ORDER BY 1, 3 DESC            
)

-- Top 5 dishes for each customer segment
SELECT 
	customer_segment,  
	order_item         
FROM ranked_dish
WHERE ranking <= 5;     


-- 3. High Value Customer Idenitfication - High Value and Regular

-- Customer data with total revenue and order frequency
WITH customer_summary AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_revenue, 
        COUNT(order_id) AS order_frequency  
    FROM orders
    GROUP BY 1
),

-- 75th percentile of total revenue to determine high-value threshold
revenue_threshold AS (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY total_revenue) AS high_revenue_threshold
    FROM customer_summary
),

-- 75th percentile of order frequency to determine high-frequency threshold
frequency_threshold AS (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY order_frequency) AS high_freq_threshold
    FROM customer_summary 
)

-- Segment customers based on thresholds for revenue and frequency
SELECT 
    cs.customer_id,
    cs.total_revenue,               
    cs.order_frequency,            
    CASE 
        WHEN cs.total_revenue >= rt.high_revenue_threshold 
            AND cs.order_frequency >= ft.high_freq_threshold 
            THEN 'High-Value'      -- Customers exceeding both thresholds are labeled as "High-Value"
        ELSE 'Regular'             -- All other customers are labeled as "Regular"
    END AS customer_segment
FROM customer_summary cs,
     revenue_threshold rt,
     frequency_threshold ft
ORDER BY total_revenue DESC, order_frequency DESC; 


-- 4. Top 3 dishes for each time bucket with count of total orders

-- Time slots - breakfast, lunch, dinner and Midnight Snack

-- Assign each order to a time slot (Breakfast, Lunch, Dinner, or Midnight Snack) based on order time
WITH time_slot_orders AS(
    SELECT 
        order_item,
        order_time,
        CASE
            WHEN order_time BETWEEN '06:00:00' AND '10:59:59' THEN 'Breakfast'
            WHEN order_time BETWEEN '11:00:00' AND '16:59:59' THEN 'Lunch'
            WHEN order_time BETWEEN '17:00:00' AND '22:59:59' THEN 'Dinner'
            ELSE 'Midnight Snack'
        END AS time_slot
    FROM orders
),

-- Aggregate orders by item and time slot to find total orders for each combination
aggregated_orders AS (
    SELECT 
        order_item,
        time_slot,
        COUNT(*) AS total_orders 
    FROM time_slot_orders
    GROUP BY order_item, time_slot
),

-- Ranked items within each time slot by their total orders
ranked_orders AS(
    SELECT *,
        RANK() OVER(PARTITION BY time_slot ORDER BY total_orders DESC) AS rank 
    FROM aggregated_orders
)

-- Top 3 ranked items for each time slot and include items with zero orders
SELECT 
    time_slot,
    order_item,
    COALESCE(total_orders, 0) AS total_orders, -- NULL values replaced for total orders with 0
    rank
FROM ranked_orders
WHERE rank <= 3 OR total_orders = 0; 

-- 5. Restaurants Open Late - Past 10PM

-- Restaurant data to extract and format closing times
WITH parsed_hours AS (
    SELECT 
        restaurant_id,
        restaurant_name,
        city,
        opening_hours,
        -- Extract closing time by splitting the 'opening_hours' string and removing leading/trailing spaces
        TRIM(SPLIT_PART(opening_hours, '-', 2)) AS closing_time
    FROM restaurants
),
	
-- Restaurants open past 10 PM.
late_night_restaurants AS (
    SELECT 
        restaurant_id,
        city,
        closing_time
    FROM parsed_hours
    WHERE 
        -- Convert closing_time (in "HH:MM AM/PM" format) to 24-hour time and filter restaurants that close later than 10 PM
        TO_TIMESTAMP(closing_time, 'HH12:MI AM')::time > '22:00:00'::time
)

-- Total number of late-night restaurants and the percentage by city
SELECT 
    city,
    COUNT(restaurant_id) AS open_late_count,
    ROUND((COUNT(restaurant_id) * 100.0 / (SELECT COUNT(*) FROM restaurants)), 2) AS open_late_percentage -- Calculate the percentage of late-night restaurants per city
FROM 
    late_night_restaurants 
GROUP BY 
    city
ORDER BY 
    open_late_percentage DESC; 

-- 6. Rider Efficiency 

--  Delivery processing time for each order in minutes.
WITH time_to_deliver AS (
	SELECT ord.order_id,
		delv.rider_id,
		ord.order_time,
		delv.delivery_time,
		-- Delivery process time in minutes.
        -- If the delivery time is earlier than the order time (e.g., past midnight), 1 day is added to ensure accurate calculation.
		EXTRACT(EPOCH FROM (delv.delivery_time - ord.order_time + 
		CASE WHEN delv.delivery_time < ord.order_time THEN INTERVAL '1 DAY'
			ELSE INTERVAL '0 DAY' 
		END )) / 60 AS delivery_process_time
	FROM orders ord
	JOIN deliveries delv 
		ON ord.order_id = delv.order_id
	WHERE delv.delivery_status = 'Delivered'
)

-- Average star rating based on delivery process time.
SELECT 
	rider_id,
    ROUND(AVG(CASE
            WHEN delivery_process_time < 30 THEN 5
            WHEN delivery_process_time BETWEEN 30 AND 55 THEN 4
            ELSE 3
        END),2) AS average_star_rating
FROM time_to_deliver
GROUP BY rider_id;

-- 6.1 Percentage of high-performing riders 

WITH time_to_deliver AS (
    SELECT ord.order_id,
           delv.rider_id,
           ord.order_time,
           delv.delivery_time,
           EXTRACT(EPOCH FROM (delv.delivery_time - ord.order_time + 
           CASE WHEN delv.delivery_time < ord.order_time THEN INTERVAL '1 DAY'
                ELSE INTERVAL '0 DAY' END )) / 60 AS delivery_process_time
    FROM orders ord
    JOIN deliveries delv 
        ON ord.order_id = delv.order_id
    WHERE delv.delivery_status = 'Delivered'
),
rider_ratings AS (
    SELECT 
        rider_id,
        ROUND(AVG(CASE
                    WHEN delivery_process_time < 30 THEN 5
                    WHEN delivery_process_time BETWEEN 30 AND 55 THEN 4
                    ELSE 3
                END), 2) AS average_star_rating
    FROM time_to_deliver
    GROUP BY rider_id
)
SELECT 
    (COUNT(CASE WHEN average_star_rating >= 4.2 THEN 1 END) * 100.0 / COUNT(*)) AS percentage_of_top_riders
FROM rider_ratings;


-- 7. Monthly Percentage Share of popular dishes

-- Top 5 dishes based on total orders
WITH dish_totals AS (
    SELECT 
        order_item,
        COUNT(*) AS total_orders 
    FROM orders
    GROUP BY order_item 
    ORDER BY total_orders DESC 
    LIMIT 5 
),

-- Monthly order counts for the top 5 dishes
monthly_orders AS (
    SELECT 
        order_item, 
        DATE_TRUNC('month', order_date) AS order_month, 
        COUNT(*) AS monthly_order_count 
    FROM orders
    WHERE order_item IN (SELECT order_item FROM dish_totals) 
    GROUP BY order_item, order_month 
),

-- Month-over-Month percentage change in order count for each dish
monthly_change AS (
    SELECT 
        order_item, 
        order_month, 
        monthly_order_count, 
        -- Percentage change compared to the previous month
        (monthly_order_count - LAG(monthly_order_count) OVER (PARTITION BY order_item ORDER BY order_month)) * 100.0 / 
        LAG(monthly_order_count) OVER (PARTITION BY order_item ORDER BY order_month) AS percent_change
    FROM monthly_orders
)

-- calculated results
SELECT * 
FROM monthly_change
ORDER BY order_item, order_month; 

--
WITH monthly_orders AS (
    SELECT 
        order_item,
        DATE_TRUNC('month', order_date) AS order_month,  
        COUNT(*) AS total_orders
    FROM orders
    WHERE order_date >= NOW() - INTERVAL '1 year'
    GROUP BY order_item, order_month
),
monthly_totals AS (
    SELECT 
        order_month,
        SUM(total_orders) AS month_total_orders
    FROM monthly_orders
    GROUP BY order_month
)
SELECT 
    mo.order_item,
    mo.order_month,
    mo.total_orders,
    (mo.total_orders::float / mt.month_total_orders) * 100 AS percentage_of_monthly_orders
FROM monthly_orders mo
JOIN monthly_totals mt ON mo.order_month = mt.order_month
ORDER BY mo.order_month, mo.total_orders DESC;





























