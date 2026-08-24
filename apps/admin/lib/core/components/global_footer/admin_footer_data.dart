import 'package:vintage_app/core/components/global_footer/footer_models.dart';
import 'package:vintage_app/core/theme/images.dart';

const FooterFlowConfig adminFooterConfig = FooterFlowConfig(
  items: [
    FooterItemData(
      label: 'Home',
      iconPath: AppImages.adminNavHome,
      routePath: '/homeScreen',
    ),
    FooterItemData(
      label: 'Users',
      iconPath: AppImages.adminNavUsers,
      routePath: '/admin/users',
    ),
    FooterItemData(
      label: 'Events',
      iconPath: AppImages.adminNavEvents,
      routePath: '/events',
    ),
    FooterItemData(
      label: 'Market',
      iconPath: AppImages.adminNavMarket,
      routePath: '/dealer/market',
    ),
    FooterItemData(
      label: 'Settings',
      iconPath: AppImages.adminNavSettings,
      routePath: '/dealer/app-settings',
    ),
  ],
  centerButton: null,
);

