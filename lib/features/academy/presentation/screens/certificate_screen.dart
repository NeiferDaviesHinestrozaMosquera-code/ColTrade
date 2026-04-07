import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ColTradeAppBar(
        dark: true,
        title: 'Mi Certificado',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Certificate Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDarkNavy.withValues(alpha: 0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: const Color(0xFFE2C87B), width: 1.5),
              ),
              child: Column(
                children: [
                  // Header banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryDarkNavy,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                    ),
                    child: Text(
                      'COLTRADE',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Corner decorations
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cornerDecoration(true, true),
                            _cornerDecoration(true, false),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Text('CERTIFICADO DE FINALIZACIÓN',
                            style: AppTextStyles.labelUppercase
                                .copyWith(letterSpacing: 2)),
                        const SizedBox(height: 8),
                        Text('Se otorga con orgullo a:',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Text('Juan Perez',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textPrimary,
                            )),
                        const SizedBox(height: 12),

                        // Gold diamond divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 40,
                                height: 1,
                                color: const Color(0xFFE2C87B)),
                            const SizedBox(width: 8),
                            const Text('◆',
                                style: TextStyle(
                                    color: Color(0xFFD4AF37), fontSize: 10)),
                            const SizedBox(width: 8),
                            Container(
                                width: 40,
                                height: 1,
                                color: const Color(0xFFE2C87B)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Text(
                          'Por completar exitosamente el curso',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'INTRODUCCIÓN AL COMERCIO EXTERIOR',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Signature area
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 1,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(height: 4),
                                Text('Carlos Ruiz',
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.textPrimary)),
                                Text('DIRECTOR ACADÉMICO',
                                    style: AppTextStyles.labelUppercase
                                        .copyWith(fontSize: 9)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Meta grid
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('FECHA DE EXPEDICIÓN',
                                        style: AppTextStyles.labelUppercase
                                            .copyWith(fontSize: 9)),
                                    const SizedBox(height: 2),
                                    Text('14 Oct 2024',
                                        style: AppTextStyles.bodyRegular
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13)),
                                  ],
                                ),
                              ),
                              Container(
                                  width: 1,
                                  height: 32,
                                  color: AppColors.border),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('ID DE CERTIFICACIÓN',
                                        style: AppTextStyles.labelUppercase
                                            .copyWith(fontSize: 9)),
                                    const SizedBox(height: 2),
                                    Text('CT-2024-0914',
                                        style: GoogleFonts.sourceCodePro(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cornerDecoration(false, true),
                            _cornerDecoration(false, false),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Congrats
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.successGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 32),
            ),
            const SizedBox(height: 12),
            Text('¡Felicidades por tu logro, Juan!',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(
              'Has demostrado dominio en los fundamentos del comercio exterior colombiano. Sigue avanzando en tu carrera.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Action buttons
            CTAButton(
              label: '↓  Descargar PDF',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            CTAButton(
              label: '< Compartir en LinkedIn',
              outlined: true,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            CTAButton(
              label: 'Continuar aprendiendo →',
              onTap: () => context.go('/home'),
              backgroundColor: AppColors.accentOrange,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _cornerDecoration(bool isTop, bool isLeft) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: _CornerPainter(isTop, isLeft)),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;

  _CornerPainter(this.isTop, this.isLeft);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (isTop && isLeft) {
      path.moveTo(0, size.height * 0.5);
      path.lineTo(0, 0);
      path.lineTo(size.width * 0.5, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(size.width * 0.5, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height * 0.5);
    } else if (!isTop && isLeft) {
      path.moveTo(0, size.height * 0.5);
      path.lineTo(0, size.height);
      path.lineTo(size.width * 0.5, size.height);
    } else {
      path.moveTo(size.width * 0.5, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, size.height * 0.5);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

