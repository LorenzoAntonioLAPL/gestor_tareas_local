
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:gestor_tareas_local/data/database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(executor: NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('Se puede agregar y consultar una tarea', () async {
    await database.agregarTarea('Estudiar Flutter');

    final tareas = await database.obtenerTareas().first;

    expect(tareas.length, 1);
    expect(tareas.first.titulo, 'Estudiar Flutter');
    expect(tareas.first.completada, false);
  });

  test('Se puede actualizar el estado de una tarea', () async {
    final id = await database.agregarTarea('Hacer ejercicio');

    await database.actualizarEstadoTarea(id, true);

    final tareas = await database.obtenerTareas().first;

    expect(tareas.first.completada, true);
  });

  test('Se puede editar el título de una tarea', () async {
    final id = await database.agregarTarea('Título original');

    await database.actualizarTituloTarea(id, 'Título modificado');

    final tareas = await database.obtenerTareas().first;

    expect(tareas.first.titulo, 'Título modificado');
  });

  test('Se puede eliminar una tarea', () async {
    final id = await database.agregarTarea('Tarea temporal');

    await database.eliminarTarea(id);

    final tareas = await database.obtenerTareas().first;

    expect(tareas, isEmpty);
  });
}
