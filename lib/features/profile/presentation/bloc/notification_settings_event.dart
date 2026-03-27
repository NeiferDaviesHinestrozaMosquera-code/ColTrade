// Notification Settings Events — standalone

abstract class NotificationSettingsEvent {
  const NotificationSettingsEvent();
}

/// Alterna el canal PUSH de un tipo de notificación.
class TogglePushEvent extends NotificationSettingsEvent {
  final String key;
  const TogglePushEvent(this.key);
}

/// Alterna el canal EMAIL de un tipo de notificación.
class ToggleEmailEvent extends NotificationSettingsEvent {
  final String key;
  const ToggleEmailEvent(this.key);
}

/// Guarda la configuración (aquí simula el guardado).
class SaveSettingsEvent extends NotificationSettingsEvent {
  const SaveSettingsEvent();
}
