import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/main.dart';
import 'package:gestor_tareas_local/data/database.dart';
import 'package:drift/native.dart';

void main() {
  testWidgets('La pantalla inicial se muestra sin errores', (tester) async {
    final database = AppDatabase(executor: NativeDatabase.memory());

    await tester.pumpWidget(
      GestorTareasApp(database: database),
    );

    expect(find.text('Gestor de tareas'), findsOneWidget);
    expect(find.text('Agregar tarea'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    await database.close();
  });
}