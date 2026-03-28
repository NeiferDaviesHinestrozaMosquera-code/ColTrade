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

class ToolsTab extends StatelessWidget {
  const ToolsTab({super.key});

  // ── Herramientas ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 3),
        child: Column(
          children: [
            const ColombiaTricolorBar(),
            AppBar(
              backgroundColor: AppColors.primaryDarkNavy,
              title: Text('Herramientas',
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              automaticallyImplyLeading: false,
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF0891B2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Asistente IA',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Clasificación inteligente y checklist automático',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: Colors.white70)),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: AppColors.successGreen,
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text('Disponible ahora',
                              style: AppTextStyles.caption
                                  .copyWith(color: Colors.white70)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const NandinaClassifierScreen())),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Abrir Asistente',
                                  style: AppTextStyles.caption.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CalculatorScreen())),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryDarkNavy,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Calculadora de Costos',
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('Landed Cost Pro – Calcula tu costo real',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: Colors.white60)),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white60),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('📊 Nueva Cotización',
                              style: AppTextStyles.caption
                                  .copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.calculate_rounded,
                      color: Colors.white30, size: 60),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.4,
            children: [
              _toolCard(
                  Icons.folder_outlined, 'Repositorio', 'Gestiona documentos',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RepositoryScreen()))),
              _toolCard(
                  Icons.history_rounded, 'Historial', 'Últimas consultas',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen()))),
              _toolCard(
                  Icons.notifications_outlined, 'Alertas', 'Regulaciones DIAN',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AlertsScreen()))),
              _toolCard(Icons.map_outlined, 'Logística', 'Puertos y rutas',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LogisticsScreen()))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toolCard(IconData icon, String title, String subtitle,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceGray,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryDarkNavy, size: 26),
            const SizedBox(height: 8),
            Text(title,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Flexible(
              child: Text(subtitle,
                  style: AppTextStyles.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }


}
