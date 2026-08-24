import 'package:vintage_app/core/components/global_footer/footer_models.dart';
import 'package:vintage_app/core/theme/images.dart';

const FooterFlowConfig sellerFooterConfig = FooterFlowConfig(
  items: [
    FooterItemData(
      label: 'Home',
      iconPath: AppImages.navHome,
      routePath: '/seller/home',
    ),
    FooterItemData(
      label: 'Inventory',
      iconPath: AppImages.navInventory,
      routePath: '/seller/inventory',
    ),
    FooterItemData(
      label: 'Orders',
      iconPath: AppImages.navOrders,
      routePath: '/seller/orders',
    ),
    FooterItemData(
      label: 'Messages',
      iconPath: AppImages.navMessages,
      routePath: '/seller/messages',
    ),
  ],
  centerButton: FooterCenterButtonConfig(
    iconPath: AppImages.navCenterPlus,
    routePath: '/seller/add',
  ),
);
