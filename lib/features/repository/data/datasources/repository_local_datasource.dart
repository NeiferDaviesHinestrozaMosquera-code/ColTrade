import '../../domain/entities/repo_document.dart';

class RepositoryLocalDatasource {
  final List<RepoDocument> _mockDocuments = [
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
    await Future.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_mockDocuments);
  }

  Future<void> uploadDocument(RepoDocument document) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    _mockDocuments.insert(0, document);
  }

  Future<void> deleteDocument(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _mockDocuments.removeWhere((doc) => doc.id == id);
  }
}
