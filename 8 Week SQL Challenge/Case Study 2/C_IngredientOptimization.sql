/* --------------------
   Case Study Questions
   --------------------*/
   
/* -------------------------------------------------------------
               C. Ingredient Optimization
---------------------------------------------------------------- */



-- What are the standard ingredients for each pizza?
SELECT
	pn.pizza_name,
	STRING_AGG(pt.topping_name,' ,') AS "pizza_toppings"
FROM
	pizza_runner.pizza_names pn
LEFT JOIN pizza_runner.cleaned_pizza_recipes pr ON pn.pizza_id=pr.pizza_id
LEFT JOIN pizza_runner.pizza_toppings pt ON pt.topping_id = pr.topping_id
GROUP BY
	pn.pizza_name
ORDER BY
	pn.pizza_name;


-- What was the most commonly added extra?
SELECT
	topping_name AS "extra",
	COUNT(extra_id) AS "extra_count"
FROM
	(SELECT
		UNNEST(string_to_array(extras,', '))::integer AS "extra_id"
	FROM
		pizza_runner.clean_customer_orders
	WHERE 
	 	extras IS NOT NULL
	) AS extra_table,
	pizza_runner.pizza_toppings pt
WHERE
	pt.topping_id=extra_id
GROUP BY
	extra
ORDER BY
	extra_count DESC
LIMIT 1;


-- What was the most common exclusion?
SELECT
	pt.topping_name AS "exclusion",
	extra_id AS "topping_id",
	COUNT(extra_id) AS "exclusion_count"
FROM
	(SELECT
	 	UNNEST(string_to_array(exclusions,','))::integer AS extra_id
	 FROM
	 	pizza_runner.clean_customer_orders
	 WHERE
	 	exclusions IS NOT NULL
	) AS extra_table,
	pizza_runner.pizza_toppings AS pt
WHERE
	pt.topping_id=extra_id
GROUP BY
	exclusion,
	extra_id
ORDER BY
	exclusion_count DESC
LIMIT 1;


-- Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
SELECT
	c.order_id,
	CASE
		WHEN c.exclusions IS NOT NULL AND c.extras IS NOT NULL THEN
			pn.pizza_name||' - Exclude '|| STRING_AGG(pt.topping_name,' ,')||' - Extra '|| STRING_AGG(pt.topping_name,' ,')
		WHEN c.exclusions IS NULL AND c.extras IS NOT NULL THEN
			pn.pizza_name||' - Extra '|| STRING_AGG(pt.topping_name,' ,')
		WHEN c.exclusions IS NOT NULL AND c.extras IS NULL THEN
			pn.pizza_name||' - Exclude '|| STRING_AGG(pt.topping_name,' ,')
		WHEN c.exclusions IS NULL AND c.extras IS NULL THEN
			pn.pizza_name
	END AS order_item
FROM
	pizza_runner.clean_customer_orders c,
	pizza_runner.pizza_names pn,
	pizza_runner.pizza_toppings pt
WHERE
	c.pizza_id = pn.pizza_id AND
	pt.topping_id = ANY(string_to_array(c.exclusions,', ')::integer[]) AND
	pt.topping_id = ANY(string_to_array(c.extras,', ')::integer[])
GROUP BY
	c.order_id,
	pn.pizza_name,
	c.exclusions,
	c.extras
ORDER BY
	c.order_id;


-- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
SELECT UNNEST(string_to_array(c.extras,', '))::integer FROM pizza_runner.clean_customer_orders where order_id = order_id

SELECT
    co.order_id,
    co.order_identifier,
    STRING_AGG(
        CASE
            WHEN co.extras IS NOT NULL THEN
                CASE
                    WHEN t.topping_name IN (
                        SELECT UNNEST(string_to_array(co.extras, ', '))::integer 
                        FROM pizza_runner.clean_customer_orders 
                        WHERE order_id = co.order_id
                    ) THEN '2x ' || t.topping_name
                    ELSE t.topping_name
                END
            ELSE t.topping_name
        END,
        ', ' ORDER BY t.topping_name
    ) AS ingredient_list
FROM pizza_runner.clean_customer_orders co
JOIN pizza_runner.pizza_recipes pr ON co.pizza_id = pr.pizza_id
JOIN pizza_runner.pizza_toppings t ON pr.toppings LIKE '%' || t.topping_id || '%'
GROUP BY co.order_id, co.order_identifier;

SELECT
	c.order_id,
	pn.pizza_name||': '||
	(
		SELECT STRING_AGG(
			CASE 
				WHEN pt.topping_id IN (SELECT UNNEST(string_to_array(c.extras,', '))::integer FROM pizza_runner.clean_customer_orders c) THEN '2x'||pt.topping_name
				ELSE pt.topping_name
			END,
			', ' ORDER BY pt.topping_name
		)
		FROM 
			pizza_runner.pizza_toppings pt,
			pizza_runner.clean_customer_orders c
		WHERE
			pt.pizza
	) AS "ingredient_list"
FROM 
	pizza_runner.clean_customer_orders c,
	pizza_runner.pizza_names pn
WHERE
	c.pizza_id=pn.pizza_id
GROUP BY
	c.order_id,
	pn.pizza_name
ORDER BY
	c.order_id;


-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
SELECT
	c.order_identifier,
	pt.topping_name,
	SUM(
		CASE 
			WHEN c.extras LIKE '%' || pt.topping_id || '%' THEN 2 
			WHEN c.exclusions LIKE '%' || pt.topping_id || '%' THEN 0 
			ELSE 1
		END
	) AS "total_quantity"
FROM 
	pizza_runner.pizza_toppings pt
LEFT JOIN
	pizza_runner.clean_customer_orders c ON 1=1
JOIN
	pizza_runner.cleaned_pizza_recipes pr ON pr.
GROUP BY
	c.order_identifier,
	pt.topping_name
ORDER BY
	c.order_identifier,
	total_quantity DESC;
	
	
Generate an alphabetically ordered comma separated ingredient list for each pizza order from the clean_customer_orders table and add a 2x in front of any relevant ingredients
-- ie only add 2x if that particular record has any extras in it. otherwise just provide the ingredient list separated by comma