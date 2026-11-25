import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get titulo => text()();

  BoolColumn get completada =>
      boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor})
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Tarea>> obtenerTareas() {
    return select(tareas).watch();
  }

  Future<int> agregarTarea(String titulo) {
    return into(tareas).insert(
      TareasCompanion.insert(titulo: titulo),
    );
  }

  Future<int> actualizarEstadoTarea(
    int id,
    bool completada,
  ) {
    return (update(tareas)..where((t) => t.id.equals(id))).write(
      TareasCompanion(
        completada: Value(completada),
      ),
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'gestor_tareas',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}