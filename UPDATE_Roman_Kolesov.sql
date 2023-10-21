-- Alter the rental duration and rental rates of the film you inserted before to three weeks and 9.99, respectively.
-- Alter any existing customer in the database with at least 10 rental and 10 payment records. Change their personal data to yours (first name, last name, address, etc.). You can use any existing address from the "address" table. Please do not perform any updates on the "address" table, as this can impact multiple records with the same address.
-- Change the customer's create_date value to current_date.

-- first option
UPDATE film
SET rental_duration = 21,
    rental_rate = 9.99
WHERE title = 'The Lord of the Rings';

-- second option
UPDATE film
SET rental_duration = 21,
    rental_rate = 9.99
WHERE film_id = 1001;


UPDATE customer
SET
  first_name = 'Roman',
  last_name = 'Kolesov',
  email = 'rkolesov@gmail.com',
  address_id = (
    SELECT address_id
    FROM address
    OFFSET floor(random() * (SELECT count(*) FROM address))
    LIMIT 1
  ),
  create_date = current_date --Change the customer's create_date value to current_date in the same query
WHERE customer_id IN (
  SELECT c.customer_id
  FROM customer c
  JOIN (
    SELECT customer_id
    FROM rental
    GROUP BY customer_id
    HAVING count(*) >= 10
  ) AS rental_counts
  ON c.customer_id = rental_counts.customer_id
  JOIN (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    HAVING count(*) >= 10
  ) AS payment_counts
  ON c.customer_id = payment_counts.customer_id
  LIMIT 1
);

-- Change the customer's create_date value to current_date in the separate query for all customers
UPDATE customer
SET create_date = current_date;

