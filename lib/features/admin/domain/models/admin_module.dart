enum AdminModule {
  manageUsers('manage_users'),
  manageBadges('manage_badges'),
  manageRewards('manage_rewards'),
  manageBanners('manage_banners'),
  manageAmbassadors('manage_ambassadors'),
  viewReports('view_reports'),
  manageZones('manage_zones'),
  manageSettings('manage_settings'),
  manageFeeds('manage_feeds');

  final String value;
  const AdminModule(this.value);

  /// Returns null for unknown permission strings — callers must skip them
  /// instead of silently granting a default module.
  static AdminModule? fromString(String value) {
    for (final m in AdminModule.values) {
      if (m.value == value) return m;
    }
    return null;
  }
}
