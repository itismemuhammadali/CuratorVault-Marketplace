import 'package:flutter/material.dart';

import 'header_config.dart';

class HeaderController extends ValueNotifier<HeaderConfig> {
  HeaderController()
      : super(
    const HeaderConfig(
        title: Text('Default Title'),
        height: 56.0,
    ),
  );
}
