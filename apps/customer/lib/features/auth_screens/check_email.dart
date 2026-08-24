import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/auth_screens/layout.dart';

class CheckEmailScreen extends StatelessWidget {
  final String email;
  const CheckEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return AuthScreensLayout(
      bottomText: 'Secure password recovery powered by Vintage Vibers',
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 6.h),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 94.w,
                height: 94.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.greenSuccess,
                ),
                child: SvgPicture.asset(
                  AppImages.checkEmailIcon,
                  width: 34.sp,
                  height: 34.sp,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'Check Your Email',
              textAlign: TextAlign.center,
              style: TextStyles.semiBoldLarge.copyWith(
                color: AppColors.gradientColor1,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              "We've sent a password reset link to",
              textAlign: TextAlign.center,
              style: TextStyles.regularSmall.copyWith(
                fontSize: 12.sp,
                color: AppColors.greyText,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                email.isNotEmpty ? email : 'your-email@example.com',
                textAlign: TextAlign.center,
                style: TextStyles.boldSmall.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.redButton,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Click the link in the email to reset your password. The\nlink will expire in 1 hour.',
              textAlign: TextAlign.center,
              style: TextStyles.regularSmall.copyWith(
                fontSize: 11.sp,
                color: AppColors.greyText,
              ),
            ),
            SizedBox(height: 22.h),
            CustomButton(
              onTap: () => context.go('/login'),
              height: 52.h,
              borderRadius: 12.r,
              btnColor: AppColors.redButton,
              btnText: 'Back to Login',
              textStyle: TextStyles.boldSmall.copyWith(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 14.h),
            CustomButton(
              onTap: () => context.push('/newPassword'),
              height: 52.h,
              borderRadius: 12.r,
              btnColor: Colors.transparent,
              borderColor: AppColors.redButton,
              btnText: 'Resend Email',
              textStyle: TextStyles.boldSmall.copyWith(
                fontSize: 14.sp,
                color: AppColors.redButton,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
