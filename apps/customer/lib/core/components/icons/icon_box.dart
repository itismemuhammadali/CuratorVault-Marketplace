import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final double? height;
  final double? width;
  final String icon;
  final Color? bgColor;
  final Color? iconColor;
  final double? borderRadius;
  final VoidCallback? onTap;
  const IconBox({
    super.key,
    this.height,
    this.width,
    required this.icon,
    this.bgColor,
    this.iconColor,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? (){},
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
        ),
        child: Center(
            child: Image.asset(
              icon,
              color: iconColor,
              height: height != null ? height! * 0.5 : null,
              width: width != null ? width! * 0.5 : null,
            )
        ),
      ),
    );
  }
}
