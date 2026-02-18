-- ================================================================
-- ANÁLISIS DE RESTRICCIONES DE BORRADO (FK)
-- ================================================================
-- FK_MEDICAMENTO_FAMILIA    → RESTRICT (por defecto)
--   Un medicamento siempre debe pertenecer a una familia
--   (COD_FAMILIA es NOT NULL), así que no tiene sentido ni CASCADE
--   ni SET NULL. Si quieres borrar una familia, primero reasigna
--   sus medicamentos.
--
-- FK_MEDICAMENTO_LABORATORIO → ON DELETE SET NULL
--   Si un laboratorio cierra o deja de ser proveedor, el medicamento
--   sigue existiendo en el catálogo, posiblemente fabricado por la
--   propia farmacia. COD_LABORATORIO ya permite NULL, así que el
--   cambio encaja perfectamente.
--
-- FK_C_CREDITO_CLIENTE      → ON DELETE CASCADE
--   C_CREDITO es una extensión de CLIENTE, no tiene vida propia
--   sin él. Si el cliente se elimina, sus datos bancarios de crédito
--   deben eliminarse también.
--
-- FK_COMP_CREDITO_MEDICAMENTO → RESTRICT (por defecto)
--   Las compras son registros históricos y contables. No puedes
--   borrar un medicamento si hay compras registradas de él.
--
-- FK_COMP_CREDITO_CLIENTE   → RESTRICT (por defecto)
--   El historial de compras a crédito no debe desaparecer si se
--   elimina el cliente.
--
-- FK_COMP_EFEC_MEDICAMENTO  → RESTRICT (por defecto)
--   Mismo razonamiento, son registros contables.
--
-- FK_COMP_EFEC_CLIENTE      → RESTRICT (por defecto)
--   El historial de compras al contado debe conservarse aunque el
--   cliente ya no exista.
--
-- RESUMEN DE CAMBIOS:
-- ┌──────────────────────────────┬──────────┬────────────┐
-- │ FK                           │ Anterior │ Aplicado   │
-- ├──────────────────────────────┼──────────┼────────────┤
-- │ FK_MEDICAMENTO_LABORATORIO   │ RESTRICT │ SET NULL   │
-- │ FK_C_CREDITO_CLIENTE         │ RESTRICT │ CASCADE    │
-- │ El resto                     │ RESTRICT │ RESTRICT   │
-- └──────────────────────────────┴──────────┴────────────┘
-- ================================================================

CREATE TABLE FAMILIA(
    CODIGO NUMBER(10),
    DESCRIPCION VARCHAR2(200),
    CONSTRAINT PK_FAMILIA PRIMARY KEY (CODIGO)
);

CREATE TABLE LABORATORIO(
    CODIGO NUMBER(10),
    NOMBRE VARCHAR2(100) NOT NULL,
    TELEF VARCHAR2(20),
    DIR VARCHAR2(200),
    FAX VARCHAR2(20),
    CONTACTO VARCHAR2(100),
    CONSTRAINT PK_LABORATORIO PRIMARY KEY (CODIGO)
);

CREATE TABLE MEDICAMENTO(
    CODIGO NUMBER(10),
    NOMBRE VARCHAR2(100) NOT NULL,
    TIPO VARCHAR2(100) NOT NULL,
    STOCK NUMBER(10) DEFAULT 0 NOT NULL,
    VENDIDAS NUMBER(10) DEFAULT 0,
    PRECIO NUMBER(10,2) NOT NULL,
    RECETA CHAR(2) CHECK (UPPER(RECETA) IN ('SI', 'NO')),
    COD_FAMILIA NUMBER(10) NOT NULL,
    COD_LABORATORIO NUMBER(10),
    CONSTRAINT PK_MEDICAMENTO PRIMARY KEY (CODIGO),
    CONSTRAINT FK_MEDICAMENTO_FAMILIA FOREIGN KEY (COD_FAMILIA) REFERENCES FAMILIA(CODIGO),
    -- RESTRICT: Un medicamento siempre debe pertenecer a una familia. Borrar la familia
    --           requiere reasignar previamente todos sus medicamentos.
    CONSTRAINT FK_MEDICAMENTO_LABORATORIO FOREIGN KEY (COD_LABORATORIO) REFERENCES LABORATORIO(CODIGO) ON DELETE SET NULL
    -- SET NULL: Si el laboratorio desaparece, el medicamento permanece en el catálogo
    --           con COD_LABORATORIO a NULL (posiblemente fabricado por la propia farmacia).
);

CREATE TABLE CLIENTE(
    DNI VARCHAR2(20),
    TELEF VARCHAR2(20),
    DIR VARCHAR2(200),
    CONSTRAINT PK_CLIENTE PRIMARY KEY (DNI)
);

CREATE TABLE C_CREDITO(
    DNI VARCHAR2(20),
    DATOS_BANCO VARCHAR2(100),
    CONSTRAINT PK_C_CREDITO PRIMARY KEY (DNI),
    CONSTRAINT FK_C_CREDITO_CLIENTE FOREIGN KEY (DNI) REFERENCES CLIENTE(DNI) ON DELETE CASCADE
    -- CASCADE: C_CREDITO es una extensión de CLIENTE, no tiene vida propia sin él.
    --          Si el cliente se elimina, sus datos bancarios se eliminan también.
);

CREATE TABLE COMP_CREDITO(
    COD_MED NUMBER(10),
    DNI_CLIEN VARCHAR2(20),
    FECH_COMP DATE NOT NULL,
    UNIDADES NUMBER(10) NOT NULL,
    FECH_PAGO DATE,
    CONSTRAINT PK_COMP_CREDITO PRIMARY KEY (COD_MED, DNI_CLIEN, FECH_COMP),
    CONSTRAINT FK_COMP_CREDITO_MEDICAMENTO FOREIGN KEY (COD_MED) REFERENCES MEDICAMENTO(CODIGO),
    -- RESTRICT: Las compras son registros contables. No se puede borrar un medicamento
    --           si tiene compras registradas.
    CONSTRAINT FK_COMP_CREDITO_CLIENTE FOREIGN KEY (DNI_CLIEN) REFERENCES C_CREDITO(DNI)
    -- RESTRICT: El historial de compras a crédito debe conservarse aunque el cliente
    --           ya no exista en el sistema.
);

CREATE TABLE COMP_EFEC(
    COD_MED NUMBER(10),
    DNI_CLIEN VARCHAR2(20),
    FECH_COMP DATE NOT NULL,
    UNIDADES NUMBER(10) NOT NULL,
    CONSTRAINT PK_COMP_EFEC PRIMARY KEY (COD_MED, DNI_CLIEN, FECH_COMP),
    CONSTRAINT FK_COMP_EFEC_MEDICAMENTO FOREIGN KEY (COD_MED) REFERENCES MEDICAMENTO(CODIGO),
    -- RESTRICT: Mismo razonamiento que en COMP_CREDITO, son registros contables.
    CONSTRAINT FK_COMP_EFEC_CLIENTE FOREIGN KEY (DNI_CLIEN) REFERENCES CLIENTE(DNI)
    -- RESTRICT: El historial de compras al contado debe conservarse aunque el cliente
    --           ya no exista en el sistema.
);