import 'package:flutter/material.dart';

import 'header_controller.dart';

class HeaderControllerProvider extends InheritedWidget {
  final HeaderController controller;

  const HeaderControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static HeaderController of(BuildContext context) {
    final result =
    context.dependOnInheritedWidgetOfExactType<HeaderControllerProvider>();
    assert(result != null, 'HeaderControllerProvider not found in context');
    return result!.controller;
  }

  @override
  bool updateShouldNotify(_) => false;
}
