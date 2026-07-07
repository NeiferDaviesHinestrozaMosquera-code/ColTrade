import '../../domain/entities/history_item.dart';
import '../../../../core/data/local_database.dart';

class HistoryLocalDatasource {
  final LocalDatabase _localDb = LocalDatabase();

  final List<HistoryItem> _initialHistory = [
    HistoryItem(
      id: '1',
      title: 'Búsqueda NANDINA: Café Verde',
      subtitle: 'Subpartida 0901.11.00.00',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      category: HistoryCategory.aranceles,
      importance: HistoryImportance.alta,
    ),
    HistoryItem(
      id: '2',
      title: 'Cotización: Miami (MIA) -> Bogotá (BOG)',
      subtitle: 'Modo Aéreo - 500kg',
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: HistoryCategory.cotizacion,
      importance: HistoryImportance.media,
    ),
    HistoryItem(
      id: '3',
      title: 'Checklist: Exportación Textil',
      subtitle: '7/10 documentos completados',
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: HistoryCategory.checklist,
      importance: HistoryImportance.alta,
    ),
    HistoryItem(
      id: '4',
      title: 'Ruta: Buenaventura -> Shanghai',
      subtitle: 'Alternativas marítimas consultadas',
      date: DateTime.now().subtract(const Duration(days: 5)),
      category: HistoryCategory.rutas,
      importance: HistoryImportance.baja,
    ),
    HistoryItem(
      id: '5',
      title: 'Consulta Arancelaria: Maquinaria Agrícola',
      subtitle: 'Tractores - Subpartida 8701.30.00.00',
      date: DateTime.now().subtract(const Duration(days: 8)),
      category: HistoryCategory.aranceles,
      importance: HistoryImportance.alta,
    ),
    HistoryItem(
      id: '6',
      title: 'Cotización: Cartagena -> Rotterdam',
      subtitle: 'Modo Marítimo - FCL 40ft',
      date: DateTime.now().subtract(const Duration(days: 12)),
      category: HistoryCategory.cotizacion,
      importance: HistoryImportance.media,
    ),
    HistoryItem(
      id: '7',
      title: 'Validación de Proveedor: XYZ Corp',
      subtitle: 'Certificados sanitarios OK',
      date: DateTime.now().subtract(const Duration(days: 15)),
      category: HistoryCategory.otros,
      importance: HistoryImportance.media,
    ),
    HistoryItem(
      id: '8',
      title: 'Checklist: Importación Cosméticos',
      subtitle: '10/10 documentos completados',
      date: DateTime.now().subtract(const Duration(days: 20)),
      category: HistoryCategory.checklist,
      importance: HistoryImportance.baja,
    ),
  ];

  Future<List<HistoryItem>> getHistoryItems() async {
    final itemsMap = await _localDb.getHistoryItems();

    if (itemsMap.isEmpty) {
      // Pre-populamos si está vacío
      for (final item in _initialHistory) {
        await saveHistoryItem(item);
      }
      return List.from(_initialHistory);
    }

    return itemsMap.map((map) {
      return HistoryItem(
        id: map['id'] as String,
        title: map['title'] as String,
        subtitle: map['subtitle'] as String,
        date: DateTime.parse(map['date'] as String),
        category: HistoryCategory.values.firstWhere(
          (e) => e.name == map['category'],
          orElse: () => HistoryCategory.otros,
        ),
        importance: HistoryImportance.values.firstWhere(
          (e) => e.name == map['importance'],
          orElse: () => HistoryImportance.baja,
        ),
      );
    }).toList();
  }

  Future<void> saveHistoryItem(HistoryItem item) async {
    await _localDb.insertHistoryItem({
      'id': item.id,
      'title': item.title,
      'subtitle': item.subtitle,
      'date': item.date.toIso8601String(),
      'category': item.category.name,
      'importance': item.importance.name,
    });
  }
}
