import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import 'package:go_router/go_router.dart';

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

          GestureDetector(
            onTap: () => context.push('/calculator'),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDarkNavy, Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDarkNavy.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
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
                  Icons.people_outline_rounded, 'Agentes', 'Directorio de agentes',
                  const [Color(0xFFF59E0B), Color(0xFFD97706)], // Vibrant Orange/Amber
                  onTap: () => context.push('/agents')),
              _toolCard(Icons.map_outlined, 'Logística', 'Puertos y rutas',
                  const [Color(0xFF0EA5E9), Color(0xFF0284C7)], // Vibrant Light Blue
                  onTap: () => context.push('/logistics')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toolCard(IconData icon, String title, String subtitle, List<Color> gradientColors,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const Spacer(),
            Text(title,
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(subtitle,
                style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withValues(alpha: 0.9)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }


}
