import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class HorizontalChipBar extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  // Layout & spacing
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry chipPadding;
  final double chipHeight;
  final double? chipMinWidth;
  final double spacing;

  // Colors & styles
  final Color backgroundColor;
  final Color activeBackgroundColor;
  final Color inactiveBackgroundColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final TextStyle? textStyle;

  // Shape
  final BorderRadiusGeometry borderRadius;

  HorizontalChipBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? chipPadding,
    double? chipHeight,
    this.chipMinWidth,
    double? spacing,
    Color? backgroundColor,
    Color? activeBackgroundColor,
    Color? inactiveBackgroundColor,
    Color? activeTextColor,
    Color? inactiveTextColor,
    this.textStyle,
    BorderRadiusGeometry? borderRadius,
  })  : padding = padding ?? const EdgeInsets.symmetric(horizontal: 16),
        chipPadding = chipPadding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        chipHeight = chipHeight ?? 32,
        spacing = spacing ?? 8,
        backgroundColor = backgroundColor ?? Colors.transparent,
        activeBackgroundColor = activeBackgroundColor ?? AppColors.redButton,
        inactiveBackgroundColor = inactiveBackgroundColor ?? const Color(0xFF3B4351),
        activeTextColor = activeTextColor ?? AppColors.bodyBg,
        inactiveTextColor = inactiveTextColor ?? AppColors.bodyBg,
        borderRadius = borderRadius ?? BorderRadius.circular(40.r);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      color: backgroundColor,
      padding: padding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(items.length, (index) {
            final bool isSelected = index == selectedIndex;

            return Padding(
              padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : spacing),
              child: GestureDetector(
                onTap: () => onChanged(index),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: chipHeight, minWidth: chipMinWidth ?? 0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isSelected ? activeBackgroundColor : inactiveBackgroundColor,
                      borderRadius: borderRadius,
                    ),
                    child: Padding(
                      padding: chipPadding,
                      child: Center(
                        child: Text(
                          items[index],
                          style: (textStyle ?? TextStyles.regularSmall).copyWith(
                            color: isSelected ? activeTextColor : inactiveTextColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
