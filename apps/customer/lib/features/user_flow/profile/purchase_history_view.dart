import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class PurchaseHistoryView extends StatefulWidget {
  const PurchaseHistoryView({super.key});

  @override
  State<PurchaseHistoryView> createState() => _PurchaseHistoryViewState();
}

class _PurchaseHistoryViewState extends State<PurchaseHistoryView> {
  String _selectedFilter = 'All Time';

  static const List<_PurchaseItem> _allPurchases = [
    _PurchaseItem(
      date: 'Dec 14, 2024',
      status: 'delivered',
      items: [
        _PurchaseProduct(
          imageAsset: AppImages.productOne,
          title: 'Victorian Pocket Watch',
          seller: 'Heritage Antiques',
          price: '\$1450.00',
        ),
      ],
      orderTotal: '\$1565.40',
    ),
    _PurchaseItem(
      date: 'Dec 10, 2024',
      status: 'delivered',
      items: [
        _PurchaseProduct(
          imageAsset: AppImages.productFour,
          title: 'Art Deco Lamp',
          seller: 'Classic Collectibles',
          price: '\$825.00',
        ),
      ],
      orderTotal: '\$895.00',
    ),
    _PurchaseItem(
      date: 'Nov 28, 2024',
      status: 'delivered',
      items: [
        _PurchaseProduct(
          imageAsset: AppImages.productSix,
          title: 'Vintage Camera',
          seller: 'Retro Finds',
          price: '\$650.00',
        ),
        _PurchaseProduct(
          imageAsset: AppImages.productTwo,
          title: 'Ming Vase',
          seller: 'Oriental Treasures',
          price: '\$1890.00',
        ),
      ],
      orderTotal: '\$2740.00',
    ),
    _PurchaseItem(
      date: 'Nov 15, 2024',
      status: 'delivered',
      items: [
        _PurchaseProduct(
          imageAsset: AppImages.productThree,
          title: 'Art Deco Necklace',
          seller: 'Luxury Vintage',
          price: '\$4200.00',
        ),
      ],
      orderTotal: '\$4536.00',
    ),
  ];

  List<_PurchaseItem> get _filteredPurchases {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final currentYear = DateTime(now.year);

    return _allPurchases.where((purchase) {
      final purchaseDate = _parseDate(purchase.date);

      switch (_selectedFilter) {
        case 'This Month':
          return purchaseDate.year == currentMonth.year &&
              purchaseDate.month == currentMonth.month;
        case 'This Year':
          return purchaseDate.year == currentYear.year;
        case 'All Time':
        default:
          return true;
      }
    }).toList();
  }

  DateTime _parseDate(String dateStr) {
    // Parse dates like "Dec 14, 2024"
    final parts = dateStr.split(' ');
    final monthStr = parts[0];
    final day = int.parse(parts[1].replaceAll(',', ''));
    final year = int.parse(parts[2]);

    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
    };

    return DateTime(year, months[monthStr] ?? 1, day);
  }

  @override
  Widget build(BuildContext context) {
    final purchases = _filteredPurchases;

    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Purchase History',
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
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryCard(),
              SizedBox(height: 14.h),
              _FilterChipsRow(
                selectedFilter: _selectedFilter,
                onFilterSelected: (filter) {
                  setState(() => _selectedFilter = filter);
                },
              ),
              SizedBox(height: 16.h),
              ...purchases.map(
                (purchase) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _purchaseCard(purchase),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientColor2, AppColors.gradientColor1],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.14),
            blurRadius: 22.r,
            spreadRadius: -10,
            offset: Offset(0, 14.h),
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
                      'Total Spent',
                      style: TextStyles.regularMedium.copyWith(
                        color: const Color(0xFFE8BC88),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '\$9736.40',
                      style: TextStyles.boldLarge.copyWith(
                        color: const Color(0xFFF8E8C7),
                        fontSize: 34.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 62.w,
                height: 62.w,
                decoration: BoxDecoration(
                  color: AppColors.bodyBg.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '\$',
                    style: TextStyles.boldLarge.copyWith(
                      color: const Color(0xFFE8BC88),
                      fontSize: 34.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _summaryStat(
                  label: 'Total Orders',
                  value: '4',
                ),
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: _summaryStat(
                  label: 'Items Purchased',
                  value: '5',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryStat({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.regularMedium.copyWith(
            color: const Color(0xFFE8BC88),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyles.regularLarge.copyWith(
            color: AppColors.bodyBg,
            fontSize: 28.sp,
          ),
        ),
      ],
    );
  }

  Widget _purchaseCard(_PurchaseItem purchase) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.08),
            blurRadius: 20.r,
            spreadRadius: -12,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: const Color(0xFFE2A56F),
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                purchase.date,
                style: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF758095),
                ),
              ),
              const Spacer(),
              _statusPill(purchase.status),
            ],
          ),
          SizedBox(height: 14.h),
          ..._buildProducts(purchase.items),
          SizedBox(height: 12.h),
          Container(
            height: 1,
            color: AppColors.lightText.withValues(alpha: 0.10),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                'Order Total',
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 17.sp,
                ),
              ),
              const Spacer(),
              Text(
                purchase.orderTotal,
                style: TextStyles.regularLarge.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProducts(List<_PurchaseProduct> items) {
    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return Padding(
        padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.asset(
                item.imageAsset,
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
                    item.title,
                    style: TextStyles.boldMedium.copyWith(
                      color: AppColors.gradientColor1,
                      fontSize: 17.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.seller,
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.gradientColor1,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.price,
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.redButton,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _statusPill(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FAED),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        status,
        style: TextStyles.regularSmall.copyWith(
          color: const Color(0xFF4ADE80),
        ),
      ),
    );
  }
}

class _FilterChipsRow extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const _FilterChipsRow({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HistoryChip(
          label: 'All Time',
          isSelected: selectedFilter == 'All Time',
          onTap: () => onFilterSelected('All Time'),
        ),
        _HistoryChip(
          label: 'This Month',
          isSelected: selectedFilter == 'This Month',
          onTap: () => onFilterSelected('This Month'),
        ),
        _HistoryChip(
          label: 'This Year',
          isSelected: selectedFilter == 'This Year',
          onTap: () => onFilterSelected('This Year'),
        ),
      ],
    );
  }
}

class _HistoryChip extends StatelessWidget {
  const _HistoryChip({
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.redButton : AppColors.bodyBg,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: isSelected
                ? AppColors.redButton
                : AppColors.shadowColor.withValues(alpha: 0.10),
          ),
          boxShadow: isSelected
              ? null
              : [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.06),
                    blurRadius: 14.r,
                    spreadRadius: -10,
                    offset: Offset(0, 8.h),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyles.regularMedium.copyWith(
            color: isSelected ? AppColors.bodyBg : AppColors.gradientColor1,
          ),
        ),
      ),
    );
  }
}

class _PurchaseItem {
  const _PurchaseItem({
    required this.date,
    required this.status,
    required this.items,
    required this.orderTotal,
  });

  final String date;
  final String status;
  final List<_PurchaseProduct> items;
  final String orderTotal;
}

class _PurchaseProduct {
  const _PurchaseProduct({
    required this.imageAsset,
    required this.title,
    required this.seller,
    required this.price,
  });

  final String imageAsset;
  final String title;
  final String seller;
  final String price;
}
