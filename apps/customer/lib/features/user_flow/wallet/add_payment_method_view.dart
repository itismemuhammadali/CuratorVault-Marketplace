import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/components/global_header/global_header.dart';
import '../../../core/components/global_header/header_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/buttons/custom_button.dart';
import '../../../core/theme/text_styles.dart';

class AddPaymentMethodView extends StatefulWidget {
  const AddPaymentMethodView({super.key});

  @override
  State<AddPaymentMethodView> createState() => _AddPaymentMethodViewState();
}

class _AddPaymentMethodViewState extends State<AddPaymentMethodView> {
  int _selectedTabIndex = 0;
  OverlayEntry? _successToastEntry;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _routingNumberController =
      TextEditingController();

  @override
  void dispose() {
    _successToastEntry?.remove();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _bankNameController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    super.dispose();
  }

  void _showSuccessToast() {
    _successToastEntry?.remove();

    final overlay = Overlay.of(context);

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return _PaymentMethodTopToast(
          message: 'Payment method added successfully',
          onDismissed: () {
            entry.remove();
            if (_successToastEntry == entry) {
              _successToastEntry = null;
            }
          },
        );
      },
    );

    _successToastEntry = entry;
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.authBackBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Add Payment Method',
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
              _methodTabs(),
              SizedBox(height: 16.h),
              _formCard(),
              SizedBox(height: 16.h),
              _securityCard(),
              SizedBox(height: 18.h),
              _submitButton(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _methodTabs() {
    return Row(
      children: [
        Expanded(
          child: _methodTab(
            index: 0,
            title: 'Card',
            icon: Icons.credit_card_rounded,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _methodTab(
            index: 1,
            title: 'Bank Account',
            icon: Icons.account_balance_rounded,
          ),
        ),
      ],
    );
  }

  Widget _methodTab({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final selected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        height: 116.h,
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.gradientColor1, AppColors.gradientColor2],
                )
              : null,
          color: selected ? null : AppColors.authBackBg,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: selected
                ? AppColors.gradientColor1.withValues(alpha: 0.85)
                : AppColors.lightText.withValues(alpha: 0.12),
            width: 1.6,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 56.w,
              width: 56.w,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.bodyBg
                    : AppColors.lightText.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Icon(
                icon,
                color: selected
                    ? AppColors.gradientColor2
                    : AppColors.lightText.withValues(alpha: 0.66),
                size: 28.sp,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              title,
              style: TextStyles.mediumLarge.copyWith(
                color: selected
                    ? AppColors.bodyBg
                    : AppColors.gradientColor1.withValues(alpha: 0.92),
                fontSize: 17.sp.clamp(15, 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.authBackBg,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: AppColors.lightText.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.12),
            blurRadius: 20,
            spreadRadius: -14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _selectedTabIndex == 0 ? _cardForm() : _bankForm(),
    );
  }

  Widget _cardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Card Number'),
        SizedBox(height: 10.h),
        _inputField(
          controller: _cardNumberController,
          hintText: '1234 5678 9012 3456',
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        _fieldLabel('Cardholder Name'),
        SizedBox(height: 10.h),
        _inputField(
          controller: _cardHolderController,
          hintText: 'John Doe',
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Expiry Date'),
                  SizedBox(height: 10.h),
                  _inputField(
                    controller: _expiryController,
                    hintText: 'MM/YY',
                    keyboardType: TextInputType.datetime,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('CVV'),
                  SizedBox(height: 10.h),
                  _inputField(
                    controller: _cvvController,
                    hintText: '123',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bankForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Bank Name'),
        SizedBox(height: 10.h),
        _inputField(
          controller: _bankNameController,
          hintText: 'Chase Bank',
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 16.h),
        _fieldLabel('Account Holder Name'),
        SizedBox(height: 10.h),
        _inputField(
          controller: _accountHolderController,
          hintText: 'John Doe',
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 16.h),
        _fieldLabel('Account Number'),
        SizedBox(height: 10.h),
        _inputField(
          controller: _accountNumberController,
          hintText: '000123456789',
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        _fieldLabel('Routing Number'),
        SizedBox(height: 10.h),
        _inputField(
          controller: _routingNumberController,
          hintText: '110000000',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: TextStyles.semiBoldMedium.copyWith(
        color: AppColors.gradientColor1.withValues(alpha: 0.92),
        fontSize: 16.sp.clamp(14, 16),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
  }) {
    return Container(
      height: 68.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.authBackBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.lightText.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyles.mediumMedium.copyWith(
          color: AppColors.lightText.withValues(alpha: 0.82),
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyles.regularMedium.copyWith(
            color: AppColors.lightText.withValues(alpha: 0.45),
            fontSize: 16.sp,
          ),
        ),
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
            height: 60.w,
            width: 60.w,
            decoration: const BoxDecoration(
              color: Color(0xff03C75A),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: AppColors.bodyBg,
              size: 34.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure & Encrypted',
                  style: TextStyles.semiBoldMedium.copyWith(
                    color: const Color(0xff0F6A3E),
                    fontSize: 16.sp.clamp(14, 16),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your payment information is encrypted\nwith bank-level security and never\nstored on our servers.',
                  style: TextStyles.regularMedium.copyWith(
                    color: const Color(0xff008A3E),
                    fontSize: 15.sp.clamp(12, 15),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return CustomButton(
      onTap: () {
        _showSuccessToast();
      },
      height: 76.h,
      borderRadius: 26.r,
      btnColor: AppColors.gradientColor1,
      child: Text(
        'Add Payment Method',
        style: TextStyles.semiBoldMedium.copyWith(
          color: AppColors.bodyBg,
          fontSize: 18.sp,
        ),
      ),
    );
  }
}

class _PaymentMethodTopToast extends StatefulWidget {
  const _PaymentMethodTopToast({
    required this.message,
    required this.onDismissed,
  });

  final String message;
  final VoidCallback onDismissed;

  @override
  State<_PaymentMethodTopToast> createState() => _PaymentMethodTopToastState();
}

class _PaymentMethodTopToastState extends State<_PaymentMethodTopToast> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _visible = true);
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => _visible = false);
    });

    Future.delayed(const Duration(milliseconds: 2100), () {
      if (!mounted) return;
      widget.onDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 0),
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            offset: _visible ? Offset.zero : const Offset(0, -0.25),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              opacity: _visible ? 1 : 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF031E1B),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFF0A3A34),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: const Color(0xFF00C853),
                        size: 18.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            height: 19.5 / 13,
                            letterSpacing: 0,
                            color: const Color(0xFF00C853),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
