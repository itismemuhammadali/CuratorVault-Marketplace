import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class SaleDetailView extends StatelessWidget {
  final String title;
  final String saleId;
  final String amount;
  final String buyer;
  final String paid;
  final String image;
  final bool isCompleted;
  final bool isRefunded;

  const SaleDetailView({
    super.key,
    required this.title,
    required this.saleId,
    required this.amount,
    required this.buyer,
    required this.paid,
    required this.image,
    this.isCompleted = false,
    this.isRefunded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          height: 144.h,
          leading: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.bodyBg.withValues(alpha: 0.22),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 20.sp,
                color: AppColors.darkText,
              ),
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sale Detail',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldSection.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                'Detailed information about the sale transaction',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.regularExtraSmall.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.76),
                  fontSize: 13.sp,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFAFAFB),
      bottomNavigationBar: (isCompleted || isRefunded)
          ? _closedBottomAction(context)
          : _bottomActions(context),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 11.h, 16.w, 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _heroImage(),
              SizedBox(height: 13.h),
              Text(
                _detailTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldMedium.copyWith(
                  color: const Color(0xFF344054),
                  fontSize: 18.sp,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    'Sale ID:',
                    style: TextStyles.regularExtraSmall.copyWith(
                      color: const Color(0xFF667085),
                      fontSize: 14.sp,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'S-$_displaySaleId',
                    style: TextStyles.boldSmall.copyWith(
                      color: const Color(0xFF344054),
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              _paymentCard(),
              SizedBox(height: 13.h),
              Row(
                children: [
                  Expanded(
                    child: _personCard(
                      icon: Icons.person_outline_rounded,
                      title: 'Buyer',
                      name: _displayBuyer,
                      email: _displayBuyerEmail,
                      accent: const Color(0xFF4F79FF),
                      bg: const Color(0xFFF2F7FF),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _personCard(
                      icon: Icons.person_outline_rounded,
                      title: 'Seller',
                      name: _displaySeller,
                      email: _displaySellerEmail,
                      accent: const Color(0xFFB75CFF),
                      bg: const Color(0xFFFBF5FF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 13.h),
              isRefunded
                  ? _refundedTimelineCard()
                  : isCompleted
                  ? _completedTimelineCard()
                  : _timelineCard(),
              if (!isRefunded) ...[
                SizedBox(height: 13.h),
                _warningCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String get _detailTitle {
    if (isRefunded) return '1970s Porsche Sunglasses';
    if (isCompleted) return 'Vintage Rolex Submariner 1960s';
    if (title.contains('Rolex')) return 'Vintage Rolex Submariner 1960s';
    return title.replaceAll('...', '');
  }

  String get _displaySaleId => isRefunded ? '005' : isCompleted ? '001' : saleId;

  String get _displayAmount => isRefunded ? r'$180.00' : isCompleted ? r'$420.00' : amount;

  String get _displayPaid => isRefunded ? 'Feb 6, 2026' : isCompleted ? 'Jan 25, 2026' : paid;

  String get _displayBuyer => isRefunded ? 'Emma Brown' : isCompleted ? 'John Smith' : buyer;

  String get _displayBuyerEmail => isRefunded ? 'emma@example.com' : 'john@example.com';

  String get _displayImage => isRefunded ? AppImages.productFive : isCompleted ? AppImages.productFour : image;

  String get _displaySeller => isRefunded ? 'Retro Eyewear' : 'Classic Watches Co';

  String get _displaySellerEmail => isRefunded ? 'seller@retroeyewear.com' : 'seller@classicwatches.com';

  Widget _heroImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.asset(
        _displayImage,
        width: double.infinity,
        height: 164.h,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: double.infinity,
            height: 164.h,
            color: const Color(0xFFF3F4F6),
            child: Icon(
              Icons.image_outlined,
              color: const Color(0xFF111827),
              size: 52.sp,
            ),
          );
        },
      ),
    );
  }

  Widget _paymentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 13.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFCF4),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFBFECCF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_money_rounded,
                size: 20.sp,
                color: const Color(0xFF16A34A),
              ),
              SizedBox(width: 8.w),
              Text(
                'Payment',
                style: TextStyles.boldSmall.copyWith(
                  color: const Color(0xFF344054),
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            _displayAmount,
            style: TextStyles.boldLarge.copyWith(
              color: const Color(0xFF16A34A),
              fontSize: 34.sp,
              height: 1,
            ),
          ),
          SizedBox(height: 11.h),
          Text(
            'Paid on $_displayPaid',
            style: TextStyles.regularExtraSmall.copyWith(
              color: const Color(0xFF667085),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _personCard({
    required IconData icon,
    required String title,
    required String name,
    required String email,
    required Color accent,
    required Color bg,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: 75.h),
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 9.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/profile_icon.svg',
                width: 15.w,
                height: 15.w,
                colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
              ),
              SizedBox(width: 6.w),
              Text(
                title,
                style: TextStyles.boldExtraSmall.copyWith(
                  color: const Color(0xFF344054),
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldExtraSmall.copyWith(
              color: const Color(0xFF344054),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularTiny.copyWith(
              color: const Color(0xFF667085),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(13.w, 13.h, 13.w, 13.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE4E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.swap_horiz_rounded,
                size: 17.sp,
                color: const Color(0xFFB75CFF),
              ),
              SizedBox(width: 8.w),
              Text(
                'Transaction Timeline',
                style: TextStyles.boldSmall.copyWith(
                  color: const Color(0xFF344054),
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 13.h),
          _timelineItem(
            useSvgIcon: true,
            svgPath: 'assets/icons/check_email_icon.svg',
            iconColor: const Color(0xFF22C55E),
            bg: const Color(0xFFE8F8EE),
            title: 'Payment Received',
            subtitle: 'Funds held in escrow - Feb 8, 2026',
          ),
          SizedBox(height: 11.h),
          _timelineItem(
            icon: Icons.access_time_rounded,
            iconColor: const Color(0xFFFFA149),
            bg: const Color(0xFFFFF0DC),
            title: 'Awaiting Action',
            subtitle: 'Waiting for seller to ship item',
          ),
        ],
      ),
    );
  }

  Widget _completedTimelineCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(13.w, 13.h, 13.w, 11.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE4E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.swap_horiz_rounded,
                size: 17.sp,
                color: const Color(0xFFB75CFF),
              ),
              SizedBox(width: 8.w),
              Text(
                'Transaction Timeline',
                style: TextStyles.boldSmall.copyWith(
                  color: const Color(0xFF344054),
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 13.h),
          _timelineItem(
            useSvgIcon: true,
            svgPath: 'assets/icons/check_email_icon.svg',
            iconColor: const Color(0xFF22C55E),
            bg: const Color(0xFFE8F8EE),
            title: 'Payment Received',
            subtitle: 'Funds held in escrow - Jan 25, 2026',
          ),
          SizedBox(height: 11.h),
          _timelineItem(
            icon: Icons.local_shipping_outlined,
            iconColor: const Color(0xFF3B82F6),
            bg: const Color(0xFFEAF2FF),
            title: 'Item Shipped',
            subtitle: 'Tracking: 1Z999AA10123456784',
          ),
          SizedBox(height: 11.h),
          _timelineItem(
            useSvgIcon: true,
            svgPath: 'assets/icons/check_email_icon.svg',
            iconColor: const Color(0xFFB75CFF),
            bg: const Color(0xFFF8EFFF),
            title: 'Payment Released to Seller',
            subtitle: 'Transaction completed - Jan 30, 2026',
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 35.w),
            padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(3.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(
              '*****\n"Beautiful piece, works perfectly!"',
              style: TextStyles.regularExtraSmall.copyWith(
                color: const Color(0xFF667085),
                fontSize: 13.sp,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _refundedTimelineCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(13.w, 13.h, 13.w, 13.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE4E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.swap_horiz_rounded,
                size: 17.sp,
                color: const Color(0xFFB75CFF),
              ),
              SizedBox(width: 8.w),
              Text(
                'Transaction Timeline',
                style: TextStyles.boldSmall.copyWith(
                  color: const Color(0xFF344054),
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 13.h),
          _timelineItem(
            useSvgIcon: true,
            svgPath: 'assets/icons/check_email_icon.svg',
            iconColor: const Color(0xFF22C55E),
            bg: const Color(0xFFE8F8EE),
            title: 'Payment Received',
            subtitle: 'Funds held in escrow - Jan 28, 2026',
          ),
          SizedBox(height: 11.h),
          _timelineItem(
            icon: Icons.local_shipping_outlined,
            iconColor: const Color(0xFF3B82F6),
            bg: const Color(0xFFEAF2FF),
            title: 'Item Shipped',
            subtitle: 'Tracking: 1Z999AA10123456787\nJan 29, 2026',
            maxSubtitleLines: 2,
          ),
          SizedBox(height: 11.h),
          _timelineItem(
            icon: Icons.refresh_rounded,
            iconColor: const Color(0xFFFF3B4F),
            bg: const Color(0xFFFFE3E3),
            title: 'Payment Refunded to Buyer',
            subtitle: 'Transaction cancelled - Feb 1, 2026',
          ),
        ],
      ),
    );
  }

  Widget _timelineItem({
    required Color iconColor,
    required Color bg,
    required String title,
    required String subtitle,
    IconData? icon,
    bool useSvgIcon = false,
    String? svgPath,
    int maxSubtitleLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: useSvgIcon && svgPath != null
              ? Center(
                  child: SvgPicture.asset(
                    svgPath,
                    width: 16.w,
                    height: 16.w,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                )
              : Icon(icon, size: 17.sp, color: iconColor),
        ),
        SizedBox(width: 11.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.boldExtraSmall.copyWith(
                  color: const Color(0xFF344054),
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                subtitle,
                maxLines: maxSubtitleLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.regularExtraSmall.copyWith(
                  color: const Color(0xFF667085),
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _warningCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(11.w, 11.h, 11.w, 11.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFFFDC73)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 17.sp,
            color: const Color(0xFFF59E0B),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              "As admin, you can manually release payment to the seller or refund the buyer if there's an issue.",
              style: TextStyles.regularExtraSmall.copyWith(
                color: const Color(0xFF955B0B),
                fontSize: 13.sp,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomActions(BuildContext context) {
    return Container(
      color: const Color(0xFFFAFAFB),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(11.w, 8.h, 11.w, 11.h),
          child: Row(
            children: [
              Expanded(
                child: _actionButton(
                  label: 'Release',
                  useSvgIcon: true,
                  svgPath: 'assets/icons/check_email_icon.svg',
                  color: const Color(0xFF00A63E),
                  textColor: AppColors.bodyBg,
                  borderColor: const Color(0xFF00A63E),
                  onTap: () => _showPaymentDialog(
                    context: context,
                    type: _PaymentDialogType.release,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _actionButton(
                  label: 'Refund',
                  icon: Icons.refresh_rounded,
                  color: AppColors.bodyBg,
                  textColor: const Color(0xFFFF3B4F),
                  borderColor: const Color(0xFFFF3B4F),
                  onTap: () => _showPaymentDialog(
                    context: context,
                    type: _PaymentDialogType.refund,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _closedBottomAction(BuildContext context) {
    return Container(
      color: const Color(0xFFFAFAFB),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(11.w, 8.h, 11.w, 11.h),
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColors.bodyBg,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              alignment: Alignment.center,
              child: Text(
                isRefunded ? 'Back' : 'Back to home',
                style: TextStyles.boldSmall.copyWith(
                  color: const Color(0xFF222B37),
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required Color textColor,
    required Color borderColor,
    required VoidCallback onTap,
    IconData? icon,
    bool useSvgIcon = false,
    String? svgPath,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (useSvgIcon && svgPath != null)
              SvgPicture.asset(
                svgPath,
                width: 17.w,
                height: 17.w,
                colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
              )
            else if (icon != null)
              Icon(icon, size: 17.sp, color: textColor),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyles.boldSmall.copyWith(
                color: textColor,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPaymentDialog({
    required BuildContext context,
    required _PaymentDialogType type,
  }) async {
    final isRelease = type == _PaymentDialogType.release;
    final accent = isRelease
        ? const Color(0xFF00A63E)
        : const Color(0xFFE7000B);
    final title = isRelease
        ? 'Release Payment to Seller?'
        : 'Refund Payment to Buyer?';
    final confirmText = isRelease ? 'Confirm Release' : 'Confirm Refund';
    final result = isRelease
        ? SaleDetailResult.release
        : SaleDetailResult.refund;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.78),
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isRelease)
                      SvgPicture.asset(
                        'assets/icons/check_email_icon.svg',
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
                      )
                    else
                      Icon(
                        Icons.refresh_rounded,
                        color: accent,
                        size: 24.sp,
                      ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyles.boldMedium.copyWith(
                          color: const Color(0xFF222B37),
                          fontSize: 20.sp,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                RichText(
                  text: TextSpan(
                    style: TextStyles.regularSmall.copyWith(
                      color: const Color(0xFF6B7280),
                      fontSize: 15.sp,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: isRelease
                            ? 'This will transfer '
                            : 'This will return ',
                      ),
                      TextSpan(
                        text: amount,
                        style: TextStyles.boldSmall.copyWith(
                          color: accent,
                          fontSize: 15.sp,
                        ),
                      ),
                      TextSpan(
                        text: isRelease
                            ? ' from the escrow wallet to the seller account. This action cannot be undone.'
                            : ' from the escrow wallet back to the buyer account. This action cannot be undone.',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          context.pop(result);
                        },
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            confirmText,
                            style: TextStyles.boldSmall.copyWith(
                              color: AppColors.bodyBg,
                              fontSize: 16.sp,
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
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: AppColors.bodyBg,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: TextStyles.boldSmall.copyWith(
                              color: const Color(0xFF222B37),
                              fontSize: 16.sp,
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
}

class SaleDetailResult {
  static const String release = 'release';
  static const String refund = 'refund';
}

enum _PaymentDialogType { release, refund }

class SaleDetailData {
  final String title;
  final String saleId;
  final String amount;
  final String buyer;
  final String paid;
  final String image;
  final bool isCompleted;
  final bool isRefunded;

  const SaleDetailData({
    required this.title,
    required this.saleId,
    required this.amount,
    required this.buyer,
    required this.paid,
    required this.image,
    this.isCompleted = false,
    this.isRefunded = false,
  });

  static const fallback = SaleDetailData(
    title: 'Vintage Rolex Submariner 1960s',
    saleId: '001',
    amount: r'$250.00',
    buyer: 'John Smith',
    paid: 'Feb 8, 2026',
    image: AppImages.marketplaceWatch,
  );
}
