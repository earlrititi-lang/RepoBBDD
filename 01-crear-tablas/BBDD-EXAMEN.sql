-- ================================================================
-- SCRIPT COMPLETO: CREACIÓN BASE DE DATOS POKÉMON
-- Con restricciones de borrado coherentes y tablas intermedias
-- ================================================================

-- ================================================================
-- PASO 1: ELIMINAR TABLAS EXISTENTES (en orden correcto)
-- ================================================================
-- Primero eliminamos tablas que dependen de otras (tablas intermedias)
DROP TABLE ENTRENADOR_OBJETO CASCADE CONSTRAINTS;
DROP TABLE ENTRENADOR_POKEMON CASCADE CONSTRAINTS;
DROP TABLE POKEMON_MOVIMIENTO CASCADE CONSTRAINTS;

-- Luego eliminamos tablas principales
DROP TABLE ENTRENADOR CASCADE CONSTRAINTS;
DROP TABLE MOVIMIENTOS CASCADE CONSTRAINTS;
DROP TABLE POKEMON CASCADE CONSTRAINTS;
DROP TABLE OBJETOS CASCADE CONSTRAINTS;
DROP TABLE MAPA CASCADE CONSTRAINTS;
DROP TABLE HABILIDADES CASCADE CONSTRAINTS;
DROP TABLE TIPOS CASCADE CONSTRAINTS;

-- ================================================================
-- PASO 2: CREAR TABLAS PRINCIPALES
-- ================================================================

-- ----------------------------------------------------------------
-- TABLA: TIPOS
-- ----------------------------------------------------------------
CREATE TABLE TIPOS(
    COD_TIPO NUMBER(3),
    NOMBRE VARCHAR2(30) NOT NULL,
    DEBILIDAD VARCHAR2(100),
    RESISTENCIA VARCHAR2(100),
    CONSTRAINT PK_TIPOS PRIMARY KEY (COD_TIPO),
    CONSTRAINT UQ_TIPO_NOMBRE UNIQUE (NOMBRE)
);

-- ----------------------------------------------------------------
-- TABLA: HABILIDADES
-- ----------------------------------------------------------------
CREATE TABLE HABILIDADES(
    COD_HABILIDAD NUMBER(4),
    NOMBRE VARCHAR2(50) NOT NULL,
    DESCRIPCION VARCHAR2(300),
    EFECTO VARCHAR2(200),
    CONSTRAINT PK_HABILIDADES PRIMARY KEY (COD_HABILIDAD),
    CONSTRAINT UQ_HABILIDAD_NOMBRE UNIQUE (NOMBRE)
);

-- ----------------------------------------------------------------
-- TABLA: MAPA
-- ----------------------------------------------------------------
CREATE TABLE MAPA(
    COD_ZONA NUMBER(4),
    NOMBRE VARCHAR2(50) NOT NULL,
    REGION VARCHAR2(30) NOT NULL,
    DESCRIPCION VARCHAR2(300),
    CONSTRAINT PK_MAPA PRIMARY KEY (COD_ZONA)
);

-- ----------------------------------------------------------------
-- TABLA: POKEMON
-- Con restricciones de borrado coherentes:
-- - TIPO1: RESTRICT (obligatorio, no puede ser NULL)
-- - TIPO2: SET NULL (opcional, puede perder tipo secundario)
-- - HABILIDAD: RESTRICT (obligatorio, no puede ser NULL)
-- - ZONA: SET NULL (opcional, zonas pueden cerrarse)
-- ----------------------------------------------------------------
CREATE TABLE POKEMON(
    COD_POKEMON NUMBER(4),
    NOMBRE VARCHAR2(50) NOT NULL,
    PS_BASE NUMBER(3) NOT NULL,
    ATAQUE_BASE NUMBER(3) NOT NULL,
    DEFENSA_BASE NUMBER(3) NOT NULL,
    VELOCIDAD_BASE NUMBER(3) NOT NULL,
    COD_TIPO_1 NUMBER(3) NOT NULL,
    COD_TIPO_2 NUMBER(3),
    COD_HABILIDAD NUMBER(4) NOT NULL,
    COD_ZONA NUMBER(4),
    CONSTRAINT PK_POKEMON PRIMARY KEY (COD_POKEMON),
    CONSTRAINT UQ_POKEMON_NOMBRE UNIQUE (NOMBRE),
    CONSTRAINT CHK_PS_BASE CHECK (PS_BASE > 0),
    CONSTRAINT CHK_ATAQUE_BASE CHECK (ATAQUE_BASE > 0),
    CONSTRAINT CHK_DEFENSA_BASE CHECK (DEFENSA_BASE > 0),
    CONSTRAINT CHK_VELOCIDAD_BASE CHECK (VELOCIDAD_BASE > 0),
    CONSTRAINT FK_POKEMON_TIPO1 FOREIGN KEY (COD_TIPO_1) 
        REFERENCES TIPOS(COD_TIPO),
    CONSTRAINT FK_POKEMON_TIPO2 FOREIGN KEY (COD_TIPO_2) 
        REFERENCES TIPOS(COD_TIPO) ON DELETE SET NULL,
    CONSTRAINT FK_POKEMON_HABILIDAD FOREIGN KEY (COD_HABILIDAD) 
        REFERENCES HABILIDADES(COD_HABILIDAD),
    CONSTRAINT FK_POKEMON_ZONA FOREIGN KEY (COD_ZONA) 
        REFERENCES MAPA(COD_ZONA) ON DELETE SET NULL
);

-- ----------------------------------------------------------------
-- TABLA: MOVIMIENTOS
-- Con restricción de borrado:
-- - TIPO: RESTRICT (obligatorio para calcular efectividad)
-- ----------------------------------------------------------------
CREATE TABLE MOVIMIENTOS(
    COD_MOVIMIENTO NUMBER(4),
    NOMBRE VARCHAR2(50) NOT NULL,
    POTENCIA NUMBER(3),
    PRECISION_MOV NUMBER(3),
    PP NUMBER(2) NOT NULL,
    CATEGORIA VARCHAR2(20) NOT NULL,
    COD_TIPO NUMBER(3) NOT NULL,
    CONSTRAINT PK_MOVIMIENTOS PRIMARY KEY (COD_MOVIMIENTO),
    CONSTRAINT UQ_MOVIMIENTO_NOMBRE UNIQUE (NOMBRE),
    CONSTRAINT CHK_POTENCIA CHECK (POTENCIA >= 0),
    CONSTRAINT CHK_PRECISION CHECK (PRECISION_MOV BETWEEN 0 AND 100),
    CONSTRAINT CHK_PP CHECK (PP > 0),
    CONSTRAINT CHK_CATEGORIA CHECK (UPPER(CATEGORIA) IN ('FISICO', 'ESPECIAL', 'ESTADO')),
    CONSTRAINT FK_MOVIMIENTO_TIPO FOREIGN KEY (COD_TIPO) 
        REFERENCES TIPOS(COD_TIPO) 
);

-- ----------------------------------------------------------------
-- TABLA: OBJETOS
-- Sin claves foráneas (tabla independiente)
-- ----------------------------------------------------------------
CREATE TABLE OBJETOS(
    COD_OBJETO NUMBER(4),
    NOMBRE VARCHAR2(50) NOT NULL,
    DESCRIPCION VARCHAR2(300),
    PRECIO NUMBER(6) NOT NULL,
    EFECTO VARCHAR2(200),
    CONSTRAINT PK_OBJETOS PRIMARY KEY (COD_OBJETO),
    CONSTRAINT UQ_OBJETO_NOMBRE UNIQUE (NOMBRE),
    CONSTRAINT CHK_PRECIO CHECK (PRECIO >= 0)
);

-- ----------------------------------------------------------------
-- TABLA: ENTRENADOR
-- Con restricción de borrado:
-- - ZONA: SET NULL (entrenadores pueden viajar sin ubicación fija)
-- ----------------------------------------------------------------
CREATE TABLE ENTRENADOR(
    COD_ENTRENADOR NUMBER(6),
    NOMBRE VARCHAR2(80) NOT NULL,
    DNI VARCHAR2(20) NOT NULL,
    COD_ZONA NUMBER(4),
    CONSTRAINT PK_ENTRENADOR PRIMARY KEY (COD_ENTRENADOR),
    CONSTRAINT UQ_ENTRENADOR_DNI UNIQUE (DNI),
    CONSTRAINT FK_ENTRENADOR_ZONA FOREIGN KEY (COD_ZONA) 
        REFERENCES MAPA(COD_ZONA) ON DELETE SET NULL
);

-- ================================================================
-- PASO 3: CREAR TABLAS INTERMEDIAS (RELACIONES N:N)
-- ================================================================

-- ----------------------------------------------------------------
-- TABLA INTERMEDIA: POKEMON_MOVIMIENTO
-- Relación N:N entre POKEMON y MOVIMIENTOS
-- 
-- Representa qué movimientos puede aprender cada pokémon
-- 
-- Restricciones de borrado:
-- - FK_PM_POKEMON → CASCADE: Si eliminas un pokémon, sus movimientos
--   aprendidos no tienen sentido sin él
-- - FK_PM_MOVIMIENTO → RESTRICT: No deberías eliminar movimientos
--   que pokémon ya han aprendido
-- ----------------------------------------------------------------
CREATE TABLE POKEMON_MOVIMIENTO(
    COD_POKEMON NUMBER(4) NOT NULL,
    COD_MOVIMIENTO NUMBER(4) NOT NULL,
    NIVEL_APRENDIZAJE NUMBER(3) NOT NULL,
    CONSTRAINT PK_POKEMON_MOVIMIENTO PRIMARY KEY (COD_POKEMON, COD_MOVIMIENTO),
    CONSTRAINT CHK_PM_NIVEL CHECK (NIVEL_APRENDIZAJE BETWEEN 1 AND 100),
    CONSTRAINT FK_PM_POKEMON FOREIGN KEY (COD_POKEMON) 
        REFERENCES POKEMON(COD_POKEMON) ON DELETE CASCADE,
    CONSTRAINT FK_PM_MOVIMIENTO FOREIGN KEY (COD_MOVIMIENTO) 
        REFERENCES MOVIMIENTOS(COD_MOVIMIENTO) 
);

-- ----------------------------------------------------------------
-- TABLA INTERMEDIA: ENTRENADOR_POKEMON
-- Relación N:N entre ENTRENADOR y POKEMON
-- 
-- Representa el equipo pokémon de cada entrenador
-- Incluye información del estado actual de cada pokémon capturado
-- 
-- Restricciones de borrado:
-- - FK_EP_ENTRENADOR → CASCADE: Si un entrenador abandona el juego,
--   su equipo pokémon debe eliminarse también
-- - FK_EP_POKEMON → RESTRICT: No deberías eliminar especies que
--   entrenadores tienen capturadas (protege progreso del jugador)
-- ----------------------------------------------------------------
CREATE TABLE ENTRENADOR_POKEMON(
    COD_ENTRENADOR NUMBER(6) NOT NULL,
    COD_POKEMON NUMBER(4) NOT NULL,
    APODO VARCHAR2(50),
    NIVEL NUMBER(3) NOT NULL,
    PS_ACTUAL NUMBER(4) NOT NULL,
    EXPERIENCIA NUMBER(8) DEFAULT 0 NOT NULL,
    ESTADO VARCHAR2(15) DEFAULT 'ACTIVO' NOT NULL,
    FECHA_CAPTURA DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_ENTRENADOR_POKEMON PRIMARY KEY (COD_ENTRENADOR, COD_POKEMON),
    CONSTRAINT CHK_EP_NIVEL CHECK (NIVEL BETWEEN 1 AND 100),
    CONSTRAINT CHK_EP_PS CHECK (PS_ACTUAL >= 0),
    CONSTRAINT CHK_EP_EXPERIENCIA CHECK (EXPERIENCIA >= 0),
    CONSTRAINT CHK_EP_ESTADO CHECK (UPPER(ESTADO) IN ('ACTIVO', 'DEBILITADO', 'EN_PC')),
    CONSTRAINT FK_EP_ENTRENADOR FOREIGN KEY (COD_ENTRENADOR) 
        REFERENCES ENTRENADOR(COD_ENTRENADOR) ON DELETE CASCADE,
    CONSTRAINT FK_EP_POKEMON FOREIGN KEY (COD_POKEMON) 
        REFERENCES POKEMON(COD_POKEMON) 
);

-- ----------------------------------------------------------------
-- TABLA INTERMEDIA: ENTRENADOR_OBJETO
-- Relación N:N entre ENTRENADOR y OBJETOS
-- 
-- Representa el inventario de objetos de cada entrenador
-- 
-- Restricciones de borrado:
-- - FK_EO_ENTRENADOR → CASCADE: Si un entrenador abandona el juego,
--   su inventario debe eliminarse también
-- - FK_EO_OBJETO → RESTRICT: No deberías eliminar objetos del catálogo
--   mientras entrenadores los posean (protege inventarios)
-- ----------------------------------------------------------------
CREATE TABLE ENTRENADOR_OBJETO(
    COD_ENTRENADOR NUMBER(6) NOT NULL,
    COD_OBJETO NUMBER(4) NOT NULL,
    CANTIDAD NUMBER(3) NOT NULL,
    EQUIPADO CHAR(1) DEFAULT 'N' NOT NULL,
    FECHA_OBTENCION DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_ENTRENADOR_OBJETO PRIMARY KEY (COD_ENTRENADOR, COD_OBJETO),
    CONSTRAINT CHK_EO_CANTIDAD CHECK (CANTIDAD BETWEEN 1 AND 999),
    CONSTRAINT CHK_EO_EQUIPADO CHECK (UPPER(EQUIPADO) IN ('S', 'N')),
    CONSTRAINT FK_EO_ENTRENADOR FOREIGN KEY (COD_ENTRENADOR) 
        REFERENCES ENTRENADOR(COD_ENTRENADOR) ON DELETE CASCADE,
    CONSTRAINT FK_EO_OBJETO FOREIGN KEY (COD_OBJETO) 
        REFERENCES OBJETOS(COD_OBJETO) 
);


-- ================================================================
-- FIN DEL SCRIPT
-- ================================================================
-- 
-- RESUMEN DE RESTRICCIONES DE BORRADO:
-- 
-- TABLA POKEMON:
--   FK_POKEMON_TIPO1      → RESTRICT  (tipo primario obligatorio)
--   FK_POKEMON_TIPO2      → SET NULL  (tipo secundario opcional)
--   FK_POKEMON_HABILIDAD  → RESTRICT  (habilidad obligatoria)
--   FK_POKEMON_ZONA       → SET NULL  (zona opcional)
-- 
-- TABLA MOVIMIENTOS:
--   FK_MOVIMIENTO_TIPO    → RESTRICT  (tipo obligatorio)
-- 
-- TABLA ENTRENADOR:
--   FK_ENTRENADOR_ZONA    → SET NULL  (zona opcional)
-- 
-- TABLA POKEMON_MOVIMIENTO:
--   FK_PM_POKEMON         → CASCADE   (movimientos dependen del pokémon)
--   FK_PM_MOVIMIENTO      → RESTRICT  (protege movimientos en uso)
-- 
-- TABLA ENTRENADOR_POKEMON:
--   FK_EP_ENTRENADOR      → CASCADE   (equipo depende del entrenador)
--   FK_EP_POKEMON         → RESTRICT  (protege pokémon capturados)
-- 
-- TABLA ENTRENADOR_OBJETO:
--   FK_EO_ENTRENADOR      → CASCADE   (inventario depende del entrenador)
--   FK_EO_OBJETO          → RESTRICT  (protege objetos en inventarios)
-- 
-- ================================================================

COMMIT;