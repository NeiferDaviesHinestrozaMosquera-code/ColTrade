import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../data/datasources/history_local_datasource.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/entities/history_item.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../bloc/history_bloc.dart';
import '../widgets/history_item_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final datasource = HistoryLocalDatasource();
    final repository = HistoryRepositoryImpl(datasource);

    return BlocProvider(
      create: (_) => HistoryBloc(
        getHistory: GetHistoryUseCase(repository),
      )..add(const LoadHistory()),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ColTradeAppBar(
        title: 'Historial de Consultas',
        dark: true,
        actions: [
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              final activeFilters = state.selectedCategories.length +
                  state.selectedImportances.length +
                  (state.selectedDateFilter != DateFilter.all ? 1 : 0);
              
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.tune_rounded, color: Colors.white),
                    onPressed: () => _showFilterBottomSheet(context),
                  ),
                  if (activeFilters > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.accentOrange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          activeFilters.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state.status == HistoryStatus.initial ||
              state.status == HistoryStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppColors.primaryDarkNavy),
            );
          }

          if (state.status == HistoryStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'Error'));
          }

          return Column(
            children: [
              // Search Bar
              Container(
                color: AppColors.primaryDarkNavy,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  onChanged: (query) =>
                      context.read<HistoryBloc>().add(SearchHistory(query)),
                  decoration: InputDecoration(
                    hintText: 'Buscar consultas...',
                    hintStyle: AppTextStyles.bodySmall,
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: AppColors.textLabel),
                    filled: true,
                    fillColor: AppColors.cardWhite,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Filter Chips / Summary
              _buildFilterChips(context, state),

              // List of items
              Expanded(
                child: state.filteredItems.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = state.filteredItems[index];
                          return HistoryItemCard(
                            item: item,
                            onTap: () {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(content: Text('Reabriendo ${item.title}')));
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, HistoryState state) {
    if (state.selectedCategories.isEmpty &&
        state.selectedImportances.isEmpty &&
        state.selectedDateFilter == DateFilter.all) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ActionChip(
            label: const Text('Limpiar todos'),
            onPressed: () =>
                context.read<HistoryBloc>().add(const ClearFilters()),
            backgroundColor: AppColors.surfaceGray,
            labelStyle: AppTextStyles.caption.copyWith(color: AppColors.errorRed),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppColors.border)),
          ),
          const SizedBox(width: 8),
          if (state.selectedDateFilter != DateFilter.all) ...[
            Chip(
              label: Text(_dateFilterName(state.selectedDateFilter)),
              backgroundColor: AppColors.blueLight.withValues(alpha: 0.2),
              labelStyle: AppTextStyles.caption.copyWith(color: AppColors.primaryDarkNavy),
              deleteIcon: const Icon(Icons.close, size: 14),
              onDeleted: () => context
                  .read<HistoryBloc>()
                  .add(const SelectDateFilter(DateFilter.all)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide.none),
            ),
            const SizedBox(width: 8),
          ],
          ...state.selectedCategories.map((cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text(cat.name.toUpperCase()),
                  backgroundColor: AppColors.surfaceGray,
                  labelStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () => context
                      .read<HistoryBloc>()
                      .add(ToggleCategoryFilter(cat)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: AppColors.border)),
                ),
              )),
          ...state.selectedImportances.map((imp) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text('Imp: ${imp.name.toUpperCase()}'),
                  backgroundColor: AppColors.surfaceGray,
                  labelStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () => context
                      .read<HistoryBloc>()
                      .add(ToggleImportanceFilter(imp)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: AppColors.border)),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surfaceGray,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off_rounded,
                size: 48, color: AppColors.textLabel),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin resultados',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No se encontraron consultas\nque coincidan con esos filtros.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext outerContext) {
    // Access the bloc from outer context
    final bloc = outerContext.read<HistoryBloc>();

    showModalBottomSheet(
      context: outerContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value: bloc, // Provide existing bloc to the modal
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filtros Avanzados',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Category Filter
                  Text('CATEGORÍA', style: AppTextStyles.labelUppercase),
                  const SizedBox(height: 12),
                  BlocBuilder<HistoryBloc, HistoryState>(
                    builder: (context, state) {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: HistoryCategory.values.map((cat) {
                          final isSelected = state.selectedCategories.contains(cat);
                          return FilterChip(
                            label: Text(cat.name.toUpperCase()),
                            selected: isSelected,
                            onSelected: (_) =>
                                context.read<HistoryBloc>().add(ToggleCategoryFilter(cat)),
                            backgroundColor: AppColors.surfaceGray,
                            selectedColor: AppColors.primaryDarkNavy,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Importance Filter
                  Text('IMPORTANCIA', style: AppTextStyles.labelUppercase),
                  const SizedBox(height: 12),
                  BlocBuilder<HistoryBloc, HistoryState>(
                    builder: (context, state) {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: HistoryImportance.values.map((imp) {
                          final isSelected = state.selectedImportances.contains(imp);
                          return FilterChip(
                            label: Text(imp.name.toUpperCase()),
                            selected: isSelected,
                            onSelected: (_) =>
                                context.read<HistoryBloc>().add(ToggleImportanceFilter(imp)),
                            backgroundColor: AppColors.surfaceGray,
                            selectedColor: imp == HistoryImportance.alta
                                ? AppColors.errorRed
                                : imp == HistoryImportance.media
                                    ? AppColors.yellowAmber
                                    : AppColors.successGreen,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Date Filter
                  Text('FECHA', style: AppTextStyles.labelUppercase),
                  const SizedBox(height: 12),
                  BlocBuilder<HistoryBloc, HistoryState>(
                    builder: (context, state) {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: DateFilter.values.map((df) {
                          final isSelected = state.selectedDateFilter == df;
                          return ChoiceChip(
                            label: Text(_dateFilterName(df)),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                context.read<HistoryBloc>().add(SelectDateFilter(df));
                              }
                            },
                            backgroundColor: AppColors.surfaceGray,
                            selectedColor: AppColors.accentOrange,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<HistoryBloc>().add(const ClearFilters());
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Limpiar Todo', style: TextStyle(color: AppColors.textSecondary)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDarkNavy,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Aplicar', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _dateFilterName(DateFilter filter) {
    switch (filter) {
      case DateFilter.all:
        return 'Todo el tiempo';
      case DateFilter.last7Days:
        return 'Últimos 7 días';
      case DateFilter.last30Days:
        return 'Últimos 30 días';
      case DateFilter.thisYear:
        return 'Este año';
    }
  }
}
