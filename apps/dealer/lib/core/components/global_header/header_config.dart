import 'package:flutter/material.dart';

class HeaderConfig {
  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final Widget? bottomWidget;
  final double height;
  final bool? isCentered;

  const HeaderConfig({
    required this.title,
    this.leading,
    this.trailing,
    this.bottomWidget,
    required this.height,
    this.isCentered = false,
  });
}
