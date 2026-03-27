// Notifications Events — standalone (no part-of)

abstract class NotificationsEvent {
  const NotificationsEvent();
}

/// Marca todas las notificaciones como leídas.
class MarkAllReadEvent extends NotificationsEvent {
  const MarkAllReadEvent();
}

/// Alterna el estado leído/no leído de una notificación concreta.
class ToggleReadEvent extends NotificationsEvent {
  final String id;
  const ToggleReadEvent(this.id);
}

/// Filtra la lista por categoría. null = todas.
class FilterCategoryEvent extends NotificationsEvent {
  final String? category;
  const FilterCategoryEvent(this.category);
}
