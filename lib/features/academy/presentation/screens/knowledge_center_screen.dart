import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import 'lesson_player_screen.dart';

class KnowledgeCenterScreen extends StatefulWidget {
  const KnowledgeCenterScreen({super.key});

  @override
  State<KnowledgeCenterScreen> createState() => _KnowledgeCenterScreenState();
}

class _KnowledgeCenterScreenState extends State<KnowledgeCenterScreen> {
  int _selectedTab = 0;

  final _courses = [
    _Course('Logística Internacional Avanzada', 10, 8, 4.8, '12h 30m', 40),
    _Course('Clasificación Arancelaria NANDINA', 8, 0, 4.9, '8h 15m', 0),
    _Course('TLCs de Colombia: Oportunidades', 12, 0, 4.7, '15h 00m', 0),
    _Course('Gestión de Riesgo en Comercio Exterior', 6, 0, 4.6, '6h 45m', 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDarkNavy,
      appBar: ColTradeAppBar(
        dark: true,
        title: 'Centro de Conocimiento',
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            color: AppColors.primaryDarkNavy,
            child: Row(
              children: ['INICIO', 'CURSOS', 'WEBINARS', 'PERFIL']
                  .asMap()
                  .entries
                  .map((e) {
                final active = e.key == _selectedTab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = e.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: active
                                ? AppColors.accentOrange
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        e.value,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? AppColors.accentOrange
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Current course
                  Text('Curso Actual', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 12),
                  _buildCurrentCourse(),
                  const SizedBox(height: 24),

                  // Courses for you
                  SectionHeader(title: 'Cursos para ti', action: 'Ver todos'),
                  const SizedBox(height: 12),
                  ..._courses.skip(1).map((c) => _buildCourseCard(c)).toList(),
                  const SizedBox(height: 24),

                  // Live webinar
                  SectionHeader(title: 'Webinars en vivo', action: 'Ver todos'),
                  const SizedBox(height: 12),
                  _buildWebinarCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentCourse() {
    final course = _courses.first;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LessonPlayerScreen()),
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF0F1C3F), Color(0xFF1E3A5F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [AppDecorations.elevatedCard.boxShadow!.first],
        ),
        child: Stack(
          children: [
            // Background icon
            Positioned(
              right: -20,
              top: -20,
              child: Icon(Icons.directions_boat_rounded,
                  size: 120, color: Colors.white.withValues(alpha: 0.05)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title,
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(
                      'Módulo 4 de ${course.totalModules}: Optimización de rutas',
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white60)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progreso del curso ${course.progress}%',
                              style: AppTextStyles.caption
                                  .copyWith(color: Colors.white60),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: course.progress / 100,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.accentOrange),
                                minHeight: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDarkNavy,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text('Continuar lección',
                            style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ],
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

  Widget _buildCourseCard(_Course course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: AppDecorations.card,
      child: Row(
        children: [
          // Cover image placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryDarkNavy,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
            child: const Icon(Icons.school_rounded,
                color: Colors.white38, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title,
                      style: AppTextStyles.bodyRegular
                          .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${course.totalModules} lecciones · ${course.duration}',
                      style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Colors.amber, size: 12),
                      const SizedBox(width: 2),
                      Text(course.rating.toString(),
                          style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildWebinarCard() {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.primaryDarkNavy,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: AppColors.errorRed, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text('EN VIVO',
                          style: AppTextStyles.badgeText.copyWith(
                              fontSize: 10, color: AppColors.errorRed)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('PANEL DE EXPERTOS',
                            style: AppTextStyles.badgeText
                                .copyWith(fontSize: 9, color: Colors.white60)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                      'Nuevas oportunidades de exportación en TLC Colombia-Indonesia',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.people_rounded,
                          size: 14, color: Colors.white60),
                      const SizedBox(width: 4),
                      Text('342 participantes',
                          style: AppTextStyles.caption
                              .copyWith(color: Colors.white60)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorRed,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text('Unirme',
                            style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              top: 40,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Course {
  final String title;
  final int totalModules;
  final int completedModules;
  final double rating;
  final String duration;
  final int progress;

  _Course(this.title, this.totalModules, this.completedModules, this.rating,
      this.duration, this.progress);
}

