import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/alerts_bloc.dart';
import '../bloc/alerts_event.dart';

class AlertFilterTabs extends StatelessWidget {
  final String activeFilter;
  const AlertFilterTabs({super.key, required this.activeFilter});

  static const _filters = ['Todas', 'DIAN', 'MinCIT', 'ICA/INVIMA'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((f) {
            final active = activeFilter == f;
            return GestureDetector(
              onTap: () => context.read<AlertsBloc>().add(FilterAlerts(f)),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color:
                      active ? AppColors.primaryDarkNavy : AppColors.surfaceGray,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: active
                          ? AppColors.primaryDarkNavy
                          : AppColors.border),
                ),
                child: Text(f,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.white : AppColors.textSecondary)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
