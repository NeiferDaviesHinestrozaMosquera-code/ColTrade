import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import 'package:go_router/go_router.dart';

class DocumentsTab extends StatelessWidget {
  const DocumentsTab({super.key});

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
              title: Text('Documentos',
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
          _buildDocCard(
            context,
            Icons.checklist_rounded,
            'Checklist Inteligente',
            'Documentos Pendientes por Carga',
            '12 Pendientes',
            Colors.orange,
            () => context.push('/checklist'),
          ),
          const SizedBox(height: 16),
          _buildDocCard(
            context,
            Icons.history_rounded,
            'Repositorio Histórico',
            'Archivo Legal y Expedientes',
            '4,520 Archivos',
            AppColors.successGreen,
            () => context.push('/repository'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocCard(BuildContext context, IconData icon, String title, String subtitle, String badgeText, Color badgeColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDarkNavy.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: AppColors.primaryDarkNavy, size: 28),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(badgeText, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: badgeColor)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(title,
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDarkNavy)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(subtitle,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textLabel, fontSize: 13)),
                ),
                const Icon(Icons.arrow_forward_rounded, color: AppColors.textLabel, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
