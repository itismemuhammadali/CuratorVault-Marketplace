import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class PrivacyTermsView extends StatelessWidget {
  const PrivacyTermsView({super.key});

  @override
  Widget build(BuildContext context) {
    const sections = [
      _PrivacySection(
        title: 'Data Protection',
        icon: Icons.shield_outlined,
        body:
            'We take your privacy seriously. All personal information is encrypted using industry-standard SSL/TLS protocols. Your data is stored securely and never shared with third parties without your explicit consent.',
      ),
      _PrivacySection(
        title: 'What We Collect',
        icon: Icons.remove_red_eye_outlined,
        body:
            'We collect information you provide when creating an account, scanning items, making purchases, and engaging with our community. This includes your name, email, browsing history, and scanned items.',
        bullets: [
          'Account information (name, email, password)',
          'Scanned antique items and collections',
          'Purchase history and saved items',
          'Community interactions and messages',
          'Device information and usage data',
        ],
      ),
      _PrivacySection(
        title: 'How We Use Your Data',
        icon: Icons.lock_outline_rounded,
        body:
            'Your information helps us provide personalized experiences, improve our AI recognition, process transactions, and send relevant updates.',
        bullets: [
          'Personalize your antique discovery experience',
          'Process marketplace transactions',
          'Improve AI recognition accuracy',
          'Send notifications about your activity',
          'Provide customer support',
        ],
      ),
      _PrivacySection(
        title: 'Your Rights',
        icon: Icons.description_outlined,
        body:
            'You have complete control over your data. You can access, modify, or delete your information at any time through your account settings.',
        bullets: [
          'Access your personal data',
          'Request data correction or deletion',
          'Export your data',
          'Opt out of marketing communications',
          'Delete your account permanently',
        ],
      ),
      _PrivacySection(
        title: 'Cookies & Tracking',
        icon: Icons.info_outline_rounded,
        body:
            'We use cookies to enhance your experience and understand how you use our app. You can control cookie preferences in your device settings.',
        bullets: [
          'Essential cookies for app functionality',
          'Analytics to improve user experience',
          'Preference cookies to remember your settings',
          'No third-party advertising cookies',
        ],
      ),
    ];

    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Privacy and Terms',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 28.sp,
            ),
          ),
          bottomWidget: _searchBar(),
          height: 210.h,
        ),
      ),
      backgroundColor: AppColors.subPageBg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _heroCard(),
              SizedBox(height: 18.h),
              Center(
                child: Text(
                  'Last updated: December 16, 2024',
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.gradientColor1,
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              ...sections.map(
                (section) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _sectionCard(section),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.bodyBg.withValues(alpha: 0.35),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: AppColors.bodyBg.withValues(alpha: 0.55),
            size: 22.sp,
          ),
          SizedBox(width: 10.w),
          Text(
            'Search for help...',
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.bodyBg.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientColor2, AppColors.gradientColor1],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.14),
            blurRadius: 22.r,
            spreadRadius: -10,
            offset: Offset(0, 14.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -4.w,
            top: 0,
            child: Icon(
              Icons.shield_outlined,
              size: 112.sp,
              color: AppColors.bodyBg.withValues(alpha: 0.10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54.w,
                height: 54.w,
                decoration: BoxDecoration(
                  color: AppColors.bodyBg.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: const Color(0xFFE0A766),
                  size: 26.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Your Privacy Matters',
                style: TextStyles.boldLarge.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 26.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "We're committed to protecting your personal information and being transparent about how we use it.",
                style: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFFE0A766),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(_PrivacySection section) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.shadowColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 18.r,
            spreadRadius: -12,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCEFEB),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  section.icon,
                  color: AppColors.redButton,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      section.body,
                      style: TextStyles.regularMedium.copyWith(
                        color: const Color(0xFF6C778B),
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (section.bullets.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Container(
              height: 1,
              color: AppColors.shadowColor.withValues(alpha: 0.10),
            ),
            SizedBox(height: 14.h),
            ...section.bullets.map(
              (bullet) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: AppColors.redButton,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        bullet,
                        style: TextStyles.regularMedium.copyWith(
                          color: const Color(0xFF6C778B),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrivacySection {
  const _PrivacySection({
    required this.title,
    required this.icon,
    required this.body,
    this.bullets = const [],
  });

  final String title;
  final IconData icon;
  final String body;
  final List<String> bullets;
}
