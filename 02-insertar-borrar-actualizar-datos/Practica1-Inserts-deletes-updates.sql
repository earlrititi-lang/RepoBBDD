-- ================================================================
-- EJEMPLOS DIDÁCTICOS: RESTRICCIONES DE BORRADO (FK)
-- ================================================================
-- Objetivo: Comprobar el comportamiento de CASCADE y RESTRICT
--           mediante inserts y deletes guiados.
-- ================================================================

-- COMMIT confirma y hace permanentes todas las operaciones de la transacción actual (INSERT, UPDATE, DELETE) en la base de datos.
-- Oracle no guarda los cambios inmediatamente al ejecutar una sentencia DML. En cambio, los mantiene en una transacción pendiente que solo tú puedes ver, hasta que ocurre una de estas dos cosas:

-- COMMIT → los cambios se guardan definitivamente y son visibles para todos los usuarios.
-- ROLLBACK → los cambios se descartan como si nunca hubieran ocurrido.

-- En los ejercicios se usa COMMIT después de los inserts para que los datos de ejemplo queden fijos antes de pasar a los deletes, y después de los deletes que sí deben ejecutarse correctamente (los casos CASCADE) para confirmar el resultado.pero si elimino los commits sigue funcionando, 
-- los ejercicios seguirían funcionando igual durante la misma sesión. Mientras no cierres la sesión Oracle mantiene todos los cambios visibles para ti, con o sin COMMIT.
-- Lo único que cambia si quitas los COMMIT es que al final de la sesión, si la cierras sin confirmar, Oracle hace un ROLLBACK automático y pierdes todos los inserts.
-- En el examen esto no es necesario.


-- ================================================================
-- 1. CARGA DE DATOS DE EJEMPLO
-- ================================================================

-- Diseñadores
INSERT INTO DISENADOR VALUES ('D01', 'Ana García',    'UX Design',         5);
INSERT INTO DISENADOR VALUES ('D02', 'Luis Martínez', 'Diseño Gráfico',    3);
INSERT INTO DISENADOR VALUES ('D03', 'Marta López',   'Motion Graphics',   8);
INSERT INTO DISENADOR VALUES ('D04', 'Carlos Ruiz',   'Diseño Editorial',  2);
COMMIT;

-- Proyectos (D01 y D03 son líderes)
INSERT INTO PROYECTO VALUES ('P01', 'Rediseño Web',     'Renovación completa del sitio web corporativo',    'D01');
INSERT INTO PROYECTO VALUES ('P02', 'App Móvil',        'Diseño de interfaz para aplicación iOS y Android', 'D03');
INSERT INTO PROYECTO VALUES ('P03', 'Campaña Verano',   'Materiales gráficos para campaña de verano',       'D01');
COMMIT;
-- Roles del líder en cada proyecto
INSERT INTO LIDER_ROL VALUES ('P01', 'Director Creativo');
INSERT INTO LIDER_ROL VALUES ('P01', 'Responsable UX');
INSERT INTO LIDER_ROL VALUES ('P02', 'Director de Arte');
INSERT INTO LIDER_ROL VALUES ('P03', 'Director Creativo');
COMMIT;
-- Perfiles profesionales (uno por diseñador)
INSERT INTO PERFIL_PROFESIONAL VALUES ('PP01', 'D01', DATE '2020-03-15');
INSERT INTO PERFIL_PROFESIONAL VALUES ('PP02', 'D02', DATE '2021-07-22');
INSERT INTO PERFIL_PROFESIONAL VALUES ('PP03', 'D03', DATE '2019-01-10');
COMMIT;
-- Colaboraciones
INSERT INTO COLABORACION VALUES ('D02', 'P01', DATE '2024-01-10', 'activo');
INSERT INTO COLABORACION VALUES ('D02', 'P03', DATE '2024-03-05', 'activo');
INSERT INTO COLABORACION VALUES ('D04', 'P01', DATE '2024-02-01', 'finalizado');
INSERT INTO COLABORACION VALUES ('D03', 'P03', DATE '2024-04-01', 'pausado');
COMMIT;


-- ================================================================
-- 2. COMPROBACIÓN DE ON DELETE CASCADE
-- ================================================================

-- ----------------------------------------------------------------
-- CASO A: FK_LR_PROY → Al borrar un PROYECTO, sus LIDER_ROL
--         se eliminan automáticamente (CASCADE).
-- ----------------------------------------------------------------

-- Primero comprobamos los roles que tiene P03 antes de borrarlo:
SELECT * FROM LIDER_ROL WHERE ID_PROYECTO = 'P03';
-- Resultado esperado: 1 fila → ('P03', 'Director Creativo')

-- También comprobamos las colaboraciones de P03:
SELECT * FROM COLABORACION WHERE ID_PROYECTO = 'P03';
-- Resultado esperado: 2 filas → D02/P03 y D03/P03

-- Ahora eliminamos el proyecto P03:
DELETE FROM PROYECTO WHERE ID_PROYECTO = 'P03';
COMMIT;

-- Verificamos que los LIDER_ROL de P03 han desaparecido (CASCADE FK_LR_PROY):
SELECT * FROM LIDER_ROL WHERE ID_PROYECTO = 'P03';
-- Resultado esperado: 0 filas ✓

-- Verificamos que las COLABORACIONES de P03 también han desaparecido (CASCADE FK_COLAB_PROY):
SELECT * FROM COLABORACION WHERE ID_PROYECTO = 'P03';
-- Resultado esperado: 0 filas ✓

-- (Restauramos para los siguientes ejercicios)
INSERT INTO PROYECTO    VALUES ('P03', 'Campaña Verano', 'Materiales gráficos para campaña de verano', 'D01');
INSERT INTO LIDER_ROL   VALUES ('P03', 'Director Creativo');
INSERT INTO COLABORACION VALUES ('D02', 'P03', DATE '2024-03-05', 'activo');
INSERT INTO COLABORACION VALUES ('D03', 'P03', DATE '2024-04-01', 'pausado');
COMMIT;


-- ----------------------------------------------------------------
-- CASO B: FK_PERFIL_DIS → Al borrar un DISEÑADOR, su
--         PERFIL_PROFESIONAL se elimina automáticamente (CASCADE).
-- ----------------------------------------------------------------

-- Comprobamos el perfil de D04 (ojo: D04 no tiene perfil creado,
-- usaremos D02 que sí lo tiene y no lidera proyectos):
SELECT * FROM PERFIL_PROFESIONAL WHERE ID_DISENADOR = 'D02';
-- Resultado esperado: 1 fila → PP02

-- Pero D02 tiene colaboraciones → RESTRICT impedirá borrarle.
-- Primero borramos sus colaboraciones para poder eliminarle:
DELETE FROM COLABORACION WHERE ID_DISENADOR = 'D02';
COMMIT;
-- Ahora sí podemos borrar al diseñador:
DELETE FROM DISENADOR WHERE ID_DISENADOR = 'D02';
COMMIT;

-- Verificamos que su perfil ha desaparecido (CASCADE FK_PERFIL_DIS):
SELECT * FROM PERFIL_PROFESIONAL WHERE ID_DISENADOR = 'D02';
-- Resultado esperado: 0 filas ✓

-- (Restauramos D02 para los siguientes ejercicios)
INSERT INTO DISENADOR        VALUES ('D02', 'Luis Martínez', 'Diseño Gráfico', 3);
INSERT INTO PERFIL_PROFESIONAL VALUES ('PP02', 'D02', DATE '2021-07-22');
INSERT INTO COLABORACION      VALUES ('D02', 'P01', DATE '2024-01-10', 'activo');
INSERT INTO COLABORACION      VALUES ('D02', 'P03', DATE '2024-03-05', 'activo');
COMMIT;


-- ================================================================
-- 3. COMPROBACIÓN DE ON DELETE RESTRICT (comportamiento por defecto)
-- ================================================================

-- ----------------------------------------------------------------
-- CASO C: FK_COLAB_DIS → No se puede borrar un DISEÑADOR que
--         tenga COLABORACIONES registradas (RESTRICT).
-- ----------------------------------------------------------------

-- Comprobamos las colaboraciones de D02:
SELECT * FROM COLABORACION WHERE ID_DISENADOR = 'D02';
-- Resultado esperado: 2 filas (P01 y P03)

-- Intentamos borrar a D02 → DEBE FALLAR con error de integridad:
DELETE FROM DISENADOR WHERE ID_DISENADOR = 'D02';
COMMIT;
-- ERROR esperado:
--   ORA-02292: integrity constraint (FK_COLAB_DIS) violated - child record found
-- ✗ No se puede borrar porque tiene colaboraciones registradas.

-- Para poder borrarlo habría que eliminar antes sus colaboraciones:
-- DELETE FROM COLABORACION WHERE ID_DISENADOR = 'D02';
-- DELETE FROM DISENADOR WHERE ID_DISENADOR = 'D02'; ← ahora sí funcionaría


-- ----------------------------------------------------------------
-- CASO D: FK_PROY_LIDER → No se puede borrar un DISEÑADOR que
--         lidere algún PROYECTO (RESTRICT).
-- ----------------------------------------------------------------

-- Comprobamos los proyectos que lidera D01:
SELECT * FROM PROYECTO WHERE ID_LIDER = 'D01';
-- Resultado esperado: 2 filas (P01 y P03)

-- Intentamos borrar a D01 → DEBE FALLAR con error de integridad:
DELETE FROM DISENADOR WHERE ID_DISENADOR = 'D01';
COMMIT;
-- ERROR esperado:
--   ORA-02292: integrity constraint (FK_PROY_LIDER) violated - child record found
-- ✗ No se puede borrar porque lidera proyectos activos.

-- Para poder borrarlo habría que reasignar primero el liderazgo:
-- UPDATE PROYECTO SET ID_LIDER = 'D03' WHERE ID_LIDER = 'D01';
-- DELETE FROM DISENADOR WHERE ID_DISENADOR = 'D01'; ← ahora sí funcionaría


-- ================================================================
-- 4. RESUMEN DE RESULTADOS ESPERADOS
-- ================================================================
--
--  CASO  │ Acción                          │ Resultado
-- ───────┼─────────────────────────────────┼──────────────────────────
--   A    │ DELETE PROYECTO P03             │ ✓ Borra LIDER_ROL y
--        │                                 │   COLABORACION (CASCADE)
-- ───────┼─────────────────────────────────┼──────────────────────────
--   B    │ DELETE DISENADOR D02            │ ✓ Borra PERFIL_PROFESIONAL
--        │ (sin colaboraciones previas)     │   automáticamente (CASCADE)
-- ───────┼─────────────────────────────────┼──────────────────────────
--   C    │ DELETE DISENADOR D02            │ ✗ ERROR: tiene
--        │ (con colaboraciones)             │   colaboraciones (RESTRICT)
-- ───────┼─────────────────────────────────┼──────────────────────────
--   D    │ DELETE DISENADOR D01            │ ✗ ERROR: lidera proyectos
--        │ (lidera proyectos)               │   activos (RESTRICT)
-- ================================================================