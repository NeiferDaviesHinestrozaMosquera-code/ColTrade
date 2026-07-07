part of 'security_bloc.dart';

class SecurityState extends Equatable {
  final bool twoFAEnabled;
  final bool biometricsEnabled;
  final List<SessionEntity> sessions;

  const SecurityState({
    this.twoFAEnabled = true,
    this.biometricsEnabled = false,
    this.sessions = const [],
  });

  SecurityState copyWith({
    bool? twoFAEnabled,
    bool? biometricsEnabled,
    List<SessionEntity>? sessions,
  }) {
    return SecurityState(
      twoFAEnabled: twoFAEnabled ?? this.twoFAEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      sessions: sessions ?? this.sessions,
    );
  }

  @override
  List<Object> get props => [twoFAEnabled, biometricsEnabled, sessions];
}
