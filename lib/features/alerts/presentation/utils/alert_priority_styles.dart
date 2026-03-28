import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/alert_entity.dart';

/// Presentation-layer styles for [AlertPriority].
/// Moved here from the domain entity to keep domain free of Flutter imports.
extension AlertPriorityStyle on AlertPriority {
  (Color border, Color badge, String label) get style => switch (this) {
        AlertPriority.alta => (
            AppColors.errorRed,
            AppColors.errorRed,
            'ALTA PRIORIDAD'
          ),
        AlertPriority.media => (
            AppColors.yellowAmber,
            AppColors.yellowAmber,
            'PRIORIDAD MEDIA'
          ),
        AlertPriority.baja => (
            AppColors.textLabel,
            AppColors.textSecondary,
            'BAJA PRIORIDAD'
          ),
        AlertPriority.informativo => (
            AppColors.infoBlue,
            AppColors.infoBlue,
            'INFORMATIVO'
          ),
        AlertPriority.tlc => (
            AppColors.successGreen,
            AppColors.successGreen,
            'ACTUALIZACIÓN TLC'
          ),
      };
}
