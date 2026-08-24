import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/global_header/global_header.dart';
import '../../../core/components/global_header/header_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/buttons/custom_button.dart';
import '../../../core/theme/text_styles.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({super.key});

  Future<void> _showDeleteDialog(BuildContext context, String cardTitle) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(color: const Color(0xFFE6E8EC), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete Payment Method',
                  style: TextStyles.semiBoldMedium.copyWith(
                    color: const Color(0xFF1F2937),
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Are you sure you want to remove $cardTitle? This action cannot be undone.',
                  style: TextStyles.regularMedium.copyWith(
                    color: const Color(0xFF475467),
                    fontSize: 14.sp,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: Container(
                          height: 46.h,
                          decoration: BoxDecoration(
                            color: AppColors.bodyBg,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: const Color(0xFFD0D5DD),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyles.mediumMedium.copyWith(
                                color: const Color(0xFF344054),
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: Container(
                          height: 46.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD90000),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Center(
                            child: Text(
                              'Delete',
                              style: TextStyles.mediumMedium.copyWith(
                                color: AppColors.bodyBg,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TextStyle _exactRegular18(Color color) {
    return TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: 15.sp,
      height: 24 / 15,
      letterSpacing: 0,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Payment Method',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.darkText,
              fontSize: 28.sp,
            ),
          ),
          height: 170.h,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomButton(
                onTap: () => context.push('/dealer/wallet/payment-method/add'),
                height: 64.h,
                borderRadius: 22.r,
                btnColor: AppColors.gradientColor1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.bodyBg, size: 26.sp),
                    SizedBox(width: 10.w),
                    Text(
                      'Add Payment Method',
                      style: TextStyles.mediumLarge.copyWith(
                        color: AppColors.bodyBg,
                        fontSize: 17.sp.clamp(15, 17),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              _paymentCard(
                context: context,
                title: 'Business Visa',
                cardLine: 'Visa •••• 4242',
                expiryLine: 'Expires 12/25',
                isPrimary: true,
                deleteColor: AppColors.lightText.withValues(alpha: 0.22),
              ),
              SizedBox(height: 14.h),
              _paymentCard(
                context: context,
                title: 'Personal Mastercard',
                cardLine: 'Mastercard •••• 8888',
                expiryLine: 'Expires 06/26',
                isPrimary: false,
                deleteColor: Colors.red,
              ),
              SizedBox(height: 18.h),
              _securityCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentCard({
    required BuildContext context,
    required String title,
    required String cardLine,
    required String expiryLine,
    required bool isPrimary,
    required Color deleteColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.authBackBg,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isPrimary
              ? const Color(0xFF101828)
              : AppColors.lightText.withValues(alpha: 0.14),
          width: 1.09,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 84.w,
                width: 84.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gradientColor1,
                      AppColors.gradientColor2,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor.withValues(alpha: 0.15),
                      blurRadius: 16,
                      spreadRadius: -8,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.credit_card_rounded,
                  color: AppColors.bodyBg,
                  size: 38.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.semiBoldLarge.copyWith(
                              color: AppColors.gradientColor2,
                              fontSize: 19.sp.clamp(16, 19),
                            ),
                          ),
                        ),
                        if (isPrimary)
                          Icon(
                            Icons.verified_outlined,
                            color: AppColors.gradientColor2,
                            size: 22.sp,
                          ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      cardLine,
                      style: _exactRegular18(
                        AppColors.gradientColor1.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      expiryLine,
                      style: _exactRegular18(
                        AppColors.gradientColor1.withValues(alpha: 0.7),
                      ),
                    ),
                    if (isPrimary) ...[
                      SizedBox(height: 9.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightText.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          'Primary',
                          style: TextStyles.mediumMedium.copyWith(
                            color: AppColors.gradientColor1,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => _showDeleteDialog(context, title),
                child: Icon(
                  Icons.delete_outline,
                  color: deleteColor,
                  size: 28.sp,
                ),
              ),
            ],
          ),
          if (!isPrimary) ...[
            SizedBox(height: 16.h),
            Container(
              height: 62.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                  color: AppColors.lightText.withValues(alpha: 0.28),
                  width: 1.8,
                ),
              ),
              child: Center(
                child: Text(
                  'Set as Primary',
                  style: TextStyles.semiBoldMedium.copyWith(
                    color: AppColors.gradientColor2,
                    fontSize: 17.sp,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _securityCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.infoCardBg,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.infoCardBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 58.w,
            width: 58.w,
            decoration: const BoxDecoration(
              color: AppColors.infoCardIconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.credit_card_rounded,
              color: AppColors.bodyBg,
              size: 30.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Payment Information',
                  style: TextStyles.semiBoldMedium.copyWith(
                    color: AppColors.gradientColor2,
                    fontSize: 17.sp.clamp(14, 17),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your payment information is encrypted\nand stored securely. We never share\nyour details with third parties.',
                  style: _exactRegular18(AppColors.infoCardText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
