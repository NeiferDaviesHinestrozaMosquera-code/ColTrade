import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/session_entity.dart';

part 'security_event.dart';
part 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc() : super(SecurityState(sessions: _initialSessions)) {
    on<LoadSecurity>(_onLoad);
    on<Toggle2FA>(_onToggle2FA);
    on<CloseSession>(_onCloseSession);
    on<CloseAllSessions>(_onCloseAllSessions);
  }

  static final List<SessionEntity> _initialSessions = [
    const SessionEntity(
      id: 'session_1',
      device: 'iPhone 15 Pro - App ColTrade',
      location: 'Bogotá, Colombia',
      time: 'Hace un momento',
      isCurrent: true,
      iconType: 'phone',
    ),
    const SessionEntity(
      id: 'session_2',
      device: 'Chrome en Windows 11',
      location: 'Medellín, Colombia',
      time: 'Hace 2 días',
      isCurrent: false,
      iconType: 'computer',
    ),
  ];

  void _onLoad(LoadSecurity event, Emitter<SecurityState> emit) {
    emit(SecurityState(sessions: List.from(_initialSessions)));
  }

  void _onToggle2FA(Toggle2FA event, Emitter<SecurityState> emit) {
    emit(state.copyWith(twoFAEnabled: !state.twoFAEnabled));
  }

  void _onCloseSession(CloseSession event, Emitter<SecurityState> emit) {
    final updated = state.sessions.where((s) => s.id != event.deviceId).toList();
    emit(state.copyWith(sessions: updated));
  }

  void _onCloseAllSessions(CloseAllSessions event, Emitter<SecurityState> emit) {
    final current = state.sessions.where((s) => s.isCurrent).toList();
    emit(state.copyWith(sessions: current));
  }
}
