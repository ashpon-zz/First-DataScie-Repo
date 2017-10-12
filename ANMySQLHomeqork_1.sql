-- 1a.
select first_name , last_name
from sakila.actor
;

-- 1b
select CONCAT(first_name , ' ', last_name) as 'Actor Name'
from sakila.actor
;

-- 2a.
select actor_id, first_name , last_name
  from sakila.actor 
 where first_name='Joe'
;

-- 2b.
select actor_id, first_name , last_name
  from sakila.actor 
 where UPPER(last_name) LIKe '%GEN%'
;

-- 2c.
select actor_id, first_name , last_name
  from sakila.actor 
 where UPPER(last_name) LIKe '%LI%'
 order by 2,1 
;

-- 2d.
select country_id, country 
  from sakila.country 
 where country in ('Afghanistan', 'Bangladesh', 'China')
;

-- 3a.
ALTER table sakila.actor add column   Middle_name varchar(15)   AFTER first_name
;

-- 3b
ALTER table sakila.actor MODIFY column   Middle_name blob 
;

-- 3c
ALTER table sakila.actor drop column  Middle_name  
;

-- 4a. List the last names of actors, as well as how many actors have that last name
select Last_name , count(actor_id)
  from sakila.actor 
 group by 1
 order by 2
;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select Last_name , count(actor_id)
  from sakila.actor 
 group by 1
 having count(actor_id) >1
 order by 2
;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
select * from sakila.actor where first_name = 'GROUCHO'
;
update sakila.actor set first_name = 'HARPO' 
 where first_name = 'GROUCHO' 
   AND last_name = 'WILLIAMS'
;

select * from sakila.actor where first_name = 'GROUCHO'
;

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, 
-- change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
-- BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! 
-- (Hint: update the record using a unique identifier.)
select * from sakila.actor where first_name = 'HARPO'
;

UPDATE sakila.actor  
   SET first_name =
   (CASE 
       WHEN first_name = 'HARPO'   THEN  'GROUCHO'
       WHEN first_name = 'GROUCHO' THEN  ' MUCHO GROUCHO'
    ELSE
	   first_name = first_name
	END)
 where actor_id = 172
;
select * from sakila.actor where actor_id = 172
;


-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?sakir
-- drop table sakila.address
;

CREATE TABLE sakila.address(
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT primary key,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) 
;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select s.first_name, s.last_name , a.address
  from sakila.staff s
  join sakila.address a on s.address_id = a.address_id
  ;
  
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select s.staff_id, sum(p.amount)
  from sakila.staff s 
  join sakila.payment p on s.staff_id = p.staff_id
 group by 1
;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
 select f.film_id, f.title, CONCAT(a.first_name,' ',a.last_name) as 'Actor Name'
   from sakila.film f 
   join sakila.film_actor fa on fa.film_id = f.film_id
   join sakila.actor a on fa.actor_id = a.actor_id 
   order by 1
;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select f.title, count(i.inventory_id)
  from sakila.inventory i
  join sakila.film f on i.film_id = f.film_id 
   and f.title = 'Hunchback Impossible'
 group by 1
;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
select c.first_name
     , c.last_name
     , sum(p.amount)
  from sakila.customer c 
  join sakila.payment p on p.customer_id = c.customer_id
  group by 1,2
  order by 2
;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
-- films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies 
-- starting with the letters K and Q whose language is English.
-- AN comment why need a sub query here?
select title, l.name
  from sakila.film f
  join sakila.language l on f.language_id = l.language_id
 where (f.title like ('K%') OR f.title like ('Q%')) 
   and l.name = 'English'
;

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select CONCAT(a.first_name, ' ', a.last_name) as 'ACTOR NAME', f.title 
  from sakila.actor a 
  join sakila.film_actor fa on fa.actor_id = a.actor_id
  join sakila.film f on f.film_id = fa.film_id 
 where f.title = 'Alone Trip'  
;

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
select CONCAT(c.first_name, ' ', c.last_name) AS 'Customer Name' , email, cn.country
  from sakila.customer c
  join sakila.address a on c.address_id = a.address_id
  join sakila.city ct on ct.city_id = a.city_id
  join sakila.country cn on ct.country_id = cn.country_id
 where cn.country = 'CANADA'
;

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as famiy films.
select f.title, c.name
  from sakila.film f 
  join sakila.film_category fc on fc.film_id = f.film_id 
  join sakila.category c on fc.category_id = c.category_id
 where c.name = 'Family'
;

-- 7e. Display the most frequently rented movies in descending order.
select f.title, count(r.rental_id) 
  from sakila.rental r
  join sakila.inventory i on r.inventory_id = i.inventory_id
  join sakila.film f on i.film_id = f.film_id
 group by 1 
 order by 2 desc
;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(p.amount) AS 'Total Sales'
  from sakila.rental r
  join sakila.payment p on r.rental_id = p.rental_id
  join sakila.inventory i on i.inventory_id = r.inventory_id
  join sakila.store s on i.store_id = s.store_id
 group by 1 
 order by 2 desc
;
-- OR
select * from sakila.sales_by_store
;

-- 7g. Write a query to display for each store its store ID, city, and country.
select concat(`c`.`city`,_utf8',',`cn`.`country`) AS `store`, s.store_id, c.city, cn.country
  from sakila.store s 
  join sakila.address a on a.address_id = s.address_id 
  join sakila.city c on c.city_id = a.city_id
  join sakila.country cn on cn.country_id = c.country_id
;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select ca.name, sum(amount) 
  from sakila.payment p 
  join sakila.rental r on p.rental_id = r.rental_id
  join sakila.inventory i on r.inventory_id = i.inventory_id
  join sakila.film_category fc on fc.film_id = i.film_id
  join sakila.category ca on ca.category_id = fc.category_id
 group by 1
 order by 2 DESC
 limit 5
 ;
 
 -- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
 -- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
 create view sakila.top5Films as (
 select ca.name, sum(amount) 
  from sakila.payment p 
  join sakila.rental r on p.rental_id = r.rental_id
  join sakila.inventory i on r.inventory_id = i.inventory_id
  join sakila.film_category fc on fc.film_id = i.film_id
  join sakila.category ca on ca.category_id = fc.category_id
 group by 1
 order by 2 DESC
 limit 5
 )
 ;
 -- test the view
 select * from sakila.top5Films;
 
-- 8b. How would you display the view that you created in 8a?
-- look above :D....

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view sakila.top5Films;

