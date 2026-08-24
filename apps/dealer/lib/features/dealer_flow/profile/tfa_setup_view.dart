import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class TFASetupView extends StatelessWidget {
  const TFASetupView({super.key});

  Widget _stepCard({
    required int stepNumber,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 32.w,
            width: 32.w,
            decoration: BoxDecoration(
              color: const Color(0xFF2D3E55),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: TextStyles.boldSmall.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
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
                  style: TextStyles.boldSmall.copyWith(
                    color: AppColors.lightText,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyles.regularSmall.copyWith(
                    color: AppColors.greyText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 80.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: AppColors.bodyBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFE2E7EE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Setup Instructions',
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.lightText,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _stepCard(
                      stepNumber: 1,
                      title: 'Download an Authenticator App',
                      description:
                          'Install Google Authenticator, Authy, or Microsoft Authenticator on your phone',
                    ),
                    SizedBox(height: 16.h),
                    _stepCard(
                      stepNumber: 2,
                      title: 'Scan the QR Code',
                      description:
                          'Open your authenticator app and scan this QR code',
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FB),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFE2E7EE)),
                      ),
                      child: Center(
                        child: Container(
                          height: 140.w,
                          width: 140.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: const Color(0xFFE2E7EE)),
                          ),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                GridView.count(
                                  crossAxisCount: 18,
                                  children: List.generate(
                                    324,
                                    (index) => Container(
                                      decoration: BoxDecoration(
                                        color:
                                            (index % 3 == 0 || index % 7 == 0)
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 36.w,
                                  width: 36.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(
                                      color: const Color(0xFFC8CCD3),
                                    ),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      AppImages.gridIcon,
                                      width: 20.sp,
                                      height: 20.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 32.w,
                          width: 32.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D3E55),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '3',
                              style: TextStyles.boldSmall.copyWith(
                                color: Colors.white,
                                fontSize: 14.sp,
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
                                'Or Enter This Key Manually',
                                style: TextStyles.boldSmall.copyWith(
                                  color: AppColors.lightText,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'If you can\'t scan the QR code, enter this key in your app',
                                style: TextStyles.regularSmall.copyWith(
                                  color: AppColors.greyText,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 12.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(color: const Color(0xFFE4E9F0)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'JBSWY3DPEHPK3PXP',
                                          style: TextStyles.boldSmall.copyWith(
                                            color: AppColors.lightText,
                                            fontSize: 13.sp,
                                            fontFamily: 'Courier',
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Container(
                                    height: 40.w,
                                    width: 40.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2D3E55),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        AppImages.copyIcon,
                                        width: 18.sp,
                                        height: 18.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 20.h),
                child: CustomButton(
                  onTap: () =>
                      context.push('/dealer/app-settings/two-factor-auth/verify'),
                  height: 52.h,
                  borderRadius: 13.r,
                  btnColor: const Color(0xFF2D3E55),
                  btnText: 'Continue to Verification',
                  textStyle: TextStyles.boldSmall.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
