// Notification Settings State & Domain Model — standalone

// ─── Alert type model ─────────────────────────────────────────────────────────
class NotifSetting {
  final String key;
  final String title;
  final String description;
  final bool pushEnabled;
  final bool emailEnabled;
  /// null = user-toggleable; 'FIJO' = always-on and locked
  final String? lockedLabel;

  const NotifSetting({
    required this.key,
    required this.title,
    required this.description,
    this.pushEnabled = false,
    this.emailEnabled = false,
    this.lockedLabel,
  });

  bool get isLocked => lockedLabel != null;

  NotifSetting copyWith({bool? pushEnabled, bool? emailEnabled}) => NotifSetting(
        key: key,
        title: title,
        description: description,
        pushEnabled: pushEnabled ?? this.pushEnabled,
        emailEnabled: emailEnabled ?? this.emailEnabled,
        lockedLabel: lockedLabel,
      );
}

// ─── Section model ────────────────────────────────────────────────────────────
class NotifSection {
  final String title;
  final String iconAsset; // uses IconData name string, resolved in UI
  final List<NotifSetting> items;

  const NotifSection({
    required this.title,
    required this.iconAsset,
    required this.items,
  });

  NotifSection copyWith({List<NotifSetting>? items}) =>
      NotifSection(title: title, iconAsset: iconAsset, items: items ?? this.items);
}

// ─── State ────────────────────────────────────────────────────────────────────
class NotificationSettingsState {
  final List<NotifSection> sections;
  final bool saved;

  const NotificationSettingsState({
    required this.sections,
    this.saved = false,
  });

  NotificationSettingsState copyWith({
    List<NotifSection>? sections,
    bool? saved,
  }) =>
      NotificationSettingsState(
        sections: sections ?? this.sections,
        saved: saved ?? this.saved,
      );
}
