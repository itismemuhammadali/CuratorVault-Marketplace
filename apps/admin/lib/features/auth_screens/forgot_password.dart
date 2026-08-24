import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

import 'package:vintage_app/features/auth_screens/layout.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return AuthScreensLayout(
      bottomText: '',
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Forgot Password?',
              textAlign: TextAlign.center,
              style: TextStyles.semiBoldLarge.copyWith(
                color: AppColors.gradientColor1,
                fontSize: 23.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "No worries, we'll send you reset instructions",
              textAlign: TextAlign.center,
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.greyText,
              ),
            ),
            SizedBox(height: 20.h),
            AppTextField(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              hintText: 'your@email.com',
              prefix: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SvgPicture.asset(
                  'assets/icons/mail_icon.svg',
                  width: 20.w,
                  height: 20.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.greyText,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              fillColor: const Color(0xFFF4F5F8),
              borderColor: const Color(0xFFE5E8EE),
              focusedBorderColor: const Color(0xFFE5E8EE),
              borderRadius: 14.r,
              labelStyle: TextStyles.mediumMedium.copyWith(
                color: AppColors.gradientColor1,
              ),
              hintStyle: TextStyles.regularMedium.copyWith(
                color: const Color(0xFF8A91A3),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 15.h,
              ),
            ),
            SizedBox(height: 14.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF5FF),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFD8E5FF)),
              ),
              child: Text(
                "Enter your email address and we'll send you a link to reset your password",
                style: TextStyles.regularSmall.copyWith(
                  color: const Color(0xFF3B578B),
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: 18.h),
            CustomButton(
              onTap: () {
                final email = _emailController.text.trim();
                context.push('/checkEmail?email=${Uri.encodeComponent(email)}');
              },
              height: 52.h,
              borderRadius: 13.r,
              btnColor: AppColors.redButton,
              btnText: 'Send Reset Link',
              textStyle: TextStyles.boldSmall.copyWith(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 18.h),
            TextButton.icon(
              onPressed: () => context.pop(),
              icon: SvgPicture.asset(
                'assets/icons/arrow_back_icon.svg',
                width: 16.w,
                height: 16.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.gradientColor1,
                  BlendMode.srcIn,
                ),
              ),
              label: Text(
                'Back to Sign In',
                style: TextStyles.mediumSmall.copyWith(
                  color: AppColors.gradientColor1,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
