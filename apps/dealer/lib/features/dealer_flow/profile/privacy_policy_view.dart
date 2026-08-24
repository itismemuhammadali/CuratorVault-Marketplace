import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box_transparent.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Privacy Policy',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 28.sp,
            ),
          ),
          bottomWidget: _headerActions(),
          height: 218.h,
        ),
      ),
      backgroundColor: AppColors.subPageBg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 16.h),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(color: const Color(0xFFD5D8DC)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _policyContentCard(),
                SizedBox(height: 12.h),
                _privacyMattersCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerActions() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        children: [
          Expanded(
            child: _headerActionButton(
              icon: AppImages.downloadIcon,
              label: 'Download',
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _headerActionButton(
              icon: AppImages.shareIcon,
              label: 'Share',
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerActionButton({required String icon, required String label}) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.bodyBg.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconBoxTransparent(icon: icon, color: AppColors.bodyBg, size: 14.h),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyles.mediumSmall.copyWith(
              color: AppColors.bodyBg,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _policyContentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD7DBE1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _updatedPill(),
          SizedBox(height: 18.h),
          _sectionTitle('Introduction'),
          _bodyText(
            'Antique Marketplace ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services.',
          ),
          _bodyText(
            'Please read this Privacy Policy carefully. By using our Service, you agree to the collection and use of information in accordance with this policy.',
            bottom: 14,
          ),
          _sectionHeadingWithIcon(
            icon: AppImages.documentIcon,
            title: 'Information We Collect',
          ),
          SizedBox(height: 10.h),
          _subInfoCard(
            icon: AppImages.iconUser,
            iconColor: const Color(0xFF2563EB),
            title: 'Personal Information',
            intro: 'We collect information that you provide directly to us:',
            points: const [
              'Name, email address, phone number',
              'Business information and tax details',
              'Bank account information for payouts',
              'Government-issued ID for verification (KYC)',
              'Profile photos and store information',
            ],
          ),
          SizedBox(height: 10.h),
          _subInfoCard(
            icon: AppImages.eyeOutlinedIcon,
            iconColor: const Color(0xFF16A34A),
            title: 'Usage Information',
            intro:
                'We automatically collect certain information about your device and how you interact with our Service:',
            points: const [
              'Device information (model, OS version)',
              'IP address and location data',
              'App usage statistics and analytics',
              'Cookies and similar tracking technologies',
            ],
          ),
          SizedBox(height: 10.h),
          _subInfoCard(
            icon: AppImages.globeIcon,
            iconColor: const Color(0xFFA855F7),
            title: 'Transaction Information',
            intro: 'When you conduct transactions on our platform:',
            points: const [
              'Purchase and sales history',
              'Payment information (processed securely)',
              'Shipping and delivery details',
              'Communication with buyers and sellers',
            ],
          ),
          SizedBox(height: 14.h),
          _sectionTitle('How We Use Your Information'),
          _bodyText('We use the information we collect to:'),
          _lineList(const [
            'Provide, maintain, and improve our Service',
            'Process transactions and send confirmations',
            'Verify your identity and prevent fraud',
            'Send you technical notices and support messages',
            'Communicate with you about products, services, and promotions',
            'Monitor and analyze trends and usage',
            'Comply with legal obligations',
          ]),
          SizedBox(height: 8.h),
          _sectionTitle('Information Sharing and Disclosure'),
          _bodyText(
            'We may share your information in the following circumstances:',
          ),
          _labeledLine(
            'With other users:',
            'Your store profile and listings are visible to buyers',
          ),
          _labeledLine(
            'Service providers:',
            'Third parties that help us operate our Service (payment processors, hosting providers)',
          ),
          _labeledLine(
            'Legal requirements:',
            'When required by law or to protect our rights',
          ),
          _labeledLine(
            'Business transfers:',
            'In connection with a merger, sale, or acquisition',
          ),
          _labeledLine(
            'With your consent:',
            'When you explicitly agree to share your information',
          ),
          SizedBox(height: 8.h),
          _sectionHeadingWithIcon(
            icon: AppImages.shieldImg,
            title: 'Data Security',
          ),
          SizedBox(height: 8.h),
          _bodyText(
            'We implement appropriate technical and organizational measures to protect your information:',
          ),
          _greenSecurityCard(),
          SizedBox(height: 10.h),
          _bodyText(
            'However, no method of transmission over the Internet is 100% secure. While we strive to protect your information, we cannot guarantee its absolute security.',
          ),
          _sectionTitle('Your Privacy Rights'),
          _bodyText(
            'Depending on your location, you may have the following rights:',
          ),
          _labeledLine(
            'Access:',
            'Request a copy of your personal information',
          ),
          _labeledLine(
            'Correction:',
            'Request correction of inaccurate information',
          ),
          _labeledLine('Deletion:', 'Request deletion of your information'),
          _labeledLine('Portability:', 'Request transfer of your data'),
          _labeledLine('Opt-out:', 'Unsubscribe from marketing communications'),
          _labeledLine('Restriction:', 'Limit how we use your information'),
          SizedBox(height: 8.h),
          _sectionTitle('Cookies and Tracking Technologies'),
          _bodyText(
            'We use cookies and similar tracking technologies to track activity on our Service and store certain information. You can instruct your device to refuse all cookies or indicate when a cookie is being sent. However, some features of our Service may not function properly without cookies.',
          ),
          _sectionTitle('Children\'s Privacy'),
          _bodyText(
            'Our Service is not intended for children under 18 years of age. We do not knowingly collect personal information from children under 18. If you become aware that a child has provided us with personal information, please contact us immediately.',
          ),
          _sectionTitle('Changes to This Privacy Policy'),
          _bodyText(
            'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date. You are advised to review this Privacy Policy periodically for any changes.',
          ),
          _sectionHeadingWithIcon(
            icon: AppImages.notificationBellIcon,
            title: 'Contact Us',
          ),
          SizedBox(height: 8.h),
          _bodyText(
            'If you have any questions about this Privacy Policy or want to exercise your privacy rights, please contact us:',
          ),
          _contactCard(),
        ],
      ),
    );
  }

  Widget _updatedPill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.infoCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.infoCardBorder),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyles.regularMedium.copyWith(
            color: const Color(0xFF274C9D),
            fontSize: 15.sp,
          ),
          children: [
            TextSpan(
              text: 'Last Updated: ',
              style: TextStyles.boldSmall.copyWith(
                color: const Color(0xFF1E4FB6),
                fontSize: 14.sp,
              ),
            ),
            const TextSpan(text: 'January 1, 2024'),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyles.boldMedium.copyWith(
          color: const Color(0xFF111827),
          fontSize: 20.sp,
          height: 1.25,
        ),
      ),
    );
  }

  Widget _sectionHeadingWithIcon({
    required String icon,
    required String title,
  }) {
    return Row(
      children: [
        IconBoxTransparent(
          icon: icon,
          color: const Color(0xFF1F2937),
          size: 18.h,
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyles.boldMedium.copyWith(
            color: const Color(0xFF111827),
            fontSize: 20.sp,
          ),
        ),
      ],
    );
  }

  Widget _bodyText(String text, {double bottom = 12}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom.h),
      child: Text(
        text,
        style: TextStyles.regularMedium.copyWith(
          color: const Color(0xFF374151),
          fontSize: 14.sp,
          height: 1.62,
        ),
      ),
    );
  }

  Widget _lineList(List<String> lines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines
          .map(
            (line) => Padding(
              padding: EdgeInsets.only(left: 12.w, bottom: 8.h),
              child: Text(
                line,
                style: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF374151),
                  fontSize: 14.sp,
                  height: 1.55,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _labeledLine(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
        text: TextSpan(
          style: TextStyles.regularMedium.copyWith(
            color: const Color(0xFF374151),
            fontSize: 14.sp,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: '$label\n',
              style: TextStyles.boldSmall.copyWith(
                color: const Color(0xFF1F2937),
                fontSize: 14.sp,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _subInfoCard({
    required String icon,
    required Color iconColor,
    required String title,
    required String intro,
    required List<String> points,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEFF2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD7DBE1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBoxTransparent(icon: icon, color: iconColor, size: 16.h),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyles.boldMedium.copyWith(
                  color: const Color(0xFF111827),
                  fontSize: 17.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            intro,
            style: TextStyles.regularMedium.copyWith(
              color: const Color(0xFF374151),
              fontSize: 13.sp,
              height: 1.52,
            ),
          ),
          SizedBox(height: 6.h),
          ...points.map(
            (point) => Padding(
              padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
              child: Text(
                point,
                style: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF374151),
                  fontSize: 13.sp,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _greenSecurityCard() {
    final items = [
      _SecurityItem(
        icon: AppImages.shieldImg,
        text: 'End-to-end encryption for sensitive data',
      ),
      _SecurityItem(
        icon: AppImages.lockIcon,
        text: 'Secure socket layer (SSL) technology',
      ),
      _SecurityItem(
        icon: AppImages.savedDiskIcon,
        text: 'Regular security audits and updates',
      ),
      _SecurityItem(
        icon: AppImages.iconUser,
        text: 'Access controls and authentication',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFAF4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF9AE6B4)),
      ),
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    IconBoxTransparent(
                      icon: item.icon,
                      color: const Color(0xFF16A34A),
                      size: 15.h,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        item.text,
                        style: TextStyles.regularMedium.copyWith(
                          color: const Color(0xFF374151),
                          fontSize: 13.sp,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _contactCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD5D9DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Team:',
            style: TextStyles.boldSmall.copyWith(
              color: const Color(0xFF1F2937),
              fontSize: 14.sp,
            ),
          ),
          Text(
            'privacy@antiquemarketplace.com',
            style: TextStyles.regularMedium.copyWith(
              color: const Color(0xFF374151),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Phone: +1 (555) 123-4567',
            style: TextStyles.boldSmall.copyWith(
              color: const Color(0xFF1F2937),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Address:',
            style: TextStyles.boldSmall.copyWith(
              color: const Color(0xFF1F2937),
              fontSize: 14.sp,
            ),
          ),
          Text(
            '123 Antique Street, Suite 100, New York, NY 10001',
            style: TextStyles.regularMedium.copyWith(
              color: const Color(0xFF374151),
              fontSize: 14.sp,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _privacyMattersCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 22.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2D3E55), Color(0xFF4A5F7F)],
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          IconBoxTransparent(
            icon: AppImages.shieldImg,
            color: AppColors.bodyBg,
            size: 42.h,
          ),
          SizedBox(height: 10.h),
          Text(
            'Your Privacy Matters to Us',
            textAlign: TextAlign.center,
            style: TextStyles.boldMedium.copyWith(
              color: AppColors.bodyBg,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'We are committed to protecting your personal information and being transparent about how we use it.',
            textAlign: TextAlign.center,
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.bodyBg.withValues(alpha: 0.92),
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityItem {
  const _SecurityItem({required this.icon, required this.text});

  final String icon;
  final String text;
}
