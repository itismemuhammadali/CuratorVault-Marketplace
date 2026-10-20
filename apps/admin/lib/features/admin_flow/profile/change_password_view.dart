import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/custom_top_toast.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_handlePasswordChanged);
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_handlePasswordChanged);
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handlePasswordChanged() {
    if (mounted) setState(() {});
  }

  bool get _isLongEnough => _newPasswordController.text.length >= 8;

  bool get _hasUpperCase =>
      _upperCaseRegExp.hasMatch(_newPasswordController.text);

  bool get _hasLowerCase =>
      _lowerCaseRegExp.hasMatch(_newPasswordController.text);

  bool get _hasNumber => _numberRegExp.hasMatch(_newPasswordController.text);

  void _handleUpdatePassword() {
    FocusScope.of(context).unfocus();
    CustomTopToast.show(context, 'Password updated successfully');
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          height: 164.h,
          leading: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              width: 31.w,
              height: 31.w,
              decoration: BoxDecoration(
                color: AppColors.bodyBg.withValues(alpha: 0.22),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 19.sp,
                color: AppColors.darkText,
              ),
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Password',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldSection.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Update your security credentials',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.regularExtraSmall.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.82),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFAFAFB),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(19.w, 13.h, 19.w, 24.h),
          child: Column(
            children: [
              _securityCard(),
              SizedBox(height: 12.h),
              _passwordCard(),
              SizedBox(height: 13.h),
              _requirementsCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomActions(context),
    );
  }

  Widget _securityCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 15.h, 14.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2FF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2D4FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 18.sp,
            color: const Color(0xFF9B4DFF),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Security First',
                  style: TextStyles.boldSmall.copyWith(
                    color: const Color(0xFF7B2DF2),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'Use a strong password with a mix of letters, numbers, and symbols.',
                  style: TextStyles.mediumExtraSmall.copyWith(
                    color: const Color(0xFF9B4DFF),
                    fontSize: 12.sp,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(13.w, 14.h, 13.w, 13.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE4E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/profile_icon.svg',
                width: 18.sp,
                height: 18.sp,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF4F79FF),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Personal Information',
                style: TextStyles.boldMedium.copyWith(
                  color: const Color(0xFF344054),
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          _passwordField(
            label: 'Current Password',
            hintText: 'Enter current password',
            controller: _currentPasswordController,
            obscureText: _obscureCurrent,
            onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
          ),
          SizedBox(height: 15.h),
          _passwordField(
            label: 'New Password',
            hintText: 'Create new password',
            controller: _newPasswordController,
            obscureText: _obscureNew,
            onToggle: () => setState(() => _obscureNew = !_obscureNew),
          ),
          SizedBox(height: 15.h),
          _passwordField(
            label: 'Confirm Password',
            hintText: 'Confirm new password',
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ],
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/lock_icon.svg',
              width: 18.sp,
              height: 18.sp,
              colorFilter: const ColorFilter.mode(
                Color(0xFF8B95A5),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 7.w),
            Text(
              label,
              style: TextStyles.semiBoldExtraSmall.copyWith(
                color: const Color(0xFF222B37),
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyles.regularSmall.copyWith(
            color: const Color(0xFF344054),
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                Icons.visibility_outlined,
                size: 15.sp,
                color: const Color(0xFF8B95A5),
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 34.w,
              minHeight: 34.h,
            ),
            hintText: hintText,
            hintStyle: TextStyles.regularSmall.copyWith(
              color: const Color(0xFF7B8190),
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: const Color(0xFFF0F0F2),
            contentPadding: EdgeInsets.fromLTRB(0, 12.h, 10.w, 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: Color(0xFF4F79FF)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _requirementsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(13.w, 15.h, 13.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE4E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements',
            style: TextStyles.boldMedium.copyWith(
              color: const Color(0xFF344054),
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 17.h),
          _requirementItem(text: 'At least 8 characters', isMet: _isLongEnough),
          _requirementItem(text: 'One uppercase letter', isMet: _hasUpperCase),
          _requirementItem(text: 'One lowercase letter', isMet: _hasLowerCase),
          _requirementItem(text: 'One number', isMet: _hasNumber),
        ],
      ),
    );
  }

  Widget _requirementItem({required String text, required bool isMet}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Container(
            width: 13.w,
            height: 13.w,
            decoration: BoxDecoration(
              color: isMet ? const Color(0xFF22C55E) : const Color(0xFFD7DCE3),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.regularExtraSmall.copyWith(
                color: const Color(0xFF667085),
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomActions(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bodyBg,
        border: Border(top: BorderSide(color: Color(0xFFE9EAED))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(13.w, 10.h, 13.w, 10.h),
          child: Row(
            children: [
              Expanded(
                child: _actionButton(
                  label: 'Cancel',
                  textColor: const Color(0xFF222B37),
                  background: AppColors.bodyBg,
                  borderColor: const Color(0xFFE4E6EA),
                  onTap: () => context.pop(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _actionButton(
                  label: 'Update Password',
                  textColor: AppColors.bodyBg,
                  background: AppColors.gradientColor2,
                  useSvgIcon: true,
                  onTap: _handleUpdatePassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color textColor,
    required Color background,
    required VoidCallback onTap,
    Color borderColor = Colors.transparent,
    IconData? icon,
    bool useSvgIcon = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (useSvgIcon) ...[
              SvgPicture.asset(
                'assets/icons/lock_icon.svg',
                width: 16.sp,
                height: 16.sp,
                colorFilter: ColorFilter.mode(
                  textColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
            ] else if (icon != null) ...[
              Icon(icon, size: 16.sp, color: textColor),
              SizedBox(width: 8.w),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.semiBoldExtraSmall.copyWith(
                  color: textColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
