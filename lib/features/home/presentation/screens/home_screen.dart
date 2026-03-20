import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/common_widgets.dart';
import '../../../alerts/presentation/screens/alerts_screen.dart';
import '../../../checklist/presentation/screens/checklist_screen.dart';
import '../../../calculator/presentation/screens/calculator_screen.dart';
import '../../../security/presentation/screens/security_screen.dart';
import '../bloc/home_bloc.dart';
import '../../../../screens/export_assistant_screen.dart';
import '../../../../screens/import_assistant_screen.dart';
import '../../../../screens/knowledge_center_screen.dart';
import '../../../../screens/nandina_classifier_screen.dart';
import '../../../../screens/agents_screen.dart';
import '../../../../screens/personal_info_screen.dart';
import '../../../../screens/company_info_screen.dart';
import '../../../../screens/api_erp_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final tab = state.selectedTab;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: tab == 0
              ? _buildDashboard(context)
              : tab == 1
                  ? _buildOperaciones(context)
                  : tab == 2
                      ? _buildHerramientas(context)
                      : _buildPerfil(context),
          bottomNavigationBar: _buildBottomNav(context, tab),
        );
      },
    );
  }

  // ── Dashboard ───────────────────────────────────────────────────────────

  Widget _buildDashboard(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.primaryDarkNavy,
          expandedHeight: 0,
          toolbarHeight: kToolbarHeight,
          title: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.accentOrange,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.business_rounded,
                    color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Text('ColTrade',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
          actions: [
            IconButton(
              icon: const NotificationBell(hasNotification: true),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AlertsScreen())),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hola, Empresa Exportadora',
                    style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('Resumen de operaciones para hoy',
                    style: AppTextStyles.bodySmall),
                const SizedBox(height: 24),
                SizedBox(
                  height: 160,
                  child: GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      QuickAccessItem(
                        icon: Icons.smart_toy_outlined,
                        label: 'Asistente',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const ExportAssistantScreen())),
                      ),
                      QuickAccessItem(
                        icon: Icons.calculate_outlined,
                        label: 'Cálculo',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CalculatorScreen())),
                      ),
                      QuickAccessItem(
                        icon: Icons.people_outline_rounded,
                        label: 'Agentes',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AgentsScreen())),
                      ),
                      QuickAccessItem(
                        icon: Icons.school_outlined,
                        label: 'Cursos',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const KnowledgeCenterScreen())),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SectionHeader(title: 'Cargas Activas', action: 'VER TODO'),
                const SizedBox(height: 12),
                _buildShipmentCard(
                  context: context,
                  badge: BadgeStatus.exportacion,
                  title: 'Café Premium a España',
                  id: 'CT-48293',
                  eta: '25 Oct',
                  statusLabel: 'EN TRÁNSITO (ATLÁNTICO)',
                  statusColor: AppColors.textSecondary,
                  progress: 0.80,
                  icon: Icons.coffee_rounded,
                  iconColor: Colors.brown,
                ),
                const SizedBox(height: 12),
                _buildShipmentCard(
                  context: context,
                  badge: BadgeStatus.importacion,
                  title: 'Electrónicos desde China',
                  id: 'CT-92104',
                  eta: 'Buenaventura',
                  statusLabel: 'ADUANA – REVISIÓN DIAN',
                  statusColor: AppColors.errorRed,
                  progress: 0.25,
                  icon: Icons.memory_rounded,
                  iconColor: Colors.teal,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ChecklistScreen())),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShipmentCard({
    required BuildContext context,
    required BadgeStatus badge,
    required String title,
    required String id,
    required String eta,
    required String statusLabel,
    required Color statusColor,
    required double progress,
    required IconData icon,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatusBadge(status: badge),
                const Spacer(),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(title, style: AppTextStyles.cardTitle),
            const SizedBox(height: 4),
            Text('ID: $id · Puerto/ETA: $eta', style: AppTextStyles.caption),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryDarkNavy),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(statusLabel,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: statusColor == AppColors.errorRed
                          ? FontWeight.w700
                          : FontWeight.normal,
                      color: statusColor,
                    )),
                Text('Detalles →',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.accentOrange)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Operaciones ─────────────────────────────────────────────────────────

  Widget _buildOperaciones(BuildContext context) {
    return Scaffold(
      appBar: const ColTradeAppBar(title: 'Operaciones'),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _operationTile(
            icon: Icons.upload_rounded,
            title: 'Nueva Exportación',
            subtitle: 'Iniciar proceso de exportación',
            color: AppColors.successGreen,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ExportAssistantScreen())),
          ),
          const SizedBox(height: 12),
          _operationTile(
            icon: Icons.download_rounded,
            title: 'Nueva Importación',
            subtitle: 'Iniciar proceso de importación',
            color: AppColors.infoBlue,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ImportAssistantScreen())),
          ),
          const SizedBox(height: 12),
          _operationTile(
            icon: Icons.checklist_rounded,
            title: 'Checklist Inteligente',
            subtitle: 'Gestiona tus documentos',
            color: AppColors.accentOrange,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ChecklistScreen())),
          ),
          const SizedBox(height: 12),
          _operationTile(
            icon: Icons.search_rounded,
            title: 'Clasificador NANDINA',
            subtitle: 'Clasifica tu producto con IA',
            color: Colors.purple,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NandinaClassifierScreen())),
          ),
        ],
      ),
    );
  }

  Widget _operationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.card,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  // ── Herramientas ────────────────────────────────────────────────────────

  Widget _buildHerramientas(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 3),
        child: Column(
          children: [
            const ColombiaTricolorBar(),
            AppBar(
              backgroundColor: AppColors.primaryDarkNavy,
              title: Text('Herramientas',
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              automaticallyImplyLeading: false,
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF0891B2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Asistente IA',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(
                          'Clasificación inteligente y checklist automático',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: Colors.white70)),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: AppColors.successGreen,
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text('Disponible ahora',
                              style: AppTextStyles.caption
                                  .copyWith(color: Colors.white70)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const NandinaClassifierScreen())),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Abrir Asistente',
                                  style: AppTextStyles.caption.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CalculatorScreen())),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryDarkNavy,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Calculadora de Costos',
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('Landed Cost Pro – Calcula tu costo real',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: Colors.white60)),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white60),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('📊 Nueva Cotización',
                              style: AppTextStyles.caption
                                  .copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.calculate_rounded,
                      color: Colors.white30, size: 60),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.4,
            children: [
              _toolCard(Icons.folder_outlined, 'Repositorio',
                  'Gestiona documentos'),
              _toolCard(
                  Icons.history_rounded, 'Historial', 'Últimas consultas'),
              _toolCard(
                  Icons.notifications_outlined, 'Alertas', 'Regulaciones DIAN',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AlertsScreen()))),
              _toolCard(Icons.map_outlined, 'Logística', 'Puertos y rutas'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toolCard(IconData icon, String title, String subtitle,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceGray,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryDarkNavy, size: 26),
            const SizedBox(height: 8),
            Text(title,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Flexible(
              child: Text(subtitle,
                  style: AppTextStyles.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  // ── Perfil ───────────────────────────────────────────────────────────────

  Widget _buildPerfil(BuildContext context) {
    return Scaffold(
      appBar: const ColTradeAppBar(title: 'Perfil', dark: false),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.card,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryDarkNavy,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('CR',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.accentOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            color: Colors.white, size: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Carlos Rodriguez',
                    style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                Text('TechCorp Solutions', style: AppTextStyles.bodySmall),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDarkNavy,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('PLAN PRO',
                      style:
                          AppTextStyles.badgeText.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _profileSection('CONFIGURACIÓN', [
            _profileItem(
              Icons.person_outline,
              'Información Personal',
              'Datos de tu perfil',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PersonalInfoScreen())),
            ),
            _profileItem(
              Icons.business_outlined,
              'Empresa',
              'TechCorp Solutions',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CompanyInfoScreen())),
            ),
            _profileItem(
              Icons.security_outlined,
              'Seguridad',
              'Contraseña y 2FA',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SecurityScreen())),
            ),
            _profileItem(Icons.notifications_outlined, 'Notificaciones',
                'Alertas y frecuencia',
                badge: 'ENT'),
            _profileItem(Icons.api_outlined, 'API / ERP',
                'Sincronización SAP',
                badge: 'ENT',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ApiErpScreen()))),
          ]),
          const SizedBox(height: 16),
          _profileSection('CENTRO DE AYUDA', [
            _profileItem(Icons.confirmation_number_outlined, 'Mis Tickets',
                'Soporte activo'),
            _profileItem(
                Icons.play_circle_outline, 'Tutoriales', 'Videos de ayuda'),
          ]),
          const SizedBox(height: 16),
          CTAButton(label: '💬  Contactar Soporte', onTap: () {}),
        ],
      ),
    );
  }

  Widget _profileSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.labelUppercase),
        const SizedBox(height: 8),
        Container(
          decoration: AppDecorations.card,
          child: Column(
            children: items
                .asMap()
                .entries
                .map((e) => Column(
                      children: [
                        e.value,
                        if (e.key < items.length - 1)
                          const Divider(height: 1),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _profileItem(IconData icon, String title, String subtitle,
      {String? badge, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Row(
        children: [
          Text(title,
              style: AppTextStyles.bodyRegular
                  .copyWith(fontWeight: FontWeight.w600)),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentOrange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(badge,
                  style: AppTextStyles.badgeText
                      .copyWith(fontSize: 9, color: Colors.white)),
            ),
          ],
        ],
      ),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: AppColors.textSecondary),
    );
  }

  // ── Bottom Navigation ───────────────────────────────────────────────────

  Widget _buildBottomNav(BuildContext context, int selectedTab) {
    const tabs = [
      (Icons.home_rounded, Icons.home_outlined, 'INICIO'),
      (Icons.anchor_rounded, Icons.anchor_outlined, 'OPERACIONES'),
      (Icons.build_rounded, Icons.build_outlined, 'HERRAMIENTAS'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'PERFIL'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: tabs.asMap().entries.map((e) {
              final active = e.key == selectedTab;
              final (activeIcon, inactiveIcon, label) = e.value;
              return Expanded(
                child: GestureDetector(
                  onTap: () => context
                      .read<HomeBloc>()
                      .add(ChangeHomeTab(e.key)),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (active)
                        Container(
                          height: 2,
                          width: 24,
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        )
                      else
                        const SizedBox(height: 2),
                      const SizedBox(height: 6),
                      Icon(
                        active ? activeIcon : inactiveIcon,
                        color: active
                            ? AppColors.accentOrange
                            : AppColors.textLabel,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? AppColors.accentOrange
                              : AppColors.textLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
