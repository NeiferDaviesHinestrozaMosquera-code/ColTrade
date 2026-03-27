import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_settings_event.dart';
import 'notification_settings_state.dart';

// ─── Seed data ─────────────────────────────────────────────────────────────────
final _initialSections = [
  // ── Temas Regulatorios ─────────────────────────────────────────────────────
  const NotifSection(
    title: 'Temas Regulatorios (DIAN / INVIMA)',
    iconAsset: 'gavel',
    items: [
      NotifSetting(
        key: 'reg_aranceles',
        title: 'Vencimientos de Aranceles',
        description: 'Alertas sobre plazos de pago ante la DIAN',
        pushEnabled: true,
        emailEnabled: false,
      ),
      NotifSetting(
        key: 'reg_invima',
        title: 'Actualización de Normativa INVIMA',
        description: 'Nuevos requisitos sanitarios para importación',
        pushEnabled: false,
        emailEnabled: true,
      ),
    ],
  ),
  // ── Estado de Trámites Logísticos ──────────────────────────────────────────
  const NotifSection(
    title: 'Estado de Trámites Logísticos',
    iconAsset: 'anchor',
    items: [
      NotifSetting(
        key: 'log_track',
        title: 'Cambios en el Track & Trace',
        description: 'Notificar cada vez que una carga cambie de zona',
        pushEnabled: true,
        emailEnabled: false,
      ),
      NotifSetting(
        key: 'log_docs',
        title: 'Documentación Aprobada',
        description: 'Confirmación de levante manual y automático',
        pushEnabled: true,
        emailEnabled: true,
      ),
    ],
  ),
  // ── Seguridad de Cuenta ────────────────────────────────────────────────────
  const NotifSection(
    title: 'Seguridad de Cuenta',
    iconAsset: 'shield',
    items: [
      NotifSetting(
        key: 'sec_login',
        title: 'Inicios de Sesión Sospechosos 🔒',
        description: 'Obligatorio por estándares internacionales ISO 27001',
        pushEnabled: true,
        lockedLabel: 'FIJO',
      ),
      NotifSetting(
        key: 'sec_audit',
        title: 'Reportes de Auditoría Mensual',
        description: 'Resumen de accesos y modificaciones a la carga',
        pushEnabled: false,
        emailEnabled: true,
      ),
    ],
  ),
];

// ─── BLoC ──────────────────────────────────────────────────────────────────────
class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  NotificationSettingsBloc()
      : super(NotificationSettingsState(sections: _initialSections)) {
    on<TogglePushEvent>(_onTogglePush);
    on<ToggleEmailEvent>(_onToggleEmail);
    on<SaveSettingsEvent>(_onSave);
  }

  void _onTogglePush(
      TogglePushEvent event, Emitter<NotificationSettingsState> emit) {
    final updated = _updateItem(
      event.key,
      (item) => item.copyWith(pushEnabled: !item.pushEnabled),
    );
    emit(state.copyWith(sections: updated, saved: false));
  }

  void _onToggleEmail(
      ToggleEmailEvent event, Emitter<NotificationSettingsState> emit) {
    final updated = _updateItem(
      event.key,
      (item) => item.copyWith(emailEnabled: !item.emailEnabled),
    );
    emit(state.copyWith(sections: updated, saved: false));
  }

  void _onSave(
      SaveSettingsEvent event, Emitter<NotificationSettingsState> emit) {
    emit(state.copyWith(saved: true));
  }

  List<NotifSection> _updateItem(
    String key,
    NotifSetting Function(NotifSetting) transform,
  ) {
    return state.sections.map((section) {
      final newItems = section.items.map((item) {
        if (item.key == key && !item.isLocked) return transform(item);
        return item;
      }).toList();
      return section.copyWith(items: newItems);
    }).toList();
  }
}
