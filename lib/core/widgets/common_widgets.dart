import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:go_router/go_router.dart';

// ─── Colombia Tricolor Bar ────────────────────────────────────────────────────
class ColombiaTricolorBar extends StatelessWidget {
  final double height;
  const ColombiaTricolorBar({super.key, this.height = 3});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: height, color: AppColors.colombiaYellow)),
        Expanded(child: Container(height: height, color: AppColors.colombiaBlue)),
        Expanded(child: Container(height: height, color: AppColors.colombiaRed)),
      ],
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────
enum BadgeStatus {
  alta,
  media,
  baja,
  informativo,
  completado,
  enProceso,
  operativo,
  exportacion,
  importacion,
  tlcUpdate,
}

class StatusBadge extends StatelessWidget {
  final BadgeStatus status;
  final String? customLabel;

  const StatusBadge({super.key, required this.status, this.customLabel});

  (Color bg, Color text, String label) get _config => switch (status) {
        BadgeStatus.alta => (AppColors.errorRed, Colors.white, 'ALTA PRIORIDAD'),
        BadgeStatus.media => (AppColors.yellowAmber, Colors.white, 'PRIORIDAD MEDIA'),
        BadgeStatus.baja => (AppColors.textSecondary, Colors.white, 'BAJA PRIORIDAD'),
        BadgeStatus.informativo => (AppColors.infoBlue, Colors.white, 'INFORMATIVO'),
        BadgeStatus.completado => (AppColors.successGreen, Colors.white, 'COMPLETADO'),
        BadgeStatus.enProceso => (AppColors.accentOrange, Colors.white, 'EN PROCESO'),
        BadgeStatus.operativo => (AppColors.successGreen, Colors.white, 'OPERATIVO'),
        BadgeStatus.exportacion => (AppColors.successGreen, Colors.white, 'EXPORTACIÓN'),
        BadgeStatus.importacion => (AppColors.infoBlue, Colors.white, 'IMPORTACIÓN'),
        BadgeStatus.tlcUpdate => (AppColors.successGreen, Colors.white, 'ACTUALIZACIÓN TLC'),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, text, label) = _config;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        customLabel ?? label,
        style: AppTextStyles.badgeText.copyWith(color: text, fontSize: 10),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.accentOrange,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── ColTrade App Bar ─────────────────────────────────────────────────────────
class ColTradeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogo;
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool dark;
  final PreferredSizeWidget? bottom;

  const ColTradeAppBar({
    super.key,
    this.showLogo = false,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.dark = true,
    this.bottom,
  });

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(kToolbarHeight + 3 + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ColombiaTricolorBar(),
          Expanded(
            child: AppBar(
              backgroundColor: dark ? AppColors.primaryDarkNavy : AppColors.cardWhite,
              foregroundColor: dark ? Colors.white : AppColors.textPrimary,
              elevation: 0,
              centerTitle: !showLogo,
              leading: leading ??
                  (context.canPop()
                      ? IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_rounded,
                              size: 18, color: dark ? AppColors.accentOrange : AppColors.textPrimary),
                          onPressed: () => context.pop(),
                        )
                      : null),
              title: showLogo
                  ? _buildLogo(dark)
                  : (titleWidget ??
                      Text(
                        title ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: dark ? Colors.white : AppColors.textPrimary,
                        ),
                      )),
              actions: actions,
              bottom: bottom,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(bool dark) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.accentOrange,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.business_rounded, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Text(
          'ColTrade',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: dark ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ─── Progress Step Indicator ──────────────────────────────────────────────────
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String label;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            Text(
              'Paso $currentStep de $totalSteps',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: currentStep / totalSteps,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryDarkNavy),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}

// ─── Timeline Step ────────────────────────────────────────────────────────────
enum TimelineStatus { completed, active, pending }

class TimelineStep extends StatelessWidget {
  final TimelineStatus status;
  final String title;
  final String? subtitle;
  final String? timestamp;
  final bool isLast;

  const TimelineStep({
    super.key,
    required this.status,
    required this.title,
    this.subtitle,
    this.timestamp,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Node + connector
          Column(
            children: [
              _buildNode(),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: status == TimelineStatus.completed
                        ? AppColors.successGreen.withValues(alpha: 0.4)
                        : AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: status == TimelineStatus.active
                  ? _buildActiveCard()
                  : _buildNormalContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNode() {
    switch (status) {
      case TimelineStatus.completed:
        return Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppColors.successGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 12),
        );
      case TimelineStatus.active:
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.accentOrange,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accentOrange.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.sync_rounded, color: Colors.white, size: 12),
        );
      case TimelineStatus.pending:
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border, width: 2),
          ),
        );
    }
  }

  Widget _buildActiveCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryDarkNavy,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusBadge(status: BadgeStatus.enProceso),
          const SizedBox(height: 6),
          Text(title, style: AppTextStyles.cardTitle.copyWith(color: Colors.white)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
          ],
        ],
      ),
    );
  }

  Widget _buildNormalContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.cardTitle.copyWith(
            color: status == TimelineStatus.completed
                ? AppColors.textPrimary
                : AppColors.textSecondary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: AppTextStyles.caption),
        ],
        if (timestamp != null) ...[
          const SizedBox(height: 4),
          Text(timestamp!, style: AppTextStyles.caption),
        ],
      ],
    );
  }
}

// ─── KPI Card ─────────────────────────────────────────────────────────────────
class KPICard extends StatelessWidget {
  final String label;
  final String value;
  final String? change;
  final bool positive;
  final bool dark;

  const KPICard({
    super.key,
    required this.label,
    required this.value,
    this.change,
    this.positive = true,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? Colors.white : AppColors.textPrimary;
    final subtextColor = dark ? Colors.white60 : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? AppColors.primaryDarkNavy : AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: dark
            ? null
            : Border(
                left: BorderSide(
                  color: positive ? AppColors.successGreen : AppColors.errorRed,
                  width: 3,
                ),
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.labelUppercase.copyWith(color: subtextColor)),
          const SizedBox(height: 8),
          Text(value,
              style: AppTextStyles.priceTotal.copyWith(
                  color: textColor, fontSize: 20)),
          if (change != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  positive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  size: 12,
                  color: positive ? AppColors.successGreen : AppColors.errorRed,
                ),
                const SizedBox(width: 2),
                Text(
                  change!,
                  style: AppTextStyles.caption.copyWith(
                    color: positive ? AppColors.successGreen : AppColors.errorRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Document Item ────────────────────────────────────────────────────────────
class DocumentItem extends StatelessWidget {
  final String name;
  final String meta;
  final bool isUrgent;
  final bool isCompleted;
  final VoidCallback? onDownload;

  const DocumentItem({
    super.key,
    required this.name,
    required this.meta,
    this.isUrgent = false,
    this.isCompleted = false,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: isUrgent
                ? AppColors.errorRed
                : isCompleted
                    ? AppColors.successGreen
                    : AppColors.border,
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isUrgent
                    ? AppColors.errorRed.withValues(alpha: 0.1)
                    : AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isUrgent
                    ? Icons.warning_amber_rounded
                    : isCompleted
                        ? Icons.check_circle_outline_rounded
                        : Icons.description_outlined,
                color: isUrgent
                    ? AppColors.errorRed
                    : isCompleted
                        ? AppColors.successGreen
                        : AppColors.textSecondary,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: AppTextStyles.bodyRegular.copyWith(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    meta,
                    style: AppTextStyles.caption.copyWith(
                      color: isUrgent ? AppColors.errorRed : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onDownload != null)
              IconButton(
                onPressed: onDownload,
                icon: const Icon(Icons.download_rounded,
                    color: AppColors.textSecondary, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Primary CTA Button ───────────────────────────────────────────────────────
class CTAButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool fullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final bool outlined;
  final Widget? icon;

  const CTAButton({
    super.key,
    required this.label,
    this.onTap,
    this.fullWidth = true,
    this.backgroundColor,
    this.textColor,
    this.outlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primaryDarkNavy;
    final fg = textColor ?? Colors.white;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 52,
      child: outlined
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: bg,
                side: BorderSide(color: bg, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _label(bg),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: bg,
                foregroundColor: fg,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _label(fg),
            ),
    );
  }

  Widget _label(Color color) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Text(
            label,
            style: AppTextStyles.buttonCTA.copyWith(color: color),
          ),
        ],
      );
}

// ─── Quick Access Grid Item ───────────────────────────────────────────────────
class QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback? onTap;

  const QuickAccessItem({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppDecorations.card,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor ?? AppColors.accentOrange, size: 28),
            const SizedBox(height: 8),
            Text(
              label.toUpperCase(),
              style: AppTextStyles.labelUppercase,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Notification Bell ────────────────────────────────────────────────────────
class NotificationBell extends StatelessWidget {
  final bool hasNotification;
  final Color color;

  const NotificationBell({
    super.key,
    this.hasNotification = false,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(Icons.notifications_outlined, color: color, size: 24),
        if (hasNotification)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.errorRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Info Card ────────────────────────────────────────────────────────────────
class InfoCard extends StatelessWidget {
  final String title;
  final String body;
  final Color borderColor;
  final Color bgColor;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.body,
    this.borderColor = AppColors.infoBlue,
    this.bgColor = AppColors.blueLight,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: borderColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTextStyles.labelUppercase
                      .copyWith(color: borderColor, letterSpacing: 0.8),
                ),
                const SizedBox(height: 4),
                Text(body, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
