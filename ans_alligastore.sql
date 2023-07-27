-- 1
CREATE DATABASE alligastore_database;

-- 2
CREATE TABLE orders(
	OrderID CHAR(5) PRIMARY KEY CHECK (LENGTH(OrderID) = 5 AND OrderID REGEXP '^OD[0-9][0-9][0-9]'),
    CustomerID CHAR(5),
    OrderDate DATE NOT NULL,
    TotalAmount INT NOT NULL CHECK (TotalAmount >= 0),
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 3
CREATE TABLE orderitems(
	OrderItemID CHAR(5) PRIMARY KEY CHECK (LENGTH(OrderItemID) = 5 AND OrderItemID REGEXP '^OI[0-9][0-9][0-9]'),
    OrderID CHAR(5),
    BookID CHAR(5),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (BookID) REFERENCES books(BookID) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 4
ALTER TABLE books ADD CONSTRAINT CHECK (PublicationYear > 1800 AND PublicationYear < 2023);

-- 5
INSERT INTO orders VALUES
	('OD001', 'CU001', '2023-07-26', 4599),
    ('OD002', 'CU002', '2023-07-25', 3250),
    ('OD003', 'CU003', '2023-07-24', 1575),
    ('OD004', 'CU004', '2023-07-23', 2730),
    ('OD005', 'CU005', '2023-07-22', 5120);

INSERT INTO orderitems VALUES
	('OI001', 'OD001', 'BO001', 2),
    ('OI002', 'OD001', 'BO003', 1),
    ('OI003', 'OD002', 'BO002', 1),
    ('OI004', 'OD003', 'BO001', 1),
    ('OI005', 'OD003', 'BO003', 3),
    ('OI006', 'OD004', 'BO003', 2),
    ('OI007', 'OD005', 'BO001', 3),
    ('OI008', 'OD005', 'BO002', 2);
    
-- 6
SELECT b.Title, a.AuthorName, b.ISBN, g.GenreName, b.PublicationYear
FROM authorsbooks ab
JOIN books b ON ab.BookID = b.BookID
JOIN alligastore_database.authors a ON ab.AuthorID = a.AuthorID
JOIN genres g ON b.GenreID = g.GenreID;

-- 7
UPDATE books
SET Price = price + (price * 0.1)
WHERE PublicationYear < 2000;

-- 8
SELECT c.CustomerID, CONCAT(c.FirstName, ' ', c.LastName) AS FullName, o.TotalAmount AS TotalSpent
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID;

-- 9
SELECT b.BookID, b.Title, a.AuthorName, g.GenreName, COUNT(oi.OrderItemID) AS TotalOrders
FROM authorsbooks ab
JOIN alligastore_database.authors a ON ab.AuthorID = a.AuthorID
JOIN books b ON ab.BookID = b.BookID
JOIN orderitems oi ON b.BookID = oi.BookID
JOIN genres g ON b.GenreID = g.GenreID
WHERE GenreName = 'Mystery';

-- 10
SELECT * FROM orders
WHERE DATE_ADD(OrderDate, INTERVAL 5 DAY);

-- 11
SELECT Title, CONCAT(LEFT(books.ISBN, 3), SUBSTRING(authors.AuthorName, POSITION(' ' IN authors.AuthorName) + 1, 1), RIGHT(books.ISBN, 3)) AS GeneratedCode
FROM authorsbooks
JOIN books ON authorsbooks.BookID = books.BookID
JOIN authors ON authorsbooks.AuthorID = authors.AuthorID;

-- 12
SELECT CONCAT(MONTHNAME(OrderDate), ' ', YEAR(OrderDate)), SUM(TotalAmount) AS TotalSales
FROM orders
WHERE YEAR(OrderDate) = 2023
GROUP BY CONCAT(MONTHNAME(OrderDate), YEAR(OrderDate));

-- 13
SELECT OrderID, DATE_FORMAT(DATE_ADD(OrderDate, INTERVAL 7 DAY), "%W, %M %D %Y") AS UpdatedOrderDate
FROM orders;

-- 14
DELETE FROM orders
WHERE RIGHT(TotalAmount, 1) = 0;

-- 15
DELETE FROM orders
WHERE TotalAmount < 2000;

-- 16
DROP DATABASE alligastore_database;