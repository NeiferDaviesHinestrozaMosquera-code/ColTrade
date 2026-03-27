import '../../domain/entities/repo_document.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/repository_local_datasource.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final RepositoryLocalDatasource datasource;

  DocumentRepositoryImpl(this.datasource);

  @override
  Future<List<RepoDocument>> getDocuments() async {
    return await datasource.getDocuments();
  }

  @override
  Future<void> uploadDocument(RepoDocument document) async {
    return await datasource.uploadDocument(document);
  }

  @override
  Future<void> deleteDocument(String id) async {
    return await datasource.deleteDocument(id);
  }
}
