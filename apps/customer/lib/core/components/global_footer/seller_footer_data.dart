import 'package:vintage_app/core/components/global_footer/footer_models.dart';

const FooterFlowConfig sellerFooterConfig = FooterFlowConfig(
  items: [
    FooterItemData(
      label: 'Home',
      iconPath: 'assets/icons/admin_nav_home.svg',
      routePath: '/seller/home',
    ),
    FooterItemData(
      label: 'Inventory',
      iconPath: 'assets/icons/admin_nav_inventory.svg',
      routePath: '/seller/inventory',
    ),
    FooterItemData(
      label: 'Orders',
      iconPath: 'assets/icons/admin_nav_orders.svg',
      routePath: '/seller/orders',
    ),
    FooterItemData(
      label: 'Messages',
      iconPath: 'assets/icons/admin_nav_messages.svg',
      routePath: '/seller/messages',
    ),
  ],
  centerButton: FooterCenterButtonConfig(
    iconPath: 'assets/icons/camera_add_icon.svg',
    routePath: '/seller/add',
  ),
);

