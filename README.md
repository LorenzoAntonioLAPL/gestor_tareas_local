# Gestor de tareas con SQLite

Aplicación multiplataforma desarrollada con Flutter que permite gestionar tareas mediante almacenamiento local persistente con SQLite y Drift.

## Funcionalidades

- Crear tareas.
- Consultar tareas registradas.
- Editar títulos.
- Marcar tareas como completadas o pendientes.
- Eliminar tareas.
- Validar títulos vacíos.
- Conservar los datos al cerrar y volver a abrir la aplicación.

## Tecnologías

- Flutter y Dart
- SQLite
- Drift
- drift_flutter

La base de datos utiliza una tabla `Tareas` con los campos `id` (autoincremental), `titulo` y `completada`. La persistencia se administra mediante `AppDatabase`.

## Instalación y ejecución

Requisitos: Flutter SDK y Git instalados.

Clonar el repositorio:

```bash
git clone https://github.com/LorenzoAntonioLAPL/gestor_tareas_local.git
cd gestor_tareas_local
```

Instalar dependencias:

```bash
flutter pub get
```

Ejecutar en Windows:

```bash
flutter run -d windows
```

Ejecutar en Web (Chrome):

```bash
flutter run -d chrome
```

## Verificación

```bash
flutter analyze
flutter test
```

El proyecto fue probado en Windows y Web (Chrome). Las pruebas automatizadas y las pruebas manuales de persistencia se documentan en el reporte de la práctica.