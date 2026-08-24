import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/auth_screens/layout.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _lockPrefix() {
    return SvgPicture.asset(
      AppImages.lockIcon,
      width: 18.sp,
      height: 18.sp,
      fit: BoxFit.contain,
    );
  }

  Widget _eyeSuffix({required bool obscure, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 18.sp,
        color: AppColors.greyText,
      ),
    );
  }

  Widget _requirementRow(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.redButton,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.regularSmall.copyWith(
                fontSize: 12.sp,
                color: AppColors.greyText,
              ),
            ),
          ),
        ],
      ),
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
            SizedBox(height: 8.h),
            Text(
              'New Password',
              style: TextStyles.semiBoldLarge.copyWith(
                color: AppColors.gradientColor1,
              ),
            ),
            SizedBox(height: 18.h),
            AppTextField(
              controller: _newPasswordController,
              labelText: 'New password',
              hintText: 'Enter new Password',
              prefix: _lockPrefix(),
              suffix: _eyeSuffix(
                obscure: _obscureNew,
                onTap: () => setState(() => _obscureNew = !_obscureNew),
              ),
              obscureText: _obscureNew,
              fillColor: AppColors.authBackBg,
              borderColor: AppColors.authBackBg,
              focusedBorderColor: AppColors.authBackBg,
              borderRadius: 14.r,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm new password',
              hintText: 'Confirm new password',
              prefix: _lockPrefix(),
              suffix: _eyeSuffix(
                obscure: _obscureConfirm,
                onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              obscureText: _obscureConfirm,
              fillColor: AppColors.authBackBg,
              borderColor: AppColors.authBackBg,
              focusedBorderColor: AppColors.authBackBg,
              borderRadius: 14.r,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
            ),
            SizedBox(height: 18.h),
            CustomButton(
              onTap: () {},
              height: 52.h,
              borderRadius: 12.r,
              btnColor: AppColors.redButton,
              btnText: 'Reset password',
              textStyle: TextStyles.boldSmall.copyWith(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 18.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.requirementCardBg,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                    spreadRadius: -18,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password Requirements:',
                    style: TextStyles.boldSmall.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.lightText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _requirementRow('At least 8 characters'),
                  _requirementRow('One uppercase letter'),
                  _requirementRow('One lowercase letter'),
                  _requirementRow('One number'),
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
