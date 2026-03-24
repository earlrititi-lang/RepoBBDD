===============================================================================
   DOCUMENTO MAESTRO: CONSULTAS SQL EN ORACLE
   Base de Datos Pokémon - 1º DAM
===============================================================================

                        ÍNDICE DE CONTENIDOS

1. Introducción a las Consultas SQL
2. SELECT y FROM: Consultas Básicas
3. WHERE: Filtrado de Datos
4. ORDER BY: Ordenación de Resultados
5. DISTINCT: Eliminación de Duplicados
6. Funciones de Agregación (COUNT, SUM, AVG, MAX, MIN)
7. GROUP BY y HAVING: Agrupación de Datos
8. JOINS: Unión de Tablas
   8.1. INNER JOIN
   8.2. LEFT JOIN (LEFT OUTER JOIN)
   8.3. RIGHT JOIN (RIGHT OUTER JOIN)
   8.4. FULL JOIN (FULL OUTER JOIN)
   8.5. CROSS JOIN
   8.6. SELF JOIN
9. Subconsultas (Subqueries)
   9.1. Subconsultas en WHERE
   9.2. Subconsultas en FROM
   9.3. Subconsultas en SELECT
10. Funciones de Cadena (String)
11. Funciones de Fecha
12. Funciones para Manejo de NULL
13. Operadores Avanzados
14. CASE WHEN: Lógica Condicional
15. UNION, INTERSECT, MINUS
16. Consultas Complejas y Ejemplos Avanzados

===============================================================================
REQUISITOS PREVIOS
===============================================================================

Antes de comenzar, asegúrate de:
1. Tener creadas las 7 tablas principales + tablas intermedias de la BD Pokémon
2. Ejecutar el script de datos: datos_pokemon_completos.sql
3. Tener acceso a un cliente de Oracle (SQL Developer, SQL*Plus, etc.)

===============================================================================

===============================================================================
1. INTRODUCCIÓN A LAS CONSULTAS SQL
===============================================================================

¿Qué es SQL?
-------------
SQL (Structured Query Language) es el lenguaje estándar para interactuar con
bases de datos relacionales. Permite:
- Consultar datos (SELECT)
- Insertar datos (INSERT)
- Actualizar datos (UPDATE)
- Eliminar datos (DELETE)

¿Qué es una consulta?
---------------------
Una consulta SQL es una instrucción que le pedimos a la base de datos para
obtener información específica. Las consultas permiten:
- Recuperar datos de una o más tablas
- Filtrar resultados según condiciones
- Ordenar y agrupar información
- Realizar cálculos y transformaciones

Tipos de consultas:
-------------------
1. Consultas simples: SELECT de una sola tabla
2. Consultas con JOIN: Combinan datos de múltiples tablas
3. Consultas anidadas: Consultas dentro de consultas (subconsultas)
4. Consultas de agregación: Resumen datos con funciones (COUNT, SUM, etc.)

Estructura básica de una consulta SELECT:
-----------------------------------------
SELECT columnas          -- ¿Qué quiero ver?
FROM tabla               -- ¿De dónde?
WHERE condición          -- ¿Con qué filtros?
GROUP BY columnas        -- ¿Cómo agrupar?
HAVING condición         -- ¿Filtros después de agrupar?
ORDER BY columnas;       -- ¿En qué orden?

===============================================================================
2. SELECT Y FROM: CONSULTAS BÁSICAS
===============================================================================

SELECT: Selecciona las columnas que quieres ver
FROM: Indica de qué tabla obtener los datos

SINTAXIS:
--------
SELECT columna1, columna2, ...
FROM nombre_tabla;

-- Para seleccionar TODAS las columnas:
SELECT *
FROM nombre_tabla;


EJEMPLO 1: Ver todos los pokémon
---------------------------------
SELECT *
FROM POKEMON;

Este comando devuelve TODAS las columnas y TODAS las filas de la tabla POKEMON.


EJEMPLO 2: Ver solo nombre y PS base de pokémon
------------------------------------------------
SELECT NOMBRE, PS_BASE
FROM POKEMON;

Este comando devuelve solo las columnas NOMBRE y PS_BASE.


EJEMPLO 3: Ver todos los entrenadores
--------------------------------------
SELECT COD_ENTRENADOR, NOMBRE, DNI
FROM ENTRENADOR;


===============================================================================
3. WHERE: FILTRADO DE DATOS
===============================================================================

WHERE filtra las filas según una condición. Solo las filas que cumplen la
condición aparecen en el resultado.

SINTAXIS:
--------
SELECT columnas
FROM tabla
WHERE condición;


OPERADORES DE COMPARACIÓN:
--------------------------
=    Igual a
<>   Distinto de (también !=)
>    Mayor que
<    Menor que
>=   Mayor o igual que
<=   Menor o igual que


EJEMPLO 1: Pokémon de tipo Fuego (COD_TIPO_1 = 1)
--------------------------------------------------
SELECT NOMBRE, PS_BASE, ATAQUE_BASE
FROM POKEMON
WHERE COD_TIPO_1 = 1;

Resultado: Charmander, Charmeleon, Charizard, Cyndaquil, Torchic, Moltres...


EJEMPLO 2: Pokémon con más de 100 PS base
------------------------------------------
SELECT NOMBRE, PS_BASE
FROM POKEMON
WHERE PS_BASE > 100;


EJEMPLO 3: Entrenadores de la zona 1 (Pueblo Paleta)
----------------------------------------------------
SELECT NOMBRE, DNI
FROM ENTRENADOR
WHERE COD_ZONA = 1;

Resultado: Ash Ketchum, Gary Oak, Blue Rival


OPERADORES LÓGICOS:
------------------
AND  - Todas las condiciones deben cumplirse
OR   - Al menos una condición debe cumplirse
NOT  - Niega una condición


EJEMPLO 4: Pokémon de tipo Fuego CON más de 50 de ataque
---------------------------------------------------------
SELECT NOMBRE, ATAQUE_BASE
FROM POKEMON
WHERE COD_TIPO_1 = 1
  AND ATAQUE_BASE > 50;

Resultado: Charmander (52), Charmeleon (64), Charizard (84), Cyndaquil (52)...


EJEMPLO 5: Pokémon de tipo Agua O tipo Eléctrico
------------------------------------------------
SELECT NOMBRE, COD_TIPO_1
FROM POKEMON
WHERE COD_TIPO_1 = 2
   OR COD_TIPO_1 = 3;


EJEMPLO 6: Pokémon que NO son de tipo Fuego
-------------------------------------------
SELECT NOMBRE, COD_TIPO_1
FROM POKEMON
WHERE COD_TIPO_1 != 1;

O también:
SELECT NOMBRE, COD_TIPO_1
FROM POKEMON
WHERE NOT COD_TIPO_1 = 1;


OPERADOR IN:
-----------
Comprueba si un valor está en una lista de valores.

SELECT NOMBRE, COD_TIPO_1
FROM POKEMON
WHERE COD_TIPO_1 IN (1, 2, 3);

Esto es equivalente a:
WHERE COD_TIPO_1 = 1 OR COD_TIPO_1 = 2 OR COD_TIPO_1 = 3


OPERADOR BETWEEN:
----------------
Comprueba si un valor está en un rango (incluye los extremos).

SELECT NOMBRE, PS_BASE
FROM POKEMON
WHERE PS_BASE BETWEEN 50 AND 70;

Esto es equivalente a:
WHERE PS_BASE >= 50 AND PS_BASE <= 70


EJEMPLO 7: Pokémon con ataque entre 80 y 100
--------------------------------------------
SELECT NOMBRE, ATAQUE_BASE
FROM POKEMON
WHERE ATAQUE_BASE BETWEEN 80 AND 100;


OPERADOR LIKE:
-------------
Se usa para buscar patrones en cadenas de texto.

% - Representa cualquier secuencia de caracteres (0 o más)
_ - Representa exactamente UN carácter

SELECT NOMBRE
FROM POKEMON
WHERE NOMBRE LIKE 'Char%';
-- Resultado: Charmander, Charmeleon, Charizard

SELECT NOMBRE
FROM POKEMON
WHERE NOMBRE LIKE '%saur';
-- Resultado: Bulbasaur, Ivysaur, Venusaur

SELECT NOMBRE
FROM POKEMON
WHERE NOMBRE LIKE '%i%';
-- Resultado: Nombres que contienen 'i' 

SELECT NOMBRE
FROM POKEMON
WHERE NOMBRE LIKE '%e__';
-- Resultado: Nombres que contienen 'e' como antepenúltimo carácter

SELECT NOMBRE
FROM POKEMON
WHERE NOMBRE LIKE '__y%';
-- Resultado: Nombres que contienen 'y' como tercer carácter


EJEMPLO 8: Pokémon cuyo nombre empieza con 'D'
-----------------------------------------------
SELECT NOMBRE
FROM POKEMON
WHERE NOMBRE LIKE 'D%';

Resultado: Dratini, Dragonair, Dragonite


OPERADOR IS NULL / IS NOT NULL:
-------------------------------
Comprueba si un campo tiene valor NULL.

⚠️ IMPORTANTE: No uses = NULL ni <> NULL. Siempre usa IS NULL / IS NOT NULL

SELECT NOMBRE
FROM POKEMON
WHERE COD_ZONA IS NULL;
-- Pokémon sin ubicación definida (legendarios)

SELECT NOMBRE
FROM POKEMON
WHERE COD_TIPO_2 IS NOT NULL;
-- Pokémon con tipo secundario


EJEMPLO 9: Entrenadores sin zona asignada
-----------------------------------------
SELECT NOMBRE
FROM ENTRENADOR
WHERE COD_ZONA IS NULL;

Resultado: Lance, Giovanni


COMBINACIÓN DE CONDICIONES:
---------------------------
Puedes combinar múltiples operadores. Usa paréntesis para claridad.

SELECT NOMBRE, ATAQUE_BASE, DEFENSA_BASE
FROM POKEMON
WHERE (COD_TIPO_1 = 1 OR COD_TIPO_1 = 2)
  AND ATAQUE_BASE > 80
  AND PS_BASE BETWEEN 50 AND 90;


===============================================================================
4. ORDER BY: ORDENACIÓN DE RESULTADOS
===============================================================================

ORDER BY ordena los resultados según una o más columnas.

SINTAXIS:
--------
SELECT columnas
FROM tabla
WHERE condición
ORDER BY columna1 [ASC|DESC], columna2 [ASC|DESC];

ASC  - Ascendente (menor a mayor) - POR DEFECTO
DESC - Descendente (mayor a menor)


EJEMPLO 1: Pokémon ordenados por nombre alfabéticamente
-------------------------------------------------------
SELECT NOMBRE, PS_BASE
FROM POKEMON
ORDER BY NOMBRE;

O explícitamente:
ORDER BY NOMBRE ASC;


EJEMPLO 2: Pokémon ordenados por PS base de mayor a menor
---------------------------------------------------------
SELECT NOMBRE, PS_BASE
FROM POKEMON
ORDER BY PS_BASE DESC;

Resultado: Mewtwo (106), Lugia (106), Ho-Oh (106), Kyogre (100)...


EJEMPLO 3: Ordenar por múltiples columnas
-----------------------------------------
SELECT NOMBRE, COD_TIPO_1, ATAQUE_BASE
FROM POKEMON
ORDER BY COD_TIPO_1, ATAQUE_BASE DESC;

Primero ordena por tipo (ascendente), y dentro de cada tipo ordena por
ataque (descendente).


EJEMPLO 4: Entrenadores ordenados por zona y luego por nombre
-------------------------------------------------------------
SELECT NOMBRE, COD_ZONA
FROM ENTRENADOR
ORDER BY COD_ZONA, NOMBRE;


EJEMPLO 5: Top 10 pokémon con más ataque
----------------------------------------
SELECT NOMBRE, ATAQUE_BASE
FROM POKEMON
ORDER BY ATAQUE_BASE DESC
FETCH FIRST 10 ROWS ONLY;


ORDENAR POR POSICIÓN DE COLUMNA:
--------------------------------
Puedes usar números en lugar de nombres de columna (no recomendado).

SELECT NOMBRE, PS_BASE, ATAQUE_BASE
FROM POKEMON
ORDER BY 2 DESC;  -- Ordena por la 2ª columna (PS_BASE)


ORDENAR VALORES NULL:
--------------------
En Oracle, NULL se considera "mayor" que cualquier valor.

ORDER BY columna ASC  → NULL aparece al FINAL
ORDER BY columna DESC → NULL aparece al PRINCIPIO

Para controlar esto:
ORDER BY columna NULLS FIRST;  -- NULL al principio
ORDER BY columna NULLS LAST;   -- NULL al final


EJEMPLO 6: Pokémon ordenados por zona, con los sin zona al final
----------------------------------------------------------------
SELECT NOMBRE, COD_ZONA
FROM POKEMON
ORDER BY COD_ZONA NULLS LAST;


===============================================================================
5. DISTINCT: ELIMINACIÓN DE DUPLICADOS
===============================================================================

DISTINCT elimina filas duplicadas del resultado.

SINTAXIS:
--------
SELECT DISTINCT columnas
FROM tabla;


EJEMPLO 1: ¿Qué tipos de pokémon hay en la base de datos?
----------------------------------------------------------
SELECT DISTINCT COD_TIPO_1
FROM POKEMON
ORDER BY COD_TIPO_1;


EJEMPLO 2: ¿Qué zonas tienen pokémon?
-------------------------------------
SELECT DISTINCT COD_ZONA
FROM POKEMON
WHERE COD_ZONA IS NOT NULL
ORDER BY COD_ZONA;


EJEMPLO 3: ¿Qué combinaciones de tipo primario y secundario existen?
--------------------------------------------------------------------
SELECT DISTINCT COD_TIPO_1, COD_TIPO_2
FROM POKEMON
WHERE COD_TIPO_2 IS NOT NULL
ORDER BY COD_TIPO_1, COD_TIPO_2 DESC;


⚠️ IMPORTANTE: DISTINCT se aplica a TODAS las columnas seleccionadas, no solo
               a una. La combinación de todas las columnas debe ser única.

-- Esto NO es correcto si quieres solo tipos únicos:
SELECT DISTINCT COD_TIPO_1, NOMBRE
FROM POKEMON;
-- Esto devolverá todos los pokémon porque la combinación (tipo, nombre)
-- siempre es única.


CONTAR VALORES ÚNICOS:
---------------------
SELECT COUNT(DISTINCT COD_TIPO_1)
FROM POKEMON;
-- Cuenta cuántos tipos diferentes hay


===============================================================================
6. FUNCIONES DE AGREGACIÓN
===============================================================================

Las funciones de agregación procesan múltiples filas y devuelven UN solo valor.

FUNCIONES PRINCIPALES:
---------------------
COUNT()  - Cuenta filas
SUM()    - Suma valores
AVG()    - Calcula promedio
MAX()    - Encuentra el valor máximo
MIN()    - Encuentra el valor mínimo


6.1. COUNT() - Contar Filas
----------------------------

SINTAXIS:
COUNT(*)            - Cuenta todas las filas (incluye NULL)
COUNT(columna)      - Cuenta filas donde columna NO es NULL
COUNT(DISTINCT col) - Cuenta valores únicos (sin duplicados)


⚠️ IMPORTANTE: COUNT POR DEFECTO NO CUENTA LOS VALORES NULL, excepto COUNT(*)


EJEMPLO 1: ¿Cuántos pokémon hay en total?
-----------------------------------------
SELECT COUNT(*) AS TOTAL_POKEMON
FROM POKEMON;

Resultado: 50


EJEMPLO 2: ¿Cuántos pokémon tienen tipo secundario?
---------------------------------------------------
SELECT COUNT(COD_TIPO_2) AS CON_TIPO_SECUNDARIO
FROM POKEMON;



EJEMPLO 3: ¿Cuántos tipos diferentes hay?
-----------------------------------------
SELECT COUNT(DISTINCT COD_TIPO_1) AS TIPOS_DIFERENTES
FROM POKEMON;


EJEMPLO 4: ¿Cuántos entrenadores hay?
-------------------------------------
SELECT COUNT(*) AS TOTAL_ENTRENADORES
FROM ENTRENADOR;

Resultado: 15


6.2. SUM() - Sumar Valores
--------------------------

SUM() suma valores numéricos de una columna.

EJEMPLO 1: ¿Cuántos PS base tienen todos los pokémon juntos?
------------------------------------------------------------
SELECT SUM(PS_BASE) AS TOTAL_PS
FROM POKEMON;


EJEMPLO 2: ¿Cuántos movimientos han aprendido todos los pokémon?
----------------------------------------------------------------

SELECT COUNT(*) AS TOTAL_MOVIMIENTOS_APRENDIDOS
FROM POKEMON_MOVIMIENTO;


6.3. AVG() - Calcular Promedio
------------------------------

AVG() calcula el promedio (media aritmética).

EJEMPLO 1: ¿Cuál es el PS base promedio de los pokémon?
-------------------------------------------------------
SELECT AVG(PS_BASE) AS PROMEDIO_PS
FROM POKEMON;


EJEMPLO 2: ¿Cuál es el ataque promedio de pokémon de tipo Fuego?
-----------------------------------------------------------------
SELECT AVG(ATAQUE_BASE) 
FROM POKEMON
WHERE COD_TIPO_1 = 1;


EJEMPLO 3: Promedio redondeado
------------------------------
SELECT ROUND(AVG(ATAQUE_BASE), 3) AS PROMEDIO_ATAQUE
FROM POKEMON
WHERE COD_TIPO_1 = 1;

ROUND(valor, decimales) redondea el resultado.


6.4. MAX() y MIN() - Máximo y Mínimo
------------------------------------

MAX() encuentra el valor más alto
MIN() encuentra el valor más bajo


EJEMPLO 1: ¿Cuál es el PS base más alto?
----------------------------------------
SELECT MAX(PS_BASE) AS PS_MAXIMO
FROM POKEMON;

Resultado: 106 (Mewtwo, Lugia, Ho-Oh)


EJEMPLO 2: ¿Cuál es el ataque más bajo?
---------------------------------------
SELECT MIN(ATAQUE_BASE) AS ATAQUE_MINIMO
FROM POKEMON;

Resultado: 10 (Magikarp)


EJEMPLO 3: Rango de velocidad (mínima y máxima)
-----------------------------------------------
SELECT MIN(VELOCIDAD_BASE) AS VEL_MINIMA,
       MAX(VELOCIDAD_BASE) AS VEL_MAXIMA
FROM POKEMON;


⚠️ LIMITACIONES DE LAS FUNCIONES DE AGREGACIÓN:
----------------------------------------------
No puedes mezclar columnas normales con funciones de agregación sin GROUP BY:

-- ❌ ESTO DA ERROR:
SELECT NOMBRE, MAX(PS_BASE)
FROM POKEMON;

-- ✅ CORRECTO (usando subconsulta):
SELECT NOMBRE, PS_BASE AS PS_MAXIMO
FROM POKEMON
WHERE PS_BASE = (SELECT MAX(PS_BASE) FROM POKEMON);



===============================================================================