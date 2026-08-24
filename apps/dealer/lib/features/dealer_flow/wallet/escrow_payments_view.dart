import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';

class EscrowPaymentsView extends StatelessWidget {
  const EscrowPaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Escrow Funds',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 28.sp,
            ),
          ),
          height: 170.h,
        ),
      ),
      backgroundColor: AppColors.subPageBg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 20.h),
          child: Column(
            children: [
              _totalEscrowCard(),
              SizedBox(height: 12.h),
              _processingTimeCard(),
              SizedBox(height: 12.h),
              _escrowOrderCard(
                context: context,
                title: 'Antique Cabinet',
                orderId: 'ORD-2451',
                amount: '\$1,200',
                status: 'Delivered',
                statusColor: const Color(0xFF10B981),
                statusBg: const Color(0xFFD1FAE5),
                buyer: 'Sarah Martinez',
                escrowCreated: 'Feb 4, 2026',
                expectedRelease: 'Feb 11, 2026',
                actionType: _EscrowActionType.requestRelease,
              ),
              SizedBox(height: 12.h),
              _escrowOrderCard(
                context: context,
                title: 'Vintage Clock',
                orderId: 'ORD-2447',
                amount: '\$780',
                status: 'In Transit',
                statusColor: const Color(0xFF0EA5E9),
                statusBg: const Color(0xFFCFFAFE),
                buyer: 'Michael Chen',
                escrowCreated: 'Jan 29, 2026',
                expectedRelease: 'Feb 9, 2026',
                actionType: _EscrowActionType.awaitingDelivery,
              ),
              SizedBox(height: 12.h),
              _escrowOrderCard(
                context: context,
                title: 'Victorian Lamp',
                orderId: 'ORD-2453',
                amount: '\$1,470',
                status: 'Ready to Release',
                statusColor: const Color(0xFF7C3AED),
                statusBg: const Color(0xFFEDE9FE),
                buyer: 'Emma Wilson',
                escrowCreated: 'Feb 1, 2026',
                expectedRelease: 'Feb 8, 2026',
                actionType: _EscrowActionType.releaseRequested,
              ),
              SizedBox(height: 12.h),
              _processCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalEscrowCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientColor1, AppColors.gradientColor2],
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42.w,
                width: 42.w,
                decoration: BoxDecoration(
                  color: AppColors.bodyBg.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: AppColors.bodyBg,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Total in Escrow\n3 orders',
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.94),
                  height: 1.4,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            '\$3,450.00',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 44.sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _processingTimeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE7EDFF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFBFD0FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34.w,
            width: 34.w,
            decoration: const BoxDecoration(
              color: Color(0xFF3B82F6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.bodyBg,
              size: 18.sp,
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
                    color: const Color(0xFF1E40AF),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Withdrawals typically take 1-3 business\ndays to reach your account.',
                  style: TextStyles.regularMedium.copyWith(
                    color: const Color(0xFF1D4ED8),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _escrowOrderCard({
    required BuildContext context,
    required String title,
    required String orderId,
    required String amount,
    required String status,
    required Color statusColor,
    required Color statusBg,
    required String buyer,
    required String escrowCreated,
    required String expectedRelease,
    required _EscrowActionType actionType,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 48.w,
                width: 48.w,
                decoration: BoxDecoration(
                  gradient: actionType == _EscrowActionType.requestRelease
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF05DF72), Color(0xFF00BC7D)],
                        )
                      : actionType == _EscrowActionType.awaitingDelivery
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF51A2FF), Color(0xFF00B8DB)],
                        )
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFC27AFF), Color(0xFFF6339A)],
                        ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: actionType == _EscrowActionType.requestRelease
                    ? Center(
                        child: SvgPicture.asset(
                          'assets/icons/check_email_icon.svg',
                          width: 24.sp,
                          height: 24.sp,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      )
                    : actionType == _EscrowActionType.awaitingDelivery
                    ? Center(
                        child: Icon(
                          Icons.access_time_rounded,
                          color: AppColors.bodyBg,
                          size: 24.sp,
                        ),
                      )
                    : Center(
                        child: SvgPicture.asset(
                          'assets/icons/send_icon.svg',
                          width: 24.sp,
                          height: 24.sp,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.boldMedium.copyWith(
                              color: AppColors.gradientColor1,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        Text(
                          amount,
                          style: TextStyles.boldMedium.copyWith(
                            color: AppColors.gradientColor1,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Order $orderId',
                      style: TextStyles.regularMedium.copyWith(
                        color: const Color(0xFF667085),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Text(
                        status,
                        style: TextStyles.mediumSmall.copyWith(
                          color: statusColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              children: [
                _detailRow('Buyer', buyer),
                SizedBox(height: 7.h),
                _detailRow('Escrow Created', escrowCreated),
                SizedBox(height: 7.h),
                _detailRow('Expected Release', expectedRelease),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          if (actionType == _EscrowActionType.requestRelease)
            GestureDetector(
              onTap: () => _showRequestReleaseModal(
                context: context,
                orderId: orderId,
                itemTitle: title,
                buyer: buyer,
                amount: amount,
              ),
              child: Container(
                width: double.infinity,
                height: 46.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gradientColor1,
                      AppColors.gradientColor2,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/send_icon.svg',
                      width: 16.sp,
                      height: 16.sp,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFF8E8C7),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Request Release',
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.bodyBg,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (actionType == _EscrowActionType.awaitingDelivery)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFFBEB), Color(0xFFFFEDD4)],
                ),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFFCD34D)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 36.w,
                    width: 36.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.access_time_rounded,
                        size: 18.sp,
                        color: AppColors.bodyBg,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Awaiting Delivery',
                          style: TextStyles.mediumMedium.copyWith(
                            color: const Color(0xFF92400E),
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Release will be available after\ndelivery',
                          style: TextStyles.regularMedium.copyWith(
                            color: const Color(0xFFB45309),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFAF5FF), Color(0xFFFDF2F8)],
                ),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFE9D5FF)),
              ),
              child: Row(
                children: [
                  Container(
                    height: 30.w,
                    width: 30.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFA855F7),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.access_time_rounded,
                        size: 16.sp,
                        color: AppColors.bodyBg,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Release Requested',
                        style: TextStyles.mediumMedium.copyWith(
                          color: const Color(0xFF6B21A8),
                        ),
                      ),
                      Text(
                        'Waiting for buyer approval',
                        style: TextStyles.regularMedium.copyWith(
                          color: const Color(0xFF7E22CE),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showRequestReleaseModal({
    required BuildContext context,
    required String orderId,
    required String itemTitle,
    required String buyer,
    required String amount,
  }) async {
    final commentController = TextEditingController();

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 14.h),
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 58.w,
                    width: 58.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.gradientColor1,
                          AppColors.gradientColor2,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor.withValues(alpha: 0.24),
                          blurRadius: 16,
                          spreadRadius: -8,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/send_icon.svg',
                        width: 28.sp,
                        height: 28.sp,
                        colorFilter: const ColorFilter.mode(
                          AppColors.bodyBg,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    'Request Release',
                    style: TextStyles.boldMedium.copyWith(
                      color: const Color(0xFF1F2937),
                      fontSize: 30.sp.clamp(22, 30),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Center(
                  child: Text(
                    'Request the buyer to approve the release\nof funds for this order.',
                    textAlign: TextAlign.center,
                    style: TextStyles.regularMedium.copyWith(
                      color: const Color(0xFF475467),
                      fontSize: 19.sp.clamp(14, 19),
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FA),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xFFE9D5FF)),
                  ),
                  child: Column(
                    children: [
                      _modalInfoRow('Order ID', orderId),
                      SizedBox(height: 8.h),
                      _modalInfoRow('Item', itemTitle),
                      SizedBox(height: 8.h),
                      _modalInfoRow('Buyer', buyer),
                      SizedBox(height: 8.h),
                      Container(height: 1, color: const Color(0xFFE4D1F9)),
                      SizedBox(height: 8.h),
                      _modalInfoRow('Amount', amount, isEmphasis: true),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.bodyBg,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xFFD8DEE6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 16.sp,
                            color: const Color(0xFF667085),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Add a comment (optional)',
                            style: TextStyles.mediumMedium.copyWith(
                              color: const Color(0xFF344054),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFD0D5DD)),
                        ),
                        child: TextField(
                          controller: commentController,
                          minLines: 4,
                          maxLines: 4,
                          style: TextStyles.regularMedium.copyWith(
                            color: const Color(0xFF1F2937),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(
                              12.w,
                              10.h,
                              12.w,
                              10.h,
                            ),
                            hintText:
                                'e.g., Item has been delivered\nsuccessfully, tracking number #123456',
                            hintStyle: TextStyles.regularMedium.copyWith(
                              color: const Color(0xFF98A2B3),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'This message will be sent to the buyer along\nwith your release request.',
                        style: TextStyles.regularMedium.copyWith(
                          color: const Color(0xFF667085),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7EDFF),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xFFBFD0FF)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 16.sp,
                        color: const Color(0xFF1D4ED8),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'The buyer will be notified to review and\napprove your release request. Funds will\nbe transferred once approved.',
                          style: TextStyles.regularMedium.copyWith(
                            color: const Color(0xFF1D4ED8),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: Container(
                          height: 44.h,
                          decoration: BoxDecoration(
                            color: AppColors.bodyBg,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFFD0D5DD)),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyles.mediumMedium.copyWith(
                                color: const Color(0xFF344054),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: Container(
                          height: 44.h,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.gradientColor1,
                                AppColors.gradientColor2,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/send_icon.svg',
                                width: 16.sp,
                                height: 16.sp,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.bodyBg,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Send Request',
                                style: TextStyles.mediumMedium.copyWith(
                                  color: AppColors.bodyBg,
                                ),
                              ),
                            ],
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

    commentController.dispose();
  }

  Widget _modalInfoRow(String label, String value, {bool isEmphasis = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.regularMedium.copyWith(
              color: const Color(0xFF7E22CE),
              fontSize: 14.sp,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyles.mediumMedium.copyWith(
            color: const Color(0xFF5B21B6),
            fontSize: isEmphasis ? 16.sp : 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.regularMedium.copyWith(
              color: const Color(0xFF4B5563),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyles.mediumMedium.copyWith(
            color: const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _processCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Escrow Release Process',
            style: TextStyles.boldMedium.copyWith(
              color: AppColors.gradientColor1,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.h),
          _stepItem(
            index: 1,
            title: 'Order Placed',
            subtitle: 'Payment held in secure escrow',
            color: const Color(0xFFBFDBFE),
            textColor: const Color(0xFF2563EB),
          ),
          SizedBox(height: 9.h),
          _stepItem(
            index: 2,
            title: 'Item Delivered',
            subtitle: 'Tracking confirms delivery to buyer',
            color: const Color(0xFFDBEAFE),
            textColor: const Color(0xFF2563EB),
          ),
          SizedBox(height: 9.h),
          _stepItem(
            index: 3,
            title: 'Request Release',
            subtitle: 'Submit request for payment release',
            color: const Color(0xFFDBEAFE),
            textColor: const Color(0xFF2563EB),
          ),
          SizedBox(height: 9.h),
          _stepItem(
            index: 4,
            title: 'Funds Released',
            subtitle: 'Payment transferred to your account',
            color: const Color(0xFFD1FAE5),
            textColor: const Color(0xFF059669),
          ),
        ],
      ),
    );
  }

  Widget _stepItem({
    required int index,
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30.w,
          width: 30.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              '$index',
              style: TextStyles.mediumMedium.copyWith(color: textColor),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.mediumMedium.copyWith(
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF475467),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _EscrowActionType { requestRelease, releaseRequested, awaitingDelivery }
