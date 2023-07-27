-- 1
CREATE DATABASE chatenraise_member;

-- 2
CREATE TABLE SubscriptionType(
	SubscriptionTypeID CHAR(6) PRIMARY KEY NOT NULL CHECK (LENGTH(SubscriptionTypeID) = 6 AND SubscriptionTypeID REGEXP '^SUB[0-9][0-9][0-9]'),
    SubscriptionTypeName VARCHAR(100) NOT NULL,
   	DiscountPercentage INT NOT NULL CHECK (DiscountPercentage > 0)
);

-- 3
CREATE TABLE SubscriptionUser(
	UserID CHAR(5) PRIMARY KEY NOT NULL CHECK (LENGTH(UserID) = 5 AND UserID REGEXP '^CU[0-9][0-9][0-9]'),
    SubscriptionTypeID CHAR(6) NOT NULL,
    StartDate DATE NOT NULL,
   	EndDate DATE NOT NULL,
    FOREIGN KEY (SubscriptionTypeID) REFERENCES subscriptiontype(SubscriptionTypeID) ON UPDATE CASCADE ON DELETE CASCADE                                           	
);

-- 4
INSERT INTO subscriptiontype VALUES
	('SUB001', 'Epic', 2),
    ('SUB002', 'Legend', 5),
    ('SUB003', 'Mythic', 10);
    
INSERT INTO subscriptionuser VALUES
	('CU001', 'SUB001', '2022-07-10', '2023-01-10'),
    ('CU005', 'SUB002', '2022-07-15', '2023-10-10'),
    ('CU007', 'SUB003', '2022-07-20', '2023-07-10');

-- 5
SELECT CakeName, CakeDescription, CakePrice 
FROM mscake
WHERE CakeDescription LIKE '% % % %';

-- 6
SELECT mc.CustomerName, REPLACE(mc.CustomerPhone, '08', '+62') AS CustomerPhone, ms.StaffName, msp.StaffPositionName, DATE_FORMAT(mt.TransactionDate, '%b') AS TransactionMonth
FROM mstransaction mt 
JOIN mscustomer mc ON mt.CustomerID = mc.CustomerID
JOIN msstaff ms ON mt.StaffID = ms.StaffID
JOIN msstaffposition msp ON ms.StaffPositionID = msp.StaffPositionID
WHERE CustomerName LIKE '% %' AND StaffSalary > 2000000;

-- 7
SELECT mc.CustomerName, st.SubscriptionTypeName, mt.TransactionDate, su.StartDate, su.EndDate, st.DiscountPercentage
FROM mstransaction mt
JOIN mscustomer mc ON mt.CustomerID = mc.CustomerID
JOIN chatenraise_member.subscriptionuser su ON mc.CustomerID = su.UserID
JOIN chatenraise_member.subscriptiontype st ON su.SubscriptionTypeID = st.SubscriptionTypeID
WHERE st.SubscriptionTypeName IN ('Legend', 'Mythic') AND MONTH(mt.TransactionDate) = 7;

-- 8
UPDATE mscustomer mc 
JOIN mstransaction mt ON mc.CustomerID = mt.CustomerID
SET mc.CustomerName = 'Erwin Setiawan Wijaya' WHERE DATEDIFF(mt.TransactionDate, '2022-08-10') = 2;

-- 9
DELETE FROM msstaff WHERE StaffID IN(
    SELECT ms.StaffID
    FROM mstransaction mt
    JOIN msstaff ms ON mt.StaffID = ms.StaffID
    WHERE DATEDIFF(mt.TransactionDate, '2022-06-10') = 30
);

-- 10
DROP DATABASE chatenraise;