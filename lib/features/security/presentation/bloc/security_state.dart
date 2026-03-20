part of 'security_bloc.dart';

class SecurityState extends Equatable {
  final bool twoFAEnabled;
  final List<SessionEntity> sessions;

  const SecurityState({
    this.twoFAEnabled = true,
    this.sessions = const [],
  });

  SecurityState copyWith({
    bool? twoFAEnabled,
    List<SessionEntity>? sessions,
  }) {
    return SecurityState(
      twoFAEnabled: twoFAEnabled ?? this.twoFAEnabled,
      sessions: sessions ?? this.sessions,
    );
  }

  @override
  List<Object> get props => [twoFAEnabled, sessions];
}
