import 'package:flutter/material.dart';
import 'package:vintage_app/core/theme/app_colors.dart';

class HorizontalDivider extends StatelessWidget {
  final double? width;
  final double height = 1.0;
  final Color? color = AppColors.grey;
  const HorizontalDivider({super.key, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 1.0,
      color: AppColors.grey,
    );
  }
}
