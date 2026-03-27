import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/repo_document.dart';
import '../../domain/usecases/document_usecases.dart';

part 'repository_event.dart';
part 'repository_state.dart';

class RepositoryBloc extends Bloc<RepositoryEvent, RepositoryState> {
  final GetDocumentsUseCase _getDocuments;
  final UploadDocumentUseCase _uploadDocument;
  final DeleteDocumentUseCase _deleteDocument;

  RepositoryBloc({
    required GetDocumentsUseCase getDocuments,
    required UploadDocumentUseCase uploadDocument,
    required DeleteDocumentUseCase deleteDocument,
  })  : _getDocuments = getDocuments,
        _uploadDocument = uploadDocument,
        _deleteDocument = deleteDocument,
        super(const RepositoryState()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<SearchDocuments>(_onSearchDocuments);
    on<FilterByCategory>(_onFilterByCategory);
    on<UploadDocument>(_onUploadDocument);
    on<DeleteDocument>(_onDeleteDocument);
  }

  Future<void> _onLoadDocuments(
      LoadDocuments event, Emitter<RepositoryState> emit) async {
    emit(state.copyWith(status: RepositoryStatus.loading));
    try {
      final docs = await _getDocuments();
      emit(state.copyWith(
        status: RepositoryStatus.loaded,
        allDocuments: docs,
        filteredDocuments: docs,
        query: '',
        selectedCategory: () => null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RepositoryStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSearchDocuments(SearchDocuments event, Emitter<RepositoryState> emit) {
    _applyFilters(emit, event.query, state.selectedCategory);
  }

  void _onFilterByCategory(
      FilterByCategory event, Emitter<RepositoryState> emit) {
    _applyFilters(emit, state.query, event.category);
  }

  Future<void> _onUploadDocument(
      UploadDocument event, Emitter<RepositoryState> emit) async {
    // Keep current list but show uploading state
    emit(state.copyWith(status: RepositoryStatus.uploading));
    try {
      await _uploadDocument(event.document);
      // Reload documents to get the updated list
      final docs = await _getDocuments();
      // Apply existing filters to the new list
      final lowerQuery = state.query.toLowerCase();
      final filtered = docs.where((doc) {
        if (state.query.isNotEmpty &&
            !doc.name.toLowerCase().contains(lowerQuery)) return false;
        if (state.selectedCategory != null &&
            doc.category != state.selectedCategory) return false;
        return true;
      }).toList();

      emit(state.copyWith(
        status: RepositoryStatus.loaded,
        allDocuments: docs,
        filteredDocuments: filtered,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RepositoryStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteDocument(
      DeleteDocument event, Emitter<RepositoryState> emit) async {
    // Optional: emit loading or deleting state here
    emit(state.copyWith(status: RepositoryStatus.loading));
    try {
      await _deleteDocument(event.id);
      final docs = await _getDocuments();
      _applyFilters(emit, state.query, state.selectedCategory, newDocs: docs);
    } catch (e) {
      emit(state.copyWith(
        status: RepositoryStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _applyFilters(
    Emitter<RepositoryState> emit,
    String query,
    DocCategory? category, {
    List<RepoDocument>? newDocs,
  }) {
    final docs = newDocs ?? state.allDocuments;
    final lowerQuery = query.toLowerCase();

    final filtered = docs.where((doc) {
      if (query.isNotEmpty && !doc.name.toLowerCase().contains(lowerQuery)) {
        return false;
      }
      if (category != null && doc.category != category) {
        return false;
      }
      return true;
    }).toList();

    emit(state.copyWith(
      status: RepositoryStatus.loaded,
      allDocuments: docs,
      filteredDocuments: filtered,
      query: query,
      selectedCategory: () => category,
    ));
  }
}
