import 'package:vintage_app/core/components/global_footer/footer_models.dart';

const FooterFlowConfig userFooterConfig = FooterFlowConfig(
  items: [
    FooterItemData(
      label: 'Home',
      iconPath: 'assets/icons/admin_nav_home.svg',
      routePath: '/homeScreen',
    ),
    FooterItemData(
      label: 'Inventory',
      iconPath: 'assets/icons/admin_nav_inventory.svg',
      routePath: '/dealer/my-finds',
    ),
    FooterItemData(
      label: 'Orders',
      iconPath: 'assets/icons/admin_nav_orders.svg',
      routePath: '/dealer/orders',
    ),
    FooterItemData(
      label: 'Messages',
      iconPath: 'assets/icons/admin_nav_messages.svg',
      routePath: '/dealer/messages',
    ),
  ],
  centerButton: FooterCenterButtonConfig(
    iconPath: 'assets/icons/camera_add_icon.svg',
    routePath: '/dealer/scan',
  ),
);

