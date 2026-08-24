import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/includes/auth_tabs.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/auth_screens/layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _selectedTabIndex = 0;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  Widget _dividerOrContinue() {
    final Color lineColor = _selectedTabIndex == 1
        ? AppColors.redButton
        : AppColors.authBackBg;
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: lineColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'or continue with',
            style: TextStyles.regularSmall.copyWith(
              fontSize: 12.sp,
              color: AppColors.greyText,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: lineColor)),
      ],
    );
  }

  Widget _socialButtons() {
    return Column(
      children: [
        CustomButton(
          onTap: () {},
          height: 46.h,
          borderRadius: 8.r,
          btnColor: Colors.transparent,
          borderColor: AppColors.authBackBg,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppImages.googleIcon,
                width: 20.sp,
                height: 20.sp,
              ),
              SizedBox(width: 10.w),
              Text(
                'Google',
                style: TextStyles.boldSmall.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.lightText,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        CustomButton(
          onTap: () {},
          height: 46.h,
          borderRadius: 8.r,
          btnColor: Colors.transparent,
          borderColor: AppColors.authBackBg,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.apple,
                size: 20.sp,
                color: AppColors.lightText,
              ),
              SizedBox(width: 10.w),
              Text(
                'Apple',
                style: TextStyles.boldSmall.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.lightText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fieldImage(String assetPath) {
    if (assetPath.endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath,
        width: 18.sp,
        height: 18.sp,
        fit: BoxFit.contain,
      );
    }
    return Image.asset(
      assetPath,
      width: 18.sp,
      height: 18.sp,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox.shrink();
      },
    );
  }

  Widget _loginFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          hintText: 'E-mail ID',
          prefix: _fieldImage(AppImages.iconMail),
        ),
        SizedBox(height: 12.h),
        AppTextField(
          controller: _passwordController,
          hintText: 'Password',
          prefix: _fieldImage(AppImages.iconLock),
          obscureText: _obscurePassword,
          suffix: IconButton(
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 18.sp,
              color: AppColors.greyText,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            SizedBox(
              height: 22.sp,
              width: 22.sp,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (v) => setState(() => _rememberMe = v ?? false),
                activeColor: AppColors.redButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                side: BorderSide(color: AppColors.authBackBg),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Remember me',
              style: TextStyles.regularSmall.copyWith(
                fontSize: 12.sp,
                color: AppColors.lightText,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/forgotPassword'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(10.w, 10.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forget Password?',
                style: TextStyles.regularSmall.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.redButton,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _registerFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _firstNameController,
                hintText: 'First name',
                prefix: _fieldImage(AppImages.iconUser),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppTextField(
                controller: _lastNameController,
                hintText: 'Last Name',
                prefix: _fieldImage(AppImages.iconUser),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        AppTextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          hintText: 'Email-ID',
          prefix: _fieldImage(AppImages.iconMail),
        ),
        SizedBox(height: 12.h),
        AppTextField(
          controller: _passwordController,
          hintText: 'Password',
          prefix: _fieldImage(AppImages.iconLock),
          obscureText: true,
        ),
        SizedBox(height: 12.h),
        AppTextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          hintText: 'Phone No.',
          prefix: _fieldImage(AppImages.iconPhone),
        ),
        SizedBox(height: 12.h),
        AppTextField(
          controller: _licenseController,
          hintText: 'License No.',
          prefix: _fieldImage(AppImages.iconLicense),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isRegister = _selectedTabIndex == 1;

    return AuthScreensLayout(
      bottomText: 'AI • Trusted by Collectors Worldwide',
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTabs(
              selectedIndex: _selectedTabIndex,
              onChanged: (index) => setState(() => _selectedTabIndex = index),
            ),
            SizedBox(height: 18.h),
            if (isRegister) _registerFields() else _loginFields(),
            SizedBox(height: 14.h),
            CustomButton(
              onTap: () {
                context.go(isRegister ? '/homeScreen' : '/homeScreen');
              },
              height: 48.h,
              borderRadius: 8.r,
              btnText: isRegister ? 'Sign up' : 'Login',
              btnColor: AppColors.redButton,
              textStyle: TextStyles.boldSmall.copyWith(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            _dividerOrContinue(),
            SizedBox(height: 14.h),
            _socialButtons(),
            SizedBox(height: 18.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isRegister
                      ? 'Already have an account? '
                      : "Don't have an account? ",
                  style: TextStyles.regularSmall.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.greyText,
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      setState(() => _selectedTabIndex = isRegister ? 0 : 1),
                  child: Text(
                    isRegister ? 'Sign In' : 'Sign Up',
                    style: TextStyles.boldSmall.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.redButton,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              'By signing up, you agree to our Privacy\nPolicy & Terms',
              textAlign: TextAlign.center,
              style: TextStyles.regularSmall.copyWith(
                fontSize: 10.sp,
                color: AppColors.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
