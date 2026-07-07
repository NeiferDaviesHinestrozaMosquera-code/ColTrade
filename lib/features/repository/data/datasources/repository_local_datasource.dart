import '../../domain/entities/repo_document.dart';
import '../../../../core/data/local_database.dart';

class RepositoryLocalDatasource {
  final LocalDatabase _localDb = LocalDatabase();

  final List<RepoDocument> _initialMockDocuments = [
    RepoDocument(
      id: 'doc-1',
      name: 'Factura_Comercial_INV001',
      extension: 'pdf',
      size: '1.2 MB',
      uploadDate: DateTime.now().subtract(const Duration(days: 1)),
      category: DocCategory.facturas,
    ),
    RepoDocument(
      id: 'doc-2',
      name: 'BL_Rotterdam_Cartagena',
      extension: 'pdf',
      size: '3.4 MB',
      uploadDate: DateTime.now().subtract(const Duration(days: 3)),
      category: DocCategory.transporte,
    ),
    RepoDocument(
      id: 'doc-3',
      name: 'Certificado_Origen_CO',
      extension: 'pdf',
      size: '0.8 MB',
      uploadDate: DateTime.now().subtract(const Duration(days: 4)),
      category: DocCategory.certificados,
    ),
    RepoDocument(
      id: 'doc-4',
      name: 'Declaracion_Aduana_DEX',
      extension: 'docx',
      size: '1.5 MB',
      uploadDate: DateTime.now().subtract(const Duration(days: 7)),
      category: DocCategory.aduanas,
    ),
    RepoDocument(
      id: 'doc-5',
      name: 'Lista_Empaque_001',
      extension: 'xlsx',
      size: '2.1 MB',
      uploadDate: DateTime.now().subtract(const Duration(days: 8)),
      category: DocCategory.otros,
    ),
  ];

  Future<List<RepoDocument>> getDocuments() async {
    final docsMap = await _localDb.getDocuments();

    if (docsMap.isEmpty) {
      // Pre-populamos si está vacío
      for (final doc in _initialMockDocuments) {
        await uploadDocument(doc);
      }
      return List.from(_initialMockDocuments);
    }

    return docsMap.map((map) {
      return RepoDocument(
        id: map['id'] as String,
        name: map['name'] as String,
        extension: map['extension'] as String,
        size: map['size'] as String,
        uploadDate: DateTime.parse(map['uploadDate'] as String),
        category: DocCategory.values.firstWhere(
          (e) => e.name == map['category'],
          orElse: () => DocCategory.otros,
        ),
      );
    }).toList();
  }

  Future<void> uploadDocument(RepoDocument document) async {
    await _localDb.insertDocument({
      'id': document.id,
      'name': document.name,
      'extension': document.extension,
      'size': document.size,
      'uploadDate': document.uploadDate.toIso8601String(),
      'category': document.category.name,
    });
  }

  Future<void> deleteDocument(String id) async {
    await _localDb.deleteDocument(id);
  }
}
