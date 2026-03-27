import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';

///import 'checklist_screen.dart';

class ExportAssistantScreen extends StatefulWidget {
  const ExportAssistantScreen({super.key});

  @override
  State<ExportAssistantScreen> createState() => _ExportAssistantScreenState();
}

class _ExportAssistantScreenState extends State<ExportAssistantScreen> {
  int _currentStep = 1;
  final _productController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedDestino;
  String _selectedTransport = 'maritimo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ColTradeAppBar(
        title: 'Asistente de Exportación',
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
      ),
      body: Column(
        children: [
          _buildProgress(),
          Expanded(child: _buildStep()),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    final labels = [
      'Selección de Producto',
      'Destino y Transporte',
      'Documentos',
      'Confirmación',
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: StepProgressIndicator(
        currentStep: _currentStep,
        totalSteps: 4,
        label: labels[_currentStep - 1],
      ),
    );
  }

  Widget _buildStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: switch (_currentStep) {
        1 => _buildStep1(),
        2 => _buildStep2(),
        3 => _buildStep3(),
        _ => _buildStep4(),
      },
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Qué producto deseas exportar?',
          style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          'Ingresa el nombre comercial o técnico de tu mercancía para comenzar el análisis.',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 24),

        // Product name input
        Text('Nombre del producto',
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textBody)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _productController,
          decoration: AppDecorations.inputDecoration(
            '',
            'Ej. Café pergamino, aguacate hass...',
            suffix:
                const Icon(Icons.search_rounded, color: AppColors.textLabel),
          ),
        ),
        const SizedBox(height: 24),

        // AI Classification
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.purple.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome,
                      color: Colors.purple, size: 20),
                  const SizedBox(width: 8),
                  Text('Clasificación por IA',
                      style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple.shade900)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                  'Sube una foto y la IA identificará tu producto automáticamente',
                  style: AppTextStyles.bodySmall),
              const SizedBox(height: 14),

              // Upload zone
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.border,
                      width: 2,
                      style: BorderStyle.solid),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined,
                        size: 32, color: AppColors.textLabel),
                    const SizedBox(height: 8),
                    Text('Toca para subir o tomar fotos',
                        style:
                            AppTextStyles.bodyRegular.copyWith(fontSize: 14)),
                    Text('PNG, JPG hasta 10MB', style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Description
        Text('Descripción detallada',
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textBody)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descController,
          maxLines: 4,
          maxLength: 500,
          decoration: AppDecorations.inputDecoration(
            '',
            'Describe características, embalaje, condiciones especiales...',
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    const destinos = [
      'España',
      'Estados Unidos',
      'Alemania',
      'Japón',
      'Brasil',
      'México'
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿A dónde exportas?',
            style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text('Selecciona el país de destino y el modo de transporte.',
            style: AppTextStyles.bodySmall),
        const SizedBox(height: 24),

        Text('País de destino',
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textBody)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedDestino,
          hint:
              Text('Seleccionar país destino', style: AppTextStyles.bodySmall),
          decoration: AppDecorations.inputDecoration('', '',
              prefix:
                  const Icon(Icons.public_rounded, color: AppColors.textLabel)),
          items: destinos
              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
              .toList(),
          onChanged: (v) => setState(() => _selectedDestino = v),
        ),
        const SizedBox(height: 20),

        Text('Modo de transporte',
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textBody)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.surfaceGray,
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _transportOption('✈️', 'Aéreo', 'aereo'),
              _transportOption('🚢', 'Marítimo', 'maritimo'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Incoterm
        Text('Incoterm',
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textBody)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          hint: Text('Ej. FOB, CIF, EXW...', style: AppTextStyles.bodySmall),
          decoration: AppDecorations.inputDecoration('', ''),
          items: ['FOB', 'CIF', 'EXW', 'DDP', 'DAP']
              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
              .toList(),
          onChanged: (_) {},
        ),
      ],
    );
  }

  Widget _transportOption(String emoji, String label, String value) {
    final active = _selectedTransport == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTransport = value),
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

  Widget _buildStep3() {
    final docs = [
      ('Factura Comercial', 'DIAN', true, false),
      ('Lista de Empaque', 'Empresa', true, false),
      ('Certificado de Origen', 'MINCIT', false, true),
      ('Declaración de Exportación', 'DIAN', false, false),
      ('Documento de Transporte (BL/AWB)', 'Naviera/Aerolínea', false, false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Documentos requeridos',
            style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text(
            'ColTrade ha identificado los documentos necesarios para tu operación.',
            style: AppTextStyles.bodySmall),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card,
          child: Column(
            children: docs.asMap().entries.map((e) {
              final (name, entity, completed, uploading) = e.value;
              return Column(
                children: [
                  _docRow(name, entity, completed, uploading),
                  if (e.key < docs.length - 1) const Divider(height: 16),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        const InfoCard(
          title: 'ENTIDADES ALIADAS',
          body: 'DIAN · ICA · INVIMA · MinCIT',
          icon: Icons.account_balance_outlined,
        ),
      ],
    );
  }

  Widget _docRow(String name, String entity, bool completed, bool uploading) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: completed ? AppColors.successGreen : Colors.transparent,
            border: completed
                ? null
                : Border.all(color: AppColors.border, width: 1.5),
            shape: BoxShape.circle,
          ),
          child: completed
              ? const Icon(Icons.check, color: Colors.white, size: 13)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: AppTextStyles.bodyRegular
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
              Text('ENTIDAD: $entity',
                  style: AppTextStyles.labelUppercase.copyWith(fontSize: 10)),
            ],
          ),
        ),
        if (uploading)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryDarkNavy,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('SUBIR',
                style: AppTextStyles.badgeText
                    .copyWith(fontSize: 10, color: Colors.white)),
          )
        else if (!completed)
          const Icon(Icons.visibility_outlined,
              size: 18, color: AppColors.textLabel),
        if (completed)
          const Icon(Icons.visibility_outlined,
              size: 18, color: AppColors.textLabel),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumen de exportación',
            style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text('Revisa los datos antes de generar tu expediente.',
            style: AppTextStyles.bodySmall),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card,
          child: Column(
            children: [
              _summaryRow(
                  'Producto',
                  _productController.text.isEmpty
                      ? 'Café Premium'
                      : _productController.text),
              const Divider(height: 16),
              _summaryRow('Destino', _selectedDestino ?? 'España'),
              const Divider(height: 16),
              _summaryRow('Transporte',
                  _selectedTransport == 'aereo' ? '✈️ Aéreo' : '🚢 Marítimo'),
              const Divider(height: 16),
              _summaryRow('Puerto de Salida', 'Cartagena (SPRC)'),
              const Divider(height: 16),
              _summaryRow('Incoterm', 'FOB'),
              const Divider(height: 16),
              _summaryRow('Documentos', '2/5 completos'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.successGreen.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.successGreen.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.successGreen, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Al confirmar, ColTrade generará automáticamente tu Checklist Inteligente.',
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.successGreen.withValues(alpha: 0.8)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.caption),
        Text(value,
            style: AppTextStyles.bodyRegular
                .copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  Widget _buildNextButton() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      child: CTAButton(
        label: _currentStep < 4 ? 'Siguiente Paso →' : '✅  Generar Checklist',
        onTap: () {
          if (_currentStep < 4) {
            setState(() => _currentStep++);
          } else {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (_) => const ChecklistScreen()),
            // );
          }
        },
      ),
    );
  }
}

