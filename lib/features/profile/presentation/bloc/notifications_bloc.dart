import 'package:flutter_bloc/flutter_bloc.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

// ─── Seed data ─────────────────────────────────────────────────────────────────
final _initialNotifications = [
  const NotificationItem(
    id: 'n1',
    category: NotiCategory.regulaciones,
    title: 'Nuevo arancel DIAN publicado',
    body: 'Se actualizaron las tarifas arancelarias para partidas 8471.xx del Arancel de Aduanas.',
    timestamp: '09:42',
    dateGroup: 'Hoy',
    isRead: false,
  ),
  const NotificationItem(
    id: 'n2',
    category: NotiCategory.operaciones,
    title: 'Carga CT-48293 en tránsito',
    body: 'Tu exportación de Café Premium a España ha salido del puerto de Cartagena.',
    timestamp: '08:15',
    dateGroup: 'Hoy',
    isRead: false,
  ),
  const NotificationItem(
    id: 'n3',
    category: NotiCategory.sistema,
    title: 'Mantenimiento programado',
    body: 'El sistema estará en mantenimiento el 22 Mar de 02:00 a 04:00 (COT).',
    timestamp: '07:00',
    dateGroup: 'Hoy',
    isRead: false,
  ),
  const NotificationItem(
    id: 'n4',
    category: NotiCategory.operaciones,
    title: 'Revisión DIAN completada',
    body: 'La carga CT-92104 pasó la revisión aduanera. Puedes proceder al retiro.',
    timestamp: '16:30',
    dateGroup: 'Ayer',
    isRead: true,
  ),
  const NotificationItem(
    id: 'n5',
    category: NotiCategory.regulaciones,
    title: 'TLC Colombia – UE actualizado',
    body: 'Nuevas preferencias arancelarias entran en vigor el 1 de abril de 2026.',
    timestamp: '11:10',
    dateGroup: 'Ayer',
    isRead: true,
  ),
  const NotificationItem(
    id: 'n6',
    category: NotiCategory.sistema,
    title: 'Bienvenido a ColTrade Pro',
    body: 'Tu suscripción Plan Pro fue activada exitosamente. ¡Explora todas las funciones!',
    timestamp: '09:00',
    dateGroup: '18 Mar',
    isRead: true,
  ),
];

// ─── BLoC ──────────────────────────────────────────────────────────────────────
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc()
      : super(NotificationsState(all: _initialNotifications)) {
    on<MarkAllReadEvent>(_onMarkAllRead);
    on<ToggleReadEvent>(_onToggleRead);
    on<FilterCategoryEvent>(_onFilterCategory);
  }

  void _onMarkAllRead(
      MarkAllReadEvent event, Emitter<NotificationsState> emit) {
    final updated = state.all.map((n) => n.copyWith(isRead: true)).toList();
    emit(state.copyWith(all: updated));
  }

  void _onToggleRead(ToggleReadEvent event, Emitter<NotificationsState> emit) {
    final updated = state.all.map((n) {
      if (n.id == event.id) return n.copyWith(isRead: !n.isRead);
      return n;
    }).toList();
    emit(state.copyWith(all: updated));
  }

  void _onFilterCategory(
      FilterCategoryEvent event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(activeFilter: event.category));
  }
}
