part of 'repository_bloc.dart';

abstract class RepositoryEvent extends Equatable {
  const RepositoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocuments extends RepositoryEvent {
  const LoadDocuments();
}

class SearchDocuments extends RepositoryEvent {
  final String query;
  const SearchDocuments(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByCategory extends RepositoryEvent {
  final DocCategory? category;
  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class UploadDocument extends RepositoryEvent {
  final RepoDocument document;
  const UploadDocument(this.document);

  @override
  List<Object?> get props => [document];
}

class DeleteDocument extends RepositoryEvent {
  final String id;
  const DeleteDocument(this.id);

  @override
  List<Object?> get props => [id];
}
