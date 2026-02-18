-- ============================================
-- VERIFICAR CONEXIÓN
-- ============================================

-- Ver información de tu usuario
SELECT USER as "Usuario Actual", 
       SYS_CONTEXT('USERENV', 'SESSION_USER') as "Sesión"
FROM DUAL;

-- Ver tablas existentes
SELECT table_name as "Mis Tablas" 
FROM user_tables 
ORDER BY table_name;

-- Activar salida de mensajes
SET SERVEROUTPUT ON;

SELECT '✓ Conexión exitosa a Oracle!' as "Estado" FROM DUAL;