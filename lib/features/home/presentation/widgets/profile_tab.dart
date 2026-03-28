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

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  // ── Perfil ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ColTradeAppBar(title: 'Perfil', dark: false),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.card,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryDarkNavy,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('CR',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.accentOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            color: Colors.white, size: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Carlos Rodriguez',
                    style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                Text('TechCorp Solutions', style: AppTextStyles.bodySmall),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDarkNavy,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('PLAN PRO',
                      style: AppTextStyles.badgeText
                          .copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _profileSection('CONFIGURACIÓN', [
            _profileItem(
              Icons.person_outline,
              'Información Personal',
              'Datos de tu perfil',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PersonalInfoScreen())),
            ),
            _profileItem(
              Icons.business_outlined,
              'Empresa',
              'TechCorp Solutions',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CompanyInfoScreen())),
            ),
            _profileItem(
              Icons.security_outlined,
              'Seguridad',
              'Contraseña y 2FA',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SecurityScreen())),
            ),
            _profileItem(Icons.notifications_outlined, 'Notificaciones',
                'Alertas y frecuencia',
                badge: 'ENT',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()))),
            _profileItem(Icons.api_outlined, 'API / ERP', 'Sincronización SAP',
                badge: 'ENT',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ApiErpScreen()))),
          ]),
          const SizedBox(height: 16),
          _profileSection('CENTRO DE AYUDA', [
            _profileItem(Icons.confirmation_number_outlined, 'Mis Tickets',
                'Soporte activo',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MyTicketsScreen()))),
            _profileItem(
                Icons.play_circle_outline, 'Tutoriales', 'Videos de ayuda',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const TutorialsScreen()))),
          ]),
          const SizedBox(height: 16),
          CTAButton(label: '💬  Contactar Soporte', onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SupportScreen()))),
        ],
      ),
    );
  }

  Widget _profileSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.labelUppercase),
        const SizedBox(height: 8),
        Container(
          decoration: AppDecorations.card,
          child: Column(
            children: items
                .asMap()
                .entries
                .map((e) => Column(
                      children: [
                        e.value,
                        if (e.key < items.length - 1) const Divider(height: 1),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _profileItem(IconData icon, String title, String subtitle,
      {String? badge, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Row(
        children: [
          Text(title,
              style: AppTextStyles.bodyRegular
                  .copyWith(fontWeight: FontWeight.w600)),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentOrange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(badge,
                  style: AppTextStyles.badgeText
                      .copyWith(fontSize: 9, color: Colors.white)),
            ),
          ],
        ],
      ),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: AppColors.textSecondary),
    );
  }


}
