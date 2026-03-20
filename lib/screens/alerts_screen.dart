import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../features/alerts/domain/entities/alert_entity.dart';
import 'alert_detail_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedFilter = 'Todas';
  final _filters = ['Todas', 'DIAN', 'MinCIT', 'ICA/INVIMA'];

  final _alerts = const [
    AlertEntity(priority: AlertPriority.alta, date: '14 Oct 2024',
      title: 'Nuevo Decreto DIAN 1234 – Cambios en declaración de exportación',
      summary: 'La DIAN modifica los formularios y requisitos para la declaración de exportación. Vigente desde el 1 de noviembre.',
      institution: 'DIAN'),
    AlertEntity(priority: AlertPriority.media, date: '12 Oct 2024',
      title: 'Actualización de aranceles para productos agrícolas',
      summary: 'MinCIT actualiza las tasas arancelarias para 42 subpartidas del sector agrícola.',
      institution: 'MinCIT'),
    AlertEntity(priority: AlertPriority.tlc, date: '10 Oct 2024',
      title: 'TLC Colombia–Indonesia – Nuevas oportunidades de exportación',
      summary: 'Entrada en vigor del TLC con Indonesia que reduce aranceles para 380 productos colombianos.',
      institution: 'MinCIT'),
    AlertEntity(priority: AlertPriority.informativo, date: '08 Oct 2024',
      title: 'INVIMA actualiza lista de productos con Registro Sanitario',
      summary: 'Se actualiza la lista de productos que requieren registro sanitario obligatorio.',
      institution: 'INVIMA'),
    AlertEntity(priority: AlertPriority.baja, date: '05 Oct 2024',
      title: 'Recordatorio: Actualización VUCE programada',
      summary: 'El portal VUCE tendrá mantenimiento el próximo fin de semana.',
      institution: 'MinCIT'),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedFilter == 'Todas'
        ? _alerts
        : _alerts.where((a) => a.institution.contains(_selectedFilter)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Alertas Regulatorias',
              style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
          Text('COLTRADE INTELLIGENCE',
              style: AppTextStyles.labelUppercase.copyWith(color: const Color(0xFF94A3B8), fontSize: 9)),
        ]),
        leading: Navigator.canPop(context)
            ? IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18), onPressed: () => Navigator.pop(context))
            : null,
        actions: [IconButton(icon: const NotificationBell(hasNotification: true), onPressed: () {})],
      ),
      body: Column(children: [
        Container(
          color: AppColors.primaryDarkNavy,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: TextFormField(
            style: AppTextStyles.bodyRegular.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Buscar alertas, decretos, normas...',
              hintStyle: AppTextStyles.bodySmall.copyWith(color: Colors.white38),
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF1E3A5F),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: _filters.map((f) {
              final active = f == _selectedFilter;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = f),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primaryDarkNavy : AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: active ? AppColors.primaryDarkNavy : AppColors.border),
                  ),
                  child: Text(f, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600,
                      color: active ? Colors.white : AppColors.textSecondary)),
                ),
              );
            }).toList()),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (_, i) => _buildAlertCard(filtered[i]),
          ),
        ),
      ]),
    );
  }

  Widget _buildAlertCard(AlertEntity alert) {
    final (borderColor, badgeColor, label) = alert.priority.style;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AlertDetailScreen(alert: alert))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: borderColor, width: 4)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(20)),
                child: Text(label, style: AppTextStyles.badgeText.copyWith(fontSize: 9, color: Colors.white)),
              ),
              const Spacer(),
              Text(alert.date, style: AppTextStyles.caption),
            ]),
            const SizedBox(height: 8),
            Text(alert.title,
                style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(alert.summary, style: AppTextStyles.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Row(children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(color: AppColors.surfaceGray, borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.account_balance_rounded, size: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 6),
              Text(alert.institution, style: AppTextStyles.caption),
              const Spacer(),
              OutlinedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AlertDetailScreen(alert: alert))),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDarkNavy,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Ver Detalles', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
