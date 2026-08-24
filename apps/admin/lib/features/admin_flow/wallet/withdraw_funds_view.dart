import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class WithdrawFundsView extends StatefulWidget {
  const WithdrawFundsView({super.key});

  @override
  State<WithdrawFundsView> createState() => _WithdrawFundsViewState();
}

class _WithdrawFundsViewState extends State<WithdrawFundsView> {
  final TextEditingController _amountController = TextEditingController();

  double get _amount {
    final raw = _amountController.text.trim().replaceAll(',', '');
    return double.tryParse(raw) ?? 0;
  }

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasAmount = _amount > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: SimpleHeader(
        config: HeaderConfig(
          height: 145.h,
          leading: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: AppColors.bodyBg.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 23.sp,
                color: AppColors.darkText,
              ),
            ),
          ),
          title: Text(
            'Withdraw Funds',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 22.sp,
              height: 1.1,
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.bodyBg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(22.w, 15.h, 22.w, 24.h),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 588.h),
            padding: EdgeInsets.fromLTRB(13.w, 27.h, 13.w, 20.h),
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(6.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 16,
                  spreadRadius: -5,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _balancePanel(),
                SizedBox(height: 13.h),
                _label('Withdrawal Amount (\$)'),
                SizedBox(height: 8.h),
                _amountField(),
                SizedBox(height: 13.h),
                _label('Bank Account'),
                SizedBox(height: 8.h),
                _bankAccountBox(),
                SizedBox(height: 17.h),
                _noticeBox(),
                SizedBox(height: 23.h),
                _withdrawButton(hasAmount),
                SizedBox(height: 10.h),
                _cancelButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _balancePanel() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 15.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FA),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularSmall.copyWith(
              color: const Color(0xFF667085),
              fontSize: 13.5.sp,
            ),
          ),
          SizedBox(height: 8.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '\$12,450.75',
              maxLines: 1,
              style: TextStyles.boldLarge.copyWith(
                color: const Color(0xFF009D4E),
                fontSize: 22.sp,
                height: 1.05,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.boldSmall.copyWith(
        color: const Color(0xFF344054),
        fontSize: 14.sp,
      ),
    );
  }

  Widget _amountField() {
    return SizedBox(
      height: 35.h,
      child: TextField(
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyles.mediumSmall.copyWith(
          color: const Color(0xFF344054),
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: const Color(0xFFF4F4F5),
          hintText: '0.00',
          hintStyle: TextStyles.mediumSmall.copyWith(
            color: const Color(0xFF9AA4B2),
            fontSize: 14.sp,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 13.w,
            vertical: 9.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
          ),
        ),
      ),
    );
  }

  Widget _bankAccountBox() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 52.h),
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFD),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFD9DDE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bank of America',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.mediumSmall.copyWith(
              color: const Color(0xFF344054),
              fontSize: 13.sp,
              height: 1.1,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Account ...5678',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.mediumExtraSmall.copyWith(
              color: const Color(0xFF9AA4B2),
              fontSize: 11.sp,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _noticeBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(11.w, 10.h, 11.w, 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF2),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFF0D36A)),
      ),
      child: Text(
        'Funds will be transferred to your bank account within\n1-3 business days.',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyles.mediumExtraSmall.copyWith(
          color: const Color(0xFF936A1F),
          fontSize: 11.5.sp,
          height: 1.35,
        ),
      ),
    );
  }

  Widget _withdrawButton(bool hasAmount) {
    final amountText = _amount.toStringAsFixed(2);

    return InkWell(
      onTap: hasAmount ? _showSuccessMessage : null,
      borderRadius: BorderRadius.circular(5.r),
      child: Container(
        width: double.infinity,
        height: 38.h,
        decoration: BoxDecoration(
          color: hasAmount ? AppColors.gradientColor2 : const Color(0xFF98A2AE),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Center(
          child: Text(
            'Withdraw \$$amountText',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldSmall.copyWith(
              color: AppColors.bodyBg.withValues(alpha: 0.82),
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cancelButton(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(),
      borderRadius: BorderRadius.circular(5.r),
      child: Container(
        width: double.infinity,
        height: 38.h,
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: const Color(0xFFE2E4E8)),
        ),
        child: Center(
          child: Text(
            'Cancel',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldSmall.copyWith(
              color: const Color(0xFF344054),
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessMessage() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Withdrawal request submitted for \$${_amount.toStringAsFixed(2)}',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
