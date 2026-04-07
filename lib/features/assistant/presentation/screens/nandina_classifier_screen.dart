import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/assistant_bloc.dart';
import '../bloc/assistant_event.dart';
import '../bloc/assistant_state.dart';

class NandinaClassifierScreen extends StatefulWidget {
  const NandinaClassifierScreen({super.key});

  @override
  State<NandinaClassifierScreen> createState() =>
      _NandinaClassifierScreenState();
}

class _NandinaClassifierScreenState extends State<NandinaClassifierScreen>
    with SingleTickerProviderStateMixin {
  final _searchCtrl = TextEditingController();
  late AnimationController _loadingAnim;

  final _suggestions = [
    'Café verde',
    'Aguacate hass',
    'Textiles',
    'Maquinaria',
    'Electrónicos'
  ];

  @override
  void initState() {
    super.initState();
    _loadingAnim =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
  }

  @override
  void dispose() {
    _loadingAnim.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _search() {
    if (_searchCtrl.text.trim().isEmpty) return;
    context.read<AssistantBloc>().add(ClassifyNandinaEvent(query: _searchCtrl.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ColTradeAppBar(
        title: 'Clasificador NANDINA',
        dark: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded,
                size: 20, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: BlocConsumer<AssistantBloc, AssistantState>(
        listener: (context, state) {
           if (state is AssistantError) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                 content: Text('Error: ${state.message}',
                     style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
                 backgroundColor: AppColors.errorRed,
                 behavior: SnackBarBehavior.floating,
               ),
             );
          }
        },
        builder: (context, state) {
          final isLoading = state is AssistantNandinaClassifying;
          final hasResult = state is AssistantNandinaResult;
          final resultData = state is AssistantNandinaResult ? state.result : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Consulta Arancelaria IA',
                    style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                Text(
                  'Ingresa el nombre o descripción de tu producto para obtener la subpartida NANDINA y los aranceles aplicables.',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 20),

                // Search bar
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _searchCtrl,
                        onFieldSubmitted: (_) => _search(),
                        decoration: InputDecoration(
                          hintText: 'Ej. Café, calzado de cuero, autopartes...',
                          hintStyle: AppTextStyles.bodySmall,
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: AppColors.textLabel),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 18),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    // Hack to clear state locally? Proper BLoC needs clear event
                                    // For now just clearing visual is ok since next search overwrites
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: AppColors.cardWhite,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.primaryDarkNavy, width: 2),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _search,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDarkNavy,
                          minimumSize: const Size(100, 48),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text('Buscar', style: AppTextStyles.buttonCTA),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Suggestions
                Row(
                  children: [
                    Text('SUGERENCIAS: ', style: AppTextStyles.labelUppercase),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _suggestions
                              .map((s) => GestureDetector(
                                    onTap: () {
                                      _searchCtrl.text = s;
                                      _search();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 6),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceGray,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: Text(s, style: AppTextStyles.caption),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Loading state
                if (isLoading) _buildLoading(),

                // Result
                if (hasResult && resultData != null) _buildResult(resultData),

                // Default state
                if (!isLoading && !hasResult) _buildEmptyState(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          RotationTransition(
            turns: _loadingAnim,
            child: const Icon(Icons.smart_toy_outlined,
                size: 40, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Text('Analizando componentes...',
              style: AppTextStyles.bodyRegular
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Consultando base de datos DIAN...',
              style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildResult(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${data['match'] ?? '98'}% COINCIDENCIA',
                      style: AppTextStyles.badgeText.copyWith(
                          color: const Color(0xFF92400E), fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('SUBPARTIDA ARANCELARIA',
                  style: AppTextStyles.labelUppercase),
              const SizedBox(height: 4),
              Text(
                data['code'] ?? '6403.59.00.00',
                style: GoogleFonts.sourceCodePro(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),

              // Description
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.yellowAmber, width: 2),
                  ),
                  color: Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DESCRIPCIÓN NANDINA',
                        style: AppTextStyles.labelUppercase
                            .copyWith(color: AppColors.yellowAmber)),
                    const SizedBox(height: 4),
                    Text(
                      data['description'] ?? 'Los demás calzados...',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Justification collapsible
              _JustificationToggle(
                  justification: data['justification'] ?? '...'),
              const SizedBox(height: 16),

              // Arancel + IVA grid
              Row(
                children: [
                  _taxCard('ARANCEL (GRAVAMEN)', data['arancel'] ?? '15%'),
                  const SizedBox(width: 16),
                  _taxCard('IVA', data['iva'] ?? '19%'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CTAButton(
          label: 'Confirmar y continuar →',
          onTap: () => context.pop(),
        ),
        const SizedBox(height: 10),
        Text(
          '*Esta es una sugerencia basada en IA y no constituye asesoría legal. Verifique con un agente de aduana.',
          style: AppTextStyles.caption.copyWith(
              fontStyle: FontStyle.italic, color: AppColors.textLabel),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _taxCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppTextStyles.labelUppercase.copyWith(fontSize: 9)),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.surfaceGray,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_rounded,
                size: 36, color: AppColors.textLabel),
          ),
          const SizedBox(height: 16),
          Text('Busca tu producto',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Ingresa el nombre comercial de tu mercancía\ny la IA clasificará la subpartida NANDINA',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _JustificationToggle extends StatefulWidget {
  final String justification;

  const _JustificationToggle({required this.justification});

  @override
  State<_JustificationToggle> createState() => _JustificationToggleState();
}

class _JustificationToggleState extends State<_JustificationToggle> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_expanded ? Icons.expand_less : Icons.add_rounded,
                  size: 18, color: AppColors.textBody),
              const SizedBox(width: 6),
              Text('Justificación de la IA',
                  style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600, color: AppColors.textBody)),
            ],
          ),
          if (_expanded) ...[
            const SizedBox(height: 8),
            Text(
              widget.justification,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
