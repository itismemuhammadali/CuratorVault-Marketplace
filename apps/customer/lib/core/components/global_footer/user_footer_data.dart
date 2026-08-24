import 'package:vintage_app/core/components/global_footer/footer_models.dart';

const FooterFlowConfig userFooterConfig = FooterFlowConfig(
  items: [
    FooterItemData(
      label: 'Home',
      iconPath: 'assets/icons/admin_nav_home.svg',
      routePath: '/homeScreen',
    ),
    FooterItemData(
      label: 'My Finds',
      iconPath: 'assets/icons/finds_icon.svg',
      routePath: '/user/my-finds',
    ),
    FooterItemData(
      label: 'Market',
      iconPath: 'assets/icons/admin_nav_market.svg',
      routePath: '/user/market',
    ),
    FooterItemData(
      label: 'Profile',
      iconPath: 'assets/icons/profile_icon.svg',
      routePath: '/user/profile',
    ),
  ],
  centerButton: FooterCenterButtonConfig(
    iconPath: 'assets/icons/scan_icon.svg',
    routePath: '/user/scan',
  ),
);

