import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/auth/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _newPassFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocuses = List.generate(6, (_) => FocusNode());
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // Track current step locally so AuthLoading / AuthFailure don't reset view
  int _step = 0; // 0 = email, 1 = otp, 2 = new password
  String _maskedEmail = '';

  // Resend countdown
  int _resendSeconds = 0;
  Timer? _resendTimer;

  void _startResendTimer() {
    _resendSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds <= 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    for (final c in _otpControllers) { c.dispose(); }
    for (final f in _otpFocuses) { f.dispose(); }
    _newPassController.dispose();
    _confirmPassController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) _showError(state.message);
        if (state is OtpSent && state.flowType == OtpFlowType.forgotPassword) {
          setState(() {
            _step = 1;
            _maskedEmail = state.maskedEmail;
          });
          _startResendTimer();
        }
        if (state is PasswordResetReady) {
          setState(() => _step = 2);
        }
        if (state is PasswordResetSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('¡Contraseña restablecida exitosamente!',
                  style:
                      GoogleFonts.inter(fontSize: 14, color: Colors.white)),
              backgroundColor: AppColors.successGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ),
          );
          context.go('/login');
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const ColTradeAppBar(
            title: 'Recuperar Contraseña',
            dark: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: _buildStep(context, isLoading),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context, bool isLoading) {
    switch (_step) {
      case 1:
        return _OtpStep(
          key: const ValueKey('otp'),
          maskedEmail: _maskedEmail,
          controllers: _otpControllers,
          focuses: _otpFocuses,
          resendSeconds: _resendSeconds,
          isLoading: isLoading,
          onVerify: () {
            final otp = _otpControllers.map((c) => c.text).join();
            context.read<AuthBloc>().add(OtpVerified(
                otp: otp, flowType: OtpFlowType.forgotPassword));
          },
          onResend: _resendSeconds == 0
              ? () {
                  context.read<AuthBloc>().add(
                      ForgotPasswordRequested(email: _emailController.text.trim()));
                }
              : null,
        );
      case 2:
        return _NewPasswordStep(
          key: const ValueKey('newpass'),
          formKey: _newPassFormKey,
          newPassController: _newPassController,
          confirmPassController: _confirmPassController,
          obscureNew: _obscureNew,
          obscureConfirm: _obscureConfirm,
          onToggleNew: () => setState(() => _obscureNew = !_obscureNew),
          onToggleConfirm: () => setState(() => _obscureConfirm = !_obscureConfirm),
          isLoading: isLoading,
          onSubmit: () {
            if (!_newPassFormKey.currentState!.validate()) return;
            context.read<AuthBloc>().add(NewPasswordSubmitted(
                  password: _newPassController.text,
                  confirmPassword: _confirmPassController.text,
                ));
          },
        );
      default:
        return _EmailStep(
          key: const ValueKey('email'),
          formKey: _emailFormKey,
          emailController: _emailController,
          isLoading: isLoading,
          onSubmit: () {
            if (!_emailFormKey.currentState!.validate()) return;
            context.read<AuthBloc>().add(
                ForgotPasswordRequested(email: _emailController.text.trim()));
          },
        );
    }
  }
}

// ── Step 1: Email ─────────────────────────────────────────────────────────────
class _EmailStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _EmailStep({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        // Illustration
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.primaryDarkNavy,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDarkNavy.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.lock_reset_rounded,
                size: 44, color: AppColors.accentOrange),
          ),
        ),
        const SizedBox(height: 24),
        Text('¿Olvidaste tu contraseña?',
            textAlign: TextAlign.center, style: AppTextStyles.h2(context)),
        const SizedBox(height: 10),
        Text(
          'Ingresa el correo de tu cuenta y te enviaremos un código de verificación.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 32),
        Form(
          key: formKey,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: AppDecorations.inputDecoration(
              'Correo Electrónico',
              'ejemplo@coltrade.com',
              prefix: const Icon(Icons.email_outlined,
                  color: AppColors.textSecondary),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Campo requerido';
              }
              if (!v.contains('@')) return 'Correo inválido';
              return null;
            },
          ),
        ),
        const SizedBox(height: 24),
        CTAButton(
          label: isLoading ? 'Enviando...' : 'Enviar Código',
          onTap: isLoading ? null : onSubmit,
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : null,
        ),
      ],
    );
  }
}

// ── Step 2: OTP Input ─────────────────────────────────────────────────────────
class _OtpStep extends StatelessWidget {
  final String maskedEmail;
  final List<TextEditingController> controllers;
  final List<FocusNode> focuses;
  final int resendSeconds;
  final bool isLoading;
  final VoidCallback onVerify;
  final VoidCallback? onResend;

  const _OtpStep({
    super.key,
    required this.maskedEmail,
    required this.controllers,
    required this.focuses,
    required this.resendSeconds,
    required this.isLoading,
    required this.onVerify,
    this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.primaryDarkNavy,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDarkNavy.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.mark_email_read_outlined,
                size: 44, color: AppColors.accentOrange),
          ),
        ),
        const SizedBox(height: 24),
        Text('Código de Verificación',
            textAlign: TextAlign.center, style: AppTextStyles.h2(context)),
        const SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTextStyles.bodySmall,
            children: [
              const TextSpan(text: 'Enviamos un código de 6 dígitos a '),
              TextSpan(
                text: maskedEmail,
                style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDarkNavy),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (i) {
            return SizedBox(
              width: 44,
              child: TextFormField(
                controller: controllers[i],
                focusNode: focuses[i],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: AppColors.primaryDarkNavy, width: 2),
                  ),
                ),
                onChanged: (v) {
                  if (v.isNotEmpty && i < 5) {
                    focuses[i + 1].requestFocus();
                  }
                  if (v.isEmpty && i > 0) {
                    focuses[i - 1].requestFocus();
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 28),
        CTAButton(
          label: isLoading ? 'Verificando...' : 'Verificar Código',
          onTap: isLoading ? null : onVerify,
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : null,
        ),
        const SizedBox(height: 20),
        Center(
          child: resendSeconds > 0
              ? Text(
                  'Reenviar código en ${resendSeconds}s',
                  style: AppTextStyles.bodySmall,
                )
              : TextButton(
                  onPressed: onResend,
                  child: Text(
                    'Reenviar código',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.accentOrange,
                        fontWeight: FontWeight.w600),
                  ),
                ),
        ),
      ],
    );
  }
}

// ── Step 3: New Password ──────────────────────────────────────────────────────
class _NewPasswordStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController newPassController;
  final TextEditingController confirmPassController;
  final bool obscureNew;
  final bool obscureConfirm;
  final VoidCallback onToggleNew;
  final VoidCallback onToggleConfirm;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _NewPasswordStep({
    super.key,
    required this.formKey,
    required this.newPassController,
    required this.confirmPassController,
    required this.obscureNew,
    required this.obscureConfirm,
    required this.onToggleNew,
    required this.onToggleConfirm,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.successGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.successGreen.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.shield_rounded,
                size: 44, color: Colors.white),
          ),
        ),
        const SizedBox(height: 24),
        Text('Nueva Contraseña',
            textAlign: TextAlign.center, style: AppTextStyles.h2(context)),
        const SizedBox(height: 10),
        Text(
          'Crea una contraseña segura. Será cifrada antes de guardarse.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 32),
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: newPassController,
                obscureText: obscureNew,
                decoration: AppDecorations.inputDecoration(
                  'Nueva Contraseña',
                  '••••••••',
                  prefix: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.textSecondary),
                  suffix: IconButton(
                    icon: Icon(
                      obscureNew
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: onToggleNew,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo requerido';
                  if (v.length < 8) return 'Mínimo 8 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPassController,
                obscureText: obscureConfirm,
                decoration: AppDecorations.inputDecoration(
                  'Confirmar Contraseña',
                  '••••••••',
                  prefix: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.textSecondary),
                  suffix: IconButton(
                    icon: Icon(
                      obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: onToggleConfirm,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo requerido';
                  if (v != newPassController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              const InfoCard(
                title: 'Cifrado SHA-256',
                body:
                    'Tu contraseña será cifrada con SHA-256 antes de almacenarse. Nadie, ni nosotros, podrá ver tu contraseña.',
                icon: Icons.enhanced_encryption_rounded,
                borderColor: AppColors.successGreen,
                bgColor: AppColors.greenLight,
              ),
              const SizedBox(height: 24),
              CTAButton(
                label: isLoading ? 'Guardando...' : '🔒 Guardar Contraseña',
                onTap: isLoading ? null : onSubmit,
                icon: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
