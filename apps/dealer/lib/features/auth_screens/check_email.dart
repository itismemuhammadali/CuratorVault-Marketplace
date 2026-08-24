import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/auth_screens/layout.dart';

class CheckEmailScreen extends StatelessWidget {
  final String email;
  const CheckEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return AuthScreensLayout(
      bottomText: '',
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 6.h),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 74.w,
                height: 74.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.greenSuccess,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 34.sp,
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'Check Your Email',
              style: TextStyles.boldLarge.copyWith(
                color: AppColors.gradientColor1,
                fontSize: 23.sp,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              "We've sent password reset instructions to",
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.greyText,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              email.isEmpty ? 'your@email.com' : email,
              textAlign: TextAlign.center,
              style: TextStyles.mediumMedium.copyWith(
                color: AppColors.gradientColor1,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              "Didn't receive the email? Check your spam folder or",
              textAlign: TextAlign.center,
              style: TextStyles.regularSmall.copyWith(
                color: AppColors.greyText,
                height: 1.35,
              ),
            ),
            SizedBox(height: 6.h),
            GestureDetector(
              onTap: () => context.push('/newPassword'),
              child: Text(
                'try again',
                textAlign: TextAlign.center,
                style: TextStyles.boldMedium.copyWith(
                  color: AppColors.gradientColor1,
                ),
              ),
            ),
            SizedBox(height: 28.h),
            CustomButton(
              onTap: () => context.go('/login'),
              height: 52.h,
              borderRadius: 13.r,
              btnColor: AppColors.redButton,
              btnText: 'Back to Sign In',
              textStyle: TextStyles.boldSmall.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
