import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = List.generate(
      5,
      (index) => _OrderHistoryItem(
        orderId: 'VV78923${4 + index}',
        date: 'Dec ${14 - index}, 2024',
        title: 'Victorian Pocket Watch',
        quantity: 1,
        trackingNumber: 'TRK123456789 $index',
        totalAmount: 1565.40,
        status: index == 0
            ? 'Delivered'
            : index == 1
            ? 'Shipped'
            : 'Processing',
      ),
    );

    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Order History',
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
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchBar(),
              SizedBox(height: 14.h),
              Row(
                children: const [
                  Expanded(
                    child: _StatusSummaryCard(
                      count: '1',
                      label: 'Delivered',
                      countColor: Color(0xFF4ADE80),
                    ),
                  ),
                  Expanded(
                    child: _StatusSummaryCard(
                      count: '1',
                      label: 'Shipped',
                      countColor: Color(0xFFD8A976),
                    ),
                  ),
                  Expanded(
                    child: _StatusSummaryCard(
                      count: '1',
                      label: 'Processing',
                      countColor: AppColors.redButton,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              ...orders.map(
                (order) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _OrderHistoryCard(order: order),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.lightText.withValues(alpha: 0.12)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: AppColors.greyText, size: 22.sp),
          SizedBox(width: 10.w),
          Text(
            'Search Orders....',
            style: TextStyles.regularMedium.copyWith(color: AppColors.greyText),
          ),
        ],
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  const _OrderHistoryCard({required this.order});

  final _OrderHistoryItem order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.10),
            blurRadius: 18,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.orderId}',
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      order.date,
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.gradientColor1,
                      ),
                    ),
                  ],
                ),
              ),
              _statusPill(order.status),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.asset(
                  AppImages.productOne,
                  width: 62.w,
                  height: 62.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.title,
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Qty: ${order.quantity}',
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.gradientColor1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            decoration: BoxDecoration(
              color: AppColors.subPageBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tracking Number',
                        style: TextStyles.regularMedium.copyWith(
                          color: AppColors.gradientColor1,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        order.trackingNumber,
                        style: TextStyles.mediumMedium.copyWith(
                          color: AppColors.gradientColor1,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.copy_all_outlined,
                  color: AppColors.redButton,
                  size: 20.sp,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            height: 1,
            color: AppColors.lightText.withValues(alpha: 0.10),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.gradientColor1,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => context.push(
                  '/dealer/order-history/track/${order.orderId}',
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.redButton,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    'Track Order',
                    style: TextStyles.semiBoldMedium.copyWith(
                      color: AppColors.bodyBg,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String status) {
    final delivered = status == 'Delivered';
    final shipped = status == 'Shipped';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: delivered
            ? const Color(0xFFE8FAED)
            : shipped
            ? const Color(0xFFFFF3E5)
            : const Color(0xFFFDECE7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            delivered
                ? Icons.check_circle_outline_rounded
                : shipped
                ? Icons.local_shipping_outlined
                : Icons.timelapse_rounded,
            size: 16.sp,
            color: delivered
                ? const Color(0xFF4ADE80)
                : shipped
                ? const Color(0xFFD8A976)
                : AppColors.redButton,
          ),
          SizedBox(width: 5.w),
          Text(
            status,
            style: TextStyles.regularSmall.copyWith(
              color: delivered
                  ? const Color(0xFF4ADE80)
                  : shipped
                  ? const Color(0xFFD8A976)
                  : AppColors.redButton,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusSummaryCard extends StatelessWidget {
  const _StatusSummaryCard({
    required this.count,
    required this.label,
    required this.countColor,
  });

  final String count;
  final String label;
  final Color countColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyles.regularLarge.copyWith(
              color: countColor,
              fontSize: 26.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyles.regularMedium.copyWith(color: AppColors.greyText),
          ),
        ],
      ),
    );
  }
}

class _OrderHistoryItem {
  const _OrderHistoryItem({
    required this.orderId,
    required this.date,
    required this.title,
    required this.quantity,
    required this.trackingNumber,
    required this.totalAmount,
    required this.status,
  });

  final String orderId;
  final String date;
  final String title;
  final int quantity;
  final String trackingNumber;
  final double totalAmount;
  final String status;
}
