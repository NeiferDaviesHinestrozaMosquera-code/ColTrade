import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../features/alerts/domain/entities/alert_entity.dart';

class AlertDetailScreen extends StatelessWidget {
  final AlertEntity alert;

  const AlertDetailScreen({super.key, required this.alert});


  @override
  Widget build(BuildContext context) {
    final (borderColor, badgeColor, label) = alert.priority.style;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primaryDarkNavy,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [IconButton(icon: const Icon(Icons.share_outlined, color: Colors.white), onPressed: () {})],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0F1C3F), Color(0xFF1E3A5F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.gavel_rounded, size: 60, color: Colors.white12),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(6)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.warning_amber_rounded, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(label, style: AppTextStyles.badgeText.copyWith(fontSize: 9, color: Colors.white)),
                      ]),
                    ),
                  ),
                  Positioned(
                    left: 16, right: 60, bottom: 16,
                    child: Text(alert.title,
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        maxLines: 2),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: AppColors.surfaceGray, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.account_balance_rounded, color: AppColors.textSecondary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(alert.institution,
                          style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w600)),
                      Text(alert.institution == 'DIAN'
                          ? 'Dirección de Impuestos y Aduanas Nacionales'
                          : 'Ministerio de Comercio, Industria y Turismo',
                          style: AppTextStyles.caption),
                    ])),
                    Container(width: 10, height: 10,
                        decoration: const BoxDecoration(color: AppColors.successGreen, shape: BoxShape.circle)),
                  ]),
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: _metaCell('PUBLICACIÓN', alert.date, Icons.calendar_today_outlined)),
                  const SizedBox(width: 12),
                  Expanded(child: _metaCell('VIGENCIA', '01 Nov 2024', Icons.event_available_outlined)),
                ]),
                const SizedBox(height: 20),
                Text('Resumen de Medidas', style: AppTextStyles.h3(context)),
                const SizedBox(height: 8),
                Text(
                  '${alert.summary}\n\nLas empresas exportadoras deben actualizar sus formularios antes de la fecha de entrada en vigencia.',
                  style: AppTextStyles.bodyRegular,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.greenLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.2)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Impacto en su Operación',
                        style: AppTextStyles.sectionTitle.copyWith(fontSize: 16)),
                    const SizedBox(height: 10),
                    _impactRow(true, 'Actualice sus formularios DIAN antes del 31 de octubre'),
                    const SizedBox(height: 6),
                    _impactRow(false, 'Verifique clasificación arancelaria de sus productos'),
                    const SizedBox(height: 6),
                    _impactRow(true, 'Coordine con su agente de aduana los cambios operativos'),
                  ]),
                ),
                const SizedBox(height: 20),
                Text('Recursos', style: AppTextStyles.sectionTitle.copyWith(fontSize: 16)),
                const SizedBox(height: 10),
                _resourceItem('Decreto_DIAN_1234_2024.pdf', '2.4 MB'),
                _resourceItem('Formulario_DEX_actualizado.pdf', '1.1 MB'),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryDarkNavy,
                    side: const BorderSide(color: AppColors.primaryDarkNavy, width: 1.5),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.notifications_outlined, size: 18),
                  label: Text('Seguir esta alerta',
                      style: AppTextStyles.buttonCTA.copyWith(color: AppColors.primaryDarkNavy)),
                ),
                const SizedBox(height: 10),
                CTAButton(label: '🤖  Consultar a la IA sobre esta alerta', onTap: () {}),
                const SizedBox(height: 10),
                Center(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined, size: 16, color: AppColors.textSecondary),
                    label: Text('Compartir Alerta',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaCell(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surfaceGray, borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppTextStyles.labelUppercase.copyWith(fontSize: 9)),
          Text(value, style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
        ]),
      ]),
    );
  }

  Widget _impactRow(bool positive, String text) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(
        positive ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
        size: 16,
        color: positive ? AppColors.successGreen : AppColors.infoBlue,
      ),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
    ]);
  }

  Widget _resourceItem(String name, String size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: AppDecorations.card,
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: AppColors.errorRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.errorRed, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: AppTextStyles.bodyRegular.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
          Text(size, style: AppTextStyles.caption),
        ])),
        IconButton(icon: const Icon(Icons.download_rounded, color: AppColors.textSecondary, size: 20), onPressed: () {}),
      ]),
    );
  }
}
