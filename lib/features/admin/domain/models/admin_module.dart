enum AdminModule {
  manageUsers('manage_users'),
  manageBadges('manage_badges'),
  manageRewards('manage_rewards'),
  manageBanners('manage_banners'),
  manageAmbassadors('manage_ambassadors'),
  viewReports('view_reports'),
  manageZones('manage_zones'),
  manageSettings('manage_settings');

  final String value;
  const AdminModule(this.value);

  static AdminModule fromString(String value) {
    return AdminModule.values.firstWhere(
      (m) => m.value == value,
      orElse: () => AdminModule.manageUsers,
    );
  }
}
