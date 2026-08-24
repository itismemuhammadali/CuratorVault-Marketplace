import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final String? btnText;
  final Color? btnColor;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final Widget? child;
  final VoidCallback onTap;
  const CustomButton({
    super.key,
    this.height,
    this.width,
    this.btnText,
    this.btnColor,
    this.borderRadius,
    this.textColor,
    required this.onTap,
    this.borderColor,
    this.textStyle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 60.h,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.transparent),
          color: btnColor ?? AppColors.redButton,
          borderRadius: BorderRadius.circular(borderRadius ?? 2.5.w),
        ),
        child: Center(
          child:
              child ??
              Text(
                btnText ?? "",
                style:
                    textStyle ?? TextStyles.boldSmall.copyWith(
                      color: textColor ?? Colors.white,
                    ),
              ),
        ),
      ),
    );
  }
}
