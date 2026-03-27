import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/history_item.dart';

class HistoryItemCard extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback? onTap;

  const HistoryItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  IconData _getCategoryIcon() {
    switch (item.category) {
      case HistoryCategory.aranceles:
        return Icons.search_rounded;
      case HistoryCategory.cotizacion:
        return Icons.calculate_rounded;
      case HistoryCategory.checklist:
        return Icons.checklist_rounded;
      case HistoryCategory.rutas:
        return Icons.map_outlined;
      case HistoryCategory.otros:
        return Icons.history_rounded;
    }
  }

  Color _getCategoryColor() {
    switch (item.category) {
      case HistoryCategory.aranceles:
        return Colors.purple;
      case HistoryCategory.cotizacion:
        return AppColors.primaryDarkNavy;
      case HistoryCategory.checklist:
        return AppColors.accentOrange;
      case HistoryCategory.rutas:
        return const Color(0xFF0EA5E9);
      case HistoryCategory.otros:
        return AppColors.textSecondary;
    }
  }

  Color _getImportanceColor() {
    switch (item.importance) {
      case HistoryImportance.alta:
        return AppColors.errorRed;
      case HistoryImportance.media:
        return AppColors.yellowAmber;
      case HistoryImportance.baja:
        return AppColors.successGreen;
    }
  }

  String _formatDate() {
    return DateFormat('dd MMM yyyy, HH:mm').format(item.date);
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _getCategoryColor();
    final impColor = _getImportanceColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Category Icon + Importance Badge + Date
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_getCategoryIcon(), color: catColor, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.category.name.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: catColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                // Importance Badge
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: impColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  item.importance.name.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: impColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Title and Subtitle
            Text(
              item.title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),

            // Footer: Date
            Row(
              children: [
                Icon(Icons.access_time_rounded,
                    size: 14, color: AppColors.textLabel),
                const SizedBox(width: 4),
                Text(
                  _formatDate(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textLabel,
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 12, color: AppColors.border.withValues(alpha: 0.8)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
