import 'package:flutter/material.dart';
import '../models/tarea.dart';
import '../data/database.dart' hide Tarea;
import '../data/database.dart' as db;

// Pantalla base SIN persistencia ni operaciones CRUD implementadas.
// Conserva las indicaciones TODO para orientar tu trabajo.
class TareasPage extends StatefulWidget {
  final AppDatabase database;

  const TareasPage({
    super.key,
    required this.database,
  });

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final TextEditingController _tituloController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Stream<List<db.Tarea>> _obtenerTareas() {
    return widget.database.obtenerTareas();
  }
  
  Future<void> _agregarTarea() async {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      _pendiente('Escribe un título para la tarea');
      return;
    }

    try {
      await widget.database.agregarTarea(titulo);

      _tituloController.clear();

      if (!mounted) return;

      _pendiente('Tarea agregada correctamente');
    } catch (e) {
      if (!mounted) return;

      _pendiente('Error al guardar la tarea');
    }
  }

  Future<void> _alternarCompletada(
    int id,
    bool completada,
  ) async {
    try {
      await widget.database.actualizarEstadoTarea(
        id,
        completada,
      );

      if (!mounted) return;

      _pendiente('Estado de la tarea actualizado');
    } catch (e) {
      if (!mounted) return;

      _pendiente('Error al actualizar la tarea');
    }
  }

  Future<void> _editarTarea(Tarea tarea) async {
    final controller = TextEditingController(text: tarea.titulo);

    final nuevoTitulo = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar tarea'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Título de la tarea',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, controller.text.trim());
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (nuevoTitulo == null) return;

    if (nuevoTitulo.isEmpty) {
      _pendiente('El título no puede estar vacío');
      return;
    }

    try {
      await widget.database.actualizarTituloTarea(
        tarea.id,
        nuevoTitulo,
      );

      if (!mounted) return;

      _pendiente('Tarea actualizada correctamente');
    } catch (e) {
      if (!mounted) return;

      _pendiente('Error al actualizar la tarea');
    }
  }

  Future<void> _eliminarTarea(Tarea tarea) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${tarea.titulo}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await widget.database.eliminarTarea(tarea.id);

      if (!mounted) return;

      _pendiente('Tarea eliminada correctamente');
    } catch (e) {
      if (!mounted) return;

      _pendiente('Error al eliminar la tarea');
    }
  }

  void _pendiente(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Nueva tarea',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _agregarTarea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),
            const SizedBox(height: 12),
            const Text('Mis tareas', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<db.Tarea>>(
                stream: _obtenerTareas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error al cargar las tareas'),
                    );
                  }

                  final tareas = snapshot.data ?? [];

                  if (tareas.isEmpty) {
                    return const Center(
                      child: Text('Todavía no hay tareas guardadas'),
                    );
                  }

                  return ListView.builder(
                    itemCount: tareas.length,
                    itemBuilder: (context, index) {
                      final tarea = tareas[index];

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: tarea.completada,
                            onChanged: (valor) {
                              if (valor != null) {
                                _alternarCompletada(tarea.id, valor);
                              }
                            },
                          ),
                          title: Text(tarea.titulo),
                          subtitle: Text('ID: ${tarea.id}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Editar',
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editarTarea(
                                  Tarea(
                                    id: tarea.id,
                                    titulo: tarea.titulo,
                                    completada: tarea.completada,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Eliminar',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _eliminarTarea(
                                  Tarea(
                                    id: tarea.id,
                                    titulo: tarea.titulo,
                                    completada: tarea.completada,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
