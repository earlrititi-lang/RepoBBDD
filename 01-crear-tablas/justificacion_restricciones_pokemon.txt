===============================================================================
JUSTIFICACIÓN DE RESTRICCIONES DE BORRADO - BASE DE DATOS POKÉMON
===============================================================================

Este documento explica las decisiones tomadas para cada clave foránea.

===============================================================================
REGLAS DE BORRADO DISPONIBLES EN ORACLE
===============================================================================

1. ON DELETE RESTRICT (o sin especificar - es el comportamiento por defecto)
   - No permite eliminar un registro si tiene dependientes
   - Protección máxima: "No puedes borrar esto mientras esté en uso"
   
2. ON DELETE CASCADE
   - Elimina en cascada todos los registros dependientes
   - "Si elimino esto, todo lo que depende de ello también se elimina"
   
3. ON DELETE SET NULL
   - Pone NULL en la FK de los registros dependientes
   - "Si elimino esto, los dependientes pierden la referencia pero siguen existiendo"
   - ⚠️ REQUIERE que la columna FK permita NULL

===============================================================================
DECISIONES TOMADAS - TABLA POR TABLA
===============================================================================

═══════════════════════════════════════════════════════════════════════════
TABLA: POKEMON
═══════════════════════════════════════════════════════════════════════════

FK_POKEMON_TIPO1 (COD_TIPO_1) → ON DELETE RESTRICT
---------------------------------------------------
DECISIÓN: RESTRICT

JUSTIFICACIÓN:
- Un pokémon SIEMPRE debe tener un tipo primario (columna NOT NULL)
- Los tipos son fundamentales para el sistema de combate
- No se puede usar SET NULL porque la columna es NOT NULL
- No se usa CASCADE porque eliminarías pokémon al borrar un tipo

ESCENARIO:
Si intentas eliminar el tipo "Fuego":
❌ ERROR: Charmander, Charmeleon, Charizard, etc. lo usan como tipo primario
✅ Solución: Primero reasigna estos pokémon a otro tipo

---

FK_POKEMON_TIPO2 (COD_TIPO_2) → ON DELETE SET NULL
---------------------------------------------------
DECISIÓN: SET NULL

JUSTIFICACIÓN:
- El tipo secundario es OPCIONAL (columna permite NULL)
- Un pokémon puede existir perfectamente con un solo tipo
- Si se elimina un tipo usado solo como secundario, el pokémon sigue siendo válido

ESCENARIO:
Si eliminas el tipo "Volador" que Charizard tiene como secundario:
✅ Charizard pasa de (Fuego/Volador) a (Fuego/--)
✅ El pokémon sigue existiendo, solo pierde su tipo secundario

---

FK_POKEMON_HABILIDAD (COD_HABILIDAD) → ON DELETE RESTRICT
----------------------------------------------------------
DECISIÓN: RESTRICT

JUSTIFICACIÓN:
- Un pokémon SIEMPRE debe tener una habilidad (columna NOT NULL)
- Las habilidades son características permanentes de cada especie
- No se puede usar SET NULL porque la columna es NOT NULL
- No se usa CASCADE porque sería drástico eliminar pokémon por retirar una habilidad

ESCENARIO:
Si intentas eliminar la habilidad "Mar Llamas":
❌ ERROR: Charmander la está usando
✅ Solución: Primero asigna otra habilidad a Charmander

---

FK_POKEMON_ZONA (COD_ZONA) → ON DELETE SET NULL
------------------------------------------------
DECISIÓN: SET NULL

JUSTIFICACIÓN:
- La zona es OPCIONAL (columna permite NULL)
- Las zonas pueden cerrarse temporalmente por mantenimiento/eventos
- El pokémon sigue existiendo en la Pokédex nacional sin ubicación

ESCENARIO:
Si eliminas "Monte Luna" (zona 3):
✅ Los pokémon que aparecían ahí quedan con COD_ZONA = NULL
✅ Siguen en la Pokédex, solo sin ubicación de aparición


═══════════════════════════════════════════════════════════════════════════
TABLA: MOVIMIENTOS
═══════════════════════════════════════════════════════════════════════════

FK_MOVIMIENTO_TIPO (COD_TIPO) → ON DELETE RESTRICT
---------------------------------------------------
DECISIÓN: RESTRICT

JUSTIFICACIÓN:
- Un movimiento SIEMPRE debe tener un tipo (columna NOT NULL)
- El tipo es fundamental para calcular la efectividad en combate
- No se puede usar SET NULL porque la columna es NOT NULL

CONSIDERACIÓN ALTERNATIVA:
- Se podría usar CASCADE si al retirar un tipo del juego, todos sus 
  movimientos también deban retirarse
- RESTRICT es más seguro: obliga a reclasificar movimientos antes de 
  eliminar un tipo

ESCENARIO:
Si intentas eliminar el tipo "Eléctrico":
❌ ERROR: "Impactrueno", "Rayo", "Trueno" lo están usando
✅ Solución: Reclasifica estos movimientos a otro tipo o acepta que no 
   puedes eliminar el tipo


═══════════════════════════════════════════════════════════════════════════
TABLA: ENTRENADOR
═══════════════════════════════════════════════════════════════════════════

FK_ENTRENADOR_ZONA (COD_ZONA) → ON DELETE SET NULL
---------------------------------------------------
DECISIÓN: SET NULL

JUSTIFICACIÓN:
- La zona es OPCIONAL (columna permite NULL)
- Los entrenadores viajan constantemente entre zonas
- Si una zona se elimina del mapa, el entrenador sigue existiendo

ESCENARIO:
Si eliminas "Pueblo Paleta" (zona 1):
✅ Ash y Gary quedan con COD_ZONA = NULL (sin ubicación temporal)
✅ Los entrenadores siguen existiendo en el sistema


═══════════════════════════════════════════════════════════════════════════
TABLA INTERMEDIA: POKEMON_MOVIMIENTO
═══════════════════════════════════════════════════════════════════════════

FK_PM_POKEMON (COD_POKEMON) → ON DELETE CASCADE
------------------------------------------------
DECISIÓN: CASCADE

JUSTIFICACIÓN:
- Si eliminas un pokémon de la Pokédex, sus movimientos aprendidos no 
  tienen sentido
- La fila "Pikachu aprende Impactrueno en nivel 5" no sirve sin Pikachu
- Los registros de aprendizaje son DEPENDIENTES del pokémon

ESCENARIO:
Si eliminas Pikachu:
✅ Se eliminan automáticamente todas las filas de POKEMON_MOVIMIENTO 
   donde COD_POKEMON = 25
✅ Los movimientos (Impactrueno, Rayo, etc.) siguen existiendo en el 
   catálogo para otros pokémon

---

FK_PM_MOVIMIENTO (COD_MOVIMIENTO) → ON DELETE RESTRICT
-------------------------------------------------------
DECISIÓN: RESTRICT

JUSTIFICACIÓN:
- Si eliminas un movimiento del catálogo, NO deberían desaparecer todos 
  los pokémon que lo aprenden
- RESTRICT protege: para eliminar un movimiento, primero hay que 
  desasociarlo de todos los pokémon

ESCENARIO:
Si intentas eliminar "Impactrueno":
❌ ERROR: Pikachu, Raichu, Pichu lo pueden aprender
✅ Solución: Primero elimina estas asociaciones en POKEMON_MOVIMIENTO


═══════════════════════════════════════════════════════════════════════════
TABLA INTERMEDIA: ENTRENADOR_POKEMON
═══════════════════════════════════════════════════════════════════════════

FK_EP_ENTRENADOR (COD_ENTRENADOR) → ON DELETE CASCADE
------------------------------------------------------
DECISIÓN: CASCADE

JUSTIFICACIÓN:
- Si un entrenador abandona el juego (se elimina su cuenta), su equipo 
  pokémon debe eliminarse también
- Los pokémon capturados son DATOS DEL JUGADOR, no del catálogo
- Un equipo "huérfano" no tiene utilidad en el sistema

ESCENARIO:
Si eliminas a Ash (COD_ENTRENADOR = 1):
✅ Se eliminan automáticamente sus 5 pokémon capturados de ENTRENADOR_POKEMON
✅ Los pokémon del catálogo (Pikachu, Charizard) siguen existiendo en 
   la tabla POKEMON
✅ Otros entrenadores pueden seguir capturando estos pokémon

---

FK_EP_POKEMON (COD_POKEMON) → ON DELETE RESTRICT
-------------------------------------------------
DECISIÓN: RESTRICT

JUSTIFICACIÓN:
- Si eliminas una especie de la Pokédex (ej: Charmander), NO deberían 
  desaparecer todos los Charmander capturados por entrenadores
- RESTRICT protege el PROGRESO del jugador
- Es más seguro: obliga a liberar pokémon antes de retirar especies

CONSIDERACIÓN:
Si realmente quieres retirar una especie del juego (ej: por rebalanceo), 
primero debes:
1. Implementar un sistema de "liberación masiva" o "conversión"
2. Notificar a los jugadores
3. Eliminar las capturas manualmente
4. Entonces eliminar la especie del catálogo

ESCENARIO:
Si intentas eliminar Charmander del catálogo:
❌ ERROR: Ash tiene un Charmander capturado
✅ Solución: Primero Ash debe liberar su Charmander


═══════════════════════════════════════════════════════════════════════════
TABLA INTERMEDIA: ENTRENADOR_OBJETO
═══════════════════════════════════════════════════════════════════════════

FK_EO_ENTRENADOR (COD_ENTRENADOR) → ON DELETE CASCADE
------------------------------------------------------
DECISIÓN: CASCADE

JUSTIFICACIÓN:
- Si un entrenador abandona el juego, su inventario debe eliminarse también
- El inventario es DATOS DEL JUGADOR
- Un inventario "huérfano" no tiene sentido

ESCENARIO:
Si eliminas a Ash:
✅ Se eliminan automáticamente sus objetos de ENTRENADOR_OBJETO
✅ Los objetos del catálogo (Poción, Pokéball) siguen existiendo en OBJETOS

---

FK_EO_OBJETO (COD_OBJETO) → ON DELETE RESTRICT
-----------------------------------------------
DECISIÓN: RESTRICT

JUSTIFICACIÓN:
- Si eliminas un objeto del catálogo, NO deberían desaparecer todos los 
  ejemplares que tienen los entrenadores
- RESTRICT protege el INVENTARIO del jugador
- Es más justo: los jugadores pueden quedarse con objetos "legacy"

CONSIDERACIÓN ALTERNATIVA:
Se podría usar CASCADE si al retirar un objeto del juego, quieres que 
desaparezca de todos los inventarios automáticamente. Pero esto puede 
causar frustración en los jugadores.

ESCENARIO:
Si intentas eliminar "Poción" del catálogo:
❌ ERROR: Ash, Misty, Brock tienen pociones en su inventario
✅ Solución 1: Implementa un sistema de "canje" o "conversión"
✅ Solución 2: Espera a que los jugadores usen sus pociones


===============================================================================
TABLA COMPARATIVA DE DECISIONES
===============================================================================

┌─────────────────────────┬──────────────┬────────────────────────────────┐
│ CLAVE FORÁNEA           │ REGLA        │ JUSTIFICACIÓN                  │
├─────────────────────────┼──────────────┼────────────────────────────────┤
│ FK_POKEMON_TIPO1        │ RESTRICT     │ Tipo primario obligatorio      │
│ FK_POKEMON_TIPO2        │ SET NULL     │ Tipo secundario opcional       │
│ FK_POKEMON_HABILIDAD    │ RESTRICT     │ Habilidad obligatoria          │
│ FK_POKEMON_ZONA         │ SET NULL     │ Zona opcional                  │
│ FK_MOVIMIENTO_TIPO      │ RESTRICT     │ Tipo obligatorio               │
│ FK_ENTRENADOR_ZONA      │ SET NULL     │ Zona opcional                  │
│ FK_PM_POKEMON           │ CASCADE      │ Dependiente del pokémon        │
│ FK_PM_MOVIMIENTO        │ RESTRICT     │ Protege movimientos en uso     │
│ FK_EP_ENTRENADOR        │ CASCADE      │ Datos del jugador              │
│ FK_EP_POKEMON           │ RESTRICT     │ Protege progreso del jugador   │
│ FK_EO_ENTRENADOR        │ CASCADE      │ Datos del jugador              │
│ FK_EO_OBJETO            │ RESTRICT     │ Protege inventario del jugador │
└─────────────────────────┴──────────────┴────────────────────────────────┘


===============================================================================
PRINCIPIOS GENERALES APLICADOS
===============================================================================

1. RESTRICT cuando:
   ✅ La columna es NOT NULL (no se puede usar SET NULL)
   ✅ Quieres proteger datos en uso (catálogos, configuraciones)
   ✅ La eliminación debe ser un proceso controlado

2. CASCADE cuando:
   ✅ Los datos dependientes no tienen sentido sin el padre
   ✅ Son datos del usuario/jugador (equipo, inventario)
   ✅ Quieres simplificar la eliminación de datos relacionados

3. SET NULL cuando:
   ✅ La columna permite NULL
   ✅ El registro hijo puede existir sin el padre
   ✅ La relación es opcional o temporal


===============================================================================
PREGUNTAS FRECUENTES
===============================================================================

Q1: ¿Por qué no usar CASCADE en todas las FK?
A: CASCADE elimina automáticamente datos dependientes. Esto es peligroso si 
   eliminas accidentalmente un registro importante (ej: un tipo usado por 
   muchos pokémon).

Q2: ¿Por qué no usar RESTRICT en todas las FK?
A: RESTRICT puede ser demasiado estricto. Por ejemplo, si no puedes eliminar 
   un entrenador porque tiene objetos, tendrías que eliminar manualmente 
   cada objeto uno por uno.

Q3: ¿Cuándo usar SET NULL vs CASCADE?
A: SET NULL si el hijo puede existir sin el padre (ej: pokémon sin zona).
   CASCADE si el hijo no tiene sentido sin el padre (ej: equipo sin entrenador).


===============================================================================
FIN DEL DOCUMENTO
===============================================================================