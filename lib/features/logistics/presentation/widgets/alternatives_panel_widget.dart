import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../domain/entities/logistics_alternative.dart';
import '../../domain/entities/trade_route.dart';

class AlternativesPanelWidget extends StatelessWidget {
  final List<LogisticsAlternative> alternatives;

  const AlternativesPanelWidget({
    super.key,
    required this.alternatives,
  });

  Color _modeColor(TransportMode mode) {
    switch (mode) {
      case TransportMode.sea:
        return const Color(0xFF0EA5E9);
      case TransportMode.air:
        return const Color(0xFF8B5CF6);
      case TransportMode.land:
        return const Color(0xFF22C55E);
      case TransportMode.multimodal:
        return AppColors.accentOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comparison header banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F1C3F), Color(0xFF1A2E5F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '⚖️ Comparativa de Alternativas',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Elige la modalidad óptima para tu carga',
                style: GoogleFonts.inter(
                    fontSize: 12, color: Colors.white60),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05),
        const SizedBox(height: 16),

        // Quick comparison table
        _buildComparisonTable(),
        const SizedBox(height: 20),

        // Alternative cards
        ...alternatives.asMap().entries.map(
              (e) => _AlternativeCard(
                alternative: e.value,
                modeColor: _modeColor(e.value.mode),
                animationIndex: e.key,
              ),
            ),
      ],
    );
  }

  Widget _buildComparisonTable() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          _tableHeader(),
          const Divider(height: 1),
          _tableRow('🚢 Marítimo', 'USD 800–3,500', '10–38 días', true),
          const Divider(height: 1),
          _tableRow('✈️ Aéreo', 'USD 3–8/kg', '1–3 días', true),
          const Divider(height: 1),
          _tableRow('🚛 Terrestre', 'USD 0.04–0.12/km', '2–7 días', false),
          const Divider(height: 1),
          _tableRow('🔄 Multimodal', 'Variable', '4–20 días', false),
          const Divider(height: 1),
          _tableRow('🛶 Fluvial', 'USD 0.02–0.05/km', '6–10 días', false,
              isLast: true),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 150.ms, duration: 400.ms)
        .slideY(begin: 0.05, delay: 150.ms);
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.surfaceGray,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text('Modalidad',
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLabel,
                      letterSpacing: 0.5))),
          Expanded(
              flex: 3,
              child: Text('Costo Est.',
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLabel,
                      letterSpacing: 0.5))),
          Expanded(
              flex: 2,
              child: Text('Tiempo',
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLabel,
                      letterSpacing: 0.5),
                  textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _tableRow(String mode, String cost, String days, bool highlight,
      {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color:
            highlight ? AppColors.blueLight.withValues(alpha: 0.4) : null,
        borderRadius:
            isLast ? const BorderRadius.vertical(bottom: Radius.circular(14)) : null,
      ),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(mode,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textPrimary))),
          Expanded(
              flex: 3,
              child: Text(cost,
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textBody))),
          Expanded(
              flex: 2,
              child: Text(days,
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDarkNavy),
                  textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

// ── Individual alternative card ───────────────────────────────────────────────
class _AlternativeCard extends StatefulWidget {
  final LogisticsAlternative alternative;
  final Color modeColor;
  final int animationIndex;

  const _AlternativeCard({
    required this.alternative,
    required this.modeColor,
    required this.animationIndex,
  });

  @override
  State<_AlternativeCard> createState() => _AlternativeCardState();
}

class _AlternativeCardState extends State<_AlternativeCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _expanded
                ? widget.modeColor
                : AppColors.border,
            width: _expanded ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _expanded
                  ? widget.modeColor.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.modeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(widget.alternative.emoji,
                          style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.alternative.title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          widget.alternative.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Transit days pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: widget.modeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.alternative.minDays}–${widget.alternative.maxDays}d',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: widget.modeColor,
                      ),
                    ),
                  ),
                ],
              ),

              // Cost range
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.attach_money_rounded,
                      size: 14, color: AppColors.textLabel),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.alternative.estimatedCostRange,
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textLabel, size: 20),
                  ),
                ],
              ),

              // Expanded pros & cons
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildExpanded(),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(
              delay: Duration(milliseconds: 200 + widget.animationIndex * 80),
              duration: 400.ms)
          .slideY(
              begin: 0.06,
              delay: Duration(milliseconds: 200 + widget.animationIndex * 80),
              duration: 400.ms,
              curve: Curves.easeOut),
    );
  }

  Widget _buildExpanded() {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          Text(
            widget.alternative.description,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textBody,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Pros & Cons side by side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _prosConsColumn(
                    '✅ Ventajas',
                    widget.alternative.pros,
                    const Color(0xFF22C55E)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _prosConsColumn(
                    '⚠️ Limitaciones',
                    widget.alternative.cons,
                    AppColors.errorRed),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Best for chip
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.modeColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: widget.modeColor.withValues(alpha: 0.3),
                  width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎯 Ideal para:',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: widget.modeColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.alternative.bestFor,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textBody,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _prosConsColumn(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            )),
        const SizedBox(height: 6),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 5, right: 5),
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                Expanded(
                  child: Text(item,
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textBody)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
