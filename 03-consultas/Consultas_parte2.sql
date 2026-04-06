===============================================================================
7. GROUP BY Y HAVING: AGRUPACIÓN DE DATOS
===============================================================================

GROUP BY agrupa filas que tienen valores iguales en columnas especificadas.
Se usa típicamente con funciones de agregación.

SINTAXIS:
--------
SELECT columnas, FUNCION_AGREGACION(columna)
FROM tabla
WHERE condición              -- Filtro ANTES de agrupar
GROUP BY columnas
HAVING condición_agregada;   -- Filtro DESPUÉS de agrupar


7.1. GROUP BY Básico
---------------------

EJEMPLO 1: ¿Cuántos pokémon hay de cada tipo?
----------------------------------------------
SELECT COD_TIPO_1, COUNT(*) AS CANTIDAD
FROM POKEMON
GROUP BY COD_TIPO_1
ORDER BY CANTIDAD DESC;



EJEMPLO 2: PS promedio por tipo de pokémon
------------------------------------------
SELECT COD_TIPO_1, ROUND(AVG(PS_BASE), 2) AS PS_PROMEDIO
FROM POKEMON
GROUP BY COD_TIPO_1
ORDER BY PS_PROMEDIO DESC;


EJEMPLO 3: ¿Cuántos pokémon tiene cada entrenador?
--------------------------------------------------
SELECT COD_ENTRENADOR, COUNT(*) AS CANTIDAD_POKEMON
FROM ENTRENADOR_POKEMON
GROUP BY COD_ENTRENADOR
ORDER BY CANTIDAD_POKEMON DESC;

Resultado:
COD_ENTRENADOR  CANTIDAD_POKEMON
--------------  ----------------
11              6    (Red - el campeón)
5               5    (Lance)
4               5    (Gary)
1               5    (Ash)
...


EJEMPLO 4: Total de objetos que tiene cada entrenador
-----------------------------------------------------
SELECT COD_ENTRENADOR, SUM(CANTIDAD) AS TOTAL_OBJETOS
FROM ENTRENADOR_OBJETO
GROUP BY COD_ENTRENADOR
ORDER BY TOTAL_OBJETOS DESC;


7.2. GROUP BY con múltiples columnas
------------------------------------

Puedes agrupar por varias columnas simultáneamente.

EJEMPLO 5: ¿Cuántos pokémon hay de cada combinación tipo1-tipo2?
----------------------------------------------------------------
SELECT COD_TIPO_1, COD_TIPO_2, COUNT(*) AS CANTIDAD
FROM POKEMON
GROUP BY COD_TIPO_1, COD_TIPO_2
ORDER BY COD_TIPO_1, COD_TIPO_2;




7.3. HAVING - Filtrar Grupos
----------------------------

HAVING filtra grupos DESPUÉS de agrupar (mientras que WHERE filtra ANTES).

⚠️ DIFERENCIA CLAVE:
WHERE  → Filtra filas individuales ANTES de agrupar
HAVING → Filtra grupos DESPUÉS de agrupar


EJEMPLO 7: Tipos que tienen más de 3 pokémon
--------------------------------------------
SELECT COD_TIPO_1, COUNT(*) AS CANTIDAD
FROM POKEMON
GROUP BY COD_TIPO_1
HAVING COUNT(*) > 3
ORDER BY CANTIDAD DESC;


EJEMPLO 8: Entrenadores con más de 3 pokémon
--------------------------------------------
SELECT COD_ENTRENADOR, COUNT(*) AS CANTIDAD_POKEMON
FROM ENTRENADOR_POKEMON
GROUP BY COD_ENTRENADOR
HAVING COUNT(*) > 3
ORDER BY CANTIDAD_POKEMON DESC;

Resultado: Solo Red (6), Lance (5), Gary (5), Ash (5)


EJEMPLO 9: Combinar WHERE y HAVING
----------------------------------
-- Tipos de pokémon con promedio de ataque > 70, excluyendo legendarios

SELECT COD_TIPO_1, 
       COUNT(*) AS CANTIDAD,
       ROUND(AVG(ATAQUE_BASE), 2) AS ATAQUE_PROMEDIO
FROM POKEMON
WHERE COD_POKEMON < 144  -- Excluir legendarios (COD >= 144)
GROUP BY COD_TIPO_1
HAVING AVG(ATAQUE_BASE) > 70
ORDER BY ATAQUE_PROMEDIO DESC;


EJEMPLO 10: Entrenadores que tienen más de 50 objetos en total
--------------------------------------------------------------
SELECT COD_ENTRENADOR, SUM(CANTIDAD) AS TOTAL_OBJETOS
FROM ENTRENADOR_OBJETO
GROUP BY COD_ENTRENADOR
HAVING SUM(CANTIDAD) > 50
ORDER BY TOTAL_OBJETOS DESC;


REGLAS IMPORTANTES DE GROUP BY:
-------------------------------
✅ Toda columna en SELECT (excepto funciones de agregación) DEBE estar en GROUP BY
✅ Puedes usar funciones de agregación sin GROUP BY (una sola fila resultado)
✅ HAVING solo se usa con GROUP BY
✅ WHERE se ejecuta ANTES de GROUP BY, HAVING se ejecuta DESPUÉS

-- ❌ ERROR: NOMBRE no está en GROUP BY
SELECT COD_TIPO_1, NOMBRE, COUNT(*)
FROM POKEMON
GROUP BY COD_TIPO_1;

-- ✅ CORRECTO:
SELECT COD_TIPO_1, COUNT(*)
FROM POKEMON
GROUP BY COD_TIPO_1;


===============================================================================
8. JOINS: UNIÓN DE TABLAS
===============================================================================

Los JOINS combinan filas de dos o más tablas basándose en una columna relacionada.

TIPOS DE JOIN:
-------------
1. INNER JOIN - Solo filas con coincidencias en ambas tablas
2. LEFT JOIN  - Todas las filas de la izquierda + coincidencias de la derecha
3. RIGHT JOIN - Todas las filas de la derecha + coincidencias de la izquierda
4. FULL JOIN  - Todas las filas de ambas tablas
5. CROSS JOIN - Producto cartesiano (todas las combinaciones posibles)
6. SELF JOIN  - Una tabla se une consigo misma


8.1. INNER JOIN
---------------

INNER JOIN devuelve solo las filas que tienen coincidencias en AMBAS tablas.

SINTAXIS:
--------
SELECT columnas
FROM tabla1
INNER JOIN tabla2 ON tabla1.columna = tabla2.columna;

-- O también:
FROM tabla1, tabla2
WHERE tabla1.columna = tabla2.columna;  -- Sintaxis antigua


EJEMPLO 1: Pokémon con el nombre de su tipo
-------------------------------------------
SELECT P.NOMBRE AS POKEMON, T.NOMBRE AS TIPO
FROM POKEMON P
INNER JOIN TIPOS T ON P.COD_TIPO_1 = T.COD_TIPO;

Resultado:
POKEMON      TIPO
---------    ---------
Charmander   Fuego
Squirtle     Agua
Bulbasaur    Planta
Pikachu      Eléctrico
...


EJEMPLO 2: Pokémon con su habilidad
-----------------------------------
SELECT P.NOMBRE AS POKEMON, 
       H.NOMBRE AS HABILIDAD,
       H.EFECTO
FROM POKEMON P
INNER JOIN HABILIDADES H ON P.COD_HABILIDAD = H.COD_HABILIDAD
ORDER BY P.NOMBRE;


EJEMPLO 3: Pokémon con su ubicación (zona)
------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS ZONA,
       M.REGION
FROM POKEMON P
INNER JOIN MAPA M ON P.COD_ZONA = M.COD_ZONA
ORDER BY M.REGION, M.NOMBRE;

⚠️ Esto solo muestra pokémon que TIENEN zona asignada (excluye legendarios sin zona).


EJEMPLO 4: Entrenadores con su ubicación
----------------------------------------
SELECT E.NOMBRE AS ENTRENADOR,
       M.NOMBRE AS ZONA,
       M.REGION
FROM ENTRENADOR E
INNER JOIN MAPA M ON E.COD_ZONA = M.COD_ZONA
ORDER BY M.REGION;


EJEMPLO 5: JOIN de 3 tablas - Pokémon con tipo y habilidad
----------------------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       T.NOMBRE AS TIPO,
       H.NOMBRE AS HABILIDAD
FROM POKEMON P
INNER JOIN TIPOS T ON P.COD_TIPO_1 = T.COD_TIPO
INNER JOIN HABILIDADES H ON P.COD_HABILIDAD = H.COD_HABILIDAD
ORDER BY P.NOMBRE;


EJEMPLO 6: JOIN de 4 tablas - Equipo de cada entrenador con detalles
--------------------------------------------------------------------
SELECT E.NOMBRE AS ENTRENADOR,
       P.NOMBRE AS POKEMON,
       EP.NIVEL,
       EP.APODO,
       T.NOMBRE AS TIPO
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_POKEMON EP ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
INNER JOIN POKEMON P ON EP.COD_POKEMON = P.COD_POKEMON
INNER JOIN TIPOS T ON P.COD_TIPO_1 = T.COD_TIPO
WHERE E.NOMBRE = 'Ash Ketchum'
ORDER BY EP.NIVEL DESC;

Resultado:
ENTRENADOR    POKEMON     NIVEL  APODO     TIPO
------------  ----------  -----  --------  ---------
Ash Ketchum   Charizard   50     Rizardon  Fuego
Ash Ketchum   Pikachu     45     Pikachu   Eléctrico
Ash Ketchum   Gyarados    42     Gyara     Agua
...


8.2. LEFT JOIN (LEFT OUTER JOIN)
--------------------------------

LEFT JOIN devuelve TODAS las filas de la tabla izquierda, y las coincidencias
de la derecha. Si no hay coincidencia, las columnas de la derecha son NULL.

SINTAXIS:
--------
SELECT columnas
FROM tabla1
LEFT JOIN tabla2 ON tabla1.columna = tabla2.columna;


EJEMPLO 7: TODOS los pokémon con su zona (incluye los sin zona)
---------------------------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS ZONA
FROM POKEMON P
LEFT JOIN MAPA M ON P.COD_ZONA = M.COD_ZONA
ORDER BY M.NOMBRE NULLS LAST;

Resultado incluye:
Mewtwo    NULL
Mew       NULL
Articuno  NULL
...


EJEMPLO 8: Todos los entrenadores con su ubicación
--------------------------------------------------
SELECT E.NOMBRE AS ENTRENADOR,
       M.NOMBRE AS ZONA
FROM ENTRENADOR E
LEFT JOIN MAPA M ON E.COD_ZONA = M.COD_ZONA
ORDER BY E.NOMBRE;

Resultado incluye:
Lance       NULL
Giovanni    NULL
...


EJEMPLO 9: Pokémon y sus movimientos (incluye pokémon sin movimientos)
----------------------------------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS MOVIMIENTO
FROM POKEMON P
LEFT JOIN POKEMON_MOVIMIENTO PM ON P.COD_POKEMON = PM.COD_POKEMON
LEFT JOIN MOVIMIENTOS M ON PM.COD_MOVIMIENTO = M.COD_MOVIMIENTO
ORDER BY P.NOMBRE;


EJEMPLO 10: Contar pokémon por zona (incluye zonas sin pokémon)
---------------------------------------------------------------
SELECT M.NOMBRE AS ZONA,
       COUNT(P.COD_POKEMON) AS CANTIDAD_POKEMON
FROM MAPA M
LEFT JOIN POKEMON P ON M.COD_ZONA = P.COD_ZONA
GROUP BY M.NOMBRE
ORDER BY CANTIDAD_POKEMON DESC;

⚠️ Usa COUNT(columna) en lugar de COUNT(*) para que no cuente NULL


8.3. RIGHT JOIN (RIGHT OUTER JOIN)
----------------------------------

RIGHT JOIN es lo opuesto a LEFT JOIN: devuelve TODAS las filas de la tabla
derecha, y las coincidencias de la izquierda.

SINTAXIS:
--------
SELECT columnas
FROM tabla1
RIGHT JOIN tabla2 ON tabla1.columna = tabla2.columna;


EJEMPLO 11: Mismo resultado que EJEMPLO 7 pero con RIGHT JOIN
-------------------------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS ZONA
FROM MAPA M
RIGHT JOIN POKEMON P ON M.COD_ZONA = P.COD_ZONA
ORDER BY M.NOMBRE NULLS LAST;

⚠️ En la práctica, LEFT JOIN es más común que RIGHT JOIN.


8.4. FULL JOIN (FULL OUTER JOIN)
--------------------------------

FULL JOIN devuelve TODAS las filas de AMBAS tablas. Si no hay coincidencia,
las columnas de la otra tabla son NULL.

SINTAXIS:
--------
SELECT columnas
FROM tabla1
FULL JOIN tabla2 ON tabla1.columna = tabla2.columna;


EJEMPLO 12: Todas las zonas y todos los pokémon
-----------------------------------------------
SELECT M.NOMBRE AS ZONA,
       P.NOMBRE AS POKEMON
FROM MAPA M
FULL JOIN POKEMON P ON M.COD_ZONA = P.COD_ZONA
ORDER BY M.NOMBRE, P.NOMBRE;

Resultado incluye:
- Zonas sin pokémon (POKEMON = NULL)
- Pokémon sin zona (ZONA = NULL)


8.5. CROSS JOIN
---------------

CROSS JOIN genera el producto cartesiano: todas las combinaciones posibles
entre las tablas.

⚠️ CUIDADO: Si tabla1 tiene 10 filas y tabla2 tiene 20, el resultado
            tiene 10 × 20 = 200 filas.

SINTAXIS:
--------
SELECT columnas
FROM tabla1
CROSS JOIN tabla2;


EJEMPLO 13: Todas las combinaciones posibles de tipo y habilidad
----------------------------------------------------------------
SELECT T.NOMBRE AS TIPO,
       H.NOMBRE AS HABILIDAD
FROM TIPOS T
CROSS JOIN HABILIDADES H
WHERE T.COD_TIPO <= 3
  AND H.COD_HABILIDAD <= 3;

Resultado: 3 tipos × 3 habilidades = 9 combinaciones


8.6. SELF JOIN
--------------

Un SELF JOIN une una tabla consigo misma. Útil para comparar filas dentro
de la misma tabla.

EJEMPLO 14: Comparar pokémon con otros del mismo tipo
-----------------------------------------------------
SELECT P1.NOMBRE AS POKEMON1,
       P2.NOMBRE AS POKEMON2,
       T.NOMBRE AS TIPO_COMUN
FROM POKEMON P1
INNER JOIN POKEMON P2 ON P1.COD_TIPO_1 = P2.COD_TIPO_1
INNER JOIN TIPOS T ON P1.COD_TIPO_1 = T.COD_TIPO
WHERE P1.COD_POKEMON < P2.COD_POKEMON  -- Evita duplicados y auto-comparación
  AND P1.COD_TIPO_1 = 1  -- Solo tipo Fuego
ORDER BY P1.NOMBRE, P2.NOMBRE;

Resultado:
Charmander    Charmeleon    Fuego
Charmander    Charizard     Fuego
Charmeleon    Charizard     Fuego
...


EJEMPLO 15: Pokémon con stats similares
---------------------------------------
SELECT P1.NOMBRE AS POKEMON1,
       P2.NOMBRE AS POKEMON2,
       P1.ATAQUE_BASE AS ATAQUE
FROM POKEMON P1
INNER JOIN POKEMON P2 ON P1.ATAQUE_BASE = P2.ATAQUE_BASE
WHERE P1.COD_POKEMON < P2.COD_POKEMON
ORDER BY P1.ATAQUE_BASE DESC;


ALIAS DE TABLA:
--------------
Los alias hacen las consultas más legibles:

-- Sin alias (difícil de leer):
SELECT POKEMON.NOMBRE, TIPOS.NOMBRE
FROM POKEMON
INNER JOIN TIPOS ON POKEMON.COD_TIPO_1 = TIPOS.COD_TIPO;

-- Con alias (más claro):
SELECT P.NOMBRE, T.NOMBRE
FROM POKEMON P
INNER JOIN TIPOS T ON P.COD_TIPO_1 = T.COD_TIPO;


===============================================================================
9. SUBCONSULTAS (SUBQUERIES)
===============================================================================

Una subconsulta es una consulta dentro de otra consulta. Se usa para obtener
datos que luego se usan en la consulta principal.

TIPOS DE SUBCONSULTAS:
---------------------
1. Subconsultas en WHERE - Filtran resultados
2. Subconsultas en FROM - Actúan como tablas temporales
3. Subconsultas en SELECT - Calculan valores por fila


9.1. Subconsultas en WHERE
--------------------------

EJEMPLO 1: Pokémon con el PS base más alto
------------------------------------------
SELECT NOMBRE, PS_BASE
FROM POKEMON
WHERE PS_BASE = (SELECT MAX(PS_BASE) FROM POKEMON);

Resultado: Mewtwo, Lugia, Ho-Oh (todos con PS = 106)


EJEMPLO 2: Pokémon con ataque superior al promedio
--------------------------------------------------
SELECT NOMBRE, ATAQUE_BASE
FROM POKEMON
WHERE ATAQUE_BASE > (SELECT AVG(ATAQUE_BASE) FROM POKEMON)
ORDER BY ATAQUE_BASE DESC;


EJEMPLO 3: Entrenadores que tienen Pikachu
------------------------------------------
SELECT NOMBRE
FROM ENTRENADOR
WHERE COD_ENTRENADOR IN (
    SELECT COD_ENTRENADOR
    FROM ENTRENADOR_POKEMON
    WHERE COD_POKEMON = 25  -- Pikachu
);

Resultado: Ash Ketchum, Surge Lightning, Red Champion


EJEMPLO 4: Movimientos que ningún pokémon ha aprendido
------------------------------------------------------
SELECT NOMBRE
FROM MOVIMIENTOS
WHERE COD_MOVIMIENTO NOT IN (
    SELECT DISTINCT COD_MOVIMIENTO
    FROM POKEMON_MOVIMIENTO
);


OPERADOR EXISTS:
---------------
EXISTS comprueba si una subconsulta devuelve al menos una fila.

EJEMPLO 5: Entrenadores que tienen al menos un pokémon
------------------------------------------------------
SELECT E.NOMBRE
FROM ENTRENADOR E
WHERE EXISTS (
    SELECT 1
    FROM ENTRENADOR_POKEMON EP
    WHERE EP.COD_ENTRENADOR = E.COD_ENTRENADOR
);


EJEMPLO 6: Tipos que tienen al menos un pokémon asociado
--------------------------------------------------------
SELECT T.NOMBRE
FROM TIPOS T
WHERE EXISTS (
    SELECT 1
    FROM POKEMON P
    WHERE P.COD_TIPO_1 = T.COD_TIPO
       OR P.COD_TIPO_2 = T.COD_TIPO
);


OPERADORES ANY y ALL:
--------------------
ANY - Compara con al menos un valor de la subconsulta
ALL - Compara con todos los valores de la subconsulta

EJEMPLO 7: Pokémon más rápidos que CUALQUIER pokémon de tipo Agua
-----------------------------------------------------------------
SELECT NOMBRE, VELOCIDAD_BASE
FROM POKEMON
WHERE VELOCIDAD_BASE > ANY (
    SELECT VELOCIDAD_BASE
    FROM POKEMON
    WHERE COD_TIPO_1 = 2  -- Agua
)
ORDER BY VELOCIDAD_BASE DESC;


EJEMPLO 8: Pokémon más rápidos que TODOS los pokémon de tipo Agua
------------------------------------------------------------------
SELECT NOMBRE, VELOCIDAD_BASE
FROM POKEMON
WHERE VELOCIDAD_BASE > ALL (
    SELECT VELOCIDAD_BASE
    FROM POKEMON
    WHERE COD_TIPO_1 = 2  -- Agua
)
ORDER BY VELOCIDAD_BASE DESC;


9.2. Subconsultas en FROM
-------------------------

Una subconsulta en FROM actúa como una tabla temporal.

EJEMPLO 9: Promedio de PS por tipo, solo tipos con promedio > 60
----------------------------------------------------------------
SELECT TIPO, PROMEDIO_PS
FROM (
    SELECT COD_TIPO_1 AS TIPO,
           AVG(PS_BASE) AS PROMEDIO_PS
    FROM POKEMON
    GROUP BY COD_TIPO_1
)
WHERE PROMEDIO_PS > 60
ORDER BY PROMEDIO_PS DESC;


EJEMPLO 10: Top 3 entrenadores con más pokémon
----------------------------------------------
SELECT ENTRENADOR, CANTIDAD
FROM (
    SELECT E.NOMBRE AS ENTRENADOR,
           COUNT(*) AS CANTIDAD
    FROM ENTRENADOR E
    INNER JOIN ENTRENADOR_POKEMON EP ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
    GROUP BY E.NOMBRE
    ORDER BY CANTIDAD DESC
)
WHERE ROWNUM <= 3;


9.3. Subconsultas en SELECT
---------------------------

Subconsultas que calculan un valor por cada fila del resultado.

EJEMPLO 11: Pokémon con su diferencia respecto al PS promedio
-------------------------------------------------------------
SELECT NOMBRE,
       PS_BASE,
       (SELECT AVG(PS_BASE) FROM POKEMON) AS PROMEDIO,
       PS_BASE - (SELECT AVG(PS_BASE) FROM POKEMON) AS DIFERENCIA
FROM POKEMON
ORDER BY DIFERENCIA DESC;


EJEMPLO 12: Entrenadores con la cantidad de pokémon que tienen
--------------------------------------------------------------
SELECT E.NOMBRE,
       (SELECT COUNT(*)
        FROM ENTRENADOR_POKEMON EP
        WHERE EP.COD_ENTRENADOR = E.COD_ENTRENADOR) AS CANTIDAD_POKEMON
FROM ENTRENADOR E
ORDER BY CANTIDAD_POKEMON DESC;


⚠️ IMPORTANTE:
- Subconsultas en SELECT deben devolver UN solo valor
- Subconsultas correlacionadas (que referencian tabla externa) son más lentas


===============================================================================
