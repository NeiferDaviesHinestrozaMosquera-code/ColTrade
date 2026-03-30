import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../subscription/domain/entities/subscription_plan.dart';
import '../../../subscription/presentation/bloc/subscription_bloc.dart';

// ─── Static Plan Catalogue ────────────────────────────────────────────────────

final _plans = <SubscriptionPlan>[
  const SubscriptionPlan(
    tier: PlanTier.free,
    id: 'free',
    name: 'Free',
    tagline: 'Ideal para explorar ColTrade',
    price: 'Gratis',
    period: '',
    icon: Icons.explore_outlined,
    gradientColors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
    accentColor: Color(0xFF6B7280),
    features: [
      'Consultas arancelarias básicas',
      'Calculadora de costos (5/mes)',
      'Noticias y alertas generales',
      'Clasificador NANDINA básico',
      'Soporte por email',
    ],
  ),
  const SubscriptionPlan(
    tier: PlanTier.pro,
    id: 'pro',
    name: 'Pro',
    tagline: 'Para profesionales del comercio',
    price: '\$49.900',
    period: '/mes',
    icon: Icons.bolt_rounded,
    gradientColors: [Color(0xFF0F1C3F), Color(0xFF1E3A8A)],
    accentColor: Color(0xFF3B82F6),
    isPopular: true,
    features: [
      'Consultas arancelarias ilimitadas',
      'Asistente IA importación/exportación',
      'Calculadora avanzada sin límites',
      'Alertas TLC personalizadas',
      'Clasificador NANDINA con IA',
      'Centro de conocimiento completo',
      'Repositorio de documentos (5 GB)',
      'Soporte prioritario por chat',
    ],
  ),
  const SubscriptionPlan(
    tier: PlanTier.pymes,
    id: 'pymes',
    name: 'Pymes',
    tagline: 'Para equipos de hasta 5 usuarios',
    price: '\$149.900',
    period: '/mes',
    icon: Icons.groups_rounded,
    gradientColors: [Color(0xFF059669), Color(0xFF10B981)],
    accentColor: Color(0xFF10B981),
    features: [
      'Todo lo del Plan Pro',
      'Hasta 5 usuarios por cuenta',
      'Panel de control multi-usuario',
      'Reportes consolidados mensuales',
      'Integración básica con ERP',
      'Gestión de operaciones en equipo',
      'Repositorio compartido (20 GB)',
      'Historial completo de operaciones',
      'Soporte prioritario por WhatsApp',
    ],
  ),
  const SubscriptionPlan(
    tier: PlanTier.empresarial,
    id: 'empresarial',
    name: 'Empresarial',
    tagline: 'Solución completa para grandes empresas',
    price: 'Contactar',
    period: '',
    icon: Icons.diamond_rounded,
    gradientColors: [Color(0xFFD97706), Color(0xFFF59E0B)],
    accentColor: Color(0xFFF59E0B),
    isEnterprise: true,
    features: [
      'Todo lo del Plan Pymes',
      'Usuarios ilimitados',
      'API REST dedicada',
      'Sincronización SAP / ERP completa',
      'Account Manager dedicado',
      'Reportes personalizados con BI',
      'Almacenamiento ilimitado',
      'SLA 99.9% uptime garantizado',
      'Soporte 24/7 con línea directa',
      'Capacitación y onboarding in-company',
    ],
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    // Trigger load as soon as screen opens
    context.read<SubscriptionBloc>().add(SubscriptionLoadPlans());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  SubscriptionPlan _planFromTier(PlanTier tier) =>
      _plans.firstWhere((p) => p.tier == tier, orElse: () => _plans.first);

  String _tierRenewalDate(PlanTier tier) {
    if (tier == PlanTier.free) return 'N/A';
    return '15 Abr';
  }

  String _tierStorage(PlanTier tier) {
    switch (tier) {
      case PlanTier.free:
        return '500 MB';
      case PlanTier.pro:
        return '5 GB';
      case PlanTier.pymes:
        return '20 GB';
      case PlanTier.empresarial:
        return '∞';
    }
  }

  String _tierQueries(PlanTier tier) =>
      tier == PlanTier.free ? '5/mes' : '∞';

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ColTradeAppBar(
        title: 'Planes y Suscripción',
        dark: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppColors.accentOrange),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // fallback if using GoRouter without history
              GoRouter.of(context).go('/profile'); 
            }
          },
        ),
      ),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) {
          if (state is SubscriptionChangedSuccess) {
            final plan = _planFromTier(state.newTier);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  plan.isEnterprise
                      ? '✅ Solicitud enviada. Te contactaremos pronto.'
                      : '✅ Plan ${plan.name} activado exitosamente',
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: AppColors.primaryDarkNavy,
              ),
            );
          }
          if (state is SubscriptionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('⚠️ ${state.message}'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.errorRed,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SubscriptionLoading || state is SubscriptionInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryDarkNavy,
              ),
            );
          }

          final activeTier = (state is SubscriptionLoaded)
              ? state.activeTier
              : PlanTier.free;
          final isChanging =
              (state is SubscriptionLoaded) && state.isChanging;

          return FadeTransition(
            opacity: _fadeIn,
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildCurrentPlanHeader(activeTier),
                    const SizedBox(height: 24),
                    Text('ELIGE TU PLAN', style: AppTextStyles.labelUppercase),
                    const SizedBox(height: 14),
                    ..._plans.map((plan) =>
                        _buildPlanCard(plan, activeTier, isChanging)),
                    const SizedBox(height: 16),
                    _buildComparisonNote(),
                    const SizedBox(height: 24),
                  ],
                ),
                if (isChanging)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Current Plan Header ────────────────────────────────────────────────────

  Widget _buildCurrentPlanHeader(PlanTier activeTier) {
    final current = _planFromTier(activeTier);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: current.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: current.gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(current.icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu plan actual',
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white60),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Plan ${current.name}',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'ACTIVO',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _headerStat('Consultas', _tierQueries(activeTier)),
                _headerDivider(),
                _headerStat('Documentos', _tierStorage(activeTier)),
                _headerDivider(),
                _headerStat('Renovación', _tierRenewalDate(activeTier)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.white60),
        ),
      ],
    );
  }

  Widget _headerDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  // ── Plan Card ──────────────────────────────────────────────────────────────

  Widget _buildPlanCard(
    SubscriptionPlan plan,
    PlanTier activeTier,
    bool isChanging,
  ) {
    final isCurrent = plan.tier == activeTier;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(
        milliseconds: 400 + (_plans.indexOf(plan) * 120),
      ),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(18),
          border: isCurrent
              ? Border.all(color: plan.accentColor, width: 2)
              : Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: isCurrent
                  ? plan.accentColor.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: isCurrent ? 16 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    plan.gradientColors.first.withValues(alpha: 0.08),
                    plan.gradientColors.last.withValues(alpha: 0.03),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: plan.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(plan.icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              plan.name,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (plan.isPopular) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.accentOrange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'POPULAR',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.successGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'ACTUAL',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(plan.tagline, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Price
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan.price,
                    style: GoogleFonts.inter(
                      fontSize: plan.isEnterprise ? 22 : 28,
                      fontWeight: FontWeight.bold,
                      color: plan.accentColor,
                    ),
                  ),
                  if (plan.period.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, left: 2),
                      child: Text(
                        plan.period,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                ],
              ),
            ),

            // Features
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
              child: Column(
                children: plan.features
                    .map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(top: 1),
                                decoration: BoxDecoration(
                                  color: plan.accentColor
                                      .withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 13,
                                  color: plan.accentColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  f,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textBody,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),

            // Action button
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: isCurrent
                    ? OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppColors.border, width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Plan Actual',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: isChanging
                            ? null
                            : () => _showPlanChangeDialog(plan, activeTier),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: plan.isEnterprise
                              ? plan.accentColor
                              : AppColors.primaryDarkNavy,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          plan.isEnterprise
                              ? 'Contactar Ventas'
                              : 'Elegir Plan ${plan.name}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Comparison Note ────────────────────────────────────────────────────────

  Widget _buildComparisonNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: AppColors.infoBlue, width: 3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.infoBlue, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SOBRE LOS PLANES',
                  style: AppTextStyles.labelUppercase
                      .copyWith(color: AppColors.infoBlue, letterSpacing: 0.8),
                ),
                const SizedBox(height: 4),
                Text(
                  'Puedes cambiar o cancelar tu plan en cualquier momento. '
                  'Los cambios se aplican al siguiente ciclo de facturación. '
                  'Si necesitas ayuda, contáctanos a soporte@coltrade.co.',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Plan Change Dialog ─────────────────────────────────────────────────────

  void _showPlanChangeDialog(SubscriptionPlan plan, PlanTier currentTier) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: plan.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(plan.icon, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                plan.isEnterprise
                    ? '¿Solicitar Plan ${plan.name}?'
                    : '¿Cambiar al Plan ${plan.name}?',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                plan.isEnterprise
                    ? 'Un asesor comercial se pondrá en contacto contigo para diseñar un plan a la medida de tu empresa.'
                    : 'Tu nuevo plan se activará al inicio del próximo ciclo de facturación. ${plan.price}${plan.period}',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Cancelar',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context
                            .read<SubscriptionBloc>()
                            .add(SubscriptionChangePlan(plan.tier));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: plan.accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        plan.isEnterprise ? 'Solicitar' : 'Confirmar',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
