import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/notification_settings_bloc.dart';
import '../bloc/notification_settings_event.dart';
import '../bloc/notification_settings_state.dart';

// ─── Entry point ───────────────────────────────────────────────────────────────
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationSettingsBloc(),
      child: const _NotificationsSettingsView(),
    );
  }
}

// ─── Main View ─────────────────────────────────────────────────────────────────
class _NotificationsSettingsView extends StatelessWidget {
  const _NotificationsSettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  // ─── AppBar: tricolor + colombia blue ────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 3),
      child: Container(
        color: AppColors.colombiaBlue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ColombiaTricolorBar(),
            SizedBox(height: MediaQuery.of(context).padding.top),
            SizedBox(
              height: kToolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    if (Navigator.canPop(context))
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: AppColors.accentOrange, size: 18),
                        onPressed: () => Navigator.pop(context),
                      )
                    else
                      const SizedBox(width: 48),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notificaciones & Alertas',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Gestiona tus preferencias de comunicación',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Scrollable body ─────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context) {
    return BlocBuilder<NotificationSettingsBloc, NotificationSettingsState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            // ── Page header ──────────────────────────────────────────────────
            _buildPageHeader(context, state),

            // ── Estado de Canales card ───────────────────────────────────────
            _buildChannelStatusCard(),

            // ── Seguridad Crítica dark card ──────────────────────────────────
            _buildCriticalSecurityCard(),

            // ── Configurable sections ────────────────────────────────────────
            for (final section in state.sections) ...[
              _SectionHeader(section: section),
              for (int i = 0; i < section.items.length; i++)
                _SettingRow(
                  item: section.items[i],
                  context: context,
                  isLast: i == section.items.length - 1,
                ),
            ],
          ],
        );
      },
    );
  }

  // ─── Page header with title + save button ────────────────────────────────────
  Widget _buildPageHeader(BuildContext context, NotificationSettingsState state) {
    return Container(
      color: AppColors.cardWhite,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONFIGURACIÓN',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.colombiaBlue,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Notificaciones & Alertas',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gestione sus preferencias de comunicación para trámites y seguridad.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context
                    .read<NotificationSettingsBloc>()
                    .add(const SaveSettingsEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Preferencias guardadas correctamente',
                      style: GoogleFonts.inter(fontSize: 13),
                    ),
                    backgroundColor: AppColors.successGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: state.saved
                    ? const Icon(Icons.check_rounded,
                        key: ValueKey('check'), size: 18)
                    : const Icon(Icons.save_rounded,
                        key: ValueKey('save'), size: 18),
              ),
              label: Text(state.saved ? 'Cambios Guardados' : 'Guardar Cambios'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textPrimary,
                foregroundColor: Colors.white,
                textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(0, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Estado de Canales ───────────────────────────────────────────────────────
  Widget _buildChannelStatusCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              'ESTADO DE CANALES',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textLabel,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          _ChannelStatusRow(
            icon: Icons.email_outlined,
            iconColor: AppColors.colombiaBlue,
            label: 'Correo Electrónico',
            statusLabel: 'ACTIVO',
            statusColor: AppColors.successGreen,
          ),
          const Divider(height: 1, indent: 52, color: AppColors.border),
          _ChannelStatusRow(
            icon: Icons.notifications_active_outlined,
            iconColor: AppColors.accentOrange,
            label: 'Push (App Móvil)',
            statusLabel: 'ACTIVO',
            statusColor: AppColors.successGreen,
          ),
        ],
      ),
    );
  }

  // ─── Seguridad Crítica dark card ─────────────────────────────────────────────
  Widget _buildCriticalSecurityCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDarkNavy.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Decorative shield watermark
          Positioned(
            right: -12,
            bottom: -12,
            child: Icon(
              Icons.shield_rounded,
              size: 100,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.colombiaBlue.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield_rounded,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Seguridad Crítica',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Las alertas de inicio de sesión y cambios de contraseña no se pueden desactivar por políticas de cumplimiento internacional.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white60,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.verified_rounded,
                        size: 14, color: AppColors.colombiaYellow),
                    const SizedBox(width: 6),
                    Text(
                      'PROTECCIÓN DIAN-OE',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.colombiaYellow,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Channel Status Row ────────────────────────────────────────────────────────
class _ChannelStatusRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String statusLabel;
  final Color statusColor;

  const _ChannelStatusRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.statusLabel,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusLabel,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: statusColor,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final NotifSection section;
  const _SectionHeader({required this.section});

  IconData _iconFromAsset(String asset) => switch (asset) {
        'gavel' => Icons.gavel_rounded,
        'anchor' => Icons.anchor_rounded,
        'shield' => Icons.shield_rounded,
        _ => Icons.notifications_rounded,
      };

  Color _colorFromAsset(String asset) => switch (asset) {
        'gavel' => AppColors.colombiaBlue,
        'anchor' => AppColors.successGreen,
        'shield' => AppColors.errorRed,
        _ => AppColors.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    final icon = _iconFromAsset(section.iconAsset);
    final color = _colorFromAsset(section.iconAsset);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            border: Border(
              left: BorderSide(color: color, width: 3),
              top: BorderSide(color: color.withValues(alpha: 0.15)),
              right: BorderSide(color: color.withValues(alpha: 0.15)),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Individual setting row ────────────────────────────────────────────────────
class _SettingRow extends StatelessWidget {
  final NotifSetting item;
  final BuildContext context;
  final bool isLast;
  const _SettingRow({required this.item, required this.context, this.isLast = false});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 12 : 0),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              )
            : null,
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: isLast
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + description
            Text(
              item.title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.description,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),

            // Toggle controls
            Row(
              children: [
                // PUSH toggle
                if (!item.isLocked) ...[
                  _ToggleChip(
                    label: 'PUSH',
                    enabled: item.pushEnabled,
                    onTap: () => ctx
                        .read<NotificationSettingsBloc>()
                        .add(TogglePushEvent(item.key)),
                  ),
                  const SizedBox(width: 8),
                  // EMAIL toggle
                  _ToggleChip(
                      label: 'EMAIL',
                      enabled: item.emailEnabled,
                      onTap: () => ctx
                          .read<NotificationSettingsBloc>()
                          .add(ToggleEmailEvent(item.key)),
                    ),
                ] else ...[
                  // Locked PUSH chip
                  _ToggleChip(
                    label: 'PUSH',
                    enabled: item.pushEnabled,
                    onTap: null,
                    isLocked: true,
                  ),
                  const SizedBox(width: 8),
                  _LockedBadge(label: item.lockedLabel!),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Toggle chip (PUSH / EMAIL) ────────────────────────────────────────────────
class _ToggleChip extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final bool isLocked;

  const _ToggleChip({
    required this.label,
    required this.enabled,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 38,
            height: 22,
            decoration: BoxDecoration(
              color: enabled
                  ? AppColors.colombiaBlue
                  : AppColors.border,
              borderRadius: BorderRadius.circular(11),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment:
                  enabled ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: enabled ? AppColors.textPrimary : AppColors.textLabel,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Locked badge ──────────────────────────────────────────────────────────────
class _LockedBadge extends StatelessWidget {
  final String label;
  const _LockedBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.amberLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.yellowAmber.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.yellowAmber,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
