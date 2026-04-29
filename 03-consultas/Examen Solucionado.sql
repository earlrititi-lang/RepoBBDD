-- ============================================================================
-- SOLUCION EXAMEN
-- Base de datos Pokemon
-- ============================================================================

-- ============================================================================
-- ENUNCIADOS
-- ============================================================================

-- Ejercicio 1
-- Muestra el nombre de todos los Pokemon junto con el nombre de la zona en la
-- que aparecen. Deben aparecer todos los Pokemon, incluso aquellos que no
-- tengan zona asignada. Ordena por nombre de los pokemon ascendente.

-- Ejercicio 2
-- Muestra el nombre de todos los Pokemon junto con el nombre de su tipo
-- principal. Ordena por nombre del tipo descendente.

-- Ejercicio 3
-- Muestra todos los datos disponibles de los objetos que existen.

-- Ejercicio 4
-- Muestra el nombre, descripcion y precio de los objetos cuyo precio sea mayor
-- o igual que 300.

-- Ejercicio 5
-- Muestra el nombre, PS base, ataque base y velocidad base de los Pokemon cuyo
-- tipo principal/primario sea el tipo con codigo 1.

-- Ejercicio 6
-- Muestra el codigo del entrenador, el codigo del objeto y la cantidad de
-- objetos que posee el entrenador con codigo 1.

-- Ejercicio 7
-- Muestra el nombre del movimiento junto con el nombre de su tipo. Ordena por
-- nombre descendente.

-- Ejercicio 8
-- Muestra el nombre del entrenador, cuantos pokemon activos tiene, la
-- experiencia media de esos pokemon redondeada a 2 decimales y el nivel maximo
-- de sus pokemon activos. Solo deben aparecer los entrenadores que tengan al
-- menos 3 pokemon activos, experiencia media superior a 180000 y algun pokemon
-- activo de nivel 60 o superior. Ordena por experiencia media descendente y
-- nombre del entrenador ascendente.

-- Ejercicio 9
-- Muestra el nombre de todos los entrenadores junto con el nombre de la zona
-- en la que se encuentran. Deben aparecer todos los entrenadores, incluso
-- aquellos que no tengan zona asignada.


-- ============================================================================
-- SOLUCIONES
-- ============================================================================

-- Ejercicio 1
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS ZONA
FROM POKEMON P
LEFT JOIN MAPA M
    ON P.COD_ZONA = M.COD_ZONA
ORDER BY P.NOMBRE ASC;


-- Ejercicio 2
SELECT P.NOMBRE AS POKEMON,
       T.NOMBRE AS TIPO_PRINCIPAL
FROM POKEMON P
INNER JOIN TIPOS T
    ON P.COD_TIPO_1 = T.COD_TIPO
ORDER BY T.NOMBRE DESC, P.NOMBRE ASC;


-- Ejercicio 3
SELECT *
FROM OBJETOS;


-- Ejercicio 4
SELECT NOMBRE,
       DESCRIPCION,
       PRECIO
FROM OBJETOS
WHERE PRECIO >= 300;


-- Ejercicio 5
SELECT NOMBRE,
       PS_BASE,
       ATAQUE_BASE,
       VELOCIDAD_BASE
FROM POKEMON
WHERE COD_TIPO_1 = 1;


-- Ejercicio 6
SELECT COD_ENTRENADOR,
       COD_OBJETO,
       CANTIDAD
FROM ENTRENADOR_OBJETO
WHERE COD_ENTRENADOR = 1;


-- Ejercicio 7
SELECT M.NOMBRE AS MOVIMIENTO,
       T.NOMBRE AS TIPO
FROM MOVIMIENTOS M
INNER JOIN TIPOS T
    ON M.COD_TIPO = T.COD_TIPO
ORDER BY M.NOMBRE DESC, T.NOMBRE ASC;


-- Ejercicio 8
SELECT E.NOMBRE AS ENTRENADOR,
       COUNT(*) AS TOTAL_POKEMON_ACTIVOS,
       ROUND(AVG(EP.EXPERIENCIA), 2) AS EXPERIENCIA_MEDIA,
       MAX(EP.NIVEL) AS NIVEL_MAXIMO_ACTIVO
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
WHERE UPPER(EP.ESTADO) = 'ACTIVO'
GROUP BY E.NOMBRE
HAVING COUNT(*) >= 3
   AND AVG(EP.EXPERIENCIA) > 180000
   AND MAX(EP.NIVEL) >= 60
ORDER BY EXPERIENCIA_MEDIA DESC, E.NOMBRE ASC;


-- Ejercicio 9
SELECT E.NOMBRE AS ENTRENADOR,
       M.NOMBRE AS ZONA
FROM ENTRENADOR E
LEFT JOIN MAPA M
    ON E.COD_ZONA = M.COD_ZONA;
