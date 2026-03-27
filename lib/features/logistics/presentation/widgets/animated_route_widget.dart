import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../domain/entities/trade_route.dart';

class AnimatedRouteWidget extends StatefulWidget {
  final TradeRoute route;
  final bool isSelected;
  final VoidCallback onTap;
  final int animationIndex;

  const AnimatedRouteWidget({
    super.key,
    required this.route,
    required this.isSelected,
    required this.onTap,
    this.animationIndex = 0,
  });

  @override
  State<AnimatedRouteWidget> createState() => _AnimatedRouteWidgetState();
}

class _AnimatedRouteWidgetState extends State<AnimatedRouteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  Color get _modeColor {
    switch (widget.route.mode) {
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

  String get _modeEmoji {
    switch (widget.route.mode) {
      case TransportMode.sea:
        return '🚢';
      case TransportMode.air:
        return '✈️';
      case TransportMode.land:
        return '🚛';
      case TransportMode.multimodal:
        return '🔄';
    }
  }

  String get _modeLabel {
    switch (widget.route.mode) {
      case TransportMode.sea:
        return 'MARÍTIMO';
      case TransportMode.air:
        return 'AÉREO';
      case TransportMode.land:
        return 'TERRESTRE';
      case TransportMode.multimodal:
        return 'MULTIMODAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? AppColors.primaryDarkNavy
              : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isSelected ? _modeColor : AppColors.border,
            width: widget.isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isSelected
                  ? _modeColor.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: widget.isSelected ? 16 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mode badge + destination country
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _modeColor.withValues(
                          alpha: widget.isSelected ? 0.25 : 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_modeEmoji,
                            style: const TextStyle(fontSize: 10)),
                        const SizedBox(width: 4),
                        Text(
                          _modeLabel,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: _modeColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.route.destinationFlag,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Animated origin → destination
              _buildRouteArrow(),

              const SizedBox(height: 10),

              // Transit time + frequency
              Row(
                children: [
                  _infoChip(
                    Icons.schedule_rounded,
                    '${widget.route.minTransitDays}–${widget.route.maxTransitDays} días',
                    widget.isSelected,
                  ),
                  const SizedBox(width: 8),
                  _infoChip(
                    Icons.repeat_rounded,
                    widget.route.frequency,
                    widget.isSelected,
                  ),
                  const Spacer(),
                  Text(
                    'USD ${widget.route.estimatedFreightUsd.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: widget.isSelected
                          ? AppColors.accentOrange
                          : AppColors.primaryDarkNavy,
                    ),
                  ),
                ],
              ),

              // Expanded detail when selected
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildExpandedDetail(),
                crossFadeState: widget.isSelected
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
            delay: Duration(milliseconds: widget.animationIndex * 80),
            duration: const Duration(milliseconds: 400),
          )
          .slideY(
            begin: 0.06,
            delay: Duration(milliseconds: widget.animationIndex * 80),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          ),
    );
  }

  Widget _buildRouteArrow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🇨🇴 Colombia',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: widget.isSelected ? Colors.white60 : AppColors.textLabel,
                ),
              ),
              Text(
                widget.route.originName,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: widget.isSelected ? Colors.white : AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Animated dotted line
        SizedBox(
          width: 60,
          height: 24,
          child: AnimatedBuilder(
            animation: _dotController,
            builder: (context, _) {
              return CustomPaint(
                painter: _DashedLinePainter(
                  progress: _dotController.value,
                  color: _modeColor,
                ),
              );
            },
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.route.destinationCountry,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: widget.isSelected ? Colors.white60 : AppColors.textLabel,
                ),
              ),
              Text(
                widget.route.destinationName,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: widget.isSelected ? Colors.white : AppColors.textPrimary,
                ),
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedDetail() {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 12),
          Text(
            widget.route.description,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Navieras / Operadores:',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.route.mainCarriers
                .map((c) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _modeColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _modeColor.withValues(alpha: 0.4),
                            width: 0.5),
                      ),
                      child: Text(c,
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              color: _modeColor,
                              fontWeight: FontWeight.w600)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          Text(
            'Productos clave:',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.route.keyProducts
                .map((p) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(p,
                          style: GoogleFonts.inter(
                              fontSize: 10, color: Colors.white60)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: selected
            ? Colors.white.withValues(alpha: 0.1)
            : AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11,
              color: selected ? Colors.white60 : AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: selected ? Colors.white60 : AppColors.textSecondary,
              )),
        ],
      ),
    );
  }
}

// ── Dashed animated line painter ──────────────────────────────────────────────
class _DashedLinePainter extends CustomPainter {
  final double progress;
  final Color color;

  _DashedLinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashWidth = 4.0;
    const gapWidth = 4.0;
    final totalWidth = size.width;
    final cy = size.height / 2;

    // Animated offset
    final offset = (progress * (dashWidth + gapWidth)) % (dashWidth + gapWidth);

    double x = -offset;
    while (x < totalWidth) {
      final start = x.clamp(0.0, totalWidth);
      final end = (x + dashWidth).clamp(0.0, totalWidth);
      if (end > start) {
        canvas.drawLine(Offset(start, cy), Offset(end, cy), paint);
      }
      x += dashWidth + gapWidth;
    }

    // Arrow head
    final arrowPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const arrowSize = 6.0;
    final tip = Offset(totalWidth, cy);
    canvas.drawLine(
        tip, Offset(totalWidth - arrowSize, cy - arrowSize * 0.6), arrowPaint);
    canvas.drawLine(
        tip, Offset(totalWidth - arrowSize, cy + arrowSize * 0.6), arrowPaint);

    // Moving dot
    final dotX =
        (progress * totalWidth + math.sin(progress * math.pi * 2) * 2)
            .clamp(0.0, totalWidth);
    canvas.drawCircle(
      Offset(dotX, cy),
      3.5,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.progress != progress;
}
