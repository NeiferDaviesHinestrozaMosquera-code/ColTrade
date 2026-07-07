import '../../domain/entities/doc_item_entity.dart';
import '../../domain/repositories/checklist_repository.dart';
import '../../../../core/data/local_database.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  final LocalDatabase _localDb = LocalDatabase();

  @override
  Future<List<DocItemEntity>> getChecklist() async {
    const operationId = 'default_op'; // TODO: Recibir desde el UI

    // 1. Obtener de DB local
    final localTasks = await _localDb.getTasks(operationId);

    // 2. Si hay tareas locales, usarlas
    if (localTasks.isNotEmpty) {
      return localTasks.map((t) => DocItemEntity(
        name: t['name'] as String,
        entity: t['entity'] as String,
        completed: t['completed'] == 1,
        needsUpload: t['needsUpload'] == 1,
        hasError: t['hasError'] == 1,
      )).toList();
    }

    // 3. Si no hay (primer login offline o nuevo), cargar mock/API e insertarlos localmente
    const initialTasks = [
      {'name': 'Factura Comercial', 'entity': 'DIAN', 'completed': true, 'needsUpload': false, 'hasError': false},
      {'name': 'Lista de Empaque (Packing List)', 'entity': 'Empresa', 'completed': true, 'needsUpload': false, 'hasError': false},
      {'name': 'Certificado de Origen', 'entity': 'MINCIT', 'completed': false, 'needsUpload': true, 'hasError': false},
      {'name': 'Declaración de Exportación (DEX)', 'entity': 'DIAN', 'completed': false, 'needsUpload': false, 'hasError': false},
      {'name': 'Fitosanitario ICA', 'entity': 'ICA', 'completed': false, 'needsUpload': false, 'hasError': true},
    ];

    await _localDb.insertTasks(operationId, initialTasks);

    // 4. Retornar los insertados
    return initialTasks.map((t) => DocItemEntity(
      name: t['name'] as String,
      entity: t['entity'] as String,
      completed: t['completed'] as bool,
      needsUpload: t['needsUpload'] as bool,
      hasError: t['hasError'] as bool,
    )).toList();
  }

  // TODO: Añadir método syncWithServer() llamado periódicamente o al detectar red
}
