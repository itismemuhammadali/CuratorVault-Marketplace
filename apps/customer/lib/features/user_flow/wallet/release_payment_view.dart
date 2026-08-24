import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/buttons/custom_button.dart';
import '../../../core/theme/images.dart';
import '../../../core/theme/text_styles.dart';

class ReleasePaymentView extends StatefulWidget {
  const ReleasePaymentView({
    super.key,
    required this.orderId,
    required this.itemTitle,
    required this.amount,
    required this.seller,
    required this.date,
  });

  final String orderId;
  final String itemTitle;
  final String amount;
  final String seller;
  final String date;

  @override
  State<ReleasePaymentView> createState() => _ReleasePaymentViewState();
}

enum _ReleaseFlowMode { initial, confirm, dispute }

class _ReleasePaymentViewState extends State<ReleasePaymentView> {
  final TextEditingController _disputeController = TextEditingController();
  _ReleaseFlowMode _mode = _ReleaseFlowMode.initial;
  bool _showToast = false;
  String _toastMessage = '';

  @override
  void dispose() {
    _disputeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            child: Column(
              children: [
                _topHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 20.h),
                    child: Column(
                      children: [
                        _itemInfoCard(),
                        SizedBox(height: 12.h),
                        _escrowProtectionCard(),
                        SizedBox(height: 12.h),
                        if (_mode == _ReleaseFlowMode.initial) _beforeReleasingCard(),
                        if (_mode == _ReleaseFlowMode.initial) SizedBox(height: 12.h),
                        if (_mode == _ReleaseFlowMode.initial) _processingTimeCard(),
                        if (_mode == _ReleaseFlowMode.confirm) _confirmReleaseCard(),
                        if (_mode == _ReleaseFlowMode.dispute) _disputeCard(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
                  child: _bottomActionRow(),
                ),
              ],
            ),
          ),
          if (_showToast)
            Positioned(
              top: MediaQuery.of(context).padding.top + 240.h,
              left: 12.w,
              right: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: _toastMessage.contains('Dispute')
                      ? const Color(0xFFD4A574)
                      : const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    if (_toastMessage.contains('Dispute'))
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1F2937),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check,
                            size: 14.sp,
                            color: const Color(0xFFD4A574),
                          ),
                        ),
                      )
                    else
                      SvgPicture.asset(
                        'assets/icons/bold_tick_circle_icon.svg',
                        width: 20.w,
                        height: 20.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF22C55E),
                          BlendMode.srcIn,
                        ),
                      ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _toastMessage,
                        style: TextStyles.mediumMedium.copyWith(
                          color: _toastMessage.contains('Dispute')
                              ? const Color(0xFF1F2937)
                              : const Color(0xFF22C55E),
                          fontSize: 14.sp,
                        ),
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

  Widget _topHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 54.h, 18.w, 22.h),
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
            color: AppColors.shadowColor.withValues(alpha: 0.25),
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
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 44.w,
              width: 44.w,
              decoration: BoxDecoration(
                color: AppColors.bodyBg.withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  AppImages.backIcon,
                  width: 18.sp,
                  height: 18.sp,
                  color: AppColors.darkText,
                ),
              ),
            ),
          ),
          SizedBox(height: 22.h),
          Text(
            'Release Payment',
            style: TextStyles.boldMedium.copyWith(
              color: AppColors.darkText,
              fontSize: 28.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Container(
              height: 62.w,
              width: 62.w,
              decoration: BoxDecoration(
                color: AppColors.bodyBg.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  AppImages.sheildIcon,
                  width: 28.sp,
                  height: 28.sp,
                  color: AppColors.darkText,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text(
              'Escrow Amount',
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.darkText.withValues(alpha: 0.85),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Center(
            child: Text(
              widget.amount,
              style: TextStyles.boldLarge.copyWith(
                color: AppColors.darkText,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.bodyBg.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                widget.orderId,
                style: TextStyles.mediumSmall.copyWith(
                  color: AppColors.darkText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE9D8C5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item section with icon on left, item name on right (same row)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50.w,
                width: 50.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F1F1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/package_icon.svg',
                    width: 24.sp,
                    height: 24.sp,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFB75D4F),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item',
                      style: TextStyles.regularSmall.copyWith(
                        color: const Color(0xFF98A2B3),
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      widget.itemTitle,
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            height: 1,
            color: const Color(0xFFE9D8C5),
          ),
          SizedBox(height: 16.h),
          // Seller and Date in two columns - icon and label on same line
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/profile_icon.svg',
                          width: 14.sp,
                          height: 14.sp,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFB75D4F),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Seller',
                          style: TextStyles.regularSmall.copyWith(
                            color: const Color(0xFF98A2B3),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      widget.seller,
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppImages.calenderEmptyIcon,
                          width: 14.sp,
                          height: 14.sp,
                          color: const Color(0xFFB75D4F),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Date',
                          style: TextStyles.regularSmall.copyWith(
                            color: const Color(0xFF98A2B3),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      widget.date,
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _escrowProtectionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4F2),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE9D8C5), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/shield_protection_icon.svg',
                width: 22.sp,
                height: 22.sp,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFD79A55),
                  BlendMode.srcIn,
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
                  'Escrow Protection Active',
                  style: TextStyles.boldMedium.copyWith(
                    color: AppColors.gradientColor1,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your payment is held securely in escrow. Release the payment only after you\'ve received and inspected the item. Once released, the funds will be transferred to the seller.',
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.gradientColor1.withValues(alpha: 0.85),
                    height: 1.5,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _beforeReleasingCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Before Releasing Payment',
            style: TextStyles.mediumMedium.copyWith(
              color: AppColors.gradientColor1,
            ),
          ),
          SizedBox(height: 10.h),
          _bullet('Confirm you have received the item'),
          _bullet('Verify the item matches the description'),
          _bullet('Check for any damages or defects'),
          _bullet('Contact the seller if you have concerns'),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 7.h),
            height: 4.w,
            width: 4.w,
            decoration: const BoxDecoration(
              color: AppColors.redBackBg,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.regularMedium.copyWith(
                color: const Color(0xFF667085),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _processingTimeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDCE8FF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFC4D8FF), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40.w,
            width: 40.w,
            decoration: const BoxDecoration(
              color: Color(0xFF2F6BFF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                AppImages.sheildIcon,
                width: 18.sp,
                height: 18.sp,
                color: AppColors.bodyBg,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Processing Time',
                  style: TextStyles.mediumMedium.copyWith(
                    color: const Color(0xFF1F4ED8),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Withdrawals typically take 1-3\nbusiness days to reach your\naccount.',
                  style: TextStyles.mediumMedium.copyWith(
                    color: const Color(0xFF1D4ED8),
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

  Widget _confirmReleaseCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF22C55E), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/check_email_icon.svg',
                width: 16.sp,
                height: 16.sp,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF22C55E),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Confirm Payment Release',
                style: TextStyles.mediumMedium.copyWith(
                  color: AppColors.gradientColor1,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFDBF5E5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You\'re about to release:',
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.gradientColor1,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.amount,
                  style: TextStyles.semiBoldLarge.copyWith(
                    color: const Color(0xFF22C55E),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'to ${widget.seller}',
                  style: TextStyles.mediumSmall.copyWith(
                    color: AppColors.gradientColor1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'By releasing this payment, you confirm that you have received the item and are satisfied with the purchase. This action cannot be undone.',
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.gradientColor1.withValues(alpha: 0.90),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _disputeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFEF4444), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.08),
            blurRadius: 14,
            spreadRadius: -10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppImages.alertIcon,
                width: 16.sp,
                height: 16.sp,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFEF4444),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Raise a Dispute',
                style: TextStyles.mediumMedium.copyWith(
                  color: AppColors.gradientColor1,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Reason for Dispute',
            style: TextStyles.mediumSmall.copyWith(
              color: AppColors.gradientColor1,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 106.h,
            padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE2C4A3), width: 1),
            ),
            child: TextField(
              controller: _disputeController,
              maxLines: 4,
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.gradientColor1,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Please describe the issue with this\ntransaction...',
                hintStyle: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomActionRow() {
    switch (_mode) {
      case _ReleaseFlowMode.initial:
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                onTap: () => setState(() => _mode = _ReleaseFlowMode.dispute),
                height: 48.h,
                borderRadius: 10.r,
                btnColor: AppColors.bodyBg,
                borderColor: const Color(0xFFEF4444),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/exclamation_circle_icon.svg',
                      width: 14.sp,
                      height: 14.sp,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFEF4444),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Raise Dispute',
                      style: TextStyles.mediumMedium.copyWith(
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomButton(
                onTap: () => setState(() => _mode = _ReleaseFlowMode.confirm),
                height: 48.h,
                borderRadius: 10.r,
                btnColor: const Color(0xFF22C55E),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/check_email_icon.svg',
                      width: 14.sp,
                      height: 14.sp,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFFFFFF),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Release Payment',
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.bodyBg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case _ReleaseFlowMode.confirm:
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                onTap: () => setState(() => _mode = _ReleaseFlowMode.initial),
                height: 48.h,
                borderRadius: 10.r,
                btnColor: AppColors.bodyBg,
                borderColor: const Color(0xFFD1D5DB),
                btnText: 'Cancel',
                textStyle: TextStyles.mediumMedium.copyWith(
                  color: AppColors.gradientColor1,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomButton(
                onTap: _confirmRelease,
                height: 48.h,
                borderRadius: 10.r,
                btnColor: const Color(0xFF22C55E),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/check_email_icon.svg',
                      width: 14.sp,
                      height: 14.sp,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFFFFFF),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Confirm Release',
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.bodyBg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case _ReleaseFlowMode.dispute:
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                onTap: () => setState(() => _mode = _ReleaseFlowMode.initial),
                height: 48.h,
                borderRadius: 10.r,
                btnColor: AppColors.bodyBg,
                borderColor: const Color(0xFFD1D5DB),
                btnText: 'Cancel',
                textStyle: TextStyles.mediumMedium.copyWith(
                  color: AppColors.gradientColor1,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomButton(
                onTap: _submitDispute,
                height: 48.h,
                borderRadius: 10.r,
                btnColor: const Color(0xFFEF4444),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppImages.alertIcon,
                      width: 14.sp,
                      height: 14.sp,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFFFFFF),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Submit Dispute',
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.bodyBg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }

  void _confirmRelease() {
    // Show toast and close after 2 seconds
    setState(() {
      _showToast = true;
      _toastMessage = 'Payment released successfully!';
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _submitDispute() {
    // Show toast and close after 2 seconds
    setState(() {
      _showToast = true;
      _toastMessage = 'Dispute raised. Our team will contact you shortly.';
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
}



