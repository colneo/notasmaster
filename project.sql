
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
SELECT year, SUM(forest_area_sqkm) total_forest_area
FROM forestation
WHERE region NOT LIKE 'WORLD'
GROUP BY year
HAVING year IN (1990, 2016) 

/*c. What was the change (in sq km) in the forest area of the world from 1990 to 2016?
*/
SELECT region,
((SELECT SUM(forest_area_sqkm) total_forest_area
 FROM forestation 
 WHERE year= 2016)- (SELECT SUM(forest_area_sqkm) total_forest_area
 FROM forestation 
 WHERE year= 1990)) change_1990_to_2016
FROM forestation
GROUP BY region 
HAVING region LIKE 'World'

