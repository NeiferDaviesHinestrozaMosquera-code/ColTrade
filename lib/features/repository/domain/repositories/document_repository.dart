import '../entities/repo_document.dart';

abstract class DocumentRepository {
  Future<List<RepoDocument>> getDocuments();
  Future<void> uploadDocument(RepoDocument document);
  Future<void> deleteDocument(String id);
}
