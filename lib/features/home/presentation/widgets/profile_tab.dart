import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  // ── Perfil ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ColTradeAppBar(title: 'Perfil', dark: true),
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
          const SizedBox(height: 24),
          _buildSubscriptionBanner(context, isPro: true),
          _profileSection('CONFIGURACIÓN', [
            _profileItem(
              Icons.person_outline,
              'Información Personal',
              'Datos de tu perfil',
              onTap: () => context.push('/personal-info'),
            ),
            _profileItem(
              Icons.business_outlined,
              'Empresa',
              'TechCorp Solutions',
              onTap: () => context.push('/company-info'),
            ),
            _profileItem(
              Icons.security_outlined,
              'Seguridad',
              'Contraseña y 2FA',
              onTap: () => context.push('/security'),
            ),
            _profileItem(Icons.notifications_outlined, 'Notificaciones',
                'Alertas y frecuencia',
                badge: 'ENT',
                onTap: () => context.push('/notification-settings')),
            _profileItem(Icons.api_outlined, 'API / ERP', 'Sincronización SAP',
                badge: 'ENT',
                onTap: () => context.push('/api-erp')),
          ]),
          const SizedBox(height: 16),
          _profileSection('CENTRO DE AYUDA', [
            _profileItem(Icons.confirmation_number_outlined, 'Mis Tickets',
                'Soporte activo',
                onTap: () => context.push('/my-tickets')),
            _profileItem(
                Icons.school_outlined, 'Academia', 'Cursos y aprendizaje',
                onTap: () => context.push('/knowledge-center')),
            _profileItem(
                Icons.play_circle_outline, 'Tutoriales', 'Videos de ayuda',
                onTap: () => context.push('/tutorials')),
          ]),
          const SizedBox(height: 16),
          CTAButton(
              label: '💬  Contactar Soporte',
              onTap: () => context.push('/support')),
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

  Widget _buildSubscriptionBanner(BuildContext context, {bool isPro = true}) {
    if (isPro) {
      return Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryDarkNavy, Color(0xFF1E3A8A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDarkNavy.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_rounded,
                  color: AppColors.yellowAmber, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Plan PRO Activo',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Acceso total a inteligencia artificial y asistentes',
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => context.push('/subscription-plans'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: Size.zero,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text('Gestionar',
                  style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.bolt_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Desbloquea todo el potencial',
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text('Potencia tus operaciones con ColTrade PRO',
                    style: AppTextStyles.caption
                        .copyWith(color: Colors.white.withValues(alpha: 0.9))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => context.push('/subscription-plans'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFD97706),
              elevation: 0,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: Text('Mejorar',
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
