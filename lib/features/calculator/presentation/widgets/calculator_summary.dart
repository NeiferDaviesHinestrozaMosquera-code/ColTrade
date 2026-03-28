import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/calculator_bloc.dart';

class CalculatorSummary extends StatelessWidget {
  const CalculatorSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecorations.darkCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Calculation Summary',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D3D60),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('ESTIMATED CIF BASE',
                        style: AppTextStyles.badgeText.copyWith(
                            color: Colors.white60, fontSize: 9)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _calcRow('CIF Value (FOB + Freight + Ins.)',
                  '\$${state.cif.toStringAsFixed(2)}', Colors.white),
              _calcRow(
                  'Customs Duty (${state.dutyPercent.toStringAsFixed(0)}%)',
                  '\$${state.duty.toStringAsFixed(2)}',
                  Colors.white70),
              _calcRow('VAT (IVA 19%)',
                  '\$${state.iva.toStringAsFixed(2)}', Colors.white70),
              _calcRow(
                  'Customs Agency Fee',
                  '\$${state.agencyFee.toStringAsFixed(2)}',
                  Colors.white70),
              _calcRow(
                  'Port/Storage Fees',
                  '\$${state.portFees.toStringAsFixed(2)}',
                  Colors.white70),
              const Divider(color: Color(0xFF2D3D60), height: 20),
              Text('FINAL LANDED COST',
                  style: AppTextStyles.labelUppercase
                      .copyWith(color: Colors.white60)),
              const SizedBox(height: 4),
              Text(
                '\$${state.totalLanded.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentOrange),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentOrange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.save_outlined, size: 16),
                      label: Text('Save Quote',
                          style: AppTextStyles.buttonCTA),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF3D4F6E)),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.share_outlined,
                        color: Colors.white60, size: 18),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _calcRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: AppTextStyles.bodySmall
                    .copyWith(color: color.withValues(alpha: 0.8))),
          ),
          Text(value,
              style: AppTextStyles.bodyRegular
                  .copyWith(color: color, fontSize: 14)),
        ],
      ),
    );
  }
}
