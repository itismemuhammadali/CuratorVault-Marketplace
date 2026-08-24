import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class TwoFactorAuthView extends StatefulWidget {
  final bool isEnabled;

  const TwoFactorAuthView({super.key, this.isEnabled = false});

  @override
  State<TwoFactorAuthView> createState() => _TwoFactorAuthViewState();
}

class _TwoFactorAuthViewState extends State<TwoFactorAuthView> {
  late bool _is2faEnabled;

  @override
  void initState() {
    super.initState();
    _is2faEnabled = widget.isEnabled;
  }

  Widget _statusCard() {
    if (!_is2faEnabled) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: AppColors.redButton,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              height: 52.w,
              width: 52.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: IconBox(
                icon: AppImages.sheildIcon,
                width: 52.w,
                height: 52.w,
                bgColor: Colors.transparent,
                iconColor: AppColors.bodyBg,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Not Protected',
                    style: TextStyles.boldLarge.copyWith(
                      color: AppColors.bodyBg,
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '2FA is inactive',
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.bodyBg.withValues(alpha: 0.85),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconBox(
                icon: AppImages.shieldImg,
                height: 44.w,
                width: 44.w,
                bgColor: Colors.white.withValues(alpha: 0.25),
                iconColor: AppColors.bodyBg,
                borderRadius: 999.r,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Protected',
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.bodyBg,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '2FA is active',
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.bodyBg.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Image.asset(
                  AppImages.circularTickIcon,
                  width: 18.sp,
                  height: 18.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Your account is protected with 2FA',
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.bodyBg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E7EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What is Two-Factor Authentication?',
            style: TextStyles.boldMedium.copyWith(
              color: AppColors.lightText,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Two-factor authentication (2FA) adds an extra layer of security to your account. In addition to your password, you\'ll need to enter a code from your authenticator app.',
            style: TextStyles.regularSmall.copyWith(
              color: AppColors.greyText,
              height: 1.45,
            ),
          ),
          SizedBox(height: 14.h),
          _benefitItem(
            iconAsset: AppImages.mobileIcon,
            title: 'Use an Authenticator App',
            subtitle: 'Google Authenticator, Authy, or Microsoft Authenticator',
            color: const Color(0xFFDBEAFE),
            iconColor: const Color(0xFF155DFC),
          ),
          SizedBox(height: 10.h),
          _benefitItem(
            iconAsset: AppImages.keyIcon,
            title: 'Secure Your Account',
            subtitle:
                'Even if someone knows your password, they can\'t access your account',
            color: const Color(0xFFDCFCE7),
            iconColor: AppColors.greenSuccess,
          ),
          SizedBox(height: 10.h),
          _benefitItem(
            iconAsset: AppImages.sheildIcon,
            title: 'Industry Standard',
            subtitle: 'Used by banks and major platforms worldwide',
            color: const Color(0xFFDBEAFE),
            iconColor: const Color(0xFF155DFC),
          ),
        ],
      ),
    );
  }

  Widget _benefitItem({
    required String iconAsset,
    required String title,
    required String subtitle,
    Color color = const Color(0xFF3B82F6),
    Color iconColor = const Color(0xFF155DFC),
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconBox(
          icon: iconAsset,
          height: 28.w,
          width: 28.w,
          bgColor: color,
          borderRadius: 999.r,
          iconColor: iconColor,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.boldSmall.copyWith(
                  color: AppColors.lightText,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyles.regularSmall.copyWith(
                  color: AppColors.greyText,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Two-Factor Authentication',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 25.sp,
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
              _statusCard(),
              SizedBox(height: 14.h),
              _infoCard(),
              SizedBox(height: 18.h),
              if (!_is2faEnabled)
                CustomButton(
                  onTap: () => context.push(
                    '/dealer/app-settings/two-factor-auth/setup',
                  ),
                  height: 52.h,
                  borderRadius: 13.r,
                  btnColor: AppColors.redButton,
                  btnText: 'Enable Two-Factor Authentication',
                  textStyle: TextStyles.boldSmall.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                )
              else
                CustomButton(
                  onTap: () {
                    setState(() => _is2faEnabled = false);
                  },
                  height: 52.h,
                  borderRadius: 13.r,
                  btnColor: const Color(0xFFEF4444),
                  btnText: 'Disable Two-Factor Authentication',
                  textStyle: TextStyles.boldSmall.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
