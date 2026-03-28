import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../alerts/presentation/screens/alerts_screen.dart';
import '../../../checklist/presentation/screens/checklist_screen.dart';
import '../../../calculator/presentation/screens/calculator_screen.dart';
import '../../../security/presentation/screens/security_screen.dart';
import '../bloc/home_bloc.dart';
import '../../../assistant/presentation/screens/export_assistant_screen.dart';
import '../../../assistant/presentation/screens/import_assistant_screen.dart';
import '../../../academy/presentation/screens/knowledge_center_screen.dart';
import '../../../assistant/presentation/screens/nandina_classifier_screen.dart';
import '../../../assistant/presentation/screens/agents_screen.dart';
import '../../../profile/presentation/screens/personal_info_screen.dart';
import '../../../profile/presentation/screens/company_info_screen.dart';
import '../../../profile/presentation/screens/notifications_screen.dart';
import '../../../profile/presentation/screens/notification_settings_screen.dart';
import '../../../profile/presentation/screens/my_tickets_screen.dart';
import '../../../profile/presentation/screens/tutorials_screen.dart';
import '../../../profile/presentation/screens/support_screen.dart';
import '../../../erp/presentation/screens/api_erp_screen.dart';
import '../../../logistics/presentation/screens/logistics_screen.dart';
import '../../../history/presentation/screens/history_screen.dart';
import '../../../repository/presentation/screens/repository_screen.dart';

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
                const SizedBox(height: 24),
                SizedBox(
                  height: 160,
                  child: GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      QuickAccessItem(
                        icon: Icons.smart_toy_outlined,
                        label: 'Asistente',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ExportAssistantScreen())),
                      ),
                      QuickAccessItem(
                        icon: Icons.calculate_outlined,
                        label: 'Cálculo',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CalculatorScreen())),
                      ),
                      QuickAccessItem(
                        icon: Icons.people_outline_rounded,
                        label: 'Agentes',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AgentsScreen())),
                      ),
                      QuickAccessItem(
                        icon: Icons.school_outlined,
                        label: 'Cursos',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const KnowledgeCenterScreen())),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // ── Notifications quick-access card ───────────────────────
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationsScreen())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.colombiaBlue, Color(0xFF0050C8)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColors.colombiaBlue.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                              Icons.notifications_active_rounded,
                              color: Colors.white,
                              size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Notificaciones & Alertas',
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              const SizedBox(height: 2),
                              Text('3 notificaciones sin leer',
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: Colors.white70)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Ver →',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

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
