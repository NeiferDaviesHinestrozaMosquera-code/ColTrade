import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class EntitiesTab extends StatelessWidget {
  const EntitiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final entities = [
      (
        'DIAN',
        'Dirección de Impuestos y Aduanas Nacionales',
        Icons.account_balance_rounded,
        AppColors.primaryDarkNavy,
        true
      ),
      (
        'ICA',
        'Instituto Colombiano Agropecuario',
        Icons.eco_rounded,
        AppColors.successGreen,
        false
      ),
      (
        'INVIMA',
        'Instituto Nacional de Vigilancia',
        Icons.health_and_safety_outlined,
        AppColors.infoBlue,
        false
      ),
      (
        'MinCIT',
        'Ministerio de Comercio, Industria y Turismo',
        Icons.business_center_outlined,
        AppColors.accentOrange,
        false
      ),
      (
        'VUCE',
        'Ventanilla Única de Comercio Exterior',
        Icons.computer_outlined,
        Colors.teal,
        false
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: entities.length,
      itemBuilder: (context, index) {
        final (code, name, icon, color, connected) = entities[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: AppDecorations.card,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(code, style: AppTextStyles.cardTitle),
                    Text(name,
                        style: AppTextStyles.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              if (connected)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                              color: AppColors.successGreen,
                              shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text('Conectado',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.successGreen)),
                    ],
                  ),
                )
              else
                Text('Conectar',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.accentOrange)),
            ],
          ),
        );
      },
    );
  }
}
