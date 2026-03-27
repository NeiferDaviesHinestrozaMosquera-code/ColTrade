import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/history_item.dart';
import '../../domain/usecases/get_history_usecase.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase _getHistory;

  HistoryBloc({required GetHistoryUseCase getHistory})
      : _getHistory = getHistory,
        super(const HistoryState()) {
    on<LoadHistory>(_onLoadHistory);
    on<SearchHistory>(_onSearchHistory);
    on<ToggleCategoryFilter>(_onToggleCategoryFilter);
    on<ToggleImportanceFilter>(_onToggleImportanceFilter);
    on<SelectDateFilter>(_onSelectDateFilter);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadHistory(
      LoadHistory event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(status: HistoryStatus.loading));
    try {
      final items = await _getHistory();
      emit(state.copyWith(
        status: HistoryStatus.loaded,
        items: items,
        filteredItems: items,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HistoryStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSearchHistory(SearchHistory event, Emitter<HistoryState> emit) {
    _applyFilters(emit, event.query, state.selectedCategories,
        state.selectedImportances, state.selectedDateFilter);
  }

  void _onToggleCategoryFilter(
      ToggleCategoryFilter event, Emitter<HistoryState> emit) {
    final categories = List<HistoryCategory>.from(state.selectedCategories);
    if (categories.contains(event.category)) {
      categories.remove(event.category);
    } else {
      categories.add(event.category);
    }
    _applyFilters(emit, state.query, categories, state.selectedImportances,
        state.selectedDateFilter);
  }

  void _onToggleImportanceFilter(
      ToggleImportanceFilter event, Emitter<HistoryState> emit) {
    final importances = List<HistoryImportance>.from(state.selectedImportances);
    if (importances.contains(event.importance)) {
      importances.remove(event.importance);
    } else {
      importances.add(event.importance);
    }
    _applyFilters(emit, state.query, state.selectedCategories, importances,
        state.selectedDateFilter);
  }

  void _onSelectDateFilter(
      SelectDateFilter event, Emitter<HistoryState> emit) {
    _applyFilters(emit, state.query, state.selectedCategories,
        state.selectedImportances, event.dateFilter);
  }

  void _onClearFilters(ClearFilters event, Emitter<HistoryState> emit) {
    _applyFilters(emit, '', const [], const [], DateFilter.all);
  }

  void _applyFilters(
    Emitter<HistoryState> emit,
    String query,
    List<HistoryCategory> categories,
    List<HistoryImportance> importances,
    DateFilter dateFilter,
  ) {
    final now = DateTime.now();
    final lowerQuery = query.toLowerCase();

    final filtered = state.items.where((item) {
      // Filter by query
      if (query.isNotEmpty) {
        if (!item.title.toLowerCase().contains(lowerQuery) &&
            !item.subtitle.toLowerCase().contains(lowerQuery)) {
          return false;
        }
      }

      // Filter by category
      if (categories.isNotEmpty && !categories.contains(item.category)) {
        return false;
      }

      // Filter by importance
      if (importances.isNotEmpty && !importances.contains(item.importance)) {
        return false;
      }

      // Filter by date
      if (dateFilter != DateFilter.all) {
        final diff = now.difference(item.date).inDays;
        if (dateFilter == DateFilter.last7Days && diff > 7) return false;
        if (dateFilter == DateFilter.last30Days && diff > 30) return false;
        if (dateFilter == DateFilter.thisYear && item.date.year != now.year) {
          return false;
        }
      }

      return true;
    }).toList();

    emit(state.copyWith(
      filteredItems: filtered,
      query: query,
      selectedCategories: categories,
      selectedImportances: importances,
      selectedDateFilter: dateFilter,
    ));
  }
}
