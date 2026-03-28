import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class ChecklistProgress extends StatelessWidget {
  final double progress;
  const ChecklistProgress({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PROGRESO DEL PROCESO', style: AppTextStyles.labelUppercase),
              Text('$pct%',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.accentOrange),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
