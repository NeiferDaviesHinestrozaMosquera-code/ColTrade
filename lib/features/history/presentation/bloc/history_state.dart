part of 'history_bloc.dart';

enum HistoryStatus { initial, loading, loaded, error }
enum DateFilter { all, last7Days, last30Days, thisYear }

class HistoryState extends Equatable {
  final HistoryStatus status;
  final List<HistoryItem> items;
  final List<HistoryItem> filteredItems;
  final String? errorMessage;
  
  // Filters
  final String query;
  final List<HistoryCategory> selectedCategories;
  final List<HistoryImportance> selectedImportances;
  final DateFilter selectedDateFilter;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.items = const [],
    this.filteredItems = const [],
    this.errorMessage,
    this.query = '',
    this.selectedCategories = const [],
    this.selectedImportances = const [],
    this.selectedDateFilter = DateFilter.all,
  });

  HistoryState copyWith({
    HistoryStatus? status,
    List<HistoryItem>? items,
    List<HistoryItem>? filteredItems,
    String? errorMessage,
    String? query,
    List<HistoryCategory>? selectedCategories,
    List<HistoryImportance>? selectedImportances,
    DateFilter? selectedDateFilter,
  }) {
    return HistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      errorMessage: errorMessage ?? this.errorMessage,
      query: query ?? this.query,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedImportances: selectedImportances ?? this.selectedImportances,
      selectedDateFilter: selectedDateFilter ?? this.selectedDateFilter,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        filteredItems,
        errorMessage,
        query,
        selectedCategories,
        selectedImportances,
        selectedDateFilter,
      ];
}
