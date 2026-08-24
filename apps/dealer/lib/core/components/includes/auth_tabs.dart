import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AuthTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final String leftLabel;
  final String rightLabel;

  const AuthTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.leftLabel = 'Login',
    this.rightLabel = 'Register',
  });

  @override
  Widget build(BuildContext context) {
    final radius = 8.r;

    Widget buildTab({
      required String label,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: selected ? AppColors.redButton : Colors.transparent,
              borderRadius: BorderRadius.circular(radius),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyles.boldSmall.copyWith(
                color: selected ? Colors.white : AppColors.lightText,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.authBackBg,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        children: [
          buildTab(
            label: leftLabel,
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          SizedBox(width: 4.w),
          buildTab(
            label: rightLabel,
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}
