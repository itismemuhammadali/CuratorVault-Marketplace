import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/global_header/header_controller_provider.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class OrdersOverviewView extends StatefulWidget {
  const OrdersOverviewView({super.key});

  @override
  State<OrdersOverviewView> createState() => _OrdersOverviewViewState();
}

class _OrdersOverviewViewState extends State<OrdersOverviewView> {
  bool _headerSet = false;

  final List<_OrderItem> _orders = const [
    _OrderItem(
      customerName: 'John Collector',
      orderId: 'ORD-2451',
      ageText: '2h ago',
      itemTitle: 'Victorian Mahogany Chair',
      productImage: AppImages.productOne,
      priceText: '\$850',
      payoutStatus: 'In Escrow',
      cardStatus: 'Awaiting Confirmation',
      cardStatusSubtitle: 'Accept order to begin processing',
      state: _OrderState.awaiting,
      primaryButtonLabel: 'Accept Order',
    ),
    _OrderItem(
      customerName: 'Sarah Martinez',
      orderId: 'ORD-2450',
      ageText: '1d ago',
      itemTitle: 'Antique Oak Cabinet',
      productImage: AppImages.productTwo,
      priceText: '\$1,200',
      payoutStatus: 'In Escrow',
      cardStatus: 'In Transit',
      cardStatusSubtitle: 'Update when delivered to buyer',
      state: _OrderState.transit,
      primaryButtonLabel: 'Mark as Delivered',
    ),
    _OrderItem(
      customerName: 'Michael Chen',
      orderId: 'ORD-2449',
      ageText: '3d ago',
      itemTitle: 'Porcelain Vase Collection',
      productImage: AppImages.productThree,
      priceText: '\$650',
      payoutStatus: 'Released',
      cardStatus: 'Order Completed',
      cardStatusSubtitle: 'Payment released to your wallet',
      state: _OrderState.completed,
    ),
    _OrderItem(
      customerName: 'Sarah Martinez',
      orderId: 'ORD-2448',
      ageText: '4d ago',
      itemTitle: 'Antique Oak Cabinet',
      productImage: AppImages.productFour,
      priceText: '\$1,200',
      payoutStatus: 'In Escrow',
      cardStatus: 'In Transit',
      cardStatusSubtitle: 'Update when delivered to buyer',
      state: _OrderState.transit,
      primaryButtonLabel: 'Mark as Delivered',
    ),
  ];

  void _updateHeader() {
    HeaderControllerProvider.of(context).value = HeaderConfig(
      title: Text(
        'Orders',
        style: TextStyles.boldLarge.copyWith(
          color: AppColors.bodyBg,
          fontSize: 28.sp,
        ),
      ),
      height: 120.h,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_headerSet) {
      _headerSet = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _updateHeader();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.subPageBg,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._orders.map(
                (order) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _OrderCard(order: order),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _OrderState { awaiting, transit, completed }

class _OrderItem {
  final String customerName;
  final String orderId;
  final String ageText;
  final String itemTitle;
  final String productImage;
  final String priceText;
  final String payoutStatus;
  final String cardStatus;
  final String cardStatusSubtitle;
  final _OrderState state;
  final String? primaryButtonLabel;

  const _OrderItem({
    required this.customerName,
    required this.orderId,
    required this.ageText,
    required this.itemTitle,
    required this.productImage,
    required this.priceText,
    required this.payoutStatus,
    required this.cardStatus,
    required this.cardStatusSubtitle,
    required this.state,
    this.primaryButtonLabel,
  });
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final _OrderItem order;

  @override
  Widget build(BuildContext context) {
    final isCompleted = order.state == _OrderState.completed;

    final bannerBg = order.state == _OrderState.awaiting
        ? const Color(0xFFF4EABD)
        : order.state == _OrderState.transit
        ? const Color(0xFFD8E8FF)
        : const Color(0xFFC5F0D7);

    final bannerBorder = order.state == _OrderState.awaiting
        ? const Color(0xFFEFC53A)
        : order.state == _OrderState.transit
        ? const Color(0xFF9ABFFF)
        : const Color(0xFF6EE09C);

    final bannerText = order.state == _OrderState.awaiting
        ? const Color(0xFFC85D45)
        : order.state == _OrderState.transit
        ? const Color(0xFF2D68D8)
        : const Color(0xFF118F49);

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
            children: [
              ClipOval(
                child: Image.asset(
                  AppImages.userImg,
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.lightText,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      order.orderId,
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                order.ageText,
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.greyText,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.asset(
                  order.productImage,
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
                      order.itemTitle,
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.lightText,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      order.priceText,
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.redButton,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          order.payoutStatus == 'Released'
                              ? Icons.shield_rounded
                              : Icons.shield_outlined,
                          size: 18.sp,
                          color: order.payoutStatus == 'Released'
                              ? const Color(0xFF0BB95A)
                              : AppColors.redButton,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          order.payoutStatus,
                          style: TextStyles.mediumMedium.copyWith(
                            color: order.payoutStatus == 'Released'
                                ? const Color(0xFF0BB95A)
                                : AppColors.redButton,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 10.h),
            decoration: BoxDecoration(
              color: bannerBg,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: bannerBorder),
            ),
            child: Row(
              children: [
                Container(
                  height: 24.w,
                  width: 24.w,
                  decoration: BoxDecoration(
                    color: bannerText,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    order.state == _OrderState.awaiting
                        ? Icons.access_time
                        : order.state == _OrderState.transit
                        ? Icons.local_shipping_outlined
                        : Icons.check_rounded,
                    size: 14.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.cardStatus,
                        style: TextStyles.mediumMedium.copyWith(
                          color: bannerText,
                          fontSize: 17.sp,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        order.cardStatusSubtitle,
                        style: TextStyles.regularSmall.copyWith(
                          color: bannerText.withValues(alpha: 0.88),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          if (!isCompleted)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (order.state == _OrderState.awaiting) {
                        context.push(
                          '/dealer/orders/accept/${order.orderId}',
                          extra: {
                            'itemTitle': order.itemTitle,
                            'priceText': order.priceText,
                            'ageText': order.ageText,
                            'productImage': order.productImage,
                          },
                        );
                      }
                    },
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2B3F5F), Color(0xFF1D2A3F)],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Text(
                          order.primaryButtonLabel ?? '',
                          style: TextStyles.semiBoldMedium.copyWith(
                            color: AppColors.bodyBg,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                _chatButton(context, compact: true),
              ],
            )
          else
            _chatButton(context, compact: false),
        ],
      ),
    );
  }

  Widget _chatButton(BuildContext context, {required bool compact}) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.chatBubbleIcon,
          width: 16.w,
          height: 16.w,
          color: AppColors.lightText,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 8.w),
        Text(
          'Chat',
          style: TextStyles.mediumMedium.copyWith(color: AppColors.lightText),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => context.push('/single_message'),
      child: Container(
        width: compact ? 100.w : double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFC9CFD8)),
        ),
        child: child,
      ),
    );
  }
}
