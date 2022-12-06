
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
 100-(((SELECT percent_forest_area 
      FROM forestation 
      WHERE year = 2016 AND country_name='World') 
                       / 
      (SELECT percent_forest_area 
      FROM forestation 
      WHERE year = 1990 AND country_name='World')))*100 dif_percent_between_1990_2016
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
 SELECT r_name ,n_year, ROUND( percent_forest_area::numeric, 2) percent_forest
FROM percent_forest
WHERE n_year = 2016 AND r_name LIKE 'World'
 
/*Which region had the HIGHEST percent forest in 2016*/
 SELECT r_name ,n_year, ROUND( percent_forest_area::numeric, 2) percent_forest
FROM percent_forest
WHERE n_year = 2016 AND r_name NOT LIKE 'World'
ORDER BY percent_forest_area DESC 
LIMIT 1
/*and which had the LOWEST, to 2 decimal places?*/
SELECT r_name ,n_year, ROUND( percent_forest_area::numeric, 2) percent_forest
FROM percent_forest
WHERE n_year = 2016 AND r_name NOT LIKE 'World'
ORDER BY percent_forest_area  
LIMIT 1

/* b. What was the percent forest of the entire world in 1990? */
 SELECT r_name ,n_year, ROUND( percent_forest_area::numeric, 2) percent_forest
FROM percent_forest
WHERE n_year = 1990 AND r_name LIKE 'World'
/*Which region had the HIGHEST percent forest in 1990,*/ 
 SELECT r_name ,n_year, ROUND( percent_forest_area::numeric, 2) percent_forest
FROM percent_forest
WHERE n_year = 1990 AND r_name NOT LIKE 'World'
ORDER BY percent_forest_area DESC 
LIMIT 1
/*and which had the LOWEST, to 2 decimal places?*/
 SELECT r_name ,n_year, ROUND( percent_forest_area::numeric, 2) percent_forest
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
SELECT f2.rn_2 region_lost_percent, f1.percent_forest_1 percent_forest_1990, f2.percent_forest_2 percent_forest_2016, 
(f1.percent_forest_1 - f2.percent_forest_2) total_lost_percent
FROM forest_area_1 f1
JOIN forest_area_2 f2
ON f1.rn_1 = f2.rn_2 
GROUP BY f2.rn_2 ,f2.ny_2,f2.percent_forest_2, f1.ny_1, f1.percent_forest_1
HAVING f2.percent_forest_2 < f1.percent_forest_1
ORDER BY percent_forest_1990 DESC 


/* to show tembalte*/
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
SELECT f2.rn_2 region, f1.percent_forest_1 percent_forest_1990,  f2.percent_forest_2 percent_forest_2016
FROM forest_area_1 f1
JOIN forest_area_2 f2
ON f1.rn_1 = f2.rn_2 
GROUP BY f2.rn_2 ,f2.ny_2,f2.percent_forest_2, f1.ny_1, f1.percent_forest_1
ORDER BY percent_forest_1990 DESC





