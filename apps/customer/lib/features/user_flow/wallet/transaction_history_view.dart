import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';

enum _TransactionTab { all, selling, billing }

enum _TransactionType { selling, billing }

class _TransactionItem {
  const _TransactionItem({
    required this.title,
    required this.subtitle,
    required this.dateText,
    required this.amountText,
    required this.orderId,
    required this.type,
  });

  final String title;
  final String subtitle;
  final String dateText;
  final String amountText;
  final String orderId;
  final _TransactionType type;
}

class TransactionHistoryView extends StatefulWidget {
  const TransactionHistoryView({super.key});

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView> {
  _TransactionTab _selectedTab = _TransactionTab.all;

  static const List<_TransactionItem> _allTransactions = [
    _TransactionItem(
      title: 'Sale Payment',
      subtitle: 'Victorian Chair',
      dateText: 'Feb 6, 2026',
      amountText: '+\$850.00',
      orderId: 'ORD-2449',
      type: _TransactionType.selling,
    ),
    _TransactionItem(
      title: 'Platform Fee',
      subtitle: 'Monthly subscription',
      dateText: 'Feb 5, 2026',
      amountText: '-\$29.99',
      orderId: '',
      type: _TransactionType.billing,
    ),
    _TransactionItem(
      title: 'Sale Payment',
      subtitle: 'Antique Cabinet',
      dateText: 'Feb 4, 2026',
      amountText: '+\$1,200.00',
      orderId: 'ORD-2451',
      type: _TransactionType.selling,
    ),
    _TransactionItem(
      title: 'Sale Payment',
      subtitle: 'Victorian Lamp',
      dateText: 'Feb 3, 2026',
      amountText: '+\$1,470.00',
      orderId: 'ORD-2453',
      type: _TransactionType.selling,
    ),
    _TransactionItem(
      title: 'Platform Fee',
      subtitle: 'Payment processing',
      dateText: 'Feb 2, 2026',
      amountText: '-\$12.99',
      orderId: '',
      type: _TransactionType.billing,
    ),
    _TransactionItem(
      title: 'Sale Payment',
      subtitle: 'Art Deco Mirror',
      dateText: 'Feb 1, 2026',
      amountText: '+\$640.00',
      orderId: 'ORD-2456',
      type: _TransactionType.selling,
    ),
  ];

  List<_TransactionItem> _filteredTransactions() {
    switch (_selectedTab) {
      case _TransactionTab.all:
        return _allTransactions;
      case _TransactionTab.selling:
        return _allTransactions
            .where((item) => item.type == _TransactionType.selling)
            .toList();
      case _TransactionTab.billing:
        return _allTransactions
            .where((item) => item.type == _TransactionType.billing)
            .toList();
    }
  }

  int _countForTab(_TransactionTab tab) {
    switch (tab) {
      case _TransactionTab.all:
        return _allTransactions.length;
      case _TransactionTab.selling:
        return _allTransactions
            .where((item) => item.type == _TransactionType.selling)
            .length;
      case _TransactionTab.billing:
        return _allTransactions
            .where((item) => item.type == _TransactionType.billing)
            .length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredTransactions();

    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Transaction History',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchField(),
              SizedBox(height: 12.h),
              _tabs(),
              SizedBox(height: 12.h),
              _netTotalCard(),
              SizedBox(height: 12.h),
              ...List.generate(items.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == items.length - 1 ? 0 : 10.h,
                  ),
                  child: _transactionCard(items[index]),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: 46.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF2B4160), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 22.sp,
            color: const Color(0xFF98A2B3),
          ),
          SizedBox(width: 8.w),
          Text(
            'Search transactions...',
            style: TextStyles.regularMedium.copyWith(
              color: const Color(0xFF98A2B3),
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    return Row(
      children: [
        Expanded(
          child: _tabChip(
            label: 'All',
            count: _countForTab(_TransactionTab.all),
            tab: _TransactionTab.all,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _tabChip(
            label: 'Selling',
            count: _countForTab(_TransactionTab.selling),
            tab: _TransactionTab.selling,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _tabChip(
            label: 'Billing',
            count: _countForTab(_TransactionTab.billing),
            tab: _TransactionTab.billing,
          ),
        ),
      ],
    );
  }

  Widget _tabChip({
    required String label,
    required int count,
    required _TransactionTab tab,
  }) {
    final selected = _selectedTab == tab;

    return GestureDetector(
      onTap: () => setState(() => _selectedTab = tab),
      child: Container(
        height: 46.h,
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.gradientColor1, AppColors.gradientColor2],
                )
              : null,
          color: selected ? null : AppColors.bodyBg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFD0D5DD), width: 1),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.16),
                    blurRadius: 14,
                    spreadRadius: -9,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            '$label ($count)',
            style: TextStyles.mediumMedium.copyWith(
              color: selected ? AppColors.bodyBg : const Color(0xFF475467),
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _netTotalCard() {
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
          Text(
            'Net Total',
            style: TextStyles.mediumMedium.copyWith(
              color: AppColors.bodyBg.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '\$877.51',
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

  Widget _transactionCard(_TransactionItem item) {
    final isSelling = item.type == _TransactionType.selling;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48.w,
            width: 48.w,
            decoration: BoxDecoration(
              color: isSelling
                  ? const Color(0xFF0FD36D)
                  : const Color(0xFFFF6363),
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.18),
                  blurRadius: 12,
                  spreadRadius: -8,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              isSelling ? Icons.north_west_rounded : Icons.north_east_rounded,
              color: AppColors.bodyBg,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyles.mediumMedium.copyWith(
                          color: const Color(0xFF1F2937),
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    Text(
                      item.amountText,
                      style: TextStyles.mediumMedium.copyWith(
                        color: isSelling
                            ? const Color(0xFF08A844)
                            : const Color(0xFFE31717),
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  item.subtitle,
                  style: TextStyles.regularMedium.copyWith(
                    color: const Color(0xFF667085),
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      item.dateText,
                      style: TextStyles.regularMedium.copyWith(
                        color: const Color(0xFF667085),
                        fontSize: 15.sp,
                      ),
                    ),
                    if (item.orderId.isNotEmpty) ...[
                      SizedBox(width: 8.w),
                      Text(
                        item.orderId,
                        style: TextStyles.mediumMedium.copyWith(
                          color: const Color(0xFF2452FF),
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Text(
                        'Completed',
                        style: TextStyles.mediumSmall.copyWith(
                          color: const Color(0xFF079455),
                          fontSize: 12.sp,
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
    );
  }
}
