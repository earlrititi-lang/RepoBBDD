===============================================================================
SOLUCIONES — HOJA DE EJERCICIOS SQL (PARTE 1)
Base de Datos Pokémon - 1º DAM
Oracle SQL
===============================================================================

-- ============================================================================
-- 1
-- Obtén el nombre, defensa base y velocidad base de los pokémon con defensa
-- mayor o igual que 60 y velocidad menor que 90. Ordena por defensa
-- descendente y nombre ascendente.
-- ============================================================================

SELECT NOMBRE, DEFENSA_BASE, VELOCIDAD_BASE
FROM POKEMON
WHERE DEFENSA_BASE >= 60
  AND VELOCIDAD_BASE < 90
ORDER BY DEFENSA_BASE DESC, NOMBRE ASC;


-- ============================================================================
-- 2
-- Obtén el nombre y precio de los objetos cuyo precio esté entre 250 y 2500.
-- Ordena el resultado de mayor a menor precio.
-- ============================================================================

SELECT NOMBRE, PRECIO
FROM OBJETOS
WHERE PRECIO BETWEEN 250 AND 2500
ORDER BY PRECIO DESC;


-- ============================================================================
-- 3
-- Muestra el nombre y la zona de los entrenadores que tengan zona asignada.
-- Ordena por zona y después por nombre.
-- ============================================================================

SELECT NOMBRE, COD_ZONA
FROM ENTRENADOR
WHERE COD_ZONA IS NOT NULL
ORDER BY COD_ZONA ASC, NOMBRE ASC;


-- ============================================================================
-- 4
-- Muestra el nombre de los pokémon que tengan tipo secundario y cuyo nombre
-- empiece por G.
-- ============================================================================

SELECT NOMBRE
FROM POKEMON
WHERE COD_TIPO_2 IS NOT NULL
  AND NOMBRE LIKE 'G%';


-- ============================================================================
-- 5
-- Muestra el nombre, potencia y categoría de los movimientos cuya potencia
-- sea mayor que 70 y cuya categoría no sea ESTADO. Ordena por potencia
-- descendente.
-- ============================================================================

SELECT NOMBRE, POTENCIA, CATEGORIA
FROM MOVIMIENTOS
WHERE POTENCIA > 70
  AND CATEGORIA <> 'ESTADO'
ORDER BY POTENCIA DESC;


-- ============================================================================
-- 6
-- Muestra el nombre y la región de las zonas cuyo nombre contenga Ciudad.
-- ============================================================================

SELECT NOMBRE, REGION
FROM MAPA
WHERE NOMBRE LIKE '%Ciudad%';


-- ============================================================================
-- 7
-- Muestra el nombre, PS base y ataque base de los pokémon con PS entre 40 y 80
-- y ataque mayor que 60.
-- ============================================================================

SELECT NOMBRE, PS_BASE, ATAQUE_BASE
FROM POKEMON
WHERE PS_BASE BETWEEN 40 AND 80
  AND ATAQUE_BASE > 60;


-- ============================================================================
-- 8
-- Muestra el nombre y el tipo primario de los pokémon cuyo tipo primario esté
-- en 10, 13, 14 o 17.
-- ============================================================================

SELECT NOMBRE, COD_TIPO_1
FROM POKEMON
WHERE COD_TIPO_1 IN (10, 13, 14, 17);


-- ============================================================================
-- 9
-- Muestra el nombre y el efecto de los objetos cuyo precio sea 0 o mayor que
-- 9500.
-- ============================================================================

SELECT NOMBRE, EFECTO
FROM OBJETOS
WHERE PRECIO = 0
   OR PRECIO > 9500;


-- ============================================================================
-- 10
-- Muestra el nombre de los entrenadores cuyo nombre termine en Trainer, Rival
-- o Explorer.
-- ============================================================================

SELECT NOMBRE
FROM ENTRENADOR
WHERE NOMBRE LIKE '%Trainer'
   OR NOMBRE LIKE '%Rival'
   OR NOMBRE LIKE '%Explorer';


-- ============================================================================
-- 11
-- Muestra el nombre, potencia y precisión de los movimientos con precisión
-- menor que 100 y potencia mayor que 0. Ordena por precisión ascendente.
-- ============================================================================

SELECT NOMBRE, POTENCIA, PRECISION_MOV
FROM MOVIMIENTOS
WHERE PRECISION_MOV < 100
  AND POTENCIA > 0
ORDER BY PRECISION_MOV ASC;


-- ============================================================================
-- 12
-- Muestra el nombre y la velocidad base de los pokémon cuyo nombre contenga
-- la letra r y tengan velocidad mayor que 70.
-- ============================================================================

SELECT NOMBRE, VELOCIDAD_BASE
FROM POKEMON
WHERE LOWER(NOMBRE) LIKE '%r%'
  AND VELOCIDAD_BASE > 70;

-- Comentario:
-- Uso LOWER(NOMBRE) para que la búsqueda no dependa de si la letra está en
-- mayúscula o minúscula.


-- ============================================================================
-- 13
-- Muestra el nombre, código de habilidad y zona de los pokémon cuya zona sea
-- NULL o cuya habilidad sea la 14.
-- ============================================================================

SELECT NOMBRE, COD_HABILIDAD, COD_ZONA
FROM POKEMON
WHERE COD_ZONA IS NULL
   OR COD_HABILIDAD = 14;


-- ============================================================================
-- 14
-- Muestra el nombre, precio y descripción de los objetos cuyo nombre empiece
-- por Anti o por Poción.
-- ============================================================================

SELECT NOMBRE, PRECIO, DESCRIPCION
FROM OBJETOS
WHERE NOMBRE LIKE 'Anti%'
   OR NOMBRE LIKE 'Poción%';

-- Comentario:
-- Si en tus datos estuviera escrito sin tilde (por ejemplo, 'Pocion'), habría
-- que adaptar el patrón LIKE al dato real almacenado.


-- ============================================================================
-- 15
-- Muestra el nombre, PS base, defensa base y velocidad base de los pokémon con
-- defensa mayor que 50 y además velocidad mayor que 60 o PS mayor que 90.
-- ============================================================================

SELECT NOMBRE, PS_BASE, DEFENSA_BASE, VELOCIDAD_BASE
FROM POKEMON
WHERE DEFENSA_BASE > 50
  AND (VELOCIDAD_BASE > 60 OR PS_BASE > 90);

-- Comentario:
-- Los paréntesis son importantes. Sin ellos, Oracle evaluaría antes el AND
-- que el OR y el resultado podría no ser el deseado.


-- ============================================================================
-- 16
-- Muestra los movimientos físicos cuya potencia esté entre 40 y 90, excluyendo
-- los que tengan precisión 999.
-- ============================================================================

SELECT NOMBRE, POTENCIA, PRECISION_MOV, CATEGORIA
FROM MOVIMIENTOS
WHERE CATEGORIA = 'FISICO'
  AND POTENCIA BETWEEN 40 AND 90
  AND PRECISION_MOV <> 999;

-- Comentario importante:
-- En esta base de datos, PRECISION_MOV tiene una restricción CHECK entre 0 y 100,
-- así que el valor 999 no debería existir. La condición está bien escrita,
-- pero en esta BD concreta realmente no filtrará filas.


-- ============================================================================
-- 17
-- Muestra los entrenadores con zona no nula cuyo código de zona no esté en
-- 1, 4, 6 ni 9.
-- ============================================================================

SELECT NOMBRE, COD_ZONA
FROM ENTRENADOR
WHERE COD_ZONA IS NOT NULL
  AND COD_ZONA NOT IN (1, 4, 6, 9);


-- ============================================================================
-- 18
-- Muestra los pokémon cuyo nombre empiece por M y contenga la letra o en
-- cualquier posición posterior.
-- ============================================================================

SELECT NOMBRE
FROM POKEMON
WHERE NOMBRE LIKE 'M%o%';


-- ============================================================================
-- 19
-- Muestra los objetos cuyo precio sea menor que 300 o esté entre 2000 y 3000.
-- Ordena por precio ascendente.
-- ============================================================================

SELECT NOMBRE, PRECIO
FROM OBJETOS
WHERE PRECIO < 300
   OR PRECIO BETWEEN 2000 AND 3000
ORDER BY PRECIO ASC;


-- ============================================================================
-- 20
-- Muestra los movimientos cuyo nombre contenga Rayo y cuya potencia sea al
-- menos 50.
-- ============================================================================

SELECT NOMBRE, POTENCIA
FROM MOVIMIENTOS
WHERE NOMBRE LIKE '%Rayo%'
  AND POTENCIA >= 50;


-- ============================================================================
-- 21
-- Muestra los pokémon cuyo nombre empiece por D o por M y tenga una longitud
-- visual compatible con 8 o más caracteres usando patrones LIKE.
-- ============================================================================

SELECT NOMBRE
FROM POKEMON
WHERE NOMBRE LIKE 'D_______%'
   OR NOMBRE LIKE 'M_______%';

-- Comentario:
-- Aquí se pide expresamente usar patrones LIKE.
-- '_______' son 7 guiones bajos, es decir, 7 caracteres obligatorios después
-- de la primera letra. Con eso obligamos a que el nombre tenga al menos 8
-- caracteres en total.


-- ============================================================================
-- 22
-- Muestra el nombre y zona de los entrenadores cuya zona esté en
-- 3, 4, 6, 7, 8 o 10. Ordena por zona descendente.
-- ============================================================================

SELECT NOMBRE, COD_ZONA
FROM ENTRENADOR
WHERE COD_ZONA IN (3, 4, 6, 7, 8, 10)
ORDER BY COD_ZONA DESC;


-- ============================================================================
-- 23
-- Muestra los pokémon cuya velocidad esté entre 45 y 100 y no tengan tipo
-- secundario.
-- ============================================================================

SELECT NOMBRE, VELOCIDAD_BASE
FROM POKEMON
WHERE VELOCIDAD_BASE BETWEEN 45 AND 100
  AND COD_TIPO_2 IS NULL;


-- ============================================================================
-- 24
-- Muestra el nombre y el precio de los objetos cuyo nombre contenga ball
-- o Ball.
-- ============================================================================

SELECT NOMBRE, PRECIO
FROM OBJETOS
WHERE NOMBRE LIKE '%ball%'
   OR NOMBRE LIKE '%Ball%';

-- Comentario:
-- Oracle distingue mayúsculas y minúsculas en LIKE según los datos almacenados.
-- Por eso aquí se contemplan ambas posibilidades.


-- ============================================================================
-- 25
-- Muestra los movimientos con potencia entre 80 y 120 y precisión entre
-- 90 y 100. Ordena por potencia descendente.
-- ============================================================================

SELECT NOMBRE, POTENCIA, PRECISION_MOV
FROM MOVIMIENTOS
WHERE POTENCIA BETWEEN 80 AND 120
  AND PRECISION_MOV BETWEEN 90 AND 100
ORDER BY POTENCIA DESC;


-- ============================================================================
-- 26
-- Muestra los pokémon cuyo nombre termine en air, duck o dos.
-- ============================================================================

SELECT NOMBRE
FROM POKEMON
WHERE NOMBRE LIKE '%air'
   OR NOMBRE LIKE '%duck'
   OR NOMBRE LIKE '%dos';


-- ============================================================================
-- 27
-- Muestra el nombre y la región de las zonas cuya descripción contenga
-- pokémon o cuyo nombre contenga Cueva.
-- ============================================================================

SELECT NOMBRE, REGION
FROM MAPA
WHERE LOWER(DESCRIPCION) LIKE '%pokémon%'
   OR LOWER(DESCRIPCION) LIKE '%pokemon%'
   OR NOMBRE LIKE '%Cueva%';

-- Comentario:
-- Se contemplan 'pokémon' con tilde y 'pokemon' sin tilde por si los datos
-- no están escritos de forma uniforme.


-- ============================================================================
-- 28
-- Muestra el nombre, tipo primario y zona de los pokémon cuyo tipo primario
-- esté en 5, 8, 10 o 14 y tengan zona asignada.
-- ============================================================================

SELECT NOMBRE, COD_TIPO_1, COD_ZONA
FROM POKEMON
WHERE COD_TIPO_1 IN (5, 8, 10, 14)
  AND COD_ZONA IS NOT NULL;


-- ============================================================================
-- 29
-- Muestra el nombre, ataque base y velocidad base de todos los pokémon
-- ordenados por ataque descendente, velocidad descendente y nombre ascendente.
-- ============================================================================

SELECT NOMBRE, ATAQUE_BASE, VELOCIDAD_BASE
FROM POKEMON
ORDER BY ATAQUE_BASE DESC, VELOCIDAD_BASE DESC, NOMBRE ASC;


-- ============================================================================
-- 30
-- Muestra el nombre y precio de los objetos ordenados por precio ascendente y,
-- si empatan, por nombre descendente.
-- ============================================================================

SELECT NOMBRE, PRECIO
FROM OBJETOS
ORDER BY PRECIO ASC, NOMBRE DESC;


-- ============================================================================
-- 31
-- Muestra el nombre, tipo primario y zona de los pokémon con zona asignada
-- ordenados por zona ascendente y tipo primario descendente.
-- ============================================================================

SELECT NOMBRE, COD_TIPO_1, COD_ZONA
FROM POKEMON
WHERE COD_ZONA IS NOT NULL
ORDER BY COD_ZONA ASC, COD_TIPO_1 DESC;


-- ============================================================================
-- 32
-- Muestra el nombre y precisión de los movimientos ordenados por precisión
-- descendente y nombre ascendente.
-- ============================================================================

SELECT NOMBRE, PRECISION_MOV
FROM MOVIMIENTOS
ORDER BY PRECISION_MOV DESC, NOMBRE ASC;


-- ============================================================================
-- 33
-- Muestra el nombre y zona de los entrenadores ordenados por zona dejando los
-- NULL al final y luego por nombre.
-- ============================================================================

SELECT NOMBRE, COD_ZONA
FROM ENTRENADOR
ORDER BY COD_ZONA ASC NULLS LAST, NOMBRE ASC;

-- Comentario:
-- En Oracle se puede controlar explícitamente dónde aparecen los NULL con
-- NULLS FIRST o NULLS LAST.


-- ============================================================================
-- 34
-- Muestra el nombre, PS base y defensa base de los pokémon con PS mayor que 50,
-- ordenados por defensa ascendente y PS descendente.
-- ============================================================================

SELECT NOMBRE, PS_BASE, DEFENSA_BASE
FROM POKEMON
WHERE PS_BASE > 50
ORDER BY DEFENSA_BASE ASC, PS_BASE DESC;


-- ============================================================================
-- 35
-- Muestra los códigos de habilidad distintos que aparecen en la tabla POKEMON.
-- ============================================================================

SELECT DISTINCT COD_HABILIDAD
FROM POKEMON;


-- ============================================================================
-- 36
-- Muestra las combinaciones distintas de tipo primario y zona en los pokémon
-- que sí tienen zona asignada.
-- ============================================================================

SELECT DISTINCT COD_TIPO_1, COD_ZONA
FROM POKEMON
WHERE COD_ZONA IS NOT NULL;

-- Comentario:
-- DISTINCT aquí se aplica a la combinación completa (COD_TIPO_1, COD_ZONA),
-- no a cada columna por separado.


-- ============================================================================
-- 37
-- Muestra las regiones distintas existentes en la tabla MAPA.
-- ============================================================================

SELECT DISTINCT REGION
FROM MAPA;


-- ============================================================================
-- 38
-- Muestra las categorías distintas existentes en la tabla MOVIMIENTOS.
-- ============================================================================

SELECT DISTINCT CATEGORIA
FROM MOVIMIENTOS;


-- ============================================================================
-- 39
-- Calcula cuántos pokémon tienen zona asignada.
-- ============================================================================

SELECT COUNT(*) AS TOTAL_POKEMON_CON_ZONA
FROM POKEMON
WHERE COD_ZONA IS NOT NULL;

-- Comentario:
-- Aquí COUNT(*) cuenta las filas que han pasado el filtro del WHERE.


-- ============================================================================
-- 40
-- Calcula cuántos pokémon no tienen zona asignada, la potencia media de los
-- movimientos con potencia mayor que 0 y la precisión máxima registrada.
-- ============================================================================

SELECT
    (SELECT COUNT(*)
     FROM POKEMON
     WHERE COD_ZONA IS NULL) AS POKEMON_SIN_ZONA,
    (SELECT ROUND(AVG(POTENCIA), 2)
     FROM MOVIMIENTOS
     WHERE POTENCIA > 0) AS POTENCIA_MEDIA,
    (SELECT MAX(PRECISION_MOV)
     FROM MOVIMIENTOS) AS PRECISION_MAXIMA
FROM DUAL;

-- Comentario importante:
-- Aquí conviene usar subconsultas en el SELECT porque estamos mezclando
-- resultados agregados que vienen de una o varias tablas y queremos obtener
-- una sola fila final con varias columnas resumen.
--
-- DUAL es la tabla especial de Oracle que se usa cuando queremos devolver
-- una fila calculada sin depender directamente de una tabla principal.