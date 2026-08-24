import 'package:vintage_app/core/components/global_footer/admin_footer_data.dart';
import 'package:vintage_app/core/components/global_footer/footer_models.dart';
import 'package:vintage_app/core/components/global_footer/seller_footer_data.dart';
import 'package:vintage_app/core/components/global_footer/user_footer_data.dart';

export 'footer_models.dart';

/// Central place where all footer flows are mapped.
class FooterConfigs {
  static FooterFlowConfig of(FooterFlow flow) {
    switch (flow) {
      case FooterFlow.user:
        return userFooterConfig;
      case FooterFlow.seller:
        return sellerFooterConfig;
      case FooterFlow.admin:
        return adminFooterConfig;
    }
  }
}
