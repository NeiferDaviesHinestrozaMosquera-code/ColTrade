import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../features/security/domain/entities/auth_entity.dart';
import '../bloc/auth/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _docNumberController = TextEditingController();
  final _roleController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String _docType = 'CC';

  final _docTypes = ['CC', 'CE', 'NIT', 'Pasaporte', 'TI'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _docNumberController.dispose();
    _roleController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          RegisterSubmitted(
            user: AuthUserEntity(
              fullName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
              docType: _docType,
              docNumber: _docNumberController.text.trim(),
              role: _roleController.text.trim(),
              city: _cityController.text.trim(),
            ),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
              backgroundColor: AppColors.errorRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
        if (state is OtpSent) {
          context.push(
            '/otp',
            extra: {
              'maskedEmail': state.maskedEmail,
              'flowType': state.flowType,
            },
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: const ColTradeAppBar(
              title: 'Crear Cuenta',
              dark: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Header ─────────────────────────────────────────
                      Text('Únete a ColTrade',
                          style: AppTextStyles.h2(context)),
                      const SizedBox(height: 6),
                      Text(
                        'Completa tu información para comenzar a importar y exportar con facilidad.',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 28),

                      // ══ DATOS PERSONALES ══════════════════════════════
                      _sectionLabel('DATOS PERSONALES'),
                      const SizedBox(height: 12),
                      _card(
                        children: [
                          // Nombre
                          _fieldLabel('NOMBRE COMPLETO'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: AppDecorations.inputDecoration(
                              '',
                              'Ej. Carlos Rodríguez',
                              prefix: const Icon(Icons.person_outline_rounded,
                                  size: 18, color: AppColors.textLabel),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Campo requerido'
                                : null,
                          ),
                          const SizedBox(height: 14),

                          // Email
                          _fieldLabel('CORREO ELECTRÓNICO'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: AppDecorations.inputDecoration(
                              '',
                              'ejemplo@coltrade.com',
                              prefix: const Icon(Icons.email_outlined,
                                  size: 18, color: AppColors.textLabel),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Campo requerido';
                              }
                              if (!v.contains('@')) return 'Correo inválido';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // Teléfono
                          _fieldLabel('TELÉFONO / CELULAR'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: AppDecorations.inputDecoration(
                              '',
                              '+57 300 000 0000',
                              prefix: const Icon(Icons.phone_outlined,
                                  size: 18, color: AppColors.textLabel),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Campo requerido'
                                : null,
                          ),
                          const SizedBox(height: 14),

                          // Tipo + Número de documento
                          _fieldLabel('DOCUMENTO DE IDENTIDAD'),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  value: _docType,
                                  decoration:
                                      AppDecorations.inputDecoration('', ''),
                                  items: _docTypes
                                      .map((t) => DropdownMenuItem(
                                            value: t,
                                            child: Text(t,
                                                style: const TextStyle(
                                                    fontSize: 13)),
                                          ))
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => _docType = v!),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _docNumberController,
                                  keyboardType: TextInputType.number,
                                  decoration: AppDecorations.inputDecoration(
                                      '', 'Número de documento'),
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? 'Requerido'
                                          : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ══ DATOS LABORALES ═══════════════════════════════
                      _sectionLabel('DATOS LABORALES'),
                      const SizedBox(height: 12),
                      _card(
                        children: [
                          // Cargo
                          _fieldLabel('CARGO / ROL'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _roleController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: AppDecorations.inputDecoration(
                              '',
                              'Ej. Gerente de Comercio Exterior',
                              prefix: const Icon(Icons.work_outline_rounded,
                                  size: 18, color: AppColors.textLabel),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Campo requerido'
                                : null,
                          ),
                          const SizedBox(height: 14),

                          // Ciudad
                          _fieldLabel('CIUDAD DE RESIDENCIA'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _cityController,
                            textCapitalization: TextCapitalization.words,
                            decoration: AppDecorations.inputDecoration(
                              '',
                              'Ej. Bogotá D.C.',
                              prefix: const Icon(Icons.location_on_outlined,
                                  size: 18, color: AppColors.textLabel),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Campo requerido'
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ══ SEGURIDAD ═════════════════════════════════════
                      _sectionLabel('SEGURIDAD'),
                      const SizedBox(height: 12),
                      _card(
                        children: [
                          _fieldLabel('CONTRASEÑA'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            onChanged: (_) => setState(() {}),
                            decoration: AppDecorations.inputDecoration(
                              '',
                              '••••••••',
                              prefix: const Icon(Icons.lock_outline_rounded,
                                  size: 18, color: AppColors.textLabel),
                              suffix: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textLabel,
                                  size: 18,
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Campo requerido';
                              }
                              if (v.length < 8) {
                                return 'Mínimo 8 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          _PasswordStrengthBar(
                              password: _passwordController.text),
                          const SizedBox(height: 14),

                          _fieldLabel('CONFIRMAR CONTRASEÑA'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirm,
                            decoration: AppDecorations.inputDecoration(
                              '',
                              '••••••••',
                              prefix: const Icon(Icons.lock_outline_rounded,
                                  size: 18, color: AppColors.textLabel),
                              suffix: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textLabel,
                                  size: 18,
                                ),
                                onPressed: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Campo requerido';
                              }
                              if (v != _passwordController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Info 2FA
                      InfoCard(
                        title: 'Verificación en 2 Pasos',
                        body:
                            'Al crear tu cuenta recibirás un código de verificación en tu correo para activar la autenticación en 2 pasos.',
                        icon: Icons.verified_user_outlined,
                        borderColor: AppColors.accentOrange,
                        bgColor: AppColors.amberLight,
                      ),
                      const SizedBox(height: 28),

                      // CTA
                      CTAButton(
                        label: isLoading ? 'Creando cuenta...' : 'Crear Cuenta',
                        onTap: isLoading ? null : () => _onRegister(context),
                        icon: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('¿Ya tienes una cuenta?',
                              style: AppTextStyles.bodyRegular),
                          TextButton(
                            onPressed: () => context.go('/login'),
                            child: Text(
                              'Inicia Sesión',
                              style: AppTextStyles.bodyRegular.copyWith(
                                color: AppColors.accentOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionLabel(String label) =>
      Text(label, style: AppTextStyles.labelUppercase);

  Widget _fieldLabel(String label) =>
      Text(label, style: AppTextStyles.labelUppercase);

  Widget _card({required List<Widget> children}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
}

// ── Password Strength Bar ─────────────────────────────────────────────────────
class _PasswordStrengthBar extends StatelessWidget {
  final String password;

  const _PasswordStrengthBar({required this.password});

  int get _strength {
    if (password.isEmpty) return 0;
    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#\$%^&*]'))) score++;
    return score;
  }

  (Color color, String label) get _config {
    final s = _strength;
    if (s <= 1) return (AppColors.errorRed, 'Débil');
    if (s <= 3) return (AppColors.yellowAmber, 'Media');
    return (AppColors.successGreen, 'Fuerte');
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();
    final (color, label) = _config;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (i) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
                decoration: BoxDecoration(
                  color: i < _strength ? color : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          'Seguridad: $label',
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
