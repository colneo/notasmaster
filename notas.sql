SELECT * # selecciona todos las columnas de la tabla.

# tambien podemos usar +, -, /, * para crear calculos entre variables y luego el resultado nombrarlas en una nueva columna
x + y AS new_colum_z 

FROM #de donde que tabla quieres los datos

WHERE x >= 500 #podemos usar ,<, >, =,<=,>=, != , para seleccionar los datos de interes. (valores numericos)

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

# para busqueda de variables tenemos IN
WHERE name_list IN ('x','y')

# agregando NOT antes que LIKE o IN hace la orden contraria a la viste anteriormente.
NOT LIKE
NOT IN

# para  diferentes ordenes en WHERE ponemos AND
where name_list IN 'x' AND name_list != y

#between para selecionar valores entre un intervalo 
WHERE rank BETWEEN 1 AND 4 // # resultado devuelve valores en la tabla 2 y 3

# OR usado para ver si cumple alguna condicion devuelva la orden 
WHERE x=y OR y=x 

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
SELECT x.*, y.*
FROM x
JOIN y
ON x.id = y.account_id
 # puedes hacerlo con multiples tablas
SELECT x.*, y.*, z.*
FROM x
JOIN y
ON x.id = y.account_id
JOIN z
ON x.id = z.account_id