import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../data/datasources/logistics_local_datasource.dart';
import '../../data/repositories/logistics_repository_impl.dart';
import '../../domain/entities/port.dart';
import '../../domain/usecases/get_ports_usecase.dart';
import '../../domain/usecases/get_routes_usecase.dart';
import '../bloc/logistics_bloc.dart';
import '../widgets/port_card_widget.dart';
import '../widgets/animated_route_widget.dart';
import '../widgets/alternatives_panel_widget.dart';

class LogisticsScreen extends StatelessWidget {
  const LogisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final datasource = LogisticsLocalDatasource();
    final repository = LogisticsRepositoryImpl(datasource);
    return BlocProvider(
      create: (_) => LogisticsBloc(
        getPorts: GetPortsUseCase(repository),
        getRoutes: GetRoutesUseCase(repository),
        getAlternatives: GetAlternativesUseCase(repository),
      )..add(const LoadLogisticsData()),
      child: const _LogisticsView(),
    );
  }
}

class _LogisticsView extends StatelessWidget {
  const _LogisticsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogisticsBloc, LogisticsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 3),
            child: Column(
              children: [
                const ColombiaTricolorBar(),
                AppBar(
                  backgroundColor: AppColors.primaryDarkNavy,
                  title: Text(
                    '🗺️ Logística',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: const NotificationBell(
                          color: Colors.white60, hasNotification: false),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: state.status == LogisticsStatus.loading ||
                  state.status == LogisticsStatus.initial
              ? const _LoadingView()
              : state.status == LogisticsStatus.error
                  ? _ErrorView(message: state.errorMessage ?? 'Error')
                  : _LoadedView(state: state),
        );
      },
    );
  }
}

// ── Loading ────────────────────────────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primaryDarkNavy),
          const SizedBox(height: 14),
          Text('Cargando rutas y puertos…',
              style: AppTextStyles.bodySmall)
              .animate()
              .fadeIn(duration: 500.ms),
        ],
      ),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.errorRed, size: 48),
          const SizedBox(height: 12),
          Text(message, style: AppTextStyles.bodySmall),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                context.read<LogisticsBloc>().add(const LoadLogisticsData()),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

// ── Loaded ────────────────────────────────────────────────────────────────────
class _LoadedView extends StatelessWidget {
  final LogisticsState state;
  const _LoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeroBanner(),
        _TabSelector(activeTab: state.activeTab),
        Expanded(
          child: _buildTabContent(context, state),
        ),
      ],
    );
  }

  Widget _buildTabContent(BuildContext context, LogisticsState state) {
    switch (state.activeTab) {
      case 0:
        return _PortsTab(state: state);
      case 1:
        return _RoutesTab(state: state);
      case 2:
        return _AlternativesTab(state: state);
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Hero Banner ───────────────────────────────────────────────────────────────
class _HeroBanner extends StatefulWidget {
  @override
  State<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<_HeroBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shipAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _shipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1C3F), Color(0xFF1A3A6E), Color(0xFF0D6EFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D6EFD).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -10,
              bottom: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Wave lines (decorative)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: const Size(double.infinity, 40),
                painter: _WavePainter(),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Red Logística Colombia',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1),
                        const SizedBox(height: 4),
                        Text(
                          'Puertos · Rutas · Alternativas de transporte',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.white60,
                          ),
                        ).animate().fadeIn(delay: 150.ms, duration: 500.ms),
                        const Spacer(),
                        Row(
                          children: [
                            _statChip('🚢 6', 'Puertos\nMarítimos'),
                            const SizedBox(width: 10),
                            _statChip('✈️ 4', 'Aeropuertos'),
                            const SizedBox(width: 10),
                            _statChip('🌍 8', 'Rutas\nInternac.'),
                          ],
                        ).animate().fadeIn(delay: 250.ms, duration: 500.ms),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Animated moving ship/plane
                  AnimatedBuilder(
                    animation: _shipAnim,
                    builder: (_, __) {
                      return Transform.translate(
                        offset: Offset(0, -8 + _shipAnim.value * 8),
                        child: const Text('🚢', style: TextStyle(fontSize: 52)),
                      );
                    },
                  ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Text(label,
            style: GoogleFonts.inter(fontSize: 9, color: Colors.white54)),
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.25, 0, size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.8, size.width, size.height * 0.4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter _) => false;
}

// ── Tab Selector ──────────────────────────────────────────────────────────────
class _TabSelector extends StatelessWidget {
  final int activeTab;
  const _TabSelector({required this.activeTab});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surfaceGray,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            _tabOption(context, 0, '🚢 Puertos', activeTab),
            _tabOption(context, 1, '🌍 Rutas', activeTab),
            _tabOption(context, 2, '⚖️ Alternativas', activeTab),
          ],
        ),
      ),
    );
  }

  Widget _tabOption(
      BuildContext context, int index, String label, int active) {
    final isActive = index == active;
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            context.read<LogisticsBloc>().add(SelectTab(index)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryDarkNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primaryDarkNavy.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight:
                  isActive ? FontWeight.w700 : FontWeight.normal,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Ports Tab ─────────────────────────────────────────────────────────────────
class _PortsTab extends StatelessWidget {
  final LogisticsState state;
  const _PortsTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LogisticsBloc>();
    return Column(
      children: [
        // Filter chips
        SizedBox(
          height: 42,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: [
              _filterChip(context, null, '🌐 Todos', bloc, state.portTypeFilter),
              const SizedBox(width: 8),
              _filterChip(
                  context, PortType.sea, '🚢 Marítimo', bloc, state.portTypeFilter),
              const SizedBox(width: 8),
              _filterChip(
                  context, PortType.air, '✈️ Aéreo', bloc, state.portTypeFilter),
              const SizedBox(width: 8),
              _filterChip(
                  context, PortType.river, '🛶 Fluvial', bloc, state.portTypeFilter),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 8),

        // Port list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: state.filteredPorts.length,
            itemBuilder: (_, i) {
              final port = state.filteredPorts[i];
              return PortCardWidget(
                port: port,
                isSelected: state.selectedPort?.id == port.id,
                animationIndex: i,
                onTap: () {
                  if (state.selectedPort?.id == port.id) {
                    bloc.add(const DismissSelection());
                  } else {
                    bloc.add(SelectPort(port));
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _filterChip(BuildContext context, PortType? type, String label,
      LogisticsBloc bloc, PortType? currentFilter) {
    final isActive = currentFilter == type;
    return GestureDetector(
      onTap: () => bloc.add(FilterByPortType(isActive ? null : type)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryDarkNavy : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primaryDarkNavy : AppColors.border,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primaryDarkNavy.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ── Routes Tab ────────────────────────────────────────────────────────────────
class _RoutesTab extends StatelessWidget {
  final LogisticsState state;
  const _RoutesTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LogisticsBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(
            '${state.routes.length} rutas internacionales activas',
            style: AppTextStyles.bodySmall,
          ).animate().fadeIn(duration: 300.ms),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: state.routes.length,
            itemBuilder: (_, i) {
              final route = state.routes[i];
              return AnimatedRouteWidget(
                route: route,
                isSelected: state.selectedRoute?.id == route.id,
                animationIndex: i,
                onTap: () {
                  if (state.selectedRoute?.id == route.id) {
                    bloc.add(const DismissSelection());
                  } else {
                    bloc.add(SelectRoute(route));
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Alternatives Tab ──────────────────────────────────────────────────────────
class _AlternativesTab extends StatelessWidget {
  final LogisticsState state;
  const _AlternativesTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      child: AlternativesPanelWidget(alternatives: state.alternatives),
    );
  }
}
