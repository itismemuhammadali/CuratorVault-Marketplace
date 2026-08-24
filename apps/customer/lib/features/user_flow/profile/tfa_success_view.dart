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

class TFASuccessView extends StatelessWidget {
  const TFASuccessView({super.key});

  Widget _statusCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff00C950), Color(0xff00A63E)],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconBox(
                icon: AppImages.shieldImg,
                bgColor: Colors.white.withValues(alpha: 0.25),
                iconColor: AppColors.bodyBg,
                height: 55.h,
                width: 55.h,
                borderRadius: 999.r,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Protected',
                      style: TextStyles.boldLarge.copyWith(
                        color: AppColors.bodyBg,
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '2FA is active',
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
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                IconBox(
                  icon: AppImages.tickIcon,
                  width: 20.sp,
                  height: 20.sp,
                  bgColor: Colors.transparent,
                  iconColor: AppColors.bodyBg,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'Your account is protected with 2FA',
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.bodyBg,
                      fontSize: 13.sp,
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
    Color iconColor = AppColors.bodyBg,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   height: 28.w,
        //   width: 28.w,
        //   decoration: BoxDecoration(
        //     color: color.withValues(alpha: 0.15),
        //     shape: BoxShape.circle,
        //   ),
        //   child: Image.asset(iconAsset, width: 16.sp, height: 16.sp, color: iconColor),
        // ),
        IconBox(
          icon: iconAsset,
          width: 30.h,
          height: 30.h,
          bgColor: color,
          iconColor: iconColor,
          borderRadius: 999.r,
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
              CustomButton(
                onTap: () {
                  context.pop();
                  context.pop();
                  context.pop();
                  context.pop();
                },
                height: 52.h,
                borderRadius: 13.r,
                btnColor: AppColors.redButton,
                btnText: 'Back to Settings',
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
