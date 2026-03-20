import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'certificate_screen.dart';

// ─── Quiz Screen ──────────────────────────────────────────────────────────────
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 3;
  int? _selectedOption;

  final _question = '¿Cuál de los siguientes documentos es obligatorio para toda exportación colombiana ante la DIAN?';

  final _options = [
    ('A', 'Certificado Fitosanitario ICA', 'Requerido para productos agropecuarios'),
    ('B', 'Declaración de Exportación (DEX)', 'Documento principal ante DIAN'),
    ('C', 'Certificado de Libre Venta INVIMA', 'Para productos farmacéuticos'),
    ('D', 'Registro Sanitario MinSalud', 'Para alimentos y bebidas'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Introducción al Comercio Exterior',
            style: GoogleFonts.inter(
                fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: StepProgressIndicator(
              currentStep: _currentQuestion,
              totalSteps: 5,
              label: '',
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Opción Múltiple', style: AppTextStyles.caption),
                  const SizedBox(height: 10),
                  Text(_question,
                      style: GoogleFonts.inter(
                          fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 24),

                  ..._options.asMap().entries.map((e) {
                    final (letter, main, sub) = e.value;
                    final selected = e.key == _selectedOption;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedOption = e.key),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected ? AppColors.primaryDarkNavy : AppColors.border,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primaryDarkNavy
                                    : AppColors.surfaceGray,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(letter,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: selected ? Colors.white : AppColors.textSecondary,
                                    )),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(main,
                                      style: AppTextStyles.bodyRegular
                                          .copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                                  Text(sub, style: AppTextStyles.caption),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
            color: Colors.white,
            child: Column(
              children: [
                CTAButton(
                  label: 'Enviar Respuesta',
                  onTap: _selectedOption != null
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const QuizResultsScreen()))
                      : null,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuizResultsScreen()),
                  ),
                  child: Text('Omitir por ahora',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textLabel)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quiz Results Screen ──────────────────────────────────────────────────────
class QuizResultsScreen extends StatelessWidget {
  const QuizResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      (true, 'Documentos de exportación', 'Respondido correctamente'),
      (true, 'Entidades reguladoras', 'Respondido correctamente'),
      (false, 'Clasificación arancelaria', 'Necesita refuerzo'),
      (true, 'Logística y transporte', 'Respondido correctamente'),
      (true, 'Costos y aranceles', 'Respondido correctamente'),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Resultados del Quiz',
            style: GoogleFonts.inter(
                fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Donut score
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      children: [
                        CircularProgressIndicator(
                          value: 0.8,
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryDarkNavy),
                          strokeWidth: 10,
                        ),
                        const Center(
                          child: Text('80%',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text('¡Felicidades!',
                      style: GoogleFonts.inter(
                          fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Text('Has completado el quiz con excelentes resultados.',
                      style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
                  const SizedBox(height: 20),

                  // Stats row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: AppDecorations.card,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('4 de 5',
                                      style: AppTextStyles.priceTotal.copyWith(fontSize: 20)),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.check_circle_rounded,
                                      color: AppColors.successGreen, size: 20),
                                ],
                              ),
                              Text('PUNTAJE', style: AppTextStyles.labelUppercase),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: AppDecorations.card,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('+120 XP',
                                      style: AppTextStyles.priceTotal.copyWith(fontSize: 20)),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.emoji_events_rounded,
                                      color: Colors.amber, size: 20),
                                ],
                              ),
                              Text('PUNTOS', style: AppTextStyles.labelUppercase),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Topic summary
                  SectionHeader(title: 'Resumen de temas'),
                  const SizedBox(height: 10),
                  ...topics.map((t) {
                    final (passed, topic, subtitle) = t;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          left: BorderSide(
                            color: passed ? AppColors.successGreen : AppColors.errorRed,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(topic,
                                    style: AppTextStyles.bodyRegular
                                        .copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                                Text(subtitle, style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          Icon(
                            passed ? Icons.check_rounded : Icons.close_rounded,
                            color: passed ? AppColors.successGreen : AppColors.errorRed,
                            size: 20,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
            color: Colors.white,
            child: Column(
              children: [
                CTAButton(
                  label: 'Ver Certificado →',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CertificateScreen()),
                  ),
                ),
                const SizedBox(height: 10),
                CTAButton(
                  label: 'Repetir Quiz',
                  outlined: true,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
