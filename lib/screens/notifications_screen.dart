import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

// ─── Data Model ───────────────────────────────────────────────────────────────
enum _NotiCategory { sistema, regulaciones, operaciones }

class _Notification {
  final String id;
  final _NotiCategory category;
  final String title;
  final String body;
  final String timestamp;
  final String dateGroup;
  bool isRead;

  _Notification({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.dateGroup,
    this.isRead = false,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_Notification> _notifications = [
    _Notification(
      id: 'n1',
      category: _NotiCategory.regulaciones,
      title: 'Nuevo arancel DIAN publicado',
      body: 'Se actualizaron las tarifas arancelarias para partidas 8471.xx del Arancel de Aduanas.',
      timestamp: '09:42',
      dateGroup: 'Hoy',
      isRead: false,
    ),
    _Notification(
      id: 'n2',
      category: _NotiCategory.operaciones,
      title: 'Carga CT-48293 en tránsito',
      body: 'Tu exportación de Café Premium a España ha salido del puerto de Cartagena.',
      timestamp: '08:15',
      dateGroup: 'Hoy',
      isRead: false,
    ),
    _Notification(
      id: 'n3',
      category: _NotiCategory.sistema,
      title: 'Mantenimiento programado',
      body: 'El sistema estará en mantenimiento el 22 Mar de 02:00 a 04:00 (COT).',
      timestamp: '07:00',
      dateGroup: 'Hoy',
      isRead: false,
    ),
    _Notification(
      id: 'n4',
      category: _NotiCategory.operaciones,
      title: 'Revisión DIAN completada',
      body: 'La carga CT-92104 pasó la revisión aduanera. Puedes proceder al retiro.',
      timestamp: '16:30',
      dateGroup: 'Ayer',
      isRead: true,
    ),
    _Notification(
      id: 'n5',
      category: _NotiCategory.regulaciones,
      title: 'TLC Colombia – UE actualizado',
      body: 'Nuevas preferencias arancelarias entran en vigor el 1 de abril de 2026.',
      timestamp: '11:10',
      dateGroup: 'Ayer',
      isRead: true,
    ),
    _Notification(
      id: 'n6',
      category: _NotiCategory.sistema,
      title: 'Bienvenido a ColTrade Pro',
      body: 'Tu suscripción Plan Pro fue activada exitosamente. ¡Explora todas las funciones!',
      timestamp: '09:00',
      dateGroup: '18 Mar',
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _toggleRead(_Notification n) {
    setState(() => n.isRead = !n.isRead);
  }

  // ─── Category helpers ──────────────────────────────────────────────────────
  (IconData, Color) _categoryMeta(_NotiCategory cat) => switch (cat) {
        _NotiCategory.sistema => (Icons.settings_rounded, AppColors.textSecondary),
        _NotiCategory.regulaciones => (Icons.gavel_rounded, AppColors.infoBlue),
        _NotiCategory.operaciones => (Icons.anchor_rounded, AppColors.successGreen),
      };

  String _categoryLabel(_NotiCategory cat) => switch (cat) {
        _NotiCategory.sistema => 'SISTEMA',
        _NotiCategory.regulaciones => 'REGULACIONES',
        _NotiCategory.operaciones => 'OPERACIONES',
      };

  @override
  Widget build(BuildContext context) {
    // Group by dateGroup preserving order
    final groups = <String, List<_Notification>>{};
    for (final n in _notifications) {
      groups.putIfAbsent(n.dateGroup, () => []).add(n);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ColTradeAppBar(title: 'Notificaciones'),
      body: Column(
        children: [
          // ── Header bar ────────────────────────────────────────────────────
          Container(
            color: AppColors.cardWhite,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _unreadCount > 0
                        ? AppColors.errorRed.withValues(alpha: 0.1)
                        : AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _unreadCount > 0 ? '$_unreadCount sin leer' : 'Todo al día',
                    style: AppTextStyles.caption.copyWith(
                      color: _unreadCount > 0 ? AppColors.errorRed : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (_unreadCount > 0)
                  TextButton(
                    onPressed: _markAllRead,
                    child: Text(
                      'Marcar todas como leídas',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.accentOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── List ──────────────────────────────────────────────────────────
          Expanded(
            child: _notifications.isEmpty
                ? _buildEmpty()
                : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    children: [
                      for (final entry in groups.entries) ...[
                        _buildDateHeader(entry.key),
                        for (final n in entry.value) _buildNotificationTile(n),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(label, style: AppTextStyles.labelUppercase),
    );
  }

  Widget _buildNotificationTile(_Notification n) {
    final (icon, color) = _categoryMeta(n.category);
    return GestureDetector(
      onTap: () => _toggleRead(n),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: AppDecorations.card.copyWith(
          color: n.isRead ? AppColors.cardWhite : AppColors.blueLight,
          border: n.isRead
              ? null
              : Border.all(color: AppColors.infoBlue.withValues(alpha: 0.25)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _categoryLabel(n.category),
                            style: AppTextStyles.badgeText.copyWith(
                              fontSize: 9,
                              color: color,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(n.timestamp, style: AppTextStyles.caption),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      n.title,
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 14,
                        color: n.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(n.body,
                        style: AppTextStyles.caption,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              // Unread dot
              if (!n.isRead) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.infoBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceGray,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_off_outlined,
                size: 36, color: AppColors.textLabel),
          ),
          const SizedBox(height: 16),
          Text('Sin notificaciones',
              style: AppTextStyles.cardTitle.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Text('Estás al día con todas las novedades.',
              style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
