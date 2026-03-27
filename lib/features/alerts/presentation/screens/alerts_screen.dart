import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/alert_entity.dart';
import '../bloc/alerts_bloc.dart';
import '../bloc/alerts_event.dart';
import '../bloc/alerts_state.dart';
import 'alert_detail_screen.dart';
import '../../../../injection/injection.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  static const _filters = ['Todas', 'DIAN', 'MinCIT', 'ICA/INVIMA'];

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
        body: BlocBuilder<AlertsBloc, AlertsState>(
          builder: (ctx, state) {
            return Column(children: [
              // Search bar
              Container(
                color: AppColors.primaryDarkNavy,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: TextFormField(
                  style:
                      AppTextStyles.bodyRegular.copyWith(color: Colors.white),
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
              // Filters
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((f) {
                      final active = state is AlertsLoaded
                          ? state.activeFilter == f
                          : f == 'Todas';
                      return GestureDetector(
                        onTap: () =>
                            ctx.read<AlertsBloc>().add(FilterAlerts(f)),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primaryDarkNavy
                                : AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: active
                                    ? AppColors.primaryDarkNavy
                                    : AppColors.border),
                          ),
                          child: Text(f,
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: active
                                      ? Colors.white
                                      : AppColors.textSecondary)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Divider(height: 1),
              // Content
              Expanded(child: _buildContent(ctx, state)),
            ]);
          },
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
        itemBuilder: (_, i) => _AlertCard(alert: state.filtered[i]),
      );
    }
    return const SizedBox.shrink();
  }
}

class _AlertCard extends StatelessWidget {
  final AlertEntity alert;
  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final (borderColor, badgeColor, label) = alert.priority.style;
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => AlertDetailScreen(alert: alert))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: borderColor, width: 4)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: badgeColor, borderRadius: BorderRadius.circular(20)),
                child: Text(label,
                    style: AppTextStyles.badgeText
                        .copyWith(fontSize: 9, color: Colors.white)),
              ),
              const Spacer(),
              Text(alert.date, style: AppTextStyles.caption),
            ]),
            const SizedBox(height: 8),
            Text(alert.title,
                style: AppTextStyles.bodyRegular
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(alert.summary,
                style: AppTextStyles.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Row(children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                    color: AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.account_balance_rounded,
                    size: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 6),
              Text(alert.institution, style: AppTextStyles.caption),
              const Spacer(),
              OutlinedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AlertDetailScreen(alert: alert))),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDarkNavy,
                  side: const BorderSide(color: AppColors.border),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Ver Detalles',
                    style: AppTextStyles.caption
                        .copyWith(fontWeight: FontWeight.w600)),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
