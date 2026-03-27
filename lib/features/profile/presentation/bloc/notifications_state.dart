// Notifications State & Domain Model — standalone (no part-of)

// ─── Domain model ──────────────────────────────────────────────────────────────
enum NotiCategory { sistema, regulaciones, operaciones }

class NotificationItem {
  final String id;
  final NotiCategory category;
  final String title;
  final String body;
  final String timestamp;
  final String dateGroup;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.dateGroup,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
        id: id,
        category: category,
        title: title,
        body: body,
        timestamp: timestamp,
        dateGroup: dateGroup,
        isRead: isRead ?? this.isRead,
      );
}

// ─── Sentinel para distinguir null intencional de "no cambiar" ─────────────────
const Object _sentinel = Object();

// ─── State ────────────────────────────────────────────────────────────────────
class NotificationsState {
  final List<NotificationItem> all;
  final String? activeFilter;

  const NotificationsState({required this.all, this.activeFilter});

  List<NotificationItem> get visible {
    if (activeFilter == null) return all;
    final cat = _categoryFromString(activeFilter!);
    if (cat == null) return all;
    return all.where((n) => n.category == cat).toList();
  }

  int get unreadCount => all.where((n) => !n.isRead).length;

  NotiCategory? _categoryFromString(String s) => switch (s) {
        'sistema' => NotiCategory.sistema,
        'regulaciones' => NotiCategory.regulaciones,
        'operaciones' => NotiCategory.operaciones,
        _ => null,
      };

  NotificationsState copyWith({
    List<NotificationItem>? all,
    Object? activeFilter = _sentinel,
  }) =>
      NotificationsState(
        all: all ?? this.all,
        activeFilter: identical(activeFilter, _sentinel)
            ? this.activeFilter
            : activeFilter as String?,
      );
}
