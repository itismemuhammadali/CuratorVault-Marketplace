import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class TrackOrderView extends StatelessWidget {
  const TrackOrderView({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Track Orders',
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
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order #$orderId',
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.gradientColor1,
                ),
              ),
              SizedBox(height: 12.h),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(
                      icon: Icons.inventory_2_outlined,
                      title: 'Tracking Information',
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.subPageBg,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tracking Number',
                            style: TextStyles.regularMedium.copyWith(
                              color: AppColors.gradientColor1,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'TRK0987654321',
                                  style: TextStyles.mediumLarge.copyWith(
                                    color: AppColors.gradientColor1,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.copy_all_outlined,
                                color: AppColors.redButton,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Carrier',
                                style: TextStyles.regularMedium.copyWith(
                                  color: AppColors.gradientColor1,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'FedEx',
                                style: TextStyles.boldMedium.copyWith(
                                  color: AppColors.gradientColor1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.bodyBg,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: AppColors.redButton),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.open_in_new_rounded,
                                  color: AppColors.redButton,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Track on FedEx',
                                  style: TextStyles.mediumMedium.copyWith(
                                    color: AppColors.redButton,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Shipping Timeline',
                style: TextStyles.boldMedium.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 12.h),
              _card(
                child: Column(
                  children: const [
                    _TimelineItem(
                      title: 'Order Placed',
                      subtitle: 'Your order has been confirmed',
                      timeText: 'Dec 10, 2024 10:30 AM',
                      completed: true,
                    ),
                    _TimelineItem(
                      title: 'Payment Confirmed',
                      subtitle: 'Payment successfully processed',
                      timeText: 'Dec 10, 2024 10:31 AM',
                      completed: true,
                    ),
                    _TimelineItem(
                      title: 'Processing',
                      subtitle: 'Seller is preparing your item',
                      timeText: 'Dec 11, 2024 2:15 PM',
                      completed: true,
                    ),
                    _TimelineItem(
                      title: 'Shipped',
                      subtitle: 'Package has been picked up by carrier',
                      timeText: 'Dec 13, 2024 9:00 AM',
                      completed: true,
                    ),
                    _TimelineItem(
                      title: 'Out for Delivery',
                      subtitle: 'Package is on the way to your address',
                      timeText: 'Expected Dec 18',
                      completed: false,
                    ),
                    _TimelineItem(
                      title: 'Delivered',
                      subtitle: 'Package delivered successfully',
                      timeText: 'Expected Dec 18',
                      completed: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Order Items',
                style: TextStyles.boldMedium.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 12.h),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => context.push(
                        '/user/order-history/track/$orderId/review',
                      ),
                      child: Row(
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
                                  'Art Deco Lamp',
                                  style: TextStyles.boldMedium.copyWith(
                                    color: AppColors.gradientColor1,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Classic Collectibles',
                                  style: TextStyles.regularMedium.copyWith(
                                    color: AppColors.gradientColor1,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Qty: 1',
                                  style: TextStyles.regularMedium.copyWith(
                                    color: AppColors.gradientColor1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$825.00',
                            style: TextStyles.mediumLarge.copyWith(
                              color: AppColors.redButton,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      height: 1,
                      color: AppColors.lightText.withValues(alpha: 0.10),
                    ),
                    SizedBox(height: 14.h),
                    _amountRow('Subtotal', '\$825.00'),
                    SizedBox(height: 10.h),
                    _amountRow('Shipping', '\$15.00'),
                    SizedBox(height: 10.h),
                    _amountRow('Tax', '\$67.20'),
                    SizedBox(height: 12.h),
                    Container(
                      height: 1,
                      color: AppColors.lightText.withValues(alpha: 0.10),
                    ),
                    SizedBox(height: 12.h),
                    _amountRow('Total', '\$907.20', highlight: true),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Delivery Address',
                style: TextStyles.boldMedium.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 12.h),
              _card(
                child: Column(
                  children: [
                    _contactRow(
                      icon: Icons.location_on_outlined,
                      text: '3819 Maple Ridge Drive, Austin, TX\n78745, USA',
                    ),
                    SizedBox(height: 14.h),
                    _contactRow(
                      icon: Icons.phone_outlined,
                      text: '+1 123 456 789',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E5),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Column(
                  children: [
                    Text(
                      'Need help with your order?',
                      style: TextStyles.mediumLarge.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.push('/single_message'),
                            child: Container(
                              height: 52.h,
                              decoration: BoxDecoration(
                                color: AppColors.redButton,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.mail_outline_rounded,
                                    color: AppColors.bodyBg,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Contact Seller',
                                    style: TextStyles.mediumMedium.copyWith(
                                      color: AppColors.bodyBg,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.push('/single_message'),
                            child: Container(
                              height: 52.h,
                              decoration: BoxDecoration(
                                color: AppColors.bodyBg,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(color: AppColors.redButton),
                              ),
                              child: Center(
                                child: Text(
                                  'Get Support',
                                  style: TextStyles.mediumMedium.copyWith(
                                    color: AppColors.redButton,
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
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
      child: child,
    );
  }

  Widget _sectionTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.redButton, size: 20.sp),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyles.boldMedium.copyWith(
            color: AppColors.gradientColor1,
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }

  Widget _amountRow(String label, String value, {bool highlight = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.gradientColor1,
            ),
          ),
        ),
        Text(
          value,
          style: (highlight ? TextStyles.boldMedium : TextStyles.mediumMedium)
              .copyWith(
            color: highlight ? AppColors.redButton : AppColors.gradientColor1,
          ),
        ),
      ],
    );
  }

  Widget _contactRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: const Color(0xFFFDECE7),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.redButton, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Text(
              text,
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.greyText,
                height: 1.45,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.title,
    required this.subtitle,
    required this.timeText,
    required this.completed,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final String timeText;
  final bool completed;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final accent = completed ? const Color(0xFF4ADE80) : const Color(0xFFD8A976);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 42.w,
          child: Column(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: completed ? 0.18 : 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: accent,
                  size: 22.sp,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2.w,
                  height: 42.h,
                  color: accent.withValues(alpha: 0.55),
                ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h, bottom: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.boldMedium.copyWith(
                    color: completed
                        ? AppColors.gradientColor1
                        : AppColors.gradientColor1.withValues(alpha: 0.55),
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.greyText,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  timeText,
                  style: TextStyles.regularSmall.copyWith(
                    color: const Color(0xFFD8A976),
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
