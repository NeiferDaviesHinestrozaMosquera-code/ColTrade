import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/alerts_bloc.dart';
import '../bloc/alerts_event.dart';
import '../bloc/alerts_state.dart';
import '../../../../injection/injection.dart';

import '../widgets/alert_filter_tabs.dart';
import '../widgets/alert_card.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlertsBloc(getAlerts: sl())..add(const LoadAlerts()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ColTradeAppBar(
          dark: true,
          titleWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alertas Regulatorias',
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              Text('COLTRADE INTELLIGENCE',
                  style: AppTextStyles.labelUppercase
                      .copyWith(color: const Color(0xFF94A3B8), fontSize: 9)),
            ],
          ),
          actions: [
            IconButton(
                icon: const NotificationBell(hasNotification: true),
                onPressed: () {})
          ],
        ),
        body: Column(
          children: [
            // Search bar
            Container(
              color: AppColors.primaryDarkNavy,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: TextFormField(
                style: AppTextStyles.bodyRegular.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar alertas, decretos, normas...',
                  hintStyle:
                      AppTextStyles.bodySmall.copyWith(color: Colors.white38),
                  prefixIcon:
                      const Icon(Icons.search_rounded, color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF1E3A5F),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            
            BlocBuilder<AlertsBloc, AlertsState>(
              builder: (ctx, state) {
                final String activeFilter = state is AlertsLoaded ? state.activeFilter : 'Todas';
                return AlertFilterTabs(activeFilter: activeFilter);
              },
            ),

            const Divider(height: 1),
            
            Expanded(
              child: BlocBuilder<AlertsBloc, AlertsState>(
                builder: (ctx, state) {
                  return _buildContent(ctx, state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext ctx, AlertsState state) {
    if (state is AlertsLoading || state is AlertsInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is AlertsError) {
      return Center(child: Text(state.message, style: AppTextStyles.bodySmall));
    }
    if (state is AlertsLoaded) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.filtered.length,
        itemBuilder: (_, i) => AlertCard(alert: state.filtered[i]),
      );
    }
    return const SizedBox.shrink();
  }
}
