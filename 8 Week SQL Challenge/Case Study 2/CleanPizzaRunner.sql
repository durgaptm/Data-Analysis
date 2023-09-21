--************************Cleaning customer_orders table by creating a new table************************--

SELECT 
	*
FROM
	pizza_runner.customer_orders
	
SELECT
	order_id,
	customer_id,
	pizza_id,
	CASE 
		WHEN (exclusions IS NOT NULL) AND ((exclusions = '') OR (exclusions='null')) THEN NULL
		ELSE exclusions
	END AS exclusions,
	CASE 
		WHEN (extras IS NOT NULL) AND ((extras = '') OR (extras='null')) THEN NULL
		ELSE extras
	END AS extras,
	order_time::timestamp
INTO
	pizza_runner.clean_customer_orders
FROM
	pizza_runner.customer_orders

-- Add new column to table clean_customer_orders
ALTER TABLE pizza_runner.clean_customer_orders
ADD COLUMN order_identifier SERIAL;

-- Update new column with unique identifiers to identify each record
CREATE SEQUENCE order_identifier_seq START 1;
UPDATE pizza_runner.clean_customer_orders
SET order_identifier = nextval('order_identifier_seq');

SELECT 
	*
FROM
	pizza_runner.clean_customer_orders;

--************************Cleaning runner_orders table by creating a new table************************--
SELECT 
	*
FROM
	pizza_runner.runner_orders;
	
SELECT
	order_id,
	runner_id,
	CASE 
		WHEN pickup_time='null' THEN NULL
		ELSE pickup_time
	END AS pickup_time::timestamp,
	CASE 
		WHEN distance='null' THEN NULL
		ELSE CAST(TRIM(REPLACE(distance,'km','')) AS NUMERIC(10,2))
	END AS distance,
	CASE 
		WHEN duration='null' THEN NULL
		ELSE CAST(TRIM(REGEXP_REPLACE(duration,'[^0-9.]','','g')) AS NUMERIC(10,2))
	END AS duration,
	CASE 
		WHEN (cancellation IS NOT NULL) AND ((cancellation = '') OR (cancellation='null')) THEN NULL
		ELSE cancellation
	END AS cancellation
INTO
	pizza_runner.clean_runner_orders
FROM
	pizza_runner.runner_orders;
	
SELECT
	* 
FROM pizza_runner.clean_runner_orders;


--************************Cleaning pizza_recipes table by creating a new table************************--


ALTER TABLE pizza_runner.clean_customer_orders
ALTER COLUMN order_time SET DATA TYPE timestamp;

ALTER TABLE pizza_runner.clean_runner_orders
ALTER COLUMN pickup_time SET DATA TYPE timestamp USING pickup_time::timestamp,
ALTER COLUMN distance SET DATA TYPE NUMERIC(10,2),
ALTER COLUMN duration SET DATA TYPE NUMERIC(10,2);


--************************Cleaning pizza_recipes table by creating a new table************************--
SELECT
	pizza_id,
	unnest(string_to_array(toppings,','))::integer AS topping_id
INTO
	pizza_runner.cleaned_pizza_recipes
FROM
	pizza_runner.pizza_recipes;
	
SELECT * FROM pizza_runner.cleaned_pizza_recipes

