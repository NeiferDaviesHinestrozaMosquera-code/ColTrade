import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/session_entity.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../injection/injection.dart';

part 'security_event.dart';
part 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc() : super(const SecurityState()) {
    on<LoadSecurity>(_onLoad);
    on<Toggle2FA>(_onToggle2FA);
    on<ToggleBiometrics>(_onToggleBiometrics);
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
    emit(state.copyWith(sessions: List.from(_initialSessions)));
  }

  void _onToggle2FA(Toggle2FA event, Emitter<SecurityState> emit) {
    emit(state.copyWith(twoFAEnabled: !state.twoFAEnabled));
  }

  Future<void> _onToggleBiometrics(ToggleBiometrics event, Emitter<SecurityState> emit) async {
    final isAvailable = await sl<BiometricService>().isBiometricAvailable();
    if (isAvailable) {
      emit(state.copyWith(biometricsEnabled: !state.biometricsEnabled));
    } else {
      // Emit state as-is or trigger side effects. In real apps, we would also emit an error
      // message, but since local_auth is checked, keeping it disabled if not available is safe.
    }
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
