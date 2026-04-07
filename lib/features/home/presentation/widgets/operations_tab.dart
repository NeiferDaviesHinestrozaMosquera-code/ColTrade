import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import 'package:go_router/go_router.dart';

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
            icon: Icons.search_rounded,
            title: 'Clasificador NANDINA',
            subtitle: 'Paso previo: Clasifica tu producto con IA',
            gradientColors: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
            onTap: () => context.push('/nandina-classifier'),
          ),
          const SizedBox(height: 16),
          _operationTile(
            icon: Icons.upload_rounded,
            title: 'Nueva Exportación',
            subtitle: 'Iniciar proceso de exportación',
            gradientColors: const [Color(0xFF10B981), Color(0xFF047857)],
            onTap: () => context.push('/export-assistant'),
          ),
          const SizedBox(height: 16),
          _operationTile(
            icon: Icons.download_rounded,
            title: 'Nueva Importación',
            subtitle: 'Iniciar proceso de importación',
            gradientColors: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            onTap: () => context.push('/import-assistant'),
          ),
        ],
      ),
    );
  }

  Widget _operationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: Icon(icon, size: 100, color: Colors.white.withValues(alpha: 0.15)),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, 
                          style: GoogleFonts.inter(
                              color: Colors.white, 
                              fontSize: 18, 
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(subtitle, 
                          style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.9), 
                              fontSize: 13,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }


}
