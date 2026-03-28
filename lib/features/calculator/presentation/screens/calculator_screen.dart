import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/calculator_bloc.dart';

import '../widgets/calculator_form.dart';
import '../widgets/calculator_summary.dart';

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

class _CalculatorView extends StatelessWidget {
  const _CalculatorView();

  @override
  Widget build(BuildContext context) {
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

            const CalculatorForm(),
            const SizedBox(height: 16),

            const CalculatorSummary(),
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
            BlocBuilder<CalculatorBloc, CalculatorState>(
              builder: (context, state) {
                return InfoCard(
                  title: 'LEAD TIME',
                  body: state.freightMode == 'sea'
                      ? 'Estimated sea transit: 25-40 days. Air: 3-7 days.'
                      : 'Estimated air transit: 3-7 days. Express options available.',
                  icon: Icons.timer_outlined,
                  borderColor: AppColors.successGreen,
                  bgColor: AppColors.greenLight,
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

