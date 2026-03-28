import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/calculator_bloc.dart';

class CalculatorForm extends StatefulWidget {
  const CalculatorForm({super.key});

  @override
  State<CalculatorForm> createState() => _CalculatorFormState();
}

class _CalculatorFormState extends State<CalculatorForm> {
  final _fobCtrl = TextEditingController(text: '5000');
  final _insuranceCtrl = TextEditingController(text: '50');
  final _dutyCtrl = TextEditingController(text: '10');

  @override
  void dispose() {
    _fobCtrl.dispose();
    _insuranceCtrl.dispose();
    _dutyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        final bloc = context.read<CalculatorBloc>();
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card,
          child: Column(
            children: [
              _inputField('Product FOB Value (USD)', _fobCtrl,
                  prefix: '\$',
                  hint: '0.00',
                  onChanged: (v) => bloc.add(UpdateFob(double.tryParse(v) ?? 0))),
              const SizedBox(height: 14),
              _inputField('Insurance (USD)', _insuranceCtrl,
                  prefix: '\$',
                  hint: 'Min. 1% of FOB',
                  onChanged: (v) =>
                      bloc.add(UpdateInsurance(double.tryParse(v) ?? 0))),
              const SizedBox(height: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('International Freight Method',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBody)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGray,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        _freightOption(
                            '✈', 'Air Freight', 'air', state, bloc),
                        _freightOption(
                            '🚢', 'Sea Freight', 'sea', state, bloc),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Port of Entry',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBody)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: state.selectedPort,
                    decoration: AppDecorations.inputDecoration('', ''),
                    items: [
                      'Buenaventura (SPRB/TCBUEN)',
                      'Cartagena (SPRC)',
                      'Barranquilla (SPRB)',
                      'Santa Marta',
                    ]
                        .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p,
                                style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => bloc.add(UpdatePort(v!)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _inputField('Customs Duty (Arancel %)', _dutyCtrl,
                  suffix: '%',
                  hint: 'e.g. 5, 10, 15',
                  onChanged: (v) =>
                      bloc.add(UpdateDutyRate(double.tryParse(v) ?? 0))),
            ],
          ),
        );
      },
    );
  }

  Widget _freightOption(String emoji, String label, String value,
      CalculatorState state, CalculatorBloc bloc) {
    final active = state.freightMode == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => bloc.add(UpdateFreightMode(value)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryDarkNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController ctrl, {
    String? prefix,
    String? suffix,
    String hint = '',
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textBody)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall,
            prefixText: prefix,
            suffixText: suffix,
            filled: true,
            fillColor: AppColors.cardWhite,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primaryDarkNavy, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
