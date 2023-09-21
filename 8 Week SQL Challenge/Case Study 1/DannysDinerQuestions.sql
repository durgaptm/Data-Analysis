/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
SELECT
	customer_id,
    SUM(price) AS "Amount Spent"
FROM dannys_diner.sales s, dannys_diner.menu m
WHERE s.product_id = m.product_id
GROUP BY customer_id;

-- 2. How many days has each customer visited the restaurant?
SELECT
	customer_id,
	COUNT(DISTINCT order_date) AS "No of Days"
FROM dannys_diner.sales
GROUP BY customer_id
ORDER BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
WITH RankPurchases AS(
	SELECT 
		s.customer_id,
		m.product_name,
		s.order_date,
		ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rank_no
	FROM
		dannys_diner.sales s
	JOIN
		dannys_diner.menu m ON s.product_id=m.product_id)

SELECT
	customer_id,
	product_name AS "first_purchase"
FROM
	RankPurchases rp
WHERE
	rank_no = 1
	
--- Alternate answer	
SELECT
  s."customer_id",
  (
    SELECT
      m."product_name"
    FROM
      dannys_diner.sales s2
    JOIN
      dannys_diner.menu m ON s2."product_id" = m."product_id"
    WHERE
      s2."customer_id" = s."customer_id"
    ORDER BY
      s2."order_date" ASC
    LIMIT 1
  ) AS "first_purchase"
FROM
  dannys_diner.sales s
GROUP BY
  s."customer_id";

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT
	m.product_name,
	COUNT(s.product_id) as "purchase_count"
FROM
	dannys_diner.sales s, dannys_diner.menu m
WHERE
	s.product_id=m.product_id 
GROUP BY
	m.product_name
ORDER BY
	"purchase_count" DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
WITH RankProduct AS(
	SELECT
		s.customer_id,
		m.product_name,
		COUNT(*) AS "purchase_count",
		ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS rnk_no
	FROM
		dannys_diner.sales s, dannys_diner.menu m
	WHERE s.product_id = m.product_id
	GROUP BY
		s.customer_id,
		m.product_name)

SELECT
	customer_id,
	product_name AS "most_popular_purchase",
	purchase_count
FROM
	RankProduct
WHERE
	rnk_no=1;

-- 6. Which item was purchased first by the customer after they became a member?

WITH RankPurchases AS(
	SELECT
		s.customer_id,
		m.product_name AS "first_purchase",
		ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rnk
	FROM
		dannys_diner.sales s
	JOIN
		dannys_diner.menu m ON s.product_id=m.product_id
	JOIN
		dannys_diner.members mem ON s.customer_id=mem.customer_id
	WHERE
		s.order_date>=mem.join_date)
SELECT
	customer_id,
	first_purchase
FROM
	RankPurchases
WHERE
	rnk = 1;

-- 7. Which item was purchased just before the customer became a member?
WITH RankPurchases AS(
	SELECT
		s.customer_id,
		m.product_name AS "last_purchase",
		ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS rnk
	FROM
		dannys_diner.sales s
	JOIN
		dannys_diner.menu m ON s.product_id=m.product_id
	JOIN
		dannys_diner.members mem ON s.customer_id=mem.customer_id
	WHERE
		s.order_date < mem.join_date)
SELECT
	customer_id,
	last_purchase
FROM
	RankPurchases
WHERE
	rnk = 1;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT
	s.customer_id,
	COUNT(*) AS "total_items",
	SUM(m.price) AS "amount_spent"
FROM
	dannys_diner.sales s
JOIN dannys_diner.menu m ON s.product_id=m.product_id
JOIN dannys_diner.members mem ON s.customer_id=mem.customer_id
WHERE
	s.order_date < mem.join_date
GROUP BY
	s.customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT
	s.customer_id,
	SUM(
		CASE
			WHEN m.product_name = 'sushi' THEN m.price*20    --2x multiplier for sushi
			ELSE m.price*10                                  --10 points for regular orders
		END
	) AS "total_points"
FROM
	dannys_diner.sales s
JOIN dannys_diner.menu m ON s.product_id=m.product_id
GROUP BY
	s.customer_id
ORDER BY
	s.customer_id;
	

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT
	s.customer_id,
	SUM(
		CASE 
			WHEN (m.product_id=1) OR (s.order_date BETWEEN mem.join_date AND mem.join_date+6) THEN m.price*20
			ELSE m.price*10
		END
	) AS "total_points"
FROM
	dannys_diner.sales s
JOIN dannys_diner.menu m ON s.product_id=m.product_id
JOIN dannys_diner.members mem ON s.customer_id=mem.customer_id
GROUP BY
	s.customer_id
ORDER BY
	s.customer_id;
	
	
	
------------------ BONUS QUESTIONS -------------------

SELECT
	s.customer_id,
	s.order_date,
	m.product_name,
	m.price,
	CASE
		WHEN (mem.join_date IS NOT NULL) AND (s.order_date>=mem.join_date) THEN 'Y'
		ELSE 'N'
	END AS "member"
FROM
	dannys_diner.sales s
JOIN dannys_diner.menu m ON s.product_id=m.product_id
LEFT JOIN dannys_diner.members mem ON s.customer_id=mem.customer_id
ORDER BY
	s.customer_id,
	s.order_date;
	
	
WITH RankPurchases AS(
	SELECT
		s.customer_id,
		s.order_date,
		m.product_name,
		m.price,
		CASE
			WHEN (mem.join_date IS NOT NULL) AND (s.order_date>=mem.join_date) THEN 'Y'
			ELSE 'N'
		END AS "member"
	FROM
		dannys_diner.sales s
	JOIN dannys_diner.menu m ON s.product_id=m.product_id
	LEFT JOIN dannys_diner.members mem ON s.customer_id=mem.customer_id)
	
SELECT
	customer_id,
	order_date,
	product_name,
	price,
	member,
	CASE
		WHEN member='Y' THEN DENSE_RANK() OVER (PARTITION BY customer_id,member ORDER BY order_date)
		ELSE NULL
	END AS "ranking"
FROM
	RankPurchases rp
ORDER BY
		customer_id,
		order_date;