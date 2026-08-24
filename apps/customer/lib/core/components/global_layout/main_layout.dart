import 'package:flutter/material.dart';
import 'package:vintage_app/core/components/global_footer/footer_config.dart';
import 'package:vintage_app/core/components/global_footer/global_footer.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import '../global_header/header_controller_provider.dart';

class GlobalLayout extends StatelessWidget {
  final Widget body;
  final HeaderConfig? headerConfig;

  const GlobalLayout({
    super.key,
    required this.body,
    this.headerConfig,
  });

  @override
  Widget build(BuildContext context) {
    const flow = FooterFlow.user;

    if (headerConfig != null) {
      return Scaffold(
        appBar: SimpleHeader(config: headerConfig!),
        body: body,
        bottomNavigationBar: const GlobalFooter(flow: flow),
      );
    }

    final controller = HeaderControllerProvider.of(context);

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, config, _) {
        return Scaffold(
          appBar: SimpleHeader(config: config),
          body: body,
          bottomNavigationBar: const GlobalFooter(flow: flow),
        );
      },
    );
  }
}
