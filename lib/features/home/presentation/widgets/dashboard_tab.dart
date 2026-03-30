import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../checklist/presentation/screens/checklist_screen.dart';
import '../../../profile/presentation/screens/notifications_screen.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  // ── Dashboard ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.primaryDarkNavy,
          expandedHeight: 0,
          toolbarHeight: kToolbarHeight,
          title: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.accentOrange,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.business_rounded,
                    color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Text('ColTrade',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
          actions: [
            IconButton(
              icon: const NotificationBell(hasNotification: true),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(
                      builder: (_) => const NotificationsScreen())),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hola, Empresa Exportadora',
                    style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('Resumen de operaciones para hoy',
                    style: AppTextStyles.bodySmall),
                const SizedBox(height: 32),

                SectionHeader(title: 'Cargas Activas', action: 'VER TODO'),
                const SizedBox(height: 12),
                _buildShipmentCard(
                  context: context,
                  badge: BadgeStatus.exportacion,
                  title: 'Café Premium a España',
                  id: 'CT-48293',
                  eta: '25 Oct',
                  statusLabel: 'EN TRÁNSITO (ATLÁNTICO)',
                  statusColor: AppColors.textSecondary,
                  progress: 0.80,
                  icon: Icons.coffee_rounded,
                  iconColor: Colors.brown,
                ),
                const SizedBox(height: 12),
                _buildShipmentCard(
                  context: context,
                  badge: BadgeStatus.importacion,
                  title: 'Electrónicos desde China',
                  id: 'CT-92104',
                  eta: 'Buenaventura',
                  statusLabel: 'ADUANA – REVISIÓN DIAN',
                  statusColor: AppColors.errorRed,
                  progress: 0.25,
                  icon: Icons.memory_rounded,
                  iconColor: Colors.teal,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ChecklistScreen())),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShipmentCard({
    required BuildContext context,
    required BadgeStatus badge,
    required String title,
    required String id,
    required String eta,
    required String statusLabel,
    required Color statusColor,
    required double progress,
    required IconData icon,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatusBadge(status: badge),
                const Spacer(),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(title, style: AppTextStyles.cardTitle),
            const SizedBox(height: 4),
            Text('ID: $id · Puerto/ETA: $eta', style: AppTextStyles.caption),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryDarkNavy),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(statusLabel,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: statusColor == AppColors.errorRed
                          ? FontWeight.w700
                          : FontWeight.normal,
                      color: statusColor,
                    )),
                Text('Detalles →',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.accentOrange)),
              ],
            ),
          ],
        ),
      ),
    );
  }


}
