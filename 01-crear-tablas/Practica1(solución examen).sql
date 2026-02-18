
-- ================================================================
-- ANÁLISIS DE RESTRICCIONES DE BORRADO (FK)
-- ================================================================
-- FK_LR_PROY (LIDER_ROL → PROYECTO)        → ON DELETE CASCADE
--   LIDER_ROL es una extensión de PROYECTO, no tiene sentido sin
--   él. Si se elimina un proyecto, sus roles de líder asociados
--   deben eliminarse también.
--
-- FK_PERFIL_DIS (PERFIL_PROFESIONAL → DISENADOR) → ON DELETE CASCADE
--   El perfil profesional es una extensión del diseñador, no tiene
--   vida propia sin él. Si se elimina el diseñador, su perfil
--   desaparece también.
--
-- FK_COLAB_DIS (COLABORACION → DISENADOR)  → RESTRICT (por defecto)
--   No se puede eliminar un diseñador si tiene colaboraciones
--   registradas. El historial de colaboraciones debe conservarse
--   para saber en qué proyectos ha participado.
--
-- FK_COLAB_PROY (COLABORACION → PROYECTO)  → ON DELETE CASCADE
--   Si se elimina un proyecto, sus colaboraciones pierden sentido
--   y se eliminan también para evitar filas huérfanas.
--
-- FK_PROY_LIDER (PROYECTO → DISENADOR)     → RESTRICT (por defecto)
--   No se puede eliminar un diseñador que lidera un proyecto activo.
--   Primero habría que reasignar el liderazgo del proyecto.
--
-- RESUMEN:
-- ┌───────────────┬──────────┬──────────┐
-- │ FK            │ Anterior │ Aplicado │
-- ├───────────────┼──────────┼──────────┤
-- │ FK_LR_PROY    │    -     │ CASCADE  │
-- │ FK_PERFIL_DIS │    -     │ CASCADE  │
-- │ FK_COLAB_PROY │    -     │ CASCADE  │
-- │ FK_COLAB_DIS  │    -     │ RESTRICT │
-- │ FK_PROY_LIDER │    -     │ RESTRICT │
-- └───────────────┴──────────┴──────────┘
-- ================================================================

-- Ejercicio 1 examen

CREATE TABLE DISENADOR(
    ID_DISENADOR VARCHAR2(20),
    NOMBRE VARCHAR2(80) NOT NULL,
    ESPECIALIDAD VARCHAR2(80) NOT NULL,
    EXPERIENCIA_ANIOS NUMBER(3) NOT NULL CHECK (EXPERIENCIA_ANIOS >= 0),
    CONSTRAINT PK_DISENADOR PRIMARY KEY (ID_DISENADOR)
);

CREATE TABLE PROYECTO(
    ID_PROYECTO VARCHAR2(20),
    TITULO VARCHAR2(120) NOT NULL,
    DESCRIPCION VARCHAR2(300) NOT NULL,
    ID_LIDER VARCHAR2(20) NOT NULL,
    CONSTRAINT PK_PROYECTO PRIMARY KEY (ID_PROYECTO),
    CONSTRAINT FK_PROY_LIDER FOREIGN KEY (ID_LIDER) REFERENCES DISENADOR(ID_DISENADOR)
    -- RESTRICT: No se puede eliminar un diseñador que lidera un proyecto.
    --           Primero habría que reasignar el liderazgo del proyecto.
);

CREATE TABLE LIDER_ROL(
    ID_PROYECTO VARCHAR2(20) NOT NULL,
    ROL VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_LIDER_ROL PRIMARY KEY (ID_PROYECTO, ROL),
    CONSTRAINT FK_LR_PROY FOREIGN KEY (ID_PROYECTO) REFERENCES PROYECTO(ID_PROYECTO) ON DELETE CASCADE
    -- CASCADE: LIDER_ROL es una extensión de PROYECTO. Si se elimina
    --          el proyecto, sus roles de líder se eliminan también.
);

CREATE TABLE PERFIL_PROFESIONAL(
    ID_PERFIL VARCHAR2(20),
    ID_DISENADOR VARCHAR2(20) NOT NULL,
    FECHA_CREACION DATE NOT NULL,
    CONSTRAINT PK_PERFIL PRIMARY KEY (ID_PERFIL),
    CONSTRAINT UQ_PERFIL_DIS UNIQUE (ID_DISENADOR),
    CONSTRAINT FK_PERFIL_DIS FOREIGN KEY (ID_DISENADOR) REFERENCES DISENADOR(ID_DISENADOR) ON DELETE CASCADE
    -- CASCADE: El perfil profesional es una extensión del diseñador,
    --          no tiene vida propia sin él. Si se elimina el diseñador,
    --          su perfil desaparece también.
);

CREATE TABLE COLABORACION(
    ID_DISENADOR VARCHAR2(20) NOT NULL,
    ID_PROYECTO VARCHAR2(20) NOT NULL,
    FECHA_INICIO DATE NOT NULL,
    ESTADO VARCHAR2(15) NOT NULL,
    CONSTRAINT PK_COLAB PRIMARY KEY (ID_DISENADOR, ID_PROYECTO),
    CONSTRAINT FK_COLAB_DIS FOREIGN KEY (ID_DISENADOR) REFERENCES DISENADOR(ID_DISENADOR),
    -- RESTRICT: No se puede eliminar un diseñador con colaboraciones registradas.
    --           El historial debe conservarse para saber en qué proyectos participó.
    CONSTRAINT FK_COLAB_PROY FOREIGN KEY (ID_PROYECTO) REFERENCES PROYECTO(ID_PROYECTO) ON DELETE CASCADE,
    -- CASCADE: Si se elimina un proyecto, sus colaboraciones pierden sentido
    --          y se eliminan también para evitar filas huérfanas.
    CONSTRAINT CK_COLAB_EST CHECK (ESTADO IN ('activo', 'pausado', 'finalizado'))
);