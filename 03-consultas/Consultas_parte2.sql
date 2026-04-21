===============================================================================
7. GROUP BY Y HAVING: AGRUPACION DE DATOS
===============================================================================

GROUP BY agrupa filas que tienen el mismo valor en una o varias columnas.
Despues puedes aplicar funciones de agregacion sobre cada grupo:
COUNT(), SUM(), AVG(), MAX(), MIN().

IDEA RAPIDA:
------------
- WHERE filtra filas individuales.
- GROUP BY construye grupos.
- HAVING filtra grupos completos.

ORDEN LOGICO DE EJECUCION:
--------------------------

FROM -> WHERE -> GROUP BY -> AGREGACIONES -> HAVING -> SELECT -> ORDER BY

Cómo entenderlo:

FROM: se forman las filas base.
WHERE: se filtran filas individuales.
GROUP BY: esas filas se agrupan.
AGREGACIONES: sobre cada grupo se calculan COUNT, SUM, AVG, MAX, MIN.
HAVING: filtra grupos usando esos resultados agregados.
SELECT: se construye la salida final.
ORDER BY: se ordena el resultado.
Por eso:

WHERE COUNT(*) > 3 da error: todavía no existen los grupos ni la agregación.
HAVING COUNT(*) > 3 sí funciona: el COUNT(*) ya fue calculado sobre cada grupo.
Ejemplo:

SELECT COD_TIPO_1, COUNT(*) AS CANTIDAD
FROM POKEMON
WHERE COD_POKEMON < 144
GROUP BY COD_TIPO_1
HAVING CANTIDAD > 2
ORDER BY CANTIDAD DESC;

Aquí:

FROM toma POKEMON
WHERE deja solo COD_POKEMON < 144
GROUP BY crea un grupo por COD_TIPO_1
COUNT(*) se calcula para cada grupo
HAVING deja solo los grupos con más de 2 filas
SELECT muestra COD_TIPO_1 y CANTIDAD
ORDER BY ordena por CANTIDAD

SINTAXIS BASE:
--------------
SELECT columnas_grupo, FUNCION_AGREGACION(columna)
FROM tabla
WHERE condicion_sobre_filas         -- Antes de agrupar
GROUP BY columnas_grupo
HAVING condicion_sobre_grupos;      -- Despues de agrupar

NOTA DIDACTICA:
---------------
En cada ejemplo veras una "LECTURA VISUAL".
Usa unas pocas filas reales del dataset para que se vea el proceso.
No pretende sustituir el resultado completo de la consulta, sino mostrar
paso a paso que hace WHERE, como agrupa GROUP BY y cuando entra HAVING.
Puede omitir grupos reales que tambien aparezcan en la salida final, pero
el orden de ejecucion y el efecto de cada clausula son los correctos.


EJEMPLO VISUAL MUY RAPIDO:
--------------------------
FILAS ORIGINALES
COD_TIPO_1  ATAQUE_BASE
----------  -----------
1           52
1           84
2           48
2           65
2           72
3           90

1. WHERE ATAQUE_BASE >= 60
   Se quedan solo estas filas:
   (1, 84), (2, 65), (2, 72), (3, 90)

2. GROUP BY COD_TIPO_1
   tipo 1 -> [84]
   tipo 2 -> [65, 72]
   tipo 3 -> [90]

3. HAVING COUNT(*) >= 2
   Solo sobrevive el grupo del tipo 2

CONCLUSION:
- WHERE elimina filas antes de crear grupos.
- HAVING elimina grupos despues de calcular COUNT, SUM, AVG, etc.


7.1. GROUP BY basico
--------------------

EJEMPLO 1: Cuantos pokemon hay de cada tipo principal
-----------------------------------------------------
SELECT COD_TIPO_1, COUNT(*) AS CANTIDAD
FROM POKEMON
GROUP BY COD_TIPO_1
ORDER BY CANTIDAD DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_TIPO_1
-----------  ----------
Charmander   1
Charmeleon   1
Squirtle     2
Pikachu      3
Raichu       3
Bulbasaur    4

1. WHERE
   No se usa, asi que pasan todas las filas.

2. GROUP BY COD_TIPO_1
   tipo 1 -> [Charmander, Charmeleon]
   tipo 2 -> [Squirtle]
   tipo 3 -> [Pikachu, Raichu]
   tipo 4 -> [Bulbasaur]

3. HAVING
   No se usa, asi que no se elimina ningun grupo.

4. COUNT(*)
   tipo 1 -> 2
   tipo 2 -> 1
   tipo 3 -> 2
   tipo 4 -> 1


EJEMPLO 2: PS promedio por tipo principal
-----------------------------------------
SELECT COD_TIPO_1, ROUND(AVG(PS_BASE), 2) AS PS_PROMEDIO
FROM POKEMON
GROUP BY COD_TIPO_1
ORDER BY PS_PROMEDIO DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_TIPO_1  PS_BASE
-----------  ----------  -------
Charmander   1           39
Charmeleon   1           58
Squirtle     2           44
Wartortle    2           59
Pikachu      3           35
Raichu       3           60

1. WHERE
   No se usa, asi que pasan todas las filas.

2. GROUP BY COD_TIPO_1
   tipo 1 -> [39, 58]
   tipo 2 -> [44, 59]
   tipo 3 -> [35, 60]

3. HAVING
   No se usa.

4. AVG(PS_BASE)
   tipo 1 -> 48.50
   tipo 2 -> 51.50
   tipo 3 -> 47.50


EJEMPLO 3: Cuantos pokemon tiene cada entrenador
------------------------------------------------
SELECT COD_ENTRENADOR, COUNT(*) AS CANTIDAD_POKEMON
FROM ENTRENADOR_POKEMON
GROUP BY COD_ENTRENADOR
ORDER BY CANTIDAD_POKEMON DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
COD_ENTRENADOR  COD_POKEMON  APODO
--------------  -----------  -------------
1               25           Pikachu
1               6            Rizardon
1               130          Gyara
4               9            Blastoise
4               26           Raichu
4               149          Dragonite

1. WHERE
   No se usa, asi que pasan todas las filas.

2. GROUP BY COD_ENTRENADOR
   entrenador 1 -> [25, 6, 130]
   entrenador 4 -> [9, 26, 149]

3. HAVING
   No se usa.

4. COUNT(*)
   entrenador 1 -> 3
   entrenador 4 -> 3


EJEMPLO 4: Total de objetos que tiene cada entrenador
-----------------------------------------------------
SELECT COD_ENTRENADOR, SUM(CANTIDAD) AS TOTAL_OBJETOS
FROM ENTRENADOR_OBJETO
GROUP BY COD_ENTRENADOR
ORDER BY TOTAL_OBJETOS DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
COD_ENTRENADOR  COD_OBJETO  CANTIDAD
--------------  ----------  --------
1               1           15
1               2           8
1               6           25
2               1           20
2               3           12
4               3           50
4               4           20

1. WHERE
   No se usa.

2. GROUP BY COD_ENTRENADOR
   entrenador 1 -> [15, 8, 25]
   entrenador 2 -> [20, 12]
   entrenador 4 -> [50, 20]

3. HAVING
   No se usa.

4. SUM(CANTIDAD)
   entrenador 1 -> 48
   entrenador 2 -> 32
   entrenador 4 -> 70


EJEMPLO 5: Ataque maximo por tipo principal, solo en pokemon de un solo tipo
----------------------------------------------------------------------------
-- WHERE filtra filas: aqui quitamos antes los que tienen tipo secundario
SELECT COD_TIPO_1, MAX(ATAQUE_BASE) AS ATAQUE_MAXIMO
FROM POKEMON
WHERE COD_TIPO_2 IS NULL
GROUP BY COD_TIPO_1
ORDER BY ATAQUE_MAXIMO DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_TIPO_1  COD_TIPO_2  ATAQUE_BASE
-----------  ----------  ----------  -----------
Charmander   1           NULL        52
Charmeleon   1           NULL        64
Charizard    1           9           84
Squirtle     2           NULL        48
Blastoise    2           NULL        83
Bulbasaur    4           7           49

1. WHERE COD_TIPO_2 IS NULL
   Se quedan solo estas filas:
   (Charmander, 1, 52), (Charmeleon, 1, 64),
   (Squirtle, 2, 48), (Blastoise, 2, 83)

2. GROUP BY COD_TIPO_1
   tipo 1 -> [52, 64]
   tipo 2 -> [48, 83]

3. HAVING
   No se usa.

4. MAX(ATAQUE_BASE)
   tipo 1 -> 64
   tipo 2 -> 83


7.2. GROUP BY con varias columnas
---------------------------------

Puedes agrupar por varias columnas a la vez.
Cada combinacion distinta forma un grupo diferente.

EJEMPLO 6: Cuantos pokemon hay de cada combinacion tipo1-tipo2
---------------------------------------------------------------
SELECT COD_TIPO_1, COD_TIPO_2, COUNT(*) AS CANTIDAD
FROM POKEMON
GROUP BY COD_TIPO_1, COD_TIPO_2
ORDER BY COD_TIPO_1, COD_TIPO_2;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_TIPO_1  COD_TIPO_2
-----------  ----------  ----------
Charizard    1           9
Gyarados     2           9
Bulbasaur    4           7
Ivysaur      4           7
Venusaur     4           7
Gastly       13          7

1. WHERE
   No se usa.

2. GROUP BY COD_TIPO_1, COD_TIPO_2
   (1, 9)   -> [Charizard]
   (2, 9)   -> [Gyarados]
   (4, 7)   -> [Bulbasaur, Ivysaur, Venusaur]
   (13, 7)  -> [Gastly]

3. HAVING
   No se usa.

4. COUNT(*)
   (1, 9)   -> 1
   (2, 9)   -> 1
   (4, 7)   -> 3
   (13, 7)  -> 1


EJEMPLO 7: Velocidad promedio por combinacion tipo1-tipo2, solo duales
-----------------------------------------------------------------------
SELECT COD_TIPO_1, COD_TIPO_2, ROUND(AVG(VELOCIDAD_BASE), 2) AS VEL_PROMEDIO
FROM POKEMON
WHERE COD_TIPO_2 IS NOT NULL
GROUP BY COD_TIPO_1, COD_TIPO_2
ORDER BY VEL_PROMEDIO DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_TIPO_1  COD_TIPO_2  VELOCIDAD_BASE
-----------  ----------  ----------  --------------
Bulbasaur    4           7           45
Ivysaur      4           7           60
Venusaur     4           7           80
Gastly       13          7           80
Haunter      13          7           95
Gengar       13          7           110

1. WHERE COD_TIPO_2 IS NOT NULL
   Pasan solo los pokemon duales.

2. GROUP BY COD_TIPO_1, COD_TIPO_2
   (4, 7)   -> [45, 60, 80]
   (13, 7)  -> [80, 95, 110]

3. HAVING
   No se usa.

4. AVG(VELOCIDAD_BASE)
   (4, 7)   -> 61.67
   (13, 7)  -> 95.00


EJEMPLO 8: Pokemon por entrenador y estado, solo a partir de nivel 30
----------------------------------------------------------------------
SELECT COD_ENTRENADOR, ESTADO, COUNT(*) AS CANTIDAD
FROM ENTRENADOR_POKEMON
WHERE NIVEL >= 30
GROUP BY COD_ENTRENADOR, ESTADO
ORDER BY COD_ENTRENADOR, ESTADO;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
COD_ENTRENADOR  NIVEL  ESTADO
--------------  -----  --------
1               45     ACTIVO
1               50     ACTIVO
1               35     EN_PC
1               28     EN_PC
5               25     EN_PC
5               48     ACTIVO
5               62     ACTIVO
5               58     ACTIVO

1. WHERE NIVEL >= 30
   Se eliminan las filas con nivel 28 y 25.

2. GROUP BY COD_ENTRENADOR, ESTADO
   (1, ACTIVO) -> [45, 50]
   (1, EN_PC)  -> [35]
   (5, ACTIVO) -> [48, 62, 58]

3. HAVING
   No se usa.

4. COUNT(*)
   (1, ACTIVO) -> 2
   (1, EN_PC)  -> 1
   (5, ACTIVO) -> 3


7.3. HAVING: filtrar grupos
---------------------------

HAVING filtra grupos ya construidos.
Por eso suele usarse con COUNT, SUM, AVG, MAX o MIN.

REGLA CLAVE:
------------
- WHERE actua sobre restricciones de fila.
- HAVING actua sobre restricciones de grupo.

EJEMPLO 9: Tipos que tienen mas de 3 pokemon
--------------------------------------------
SELECT COD_TIPO_1, COUNT(*) AS CANTIDAD
FROM POKEMON
GROUP BY COD_TIPO_1
HAVING CANTIDAD > 3
ORDER BY CANTIDAD DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_TIPO_1
-----------  ----------
Charmander   1
Charmeleon   1
Cyndaquil    1
Torchic      1
Squirtle     2
Psyduck      2
Pikachu      3
Raichu       3

1. WHERE
   No se usa.

2. GROUP BY COD_TIPO_1
   tipo 1 -> [Charmander, Charmeleon, Cyndaquil, Torchic]
   tipo 2 -> [Squirtle, Psyduck]
   tipo 3 -> [Pikachu, Raichu]

3. HAVING COUNT(*) > 3
   Solo sobrevive el grupo del tipo 1.

4. RESULTADO
   tipo 1 -> 4


EJEMPLO 10: Entrenadores cuyo nivel promedio es al menos 40
-----------------------------------------------------------
SELECT COD_ENTRENADOR, ROUND(AVG(NIVEL), 2) AS NIVEL_PROMEDIO
FROM ENTRENADOR_POKEMON
GROUP BY COD_ENTRENADOR
HAVING NIVEL_PROMEDIO >= 40
ORDER BY NIVEL_PROMEDIO DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
COD_ENTRENADOR  NIVEL
--------------  -----
1               45
1               50
1               35
1               28
1               42
5               25
5               48
5               62
5               58
5               60
13              18

1. WHERE
   No se usa.

2. GROUP BY COD_ENTRENADOR
   entrenador 1  -> [45, 50, 35, 28, 42]
   entrenador 5  -> [25, 48, 62, 58, 60]
   entrenador 13 -> [18]

3. HAVING NIVEL_PROMEDIO >= 40
   entrenador 1  -> promedio 40.00 -> se queda
   entrenador 5  -> promedio 50.60 -> se queda
   entrenador 13 -> promedio 18.00 -> se elimina


EJEMPLO 11: Tipos con ataque promedio > 65, limitando a COD_POKEMON < 144
--------------------------------------------------------------------------
-- WHERE excluye filas concretas antes del resumen
-- HAVING decide que grupos resumen pasan el filtro final
SELECT COD_TIPO_1,
       COUNT(*) AS CANTIDAD,
       ROUND(AVG(ATAQUE_BASE), 2) AS ATAQUE_PROMEDIO
FROM POKEMON
WHERE COD_POKEMON < 144
GROUP BY COD_TIPO_1
HAVING ATAQUE_PROMEDIO > 65
ORDER BY ATAQUE_PROMEDIO DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_POKEMON  COD_TIPO_1  ATAQUE_BASE
-----------  -----------  ----------  -----------
Charmander   1            1           52
Charmeleon   5            1           64
Charizard    6            1           84
Squirtle     4            2           48
Blastoise    9            2           83
Gyarados     130          2           125
Mewtwo       150          10          110

1. WHERE COD_POKEMON < 144
   Mewtwo se elimina antes de agrupar.

2. GROUP BY COD_TIPO_1
   tipo 1 -> [52, 64, 84]
   tipo 2 -> [48, 83, 125]

3. HAVING AVG(ATAQUE_BASE) > 65
   tipo 1 -> promedio 66.67 -> se queda
   tipo 2 -> promedio 85.33 -> se queda

4. RESULTADO
   sobreviven los tipos 1 y 2


EJEMPLO 12: Entrenadores con mas de 2 pokemon activos
-----------------------------------------------------
SELECT COD_ENTRENADOR, COUNT(*) AS ACTIVOS
FROM ENTRENADOR_POKEMON
WHERE ESTADO = 'ACTIVO'
GROUP BY COD_ENTRENADOR
HAVING ACTIVOS > 2
ORDER BY ACTIVOS DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
COD_ENTRENADOR  COD_POKEMON  ESTADO
--------------  -----------  --------
1               25           ACTIVO
1               6            ACTIVO
1               12           EN_PC
1               130          ACTIVO
5               147          EN_PC
5               148          ACTIVO
5               149          ACTIVO
5               130          ACTIVO
5               6            ACTIVO

1. WHERE ESTADO = 'ACTIVO'
   Se eliminan Butterfree y Dratini Jr porque no estan activos.

2. GROUP BY COD_ENTRENADOR
   entrenador 1 -> [25, 6, 130]
   entrenador 5 -> [148, 149, 130, 6]

3. HAVING COUNT(*) > 2
   entrenador 1 -> 3 -> se queda
   entrenador 5 -> 4 -> se queda


EJEMPLO 13: Entrenadores con mas de 5 objetos equipados en total
----------------------------------------------------------------
SELECT COD_ENTRENADOR, SUM(CANTIDAD) AS TOTAL_EQUIPADO
FROM ENTRENADOR_OBJETO
WHERE EQUIPADO = 'S'
GROUP BY COD_ENTRENADOR
HAVING TOTAL_EQUIPADO > 5
ORDER BY TOTAL_EQUIPADO DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
COD_ENTRENADOR  CANTIDAD  EQUIPADO
--------------  --------  --------
1               25        S
2               12        S
4               20        S
5               99        S
10              20        S

1. WHERE EQUIPADO = 'S'
   Solo pasan las filas que representan objetos equipados.

2. GROUP BY COD_ENTRENADOR
   entrenador 1  -> [25]
   entrenador 2  -> [12]
   entrenador 4  -> [20]
   entrenador 5  -> [99]
   entrenador 10 -> [20]

3. HAVING SUM(CANTIDAD) > 5
   Todos esos grupos se quedan porque todos superan 5.


EJEMPLO 14: Tipos cuyos pokemon de un solo tipo tienen defensa minima >= 40
----------------------------------------------------------------------------
SELECT COD_TIPO_1, MIN(DEFENSA_BASE) AS DEFENSA_MINIMA
FROM POKEMON
WHERE COD_TIPO_2 IS NULL
GROUP BY COD_TIPO_1
HAVING MIN(DEFENSA_BASE) >= 40
ORDER BY DEFENSA_MINIMA DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_TIPO_1  COD_TIPO_2  DEFENSA_BASE
-----------  ----------  ----------  ------------
Charmander   1           NULL        43
Torchic      1           NULL        40
Squirtle     2           NULL        65
Psyduck      2           NULL        48
Pichu        3           NULL        15
Raichu       3           NULL        55

1. WHERE COD_TIPO_2 IS NULL
   Pasan solo los pokemon de un solo tipo.

2. GROUP BY COD_TIPO_1
   tipo 1 -> [43, 40]
   tipo 2 -> [65, 48]
   tipo 3 -> [15, 55]

3. HAVING MIN(DEFENSA_BASE) >= 40
   tipo 1 -> minimo 40 -> se queda
   tipo 2 -> minimo 48 -> se queda
   tipo 3 -> minimo 15 -> se elimina


EJEMPLO 15: Tipos secundarios que aparecen al menos 2 veces
-----------------------------------------------------------
SELECT COD_TIPO_2, COUNT(*) AS CANTIDAD
FROM POKEMON
WHERE COD_TIPO_2 IS NOT NULL
GROUP BY COD_TIPO_2
HAVING CANTIDAD >= 2
ORDER BY CANTIDAD DESC, COD_TIPO_2;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_TIPO_2
-----------  ----------
Charizard    9
Gyarados     9
Bulbasaur    7
Ivysaur      7
Venusaur     7
Gastly       7

1. WHERE COD_TIPO_2 IS NOT NULL
   Se descartan todos los pokemon de un solo tipo.

2. GROUP BY COD_TIPO_2
   tipo_sec 9 -> [Charizard, Gyarados]
   tipo_sec 7 -> [Bulbasaur, Ivysaur, Venusaur, Gastly]

3. HAVING COUNT(*) >= 2
   ambos grupos sobreviven porque tienen 2 o mas filas


EJEMPLO 16: Zonas con al menos 2 pokemon con COD_POKEMON < 144 y velocidad media > 60
---------------------------------------------------------------------------------------
SELECT COD_ZONA,
       COUNT(*) AS CANTIDAD,
       ROUND(AVG(VELOCIDAD_BASE), 2) AS VEL_PROMEDIO
FROM POKEMON
WHERE COD_ZONA IS NOT NULL
  AND COD_POKEMON < 144
GROUP BY COD_ZONA
HAVING COUNT(*) >= 2
   AND AVG(VELOCIDAD_BASE) > 60
ORDER BY VEL_PROMEDIO DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_ZONA  COD_POKEMON  VELOCIDAD_BASE
-----------  --------  -----------  --------------
Wartortle    4         8            58
Blastoise    4         9            78
Psyduck      4         54           55
Golduck      4         55           85
Mewtwo       8         150          130

1. WHERE COD_ZONA IS NOT NULL AND COD_POKEMON < 144
   Mewtwo se elimina por tener COD_POKEMON = 150.

2. GROUP BY COD_ZONA
   zona 4 -> [58, 78, 55, 85]

3. HAVING COUNT(*) >= 2 AND AVG(VELOCIDAD_BASE) > 60
   zona 4 -> cantidad 4 y promedio 69.00 -> se queda


EJEMPLO 17: Entrenador y estado con al menos 2 pokemon y nivel medio > 25
--------------------------------------------------------------------------
SELECT COD_ENTRENADOR,
       ESTADO,
       COUNT(*) AS CANTIDAD,
       ROUND(AVG(NIVEL), 2) AS NIVEL_PROMEDIO
FROM ENTRENADOR_POKEMON
WHERE ESTADO IN ('ACTIVO', 'EN_PC')
GROUP BY COD_ENTRENADOR, ESTADO
HAVING COUNT(*) >= 2
   AND AVG(NIVEL) > 25
ORDER BY COD_ENTRENADOR, NIVEL_PROMEDIO DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
COD_ENTRENADOR  ESTADO   NIVEL
--------------  -------  -----
1               ACTIVO   45
1               ACTIVO   50
1               ACTIVO   42
1               EN_PC    35
1               EN_PC    28
5               ACTIVO   48
5               ACTIVO   62
5               ACTIVO   58
5               EN_PC    25

1. WHERE ESTADO IN ('ACTIVO', 'EN_PC')
   En este caso pasan todas las filas mostradas.

2. GROUP BY COD_ENTRENADOR, ESTADO
   (1, ACTIVO) -> [45, 50, 42]
   (1, EN_PC)  -> [35, 28]
   (5, ACTIVO) -> [48, 62, 58]
   (5, EN_PC)  -> [25]

3. HAVING COUNT(*) >= 2 AND AVG(NIVEL) > 25
   (1, ACTIVO) -> 3 y 45.67 -> se queda
   (1, EN_PC)  -> 2 y 31.50 -> se queda
   (5, ACTIVO) -> 3 y 56.00 -> se queda
   (5, EN_PC)  -> 1 y 25.00 -> se elimina


EJEMPLO 18: Tipos principales entre 1 y 10 con PS medio > 60 y velocidad maxima >= 80
---------------------------------------------------------------------------------------
SELECT COD_TIPO_1,
       ROUND(AVG(PS_BASE), 2) AS PS_PROMEDIO,
       MAX(VELOCIDAD_BASE) AS VELOCIDAD_MAXIMA
FROM POKEMON
WHERE COD_TIPO_1 BETWEEN 1 AND 10
GROUP BY COD_TIPO_1
HAVING AVG(PS_BASE) > 60
   AND MAX(VELOCIDAD_BASE) >= 80
ORDER BY PS_PROMEDIO DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_TIPO_1  PS_BASE  VELOCIDAD_BASE
-----------  ----------  -------  --------------
Charmander   1           39       65
Charmeleon   1           58       80
Charizard    1           78       100
Cyndaquil    1           39       65
Ho-Oh        1           106      90
Squirtle     2           44       43
Blastoise    2           79       78
Gyarados     2           95       81

1. WHERE COD_TIPO_1 BETWEEN 1 AND 10
   Pasa cualquier fila cuyo tipo principal este en ese rango.

2. GROUP BY COD_TIPO_1
   tipo 1 -> PS [39, 58, 78, 39, 106], VEL max 100
   tipo 2 -> PS [44, 79, 95], VEL max 81

3. HAVING AVG(PS_BASE) > 60 AND MAX(VELOCIDAD_BASE) >= 80
   tipo 1 -> promedio 64.00 y max 100 -> se queda
   tipo 2 -> promedio 72.67 y max 81 -> se queda


EJEMPLO 19: Estados de equipamiento cuyo inventario total es al menos 20
------------------------------------------------------------------------
SELECT EQUIPADO, SUM(CANTIDAD) AS TOTAL_UNIDADES
FROM ENTRENADOR_OBJETO
GROUP BY EQUIPADO
HAVING SUM(CANTIDAD) >= 20
ORDER BY TOTAL_UNIDADES DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
COD_ENTRENADOR  EQUIPADO  CANTIDAD
--------------  --------  --------
1               N         15
1               N         8
1               S         25
2               N         20
2               S         12
4               N         50

1. WHERE
   No se usa.

2. GROUP BY EQUIPADO
   N -> [15, 8, 20, 50]
   S -> [25, 12]

3. HAVING SUM(CANTIDAD) >= 20
   N -> 93 -> se queda
   S -> 37 -> se queda


EJEMPLO 20: Tipos con al menos 2 pokemon rapidos de un solo tipo y ataque medio > 65
--------------------------------------------------------------------------------------
SELECT COD_TIPO_1,
       COUNT(*) AS CANTIDAD,
       ROUND(AVG(ATAQUE_BASE), 2) AS ATAQUE_PROMEDIO
FROM POKEMON
WHERE COD_TIPO_2 IS NULL
  AND VELOCIDAD_BASE >= 60
GROUP BY COD_TIPO_1
HAVING COUNT(*) >= 2
   AND AVG(ATAQUE_BASE) > 65
ORDER BY ATAQUE_PROMEDIO DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_TIPO_1  COD_TIPO_2  VELOCIDAD_BASE  ATAQUE_BASE
-----------  ----------  ----------  --------------  -----------
Blastoise    2           NULL        78              83
Golduck      2           NULL        85              82
Magikarp     2           NULL        80              10
Kyogre       2           NULL        90              100
Pikachu      3           NULL        90              55
Raichu       3           NULL        110             90
Voltorb      3           NULL        100             30
Electrode    3           NULL        150             50
Pichu        3           NULL        60              40

1. WHERE COD_TIPO_2 IS NULL AND VELOCIDAD_BASE >= 60
   Pasan solo los pokemon de un solo tipo y suficientemente rapidos.

2. GROUP BY COD_TIPO_1
   tipo 2 -> [83, 82, 10, 100]
   tipo 3 -> [55, 90, 30, 50, 40]

3. HAVING COUNT(*) >= 2 AND AVG(ATAQUE_BASE) > 65
   tipo 2 -> cantidad 4 y promedio 68.75 -> se queda
   tipo 3 -> cantidad 5 y promedio 53.00 -> se elimina


7.3.1. COUNT(*) vs COUNT(columna)
---------------------------------

COUNT(*) cuenta filas.
COUNT(columna) cuenta solo las filas donde esa columna NO es NULL.

EJEMPLO 21: Contar pokemon por entrenador con COUNT(COD_POKEMON)
----------------------------------------------------------------
-- Aqui COD_POKEMON nunca es NULL en ENTRENADOR_POKEMON,
-- asi que COUNT(COD_POKEMON) y COUNT(*) dan el mismo total.
SELECT COD_ENTRENADOR, COUNT(COD_POKEMON) AS CANTIDAD_POKEMON
FROM ENTRENADOR_POKEMON
GROUP BY COD_ENTRENADOR
ORDER BY CANTIDAD_POKEMON DESC;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
COD_ENTRENADOR  COD_POKEMON
--------------  -----------
1               25
1               6
1               130
5               148
5               149

1. WHERE
   No se usa.

2. GROUP BY COD_ENTRENADOR
   entrenador 1 -> [25, 6, 130]
   entrenador 5 -> [148, 149]

3. COUNT(COD_POKEMON)
   entrenador 1 -> 3
   entrenador 5 -> 2

4. IDEA CLAVE
   Como COD_POKEMON nunca es NULL en esta tabla,
   COUNT(COD_POKEMON) = COUNT(*)


EJEMPLO 22: Cuantos pokemon con tipo secundario tiene cada tipo principal
-------------------------------------------------------------------------
-- Aqui COUNT(COD_TIPO_2) NO cuenta los NULL.
SELECT COD_TIPO_1, COUNT(COD_TIPO_2) AS CON_TIPO_SECUNDARIO
FROM POKEMON
GROUP BY COD_TIPO_1
ORDER BY CON_TIPO_SECUNDARIO DESC, COD_TIPO_1;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_TIPO_1  COD_TIPO_2
-----------  ----------  ----------
Charmander   1           NULL
Charmeleon   1           NULL
Charizard    1           9
Moltres      1           9
Ho-Oh        1           9
Squirtle     2           NULL
Gyarados     2           9

1. WHERE
   No se usa.

2. GROUP BY COD_TIPO_1
   tipo 1 -> [NULL, NULL, 9, 9, 9]
   tipo 2 -> [NULL, 9]

3. COUNT(COD_TIPO_2)
   tipo 1 -> 3
   tipo 2 -> 1

4. IDEA CLAVE
   Los NULL no se cuentan.
   Por eso en tipo 1 no da 5, sino 3.


EJEMPLO 23: Tipos principales que tienen al menos 2 pokemon duales
------------------------------------------------------------------
SELECT COD_TIPO_1, COD_TIPO_2, COUNT(COD_TIPO_2) AS DUALES
FROM POKEMON
GROUP BY COD_TIPO_1, COD_TIPO_2
HAVING COUNT(COD_TIPO_2) >= 2
ORDER BY DUALES DESC, COD_TIPO_1;

LECTURA VISUAL:
---------------
FILAS ORIGINALES
NOMBRE       COD_TIPO_1  COD_TIPO_2
-----------  ----------  ----------
Bulbasaur    4           7
Ivysaur      4           7
Venusaur     4           7
Pikachu      3           NULL
Raichu       3           NULL
Gastly       13          7
Haunter      13          7
Gengar       13          7

1. WHERE
   No se usa.

2. GROUP BY COD_TIPO_1
   tipo 4  -> [7, 7, 7]
   tipo 3  -> [NULL, NULL]
   tipo 13 -> [7, 7, 7]

3. COUNT(COD_TIPO_2)
   tipo 4  -> 3
   tipo 3  -> 0
   tipo 13 -> 3

4. HAVING COUNT(COD_TIPO_2) >= 2
   tipo 4  -> se queda
   tipo 3  -> se elimina
   tipo 13 -> se queda


7.4. WHERE vs HAVING: misma idea, preguntas distintas
-----------------------------------------------------

COMPARACION VISUAL:
-------------------
Supongamos estas filas de ENTRENADOR_POKEMON:

COD_ENTRENADOR  NIVEL  ESTADO
--------------  -----  ----------
1               80     ACTIVO
1               20     ACTIVO
2               55     ACTIVO
2               60     EN_PC
3               15     ACTIVO

CASO A: WHERE NIVEL >= 50
-------------------------
La condicion actua fila por fila.
Se eliminan antes de agrupar las filas con nivel 20 y 15.

Filas que siguen:
1  80  ACTIVO
2  55  ACTIVO
2  60  EN_PC

Si luego agrupas por entrenador:
entrenador 1 -> 1 fila
entrenador 2 -> 2 filas

Consulta:
SELECT COD_ENTRENADOR, COUNT(*) AS CANTIDAD
FROM ENTRENADOR_POKEMON
WHERE NIVEL >= 50
GROUP BY COD_ENTRENADOR;


CASO B: HAVING AVG(NIVEL) >= 50
-------------------------------
Aqui NO eliminas filas al principio.
Primero agrupas todas las filas del entrenador y luego calculas el promedio.

Grupos completos:
entrenador 1 -> [80, 20] -> promedio 50
entrenador 2 -> [55, 60] -> promedio 57.5
entrenador 3 -> [15]     -> promedio 15

Despues HAVING decide:
se quedan entrenador 1 y 2

Consulta:
SELECT COD_ENTRENADOR, ROUND(AVG(NIVEL), 2) AS NIVEL_PROMEDIO
FROM ENTRENADOR_POKEMON
GROUP BY COD_ENTRENADOR
HAVING AVG(NIVEL) >= 50;


RESUMEN MUY IMPORTANTE:
-----------------------
- WHERE pregunta: "Que filas pueden entrar al calculo?"
- HAVING pregunta: "Que grupos ya calculados cumplen la condicion?"


7.5. Sobre que restricciones actua cada uno
-------------------------------------------

RESTRICCIONES DE FILA -> WHERE
------------------------------
Se pueden evaluar mirando una sola fila:
- PS_BASE > 80
- ESTADO = 'ACTIVO'
- COD_TIPO_2 IS NULL
- NIVEL BETWEEN 30 AND 60

RESTRICCIONES DE GRUPO -> HAVING
--------------------------------
Necesitan mirar varias filas juntas:
- COUNT(*) > 3
- AVG(NIVEL) >= 40
- SUM(CANTIDAD) > 50
- MIN(DEFENSA_BASE) >= 40

POR ESO ESTO DA ERROR:
----------------------
-- COUNT(*) aun no existe en la fase WHERE
SELECT COD_TIPO_1, COUNT(*) AS CANTIDAD
FROM POKEMON
WHERE COUNT(*) > 3
GROUP BY COD_TIPO_1;

CORRECTO:
---------
SELECT COD_TIPO_1, COUNT(*) AS CANTIDAD
FROM POKEMON
GROUP BY COD_TIPO_1
HAVING COUNT(*) > 3;


7.6. Que pasa si quitamos GROUP BY
----------------------------------

SIN GROUP BY, TODA LA CONSULTA ES UN SOLO GRUPO.
Eso significa que una agregacion como COUNT(*) o AVG() devuelve una sola fila.

ESTO SI ES VALIDO:
------------------
SELECT COUNT(*) AS TOTAL_POKEMON
FROM POKEMON;

Resultado conceptual:
TOTAL_POKEMON
-------------
151

ESTO NO ES VALIDO:
------------------
SELECT COD_TIPO_1, COUNT(*) AS TOTAL
FROM POKEMON;

POR QUE FALLA:
--------------
COUNT(*) resume toda la tabla y produce una sola fila.
Pero COD_TIPO_1 no tiene un solo valor para toda la tabla.

Piensalo asi:

FILAS REALES
COD_POKEMON  NOMBRE       COD_TIPO_1
-----------  -----------  ----------
25           Pikachu      13
26           Raichu       13
4            Charmander   10
7            Squirtle     2

Si haces:
SELECT COD_TIPO_1, COUNT(*)
FROM POKEMON;

SQL puede calcular COUNT(*) = 4
pero no puede decidir que COD_TIPO_1 poner en esa unica fila:
- 13 ?
- 10 ?
- 2 ?
- todos a la vez ?

La consulta esta mal formulada porque pide:
- un detalle por fila o por categoria: COD_TIPO_1
- y a la vez un resumen global: COUNT(*)

Eso solo es coherente de dos maneras:

OPCION 1: QUIERES UN RESUMEN POR TIPO
-------------------------------------
SELECT COD_TIPO_1, COUNT(*) AS TOTAL
FROM POKEMON
GROUP BY COD_TIPO_1;

OPCION 2: QUIERES EL TOTAL GLOBAL, SIN DETALLE
----------------------------------------------
SELECT COUNT(*) AS TOTAL
FROM POKEMON;


OTRO ERROR TIPICO:
------------------
-- NOMBRE es una columna normal; MAX(PS_BASE) es una agregacion global
SELECT NOMBRE, MAX(PS_BASE)
FROM POKEMON;

Problema:
- MAX(PS_BASE) devuelve un unico valor
- NOMBRE tiene muchos valores posibles

SI QUIERES EL POKEMON O LOS POKEMON CON EL MAXIMO PS:
-----------------------------------------------------
SELECT NOMBRE, PS_BASE
FROM POKEMON
WHERE PS_BASE = (SELECT MAX(PS_BASE) FROM POKEMON);


REGLAS IMPORTANTES DE GROUP BY:
-------------------------------
- Toda columna en SELECT que no este dentro de COUNT, SUM, AVG, MAX o MIN debe aparecer en GROUP BY.
- Puedes usar funciones de agregacion sin GROUP BY, pero el resultado sera una sola fila para toda la consulta.
- WHERE se ejecuta antes de GROUP BY.
- HAVING se ejecuta despues de GROUP BY.
- HAVING suele ir con GROUP BY; si no hay GROUP BY, filtra el unico grupo global de la consulta.


===============================================================================
8. JOINS: UNIÓN DE TABLAS
===============================================================================

Los JOINS combinan filas de dos o más tablas basándose en una columna relacionada.

TIPOS DE JOIN:
-------------
1. INNER JOIN - Solo filas con coincidencias en ambas tablas
2. LEFT JOIN  - Todas las filas de la izquierda + coincidencias de la derecha
3. RIGHT JOIN - Todas las filas de la derecha + coincidencias de la izquierda
4. FULL JOIN  - Todas las filas de ambas tablas


8.1. INNER JOIN
---------------

INNER JOIN devuelve solo las filas que tienen coincidencias en AMBAS tablas.

SINTAXIS:
--------
SELECT columnas
FROM tabla1
INNER JOIN tabla2 ON tabla1.columna = tabla2.columna;

-- O también:
FROM tabla1, tabla2
WHERE tabla1.columna = tabla2.columna;  -- Sintaxis antigua

NOTA DIDACTICA:
---------------
En los JOINS, la "LECTURA VISUAL" sigue este orden:
1. Que filas hay en cada tabla.
2. Que condicion se usa en ON.
3. Que filas emparejan y cuales se pierden o quedan con NULL.
4. Si hay WHERE o GROUP BY, cuando actuan.


EJEMPLO 1: Pokémon con el nombre de su tipo (INNER JOIN, LEFT JOIN Y RIGHT JOIN)
-------------------------------------------
SELECT P.NOMBRE AS POKEMON, T.NOMBRE AS TIPO_PRINCIPAL
FROM POKEMON P INNER JOIN TIPOS T ON P.COD_TIPO_1 = T.COD_TIPO;

INNER JOIN: solo Pokémon con el nombre de su tipo principal.


LECTURA VISUAL:
---------------
TABLA IZQUIERDA: POKEMON
NOMBRE       COD_TIPO_1  
-----------  ----------
Charmander   1              
Squirtle     2             
Bulbasaur    4            

TABLA DERECHA: TIPOS
COD_TIPO  NOMBRE
--------  --------
1         Fuego
2         Agua
4         Planta

1. INNER JOIN ON P.COD_TIPO_1 = T.COD_TIPO
   Charmander -> 1 empareja con Fuego
   Squirtle   -> 2 empareja con Agua
   Bulbasaur  -> 4 empareja con Planta
   Eso significa: trae el nombre del tipo cuyo codigo coincida con el tipo principal del pokemon.

2. RESULTADO
   (Charmander, Fuego)
   (Squirtle, Agua)
   (Bulbasaur, Planta)

Resultado:
POKEMON      TIPO
---------    ---------
Charmander   Fuego
Squirtle     Agua
Bulbasaur    Planta
Pikachu      Eléctrico
...

EJEMPLO 1(bis): Pokémon con el nombre de su tipo principal y secundario (aunque no tenga)(INNER JOIN + LEFT JOIN)
-------------------------------------------

SELECT P.NOMBRE AS POKEMON, T1.NOMBRE AS TIPO_PRINCIPAL, T2.NOMBRE AS TIPO_SECUNDARIO
FROM POKEMON P INNER JOIN TIPOS T1 ON P.COD_TIPO_1 = T1.COD_TIPO LEFT JOIN TIPOS T2 ON P.COD_TIPO_2 = T2.COD_TIPO;

INNER JOIN + LEFT JOIN: todos los Pokémon, y el secundario aunque no exista.

TABLA IZQUIERDA: POKEMON

NOMBRE       COD_TIPO_1   COD_TIPO_2
-----------  -----------  -----------
Charmander   1            NULL
Squirtle     2            NULL
Bulbasaur    4            8

TABLA DERECHA 1: TIPOS como T1 para TIPO_PRINCIPAL

COD_TIPO   NOMBRE
---------  --------
1          Fuego
2          Agua
4          Planta
8          Veneno

TABLA DERECHA 2: TIPOS como T2 para TIPO_SECUNDARIO

COD_TIPO   NOMBRE
---------  --------
1          Fuego
2          Agua
4          Planta
8          Veneno

INNER JOIN T1 ON P.COD_TIPO_1 = T1.COD_TIPO
Charmander -> 1 empareja con Fuego
Squirtle -> 2 empareja con Agua
Bulbasaur -> 4 empareja con Planta

Eso significa: trae el nombre del tipo principal del pokemon.

RESULTADO PARCIAL

POKEMON      TIPO_PRINCIPAL   COD_TIPO_2
-----------  ---------------  -----------
Charmander   Fuego            NULL
Squirtle     Agua             NULL
Bulbasaur    Planta           8

LEFT JOIN T2 ON P.COD_TIPO_2 = T2.COD_TIPO

Charmander -> NULL no empareja con nada, pero como es LEFT JOIN se conserva la fila
Squirtle -> NULL no empareja con nada, pero como es LEFT JOIN se conserva la fila
Bulbasaur -> 8 empareja con Veneno

Eso significa: trae el nombre del tipo secundario si existe; si no existe, devuelve NULL.

RESULTADO FINAL

POKEMON      TIPO_PRINCIPAL   TIPO_SECUNDARIO
-----------  ---------------  ----------------
Charmander   Fuego            NULL
Squirtle     Agua             NULL
Bulbasaur    Planta           Veneno

EJEMPLO 1(tris): Pokémon con el nombre de su tipo principal y secundario, conservando todos los tipos secundarios de la tabla TIPOS (INNER JOIN + RIGHT JOIN)
------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT P.NOMBRE AS POKEMON, T1.NOMBRE AS TIPO_PRINCIPAL, T2.NOMBRE AS TIPO_SECUNDARIO
FROM POKEMON P
INNER JOIN TIPOS T1 ON P.COD_TIPO_1 = T1.COD_TIPO
RIGHT JOIN TIPOS T2 ON P.COD_TIPO_2 = T2.COD_TIPO;

INNER JOIN + RIGHT JOIN: todos los tipos de la derecha, y el Pokémon solo si coincide con ese tipo secundario.

TABLA IZQUIERDA: POKEMON

NOMBRE       COD_TIPO_1   COD_TIPO_2
-----------  -----------  -----------
Charmander   1            NULL
Squirtle     2            NULL
Bulbasaur    4            8
Gastly       3            8

TABLA DERECHA 1: TIPOS como T1 para TIPO_PRINCIPAL

COD_TIPO   NOMBRE
---------  --------
1          Fuego
2          Agua
3          Fantasma
4          Planta
8          Veneno
9          Volador

TABLA DERECHA 2: TIPOS como T2 para TIPO_SECUNDARIO

COD_TIPO   NOMBRE
---------  --------
1          Fuego
2          Agua
3          Fantasma
4          Planta
8          Veneno
9          Volador

1. INNER JOIN T1 ON P.COD_TIPO_1 = T1.COD_TIPO

   Charmander -> 1 empareja con Fuego
   Squirtle -> 2 empareja con Agua
   Bulbasaur -> 4 empareja con Planta
   Gastly -> 3 empareja con Fantasma

   Eso significa: trae el nombre del tipo principal de cada pokemon.

2. RESULTADO PARCIAL

POKEMON      TIPO_PRINCIPAL   COD_TIPO_2
-----------  ---------------  -----------
Charmander   Fuego            NULL
Squirtle     Agua             NULL
Bulbasaur    Planta           8
Gastly       Fantasma         8

3. RIGHT JOIN T2 ON P.COD_TIPO_2 = T2.COD_TIPO

   Bulbasaur -> 8 empareja con Veneno
   Gastly -> 8 empareja con Veneno
   Fuego -> no tiene pokemon con COD_TIPO_2 = 1, pero como es RIGHT JOIN se conserva la fila
   Agua -> no tiene pokemon con COD_TIPO_2 = 2, pero como es RIGHT JOIN se conserva la fila
   Fantasma -> no tiene pokemon con COD_TIPO_2 = 3, pero como es RIGHT JOIN se conserva la fila
   Planta -> no tiene pokemon con COD_TIPO_2 = 4, pero como es RIGHT JOIN se conserva la fila
   Volador -> no tiene pokemon con COD_TIPO_2 = 9, pero como es RIGHT JOIN se conserva la fila

   Eso significa: trae todos los tipos secundarios de la tabla TIPOS, aunque ningun pokemon los tenga como segundo tipo.

4. RESULTADO FINAL

POKEMON      TIPO_PRINCIPAL   TIPO_SECUNDARIO
-----------  ---------------  ----------------
Bulbasaur    Planta           Veneno
Gastly       Fantasma         Veneno
NULL         NULL             Fuego
NULL         NULL             Agua
NULL         NULL             Fantasma
NULL         NULL             Planta
NULL         NULL             Volador

EJEMPLO 2: Pokémon con su habilidad
-----------------------------------
SELECT P.NOMBRE AS POKEMON, 
       H.NOMBRE AS HABILIDAD,
       H.EFECTO
FROM POKEMON P
INNER JOIN HABILIDADES H ON P.COD_HABILIDAD = H.COD_HABILIDAD
ORDER BY P.NOMBRE;

LECTURA VISUAL:
---------------
TABLA IZQUIERDA: POKEMON
NOMBRE       COD_HABILIDAD
-----------  -------------
Charmander   1
Squirtle     2
Pikachu      3
Gyarados     5

TABLA DERECHA: HABILIDADES
COD_HABILIDAD  NOMBRE
-------------  -----------------------
1              Mar Llamas
2              Torrente
3              Electricidad Estática
5              Intimidación

1. INNER JOIN ON P.COD_HABILIDAD = H.COD_HABILIDAD
   Cada pokémon busca su habilidad por codigo.

   Eso significa: trae la habilidad cuyo codigo coincida con la habilidad asignada a cada pokemon.

2. RESULTADO
   Charmander -> Mar Llamas
   Squirtle   -> Torrente
   Pikachu    -> Electricidad Estática
   Gyarados   -> Intimidación


EJEMPLO 3: Pokémon con su ubicación (zona)
------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS ZONA,
       M.REGION
FROM POKEMON P
INNER JOIN MAPA M ON P.COD_ZONA = M.COD_ZONA
ORDER BY M.REGION, M.NOMBRE;

LECTURA VISUAL:
---------------
TABLA IZQUIERDA: POKEMON
NOMBRE       COD_ZONA
-----------  --------
Charmander   1
Charizard    7
Articuno     NULL
Mew          NULL

TABLA DERECHA: MAPA
COD_ZONA  NOMBRE
--------  --------------
1         Pueblo Paleta
7         Isla Canela

1. INNER JOIN ON P.COD_ZONA = M.COD_ZONA
   Charmander -> 1 empareja con Pueblo Paleta
   Charizard  -> 7 empareja con Isla Canela
   Articuno   -> NULL, no empareja
   Mew        -> NULL, no empareja

   Eso significa: trae la zona cuyo codigo coincida con la zona asignada a cada pokemon.

2. RESULTADO
   Solo aparecen Charmander y Charizard.
   Articuno y Mew desaparecen porque INNER JOIN exige coincidencia.

⚠️ Esto solo muestra pokémon que TIENEN zona asignada (excluye legendarios sin zona).


EJEMPLO 4: Entrenadores con su ubicación
----------------------------------------
SELECT E.NOMBRE AS ENTRENADOR,
       M.NOMBRE AS ZONA,
       M.REGION
FROM ENTRENADOR E
INNER JOIN MAPA M ON E.COD_ZONA = M.COD_ZONA
ORDER BY M.REGION;

LECTURA VISUAL:
---------------
TABLA IZQUIERDA: ENTRENADOR
NOMBRE              COD_ZONA
------------------  --------
Ash Ketchum         1
Misty Waterflower   4
Lance Blackthorn    NULL

TABLA DERECHA: MAPA
COD_ZONA  NOMBRE
--------  --------------
1         Pueblo Paleta
4         Ciudad Celeste

1. INNER JOIN ON E.COD_ZONA = M.COD_ZONA
   Ash   -> 1 empareja
   Misty -> 4 empareja
   Lance -> NULL, no empareja
   Eso significa: trae la zona cuyo codigo coincida con la zona asignada a cada entrenador.

2. RESULTADO
   Ash y Misty aparecen con zona.
   Lance desaparece.


EJEMPLO 5: JOIN de 3 tablas - Pokémon con tipo y habilidad
----------------------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       T.NOMBRE AS TIPO,
       H.NOMBRE AS HABILIDAD
FROM POKEMON P
INNER JOIN TIPOS T ON P.COD_TIPO_1 = T.COD_TIPO
INNER JOIN HABILIDADES H ON P.COD_HABILIDAD = H.COD_HABILIDAD
ORDER BY P.NOMBRE;

LECTURA VISUAL:
---------------
POKEMON
NOMBRE       COD_TIPO_1  COD_HABILIDAD
-----------  ----------  -------------
Charmander   1           1
Squirtle     2           2
Pikachu      3           3

TIPOS
COD_TIPO  NOMBRE
--------  ----------
1         Fuego
2         Agua
3         Eléctrico

HABILIDADES
COD_HABILIDAD  NOMBRE
-------------  -----------------------
1              Mar Llamas
2              Torrente
3              Electricidad Estática

1. P INNER JOIN T
   Charmander -> Fuego
   Squirtle   -> Agua
   Pikachu    -> Eléctrico

   Eso significa: primero trae el tipo cuyo codigo coincida con el tipo principal de cada pokemon.

2. RESULTADO ANTERIOR INNER JOIN H
   Charmander -> Fuego + Mar Llamas
   Squirtle   -> Agua + Torrente
   Pikachu    -> Eléctrico + Electricidad Estática


   Eso significa: despues trae la habilidad cuyo codigo coincida con la habilidad de ese mismo pokemon.

EJEMPLO 6: JOIN de 4 tablas - Equipo de cada entrenador con detalles
--------------------------------------------------------------------
SELECT E.NOMBRE AS ENTRENADOR,
       P.NOMBRE AS POKEMON,
       EP.NIVEL,
       EP.APODO,
       T.NOMBRE AS TIPO
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_POKEMON EP ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
INNER JOIN POKEMON P ON EP.COD_POKEMON = P.COD_POKEMON
INNER JOIN TIPOS T ON P.COD_TIPO_1 = T.COD_TIPO
WHERE E.NOMBRE = 'Ash Ketchum'
ORDER BY EP.NIVEL DESC;

LECTURA VISUAL:
---------------
ENTRENADOR
COD_ENTRENADOR  NOMBRE
--------------  ------------
1               Ash Ketchum
4               Gary Oak

ENTRENADOR_POKEMON
COD_ENTRENADOR  COD_POKEMON  NIVEL  APODO
--------------  -----------  -----  ---------
1               25           45     Pikachu
1               6            50     Rizardon
1               130          42     Gyara
4               26           48     Raichu

POKEMON
COD_POKEMON  NOMBRE       COD_TIPO_1
-----------  -----------  ----------
25           Pikachu      3
6            Charizard    1
130          Gyarados     2
26           Raichu       3

TIPOS
COD_TIPO  NOMBRE
--------  ----------
1         Fuego
2         Agua
3         Eléctrico

1. E INNER JOIN EP
   Ash se empareja con 25, 6 y 130.
   Gary se empareja con 26 y otros pokémon.

   Eso significa: primero trae las filas de la tabla intermedia que relacionan a cada entrenador con sus pokemon.

2. + INNER JOIN P
   25 -> Pikachu
   6  -> Charizard
   130 -> Gyarados

   Eso significa: despues trae el pokemon cuyo codigo coincida con cada fila de la tabla intermedia.

3. + INNER JOIN T
   Pikachu   -> Eléctrico
   Charizard -> Fuego
   Gyarados  -> Agua

   Eso significa: finalmente trae el tipo cuyo codigo coincida con el tipo principal de cada pokemon.

4. WHERE E.NOMBRE = 'Ash Ketchum'
   Se eliminan las filas de Gary y de cualquier otro entrenador.

Resultado:
ENTRENADOR    POKEMON     NIVEL  APODO     TIPO
------------  ----------  -----  --------  ---------
Ash Ketchum   Charizard   50     Rizardon  Fuego
Ash Ketchum   Pikachu     45     Pikachu   Eléctrico
Ash Ketchum   Gyarados    42     Gyara     Agua
...


EJEMPLO 7: Pokemon con movimientos de su mismo tipo principal
-------------------------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS MOVIMIENTO,
       M.POTENCIA
FROM POKEMON P
INNER JOIN MOVIMIENTOS M ON P.COD_TIPO_1 = M.COD_TIPO
WHERE P.NOMBRE = 'Pikachu'
ORDER BY M.POTENCIA DESC, M.NOMBRE;

LECTURA VISUAL:
---------------
TABLA IZQUIERDA: POKEMON
NOMBRE    COD_TIPO_1
--------  ----------
Pikachu   3

TABLA DERECHA: MOVIMIENTOS
NOMBRE         COD_TIPO  POTENCIA
-------------  --------  --------
Impactrueno    3         40
Rayo           3         90
Trueno         3         110
Chispa         3         65
Onda Trueno    3         0

1. INNER JOIN ON P.COD_TIPO_1 = M.COD_TIPO
   Pikachu -> 3 empareja con todos los movimientos de tipo 3.

   Eso significa: "trae los movimientos cuyo tipo coincida con el tipo principal del Pokemon".

2. RESULTADO
   Pikachu -> Impactrueno
   Pikachu -> Rayo
   Pikachu -> Trueno
   Pikachu -> Chispa
   Pikachu -> Onda Trueno



EJEMPLO 8: PokÃ©mon y movimientos que realmente aprende
------------------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS MOVIMIENTO,
       PM.NIVEL_APRENDIZAJE
FROM POKEMON P
INNER JOIN POKEMON_MOVIMIENTO PM ON P.COD_POKEMON = PM.COD_POKEMON
INNER JOIN MOVIMIENTOS M ON PM.COD_MOVIMIENTO = M.COD_MOVIMIENTO
WHERE P.NOMBRE = 'Charizard'
ORDER BY PM.NIVEL_APRENDIZAJE;

LECTURA VISUAL:
---------------
POKEMON
COD_POKEMON  NOMBRE
-----------  ---------
6            Charizard

POKEMON_MOVIMIENTO
COD_POKEMON  COD_MOVIMIENTO  NIVEL_APRENDIZAJE
-----------  --------------  -----------------
6            2               1
6            4               36
6            39              40
6            9               45

MOVIMIENTOS
COD_MOVIMIENTO  NOMBRE
--------------  -------------
2               Lanzallamas
4               Sofoco
39              Furia DragÃ³n
9               Cascada

1. P INNER JOIN PM
   Charizard -> genera 4 filas, una por movimiento aprendido.

   Eso significa: primero trae solo las filas de la tabla intermedia que pertenecen a Charizard.

2. RESULTADO ANTERIOR INNER JOIN M
   2  -> Lanzallamas
   4  -> Sofoco
   39 -> Furia DragÃ³n
   9  -> Cascada

   Eso significa: despues trae el movimiento cuyo codigo coincida con cada movimiento aprendido por Charizard.

3. IDEA CLAVE
   Aqui si se esta usando la tabla intermedia para representar una relaciÃ³n real N:N.


EJEMPLO 9: Entrenadores y objetos que tienen
--------------------------------------------
SELECT E.NOMBRE AS ENTRENADOR,
       O.NOMBRE AS OBJETO,
       EO.CANTIDAD
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_OBJETO EO ON E.COD_ENTRENADOR = EO.COD_ENTRENADOR
INNER JOIN OBJETOS O ON EO.COD_OBJETO = O.COD_OBJETO
WHERE E.NOMBRE = 'Ash Ketchum'
ORDER BY EO.CANTIDAD DESC, O.NOMBRE;

LECTURA VISUAL:
---------------
ENTRENADOR
COD_ENTRENADOR  NOMBRE
--------------  ------------
1               Ash Ketchum

ENTRENADOR_OBJETO
COD_ENTRENADOR  COD_OBJETO  CANTIDAD
--------------  ----------  --------
1               1           10
1               2           6
1               4           3

OBJETOS
COD_OBJETO  NOMBRE
----------  ------------
1           PokÃ© Ball
2           Super Ball
4           PociÃ³n

1. E INNER JOIN EO
   Ash -> se empareja con las filas de su inventario.

   Eso significa: primero trae las filas del inventario que pertenecen a Ash.

2. RESULTADO ANTERIOR INNER JOIN O
   1 -> PokÃ© Ball
   2 -> Super Ball
   4 -> PociÃ³n

   Eso significa: despues trae el objeto cuyo codigo coincida con cada fila del inventario.

3. IDEA CLAVE
   Un INNER JOIN puede encadenarse varias veces para recorrer relaciones intermedias.


EJEMPLO 10: PokÃ©mon con nombre de tipo principal y secundario
-------------------------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       T1.NOMBRE AS TIPO_PRINCIPAL,
       T2.NOMBRE AS TIPO_SECUNDARIO
FROM POKEMON P
INNER JOIN TIPOS T1 ON P.COD_TIPO_1 = T1.COD_TIPO
INNER JOIN TIPOS T2 ON P.COD_TIPO_2 = T2.COD_TIPO
ORDER BY P.NOMBRE;

LECTURA VISUAL:
---------------
POKEMON
NOMBRE      COD_TIPO_1  COD_TIPO_2
----------  ----------  ----------
Bulbasaur   4           7
Charizard   1           9
Gengar      13          7

TIPOS T1
COD_TIPO  NOMBRE
--------  --------
4         Planta
1         Fuego
13        Fantasma

TIPOS T2
COD_TIPO  NOMBRE
--------  --------
7         Veneno
9         Volador

1. P INNER JOIN T1
   Cada pokÃ©mon obtiene el nombre de su tipo principal.

   Eso significa: primero trae el tipo principal cuyo codigo coincida con COD_TIPO_1.

2. RESULTADO ANTERIOR INNER JOIN T2
   Solo quedan los pokÃ©mon que SI tienen COD_TIPO_2.
   Bulbasaur -> Planta / Veneno
   Charizard -> Fuego / Volador
   Gengar -> Fantasma / Veneno

   Eso significa: despues trae el tipo secundario cuyo codigo coincida con COD_TIPO_2.

3. IDEA CLAVE
   Puedes hacer JOIN con la misma tabla dos veces si usas alias distintos.


8.2. LEFT JOIN (LEFT OUTER JOIN)
--------------------------------

LEFT JOIN devuelve TODAS las filas de la tabla izquierda, y las coincidencias
de la derecha. Si no hay coincidencia, las columnas de la derecha son NULL.

SINTAXIS:
--------
SELECT columnas
FROM tabla1
LEFT JOIN tabla2 ON tabla1.columna = tabla2.columna;


EJEMPLO 7: TODOS los pokémon con su zona (incluye los sin zona)
---------------------------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS ZONA
FROM POKEMON P
LEFT JOIN MAPA M ON P.COD_ZONA = M.COD_ZONA
ORDER BY M.NOMBRE NULLS LAST;

LECTURA VISUAL:
---------------
TABLA IZQUIERDA: POKEMON
NOMBRE       COD_ZONA
-----------  --------
Charmander   1
Charizard    7
Mewtwo       8
Mew          NULL
Articuno     NULL

TABLA DERECHA: MAPA
COD_ZONA  NOMBRE
--------  --------------
1         Pueblo Paleta
7         Isla Canela
8         Cueva Celeste

1. LEFT JOIN ON P.COD_ZONA = M.COD_ZONA
   Charmander -> Pueblo Paleta
   Charizard  -> Isla Canela
   Mewtwo     -> Cueva Celeste
   Mew        -> no empareja, pero se conserva
   Articuno   -> no empareja, pero se conserva
   Eso significa: trae todos los pokemon y, si existe coincidencia, tambien su zona.

2. RESULTADO
   Charmander  Pueblo Paleta
   Charizard   Isla Canela
   Mewtwo      Cueva Celeste
   Mew         NULL
   Articuno    NULL

Resultado incluye:
Mew       NULL
Articuno  NULL
Zapdos    NULL
...


EJEMPLO 8: Todos los entrenadores con su ubicación
--------------------------------------------------
SELECT E.NOMBRE AS ENTRENADOR,
       M.NOMBRE AS ZONA
FROM ENTRENADOR E
LEFT JOIN MAPA M ON E.COD_ZONA = M.COD_ZONA
ORDER BY E.NOMBRE;

LECTURA VISUAL:
---------------
TABLA IZQUIERDA: ENTRENADOR
NOMBRE              COD_ZONA
------------------  --------
Ash Ketchum         1
Lance Blackthorn    NULL
Giovanni Rocket     NULL

TABLA DERECHA: MAPA
COD_ZONA  NOMBRE
--------  --------------
1         Pueblo Paleta

1. LEFT JOIN ON E.COD_ZONA = M.COD_ZONA
   Ash       -> Pueblo Paleta
   Lance     -> no empareja, pero se conserva
   Giovanni  -> no empareja, pero se conserva
   Eso significa: trae todos los entrenadores y, si existe coincidencia, tambien su zona.

2. RESULTADO
   Ash Ketchum       Pueblo Paleta
   Lance Blackthorn  NULL
   Giovanni Rocket   NULL

Resultado incluye:
Lance       NULL
Giovanni    NULL
...


EJEMPLO 9: Pokémon y sus movimientos (incluye pokémon sin movimientos)
----------------------------------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS MOVIMIENTO
FROM POKEMON P
LEFT JOIN POKEMON_MOVIMIENTO PM ON P.COD_POKEMON = PM.COD_POKEMON
LEFT JOIN MOVIMIENTOS M ON PM.COD_MOVIMIENTO = M.COD_MOVIMIENTO
ORDER BY P.NOMBRE;

LECTURA VISUAL:
---------------
POKEMON
COD_POKEMON  NOMBRE
-----------  ----------
25           Pikachu
100          Voltorb

POKEMON_MOVIMIENTO
COD_POKEMON  COD_MOVIMIENTO
-----------  --------------
25           11
25           14
25           12
25           13

MOVIMIENTOS
COD_MOVIMIENTO  NOMBRE
--------------  ------------
11              Impactrueno
12              Rayo
13              Trueno
14              Chispa

1. P LEFT JOIN PM
   Pikachu -> genera 4 filas, una por movimiento
   Voltorb -> no empareja, pero queda con PM = NULL

   Eso significa: trae todos los pokemon, tengan o no filas asociadas en la tabla intermedia.

2. RESULTADO ANTERIOR LEFT JOIN MOVIMIENTOS
   Pikachu -> Impactrueno
   Pikachu -> Chispa
   Pikachu -> Rayo
   Pikachu -> Trueno
   Voltorb -> NULL

   Eso significa: despues trae el nombre del movimiento si existe coincidencia; si no, queda NULL.

3. IDEA CLAVE
   Un LEFT JOIN puede duplicar filas cuando hay varias coincidencias.


EJEMPLO 10: Contar pokémon por zona (incluye zonas sin pokémon)
---------------------------------------------------------------
SELECT M.NOMBRE AS ZONA,
       COUNT(P.COD_POKEMON) AS CANTIDAD_POKEMON
FROM MAPA M
LEFT JOIN POKEMON P ON M.COD_ZONA = P.COD_ZONA
GROUP BY M.NOMBRE
ORDER BY CANTIDAD_POKEMON DESC;

LECTURA VISUAL:
---------------
MAPA
COD_ZONA  NOMBRE
--------  --------------
4         Ciudad Celeste
3         Monte Luna

POKEMON
NOMBRE       COD_ZONA
-----------  --------
Wartortle    4
Blastoise    4
Psyduck      4
Golduck      4

1. LEFT JOIN ON M.COD_ZONA = P.COD_ZONA
   Ciudad Celeste -> 4 filas emparejadas
   Monte Luna     -> 1 fila conservada con P.COD_POKEMON = NULL

   Eso significa: trae todas las zonas y, si existe coincidencia, los pokemon de cada zona.

2. GROUP BY M.NOMBRE
   Ciudad Celeste -> [8, 9, 54, 55]
   Monte Luna     -> [NULL]

3. COUNT(P.COD_POKEMON)
   Ciudad Celeste -> 4
   Monte Luna     -> 0

4. IDEA CLAVE
   COUNT(P.COD_POKEMON) no cuenta NULL.
   COUNT(*) aqui contaria 1 fila para Monte Luna.

⚠️ Usa COUNT(columna) en lugar de COUNT(*) para que no cuente NULL


8.3. RIGHT JOIN (RIGHT OUTER JOIN)
----------------------------------

RIGHT JOIN es lo opuesto a LEFT JOIN: devuelve TODAS las filas de la tabla
derecha, y las coincidencias de la izquierda.

SINTAXIS:
--------
SELECT columnas
FROM tabla1
RIGHT JOIN tabla2 ON tabla1.columna = tabla2.columna;


EJEMPLO 11: Mismo resultado que EJEMPLO 7 pero con RIGHT JOIN
-------------------------------------------------------------
SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS ZONA
FROM MAPA M
RIGHT JOIN POKEMON P ON M.COD_ZONA = P.COD_ZONA
ORDER BY M.NOMBRE NULLS LAST;

LECTURA VISUAL:
---------------
TABLA IZQUIERDA: MAPA
COD_ZONA  NOMBRE
--------  --------------
1         Pueblo Paleta
7         Isla Canela

TABLA DERECHA: POKEMON
NOMBRE       COD_ZONA
-----------  --------
Charmander   1
Charizard    7
Mew          NULL

1. RIGHT JOIN ON M.COD_ZONA = P.COD_ZONA
   Charmander -> Pueblo Paleta
   Charizard  -> Isla Canela
   Mew        -> no empareja, pero se conserva porque la tabla derecha es POKEMON

   Eso significa: trae todos los pokemon y, si existe coincidencia, tambien su zona, pero escrito con RIGHT JOIN.

2. RESULTADO
   Charmander  Pueblo Paleta
   Charizard   Isla Canela
   Mew         NULL

⚠️ En la práctica, LEFT JOIN es más común que RIGHT JOIN.


