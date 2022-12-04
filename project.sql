
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

/*a. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?/*
