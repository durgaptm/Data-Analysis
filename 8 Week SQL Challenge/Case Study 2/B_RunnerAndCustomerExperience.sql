/* --------------------
   Case Study Questions
   --------------------*/
   
/* -------------------------------------------------------------
               B. Runner and Customer Experience
---------------------------------------------------------------- */

-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT
	DATE_TRUNC('week',registration_date)::DATE AS "week_start",
	COUNT(*) AS "sign_ups"
FROM
	pizza_runner.runners
GROUP BY
	week_start
ORDER BY
	week_start;
	

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT
	r.runner_id,
	ROUND(AVG(EXTRACT(EPOCH FROM (r.pickup_time - c.order_time))/60)) AS "avg_time_in_min"
FROM
	pizza_runner.clean_customer_orders c,
	pizza_runner.clean_runner_orders r
WHERE
	c.order_id=r.order_id
GROUP BY
	r.runner_id
ORDER BY
	r.runner_id;
	

-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT
	no_of_pizzas,
	ROUND(AVG(EXTRACT(EPOCH FROM (r.pickup_time - c.order_time))/60)) AS "avg_prep_time_in_min"
FROM
	(SELECT
	 	order_id,
	 	order_time,
	 	COUNT(pizza_id) AS "no_of_pizzas"
	FROM pizza_runner.clean_customer_orders
	GROUP BY order_id,order_time) AS c,
	pizza_runner.clean_runner_orders r
WHERE
	c.order_id=r.order_id
GROUP BY
	no_of_pizzas
ORDER BY
	no_of_pizzas;
	

-- What was the average distance travelled for each customer?
SELECT
	c.customer_id,
	ROUND(AVG(r.distance),2) AS "avg_distance"
FROM
	pizza_runner.clean_customer_orders c,
	pizza_runner.clean_runner_orders r
WHERE
	c.order_id=r.order_id
GROUP BY
	c.customer_id
ORDER BY
	c.customer_id;
	
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'clean_runner_orders';

-- What was the difference between the longest and shortest delivery times for all orders?
SELECT
	ROUND(MAX(duration)) AS "largest_delivery_time",
	ROUND(MIN(duration)) AS "smallest_delivery_time",
	ROUND(MAX(duration) - MIN(duration)) AS "time_diff_min"
FROM
	pizza_runner.clean_runner_orders


-- What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT
	runner_id,
	order_id,
	distance,
	duration,
	ROUND((distance/duration)*60,2) AS "avg_speed_kmph"
FROM
	pizza_runner.clean_runner_orders
WHERE
	cancellation IS NULL
GROUP BY
	runner_id,
	order_id,
	distance,
	duration
ORDER BY
	runner_id;


-- What is the successful delivery percentage for each runner?
SELECT
	runner_id,
	COUNT(*) AS "total_deliveries",
	COUNT(CASE WHEN cancellation IS NULL THEN 1 ELSE NULL END) AS "successful_deliveries",
	ROUND((COUNT(CASE WHEN cancellation IS NULL THEN 1 ELSE NULL END)::numeric/COUNT(*))*100) AS success_delivery_percentage
FROM
	pizza_runner.clean_runner_orders
GROUP BY
	runner_id;
ORDER BY
	runner_id;
