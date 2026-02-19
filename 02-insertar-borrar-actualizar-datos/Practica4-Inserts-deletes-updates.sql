-- ================================================================
-- EJEMPLOS DIDÁCTICOS: RESTRICCIONES DE BORRADO (FK)
-- Denuncias: INFRACCION, INFRACTOR, AGENTE, PROPIETARIO,
--            VEHICULO, DENUNCIA
-- ================================================================
-- Objetivo: Comprobar CASCADE, SET NULL y RESTRICT mediante
--           inserts y deletes guiados.
-- ================================================================


-- ================================================================
-- 1. CARGA DE DATOS DE EJEMPLO
-- ================================================================

-- Infracciones
INSERT INTO INFRACCION VALUES (1, 200.00, 'Exceso de velocidad en vía urbana');
INSERT INTO INFRACCION VALUES (2,  90.00, 'Estacionamiento en zona prohibida');
INSERT INTO INFRACCION VALUES (3, 500.00, 'Conducción bajo efectos del alcohol');
INSERT INTO INFRACCION VALUES (4,  30.00, 'No llevar el cinturón de seguridad');
COMMIT;

-- Infractores
INSERT INTO INFRACTOR VALUES ('11111111A', 'Carlos Pérez');
INSERT INTO INFRACTOR VALUES ('22222222B', 'Laura Gómez');
INSERT INTO INFRACTOR VALUES ('33333333C', 'Miguel Torres');
INSERT INTO INFRACTOR VALUES ('44444444D', 'Ana Ruiz');
COMMIT;

-- Agentes
INSERT INTO AGENTE VALUES ('55555555E', 1001, 'Roberto Díaz',   'AGENTE');
INSERT INTO AGENTE VALUES ('66666666F', 1002, 'Sofía Martín',   'SUBINSPECTOR');
INSERT INTO AGENTE VALUES ('77777777G', 1003, 'Juan López',     'AGENTE');
COMMIT;

-- Propietarios
INSERT INTO PROPIETARIO VALUES ('88888888H', 'Empresa Logística S.L.');
INSERT INTO PROPIETARIO VALUES ('99999999I', 'Pedro Sánchez');
INSERT INTO PROPIETARIO VALUES ('10101010J', 'María Fernández');
COMMIT;

-- Vehículos
INSERT INTO VEHICULO (MATRICULA, MODELO, MARCA, COLOR, NIF_PROPIETARIO) VALUES ('1234ABC', 'Ibiza',  'SEAT',       'Rojo',   '88888888H');
INSERT INTO VEHICULO (MATRICULA, MODELO, MARCA, COLOR, NIF_PROPIETARIO) VALUES ('5678DEF', 'Corsa',  'Opel',       'Blanco', '99999999I');
INSERT INTO VEHICULO (MATRICULA, MODELO, MARCA, COLOR, NIF_PROPIETARIO) VALUES ('9999XYZ', 'Golf',   'Volkswagen', 'Negro',  '10101010J');
INSERT INTO VEHICULO (MATRICULA, MODELO, MARCA, COLOR, NIF_PROPIETARIO) VALUES ('0001ZZZ', 'Clio',   'Renault',    'Gris',   '99999999I');
COMMIT;
-- Denuncias
INSERT INTO DENUNCIA (NIF_AGENTE, FECHAHORA_INFRACCION, LUGAR, CODIGO_INFRACCION, MATRICULA, NIF_SANCIONADO, PAPEL_SANCIONADO, INMOVILIZADO)
    VALUES ('55555555E', DATE '2024-09-01', 'Calle Gran Vía 10',     1, '1234ABC', '11111111A', 'CONDUCTOR', 'N');
INSERT INTO DENUNCIA (NIF_AGENTE, FECHAHORA_INFRACCION, LUGAR, CODIGO_INFRACCION, MATRICULA, NIF_SANCIONADO, PAPEL_SANCIONADO, INMOVILIZADO)
    VALUES ('55555555E', DATE '2024-09-15', 'Avenida Constitución 5', 2, '5678DEF', '22222222B', 'PROPIETARIO', 'N');
INSERT INTO DENUNCIA (NIF_AGENTE, FECHAHORA_INFRACCION, LUGAR, CODIGO_INFRACCION, MATRICULA, NIF_SANCIONADO, PAPEL_SANCIONADO, INMOVILIZADO)
    VALUES ('66666666F', DATE '2024-10-03', 'Rotonda del Parque',     3, '9999XYZ', '33333333C', 'CONDUCTOR', 'S');
INSERT INTO DENUNCIA (NIF_AGENTE, FECHAHORA_INFRACCION, LUGAR, CODIGO_INFRACCION, MATRICULA, NIF_SANCIONADO, PAPEL_SANCIONADO, INMOVILIZADO)
    VALUES ('77777777G', DATE '2024-10-20', 'Calle Sierpes 3',        2, '1234ABC', '44444444D', 'CONDUCTOR', 'N');
COMMIT;

-- ================================================================
-- 2. COMPROBACIÓN DE ON DELETE SET NULL
-- ================================================================

-- ----------------------------------------------------------------
-- CASO A: FK_VEHICULO_PROPIETARIO → Al borrar un PROPIETARIO,
--         NIF_PROPIETARIO en sus vehículos pasa a NULL (SET NULL).
--         Los vehículos siguen existiendo en el sistema.
--
--         ⚠ Usamos el propietario 10101010J (María Fernández),
--         cuyo vehículo 9999XYZ tiene denuncias. Aun así el SET NULL
--         funciona porque la restricción está en VEHICULO, no en
--         DENUNCIA.
-- ----------------------------------------------------------------

-- Comprobamos el vehículo de María antes del borrado:
SELECT MATRICULA, MODELO, NIF_PROPIETARIO FROM VEHICULO WHERE NIF_PROPIETARIO = '10101010J';
-- Resultado esperado: 1 fila → ('9999XYZ', 'Golf', '10101010J')

-- Borramos el propietario:
DELETE FROM PROPIETARIO WHERE NIF_PROPIETARIO = '10101010J';
COMMIT;
-- Verificamos que el vehículo sigue existiendo con NIF_PROPIETARIO = NULL:
SELECT MATRICULA, MODELO, NIF_PROPIETARIO FROM VEHICULO WHERE MATRICULA = '9999XYZ';
-- Resultado esperado: 1 fila → ('9999XYZ', 'Golf', NULL) ✓

-- Las denuncias del vehículo siguen intactas:
SELECT * FROM DENUNCIA WHERE MATRICULA = '9999XYZ';
-- Resultado esperado: 1 fila ✓


-- ================================================================
-- 3. COMPROBACIÓN DE ON DELETE CASCADE
-- ================================================================

-- ----------------------------------------------------------------
-- CASO B: FK_DENUNCIA_VEHICULO → Al borrar un VEHÍCULO, todas sus
--         DENUNCIAS se eliminan automáticamente (CASCADE).
--
--         ⚠ Usamos el vehículo 0001ZZZ, que NO tiene denuncias,
--         para ver el CASCADE "limpio". A continuación usamos
--         1234ABC, que sí las tiene, para ver que se van también.
-- ----------------------------------------------------------------

-- (B.1) Vehículo sin denuncias — CASCADE sin efecto visible pero correcto

-- Comprobamos que 0001ZZZ no tiene denuncias:
SELECT * FROM DENUNCIA WHERE MATRICULA = '0001ZZZ';
-- Resultado esperado: 0 filas

-- Borramos el vehículo:
DELETE FROM VEHICULO WHERE MATRICULA = '0001ZZZ';
COMMIT;
-- El vehículo ha desaparecido:
SELECT * FROM VEHICULO WHERE MATRICULA = '0001ZZZ';
-- Resultado esperado: 0 filas ✓


-- (B.2) Vehículo CON denuncias — CASCADE elimina las denuncias también

-- Comprobamos las denuncias de 1234ABC antes del borrado:
SELECT * FROM DENUNCIA WHERE MATRICULA = '1234ABC';
-- Resultado esperado: 2 filas

-- Borramos el vehículo:
DELETE FROM VEHICULO WHERE MATRICULA = '1234ABC';
COMMIT;
-- Verificamos que las denuncias han desaparecido (CASCADE):
SELECT * FROM DENUNCIA WHERE MATRICULA = '1234ABC';
-- Resultado esperado: 0 filas ✓

-- El vehículo tampoco existe ya:
SELECT * FROM VEHICULO WHERE MATRICULA = '1234ABC';
-- Resultado esperado: 0 filas ✓


-- ================================================================
-- 4. COMPROBACIÓN DE ON DELETE RESTRICT (comportamiento por defecto)
-- ================================================================

-- ----------------------------------------------------------------
-- CASO C: FK_DENUNCIA_AGENTE → No se puede borrar un AGENTE que
--         tenga DENUNCIAS registradas (RESTRICT).
-- ----------------------------------------------------------------

-- Comprobamos las denuncias del agente 55555555E:
SELECT * FROM DENUNCIA WHERE NIF_AGENTE = '55555555E';
-- Resultado esperado: 2 filas (aunque 1234ABC ya no existe, la denuncia
-- de 5678DEF sigue viva)

-- Intentamos borrar al agente → DEBE FALLAR:
DELETE FROM AGENTE WHERE NIF_AGENTE = '55555555E';
COMMIT;
-- ERROR esperado:
--   ORA-02292: integrity constraint (FK_DENUNCIA_AGENTE) violated - child record found
-- ✗ No se puede borrar porque tiene denuncias registradas.

-- Para poder borrarlo habría que eliminar antes sus denuncias:
-- DELETE FROM DENUNCIA WHERE NIF_AGENTE = '55555555E';
-- DELETE FROM AGENTE   WHERE NIF_AGENTE = '55555555E'; ← ahora sí funcionaría


-- ----------------------------------------------------------------
-- CASO D: FK_DENUNCIA_INFRACCION → No se puede borrar una
--         INFRACCION que haya sido usada en una denuncia (RESTRICT).
-- ----------------------------------------------------------------

-- Comprobamos las denuncias con infracción código 2:
SELECT * FROM DENUNCIA WHERE CODIGO_INFRACCION = 2;
-- Resultado esperado: 1 fila → denuncia de 5678DEF

-- Intentamos borrar la infracción → DEBE FALLAR:
DELETE FROM INFRACCION WHERE CODIGO_INFRACCION = 2;
COMMIT;
-- ERROR esperado:
--   ORA-02292: integrity constraint (FK_DENUNCIA_INFRACCION) violated - child record found
-- ✗ No se puede borrar porque hay denuncias que la usan.

-- La infracción 4 (no llevar cinturón) no tiene denuncias → sí se puede borrar:
SELECT * FROM DENUNCIA WHERE CODIGO_INFRACCION = 4;
-- Resultado esperado: 0 filas
DELETE FROM INFRACCION WHERE CODIGO_INFRACCION = 4;
COMMIT;
-- ✓ Borrado correcto, nadie la referencia.


-- ----------------------------------------------------------------
-- CASO E: FK_DENUNCIA_INFRACTOR → No se puede borrar un INFRACTOR
--         que tenga denuncias asociadas (RESTRICT).
-- ----------------------------------------------------------------

-- Comprobamos las denuncias de Laura Gómez (22222222B):
SELECT * FROM DENUNCIA WHERE NIF_SANCIONADO = '22222222B';
-- Resultado esperado: 1 fila

-- Intentamos borrarla → DEBE FALLAR:
DELETE FROM INFRACTOR WHERE NIF_SANCIONADO = '22222222B';
COMMIT;
-- ERROR esperado:
--   ORA-02292: integrity constraint (FK_DENUNCIA_INFRACTOR) violated - child record found
-- ✗ No se puede borrar porque tiene denuncias registradas.

-- El infractor 44444444D (Ana Ruiz) tenía su denuncia sobre el vehículo
-- 1234ABC, que ya fue borrado por CASCADE en el caso B.2.
-- Por tanto, ya no tiene denuncias y SÍ se puede borrar:
SELECT * FROM DENUNCIA WHERE NIF_SANCIONADO = '44444444D';
-- Resultado esperado: 0 filas (CASCADE la eliminó con el vehículo)

DELETE FROM INFRACTOR WHERE NIF_SANCIONADO = '44444444D';
COMMIT;
-- ✓ Borrado correcto ✓


-- ----------------------------------------------------------------
-- CASO F (BONUS): Borrado en cadena correcto → orden que SÍ
--         funciona para eliminar un agente con historial completo.
-- ----------------------------------------------------------------

-- Queremos eliminar al agente 66666666F (Sofía Martín), que tiene
-- una denuncia sobre el vehículo 9999XYZ (ya sin propietario).

-- Comprobamos sus denuncias:
SELECT * FROM DENUNCIA WHERE NIF_AGENTE = '66666666F';
-- Resultado esperado: 1 fila

-- Paso 1: eliminar las denuncias del agente
DELETE FROM DENUNCIA WHERE NIF_AGENTE = '66666666F';
COMMIT;
-- Paso 2: eliminar el agente
DELETE FROM AGENTE WHERE NIF_AGENTE = '66666666F';
COMMIT;

-- Verificamos:
SELECT * FROM AGENTE  WHERE NIF_AGENTE = '66666666F';
-- Resultado esperado: 0 filas ✓
SELECT * FROM DENUNCIA WHERE NIF_AGENTE = '66666666F';
-- Resultado esperado: 0 filas ✓


-- ================================================================
-- 5. RESUMEN DE RESULTADOS ESPERADOS
-- ================================================================
--
--  CASO  │ Acción                               │ Resultado
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   A    │ DELETE PROPIETARIO (10101010J)       │ ✓ Vehículo permanece con
--        │                                      │   NIF_PROPIETARIO = NULL
--        │                                      │   (SET NULL)
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--  B.1   │ DELETE VEHICULO (sin denuncias)      │ ✓ Borrado limpio, CASCADE
--        │                                      │   sin efecto visible
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--  B.2   │ DELETE VEHICULO (con denuncias)      │ ✓ Denuncias eliminadas
--        │                                      │   automáticamente (CASCADE)
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   C    │ DELETE AGENTE (con denuncias)        │ ✗ ERROR: tiene denuncias
--        │                                      │   registradas (RESTRICT)
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   D    │ DELETE INFRACCION (usada en          │ ✗ ERROR: hay denuncias que
--        │ denuncias)                           │   la usan (RESTRICT)
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   D    │ DELETE INFRACCION (sin uso)          │ ✓ Borrado correcto, nadie
--        │                                      │   la referencia
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   E    │ DELETE INFRACTOR (con denuncias)     │ ✗ ERROR: tiene denuncias
--        │                                      │   registradas (RESTRICT)
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   E    │ DELETE INFRACTOR (44444444D, sus     │ ✓ Sus denuncias ya fueron
--        │ denuncias eliminadas por CASCADE)    │   borradas en cascada con
--        │                                      │   el vehículo (caso B.2)
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   F    │ DELETE ordenado: DENUNCIA →          │ ✓ Borrado completo correcto
--  BONUS │ AGENTE                               │
-- ================================================================