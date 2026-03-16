-- ================================================================
-- SCRIPT DE DATOS DE EJEMPLO - BASE DE DATOS POKEMON
-- ================================================================
-- Este script contiene datos de ejemplo para practicar consultas SQL
-- Ejecutar DESPUÉS de crear las tablas y aplicar las restricciones

-- ================================================================
-- LIMPIAR DATOS EXISTENTES (opcional)
-- ================================================================
DELETE FROM ENTRENADOR_OBJETO;
DELETE FROM ENTRENADOR_POKEMON;
DELETE FROM POKEMON_MOVIMIENTO;
DELETE FROM ENTRENADOR;
DELETE FROM MOVIMIENTOS;
DELETE FROM POKEMON;
DELETE FROM OBJETOS;
DELETE FROM MAPA;
DELETE FROM HABILIDADES;
DELETE FROM TIPOS;
COMMIT;

-- ================================================================
-- TIPOS (18 tipos del juego Pokémon)
-- ================================================================
INSERT INTO TIPOS VALUES (1, 'Fuego', 'Agua, Roca, Tierra', 'Planta, Hielo, Bicho, Acero');
INSERT INTO TIPOS VALUES (2, 'Agua', 'Planta, Eléctrico', 'Fuego, Hielo, Acero');
INSERT INTO TIPOS VALUES (3, 'Eléctrico', 'Tierra', 'Volador, Acero');
INSERT INTO TIPOS VALUES (4, 'Planta', 'Fuego, Hielo, Veneno, Volador, Bicho', 'Agua, Tierra, Roca');
INSERT INTO TIPOS VALUES (5, 'Hielo', 'Fuego, Lucha, Roca, Acero', 'Hielo');
INSERT INTO TIPOS VALUES (6, 'Lucha', 'Volador, Psíquico, Hada', 'Roca, Bicho, Siniestro');
INSERT INTO TIPOS VALUES (7, 'Veneno', 'Tierra, Psíquico', 'Planta, Lucha, Veneno, Bicho, Hada');
INSERT INTO TIPOS VALUES (8, 'Tierra', 'Agua, Planta, Hielo', 'Veneno, Roca');
INSERT INTO TIPOS VALUES (9, 'Volador', 'Eléctrico, Hielo, Roca', 'Planta, Lucha, Bicho');
INSERT INTO TIPOS VALUES (10, 'Psíquico', 'Bicho, Fantasma, Siniestro', 'Lucha, Psíquico');
INSERT INTO TIPOS VALUES (11, 'Bicho', 'Fuego, Volador, Roca', 'Planta, Lucha, Tierra');
INSERT INTO TIPOS VALUES (12, 'Roca', 'Agua, Planta, Lucha, Tierra, Acero', 'Normal, Fuego, Veneno, Volador');
INSERT INTO TIPOS VALUES (13, 'Fantasma', 'Fantasma, Siniestro', 'Veneno, Bicho');
INSERT INTO TIPOS VALUES (14, 'Dragón', 'Hielo, Dragón, Hada', 'Fuego, Agua, Planta, Eléctrico');
INSERT INTO TIPOS VALUES (15, 'Siniestro', 'Lucha, Bicho, Hada', 'Fantasma, Siniestro');
INSERT INTO TIPOS VALUES (16, 'Acero', 'Fuego, Lucha, Tierra', 'Normal, Planta, Hielo, Volador, Psíquico, Bicho, Roca, Dragón, Acero, Hada');
INSERT INTO TIPOS VALUES (17, 'Hada', 'Veneno, Acero', 'Lucha, Bicho, Siniestro');

-- ================================================================
-- HABILIDADES
-- ================================================================
INSERT INTO HABILIDADES VALUES (1, 'Mar Llamas', 'Potencia los movimientos de tipo Fuego', '+50% potencia cuando PS < 33%');
INSERT INTO HABILIDADES VALUES (2, 'Torrente', 'Potencia los movimientos de tipo Agua', '+50% potencia cuando PS < 33%');
INSERT INTO HABILIDADES VALUES (3, 'Electricidad Estática', 'Puede paralizar al contacto', '30% de paralizar al contacto');
INSERT INTO HABILIDADES VALUES (4, 'Espesura', 'Potencia los movimientos de tipo Planta', '+50% potencia cuando PS < 33%');
INSERT INTO HABILIDADES VALUES (5, 'Intimidación', 'Baja el Ataque del rival', 'Reduce Ataque rival en 1 nivel al entrar');
INSERT INTO HABILIDADES VALUES (6, 'Levitación', 'Inmunidad a movimientos de tipo Tierra', 'Evita todos los ataques de Tierra');
INSERT INTO HABILIDADES VALUES (7, 'Absorbe Agua', 'Recupera PS cuando es golpeado por Agua', 'Recupera 25% PS máx.');
INSERT INTO HABILIDADES VALUES (8, 'Clorofila', 'Duplica Velocidad con sol', 'x2 Velocidad en clima soleado');
INSERT INTO HABILIDADES VALUES (9, 'Nado Rápido', 'Duplica Velocidad con lluvia', 'x2 Velocidad en clima lluvioso');
INSERT INTO HABILIDADES VALUES (10, 'Escudo Mágico', 'Solo recibe daño de ataques directos', 'Inmune a cambios de estado');
INSERT INTO HABILIDADES VALUES (11, 'Piel Tosca', 'Daña al contacto', 'Rival pierde 1/8 PS al contacto');
INSERT INTO HABILIDADES VALUES (12, 'Efecto Espora', 'Puede envenenar, paralizar o dormir al contacto', '30% cada efecto');
INSERT INTO HABILIDADES VALUES (13, 'Sincronía', 'Pasa problemas de estado al rival', 'Comparte envenenamiento/parálisis/quemadura');
INSERT INTO HABILIDADES VALUES (14, 'Presión', 'Hace que el rival gaste más PP', 'El rival gasta 2 PP en vez de 1');
INSERT INTO HABILIDADES VALUES (15, 'Multitipo', 'Cambia de tipo según tabla que lleve', 'Tipo varía según objeto equipado');

-- ================================================================
-- MAPA (Zonas de Kanto, Johto y Hoenn)
-- ================================================================
-- Kanto
INSERT INTO MAPA VALUES (1, 'Pueblo Paleta', 'Kanto', 'Pueblo natal del Profesor Oak');
INSERT INTO MAPA VALUES (2, 'Bosque Verde', 'Kanto', 'Bosque lleno de pokémon bicho');
INSERT INTO MAPA VALUES (3, 'Monte Luna', 'Kanto', 'Cueva llena de pokémon roca y zubat');
INSERT INTO MAPA VALUES (4, 'Ciudad Celeste', 'Kanto', 'Ciudad junto al mar');
INSERT INTO MAPA VALUES (5, 'Torre Pokémon', 'Kanto', 'Torre donde habitan pokémon fantasma');
INSERT INTO MAPA VALUES (6, 'Ciudad Azafrán', 'Kanto', 'Ciudad con el gimnasio psíquico');
INSERT INTO MAPA VALUES (7, 'Isla Canela', 'Kanto', 'Isla volcánica con pokémon de fuego');
INSERT INTO MAPA VALUES (8, 'Cueva Celeste', 'Kanto', 'Cueva misteriosa donde habita Mewtwo');

-- Johto
INSERT INTO MAPA VALUES (9, 'Pueblo Primavera', 'Johto', 'Pueblo tranquilo rodeado de flores');
INSERT INTO MAPA VALUES (10, 'Encina', 'Johto', 'Ciudad famosa por sus torres gemelas');
INSERT INTO MAPA VALUES (11, 'Azalea', 'Johto', 'Pueblo rodeado de bosques');
INSERT INTO MAPA VALUES (12, 'Lago de la Furia', 'Johto', 'Lago donde habita Gyarados rojo');

-- Hoenn
INSERT INTO MAPA VALUES (13, 'Pueblo Raíz', 'Hoenn', 'Pequeño pueblo entre árboles');
INSERT INTO MAPA VALUES (14, 'Ruta 119', 'Hoenn', 'Ruta lluviosa con mucha vegetación');
INSERT INTO MAPA VALUES (15, 'Cueva Ancestral', 'Hoenn', 'Antigua cueva submarina');

-- ================================================================
-- POKEMON (50 pokémon variados)
-- ================================================================
-- Iniciales de Kanto
INSERT INTO POKEMON VALUES (1, 'Charmander', 39, 52, 43, 65, 1, NULL, 1, 1);
INSERT INTO POKEMON VALUES (4, 'Squirtle', 44, 48, 65, 43, 2, NULL, 2, 1);
INSERT INTO POKEMON VALUES (7, 'Bulbasaur', 45, 49, 49, 45, 4, 7, 4, 2);

-- Evoluciones
INSERT INTO POKEMON VALUES (5, 'Charmeleon', 58, 64, 58, 80, 1, NULL, 1, 7);
INSERT INTO POKEMON VALUES (6, 'Charizard', 78, 84, 78, 100, 1, 9, 1, 7);
INSERT INTO POKEMON VALUES (8, 'Wartortle', 59, 63, 80, 58, 2, NULL, 2, 4);
INSERT INTO POKEMON VALUES (9, 'Blastoise', 79, 83, 100, 78, 2, NULL, 2, 4);
INSERT INTO POKEMON VALUES (2, 'Ivysaur', 60, 62, 63, 60, 4, 7, 4, 2);
INSERT INTO POKEMON VALUES (3, 'Venusaur', 80, 82, 83, 80, 4, 7, 4, 2);

-- Pokémon comunes
INSERT INTO POKEMON VALUES (10, 'Caterpie', 45, 30, 35, 45, 11, NULL, 12, 2);
INSERT INTO POKEMON VALUES (11, 'Metapod', 50, 20, 55, 30, 11, NULL, 12, 2);
INSERT INTO POKEMON VALUES (12, 'Butterfree', 60, 45, 50, 70, 11, 9, 12, 2);
INSERT INTO POKEMON VALUES (13, 'Weedle', 40, 35, 30, 50, 11, 7, 12, 2);
INSERT INTO POKEMON VALUES (14, 'Kakuna', 45, 25, 50, 35, 11, 7, 12, 2);
INSERT INTO POKEMON VALUES (15, 'Beedrill', 65, 90, 40, 75, 11, 7, 12, 2);

-- Eléctricos
INSERT INTO POKEMON VALUES (25, 'Pikachu', 35, 55, 40, 90, 3, NULL, 3, 2);
INSERT INTO POKEMON VALUES (26, 'Raichu', 60, 90, 55, 110, 3, NULL, 3, 6);
INSERT INTO POKEMON VALUES (100, 'Voltorb', 40, 30, 50, 100, 3, NULL, 3, 6);
INSERT INTO POKEMON VALUES (101, 'Electrode', 60, 50, 70, 150, 3, NULL, 3, 6);

-- Psíquicos
INSERT INTO POKEMON VALUES (63, 'Abra', 25, 20, 15, 90, 10, NULL, 13, 6);
INSERT INTO POKEMON VALUES (64, 'Kadabra', 40, 35, 30, 105, 10, NULL, 13, 6);
INSERT INTO POKEMON VALUES (65, 'Alakazam', 55, 50, 45, 120, 10, NULL, 13, 6);

-- Agua
INSERT INTO POKEMON VALUES (54, 'Psyduck', 50, 52, 48, 55, 2, NULL, 7, 4);
INSERT INTO POKEMON VALUES (55, 'Golduck', 80, 82, 78, 85, 2, NULL, 9, 4);
INSERT INTO POKEMON VALUES (129, 'Magikarp', 20, 10, 55, 80, 2, NULL, 9, 12);
INSERT INTO POKEMON VALUES (130, 'Gyarados', 95, 125, 79, 81, 2, 9, 5, 12);

-- Fantasmas
INSERT INTO POKEMON VALUES (92, 'Gastly', 30, 35, 30, 80, 13, 7, 6, 5);
INSERT INTO POKEMON VALUES (93, 'Haunter', 45, 50, 45, 95, 13, 7, 6, 5);
INSERT INTO POKEMON VALUES (94, 'Gengar', 60, 65, 60, 110, 13, 7, 6, 5);

-- Dragones
INSERT INTO POKEMON VALUES (147, 'Dratini', 41, 64, 45, 50, 14, NULL, 12, 15);
INSERT INTO POKEMON VALUES (148, 'Dragonair', 61, 84, 65, 70, 14, NULL, 12, 15);
INSERT INTO POKEMON VALUES (149, 'Dragonite', 91, 134, 95, 80, 14, 9, 14, 15);

-- Legendarios
INSERT INTO POKEMON VALUES (144, 'Articuno', 90, 85, 100, 85, 5, 9, 14, NULL);
INSERT INTO POKEMON VALUES (145, 'Zapdos', 90, 90, 85, 100, 3, 9, 14, NULL);
INSERT INTO POKEMON VALUES (146, 'Moltres', 90, 100, 90, 90, 1, 9, 14, 7);
INSERT INTO POKEMON VALUES (150, 'Mewtwo', 106, 110, 90, 130, 10, NULL, 14, 8);
INSERT INTO POKEMON VALUES (151, 'Mew', 100, 100, 100, 100, 10, NULL, 13, NULL);

-- Johto
INSERT INTO POKEMON VALUES (152, 'Chikorita', 45, 49, 65, 45, 4, NULL, 4, 9);
INSERT INTO POKEMON VALUES (155, 'Cyndaquil', 39, 52, 43, 65, 1, NULL, 1, 9);
INSERT INTO POKEMON VALUES (158, 'Totodile', 50, 65, 64, 43, 2, NULL, 2, 9);
INSERT INTO POKEMON VALUES (172, 'Pichu', 20, 40, 15, 60, 3, NULL, 3, 9);
INSERT INTO POKEMON VALUES (175, 'Togepi', 35, 20, 65, 20, 17, NULL, 10, 10);
INSERT INTO POKEMON VALUES (249, 'Lugia', 106, 90, 130, 110, 10, 9, 14, NULL);
INSERT INTO POKEMON VALUES (250, 'Ho-Oh', 106, 130, 90, 90, 1, 9, 14, 10);

-- Hoenn
INSERT INTO POKEMON VALUES (252, 'Treecko', 40, 45, 35, 70, 4, NULL, 4, 13);
INSERT INTO POKEMON VALUES (255, 'Torchic', 45, 60, 40, 45, 1, NULL, 1, 13);
INSERT INTO POKEMON VALUES (258, 'Mudkip', 50, 70, 50, 40, 2, NULL, 2, 13);
INSERT INTO POKEMON VALUES (280, 'Ralts', 28, 25, 25, 40, 10, 17, 13, 13);
INSERT INTO POKEMON VALUES (382, 'Kyogre', 100, 100, 90, 90, 2, NULL, 14, 15);
INSERT INTO POKEMON VALUES (383, 'Groudon', 100, 150, 140, 90, 8, NULL, 14, NULL);

-- ================================================================
-- MOVIMIENTOS (50 movimientos variados)
-- ================================================================
-- Fuego
INSERT INTO MOVIMIENTOS VALUES (1, 'Ascuas', 40, 100, 25, 'ESPECIAL', 1);
INSERT INTO MOVIMIENTOS VALUES (2, 'Lanzallamas', 90, 100, 15, 'ESPECIAL', 1);
INSERT INTO MOVIMIENTOS VALUES (3, 'Giro Fuego', 35, 85, 15, 'FISICO', 1);
INSERT INTO MOVIMIENTOS VALUES (4, 'Sofoco', 120, 100, 5, 'ESPECIAL', 1);
INSERT INTO MOVIMIENTOS VALUES (5, 'Pirotecnia', 70, 100, 15, 'ESPECIAL', 1);

-- Agua
INSERT INTO MOVIMIENTOS VALUES (6, 'Pistola Agua', 40, 100, 25, 'ESPECIAL', 2);
INSERT INTO MOVIMIENTOS VALUES (7, 'Hidrobomba', 110, 80, 5, 'ESPECIAL', 2);
INSERT INTO MOVIMIENTOS VALUES (8, 'Surf', 90, 100, 15, 'ESPECIAL', 2);
INSERT INTO MOVIMIENTOS VALUES (9, 'Cascada', 80, 100, 15, 'FISICO', 2);
INSERT INTO MOVIMIENTOS VALUES (10, 'Rayo Burbuja', 65, 100, 20, 'ESPECIAL', 2);

-- Eléctrico
INSERT INTO MOVIMIENTOS VALUES (11, 'Impactrueno', 40, 100, 30, 'ESPECIAL', 3);
INSERT INTO MOVIMIENTOS VALUES (12, 'Rayo', 90, 100, 15, 'ESPECIAL', 3);
INSERT INTO MOVIMIENTOS VALUES (13, 'Trueno', 110, 70, 10, 'ESPECIAL', 3);
INSERT INTO MOVIMIENTOS VALUES (14, 'Chispa', 65, 100, 20, 'FISICO', 3);
INSERT INTO MOVIMIENTOS VALUES (15, 'Onda Trueno', 0, 90, 20, 'ESTADO', 3);

-- Planta
INSERT INTO MOVIMIENTOS VALUES (16, 'Látigo Cepa', 45, 100, 25, 'FISICO', 4);
INSERT INTO MOVIMIENTOS VALUES (17, 'Hoja Afilada', 55, 95, 25, 'FISICO', 4);
INSERT INTO MOVIMIENTOS VALUES (18, 'Rayo Solar', 120, 100, 10, 'ESPECIAL', 4);
INSERT INTO MOVIMIENTOS VALUES (19, 'Bomba Germen', 80, 100, 15, 'ESPECIAL', 4);
INSERT INTO MOVIMIENTOS VALUES (20, 'Drenadoras', 20, 100, 25, 'ESPECIAL', 4);

-- Hielo
INSERT INTO MOVIMIENTOS VALUES (21, 'Rayo Hielo', 90, 100, 10, 'ESPECIAL', 5);
INSERT INTO MOVIMIENTOS VALUES (22, 'Ventisca', 110, 70, 5, 'ESPECIAL', 5);
INSERT INTO MOVIMIENTOS VALUES (23, 'Viento Hielo', 55, 95, 15, 'ESPECIAL', 5);
INSERT INTO MOVIMIENTOS VALUES (24, 'Nieve Polvo', 40, 100, 25, 'ESPECIAL', 5);

-- Lucha
INSERT INTO MOVIMIENTOS VALUES (25, 'Patada Baja', 65, 100, 20, 'FISICO', 6);
INSERT INTO MOVIMIENTOS VALUES (26, 'Onda Vacío', 40, 100, 30, 'ESPECIAL', 6);
INSERT INTO MOVIMIENTOS VALUES (27, 'A Bocajarro', 120, 100, 5, 'FISICO', 6);
INSERT INTO MOVIMIENTOS VALUES (28, 'Karate', 50, 100, 25, 'FISICO', 6);

-- Veneno
INSERT INTO MOVIMIENTOS VALUES (29, 'Ácido', 40, 100, 30, 'ESPECIAL', 7);
INSERT INTO MOVIMIENTOS VALUES (30, 'Púas Tóxicas', 80, 100, 10, 'FISICO', 7);
INSERT INTO MOVIMIENTOS VALUES (31, 'Residuos', 65, 100, 20, 'ESPECIAL', 7);

-- Psíquico
INSERT INTO MOVIMIENTOS VALUES (32, 'Confusión', 50, 100, 25, 'ESPECIAL', 10);
INSERT INTO MOVIMIENTOS VALUES (33, 'Psíquico', 90, 100, 10, 'ESPECIAL', 10);
INSERT INTO MOVIMIENTOS VALUES (34, 'Psicocorte', 70, 100, 20, 'FISICO', 10);
INSERT INTO MOVIMIENTOS VALUES (35, 'Psicorrayo', 65, 100, 20, 'ESPECIAL', 10);

-- Fantasma
INSERT INTO MOVIMIENTOS VALUES (36, 'Lengüetazo', 30, 100, 30, 'FISICO', 13);
INSERT INTO MOVIMIENTOS VALUES (37, 'Bola Sombra', 80, 100, 15, 'ESPECIAL', 13);
INSERT INTO MOVIMIENTOS VALUES (38, 'Rayo Confuso', 50, 100, 10, 'ESPECIAL', 13);

-- Dragón
INSERT INTO MOVIMIENTOS VALUES (39, 'Furia Dragón', 40, 100, 10, 'ESPECIAL', 14);
INSERT INTO MOVIMIENTOS VALUES (40, 'Pulso Dragón', 85, 100, 10, 'ESPECIAL', 14);
INSERT INTO MOVIMIENTOS VALUES (41, 'Garra Dragón', 80, 100, 15, 'FISICO', 14);
INSERT INTO MOVIMIENTOS VALUES (42, 'Cometa Draco', 130, 90, 5, 'ESPECIAL', 14);

-- Normal (ataques básicos)
INSERT INTO MOVIMIENTOS VALUES (43, 'Placaje', 40, 100, 35, 'FISICO', 1);
INSERT INTO MOVIMIENTOS VALUES (44, 'Arañazo', 40, 100, 35, 'FISICO', 1);
INSERT INTO MOVIMIENTOS VALUES (45, 'Destructor', 40, 100, 35, 'FISICO', 6);
INSERT INTO MOVIMIENTOS VALUES (46, 'Hiperrayo', 150, 90, 5, 'ESPECIAL', 1);
INSERT INTO MOVIMIENTOS VALUES (47, 'Rapidez', 60, 999, 20, 'ESPECIAL', 1);
INSERT INTO MOVIMIENTOS VALUES (48, 'Megapuño', 80, 85, 20, 'FISICO', 1);

-- ================================================================
-- OBJETOS
-- ================================================================
-- Pociones
INSERT INTO OBJETOS VALUES (1, 'Poción', 'Restaura 20 PS de un pokémon', 300, 'Cura 20 PS');
INSERT INTO OBJETOS VALUES (2, 'Superpoción', 'Restaura 50 PS de un pokémon', 700, 'Cura 50 PS');
INSERT INTO OBJETOS VALUES (3, 'Hiperpoción', 'Restaura 200 PS de un pokémon', 1200, 'Cura 200 PS');
INSERT INTO OBJETOS VALUES (4, 'Poción Máxima', 'Restaura todos los PS de un pokémon', 2500, 'Cura 100% PS');
INSERT INTO OBJETOS VALUES (5, 'Restaurar Todo', 'Restaura PS y cura problemas de estado', 3000, 'Cura todo');

-- Pokéballs
INSERT INTO OBJETOS VALUES (6, 'Pokéball', 'Dispositivo para capturar pokémon', 200, 'Captura básica x1');
INSERT INTO OBJETOS VALUES (7, 'Superball', 'Pokéball con mayor probabilidad de captura', 600, 'Captura x1.5');
INSERT INTO OBJETOS VALUES (8, 'Ultraball', 'Pokéball de alta tecnología', 1200, 'Captura x2');
INSERT INTO OBJETOS VALUES (9, 'Ball Maestra', 'Captura cualquier pokémon sin fallar', 0, 'Captura 100%');

-- Curas de estado
INSERT INTO OBJETOS VALUES (10, 'Antídoto', 'Cura el envenenamiento', 100, 'Elimina veneno');
INSERT INTO OBJETOS VALUES (11, 'Antiparalizador', 'Cura la parálisis', 200, 'Elimina parálisis');
INSERT INTO OBJETOS VALUES (12, 'Despertar', 'Despierta a un pokémon dormido', 250, 'Elimina sueño');
INSERT INTO OBJETOS VALUES (13, 'Antihielo', 'Descongela a un pokémon', 250, 'Elimina congelación');
INSERT INTO OBJETOS VALUES (14, 'Antiquemar', 'Cura las quemaduras', 250, 'Elimina quemadura');

-- Potenciadores
INSERT INTO OBJETOS VALUES (15, 'Proteína', 'Aumenta el Ataque base de un pokémon', 9800, '+1 EV Ataque');
INSERT INTO OBJETOS VALUES (16, 'Hierro', 'Aumenta la Defensa base de un pokémon', 9800, '+1 EV Defensa');
INSERT INTO OBJETOS VALUES (17, 'Calcio', 'Aumenta el Ataque Especial base', 9800, '+1 EV At.Esp');
INSERT INTO OBJETOS VALUES (18, 'Zinc', 'Aumenta la Defensa Especial base', 9800, '+1 EV Def.Esp');
INSERT INTO OBJETOS VALUES (19, 'Caramelo Raro', 'Sube el nivel de un pokémon en 1', 10000, '+1 nivel');
INSERT INTO OBJETOS VALUES (20, 'Piedra Trueno', 'Hace evolucionar a ciertos pokémon', 2100, 'Evoluciona eléctricos');

-- ================================================================
-- ENTRENADORES
-- ================================================================
INSERT INTO ENTRENADOR VALUES (1, 'Ash Ketchum', '12345678A', 1);
INSERT INTO ENTRENADOR VALUES (2, 'Misty Waterflower', '87654321B', 4);
INSERT INTO ENTRENADOR VALUES (3, 'Brock Harrison', '11111111C', 3);
INSERT INTO ENTRENADOR VALUES (4, 'Gary Oak', '22222222D', 1);
INSERT INTO ENTRENADOR VALUES (5, 'Lance Blackthorn', '33333333E', NULL);
INSERT INTO ENTRENADOR VALUES (6, 'Sabrina Psychic', '44444444F', 6);
INSERT INTO ENTRENADOR VALUES (7, 'Giovanni Rocket', '55555555G', NULL);
INSERT INTO ENTRENADOR VALUES (8, 'Blaine Volcano', '66666666H', 7);
INSERT INTO ENTRENADOR VALUES (9, 'Erika Garden', '77777777I', 4);
INSERT INTO ENTRENADOR VALUES (10, 'Surge Lightning', '88888888J', 4);
INSERT INTO ENTRENADOR VALUES (11, 'Red Champion', '99999999K', 8);
INSERT INTO ENTRENADOR VALUES (12, 'Blue Rival', '10101010L', 1);
INSERT INTO ENTRENADOR VALUES (13, 'Silver Mysterious', '11011011M', 9);
INSERT INTO ENTRENADOR VALUES (14, 'Gold Trainer', '12012012N', 9);
INSERT INTO ENTRENADOR VALUES (15, 'Crystal Explorer', '13013013O', 10);

-- ================================================================
-- POKEMON_MOVIMIENTO (qué movimientos aprende cada pokémon)
-- ================================================================
-- Charmander
INSERT INTO POKEMON_MOVIMIENTO VALUES (1, 1, 1);   -- Ascuas nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (1, 43, 1);  -- Placaje nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (1, 2, 16);  -- Lanzallamas nivel 16
INSERT INTO POKEMON_MOVIMIENTO VALUES (1, 3, 24);  -- Giro Fuego nivel 24

-- Charizard
INSERT INTO POKEMON_MOVIMIENTO VALUES (6, 2, 1);   -- Lanzallamas nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (6, 4, 36);  -- Sofoco nivel 36
INSERT INTO POKEMON_MOVIMIENTO VALUES (6, 39, 40); -- Furia Dragón nivel 40
INSERT INTO POKEMON_MOVIMIENTO VALUES (6, 9, 45);  -- Cascada nivel 45

-- Squirtle
INSERT INTO POKEMON_MOVIMIENTO VALUES (4, 6, 1);   -- Pistola Agua nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (4, 43, 1);  -- Placaje nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (4, 10, 12); -- Rayo Burbuja nivel 12
INSERT INTO POKEMON_MOVIMIENTO VALUES (4, 8, 28);  -- Surf nivel 28

-- Blastoise
INSERT INTO POKEMON_MOVIMIENTO VALUES (9, 7, 1);   -- Hidrobomba nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (9, 8, 1);   -- Surf nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (9, 9, 20);  -- Cascada nivel 20
INSERT INTO POKEMON_MOVIMIENTO VALUES (9, 21, 30); -- Rayo Hielo nivel 30

-- Bulbasaur
INSERT INTO POKEMON_MOVIMIENTO VALUES (7, 16, 1);  -- Látigo Cepa nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (7, 43, 1);  -- Placaje nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (7, 17, 13); -- Hoja Afilada nivel 13
INSERT INTO POKEMON_MOVIMIENTO VALUES (7, 18, 32); -- Rayo Solar nivel 32

-- Venusaur
INSERT INTO POKEMON_MOVIMIENTO VALUES (3, 18, 1);  -- Rayo Solar nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (3, 19, 1);  -- Bomba Germen nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (3, 29, 25); -- Ácido nivel 25
INSERT INTO POKEMON_MOVIMIENTO VALUES (3, 8, 40);  -- Surf nivel 40

-- Pikachu
INSERT INTO POKEMON_MOVIMIENTO VALUES (25, 11, 1);  -- Impactrueno nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (25, 14, 10); -- Chispa nivel 10
INSERT INTO POKEMON_MOVIMIENTO VALUES (25, 12, 26); -- Rayo nivel 26
INSERT INTO POKEMON_MOVIMIENTO VALUES (25, 13, 42); -- Trueno nivel 42

-- Raichu
INSERT INTO POKEMON_MOVIMIENTO VALUES (26, 12, 1);  -- Rayo nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (26, 13, 1);  -- Trueno nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (26, 11, 1);  -- Impactrueno nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (26, 47, 30); -- Rapidez nivel 30

-- Gengar
INSERT INTO POKEMON_MOVIMIENTO VALUES (94, 36, 1);  -- Lengüetazo nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (94, 37, 25); -- Bola Sombra nivel 25
INSERT INTO POKEMON_MOVIMIENTO VALUES (94, 33, 35); -- Psíquico nivel 35
INSERT INTO POKEMON_MOVIMIENTO VALUES (94, 12, 40); -- Rayo nivel 40

-- Alakazam
INSERT INTO POKEMON_MOVIMIENTO VALUES (65, 32, 1);  -- Confusión nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (65, 33, 16); -- Psíquico nivel 16
INSERT INTO POKEMON_MOVIMIENTO VALUES (65, 34, 30); -- Psicocorte nivel 30
INSERT INTO POKEMON_MOVIMIENTO VALUES (65, 35, 40); -- Psicorrayo nivel 40

-- Gyarados
INSERT INTO POKEMON_MOVIMIENTO VALUES (130, 7, 1);   -- Hidrobomba nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (130, 8, 1);   -- Surf nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (130, 41, 32); -- Garra Dragón nivel 32
INSERT INTO POKEMON_MOVIMIENTO VALUES (130, 21, 40); -- Rayo Hielo nivel 40

-- Dragonite
INSERT INTO POKEMON_MOVIMIENTO VALUES (149, 40, 1);  -- Pulso Dragón nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (149, 41, 1);  -- Garra Dragón nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (149, 42, 61); -- Cometa Draco nivel 61
INSERT INTO POKEMON_MOVIMIENTO VALUES (149, 46, 55); -- Hiperrayo nivel 55

-- Mewtwo
INSERT INTO POKEMON_MOVIMIENTO VALUES (150, 33, 1);  -- Psíquico nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (150, 32, 1);  -- Confusión nivel 1
INSERT INTO POKEMON_MOVIMIENTO VALUES (150, 47, 50); -- Rapidez nivel 50
INSERT INTO POKEMON_MOVIMIENTO VALUES (150, 21, 70); -- Rayo Hielo nivel 70

-- Más movimientos para variedad
INSERT INTO POKEMON_MOVIMIENTO VALUES (54, 6, 1);   -- Psyduck - Pistola Agua
INSERT INTO POKEMON_MOVIMIENTO VALUES (54, 32, 15); -- Psyduck - Confusión
INSERT INTO POKEMON_MOVIMIENTO VALUES (55, 8, 1);   -- Golduck - Surf
INSERT INTO POKEMON_MOVIMIENTO VALUES (55, 33, 1);  -- Golduck - Psíquico
INSERT INTO POKEMON_MOVIMIENTO VALUES (144, 21, 1); -- Articuno - Rayo Hielo
INSERT INTO POKEMON_MOVIMIENTO VALUES (144, 22, 1); -- Articuno - Ventisca
INSERT INTO POKEMON_MOVIMIENTO VALUES (145, 12, 1); -- Zapdos - Rayo
INSERT INTO POKEMON_MOVIMIENTO VALUES (145, 13, 1); -- Zapdos - Trueno
INSERT INTO POKEMON_MOVIMIENTO VALUES (146, 2, 1);  -- Moltres - Lanzallamas
INSERT INTO POKEMON_MOVIMIENTO VALUES (146, 4, 1);  -- Moltres - Sofoco

-- ================================================================
-- ENTRENADOR_POKEMON (equipos de los entrenadores)
-- ================================================================
-- Ash (el protagonista - equipo balanceado)
INSERT INTO ENTRENADOR_POKEMON VALUES (1, 25, 'Pikachu', 45, 35, 125000, 'ACTIVO', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (1, 6, 'Rizardon', 50, 78, 180000, 'ACTIVO', TO_DATE('2024-02-20', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (1, 12, NULL, 35, 60, 85000, 'EN_PC', TO_DATE('2024-01-18', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (1, 54, NULL, 28, 50, 45000, 'EN_PC', TO_DATE('2024-03-10', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (1, 130, 'Gyara', 42, 95, 150000, 'ACTIVO', TO_DATE('2024-04-05', 'YYYY-MM-DD'));

-- Misty (especialista agua)
INSERT INTO ENTRENADOR_POKEMON VALUES (2, 4, 'Squirtle', 38, 44, 95000, 'ACTIVO', TO_DATE('2024-01-10', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (2, 55, 'Golduck', 42, 80, 120000, 'ACTIVO', TO_DATE('2024-02-14', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (2, 130, 'Red Gyarados', 55, 95, 200000, 'ACTIVO', TO_DATE('2024-03-20', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (2, 9, 'Blastoise', 52, 79, 185000, 'ACTIVO', TO_DATE('2024-04-01', 'YYYY-MM-DD'));

-- Brock (especialista roca)
INSERT INTO ENTRENADOR_POKEMON VALUES (3, 7, 'Bulby', 35, 45, 80000, 'ACTIVO', TO_DATE('2024-01-05', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (3, 3, 'Venusaur', 48, 80, 155000, 'ACTIVO', TO_DATE('2024-02-28', 'YYYY-MM-DD'));

-- Gary (rival - equipo fuerte)
INSERT INTO ENTRENADOR_POKEMON VALUES (4, 9, 'Blastoise', 55, 79, 195000, 'ACTIVO', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (4, 26, 'Raichu', 48, 60, 145000, 'ACTIVO', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (4, 65, 'Alakazam', 52, 55, 175000, 'ACTIVO', TO_DATE('2024-02-10', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (4, 94, 'Gengar', 50, 60, 168000, 'ACTIVO', TO_DATE('2024-02-25', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (4, 149, 'Dragonite', 58, 91, 225000, 'ACTIVO', TO_DATE('2024-04-15', 'YYYY-MM-DD'));

-- Lance (maestro dragón)
INSERT INTO ENTRENADOR_POKEMON VALUES (5, 147, 'Dratini Jr', 25, 41, 35000, 'EN_PC', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (5, 148, 'Dragonair', 48, 61, 155000, 'ACTIVO', TO_DATE('2024-02-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (5, 149, 'Dragonite', 62, 91, 250000, 'ACTIVO', TO_DATE('2024-03-15', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (5, 130, 'Gyarados', 58, 95, 220000, 'ACTIVO', TO_DATE('2024-03-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (5, 6, 'Charizard', 60, 78, 235000, 'ACTIVO', TO_DATE('2024-03-20', 'YYYY-MM-DD'));

-- Sabrina (maestra psíquica)
INSERT INTO ENTRENADOR_POKEMON VALUES (6, 63, NULL, 30, 25, 50000, 'EN_PC', TO_DATE('2024-01-05', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (6, 64, 'Kadabra', 42, 40, 115000, 'ACTIVO', TO_DATE('2024-02-10', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (6, 65, 'Alakazam', 55, 55, 195000, 'ACTIVO', TO_DATE('2024-03-25', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (6, 150, 'Mewtwo', 70, 106, 350000, 'ACTIVO', TO_DATE('2024-04-20', 'YYYY-MM-DD'));

-- Giovanni (jefe Team Rocket)
INSERT INTO ENTRENADOR_POKEMON VALUES (7, 150, 'Mewtwo Clone', 75, 106, 400000, 'ACTIVO', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (7, 94, 'Gengar', 60, 60, 235000, 'ACTIVO', TO_DATE('2024-02-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (7, 149, 'Dragonite', 65, 91, 285000, 'ACTIVO', TO_DATE('2024-03-01', 'YYYY-MM-DD'));

-- Blaine (maestro fuego)
INSERT INTO ENTRENADOR_POKEMON VALUES (8, 1, NULL, 25, 39, 35000, 'EN_PC', TO_DATE('2024-01-10', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (8, 5, 'Charmeleon', 38, 58, 95000, 'ACTIVO', TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (8, 6, 'Charizard', 55, 78, 205000, 'ACTIVO', TO_DATE('2024-04-10', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (8, 146, 'Moltres', 60, 90, 240000, 'ACTIVO', TO_DATE('2024-04-25', 'YYYY-MM-DD'));

-- Red (campeón)
INSERT INTO ENTRENADOR_POKEMON VALUES (11, 25, 'Pikachu Legend', 88, 35, 550000, 'ACTIVO', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (11, 3, 'Venusaur', 84, 80, 485000, 'ACTIVO', TO_DATE('2023-02-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (11, 6, 'Charizard', 84, 78, 485000, 'ACTIVO', TO_DATE('2023-02-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (11, 9, 'Blastoise', 84, 79, 485000, 'ACTIVO', TO_DATE('2023-02-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (11, 149, 'Dragonite', 85, 91, 495000, 'ACTIVO', TO_DATE('2023-03-15', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (11, 151, 'Mew', 86, 100, 510000, 'ACTIVO', TO_DATE('2023-05-01', 'YYYY-MM-DD'));

-- Más entrenadores con pocos pokémon
INSERT INTO ENTRENADOR_POKEMON VALUES (9, 7, 'Bulbasaur', 32, 45, 75000, 'ACTIVO', TO_DATE('2024-03-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (9, 2, 'Ivysaur', 36, 60, 88000, 'ACTIVO', TO_DATE('2024-03-15', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (10, 25, 'Pikachu', 40, 35, 110000, 'ACTIVO', TO_DATE('2024-02-20', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (10, 100, 'Voltorb', 28, 40, 52000, 'ACTIVO', TO_DATE('2024-03-05', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (12, 4, NULL, 35, 44, 82000, 'ACTIVO', TO_DATE('2024-02-10', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (13, 155, NULL, 18, 39, 28000, 'ACTIVO', TO_DATE('2024-04-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (14, 158, NULL, 20, 50, 32000, 'ACTIVO', TO_DATE('2024-04-05', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_POKEMON VALUES (15, 152, NULL, 22, 45, 38000, 'ACTIVO', TO_DATE('2024-04-10', 'YYYY-MM-DD'));

-- ================================================================
-- ENTRENADOR_OBJETO (inventarios de los entrenadores)
-- ================================================================
-- Ash
INSERT INTO ENTRENADOR_OBJETO VALUES (1, 1, 15, 'N', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (1, 2, 8, 'N', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (1, 6, 25, 'S', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (1, 7, 10, 'N', TO_DATE('2024-02-10', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (1, 10, 5, 'N', TO_DATE('2024-01-20', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (1, 19, 3, 'N', TO_DATE('2024-03-15', 'YYYY-MM-DD'));

-- Misty
INSERT INTO ENTRENADOR_OBJETO VALUES (2, 1, 20, 'N', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (2, 3, 12, 'S', TO_DATE('2024-02-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (2, 6, 30, 'N', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (2, 11, 8, 'N', TO_DATE('2024-02-15', 'YYYY-MM-DD'));

-- Brock
INSERT INTO ENTRENADOR_OBJETO VALUES (3, 1, 25, 'N', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (3, 2, 15, 'S', TO_DATE('2024-01-10', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (3, 5, 5, 'N', TO_DATE('2024-03-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (3, 15, 10, 'N', TO_DATE('2024-02-20', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (3, 16, 10, 'N', TO_DATE('2024-02-20', 'YYYY-MM-DD'));

-- Gary
INSERT INTO ENTRENADOR_OBJETO VALUES (4, 3, 50, 'N', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (4, 4, 20, 'S', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (4, 8, 40, 'N', TO_DATE('2024-02-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (4, 15, 15, 'N', TO_DATE('2024-01-20', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (4, 16, 15, 'N', TO_DATE('2024-01-20', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (4, 17, 15, 'N', TO_DATE('2024-01-20', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (4, 19, 10, 'N', TO_DATE('2024-03-10', 'YYYY-MM-DD'));

-- Lance
INSERT INTO ENTRENADOR_OBJETO VALUES (5, 4, 99, 'S', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (5, 5, 30, 'N', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (5, 8, 50, 'N', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (5, 19, 25, 'N', TO_DATE('2024-02-01', 'YYYY-MM-DD'));

-- Sabrina
INSERT INTO ENTRENADOR_OBJETO VALUES (6, 2, 30, 'N', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (6, 4, 15, 'S', TO_DATE('2024-02-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (6, 8, 35, 'N', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (6, 17, 20, 'N', TO_DATE('2024-03-01', 'YYYY-MM-DD'));

-- Giovanni
INSERT INTO ENTRENADOR_OBJETO VALUES (7, 4, 99, 'N', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (7, 5, 50, 'S', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (7, 8, 99, 'N', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (7, 9, 1, 'N', TO_DATE('2024-01-01', 'YYYY-MM-DD'));

-- Red (el campeón tiene de todo)
INSERT INTO ENTRENADOR_OBJETO VALUES (11, 4, 99, 'N', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (11, 5, 99, 'S', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (11, 8, 99, 'N', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (11, 15, 50, 'N', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (11, 16, 50, 'N', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (11, 17, 50, 'N', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (11, 18, 50, 'N', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (11, 19, 99, 'N', TO_DATE('2023-01-01', 'YYYY-MM-DD'));

-- Entrenadores con menos objetos
INSERT INTO ENTRENADOR_OBJETO VALUES (8, 1, 10, 'N', TO_DATE('2024-02-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (8, 6, 15, 'S', TO_DATE('2024-02-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (9, 1, 12, 'N', TO_DATE('2024-03-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (9, 6, 18, 'S', TO_DATE('2024-03-01', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (10, 1, 8, 'N', TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (10, 6, 20, 'S', TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO ENTRENADOR_OBJETO VALUES (10, 20, 2, 'N', TO_DATE('2024-03-20', 'YYYY-MM-DD'));

COMMIT;

-- ================================================================
-- FIN DEL SCRIPT DE DATOS
-- ================================================================
-- Total de registros insertados:
-- - TIPOS: 17
-- - HABILIDADES: 15
-- - MAPA: 15
-- - POKEMON: 50
-- - MOVIMIENTOS: 48
-- - OBJETOS: 20
-- - ENTRENADOR: 15
-- - POKEMON_MOVIMIENTO: ~35
-- - ENTRENADOR_POKEMON: ~45
-- - ENTRENADOR_OBJETO: ~35
-- ================================================================