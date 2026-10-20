import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/services/auth_service.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
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

  Widget _fieldImageWithFallback({
    required String assetPath,
    required IconData fallback,
  }) {
    return Image.asset(
      assetPath,
      width: 18.sp,
      height: 18.sp,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallback, size: 18.sp, color: AppColors.greyText);
      },
    );
  }

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
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: AppColors.redButtonBg10,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.mail_outline,
                  size: 26.sp,
                  color: AppColors.redButton,
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              'Forgot Password?',
              textAlign: TextAlign.center,
              style: TextStyles.semiBoldLarge.copyWith(
                color: AppColors.gradientColor1,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Enter your email address and we'll send you a\nlink to reset your password.",
              textAlign: TextAlign.center,
              style: TextStyles.regularSmall.copyWith(
                fontSize: 12.sp,
                color: AppColors.greyText,
              ),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email Address',
              prefix: _fieldImageWithFallback(
                assetPath: AppImages.iconMail,
                fallback: Icons.mail_outline,
              ),
              borderColor: AppColors.redButton,
              focusedBorderColor: AppColors.redButton,
              borderRadius: 12.r,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
            ),
            SizedBox(height: 14.h),
            CustomButton(
              onTap: () async {
                final email = _emailController.text.trim();
                if (email.isNotEmpty) {
                  try {
                    await AuthService().sendPasswordResetEmail(email);
                  } catch (e) {
                    debugPrint('Error sending password reset email: $e');
                  }
                }
                if (context.mounted) {
                  context.push('/checkEmail?email=${Uri.encodeComponent(email)}');
                }
              },
              height: 52.h,
              borderRadius: 10.r,
              btnColor: AppColors.redButton,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppImages.sendIcon,
                    width: 18.sp,
                    height: 18.sp,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Send Reset Link',
                    style: TextStyles.boldSmall.copyWith(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Remember your password? ',
                  style: TextStyles.regularSmall.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.redButton,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Text(
                    'Login',
                    style: TextStyles.boldSmall.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.redButton,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.redButtonBg10,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.greyText,
                    size: 18.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      "Tip: Check your spam folder if you don't see the\nemail within a few minutes.",
                      style: TextStyles.regularSmall.copyWith(
                        fontSize: 10.sp,
                        color: AppColors.greyText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
