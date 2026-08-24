import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class PrivacyAndTermsView extends StatelessWidget {
  const PrivacyAndTermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF8E8C7).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: const Color(0xFFF8E8C7),
                  size: 20.sp,
                ),
              ),
            ),
          ),
          title: Text(
            'Privacy & Terms',
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
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Your Privacy Matters
              _sectionCard(
                useGradient: true,
                iconColor: const Color(0xFF2563EB),
                icon: Icons.shield_outlined,
                title: 'Your Privacy Matters',
                description:
                    'We\'re committed to protecting your personal information on all our platforms and devices.',
                date: 'Last updated: December 15, 2024',
              ),
              SizedBox(height: 16.h),
              // Data Protection - shield_protection_icon
              _sectionCard(
                useGradient: false,
                iconColor: const Color(0xFFC65A46),
                icon: Icons.shield_outlined,
                svgPath: 'assets/icons/shield_protection_icon.svg',
                title: 'Data Protection',
                description:
                    'We take your privacy seriously. All personal information is protected using industry-standard 256-bit encryption and secured with advanced protection methods.',
              ),
              SizedBox(height: 16.h),
              // What We Collect - eye icon
              _sectionCardWithBullets(
                iconColor: const Color(0xFFC65A46),
                icon: Icons.visibility_outlined,
                title: 'What We Collect',
                description:
                    'We collect information you provide when SIGHTS at account registration, purchases, or when interacting with our platform:',
                bullets: [
                  'Identity information (names, emails)',
                  'Payment and billing information',
                  'Browsing and transaction history',
                  'Device information and analytics',
                  'Cookies data tracking preferences',
                ],
              ),
              SizedBox(height: 16.h),
              // How We Use Your Data - lock_icon
              _sectionCardWithBullets(
                iconColor: const Color(0xFFC65A46),
                icon: Icons.lock_outlined,
                svgPath: 'assets/icons/lock_icon.svg',
                title: 'How We Use Your Data',
                description:
                    'We collect information you provide when SIGHTS at account registration, purchases, or when interacting with our platform:',
                bullets: [
                  'Process transactions and deliver services',
                  'Provide customer support and updates',
                  'Personalize your experience',
                  'Monitor for fraud and security issues',
                  'Improve our services and platform',
                ],
              ),
              SizedBox(height: 16.h),
              // Your Rights - document_icon
              _sectionCardWithBullets(
                iconColor: const Color(0xFFC65A46),
                icon: Icons.description_outlined,
                svgPath: 'assets/icons/document_icon.svg',
                title: 'Your Rights',
                description:
                    'You have complete control over your data. You can:',
                bullets: [
                  'Access your complete data',
                  'Request data correction or updates',
                  'Export your data',
                  'Request deletion of your communications',
                  'Opt out of promotional emails',
                ],
              ),
              SizedBox(height: 16.h),
              // Cookies & Tracking - exclamation_circle_icon
              _sectionCardWithBullets(
                iconColor: const Color(0xFFC65A46),
                icon: Icons.info_outlined,
                svgPath: 'assets/icons/exclamation_circle_icon.svg',
                isInverted: false,
                title: 'Cookies & Tracking',
                description:
                    'We understand how you use our services via cookies and analytics to give you better experience. You can understand these uses and customize settings:',
                bullets: [
                  'Analytics to improve user experience',
                  'Performance monitoring and analytics',
                  'Marketing and retargeting analytics',
                  'Security and fraud prevention systems',
                ],
              ),
              SizedBox(height: 20.h),
              // Questions section
              _questionsSection(),
              SizedBox(height: 20.h),
              // Terms of Service
              _termsOfServiceSection(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sectionCard({
    required Color iconColor,
    required IconData icon,
    required String title,
    required String description,
    String? date,
    String? svgPath,
    bool useGradient = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: useGradient
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2D3E55), Color(0xFF1A2332)],
                  )
                : null,
            color: !useGradient ? AppColors.bodyBg : null,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: useGradient
                  ? Colors.transparent
                  : AppColors.greyText.withValues(alpha: 0.1),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Stack(
              children: [
                // Background icon
                if (useGradient)
                  Positioned(
                    right: -15.w,
                    top: -10.h,
                    child: Icon(
                      icon,
                      size: 115.sp,
                      color: const Color(0xFFD4A574).withValues(alpha: 0.1),
                    ),
                  ),
                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: useGradient
                                ? const Color(0xFFD4A574).withValues(alpha: 0.2)
                                : const Color(0xFFC65A46).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child: svgPath != null
                                ? SvgPicture.asset(
                                    svgPath,
                                    width: 22.sp,
                                    height: 22.sp,
                                    colorFilter: ColorFilter.mode(
                                      useGradient ? const Color(0xFFD4A574) : const Color(0xFFC65A46),
                                      BlendMode.srcIn,
                                    ),
                                  )
                                : Icon(
                                    icon,
                                    color: useGradient ? const Color(0xFFD4A574) : const Color(0xFFC65A46),
                                    size: 22.sp,
                                  ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyles.boldLarge.copyWith(
                                  color: useGradient ? Colors.white : AppColors.lightText,
                                  fontSize: 22.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      description,
                      style: TextStyles.regularSmall.copyWith(
                        color: useGradient
                            ? const Color(0xFFD4A574)
                            : AppColors.greyText,
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (date != null) ...[
          SizedBox(height: 8.h),
          Center(
            child: Text(
              date,
              style: TextStyles.regularExtraSmall.copyWith(
                color: AppColors.greyText.withValues(alpha: 0.7),
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ],
    );
  }

  static Widget _sectionCardWithBullets({
    required Color iconColor,
    required IconData icon,
    required String title,
    required String description,
    required List<String> bullets,
    String? svgPath,
    bool isInverted = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.greyText.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFC65A46).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Transform.scale(
                    scaleX: isInverted ? -1 : 1,
                    child: svgPath != null
                        ? SvgPicture.asset(
                            svgPath,
                            width: 22.sp,
                            height: 22.sp,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFC65A46),
                              BlendMode.srcIn,
                            ),
                          )
                        : Icon(
                            icon,
                            color: const Color(0xFFC65A46),
                            size: 22.sp,
                          ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.lightText,
                        fontSize: 17.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      description,
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...bullets.map((bullet) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h, left: 56.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.greyText,
                      fontSize: 14.sp,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      bullet,
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  static Widget _questionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Questions about our privacy policy?',
          style: TextStyles.boldMedium.copyWith(
            color: AppColors.lightText,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              'Contact Privacy Team',
              style: TextStyles.boldMedium.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _termsOfServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Terms of Service',
          style: TextStyles.boldMedium.copyWith(
            color: AppColors.lightText,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'By using these Vintage Vibes, you agree to our Terms. We collect personal information on our marketplace sites and mobile apps in accordance with this privacy notice and our terms of service.',
          style: TextStyles.regularSmall.copyWith(
            color: AppColors.greyText,
            fontSize: 14.sp,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
