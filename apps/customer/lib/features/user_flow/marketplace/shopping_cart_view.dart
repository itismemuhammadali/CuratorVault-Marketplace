import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class ShoppingCartView extends StatefulWidget {
  const ShoppingCartView({super.key});

  @override
  State<ShoppingCartView> createState() => _ShoppingCartViewState();
}

class _ShoppingCartViewState extends State<ShoppingCartView> {
  final TextEditingController _promoController = TextEditingController();
  int _quantity = 1;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const subtotal = 1450.0;
    const shipping = 15.0;
    const tax = 116.0;
    final total = subtotal + shipping + tax;

    return Scaffold(
      backgroundColor: AppColors.subPageBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: IconBox(
            icon: AppImages.backIcon,
            bgColor: AppColors.darkText.withValues(alpha: 0.20),
            onTap: () => context.pop(),
            iconColor: AppColors.darkText,
            height: 40.h,
            width: 40.w,
            borderRadius: 100.r,
          ),
          title: Text(
            'Shopping Cart',
            style: TextStyles.boldLarge.copyWith(color: AppColors.bodyBg),
          ),
          height: 170.h,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(22.w, 14.h, 22.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 16.w, 18.h),
                decoration: BoxDecoration(
                  color: AppColors.bodyBg,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor.withValues(alpha: 0.10),
                      blurRadius: 26,
                      spreadRadius: -12,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18.r),
                      child: Image.asset(
                        AppImages.productOne,
                        width: 92.w,
                        height: 92.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Victorian Pocket Watch',
                              maxLines: 2,
                              style: TextStyles.boldLarge.copyWith(
                                color: AppColors.gradientColor1,
                                fontSize: 20.sp,
                                height: 1.08,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Heritage Antiques',
                              style: TextStyles.regularMedium.copyWith(
                                color: AppColors.greyText,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '\$1,450',
                              style: TextStyles.boldLarge.copyWith(
                                color: AppColors.redButton,
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                _QuantityButton(
                                  label: '-',
                                  onTap: () {
                                    if (_quantity <= 1) return;
                                    setState(() {
                                      _quantity -= 1;
                                    });
                                  },
                                ),
                                SizedBox(width: 18.w),
                                Text(
                                  '$_quantity',
                                  style: TextStyles.mediumLarge.copyWith(
                                    color: AppColors.gradientColor1,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(width: 18.w),
                                _QuantityButton(
                                  label: '+',
                                  onTap: () {
                                    setState(() {
                                      _quantity += 1;
                                    });
                                  },
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 42.w,
                                    height: 42.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDC2626).withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(11.r),
                                      child: SvgPicture.asset(
                                        'assets/icons/delete_icon.svg',
                                        colorFilter: const ColorFilter.mode(
                                          Color(0xFFDC2626),
                                          BlendMode.srcIn,
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Container(
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
                decoration: BoxDecoration(
                  color: AppColors.bodyBg,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor.withValues(alpha: 0.08),
                      blurRadius: 24,
                      spreadRadius: -12,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/category_icon.svg',
                          width: 20.sp,
                          height: 20.sp,
                          colorFilter: const ColorFilter.mode(
                            AppColors.redButton,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.w),

                        Text(
                          'Promo Code',
                          style: TextStyles.boldLarge.copyWith(
                            color: AppColors.gradientColor1,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _promoController,
                            decoration: InputDecoration(
                              hintText: 'Enter code (try VINTAGE10)',
                              hintStyle: TextStyles.regularLarge.copyWith(
                                color: AppColors.greyText,
                                fontSize: 15.sp,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF9F9F9),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18.r),
                                borderSide: BorderSide(
                                  color: AppColors.lightText.withValues(alpha: 0.10),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18.r),
                                borderSide: BorderSide(
                                  color: AppColors.lightText.withValues(alpha: 0.10),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18.r),
                                borderSide: BorderSide(
                                  color: AppColors.redButton.withValues(alpha: 0.30),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 64.h,
                            width: 118.w,
                            decoration: BoxDecoration(
                              color: AppColors.redButton,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: Text(
                                'Apply',
                                style: TextStyles.semiBoldLarge.copyWith(
                                  color: const Color(0xFFF8E8C7),
                                  fontSize: 17.sp,
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
              SizedBox(height: 14.h),
              Container(
                padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 22.h),
                decoration: BoxDecoration(
                  color: AppColors.gradientColor1,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: AppColors.bodyBg.withValues(alpha: 0.45),
                    width: 1.1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor.withValues(alpha: 0.20),
                      blurRadius: 28,
                      spreadRadius: -12,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyles.boldLarge.copyWith(
                        color: const Color(0xFFF8E8C7),
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Container(
                      height: 1,
                      color: AppColors.bodyBg.withValues(alpha: 0.35),
                    ),
                    SizedBox(height: 20.h),
                    _SummaryRow(label: 'Subtotal', value: '\$1,450'),
                    SizedBox(height: 14.h),
                    _SummaryRow(label: 'Shipping', value: '\$15'),
                    SizedBox(height: 14.h),
                    _SummaryRow(label: 'Tax (8%)', value: '\$116.00'),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppColors.bodyBg.withValues(alpha: 0.35),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Icon(
                          Icons.auto_awesome_outlined,
                          color: AppColors.darkText,
                          size: 16.sp,
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppColors.bodyBg.withValues(alpha: 0.35),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Total Amount',
                            style: TextStyles.regularLarge.copyWith(
                              color: const Color(0xFFF8E8C7),
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: TextStyles.boldLarge.copyWith(
                                color: Colors.white,
                                fontSize: 34.sp,
                                height: 0.95,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'USD',
                              style: TextStyles.regularMedium.copyWith(
                                color: const Color(0xFFF8E8C7),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () => context.push('/market/checkout/shipping'),
                      child: Container(
                        height: 58.h,
                        decoration: BoxDecoration(
                          color: AppColors.redButton,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Center(
                          child: Text(
                            'Proceed to Checkout',
                            style: TextStyles.regularLarge.copyWith(
                              color: const Color(0xFFF8E8C7),
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Center(
                      child: GestureDetector(
                        onTap: () => context.push('/user/privacy-terms'),
                        child: Text(
                          'By placing this order, you agree to our\nterms and conditions',
                          textAlign: TextAlign.center,
                          style: TextStyles.regularMedium.copyWith(
                            color: const Color(0xFFF8E8C7),
                            fontSize: 13.sp,
                            height: 1.35,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuantityButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: AppColors.darkText.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.mediumLarge.copyWith(
              color: AppColors.gradientColor1,
              fontSize: 22.sp,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.regularLarge.copyWith(
              color: AppColors.darkText,
              fontSize: 16.sp,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyles.regularLarge.copyWith(
            color: const Color(0xFFF8E8C7),
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
