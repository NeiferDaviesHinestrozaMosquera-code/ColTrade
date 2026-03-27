part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  const AuthSuccess();
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class OtpSent extends AuthState {
  final String maskedEmail;
  final OtpFlowType flowType;

  const OtpSent({required this.maskedEmail, required this.flowType});

  @override
  List<Object> get props => [maskedEmail, flowType];
}

class PasswordResetReady extends AuthState {
  const PasswordResetReady();
}

class PasswordResetSuccess extends AuthState {
  const PasswordResetSuccess();
}
