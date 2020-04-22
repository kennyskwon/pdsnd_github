--Practice Quiz #1 Question #1

SELECT concat(a.first_name, ' ',a.last_name) AS full_name,
       f.title AS title,
       f.length
FROM actor a
JOIN film_actor
ON a.actor_id = film_actor.actor_id
JOIN film f
ON film_actor.film_id = f.film_id;

--Practice Quiz #1 Question #2

SELECT full_name,
       title
FROM (SELECT TRIM(concat(a.first_name, ' ',a.last_name)) AS full_name,
       f.title AS title,
       f.description,
       f.length
FROM actor a
JOIN film_actor
ON a.actor_id = film_actor.actor_id
JOIN film f
ON film_actor.film_id = f.film_id
WHERE f.length > 60) AS sub;

--Practice Quiz #1 Question #3

SELECT id,
       full_name,
       count(title)
FROM (SELECT TRIM(concat(a.first_name, ' ',a.last_name)) AS full_name,
       f.title AS title,
       a.actor_id AS id
FROM actor a
JOIN film_actor
ON a.actor_id = film_actor.actor_id
JOIN film f
ON film_actor.film_id = f.film_id) AS sub
GROUP BY 1, 2
ORDER BY 3 DESC;
