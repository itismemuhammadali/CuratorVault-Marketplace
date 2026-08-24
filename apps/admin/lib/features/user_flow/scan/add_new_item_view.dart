import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AddNewItemView extends StatelessWidget {
  const AddNewItemView({super.key});

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/homeScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: IconBox(
            icon: AppImages.backIcon,
            bgColor: AppColors.darkText.withValues(alpha: 0.20),
            onTap: () => _goBack(context),
            iconColor: AppColors.darkText,
            height: 40.h,
            width: 40.w,
            borderRadius: 100.r,
          ),
          title: Text(
            'Add New Item',
            style: TextStyles.boldLarge.copyWith(color: AppColors.bodyBg),
          ),
          height: 170.h,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
          child: Column(
            children: [
              _ScanOptionCard(
                icon: Icons.photo_camera_outlined,
                title: 'Scan via Camera',
                subtitle: 'Take photos of your antique item',
                onTap: () => context.push('/user/scan/camera'),
              ),
              SizedBox(height: 18.h),
              _ScanOptionCard(
                icon: Icons.image_outlined,
                title: 'Upload from Gallery',
                subtitle: 'Choose existing photos',
                onTap: () => context.push('/user/scan/gallery'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ScanOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 26.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.lightText.withValues(alpha: 0.14),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 54.w,
              height: 54.w,
              decoration: BoxDecoration(
                color: AppColors.redButton.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: AppColors.redButton, size: 28.sp),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              style: TextStyles.semiBoldLarge.copyWith(
                color: AppColors.gradientColor1,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
