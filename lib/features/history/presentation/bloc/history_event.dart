part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistory extends HistoryEvent {
  const LoadHistory();
}

class SearchHistory extends HistoryEvent {
  final String query;
  const SearchHistory(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleCategoryFilter extends HistoryEvent {
  final HistoryCategory category;
  const ToggleCategoryFilter(this.category);

  @override
  List<Object?> get props => [category];
}

class ToggleImportanceFilter extends HistoryEvent {
  final HistoryImportance importance;
  const ToggleImportanceFilter(this.importance);

  @override
  List<Object?> get props => [importance];
}

class SelectDateFilter extends HistoryEvent {
  final DateFilter dateFilter;
  const SelectDateFilter(this.dateFilter);

  @override
  List<Object?> get props => [dateFilter];
}

class ClearFilters extends HistoryEvent {
  const ClearFilters();
}
