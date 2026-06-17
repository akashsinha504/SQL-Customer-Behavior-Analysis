
CREATE DATABASE customer_behaviour_analysis;

USE customer_behaviour_analysis;

## Creating table structure. 

CREATE TABLE customers (
    customersmer_id VARCHAR(20),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    currency VARCHAR(10),
    age VARCHAR(10),
    gender VARCHAR(20),
    registration_date VARCHAR(30),
    is_premium VARCHAR(10),
    email_verified VARCHAR(10),
    email VARCHAR(150)
);

## Loaded data through import data wizard.

## View Data in table.

  SELECT * 
	FROM customers;

## 01. What is the total number of customers ?
 
 SELECT COUNT(*) AS total_customers
	FROM customers;

## 02. How many countries are there ?

 SELECT DISTINCT country AS country_name
	FROM customers;
    
## 03. Find out the gender distribution.

 SELECT DISTINCT gender,
 (SELECT COUNT(gender)
	FROM customers
    WHERE gender= "M"),
    (SELECT COUNT(gender)
	FROM customers
    WHERE gender= "F"),
    (SELECT COUNT(gender)
	FROM customers
    WHERE gender= "Other")
    From customers;
    
SELECT
    gender,
    COUNT(*) AS total_customers
FROM customers
	GROUP BY gender
	ORDER BY total_customers DESC;
        
## 04. How many customers are premium and how many are non-premium.

 SELECT is_premium AS Premium,
	COUNT(is_premium) AS Number_of_premium_customers
FROM customers
	GROUP BY (is_premium);
        
## 05. Findout the email verification status.
	
SELECT
    email_verified,
    COUNT(*) AS customers
FROM customers
	GROUP BY (email_verified);

## 06. Calculate the age statistics.

SELECT
    MIN(age) AS youngest_customer,
    MAX(age) AS oldest_customer,
    AVG(age) AS average_age
FROM customers;

## 07. Which are the top countries having highest customers.

SELECT
    country,
    COUNT(*) AS customers
FROM customers
	GROUP BY country
	ORDER BY customers DESC;
    
## 08. Customer Age Segmentation

SELECT
CASE
    WHEN CAST(age AS UNSIGNED) BETWEEN 18 AND 25 THEN 'Young'
    WHEN CAST(age AS UNSIGNED) BETWEEN 26 AND 40 THEN 'Adult'
    WHEN CAST(age AS UNSIGNED) BETWEEN 41 AND 60 THEN 'Middle Age'
    ELSE 'Senior'
END AS age_group,
COUNT(*) AS customers
FROM customers
GROUP BY age_group
ORDER BY customers DESC;


## 09. Premium Customers by Country

SELECT
country,
COUNT(*) AS premium_customers
FROM customers
WHERE is_premium = 'TRUE'
GROUP BY country
ORDER BY premium_customers DESC;

## 10. Verification Rate by Country

SELECT
country,
ROUND(
SUM(
CASE
WHEN email_verified='TRUE' THEN 1
ELSE 0
END
)*100/COUNT(*),2) AS verification_rate
FROM customers
GROUP BY country
ORDER BY verification_rate DESC;

## 11. Average Age by Gender

SELECT
gender,
ROUND(AVG(CAST(age AS UNSIGNED)),2) AS average_age
FROM customers
GROUP BY gender;

## 12. Check Duplicate Emails

SELECT
email,
COUNT(*) AS duplicate_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;


## 13. Check Invalid Ages

SELECT *
FROM customers
WHERE CAST(age AS UNSIGNED) < 18
OR CAST(age AS UNSIGNED) > 100;

## 14. Rank Countries by Customer Count

SELECT
country,
COUNT(*) AS total_customers,
RANK() OVER(
ORDER BY COUNT(*) DESC
) AS country_rank
FROM customers
GROUP BY country;

## 15. Rank Countries by Premium Customers

SELECT
country,
COUNT(*) AS premium_customers,
DENSE_RANK() OVER(
ORDER BY COUNT(*) DESC
) AS premium_rank
FROM customers
WHERE is_premium='TRUE'
GROUP BY country;

## 16. Countries with More Than 500 Customers

WITH country_customers AS
(
SELECT
country,
COUNT(*) AS total_customers
FROM customers
GROUP BY country
)

SELECT *
FROM country_customers
WHERE total_customers > 500;

## 17. Premium Percentage by Country

SELECT
    country,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_premium = 'TRUE' THEN 1 ELSE 0 END) AS premium_customers,
    ROUND(SUM(CASE WHEN is_premium = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS premium_percentage
FROM customers
GROUP BY country
ORDER BY premium_percentage DESC;

## 18. Customer Registration Trend by Year

SELECT
    YEAR(STR_TO_DATE(registration_date, '%d-%m-%Y')) AS registration_year,
    COUNT(*) AS total_registrations
FROM customers
GROUP BY registration_year
ORDER BY registration_year;

## 19. Monthly Customer Registration Trend

SELECT
    DATE_FORMAT(STR_TO_DATE(registration_date, '%d-%m-%Y'), '%Y-%m') AS registration_month,
    COUNT(*) AS total_registrations
FROM customers
GROUP BY registration_month
ORDER BY registration_month;

## 20. Top 5 Countries by Customer Share
SELECT
    country,
    COUNT(*) AS customers,
    ROUND(COUNT(*) * 100.0 /
    (SELECT COUNT(*) FROM customers),2) AS customer_share_percentage
FROM customers
GROUP BY country
ORDER BY customers DESC;

## 21. Premium Vs Non Premium

SELECT
    is_premium,
    COUNT(*) AS customers,
    ROUND(COUNT(*) * 100.0 /
    (SELECT COUNT(*) FROM customers),2) AS percentage
FROM customers
GROUP BY is_premium;

## 22. Email Verification Percentage

SELECT
    email_verified,
    COUNT(*) AS customers,
    ROUND(COUNT(*) * 100.0 /
    (SELECT COUNT(*) FROM customers),2) AS percentage
FROM customers
GROUP BY email_verified;


