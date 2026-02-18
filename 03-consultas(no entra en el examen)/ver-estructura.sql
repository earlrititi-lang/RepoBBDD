-- Ver todas tus tablas
SELECT table_name FROM user_tables ORDER BY table_name;

-- Ver columnas de una tabla específica
SELECT column_name, data_type, data_length 
FROM user_tab_columns 
WHERE table_name = 'DISENADOR'
ORDER BY column_id;