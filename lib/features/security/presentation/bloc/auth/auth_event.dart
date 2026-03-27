part of 'auth_bloc.dart';

enum OtpFlowType { register, forgotPassword }

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterSubmitted extends AuthEvent {
  final AuthUserEntity user;
  final String password;
  final String confirmPassword;

  const RegisterSubmitted({
    required this.user,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [user, password, confirmPassword];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class OtpVerified extends AuthEvent {
  final String otp;
  final OtpFlowType flowType;

  const OtpVerified({required this.otp, required this.flowType});

  @override
  List<Object> get props => [otp, flowType];
}

class NewPasswordSubmitted extends AuthEvent {
  final String password;
  final String confirmPassword;

  const NewPasswordSubmitted({
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [password, confirmPassword];
}

class AuthReset extends AuthEvent {
  const AuthReset();
}
