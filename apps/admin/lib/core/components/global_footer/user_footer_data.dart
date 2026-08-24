import 'package:vintage_app/core/components/global_footer/footer_models.dart';
import 'package:vintage_app/core/theme/images.dart';

const FooterFlowConfig userFooterConfig = FooterFlowConfig(
  items: [
    FooterItemData(
      label: 'Home',
      iconPath: AppImages.navHome,
      routePath: '/homeScreen',
    ),
    FooterItemData(
      label: 'Inventory',
      iconPath: AppImages.navFolder,
      routePath: '/dealer/my-finds',
    ),
    FooterItemData(
      label: 'Orders',
      iconPath: AppImages.shoppingCartIcon,
      routePath: '/dealer/orders',
    ),
    FooterItemData(
      label: 'Messages',
      iconPath: AppImages.chatBubbleIcon,
      routePath: '/dealer/messages',
    ),
  ],
  centerButton: FooterCenterButtonConfig(
    iconPath: AppImages.navCenterScan,
    routePath: '/dealer/scan',
  ),
);
