import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'lesson_player_screen.dart';

// ─── Data Model ───────────────────────────────────────────────────────────────
class _Tutorial {
  final String id;
  final String title;
  final String duration;
  final String category;
  final double progress;
  final IconData thumbIcon;
  final Color thumbColor;

  const _Tutorial({
    required this.id,
    required this.title,
    required this.duration,
    required this.category,
    required this.progress,
    required this.thumbIcon,
    required this.thumbColor,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  static const _categories = ['Todos', 'Exportaciones', 'Importaciones', 'Herramientas', 'DIAN'];
  String _selected = 'Todos';

  static const List<_Tutorial> _all = [
    _Tutorial(
      id: 't1',
      title: 'Cómo hacer tu primera exportación paso a paso',
      duration: '18:42',
      category: 'Exportaciones',
      progress: 1.0,
      thumbIcon: Icons.upload_rounded,
      thumbColor: AppColors.successGreen,
    ),
    _Tutorial(
      id: 't2',
      title: 'Proceso de importación desde China en 2026',
      duration: '24:15',
      category: 'Importaciones',
      progress: 0.35,
      thumbIcon: Icons.download_rounded,
      thumbColor: AppColors.infoBlue,
    ),
    _Tutorial(
      id: 't3',
      title: 'Clasificación NANDINA con inteligencia artificial',
      duration: '11:50',
      category: 'Herramientas',
      progress: 0.0,
      thumbIcon: Icons.smart_toy_outlined,
      thumbColor: Color(0xFF8B5CF6),
    ),
    _Tutorial(
      id: 't4',
      title: 'Declaración de exportación ante la DIAN',
      duration: '31:07',
      category: 'DIAN',
      progress: 0.6,
      thumbIcon: Icons.gavel_rounded,
      thumbColor: AppColors.accentOrange,
    ),
    _Tutorial(
      id: 't5',
      title: 'Calculadora de costos: Landed Cost explicado',
      duration: '14:22',
      category: 'Herramientas',
      progress: 0.0,
      thumbIcon: Icons.calculate_outlined,
      thumbColor: AppColors.yellowAmber,
    ),
    _Tutorial(
      id: 't6',
      title: 'Aprovecha el TLC Colombia–Unión Europea',
      duration: '22:03',
      category: 'Exportaciones',
      progress: 0.0,
      thumbIcon: Icons.flag_outlined,
      thumbColor: AppColors.colombiaBlue,
    ),
    _Tutorial(
      id: 't7',
      title: 'Arancel de aduanas 2026: novedades DIAN',
      duration: '09:55',
      category: 'DIAN',
      progress: 0.0,
      thumbIcon: Icons.article_outlined,
      thumbColor: AppColors.errorRed,
    ),
    _Tutorial(
      id: 't8',
      title: 'Gestión de agentes aduanales en Colombia',
      duration: '16:40',
      category: 'Importaciones',
      progress: 0.0,
      thumbIcon: Icons.people_outline_rounded,
      thumbColor: Colors.teal,
    ),
  ];

  List<_Tutorial> get _filtered =>
      _selected == 'Todos' ? _all : _all.where((t) => t.category == _selected).toList();

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ColTradeAppBar(title: 'Tutoriales'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Featured Banner ──────────────────────────────────────────────
          _buildFeaturedBanner(context),
          const SizedBox(height: 20),

          // ── Category Chips ───────────────────────────────────────────────
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final active = cat == _selected;
                return GestureDetector(
                  onTap: () => setState(() => _selected = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primaryDarkNavy : AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active ? AppColors.primaryDarkNavy : AppColors.border,
                      ),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: AppColors.primaryDarkNavy.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    child: Text(
                      cat,
                      style: AppTextStyles.caption.copyWith(
                        color: active ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // ── Count ────────────────────────────────────────────────────────
          Text('${filtered.length} videos',
              style: AppTextStyles.labelUppercase),
          const SizedBox(height: 12),

          // ── Grid ─────────────────────────────────────────────────────────
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (_, i) => _buildVideoCard(context, filtered[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedBanner(BuildContext context) {
    final featured = _all[1]; // "Proceso de importación..."
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LessonPlayerScreen()),
      ),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F1C3F), Color(0xFF1E3A5F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            // Decorative circle
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('DESTACADO',
                        style: AppTextStyles.badgeText
                            .copyWith(fontSize: 9, color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    featured.title,
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.play_circle_filled_rounded,
                          color: AppColors.accentOrange, size: 20),
                      const SizedBox(width: 6),
                      Text('Reproducir · ${featured.duration}',
                          style: AppTextStyles.caption
                              .copyWith(color: Colors.white70, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text('${(featured.progress * 100).round()}% visto',
                          style: AppTextStyles.caption.copyWith(color: Colors.white54)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: featured.progress,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentOrange),
                      minHeight: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, _Tutorial tutorial) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LessonPlayerScreen()),
      ),
      child: Container(
        decoration: AppDecorations.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: tutorial.thumbColor.withValues(alpha: 0.12),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(tutorial.thumbIcon,
                        size: 44, color: tutorial.thumbColor.withValues(alpha: 0.4)),
                  ),
                  Center(
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: tutorial.thumbColor.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  // Duration chip
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(tutorial.duration,
                          style: GoogleFonts.robotoMono(
                              fontSize: 10, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tutorial.title,
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (tutorial.progress > 0) ...[
                      Text('${(tutorial.progress * 100).round()}% visto',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.accentOrange, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: tutorial.progress,
                          backgroundColor: AppColors.border,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(AppColors.accentOrange),
                          minHeight: 3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
