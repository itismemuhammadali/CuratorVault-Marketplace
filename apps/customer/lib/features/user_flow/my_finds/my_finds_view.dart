import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/global_header/header_controller_provider.dart';
import 'package:vintage_app/core/components/includes/horizontal_chip_bar.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class MyFindsView extends StatefulWidget {
  const MyFindsView({super.key});

  @override
  State<MyFindsView> createState() => _MyFindsViewState();
}

class _MyFindsViewState extends State<MyFindsView> {
  int _selectedFilterIndex = 0;

  final List<String> filters = const [
    'All Items',
    'Horology',
    'Pottery',
    'Jewelry',
    'Photography',
  ];

  final List<_InventoryItem> _items = const [
    _InventoryItem(
      id: '1',
      title: 'Victorian Mahogany Chair',
      price: '\$1,200 - \$1,800',
      views: '124',
      status: 'Live',
      statusColor: Color(0xFF19D36B),
      image: AppImages.productOne,
    ),
    _InventoryItem(
      id: '2',
      title: 'Antique Oak Cabinet',
      price: '\$1,200 - \$1,800',
      views: '89',
      status: 'Live',
      statusColor: Color(0xFF19D36B),
      image: AppImages.productFour,
    ),
    _InventoryItem(
      id: '3',
      title: 'Porcelain Vase Collection',
      price: '\$1,200 - \$1,800',
      views: '156',
      status: 'Sold',
      statusColor: Color(0xFF1F2937),
      image: AppImages.productThree,
    ),
    _InventoryItem(
      id: '4',
      title: 'Vintage Pocket Watch',
      price: '\$1,200 - \$1,800',
      views: '0',
      status: 'Draft',
      statusColor: Color(0xFFB56C3A),
      image: AppImages.productFive,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      HeaderControllerProvider.of(context).value = HeaderConfig(
        title: Text(
          'My Collection',
          style: TextStyles.boldLarge.copyWith(color: Colors.white),
        ),
        trailing: GestureDetector(
          onTap: () => context.push('/user/my-finds/offers'),
          child: Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.offerIconBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppImages.offerIcon,
                width: 24.w,
                height: 24.w,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFD4A574),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        bottomWidget: HorizontalChipBar(
          items: filters,
          selectedIndex: _selectedFilterIndex,
          padding: EdgeInsets.zero,
          chipPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          chipHeight: 36.h,
          spacing: 10.w,
          activeBackgroundColor: AppColors.collectionChipSelected,
          inactiveBackgroundColor: AppColors.collectionChipUnselected,
          activeTextColor: AppColors.collectionChipText,
          inactiveTextColor: AppColors.collectionChipText,
          textStyle: TextStyles.mediumSmall,
          borderRadius: BorderRadius.circular(20.r),
          onChanged: (index) {
            setState(() {
              _selectedFilterIndex = index;
            });
          },
        ),
        height: 175.h,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.subPageBg,
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 18.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.h,
          childAspectRatio: 0.75,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return _CollectionCard(
            item: item,
            onTap: () => context.push('/market/product/${item.id}'),
          );
        },
      ),
    );
  }
}

class _InventoryItem {
  final String id;
  final String title;
  final String price;
  final String views;
  final String status;
  final Color statusColor;
  final String image;

  const _InventoryItem({
    required this.id,
    required this.title,
    required this.price,
    required this.views,
    required this.status,
    required this.statusColor,
    required this.image,
  });
}

class _CollectionCard extends StatelessWidget {
  final _InventoryItem item;
  final VoidCallback onTap;

  const _CollectionCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.12),
              blurRadius: 12.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: Image.asset(
                item.image,
                width: double.infinity,
                height: 140.h,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.boldSmall.copyWith(
                      color: AppColors.lightText,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 1,
                    color: AppColors.collectionProgressEmpty,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    item.price,
                    style: TextStyles.boldSmall.copyWith(
                      color: AppColors.redButton,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(child: SizedBox.shrink()),
                      SizedBox(
                        width: 77.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '94%',
                              style: TextStyles.boldExtraSmall.copyWith(
                                color: AppColors.redButton,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: AppColors.collectionProgressEmpty,
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: 0.94,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.redButton,
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
