### STAT 3
## HW1 Siying Cao

# Q1. How many tables in the Sakila db?
USE sakila;
SHOW TABLES;
# Method 1 (this includes views)
SELECT FOUND_ROWS();

# Method 2 (this only counts tables)
SELECT COUNT(*) FROM information_schema.tables
WHERE table_schema='sakila'
AND table_type='base table';

# Q2. List DVD's that were returned later than due date
SELECT DISTINCT inventory.inventory_id FROM inventory, rental, film
WHERE inventory.inventory_id=rental.inventory_id
AND film.film_id=inventory.film_id
AND return_date IS NOT NULL
AND (rental_date + INTERVAL film.rental_duration DAY) < return_date;

# Testing part, don't run
SELECT inventory.inventory_id, (rental_date + INTERVAL film.rental_duration DAY) AS due_date, return_date
FROM inventory, rental, film
WHERE inventory.inventory_id=6
AND inventory.inventory_id=rental.inventory_id
AND film.film_id=inventory.film_id;

# Q3. How many DVD's were returned on time 

# Q4. Find the category name, category id, number of movies in each movie category
SELECT category.name, category.category_id, COUNT(film_category.film_id) AS total 
FROM category, film_category
WHERE film_category.category_id=category.category_id
GROUP BY category.category_id
ORDER BY category.name;

# Testing part, don't run
SELECT COUNT(film_category.film_id) FROM film_category
WHERE category_id=2;

# Q5. Find the names of actors, and the drama movies they acted in
SELECT actor.actor_id, CONCAT(actor.first_name, ',', actor.last_name) AS Actor_Name,
film.title
FROM actor, film, film_actor, category, film_category
WHERE film_actor.actor_id=actor.actor_id
AND film_actor.film_id=film.film_id
AND category.name='Drama'
AND film_category.category_id=category.category_id
AND film_category.film_id=film.film_id
ORDER BY Actor_Name, title;

# Testing
SELECT actor.actor_id, film.title, film.film_id, category.name
FROM actor, film, film_actor, category, film_category
WHERE film_actor.actor_id=actor.actor_id
AND film_actor.film_id=film.film_id
AND actor.actor_id=165 # Should have three drama movies listed under his name
AND film.film_id=film_category.film_id
AND category.category_id=film_category.category_id;

# Q6. Find the number of customers living in each city
SELECT city.city_id, city.city, COUNT(customer.customer_id) AS total
FROM customer, address, city
WHERE customer.address_id=address.address_id
AND address.city_id=city.city_id
GROUP BY city.city
#HAVING total>1
ORDER BY city.city;

# Testing part, don't run
SELECT city.city_id, city.city, customer_id
FROM city, customer, address
WHERE city.city_id=42
AND customer.address_id=address.address_id
AND address.city_id=city.city_id;

# Q7. Find the names of the top 20 customers
# who have rented the most movies
SELECT customer.customer_id, CONCAT(customer.first_name, ',', customer.last_name) AS name,COUNT(rental_id) 
FROM customer, rental
WHERE customer.customer_id=rental.customer_id
GROUP BY customer.customer_id
ORDER BY -COUNT(rental_id)
LIMIT 20;

# Q8. Find the names of the top 5 most rented movies,
# How many times were they rented?
SELECT film.film_id, film.title, COUNT(rental.rental_id)
FROM rental, inventory, film
WHERE rental.inventory_id=inventory.inventory_id
AND inventory.film_id=film.film_id
GROUP BY film.film_id
ORDER BY -COUNT(rental.rental_id), title;

# Testing part, don't run
SELECT inventory_id FROM inventory
WHERE inventory.film_id=1;

SELECT rental_id, inventory_id FROM rental
WHERE rental.inventory_id IN (1,2,3,4,5,6,7,8);

# Q9. Find the movies that each actor has acted in
SELECT actor.actor_id, CONCAT(first_name, ',', last_name) AS actor_name, film.film_id, film.title
FROM actor, film, film_actor
WHERE film_actor.actor_id=actor.actor_id
AND film_actor.film_id=film.film_id;

# Q10. Find the top 5 actors whose movies were rented the most
SELECT actor.actor_id, CONCAT(first_name, ',', last_name) AS actor_name, COUNT(rental.rental_id)
FROM actor, film, film_actor, rental, inventory
WHERE film_actor.actor_id=actor.actor_id
AND film_actor.film_id=film.film_id
AND rental.inventory_id=inventory.inventory_id
AND inventory.film_id=film.film_id
GROUP BY actor.actor_id
ORDER BY -COUNT(rental.rental_id)
LIMIT 5;

# Testing part, don't run
SELECT actor.actor_id, film.film_id, film.title
FROM actor, film, film_actor
WHERE film_actor.actor_id=actor.actor_id
AND film_actor.film_id=film.film_id
AND actor.actor_id=1;

SELECT COUNT(rental.rental_id)
FROM rental, inventory, film
WHERE rental.inventory_id=inventory.inventory_id
AND inventory.film_id=film.film_id
AND film.film_id IN (1,23,25,106,140,166,277,361,438,499,506,509,605,635,749,832,939,970,980)
GROUP BY film.film_id
ORDER BY -COUNT(rental.rental_id), title;