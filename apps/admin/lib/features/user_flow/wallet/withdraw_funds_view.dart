import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';

import '../../../core/components/global_header/header_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/buttons/custom_button.dart';
import '../../../core/theme/images.dart';
import '../../../core/theme/text_styles.dart';

class WithdrawFundsView extends StatefulWidget {
  const WithdrawFundsView({super.key});

  @override
  State<WithdrawFundsView> createState() => _WithdrawFundsViewState();
}

class _WithdrawFundsViewState extends State<WithdrawFundsView> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  int _selectedMethodIndex = 0;

  static const double _availableBalance = 2450.75;

  @override
  void initState() {
    super.initState();
    _setAmount(500);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _setAmount(double value) {
    _amountController.text = value.toStringAsFixed(2);
  }

  void _setAllAmount() {
    _amountController.text = _availableBalance.toStringAsFixed(2);
  }

  String _selectedMethodTitle() {
    switch (_selectedMethodIndex) {
      case 0:
        return 'Chase Business Account';
      case 1:
        return 'Bank of America';
      default:
        return 'Bank Account';
    }
  }

  String _formattedAmount() {
    final raw = _amountController.text.trim().replaceAll(',', '');
    final amount = double.tryParse(raw) ?? 0.0;
    return amount.toStringAsFixed(2);
  }

  Future<void> _showWithdrawalSuccessDialog() {
    final methodTitle = _selectedMethodTitle();
    final amountText = _formattedAmount();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
          alignment: Alignment.center,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 22.h),
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.18),
                  blurRadius: 28,
                  spreadRadius: -10,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _successIcon(),
                SizedBox(height: 16.h),
                Text(
                  'Withdrawal Successful!',
                  textAlign: TextAlign.center,
                  style: TextStyles.semiBoldLarge.copyWith(
                    color: AppColors.gradientColor2,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Your withdrawal request has been\nprocessed successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.greyText,
                    fontSize: 14.sp,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 20.h),
                _successAmountCard(amountText),
                SizedBox(height: 12.h),
                _successMethodCard(methodTitle),
                SizedBox(height: 12.h),
                _successTimingCard(),
                SizedBox(height: 18.h),
                Container(
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
                    onTap: () => Navigator.of(context).pop(),
                    height: 64.h,
                    borderRadius: 22.r,
                    btnColor: AppColors.gradientColor2,
                    child: Text(
                      'Done',
                      style: TextStyles.semiBoldMedium.copyWith(
                        color: AppColors.bodyBg,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _successIcon() {
    return Image.asset(
      AppImages.tickBgIcon,
      width: 84.w,
      height: 84.w,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Withdraw Funds',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.darkText,
              fontSize: 34.sp,
              height: 1.05,
            ),
          ),
          height: 230.h,
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
              _availableBalanceCard(),
              SizedBox(height: 16.h),
              _withdrawAmountCard(),
              SizedBox(height: 16.h),
              _withdrawMethodCard(),
              SizedBox(height: 16.h),
              _noteCard(),
              SizedBox(height: 16.h),
              _processingInfoCard(),
              SizedBox(height: 18.h),
              _confirmWithdrawButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmWithdrawButton() {
    return Container(
      width: double.infinity,
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
        onTap: _showWithdrawalSuccessDialog,
        height: 64.h,
        borderRadius: 22.r,
        btnColor: AppColors.gradientColor2,
        child: Text(
          'Confirm Withdraw',
          style: TextStyles.semiBoldMedium.copyWith(
            color: AppColors.bodyBg,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _successAmountCard(String amountText) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.greenSuccess.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.greenSuccess.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Amount',
            style: TextStyles.mediumSmall.copyWith(
              color: AppColors.greenSuccess,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '\$$amountText',
            style: TextStyles.semiBoldLarge.copyWith(
              color: AppColors.greenSuccess,
              fontSize: 26.sp,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _successMethodCard(String methodTitle) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.infoCardBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.infoCardBorder, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Withdrawal Method',
            style: TextStyles.mediumSmall.copyWith(
              color: AppColors.infoCardText,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            methodTitle,
            textAlign: TextAlign.center,
            style: TextStyles.mediumMedium.copyWith(
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _successTimingCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.crossIconColor.withValues(alpha: 0.75),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Image.asset(
              AppImages.alertIcon,
              width: 18.sp,
              height: 18.sp,
              color: AppColors.redButton,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Funds will arrive in your account within\n',
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.redButton,
                      fontSize: 14.sp,
                      height: 1.25,
                    ),
                  ),
                  TextSpan(
                    text: '1-3 business days.',
                    style: TextStyles.semiBoldMedium.copyWith(
                      color: AppColors.redButton,
                      fontSize: 14.sp,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _availableBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 22.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientColor1, AppColors.gradientColor2],
        ),
        borderRadius: BorderRadius.circular(26.r),
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
            'Available Balance',
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.bodyBg.withValues(alpha: 0.88),
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '\$2450.75',
            style: TextStyles.semiBoldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 48.sp.clamp(32, 48),
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _withdrawAmountCard() {
    return _sectionCard(
      title: 'Withdrawal Amount',
      child: Column(
        children: [
          _inputField(
            prefix: Text(
              '\$',
              style: TextStyles.semiBoldLarge.copyWith(
                color: AppColors.lightText.withValues(alpha: 0.45),
                fontSize: 28.sp,
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
              fontSize: 26.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _pillButton(
                  label: '\$100',
                  onTap: () => _setAmount(100),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _pillButton(
                  label: '\$500',
                  onTap: () => _setAmount(500),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _pillButton(
                  label: '\$1000',
                  onTap: () => _setAmount(1000),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _pillButton(label: 'All', onTap: _setAllAmount),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _withdrawMethodCard() {
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

  Widget _noteCard() {
    return _sectionCard(
      title: 'Note (Optional)',
      child: _inputField(
        controller: _noteController,
        hintText: 'Add a note for your records...',
        keyboardType: TextInputType.text,
        maxLines: 4,
        fieldHeight: 120.h,
        textStyle: TextStyles.regularMedium.copyWith(
          color: AppColors.lightText,
          fontSize: 15.sp,
        ),
      ),
    );
  }

  Widget _processingInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.infoCardBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.infoCardBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42.w,
            width: 42.w,
            decoration: BoxDecoration(
              color: AppColors.infoCardIconBg,
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Center(
              child: Image.asset(
                AppImages.shieldImg,
                width: 22.sp,
                height: 22.sp,
                color: AppColors.bodyBg,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Processing Time',
                  style: TextStyles.semiBoldMedium.copyWith(
                    color: AppColors.infoCardText,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Withdrawals typically take 1-3\n'
                  'business days to reach your\n'
                  'account.',
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.infoCardText,
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

  Widget _pillButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: AppColors.lightText.withValues(alpha: 0.9),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.semiBoldMedium.copyWith(
            color: AppColors.gradientColor1,
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
                    style: TextStyles.mediumMedium.copyWith(
                      color: AppColors.lightText.withValues(alpha: 0.65),
                      fontSize: 16.sp,
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
