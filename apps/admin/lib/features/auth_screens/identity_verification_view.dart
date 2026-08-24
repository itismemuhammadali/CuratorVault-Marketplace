import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/auth_screens/dealer_onboarding_scaffold.dart';

class IdentityVerificationView extends StatelessWidget {
  const IdentityVerificationView({super.key});

  Widget _documentCard({required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE7D9CB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F5F8),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: SvgPicture.asset(
                    'assets/icons/document_icon.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.greyText,
                      BlendMode.srcIn,
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
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth * 0.55,
                          child: CustomButton(
                            onTap: () {},
                            height: 40.h,
                            borderRadius: 10.r,
                            btnColor: AppColors.gradientColor1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/upload_icon.svg',
                                    width: 16.sp,
                                    height: 16.sp,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),

                                  SizedBox(width: 6.w),
                                  Text(
                                    'Upload Document',
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyles.mediumSmall.copyWith(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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

  Widget _guideline(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: const Color(0xFF34B25A),
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.regularSmall.copyWith(
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
    return DealerOnboardingScaffold(
      title: 'Identity Verification',
      subtitle: 'Upload documents to verify your identity',
      step: 4,
      totalSteps: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFB7D3FF)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xFF2E5AAC),
                  size: 18.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyles.regularSmall.copyWith(
                        color: const Color(0xFF2E5AAC),
                        height: 1.4,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Why We Need This\n',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text:
                              'KYC verification helps us maintain a trusted marketplace and comply with regulations. Your documents are encrypted and securely stored.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardSpacing = 12.h;
              final isNarrow = constraints.maxWidth < 420;

              if (isNarrow) {
                return Column(
                  children: [
                    _documentCard(
                      title: 'Government ID',
                      subtitle: "Driver's License, Passport, or National ID",
                    ),
                    SizedBox(height: cardSpacing),
                    _documentCard(
                      title: 'Business License',
                      subtitle: 'Business registration or reseller certificate',
                    ),
                    SizedBox(height: cardSpacing),
                    _documentCard(
                      title: 'Proof of Address',
                      subtitle:
                          'Utility bill, bank statement (within 3 months)',
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  _documentCard(
                    title: 'Government ID',
                    subtitle: "Driver's License, Passport, or National ID",
                  ),
                  SizedBox(height: cardSpacing),
                  _documentCard(
                    title: 'Business License',
                    subtitle: 'Business registration or reseller certificate',
                  ),
                  SizedBox(height: cardSpacing),
                  _documentCard(
                    title: 'Proof of Address',
                    subtitle: 'Utility bill, bank statement (within 3 months)',
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 18.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Guidelines',
                  style: TextStyles.boldMedium.copyWith(
                    color: AppColors.lightText,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                _guideline('Documents must be clear and readable'),
                _guideline('All four corners of the document must be visible'),
                _guideline('Accepted formats: JPG, PNG, PDF (max 10MB each)'),
                _guideline('Documents must be valid and not expired'),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          CustomButton(
            onTap: () => context.push('/dealer/payout-details'),
            height: 50.h,
            borderRadius: 14.r,
            btnColor: AppColors.gradientColor1,
            btnText: 'Upload All Documents First',
            textStyle: TextStyles.mediumMedium.copyWith(
              color: Colors.white,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}
