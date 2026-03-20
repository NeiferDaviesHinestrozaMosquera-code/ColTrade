import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../bloc/security_bloc.dart';
import '../../domain/entities/session_entity.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SecurityBloc()..add(const LoadSecurity()),
      child: const _SecurityView(),
    );
  }
}

class _SecurityView extends StatelessWidget {
  const _SecurityView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SecurityBloc, SecurityState>(
      builder: (context, state) {
        final bloc = context.read<SecurityBloc>();
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Seguridad de la Cuenta',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            children: [
              // ── ACCESO ──────────────────────────────────────────────────────
              _sectionLabel('ACCESO'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: AppDecorations.card,
                child: Column(
                  children: [
                    _securityTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'Cambiar Contraseña',
                      subtitle: 'Actualiza tu contraseña regularmente',
                      onTap: () => _showChangePasswordSheet(context),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    // 2FA tile with BLoC state
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryDarkNavy,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.lock_rounded,
                            color: Colors.white, size: 20),
                      ),
                      title: Text('Autenticación de dos factores (2FA)',
                          style: AppTextStyles.bodyRegular
                              .copyWith(fontWeight: FontWeight.w600)),
                      subtitle: Text('Añade una capa extra de seguridad',
                          style: AppTextStyles.caption),
                      trailing: Switch(
                        value: state.twoFAEnabled,
                        onChanged: (_) => bloc.add(const Toggle2FA()),
                        activeColor: AppColors.primaryDarkNavy,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── SESIONES ACTIVAS ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SESIONES ACTIVAS', style: AppTextStyles.labelUppercase),
                    GestureDetector(
                      onTap: () =>
                          _confirmCloseAllSessions(context, bloc),
                      child: Text(
                        'Cerrar todas',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.errorRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: AppDecorations.card,
                child: Column(
                  children: state.sessions.asMap().entries.map((entry) {
                    final i = entry.key;
                    final session = entry.value;
                    return Column(
                      children: [
                        _sessionTile(
                          session: session,
                          onClose: session.isCurrent
                              ? null
                              : () => _confirmCloseSession(
                                    context,
                                    bloc,
                                    session,
                                  ),
                        ),
                        if (i < state.sessions.length - 1)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 28),

              // ── HISTORIAL ────────────────────────────────────────────────
              _sectionLabel('HISTORIAL DE INICIO DE SESIÓN'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: AppDecorations.card,
                child: Column(
                  children: [
                    _loginHistoryTile(
                        success: true,
                        label: 'Inicio de sesión exitoso',
                        date: '12 Oct 2023, 14:30',
                        ip: '186.12.XX.XX'),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _loginHistoryTile(
                        success: false,
                        label: 'Intento fallido',
                        date: '10 Oct 2023, 09:15',
                        ip: '192.168.X.X'),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _loginHistoryTile(
                        success: true,
                        label: 'Inicio de sesión exitoso',
                        date: '08 Oct 2023, 20:10',
                        ip: '186.12.XX.XX'),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Ver historial completo',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryDarkNavy.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_user_rounded,
                          color: AppColors.primaryDarkNavy, size: 22),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ColTrade AI protege tu cuenta con cifrado de grado '
                      'militar. Si notas actividad inusual, contacta a soporte '
                      'inmediatamente.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  static Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 10),
        child: Text(label, style: AppTextStyles.labelUppercase),
      );

  static Widget _securityTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryDarkNavy, size: 20),
      ),
      title: Text(title,
          style: AppTextStyles.bodyRegular
              .copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: AppColors.textSecondary),
    );
  }

  static Widget _sessionTile({
    required SessionEntity session,
    VoidCallback? onClose,
  }) {
    final icon = session.iconType == 'phone'
        ? Icons.smartphone_rounded
        : Icons.computer_rounded;

    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 26),
      title: Row(
        children: [
          Flexible(
            child: Text(session.device,
                style: AppTextStyles.bodyRegular
                    .copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis),
          ),
          if (session.isCurrent) ...[
            const SizedBox(width: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.successGreen,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('ACTUAL',
                  style: AppTextStyles.badgeText
                      .copyWith(fontSize: 9, color: Colors.white)),
            ),
          ],
        ],
      ),
      subtitle: Text('${session.location} • ${session.time}',
          style: AppTextStyles.caption),
      trailing: session.isCurrent
          ? null
          : IconButton(
              icon: const Icon(Icons.logout_rounded,
                  size: 18, color: AppColors.textSecondary),
              onPressed: onClose,
            ),
    );
  }

  static Widget _loginHistoryTile({
    required bool success,
    required String label,
    required String date,
    required String ip,
  }) {
    return ListTile(
      leading: Icon(
        success ? Icons.check_circle_rounded : Icons.cancel_rounded,
        color: success ? AppColors.successGreen : AppColors.errorRed,
        size: 26,
      ),
      title: Text(label,
          style: AppTextStyles.bodyRegular
              .copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text('$date • $ip', style: AppTextStyles.caption),
    );
  }

  // ── Dialogs ──────────────────────────────────────────────────────────────

  static void _showChangePasswordSheet(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) {
          bool obscureCurrent = true;
          bool obscureNew = true;
          bool obscureConfirm = true;
          return Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Cambiar Contraseña',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      )),
                  const SizedBox(height: 6),
                  Text('Usa al menos 8 caracteres con letras y números.',
                      style: AppTextStyles.caption),
                  const SizedBox(height: 24),
                  _passwordField(
                    controller: currentCtrl,
                    label: 'Contraseña actual',
                    obscure: obscureCurrent,
                    onToggle: () =>
                        setModal(() => obscureCurrent = !obscureCurrent),
                  ),
                  const SizedBox(height: 14),
                  _passwordField(
                    controller: newCtrl,
                    label: 'Nueva contraseña',
                    obscure: obscureNew,
                    onToggle: () =>
                        setModal(() => obscureNew = !obscureNew),
                  ),
                  const SizedBox(height: 14),
                  _passwordField(
                    controller: confirmCtrl,
                    label: 'Confirmar nueva contraseña',
                    obscure: obscureConfirm,
                    onToggle: () =>
                        setModal(() => obscureConfirm = !obscureConfirm),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                '✅ Contraseña actualizada correctamente'),
                            backgroundColor: AppColors.successGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDarkNavy,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Guardar cambios',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.caption,
        filled: true,
        fillColor: AppColors.surfaceGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  static void _confirmCloseSession(
      BuildContext context, SecurityBloc bloc, SessionEntity session) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cerrar sesión',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        content: Text('¿Quieres cerrar la sesión en "${session.device}"?',
            style: AppTextStyles.bodySmall),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style:
                    GoogleFonts.inter(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              bloc.add(CloseSession(session.id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sesión de "${session.device}" cerrada'),
                  backgroundColor: AppColors.primaryDarkNavy,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Cerrar sesión',
                style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static void _confirmCloseAllSessions(
      BuildContext context, SecurityBloc bloc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cerrar todas las sesiones',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        content: Text(
            'Se cerrarán todas las sesiones activas excepto la actual.',
            style: AppTextStyles.bodySmall),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style:
                    GoogleFonts.inter(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              bloc.add(const CloseAllSessions());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todas las sesiones han sido cerradas'),
                  backgroundColor: AppColors.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Cerrar todas',
                style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
