-- ================================================================
-- PASO 4: VERIFICAR CREACIÓN
-- ================================================================

-- Consulta para verificar que todas las tablas se crearon correctamente
SELECT TABLE_NAME 
FROM USER_TABLES 
WHERE TABLE_NAME IN (
    'TIPOS', 'HABILIDADES', 'MAPA', 'POKEMON', 'MOVIMIENTOS', 
    'OBJETOS', 'ENTRENADOR', 'POKEMON_MOVIMIENTO', 
    'ENTRENADOR_POKEMON', 'ENTRENADOR_OBJETO'
)
ORDER BY TABLE_NAME;

-- Consulta para verificar las restricciones de clave foránea
SELECT CONSTRAINT_NAME, TABLE_NAME, R_CONSTRAINT_NAME, DELETE_RULE
FROM USER_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'R' -- Solo claves foráneas
  AND TABLE_NAME IN (
    'POKEMON', 'MOVIMIENTOS', 'ENTRENADOR', 
    'POKEMON_MOVIMIENTO', 'ENTRENADOR_POKEMON', 'ENTRENADOR_OBJETO'
)
ORDER BY TABLE_NAME, CONSTRAINT_NAME;

--Tipos comunes en Oracle:

--'P': primary key
--'R': foreign key
--'U': unique
--'C': check constraint
