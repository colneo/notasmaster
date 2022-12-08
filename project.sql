
/*FIRST PART*/
#crate TABLE forestation
CREATE VIEW forestation
AS
SELECT r.*,l.year, COALESCE(f.forest_area_sqkm, 0) forest_area_sqkm,  
COALESCE((l.total_area_sq_mi * 2.59), 0) total_area_sqkm,
COALESCE(((f.forest_area_sqkm/(l.total_area_sq_mi * 2.59))*100), 0) percent_forest_area
FROM regions r
JOIN land_area l
ON r.country_code = l.country_code
JOIN forest_area f
ON l.country_code = f.country_code 
AND
l.year = f.year


/*
a. What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.
b. What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”
*/
SELECT country_name, year, forest_area_sqkm 
FROM forestation
WHERE country_name LIKE 'World' AND year IN (1990, 2016)

/*c. What was the change (in sq km) in the forest area of the world from 1990 to 2016?
*/
SELECT country_name,
        ((SELECT forest_area_sqkm
         FROM forestation 
        WHERE year= 1990 AND country_name LIKE 'World') 
               - 
        (SELECT forest_area_sqkm
        FROM forestation 
        WHERE year= 2016 AND country_name LIKE 'World')) change_1990_to_2016
FROM forestation
GROUP BY country_name
HAVING country_name = 'World'      

/*d. What was the percent change in forest area of the world between 1990 and 2016?*/
SELECT country_name, 
ROUND((100-(((SELECT percent_forest_area 
      FROM forestation 
      WHERE year = 2016 AND country_name='World') 
                       / 
      (SELECT percent_forest_area 
      FROM forestation 
      WHERE year = 1990 AND country_name='World')))*100)::numeric, 2) dif_percent_between_1990_2016
FROM forestation
GROUP BY country_name
HAVING country_name= 'World'   
   
/*e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?*/             
SELECT country_name, year, total_area_sqkm
FROM forestation
WHERE year = 2016 AND total_area_sqkm < 
                                       ((SELECT forest_area_sqkm
                                         FROM forestation 
                                        WHERE year= 1990 AND country_name LIKE 'World')
                                                         - 
                                        (SELECT forest_area_sqkm
                                         FROM forestation 
                                         WHERE year= 2016 AND country_name LIKE 'World')) 
ORDER BY total_area_sqkm DESC
LIMIT 1

/*2. REGIONAL OUTLOOK*/
#crate TABLE 
CREATE VIEW percent_forest
AS
SELECT r.region r_name ,l.year n_year, 
COALESCE((SUM(f.forest_area_sqkm)/(SUM(l.total_area_sq_mi * 2.59))*100), 0) percent_forest_area
FROM regions r
JOIN land_area l
ON r.country_code = l.country_code
JOIN forest_area f
ON l.country_code = f.country_code 
AND
l.year = f.year
GROUP BY r_name, n_year


/*a. What was the percent forest of the entire world in 2016?*/
 SELECT r_name ,n_year, ROUND( percent_forest_area::numeric, 2) percent_forest_world
FROM percent_forest
WHERE n_year = 2016 AND r_name LIKE 'World'
 
/*Which region had the HIGHEST percent forest in 2016*/
 SELECT r_name ,n_year, ROUND( percent_forest_area::numeric, 2) percent_forest_highest
FROM percent_forest
WHERE n_year = 2016 AND r_name NOT LIKE 'World'
ORDER BY percent_forest_area DESC 
LIMIT 1
/*and which had the LOWEST, to 2 decimal places?*/
SELECT r_name ,n_year, ROUND( percent_forest_area::numeric, 2) percent_forest_lowest
FROM percent_forest
WHERE n_year = 2016 AND r_name NOT LIKE 'World'
ORDER BY percent_forest_area  
LIMIT 1

/* b. What was the percent forest of the entire world in 1990? */
 SELECT r_name ,n_year, ROUND( percent_forest_area::numeric, 2) percent_forest_world
FROM percent_forest
WHERE n_year = 1990 AND r_name LIKE 'World'
/*Which region had the HIGHEST percent forest in 1990,*/ 
 SELECT r_name ,n_year, ROUND( percent_forest_area::numeric, 2) percent_forest_highest
FROM percent_forest
WHERE n_year = 1990 AND r_name NOT LIKE 'World'
ORDER BY percent_forest_area DESC 
LIMIT 1
/*and which had the LOWEST, to 2 decimal places?*/
 SELECT r_name ,n_year, ROUND( percent_forest_area::numeric, 2) percent_forest_lowest
FROM percent_forest
WHERE n_year = 1990 AND r_name NOT LIKE 'World'
ORDER BY percent_forest_area 
LIMIT 1

/*c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?*/
WITH forest_area_1
        AS
        (SELECT r_name rn_1, n_year ny_1, ROUND( percent_forest_area::numeric, 2) percent_forest_1
        FROM percent_forest
        WHERE n_year = 1990 AND r_name NOT LIKE 'World'),
        
     forest_area_2 
         AS
        (SELECT r_name rn_2, n_year ny_2, ROUND( percent_forest_area::numeric, 2) percent_forest_2
        FROM percent_forest
        WHERE n_year = 2016 AND r_name NOT LIKE 'World')
SELECT f2.rn_2 region, f1.percent_forest_1 percent_forest_1990,  f2.percent_forest_2 percent_forest_2016,
       (f1.percent_forest_1 - f2.percent_forest_2) total_percent_lost
FROM forest_area_1 f1
JOIN forest_area_2 f2
ON f1.rn_1 = f2.rn_2 
GROUP BY region, percent_forest_1990, percent_forest_2016
HAVING f2.percent_forest_2 < f1.percent_forest_1
ORDER BY percent_forest_1990 DESC 


/* to show report*/
WITH forest_area_1
        AS
        (SELECT r_name rn_1, n_year ny_1, ROUND( percent_forest_area::numeric, 2) percent_forest_1
        FROM percent_forest
        WHERE n_year = 1990 ),
     forest_area_2 
        AS
        (SELECT r_name rn_2, n_year ny_2, ROUND( percent_forest_area::numeric, 2) percent_forest_2
        FROM percent_forest
        WHERE n_year = 2016 )
SELECT f2.rn_2 region, f1.percent_forest_1 percent_forest_1990,  f2.percent_forest_2 percent_forest_2016
FROM forest_area_1 f1
JOIN forest_area_2 f2
ON f1.rn_1 = f2.rn_2 
GROUP BY region, percent_forest_1990, percent_forest_2016
ORDER BY percent_forest_1990 DESC


/*3. COUNTRY-LEVEL DETAIL*/

CREATE VIEW forestation
AS
SELECT r.*,l.year, COALESCE(f.forest_area_sqkm, 0) forest_area_sqkm,  
COALESCE((l.total_area_sq_mi * 2.59), 0) total_area_sqkm,
COALESCE(((f.forest_area_sqkm/(l.total_area_sq_mi * 2.59))*100), 0) percent_forest_area
FROM regions r
JOIN land_area l
ON r.country_code = l.country_code
JOIN forest_area f
ON l.country_code = f.country_code 
AND
l.year = f.year

/*a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? 
What was the difference in forest area for each?*/

WITH forest_area_1990
AS
        (SELECT country_name country_t1, year year_1990, 
                ROUND(forest_area_sqkm::numeric, 2) forest_area_1990 
        FROM forestation 
        WHERE year = 1990 AND country_name NOT LIKE 'World'),
      forest_area_2016
AS
        (SELECT country_name country_t2, year year_2016, 
                ROUND(forest_area_sqkm::numeric, 2) forest_area_2016 
        FROM forestation 
        WHERE year = 2016 AND country_name NOT LIKE 'World')

SELECT f1.country_t1 country, f1.forest_area_1990, f2.forest_area_2016, 
        (f1.forest_area_1990-f2.forest_area_2016) total_decrease_sqkm
FROM forest_area_1990 f1
JOIN forest_area_2016 f2
ON f1.country_t1 = f2.country_t2
GROUP BY country, f1.forest_area_1990, f2.forest_area_2016
ORDER BY total_decrease_sqkm DESC
LIMIT 5

/*b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? 
What was the percent change to 2 decimal places for each?*/
WITH forest_area_1990
AS
        (SELECT country_name country_t1, year year_1990, 
                ROUND(percent_forest_area::numeric,2) percent_forest_area_1990
        FROM forestation 
        WHERE year = 1990 AND country_name NOT LIKE 'World'),
      forest_area_2016
AS
        (SELECT country_name country_t2, year year_2016, 
                ROUND(percent_forest_area::numeric,2) percent_forest_area_2016
        FROM forestation 
        WHERE year = 2016 AND country_name NOT LIKE 'World')

SELECT f1.country_t1 country, f1.percent_forest_area_1990, f2.percent_forest_area_2016, 
        (f1.percent_forest_area_1990-percent_forest_area_2016) total_percent_decrease
FROM forest_area_1990 f1
JOIN forest_area_2016 f2
ON f1.country_t1 = f2.country_t2
GROUP BY country, f1.percent_forest_area_1990, f2.percent_forest_area_2016
ORDER BY total_percent_decrease DESC
LIMIT 5

/*c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?*/

WITH forest_area_2016
        AS
        (SELECT country_name country_t2, year year_2016, 
                ROUND(percent_forest_area) percent_forest_area_2016
        FROM forestation 
        WHERE year = 2016 AND country_name NOT LIKE 'World'),

        quartile_table 
        AS
        (SELECT country_t2 country_t3, percent_forest_area_2016, 
                                CASE WHEN percent_forest_area_2016 > 75 THEN 'QUARTILE 4'
                                WHEN percent_forest_area_2016 > 50 THEN 'QUARTILE 3'
                                WHEN percent_forest_area_2016 > 25 THEN 'QUARTILE 2'
                                ELSE 'QUARTILE 1' END AS quartile
        FROM forest_area_2016)
         
SELECT quartile quartile_group, count(*) total_group_quartile
FROM quartile_table
GROUP BY quartile
ORDER BY total_group_quartile DESC 
LIMIT 1

/*d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.*/
WITH forest_area_2016
        AS
        (SELECT country_name country_t2, year year_2016, 
                ROUND(percent_forest_area) percent_forest_area_2016
        FROM forestation 
        WHERE year = 2016 AND country_name NOT LIKE 'World')

SELECT country_t2 country, percent_forest_area_2016 , 
                                CASE WHEN percent_forest_area_2016 > 75 THEN 'QUARTILE 4'
                                WHEN percent_forest_area_2016 > 50 THEN 'QUARTILE 3'
                                WHEN percent_forest_area_2016 > 25 THEN 'QUARTILE 2'
                                ELSE 'QUARTILE 1' END AS quartile
        FROM forest_area_2016
        WHERE percent_forest_area_2016  > 75
        ORDER BY percent_forest_area_2016 DESC

/*e. How many countries had a percent forestation higher than the United States in 2016?*/

SELECT COUNT (*) total_countries
FROM forestation 
        WHERE year = 2016 
                         AND country_name NOT LIKE 'World' 
                         AND percent_forest_area  > (SELECT percent_forest_area
                                                                FROM forestation
                                                                WHERE country_name LIKE 'United States'
                                                                                       AND year = 2016 )

                                                                
