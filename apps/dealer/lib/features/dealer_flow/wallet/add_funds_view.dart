import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';

import '../../../core/components/global_header/header_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/buttons/custom_button.dart';
import '../../../core/theme/images.dart';
import '../../../core/theme/text_styles.dart';

class AddFundsView extends StatefulWidget {
  const AddFundsView({super.key});

  @override
  State<AddFundsView> createState() => _AddFundsViewState();
}

class _AddFundsViewState extends State<AddFundsView> {
  final TextEditingController _amountController = TextEditingController();

  int _selectedMethodIndex = 0;

  static const double _availableBalance = 2450.75;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setAmount(double value) {
    _amountController.text = value.toStringAsFixed(2);
  }

  void _setAllAmount() {
    _amountController.text = _availableBalance.toStringAsFixed(2);
  }

  double _enteredAmountOrDefault() {
    final raw = _amountController.text.trim().replaceAll(',', '');
    final parsed = double.tryParse(raw) ?? 0;
    if (parsed > 0) return parsed;

    _setAmount(100);
    return 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Add Funds',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.darkText,
              height: 1.05,
            ),
          ),
          height: 170.h,
        ),
      ),
      backgroundColor: AppColors.subPageBg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _currentBalanceCard(),
              SizedBox(height: 16.h),
              _amountCard(),
              SizedBox(height: 16.h),
              _paymentMethodCard(),
              SizedBox(height: 16.h),
              _instantDepositInfoCard(),
              SizedBox(height: 16.h),
              _addFundsButton(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addFundsButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.22),
            blurRadius: 18,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: CustomButton(
        onTap: () {
          final amount = _enteredAmountOrDefault();
          Navigator.of(context).pop(amount);
        },
        height: 64.h,
        borderRadius: 22.r,
        btnColor: AppColors.gradientColor2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 26.w,
              width: 26.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.bodyBg.withValues(alpha: 0.85),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.tickIcon,
                  width: 14.sp,
                  height: 14.sp,
                  color: AppColors.bodyBg,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Add Funds',
              style: TextStyles.semiBoldMedium.copyWith(
                color: AppColors.bodyBg,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currentBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientColor1, AppColors.gradientColor2],
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.20),
            blurRadius: 22,
            spreadRadius: -12,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Balance',
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.bodyBg.withValues(alpha: 0.92),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '\$2450.75',
            style: TextStyles.semiBoldLarge.copyWith(
              color: AppColors.bodyBg,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountCard() {
    return _sectionCard(
      title: 'Withdrawal Amount',
      child: Column(
        children: [
          _inputField(
            prefix: Text(
              '\$',
              style: TextStyles.semiBoldLarge.copyWith(
                color: AppColors.lightText.withValues(alpha: 0.45),
                fontSize: 22.sp,
              ),
            ),
            controller: _amountController,
            hintText: '0.00',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            fieldHeight: 64.h,
            textStyle: TextStyles.mediumLarge.copyWith(
              color: AppColors.lightText.withValues(alpha: 0.65),
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _outlinePillButton(
                  label: '\$50',
                  onTap: () => _setAmount(50),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _outlinePillButton(
                  label: '\$100',
                  onTap: () => _setAmount(100),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _outlinePillButton(
                  label: '\$250',
                  onTap: () => _setAmount(250),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _outlinePillButton(label: 'All', onTap: _setAllAmount),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paymentMethodCard() {
    return _sectionCard(
      title: 'Withdrawal Method',
      child: Column(
        children: [
          _methodTile(
            index: 0,
            title: 'Chase Business Account',
            subtitle: '•••• 6789',
            iconAsset: AppImages.cardWhiteIcon,
          ),
          SizedBox(height: 12.h),
          _methodTile(
            index: 1,
            title: 'Bank of America',
            subtitle: '•••• 4321',
            iconAsset: AppImages.cardWhiteIcon,
          ),
        ],
      ),
    );
  }

  Widget _instantDepositInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.greenSuccess.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.10),
            blurRadius: 18,
            spreadRadius: -14,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppImages.tickBgIcon,
            width: 34.w,
            height: 34.w,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No Fees • Instant Deposit',
                  style: TextStyles.semiBoldMedium.copyWith(
                    color: AppColors.gradientColor2,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Funds will be added to your wallet instantly with\nno processing fees.',
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.lightText.withValues(alpha: 0.80),
                    fontSize: 15.sp,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: AppColors.lightText.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.12),
            blurRadius: 24,
            spreadRadius: -16,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.semiBoldMedium.copyWith(
              color: AppColors.gradientColor1,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }

  Widget _inputField({
    Widget? prefix,
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    TextStyle? textStyle,
    int maxLines = 1,
    double? fieldHeight,
  }) {
    return Container(
      width: double.infinity,
      height: fieldHeight,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.lightText.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          if (prefix != null) ...[
            Padding(
              padding: EdgeInsets.only(
                right: 12.w,
                top: maxLines > 1 ? 2.h : 0,
              ),
              child: prefix,
            ),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              style: textStyle,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: textStyle?.copyWith(
                  color: AppColors.lightText.withValues(alpha: 0.35),
                ),
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlinePillButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.gradientColor2, width: 1),
        ),
        child: Text(
          label,
          style: TextStyles.semiBoldMedium.copyWith(
            color: AppColors.gradientColor2,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _methodTile({
    required int index,
    required String title,
    required String subtitle,
    required String iconAsset,
  }) {
    final selected = index == _selectedMethodIndex;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethodIndex = index),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.greenSuccess.withValues(alpha: 0.10)
              : AppColors.bodyBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected
                ? AppColors.greenSuccess
                : AppColors.lightText.withValues(alpha: 0.10),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 52.w,
              width: 52.w,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.greenSuccess
                    : AppColors.lightText.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.18),
                    blurRadius: 10,
                    spreadRadius: -4,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  iconAsset,
                  width: 26.sp,
                  height: 26.sp,
                  color: selected
                      ? AppColors.bodyBg
                      : AppColors.lightText.withValues(alpha: 0.55),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.semiBoldMedium.copyWith(
                      color: selected
                          ? AppColors.gradientColor2
                          : AppColors.gradientColor1,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    style: TextStyles.regularMedium.copyWith(
                      color: const Color(0xFF1D4ED8),
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                height: 34.w,
                width: 34.w,
                decoration: BoxDecoration(
                  color: AppColors.greenSuccess,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Center(
                  child: Image.asset(
                    AppImages.tickIcon,
                    width: 20.sp,
                    height: 20.sp,
                    color: AppColors.bodyBg,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            else
              SizedBox(width: 34.w, height: 34.w),
          ],
        ),
      ),
    );
  }
}
