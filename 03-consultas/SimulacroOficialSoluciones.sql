-- ============================================================================
-- Examen SQL - Enunciados y posibles soluciones equivalentes
-- Base de datos Pokemon
-- ============================================================================

-- ============================================================================
-- Ejercicio 1
-- Enunciado:
-- Muestra el nombre del pokemon y el nombre de los movimientos cuyo tipo
-- coincida con el tipo secundario del pokemon. Solo deben aparecer movimientos
-- con potencia mayor que 0. Ordena por nombre del pokemon ascendente y nombre
-- del movimiento ascendente.
-- ============================================================================

-- Solucion 1
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS MOVIMIENTO
FROM POKEMON P
INNER JOIN MOVIMIENTOS M
    ON P.COD_TIPO_2 = M.COD_TIPO
    AND M.POTENCIA > 0
ORDER BY P.NOMBRE ASC, M.NOMBRE ASC;

SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS MOVIMIENTO
FROM POKEMON P
LEFT JOIN MOVIMIENTOS M
    ON P.COD_TIPO_2 = M.COD_TIPO
WHERE M.POTENCIA > 0
ORDER BY P.NOMBRE ASC, M.NOMBRE ASC;

SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS MOVIMIENTO
FROM POKEMON P
RIGHT JOIN MOVIMIENTOS M
    ON P.COD_TIPO_2 = M.COD_TIPO
WHERE M.POTENCIA > 0 
ORDER BY P.NOMBRE ASC, M.NOMBRE ASC;



-- Solucion 2: mismo INNER JOIN, poniendo el filtro del movimiento en el ON
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS MOVIMIENTO
FROM POKEMON P
INNER JOIN MOVIMIENTOS M
    ON P.COD_TIPO_2 = M.COD_TIPO
   AND M.POTENCIA > 0
ORDER BY P.NOMBRE ASC, M.NOMBRE ASC;

-- Solucion 3: mismo resultado empezando desde MOVIMIENTOS
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS MOVIMIENTO
FROM MOVIMIENTOS M
INNER JOIN POKEMON P
    ON P.COD_TIPO_2 = M.COD_TIPO
WHERE M.POTENCIA > 0
ORDER BY P.NOMBRE ASC, M.NOMBRE ASC;

-- ============================================================================
-- Ejercicio 2
-- Enunciado:
-- Muestra el nombre de todas las zonas y el nombre del entrenador que este en
-- cada zona. Deben aparecer tambien las zonas sin entrenador. Ordena por nombre
-- de zona ascendente y nombre de entrenador ascendente.
-- ============================================================================

-- Solucion 1
SELECT M.NOMBRE AS ZONA,
       E.NOMBRE AS ENTRENADOR
FROM MAPA M
LEFT JOIN ENTRENADOR E
    ON M.COD_ZONA = E.COD_ZONA
ORDER BY M.NOMBRE ASC, E.NOMBRE ASC;

-- Solucion 2: equivalente usando RIGHT JOIN y cambiando el orden de las tablas
SELECT M.NOMBRE AS ZONA,
       E.NOMBRE AS ENTRENADOR
FROM ENTRENADOR E
RIGHT JOIN MAPA M
    ON M.COD_ZONA = E.COD_ZONA
ORDER BY M.NOMBRE ASC, E.NOMBRE ASC;

-- ============================================================================
-- Ejercicio 3
-- Enunciado:
-- Muestra el nombre de todos los movimientos y el codigo de los pokemon que
-- pueden aprenderlos. Deben aparecer tambien los movimientos que no tenga
-- asignado ningun pokemon. Ordena por nombre del movimiento ascendente y codigo
-- de pokemon ascendente.
-- ============================================================================

-- Solucion 1
SELECT M.NOMBRE AS MOVIMIENTO,
       PM.COD_POKEMON
FROM POKEMON_MOVIMIENTO PM
RIGHT JOIN MOVIMIENTOS M
    ON PM.COD_MOVIMIENTO = M.COD_MOVIMIENTO
ORDER BY M.NOMBRE ASC, PM.COD_POKEMON ASC;

-- Solucion 2: equivalente usando LEFT JOIN desde MOVIMIENTOS
SELECT M.NOMBRE AS MOVIMIENTO,
       PM.COD_POKEMON
FROM MOVIMIENTOS M
LEFT JOIN POKEMON_MOVIMIENTO PM
    ON PM.COD_MOVIMIENTO = M.COD_MOVIMIENTO
ORDER BY M.NOMBRE ASC, PM.COD_POKEMON ASC;

-- ============================================================================
-- Ejercicio 4
-- Enunciado:
-- Muestra cada estado de ENTRENADOR_POKEMON y cuantos registros hay en ese
-- estado. Solo deben aparecer los estados con 2 o mas registros. Ordena por
-- total de registros descendente y estado ascendente.
-- ============================================================================

-- Solucion 1
SELECT ESTADO,
       COUNT(*) AS TOTAL_REGISTROS
FROM ENTRENADOR_POKEMON
GROUP BY ESTADO
HAVING COUNT(*) >= 2
ORDER BY TOTAL_REGISTROS DESC, ESTADO ASC;

-- Solucion 2: equivalente porque ESTADO es una columna obligatoria
SELECT ESTADO,
       COUNT(ESTADO) AS TOTAL_REGISTROS
FROM ENTRENADOR_POKEMON
GROUP BY ESTADO
HAVING COUNT(ESTADO) >= 2
ORDER BY TOTAL_REGISTROS DESC, ESTADO ASC;

-- ============================================================================
-- Ejercicio 5
-- Enunciado:
-- Muestra el nombre del entrenador, cuantos pokemon activos tiene, la
-- experiencia media de esos pokemon redondeada a 2 decimales y el nivel maximo
-- de sus pokemon activos. Solo deben aparecer los entrenadores que tengan al
-- menos 3 pokemon activos, experiencia media superior a 180000 y algun pokemon
-- activo de nivel 60 o superior. Ordena por experiencia media descendente y
-- nombre del entrenador ascendente.
-- ============================================================================

-- Solucion 1
SELECT E.NOMBRE AS ENTRENADOR,
       COUNT(*) AS TOTAL_POKEMON_ACTIVOS,
       ROUND(AVG(EP.EXPERIENCIA), 2) AS EXPERIENCIA_MEDIA,
       MAX(EP.NIVEL) AS NIVEL_MAXIMO_ACTIVO
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
WHERE EP.ESTADO = 'ACTIVO'
GROUP BY E.NOMBRE
HAVING COUNT(*) >= 3
   AND AVG(EP.EXPERIENCIA) > 180000
   AND MAX(EP.NIVEL) >= 60
ORDER BY EXPERIENCIA_MEDIA DESC, E.NOMBRE ASC;

-- Solucion 2: equivalente moviendo el filtro de estado al ON del INNER JOIN
SELECT E.NOMBRE AS ENTRENADOR,
       COUNT(EP.COD_POKEMON) AS TOTAL_POKEMON_ACTIVOS,
       ROUND(AVG(EP.EXPERIENCIA), 2) AS EXPERIENCIA_MEDIA,
       MAX(EP.NIVEL) AS NIVEL_MAXIMO_ACTIVO
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
   AND EP.ESTADO = 'ACTIVO'
GROUP BY E.NOMBRE
HAVING COUNT(EP.COD_POKEMON) >= 3
   AND AVG(EP.EXPERIENCIA) > 180000
   AND MAX(EP.NIVEL) >= 60
ORDER BY EXPERIENCIA_MEDIA DESC, E.NOMBRE ASC;

-- ============================================================================
-- Ejercicio 6
-- Enunciado:
-- Muestra el codigo del entrenador y la cantidad total de objetos que tiene,
-- pero solo sumando los registros cuya cantidad sea mayor que 5. Solo deben
-- aparecer entrenadores cuya suma total sea superior a 40. Ordena por cantidad
-- total descendente y codigo de entrenador ascendente.
-- ============================================================================

-- Solucion 1
SELECT COD_ENTRENADOR,
       SUM(CANTIDAD) AS CANTIDAD_TOTAL
FROM ENTRENADOR_OBJETO
WHERE CANTIDAD > 5
GROUP BY COD_ENTRENADOR
HAVING SUM(CANTIDAD) > 40
ORDER BY CANTIDAD_TOTAL DESC, COD_ENTRENADOR ASC;

-- Solucion 2: equivalente filtrando el resultado agregado en una subconsulta
SELECT COD_ENTRENADOR,
       CANTIDAD_TOTAL
FROM (
    SELECT COD_ENTRENADOR,
           SUM(CANTIDAD) AS CANTIDAD_TOTAL
    FROM ENTRENADOR_OBJETO
    WHERE CANTIDAD > 5
    GROUP BY COD_ENTRENADOR
)
WHERE CANTIDAD_TOTAL > 40
ORDER BY CANTIDAD_TOTAL DESC, COD_ENTRENADOR ASC;

-- ============================================================================
-- Ejercicio 7
-- Enunciado:
-- Muestra los codigos de pokemon distintos que aparecen en la tabla
-- POKEMON_MOVIMIENTO. Ordena por codigo de pokemon ascendente.
-- ============================================================================

-- Solucion 1: usando DISTINCT
SELECT DISTINCT COD_POKEMON
FROM POKEMON_MOVIMIENTO
ORDER BY COD_POKEMON ASC;

-- Solucion 2: equivalente usando GROUP BY
SELECT COD_POKEMON
FROM POKEMON_MOVIMIENTO
GROUP BY COD_POKEMON
ORDER BY COD_POKEMON ASC;

-- ============================================================================
-- Ejercicio 8
-- Enunciado:
-- Muestra el nombre, la potencia y la precision de los movimientos de categoria
-- ESPECIAL cuya potencia sea mayor que 80. Ordena por potencia descendente y
-- nombre ascendente.
-- ============================================================================

-- Solucion 1
SELECT NOMBRE,
       POTENCIA,
       PRECISION_MOV
FROM MOVIMIENTOS
WHERE CATEGORIA = 'ESPECIAL'
  AND POTENCIA > 80
ORDER BY POTENCIA DESC, NOMBRE ASC;
