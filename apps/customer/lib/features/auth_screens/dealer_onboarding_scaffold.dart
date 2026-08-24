import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class DealerOnboardingScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final int step;
  final int totalSteps;
  final Widget child;

  const DealerOnboardingScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.step,
    required this.totalSteps,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final progress = step / totalSteps;

    return Scaffold(
      backgroundColor: AppColors.subPageBg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(22.w, 54.h, 22.w, 22.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.gradientColor1, AppColors.gradientColor2],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(34.r),
                  bottomRight: Radius.circular(34.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.18),
                    blurRadius: 24,
                    spreadRadius: -12,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.bodyBg.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          AppImages.backIcon,
                          width: 16.w,
                          height: 16.w,
                          color: AppColors.darkText,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    title,
                    style: TextStyles.boldLarge.copyWith(
                      color: AppColors.bodyBg,
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    subtitle,
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.bodyBg.withValues(alpha: 0.78),
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99.r),
                          child: LinearProgressIndicator(
                            minHeight: 5.h,
                            value: progress,
                            backgroundColor:
                                AppColors.bodyBg.withValues(alpha: 0.25),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.bodyBg,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Step $step of $totalSteps',
                        style: TextStyles.mediumSmall.copyWith(
                          color: AppColors.bodyBg,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 24.h),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
