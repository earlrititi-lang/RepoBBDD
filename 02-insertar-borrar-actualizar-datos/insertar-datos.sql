-- ============================================
-- SCRIPT: INSERTAR DATOS EN ORACLE SQL
-- ============================================
-- Propósito: Guía completa para insertar registros en tus tablas
-- Uso: Selecciona el código que necesites y ejecuta (F5)
-- ⚠️ IMPORTANTE: Cambia los nombres de tablas y columnas según tu esquema
-- ============================================


-- ============================================
-- OPCIÓN 1: INSERT BÁSICO (Todas las columnas)
-- ============================================
-- Inserta valores en TODAS las columnas, en el orden en que se crearon

INSERT INTO nombre_tabla VALUES (valor1, valor2, valor3);

-- Ejemplo práctico:
INSERT INTO PROYECTO VALUES (1, 'Sistema de Ventas', TO_DATE('2026-01-15', 'YYYY-MM-DD'), 50000, 'activo');

-- ⚠️ Debes conocer el orden exacto de las columnas
-- ⚠️ Debes proporcionar valores para TODAS las columnas


-- ============================================
-- OPCIÓN 2: INSERT ESPECIFICANDO COLUMNAS (Recomendado)
-- ============================================
-- Más seguro: especificas qué columnas llenas

INSERT INTO nombre_tabla (columna1, columna2, columna3)
VALUES (valor1, valor2, valor3);

-- Ejemplo práctico:
INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (1, 'Sistema de Ventas', TO_DATE('2026-01-15', 'YYYY-MM-DD'), 50000, 'activo');

-- ✅ Ventajas:
-- - Más legible
-- - No importa el orden de creación de columnas
-- - Puedes omitir columnas con valores por defecto o NULL


-- ============================================
-- OPCIÓN 3: INSERT MÚLTIPLES REGISTROS (Uno por uno)
-- ============================================
-- Forma tradicional: un INSERT por cada registro

INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (1, 'Sistema de Ventas', TO_DATE('2026-01-15', 'YYYY-MM-DD'), 50000, 'activo');

INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (2, 'App Móvil', TO_DATE('2026-02-01', 'YYYY-MM-DD'), 30000, 'activo');

INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (3, 'Migración Base de Datos', TO_DATE('2025-12-01', 'YYYY-MM-DD'), 80000, 'finalizado');

-- Ejecuta todos juntos: selecciona los 3 INSERT y presiona F5


-- ============================================
-- OPCIÓN 4: INSERT MÚLTIPLES (INSERT ALL - Oracle)
-- ============================================
-- Forma optimizada para insertar varios registros a la vez

INSERT ALL
    INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
    VALUES (1, 'Sistema de Ventas', TO_DATE('2026-01-15', 'YYYY-MM-DD'), 50000, 'activo')
    
    INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
    VALUES (2, 'App Móvil', TO_DATE('2026-02-01', 'YYYY-MM-DD'), 30000, 'activo')
    
    INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
    VALUES (3, 'Migración BD', TO_DATE('2025-12-01', 'YYYY-MM-DD'), 80000, 'finalizado')
SELECT * FROM DUAL;

-- ✅ Más eficiente que múltiples INSERT separados


-- ============================================
-- OPCIÓN 5: INSERT CON VALORES POR DEFECTO
-- ============================================
-- Usar valores DEFAULT definidos en la tabla

INSERT INTO PROYECTO (id_proyecto, nombre)
VALUES (4, 'Nuevo Proyecto');
-- Las columnas fecha_inicio y estado usarán sus valores DEFAULT

-- Insertar NULL explícitamente
INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (5, 'Proyecto Sin Presupuesto', SYSDATE, NULL, 'activo');


-- ============================================
-- OPCIÓN 6: INSERT CON FUNCIONES Y EXPRESIONES
-- ============================================

-- Usar SYSDATE para fecha actual
INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (6, 'Proyecto Hoy', SYSDATE, 25000, 'activo');

-- Usar cálculos
INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (7, 'Proyecto Calculado', SYSDATE, 1000 * 50, 'activo');

-- Usar funciones de texto
INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (8, UPPER('proyecto en mayúsculas'), SYSDATE, 30000, 'activo');

-- Usar concatenación
INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (9, 'Proyecto ' || TO_CHAR(SYSDATE, 'YYYY'), SYSDATE, 40000, 'activo');


-- ============================================
-- OPCIÓN 7: INSERT DESDE OTRA TABLA (Copiar datos)
-- ============================================

-- Copiar todos los registros de una tabla a otra
INSERT INTO tabla_destino (columna1, columna2, columna3)
SELECT columna1, columna2, columna3
FROM tabla_origen;

-- Ejemplo: Copiar proyectos activos a una tabla de backup
INSERT INTO PROYECTO_BACKUP (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
SELECT id_proyecto, nombre, fecha_inicio, presupuesto, estado
FROM PROYECTO
WHERE estado = 'activo';

-- Copiar con transformaciones
INSERT INTO PROYECTO_RESUMEN (id_proyecto, nombre, anio)
SELECT id_proyecto, nombre, EXTRACT(YEAR FROM fecha_inicio)
FROM PROYECTO;


-- ============================================
-- OPCIÓN 8: INSERT CON SECUENCIAS (IDs autoincrementales)
-- ============================================

-- Primero, crear una secuencia
CREATE SEQUENCE seq_proyecto
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Usar la secuencia en INSERT
INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (seq_proyecto.NEXTVAL, 'Proyecto con ID automático', SYSDATE, 45000, 'activo');

-- Cada vez que uses seq_proyecto.NEXTVAL, obtienes el siguiente número


-- ============================================
-- OPCIÓN 9: INSERT CON VERIFICACIÓN PREVIA
-- ============================================

-- Insertar solo si NO existe un registro similar
INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
SELECT 10, 'Proyecto Único', SYSDATE, 35000, 'activo'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM PROYECTO WHERE nombre = 'Proyecto Único'
);


-- ============================================
-- OPCIÓN 10: INSERT DE DATOS CON CARACTERES ESPECIALES
-- ============================================

-- Texto con comillas simples (duplicar la comilla)
INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (11, 'Proyecto ''Alpha''', SYSDATE, 50000, 'activo');
-- Resultado: Proyecto 'Alpha'

-- Texto con caracteres especiales (ñ, acentos)
INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (12, 'Diseño de Aplicación Móvil', SYSDATE, 60000, 'activo');

-- Texto largo (usando concatenación si es necesario)
INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (13, 'Sistema Integrado de Gestión Empresarial para Automatización de Procesos', 
        SYSDATE, 100000, 'activo');


-- ============================================
-- OPCIÓN 11: INSERT CON DIFERENTES TIPOS DE DATOS
-- ============================================

-- Números
INSERT INTO tabla (columna_number) VALUES (123);
INSERT INTO tabla (columna_number) VALUES (123.45);

-- Texto / VARCHAR2
INSERT INTO tabla (columna_varchar) VALUES ('Texto simple');
INSERT INTO tabla (columna_varchar) VALUES ('Texto con "comillas dobles"');

-- Fechas (diferentes formatos)
INSERT INTO tabla (columna_date) VALUES (SYSDATE);
INSERT INTO tabla (columna_date) VALUES (TO_DATE('2026-01-23', 'YYYY-MM-DD'));
INSERT INTO tabla (columna_date) VALUES (TO_DATE('23/01/2026', 'DD/MM/YYYY'));
INSERT INTO tabla (columna_date) VALUES (TO_DATE('23-ENE-2026', 'DD-MON-YYYY'));

-- Timestamp
INSERT INTO tabla (columna_timestamp) VALUES (SYSTIMESTAMP);
INSERT INTO tabla (columna_timestamp) VALUES (TO_TIMESTAMP('2026-01-23 14:30:00', 'YYYY-MM-DD HH24:MI:SS'));

-- CLOB (texto largo)
INSERT INTO tabla (columna_clob) VALUES ('Texto muy largo que puede tener miles de caracteres...');

-- NULL
INSERT INTO tabla (columna_opcional) VALUES (NULL);


-- ============================================
-- OPCIÓN 12: INSERT CON COMMIT Y ROLLBACK
-- ============================================

-- Oracle NO hace commit automático
-- Tus cambios están en memoria hasta que hagas COMMIT

-- Insertar datos
INSERT INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
VALUES (14, 'Proyecto Temporal', SYSDATE, 25000, 'activo');

-- Si todo está bien, confirmar cambios:
COMMIT;

-- Si te equivocaste, deshacer cambios:
ROLLBACK;

-- ⚠️ IMPORTANTE:
-- - En VS Code, cada INSERT NO se guarda automáticamente
-- - Necesitas hacer COMMIT para guardar permanentemente
-- - Puedes hacer ROLLBACK antes del COMMIT para deshacer


-- ============================================
-- PLANTILLA PARA INSERTAR DATOS DE PRUEBA
-- ============================================

-- Ejemplo completo: Insertar datos de prueba en múltiples tablas relacionadas

-- Paso 1: Insertar en tabla principal (PROYECTO)
INSERT ALL
    INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
    VALUES (101, 'E-Commerce Platform', TO_DATE('2026-01-01', 'YYYY-MM-DD'), 150000, 'activo')
    
    INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
    VALUES (102, 'CRM System', TO_DATE('2026-01-15', 'YYYY-MM-DD'), 80000, 'activo')
    
    INTO PROYECTO (id_proyecto, nombre, fecha_inicio, presupuesto, estado)
    VALUES (103, 'Mobile App', TO_DATE('2025-12-01', 'YYYY-MM-DD'), 50000, 'finalizado')
SELECT * FROM DUAL;

-- Paso 2: Insertar en tabla relacionada (DISENADOR - ejemplo)
INSERT ALL
    INTO DISENADOR (id_disenador, nombre, especialidad)
    VALUES (1, 'Ana García', 'Frontend')
    
    INTO DISENADOR (id_disenador, nombre, especialidad)
    VALUES (2, 'Carlos López', 'Backend')
    
    INTO DISENADOR (id_disenador, nombre, especialidad)
    VALUES (3, 'María Rodríguez', 'UX/UI')
SELECT * FROM DUAL;

-- Paso 3: Insertar en tabla de relación (COLABORACION - ejemplo)
INSERT ALL
    INTO COLABORACION (id_disenador, id_proyecto, fecha_inicio, estado)
    VALUES (1, 101, TO_DATE('2026-01-01', 'YYYY-MM-DD'), 'activo')
    
    INTO COLABORACION (id_disenador, id_proyecto, fecha_inicio, estado)
    VALUES (2, 101, TO_DATE('2026-01-01', 'YYYY-MM-DD'), 'activo')
    
    INTO COLABORACION (id_disenador, id_proyecto, fecha_inicio, estado)
    VALUES (3, 102, TO_DATE('2026-01-15', 'YYYY-MM-DD'), 'activo')
SELECT * FROM DUAL;

-- Paso 4: Confirmar todos los cambios
COMMIT;


-- ============================================
-- VERIFICAR LOS DATOS INSERTADOS
-- ============================================

-- Verificar tabla PROYECTO
SELECT * FROM PROYECTO ORDER BY id_proyecto;

-- Verificar tabla DISENADOR
SELECT * FROM DISENADOR ORDER BY id_disenador;

-- Verificar tabla COLABORACION
SELECT * FROM COLABORACION ORDER BY id_disenador, id_proyecto;

-- Verificar con JOIN
SELECT 
    p.nombre AS "Proyecto",
    d.nombre AS "Diseñador",
    c.fecha_inicio AS "Inicio Colaboración",
    c.estado AS "Estado"
FROM PROYECTO p
JOIN COLABORACION c ON p.id_proyecto = c.id_proyecto
JOIN DISENADOR d ON c.id_disenador = d.id_disenador
ORDER BY p.nombre, d.nombre;


-- ============================================
-- ERRORES COMUNES Y SOLUCIONES
-- ============================================

/*
❌ ERROR 1: ORA-00001: restricción única violada
CAUSA: Intentas insertar un valor duplicado en PRIMARY KEY o UNIQUE
SOLUCIÓN: Verifica que el ID sea único

SELECT * FROM tabla WHERE id = valor;  -- Ver si ya existe
*/

/*
❌ ERROR 2: ORA-02291: restricción de integridad violada (padre no encontrado)
CAUSA: Intentas insertar un FOREIGN KEY que no existe en la tabla padre
SOLUCIÓN: Verifica que el valor de FK exista en la tabla padre

SELECT * FROM tabla_padre WHERE id = valor_fk;  -- Verificar
*/

/*
❌ ERROR 3: ORA-01400: no se puede realizar una inserción NULL
CAUSA: Intentas insertar NULL en una columna NOT NULL
SOLUCIÓN: Proporciona un valor válido para esa columna
*/

/*
❌ ERROR 4: ORA-02290: restricción de control (CHECK) violada
CAUSA: El valor no cumple la restricción CHECK
SOLUCIÓN: Ver las restricciones de la tabla

SELECT constraint_name, search_condition
FROM user_constraints
WHERE table_name = 'TU_TABLA' AND constraint_type = 'C';
*/

/*
❌ ERROR 5: ORA-12899: valor demasiado grande para la columna
CAUSA: El texto es más largo que el tamaño definido (ej: VARCHAR2(50))
SOLUCIÓN: Acorta el texto o modifica la tabla para aumentar el tamaño
*/


-- ============================================
-- CONSEJOS Y BUENAS PRÁCTICAS
-- ============================================

/*
💡 TIPS PARA INSERTAR DATOS:

1. SIEMPRE especifica las columnas en el INSERT
   ✅ INSERT INTO tabla (col1, col2) VALUES (val1, val2)
   ❌ INSERT INTO tabla VALUES (val1, val2)

2. Usa COMMIT después de insertar
   INSERT INTO tabla (...) VALUES (...);
   COMMIT;

3. Inserta datos de prueba realistas
   - Nombres completos, no solo "test1", "test2"
   - Fechas variadas (pasado, presente, futuro)
   - Valores numéricos variados

4. Verifica antes de insertar
   SELECT * FROM tabla WHERE id = nuevo_id;
   -- Si devuelve 0 filas, puedes insertar

5. Usa transacciones para insertar en múltiples tablas
   INSERT INTO tabla1 (...) VALUES (...);
   INSERT INTO tabla2 (...) VALUES (...);
   COMMIT;  -- Confirma ambos o ninguno

6. Para fechas, usa siempre TO_DATE con formato
   TO_DATE('2026-01-23', 'YYYY-MM-DD')  -- ✅ Claro
   '23-ENE-2026'  -- ❌ Depende de configuración regional

7. Para IDs, considera usar secuencias
   Evita conflictos de IDs duplicados

8. Inserta datos en el orden correcto (tablas padre primero)
   1. PROYECTO
   2. DISENADOR
   3. COLABORACION (tiene FKs de PROYECTO y DISENADOR)

9. Usa INSERT ALL para múltiples registros similares
   Más eficiente que múltiples INSERT separados

10. Documenta tus datos de prueba
    -- Insertar proyectos de ejemplo para testing
    INSERT INTO PROYECTO (...) VALUES (...);
*/


-- ============================================
-- PLANTILLA VACÍA PARA TUS EJERCICIOS
-- ============================================

-- Copia esta plantilla para cada ejercicio nuevo

/*
-- ============================================
-- EJERCICIO: [Nombre del ejercicio]
-- ============================================
-- FECHA: [Fecha]
-- ALUMNO: [Tu nombre]
-- ============================================
*/

-- Insertar en tabla principal
INSERT INTO tabla_principal (columna1, columna2, columna3)
VALUES (valor1, valor2, valor3);

-- Verificar
SELECT * FROM tabla_principal;

-- Confirmar cambios
COMMIT;


-- ============================================
-- FIN DEL SCRIPT
-- ============================================
-- Guarda este archivo como: insertar-datos.sql
-- Úsalo como referencia para todos tus ejercicios de INSERT
-- ============================================