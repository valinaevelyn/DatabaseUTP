-- Import lademy.sql
CREATE DATABASE lademy;

-- 1
CREATE DATABASE lademy_subscription;

drop table subscription;
drop table membership;

-- 2
CREATE TABLE subscription(
	SubscriptionID CHAR(5) PRIMARY KEY CHECK (LENGTH(SubscriptionID) = 5 AND SubscriptionID REGEXP '^SC[0-9][0-9][0-9]'),
    ParticipantID CHAR(5),
    StartSubscription DATE NOT NULL,
    EndSubscription DATE CHECK (DATEDIFF(EndSubscription, StartSubscription) >= 30), 
    FOREIGN KEY(ParticipantID) REFERENCES lademy.participant(ParticipantID) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 3
CREATE TABLE membership(
	MembershipID CHAR(5) PRIMARY KEY CHECK (LENGTH(MembershipID) = 5 AND MembershipID REGEXP '^ME[0-9][0-9][0-9]'),
    ParticipantID CHAR(5),
    MemberPoint INT CHECK (MemberPoint % 2 = 0),
    JoinDate DATE CHECK (YEAR(JoinDate) < 2023),
    FOREIGN KEY (ParticipantID) REFERENCES lademy.participant(ParticipantID) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 4
INSERT INTO subscription VALUES
	('SC001', 'PT006', '2021-05-09', '2021-07-09'),
    ('SC002', 'PT001', '2021-08-10', '2022-01-10'),
    ('SC003', 'PT009', '2022-01-05', '2022-03-05');
    
INSERT INTO membership VALUES
	('ME001', 'PT004', 12, '2021-08-02'),
    ('ME002', 'PT007', 6, '2022-02-05'),
    ('ME003', 'PT005', 20, '2022-04-07');

-- 5
SELECT c.CourseName, cc.CourseCategoryName, CONCAT('Rp ', c.CoursePrice) 
FROM course c JOIN coursecategory cc ON c.CourseCategoryID = cc.CourseCategoryID
WHERE c.AmountOfSession >= 10;

-- 6
SELECT p.ParticipantName, DATE_FORMAT(th.TransactionDate, "%M %D, %Y") AS TransactionDate, c.CourseName 
FROM transactiondetail td 
JOIN course c ON td.CourseID = c.CourseID
JOIN transactionheader th ON td.TransactionID = th.TransactionID
JOIN participant p ON th.ParticipantID = p.ParticipantID
WHERE LENGTH(c.CourseName) > 20 AND CAST(RIGHT(c.CourseID, 1) AS INT) % 2 = 0;

-- 7
SELECT SUBSTRING(p.ParticipantName, 1, POSITION(' ' IN p.ParticipantName) - 1) AS ParticipantName, p.ParticipantEmail, p.ParticipantGender, th.TransactionDate, m.MemberPoint
FROM transactiondetail td
JOIN transactionheader th ON td.TransactionID = th.TransactionID
JOIN participant p ON th.ParticipantID = p.ParticipantID
JOIN lademy_subscription.membership m ON p.ParticipantID = m.ParticipantID
WHERE MONTH(th.TransactionDate) = 8 AND m.MemberPoint > 15;

-- 8
UPDATE tutor t 
JOIN course c ON t.TutorID = c.CourseTutorID
SET TutorEmail = CONCAT(LEFT(TutorEmail, POSITION('@' IN TutorEmail) - 1), '@lademy.co.id')
WHERE c.CourseCategoryID IN ('CRT04');

-- 9
DELETE FROM participant WHERE ParticipantID IN (
    SELECT th.ParticipantID FROM transactionheader th 
    JOIN participant p ON th.ParticipantID = p.ParticipantID
    WHERE DAYNAME(th.TransactionDate) = 'Sunday'
);

-- 10
DROP DATABASE lademy_subscription;