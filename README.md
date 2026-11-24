# Gestor de tareas SQLite multiplataforma

Aplicación desarrollada en Flutter para administrar tareas mediante almacenamiento local SQLite. El proyecto busca funcionar en Android, iOS, Windows, Linux, macOS y Web.

## Tecnologías

- Flutter
- Dart
- SQLite
- Drift
- drift_flutter

Se utilizará Drift como ORM para trabajar con SQLite desde Dart, y drift_flutter para facilitar la configuración de la base de datos en Flutter. La finalidad es utilizar una misma implementación de persistencia en las diferentes plataformas.

## Diseño de la base de datos

Se utilizará una tabla llamada `Tareas` con los siguientes campos:

| Campo | Tipo | Descripción |
|---|---|---|
| id | INTEGER | Identificador único autoincremental |
| titulo | TEXT | Nombre de la tarea |
| completada | BOOLEAN | Indica si la tarea está completada |

El identificador permitirá realizar modificaciones y eliminaciones sobre una tarea específica.

## Funcionalidades

- Agregar tareas.
- Consultar tareas guardadas.
- Editar títulos.
- Marcar tareas como completadas o pendientes.
- Eliminar tareas.
- Conservar la información después de cerrar y abrir la aplicación.

## Desarrollo

El proyecto se desarrollará por etapas:

1. Preparación del proyecto y diseño de persistencia.
2. Implementación de SQLite y operaciones de alta y consulta.
3. Implementación de edición, cambio de estado y eliminación.
4. Compatibilidad multiplataforma y pruebas.

## Estado actual

- [x] Proyecto Flutter creado.
- [x] Interfaz inicial incorporada.
- [x] Dependencias iniciales instaladas.
- [x] Prueba inicial ejecutada correctamente.
- [ ] Configuración de Drift.
- [ ] Implementación de persistencia.
- [ ] CRUD completo.
- [ ] Pruebas de persistencia y multiplataforma.
