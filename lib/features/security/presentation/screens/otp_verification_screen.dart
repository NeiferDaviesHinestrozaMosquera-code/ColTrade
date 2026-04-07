import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../injection/injection.dart';
import '../../../../core/utils/auth_notifier.dart';
import '../bloc/auth/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String maskedEmail;
  final OtpFlowType flowType;

  const OtpVerificationScreen({
    super.key,
    required this.maskedEmail,
    required this.flowType,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendSeconds = 60;
  Timer? _timer;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 0.9, end: 1.0).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startTimer() {
    _resendSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_resendSeconds <= 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _verifyOtp(BuildContext context) {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingresa los 6 dígitos del código',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }
    context
        .read<AuthBloc>()
        .add(OtpVerified(otp: otp, flowType: widget.flowType));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message,
                  style:
                      GoogleFonts.inter(fontSize: 14, color: Colors.white)),
              backgroundColor: AppColors.errorRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ),
          );
          // Clear OTP fields on failure
          for (final c in _controllers) c.clear();
          _focusNodes[0].requestFocus();
        }
        if (state is AuthSuccess) {
          sl<AuthNotifier>().login();
          context.go('/home');
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: ColTradeAppBar(
            title: 'Verificación 2FA',
            dark: true,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded,
                  color: AppColors.accentOrange, size: 22),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  // ── Animated Shield ───────────────────────────────────
                  Center(
                    child: ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: AppColors.primaryDarkNavy,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentOrange.withValues(alpha: 0.3),
                              blurRadius: 24,
                              spreadRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.verified_user_rounded,
                            size: 52, color: AppColors.accentOrange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Verificación en 2 Pasos',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h2(context),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.bodySmall,
                      children: [
                        const TextSpan(
                            text: 'Ingresa el código de 6 dígitos enviado a '),
                        TextSpan(
                          text: widget.maskedEmail,
                          style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDarkNavy),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── OTP Fields ────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (i) {
                      return SizedBox(
                        width: 48,
                        child: TextFormField(
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDarkNavy,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                            filled: true,
                            fillColor: AppColors.cardWhite,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.accentOrange, width: 2),
                            ),
                          ),
                          onChanged: (v) {
                            if (v.isNotEmpty && i < 5) {
                              _focusNodes[i + 1].requestFocus();
                            }
                            if (v.isEmpty && i > 0) {
                              _focusNodes[i - 1].requestFocus();
                            }
                            // Auto-verify when all digits entered
                            if (i == 5 && v.isNotEmpty) {
                              _verifyOtp(context);
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // ── Verify Button ─────────────────────────────────────
                  CTAButton(
                    label: isLoading ? 'Verificando...' : 'Verificar Código',
                    onTap: isLoading ? null : () => _verifyOtp(context),
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

                  // ── Resend ────────────────────────────────────────────
                  Center(
                    child: _resendSeconds > 0
                        ? Text(
                            'Reenviar código en ${_resendSeconds}s',
                            style: AppTextStyles.bodySmall,
                          )
                        : TextButton(
                            onPressed: () {
                              _startTimer();
                              context.read<AuthBloc>().add(const AuthReset());
                            },
                            child: Text(
                              'Reenviar código',
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.accentOrange,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                  ),
                  const SizedBox(height: 28),

                  // ── Security Info ─────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDarkNavy,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                color: AppColors.accentOrange, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              '¿QUÉ ES LA VERIFICACIÓN 2FA?',
                              style: AppTextStyles.labelUppercase.copyWith(
                                  color: Colors.white70),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'La autenticación en 2 pasos añade una capa extra de seguridad a tu cuenta. Incluso si alguien conoce tu contraseña, no podrá acceder sin el código enviado a tu correo.',
                          style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
