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

class OperationsTab extends StatelessWidget {
  const OperationsTab({super.key});

  // ── Operaciones ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ColTradeAppBar(title: 'Operaciones'),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _operationTile(
            icon: Icons.upload_rounded,
            title: 'Nueva Exportación',
            subtitle: 'Iniciar proceso de exportación',
            color: AppColors.successGreen,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ExportAssistantScreen())),
          ),
          const SizedBox(height: 12),
          _operationTile(
            icon: Icons.download_rounded,
            title: 'Nueva Importación',
            subtitle: 'Iniciar proceso de importación',
            color: AppColors.infoBlue,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ImportAssistantScreen())),
          ),
          const SizedBox(height: 12),
          _operationTile(
            icon: Icons.checklist_rounded,
            title: 'Checklist Inteligente',
            subtitle: 'Gestiona tus documentos',
            color: AppColors.accentOrange,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ChecklistScreen())),
          ),
          const SizedBox(height: 12),
          _operationTile(
            icon: Icons.search_rounded,
            title: 'Clasificador NANDINA',
            subtitle: 'Clasifica tu producto con IA',
            color: Colors.purple,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NandinaClassifierScreen())),
          ),
        ],
      ),
    );
  }

  Widget _operationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.card,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }


}
