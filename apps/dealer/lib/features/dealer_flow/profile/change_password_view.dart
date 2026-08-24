import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/custom_top_toast.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  static final RegExp _upperCaseRegExp = RegExp(r'[A-Z]');
  static final RegExp _lowerCaseRegExp = RegExp(r'[a-z]');
  static final RegExp _numberRegExp = RegExp(r'\d');
  static final RegExp _specialCharRegExp = RegExp(r'[^\w\s]');

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(_handleFormChanged);
    _newPasswordController.addListener(_handleFormChanged);
    _confirmPasswordController.addListener(_handleFormChanged);
  }

  @override
  void dispose() {
    _currentPasswordController
      ..removeListener(_handleFormChanged)
      ..dispose();
    _newPasswordController
      ..removeListener(_handleFormChanged)
      ..dispose();
    _confirmPasswordController
      ..removeListener(_handleFormChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFormChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get _hasCurrentPassword => _currentPasswordController.text.isNotEmpty;

  bool get _isLongEnough => _newPasswordController.text.length >= 8;

  bool get _hasUpperCase =>
      _upperCaseRegExp.hasMatch(_newPasswordController.text);

  bool get _hasLowerCase =>
      _lowerCaseRegExp.hasMatch(_newPasswordController.text);

  bool get _hasNumber => _numberRegExp.hasMatch(_newPasswordController.text);

  bool get _hasSpecialCharacter =>
      _specialCharRegExp.hasMatch(_newPasswordController.text);

  bool get _passwordsMatch =>
      _newPasswordController.text.isNotEmpty &&
      _newPasswordController.text == _confirmPasswordController.text;

  bool get _isPasswordValid =>
      _hasCurrentPassword &&
      _isLongEnough &&
      _hasUpperCase &&
      _hasLowerCase &&
      _hasNumber &&
      _hasSpecialCharacter &&
      _passwordsMatch;

  void _handleUpdatePassword() {
    if (!_isPasswordValid) return;

    CustomTopToast.show(context, 'Password updated successfully');
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        context.pop();
      }
    });
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return AppTextField(
      controller: controller,
      labelText: label,
      hintText: hint,
      obscureText: obscureText,
      prefix: SvgPicture.asset(
        'assets/icons/lock_icon.svg',
        width: 22.w,
        height: 22.w,
        colorFilter: const ColorFilter.mode(
          Color(0xFF98A0AF),
          BlendMode.srcIn,
        ),
      ),
      suffix: InkWell(
        onTap: onToggleVisibility,
        child: IconBox(
          icon: AppImages.eyeOutlinedIcon,
          width: 55.w,
          height: 55.w,
          bgColor: Colors.transparent,
          iconColor: const Color(0xFF98A0AF),
        ),
      ),
      fillColor: const Color(0xFFF6F7F9),
      borderColor: const Color(0xFFDDE2EA),
      focusedBorderColor: const Color(0xFFC7D2E0),
      borderRadius: 14.r,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      labelStyle: TextStyles.boldSmall.copyWith(
        color: AppColors.lightText,
        fontSize: 15.sp,
      ),
      hintStyle: TextStyles.regularSmall.copyWith(
        color: const Color(0xFF98A0AF),
        fontSize: 15.sp,
      ),
    );
  }

  Widget _requirementItem({required String text, required bool isMet}) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMet ? const Color(0xFF10B981) : const Color(0xFFE4E8EF),
            ),
            child: Center(
              child: isMet
                  ? IconBox(
                      icon: AppImages.tickIcon,
                      width: 12.sp,
                      height: 12.sp,
                      bgColor: Colors.transparent,
                    )
                  : Container(
                      width: 8.sp,
                      height: 8.sp,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFCED5DF),
                      ),
                    ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.regularSmall.copyWith(
                color: isMet ? AppColors.lightText : const Color(0xFF6F7A8B),
                fontSize: 14.sp,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E7EE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -10,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _securityTipCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFBED1FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Tip:',
            style: TextStyles.boldSmall.copyWith(
              color: const Color(0xFF1D4ED8),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Use a unique password that you don't use for other accounts. Consider using a password manager to generate and store strong passwords.",
            style: TextStyles.regularSmall.copyWith(
              color: const Color(0xFF1E40AF),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final password = _newPasswordController.text;

    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Change Password',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 28.sp,
            ),
          ),
          height: 170.h,
        ),
      ),
      backgroundColor: AppColors.subPageBg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 20.h),
          child: Column(
            children: [
              _fieldCard(
                child: _passwordField(
                  controller: _currentPasswordController,
                  label: 'Current Password',
                  hint: 'Enter current password',
                  obscureText: _obscureCurrent,
                  onToggleVisibility: () {
                    setState(() => _obscureCurrent = !_obscureCurrent);
                  },
                ),
              ),
              SizedBox(height: 12.h),
              _fieldCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _passwordField(
                      controller: _newPasswordController,
                      label: 'New Password',
                      hint: 'Enter new password',
                      obscureText: _obscureNew,
                      onToggleVisibility: () {
                        setState(() => _obscureNew = !_obscureNew);
                      },
                    ),
                    SizedBox(height: 6.h),
                    _requirementItem(
                      text: 'At least 8 characters',
                      isMet: _isLongEnough,
                    ),
                    _requirementItem(
                      text: 'Contains uppercase letter',
                      isMet: _hasUpperCase,
                    ),
                    _requirementItem(
                      text: 'Contains lowercase letter',
                      isMet: _hasLowerCase,
                    ),
                    _requirementItem(
                      text: 'Contains number',
                      isMet: _hasNumber,
                    ),
                    _requirementItem(
                      text: 'Contains special character',
                      isMet: _hasSpecialCharacter,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              _fieldCard(
                child: _passwordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                  hint: 'Confirm new password',
                  obscureText: _obscureConfirm,
                  onToggleVisibility: () {
                    setState(() => _obscureConfirm = !_obscureConfirm);
                  },
                ),
              ),
              SizedBox(height: 12.h),
              _securityTipCard(),
              SizedBox(height: 18.h),
              IgnorePointer(
                ignoring: !_isPasswordValid,
                child: Opacity(
                  opacity: _isPasswordValid ? 1 : 0.55,
                  child: CustomButton(
                    onTap: _handleUpdatePassword,
                    height: 52.h,
                    borderRadius: 13.r,
                    btnColor: _isPasswordValid
                        ? AppColors.redButton
                        : const Color(0xFFCBD0D8),
                    btnText: 'Update Password',
                    textStyle: TextStyles.boldSmall.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                _isPasswordValid
                    ? 'All password conditions are satisfied.'
                    : password.isEmpty
                    ? 'Fill in the fields to enable the update button.'
                    : 'Complete all password rules and match the confirmation field.',
                textAlign: TextAlign.center,
                style: TextStyles.regularSmall.copyWith(
                  color: const Color(0xFF6D7585),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
