--Question Set #2 Question #1
--Want to find out how 2 stores compare in rental orders each month.
--Store ID, Year, Month, Number of Rental Orders/store/Month


SELECT DATE_PART('year', r.rental_date) AS year,
       DATE_PART('month', r.rental_date) AS month,
       s.store_id,
       count(*)
FROM store s
JOIN staff ON s.store_id = staff.store_id
JOIN rental r ON staff.staff_id = r.staff_id
GROUP BY 1, 2, 3
ORDER BY 1, 2;


--Question Set #2 Question #2
--Want to know top 10 paying customers, how many payments they made on a monthly basis during 2007, and amount of monthly payments
--Customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers

WITH t1 AS (SELECT (first_name || ' ' || last_name) AS name,
                   c.customer_id,
                   p.amount,
                   p.payment_date
              FROM customer AS c
                   JOIN payment AS p
                    ON c.customer_id = p.customer_id),

     t2 AS (SELECT t1.customer_id
              FROM t1
             GROUP BY 1
             ORDER BY SUM(t1.amount) DESC
             LIMIT 10)

SELECT t1.name,
       DATE_PART('month', t1.payment_date) AS payment_month,
       DATE_PART('year', t1.payment_date) AS payment_year,
       COUNT (*),
       SUM(t1.amount)
  FROM t1
       JOIN t2
        ON t1.customer_id = t2.customer_id
 WHERE t1.payment_date BETWEEN '20070101' AND '20080101'
 GROUP BY 1, 2, 3;

--Alternate attempt

SELECT sub.date,
       sub.name,
       COUNT(*),
       SUM(sub.amount)
FROM (SELECT p.payment_date AS date,
             concat(c.first_name, ' ', c.last_name) AS name,
             c.customer_id,
             p.amount AS amount,
             SUM(p.amount)
      FROM customer c
      JOIN payment p ON c.customer_id = p.customer_id
      WHERE p.payment_date BETWEEN '20070101' and '20180101'
      GROUP BY 3, 2, 1, 4
      LIMIT 10) sub
GROUP BY 1, 2
ORDER BY 2, 1;

--Question Set #2 Question #3
--Write a query to compare payment amounts in each successive month of top 10 paying customers.

WITH t1 AS (SELECT (first_name || ' ' || last_name) AS name,
                   c.customer_id,
                   p.amount,
                   p.payment_date
              FROM customer AS c
                   JOIN payment AS p
                    ON c.customer_id = p.customer_id),

     t2 AS (SELECT t1.customer_id
              FROM t1
             GROUP BY 1
             ORDER BY SUM(t1.amount) DESC
             LIMIT 10),


t3 AS (SELECT t1.name,
              DATE_PART('month', t1.payment_date) AS payment_month,
              DATE_PART('year', t1.payment_date) AS payment_year,
              COUNT (*),
              SUM(t1.amount),
              SUM(t1.amount) AS total,
              LEAD(SUM(t1.amount)) OVER(PARTITION BY t1.name ORDER BY DATE_PART('month', t1.payment_date)) AS lead,
              LEAD(SUM(t1.amount)) OVER(PARTITION BY t1.name ORDER BY DATE_PART('month', t1.payment_date)) - SUM(t1.amount) AS lead_dif
         FROM t1
              JOIN t2
               ON t1.customer_id = t2.customer_id
        WHERE t1.payment_date BETWEEN '20070101' AND '20080101'
        GROUP BY 1, 2, 3
        ORDER BY 1, 3, 2)

SELECT t3.*,
       CASE
           WHEN t3.lead_dif = (SELECT MAX(t3.lead_dif) FROM t3 ORDER BY 1 DESC LIMIT 1) THEN 'this is the maximum difference'
           ELSE NULL
           END AS is_max
  FROM t3
 ORDER BY 1;
