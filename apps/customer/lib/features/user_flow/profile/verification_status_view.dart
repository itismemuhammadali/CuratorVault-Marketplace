import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class VerificationStatusView extends StatelessWidget {
  const VerificationStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Verification Status',
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
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 92.w,
                  height: 92.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCFF3DD),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor.withValues(alpha: 0.10),
                        blurRadius: 16,
                        spreadRadius: -10,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.verified_rounded,
                    color: const Color(0xFF0BA84B),
                    size: 48.sp,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: Text(
                  'Account Verified',
                  style: TextStyles.boldLarge.copyWith(
                    color: AppColors.lightText,
                    fontSize: 20.sp,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  'Your dealer account has been verified and\napproved',
                  textAlign: TextAlign.center,
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.greyText,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F8ED),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFABE4BE)),
                ),
                child: Column(
                  children: [
                    _statusRow('Verified Since', 'January 15, 2024'),
                    SizedBox(height: 10.h),
                    _statusRow(
                      'Account Status',
                      'Active',
                      valueColor: const Color(0xFF07A547),
                      showValueIcon: true,
                    ),
                    SizedBox(height: 10.h),
                    _statusRow(
                      'Trust Score',
                      'Excellent (98%)',
                      valueColor: const Color(0xFF07A547),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'Verification Items',
                style: TextStyles.boldMedium.copyWith(
                  color: AppColors.lightText,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 10.h),
              ...const [
                _VerificationItem(
                  title: 'Email Verified',
                  subtitle: 'dealer@antiques.com',
                  verifiedOn: 'Verified on Jan 10, 2024',
                ),
                _VerificationItem(
                  title: 'Identity Verified',
                  subtitle: 'Government ID confirmed',
                  verifiedOn: 'Verified on Jan 12, 2024',
                ),
                _VerificationItem(
                  title: 'Business License',
                  subtitle: 'Valid business registration',
                  verifiedOn: 'Verified on Jan 13, 2024',
                ),
                _VerificationItem(
                  title: 'Bank Account Connected',
                  subtitle: 'Payment account verified',
                  verifiedOn: 'Verified on Jan 15, 2024',
                ),
              ],
              SizedBox(height: 12.h),
              _infoBlock(
                title: 'Security & Compliance',
                titleColor: const Color(0xFF2149B2),
                bgColor: const Color(0xFFE9F0FF),
                borderColor: const Color(0xFFBBD0FF),
                icon: Icons.shield_outlined,
                points: const [
                  'KYC (Know Your Customer) requirements met',
                  'AML (Anti-Money Laundering) screening passed',
                  'Background check completed successfully',
                  'All documents securely encrypted and stored',
                ],
              ),
              SizedBox(height: 12.h),
              _infoBlock(
                title: 'Verified Seller Benefits',
                titleColor: const Color(0xFF6B21A8),
                bgColor: const Color(0xFFF3EAFF),
                borderColor: const Color(0xFFD9BFFF),
                icon: Icons.auto_awesome,
                points: const [
                  'Verified badge displayed on all your listings',
                  'Higher visibility in search results',
                  'Access to premium seller tools and analytics',
                  'Faster payment processing and withdrawals',
                  'Priority customer support',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusRow(
    String label,
    String value, {
    Color? valueColor,
    bool showValueIcon = false,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyles.mediumMedium.copyWith(color: AppColors.lightText),
        ),
        const Spacer(),
        if (showValueIcon) ...[
          Icon(
            Icons.check_circle_outline,
            color: valueColor ?? AppColors.lightText,
            size: 17.sp,
          ),
          SizedBox(width: 4.w),
        ],
        Text(
          value,
          style: TextStyles.semiBoldMedium.copyWith(
            color: valueColor ?? AppColors.lightText,
          ),
        ),
      ],
    );
  }

  Widget _infoBlock({
    required String title,
    required Color titleColor,
    required Color bgColor,
    required Color borderColor,
    required IconData icon,
    required List<String> points,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Icon(icon, color: titleColor, size: 20.sp),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.boldMedium.copyWith(
                        color: titleColor,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ...points.map(
                      (point) => Padding(
                        padding: EdgeInsets.only(bottom: 7.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5.h),
                              child: Icon(
                                Icons.check_circle_outline,
                                size: 16.sp,
                                color: titleColor,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                point,
                                style: TextStyles.regularMedium.copyWith(
                                  color: titleColor,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerificationItem extends StatelessWidget {
  const _VerificationItem({
    required this.title,
    required this.subtitle,
    required this.verifiedOn,
  });

  final String title;
  final String subtitle;
  final String verifiedOn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFDDE2EA)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: const Color(0xFFCFF3DD),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.circularTickIcon,
                  width: 22.w,
                  height: 22.h,
                  color: const Color(0xFF07A547),
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
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.greyText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    verifiedOn,
                    style: TextStyles.mediumMedium.copyWith(
                      color: const Color(0xFF07A547),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
