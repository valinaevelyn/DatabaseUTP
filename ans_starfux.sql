-- Import starfux.sql
CREATE DATABASE starfux;

-- 1
CREATE DATABASE starfux_promo;

-- 2
CREATE TABLE WeeklyPromo(
	WeeklyPromoID CHAR(5) PRIMARY KEY CHECK (LENGTH(WeeklyPromoID) = 5 AND WeeklyPromoID REGEXP '^WP[0-9][0-9][0-9]'),
    WeeklyPromoName VARCHAR(255) NOT NULL CHECK (LENGTH(WeeklyPromoName) > 0),
    WeeklyPromoDay INT NOT NULL,
    WeeklyPromoDiscount INT NOT NULL
);

-- 3
CREATE TABLE SeasonalPromo(
	SeasonalPromoID CHAR(5) PRIMARY KEY CHECK (LENGTH(SeasonalPromoID) = 5 AND SeasonalPromoID REGEXP '^SP[0-9][0-9][0-9]'),
    SeasonalPromoName VARCHAR(255) NOT NULL CHECK (LENGTH(SeasonalPromoName) > 0),
    SeasonalPromoStartDate DATE NOT NULL,
    SeasonalPromoEndDate DATE NOT NULL CHECK (DATEDIFF(SeasonalPromoEndDate, SeasonalPromoStartDate) > 0),
    SeasonalPromoDiscount INT NOT NULL
);

-- 4
INSERT INTO weeklypromo VALUES
	('WP001', 'TGIF', 5, 50),
    ('WP002', 'Work Day', 1, 2);
    
INSERT INTO seasonalpromo VALUES
	('SP001', 'Valentine Day', '2021-02-14', '2021-02-15', 60),
    ('SP002', 'Spring Season Celebration', '2021-03-18', '2021-04-20', 40),
    ('SP003', 'Summer Opening', '2021-06-21', '2021-07-15', 20),
    ('SP004', 'Mid Autumn Festival', '2021-09-23', '2021-10-10', 30),
    ('SP005', 'Winter Festival', '2021-12-20', '2022-01-10', 35);

-- 5
SELECT StaffID, StaffName, StaffEmail, REPLACE(StaffPhone, '+62', '0'), StaffGender, StaffSalary
FROM staff
WHERE StaffPosition = 'Barista';

-- 6
SELECT s.StaffID, s.StaffName, s.StaffPosition, o.OrderID, o.OrderDate, o.CustomerName, GROUP_CONCAT(p.ProductName SEPARATOR ', ') AS orders
FROM starfux.order o
JOIN staff s ON o.StaffID = s.StaffID
JOIN orderdetail od ON o.OrderID = od.OrderID
JOIN product p ON od.ProductID = p.ProductID
WHERE s.StaffPosition != 'Store Manager' AND DAYNAME(o.OrderDate) != 'Sunday'
GROUP BY o.OrderID ORDER BY s.StaffID;


-- 7
SELECT o.OrderID, o.OrderDate, o.CustomerName, s.StaffName, StaffPosition, sp.SeasonalPromoName, CONCAT(sp.SeasonalPromoDiscount, '%') AS 'Seasonal Discount'
FROM starfux.order o
JOIN staff s ON o.StaffID = s.StaffID
JOIN starfux_promo.seasonalpromo sp ON DATEDIFF(o.OrderDate, sp.SeasonalPromoStartDate) >= 0 AND DATEDIFF(o.OrderDate, sp.SeasonalPromoEndDate) <= 0
WHERE o.OrderType = 'Dine In' AND s.StaffPosition = 'Barista';

-- 8
UPDATE staff s
JOIN starfux.order o ON s.StaffID = o.StaffID
SET StaffSalary = StaffSalary + 50000
WHERE o.OrderType IN ('GoZek', 'GrapPood');


-- 9
DELETE FROM topping WHERE ToppingID IN(
	SELECT t.ToppingID
    FROM starfux.order o
    JOIN ordertoppingdetail ot ON o.OrderID = ot.OrderID
    JOIN topping t ON ot.ToppingID = t.ToppingID
    WHERE MONTHNAME(o.OrderDate) = 'July'
);

-- 10
DROP DATABASE starfux_promo;