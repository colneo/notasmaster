SELECT * # selecciona todos las columnas de la tabla.

# tambien podemos usar +, -, /, * para crear calculos entre variables y luego el resultado nombrarlas en una nueva columna
x + y AS new_colum_z 

#contar las filas de los datos
SELECT COUNT(*) AS ntotal

#SUM
SELECT SUM(x1) AS x1,
       SUM(x2) AS x2,
       SUM(x3) AS x3
FROM x

SELECT DISTINCT #devuelve tabla quitando los duplicados.

#en las mismas tenemos AVG(), MAX(), MIN()
#nota: This aggregate function again ignores the NULL values in both the numerator and the denominator.
#entonces If you want to count NULLs as zero, you will need to use SUM and COUNT. 
#However, this is probably not a good idea if the NULL values truly just represent unknown values for a cell.

FROM #de donde que tabla quieres los datos

WHERE x >= 500 #podemos usar ,<, >, =,<=,>=, <> , para seleccionar los datos de interes. (valores numericos)

#cuando son valores string solo usamos ,= o != para seleccionar datos de interes  
WHERE name_list = 'name x' o WHERE name_list != "x" 

# para busqueda de strings objetivo haciendo target en el objetivo dentro de una cadena y que te devuelva los datos
#que solo tienen esa string objetivo  
# nota '%' este simbolo dentro de la orden indica que puede que queramos string cerca de la strings objetivo 
# ejemplo strig x.... cuando x% indica q solo devuelva si x tiene enfrente strings o %x cuando x tiene por detras cadena de string
WHERE name_list like '%x%' #// resultado zzzzzzxzzzzzz
                      '%x'#// resultado zzzzzzzzzzx
                      'x%'#// resultado xzzzzzzzzzz
                      'x'#// resultado x
                      '% x%'#// resultado zzzz xzzzzzzzzz 

# para busqueda de variables tenemos IN
WHERE name_list IN ('x','y')
DISTINCT
# agregando NOT antes que LIKE o IN hace la orden contraria a la viste anteriormente.
NOT LIKE
NOT IN

# para  diferentes ordenes en WHERE ponemos AND
where name_list IN 'x' AND name_list != y

#between para selecionar valores entre un intervalo 
WHERE rank BETWEEN 1 AND 4 // # resultado devuelve valores en la tabla 2 y 3

# OR usado para ver si cumple alguna condicion devuelva la orden 
WHERE x=y OR y=x 

#estado NULL
WHERE x IS NULL //# resultado tabla en el no hay datos es decir NULL

ORDER BY # como quieres que se organicen usando un tipo de variable de interes (columna) va de a-z

ORDER BY x DESC # organiza de forma decendente

#nota si queremos organizar  primero agrupando "x" (a-z) y luego organizando "y" (z-a) en desc con variables seria
ORDER BY x, y DESC

#ahora si queremos que se organice primero agrupando "y" en desc...luego "x" (a-z)  
ORDER BY y DESC, x

LIMIT # numeros de filas que quieres en tus datos


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# JOIN nos permite trabajar con varias tablas a la vez a la hora de trabajar con datos.
# ejem tenemos TABLE1= x table2= y variable q las une es primary key = ID entonces  
#en x tenemos id y en y tenemos variable account_id 
# puedes agregar un alias en frente de las tablas que vas a agrupar
SELECT x.*, y.*
FROM x t1/// # t1 seria el alias de x
JOIN y t2// # t2 seria el alias de y
ON x.id = y.account_id
 # puedes hacerlo con multiples tablas
SELECT x.*, y.*, z.*
FROM x
JOIN y
ON x.id = y.account_id
JOIN z
ON x.id = z.account_id

// # LEFT JOIN asociada a LEFT = FROM  devuelve tabla (FROM) + INNER JOIN
  # RIGHT JOIN asociada a RIGHT = JOIN  devuelve tabla (JOIN) + INNER JOIN
   # INNER JOIN es el resultado de la union de las dos tablas solo devuelve el match entre las 2 tablas.
   # OUTER JOIN devuelve tabla tando de left como de rigth y del inner en conjunto. esten asosciadas por el condicional (ON) o no
# para inner join podemos usar USING() en vez de ON xxx = xxx
SELECT x.*, y.*, z.*
FROM x
JOIN y
USING(code)

#  GROUP BY x para agrupar los datos de un AVG o SUM en cada elemento de la columna x ej
SELECT account_id,
       SUM(standard_qty) AS standard,
       SUM(gloss_qty) AS gloss,
       SUM(poster_qty) AS poster
FROM orders
GROUP BY account_id
ORDER BY account_id

#nota filtrar WHERE no funciona con GROUP BY instead HAVING + la orden que deceas filitrar
SELECT account_id,
       SUM(standard_qty) AS standard,
       SUM(gloss_qty) AS gloss,
       SUM(poster_qty) AS poster
FROM orders
GROUP BY account_id
HAVING SUM(standard_qty) AS standard >= 123214234
ORDER BY account_id

#### seleccionar datos de DAte
DATE_PART # can be useful for pulling a specific portion of a date, 
# but notice pulling month or day of the week (dow) means that you are no longer keeping the years in order.
# Rather you are grouping for certain components regardless of which year they belonged in.

DATE_TRUNC #llows you to truncate your date to a particular part of your date-time column. 
#Common truncations are day, month, and year. Here is a great blog post by Mode Analytics on the power of this function.


## CASE WHEN condicion THEN accion que va a devolver ELSE que quieres poner en las q no cumple condicion
# y para finalizar END 
SELECT id,
       account_id,
       occurred_at,
       channel,
       CASE WHEN channel = 'facebook' OR channel = 'direct' THEN 'yes' 
       ELSE 'no' END AS is_facebook
FROM web_events
ORDER BY occurred_at

SELECT account_id,
       occurred_at,
       total,
       CASE WHEN total > 500 THEN 'Over 500'
            WHEN total > 300 THEN '301 - 500'
            WHEN total > 100 THEN '101 - 300'
            ELSE '100 or under' END AS total_group
FROM orders

#notas esta selecciona anos dias puntuales para flitrar
HAVING DATE_PART('year',occurred_at) IN('2016','2017')

# ejemplo de redondear
ROUND( x,zzzzzzz ::numeric, 2)  resultado = x,zz

CREATE VIEW <VIEW_NAME>
AS
SELECT …
FROM …
WHERE …


-- otras formas de sumar dos tables
UNION -- devuelve ambas sin duplicar
UNION ALL --devuelve ambas y duplicadas
INTERSECT --solamente devuelve las intersecciones entre dos tablas
EXCEPT  -- devuelve solo los valores de la tabla en la que no estan los datos en la otra tabla.



JOIN
LEFT JOIN 
RIGHT JOIN  
CROSS JOIN 
OUTER JOIN  
ALL OUTER JOIN 




CREATE TEMP TABLE name AS (SELECT .....  
                            FROM .........)- indagar



























