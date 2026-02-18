-- ================================================================
-- EJEMPLOS DIDÁCTICOS: RESTRICCIONES DE BORRADO (FK)
-- Farmacia: FAMILIA, LABORATORIO, MEDICAMENTO, CLIENTE,
--           C_CREDITO, COMP_CREDITO, COMP_EFEC
-- ================================================================
-- Objetivo: Comprobar CASCADE, SET NULL y RESTRICT mediante
--           inserts y deletes guiados.
-- ================================================================


-- ================================================================
-- 1. CARGA DE DATOS DE EJEMPLO
-- ================================================================

-- Familias
INSERT INTO FAMILIA VALUES (1, 'Analgésicos');
INSERT INTO FAMILIA VALUES (2, 'Antibióticos');
INSERT INTO FAMILIA VALUES (3, 'Antiinflamatorios');

-- Laboratorios
INSERT INTO LABORATORIO (CODIGO, NOMBRE) VALUES (10, 'Pfizer');
INSERT INTO LABORATORIO (CODIGO, NOMBRE) VALUES (20, 'Bayer');
INSERT INTO LABORATORIO (CODIGO, NOMBRE) VALUES (30, 'Novartis');

-- Medicamentos
INSERT INTO MEDICAMENTO VALUES (101, 'Paracetamol', 'Comprimido', 100, 50, 2.50,  'NO', 1, 10);
INSERT INTO MEDICAMENTO VALUES (102, 'Ibuprofeno',  'Comprimido',  80, 30, 3.20,  'NO', 3, 20);
INSERT INTO MEDICAMENTO VALUES (103, 'Amoxicilina', 'Cápsula',     60, 20, 8.75,  'SI', 2, 20);
INSERT INTO MEDICAMENTO VALUES (104, 'Aspirina',    'Comprimido',  90, 40, 1.80,  'NO', 1, 30);

-- Clientes
INSERT INTO CLIENTE VALUES ('12345678A', '600111222', 'Calle Mayor 1');
INSERT INTO CLIENTE VALUES ('87654321B', '600333444', 'Avenida Sol 5');
INSERT INTO CLIENTE VALUES ('11223344C', '600555666', 'Plaza Luna 3');
INSERT INTO CLIENTE VALUES ('99887766D', '600777888', 'Calle Mar 7');

-- Datos bancarios (crédito) — solo algunos clientes
INSERT INTO C_CREDITO VALUES ('12345678A', 'ES12 1234 5678 9012 3456 7890');
INSERT INTO C_CREDITO VALUES ('87654321B', 'ES98 9876 5432 1098 7654 3210');
INSERT INTO C_CREDITO VALUES ('99887766D', 'ES55 1111 2222 3333 4444 5555');

-- Compras a crédito
INSERT INTO COMP_CREDITO VALUES (101, '12345678A', DATE '2024-10-01', 2, DATE '2024-11-01');
INSERT INTO COMP_CREDITO VALUES (103, '12345678A', DATE '2024-10-15', 1, NULL);
INSERT INTO COMP_CREDITO VALUES (102, '87654321B', DATE '2024-11-03', 3, DATE '2024-12-03');

-- Compras al contado
INSERT INTO COMP_EFEC VALUES (101, '11223344C', DATE '2024-10-05', 1);
INSERT INTO COMP_EFEC VALUES (104, '11223344C', DATE '2024-10-20', 2);
INSERT INTO COMP_EFEC VALUES (102, '87654321B', DATE '2024-11-10', 1);


-- ================================================================
-- 2. COMPROBACIÓN DE ON DELETE CASCADE
-- ================================================================

-- ----------------------------------------------------------------
-- CASO A: FK_C_CREDITO_CLIENTE → Al borrar un CLIENTE, sus datos
--         bancarios en C_CREDITO se eliminan automáticamente (CASCADE).
--
--         ⚠ Usamos el cliente 99887766D que tiene C_CREDITO
--         pero NO tiene compras registradas (ni en COMP_CREDITO
--         ni en COMP_EFEC), por lo que no hay RESTRICT que lo bloquee.
-- ----------------------------------------------------------------

-- Comprobamos los datos bancarios de 99887766D antes del borrado:
SELECT * FROM C_CREDITO WHERE DNI = '99887766D';
-- Resultado esperado: 1 fila → ES55 1111 2222 ...

-- Borramos el cliente:
DELETE FROM CLIENTE WHERE DNI = '99887766D';

-- Verificamos que sus datos bancarios han desaparecido (CASCADE):
SELECT * FROM C_CREDITO WHERE DNI = '99887766D';
-- Resultado esperado: 0 filas ✓


-- ================================================================
-- 3. COMPROBACIÓN DE ON DELETE SET NULL
-- ================================================================

-- ----------------------------------------------------------------
-- CASO B: FK_MEDICAMENTO_LABORATORIO → Al borrar un LABORATORIO,
--         COD_LABORATORIO de sus medicamentos pasa a NULL (SET NULL).
--         Los medicamentos siguen existiendo en el catálogo.
-- ----------------------------------------------------------------

-- Comprobamos los medicamentos de Novartis (código 30) antes del borrado:
SELECT CODIGO, NOMBRE, COD_LABORATORIO FROM MEDICAMENTO WHERE COD_LABORATORIO = 30;
-- Resultado esperado: 1 fila → (104, 'Aspirina', 30)

-- Borramos el laboratorio:
DELETE FROM LABORATORIO WHERE CODIGO = 30;

-- Verificamos que Aspirina sigue existiendo pero con COD_LABORATORIO = NULL:
SELECT CODIGO, NOMBRE, COD_LABORATORIO FROM MEDICAMENTO WHERE CODIGO = 104;
-- Resultado esperado: 1 fila → (104, 'Aspirina', NULL) ✓

-- El medicamento no ha desaparecido, solo ha perdido su laboratorio:
SELECT * FROM MEDICAMENTO WHERE CODIGO = 104;
-- Resultado esperado: 1 fila con COD_LABORATORIO = NULL ✓


-- ================================================================
-- 4. COMPROBACIÓN DE ON DELETE RESTRICT (comportamiento por defecto)
-- ================================================================

-- ----------------------------------------------------------------
-- CASO C: FK_MEDICAMENTO_FAMILIA → No se puede borrar una FAMILIA
--         que tenga MEDICAMENTOS asignados (RESTRICT).
-- ----------------------------------------------------------------

-- Comprobamos los medicamentos de la familia Analgésicos (1):
SELECT CODIGO, NOMBRE FROM MEDICAMENTO WHERE COD_FAMILIA = 1;
-- Resultado esperado: 2 filas → Paracetamol y Aspirina

-- Intentamos borrar la familia → DEBE FALLAR:
DELETE FROM FAMILIA WHERE CODIGO = 1;
-- ERROR esperado:
--   ORA-02292: integrity constraint (FK_MEDICAMENTO_FAMILIA) violated - child record found
-- ✗ No se puede borrar porque tiene medicamentos asignados.

-- Para poder borrarla habría que reasignar antes sus medicamentos:
-- UPDATE MEDICAMENTO SET COD_FAMILIA = 3 WHERE COD_FAMILIA = 1;
-- DELETE FROM FAMILIA WHERE CODIGO = 1; ← ahora sí funcionaría


-- ----------------------------------------------------------------
-- CASO D: FK_COMP_CREDITO_MEDICAMENTO / FK_COMP_EFEC_MEDICAMENTO
--         → No se puede borrar un MEDICAMENTO con compras
--         registradas (RESTRICT).
-- ----------------------------------------------------------------

-- Comprobamos compras de Paracetamol (101):
SELECT * FROM COMP_CREDITO WHERE COD_MED = 101;
-- Resultado esperado: 1 fila
SELECT * FROM COMP_EFEC WHERE COD_MED = 101;
-- Resultado esperado: 1 fila

-- Intentamos borrar Paracetamol → DEBE FALLAR:
DELETE FROM MEDICAMENTO WHERE CODIGO = 101;
-- ERROR esperado:
--   ORA-02292: integrity constraint (FK_COMP_CREDITO_MEDICAMENTO) violated - child record found
-- ✗ No se puede borrar porque tiene compras registradas.

-- Para poder borrarlo habría que eliminar antes todas sus compras:
-- DELETE FROM COMP_CREDITO WHERE COD_MED = 101;
-- DELETE FROM COMP_EFEC    WHERE COD_MED = 101;
-- DELETE FROM MEDICAMENTO  WHERE CODIGO  = 101; ← ahora sí funcionaría


-- ----------------------------------------------------------------
-- CASO E: FK_COMP_CREDITO_CLIENTE / FK_COMP_EFEC_CLIENTE
--         → No se puede borrar un CLIENTE con compras registradas
--         (RESTRICT), aunque CASCADE borre su C_CREDITO.
--
--         Este caso es especialmente interesante: el CASCADE de
--         C_CREDITO no evita el RESTRICT de las compras. Ambas
--         restricciones actúan de forma independiente.
-- ----------------------------------------------------------------

-- Comprobamos las compras del cliente 12345678A:
SELECT * FROM COMP_CREDITO WHERE DNI_CLIEN = '12345678A';
-- Resultado esperado: 2 filas
SELECT * FROM COMP_EFEC WHERE DNI_CLIEN = '12345678A';
-- Resultado esperado: 0 filas (este cliente no compró al contado)

-- Intentamos borrar al cliente → DEBE FALLAR (por sus compras a crédito):
DELETE FROM CLIENTE WHERE DNI = '12345678A';
-- ERROR esperado:
--   ORA-02292: integrity constraint (FK_COMP_CREDITO_CLIENTE) violated - child record found
-- ✗ Aunque su C_CREDITO se borraría por CASCADE, las COMP_CREDITO
--   lo impiden antes de que eso ocurra.

-- Para poder borrarlo habría que eliminar antes sus compras:
-- DELETE FROM COMP_CREDITO WHERE DNI_CLIEN = '12345678A';
-- DELETE FROM CLIENTE      WHERE DNI = '12345678A';
-- ← El CASCADE se encargaría de borrar su C_CREDITO automáticamente.


-- ----------------------------------------------------------------
-- CASO F (BONUS): Borrado en cadena correcto → orden que SÍ
--         funciona para eliminar un cliente con historial completo.
-- El caso más interesante del modelo, porque ilustra que CASCADE y RESTRICT no se cancelan entre sí: 
-- aunque borrar el cliente dispararía CASCADE sobre C_CREDITO, el RESTRICT de COMP_CREDITO lo bloquea antes de que eso ocurra. 
-- El orden correcto de borrado lo resuelve.
-- ----------------------------------------------------------------

-- Queremos eliminar al cliente 87654321B, que tiene:
--   - C_CREDITO (se borrará por CASCADE)
--   - COMP_CREDITO (hay que borrarlas a mano)
--   - COMP_EFEC    (hay que borrarlas a mano)

-- Paso 1: eliminar compras al contado
DELETE FROM COMP_EFEC WHERE DNI_CLIEN = '87654321B';
-- Paso 2: eliminar compras a crédito
DELETE FROM COMP_CREDITO WHERE DNI_CLIEN = '87654321B';
-- Paso 3: eliminar el cliente (CASCADE borrará su C_CREDITO automáticamente)
DELETE FROM CLIENTE WHERE DNI = '87654321B';

-- Verificamos que el cliente y sus datos bancarios han desaparecido:
SELECT * FROM CLIENTE    WHERE DNI = '87654321B';
-- Resultado esperado: 0 filas ✓
SELECT * FROM C_CREDITO  WHERE DNI = '87654321B';
-- Resultado esperado: 0 filas ✓  (CASCADE en acción)


-- ================================================================
-- 5. RESUMEN DE RESULTADOS ESPERADOS
-- ================================================================
--
--  CASO  │ Acción                               │ Resultado
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   A    │ DELETE CLIENTE (sin compras)         │ ✓ Borra C_CREDITO
--        │                                      │   automáticamente (CASCADE)
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   B    │ DELETE LABORATORIO (Novartis)        │ ✓ Medicamentos siguen existiendo
--        │                                      │   con COD_LABORATORIO = NULL
--        │                                      │   (SET NULL)
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   C    │ DELETE FAMILIA (con medicamentos)    │ ✗ ERROR: tiene medicamentos
--        │                                      │   asignados (RESTRICT)
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   D    │ DELETE MEDICAMENTO (con compras)     │ ✗ ERROR: tiene compras
--        │                                      │   registradas (RESTRICT)
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   E    │ DELETE CLIENTE (con compras)         │ ✗ ERROR: tiene compras aunque
--        │                                      │   CASCADE cubriría C_CREDITO
--        │                                      │   (RESTRICT prevalece)
-- ───────┼──────────────────────────────────────┼─────────────────────────────────
--   F    │ DELETE ordenado: COMP_EFEC →         │ ✓ Borrado completo correcto;
--  BONUS │ COMP_CREDITO → CLIENTE               │   C_CREDITO desaparece solo
-- ================================================================