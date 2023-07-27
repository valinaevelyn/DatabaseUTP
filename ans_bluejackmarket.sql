-- Import bluejackmarket.sql
CREATE DATABASE bluejackmarket;

-- 1
CREATE DATABASE bluejackmarket_promotoko;

-- 2
CREATE TABLE SeasonPromo(
	id CHAR(5) PRIMARY KEY CHECK (LENGTH(id) = 5 AND id REGEXP '^SP[0-9][0-9][0-9]'),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    promo_name VARCHAR(255) NOT NULL CHECK (LENGTH(promo_name) > 0),
    discount INT NOT NULL                                        
);

-- 3
CREATE TABLE ProductPromo(
	id INT PRIMARY KEY AUTO_INCREMENT,
    product_id CHAR(5) NOT NULL,
    discount INT NOT NULL
);

-- 4
INSERT INTO seasonpromo VALUES
	('SP001', '2022-01-01', '2022-01-07', 'New Year Week', 30),
    ('SP002', '2022-02-14', '2022-02-21', 'Valentine Week', 25),
    ('SP003', '2022-03-01', '2022-03-07', 'Spring Week Festival', 10),
    ('SP004', '2022-06-01', '2022-06-07', 'Summer Week Festival', 12),
    ('SP005', '2022-09-01', '2022-09-07', 'Autumn Week Festival', 15),
    ('SP006', '2022-12-01', '2022-12-07', 'Winter Week Festival', 17);
    
-- 5
ALTER TABLE seasonpromo ADD CONSTRAINT CHECK (DATEDIFF(end_date, start_date) > 0);
ALTER TABLE productpromo ADD CONSTRAINT CHECK (discount > 0);

-- 6
INSERT INTO productpromo VALUES
	(NULL, 'PX001', 10),
    (NULL, 'PR002', 15),
    (NULL, 'PR004', 20),
    (NULL, 'PZ007', 5);

-- 7
SELECT c.customer_name, c.customer_email, DATE_FORMAT(t.date, "%D, %e %M %Y"), t.order_type, GROUP_CONCAT(p.product_name SEPARATOR ', ')
FROM bluejackmarket.transaction t
JOIN customer c ON t.customer_id = c.id
JOIN transactiondetail td ON t.id = td.transaction_id
JOIN product p ON td.product_id = p.id
GROUP BY t.id 

-- 8
SELECT s.staff_name, s.staff_email, sp.staff_position_name
FROM staff s
JOIN staffposition sp ON s.staff_position = sp.id
WHERE s.id NOT IN (SELECT t.staff_id FROM bluejackmarket.transaction t);

-- 9
SELECT p.id, p.product_name, CONCAT("Rp.", p.product_price) AS Price, c.category_name
FROM product p 
JOIN category c ON p.product_category_id = c.id;

-- 10
SELECT p.id, p.product_name, p.product_price, pp.discount, CAST(p.product_price - (p.product_price * pp.discount/100) AS INT) AS "new price"
FROM product p
JOIN bluejackmarket_promotoko.productpromo pp ON p.id = pp.product_id;

-- 11
SELECT c.customer_name, c.customer_email, t.order_type, sp.promo_name, CONCAT(sp.discount, "%")
FROM bluejackmarket.transaction t
JOIN customer c ON t.customer_id = c.id
JOIN bluejackmarket_promotoko.seasonpromo sp ON DATEDIFF(t.date, sp.start_date) >= 0 AND DATEDIFF(t.date, sp.end_date) <= 0;

-- 12
UPDATE product p
JOIN category c ON p.product_category_id = c.id
SET product_price = product_price + (product_price * 0.1)
WHERE c.category_name = 'Main Course';

-- 13
DELETE FROM customer
WHERE customer_name NOT LIKE '% %';

