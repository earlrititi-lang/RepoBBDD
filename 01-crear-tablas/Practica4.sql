--Reglas de borrado
--FK_VEHICULO_PROPIETARIO → ON DELETE SET NULL
--Si se elimina un propietario, el vehículo sigue existiendo (puede venderse, estar en trámites, etc.), pero su propietario quedaría a NULL temporalmente. Tiene sentido que el vehículo no desaparezca. Para esto, NIF_PROPIETARIO en VEHICULO tendría que permitir NULLs, por lo que habría que quitarle el NOT NULL.
--FK_DENUNCIA_VEHICULO → ON DELETE CASCADE
--Si se elimina un vehículo del sistema (dado de baja definitivamente), todas sus denuncias asociadas pierden sentido y deberían eliminarse también.


--El resto van con RESTRICT:


--FK_DENUNCIA_AGENTE → No tiene sentido borrar un agente si tiene denuncias puestas, son registros legales.
--FK_DENUNCIA_INFRACCION → Una infracción del catálogo no debería borrarse si ya se ha usado en denuncias.
--FK_DENUNCIA_INFRACTOR → Un infractor con denuncias no debería poder eliminarse.


CREATE TABLE INFRACCION(
    CODIGO_INFRACCION NUMBER(4),
    IMPORTE_SANCION NUMBER(8,2) NOT NULL,
    DESCRIPCION_INFRACCION VARCHAR2(300) NOT NULL,
    CONSTRAINT PK_INFRACCION PRIMARY KEY (CODIGO_INFRACCION),
    CONSTRAINT CHK_IMPORTE_MINIMO CHECK (IMPORTE_SANCION >= 30)
);

CREATE TABLE INFRACTOR(
    NIF_SANCIONADO VARCHAR2(9),
    NOMBRE_SANCIONADO VARCHAR2(100) NOT NULL,
    CONSTRAINT PK_INFRACTOR PRIMARY KEY (NIF_SANCIONADO)
);

CREATE TABLE AGENTE(
    NIF_AGENTE VARCHAR2(9),
    NUM_AGENTE NUMBER(4) NOT NULL,
    NOMBRE_AGENTE VARCHAR2(100) NOT NULL,
    RANGO_AGENTE VARCHAR2(50) DEFAULT 'AGENTE'NOT NULL,
    CONSTRAINT PK_AGENTE PRIMARY KEY (NIF_AGENTE),
    CONSTRAINT UQ_NUM_AGENTE UNIQUE (NUM_AGENTE)
);

CREATE TABLE PROPIETARIO(
    NIF_PROPIETARIO VARCHAR2(9),
    NOMBRE_PROPIETARIO VARCHAR2(100) NOT NULL,
    CONSTRAINT PK_PROPIETARIO PRIMARY KEY (NIF_PROPIETARIO)
);

CREATE TABLE VEHICULO(
    MATRICULA VARCHAR2(7),
    MODELO VARCHAR2(30) NOT NULL,
    MARCA VARCHAR2(30) NOT NULL,
    COLOR VARCHAR2(30),
    NIF_PROPIETARIO VARCHAR2(9),
    CIA_ASEGURADORA VARCHAR2(50),
    NUM_POLIZA VARCHAR2(20),
    CONSTRAINT PK_VEHICULO PRIMARY KEY (MATRICULA),
    CONSTRAINT UK_NUM_POLIZA UNIQUE (NUM_POLIZA),
    CONSTRAINT FK_VEHICULO_PROPIETARIO FOREIGN KEY (NIF_PROPIETARIO) REFERENCES PROPIETARIO(NIF_PROPIETARIO) ON DELETE SET NULL
    -- Si se elimina el propietario, el vehículo permanece en el sistema con propietario a NULL (posiblemente un vehículo sin dueño conocido o abandonado).
);

CREATE TABLE DENUNCIA(
    NIF_AGENTE VARCHAR2(9) NOT NULL,
    FECHAHORA_INFRACCION DATE DEFAULT SYSDATE NOT NULL,
    LUGAR VARCHAR2(200) NOT NULL,
    CODIGO_INFRACCION NUMBER(4) NOT NULL,
    MATRICULA VARCHAR2(7) NOT NULL,
    NIF_SANCIONADO VARCHAR2(9) NOT NULL,
    PAPEL_SANCIONADO VARCHAR2(20) NOT NULL,
    INMOVILIZADO VARCHAR2(1) DEFAULT 'N' NOT NULL,
    MATRICULA_GRUA VARCHAR2(7),
    NIF_GRUA VARCHAR2(9),
    CONSTRAINT PK_DENUNCIA PRIMARY KEY (CODIGO_INFRACCION, FECHAHORA_INFRACCION, NIF_SANCIONADO),
     -- La clave primaria de DENUNCIA se compone de CODIGO_INFRACCION, FECHAHORA_INFRACCION y NIF_SANCIONADO
     -- para permitir múltiples denuncias por el mismo infractor y el mismo tipo de infracción en diferentes momentos.
     -- Además, garantiza que no haya denuncias duplicadas con la misma combinación de infracción, fecha/hora e infractor.
     -- Si se quisiera permitir solo una denuncia por infracción e infractor, se podría eliminar FECHAHORA_INFRACCION de la clave primaria.
     -- En ese caso, habría que considerar cómo manejar las denuncias posteriores del mismo tipo para el mismo infractor (¿actualizar la denuncia existente o rechazar nuevas denuncias?).
     -- La elección depende de los requisitos específicos del sistema de gestión de denuncias.
    CONSTRAINT CHK_INMOVILIZADO CHECK (UPPER(INMOVILIZADO) IN ('S', 'N')),
    CONSTRAINT FK_DENUNCIA_AGENTE FOREIGN KEY (NIF_AGENTE) REFERENCES AGENTE(NIF_AGENTE),
    -- RESTRICT: No se puede eliminar un agente con denuncias (son registros legales)
     -- El historial de denuncias debe conservarse para saber quién las puso y cuándo.
     -- Además, esta FK es en cierta medida redundante con FK_DENUNCIA_VEHICULO ya que el agente viene implícito en la denuncia, pero se mantiene por integridad.
    CONSTRAINT FK_DENUNCIA_INFRACCION FOREIGN KEY (CODIGO_INFRACCION) REFERENCES INFRACCION(CODIGO_INFRACCION),
    -- RESTRICT: No se puede eliminar una infracción del catálogo si ya ha sido usada en una denuncia
    CONSTRAINT FK_DENUNCIA_VEHICULO FOREIGN KEY (MATRICULA) REFERENCES VEHICULO(MATRICULA) ON DELETE CASCADE,
     -- CASCADE: Si el vehículo se da de baja definitivamente, sus denuncias se eliminan también
    CONSTRAINT FK_DENUNCIA_INFRACTOR FOREIGN KEY (NIF_SANCIONADO) REFERENCES INFRACTOR(NIF_SANCIONADO)
    -- RESTRICT: No se puede eliminar un infractor que tenga denuncias asociadas


);