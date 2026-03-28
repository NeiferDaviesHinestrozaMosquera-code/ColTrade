import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/alert_entity.dart';
import '../screens/alert_detail_screen.dart';
import '../utils/alert_priority_styles.dart';

class AlertCard extends StatelessWidget {
  final AlertEntity alert;
  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    // Note: We leave Navigator.push for now, Phase 7 will migrate it to GoRouter.
    final (borderColor, badgeColor, label) = alert.priority.style;
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => AlertDetailScreen(alert: alert))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: borderColor, width: 4)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: badgeColor, borderRadius: BorderRadius.circular(20)),
                child: Text(label,
                    style: AppTextStyles.badgeText
                        .copyWith(fontSize: 9, color: Colors.white)),
              ),
              const Spacer(),
              Text(alert.date, style: AppTextStyles.caption),
            ]),
            const SizedBox(height: 8),
            Text(alert.title,
                style: AppTextStyles.bodyRegular
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(alert.summary,
                style: AppTextStyles.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Row(children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                    color: AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.account_balance_rounded,
                    size: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 6),
              Text(alert.institution, style: AppTextStyles.caption),
              const Spacer(),
              OutlinedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AlertDetailScreen(alert: alert))),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDarkNavy,
                  side: const BorderSide(color: AppColors.border),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Ver Detalles',
                    style: AppTextStyles.caption
                        .copyWith(fontWeight: FontWeight.w600)),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
