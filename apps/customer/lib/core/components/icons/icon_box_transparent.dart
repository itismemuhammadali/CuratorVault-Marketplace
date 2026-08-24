import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/theme/app_colors.dart';

class IconBoxTransparent extends StatelessWidget {
  final String icon;
  final double? size;
  final Color? color;
  final VoidCallback? onTap;
  const IconBoxTransparent({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Image.asset(
        icon,
        color: color ?? AppColors.redButton,
        height: size ?? 20.h,
        width: size ?? 20.w,
      ),
    );
  }
}
