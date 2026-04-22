# Simulacro enunciados

Recopilacion de los enunciados de los 25 ejercicios.

---

# Ejercicio 1

Muestra el nombre de la zona y cuantos pokemon hay en cada una, pero solo teniendo en cuenta los pokemon cuyo ataque base sea mayor que 60. Excluye los pokemon sin zona. Haz que solo aparezcan las zonas con al menos 2 pokemon. Ordena por total descendente y nombre de zona ascendente.

---

# Ejercicio 2

Muestra el nombre de todos los tipos y la velocidad media de los pokemon cuyo tipo primario sea ese tipo y cuya velocidad base sea mayor que 50. Haz que solo aparezcan los tipos cuya velocidad media sea superior a 75. Ordena por velocidad media descendente.

---

# Ejercicio 3

Muestra el nombre del entrenador y cuantos pokemon tiene registrados en `ENTRENADOR_POKEMON`, pero solo teniendo en cuenta los pokemon de nivel mayor o igual que 40 y con estado `ACTIVO`. Haz que solo aparezcan los entrenadores que tengan al menos 2 pokemon en esas condiciones. Ordena por total descendente y nombre del entrenador ascendente.

---

# Ejercicio 4

Muestra el nombre de todos los objetos y en cuantos inventarios aparece cada uno con cantidad mayor o igual que 10. Haz que solo aparezcan los objetos que esten en al menos 3 inventarios. Ordena por total descendente y nombre del objeto ascendente.

---

# Ejercicio 5

Muestra el nombre del pokemon y cuantos movimientos tiene aprendidos, pero solo teniendo en cuenta los movimientos aprendidos a nivel 20 o superior. Haz que solo aparezcan los pokemon que tengan al menos 2 movimientos en esas condiciones. Ordena por total descendente y nombre del pokemon ascendente.

---

# Ejercicio 6

Muestra el nombre de todos los entrenadores y cuantos pokemon distintos tiene cada uno en `ENTRENADOR_POKEMON` con nivel mayor o igual que 40. Haz que solo aparezcan los entrenadores que tengan al menos 3 pokemon distintos en esas condiciones. Ordena por total descendente y nombre del entrenador ascendente.



# Ejercicio 7

Muestra el nombre del tipo de los movimientos y cuantos movimientos distintos tiene cada tipo, pero solo teniendo en cuenta los movimientos con potencia mayor que 0 y precision mayor o igual que 90. Haz que solo aparezcan los tipos que tengan al menos 3 movimientos distintos y cuya potencia media sea superior a 75. Ordena por total descendente y nombre del tipo ascendente.

---

# Ejercicio 8

Muestra el nombre del entrenador y la experiencia minima, maxima y media de sus pokemon activos. Haz que solo aparezcan los entrenadores cuya experiencia media sea superior a 150000 y cuya experiencia maxima sea mayor o igual que 200000. Ordena por experiencia media descendente.

---

# Ejercicio 9

Muestra el nombre de todos los objetos y en cuantos entrenadores distintos aparece cada uno con cantidad mayor o igual que 10. Haz que solo aparezcan los objetos presentes en al menos 4 entrenadores distintos y cuya cantidad media sea superior a 15. Ordena por total de entrenadores descendente y nombre del objeto ascendente.

---

# Ejercicio 10

Muestra el nombre del tipo primario y el ataque medio de sus pokemon. Solo deben tenerse en cuenta pokemon con ataque base mayor que 50 y velocidad base mayor que 50, y ademas con habilidad asociada. Haz que solo aparezcan los tipos cuyo ataque medio sea superior a 80, cuya defensa minima sea mayor o igual que 55 y que tengan al menos 2 pokemon distintos en esas condiciones. Ordena por ataque medio descendente y nombre del tipo ascendente.

---

# Ejercicio 11

Muestra el nombre del pokemon y el nombre de su zona para los pokemon cuyo ataque base sea mayor o igual que 90. Excluye los pokemon sin zona. Ordena por ataque descendente y nombre del pokemon ascendente.

---

# Ejercicio 12

Muestra el nombre del entrenador, el nombre del pokemon y el nivel para los registros activos con nivel mayor o igual que 50. Ordena por nivel descendente y nombre del entrenador ascendente.

---

# Ejercicio 13

Muestra el nombre del objeto y la cantidad para los registros de inventario con cantidad mayor o igual que 15. Ordena por cantidad descendente y nombre del objeto ascendente.

---

# Ejercicio 14

Muestra el nombre del pokemon, el codigo del movimiento y el nivel de aprendizaje para los movimientos aprendidos a nivel 40 o superior. Ordena por nivel de aprendizaje descendente y nombre del pokemon ascendente.

---

# Ejercicio 15

Muestra el nombre de todos los tipos y el nombre del movimiento, pero solo teniendo en cuenta movimientos con potencia mayor que 100. Ordena por nombre del tipo ascendente y nombre del movimiento ascendente.

---

# Ejercicio 16

Muestra el nombre de todas las zonas y cuantos pokemon tiene cada una con velocidad base mayor o igual que 90. Ordena por total descendente y nombre de zona ascendente.

---

# Ejercicio 17

Muestra el nombre de todos los tipos primarios y cuantos pokemon tiene cada uno que ademas tengan tipo secundario y ataque base mayor que 80. Ordena por total descendente y nombre del tipo ascendente.

---

# Ejercicio 18

Muestra el nombre de todas las habilidades y cuantos pokemon tiene cada una, pero solo teniendo en cuenta pokemon con zona asignada y defensa base mayor o igual que 70. Ordena por total descendente y nombre de la habilidad ascendente.

---

# Ejercicio 19

Muestra el nombre de todos los objetos y en cuantos entrenadores distintos aparece cada uno con cantidad mayor o igual que 10. Ordena por total descendente y nombre del objeto ascendente.

---

# Ejercicio 20

Muestra el nombre de todos los entrenadores y cuantos pokemon activos tiene cada uno con experiencia mayor o igual que 200000 y nivel mayor o igual que 50. Ordena por total descendente y nombre del entrenador ascendente.

---

# Ejercicio 21

Muestra el nombre, ataque base y velocidad base de los pokemon cuyo ataque base sea mayor que 100 y cuya velocidad base sea mayor que 80. Ordena por ataque descendente y nombre ascendente.

---

# Ejercicio 22

Muestra el nombre, potencia y precision de los movimientos cuya potencia sea mayor que 0 y cuya precision este entre 80 y 99. Ordena por precision ascendente y nombre ascendente.

---

# Ejercicio 23

Muestra el nombre y el precio de los objetos cuyo precio este entre 200 y 2500. Ordena por precio ascendente y nombre ascendente.

---

# Ejercicio 24

Muestra el estado y cuantos registros hay en `ENTRENADOR_POKEMON`, pero solo teniendo en cuenta filas con nivel mayor o igual que 40. Haz que solo aparezcan los estados con al menos 3 registros. Ordena por total descendente y estado ascendente.

---

# Ejercicio 25

Muestra el codigo de zona y cuantos pokemon hay en cada una, excluyendo los pokemon sin zona. Haz que solo aparezcan las zonas con al menos 2 pokemon. Ordena por total descendente y codigo de zona ascendente.

# Ejercicio 26

Muestra el nombre del Pokémon y el nombre de los movimientos que sean del mismo tipo que el tipo primario del Pokémon. Solo deben aparecer movimientos con potencia mayor que 0. Ordena por nombre del Pokémon ascendente y nombre del movimiento ascendente.

SELECT P.NOMBRE AS POKEMON,
       M.NOMBRE AS MOVIMIENTO
FROM POKEMON P
INNER JOIN MOVIMIENTOS M
    ON P.COD_TIPO_1 = M.COD_TIPO
WHERE M.POTENCIA > 0
ORDER BY P.NOMBRE ASC, M.NOMBRE ASC;
