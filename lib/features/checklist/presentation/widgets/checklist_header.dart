import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class ChecklistHeader extends StatelessWidget {
  const ChecklistHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('COLTRADE AI',
              style: AppTextStyles.labelUppercase
                  .copyWith(color: const Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          Text('Exportación de Aguacate Hass',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: Color(0xFFCBD5E1)),
              const SizedBox(width: 4),
              Text('Destino: Puerto de Rotterdam, NL',
                  style: AppTextStyles.caption
                      .copyWith(color: const Color(0xFFCBD5E1))),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade800, Colors.green.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text('🥑', style: TextStyle(fontSize: 60)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
