-- Sakila Sample Database Schema
-- Version 1.5

-- Firebird port of sakila-schema.sql from MySQL

-- NOTE: Firebird does not support schemas

--
-- Definition for domain YEARONLY
--

CREATE DOMAIN YEARONLY AS INT
  CHECK (VALUE >= 1901 AND VALUE <= 2155);

--
-- Definition for domain RATING
--

CREATE DOMAIN RATING AS VARCHAR(5)
  CHECK (VALUE IS NULL OR VALUE IN ('G', 'PG', 'PG-13', 'R', 'NC-17'));

--
-- Definition for domain SPECIAL_FEATURES
--

CREATE DOMAIN SPECIAL_FEATURES AS VARCHAR(100)
  CHECK (VALUE IS NULL OR 
         VALUE LIKE 'Trailers' OR
         VALUE LIKE 'Trailers,%' OR
         VALUE LIKE '%,Trailers,%' OR
         VALUE LIKE '%,Trailers' OR
         VALUE LIKE 'Commentaries' OR
         VALUE LIKE 'Commentaries,%' OR
         VALUE LIKE '%,Commentaries,%' OR
         VALUE LIKE '%,Commentaries' OR
         VALUE LIKE 'Deleted Scenes' OR
         VALUE LIKE 'Deleted Scenes,%' OR
         VALUE LIKE '%,Deleted Scenes,%' OR
         VALUE LIKE '%,Deleted Scenes' OR
         VALUE LIKE 'Behind the Scenes' OR
         VALUE LIKE 'Behind the Scenes,%' OR
         VALUE LIKE '%,Behind the Scenes,%' OR
         VALUE LIKE '%,Behind the Scenes');

--
-- Table structure for table `actor`
--

CREATE TABLE actor (
  actor_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (actor_id)
);

CREATE INDEX actor_idx_last_name ON actor(last_name);

SET TERM ^ ;

CREATE TRIGGER actor_before_update FOR actor
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `address`
--

CREATE TABLE address (
  address_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id INT NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (address_id)
);

CREATE INDEX idx_address_fk_city_id ON address(city_id);

SET TERM ^ ;

CREATE TRIGGER address_before_update FOR address
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `category`
--

CREATE TABLE category (
  category_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  name VARCHAR(25) NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (category_id)
);

SET TERM ^ ;

CREATE TRIGGER category_before_update FOR category
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `city`
--

CREATE TABLE city (
  city_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  city VARCHAR(50) NOT NULL,
  country_id INT NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (city_id)
);

CREATE INDEX idx_city_fk_country_id ON city(country_id);

SET TERM ^ ;

CREATE TRIGGER city_before_update FOR city
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `country`
--

CREATE TABLE country (
  country_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  country VARCHAR(50) NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (country_id)
);

SET TERM ^ ;

CREATE TRIGGER country_before_update FOR country
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `customer`
--

CREATE TABLE customer (
  customer_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  store_id INT NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id INT NOT NULL,
  active BOOLEAN DEFAULT TRUE NOT NULL,
  create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (customer_id)
);

CREATE INDEX idx_customer_fk_store_id ON customer(store_id);
CREATE INDEX idx_customer_fk_address_id ON customer(address_id);
CREATE INDEX idx_customer_last_name ON customer(last_name);

SET TERM ^ ;

CREATE TRIGGER customer_before_update FOR customer
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `film`
--

CREATE TABLE film (
  film_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  title VARCHAR(255) NOT NULL,
  description BLOB SUB_TYPE TEXT DEFAULT NULL,
  release_year YEARONLY DEFAULT NULL,
  language_id INT NOT NULL,
  original_language_id INT DEFAULT NULL,
  rental_duration SMALLINT  DEFAULT 3 NOT NULL,
  rental_rate DECIMAL(4,2) DEFAULT 4.99 NOT NULL,
  length SMALLINT DEFAULT NULL,
  replacement_cost DECIMAL(5,2) DEFAULT 19.99 NOT NULL,
  rating RATING DEFAULT 'G',
  special_features SPECIAL_FEATURES DEFAULT NULL, -- Firebird does not support MySQL-like SET types, we must emulate this
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (film_id)
);

CREATE INDEX idx_film_fk_language_id ON film(language_id);
CREATE INDEX idx_film_fk_original_language_id ON film(original_language_id);

SET TERM ^ ;

CREATE TRIGGER film_before_update FOR film
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `film_actor`
--

CREATE TABLE film_actor (
  actor_id INT NOT NULL,
  film_id INT NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (actor_id,film_id)
);

CREATE INDEX film_actor_idx_fk_film ON film_actor(film_id);
CREATE INDEX film_actor_idx_fk_actor ON film_actor(actor_id) ;

SET TERM ^ ;

CREATE TRIGGER film_actor_before_update FOR film_actor
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `film_category`
--

CREATE TABLE film_category (
  film_id INT NOT NULL,
  category_id INT NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (film_id, category_id)
);

CREATE INDEX film_category_idx_fk_film ON film_category(film_id);
CREATE INDEX film_category_idx_fk_category ON film_category(category_id);

SET TERM ^ ;

CREATE TRIGGER film_category_before_update FOR film_category
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `film_text`
-- 

CREATE TABLE film_text (
  film_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description BLOB SUB_TYPE TEXT,
  PRIMARY KEY (film_id)
);

--
-- Triggers for loading film_text from film
--

SET TERM ^ ; 

CREATE TRIGGER ins_film FOR film
ACTIVE
AFTER INSERT 
AS
BEGIN
  INSERT INTO 
    film_text (film_id, title, description)
  VALUES 
    (new.film_id, new.title, new.description);
END^

CREATE TRIGGER upd_film FOR film 
ACTIVE
AFTER UPDATE 
AS 
BEGIN
  IF ((old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)) THEN
  BEGIN
    UPDATE 
      film_text
    SET 
      title=new.title,
      description=new.description,
      film_id=new.film_id
    WHERE 
      film_id=old.film_id;
  END
END^

CREATE TRIGGER del_film FOR film 
ACTIVE
AFTER DELETE 
AS
BEGIN
  DELETE FROM film_text WHERE film_id = old.film_id;
END^

SET TERM ; ^
--
-- Table structure for table `inventory`
--

CREATE TABLE inventory (
  inventory_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  film_id INT NOT NULL,
  store_id INT NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (inventory_id)
);

CREATE INDEX idx_inventory_fk_film_id ON inventory(film_id);
CREATE INDEX idx_inventory_fk_film_id_store_id ON inventory(store_id,film_id);

SET TERM ^ ;

CREATE TRIGGER inventory_before_update FOR inventory
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `language`
--

CREATE TABLE language (
  language_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  name CHAR(20) NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (language_id)
);

SET TERM ^ ;

CREATE TRIGGER language_before_update FOR language
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `payment`
--

CREATE TABLE payment (
  payment_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  customer_id INT NOT NULL,
  staff_id INT NOT NULL,
  rental_id INT DEFAULT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date TIMESTAMP NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (payment_id)
);

CREATE INDEX idx_payment_fk_staff_id ON payment(staff_id);
CREATE INDEX idx_payment_fk_customer_id ON payment(customer_id);

SET TERM ^ ;

CREATE TRIGGER payment_before_update FOR payment
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `rental`
--

CREATE TABLE rental (
  rental_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  rental_date TIMESTAMP NOT NULL,
  inventory_id INT  NOT NULL,
  customer_id INT  NOT NULL,
  return_date TIMESTAMP DEFAULT NULL,
  staff_id INT NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (rental_id)
);

CREATE UNIQUE INDEX idx_rental ON rental (rental_date,inventory_id,customer_id);
CREATE INDEX idx_rental_fk_inventory_id ON rental(inventory_id);
CREATE INDEX idx_rental_fk_customer_id ON rental(customer_id);
CREATE INDEX idx_rental_fk_staff_id ON rental(staff_id);

SET TERM ^ ;

CREATE TRIGGER rental_before_update FOR rental
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `staff`
--

CREATE TABLE staff (
  staff_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  address_id INT NOT NULL,
  picture BLOB DEFAULT NULL,
  email VARCHAR(50) DEFAULT NULL,
  store_id INT NOT NULL,
  active BOOLEAN DEFAULT TRUE NOT NULL,
  username VARCHAR(16) NOT NULL,
  password VARCHAR(40) DEFAULT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (staff_id)
);

CREATE INDEX idx_staff_fk_store_id ON staff(store_id);
CREATE INDEX idx_staff_fk_address_id ON staff(address_id);

SET TERM ^ ;

CREATE TRIGGER staff_before_update FOR staff
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Table structure for table `store`
--

CREATE TABLE store (
  store_id INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
  manager_staff_id INT NOT NULL,
  address_id INT NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (store_id)
);

CREATE INDEX idx_store_fk_manager_staff_id ON store(manager_staff_id);
CREATE INDEX idx_store_fk_address ON store(address_id);

SET TERM ^ ;

CREATE TRIGGER store_before_update FOR store
ACTIVE
BEFORE UPDATE
AS
BEGIN
  NEW.last_update=CURRENT_TIMESTAMP;
END^

SET TERM ; ^

--
-- Foreign key constraints
--

ALTER TABLE address ADD CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE city ADD CONSTRAINT fk_city_country FOREIGN KEY (country_id) REFERENCES country (country_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE customer ADD CONSTRAINT fk_customer_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE customer ADD CONSTRAINT fk_customer_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE film ADD CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES language (language_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE film ADD CONSTRAINT fk_film_language_original FOREIGN KEY (original_language_id) REFERENCES language (language_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE film_actor ADD CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE film_actor ADD CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE film_category ADD CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE film_category ADD CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) REFERENCES category (category_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE inventory ADD CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE inventory ADD CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE payment ADD CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) REFERENCES rental (rental_id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE payment ADD CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE payment ADD CONSTRAINT fk_payment_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE rental ADD CONSTRAINT fk_rental_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE rental ADD CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE rental ADD CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE staff ADD CONSTRAINT fk_staff_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE staff ADD CONSTRAINT fk_staff_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE store ADD CONSTRAINT fk_store_staff FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE store ADD CONSTRAINT fk_store_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- View structure for view `customer_list`
--

CREATE VIEW customer_list
AS
SELECT 
  cu.customer_id AS ID,
  cu.first_name||' '||cu.last_name AS name,
  a.address AS address,
  a.postal_code AS "zip code",
  a.phone AS phone,
  city.city AS city,
  country.country AS country,
  case when cu.active=true then 'active' else '' end AS notes,
  cu.store_id AS SID
FROM 
  customer AS cu 
JOIN  
  address AS a ON cu.address_id = a.address_id 
JOIN 
  city ON a.city_id = city.city_id
JOIN 
  country ON city.country_id = country.country_id;

--
-- View structure for view `film_list`
--
CREATE VIEW film_list
AS
SELECT 
  film.film_id AS FID,
  film.title AS title,
  film.description AS description,
  category.name AS category,
  film.rental_rate AS price,
  film.length AS length,
  film.rating AS rating,
  LIST(actor.first_name||' '||actor.last_name, ', ') AS actors
FROM 
  film 
LEFT JOIN 
  film_category ON film_category.film_id = film.film_id
LEFT JOIN 
  category ON category.category_id = film_category.category_id 
LEFT JOIN 
  film_actor ON film.film_id = film_actor.film_id 
LEFT JOIN 
  actor ON film_actor.actor_id = actor.actor_id
GROUP BY 
  film.film_id, 
  category.name, 
  film.title,
  film.description, 
  film.rental_rate, 
  film.length, 
  film.rating;

--
-- View structure for view `nicer_but_slower_film_list`
--

CREATE VIEW nicer_but_slower_film_list
AS
SELECT 
  film.film_id AS FID, 
  film.title AS title, 
  film.description AS description, 
  category.name AS category, 
  film.rental_rate AS price,
  film.length AS length, 
  film.rating AS rating, 
  LIST(
	UPPER(SUBSTRING(actor.first_name from 1 for 1))||LOWER(SUBSTRING(actor.first_name from 2 for CHAR_LENGTH(actor.first_name)))||' '||
	UPPER(SUBSTRING(actor.last_name from 1 for 1))||LOWER(SUBSTRING(actor.last_name from 2 for CHAR_LENGTH(actor.last_name))), ', ') AS actors
FROM 
  film 
LEFT JOIN 
  film_category ON film_category.film_id = film.film_id
LEFT JOIN 
  category ON category.category_id = film_category.category_id 
LEFT JOIN 
  film_actor ON film.film_id = film_actor.film_id 
LEFT JOIN 
  actor ON film_actor.actor_id = actor.actor_id
GROUP BY 
  film.film_id, 
  category.name, 
  film.title,
  film.description, 
  film.rental_rate, 
  film.length, 
  film.rating;

--
-- View structure for view `staff_list`
--

CREATE VIEW staff_list
AS
SELECT 
  s.staff_id AS ID,
  s.first_name||' '||s.last_name AS name, 
  a.address AS address, 
  a.postal_code AS "zip code",
  a.phone AS phone,
  city.city AS city, 
  country.country AS country, 
  s.store_id AS SID
FROM 
  staff AS s 
JOIN 
  address AS a ON s.address_id = a.address_id 
JOIN 
  city ON a.city_id = city.city_id
JOIN 
  country ON city.country_id = country.country_id;

--
-- View structure for view `sales_by_store`
--

CREATE VIEW sales_by_store
AS
SELECT
  c.city||','||cy.country AS store,
  m.first_name||' '||m.last_name AS manager,
  SUM(p.amount) AS total_sales
FROM 
  payment AS p
INNER JOIN 
  rental AS r ON p.rental_id = r.rental_id
INNER JOIN 
  inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN 
  store AS s ON i.store_id = s.store_id
INNER JOIN 
  address AS a ON s.address_id = a.address_id
INNER JOIN 
  city AS c ON a.city_id = c.city_id
INNER JOIN 
  country AS cy ON c.country_id = cy.country_id
INNER JOIN 
  staff AS m ON s.manager_staff_id = m.staff_id
GROUP BY 
  s.store_id, store, manager;

--
-- View structure for view `sales_by_film_category`
--
-- Note that total sales will add up to >100% because
-- some titles belong to more than 1 category
--

CREATE VIEW sales_by_film_category
AS
SELECT
  c.name AS category, 
  SUM(p.amount) AS total_sales
FROM 
  payment AS p
INNER JOIN 
  rental AS r ON p.rental_id = r.rental_id
INNER JOIN 
  inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN 
  film AS f ON i.film_id = f.film_id
INNER JOIN 
  film_category AS fc ON f.film_id = fc.film_id
INNER JOIN 
  category AS c ON fc.category_id = c.category_id
GROUP BY 
  c.name
ORDER BY 
  total_sales DESC;

--
-- View structure for view `actor_info`
--

CREATE VIEW actor_info
AS
SELECT
  a.actor_id,
  a.first_name,
  a.last_name,
  LIST(
    c.name||': '||(
	  SELECT 
	    LIST(f.title, ', ')
      FROM 
	    film f
      INNER JOIN 
	    film_category fc ON f.film_id = fc.film_id
      INNER JOIN 
	    film_actor fa ON f.film_id = fa.film_id
      WHERE 
	    fc.category_id = c.category_id AND fa.actor_id = a.actor_id
    ), '; ') AS film_info
FROM 
  actor a
LEFT JOIN 
  film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN 
  film_category fc ON fa.film_id = fc.film_id
LEFT JOIN 
  category c ON fc.category_id = c.category_id
GROUP BY 
  a.actor_id, a.first_name, a.last_name;

--
-- Procedure structure for procedure `rewards_report`
--

-- MISSING PROCEDURES: rewards_report, film_in_stock, film_not_in_stock

SET TERM ^ ;

CREATE FUNCTION get_customer_balance(p_customer_id INT, p_effective_date TIMESTAMP) 
RETURNS DECIMAL(5,2)
AS
  DECLARE v_rentfees DECIMAL(5,2); -- FEES PAID TO RENT THE VIDEOS INITIALLY
  DECLARE v_overfees INT;          -- LATE FEES FOR PRIOR RENTALS
  DECLARE v_payments DECIMAL(5,2); -- SUM OF PAYMENTS MADE PREVIOUSLY
BEGIN

   -- OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
   -- THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
   --   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
   --   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
   --   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
   --   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED

  SELECT 
    NULLIF(SUM(film.rental_rate),0) 
  FROM 
    film, inventory, rental
  WHERE 
    film.film_id = inventory.film_id AND 
	inventory.inventory_id = rental.inventory_id AND 
	rental.rental_date <= :p_effective_date AND 
	rental.customer_id = :p_customer_id 
  INTO 
    :v_rentfees;

  SELECT 
    NULLIF(SUM(IIF((DATEDIFF (DAY FROM rental.rental_date TO  rental.return_date)) > film.rental_duration,
     ((DATEDIFF (DAY FROM  rental.rental_date TO rental.return_date)) - film.rental_duration),0)),0) 
  FROM 
    rental, inventory, film
  WHERE 
    film.film_id = inventory.film_id AND 
	inventory.inventory_id = rental.inventory_id AND 
	rental.rental_date <= :p_effective_date AND 
	rental.customer_id = :p_customer_id 
  INTO :v_overfees;

  SELECT 
    NULLIF(SUM(payment.amount),0) 
  FROM 
    payment
  WHERE 
    payment.payment_date <= :p_effective_date AND 
	payment.customer_id = :p_customer_id
  INTO 
    :v_payments;

  RETURN :v_rentfees + :v_overfees - :v_payments;
  
END^

CREATE FUNCTION inventory_held_by_customer(p_inventory_id INT) RETURNS INT
AS
  DECLARE v_customer_id INT;
BEGIN

  SELECT 
    customer_id 
  FROM 
    rental
  WHERE 
    return_date IS NULL AND inventory_id = :p_inventory_id
  INTO 
    v_customer_id;

  RETURN v_customer_id;
  
END^

CREATE FUNCTION inventory_in_stock(p_inventory_id INT) RETURNS BOOLEAN
AS
  DECLARE v_rentals INT;
  DECLARE v_out     INT;
BEGIN

  -- AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
  -- FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

  SELECT 
    COUNT(*) 
  FROM 
    rental
  WHERE 
    inventory_id = :p_inventory_id
  INTO 
    :v_rentals;

  IF (:v_rentals = 0) THEN
    RETURN TRUE;

  SELECT 
    COUNT(rental_id) 
  FROM 
    inventory 
  LEFT JOIN 
    rental USING(inventory_id)
  WHERE 
    inventory.inventory_id = :p_inventory_id AND rental.return_date IS NULL
  INTO 
    :v_out;

  IF (:v_out > 0) THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
	
END^

SET TERM ; ^
