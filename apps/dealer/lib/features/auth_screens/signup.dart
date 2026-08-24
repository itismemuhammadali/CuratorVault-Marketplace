import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _fieldIcon({
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

  Widget _socialButton({
    required VoidCallback onTap,
    required Widget leading,
    required String label,
    required Color background,
    required Color textColor,
    Color borderColor = const Color(0xFFE3E6EC),
  }) {
    return CustomButton(
      onTap: onTap,
      height: 48.h,
      borderRadius: 14.r,
      btnColor: background,
      borderColor: borderColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leading,
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyles.mediumMedium.copyWith(
              color: textColor,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xFFE3E6EC))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'or',
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.greyText,
              fontSize: 14.sp,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: const Color(0xFFE3E6EC))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 26.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 6.h),
              Center(
                child: ClipOval(
                  child: Image.asset(
                    AppImages.userImg,
                    width: 90.w,
                    height: 90.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 26.h),
              Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: TextStyles.semiBoldLarge.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 26.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Sign up to start selling your antiques',
                textAlign: TextAlign.center,
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.greyText,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 28.h),
              _socialButton(
                onTap: () {},
                background: Colors.white,
                textColor: AppColors.gradientColor1,
                leading: SvgPicture.asset(
                  'assets/icons/google_icon.svg',
                  width: 18.sp,
                  height: 18.sp,
                ),
                label: 'Continue with Google',
              ),
              SizedBox(height: 12.h),
              _socialButton(
                onTap: () {},
                background: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.white,
                leading: FaIcon(
                  FontAwesomeIcons.apple,
                  size: 18.sp,
                  color: Colors.white,
                ),
                label: 'Continue with Apple',
              ),
              SizedBox(height: 24.h),
              _divider(),
              SizedBox(height: 26.h),
              AppTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'your@email.com',
                keyboardType: TextInputType.emailAddress,
                prefix: _fieldIcon(
                  assetPath: AppImages.iconMail,
                  fallback: Icons.mail_outline,
                ),
                fillColor: const Color(0xFFF4F5F8),
                borderColor: const Color(0xFFE5E8EE),
                focusedBorderColor: const Color(0xFFE5E8EE),
                borderRadius: 14.r,
                labelStyle: TextStyles.mediumMedium.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 15.sp,
                ),
                hintStyle: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF8A91A3),
                  fontSize: 14.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 15.h,
                ),
              ),
              SizedBox(height: 18.h),
              AppTextField(
                controller: _passwordController,
                labelText: 'Password',
                hintText: '........',
                obscureText: _obscurePassword,
                prefix: SvgPicture.asset(
                  'assets/icons/lock_icon.svg',
                  width: 18.sp,
                  height: 18.sp,
                  colorFilter: const ColorFilter.mode(
                    AppColors.greyText,
                    BlendMode.srcIn,
                  ),
                ),
                suffix: GestureDetector(
                  onTap: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18.sp,
                    color: AppColors.greyText,
                  ),
                ),
                fillColor: const Color(0xFFF4F5F8),
                borderColor: const Color(0xFFE5E8EE),
                focusedBorderColor: const Color(0xFFE5E8EE),
                borderRadius: 14.r,
                labelStyle: TextStyles.mediumMedium.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 15.sp,
                ),
                hintStyle: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF8A91A3),
                  fontSize: 14.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 15.h,
                ),
              ),
              SizedBox(height: 18.h),
              AppTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                hintText: '........',
                obscureText: _obscureConfirmPassword,
                prefix: SvgPicture.asset(
                  'assets/icons/lock_icon.svg',
                  width: 18.sp,
                  height: 18.sp,
                  colorFilter: const ColorFilter.mode(
                    AppColors.greyText,
                    BlendMode.srcIn,
                  ),
                ),
                suffix: GestureDetector(
                  onTap: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword),
                  child: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18.sp,
                    color: AppColors.greyText,
                  ),
                ),
                fillColor: const Color(0xFFF4F5F8),
                borderColor: const Color(0xFFE5E8EE),
                focusedBorderColor: const Color(0xFFE5E8EE),
                borderRadius: 14.r,
                labelStyle: TextStyles.mediumMedium.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 15.sp,
                ),
                hintStyle: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF8A91A3),
                  fontSize: 14.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 15.h,
                ),
              ),
              SizedBox(height: 22.h),
              CustomButton(
                onTap: () => context.go('/dealer/business-info'),
                height: 52.h,
                borderRadius: 14.r,
                btnColor: AppColors.redButton,
                btnText: 'Sign Up',
                textStyle: TextStyles.boldMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 26.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.greyText,
                      fontSize: 14.sp,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      'Sign In',
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Privacy Policy',
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.greyText,
                      fontSize: 14.sp,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Text(
                      '•',
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.greyText,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Text(
                    'Terms of Service',
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.greyText,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
