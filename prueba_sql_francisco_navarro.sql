-- PRIMERA PARTE DE LA PRUEBA
--Crear modelo de base de datos

CREATE TABLE peliculas (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    anno INTEGER NOT NULL
);

CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    tag VARCHAR(32) NOT NULL
);

CREATE TABLE pelicula_tags (
    pelicula_id INTEGER REFERENCES peliculas(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (pelicula_id, tag_id)
);

-- Poblar base de datos

-- Insertar 5 películas con el campo 'anno'
INSERT INTO peliculas (id, nombre, anno) VALUES 
(1, 'Pelicula 1', 2020),
(2, 'Pelicula 2', 2021),
(3, 'Pelicula 3', 2019),
(4, 'Pelicula 4', 2018),
(5, 'Pelicula 5', 2022);

-- Insertar 5 tags con el campo 'tag'
INSERT INTO tags (id, tag) VALUES 
(1, 'Tag 1'),
(2, 'Tag 2'),
(3, 'Tag 3'),
(4, 'Tag 4'),
(5, 'Tag 5');

-- Asociar tags con películas
INSERT INTO pelicula_tags (pelicula_id, tag_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5);

SELECT * FROM PELICULAS
SELECT * FROM TAGS

--Unidos
SELECT peliculas.nombre AS pelicula, tags.tag AS tag
FROM peliculas
LEFT JOIN pelicula_tags ON peliculas.id = pelicula_tags.pelicula_id
LEFT JOIN tags ON pelicula_tags.tag_id = tags.id;

--Versión tags separados por comas (Group By y String_Agg)
SELECT peliculas.nombre AS pelicula, 
       STRING_AGG(tags.tag, ', ') AS tags
FROM peliculas
LEFT JOIN pelicula_tags ON peliculas.id = pelicula_tags.pelicula_id
LEFT JOIN tags ON pelicula_tags.tag_id = tags.id
GROUP BY peliculas.nombre
ORDER BY peliculas.nombre;



-- Contar cantidad de tags por película

--Versión no abreviada
SELECT peliculas.nombre, COUNT(pelicula_tags.tag_id) AS cantidad_tags
FROM peliculas
LEFT JOIN pelicula_tags ON peliculas.id = pelicula_tags.pelicula_id
GROUP BY peliculas.id;
--Version abreviada
SELECT p.nombre, COUNT(pt.tag_id) AS cantidad_tags
FROM peliculas p
LEFT JOIN pelicula_tags pt ON p.id = pt.pelicula_id
GROUP BY p.id;

--SEGUNDA PARTE DE LA PRUEBA

-- Crear tabla usuarios
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    edad INTEGER
);

-- Crear tabla preguntas
CREATE TABLE preguntas (
    id INTEGER PRIMARY KEY,
    pregunta VARCHAR(255) NOT NULL,
    respuesta_correcta VARCHAR(255) NOT NULL
);

-- Crear tabla respuestas
CREATE TABLE respuestas (
    id INTEGER PRIMARY KEY,
    respuesta VARCHAR(255) NOT NULL,
    usuario_id INTEGER REFERENCES usuarios(id),
    pregunta_id INTEGER REFERENCES preguntas(id)
);

-- Insertamos datos en la tabla usuarios
INSERT INTO usuarios (id, nombre, edad) VALUES 
(1, 'Usuario 1', 25),
(2, 'Usuario 2', 30),
(3, 'Usuario 3', 22),
(4, 'Usuario 4', 28),
(5, 'Usuario 5', 35);

SELECT * FROM usuarios;

-- Poblar tabla preguntas
INSERT INTO preguntas (id, pregunta, respuesta_correcta) VALUES 
(1, 'Pregunta 1: ¿Color del cielo?', 'azul'),
(2, 'Pregunta 2: Año de estreno de la película The Matrix', '1999');

SELECT * FROM preguntas; 

-- Poblar tabla respuestas
-- (Pregunta 1 dos usuarios responden correctamente)
-- (Pregunta 2 solo un usuario responde correctamente)
INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES 
(1, 'azul', 1, 1),  -- Usuario 1 responde correctamente "azul" a la Pregunta 1
(2, 'azul', 2, 1),  -- Usuario 2 responde correctamente "azul" a la Pregunta 1
(3, 'rojo', 3, 1),  -- Usuario 3 responde incorrectamente "rojo" a la Pregunta 1
(4, 'rojo', 4, 1),  -- Usuario 4 responde incorrectamente "rojo" a la Pregunta 1
(5, 'rojo', 5, 1),  -- Usuario 5 responde incorrectamente "rojo" a la Pregunta 1
(6, '1999', 3, 2),  -- Usuario 3 responde correctamente "1999" a la Pregunta 2
(7, '2000', 1, 2),  -- Usuario 1 responde incorrectamente "2000" a la Pregunta 2
(8, '1998', 2, 2),  -- Usuario 2 responde incorrectamente "1998" a la Pregunta 2
(9, '2001', 4, 2),  -- Usuario 4 responde incorrectamente "2001" a la Pregunta 2
(10, '1997', 5, 2); -- Usuario 5 responde incorrectamente "1997" a la Pregunta 2

-- Contar la cantidad de respuestas correctas totales por usuario (independiente de la pregunta)
SELECT usuarios.nombre, COUNT(respuestas.id) AS respuestas_correctas
FROM usuarios
LEFT JOIN respuestas ON usuarios.id = respuestas.usuario_id
LEFT JOIN preguntas ON respuestas.pregunta_id = preguntas.id
WHERE respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY usuarios.id, usuarios.nombre;

-- Contar cuántos usuarios tuvieron la respuesta correcta por pregunta
SELECT respuestas.pregunta_id, preguntas.pregunta, COUNT(respuestas.usuario_id) AS usuarios_correctos
FROM respuestas
JOIN preguntas ON respuestas.pregunta_id = preguntas.id
WHERE respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY respuestas.pregunta_id, preguntas.pregunta;


-- Borrado en cascada
-- Al borrar un usuario tambien se borra la FK de la tabla respuetas
-- Así se borra el usuario y la respuesta
SELECT * FROM respuestas WHERE usuario_id = 1;

DELETE FROM usuarios WHERE id = 1;

SELECT * FROM respuestas WHERE usuario_id = 1;
-- Dará error porque hay que implementar borrado en cascada

ALTER TABLE respuestas
DROP CONSTRAINT respuestas_usuario_id_fkey; -- Elimina restricción de foreign keys
-- ON DELETE CASCADE
ALTER TABLE respuestas
ADD CONSTRAINT respuestas_usuario_id_fkey --Añade restricción con borrado en cascada para foreign keys
FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
ON DELETE CASCADE;

--Ahora intentamos borrar nuevamente
SELECT * FROM respuestas WHERE usuario_id = 1;
DELETE FROM usuarios WHERE id = 1;
SELECT * FROM respuestas WHERE usuario_id = 1;

--Éxito conseguido.


--Crear restricción a menores de 18 años
ALTER TABLE usuarios
ADD CONSTRAINT restriccion_edad CHECK (edad >= 18);
--Verificar
INSERT INTO usuarios (id, nombre, edad) VALUES (6, 'Usuario Menor', 17);


-- Alterar tabla usuarios para añadir campo email tenga restricción de ÚNICO
ALTER TABLE usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;
--Verificar
INSERT INTO usuarios (id, nombre, edad, email) VALUES 
(6, 'Usuario Nuevo', 26, 'usuario@correo.com'),
(7, 'Otro Usuario', 29, 'usuario@correo.com');
-- Dará error
INSERT INTO usuarios (id, nombre, edad, email) VALUES 
(6, 'Usuario Nuevo', 26, 'usuario@correo.com');
--Verificar
SELECT * FROM usuarios;

--Fin Prueba





