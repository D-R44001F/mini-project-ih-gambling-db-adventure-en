/* Mini Project | The Ironhack Gambling Database Adventure

Challenge Format
	-The challenge starts with simple queries and gradually increases in complexity.
	-For each question, write your SQL query to find the answer.
	-Although the original data is in Excel, 
	 focus only on writing SQL queries as if the data were in a SQL database. 
	 Whether you test it in MySQL or not is up to you.
*/

-- Questions:
-- Question 01: Using the customer table or tab, please write an SQL query that shows Title, 
-- First Name and Last Name and Date of Birth for each of the customers.

SELECT FirstName, LastName, DateOfBirth FROM Customer;

-- Question 02: Using customer table or tab, please write an SQL query that shows the number 
-- of customers in each customer group (Bronze, Silver & Gold). I can see visually that there 
-- are 4 Bronze, 3 Silver and 3 Gold but if there were a million customers how would I do this in Excel?

SELECT CustomerGroup, COUNT(*) AS CustomerCount
FROM customer
GROUP BY CustomerGroup;

--Question 03: The CRM manager has asked me to provide a complete list of all data for those customers in 
--the customer table but I need to add the currencycode of each player so she will be able to send the 
--right offer in the right currency. Note that the currencycode does not exist in the customer table but 
--in the account table. Please write the SQL that would facilitate this.

SELECT customer.*, account.CurrencyCode
FROM customer
INNER JOIN account ON account.CustId = costumer.CustId;

--Question 4: Now I need to provide a product manager with a summary report that shows, by product and by
--day how much money has been bet on a particular product. PLEASE note that the transactions are stored in 
--the betting table and there is a product code in that table that is required to be looked up 
--(classid & categortyid) to determine which product family this belongs to. Please write the SQL that would provide the report.
SELECT 
	product.product, 
	betting.BetDate, 
	SUM(Bet_Amt) as "Bet Amount"
FROM 
	product
INNER JOIN
	betting ON betting.ClassId = product.classid
	AND
	betting.CategoryId = product.CategoryId
GROUP by
	product.product,
	betting.BetDate;
Order by
	product.product,
	betting.BetDate;

--Question 5: You’ve just provided the report from question 4 to the product manager, now he has emailed me and wants it changed. 
--Can you please amend the summary report so that it only summarizes transactions that occurred on or after 1st November 
--and he only wants to see Sportsbook transactions.Again, please write the SQL below that will do this.
SELECT 
	product.product, 
	betting.BetDate, 
	SUM(Bet_Amt) as "Bet Amount"
FROM 
	product
INNER JOIN
	betting ON betting.ClassId = product.classid
	AND
	betting.CategoryId = product.CategoryId
WHERE
	product.product = "Sportsbook"
AND
	betting.betDate >= "11/01/2012"
GROUP by
	product.product,
	betting.BetDate;
Order by
	product.product,
	betting.BetDate;
	
--Question 06: As often happens, the product manager has shown his new report to his director and now he also wants different version 
--of this report. This time, he wants the all of the products but split by the currencycode and customergroup of the customer, rather than 
--by day and product. He would also only like transactions that occurred after 1st December. Please write the SQL code that will do this.
SELECT 
	product.*,
	account.CurrencyCode,
	customer.CustomerGroup,
	SUM(Bet_Amt) as "Bet Amount"
FROM
	product
INNER JOIN
	betting ON betting.ClassId = product.ClassId
	AND
	betting.CategoryId = product.CategortyId
INNER JOIN
	account ON betting.AccountId = account.AccountId
INNER JOIN 
	customer on account.CustId = customer.CustId
WHERE
	betting.BetDate > "12/01/2012"
GROUP by
	product.Product,
	account.currencycode,
	customer.CustomerGroup
Order by
	account.currencycode,
	CustomerGroup;
	
--Question 07: Our VIP team have asked to see a report of all players regardless of whether they have done 
--anything in the complete timeframe or not. In our example, it is possible that not all of the players have
--been active. Please write an SQL query that shows all players Title, First Name and Last Name and a 
--summary of their bet amount for the complete period of November.
SELECT 
	customer.title,
	customer.FirstName,
	customer.LastName,
	SUM(betting.Bet_Amt)
FROM
	Customer
LEFT JOIN
	account ON account.CustId = customer.CustId
LEFT JOIN
	betting ON betting.AccountNO = account.AccountNO
WHERE
	betting.BetDate >= "11/01/2012" AND betting.BetDate <= "11/31/2012";
GROUP by
	customer.title,
	customer.FirstName,
	customer.LastName
Order by
	customer.FirstName,
	customer.LastName;

--Question 08: Our marketing and CRM teams want to measure the number of players who play more than one 
--product. Can you please write 2 queries, one that shows the number of products per player and another 
--that shows players who play both Sportsbook and Vegas.
SELECT 
	customer.CustId,
	COUNT(product.product)
FROM
	customer
INNER JOIN
	account on account.CustId = customer.CustId	
INNER JOIN
	betting ON betting.AccountNO = account.AccountNO
INNER JOIN
	product ON betting.ClassId = product.ClassId
Group by
	customer.CustId,
ORDER by
	customer.CustId;
	
--Query 2
SELECT 
    customer.CustId
FROM 
    customer
INNER JOIN 
    account ON account.CustId = customer.CustId
INNER JOIN 
    betting ON betting.AccountNO = account.AccountNO
INNER JOIN 
    product ON betting.ClassId = product.ClassId
WHERE 
    product.ProductType IN ('Sportsbook', 'Vegas')
GROUP BY 
    customer.CustId
HAVING 
    COUNT(DISTINCT product.ProductType) = 2;

	
--Question 09: Now our CRM team want to look at players who only play one product, please write SQL code 
--that shows the players who only play at sportsbook, use the bet_amt > 0 as the key. Show each player and 
--the sum of their bets for both products.
SELECT 
    customer.CustId,
    SUM(CASE WHEN product.ProductType = 'Sportsbook' THEN betting.Bet_Amt ELSE 0 END) AS "Sportsbook Bet Sum",
    SUM(CASE WHEN product.ProductType != 'Sportsbook' THEN betting.Bet_Amt ELSE 0 END) AS "Other Product Bet Sum"
FROM 
    customer
INNER JOIN 
    account ON account.CustId = customer.CustId
INNER JOIN 
    betting ON betting.AccountNO = account.AccountNO
INNER JOIN 
    product ON betting.ClassId = product.ClassId
WHERE 
    betting.Bet_Amt > 0
GROUP BY 
    customer.CustId
HAVING 
    COUNT(DISTINCT product.ProductType) = 1 
    AND MAX(product.ProductType) = 'Sportsbook'
ORDER BY 
    customer.CustId;

--Question 10: The last question requires us to calculate and determine a player’s favorite product. 
--This can be determined by the most money staked. Please write a query that will show each players 
--favorite product.
SELECT 
    customer.CustId,
    product.ProductType AS "Favorite Product",
    SUM(betting.Bet_Amt) AS "Bet Total"
FROM 
    customer
INNER JOIN 
    account ON account.CustId = customer.CustId
INNER JOIN 
    betting ON betting.AccountNO = account.AccountNO
INNER JOIN 
    product ON betting.ClassId = product.ClassId
GROUP BY 
    customer.CustId, product.product
ORDER BY 
    customer.CustId, SUM(betting.Bet_Amt) DESC;
	
--Question 11: Write a query that returns the top 5 students based on GPA.
SELECT 
	student_name,
	GPA
FROM 
	Student_School
ORDER By
	GPA DESC
LIMIT 5;

--Question 12: Write a query that returns the number of students in each school. 
--(a school should be in the output even if it has no students!).
SELECT
	COUNT(student.student_id) as "Number of Students",
	school.school_name as "School"
FROM
	student
LEFT JOIN
	school ON school.school_id = student.school_id
GROUP By
	school.school_id,
	school.school_name
Order By
	school.school_name;
	

--Question 13: Write a query that returns the top 3 GPA students' name from each university.
SELECT
	student.student_name AS "Student",
	school.school_name AS "School"
FROM
	student
INNER JOIN
	school ON school.school_id = student.school_id
WHERE 
	(SELECT COUNT(*)
     FROM student AS s
     WHERE s.school_id = student.school_id AND s.GPA > student.GPA) < 3	
ORDER By
	school.school_name,
	GPA DESC;