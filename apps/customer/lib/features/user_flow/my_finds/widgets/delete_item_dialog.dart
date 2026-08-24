import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

Future<void> showDeleteItemDialog(
  BuildContext context, {
  required String itemTitle,
  VoidCallback? onConfirm,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 22.h),
          decoration: BoxDecoration(
            color: AppColors.authBackBg,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete Item',
                textAlign: TextAlign.center,
                style: TextStyles.semiBoldMedium.copyWith(
                  color: const Color(0xFF202124),
                  fontSize: 30.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Are you sure you want to delete "$itemTitle"? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.gradientColor1.withValues(alpha: 0.7),
                  height: 1.35,
                ),
              ),
              SizedBox(height: 18.h),
              _DialogButton(
                label: 'Delete',
                backgroundColor: const Color(0xFFF10000),
                textColor: AppColors.bodyBg,
                borderColor: Colors.transparent,
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  onConfirm?.call();
                },
              ),
              SizedBox(height: 10.h),
              _DialogButton(
                label: 'Cancel',
                backgroundColor: Colors.transparent,
                textColor: const Color(0xFF202124),
                borderColor: const Color(0xFFD3D8E0),
                onTap: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _DialogButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.mediumMedium.copyWith(
              color: textColor,
              fontSize: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}
