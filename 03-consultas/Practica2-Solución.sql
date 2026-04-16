===============================================================================
SOLUCIONES — HOJA DE EJERCICIOS SQL (PARTE 2)
SELECT, WHERE, ORDER BY, DISTINCT, AGREGACIÓN, GROUP BY Y HAVING
Base de Datos Pokémon - 1º DAM
Sin JOIN
===============================================================================

-- ============================================================================
-- 1
-- Muestra cuántos pokémon hay por tipo primario. Haz que solo aparezcan los
-- tipos primarios que tengan al menos 3 pokémon. Ordena por total descendente. (En este caso estamos contando los nulos)
-- ============================================================================

SELECT COD_TIPO_1, COUNT(*) AS TOTAL_POKEMON
FROM POKEMON
GROUP BY COD_TIPO_1
HAVING COUNT(*) >= 3
ORDER BY TOTAL_POKEMON DESC;


-- ============================================================================
-- 2
-- Muestra el nombre, PS base y velocidad base de los pokémon cuyo PS base sea
-- mayor que 50. Ordena por velocidad descendente y nombre ascendente.
-- ============================================================================

SELECT NOMBRE, PS_BASE, VELOCIDAD_BASE
FROM POKEMON
WHERE PS_BASE > 50
ORDER BY VELOCIDAD_BASE DESC, NOMBRE ASC;


-- ============================================================================
-- 3
-- Muestra las regiones distintas existentes en la tabla MAPA.
-- ============================================================================

SELECT DISTINCT REGION
FROM MAPA;


-- ============================================================================
-- 4
-- Calcula la potencia media de los movimientos cuya potencia sea mayor que 0 y
-- la precisión máxima registrada en la tabla MOVIMIENTOS.
-- ============================================================================

SELECT AVG(POTENCIA) AS POTENCIA_MEDIA,
       MAX(PRECISION_MOV) AS PRECISION_MAXIMA
FROM MOVIMIENTOS
WHERE POTENCIA > 0;


-- ============================================================================
-- 5
-- Muestra cuántos objetos hay por efecto, excluyendo los objetos cuyo precio
-- sea 0. Haz que solo aparezcan los efectos que tengan al menos 1 objeto.
-- Ordena por nombre de efecto ascendente.
-- ============================================================================

SELECT EFECTO, COUNT(*) AS TOTAL_OBJETOS
FROM OBJETOS
WHERE PRECIO > 0
GROUP BY EFECTO
HAVING TOTAL_OBJETOS >= 1
ORDER BY EFECTO ASC;


-- Comentario:
-- Aunque HAVING COUNT(*) >= 1 no filtra mucho realmente, sirve para practicar
-- la estructura WHERE + GROUP BY + HAVING.


-- ============================================================================
-- 6
-- Muestra el nombre y precio de los objetos cuyo precio esté entre 200 y 2500.
-- Ordena por precio ascendente y, si empatan, por nombre descendente.
-- ============================================================================

SELECT NOMBRE, PRECIO
FROM OBJETOS
WHERE PRECIO BETWEEN 200 AND 2500
ORDER BY PRECIO ASC, NOMBRE DESC;


-- ============================================================================
-- 7
-- Muestra cuántos pokémon hay en cada zona asignada. No debes tener en cuenta
-- los pokémon sin zona. Ordena por total descendente.
-- ============================================================================

SELECT COD_ZONA, COUNT(*) AS TOTAL_POKEMON
FROM POKEMON
WHERE COD_ZONA IS NOT NULL
GROUP BY COD_ZONA
ORDER BY TOTAL_POKEMON DESC;


-- ============================================================================
-- 8
-- Muestra los códigos de tipo primario distintos que aparecen en la tabla
-- POKEMON.
-- ============================================================================

SELECT DISTINCT COD_TIPO_1
FROM POKEMON;


-- ============================================================================
-- 9
-- Muestra la experiencia media por estado en la tabla ENTRENADOR_POKEMON,
-- considerando solo los registros con experiencia mayor que 50000. Haz que solo
-- aparezcan los estados cuya experiencia media sea superior a 150000. Ordena
-- por experiencia media descendente.
-- ============================================================================

SELECT ESTADO, AVG(EXPERIENCIA) AS EXPERIENCIA_MEDIA
FROM ENTRENADOR_POKEMON
WHERE EXPERIENCIA > 50000
GROUP BY ESTADO
HAVING AVG(EXPERIENCIA) > 150000
ORDER BY EXPERIENCIA_MEDIA DESC;

-- Comentario:
-- EXPERIENCIA > 50000 va en WHERE porque filtra filas antes de agrupar.
-- AVG(EXPERIENCIA) > 150000 va en HAVING porque filtra grupos ya agregados.


-- ============================================================================
-- 10
-- Muestra el nombre y la zona de los entrenadores que sí tengan zona asignada.
-- Ordena por zona ascendente y nombre ascendente.
-- ============================================================================

SELECT NOMBRE, COD_ZONA
FROM ENTRENADOR
WHERE COD_ZONA IS NOT NULL
ORDER BY COD_ZONA ASC, NOMBRE ASC;


-- ============================================================================
-- 11
-- Calcula la media de ataque base por tipo primario para los pokémon cuyo
-- ataque base sea mayor que 40. Muestra solo los tipos cuya media sea mayor
-- que 70. Ordena por media descendente.
-- ============================================================================

SELECT COD_TIPO_1, AVG(ATAQUE_BASE) AS MEDIA_ATAQUE
FROM POKEMON
WHERE ATAQUE_BASE > 40
GROUP BY COD_TIPO_1
HAVING AVG(ATAQUE_BASE) > 70
ORDER BY MEDIA_ATAQUE DESC;


-- ============================================================================
-- 12
-- Muestra las categorías distintas existentes en la tabla MOVIMIENTOS.
-- ============================================================================

SELECT DISTINCT CATEGORIA
FROM MOVIMIENTOS;


-- ============================================================================
-- 13
-- Muestra el precio mínimo, máximo y medio de los objetos cuyo precio sea
-- mayor que 0.
-- ============================================================================

SELECT MIN(PRECIO) AS PRECIO_MINIMO,
       MAX(PRECIO) AS PRECIO_MAXIMO,
       AVG(PRECIO) AS PRECIO_MEDIO
FROM OBJETOS
WHERE PRECIO > 0;


-- ============================================================================
-- 14
-- Muestra cuántos movimientos hay de cada categoría, pero solo teniendo en
-- cuenta los movimientos con potencia mayor que 0. Haz que solo aparezcan las
-- categorías que tengan al menos 5 movimientos. Ordena por total descendente.
-- ============================================================================

SELECT CATEGORIA, COUNT(*) AS TOTAL_MOVIMIENTOS
FROM MOVIMIENTOS
WHERE POTENCIA > 0
GROUP BY CATEGORIA
HAVING COUNT(*) >= 5
ORDER BY TOTAL_MOVIMIENTOS DESC;


-- ============================================================================
-- 15
-- Muestra el nombre del tipo y su resistencia para los tipos cuya resistencia
-- no sea NULL. Ordena por nombre ascendente.
-- ============================================================================

SELECT NOMBRE, RESISTENCIA
FROM TIPOS
WHERE RESISTENCIA IS NOT NULL
ORDER BY NOMBRE ASC;


-- ============================================================================
-- 16
-- Muestra cuántos entrenadores hay por zona, excluyendo los entrenadores sin
-- zona. Haz que solo aparezcan las zonas con 2 o más entrenadores. Ordena por
-- zona ascendente.
-- ============================================================================

SELECT COD_ZONA, COUNT(*) AS TOTAL_ENTRENADORES
FROM ENTRENADOR
WHERE COD_ZONA IS NOT NULL
GROUP BY COD_ZONA
HAVING COUNT(*) >= 2
ORDER BY COD_ZONA ASC;


-- ============================================================================
-- 17
-- Calcula cuántos pokémon hay en total, cuántos tienen zona asignada y cuántos
-- tienen tipo secundario.
-- ============================================================================

SELECT COUNT(*) AS TOTAL_POKEMON,
       COUNT(COD_ZONA) AS CON_ZONA,
       COUNT(COD_TIPO_2) AS CON_TIPO_SECUNDARIO
FROM POKEMON;

-- Comentario:
-- COUNT(columna) no cuenta los NULL, por eso sirve para contar cuántos tienen
-- zona o tipo secundario informado.


-- ============================================================================
-- 18
-- Muestra la potencia media de los movimientos por tipo. Solo debes tener en
-- cuenta los movimientos con potencia mayor que 40. Haz que solo aparezcan los
-- tipos que tengan al menos 2 movimientos de ese tipo. Ordena por potencia
-- media descendente.
-- ============================================================================

SELECT COD_TIPO, AVG(POTENCIA) AS POTENCIA_MEDIA
FROM MOVIMIENTOS
WHERE POTENCIA > 40
GROUP BY COD_TIPO
HAVING COUNT(*) >= 2
ORDER BY POTENCIA_MEDIA DESC;


-- ============================================================================
-- 19
-- Muestra el nombre, potencia y precisión de los movimientos cuya potencia sea
-- mayor que 0 y cuya precisión sea menor que 100. Ordena por precisión
-- ascendente.
-- ============================================================================

SELECT NOMBRE, POTENCIA, PRECISION_MOV
FROM MOVIMIENTOS
WHERE POTENCIA > 0
  AND PRECISION_MOV < 100
ORDER BY PRECISION_MOV ASC;


-- ============================================================================
-- 20
-- Muestra cuántos registros hay por estado en la tabla ENTRENADOR_POKEMON,
-- pero solo teniendo en cuenta los pokémon cuyo nivel sea mayor o igual que 40.
-- Haz que solo aparezcan los estados que tengan al menos 3 registros. Ordena
-- por total descendente.
-- ============================================================================

SELECT ESTADO, COUNT(*) AS TOTAL_REGISTROS
FROM ENTRENADOR_POKEMON
WHERE NIVEL >= 40
GROUP BY ESTADO
HAVING COUNT(*) >= 3
ORDER BY TOTAL_REGISTROS DESC;


-- ============================================================================
-- 21
-- Muestra cuántos pokémon hay por zona, pero solo teniendo en cuenta los
-- pokémon cuyo PS base sea mayor que 40 y cuya velocidad base sea mayor que 60.
-- Excluye los pokémon sin zona. Haz que solo aparezcan las zonas con al menos
-- 2 pokémon. Ordena por total descendente y zona ascendente.
-- ============================================================================

SELECT COD_ZONA, COUNT(*) AS TOTAL_POKEMON
FROM POKEMON
WHERE PS_BASE > 40
  AND VELOCIDAD_BASE > 60
  AND COD_ZONA IS NOT NULL
GROUP BY COD_ZONA
HAVING COUNT(*) >= 2
ORDER BY TOTAL_POKEMON DESC, COD_ZONA ASC;


-- ============================================================================
-- 22
-- Muestra la media de defensa base por tipo primario, pero solo teniendo en
-- cuenta los pokémon cuya defensa base sea mayor que 30 y cuyo ataque base sea
-- mayor que 40. Haz que solo aparezcan los tipos cuya media de defensa sea
-- superior a 60. Ordena por media de defensa descendente.
-- ============================================================================

SELECT COD_TIPO_1, AVG(DEFENSA_BASE) AS MEDIA_DEFENSA
FROM POKEMON
WHERE DEFENSA_BASE > 30
  AND ATAQUE_BASE > 40
GROUP BY COD_TIPO_1
HAVING AVG(DEFENSA_BASE) > 60
ORDER BY MEDIA_DEFENSA DESC;


-- ============================================================================
-- 23
-- Muestra cuántos movimientos hay por categoría, pero solo teniendo en cuenta
-- los movimientos con potencia mayor que 40 y precisión mayor o igual que 95.
-- Haz que solo aparezcan las categorías con al menos 3 movimientos. Ordena por
-- total descendente y categoría ascendente.
-- ============================================================================

SELECT CATEGORIA, COUNT(*) AS TOTAL_MOVIMIENTOS
FROM MOVIMIENTOS
WHERE POTENCIA > 40
  AND PRECISION_MOV >= 95
GROUP BY CATEGORIA
HAVING COUNT(*) >= 3
ORDER BY TOTAL_MOVIMIENTOS DESC, CATEGORIA ASC;


-- ============================================================================
-- 24
-- Muestra la potencia media por tipo en la tabla MOVIMIENTOS, pero solo
-- teniendo en cuenta los movimientos con potencia mayor que 0 y PP menor o
-- igual que 20. Haz que solo aparezcan los tipos cuya potencia media sea
-- superior a 75. Ordena por potencia media descendente y tipo ascendente.
-- ============================================================================

SELECT COD_TIPO, AVG(POTENCIA) AS POTENCIA_MEDIA
FROM MOVIMIENTOS
WHERE POTENCIA > 0
  AND PP <= 20
GROUP BY COD_TIPO
HAVING AVG(POTENCIA) > 75
ORDER BY POTENCIA_MEDIA DESC, COD_TIPO ASC;


-- ============================================================================
-- 25
-- Muestra cuántos registros hay por estado en ENTRENADOR_POKEMON, pero solo
-- teniendo en cuenta los pokémon con experiencia mayor que 80000 y nivel mayor
-- o igual que 35. Haz que solo aparezcan los estados con al menos 4 registros.
-- Ordena por total descendente.
-- ============================================================================

SELECT ESTADO, COUNT(*) AS TOTAL_REGISTROS
FROM ENTRENADOR_POKEMON
WHERE EXPERIENCIA > 80000
  AND NIVEL >= 35
GROUP BY ESTADO
HAVING COUNT(*) >= 4
ORDER BY TOTAL_REGISTROS DESC;


-- ============================================================================
-- 26
-- Muestra la cantidad total de objetos por entrenador en ENTRENADOR_OBJETO,
-- pero solo teniendo en cuenta los registros cuya cantidad sea mayor o igual
-- que 10 y cuyo objeto no sea la Ball Maestra (COD_OBJETO <> 9). Haz que solo
-- aparezcan los entrenadores cuya suma total de objetos sea superior a 40.
-- Ordena por cantidad total descendente y código de entrenador ascendente.
-- ============================================================================

SELECT COD_ENTRENADOR, SUM(CANTIDAD) AS CANTIDAD_TOTAL
FROM ENTRENADOR_OBJETO
WHERE CANTIDAD >= 10
  AND COD_OBJETO <> 9
GROUP BY COD_ENTRENADOR
HAVING SUM(CANTIDAD) > 40
ORDER BY CANTIDAD_TOTAL DESC, COD_ENTRENADOR ASC;

===============================================================================