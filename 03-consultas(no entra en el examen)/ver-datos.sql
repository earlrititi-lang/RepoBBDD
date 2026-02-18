-- ============================================
-- SCRIPT: VER DATOS DE TODAS TUS TABLAS
-- ============================================
-- Propósito: Consultar rápidamente los datos de tus tablas
-- Uso: Selecciona la sección de la tabla que quieres ver y ejecuta (F5)
-- ============================================

-- ============================================
-- OPCIÓN 1: VER LISTA DE TODAS TUS TABLAS
-- ============================================
-- Ejecuta esto primero para ver qué tablas tienes

SELECT 
    table_name AS "📋 Nombre de Tabla",
    num_rows AS "📊 Filas (aprox)",
    TO_CHAR(last_analyzed, 'DD/MM/YYYY HH24:MI') AS "🕐 Última Análisis"
FROM user_tables
ORDER BY table_name;


-- ============================================
-- OPCIÓN 2: VER DATOS DE UNA TABLA ESPECÍFICA
-- ============================================
-- ⚠️ CAMBIA 'NOMBRE_TABLA' por el nombre real de tu tabla
-- Ejemplo: SELECT * FROM PROYECTO;

SELECT * FROM DISENADOR;


-- ============================================
-- OPCIÓN 3: VER SOLO ALGUNAS FILAS (Top N)
-- ============================================
-- Útil cuando la tabla tiene muchos datos
-- ⚠️ CAMBIA 'NOMBRE_TABLA' y el número de filas

-- Ver primeras 10 filas
SELECT * FROM NOMBRE_TABLA
WHERE ROWNUM <= 10;

-- Ver primeras 50 filas
SELECT * FROM NOMBRE_TABLA
WHERE ROWNUM <= 50;

-- Ver primeras 100 filas
SELECT * FROM NOMBRE_TABLA
WHERE ROWNUM <= 100;


-- ============================================
-- OPCIÓN 4: VER DATOS CON FORMATO ORDENADO
-- ============================================
-- ⚠️ CAMBIA 'NOMBRE_TABLA' y 'nombre_columna'

-- Ordenar por una columna específica (ascendente)
SELECT * FROM NOMBRE_TABLA
ORDER BY nombre_columna ASC;

-- Ordenar por una columna (descendente)
SELECT * FROM NOMBRE_TABLA
ORDER BY nombre_columna DESC;

-- Ordenar por múltiples columnas
SELECT * FROM NOMBRE_TABLA
ORDER BY columna1 ASC, columna2 DESC;


-- ============================================
-- OPCIÓN 5: CONTAR CUÁNTOS REGISTROS TIENE CADA TABLA
-- ============================================
-- Este script cuenta automáticamente los registros de TODAS tus tablas
-- ⚠️ Puede tardar si tienes muchas tablas grandes

SET SERVEROUTPUT ON;

DECLARE
    v_count NUMBER;
    v_sql VARCHAR2(1000);
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('  CONTEO DE REGISTROS POR TABLA');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    FOR t IN (SELECT table_name FROM user_tables ORDER BY table_name) LOOP
        v_sql := 'SELECT COUNT(*) FROM ' || t.table_name;
        EXECUTE IMMEDIATE v_sql INTO v_count;
        
        DBMS_OUTPUT.PUT_LINE('📋 ' || RPAD(t.table_name, 30) || ' → ' || v_count || ' filas');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('========================================');
END;
/


-- ============================================
-- OPCIÓN 6: VER DATOS DE TODAS LAS TABLAS (UNA POR UNA)
-- ============================================
-- Genera automáticamente SELECT para todas tus tablas
-- Copia el resultado y ejecuta los SELECT que necesites

SELECT 'SELECT * FROM ' || table_name || ' WHERE ROWNUM <= 10;' AS "Comandos SELECT"
FROM user_tables
ORDER BY table_name;


-- ============================================
-- OPCIÓN 7: VER DATOS CON FILTROS
-- ============================================
-- Ejemplos de cómo filtrar datos
-- ⚠️ CAMBIA según tus tablas y columnas

-- Filtrar por valor exacto
SELECT * FROM NOMBRE_TABLA
WHERE columna = 'valor';

-- Filtrar por rango numérico
SELECT * FROM NOMBRE_TABLA
WHERE columna_numerica BETWEEN 100 AND 500;

-- Filtrar por rango de fechas
SELECT * FROM NOMBRE_TABLA
WHERE fecha BETWEEN TO_DATE('2026-01-01', 'YYYY-MM-DD') 
                AND TO_DATE('2026-01-31', 'YYYY-MM-DD');

-- Filtrar con texto parcial (LIKE)
SELECT * FROM NOMBRE_TABLA
WHERE columna_texto LIKE '%palabra%';

-- Filtrar con múltiples condiciones (AND)
SELECT * FROM NOMBRE_TABLA
WHERE columna1 = 'valor1'
  AND columna2 > 100;

-- Filtrar con opciones (OR)
SELECT * FROM NOMBRE_TABLA
WHERE columna = 'valor1'
   OR columna = 'valor2'
   OR columna = 'valor3';

-- Filtrar con lista de valores (IN)
SELECT * FROM NOMBRE_TABLA
WHERE columna IN ('valor1', 'valor2', 'valor3');

-- Filtrar valores NULL
SELECT * FROM NOMBRE_TABLA
WHERE columna IS NULL;

-- Filtrar valores NO NULL
SELECT * FROM NOMBRE_TABLA
WHERE columna IS NOT NULL;


-- ============================================
-- OPCIÓN 8: VER DATOS CON COLUMNAS ESPECÍFICAS
-- ============================================
-- En lugar de SELECT *, selecciona solo las columnas que necesitas

SELECT 
    columna1,
    columna2,
    columna3
FROM NOMBRE_TABLA;

-- Con alias (nombres más legibles)
SELECT 
    columna1 AS "Nombre",
    columna2 AS "Edad",
    columna3 AS "Ciudad"
FROM NOMBRE_TABLA;


-- ============================================
-- OPCIÓN 9: VER DATOS AGRUPADOS (RESUMEN)
-- ============================================
-- Útil para ver estadísticas

-- Contar por categoría
SELECT 
    columna_categoria,
    COUNT(*) AS "Total"
FROM NOMBRE_TABLA
GROUP BY columna_categoria
ORDER BY COUNT(*) DESC;

-- Sumar valores por categoría
SELECT 
    columna_categoria,
    SUM(columna_numerica) AS "Total",
    AVG(columna_numerica) AS "Promedio",
    MAX(columna_numerica) AS "Máximo",
    MIN(columna_numerica) AS "Mínimo"
FROM NOMBRE_TABLA
GROUP BY columna_categoria;


-- ============================================
-- OPCIÓN 10: VER DATOS DE MÚLTIPLES TABLAS (JOIN)
-- ============================================
-- Combinar datos de tablas relacionadas
-- ⚠️ CAMBIA según tus tablas

-- INNER JOIN (solo registros que coinciden en ambas tablas)
SELECT 
    t1.columna1,
    t1.columna2,
    t2.columna3
FROM tabla1 t1
INNER JOIN tabla2 t2 ON t1.id = t2.id_tabla1;

-- LEFT JOIN (todos de tabla1, con o sin coincidencia en tabla2)
SELECT 
    t1.columna1,
    t1.columna2,
    t2.columna3
FROM tabla1 t1
LEFT JOIN tabla2 t2 ON t1.id = t2.id_tabla1;


-- ============================================
-- OPCIÓN 11: EXPORTAR RESULTADOS
-- ============================================
-- Después de ejecutar cualquier SELECT:
-- 1. Los resultados aparecen en el panel inferior
-- 2. Clic derecho en los resultados → "Export Results"
-- 3. Elige formato: CSV, JSON, etc.


-- ============================================
-- CONSEJOS DE USO
-- ============================================

/*
💡 TIPS:

1. Ejecuta por secciones:
   - Selecciona solo el código que necesitas
   - Presiona F5
   - No ejecutes todo el archivo de golpe

2. Usa ROWNUM cuando la tabla sea grande:
   SELECT * FROM tabla WHERE ROWNUM <= 10;
   Esto evita cargar millones de filas

3. Si no recuerdas los nombres de columnas:
   - Explorador Oracle (izquierda) → Tabla → Pestaña "Columnas"
   - O ejecuta: DESC nombre_tabla;

4. Para debugging:
   - Añade WHERE con condiciones específicas
   - Usa ORDER BY para ver datos en orden lógico
   - Usa COUNT(*) para ver cuántos registros coinciden

5. Formato de fechas en Oracle:
   TO_DATE('2026-01-23', 'YYYY-MM-DD')
   TO_CHAR(fecha_columna, 'DD/MM/YYYY')

6. Wildcards en LIKE:
   % → cualquier cantidad de caracteres
   _ → exactamente un carácter
   Ejemplo: LIKE 'A%' → empieza con A
           LIKE '%A' → termina con A
           LIKE '%A%' → contiene A
           LIKE 'A_B' → A[cualquier letra]B

*/


-- ============================================
-- EJEMPLOS PRÁCTICOS COMUNES
-- ============================================

-- Ver registros más recientes (últimos 10)
SELECT * FROM NOMBRE_TABLA
ORDER BY fecha_columna DESC
FETCH FIRST 10 ROWS ONLY;

-- Ver registros duplicados
SELECT columna, COUNT(*)
FROM NOMBRE_TABLA
GROUP BY columna
HAVING COUNT(*) > 1;

-- Ver valores únicos de una columna
SELECT DISTINCT columna
FROM NOMBRE_TABLA
ORDER BY columna;

-- Ver registros creados hoy
SELECT * FROM NOMBRE_TABLA
WHERE TRUNC(fecha_columna) = TRUNC(SYSDATE);

-- Ver registros de los últimos 7 días
SELECT * FROM NOMBRE_TABLA
WHERE fecha_columna >= SYSDATE - 7;

-- Ver registros de este mes
SELECT * FROM NOMBRE_TABLA
WHERE TRUNC(fecha_columna, 'MM') = TRUNC(SYSDATE, 'MM');


-- ============================================
-- FIN DEL SCRIPT
-- ============================================
-- Guarda este archivo como: ver-datos.sql o consultas-utiles.sql
-- Úsalo como referencia cada vez que necesites consultar tus datos
-- ============================================