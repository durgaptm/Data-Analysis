/* --------------------
   Case Study Questions
   --------------------*/
   
					/***************************************
								C. Challenge Payment Question
						****************************************/


/* 
The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:
- monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
- upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
- upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
- once a customer churns they will no longer make payments 
*/

CREATE TABLE payments AS
WITH InitialPayments AS(
	SELECT 
		s.customer_id,
		s.plan_id,
		p.plan_name,
		s.start_date,
        CASE 
			WHEN 
				LEAD(s.start_date) OVER (PARTITION BY s.customer_id ORDER BY s.start_date, s.plan_id) 
				THEN LEAD(s.start_date) OVER (PARTITION BY s.customer_id ORDER BY s.start_date, s.plan_id) 
            ELSE '2021-01-01'
		END AS end_date,
		p.price
	FROM
		subscriptions s
	JOIN 
		plans p ON p.plan_id=s.plan_id
	WHERE
		s.plan_id<>0 AND
        YEAR(s.start_date)=2020
),
paymentSchedule AS(
	SELECT
		ip.customer_id,
        ip.plan_id,
        ip.plan_name,
        CASE 
			WHEN plan_id <> 3
				THEN DATE_FORMAT(DATE_ADD(ip.start_date, INTERVAL pm.n MONTH), '%Y-%m-%d')
			ELSE DATE_FORMAT(DATE_ADD(ip.start_date, INTERVAL pm.n YEAR), '%Y-%m-%d')
		END AS payment_date,
        ip.price
	FROM
		InitialPayments ip
	JOIN (
		SELECT 0 AS n UNION ALL
        SELECT 1 UNION ALL
        SELECT 2 UNION ALL
        SELECT 3 UNION ALL
        SELECT 4 UNION ALL
        SELECT 5 UNION ALL
        SELECT 6 UNION ALL
        SELECT 7 UNION ALL
        SELECT 8 UNION ALL
        SELECT 9 UNION ALL
        SELECT 10 UNION ALL
        SELECT 11
	) AS pm ON pm.n<=11
    WHERE
        ip.plan_id<>4 AND
        DATE_FORMAT(DATE_ADD(ip.start_date, INTERVAL pm.n MONTH), '%Y-%m-%d') < ip.end_date
)
 
SELECT 
	customer_id,
    plan_id,
    plan_name,
    payment_date,
	CASE 
		WHEN 
			PERIOD_DIFF(DATE_FORMAT(payment_date, '%Y%m'), DATE_FORMAT(LAG(payment_date) OVER (PARTITION BY customer_id ORDER BY payment_date),'%Y%m')) < 1
		THEN (price - LAG(price) OVER (PARTITION BY customer_id ORDER BY payment_date)) 
		ELSE price
	END AS amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date ASC) AS payment_order
FROM 
	paymentSchedule
WHERE YEAR(payment_date)=2020
ORDER BY
	customer_id,
    plan_id,
    payment_order;