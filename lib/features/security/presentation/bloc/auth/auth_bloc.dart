import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth_entity.dart';
import '../../../../../core/utils/password_hasher.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<LoginSubmitted>(_onLogin);
    on<RegisterSubmitted>(_onRegister);
    on<ForgotPasswordRequested>(_onForgotPassword);
    on<OtpVerified>(_onOtpVerified);
    on<NewPasswordSubmitted>(_onNewPassword);
    on<AuthReset>(_onReset);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  String? _validatePasswordStrength(String password) {
    if (password.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'La contraseña debe incluir al menos una letra mayúscula.';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'La contraseña debe incluir al menos una letra minúscula.';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'La contraseña debe incluir al menos un número.';
    }
    if (!RegExp(r'[!@#\$&*~_.-]').hasMatch(password)) {
      return 'La contraseña debe incluir al menos un carácter especial (ej. !@#\$&*~_.-).';
    }
    return null;
  }

  Future<void> _onLogin(
      LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!_isValidEmail(event.email)) {
      emit(const AuthFailure('Correo electrónico inválido. Verifica el formato.'));
      return;
    }
    if (event.password.length < 6) {
      emit(const AuthFailure('La contraseña debe tener al menos 6 caracteres.'));
      return;
    }
    
    emit(const AuthSuccess());
  }

  Future<void> _onRegister(
      RegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 600));

    if (!_isValidEmail(event.user.email)) {
      emit(const AuthFailure('Correo electrónico inválido. Verifica el formato.'));
      return;
    }

    final passwordError = _validatePasswordStrength(event.password);
    if (passwordError != null) {
      emit(AuthFailure(passwordError));
      return;
    }

    if (event.password != event.confirmPassword) {
      emit(const AuthFailure('Las contraseñas no coinciden.'));
      return;
    }

    // Simulate storing user with salted hashed password
    PasswordHasher.hash(event.password);
    final maskedEmail = _maskEmail(event.user.email);
    emit(OtpSent(maskedEmail: maskedEmail, flowType: OtpFlowType.register));
  }

  Future<void> _onForgotPassword(
      ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 400));
    if (!_isValidEmail(event.email)) {
      emit(const AuthFailure('Correo electrónico inválido. Verifica el formato.'));
      return;
    }
    final maskedEmail = _maskEmail(event.email);
    emit(OtpSent(maskedEmail: maskedEmail, flowType: OtpFlowType.forgotPassword));
  }

  Future<void> _onOtpVerified(
      OtpVerified event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 400));
    // Simulate: OTP "123456" or any 6-digit code works in demo
    if (event.otp == '123456' || event.otp.length == 6) {
      if (event.flowType == OtpFlowType.forgotPassword) {
        emit(const PasswordResetReady());
      } else {
        emit(const AuthSuccess());
      }
    } else {
      emit(const AuthFailure('Código incorrecto. Inténtalo de nuevo.'));
    }
  }

  Future<void> _onNewPassword(
      NewPasswordSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));

    final passwordError = _validatePasswordStrength(event.password);
    if (passwordError != null) {
      emit(AuthFailure(passwordError));
      return;
    }

    if (event.password != event.confirmPassword) {
      emit(const AuthFailure('Las contraseñas no coinciden.'));
      return;
    }
    // Simulate: salted hash would be sent to backend
    PasswordHasher.hash(event.password);
    emit(const PasswordResetSuccess());
  }

  void _onReset(AuthReset event, Emitter<AuthState> emit) {
    emit(const AuthInitial());
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '${name[0]}***@$domain';
    return '${name[0]}${name[1]}***@$domain';
  }
}
