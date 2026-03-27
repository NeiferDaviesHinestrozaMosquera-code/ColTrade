import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
//import 'calculator_screen.dart';

class ImportAssistantScreen extends StatefulWidget {
  const ImportAssistantScreen({super.key});

  @override
  State<ImportAssistantScreen> createState() => _ImportAssistantScreenState();
}

class _ImportAssistantScreenState extends State<ImportAssistantScreen> {
  int _currentStep = 1;
  final _productCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  String? _selectedOrigen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ColTradeAppBar(
        title: 'Asistente de Importación',
        dark: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.accentOrange),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded,
                size: 20, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          _buildProgress(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: StepProgressIndicator(
        currentStep: _currentStep,
        totalSteps: 4,
        label: 'Armando tu expediente',
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: switch (_currentStep) {
              1 => _buildStep1(),
              2 => _buildStep2(),
              3 => _buildStep3(),
              _ => _buildStep4(),
            },
          ),
        ),
        _buildFooter(),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Chat bubble
        Text('COLTRADE AI',
            style: AppTextStyles.labelUppercase
                .copyWith(color: AppColors.textLabel)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryDarkNavy,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkNavy,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    style:
                        AppTextStyles.bodyRegular.copyWith(color: Colors.white),
                    children: [
                      const TextSpan(
                          text:
                              'Hola, soy tu asistente de importación. Para comenzar necesito:\n\n'),
                      const TextSpan(
                          text: '• ¿Qué producto deseas importar?\n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(
                          text: '• ¿Cuál es su país de origen?\n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(
                          text: '• ¿Cuánto pesa aproximadamente?',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Generating chip
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceGray,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calculate_outlined,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('Generando pre-liquidación...',
                    style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Form
        _formLabel('PRODUCTO'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _productCtrl,
          decoration: AppDecorations.inputDecoration(
            '',
            'Ej. Maquinaria industrial, textiles...',
            suffix: const Icon(Icons.account_tree_outlined,
                size: 18, color: AppColors.textLabel),
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _formLabel('ORIGEN'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedOrigen,
                    hint: Text('País', style: AppTextStyles.bodySmall),
                    decoration: AppDecorations.inputDecoration('', '',
                        prefix: const Icon(Icons.public_rounded,
                            size: 18, color: AppColors.textLabel)),
                    items: [
                      'China',
                      'Estados Unidos',
                      'Alemania',
                      'India',
                      'Brasil',
                      'México'
                    ]
                        .map((c) => DropdownMenuItem(
                            value: c,
                            child:
                                Text(c, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedOrigen = v),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _formLabel('PESO (KG)'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _weightCtrl,
                    keyboardType: TextInputType.number,
                    decoration: AppDecorations.inputDecoration(
                      '',
                      '0.00',
                      prefix: const Icon(Icons.scale_outlined,
                          size: 18, color: AppColors.textLabel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        _formLabel('VALOR ESTIMADO (USD)'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _valueCtrl,
          keyboardType: TextInputType.number,
          decoration: AppDecorations.inputDecoration(
            '',
            '0.00',
            prefix: const Icon(Icons.attach_money_rounded,
                size: 18, color: AppColors.textLabel),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Clasificación NANDINA',
            style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text(
            'La IA ha sugerido la siguiente clasificación arancelaria para tu producto.',
            style: AppTextStyles.bodySmall),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecorations.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('RESULTADO SUGERIDO',
                      style: AppTextStyles.labelUppercase),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('98% COINCIDENCIA',
                        style: AppTextStyles.badgeText.copyWith(
                            color: const Color(0xFF92400E), fontSize: 10)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('SUBPARTIDA ARANCELARIA',
                  style: AppTextStyles.labelUppercase),
              const SizedBox(height: 4),
              Text('8471.30.00.00',
                  style: GoogleFonts.sourceCodePro(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(color: AppColors.yellowAmber, width: 2)),
                  color: const Color(0xFFFFFBEB),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  'Máquinas automáticas para tratamiento o procesamiento de datos, portátiles',
                  style: AppTextStyles.bodySmall,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _arancelStat('ARANCEL', '15%'),
                  const SizedBox(width: 20),
                  _arancelStat('IVA', '19%'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _arancelStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelUppercase),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildStep3() {
    const ports = [
      ('Buenaventura', 'Pacífico', 'SPRB/TCBUEN'),
      ('Cartagena', 'Atlántico', 'SPRC'),
      ('Barranquilla', 'Atlántico', 'SPRB'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Puerto de entrada',
            style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text('Selecciona el puerto por donde ingresará tu mercancía.',
            style: AppTextStyles.bodySmall),
        const SizedBox(height: 20),
        ...ports.map((p) {
          final (name, zone, code) = p;
          final selected = name == 'Buenaventura';
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.primaryDarkNavy : AppColors.border,
                width: selected ? 2 : 1,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primaryDarkNavy.withValues(alpha: 0.1)
                      : AppColors.surfaceGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.anchor_rounded,
                    color: selected
                        ? AppColors.primaryDarkNavy
                        : AppColors.textLabel),
              ),
              title: Text(name, style: AppTextStyles.cardTitle),
              subtitle: Text('$zone · $code', style: AppTextStyles.caption),
              trailing: selected
                  ? Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                          color: AppColors.primaryDarkNavy,
                          shape: BoxShape.circle),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 13),
                    )
                  : const Icon(Icons.radio_button_unchecked,
                      color: AppColors.textLabel),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumen de importación',
            style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text('Tu expediente ha sido generado con éxito.',
            style: AppTextStyles.bodySmall),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecorations.darkCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RESUMEN DE COSTOS',
                  style: AppTextStyles.labelUppercase
                      .copyWith(color: Colors.white60)),
              const SizedBox(height: 16),
              _costRow('Valor FOB (USD)', '\$5,000.00', Colors.white),
              _costRow('Flete estimado', '\$800.00', Colors.white70),
              _costRow('Seguro', '\$50.00', Colors.white70),
              _costRow('Arancel (15%)', '\$877.50', Colors.white70),
              _costRow('IVA (19%)', '\$1,282.25', Colors.white70),
              const Divider(color: Colors.white24, height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('COSTO LANDED',
                      style: AppTextStyles.labelUppercase
                          .copyWith(color: Colors.white60)),
                  Text('\$8,009.75',
                      style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentOrange)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // CTAButton(
        //   label: '📊  Ver Cálculo Detallado',
        //   onTap: () => Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (_) => const CalculatorScreen()),
        //   ),
        //   backgroundColor: AppColors.accentOrange,
        // ),
      ],
    );
  }

  Widget _costRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: color.withValues(alpha: 0.7))),
          Text(value,
              style: AppTextStyles.bodyRegular
                  .copyWith(color: color, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _formLabel(String label) =>
      Text(label, style: AppTextStyles.labelUppercase);

  Widget _buildFooter() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
          20, 10, 20, MediaQuery.of(context).padding.bottom + 10),
      child: Column(
        children: [
          CTAButton(
            label: _currentStep < 4
                ? 'Continuar con el Expediente >'
                : '✅  Finalizar Importación',
            onTap: () {
              if (_currentStep < 4)
                setState(() => _currentStep++);
              else
                Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Al continuar, ColTrade procesará estos datos para calcular aranceles y fletes aproximados.',
            style: AppTextStyles.caption.copyWith(color: AppColors.textLabel),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

