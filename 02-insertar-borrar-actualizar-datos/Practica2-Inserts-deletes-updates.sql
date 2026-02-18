-- ================================================================
-- EJEMPLOS DIDÁCTICOS: RESTRICCIONES DE BORRADO (FK)
-- Videoclub: PELICULAS, COPIAS, CLIENTES, ALQUILERES
-- ================================================================
-- Objetivo: Comprobar el comportamiento de CASCADE y RESTRICT
--           mediante inserts y deletes guiados.
-- ================================================================


-- ================================================================
-- 1. CARGA DE DATOS DE EJEMPLO
-- ================================================================

-- Películas
INSERT INTO PELICULAS VALUES (1001, 'El Padrino',      'drama');
INSERT INTO PELICULAS VALUES (1002, 'Tiburón',         'suspense');
INSERT INTO PELICULAS VALUES (1003, 'Scary Movie',     'comedia');
INSERT INTO PELICULAS VALUES (1004, 'Alien',           'ficcion');

-- Copias (varias por película)
INSERT INTO COPIAS VALUES (1, 1001, 'libre');
INSERT INTO COPIAS VALUES (2, 1001, 'alquilada');
INSERT INTO COPIAS VALUES (1, 1002, 'libre');
INSERT INTO COPIAS VALUES (2, 1002, 'libre');
INSERT INTO COPIAS VALUES (1, 1003, 'alquilada');
INSERT INTO COPIAS VALUES (1, 1004, 'libre');

-- Clientes
INSERT INTO CLIENTES VALUES (1, 'María Sánchez', '12345678A', 600111222);
INSERT INTO CLIENTES VALUES (2, 'Pedro Gómez',   '87654321B', 600333444);
INSERT INTO CLIENTES VALUES (3, 'Laura Torres',  '11223344C', 600555666);

-- Alquileres
INSERT INTO ALQUILERES VALUES (1, 2, 1001, DATE '2024-11-01');   -- María alquiló copia 2 de El Padrino
INSERT INTO ALQUILERES VALUES (2, 1, 1002, DATE '2024-11-05');   -- Pedro alquiló copia 1 de Tiburón
INSERT INTO ALQUILERES VALUES (1, 1, 1003, DATE '2024-11-10');   -- María alquiló copia 1 de Scary Movie
INSERT INTO ALQUILERES VALUES (3, 1, 1004, DATE '2024-11-12');   -- Laura alquiló copia 1 de Alien




-- ================================================================
-- 2. COMPROBACIÓN DE ON DELETE CASCADE
-- ================================================================

-- ----------------------------------------------------------------
-- CASO A: FK_COPIAS_PELICULAS → Al borrar una PELÍCULA, todas
--         sus COPIAS se eliminan automáticamente (CASCADE).
--
--         ⚠ ATENCIÓN: Para poder borrar la película primero deben
--         no existir ALQUILERES que referencien esa película
--         (RESTRICT de FK_ALQUILERES_PELICULAS y FK_ALQUILERES_COPIAS).
--         Por eso usamos la película 1004 (Alien), que SÍ tiene
--         copias pero cuyo alquiler vamos a borrar antes.
-- ----------------------------------------------------------------

-- Comprobamos las copias de Alien antes del borrado:
SELECT * FROM COPIAS WHERE CODPELICULA = 1004;
-- Resultado esperado: 1 fila → (1, 1004, 'libre')

-- El alquiler de Alien impide borrarla directamente. Lo eliminamos:
DELETE FROM ALQUILERES WHERE CODPELICULA = 1004;

-- Ahora sí borramos la película:
DELETE FROM PELICULAS WHERE CODPELICULA = 1004;


-- Verificamos que la copia huérfana ha desaparecido (CASCADE FK_COPIAS_PELICULAS):
SELECT * FROM COPIAS WHERE CODPELICULA = 1004;
-- Resultado esperado: 0 filas ✓

-- Verificamos que la película ya no existe:
SELECT * FROM PELICULAS WHERE CODPELICULA = 1004;
-- Resultado esperado: 0 filas ✓


-- ================================================================
-- 3. COMPROBACIÓN DE ON DELETE RESTRICT (comportamiento por defecto)
-- ================================================================

-- ----------------------------------------------------------------
-- CASO B: FK_ALQUILERES_CLIENTES → No se puede borrar un CLIENTE
--         que tenga ALQUILERES registrados (RESTRICT).
-- ----------------------------------------------------------------

-- Comprobamos los alquileres de María (cliente 1):
SELECT * FROM ALQUILERES WHERE CODCLIENTE = 1;
-- Resultado esperado: 2 filas (copia 2 de El Padrino y copia 1 de Scary Movie)

-- Intentamos borrar a María → DEBE FALLAR:
DELETE FROM CLIENTES WHERE CODCLIENTE = 1;
-- ERROR esperado:
--   ORA-02292: integrity constraint (FK_ALQUILERES_CLIENTES) violated - child record found
-- ✗ No se puede borrar porque tiene alquileres registrados.

-- Para poder borrarla habría que eliminar antes sus alquileres:
-- DELETE FROM ALQUILERES WHERE CODCLIENTE = 1;
-- DELETE FROM CLIENTES WHERE CODCLIENTE = 1; ← ahora sí funcionaría


-- ----------------------------------------------------------------
-- CASO C: FK_ALQUILERES_COPIAS → No se puede borrar una COPIA
--         que tenga ALQUILERES históricos asociados (RESTRICT).
-- ----------------------------------------------------------------

-- Comprobamos los alquileres de la copia 2 de El Padrino:
SELECT * FROM ALQUILERES WHERE CODCOPIA = 2 AND CODPELICULA = 1001;
-- Resultado esperado: 1 fila → (1, 2, 1001, ...)

-- Intentamos borrar esa copia → DEBE FALLAR:
DELETE FROM COPIAS WHERE CODCOPIA = 2 AND CODPELICULA = 1001;
-- ERROR esperado:
--   ORA-02292: integrity constraint (FK_ALQUILERES_COPIAS) violated - child record found
-- ✗ No se puede borrar porque tiene alquileres registrados.

-- Para poder borrarla habría que eliminar antes sus alquileres:
-- DELETE FROM ALQUILERES WHERE CODCOPIA = 2 AND CODPELICULA = 1001;
-- DELETE FROM COPIAS WHERE CODCOPIA = 2 AND CODPELICULA = 1001; ← ahora sí funcionaría


-- ----------------------------------------------------------------
-- CASO D: FK_ALQUILERES_PELICULAS → No se puede borrar una PELÍCULA
--         que tenga ALQUILERES históricos asociados (RESTRICT).
--         (Esta FK protege el historial de manera independiente a la
--          FK sobre COPIAS.)
-- ----------------------------------------------------------------

-- Comprobamos los alquileres de la película Tiburón (1002):
SELECT * FROM ALQUILERES WHERE CODPELICULA = 1002;
-- Resultado esperado: 1 fila → (2, 1, 1002, ...)

-- Intentamos borrar Tiburón → DEBE FALLAR (aunque CASCADE borraría
-- sus copias, RESTRICT en ALQUILERES lo impide primero):
DELETE FROM PELICULAS WHERE CODPELICULA = 1002;
-- ERROR esperado:
--   ORA-02292: integrity constraint (FK_ALQUILERES_PELICULAS) violated - child record found
-- ✗ No se puede borrar porque tiene alquileres registrados.

-- Para poder borrarla habría que eliminar antes sus alquileres:
-- DELETE FROM ALQUILERES  WHERE CODPELICULA = 1002;
-- DELETE FROM PELICULAS   WHERE CODPELICULA = 1002; ← ahora CASCADE borraría sus copias también


-- ----------------------------------------------------------------
-- CASO E (BONUS): Borrado en cadena correcto → orden que SÍ funciona
--         para eliminar completamente una película con historial.
-- ----------------------------------------------------------------

-- Queremos eliminar El Padrino (1001) que tiene copias y alquileres.
-- Orden correcto: primero alquileres, luego la película (CASCADE con copias).

-- Paso 1: eliminar alquileres de la película
DELETE FROM ALQUILERES WHERE CODPELICULA = 1001;
-- Paso 2: eliminar la película (CASCADE borrará sus copias automáticamente)
DELETE FROM PELICULAS WHERE CODPELICULA = 1001;


-- Verificamos que tanto la película como sus copias han desaparecido:
SELECT * FROM PELICULAS WHERE CODPELICULA = 1001;
-- Resultado esperado: 0 filas ✓
SELECT * FROM COPIAS WHERE CODPELICULA = 1001;
-- Resultado esperado: 0 filas ✓  (CASCADE en acción)


-- ================================================================
-- 4. RESUMEN DE RESULTADOS ESPERADOS
-- ================================================================
--
--  CASO  │ Acción                              │ Resultado
-- ───────┼─────────────────────────────────────┼───────────────────────────────
--   A    │ DELETE PELICULAS (1004, sin         │ ✓ Borra COPIAS asociadas
--        │ alquileres vivos)                   │   automáticamente (CASCADE)
-- ───────┼─────────────────────────────────────┼───────────────────────────────
--   B    │ DELETE CLIENTES (cliente con        │ ✗ ERROR: tiene alquileres
--        │ alquileres registrados)             │   registrados (RESTRICT)
-- ───────┼─────────────────────────────────────┼───────────────────────────────
--   C    │ DELETE COPIAS (copia con            │ ✗ ERROR: tiene alquileres
--        │ alquileres históricos)              │   históricos (RESTRICT)
-- ───────┼─────────────────────────────────────┼───────────────────────────────
--   D    │ DELETE PELICULAS (con alquileres    │ ✗ ERROR: historial de
--        │ históricos)                         │   alquileres (RESTRICT)
-- ───────┼─────────────────────────────────────┼───────────────────────────────
--   E    │ DELETE ordenado: alquileres →       │ ✓ Borrado completo correcto;
--   BONUS│ película (con CASCADE en copias)    │   COPIAS desaparecen solas
-- ================================================================