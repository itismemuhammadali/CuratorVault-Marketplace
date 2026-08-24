enum FooterFlow { user, seller, admin }

/// Shared models and enums for the global footer.
class FooterItemData {
  final String label;
  final String iconPath;
  final String routePath;

  const FooterItemData({
    required this.label,
    required this.iconPath,
    required this.routePath,
  });
}

class FooterCenterButtonConfig {
  final String iconPath;
  final String? routePath;

  const FooterCenterButtonConfig({required this.iconPath, this.routePath});
}

class FooterFlowConfig {
  final List<FooterItemData> items;
  final FooterCenterButtonConfig? centerButton;

  const FooterFlowConfig({required this.items, this.centerButton});
}
