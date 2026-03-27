import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import 'quiz_screen.dart';

class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({super.key});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  bool _isPlaying = false;
  int _currentLesson = 3;

  final _lessons = [
    (false, 'Lección 1', 'Introducción a la logística'),
    (false, 'Lección 2', 'Documentos de exportación'),
    (true, 'Lección 3', 'El flujo de una exportación'),
    (false, 'Lección 4', 'Cálculo de costos'),
    (false, 'Lección 5', 'Optimización de rutas'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ColTradeAppBar(
        dark: true,
        title: 'Introducción al Comercio Exterior',
        actions: [
          IconButton(
            icon: const Icon(Icons.link_rounded, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // Video player
          _buildVideoPlayer(),

          // Metadata
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _metaBadge('LECCIÓN 3'),
                      const SizedBox(width: 6),
                      _metaBadge('INTERMEDIO'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('El flujo de una exportación',
                      style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 16),

                  // Content tabs
                  _buildContentTabs(),
                  const SizedBox(height: 16),

                  // Lesson list
                  ..._lessons
                      .asMap()
                      .entries
                      .map((e) => _buildLessonItem(e.key + 1, e.value))
                      .toList(),

                  const SizedBox(height: 20),
                  CTAButton(
                    label: 'Completar Lección →',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: double.infinity,
      height: 220,
      color: const Color(0xFF0A1628),
      child: Stack(
        children: [
          // Placeholder background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A1628), Color(0xFF1E3A5F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(Icons.directions_boat_rounded,
                  size: 80, color: Colors.white10),
            ),
          ),

          // Play button
          Center(
            child: GestureDetector(
              onTap: () => setState(() => _isPlaying = !_isPlaying),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white54, width: 2),
                ),
                child: Icon(
                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),

          // Progress bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('08:24',
                          style: GoogleFonts.robotoMono(
                              fontSize: 12, color: Colors.white)),
                      Row(
                        children: [
                          const Icon(Icons.settings_rounded,
                              color: Colors.white54, size: 16),
                          const SizedBox(width: 8),
                          const Icon(Icons.fullscreen_rounded,
                              color: Colors.white54, size: 18),
                        ],
                      ),
                      Text('24:15',
                          style: GoogleFonts.robotoMono(
                              fontSize: 12, color: Colors.white54)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  child: LinearProgressIndicator(
                    value: 8.4 / 24.25,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.colombiaYellow),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label, style: AppTextStyles.caption),
    );
  }

  Widget _buildContentTabs() {
    return Row(
      children: ['Contenido', 'Recursos', 'Preguntas'].map((tab) {
        final active = tab == 'Contenido';
        return Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? AppColors.primaryDarkNavy : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            tab,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: active ? AppColors.textPrimary : AppColors.textLabel,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLessonItem(
      int num, (bool completed, String label, String title) data) {
    final (completed, label, title) = data;
    final isCurrent = num == _currentLesson;

    if (isCurrent) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primaryDarkNavy,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('VIENDO AHORA',
                      style: AppTextStyles.labelUppercase.copyWith(
                          color: AppColors.accentOrange, fontSize: 9)),
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ],
              ),
            ),
            const Icon(Icons.more_vert_rounded,
                color: Colors.white54, size: 18),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: completed ? AppColors.successGreen : Colors.transparent,
              border: completed
                  ? null
                  : Border.all(color: AppColors.border, width: 1.5),
              shape: BoxShape.circle,
            ),
            child: completed
                ? const Icon(Icons.check, color: Colors.white, size: 12)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(),
                    style: AppTextStyles.labelUppercase.copyWith(fontSize: 9)),
                Text(title,
                    style: AppTextStyles.bodyRegular.copyWith(
                        color: completed
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        fontSize: 14)),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded,
              color: AppColors.textLabel, size: 16),
        ],
      ),
    );
  }
}

