import 'package:vintage_app/core/components/global_footer/footer_models.dart';

const FooterFlowConfig adminFooterConfig = FooterFlowConfig(
  items: [
    FooterItemData(
      label: 'Home',
      iconPath: 'assets/icons/admin_nav_home.svg',
      routePath: '/admin/home',
    ),
    FooterItemData(
      label: 'Users',
      iconPath: 'assets/icons/admin_nav_users.svg',
      routePath: '/admin/users',
    ),
    FooterItemData(
      label: 'Events',
      iconPath: 'assets/icons/admin_nav_events.svg',
      routePath: '/admin/events',
    ),
    FooterItemData(
      label: 'Market',
      iconPath: 'assets/icons/admin_nav_market.svg',
      routePath: '/admin/market',
    ),
    FooterItemData(
      label: 'Settings',
      iconPath: 'assets/icons/admin_nav_settings.svg',
      routePath: '/admin/settings',
    ),
  ],
  centerButton: null,
);

