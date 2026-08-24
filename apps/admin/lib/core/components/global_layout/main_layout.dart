import 'package:flutter/material.dart';
import 'package:vintage_app/core/components/global_footer/footer_config.dart';
import 'package:vintage_app/core/components/global_footer/global_footer.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import '../global_header/header_controller_provider.dart';

class GlobalLayout extends StatelessWidget {
  final Widget body;
  final HeaderConfig? headerConfig;
  final FooterFlow flow;

  const GlobalLayout({
    super.key,
    required this.body,
    this.headerConfig,
    this.flow = FooterFlow.user,
  });

  @override
  Widget build(BuildContext context) {
    if (headerConfig != null) {
      return Scaffold(
        appBar: SimpleHeader(config: headerConfig!),
        body: body,
        bottomNavigationBar: GlobalFooter(flow: flow),
      );
    }

    final controller = HeaderControllerProvider.of(context);

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, config, _) {
        return Scaffold(
          appBar: SimpleHeader(config: config),
          body: body,
          bottomNavigationBar: GlobalFooter(flow: flow),
        );
      },
    );
  }
}
