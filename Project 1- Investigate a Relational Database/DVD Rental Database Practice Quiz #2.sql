--Practice Quiz #1 Question #1
--actor full name, film title, length of movie, filmlen_groups
--filmlen_groups: 1 hr or less, 1-2hrs, 2-3hrs, more than 3 2hrs

SELECT full_name,
       film_title,
       film_length,
       CASE WHEN film_length <= 60 THEN 'Short'
       WHEN film_length > 60 AND film_length <= 120 THEN 'Medium'
       WHEN film_length > 120 AND film_length <= 180 THEN 'Long'
       ELSE 'Very Long' END AS filmlen_groups
FROM (
      SELECT TRIM(concat(a.first_name, ' ', a.last_name)) AS full_name,
             f.title AS film_title,
             f.length AS film_length
      FROM actor a
      JOIN film_actor ON a.actor_id = film_actor.actor_id
      JOIN film f ON film_actor.film_id = f.film_id) AS sub

--Practice Quiz #1 Question #1
--Modify above query to count movies in each category

SELECT DISTINCT(filmlen_groups),
       count(title) OVER (PARTITION BY filmlen_grpups) AS filmcount_bylencat
FROM (
      SELECT title,
             length,
             CASE WHEN film_length <= 60 THEN 'Short'
             WHEN film_length > 60 AND film_length <= 120 THEN 'Medium'
             WHEN film_length > 120 AND film_length <= 180 THEN 'Long'
             ELSE 'Very Long' END AS filmlen_groups
      FROM film) t1
ORDER BY filmlen_groups
