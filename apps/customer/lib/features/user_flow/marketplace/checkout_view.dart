import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/images.dart';
import '../../../core/theme/text_styles.dart';

enum CheckoutStep { shipping, payment, review, success }

class CheckoutView extends StatefulWidget {
  const CheckoutView({
    super.key,
    required this.step,
    this.productId,
  });

  final CheckoutStep step;
  final String? productId;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cardNumberController;
  late final TextEditingController _cardholderController;
  late final TextEditingController _expiryController;
  late final TextEditingController _cvvController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: 'John Doe');
    _streetController = TextEditingController(text: '123 Main Street');
    _cityController = TextEditingController(text: 'New York');
    _stateController = TextEditingController(text: 'NY');
    _zipController = TextEditingController(text: '10001');
    _phoneController = TextEditingController(text: '+1 234 567 8900');
    _cardNumberController = TextEditingController(text: '1234 5678 9012 3456');
    _cardholderController = TextEditingController(text: 'JOHN DOE');
    _expiryController = TextEditingController(text: 'MM/YY');
    _cvvController = TextEditingController(text: '123');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    _cardNumberController.dispose();
    _cardholderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.step == CheckoutStep.success) {
      return Scaffold(
        backgroundColor: AppColors.subPageBg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(18.w, 24.h, 18.w, 24.h),
            child: _successContent(context),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.subPageBg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 24.h),
                child: _buildStepBody(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22.w, 54.h, 22.w, 22.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientColor1, AppColors.gradientColor2],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34.r),
          bottomRight: Radius.circular(34.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.18),
            blurRadius: 24,
            spreadRadius: -12,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.step == CheckoutStep.shipping) {
                // Always go back to product detail screen if we have the ID
                if (widget.productId != null && widget.productId!.isNotEmpty) {
                  context.go('/market/product/${widget.productId}');
                } else {
                  // Fallback to marketplace if no product ID
                  context.go('/user/market');
                }
              } else if (widget.step == CheckoutStep.payment) {
                // Go back to shipping step
                context.go('/user/checkout');
              } else if (widget.step == CheckoutStep.review) {
                // Go back to payment step
                context.go('/market/checkout/payment');
              }
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.bodyBg.withValues(alpha: 0.22),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  AppImages.backIcon,
                  width: 16.w,
                  height: 16.w,
                  color: AppColors.darkText,
                ),
              ),
            ),
          ),
          SizedBox(height: 26.h),
          Text(
            'Checkout',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.darkText,
            ),
          ),
          SizedBox(height: 20.h),
          _CheckoutStepper(step: widget.step),
        ],
      ),
    );
  }

  Widget _buildStepBody(BuildContext context) {
    switch (widget.step) {
      case CheckoutStep.shipping:
        return _shippingContent(context);
      case CheckoutStep.payment:
        return _paymentContent(context);
      case CheckoutStep.review:
        return _reviewContent(context);
      case CheckoutStep.success:
        return const SizedBox.shrink();
    }
  }

  Widget _shippingContent(BuildContext context) {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('assets/icons/location_icon.svg', 'Shipping Address'),
          SizedBox(height: 18.h),
          _fieldLabel('Full Name'),
          _inputField(controller: _fullNameController),
          SizedBox(height: 14.h),
          _fieldLabel('Street Address'),
          _inputField(controller: _streetController),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('City'),
                    _inputField(controller: _cityController),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('State'),
                    _inputField(controller: _stateController),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('ZIP Code'),
                    _inputField(controller: _zipController),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Phone'),
                    _inputField(controller: _phoneController),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          _primaryButton(
            label: 'Continue to Payment',
            onTap: () => context.push('/market/checkout/payment'),
          ),
        ],
      ),
    );
  }

  Widget _paymentContent(BuildContext context) {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('assets/icons/wallet_icon.svg', 'Payment Information'),
          SizedBox(height: 18.h),
          _fieldLabel('Card Number'),
          _inputField(controller: _cardNumberController),
          SizedBox(height: 14.h),
          _fieldLabel('Cardholder Name'),
          _inputField(controller: _cardholderController),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Expiry Date'),
                    _inputField(controller: _expiryController),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('CVV'),
                    _inputField(controller: _cvvController),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.darkText.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 16.sp,
                  color: AppColors.lightText,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'Your payment information is encrypted and secure',
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.lightText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _secondaryButton(
                  label: 'Back',
                  onTap: () => context.go('/user/checkout'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _primaryButton(
                  label: 'Review Order',
                  onTap: () => context.push('/market/checkout/review'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reviewContent(BuildContext context) {
    const total = 1581.00;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF8F0), Color(0xFFF6E2D1)],
            ),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: AppColors.redButton.withValues(alpha: 0.20),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: const BoxDecoration(
                  color: AppColors.redButton,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColors.bodyBg,
                  size: 34.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Almost There!',
                style: TextStyles.boldLarge.copyWith(
                  color: AppColors.lightText,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Review your order details before\nconfirming',
                textAlign: TextAlign.center,
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.lightText,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                height: 1,
                color: AppColors.redButton.withValues(alpha: 0.18),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        _reviewInfoCard(
          icon: 'assets/icons/location_icon.svg',
          title: 'Delivery Address',
          subtitle: "Where we'll send your treasure",
          lines: const [
            'Shaq Fix',
            '24 Street , USA',
            'New York, NY 5465',
            '+1 212 2465 2649',
          ],
          onEdit: () => context.go('/user/checkout'),
        ),
        SizedBox(height: 12.h),
        _reviewInfoCard(
          icon: Icons.credit_card_outlined,
          title: 'Payment Method',
          subtitle: 'Secure payment processing',
          lines: const [
            '**** **** **** 6566',
            'My card',
            'Expires 09/27',
          ],
          onEdit: () => context.go('/market/checkout/payment'),
          cardTint: const Color(0xFFFFF4F2),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF7ECDD),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const _MiniFeature(label: 'Secure Checkout', iconPath: 'assets/icons/shield_protection_icon.svg'),
              Container(
                width: 1,
                height: 30.h,
                color: AppColors.redButton.withValues(alpha: 0.2),
              ),
              const _MiniFeature(label: 'Encrypted', iconPath: 'assets/icons/lock_icon.svg'),
              Container(
                width: 1,
                height: 30.h,
                color: AppColors.redButton.withValues(alpha: 0.2),
              ),
              const _MiniFeature(label: 'Tracked Shipping', iconPath: 'assets/icons/package_icon.svg'),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
          decoration: BoxDecoration(
            color: AppColors.gradientColor1,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withValues(alpha: 0.16),
                blurRadius: 22,
                spreadRadius: -12,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.bodyBg.withValues(alpha: 0.28),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Icon(
                      Icons.auto_awesome_outlined,
                      color: AppColors.darkText,
                      size: 16.sp,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.bodyBg.withValues(alpha: 0.28),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              _summaryRow('Subtotal', '\$1422.90'),
              SizedBox(height: 10.h),
              _summaryRow('Shipping', '\$79.05'),
              SizedBox(height: 10.h),
              _summaryRow('Tax', '\$79.05'),
              SizedBox(height: 16.h),
              Container(
                height: 1,
                color: AppColors.bodyBg.withValues(alpha: 0.28),
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyles.regularLarge.copyWith(
                      color: const Color(0xFFF8E8C7),
                      fontSize: TextStyles.regularLarge.fontSize! - 5.sp,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyles.boldLarge.copyWith(
                          color: Colors.white,
                          fontSize: 32.sp,
                        ),
                      ),
                      Text(
                        'USD',
                        style: TextStyles.regularSmall.copyWith(
                          color: const Color(0xFFF8E8C7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              _primaryButton(
                label: 'Place Order',
                iconPath: 'assets/icons/lock_icon.svg',
                trailingIcon: Icons.auto_awesome_outlined,
                onTap: () => context.push('/market/checkout/success'),
              ),
              SizedBox(height: 12.h),
              Text(
                'By placing this order, you agree to our\nterms and conditions',
                textAlign: TextAlign.center,
                style: TextStyles.regularExtraSmall.copyWith(
                  color: const Color(0xFFF8E8C7),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _successContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 18.h),
        Container(
          width: 96.w,
          height: 96.w,
          decoration: const BoxDecoration(
            color: Color(0xFF44DB72),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/check_email_icon.svg',
              width: 56.sp,
              height: 56.sp,
              colorFilter: const ColorFilter.mode(
                AppColors.bodyBg,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'Order Confirmed!',
          style: TextStyles.boldLarge.copyWith(
            color: AppColors.lightText,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Thank you for your purchase',
          style: TextStyles.regularMedium.copyWith(
            color: AppColors.lightText,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Order\n#VV266587',
          textAlign: TextAlign.center,
          style: TextStyles.regularSmall.copyWith(
            color: AppColors.lightText.withValues(alpha: 0.82),
            height: 1.35,
          ),
        ),
        SizedBox(height: 18.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
          decoration: BoxDecoration(
            color: AppColors.bodyBg,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.lightText.withValues(alpha: 0.10),
            ),
          ),
          child: Column(
            children: [
              _statusRow(
                color: const Color(0xFF44DB72),
                iconPath: 'assets/icons/check_email_icon.svg',
                title: 'Order Placed',
                subtitle: 'Your order has been confirmed',
              ),
              SizedBox(height: 18.h),
              _statusRow(
                color: const Color(0xFFFFF0E0),
                iconPath: 'assets/icons/package_icon.svg',
                title: 'Processing',
                subtitle: 'Seller is preparing your item',
                iconColor: AppColors.redButton,
              ),
              SizedBox(height: 18.h),
              _statusRow(
                color: const Color(0xFFFFF0E0),
                icon: Icons.local_shipping_outlined,
                title: 'Shipping',
                subtitle: 'Estimated delivery: December 23, 2025',
                iconColor: AppColors.redButton,
              ),
              SizedBox(height: 18.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                decoration: BoxDecoration(
                  color: AppColors.gradientColor1,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TRACKING AVAILABLE SOON',
                      style: TextStyles.mediumExtraSmall.copyWith(
                        color: const Color(0xFFF8E8C7),
                        letterSpacing: 0.6,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "We'll send you a tracking number once your\nitem ships",
                      style: TextStyles.regularSmall.copyWith(
                        color: const Color(0xFFF8E8C7),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        _primaryButton(
          label: 'Back to Home',
          iconPath: 'assets/icons/admin_nav_home.svg',
          textColor: const Color(0xFFF8E8C7),
          onTap: () => context.go('/homeScreen'),
        ),
        SizedBox(height: 10.h),
        _secondaryButton(
          label: 'View Order Details',
          onTap: () => context.push('/user/orders/history', extra: {'from': 'checkout_success'}),
          outlinedRed: true,
        ),
      ],
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.lightText.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.08),
            blurRadius: 18,
            spreadRadius: -12,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String iconPath, String title) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 22.sp,
          height: 22.sp,
          colorFilter: const ColorFilter.mode(
            AppColors.redButton,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyles.boldLarge.copyWith(
            color: AppColors.lightText,
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextStyles.mediumMedium.copyWith(
          color: AppColors.lightText,
        ),
      ),
    );
  }

  Widget _inputField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      style: TextStyles.regularMedium.copyWith(
        color: AppColors.lightText,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.lightText.withValues(alpha: 0.10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.lightText.withValues(alpha: 0.10),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.redButton.withValues(alpha: 0.28),
          ),
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    String? iconPath,
    IconData? trailingIcon,
    String? trailingIconPath,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.redButton,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null) ...[
              SvgPicture.asset(
                iconPath,
                width: 18.sp,
                height: 18.sp,
                colorFilter: ColorFilter.mode(textColor ?? AppColors.bodyBg, BlendMode.srcIn),
              ),
              SizedBox(width: 8.w),
            ] else if (icon != null) ...[
              Icon(icon, size: 18.sp, color: textColor ?? AppColors.bodyBg),
              SizedBox(width: 8.w),
            ],
            Text(
              label,
              style: TextStyles.mediumMedium.copyWith(
                color: textColor ?? AppColors.bodyBg,
              ),
            ),
            if (trailingIconPath != null) ...[
              SizedBox(width: 8.w),
              SvgPicture.asset(
                trailingIconPath,
                width: 18.sp,
                height: 18.sp,
                colorFilter: ColorFilter.mode(textColor ?? AppColors.bodyBg, BlendMode.srcIn),
              ),
            ] else if (trailingIcon != null) ...[
              SizedBox(width: 8.w),
              Icon(trailingIcon, size: 18.sp, color: textColor ?? AppColors.bodyBg),
            ],
          ],
        ),
      ),
    );
  }

  Widget _secondaryButton({
    required String label,
    required VoidCallback onTap,
    bool outlinedRed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: outlinedRed ? Colors.transparent : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: outlinedRed
                ? AppColors.redButton.withValues(alpha: 0.80)
                : AppColors.lightText.withValues(alpha: 0.10),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.mediumMedium.copyWith(
              color: outlinedRed ? AppColors.redButton : AppColors.lightText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewInfoCard({
    required dynamic icon,
    required String title,
    required String subtitle,
    required List<String> lines,
    required VoidCallback onEdit,
    Color? cardTint,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.redButton.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1EA),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: icon is String
                    ? Center(child: SvgPicture.asset(icon, width: 24.sp, height: 24.sp, colorFilter: const ColorFilter.mode(AppColors.redButton, BlendMode.srcIn)))
                    : Icon(icon, size: 22.sp, color: AppColors.redButton),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.lightText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: Text(
                  'Edit',
                  style: TextStyles.mediumSmall.copyWith(
                    color: AppColors.redButton,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 4.h),
            decoration: BoxDecoration(
              color: cardTint ?? const Color(0xFFFCF7F2),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines
                  .map(
                    (line) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: const BoxDecoration(
                                color: AppColors.redButton,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              line,
                              style: TextStyles.regularMedium.copyWith(
                                color: AppColors.lightText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow({
    required Color color,
    IconData? icon,
    String? iconPath,
    required String title,
    required String subtitle,
    Color iconColor = AppColors.bodyBg,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: iconPath != null
              ? Center(
                  child: SvgPicture.asset(
                    iconPath,
                    width: 22.sp,
                    height: 22.sp,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                )
              : Icon(icon, size: 22.sp, color: iconColor),
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
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyles.regularSmall.copyWith(
                  color: AppColors.lightText.withValues(alpha: 0.82),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.regularMedium.copyWith(
              color: const Color(0xFFF8E8C7),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyles.mediumMedium.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _CheckoutStepper extends StatelessWidget {
  const _CheckoutStepper({required this.step});

  final CheckoutStep step;

  @override
  Widget build(BuildContext context) {
    final states = [
      _StepState(
        label: 'Shipping',
        value: step.index > CheckoutStep.shipping.index ? 'check' : '1',
        active: step == CheckoutStep.shipping,
        done: step.index > CheckoutStep.shipping.index,
      ),
      _StepState(
        label: 'Payment',
        value: step.index > CheckoutStep.payment.index ? 'check' : '2',
        active: step == CheckoutStep.payment,
        done: step.index > CheckoutStep.payment.index,
      ),
      _StepState(
        label: 'Review',
        value: '3',
        active: step == CheckoutStep.review,
        done: false,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < states.length; i++) ...[
          _StepperNode(state: states[i]),
          if (i != states.length - 1)
            Expanded(
              child: Container(
                height: 4.h,
                margin: EdgeInsets.only(bottom: 22.h),
                color: states[i].done || states[i + 1].active
                    ? AppColors.redButton
                    : AppColors.bodyBg,
              ),
            ),
        ],
      ],
    );
  }
}

class _StepperNode extends StatelessWidget {
  const _StepperNode({required this.state});

  final _StepState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 38.w,
          height: 38.w,
          decoration: BoxDecoration(
            color: state.active || state.done
                ? AppColors.redButton
                : AppColors.bodyBg,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: state.value == 'check'
                ? Icon(
                    Icons.check_rounded,
                    size: 20.sp,
                    color: AppColors.bodyBg,
                  )
                : Text(
                    state.value,
                    style: TextStyles.mediumMedium.copyWith(
                      color: state.active ? AppColors.bodyBg : AppColors.lightText,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          state.label,
          style: TextStyles.mediumSmall.copyWith(
            color: state.active || state.done
                ? AppColors.bodyBg
                : AppColors.bodyBg.withValues(alpha: 0.70),
          ),
        ),
      ],
    );
  }
}

class _StepState {
  const _StepState({
    required this.label,
    required this.value,
    required this.active,
    required this.done,
  });

  final String label;
  final String value;
  final bool active;
  final bool done;
}

class _MiniFeature extends StatelessWidget {
  const _MiniFeature({
    required this.label,
    this.icon,
    this.iconPath,
  });

  final String label;
  final IconData? icon;
  final String? iconPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconPath != null)
          SvgPicture.asset(
            iconPath!,
            width: 18.sp,
            height: 18.sp,
            colorFilter: const ColorFilter.mode(
              AppColors.redButton,
              BlendMode.srcIn,
            ),
          )
        else
          Icon(
            icon,
            size: 18.sp,
            color: AppColors.redButton,
          ),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyles.regularSmall.copyWith(
            color: AppColors.lightText,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}
