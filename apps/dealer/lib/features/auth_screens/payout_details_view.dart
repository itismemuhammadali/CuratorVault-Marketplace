import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/auth_screens/dealer_onboarding_scaffold.dart';

class PayoutDetailsView extends StatefulWidget {
  const PayoutDetailsView({super.key});

  @override
  State<PayoutDetailsView> createState() => _PayoutDetailsViewState();
}

class _PayoutDetailsViewState extends State<PayoutDetailsView> {
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return DealerOnboardingScaffold(
      title: 'Bank Account',
      subtitle: 'Set up payment to receive your earnings',
      step: 5,
      totalSteps: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEAFBF0),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFB6E6C6)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: const Color(0xFF178A43),
                  size: 18.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyles.regularSmall.copyWith(
                        color: const Color(0xFF178A43),
                        height: 1.4,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Secure Payment Setup\n',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text:
                              'Your payment details are encrypted and never shared. We use industry-standard security to protect your information.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Select Payment Method',
            style: TextStyles.boldMedium.copyWith(
              color: AppColors.lightText,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 16.h),
          _paymentMethodButton('Bank Account', 'bank_account'),
          SizedBox(height: 12.h),
          _paymentMethodButton('Credit Card', 'credit_card'),
          SizedBox(height: 24.h),
          CustomButton(
            onTap: _selectedPaymentMethod != null
                ? () => context.go('/dealer/verification-progress')
                : () {},
            height: 50.h,
            borderRadius: 14.r,
            btnColor: _selectedPaymentMethod != null
                ? AppColors.gradientColor1
                : const Color(0xFF9FA9B8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Complete Setup',
                  style: TextStyles.mediumMedium.copyWith(
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentMethodButton(String label, String value) {
    final selected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.gradientColor1.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? AppColors.gradientColor1 : const Color(0xFFE3E6EC),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.gradientColor1 : const Color(0xFFE3E6EC),
                  width: 2,
                ),
                color: selected ? AppColors.gradientColor1 : Colors.transparent,
              ),
              child: selected
                  ? Icon(Icons.check, color: Colors.white, size: 14.sp)
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyles.mediumMedium.copyWith(
                color: AppColors.lightText,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
