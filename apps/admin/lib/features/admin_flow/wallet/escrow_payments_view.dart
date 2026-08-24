import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/admin_flow/wallet/sale_detail_view.dart';

enum _EscrowTab { all, escrow, shipped, done, refund }

enum _SaleStatus { escrow, shipped, completed, refunded }

class EscrowPaymentsView extends StatefulWidget {
  const EscrowPaymentsView({super.key});

  @override
  State<EscrowPaymentsView> createState() => _EscrowPaymentsViewState();
}

class _EscrowPaymentsViewState extends State<EscrowPaymentsView> {
  _EscrowTab _selectedTab = _EscrowTab.all;

  final List<_SaleItem> _sales = [
    _SaleItem(
      title: 'Vintage Rolex Sub...',
      saleId: '001',
      amount: r'$250.00',
      buyer: 'John Smith',
      paid: 'Feb 8, 2026',
      image: AppImages.marketplaceWatch,
      status: _SaleStatus.escrow,
    ),
    _SaleItem(
      title: '1950s Leather...',
      saleId: '002',
      amount: r'$450.00',
      buyer: 'Sarah Johnson',
      paid: 'Feb 6, 2026',
      image: AppImages.productTwo,
      status: _SaleStatus.shipped,
    ),
    _SaleItem(
      title: 'Antique Polaroid...',
      saleId: '003',
      amount: r'$350.00',
      buyer: 'Mike Davis',
      paid: 'Feb 1, 2026',
      image: AppImages.productThree,
      status: _SaleStatus.completed,
    ),
    _SaleItem(
      title: 'Vintage Gibson...',
      saleId: '004',
      amount: r'$3200.00',
      buyer: 'Tom Wilson',
      paid: 'Feb 5, 2026',
      image: AppImages.productSeven,
      status: _SaleStatus.shipped,
    ),
    _SaleItem(
      title: '1970s Porsche...',
      saleId: '005',
      amount: r'$180.00',
      buyer: 'Emma Brown',
      paid: 'Jan 28, 2026',
      image: AppImages.productFive,
      status: _SaleStatus.refunded,
    ),
    _SaleItem(
      title: 'Classic Vinyl Rec...',
      saleId: '006',
      amount: r'$650.00',
      buyer: 'Lisa Anderson',
      paid: 'Feb 9, 2026',
      image: AppImages.productOne,
      status: _SaleStatus.escrow,
    ),
    _SaleItem(
      title: 'Vintage Typewriter...',
      saleId: '007',
      amount: r'$420.00',
      buyer: 'David Martinez',
      paid: 'Jan 25, 2026',
      image: AppImages.productFour,
      status: _SaleStatus.completed,
    ),
  ];

  List<_SaleItem> get _visibleSales {
    return _sales.where((sale) {
      return switch (_selectedTab) {
        _EscrowTab.all => true,
        _EscrowTab.escrow => sale.status == _SaleStatus.escrow,
        _EscrowTab.shipped => sale.status == _SaleStatus.shipped,
        _EscrowTab.done => sale.status == _SaleStatus.completed,
        _EscrowTab.refund => sale.status == _SaleStatus.refunded,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visibleSales = _visibleSales;

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
                'Escrow Sales',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldSection.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'Manage platform transactions',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.regularExtraSmall.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.76),
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFAFAFB),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 11.h, 14.w, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          icon: Icons.account_balance_wallet_outlined,
                          iconColor: const Color(0xFF16A34A),
                          bgColor: const Color(0xFFEFFCF4),
                          label: 'Admin',
                          amount: r'$12,450.75',
                          subtitle: 'Platform Earnings',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _summaryCard(
                          icon: Icons.credit_card_outlined,
                          iconColor: const Color(0xFFF97316),
                          bgColor: const Color(0xFFFFF7ED),
                          label: 'Escrow',
                          amount: r'$8,950.00',
                          subtitle: 'Buyer Payments Held',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  _tabs(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(13.w, 10.h, 13.w, 7.h),
              child: Text(
                'Running Sales (${visibleSales.length})',
                style: TextStyles.boldMedium.copyWith(
                  color: const Color(0xFF344054),
                  fontSize: 20.sp,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(13.w, 0, 13.w, 14.h),
                itemCount: visibleSales.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  return _saleCard(context, visibleSales[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required String amount,
    required String subtitle,
  }) {
    final isAdmin = label == 'Admin';
    final svgIcon = isAdmin ? 'assets/icons/wallet_icon2.svg' : 'assets/icons/escrow_icon.svg';

    return Container(
      height: 118.h,
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 9.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: iconColor.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                svgIcon,
                width: 18.w,
                height: 18.w,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.boldExtraSmall.copyWith(
                    color: iconColor,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              Icon(
                Icons.visibility_off_outlined,
                size: 15.sp,
                color: iconColor,
              ),
            ],
          ),
          const Spacer(),
          Text(
            amount,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldMedium.copyWith(
              color: iconColor,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 9.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularExtraSmall.copyWith(
              color: const Color(0xFF667085),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    final tabs = <({String label, _EscrowTab value})>[
      (label: 'All', value: _EscrowTab.all),
      (label: 'Escrow', value: _EscrowTab.escrow),
      (label: 'Shipped', value: _EscrowTab.shipped),
      (label: 'Done', value: _EscrowTab.done),
      (label: 'Refund', value: _EscrowTab.refund),
    ];

    return Container(
      height: 36.h,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = tab.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _selectedTab == tab.value
                        ? const Color(0xFF111827)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.boldExtraSmall.copyWith(
                      color: _selectedTab == tab.value
                          ? AppColors.bodyBg
                          : const Color(0xFF344054),
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _saleCard(BuildContext context, _SaleItem sale) {
    final style = _statusStyle(sale.status);

    return Material(
      color: AppColors.bodyBg,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: () => _openSaleDetail(context, sale),
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 102.h),
          padding: EdgeInsets.all(7.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: Image.asset(
                  sale.image,
                  width: 76.w,
                  height: 85.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 76.w,
                      height: 85.h,
                      color: const Color(0xFFF3F4F6),
                      child: Icon(
                        Icons.image_outlined,
                        color: const Color(0xFF111827),
                        size: 36.sp,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sale.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.boldExtraSmall.copyWith(
                        color: const Color(0xFF344054),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    _metaLine('Sale ID:', sale.saleId),
                    _metaLine('Amount:', ''),
                    _metaLine('Buyer:', ''),
                    _metaLine('Paid:', ''),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: 110.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: style.color,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (sale.status == _SaleStatus.completed)
                            SvgPicture.asset(
                              'assets/icons/check_email_icon.svg',
                              width: 11.w,
                              height: 11.w,
                              colorFilter: const ColorFilter.mode(
                                AppColors.bodyBg,
                                BlendMode.srcIn,
                              ),
                            )
                          else if (sale.status == _SaleStatus.escrow)
                            Icon(
                              Icons.schedule_rounded,
                              size: 11.sp,
                              color: AppColors.bodyBg,
                            )
                          else
                            Icon(
                              style.icon,
                              size: 11.sp,
                              color: AppColors.bodyBg,
                            ),
                          SizedBox(width: 3.w),
                          Flexible(
                            child: Text(
                              style.label,
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              style: TextStyles.boldExtraSmall.copyWith(
                                color: AppColors.bodyBg,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 9.h),
                    _rightValue(sale.saleId, color: const Color(0xFF344054)),
                    _rightValue(sale.amount, color: const Color(0xFF16A34A)),
                    _rightValue(sale.buyer, color: const Color(0xFF344054)),
                    _rightValue(sale.paid, color: const Color(0xFF667085)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openSaleDetail(BuildContext context, _SaleItem sale) async {
    final result = await context.push<String>(
      '/dealer/wallet/escrow-payments/detail',
      extra: SaleDetailData(
        title: sale.title,
        saleId: sale.saleId,
        amount: sale.amount,
        buyer: sale.buyer,
        paid: sale.paid,
        image: sale.image,
        isCompleted: sale.status == _SaleStatus.completed,
        isRefunded: sale.status == _SaleStatus.refunded,
      ),
    );

    if (!mounted || result == null) return;

    final index = _sales.indexWhere((item) => item.saleId == sale.saleId);
    if (index == -1) return;

    setState(() {
      if (result == SaleDetailResult.release) {
        _sales[index] = _sales[index].copyWith(status: _SaleStatus.completed);
        _selectedTab = _EscrowTab.done;
      } else if (result == SaleDetailResult.refund) {
        _sales[index] = _sales[index].copyWith(status: _SaleStatus.refunded);
        _selectedTab = _EscrowTab.refund;
      }
    });
  }

  Widget _metaLine(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Text(
        value.isEmpty ? label : '$label $value',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyles.regularExtraSmall.copyWith(
          color: const Color(0xFF344054),
          fontSize: 12.sp,
          height: 1.05,
        ),
      ),
    );
  }

  Widget _rightValue(String value, {required Color color}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: TextStyles.boldExtraSmall.copyWith(
          color: color,
          fontSize: 12.sp,
          height: 1.05,
        ),
      ),
    );
  }

  _StatusStyle _statusStyle(_SaleStatus status) {
    return switch (status) {
      _SaleStatus.escrow => const _StatusStyle(
        label: 'In Escrow',
        color: Color(0xFFFF6B00),
        icon: Icons.info_outline_rounded,
      ),
      _SaleStatus.shipped => const _StatusStyle(
        label: 'Shipped',
        color: Color(0xFF3B82F6),
        icon: Icons.local_shipping_outlined,
      ),
      _SaleStatus.completed => const _StatusStyle(
        label: 'Completed',
        color: Color(0xFF22C55E),
        icon: Icons.check_circle_outline_rounded,
      ),
      _SaleStatus.refunded => const _StatusStyle(
        label: 'Refunded',
        color: Color(0xFFFF3B4F),
        icon: Icons.cancel_outlined,
      ),
    };
  }
}

class _SaleItem {
  final String title;
  final String saleId;
  final String amount;
  final String buyer;
  final String paid;
  final String image;
  final _SaleStatus status;

  const _SaleItem({
    required this.title,
    required this.saleId,
    required this.amount,
    required this.buyer,
    required this.paid,
    required this.image,
    required this.status,
  });

  _SaleItem copyWith({_SaleStatus? status}) {
    return _SaleItem(
      title: title,
      saleId: saleId,
      amount: amount,
      buyer: buyer,
      paid: paid,
      image: image,
      status: status ?? this.status,
    );
  }
}

class _StatusStyle {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusStyle({
    required this.label,
    required this.color,
    required this.icon,
  });
}
