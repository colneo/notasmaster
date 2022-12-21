-- Active: 1671624843500@@127.0.0.1@5432@postgres
SELECT *
FROM fortune500
-- para verrificar missing values en la tabla
-- para ver missing values por columna 
SELECT COUNT(*) - COUNT(ticker) missing
FROM fortune500

--
SELECT COUNT(*) - COUNT(profits_change) missing
FROM fortune500
--
SELECT COUNT(*) - COUNT(industry) missing
FROM fortune500

-- join dos tablas sin relacion 
SELECT *
FROM fortune500

SELECT * 
FROM company 
--- sabiendo las fields de las compañias solo usa las que estan relacionadas.
SELECT *
FROM company
JOIN fortune500
USING(ticker)

/*The information you need is sometimes split across multiple tables in the database.

What is the most common stackoverflow tag_type? What companies have a tag of that type?

To generate a list of such companies, you'll need to join three tables together.

Reference the entity relationship diagram as needed when determining which columns to use when joining tables*/

-- Count the number of tags with each type
SELECT type, COUNT(tag) AS count
  FROM tag_type
 -- To get the count for each type, what do you need to do?
 GROUP BY type
 -- Order the results with the most common
 -- tag types listed first
 ORDER BY count DESC;


 --AFTER
/*The coalesce() function can be useful for specifying a default or backup value when a column contains NULL values.

coalesce() checks arguments in order and returns the first non-NULL value, if one exists.

coalesce(NULL, 1, 2) = 1
coalesce(NULL, NULL) = NULL
coalesce(2, 3, NULL) = 2
In the fortune500 data, industry contains some missing values. 
Use coalesce() to use the value of sector as the industry when industry is NULL. 
Then find the most common industry.*/

 -- Use coalesce
SELECT coalesce(industry, sector, 'Unknown') AS industry2,
       -- Don't forget to count!
       count(*) 
  FROM fortune500 
-- Group by what? (What are you counting by?)
 GROUP BY industry2
-- Order results to see most common first
 ORDER BY count DESC
-- Limit results to get just the one value you want
 LIMIT 1;


 -----
/*you previously joined the company and fortune500 tables to find out which companies are in both tables. 
Now, also include companies from company that are subsidiaries of Fortune 500 companies as well.

To include subsidiaries, you will need to join company to itself to associate a subsidiary with its parent company's information. 
To do this self-join, use two different aliases for company.

coalesce will help you combine the two ticker columns in the result of the self-join to join to fortune500.*/

 SELECT company_original.name, fortune500.title, fortune500.rank
  -- Start with original company information
  FROM company AS company_original
       -- Join to another copy of company with parent
       -- company information
	   LEFT JOIN company AS company_parent
       ON company_original.parent_id = company_parent.parent_id 
       -- Join to fortune500, only keep rows that match
       INNER JOIN fortune500 
       -- Use parent ticker if there is one, 
       -- otherwise original ticker
       ON coalesce(company_original.ticker, 
                   company_parent.ticker) = 
             fortune500.ticker
 -- For clarity, order by rank
 ORDER BY rank; 

