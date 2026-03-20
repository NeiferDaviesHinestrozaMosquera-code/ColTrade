import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../../theme/app_theme.dart';

enum AlertPriority { alta, media, baja, informativo, tlc }

extension AlertPriorityStyle on AlertPriority {
  (Color border, Color badge, String label) get style => switch (this) {
        AlertPriority.alta => (AppColors.errorRed, AppColors.errorRed, 'ALTA PRIORIDAD'),
        AlertPriority.media => (AppColors.yellowAmber, AppColors.yellowAmber, 'PRIORIDAD MEDIA'),
        AlertPriority.baja => (AppColors.textLabel, AppColors.textSecondary, 'BAJA PRIORIDAD'),
        AlertPriority.informativo => (AppColors.infoBlue, AppColors.infoBlue, 'INFORMATIVO'),
        AlertPriority.tlc => (AppColors.successGreen, AppColors.successGreen, 'ACTUALIZACIÓN TLC'),
      };
}

class AlertEntity extends Equatable {
  final AlertPriority priority;
  final String date;
  final String title;
  final String summary;
  final String institution;

  const AlertEntity({
    required this.priority,
    required this.date,
    required this.title,
    required this.summary,
    required this.institution,
  });

  @override
  List<Object> get props => [priority, date, title, summary, institution];
}
