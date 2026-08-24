import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _fieldIcon({required String assetPath, required IconData fallback}) {
    if (assetPath.endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath,
        width: 18.w,
        height: 18.h,
        fit: BoxFit.contain,
        colorFilter: const ColorFilter.mode(
          AppColors.greyText,
          BlendMode.srcIn,
        ),
      );
    }
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        AppImages.splashImage,
                        width: 90.w,
                        height: 90.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: TextStyles.semiBoldLarge.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 26.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Vintage Vinnie',
                      textAlign: TextAlign.center,
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.greyText,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    SizedBox(
                      width: double.infinity,
                      child: AppTextField(
                        controller: _emailController,
                        labelText: 'Email address',
                        hintText: 'admin@vintagevinnie.com',
                        keyboardType: TextInputType.emailAddress,
                        prefix: Padding(
                          padding: EdgeInsets.all(12.r),
                          child: SvgPicture.asset(
                            'assets/icons/mail_icon.svg',
                            width: 18.w,
                            height: 18.h,
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
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                      width: double.infinity,
                      child: AppTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        obscureText: _obscurePassword,
                        prefix: _fieldIcon(
                          assetPath: AppImages.iconLock,
                          fallback: Icons.lock_outline,
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
                    ),
                    SizedBox(height: 14.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/forgotPassword'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyles.mediumMedium.copyWith(
                            color: AppColors.gradientColor1,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 22.h),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onTap: () => context.go('/homeScreen'),
                        height: 52.h,
                        borderRadius: 14.r,
                        btnColor: AppColors.redButton,
                        btnText: 'Sign In',
                        textStyle: TextStyles.boldMedium.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Secure Admin Access',
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
                          'Session managed',
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
            ],
          ),
        ),
      ),
    );
  }
}
