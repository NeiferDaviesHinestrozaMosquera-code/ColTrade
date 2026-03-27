import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/checklist_bloc.dart';
import '../../domain/entities/doc_item_entity.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChecklistBloc()..add(const LoadChecklist()),
      child: const _ChecklistView(),
    );
  }
}

class _ChecklistView extends StatefulWidget {
  const _ChecklistView();

  @override
  State<_ChecklistView> createState() => _ChecklistViewState();
}

class _ChecklistViewState extends State<_ChecklistView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      context.read<ChecklistBloc>().add(ChangeTab(_tabController.index));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistBloc, ChecklistState>(
      builder: (context, state) {
        final loaded = state is ChecklistLoaded ? state : null;
        return Scaffold(
          backgroundColor: AppColors.primaryDarkNavy,
          appBar: ColTradeAppBar(
            dark: true,
            title: 'Checklist Inteligente',
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                onPressed: () {},
              )
            ],
          ),
          body: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (loaded != null) _buildProgress(loaded),
                      _buildTabs(loaded?.selectedTab ?? 0),
                      Expanded(child: _buildTabContent(loaded)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('COLTRADE AI',
              style: AppTextStyles.labelUppercase
                  .copyWith(color: const Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          Text('Exportación de Aguacate Hass',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: Color(0xFFCBD5E1)),
              const SizedBox(width: 4),
              Text('Destino: Puerto de Rotterdam, NL',
                  style: AppTextStyles.caption
                      .copyWith(color: const Color(0xFFCBD5E1))),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade800, Colors.green.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text('🥑', style: TextStyle(fontSize: 60)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(ChecklistLoaded state) {
    final pct = (state.progress * 100).round();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PROGRESO DEL PROCESO', style: AppTextStyles.labelUppercase),
              Text('$pct%',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: state.progress,
              backgroundColor: AppColors.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.accentOrange),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(int selectedTab) {
    final tabs = ['Documentos', 'Orden de Ejecución', 'Entidades'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: tabs.asMap().entries.map((e) {
          final active = e.key == selectedTab;
          return GestureDetector(
            onTap: () => _tabController.animateTo(e.key),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: active ? AppColors.accentOrange : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                e.value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColors.textPrimary : AppColors.textLabel,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent(ChecklistLoaded? state) {
    return TabBarView(
      controller: _tabController,
      children: [
        state != null ? _buildDocumentsTab(state) : const SizedBox(),
        _buildOrderTab(),
        _buildEntitiesTab(),
      ],
    );
  }

  Widget _buildDocumentsTab(ChecklistLoaded state) {
    final completed = state.docs.where((d) => d.completed).length;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('DOCUMENTOS NECESARIOS', style: AppTextStyles.labelUppercase),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('$completed/${state.docs.length}',
                  style: AppTextStyles.badgeText
                      .copyWith(color: AppColors.textSecondary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...state.docs.asMap().entries.map((e) => _buildDocRow(e.value, e.key)),
        const SizedBox(height: 20),
        Text('ENTIDADES ALIADAS', style: AppTextStyles.labelUppercase),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: const [
            _EntityBadge('DIAN', AppColors.textSecondary),
            _EntityBadge('ICA', AppColors.successGreen),
            _EntityBadge('INVIMA', AppColors.infoBlue),
            _EntityBadge('MinCIT', AppColors.accentOrange),
          ],
        ),
      ],
    );
  }

  Widget _buildDocRow(DocItemEntity doc, int index) {
    return GestureDetector(
      onTap: () => context.read<ChecklistBloc>().add(ToggleDocument(index)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color:
                    doc.completed ? AppColors.successGreen : Colors.transparent,
                border: doc.completed
                    ? null
                    : Border.all(
                        color: doc.hasError
                            ? AppColors.errorRed
                            : AppColors.border,
                        width: 1.5),
                shape: BoxShape.circle,
              ),
              child: doc.completed
                  ? const Icon(Icons.check, color: Colors.white, size: 13)
                  : doc.hasError
                      ? const Icon(Icons.error_outline_rounded,
                          color: AppColors.errorRed, size: 14)
                      : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.name,
                      style: AppTextStyles.bodyRegular
                          .copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text('ENTIDAD: ${doc.entity}',
                      style:
                          AppTextStyles.labelUppercase.copyWith(fontSize: 10)),
                ],
              ),
            ),
            if (doc.needsUpload)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkNavy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('SUBIR',
                    style: AppTextStyles.badgeText
                        .copyWith(fontSize: 10, color: Colors.white)),
              )
            else
              const Icon(Icons.visibility_outlined,
                  size: 18, color: AppColors.textLabel),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTab() {
    final steps = [
      (
        TimelineStatus.completed,
        'Solicitud creada',
        'Inicio del proceso',
        '12 Oct, 09:00'
      ),
      (
        TimelineStatus.completed,
        'Documentos DIAN listos',
        'Factura y lista de empaque aprobados',
        '14 Oct, 11:30'
      ),
      (
        TimelineStatus.active,
        'Obtener Certificado ICA',
        'Pendiente de inspección fitosanitaria',
        null
      ),
      (TimelineStatus.pending, 'Declaración de Exportación', null, null),
      (TimelineStatus.pending, 'Embarque y BL', null, null),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: steps.asMap().entries.map((e) {
        final (status, title, subtitle, timestamp) = e.value;
        return TimelineStep(
          status: status,
          title: title,
          subtitle: subtitle,
          timestamp: timestamp,
          isLast: e.key == steps.length - 1,
        );
      }).toList(),
    );
  }

  Widget _buildEntitiesTab() {
    final entities = [
      (
        'DIAN',
        'Dirección de Impuestos y Aduanas Nacionales',
        Icons.account_balance_rounded,
        AppColors.primaryDarkNavy,
        true
      ),
      (
        'ICA',
        'Instituto Colombiano Agropecuario',
        Icons.eco_rounded,
        AppColors.successGreen,
        false
      ),
      (
        'INVIMA',
        'Instituto Nacional de Vigilancia',
        Icons.health_and_safety_outlined,
        AppColors.infoBlue,
        false
      ),
      (
        'MinCIT',
        'Ministerio de Comercio, Industria y Turismo',
        Icons.business_center_outlined,
        AppColors.accentOrange,
        false
      ),
      (
        'VUCE',
        'Ventanilla Única de Comercio Exterior',
        Icons.computer_outlined,
        Colors.teal,
        false
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: entities.map((e) {
        final (code, name, icon, color, connected) = e;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: AppDecorations.card,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(code, style: AppTextStyles.cardTitle),
                    Text(name,
                        style: AppTextStyles.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              if (connected)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                              color: AppColors.successGreen,
                              shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text('Conectado',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.successGreen)),
                    ],
                  ),
                )
              else
                Text('Conectar',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.accentOrange)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Shared visual widget (extracted from private class) ─────────────────────
class _EntityBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _EntityBadge(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: AppTextStyles.badgeText.copyWith(color: color, fontSize: 10)),
    );
  }
}
