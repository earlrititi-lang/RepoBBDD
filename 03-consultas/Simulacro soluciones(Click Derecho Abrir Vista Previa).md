<a id="indice"></a>
# Simulacro soluciones

Documento reorganizado con una estructura unica:

1. Ejercicios 1 a 10: simulacro original.
2. Ejercicios 11 a 15: ejercicios sin `GROUP BY`.
3. Ejercicios 16 a 20: casos donde cambiar joins, mover filtros o contar mal cambia mucho la salida final.
4. Ejercicios 21 a 25: ejercicios sin joins.

## Indice

### Simulacro original
- [Ejercicio 1: Zonas con pokemon de ataque alto](#ejercicio-1-zonas-con-pokemon-de-ataque-alto)
- [Ejercicio 2: Tipos y velocidad media de pokemon rapidos](#ejercicio-2-tipos-y-velocidad-media-de-pokemon-rapidos)
- [Ejercicio 3: Entrenadores con pokemon activos de nivel alto](#ejercicio-3-entrenadores-con-pokemon-activos-de-nivel-alto)
- [Ejercicio 4: Objetos presentes en muchos inventarios](#ejercicio-4-objetos-presentes-en-muchos-inventarios)
- [Ejercicio 5: Pokemon con varios movimientos aprendidos a nivel alto](#ejercicio-5-pokemon-con-varios-movimientos-aprendidos-a-nivel-alto)
- [Ejercicio 6: Entrenadores con pokemon distintos de nivel alto](#ejercicio-6-entrenadores-con-pokemon-distintos-de-nivel-alto)
- [Ejercicio 7: Tipos con movimientos precisos y potentes](#ejercicio-7-tipos-con-movimientos-precisos-y-potentes)
- [Ejercicio 8: Entrenadores con pokemon activos muy experimentados](#ejercicio-8-entrenadores-con-pokemon-activos-muy-experimentados)
- [Ejercicio 9: Objetos presentes en muchos entrenadores distintos](#ejercicio-9-objetos-presentes-en-muchos-entrenadores-distintos)
- [Ejercicio 10: Tipos con pokemon ofensivos y rapidos](#ejercicio-10-tipos-con-pokemon-ofensivos-y-rapidos)

### Sin `GROUP BY`
- [Ejercicio 11: Pokemon fuertes y su zona](#ejercicio-11-pokemon-fuertes-y-su-zona)
- [Ejercicio 12: Entrenadores y pokemon activos de nivel muy alto](#ejercicio-12-entrenadores-y-pokemon-activos-de-nivel-muy-alto)
- [Ejercicio 13: Objetos con cantidad alta en inventarios](#ejercicio-13-objetos-con-cantidad-alta-en-inventarios)
- [Ejercicio 14: Pokemon y movimientos aprendidos a nivel 40 o superior](#ejercicio-14-pokemon-y-movimientos-aprendidos-a-nivel-40-o-superior)
- [Ejercicio 15: Tipos y movimientos extremadamente potentes](#ejercicio-15-tipos-y-movimientos-extremadamente-potentes)

### Cambios fuertes por `JOIN`, `ON` o `COUNT`
- [Ejercicio 16: Todas las zonas y cuantos pokemon muy rapidos tienen](#ejercicio-16-todas-las-zonas-y-cuantos-pokemon-muy-rapidos-tienen)
- [Ejercicio 17: Todos los tipos y cuantos pokemon duales fuertes tienen](#ejercicio-17-todos-los-tipos-y-cuantos-pokemon-duales-fuertes-tienen)
- [Ejercicio 18: Todas las habilidades y cuantos pokemon resistentes con zona tienen](#ejercicio-18-todas-las-habilidades-y-cuantos-pokemon-resistentes-con-zona-tienen)
- [Ejercicio 19: Todos los objetos y en cuantos entrenadores aparecen con cantidad alta](#ejercicio-19-todos-los-objetos-y-en-cuantos-entrenadores-aparecen-con-cantidad-alta)
- [Ejercicio 20: Todos los entrenadores y cuantos pokemon muy experimentados tienen](#ejercicio-20-todos-los-entrenadores-y-cuantos-pokemon-muy-experimentados-tienen)

### Sin joins
- [Ejercicio 21: Pokemon muy ofensivos y rapidos](#ejercicio-21-pokemon-muy-ofensivos-y-rapidos)
- [Ejercicio 22: Movimientos precisos pero no perfectos](#ejercicio-22-movimientos-precisos-pero-no-perfectos)
- [Ejercicio 23: Objetos de precio medio](#ejercicio-23-objetos-de-precio-medio)
- [Ejercicio 24: Estados con al menos 3 registros de nivel alto](#ejercicio-24-estados-con-al-menos-3-registros-de-nivel-alto)
- [Ejercicio 25: Zonas con al menos 2 pokemon sin hacer joins](#ejercicio-25-zonas-con-al-menos-2-pokemon-sin-hacer-joins)

## Resumen rapido: cambiar a `COUNT(*)`
Esta tabla resume si cambiar el conteo principal del ejercicio por `COUNT(*)` mantiene la salida final de la consulta original.

| Ejercicio | Resultado al usar `COUNT(*)` | Motivo principal |
|---|---|---|
| 1 | Igual | La consulta original ya usa `COUNT(*)`; con `COUNT(P.COD_POKEMON)` tambien coincidiria porque hay `INNER JOIN`. |
| 2 | No aplica | No usa `COUNT`; el agregado importante es `AVG`. |
| 3 | Igual | Hay `INNER JOIN` y solo quedan filas reales de `ENTRENADOR_POKEMON`. |
| 4 | Salida final igual, pero concepto peor | El `LEFT JOIN` daria `1` a objetos sin coincidencias, pero `HAVING >= 3` los elimina. |
| 5 | Igual | Hay `INNER JOIN`; ademas `POKEMON_MOVIMIENTO` no permite repetir el mismo movimiento para un pokemon. |
| 6 | Salida final igual, pero concepto peor | Los grupos vacios contarian `1`, pero `HAVING >= 3` los elimina; no se repite pokemon por entrenador. |
| 7 | Salida final igual, pero concepto peor | Los tipos sin movimientos validos caen por `AVG(NULL)` y `HAVING`; cada movimiento tiene codigo unico. |
| 8 | No aplica | No usa `COUNT`; trabaja con `MIN`, `MAX` y `AVG`. |
| 9 | Salida final igual, pero concepto peor | Los objetos sin coincidencias caen por `AVG(NULL)` y `HAVING`; no se repite objeto por entrenador. |
| 10 | Igual | Los joins no multiplican pokemon: `POKEMON` e `HABILIDADES` se unen por claves. |
| 11 | No aplica | No hay `GROUP BY` ni `COUNT`. |
| 12 | No aplica | Es una consulta de detalle sin agregados. |
| 13 | No aplica | Es una consulta de detalle sin agregados. |
| 14 | No aplica | Es una consulta de detalle sin agregados. |
| 15 | No aplica | No cuenta filas; muestra detalle conservando tipos. |
| 16 | Cambia | Las zonas sin pokemon rapidos pasarian de `0` a `1`. |
| 17 | Cambia | Los tipos sin pokemon duales fuertes pasarian de `0` a `1`. |
| 18 | Cambia | Las habilidades sin pokemon validos pasarian de `0` a `1`. |
| 19 | Cambia | Los objetos sin entrenadores validos pasarian de `0` a `1`. |
| 20 | Cambia | Los entrenadores sin pokemon top pasarian de `0` a `1`. |
| 21 | No aplica | No usa agregados. |
| 22 | No aplica | No usa agregados. |
| 23 | No aplica | No usa agregados. |
| 24 | Igual | No hay join; `COUNT(*)` cuenta filas reales de `ENTRENADOR_POKEMON`. |
| 25 | Igual | No hay join y `COD_ZONA IS NOT NULL` elimina los `NULL`. |

---

<a id="ejercicio-1"></a>
# Ejercicio 1: Zonas con pokemon de ataque alto

## Enunciado completo
Muestra el nombre de la zona y cuantos pokemon hay en cada una, pero solo teniendo en cuenta los pokemon cuyo ataque base sea mayor que 60. Excluye los pokemon sin zona. Haz que solo aparezcan las zonas con al menos 2 pokemon. Ordena por total descendente y nombre de zona ascendente.

## Consulta original
```sql
SELECT M.NOMBRE, COUNT(*) AS TOTAL_POKEMON
FROM POKEMON P
INNER JOIN MAPA M
    ON P.COD_ZONA = M.COD_ZONA
WHERE P.ATAQUE_BASE > 60
GROUP BY M.NOMBRE
HAVING COUNT(*) >= 2
ORDER BY TOTAL_POKEMON DESC, M.NOMBRE ASC;
```

## Idea del ejercicio
Queremos contar pokemon por zona, pero solo los que tienen `ATAQUE_BASE > 60`. Ademas, solo interesan zonas con al menos 2 pokemon de ese tipo.

## Variante `LEFT JOIN`
```sql
SELECT M.NOMBRE, COUNT(*) AS TOTAL_POKEMON
FROM POKEMON P
LEFT JOIN MAPA M
    ON P.COD_ZONA = M.COD_ZONA
WHERE P.ATAQUE_BASE > 60
GROUP BY M.NOMBRE
HAVING COUNT(*) >= 2
ORDER BY TOTAL_POKEMON DESC, M.NOMBRE ASC;
```

### Que pasa
Aqui si cambia la salida.

Como `LEFT JOIN` conserva todos los pokemon de `POKEMON`, los pokemon sin zona tambien entran en la consulta. Esos quedan con `M.NOMBRE = NULL`, asi que se forma un grupo adicional con `NULL`.

## Variante `RIGHT JOIN`
```sql
SELECT M.NOMBRE, COUNT(*) AS TOTAL_POKEMON
FROM POKEMON P
RIGHT JOIN MAPA M
    ON P.COD_ZONA = M.COD_ZONA
WHERE P.ATAQUE_BASE > 60
GROUP BY M.NOMBRE
HAVING COUNT(*) >= 2
ORDER BY TOTAL_POKEMON DESC, M.NOMBRE ASC;
```

### Que pasa
Con estos inserts, la salida final no cambia respecto a la original.

Aunque `RIGHT JOIN` conserva todas las zonas, el `WHERE P.ATAQUE_BASE > 60` elimina las filas en las que `P` es `NULL`. Por tanto, las zonas sin pokemon validos desaparecen antes de agrupar.

## Â¿Que pasa si muevo el filtro del `WHERE` al `ON`?
```sql
SELECT M.NOMBRE, COUNT(*) AS TOTAL_POKEMON
FROM POKEMON P
INNER JOIN MAPA M
    ON P.COD_ZONA = M.COD_ZONA
   AND P.ATAQUE_BASE > 60
GROUP BY M.NOMBRE
HAVING COUNT(*) >= 2
ORDER BY TOTAL_POKEMON DESC, M.NOMBRE ASC;
```

### Que pasa
Con `INNER JOIN`, la salida final no cambia.

En un `INNER JOIN`, una condicion sobre la tabla enlazada suele dar el mismo resultado tanto en `ON` como en `WHERE`.

## `COUNT(*)` y `COUNT(columna)`
En esta consulta concreta, `COUNT(*)` y `COUNT(P.COD_POKEMON)` dan el mismo resultado en la version original porque el `INNER JOIN` solo deja filas con coincidencia real entre `POKEMON` y `MAPA`.

Tambien coincidiria con `COUNT(DISTINCT P.COD_POKEMON)` porque `COD_POKEMON` es clave primaria y cada pokemon pertenece como mucho a una zona.

La diferencia importante aparece cuando usas un `OUTER JOIN` para conservar filas de una tabla aunque no haya coincidencia en la otra:

- `COUNT(*)` cuenta filas.
- `COUNT(P.COD_POKEMON)` cuenta solo valores no `NULL` de esa columna.

Por eso, si quieres contar elementos reales de la tabla que puede quedar en `NULL`, suele ser mas seguro usar `COUNT(columna)`.

---

<a id="ejercicio-2"></a>
# Ejercicio 2: Tipos y velocidad media de pokemon rapidos

## Enunciado completo
Muestra el nombre de todos los tipos y la velocidad media de los pokemon cuyo tipo primario sea ese tipo y cuya velocidad base sea mayor que 50. Haz que solo aparezcan los tipos cuya velocidad media sea superior a 75. Ordena por velocidad media descendente.

## Consulta original
```sql
SELECT T.NOMBRE, AVG(P.VELOCIDAD_BASE) AS VELOCIDAD_MEDIA
FROM TIPOS T
LEFT JOIN POKEMON P
    ON T.COD_TIPO = P.COD_TIPO_1
   AND P.VELOCIDAD_BASE > 50
GROUP BY T.NOMBRE
HAVING AVG(P.VELOCIDAD_BASE) > 75
ORDER BY VELOCIDAD_MEDIA DESC;
```

## Idea del ejercicio
El enunciado parte de todos los tipos. Por eso es natural arrancar desde `TIPOS` y conservar primero todos los tipos con `LEFT JOIN`.

## Variante `INNER JOIN`
```sql
SELECT T.NOMBRE, AVG(P.VELOCIDAD_BASE) AS VELOCIDAD_MEDIA
FROM TIPOS T
INNER JOIN POKEMON P
    ON T.COD_TIPO = P.COD_TIPO_1
WHERE P.VELOCIDAD_BASE > 50
GROUP BY T.NOMBRE
HAVING AVG(P.VELOCIDAD_BASE) > 75
ORDER BY VELOCIDAD_MEDIA DESC;
```

### Que pasa
Con estos inserts, la salida final no cambia.

Los tipos sin pokemon rapidos en la original quedaban con `AVG(NULL)` y luego eran eliminados por `HAVING`. En `INNER JOIN` desaparecen antes, pero la salida final coincide.

## Variante `RIGHT JOIN`
```sql
SELECT T.NOMBRE, AVG(P.VELOCIDAD_BASE) AS VELOCIDAD_MEDIA
FROM POKEMON P
RIGHT JOIN TIPOS T
    ON T.COD_TIPO = P.COD_TIPO_1
   AND P.VELOCIDAD_BASE > 50
GROUP BY T.NOMBRE
HAVING AVG(P.VELOCIDAD_BASE) > 75
ORDER BY VELOCIDAD_MEDIA DESC;
```

### Que pasa
La salida final tampoco cambia. Es la misma logica que la consulta original, pero escrita desde el otro lado.

## Â¿Que pasa si muevo el filtro del `ON` al `WHERE`?
```sql
SELECT T.NOMBRE, AVG(P.VELOCIDAD_BASE) AS VELOCIDAD_MEDIA
FROM TIPOS T
LEFT JOIN POKEMON P
    ON T.COD_TIPO = P.COD_TIPO_1
WHERE P.VELOCIDAD_BASE > 50
GROUP BY T.NOMBRE
HAVING AVG(P.VELOCIDAD_BASE) > 75
ORDER BY VELOCIDAD_MEDIA DESC;
```

### Que pasa
La salida final no cambia con estos inserts, pero la logica si cambia.

Con filtro en `ON`, primero conservas todos los tipos. Con filtro en `WHERE`, eliminas enseguida los tipos sin pokemon rapidos.

## Nota sobre `AVG` y `NULL`
`AVG(columna)` ignora los `NULL`. Por eso, en un `LEFT JOIN`, los tipos sin coincidencias quedan con media `NULL` y luego `HAVING` puede eliminarlos.

Aqui esa es la razon principal de que varias versiones terminen dando la misma salida final.

---

<a id="ejercicio-3"></a>
# Ejercicio 3: Entrenadores con pokemon activos de nivel alto

## Enunciado completo
Muestra el nombre del entrenador y cuantos pokemon tiene registrados en `ENTRENADOR_POKEMON`, pero solo teniendo en cuenta los pokemon de nivel mayor o igual que 40 y con estado `ACTIVO`. Haz que solo aparezcan los entrenadores que tengan al menos 2 pokemon en esas condiciones. Ordena por total descendente y nombre del entrenador ascendente.

## Consulta original
```sql
SELECT E.NOMBRE, COUNT(*) AS TOTAL_POKEMON
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
WHERE EP.NIVEL >= 40
  AND EP.ESTADO = 'ACTIVO'
GROUP BY E.NOMBRE
HAVING COUNT(*) >= 2
ORDER BY TOTAL_POKEMON DESC, E.NOMBRE ASC;
```

## Idea del ejercicio
Solo interesan entrenadores con filas validas en `ENTRENADOR_POKEMON`, asi que `INNER JOIN` es la forma mas directa.

## Variante `LEFT JOIN`
```sql
SELECT E.NOMBRE, COUNT(*) AS TOTAL_POKEMON
FROM ENTRENADOR E
LEFT JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
WHERE EP.NIVEL >= 40
  AND EP.ESTADO = 'ACTIVO'
GROUP BY E.NOMBRE
HAVING COUNT(*) >= 2
ORDER BY TOTAL_POKEMON DESC, E.NOMBRE ASC;
```

### Que pasa
La salida final no cambia.

El `WHERE` obliga a que `EP` no sea `NULL`, asi que el `LEFT JOIN` se comporta en la practica como un `INNER JOIN`.

## Variante `RIGHT JOIN`
```sql
SELECT E.NOMBRE, COUNT(*) AS TOTAL_POKEMON
FROM ENTRENADOR_POKEMON EP
RIGHT JOIN ENTRENADOR E
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
WHERE EP.NIVEL >= 40
  AND EP.ESTADO = 'ACTIVO'
GROUP BY E.NOMBRE
HAVING COUNT(*) >= 2
ORDER BY TOTAL_POKEMON DESC, E.NOMBRE ASC;
```

### Que pasa
La salida final tampoco cambia por la misma razon: el `WHERE` elimina las filas sin pareja real.

## Â¿Que pasa si muevo los filtros del `WHERE` al `ON`?
```sql
SELECT E.NOMBRE, COUNT(*) AS TOTAL_POKEMON
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
   AND EP.NIVEL >= 40
   AND EP.ESTADO = 'ACTIVO'
GROUP BY E.NOMBRE
HAVING COUNT(*) >= 2
ORDER BY TOTAL_POKEMON DESC, E.NOMBRE ASC;
```

### Que pasa
Con `INNER JOIN`, la salida final no cambia.

## `COUNT(*)` y `COUNT(columna)`
Aqui `COUNT(*)` y `COUNT(EP.COD_POKEMON)` coinciden en la consulta original porque el `INNER JOIN` solo deja filas reales de entrenador y pokemon.

Tambien coincidiria con `COUNT(DISTINCT EP.COD_POKEMON)` para cada entrenador, porque `ENTRENADOR_POKEMON` tiene clave primaria `(COD_ENTRENADOR, COD_POKEMON)` y no admite el mismo pokemon repetido para un entrenador.

Si quisieras conservar a todos los entrenadores con `LEFT JOIN` y contar solo los pokemon validos, seria mejor `COUNT(EP.COD_POKEMON)`.

---

<a id="ejercicio-4"></a>
# Ejercicio 4: Objetos presentes en muchos inventarios

## Enunciado completo
Muestra el nombre de todos los objetos y en cuantos inventarios aparece cada uno con cantidad mayor o igual que 10. Haz que solo aparezcan los objetos que esten en al menos 3 inventarios. Ordena por total descendente y nombre del objeto ascendente.

## Consulta original
```sql
SELECT O.NOMBRE, COUNT(EO.COD_OBJETO) AS TOTAL_INVENTARIOS
FROM OBJETOS O
LEFT JOIN ENTRENADOR_OBJETO EO
    ON O.COD_OBJETO = EO.COD_OBJETO
   AND EO.CANTIDAD >= 10
GROUP BY O.NOMBRE
HAVING COUNT(EO.COD_OBJETO) >= 3
ORDER BY TOTAL_INVENTARIOS DESC, O.NOMBRE ASC;
```

## Idea del ejercicio
El enunciado parte de todos los objetos, asi que tiene sentido conservar primero `OBJETOS` y filtrar la condicion de cantidad en `ON`.

## Variante `INNER JOIN`
```sql
SELECT O.NOMBRE, COUNT(EO.COD_OBJETO) AS TOTAL_INVENTARIOS
FROM OBJETOS O
INNER JOIN ENTRENADOR_OBJETO EO
    ON O.COD_OBJETO = EO.COD_OBJETO
WHERE EO.CANTIDAD >= 10
GROUP BY O.NOMBRE
HAVING COUNT(EO.COD_OBJETO) >= 3
ORDER BY TOTAL_INVENTARIOS DESC, O.NOMBRE ASC;
```

### Que pasa
Con estos inserts, la salida final no cambia.

Los objetos sin coincidencias utiles ya iban a caer por `HAVING`, asi que el resultado visible se mantiene.

## Variante `RIGHT JOIN`
```sql
SELECT O.NOMBRE, COUNT(EO.COD_OBJETO) AS TOTAL_INVENTARIOS
FROM ENTRENADOR_OBJETO EO
RIGHT JOIN OBJETOS O
    ON O.COD_OBJETO = EO.COD_OBJETO
   AND EO.CANTIDAD >= 10
GROUP BY O.NOMBRE
HAVING COUNT(EO.COD_OBJETO) >= 3
ORDER BY TOTAL_INVENTARIOS DESC, O.NOMBRE ASC;
```

### Que pasa
La salida final tampoco cambia. Es equivalente a la original, pero escrita con `RIGHT JOIN`.

## Â¿Que pasa si muevo el filtro del `ON` al `WHERE`?
```sql
SELECT O.NOMBRE, COUNT(EO.COD_OBJETO) AS TOTAL_INVENTARIOS
FROM OBJETOS O
LEFT JOIN ENTRENADOR_OBJETO EO
    ON O.COD_OBJETO = EO.COD_OBJETO
WHERE EO.CANTIDAD >= 10
GROUP BY O.NOMBRE
HAVING COUNT(EO.COD_OBJETO) >= 3
ORDER BY TOTAL_INVENTARIOS DESC, O.NOMBRE ASC;
```

### Que pasa
La salida final no cambia con estos inserts, pero el `LEFT JOIN` deja de conservar de verdad todos los objetos.

## `COUNT(*)` y `COUNT(columna)`
Aqui es importante usar `COUNT(EO.COD_OBJETO)` y no `COUNT(*)`.

En esta consulta concreta, si solo miras la salida final, `COUNT(*)` no cambiaria los objetos que aparecen porque el `HAVING COUNT(...) >= 3` elimina los grupos sin suficientes coincidencias.

Pero como significado del dato es peor: si usaras `COUNT(*)` en un `OUTER JOIN`, un objeto sin inventarios validos seguiria generando una fila y contaria como `1`, que no es lo que quieres medir.

---

<a id="ejercicio-5"></a>
# Ejercicio 5: Pokemon con varios movimientos aprendidos a nivel alto

## Enunciado completo
Muestra el nombre del pokemon y cuantos movimientos tiene aprendidos, pero solo teniendo en cuenta los movimientos aprendidos a nivel 20 o superior. Haz que solo aparezcan los pokemon que tengan al menos 2 movimientos en esas condiciones. Ordena por total descendente y nombre del pokemon ascendente.

## Consulta original
```sql
SELECT P.NOMBRE, COUNT(PM.COD_MOVIMIENTO) AS TOTAL_MOVIMIENTOS
FROM POKEMON P
INNER JOIN POKEMON_MOVIMIENTO PM
    ON P.COD_POKEMON = PM.COD_POKEMON
WHERE PM.NIVEL_APRENDIZAJE >= 20
GROUP BY P.NOMBRE
HAVING COUNT(PM.COD_MOVIMIENTO) >= 2
ORDER BY TOTAL_MOVIMIENTOS DESC, P.NOMBRE ASC;
```

## Idea del ejercicio
Solo acaban interesando los pokemon que si tienen movimientos en ese rango de nivel, asi que `INNER JOIN` es suficiente.

## Variante `LEFT JOIN`
```sql
SELECT P.NOMBRE, COUNT(PM.COD_MOVIMIENTO) AS TOTAL_MOVIMIENTOS
FROM POKEMON P
LEFT JOIN POKEMON_MOVIMIENTO PM
    ON P.COD_POKEMON = PM.COD_POKEMON
WHERE PM.NIVEL_APRENDIZAJE >= 20
GROUP BY P.NOMBRE
HAVING COUNT(PM.COD_MOVIMIENTO) >= 2
ORDER BY TOTAL_MOVIMIENTOS DESC, P.NOMBRE ASC;
```

### Que pasa
La salida final no cambia.

De nuevo, el `WHERE` obliga a que haya fila real en `PM`, asi que el `LEFT JOIN` se estrecha hasta comportarse como un `INNER JOIN`.

## Variante `RIGHT JOIN`
```sql
SELECT P.NOMBRE, COUNT(PM.COD_MOVIMIENTO) AS TOTAL_MOVIMIENTOS
FROM POKEMON_MOVIMIENTO PM
RIGHT JOIN POKEMON P
    ON P.COD_POKEMON = PM.COD_POKEMON
WHERE PM.NIVEL_APRENDIZAJE >= 20
GROUP BY P.NOMBRE
HAVING COUNT(PM.COD_MOVIMIENTO) >= 2
ORDER BY TOTAL_MOVIMIENTOS DESC, P.NOMBRE ASC;
```

### Que pasa
La salida final tampoco cambia por la misma razon.

## Â¿Que pasa si muevo el filtro del `WHERE` al `ON`?
```sql
SELECT P.NOMBRE, COUNT(PM.COD_MOVIMIENTO) AS TOTAL_MOVIMIENTOS
FROM POKEMON P
INNER JOIN POKEMON_MOVIMIENTO PM
    ON P.COD_POKEMON = PM.COD_POKEMON
   AND PM.NIVEL_APRENDIZAJE >= 20
GROUP BY P.NOMBRE
HAVING COUNT(PM.COD_MOVIMIENTO) >= 2
ORDER BY TOTAL_MOVIMIENTOS DESC, P.NOMBRE ASC;
```

### Que pasa
Con `INNER JOIN`, la salida final no cambia.

## `COUNT(*)` y `COUNT(columna)`
`COUNT(PM.COD_MOVIMIENTO)` es la opcion didacticamente mas clara porque cuenta movimientos reales.

En la consulta original, `COUNT(*)` daria el mismo resultado porque hay `INNER JOIN`: cada fila que llega al grupo es una fila real de `POKEMON_MOVIMIENTO`. Ademas, la clave primaria `(COD_POKEMON, COD_MOVIMIENTO)` impide que el mismo movimiento se repita para el mismo pokemon.

En un `OUTER JOIN`, `COUNT(*)` podria contar la fila preservada aunque `PM` fuese `NULL`.

---

<a id="ejercicio-6"></a>
# Ejercicio 6: Entrenadores con pokemon distintos de nivel alto

## Enunciado completo
Muestra el nombre de todos los entrenadores y cuantos pokemon distintos tiene cada uno en `ENTRENADOR_POKEMON` con nivel mayor o igual que 40. Haz que solo aparezcan los entrenadores que tengan al menos 3 pokemon distintos en esas condiciones. Ordena por total descendente y nombre del entrenador ascendente.

## Consulta original
```sql
SELECT E.NOMBRE, COUNT(DISTINCT EP.COD_POKEMON) AS TOTAL_POKEMON
FROM ENTRENADOR E
LEFT JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
   AND EP.NIVEL >= 40
GROUP BY E.NOMBRE
HAVING COUNT(DISTINCT EP.COD_POKEMON) >= 3
ORDER BY TOTAL_POKEMON DESC, E.NOMBRE ASC;
```

## Idea del ejercicio
El enunciado parte de todos los entrenadores. Por eso `LEFT JOIN` encaja bien y el filtro de nivel va en `ON`.

## Variante `INNER JOIN`
```sql
SELECT E.NOMBRE, COUNT(DISTINCT EP.COD_POKEMON) AS TOTAL_POKEMON
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
WHERE EP.NIVEL >= 40
GROUP BY E.NOMBRE
HAVING COUNT(DISTINCT EP.COD_POKEMON) >= 3
ORDER BY TOTAL_POKEMON DESC, E.NOMBRE ASC;
```

### Que pasa
Con estos inserts, la salida final no cambia.

Los entrenadores sin suficientes pokemon validos ya desaparecian por `HAVING`.

## Variante `RIGHT JOIN`
```sql
SELECT E.NOMBRE, COUNT(DISTINCT EP.COD_POKEMON) AS TOTAL_POKEMON
FROM ENTRENADOR_POKEMON EP
RIGHT JOIN ENTRENADOR E
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
   AND EP.NIVEL >= 40
GROUP BY E.NOMBRE
HAVING COUNT(DISTINCT EP.COD_POKEMON) >= 3
ORDER BY TOTAL_POKEMON DESC, E.NOMBRE ASC;
```

### Que pasa
La salida final tampoco cambia. Es la misma idea que la original, pero invertida.

## Â¿Que pasa si muevo el filtro del `ON` al `WHERE`?
```sql
SELECT E.NOMBRE, COUNT(DISTINCT EP.COD_POKEMON) AS TOTAL_POKEMON
FROM ENTRENADOR E
LEFT JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
WHERE EP.NIVEL >= 40
GROUP BY E.NOMBRE
HAVING COUNT(DISTINCT EP.COD_POKEMON) >= 3
ORDER BY TOTAL_POKEMON DESC, E.NOMBRE ASC;
```

### Que pasa
La salida final no cambia con estos inserts, pero el `LEFT JOIN` pierde su efecto de conservacion.

## `COUNT(DISTINCT)` y `NULL`
`COUNT(DISTINCT EP.COD_POKEMON)` ignora los `NULL`. Por eso, los entrenadores sin coincidencias utiles acaban con conteo `0`.

Si se cambia `COUNT(DISTINCT EP.COD_POKEMON)` o `COUNT(EP.COD_POKEMON)` por `COUNT(*)`, en este ejercicio la salida final tambien queda igual. Los entrenadores sin coincidencias utiles pasarian de `0` a `1`, pero no llegan al `HAVING >= 3`; y los entrenadores que si pasan no pueden tener el mismo pokemon repetido porque la clave primaria es `(COD_ENTRENADOR, COD_POKEMON)`.

Ese es uno de los motivos por los que varias versiones terminan devolviendo la misma salida final.

---

<a id="ejercicio-7"></a>
# Ejercicio 7: Tipos con movimientos precisos y potentes

## Enunciado completo
Muestra el nombre del tipo de los movimientos y cuantos movimientos distintos tiene cada tipo, pero solo teniendo en cuenta los movimientos con potencia mayor que 0 y precision mayor o igual que 90. Haz que solo aparezcan los tipos que tengan al menos 3 movimientos distintos y cuya potencia media sea superior a 75. Ordena por total descendente y nombre del tipo ascendente.

## Consulta original
```sql
SELECT T.NOMBRE,
       COUNT(DISTINCT M.COD_MOVIMIENTO) AS TOTAL_MOVIMIENTOS,
       AVG(M.POTENCIA) AS POTENCIA_MEDIA
FROM TIPOS T
LEFT JOIN MOVIMIENTOS M
    ON T.COD_TIPO = M.COD_TIPO
   AND M.POTENCIA > 0
   AND M.PRECISION_MOV >= 90
GROUP BY T.NOMBRE
HAVING COUNT(DISTINCT M.COD_MOVIMIENTO) >= 3
   AND AVG(M.POTENCIA) > 75
ORDER BY TOTAL_MOVIMIENTOS DESC, T.NOMBRE ASC;
```

## Idea del ejercicio
Se parte de todos los tipos, pero el `HAVING` final deja solo los grupos realmente fuertes.

## Variante `INNER JOIN`
```sql
SELECT T.NOMBRE,
       COUNT(DISTINCT M.COD_MOVIMIENTO) AS TOTAL_MOVIMIENTOS,
       AVG(M.POTENCIA) AS POTENCIA_MEDIA
FROM TIPOS T
INNER JOIN MOVIMIENTOS M
    ON T.COD_TIPO = M.COD_TIPO
WHERE M.POTENCIA > 0
  AND M.PRECISION_MOV >= 90
GROUP BY T.NOMBRE
HAVING COUNT(DISTINCT M.COD_MOVIMIENTO) >= 3
   AND AVG(M.POTENCIA) > 75
ORDER BY TOTAL_MOVIMIENTOS DESC, T.NOMBRE ASC;
```

### Que pasa
Con estos inserts, la salida final no cambia.

Los grupos sin movimientos validos ya quedaban fuera por `HAVING`.

## Variante `RIGHT JOIN`
```sql
SELECT T.NOMBRE,
       COUNT(DISTINCT M.COD_MOVIMIENTO) AS TOTAL_MOVIMIENTOS,
       AVG(M.POTENCIA) AS POTENCIA_MEDIA
FROM MOVIMIENTOS M
RIGHT JOIN TIPOS T
    ON T.COD_TIPO = M.COD_TIPO
   AND M.POTENCIA > 0
   AND M.PRECISION_MOV >= 90
GROUP BY T.NOMBRE
HAVING COUNT(DISTINCT M.COD_MOVIMIENTO) >= 3
   AND AVG(M.POTENCIA) > 75
ORDER BY TOTAL_MOVIMIENTOS DESC, T.NOMBRE ASC;
```

### Que pasa
La salida final tampoco cambia. La escritura cambia, pero la logica final es la misma.

## Â¿Que pasa si muevo los filtros del `ON` al `WHERE`?
```sql
SELECT T.NOMBRE,
       COUNT(DISTINCT M.COD_MOVIMIENTO) AS TOTAL_MOVIMIENTOS,
       AVG(M.POTENCIA) AS POTENCIA_MEDIA
FROM TIPOS T
LEFT JOIN MOVIMIENTOS M
    ON T.COD_TIPO = M.COD_TIPO
WHERE M.POTENCIA > 0
  AND M.PRECISION_MOV >= 90
GROUP BY T.NOMBRE
HAVING COUNT(DISTINCT M.COD_MOVIMIENTO) >= 3
   AND AVG(M.POTENCIA) > 75
ORDER BY TOTAL_MOVIMIENTOS DESC, T.NOMBRE ASC;
```

### Que pasa
La salida final no cambia con estos inserts, pero el conjunto preservado cambia antes del agrupamiento.

## `COUNT(DISTINCT)` y `AVG`
En este tipo de ejercicios, el resultado final puede estabilizarse por dos motivos:

- `COUNT(DISTINCT ...)` ignora `NULL`.
- `AVG(...)` devuelve `NULL` si no hay valores, y luego `HAVING` elimina ese grupo.

Si cambias `COUNT(DISTINCT M.COD_MOVIMIENTO)` por `COUNT(*)`, la salida final tambien queda igual en este ejercicio. Los tipos sin movimientos validos tendrian `COUNT(*) = 1`, pero `AVG(M.POTENCIA)` seria `NULL` y no pasarian el `HAVING`; y los tipos que si pasan cuentan movimientos reales, con `COD_MOVIMIENTO` unico por clave primaria.

---

<a id="ejercicio-8"></a>
# Ejercicio 8: Entrenadores con pokemon activos muy experimentados

## Enunciado completo
Muestra el nombre del entrenador y la experiencia minima, maxima y media de sus pokemon activos. Haz que solo aparezcan los entrenadores cuya experiencia media sea superior a 150000 y cuya experiencia maxima sea mayor o igual que 200000. Ordena por experiencia media descendente.

## Consulta original
```sql
SELECT E.NOMBRE,
       MIN(EP.EXPERIENCIA) AS EXPERIENCIA_MINIMA,
       MAX(EP.EXPERIENCIA) AS EXPERIENCIA_MAXIMA,
       AVG(EP.EXPERIENCIA) AS EXPERIENCIA_MEDIA
FROM ENTRENADOR E
LEFT JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
   AND EP.ESTADO = 'ACTIVO'
GROUP BY E.NOMBRE
HAVING AVG(EP.EXPERIENCIA) > 150000
   AND MAX(EP.EXPERIENCIA) >= 200000
ORDER BY EXPERIENCIA_MEDIA DESC;
```

## Idea del ejercicio
Se arranca desde todos los entrenadores, pero el `HAVING` exige valores altos en los agregados.

## Variante `INNER JOIN`
```sql
SELECT E.NOMBRE,
       MIN(EP.EXPERIENCIA) AS EXPERIENCIA_MINIMA,
       MAX(EP.EXPERIENCIA) AS EXPERIENCIA_MAXIMA,
       AVG(EP.EXPERIENCIA) AS EXPERIENCIA_MEDIA
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
WHERE EP.ESTADO = 'ACTIVO'
GROUP BY E.NOMBRE
HAVING AVG(EP.EXPERIENCIA) > 150000
   AND MAX(EP.EXPERIENCIA) >= 200000
ORDER BY EXPERIENCIA_MEDIA DESC;
```

### Que pasa
Con estos inserts, la salida final no cambia.

Los entrenadores sin valores suficientes ya eran eliminados por los agregados del `HAVING`.

## Variante `RIGHT JOIN`
```sql
SELECT E.NOMBRE,
       MIN(EP.EXPERIENCIA) AS EXPERIENCIA_MINIMA,
       MAX(EP.EXPERIENCIA) AS EXPERIENCIA_MAXIMA,
       AVG(EP.EXPERIENCIA) AS EXPERIENCIA_MEDIA
FROM ENTRENADOR_POKEMON EP
RIGHT JOIN ENTRENADOR E
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
   AND EP.ESTADO = 'ACTIVO'
GROUP BY E.NOMBRE
HAVING AVG(EP.EXPERIENCIA) > 150000
   AND MAX(EP.EXPERIENCIA) >= 200000
ORDER BY EXPERIENCIA_MEDIA DESC;
```

### Que pasa
La salida final tampoco cambia. Es equivalente a la original desde el otro lado.

## Â¿Que pasa si muevo el filtro del `ON` al `WHERE`?
```sql
SELECT E.NOMBRE,
       MIN(EP.EXPERIENCIA) AS EXPERIENCIA_MINIMA,
       MAX(EP.EXPERIENCIA) AS EXPERIENCIA_MAXIMA,
       AVG(EP.EXPERIENCIA) AS EXPERIENCIA_MEDIA
FROM ENTRENADOR E
LEFT JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
WHERE EP.ESTADO = 'ACTIVO'
GROUP BY E.NOMBRE
HAVING AVG(EP.EXPERIENCIA) > 150000
   AND MAX(EP.EXPERIENCIA) >= 200000
ORDER BY EXPERIENCIA_MEDIA DESC;
```

### Que pasa
La salida final no cambia con estos inserts, pero el `LEFT JOIN` deja de preservar entrenadores sin coincidencias.

## Nota sobre `MIN`, `MAX`, `AVG` y `NULL`
En grupos sin coincidencias, estos agregados devuelven `NULL`.

Eso hace que despues `HAVING` descarte esos grupos y que varias variantes terminen mostrando lo mismo.

---

<a id="ejercicio-9"></a>
# Ejercicio 9: Objetos presentes en muchos entrenadores distintos

## Enunciado completo
Muestra el nombre de todos los objetos y en cuantos entrenadores distintos aparece cada uno con cantidad mayor o igual que 10. Haz que solo aparezcan los objetos presentes en al menos 4 entrenadores distintos y cuya cantidad media sea superior a 15. Ordena por total de entrenadores descendente y nombre del objeto ascendente.

## Consulta original
```sql
SELECT O.NOMBRE,
       COUNT(DISTINCT EO.COD_ENTRENADOR) AS TOTAL_ENTRENADORES,
       AVG(EO.CANTIDAD) AS CANTIDAD_MEDIA
FROM OBJETOS O
LEFT JOIN ENTRENADOR_OBJETO EO
    ON O.COD_OBJETO = EO.COD_OBJETO
   AND EO.CANTIDAD >= 10
GROUP BY O.NOMBRE
HAVING COUNT(DISTINCT EO.COD_ENTRENADOR) >= 4
   AND AVG(EO.CANTIDAD) > 15
ORDER BY TOTAL_ENTRENADORES DESC, O.NOMBRE ASC;
```

## Idea del ejercicio
Se parte de todos los objetos, pero el `HAVING` final deja solo los objetos con presencia fuerte y cantidad media alta.

## Variante `INNER JOIN`
```sql
SELECT O.NOMBRE,
       COUNT(DISTINCT EO.COD_ENTRENADOR) AS TOTAL_ENTRENADORES,
       AVG(EO.CANTIDAD) AS CANTIDAD_MEDIA
FROM OBJETOS O
INNER JOIN ENTRENADOR_OBJETO EO
    ON O.COD_OBJETO = EO.COD_OBJETO
WHERE EO.CANTIDAD >= 10
GROUP BY O.NOMBRE
HAVING COUNT(DISTINCT EO.COD_ENTRENADOR) >= 4
   AND AVG(EO.CANTIDAD) > 15
ORDER BY TOTAL_ENTRENADORES DESC, O.NOMBRE ASC;
```

### Que pasa
Con estos inserts, la salida final no cambia.

Los objetos sin coincidencias suficientemente fuertes ya iban a desaparecer por `HAVING`.

## Variante `RIGHT JOIN`
```sql
SELECT O.NOMBRE,
       COUNT(DISTINCT EO.COD_ENTRENADOR) AS TOTAL_ENTRENADORES,
       AVG(EO.CANTIDAD) AS CANTIDAD_MEDIA
FROM ENTRENADOR_OBJETO EO
RIGHT JOIN OBJETOS O
    ON O.COD_OBJETO = EO.COD_OBJETO
   AND EO.CANTIDAD >= 10
GROUP BY O.NOMBRE
HAVING COUNT(DISTINCT EO.COD_ENTRENADOR) >= 4
   AND AVG(EO.CANTIDAD) > 15
ORDER BY TOTAL_ENTRENADORES DESC, O.NOMBRE ASC;
```

### Que pasa
La salida final tampoco cambia. Es la misma logica de preservacion, pero invertida.

## Â¿Que pasa si muevo el filtro del `ON` al `WHERE`?
```sql
SELECT O.NOMBRE,
       COUNT(DISTINCT EO.COD_ENTRENADOR) AS TOTAL_ENTRENADORES,
       AVG(EO.CANTIDAD) AS CANTIDAD_MEDIA
FROM OBJETOS O
LEFT JOIN ENTRENADOR_OBJETO EO
    ON O.COD_OBJETO = EO.COD_OBJETO
WHERE EO.CANTIDAD >= 10
GROUP BY O.NOMBRE
HAVING COUNT(DISTINCT EO.COD_ENTRENADOR) >= 4
   AND AVG(EO.CANTIDAD) > 15
ORDER BY TOTAL_ENTRENADORES DESC, O.NOMBRE ASC;
```

### Que pasa
La salida final no cambia con estos inserts, pero la conservacion inicial de `OBJETOS` desaparece.

## `COUNT(DISTINCT)` y `AVG`
Este es un ejemplo claro de salida final estable:

- `COUNT(DISTINCT ...)` ignora `NULL`.
- `AVG(...)` sobre grupos vacios da `NULL`.
- `HAVING` elimina luego los grupos que no cumplen.

Si sustituyes `COUNT(DISTINCT EO.COD_ENTRENADOR)` por `COUNT(*)`, la salida final tambien queda igual aqui. Los objetos sin coincidencias no pasan por el `AVG(NULL)`, y para los objetos con coincidencias reales la clave primaria `(COD_ENTRENADOR, COD_OBJETO)` impide que el mismo entrenador aparezca dos veces con el mismo objeto.

---

<a id="ejercicio-10"></a>
# Ejercicio 10: Tipos con pokemon ofensivos y rapidos

## Enunciado completo
Muestra el nombre del tipo primario y el ataque medio de sus pokemon. Solo deben tenerse en cuenta pokemon con ataque base mayor que 50 y velocidad base mayor que 50, y ademas con habilidad asociada. Haz que solo aparezcan los tipos cuyo ataque medio sea superior a 80, cuya defensa minima sea mayor o igual que 55 y que tengan al menos 2 pokemon distintos en esas condiciones. Ordena por ataque medio descendente y nombre del tipo ascendente.

## Consulta original
```sql
SELECT T.NOMBRE,
       AVG(P.ATAQUE_BASE) AS ATAQUE_MEDIO
FROM TIPOS T
INNER JOIN POKEMON P
    ON T.COD_TIPO = P.COD_TIPO_1
INNER JOIN HABILIDADES H
    ON P.COD_HABILIDAD = H.COD_HABILIDAD
WHERE P.ATAQUE_BASE > 50
  AND P.VELOCIDAD_BASE > 50
GROUP BY T.NOMBRE
HAVING AVG(P.ATAQUE_BASE) > 80
   AND MIN(P.DEFENSA_BASE) >= 55
   AND COUNT(DISTINCT P.COD_POKEMON) >= 2
ORDER BY ATAQUE_MEDIO DESC, T.NOMBRE ASC;
```

## Idea del ejercicio
La forma mas directa es usar `INNER JOIN` porque el resultado final exige tipos con pokemon validos y con habilidad asociada.

## Variante `LEFT JOIN`
```sql
SELECT T.NOMBRE,
       AVG(P.ATAQUE_BASE) AS ATAQUE_MEDIO
FROM TIPOS T
LEFT JOIN POKEMON P
    ON T.COD_TIPO = P.COD_TIPO_1
   AND P.ATAQUE_BASE > 50
   AND P.VELOCIDAD_BASE > 50
LEFT JOIN HABILIDADES H
    ON P.COD_HABILIDAD = H.COD_HABILIDAD
GROUP BY T.NOMBRE
HAVING AVG(P.ATAQUE_BASE) > 80
   AND MIN(P.DEFENSA_BASE) >= 55
   AND COUNT(DISTINCT P.COD_POKEMON) >= 2
ORDER BY ATAQUE_MEDIO DESC, T.NOMBRE ASC;
```

### Que pasa
Con estos inserts, la salida final no cambia.

El `HAVING` es tan restrictivo que solo sobreviven los tipos con datos fuertes de verdad.

## Variante `RIGHT JOIN`
```sql
SELECT T.NOMBRE,
       AVG(P.ATAQUE_BASE) AS ATAQUE_MEDIO
FROM POKEMON P
RIGHT JOIN TIPOS T
    ON T.COD_TIPO = P.COD_TIPO_1
   AND P.ATAQUE_BASE > 50
   AND P.VELOCIDAD_BASE > 50
LEFT JOIN HABILIDADES H
    ON P.COD_HABILIDAD = H.COD_HABILIDAD
GROUP BY T.NOMBRE
HAVING AVG(P.ATAQUE_BASE) > 80
   AND MIN(P.DEFENSA_BASE) >= 55
   AND COUNT(DISTINCT P.COD_POKEMON) >= 2
ORDER BY ATAQUE_MEDIO DESC, T.NOMBRE ASC;
```

### Que pasa
La salida final tampoco cambia por el mismo motivo: el `HAVING` fuerte estabiliza el resultado.

## Â¿Que pasa si muevo los filtros del `WHERE` al `ON`?
```sql
SELECT T.NOMBRE,
       AVG(P.ATAQUE_BASE) AS ATAQUE_MEDIO
FROM TIPOS T
INNER JOIN POKEMON P
    ON T.COD_TIPO = P.COD_TIPO_1
   AND P.ATAQUE_BASE > 50
   AND P.VELOCIDAD_BASE > 50
INNER JOIN HABILIDADES H
    ON P.COD_HABILIDAD = H.COD_HABILIDAD
GROUP BY T.NOMBRE
HAVING AVG(P.ATAQUE_BASE) > 80
   AND MIN(P.DEFENSA_BASE) >= 55
   AND COUNT(DISTINCT P.COD_POKEMON) >= 2
ORDER BY ATAQUE_MEDIO DESC, T.NOMBRE ASC;
```

### Que pasa
Con `INNER JOIN`, la salida final no cambia.

## Nota sobre varios agregados
Aqui conviven `AVG`, `MIN` y `COUNT(DISTINCT)`. Esa combinacion hace que el filtro final sea muy exigente y que varias variantes distintas terminen devolviendo la misma salida final.

Si cambias `COUNT(DISTINCT P.COD_POKEMON)` por `COUNT(*)`, la salida final no cambia en este ejercicio. Los joins son internos y no multiplican filas: cada pokemon tiene un unico `COD_POKEMON` y una unica habilidad asociada.

---

<a id="ejercicio-11"></a>
# Ejercicio 11: Pokemon fuertes y su zona

## Enunciado completo
Muestra el nombre del pokemon y el nombre de su zona para los pokemon cuyo ataque base sea mayor o igual que 90. Excluye los pokemon sin zona. Ordena por ataque descendente y nombre del pokemon ascendente.

## Consulta original
```sql
SELECT P.NOMBRE, M.NOMBRE AS ZONA
FROM POKEMON P
INNER JOIN MAPA M
    ON P.COD_ZONA = M.COD_ZONA
WHERE P.ATAQUE_BASE >= 90
ORDER BY P.ATAQUE_BASE DESC, P.NOMBRE ASC;
```

## Idea del ejercicio
Este ejercicio no usa `GROUP BY`. Solo queremos detalle fila a fila de pokemon fuertes con zona conocida.

## Variante `LEFT JOIN`
```sql
SELECT P.NOMBRE, M.NOMBRE AS ZONA
FROM POKEMON P
LEFT JOIN MAPA M
    ON P.COD_ZONA = M.COD_ZONA
WHERE P.ATAQUE_BASE >= 90
ORDER BY P.ATAQUE_BASE DESC, P.NOMBRE ASC;
```

### Que pasa
Aqui si puede cambiar la salida, porque `LEFT JOIN` conserva tambien los pokemon fuertes sin zona y los deja con `ZONA = NULL`.

## Variante `RIGHT JOIN`
```sql
SELECT P.NOMBRE, M.NOMBRE AS ZONA
FROM POKEMON P
RIGHT JOIN MAPA M
    ON P.COD_ZONA = M.COD_ZONA
WHERE P.ATAQUE_BASE >= 90
ORDER BY P.ATAQUE_BASE DESC, P.NOMBRE ASC;
```

### Que pasa
La salida final suele coincidir con la original porque el `WHERE` elimina las filas donde `P` es `NULL`.

## Â¿Que pasa si muevo el filtro del `WHERE` al `ON`?
```sql
SELECT P.NOMBRE, M.NOMBRE AS ZONA
FROM POKEMON P
INNER JOIN MAPA M
    ON P.COD_ZONA = M.COD_ZONA
   AND P.ATAQUE_BASE >= 90
ORDER BY P.ATAQUE_BASE DESC, P.NOMBRE ASC;
```

### Que pasa
Con `INNER JOIN`, la salida final no cambia.

## Nota didactica adicional
Como aqui no hay agregados, la diferencia entre joins se ve directamente en las filas que sobreviven o desaparecen.

---

<a id="ejercicio-12"></a>
# Ejercicio 12: Entrenadores y pokemon activos de nivel muy alto

## Enunciado completo
Muestra el nombre del entrenador, el nombre del pokemon y el nivel para los registros activos con nivel mayor o igual que 50. Ordena por nivel descendente y nombre del entrenador ascendente.

## Consulta original
```sql
SELECT E.NOMBRE, P.NOMBRE AS POKEMON, EP.NIVEL
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
INNER JOIN POKEMON P
    ON EP.COD_POKEMON = P.COD_POKEMON
WHERE EP.ESTADO = 'ACTIVO'
  AND EP.NIVEL >= 50
ORDER BY EP.NIVEL DESC, E.NOMBRE ASC;
```

## Idea del ejercicio
Tampoco hay `GROUP BY`. Queremos listar filas concretas de la relacion entre entrenador y pokemon.

## Variante `LEFT JOIN`
```sql
SELECT E.NOMBRE, P.NOMBRE AS POKEMON, EP.NIVEL
FROM ENTRENADOR E
LEFT JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
LEFT JOIN POKEMON P
    ON EP.COD_POKEMON = P.COD_POKEMON
WHERE EP.ESTADO = 'ACTIVO'
  AND EP.NIVEL >= 50
ORDER BY EP.NIVEL DESC, E.NOMBRE ASC;
```

### Que pasa
La salida final no cambia porque el `WHERE` exige una fila real en `EP`.

## Variante `RIGHT JOIN`
```sql
SELECT E.NOMBRE, P.NOMBRE AS POKEMON, EP.NIVEL
FROM ENTRENADOR_POKEMON EP
RIGHT JOIN ENTRENADOR E
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
LEFT JOIN POKEMON P
    ON EP.COD_POKEMON = P.COD_POKEMON
WHERE EP.ESTADO = 'ACTIVO'
  AND EP.NIVEL >= 50
ORDER BY EP.NIVEL DESC, E.NOMBRE ASC;
```

### Que pasa
La salida final tampoco cambia, por la misma razon.

## Â¿Que pasa si muevo los filtros del `WHERE` al `ON`?
```sql
SELECT E.NOMBRE, P.NOMBRE AS POKEMON, EP.NIVEL
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
   AND EP.ESTADO = 'ACTIVO'
   AND EP.NIVEL >= 50
INNER JOIN POKEMON P
    ON EP.COD_POKEMON = P.COD_POKEMON
ORDER BY EP.NIVEL DESC, E.NOMBRE ASC;
```

### Que pasa
Con `INNER JOIN`, la salida final no cambia.

## Nota didactica adicional
En consultas de detalle, mover un filtro entre `ON` y `WHERE` solo conserva el resultado cuando el join es interno.

---

<a id="ejercicio-13"></a>
# Ejercicio 13: Objetos con cantidad alta en inventarios

## Enunciado completo
Muestra el nombre del objeto y la cantidad para los registros de inventario con cantidad mayor o igual que 15. Ordena por cantidad descendente y nombre del objeto ascendente.

## Consulta original
```sql
SELECT O.NOMBRE, EO.CANTIDAD
FROM OBJETOS O
INNER JOIN ENTRENADOR_OBJETO EO
    ON O.COD_OBJETO = EO.COD_OBJETO
WHERE EO.CANTIDAD >= 15
ORDER BY EO.CANTIDAD DESC, O.NOMBRE ASC;
```

## Idea del ejercicio
No necesitamos agrupar. Solo queremos detalle de cada fila de inventario fuerte.

## Variante `LEFT JOIN`
```sql
SELECT O.NOMBRE, EO.CANTIDAD
FROM OBJETOS O
LEFT JOIN ENTRENADOR_OBJETO EO
    ON O.COD_OBJETO = EO.COD_OBJETO
WHERE EO.CANTIDAD >= 15
ORDER BY EO.CANTIDAD DESC, O.NOMBRE ASC;
```

### Que pasa
La salida final no cambia, porque el `WHERE` obliga a que `EO` no sea `NULL`.

## Variante `RIGHT JOIN`
```sql
SELECT O.NOMBRE, EO.CANTIDAD
FROM ENTRENADOR_OBJETO EO
RIGHT JOIN OBJETOS O
    ON O.COD_OBJETO = EO.COD_OBJETO
WHERE EO.CANTIDAD >= 15
ORDER BY EO.CANTIDAD DESC, O.NOMBRE ASC;
```

### Que pasa
La salida final tampoco cambia por el mismo motivo.

## Â¿Que pasa si muevo el filtro del `WHERE` al `ON`?
```sql
SELECT O.NOMBRE, EO.CANTIDAD
FROM OBJETOS O
INNER JOIN ENTRENADOR_OBJETO EO
    ON O.COD_OBJETO = EO.COD_OBJETO
   AND EO.CANTIDAD >= 15
ORDER BY EO.CANTIDAD DESC, O.NOMBRE ASC;
```

### Que pasa
Con `INNER JOIN`, la salida final no cambia.

## Nota didactica adicional
Aunque sea un ejercicio sin `GROUP BY`, sigue sirviendo para ver como el `WHERE` puede anular el efecto externo de un join.

---

<a id="ejercicio-14"></a>
# Ejercicio 14: Pokemon y movimientos aprendidos a nivel 40 o superior

## Enunciado completo
Muestra el nombre del pokemon, el codigo del movimiento y el nivel de aprendizaje para los movimientos aprendidos a nivel 40 o superior. Ordena por nivel de aprendizaje descendente y nombre del pokemon ascendente.

## Consulta original
```sql
SELECT P.NOMBRE, PM.COD_MOVIMIENTO, PM.NIVEL_APRENDIZAJE
FROM POKEMON P
INNER JOIN POKEMON_MOVIMIENTO PM
    ON P.COD_POKEMON = PM.COD_POKEMON
WHERE PM.NIVEL_APRENDIZAJE >= 40
ORDER BY PM.NIVEL_APRENDIZAJE DESC, P.NOMBRE ASC;
```

## Idea del ejercicio
Es otro caso de detalle fila a fila, sin agrupacion.

## Variante `LEFT JOIN`
```sql
SELECT P.NOMBRE, PM.COD_MOVIMIENTO, PM.NIVEL_APRENDIZAJE
FROM POKEMON P
LEFT JOIN POKEMON_MOVIMIENTO PM
    ON P.COD_POKEMON = PM.COD_POKEMON
WHERE PM.NIVEL_APRENDIZAJE >= 40
ORDER BY PM.NIVEL_APRENDIZAJE DESC, P.NOMBRE ASC;
```

### Que pasa
La salida final no cambia, porque el `WHERE` fuerza coincidencia real en `PM`.

## Variante `RIGHT JOIN`
```sql
SELECT P.NOMBRE, PM.COD_MOVIMIENTO, PM.NIVEL_APRENDIZAJE
FROM POKEMON_MOVIMIENTO PM
RIGHT JOIN POKEMON P
    ON P.COD_POKEMON = PM.COD_POKEMON
WHERE PM.NIVEL_APRENDIZAJE >= 40
ORDER BY PM.NIVEL_APRENDIZAJE DESC, P.NOMBRE ASC;
```

### Que pasa
La salida final tampoco cambia.

## Â¿Que pasa si muevo el filtro del `WHERE` al `ON`?
```sql
SELECT P.NOMBRE, PM.COD_MOVIMIENTO, PM.NIVEL_APRENDIZAJE
FROM POKEMON P
INNER JOIN POKEMON_MOVIMIENTO PM
    ON P.COD_POKEMON = PM.COD_POKEMON
   AND PM.NIVEL_APRENDIZAJE >= 40
ORDER BY PM.NIVEL_APRENDIZAJE DESC, P.NOMBRE ASC;
```

### Que pasa
Con `INNER JOIN`, la salida final no cambia.

## Nota didactica adicional
Si quisieras conservar todos los pokemon, el filtro tendria que ir en `ON` dentro de un `LEFT JOIN`.

---

<a id="ejercicio-15"></a>
# Ejercicio 15: Tipos y movimientos extremadamente potentes

## Enunciado completo
Muestra el nombre de todos los tipos y el nombre del movimiento, pero solo teniendo en cuenta movimientos con potencia mayor que 100. Ordena por nombre del tipo ascendente y nombre del movimiento ascendente.

## Consulta original
```sql
SELECT T.NOMBRE, M.NOMBRE AS MOVIMIENTO
FROM TIPOS T
LEFT JOIN MOVIMIENTOS M
    ON T.COD_TIPO = M.COD_TIPO
   AND M.POTENCIA > 100
ORDER BY T.NOMBRE ASC, M.NOMBRE ASC;
```

## Idea del ejercicio
Aqui no hay `GROUP BY`, pero si hay un ejemplo muy claro de conservacion de filas: queremos mantener todos los tipos.

## Variante `INNER JOIN`
```sql
SELECT T.NOMBRE, M.NOMBRE AS MOVIMIENTO
FROM TIPOS T
INNER JOIN MOVIMIENTOS M
    ON T.COD_TIPO = M.COD_TIPO
WHERE M.POTENCIA > 100
ORDER BY T.NOMBRE ASC, M.NOMBRE ASC;
```

### Que pasa
Aqui si cambia la salida.

Con `INNER JOIN`, desaparecen los tipos que no tienen movimientos por encima de ese umbral.

## Variante `RIGHT JOIN`
```sql
SELECT T.NOMBRE, M.NOMBRE AS MOVIMIENTO
FROM MOVIMIENTOS M
RIGHT JOIN TIPOS T
    ON T.COD_TIPO = M.COD_TIPO
   AND M.POTENCIA > 100
ORDER BY T.NOMBRE ASC, M.NOMBRE ASC;
```

### Que pasa
La salida final coincide con la original porque sigue conservando todos los tipos.

## Â¿Que pasa si muevo el filtro del `ON` al `WHERE`?
```sql
SELECT T.NOMBRE, M.NOMBRE AS MOVIMIENTO
FROM TIPOS T
LEFT JOIN MOVIMIENTOS M
    ON T.COD_TIPO = M.COD_TIPO
WHERE M.POTENCIA > 100
ORDER BY T.NOMBRE ASC, M.NOMBRE ASC;
```

### Que pasa
Aqui si cambia la salida. El `LEFT JOIN` deja de conservar tipos sin movimientos validos.

## Nota didactica adicional
Este ejercicio sin `GROUP BY` es muy util para ver que la diferencia entre `ON` y `WHERE` no solo afecta a agregados: tambien afecta a filas de detalle.

---

<a id="ejercicio-16"></a>
# Ejercicio 16: Todas las zonas y cuantos pokemon muy rapidos tienen

## Enunciado completo
Muestra el nombre de todas las zonas y cuantos pokemon tiene cada una con velocidad base mayor o igual que 90. Ordena por total descendente y nombre de zona ascendente.

## Consulta original
```sql
SELECT M.NOMBRE, COUNT(P.COD_POKEMON) AS TOTAL_POKEMON_RAPIDOS
FROM MAPA M
LEFT JOIN POKEMON P
    ON M.COD_ZONA = P.COD_ZONA
   AND P.VELOCIDAD_BASE >= 90
GROUP BY M.NOMBRE
ORDER BY TOTAL_POKEMON_RAPIDOS DESC, M.NOMBRE ASC;
```

## Idea del ejercicio
Aqui queremos conservar todas las zonas, incluso las que no tengan ningun pokemon tan rapido. Por eso la consulta correcta arranca desde `MAPA` con `LEFT JOIN`.

El filtro `P.VELOCIDAD_BASE >= 90` va en `ON` y no forma parte de la FK. Sirve para decidir que pokemon cuentan sin dejar de conservar las zonas.

## Variante `INNER JOIN`
```sql
SELECT M.NOMBRE, COUNT(P.COD_POKEMON) AS TOTAL_POKEMON_RAPIDOS
FROM MAPA M
INNER JOIN POKEMON P
    ON M.COD_ZONA = P.COD_ZONA
   AND P.VELOCIDAD_BASE >= 90
GROUP BY M.NOMBRE
ORDER BY TOTAL_POKEMON_RAPIDOS DESC, M.NOMBRE ASC;
```

### Que pasa
Aqui si cambia mucho la salida.

Con `INNER JOIN`, desaparecen todas las zonas que no tengan pokemon con velocidad mayor o igual que 90. En la original esas zonas seguian apareciendo con total `0`.

## Variante `RIGHT JOIN`
```sql
SELECT M.NOMBRE, COUNT(P.COD_POKEMON) AS TOTAL_POKEMON_RAPIDOS
FROM POKEMON P
RIGHT JOIN MAPA M
    ON M.COD_ZONA = P.COD_ZONA
   AND P.VELOCIDAD_BASE >= 90
GROUP BY M.NOMBRE
ORDER BY TOTAL_POKEMON_RAPIDOS DESC, M.NOMBRE ASC;
```

### Que pasa
La salida final coincide con la original.

`RIGHT JOIN` aqui conserva `MAPA`, igual que hacia la original con `LEFT JOIN`.

## Que pasa si muevo el filtro del `ON` al `WHERE`?
```sql
SELECT M.NOMBRE, COUNT(P.COD_POKEMON) AS TOTAL_POKEMON_RAPIDOS
FROM MAPA M
LEFT JOIN POKEMON P
    ON M.COD_ZONA = P.COD_ZONA
WHERE P.VELOCIDAD_BASE >= 90
GROUP BY M.NOMBRE
ORDER BY TOTAL_POKEMON_RAPIDOS DESC, M.NOMBRE ASC;
```

### Que pasa
Aqui tambien cambia mucho la salida.

Al pasar el filtro a `WHERE`, las filas en las que `P` es `NULL` desaparecen. Eso hace que el `LEFT JOIN` deje de conservar las zonas sin pokemon rapidos y se comporte en la practica como un `INNER JOIN`.

## `COUNT(*)` y `COUNT(columna)`
En esta consulta correcta debe usarse `COUNT(P.COD_POKEMON)`.

- `COUNT(P.COD_POKEMON)` cuenta solo pokemon reales que cumplen la condicion del `ON`.
- `COUNT(*)` contaria tambien la fila preservada de una zona sin coincidencias y le daria `1`.
- `COUNT(M.COD_ZONA)` tambien estaria mal, porque `M` es la tabla conservada y nunca vale `NULL`.

Este es un ejemplo muy claro de que no basta con saber que hay que contar: tambien hay que saber sobre que columna contar.

---

<a id="ejercicio-17"></a>
# Ejercicio 17: Todos los tipos y cuantos pokemon duales fuertes tienen

## Enunciado completo
Muestra el nombre de todos los tipos primarios y cuantos pokemon tiene cada uno que ademas tengan tipo secundario y ataque base mayor que 80. Ordena por total descendente y nombre del tipo ascendente.

## Consulta original
```sql
SELECT T.NOMBRE, COUNT(P.COD_POKEMON) AS TOTAL_POKEMON_DUALES_FUERTES
FROM TIPOS T
LEFT JOIN POKEMON P
    ON T.COD_TIPO = P.COD_TIPO_1
   AND P.COD_TIPO_2 IS NOT NULL
   AND P.ATAQUE_BASE > 80
GROUP BY T.NOMBRE
ORDER BY TOTAL_POKEMON_DUALES_FUERTES DESC, T.NOMBRE ASC;
```

## Idea del ejercicio
Queremos conservar todos los tipos, aunque algunos no tengan ningun pokemon dual fuerte.

Las comprobaciones `P.COD_TIPO_2 IS NOT NULL` y `P.ATAQUE_BASE > 80` van en `ON`. Ninguna de las dos es parte de la FK; son filtros extra que deciden que filas de `POKEMON` cuentan.

## Variante `INNER JOIN`
```sql
SELECT T.NOMBRE, COUNT(P.COD_POKEMON) AS TOTAL_POKEMON_DUALES_FUERTES
FROM TIPOS T
INNER JOIN POKEMON P
    ON T.COD_TIPO = P.COD_TIPO_1
   AND P.COD_TIPO_2 IS NOT NULL
   AND P.ATAQUE_BASE > 80
GROUP BY T.NOMBRE
ORDER BY TOTAL_POKEMON_DUALES_FUERTES DESC, T.NOMBRE ASC;
```

### Que pasa
La salida cambia mucho.

Con `INNER JOIN`, desaparecen todos los tipos que no tienen pokemon duales fuertes. En la consulta original esos tipos seguian visibles con total `0`.

## Variante `RIGHT JOIN`
```sql
SELECT T.NOMBRE, COUNT(P.COD_POKEMON) AS TOTAL_POKEMON_DUALES_FUERTES
FROM POKEMON P
RIGHT JOIN TIPOS T
    ON T.COD_TIPO = P.COD_TIPO_1
   AND P.COD_TIPO_2 IS NOT NULL
   AND P.ATAQUE_BASE > 80
GROUP BY T.NOMBRE
ORDER BY TOTAL_POKEMON_DUALES_FUERTES DESC, T.NOMBRE ASC;
```

### Que pasa
La salida final coincide con la original.

De nuevo, `RIGHT JOIN` conserva la tabla que nos interesa mantener completa, que aqui es `TIPOS`.

## Que pasa si muevo los filtros del `ON` al `WHERE`?
```sql
SELECT T.NOMBRE, COUNT(P.COD_POKEMON) AS TOTAL_POKEMON_DUALES_FUERTES
FROM TIPOS T
LEFT JOIN POKEMON P
    ON T.COD_TIPO = P.COD_TIPO_1
WHERE P.COD_TIPO_2 IS NOT NULL
  AND P.ATAQUE_BASE > 80
GROUP BY T.NOMBRE
ORDER BY TOTAL_POKEMON_DUALES_FUERTES DESC, T.NOMBRE ASC;
```

### Que pasa
La salida vuelve a cambiar mucho.

Al poner esos filtros en `WHERE`, los tipos sin pokemon validos dejan de conservarse. El resultado se parece al del `INNER JOIN`.

## `COUNT(*)` y `COUNT(columna)`
Aqui el conteo correcto vuelve a ser `COUNT(P.COD_POKEMON)`.

- `COUNT(*)` daria `1` a un tipo que no tenga ningun pokemon dual fuerte, porque la fila del tipo se conserva.
- `COUNT(T.COD_TIPO)` tambien daria un valor enganoso, porque `T` es la tabla preservada.

Si el join es externo, la columna correcta para contar suele ser la de la tabla opcional.

---

<a id="ejercicio-18"></a>
# Ejercicio 18: Todas las habilidades y cuantos pokemon resistentes con zona tienen

## Enunciado completo
Muestra el nombre de todas las habilidades y cuantos pokemon tiene cada una, pero solo teniendo en cuenta pokemon con zona asignada y defensa base mayor o igual que 70. Ordena por total descendente y nombre de la habilidad ascendente.

## Consulta original
```sql
SELECT H.NOMBRE, COUNT(P.COD_POKEMON) AS TOTAL_POKEMON_RESISTENTES
FROM HABILIDADES H
LEFT JOIN POKEMON P
    ON H.COD_HABILIDAD = P.COD_HABILIDAD
   AND P.COD_ZONA IS NOT NULL
   AND P.DEFENSA_BASE >= 70
GROUP BY H.NOMBRE
ORDER BY TOTAL_POKEMON_RESISTENTES DESC, H.NOMBRE ASC;
```

## Idea del ejercicio
El objetivo es ver todas las habilidades, incluso las que no tengan ningun pokemon que cumpla el filtro.

Las comprobaciones `P.COD_ZONA IS NOT NULL` y `P.DEFENSA_BASE >= 70` no forman parte de la FK. Estan en `ON` precisamente para no romper la conservacion de `HABILIDADES`.

## Variante `INNER JOIN`
```sql
SELECT H.NOMBRE, COUNT(P.COD_POKEMON) AS TOTAL_POKEMON_RESISTENTES
FROM HABILIDADES H
INNER JOIN POKEMON P
    ON H.COD_HABILIDAD = P.COD_HABILIDAD
   AND P.COD_ZONA IS NOT NULL
   AND P.DEFENSA_BASE >= 70
GROUP BY H.NOMBRE
ORDER BY TOTAL_POKEMON_RESISTENTES DESC, H.NOMBRE ASC;
```

### Que pasa
La salida cambia mucho.

Con `INNER JOIN`, desaparecen las habilidades sin pokemon validos. La consulta original, en cambio, las mantenia con total `0`.

## Variante `RIGHT JOIN`
```sql
SELECT H.NOMBRE, COUNT(P.COD_POKEMON) AS TOTAL_POKEMON_RESISTENTES
FROM POKEMON P
RIGHT JOIN HABILIDADES H
    ON H.COD_HABILIDAD = P.COD_HABILIDAD
   AND P.COD_ZONA IS NOT NULL
   AND P.DEFENSA_BASE >= 70
GROUP BY H.NOMBRE
ORDER BY TOTAL_POKEMON_RESISTENTES DESC, H.NOMBRE ASC;
```

### Que pasa
La salida final coincide con la original.

`RIGHT JOIN` mantiene todas las habilidades, igual que hacia el `LEFT JOIN` original.

## Que pasa si muevo los filtros del `ON` al `WHERE`?
```sql
SELECT H.NOMBRE, COUNT(P.COD_POKEMON) AS TOTAL_POKEMON_RESISTENTES
FROM HABILIDADES H
LEFT JOIN POKEMON P
    ON H.COD_HABILIDAD = P.COD_HABILIDAD
WHERE P.COD_ZONA IS NOT NULL
  AND P.DEFENSA_BASE >= 70
GROUP BY H.NOMBRE
ORDER BY TOTAL_POKEMON_RESISTENTES DESC, H.NOMBRE ASC;
```

### Que pasa
La salida tambien cambia mucho.

Las habilidades sin coincidencias validas desaparecen por culpa del `WHERE`, asi que el `LEFT JOIN` deja de hacer el trabajo didactico que buscabamos.

## `COUNT(*)` y `COUNT(columna)`
El conteo correcto es `COUNT(P.COD_POKEMON)`.

- `COUNT(*)` daria `1` a una habilidad sin ningun pokemon valido.
- `COUNT(H.COD_HABILIDAD)` tambien seria enganoso por la misma razon: `HABILIDADES` es la tabla preservada.

Esta es otra situacion donde contar la columna equivocada cambia mucho el resultado.

---

<a id="ejercicio-19"></a>
# Ejercicio 19: Todos los objetos y en cuantos entrenadores aparecen con cantidad alta

## Enunciado completo
Muestra el nombre de todos los objetos y en cuantos entrenadores distintos aparece cada uno con cantidad mayor o igual que 10. Ordena por total descendente y nombre del objeto ascendente.

## Consulta original
```sql
SELECT O.NOMBRE,
       COUNT(DISTINCT EO.COD_ENTRENADOR) AS TOTAL_ENTRENADORES
FROM OBJETOS O
LEFT JOIN ENTRENADOR_OBJETO EO
    ON O.COD_OBJETO = EO.COD_OBJETO
   AND EO.CANTIDAD >= 10
GROUP BY O.NOMBRE
ORDER BY TOTAL_ENTRENADORES DESC, O.NOMBRE ASC;
```

## Idea del ejercicio
Queremos que todos los objetos salgan en la tabla final, aunque algunos no esten en ningun inventario con cantidad alta.

El filtro `EO.CANTIDAD >= 10` no forma parte de la FK. Justamente por eso debe ir en `ON`: queremos decidir que inventarios cuentan sin dejar de conservar todos los objetos.

## Variante `INNER JOIN`
```sql
SELECT O.NOMBRE,
       COUNT(DISTINCT EO.COD_ENTRENADOR) AS TOTAL_ENTRENADORES
FROM OBJETOS O
INNER JOIN ENTRENADOR_OBJETO EO
    ON O.COD_OBJETO = EO.COD_OBJETO
   AND EO.CANTIDAD >= 10
GROUP BY O.NOMBRE
ORDER BY TOTAL_ENTRENADORES DESC, O.NOMBRE ASC;
```

### Que pasa
La salida cambia mucho.

Con `INNER JOIN`, desaparecen todos los objetos que no tengan ningun entrenador con cantidad suficiente. En la original seguian apareciendo con total `0`.

## Variante `RIGHT JOIN`
```sql
SELECT O.NOMBRE,
       COUNT(DISTINCT EO.COD_ENTRENADOR) AS TOTAL_ENTRENADORES
FROM ENTRENADOR_OBJETO EO
RIGHT JOIN OBJETOS O
    ON O.COD_OBJETO = EO.COD_OBJETO
   AND EO.CANTIDAD >= 10
GROUP BY O.NOMBRE
ORDER BY TOTAL_ENTRENADORES DESC, O.NOMBRE ASC;
```

### Que pasa
La salida final coincide con la original.

`RIGHT JOIN` conserva `OBJETOS`, asi que mantiene visibles tambien los objetos sin coincidencias.

## Que pasa si muevo el filtro del `ON` al `WHERE`?
```sql
SELECT O.NOMBRE,
       COUNT(DISTINCT EO.COD_ENTRENADOR) AS TOTAL_ENTRENADORES
FROM OBJETOS O
LEFT JOIN ENTRENADOR_OBJETO EO
    ON O.COD_OBJETO = EO.COD_OBJETO
WHERE EO.CANTIDAD >= 10
GROUP BY O.NOMBRE
ORDER BY TOTAL_ENTRENADORES DESC, O.NOMBRE ASC;
```

### Que pasa
La salida vuelve a cambiar mucho.

Los objetos sin inventarios validos desaparecen antes de agrupar, asi que el `LEFT JOIN` pierde su sentido.

## `COUNT(*)` y `COUNT(columna)`
Aqui es especialmente facil equivocarse.

- El conteo correcto es `COUNT(DISTINCT EO.COD_ENTRENADOR)`.
- `COUNT(*)` estaria mal porque contaria la fila preservada del objeto aunque no haya coincidencia.
- `COUNT(O.COD_OBJETO)` tambien estaria mal porque `OBJETOS` es la tabla conservada.
- En este modelo, quitar `DISTINCT` no cambia el conteo de las filas reales porque la clave primaria `(COD_ENTRENADOR, COD_OBJETO)` impide repetir el mismo objeto para el mismo entrenador. En un modelo que permitiera duplicados, si cambiaria.

No solo importa contar la tabla correcta; a veces tambien importa contar en distinto.

---

<a id="ejercicio-20"></a>
# Ejercicio 20: Todos los entrenadores y cuantos pokemon muy experimentados tienen

## Enunciado completo
Muestra el nombre de todos los entrenadores y cuantos pokemon activos tiene cada uno con experiencia mayor o igual que 200000 y nivel mayor o igual que 50. Ordena por total descendente y nombre del entrenador ascendente.

## Consulta original
```sql
SELECT E.NOMBRE, COUNT(EP.COD_POKEMON) AS TOTAL_POKEMON_TOP
FROM ENTRENADOR E
LEFT JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
   AND EP.ESTADO = 'ACTIVO'
   AND EP.EXPERIENCIA >= 200000
   AND EP.NIVEL >= 50
GROUP BY E.NOMBRE
ORDER BY TOTAL_POKEMON_TOP DESC, E.NOMBRE ASC;
```

## Idea del ejercicio
Este ejercicio esta hecho para que se vea muy bien la diferencia entre:

- conservar a todos los entrenadores y mostrar `0`,
- o quedarse solo con los que si tienen pokemon muy fuertes.

Las condiciones de estado, experiencia y nivel no son parte de la FK. Van en `ON` porque queremos que solo cuenten esos pokemon, pero sin dejar de conservar todos los entrenadores.

## Variante `INNER JOIN`
```sql
SELECT E.NOMBRE, COUNT(EP.COD_POKEMON) AS TOTAL_POKEMON_TOP
FROM ENTRENADOR E
INNER JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
   AND EP.ESTADO = 'ACTIVO'
   AND EP.EXPERIENCIA >= 200000
   AND EP.NIVEL >= 50
GROUP BY E.NOMBRE
ORDER BY TOTAL_POKEMON_TOP DESC, E.NOMBRE ASC;
```

### Que pasa
La salida cambia mucho.

Con `INNER JOIN`, solo aparecen los entrenadores que si tienen al menos un pokemon de ese nivel de fuerza. En la original tambien aparecen los demas con total `0`.

## Variante `RIGHT JOIN`
```sql
SELECT E.NOMBRE, COUNT(EP.COD_POKEMON) AS TOTAL_POKEMON_TOP
FROM ENTRENADOR_POKEMON EP
RIGHT JOIN ENTRENADOR E
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
   AND EP.ESTADO = 'ACTIVO'
   AND EP.EXPERIENCIA >= 200000
   AND EP.NIVEL >= 50
GROUP BY E.NOMBRE
ORDER BY TOTAL_POKEMON_TOP DESC, E.NOMBRE ASC;
```

### Que pasa
La salida final coincide con la original.

Al conservar `ENTRENADOR`, `RIGHT JOIN` mantiene visibles tambien los entrenadores sin coincidencias.

## Que pasa si muevo los filtros del `ON` al `WHERE`?
```sql
SELECT E.NOMBRE, COUNT(EP.COD_POKEMON) AS TOTAL_POKEMON_TOP
FROM ENTRENADOR E
LEFT JOIN ENTRENADOR_POKEMON EP
    ON E.COD_ENTRENADOR = EP.COD_ENTRENADOR
WHERE EP.ESTADO = 'ACTIVO'
  AND EP.EXPERIENCIA >= 200000
  AND EP.NIVEL >= 50
GROUP BY E.NOMBRE
ORDER BY TOTAL_POKEMON_TOP DESC, E.NOMBRE ASC;
```

### Que pasa
La salida vuelve a cambiar mucho.

Los entrenadores sin pokemon validos desaparecen antes de agrupar, asi que el resultado pasa a parecerse al de `INNER JOIN`.

## `COUNT(*)` y `COUNT(columna)`
En esta consulta correcta debe usarse `COUNT(EP.COD_POKEMON)`.

- `COUNT(EP.COD_POKEMON)` devuelve `0` para un entrenador sin pokemon top.
- `COUNT(*)` devolveria `1` por la fila preservada del entrenador.
- `COUNT(E.COD_ENTRENADOR)` tambien seria incorrecto, porque `E` es la tabla que siempre se conserva.

Este ejercicio resume muy bien el problema tipico de los joins externos: si cuentas la columna equivocada, el numero deja de significar lo que crees que significa.

---

<a id="ejercicio-21"></a>
# Ejercicio 21: Pokemon muy ofensivos y rapidos

## Enunciado completo
Muestra el nombre, ataque base y velocidad base de los pokemon cuyo ataque base sea mayor que 100 y cuya velocidad base sea mayor que 80. Ordena por ataque descendente y nombre ascendente.

## Consulta original
```sql
SELECT NOMBRE, ATAQUE_BASE, VELOCIDAD_BASE
FROM POKEMON
WHERE ATAQUE_BASE > 100
  AND VELOCIDAD_BASE > 80
ORDER BY ATAQUE_BASE DESC, NOMBRE ASC;
```

## Idea del ejercicio
Este ejercicio se resuelve con una sola tabla. No hace falta hacer joins porque toda la informacion esta en `POKEMON`.

## Variante `LEFT JOIN`
```sql
-- No aplica: este ejercicio no necesita JOIN.
```

### Que pasa
No aplica. Forzar un `LEFT JOIN` aqui seria artificial y empeoraria la claridad.

## Variante `RIGHT JOIN`
```sql
-- No aplica: este ejercicio no necesita JOIN.
```

### Que pasa
No aplica por la misma razon.

## Â¿Que pasa si muevo el filtro del `WHERE` al `ON`?
```sql
-- No aplica: sin JOIN no existe clausula ON.
```

### Que pasa
No aplica. Aqui la clausula correcta es `WHERE`.

## Nota didactica adicional
En ejercicios sin join, la prioridad es distinguir bien entre:

- `SELECT` para elegir columnas,
- `WHERE` para filtrar filas,
- `ORDER BY` para ordenar.

---

<a id="ejercicio-22"></a>
# Ejercicio 22: Movimientos precisos pero no perfectos

## Enunciado completo
Muestra el nombre, potencia y precision de los movimientos cuya potencia sea mayor que 0 y cuya precision este entre 80 y 99. Ordena por precision ascendente y nombre ascendente.

## Consulta original
```sql
SELECT NOMBRE, POTENCIA, PRECISION_MOV
FROM MOVIMIENTOS
WHERE POTENCIA > 0
  AND PRECISION_MOV BETWEEN 80 AND 99
ORDER BY PRECISION_MOV ASC, NOMBRE ASC;
```

## Idea del ejercicio
Toda la informacion vive en `MOVIMIENTOS`, asi que no hay motivo para enlazar tablas.

## Variante `LEFT JOIN`
```sql
-- No aplica: este ejercicio no necesita JOIN.
```

### Que pasa
No aplica.

## Variante `RIGHT JOIN`
```sql
-- No aplica: este ejercicio no necesita JOIN.
```

### Que pasa
No aplica.

## Â¿Que pasa si muevo el filtro del `WHERE` al `ON`?
```sql
-- No aplica: sin JOIN no existe ON.
```

### Que pasa
No aplica.

## Nota didactica adicional
Este tipo de ejercicios sirve para practicar filtros compuestos en una sola tabla sin distraerte con joins.

---

<a id="ejercicio-23"></a>
# Ejercicio 23: Objetos de precio medio

## Enunciado completo
Muestra el nombre y el precio de los objetos cuyo precio este entre 200 y 2500. Ordena por precio ascendente y nombre ascendente.

## Consulta original
```sql
SELECT NOMBRE, PRECIO
FROM OBJETOS
WHERE PRECIO BETWEEN 200 AND 2500
ORDER BY PRECIO ASC, NOMBRE ASC;
```

## Idea del ejercicio
Es un ejemplo basico y limpio de consulta sin joins.

## Variante `LEFT JOIN`
```sql
-- No aplica: este ejercicio no necesita JOIN.
```

### Que pasa
No aplica.

## Variante `RIGHT JOIN`
```sql
-- No aplica: este ejercicio no necesita JOIN.
```

### Que pasa
No aplica.

## Â¿Que pasa si muevo el filtro del `WHERE` al `ON`?
```sql
-- No aplica: sin JOIN no existe ON.
```

### Que pasa
No aplica.

## Nota didactica adicional
Cuando una sola tabla basta, usar joins solo complica la consulta sin aportar nada.

---

<a id="ejercicio-24"></a>
# Ejercicio 24: Estados con al menos 3 registros de nivel alto

## Enunciado completo
Muestra el estado y cuantos registros hay en `ENTRENADOR_POKEMON`, pero solo teniendo en cuenta filas con nivel mayor o igual que 40. Haz que solo aparezcan los estados con al menos 3 registros. Ordena por total descendente y estado ascendente.

## Consulta original
```sql
SELECT ESTADO, COUNT(*) AS TOTAL_REGISTROS
FROM ENTRENADOR_POKEMON
WHERE NIVEL >= 40
GROUP BY ESTADO
HAVING COUNT(*) >= 3
ORDER BY TOTAL_REGISTROS DESC, ESTADO ASC;
```

## Idea del ejercicio
Aunque hay `GROUP BY`, sigue siendo un ejercicio sin joins. Toda la informacion necesaria ya esta en una sola tabla.

## Variante `LEFT JOIN`
```sql
-- No aplica: este ejercicio no necesita JOIN.
```

### Que pasa
No aplica.

## Variante `RIGHT JOIN`
```sql
-- No aplica: este ejercicio no necesita JOIN.
```

### Que pasa
No aplica.

## Â¿Que pasa si muevo el filtro del `WHERE` al `ON`?
```sql
-- No aplica: sin JOIN no existe ON.
```

### Que pasa
No aplica.

## `COUNT(*)` y `COUNT(columna)`
Como no hay joins, `COUNT(*)` es totalmente natural aqui: solo cuenta filas reales de `ENTRENADOR_POKEMON`.

No hay riesgo de contar filas preservadas con `NULL`, porque no existe join externo.

Si usaras `COUNT(ESTADO)`, tambien daria lo mismo porque `ESTADO` es `NOT NULL` en la tabla. Lo que si cambiaria el significado seria contar `COUNT(DISTINCT COD_POKEMON)`, porque ahi ya no contarias registros, sino especies distintas.

---

<a id="ejercicio-25"></a>
# Ejercicio 25: Zonas con al menos 2 pokemon sin hacer joins

## Enunciado completo
Muestra el codigo de zona y cuantos pokemon hay en cada una, excluyendo los pokemon sin zona. Haz que solo aparezcan las zonas con al menos 2 pokemon. Ordena por total descendente y codigo de zona ascendente.

## Consulta original
```sql
SELECT COD_ZONA, COUNT(*) AS TOTAL_POKEMON
FROM POKEMON
WHERE COD_ZONA IS NOT NULL
GROUP BY COD_ZONA
HAVING COUNT(*) >= 2
ORDER BY TOTAL_POKEMON DESC, COD_ZONA ASC;
```

## Idea del ejercicio
Este ejercicio demuestra que no siempre hace falta unir `MAPA`: si solo quieres el codigo de zona, `POKEMON` basta.

## Variante `LEFT JOIN`
```sql
-- No aplica: este ejercicio no necesita JOIN.
```

### Que pasa
No aplica.

## Variante `RIGHT JOIN`
```sql
-- No aplica: este ejercicio no necesita JOIN.
```

### Que pasa
No aplica.

## Â¿Que pasa si muevo el filtro del `WHERE` al `ON`?
```sql
-- No aplica: sin JOIN no existe ON.
```

### Que pasa
No aplica.

## `COUNT(*)` y `COUNT(columna)`
Aqui `COUNT(*)` es correcto porque solo contamos filas reales de `POKEMON` ya filtradas por `WHERE COD_ZONA IS NOT NULL`.

Si usaras `COUNT(COD_ZONA)`, el resultado seria el mismo porque el `WHERE` ya ha eliminado los `NULL`.

Tambien coincidiria con `COUNT(COD_POKEMON)` porque `COD_POKEMON` es clave primaria y nunca es `NULL`.

