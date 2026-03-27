part of 'repository_bloc.dart';

enum RepositoryStatus { initial, loading, loaded, uploading, error }

class RepositoryState extends Equatable {
  final RepositoryStatus status;
  final List<RepoDocument> allDocuments;
  final List<RepoDocument> filteredDocuments;
  final String? errorMessage;
  
  // Filters
  final String query;
  final DocCategory? selectedCategory;

  const RepositoryState({
    this.status = RepositoryStatus.initial,
    this.allDocuments = const [],
    this.filteredDocuments = const [],
    this.errorMessage,
    this.query = '',
    this.selectedCategory,
  });

  RepositoryState copyWith({
    RepositoryStatus? status,
    List<RepoDocument>? allDocuments,
    List<RepoDocument>? filteredDocuments,
    String? errorMessage,
    String? query,
    // Using a tricky way to allow nullification of selectedCategory
    DocCategory? Function()? selectedCategory,
  }) {
    return RepositoryState(
      status: status ?? this.status,
      allDocuments: allDocuments ?? this.allDocuments,
      filteredDocuments: filteredDocuments ?? this.filteredDocuments,
      errorMessage: errorMessage ?? this.errorMessage,
      query: query ?? this.query,
      selectedCategory: selectedCategory != null ? selectedCategory() : this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allDocuments,
        filteredDocuments,
        errorMessage,
        query,
        selectedCategory,
      ];
}
