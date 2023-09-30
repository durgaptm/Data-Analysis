SELECT 
	s.customer_id,
    p.plan_name,
    s.start_date,
    DATEDIFF((LEAD(s.start_date) OVER (PARTITION by s.customer_id ORDER BY s.start_date)), s.start_date) AS no_of_days
FROM
	subscriptions s,
    plans p
WHERE
	p.plan_id=s.plan_id AND
    s.customer_id IN (1,2,11,13,15,16,18,19);

/*
Customer 1: 
	- Signed up on August 1, 2020 
    - After the trial plan, subscibed to basic montly plan instead of the automatic pro monthly plan
Customer 2: 
	- Signed up on September 20, 2020
    - After the trial plan, upgraded to pro annual plan on September 27, 2020
Customer 11: 
	- Signed up on November 19, 2020 
    - Churned on November 26, 2020 after the trial period
Customer 13: 
	- Signed up on December 15, 2020
    - Transitioned to basic monthly plan after the trial period for 97 days since December 22, 2020
    - Upgraded to pro monthly plan on March 19, 2020
Customer 15:
	- Signed up on March 17, 2020
	- Continued with automatic pro monthly plan since March 24, 2020 for 36 days
    - Churned on April 29, 2020
Customer 16:
	- Signed up on May 31, 2020
    - Transitioned to basic monthly plan after the trial period since June 7, 2020 for 136 days
    - Upgraded to pro annual plan on October 21, 2020
Customer 18:
	- Signed up on July 6, 2020
    - Continued with automatic pro montly plan after trial period since July 13, 2020
Customer 19:
	- Signed up on June 22, 2020
    - Continued with automatic pro monthly plan after trial period since June 29, 2020 for 61 days
    - Upgraded to pro annual plan on August 29, 2020
*/