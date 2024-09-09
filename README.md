# prueba-sql
Script SQL y breve video explicativo

# Resumen de lo visto en SQL

## Constraints
- Uso de `CHECK (edad >= 18)` para validar edades.

## LEFT JOIN
- Relacionar tablas y mostrar todas las filas, incluso sin coincidencias.

## Consulta SQL Compleja
**Uso de `GROUP BY` con `STRING_AGG()`**:
- Agrupar datos, como películas y sus tags asociados.
- Concatenación de tags en una sola fila separados por comas.

```sql
SELECT peliculas.nombre AS pelicula, 
       STRING_AGG(tags.tag, ', ') AS tags
FROM peliculas
LEFT JOIN pelicula_tags ON peliculas.id = pelicula_tags.pelicula_id
LEFT JOIN tags ON pelicula_tags.tag_id = tags.id
GROUP BY peliculas.nombre
ORDER BY peliculas.nombre;
```
Como queda la consulta con los tags separados por comas y agrupados por la misma película:

| pelicula   | tags                |
|------------|---------------------|
| Película 1 | Tag 1, Tag 2, Tag 3 |
| Película 2 | Tag 4, Tag 5        |
| Película 3 | NULL                |
| Película 4 | NULL                |
| Película 5 | NULL                |


## CASCADE

    Borrado en cascada con `ON DELETE CASCADE` en claves foráneas.

## ORDER BY

    Ordenar resultados por nombre de películas.

## Alias en SQL

    Simplificación de consultas mediante alias (`peliculas p`).

## Validación de Datos

    Restricciones que no afectan datos preexistentes.


