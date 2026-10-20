import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String hintText;
  final TextInputType keyboardType;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final bool enabled;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;

  const AppTextField({
    super.key,
    required this.controller,
    this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onSubmitted,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.contentPadding,
    this.borderRadius,
    this.labelStyle,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    final radius = (borderRadius ?? 8.r);
    final effectiveBorderColor = borderColor ?? AppColors.authBackBg;
    final effectiveFocusedBorderColor =
        focusedBorderColor ?? AppColors.redButton;

    final field = TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            hintStyle ??
            TextStyles.regularSmall.copyWith(
              color: AppColors.greyText,
            ),
        prefixIcon:
            prefix == null
                ? null
                : Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Align(
                    alignment: Alignment.center,
                    child: prefix!,
                  ),
                ),
        prefixIconConstraints: BoxConstraints(
          minWidth: 44.w,
          minHeight: 44.h,
          maxWidth: 44.w,
          maxHeight: 44.h,
        ),
        suffixIcon:
            suffix == null
                ? null
                : Padding(
                  padding: EdgeInsets.all(6.w),
                  child: Align(
                    alignment: Alignment.center,
                    child: suffix!,
                  ),
                ),
        suffixIconConstraints: BoxConstraints(
          minWidth: 44.w,
          minHeight: 44.h,
          maxWidth: 44.w,
          maxHeight: 44.h,
        ),
        filled: true,
        fillColor: fillColor ?? Colors.white,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: effectiveBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: effectiveBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: effectiveFocusedBorderColor, width: 1.2),
        ),
      ),
    );

    if (labelText == null || labelText!.trim().isEmpty) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText!,
          style:
              labelStyle ??
              TextStyles.boldSmall.copyWith(
                color: AppColors.lightText,
              ),
        ),
        SizedBox(height: 8.h),
        field,
      ],
    );
  }
}
