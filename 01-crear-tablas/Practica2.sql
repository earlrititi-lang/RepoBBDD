-- ================================================================
-- ANÁLISIS DE RESTRICCIONES DE BORRADO (FK)
-- ================================================================
-- FK_COPIAS_PELICULAS         → ON DELETE CASCADE
--   Una copia no tiene sentido sin su película. Si la película se
--   elimina del catálogo, todas sus copias físicas deben eliminarse
--   también. No tiene sentido tener copias huérfanas.
--
-- FK_ALQUILERES_CLIENTES      → RESTRICT (por defecto)
--   El historial de alquileres es un registro contable. No se puede
--   eliminar un cliente si tiene alquileres registrados, ya sea para
--   auditorías o para controlar si tiene copias pendientes de devolver.
--
-- FK_ALQUILERES_COPIAS        → RESTRICT (por defecto)
--   Una copia no debería eliminarse si tiene alquileres históricos
--   asociados. El registro debe conservarse para saber quién la tuvo
--   y cuándo.
--
-- FK_ALQUILERES_PELICULAS     → RESTRICT (por defecto)
--   El historial de qué películas se alquilaron debe conservarse.
--   Además, esta FK es en cierta medida redundante con
--   FK_ALQUILERES_COPIAS ya que CODPELICULA viene implícito en la
--   copia, pero se mantiene por integridad.
--
-- RESUMEN DE CAMBIOS:
-- ┌──────────────────────┬──────────┬──────────┐
-- │ FK                   │ Anterior │ Aplicado │
-- ├──────────────────────┼──────────┼──────────┤
-- │ FK_COPIAS_PELICULAS  │ RESTRICT │ CASCADE  │
-- │ El resto             │ RESTRICT │ RESTRICT │
-- └──────────────────────┴──────────┴──────────┘
-- ================================================================

CREATE TABLE PELICULAS(
    CODPELICULA NUMBER(4),
    NOMBRE VARCHAR2(20) NOT NULL,
    CATEGORIA VARCHAR2(10) NOT NULL,
    CONSTRAINT PK_PELICULAS PRIMARY KEY (CODPELICULA),
    CONSTRAINT CK_PELICULA_CATEGORIA CHECK (LOWER(CATEGORIA) IN ('comedia', 'drama', 'terror', 'suspense', 'ficcion'))
);

CREATE TABLE COPIAS(
    CODCOPIA NUMBER(2),
    CODPELICULA NUMBER(4),
    ESTADO VARCHAR2(10) NOT NULL,
    CONSTRAINT PK_COPIAS PRIMARY KEY (CODCOPIA, CODPELICULA),
    CONSTRAINT CK_COPIAS_ESTADO CHECK (LOWER(ESTADO) IN ('alquilada', 'libre', 'vendida')),
    CONSTRAINT FK_COPIAS_PELICULAS FOREIGN KEY (CODPELICULA) REFERENCES PELICULAS(CODPELICULA) ON DELETE CASCADE
    -- CASCADE: Una copia no tiene sentido sin su película. Si la película
    --          se elimina del catálogo, sus copias se eliminan también.
);

CREATE TABLE CLIENTES(
    CODCLIENTE NUMBER(4),
    NOMBRE VARCHAR2(30) NOT NULL,
    DNI VARCHAR2(9) NOT NULL,
    TELEFONO NUMBER(15),
    CONSTRAINT PK_CLIENTES PRIMARY KEY (CODCLIENTE)
);

DROP TABLE ALQUILERES;

CREATE TABLE ALQUILERES(
    CODCLIENTE NUMBER(4),
    CODCOPIA NUMBER(2),
    CODPELICULA NUMBER(4),
    FECHA DATE NOT NULL,
    CONSTRAINT PK_ALQUILERES PRIMARY KEY (CODCLIENTE, CODCOPIA, CODPELICULA, FECHA),
    CONSTRAINT FK_ALQUILERES_CLIENTES FOREIGN KEY (CODCLIENTE) REFERENCES CLIENTES(CODCLIENTE),
    -- RESTRICT: No se puede eliminar un cliente con alquileres registrados,
    --           podría tener copias pendientes de devolver.
    CONSTRAINT FK_ALQUILERES_COPIAS FOREIGN KEY (CODCOPIA, CODPELICULA) REFERENCES COPIAS(CODCOPIA, CODPELICULA),
    -- RESTRICT: El historial de qué copias se alquilaron debe conservarse
    --           para saber quién la tuvo y cuándo.
    CONSTRAINT FK_ALQUILERES_PELICULAS FOREIGN KEY (CODPELICULA) REFERENCES PELICULAS(CODPELICULA)
    -- RESTRICT: El historial de películas alquiladas debe conservarse.
    --           FK mantenida por integridad aunque CODPELICULA ya viene
    --           implícito a través de FK_ALQUILERES_COPIAS.
);