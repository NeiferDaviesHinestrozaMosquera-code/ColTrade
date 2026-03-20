part of 'security_bloc.dart';

abstract class SecurityEvent extends Equatable {
  const SecurityEvent();

  @override
  List<Object> get props => [];
}

class LoadSecurity extends SecurityEvent {
  const LoadSecurity();
}

class Toggle2FA extends SecurityEvent {
  const Toggle2FA();
}

class CloseSession extends SecurityEvent {
  final String deviceId;
  const CloseSession(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class CloseAllSessions extends SecurityEvent {
  const CloseAllSessions();
}
