import '../../domain/entities/history_item.dart';

class HistoryLocalDatasource {
  Future<List<HistoryItem>> getHistoryItems() async {
    // Simulated network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return [
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
  }
}
