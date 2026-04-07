import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_state.dart';
import '../bloc/notifications_event.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsBloc(),
      child: const _NotificationsView(),
    );
  }
}

// ─── View ─────────────────────────────────────────────────────────────────────
class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildHeaderBar(context),
          Expanded(child: _buildList(context)),
        ],
      ),
    );
  }

  // ─── Custom AppBar: tricolor + Azure blue AppBar + filter chips ──────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 3 + 48),
      child: Container(
        color: AppColors.colombiaBlue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Colombia tricolor bar
            const ColombiaTricolorBar(),
            SizedBox(height: MediaQuery.of(context).padding.top),
            // Custom Toolbar Row
            SizedBox(
              height: kToolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    if (context.canPop())
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: AppColors.accentOrange, size: 18),
                        onPressed: () => context.pop(),
                      )
                    else
                      const SizedBox(width: 48),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notificaciones & Alertas',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Gestiona tus preferencias de comunicación',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<NotificationsBloc, NotificationsState>(
                      builder: (context, state) {
                        if (state.unreadCount == 0) return const SizedBox.shrink();
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.errorRed,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${state.unreadCount}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Filter chips area
            SizedBox(
              height: 48,
              child: _buildFilterChips(context),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Category filter chips ──────────────────────────────────────────────────
  Widget _buildFilterChips(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        const filters = <(String?, String)>[
          (null, 'Todas'),
          ('regulaciones', 'Regulaciones'),
          ('operaciones', 'Operaciones'),
          ('sistema', 'Sistema'),
        ];
        return Container(
          color: AppColors.colombiaBlue,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((f) {
                final (value, label) = f;
                final isActive = state.activeFilter == value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => context
                        .read<NotificationsBloc>()
                        .add(FilterCategoryEvent(value)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? AppColors.colombiaBlue
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // ─── Sticky header: unread count + mark-all ─────────────────────────────────
  Widget _buildHeaderBar(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        return Container(
          color: AppColors.cardWhite,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: state.unreadCount > 0
                      ? AppColors.errorRed.withValues(alpha: 0.1)
                      : AppColors.surfaceGray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      state.unreadCount > 0
                          ? Icons.circle
                          : Icons.check_circle_outline,
                      size: 8,
                      color: state.unreadCount > 0
                          ? AppColors.errorRed
                          : AppColors.successGreen,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      state.unreadCount > 0
                          ? '${state.unreadCount} sin leer'
                          : 'Todo al día',
                      style: AppTextStyles.caption.copyWith(
                        color: state.unreadCount > 0
                            ? AppColors.errorRed
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (state.unreadCount > 0)
                TextButton.icon(
                  onPressed: () => context
                      .read<NotificationsBloc>()
                      .add(const MarkAllReadEvent()),
                  icon: const Icon(Icons.done_all_rounded,
                      size: 15, color: AppColors.colombiaBlue),
                  label: Text(
                    'Marcar todas leídas',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.colombiaBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ─── Notifications list ─────────────────────────────────────────────────────
  Widget _buildList(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        final items = state.visible;
        if (items.isEmpty) return _buildEmpty();

        final groups = <String, List<NotificationItem>>{};
        for (final n in items) {
          groups.putIfAbsent(n.dateGroup, () => []).add(n);
        }

        final flattenedWidgets = <Widget>[];
        for (final entry in groups.entries) {
          flattenedWidgets.add(_buildDateHeader(entry.key));
          for (final n in entry.value) {
            flattenedWidgets.add(_NotificationTile(notification: n));
          }
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 24, top: 8),
          itemCount: flattenedWidgets.length,
          itemBuilder: (context, index) => flattenedWidgets[index],
        );
      },
    );
  }

  Widget _buildDateHeader(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(label, style: AppTextStyles.labelUppercase),
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
            decoration: const BoxDecoration(
              color: AppColors.surfaceGray,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_off_outlined,
                size: 36, color: AppColors.textLabel),
          ),
          const SizedBox(height: 16),
          Text('Sin notificaciones',
              style: AppTextStyles.cardTitle
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Text('Estás al día con todas las novedades.',
              style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

// ─── Individual Notification Tile ─────────────────────────────────────────────
class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  const _NotificationTile({required this.notification});

  (IconData, Color) get _meta => switch (notification.category) {
        NotiCategory.sistema => (
            Icons.settings_rounded,
            AppColors.textSecondary
          ),
        NotiCategory.regulaciones => (
            Icons.gavel_rounded,
            AppColors.colombiaBlue
          ),
        NotiCategory.operaciones => (
            Icons.anchor_rounded,
            AppColors.successGreen
          ),
      };

  String get _label => switch (notification.category) {
        NotiCategory.sistema => 'SISTEMA',
        NotiCategory.regulaciones => 'REGULACIONES',
        NotiCategory.operaciones => 'OPERACIONES',
      };

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _meta;
    final n = notification;

    return GestureDetector(
      onTap: () =>
          context.read<NotificationsBloc>().add(ToggleReadEvent(n.id)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: n.isRead ? AppColors.cardWhite : AppColors.blueLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: n.isRead
                ? AppColors.border
                : AppColors.colombiaBlue.withValues(alpha: 0.25),
            width: n.isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: n.isRead ? 0.04 : 0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category icon
              Container(
                width: 44,
                height: 44,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _label,
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
                        color: n.isRead
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      n.body,
                      style: AppTextStyles.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Unread dot
              if (!n.isRead) ...[
                const SizedBox(width: 8),
                Container(
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.colombiaBlue,
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
}
