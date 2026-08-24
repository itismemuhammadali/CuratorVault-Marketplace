import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class VerificationInProgressView extends StatelessWidget {
  const VerificationInProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientColor1, AppColors.gradientColor2],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 22.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 34.h),
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 124.w,
                          height: 124.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF2F5F8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.access_time_rounded,
                            color: AppColors.gradientColor1,
                            size: 58.sp,
                          ),
                        ),
                        Positioned(
                          right: -2.w,
                          bottom: 4.h,
                          child: Container(
                            width: 38.w,
                            height: 38.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF4C400),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Text(
                    'Application Submitted!',
                    textAlign: TextAlign.center,
                    style: TextStyles.semiBoldLarge.copyWith(
                      color: Colors.white,
                      fontSize: 28.sp,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    "We're reviewing your dealer account",
                    textAlign: TextAlign.center,
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.bodyBg.withValues(alpha: 0.88),
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "This typically takes 24-48 hours. We'll notify you\nonce approved.",
                    textAlign: TextAlign.center,
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.bodyBg.withValues(alpha: 0.74),
                      fontSize: 14.sp,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _StatusCard(
                    icon: Icons.check_rounded,
                    iconBg: const Color(0xFF00D36F),
                    title: 'Account Created',
                    subtitle: 'Your dealer account has been created',
                  ),
                  SizedBox(height: 14.h),
                  _StatusCard(
                    icon: Icons.check_rounded,
                    iconBg: const Color(0xFF00D36F),
                    title: 'Documents Received',
                    subtitle: 'All verification documents submitted',
                  ),
                  SizedBox(height: 14.h),
                  _StatusCard(
                    icon: Icons.access_time_rounded,
                    iconBg: const Color(0xFFF4C400),
                    title: 'Under Review',
                    subtitle: 'Our team is verifying your information',
                  ),
                  SizedBox(height: 14.h),
                  _StatusCard(
                    icon: Icons.check_circle_outline,
                    iconBg: const Color(0xFF5A6475),
                    iconColor: const Color(0xFFBDC4CF),
                    title: 'Approval Pending',
                    subtitle: 'You\'ll receive email notification',
                    dimmed: true,
                  ),
                  SizedBox(height: 18.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2F3C53).withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(22.r),
                      border: Border.all(
                        color: AppColors.bodyBg.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.mail_outline,
                              color: AppColors.bodyBg,
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'What Happens Next?',
                              style: TextStyles.boldMedium.copyWith(
                                color: AppColors.bodyBg,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        _StepRow(
                          index: '1',
                          text:
                              'We\'ll verify your identity and business documents',
                        ),
                        _StepRow(
                          index: '2',
                          text: 'Our team will review your store profile',
                        ),
                        _StepRow(
                          index: '3',
                          text: 'You\'ll receive an email with approval status',
                        ),
                        _StepRow(
                          index: '4',
                          text: 'Once approved, you can start listing items!',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22.h),
                  Center(
                    child: Text(
                      'Have questions? Our support team is here to help',
                      textAlign: TextAlign.center,
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.bodyBg.withValues(alpha: 0.78),
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Text(
                      'support@antiquedealer.com',
                      textAlign: TextAlign.center,
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.bodyBg,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  CustomButton(
                    onTap: () => context.go('/homeScreen'),
                    height: 56.h,
                    borderRadius: 16.r,
                    btnColor: Colors.white,
                    btnText: 'Continue to Dashboard',
                    textStyle: TextStyles.boldMedium.copyWith(
                      color: AppColors.gradientColor1,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'You can explore the app with limited access while we review your account',
                    textAlign: TextAlign.center,
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.bodyBg.withValues(alpha: 0.60),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final bool dimmed;

  const _StatusCard({
    required this.icon,
    required this.iconBg,
    this.iconColor,
    required this.title,
    required this.subtitle,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg.withValues(alpha: dimmed ? 0.08 : 0.12),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.bodyBg.withValues(alpha: dimmed ? 0.10 : 0.16),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor ?? Colors.white, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.boldMedium.copyWith(
                    color: dimmed
                        ? AppColors.bodyBg.withValues(alpha: 0.50)
                        : AppColors.bodyBg,
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyles.regularSmall.copyWith(
                    color: dimmed
                        ? AppColors.bodyBg.withValues(alpha: 0.36)
                        : AppColors.bodyBg.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String index;
  final String text;

  const _StepRow({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            index,
            style: TextStyles.boldMedium.copyWith(
              color: const Color(0xFFF4C400),
              fontSize: 16.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.regularSmall.copyWith(
                color: AppColors.bodyBg,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
