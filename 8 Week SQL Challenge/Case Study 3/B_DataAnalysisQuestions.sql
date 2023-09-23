	
/* --------------------
   Case Study Questions
   --------------------*/
   
					/***************************************
								B. Data Analysis Questions
						****************************************/

-- How many customers has Foodie-Fi ever had?
SELECT 
	COUNT(DISTINCT customer_id) AS "no_of_customers" 
FROM 
	subscriptions;


-- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
SELECT 
	MONTH(start_date) AS "start_of_month",
    COUNT(customer_id) AS "trial_plan_count"
FROM
	subscriptions
WHERE
	plan_id=0
GROUP BY 
	start_of_month
ORDER BY
	start_of_month;
    

-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT
	p.plan_name,
    COUNT(s.plan_id) AS "count_of_events"
FROM 
	subscriptions s,
	plans p
WHERE
	p.plan_id=s.plan_id AND
    YEAR(start_date) > 2020
GROUP BY
	p.plan_name;


-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
SELECT
	COUNT(DISTINCT customer_id) AS "cust_churn_count",
    ROUND(COUNT(DISTINCT customer_id)/(SELECT COUNT(DISTINCT customer_id) FROM subscriptions)*100,1) AS "percent_of_cust_churn"
FROM
	subscriptions
WHERE
    plan_id=4;


-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
WITH ChurnedCustomer AS(
						SELECT
							customer_id,
                            CASE
								WHEN plan_id=4 AND
                                LAG(plan_id) OVER (PARTITION BY customer_id ORDER BY start_date) = 0
                                THEN 1 ELSE 0
							END AS "customer_churn"
						FROM
							subscriptions
						)
SELECT 
	SUM(customer_churn) AS "churn_after_first_trial",
    ROUND(SUM(customer_churn)/COUNT(DISTINCT customer_id)*100,0) AS "perc_of_churn" 
FROM
	ChurnedCustomer;
    

-- What is the number and percentage of customer plans after their initial free trial?
WITH CustomerPlans AS(
		SELECT
			customer_id,
            plan_id,
            ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY start_date) AS row_no
		FROM subscriptions	
		WHERE plan_id <> 0         
	)
SELECT
	p.plan_name,
	COUNT(cp.customer_id) AS "no_of_plans",
    ROUND(COUNT(DISTINCT cp.customer_id)/(SELECT COUNT(DISTINCT customer_id) FROM subscriptions)*100,1) AS "percentage"
FROM
	CustomerPlans cp,
    plans p
WHERE
	cp.plan_id=p.plan_id AND
    cp.row_no = 1
GROUP BY
	p.plan_name;


-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
SET @cust_count=(
		SELECT COUNT(DISTINCT customer_id)
		FROM subscriptions
        WHERE start_date);

WITH CustomerPlans AS(
			SELECT
				customer_id,
                plan_id,
				ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY start_date DESC) AS row_no
			FROM
				subscriptions
			WHERE 
				start_date<='2020-12-31')
SELECT
	p.plan_name,
    COUNT(DISTINCT c.customer_id) AS "cust_count",
    ROUND(COUNT(c.customer_id)/@cust_count*100,1) AS "percentage"
FROM
	CustomerPlans c,
    plans p
WHERE
	c.plan_id=p.plan_id AND
    c.row_no=1
GROUP BY
	p.plan_name;
    

-- How many customers have upgraded to an annual plan in 2020?
SELECT 
	COUNT(DISTINCT customer_id) AS "annual_plan_holders"
FROM
	subscriptions
WHERE
	plan_id=3 AND
    YEAR(start_date)=2020;


-- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
SELECT 
	AVG(DATEDIFF(s2.start_date,s1.start_date)) AS "avg_days"
FROM
	subscriptions s1,
    subscriptions s2
WHERE
	s1.plan_id = 0 AND
    s2.plan_id = 3 AND
    s1.customer_id=s2.customer_id;


-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
WITH Bins AS(
		SELECT
			s1.customer_id as "customer_id",
			s1.start_date as "join_date",
			s2.start_date as "annual_plan_date",
			(DATEDIFF(s2.start_date,s1.start_date)) AS "days",
			CEIL(DATEDIFF(s2.start_date,s1.start_date)/30) AS "bin"
		FROM
			subscriptions s1,
			subscriptions s2
		WHERE
			s1.plan_id = 0 AND
			s2.plan_id = 3 AND
			s1.customer_id=s2.customer_id
		)

SELECT
	CASE
		WHEN bin=1 THEN CONCAT(bin-1, ' - ', bin*30, ' days')
        ELSE CONCAT((bin-1)*30+1, ' - ', bin*30, ' days')
	END AS periods,
    COUNT(DISTINCT customer_id) AS "cust_count",
    AVG(days) AS "avg_days"
FROM Bins
GROUP BY bin
ORDER BY bin;
	

-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
WITH Downgrade_CTE AS(
			SELECT
				customer_id,
                CASE 
					WHEN plan_id=2 AND
						LEAD(plan_id) OVER (PARTITION BY customer_id ORDER BY start_date) = 1
                        THEN 1 ELSE 0
				END AS "downgraded_cust"
			FROM subscriptions
		)
SELECT
	SUM(downgraded_cust)
FROM Downgrade_CTE