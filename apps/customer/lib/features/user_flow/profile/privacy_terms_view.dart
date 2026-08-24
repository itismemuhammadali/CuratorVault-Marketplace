import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box_transparent.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class PrivacyTermsView extends StatelessWidget {
  const PrivacyTermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
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
                _termsContentCard(),
                SizedBox(height: 12.h),
                _acknowledgmentCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _termsContentCard() {
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
          _section(
            title: '1. Introduction',
            paragraphs: const [
              'Welcome to Antique Marketplace ("we," "our," or "us"). These Terms of Service ("Terms") govern your access to and use of our platform, including our mobile applications and website (collectively, the "Service").',
              'By accessing or using the Service, you agree to be bound by these Terms. If you disagree with any part of the Terms, you may not access the Service.',
            ],
          ),
          _section(
            title: '2. Account Registration',
            paragraphs: const [
              'To use certain features of the Service, you must register for an account. You agree to:',
            ],
            lines: const [
              'Provide accurate, current, and complete information during registration',
              'Maintain and update your information to keep it accurate and complete',
              'Maintain the security of your password and account',
              'Accept all responsibility for all activities under your account',
              'Notify us immediately of any unauthorized use of your account',
            ],
          ),
          _section(
            title: '3. Seller Obligations',
            paragraphs: const ['As a seller on our platform, you agree to:'],
            lines: const [
              'Provide accurate descriptions and images of items for sale',
              'Honor all sales and ship items promptly',
              'Comply with all applicable laws and regulations',
              'Not sell counterfeit, stolen, or illegal items',
              'Maintain professional communication with buyers',
              'Complete the KYC verification process',
            ],
          ),
          _section(
            title: '4. Fees and Payments',
            paragraphs: const [
              'We charge the following fees for using our Service:',
            ],
            lines: const [
              'Commission: 10% of the sale price',
              'Payment Processing: 3% of the transaction amount',
              'Listing Fee: No listing fees',
            ],
            trailingParagraphs: const [
              'Payments are held in escrow until the buyer confirms receipt or 7 days after delivery, whichever comes first.',
            ],
          ),
          _section(
            title: '5. Prohibited Activities',
            paragraphs: const ['You may not:'],
            lines: const [
              'Use the Service for any illegal purpose',
              'Violate any laws in your jurisdiction',
              'Infringe upon or violate our intellectual property rights',
              'Transmit any harmful code or viruses',
              'Harass, abuse, or harm another person',
              'Attempt to circumvent any security features',
              'Engage in price manipulation or fraud',
            ],
          ),
          _section(
            title: '6. Intellectual Property',
            paragraphs: const [
              'The Service and its original content, features, and functionality are owned by Antique Marketplace and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.',
            ],
          ),
          _section(
            title: '7. Termination',
            paragraphs: const [
              'We may terminate or suspend your account and access to the Service immediately, without prior notice, for any reason, including if you breach these Terms. Upon termination, your right to use the Service will immediately cease.',
            ],
          ),
          _section(
            title: '8. Limitation of Liability',
            paragraphs: const [
              'In no event shall Antique Marketplace, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages, including loss of profits, data, use, or goodwill.',
            ],
          ),
          _section(
            title: '9. Changes to Terms',
            paragraphs: const [
              'We reserve the right to modify or replace these Terms at any time. We will notify you of any changes by posting the new Terms on this page and updating the "Last Updated" date. Your continued use of the Service after such modifications constitutes your acceptance of the new Terms.',
            ],
          ),
          _section(
            title: '10. Contact Us',
            paragraphs: const [
              'If you have any questions about these Terms, please contact us:',
            ],
            customContent: _contactCard(),
            addBottomSpacing: false,
          ),
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

  Widget _section({
    required String title,
    required List<String> paragraphs,
    List<String> lines = const [],
    List<String> trailingParagraphs = const [],
    Widget? customContent,
    bool addBottomSpacing = true,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: addBottomSpacing ? 16.h : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.boldMedium.copyWith(
              color: const Color(0xFF111827),
              fontSize: 20.sp,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          ...paragraphs.map(
            (paragraph) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Text(
                paragraph,
                style: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF374151),
                  fontSize: 14.sp,
                  height: 1.62,
                ),
              ),
            ),
          ),
          if (lines.isNotEmpty) ...[
            ...lines.map(
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
            ),
            SizedBox(height: 4.h),
          ],
          ...trailingParagraphs.map(
            (paragraph) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Text(
                paragraph,
                style: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF374151),
                  fontSize: 14.sp,
                  height: 1.62,
                ),
              ),
            ),
          ),
          if (customContent != null) customContent,
        ],
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
          _contactLine('Email:', 'legal@antiquemarketplace.com'),
          SizedBox(height: 6.h),
          _contactLine('Phone:', '+1 (555) 123-4567'),
          SizedBox(height: 6.h),
          _contactLine(
            'Address:',
            '123 Antique Street, Suite 100, New York, NY 10001',
          ),
        ],
      ),
    );
  }

  Widget _contactLine(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyles.regularMedium.copyWith(
          color: const Color(0xFF3F4A5B),
          fontSize: 14.sp,
          height: 1.45,
        ),
        children: [
          TextSpan(
            text: '$label ',
            style: TextStyles.boldSmall.copyWith(
              color: const Color(0xFF1F2937),
              fontSize: 14.sp,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _acknowledgmentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 22.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xFF2D3E55), Color(0xFF4A5F7F)],
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          IconBoxTransparent(
            icon: AppImages.documentIcon,
            color: AppColors.bodyBg,
            size: 42.h,
          ),
          SizedBox(height: 10.h),
          Text(
            'By using our Service, you acknowledge that you have read and understood these Terms of Service and agree to be bound by them.',
            textAlign: TextAlign.center,
            style: TextStyles.boldMedium.copyWith(
              color: AppColors.bodyBg,
              fontSize: 17.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
