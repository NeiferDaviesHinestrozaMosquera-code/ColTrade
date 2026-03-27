import '../entities/repo_document.dart';
import '../repositories/document_repository.dart';

class GetDocumentsUseCase {
  final DocumentRepository repository;

  GetDocumentsUseCase(this.repository);

  Future<List<RepoDocument>> call() async {
    return await repository.getDocuments();
  }
}

class UploadDocumentUseCase {
  final DocumentRepository repository;

  UploadDocumentUseCase(this.repository);

  Future<void> call(RepoDocument document) async {
    return await repository.uploadDocument(document);
  }
}

class DeleteDocumentUseCase {
  final DocumentRepository repository;

  DeleteDocumentUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteDocument(id);
  }
}
