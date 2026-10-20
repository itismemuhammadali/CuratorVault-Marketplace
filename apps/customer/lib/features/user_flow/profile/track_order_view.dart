import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/services/api_service.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class TrackOrderView extends StatefulWidget {
  const TrackOrderView({super.key, required this.orderId});

  final String orderId;

  @override
  State<TrackOrderView> createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {
  Map<String, dynamic>? _orderData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  Future<void> _fetchOrder() async {
    try {
      final res = await ApiService.get('/api/v1/orders/${widget.orderId}');
      if (res is Map<String, dynamic> && mounted) {
        setState(() {
          _orderData = res;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading order tracking: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _copyTracking(String trk) {
    Clipboard.setData(ClipboardData(text: trk));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tracking number $trk copied to clipboard!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = _orderData;
    final carrier = order?['carrier'] ?? 'DHL Express';
    final trackingNumber = order?['trackingNumber'] ?? 'DHL987654321';
    final status = order?['status'] ?? 'In Transit';
    final subtotal = (order?['subtotal'] ?? 825.0).toDouble();
    final shipping = (order?['shippingFee'] ?? 15.0).toDouble();
    final tax = (order?['tax'] ?? 67.20).toDouble();
    final total = (order?['total'] ?? 907.20).toDouble();

    final rawTimeline = order?['timeline'] as List<dynamic>?;
    final timeline = rawTimeline != null && rawTimeline.isNotEmpty
        ? rawTimeline.map((e) => Map<String, dynamic>.from(e as Map)).toList()
        : [
            {
              'title': 'Order Placed',
              'subtitle': 'Your order has been confirmed',
              'timeText': 'Oct 05, 2026 10:30 AM',
              'completed': true,
            },
            {
              'title': 'Payment Confirmed',
              'subtitle': 'Payment held in escrow protection',
              'timeText': 'Oct 05, 2026 10:31 AM',
              'completed': true,
            },
            {
              'title': 'Processing',
              'subtitle': 'Dealer has packaged your antique',
              'timeText': 'Oct 06, 2026 2:15 PM',
              'completed': true,
            },
            {
              'title': 'Shipped',
              'subtitle': 'Dispatched with $carrier (TRK: $trackingNumber)',
              'timeText': 'Oct 07, 2026 9:00 AM',
              'completed': status == 'Shipped' || status == 'Delivered',
            },
            {
              'title': 'Delivered',
              'subtitle': 'Delivered safely to your destination',
              'timeText': 'Expected in 2-3 Days',
              'completed': status == 'Delivered',
            },
          ];

    final items = (order?['items'] as List<dynamic>?) ?? [
      {
        'id': '1',
        'title': 'Victorian Pocket Watch',
        'price': 825.0,
        'quantity': 1,
        'imageUrl': 'assets/images/product_one.png',
        'sellerName': 'London Heritage Antiques'
      }
    ];

    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Track Order',
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #${widget.orderId}',
                          style: TextStyles.boldMedium.copyWith(
                            color: AppColors.gradientColor1,
                            fontSize: 18.sp,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: status == 'Shipped' || status == 'Delivered'
                                ? const Color(0xFFE6F9EE)
                                : const Color(0xFFFFF3E5),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            status,
                            style: TextStyles.boldSmall.copyWith(
                              color: status == 'Shipped' || status == 'Delivered'
                                  ? const Color(0xFF00A854)
                                  : const Color(0xFFF08100),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(
                            iconPath: 'assets/icons/package_icon.svg',
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
                                        trackingNumber,
                                        style: TextStyles.mediumLarge.copyWith(
                                          color: AppColors.gradientColor1,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _copyTracking(trackingNumber),
                                      child: Container(
                                        padding: EdgeInsets.all(6.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.bodyBg,
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/icons/copy_icon.svg',
                                          width: 18.sp,
                                          height: 18.sp,
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.redButton,
                                            BlendMode.srcIn,
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
                                    SizedBox(height: 6.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_shipping_outlined,
                                          size: 18.sp,
                                          color: AppColors.redButton,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          carrier,
                                          style: TextStyles.boldMedium.copyWith(
                                            color: AppColors.gradientColor1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Connecting to $carrier tracking network...')),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 10.h,
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
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Track on $carrier',
                                        style: TextStyles.mediumMedium.copyWith(
                                          color: AppColors.redButton,
                                          fontSize: 13.sp,
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
                    SizedBox(height: 18.h),
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
                        children: List.generate(timeline.length, (index) {
                          final step = timeline[index];
                          final isLast = index == timeline.length - 1;
                          return _TimelineItem(
                            title: step['title'] ?? '',
                            subtitle: step['subtitle'] ?? '',
                            timeText: step['timeText'] ?? '',
                            completed: step['completed'] == true,
                            isLast: isLast,
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 18.h),
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
                          ...items.map((item) {
                            final title = item['title'] ?? 'Antique Item';
                            final seller = item['sellerName'] ?? 'Verified Dealer';
                            final qty = item['quantity'] ?? 1;
                            final price = (item['price'] ?? 0.0).toDouble();
                            final img = (item['imageUrl'] ?? '').toString();

                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: img.startsWith('assets/')
                                        ? Image.asset(
                                            img,
                                            width: 58.w,
                                            height: 58.w,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            AppImages.productOne,
                                            width: 58.w,
                                            height: 58.w,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: TextStyles.boldMedium.copyWith(
                                            color: AppColors.gradientColor1,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          seller,
                                          style: TextStyles.regularSmall.copyWith(
                                            color: AppColors.greyText,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          'Qty: $qty',
                                          style: TextStyles.regularSmall.copyWith(
                                            color: AppColors.gradientColor1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${price.toStringAsFixed(2)}',
                                    style: TextStyles.boldMedium.copyWith(
                                      color: AppColors.redButton,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          Container(
                            height: 1,
                            color: AppColors.lightText.withValues(alpha: 0.10),
                          ),
                          SizedBox(height: 12.h),
                          _amountRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                          SizedBox(height: 8.h),
                          _amountRow('Shipping', '\$${shipping.toStringAsFixed(2)}'),
                          SizedBox(height: 8.h),
                          _amountRow('Tax', '\$${tax.toStringAsFixed(2)}'),
                          SizedBox(height: 10.h),
                          Container(
                            height: 1,
                            color: AppColors.lightText.withValues(alpha: 0.10),
                          ),
                          SizedBox(height: 10.h),
                          _amountRow('Total', '\$${total.toStringAsFixed(2)}', highlight: true),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
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
                            iconPath: 'assets/icons/location_icon.svg',
                            text: '3819 Maple Ridge Drive, Austin, TX 78745, USA',
                          ),
                          SizedBox(height: 14.h),
                          _contactRow(
                            iconPath: 'assets/icons/phone_icon.svg',
                            text: '+1 (555) 123-4567',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
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
                            'Need help with your shipment?',
                            style: TextStyles.mediumLarge.copyWith(
                              color: AppColors.gradientColor1,
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => context.push('/single_message'),
                                  child: Container(
                                    height: 48.h,
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
                                    height: 48.h,
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

  Widget _sectionTitle({required String iconPath, required String title}) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 20.sp,
          height: 20.sp,
          colorFilter: const ColorFilter.mode(
            AppColors.redButton,
            BlendMode.srcIn,
          ),
        ),
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
                color: highlight
                    ? AppColors.redButton
                    : AppColors.gradientColor1,
              ),
        ),
      ],
    );
  }

  Widget _contactRow({required String iconPath, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: const BoxDecoration(
            color: Color(0xFFFDECE7),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 20.sp,
              height: 20.sp,
              colorFilter: const ColorFilter.mode(
                AppColors.redButton,
                BlendMode.srcIn,
              ),
            ),
          ),
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
    final accent = completed
        ? const Color(0xFF4ADE80)
        : const Color(0xFFD8A976);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 42.w,
          child: Column(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: completed ? 0.18 : 0.16),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/check_email_icon.svg',
                    width: 20.sp,
                    height: 20.sp,
                    colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
                  ),
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
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.greyText,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 4.h),
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
