--Question 1
--We want to understand more about the movies that families are watching.
--Family Movies: Animation, Children, Classics, Comedy, Family, and Music

--Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented count
--5 tables: Category, Film_Category, Inventory, Rental, Film
--3 columns: Film title, Category name, Count of Rentals

SELECT f.title AS film,
       c.name AS category,
       COUNT(r.rental_id) AS rental_count
FROM rental r
    JOIN inventory ON r.inventory_id = inventory.inventory_id
    JOIN film f ON inventory.film_id = f.film_id
    JOIN film_category ON f.film_id = film_category.film_id
    JOIN category c ON film_category.category_id = c.category_id
         AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1, 2
ORDER BY 1, 2;

--Question 2
--Find length of rental duration of family friendly movies compared to duration that all movies are rented for.
--Title, Category, rental_duration, quartile

SELECT sub.title,
       sub.name,
       sub.rental_duration,
       NTILE(4) OVER(ORDER BY sub.rental_duration) as quartile
  FROM (SELECT f.title AS title,
			         c.name AS name,
	  		       f.rental_duration AS rental_duration
          FROM category c
	             JOIN film_category ON c.category_id = film_category.category_id
               AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
               JOIN film f ON f.film_id = film_category.film_id) sub
ORDER BY 2, 1;

--Question 3
--Include corresponding count of movies within each combination of film category for each corresponding rental duration category in addition to the work so far

SELECT sub.name,
       sub.quartile,
       count(*)
  FROM (SELECT c.name AS name,
	  		       f.rental_duration,
               NTILE(4) OVER (ORDER BY f.rental_duration) AS quartile
          FROM category c
	             JOIN film_category
	              ON 	c.category_id = film_category.category_id
                AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')

               JOIN film AS f
	              ON f.film_id = film_category.film_id) sub
GROUP BY 1, 2
ORDER BY 1, 2;
