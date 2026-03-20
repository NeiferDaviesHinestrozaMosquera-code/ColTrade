import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/common_widgets.dart';
import '../bloc/calculator_bloc.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalculatorBloc(),
      child: const _CalculatorView(),
    );
  }
}

class _CalculatorView extends StatefulWidget {
  const _CalculatorView();

  @override
  State<_CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<_CalculatorView> {
  // Controllers stay in Widget layer – they only drive UI text display.
  // Changes fire BLoC events; BLoC owns the state values.
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
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: ColTradeAppBar(
            showLogo: true,
            dark: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.history_rounded,
                    color: AppColors.textSecondary),
                onPressed: () {},
              ),
              IconButton(
                icon: const NotificationBell(color: AppColors.textSecondary),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bar_chart_rounded,
                        color: AppColors.primaryDarkNavy, size: 22),
                    const SizedBox(width: 8),
                    Text('Import Parameters',
                        style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Form Inputs ─────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppDecorations.card,
                  child: Column(
                    children: [
                      _inputField('Product FOB Value (USD)', _fobCtrl,
                          prefix: '\$',
                          hint: '0.00',
                          onChanged: (v) => bloc.add(
                              UpdateFob(double.tryParse(v) ?? 0))),
                      const SizedBox(height: 14),
                      _inputField('Insurance (USD)', _insuranceCtrl,
                          prefix: '\$',
                          hint: 'Min. 1% of FOB',
                          onChanged: (v) => bloc.add(
                              UpdateInsurance(double.tryParse(v) ?? 0))),
                      const SizedBox(height: 14),

                      // Freight toggle
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
                                _freightOption('✈', 'Air Freight', 'air',
                                    state, bloc),
                                _freightOption('🚢', 'Sea Freight', 'sea',
                                    state, bloc),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Port dropdown
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
                            decoration:
                                AppDecorations.inputDecoration('', ''),
                            items: [
                              'Buenaventura (SPRB/TCBUEN)',
                              'Cartagena (SPRC)',
                              'Barranquilla (SPRB)',
                              'Santa Marta',
                            ]
                                .map((p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p,
                                        style: const TextStyle(
                                            fontSize: 13))))
                                .toList(),
                            onChanged: (v) =>
                                bloc.add(UpdatePort(v!)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      _inputField(
                          'Customs Duty (Arancel %)', _dutyCtrl,
                          suffix: '%',
                          hint: 'e.g. 5, 10, 15',
                          onChanged: (v) => bloc.add(
                              UpdateDutyRate(double.tryParse(v) ?? 0))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Calculation Summary ─────────────────────────────────────
                Container(
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
                      _calcRow(
                          'CIF Value (FOB + Freight + Ins.)',
                          '\$${state.cif.toStringAsFixed(2)}',
                          Colors.white),
                      _calcRow(
                          'Customs Duty (${state.dutyPercent.toStringAsFixed(0)}%)',
                          '\$${state.duty.toStringAsFixed(2)}',
                          Colors.white70),
                      _calcRow('VAT (IVA 19%)',
                          '\$${state.iva.toStringAsFixed(2)}', Colors.white70),
                      _calcRow('Customs Agency Fee',
                          '\$${state.agencyFee.toStringAsFixed(2)}',
                          Colors.white70),
                      _calcRow('Port/Storage Fees',
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
                                    borderRadius:
                                        BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
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
                              border: Border.all(
                                  color: const Color(0xFF3D4F6E)),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(Icons.share_outlined,
                                color: Colors.white60, size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const InfoCard(
                  title: 'LEGAL NOTE',
                  body:
                      'Mandatory Customs Broker required for all imports > 1,000 USD in Colombia.',
                  icon: Icons.gavel_outlined,
                ),
                const SizedBox(height: 8),
                const InfoCard(
                  title: 'TLC STATUS',
                  body:
                      'Duty rates are estimated based on MFN tariff. TLC benefits may apply — verify with your broker.',
                  icon: Icons.handshake_outlined,
                ),
                const SizedBox(height: 8),
                InfoCard(
                  title: 'LEAD TIME',
                  body: state.freightMode == 'sea'
                      ? 'Estimated sea transit: 25-40 days. Air: 3-7 days.'
                      : 'Estimated air transit: 3-7 days. Express options available.',
                  icon: Icons.timer_outlined,
                  borderColor: AppColors.successGreen,
                  bgColor: AppColors.greenLight,
                ),
                const SizedBox(height: 40),
              ],
            ),
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

  Widget _calcRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style:
                    AppTextStyles.bodySmall.copyWith(color: color.withValues(alpha: 0.8))),
          ),
          Text(value,
              style: AppTextStyles.bodyRegular.copyWith(
                  color: color, fontSize: 14)),
        ],
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
              borderSide: const BorderSide(
                  color: AppColors.primaryDarkNavy, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
