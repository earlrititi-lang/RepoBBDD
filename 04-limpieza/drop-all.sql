-- ============================================
-- SCRIPT DE LIMPIEZA - ELIMINAR TODAS LAS TABLAS
-- ============================================
-- ADVERTENCIA: Esto eliminará TODAS tus tablas
-- Ejecuta solo cuando quieras empezar de cero
-- ============================================

BEGIN
   FOR t IN (SELECT table_name FROM user_tables) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('✓ Todas las tablas han sido eliminadas');
END;
/

-- Verificar que no queden tablas
SELECT COUNT(*) as "Tablas Restantes" FROM user_tables;