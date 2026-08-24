import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  late final TextEditingController _holderController;
  late final TextEditingController _bankController;
  late final TextEditingController _routingController;
  late final TextEditingController _accountController;
  late final TextEditingController _confirmAccountController;
  String _accountType = 'Checking';
  bool _authorized = false;

  @override
  void initState() {
    super.initState();
    _holderController = TextEditingController(
      text: 'John Doe or Business Name',
    );
    _bankController = TextEditingController(
      text: 'Chase, Bank of America, etc.',
    );
    _routingController = TextEditingController(text: '9 digits');
    _accountController = TextEditingController(text: 'Enter account number');
    _confirmAccountController = TextEditingController(
      text: 'Re-enter account number',
    );
  }

  @override
  void dispose() {
    _holderController.dispose();
    _bankController.dispose();
    _routingController.dispose();
    _accountController.dispose();
    _confirmAccountController.dispose();
    super.dispose();
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyles.mediumMedium.copyWith(
          color: AppColors.lightText,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, {IconData? icon}) {
    return TextField(
      controller: controller,
      style: TextStyles.regularMedium.copyWith(
        color: AppColors.lightText,
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        prefixIcon: icon == null
            ? null
            : Icon(icon, size: 18.sp, color: AppColors.greyText),
        filled: true,
        fillColor: const Color(0xFFF7F8FB),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: AppColors.lightText.withValues(alpha: 0.10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: AppColors.lightText.withValues(alpha: 0.10),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: AppColors.redButton.withValues(alpha: 0.28),
          ),
        ),
      ),
    );
  }

  Widget _accountTypeButton(String label) {
    final selected = _accountType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _accountType = label),
        child: Container(
          height: 44.h,
          decoration: BoxDecoration(
            color: selected ? Colors.white : const Color(0xFFF7F8FB),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE3E6EC)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyles.mediumMedium.copyWith(
                color: AppColors.lightText,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

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
              children: [
                SvgPicture.asset(

                  'assets/icons/shield_protection_icon.svg',
                  width: 18.sp,
                  height: 18.sp,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF178A43),
                    BlendMode.srcIn,
                  ),
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
                              'Your bank details are encrypted and never shared. We use industry-standard security to protect your information.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _fieldLabel('Account Holder Name *'),
          _input(_holderController, icon: Icons.apartment_outlined),
          SizedBox(height: 14.h),
          _fieldLabel('Bank Name *'),
          _input(_bankController, icon: Icons.account_balance_outlined),
          SizedBox(height: 14.h),
          _fieldLabel('Account Type *'),
          Row(
            children: [
              _accountTypeButton('Checking'),
              SizedBox(width: 10.w),
              _accountTypeButton('Savings'),
            ],
          ),
          SizedBox(height: 14.h),
          _fieldLabel('Routing Number *'),
          _input(_routingController, icon: Icons.numbers_outlined),
          SizedBox(height: 6.h),
          Text(
            'Found at the bottom of your check',
            style: TextStyles.regularSmall.copyWith(color: AppColors.greyText),
          ),
          SizedBox(height: 14.h),
          _fieldLabel('Account Number *'),
          _input(_accountController, icon: Icons.attach_money_outlined),
          SizedBox(height: 14.h),
          _fieldLabel('Confirm Account Number *'),
          _input(_confirmAccountController, icon: Icons.attach_money_outlined),
          SizedBox(height: 16.h),
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
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.gradientColor1,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'How Payments Work',
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.lightText,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                _bullet(
                  'Funds are held in escrow until buyer confirms receipt',
                ),
                _bullet('Automatic deposits every Monday (3-5 business days)'),
                _bullet('2.9% + \$0.30 transaction fee applies'),
                _bullet('You can update bank details anytime in settings'),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFD0E2FF)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _authorized,
                  onChanged: (value) {
                    setState(() => _authorized = value ?? false);
                  },
                  activeColor: AppColors.gradientColor1,
                  side: BorderSide(color: AppColors.greyText),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Text(
                      'I authorize Antique Marketplace to electronically debit my account and, if necessary, initiate credit entries and adjustments for any debits made in error. I agree to the ACH Authorization Terms.',
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.lightText,
                        height: 1.45,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          CustomButton(
            onTap: _authorized
                ? () => context.go('/dealer/verification-progress')
                : () {},
            height: 50.h,
            borderRadius: 14.r,
            btnColor: _authorized
                ? AppColors.gradientColor1.withValues(alpha: 0.90)
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

  Widget _bullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.lightText,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.regularSmall.copyWith(
                color: AppColors.greyText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
