import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/cards/app_item_card.dart';
import '../../../core/components/global_header/header_config.dart';
import '../../../core/components/global_header/header_controller_provider.dart';
import '../../../core/components/icons/icon_box.dart';
import '../../../core/components/includes/app_text_field.dart';
import '../../../core/components/includes/horizontal_chip_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/images.dart';
import '../../../core/theme/text_styles.dart';

class MarketplaceView extends StatefulWidget {
  const MarketplaceView({super.key});

  @override
  State<MarketplaceView> createState() => _MarketplaceViewState();
}

class _MarketplaceViewState extends State<MarketplaceView> {
  final TextEditingController _searchController = TextEditingController();
  bool _headerSet = false;

  int _selectedFilterIndex = 0;

  final List<String> filters = const [
    'All',
    'Furniture',
    'Jewelry',
    'Art',
    'Ceramics',
  ];

  final List<({
    String title,
    String location,
    String price,
    String image,
    AppItemCardBadge badge,
    double confidence,
  })> _items = const [
    (
      title: 'Edwardian Writing Desk',
      location: 'London, UK',
      price: '\$3,200',
      image: AppImages.productOne,
      badge: AppItemCardBadge.hot,
      confidence: 0.86,
    ),
    (
      title: 'Art Nouveau Brooch',
      location: 'London, UK',
      price: '\$3,200',
      image: AppImages.productTwo,
      badge: AppItemCardBadge.hot,
      confidence: 0.94,
    ),
    (
      title: 'Mid-Century Modern Chair',
      location: 'New York, USA',
      price: '\$1,500',
      image: AppImages.productThree,
      badge: AppItemCardBadge.hot,
      confidence: 0.96,
    ),
    (
      title: 'Victorian Silver Teapot',
      location: 'Birmingham, UK',
      price: '\$1,800',
      image: AppImages.productFour,
      badge: AppItemCardBadge.hot,
      confidence: 0.95,
    ),
    (
      title: 'Bauhaus Coffee Table',
      location: 'Berlin, Germany',
      price: '\$2,000',
      image: AppImages.productFive,
      badge: AppItemCardBadge.hot,
      confidence: 0.95,
    ),
    (
      title: 'Renaissance Oil Painting',
      location: 'Florence, Italy',
      price: '\$15,000',
      image: AppImages.productSix,
      badge: AppItemCardBadge.hot,
      confidence: 0.95,
    ),
  ];

  void _updateHeader() {
    HeaderControllerProvider.of(context).value = HeaderConfig(
      title: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Marketplace',
              style:
                  TextStyles.semiBoldLarge.copyWith(color: AppColors.bodyBg),
            ),
            SizedBox(height: 4.h),
            Text(
              'Discover authentic antiques worldwide',
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.darkText,
              ),
            ),
          ],
        ),
      ),
      trailing: Stack(
        clipBehavior: Clip.none,
        children: [
          IconBox(
            icon: AppImages.shoppingCartIcon,
            height: 40.h,
            width: 40.w,
            bgColor: AppColors.darkText.withValues(alpha: 0.12),
            borderRadius: 60.r,
            iconColor: AppColors.darkText,
            onTap: () => context.push('/market/cart'),
          ),
          Positioned(
            top: -4.h,
            right: -4.w,
            child: Container(
              height: 19.h,
              width: 19.w,
              decoration: const BoxDecoration(
                color: AppColors.redButton,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '3',
                  style: TextStyles.semiBoldSmall.copyWith(
                    color: AppColors.bodyBg,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      bottomWidget: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _searchController,
              hintText: 'Search marketplace...',
              fillColor: AppColors.darkText,
              prefix: IconBox(
                icon: AppImages.magnifineGlassIcon,
                bgColor: Colors.transparent,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          IconBox(
            icon: AppImages.filterIcon,
            bgColor: AppColors.darkText,
            iconColor: AppColors.lightText,
            borderRadius: 16.r,
            height: 52.h,
            width: 40.w,
          ),
        ],
      ),
      height: 220.h,
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
      color: AppColors.bodyBg,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              child: Column(
                children: [
                  HorizontalChipBar(
                    items: filters,
                    selectedIndex: _selectedFilterIndex,
                    onChanged: (index) {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    activeBackgroundColor: AppColors.redButton,
                    inactiveBackgroundColor: Colors.transparent,
                    inactiveTextColor: AppColors.lightText,
                    activeTextColor: AppColors.bodyBg,
                  ),
                  SizedBox(height: 24.h,),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];

                      return AppItemCard(
                        layout: AppItemCardLayout.grid,
                        title: item.title,
                        locationText: item.location,
                        priceText: item.price,
                        priceColor: AppColors.redButton,
                        imageAsset: item.image,
                        badge: item.badge,
                        confidence: item.confidence,
                        gridTitleMaxLines: 1,
                        gridActionIcon: Icons.favorite_border,
                        gridActionPosition:
                            AppItemCardGridActionPosition.topRight,
                        onGridActionTap: () {},
                        onTap: () {},
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.redButton),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 14.h,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Load More Items',
                        style: TextStyles.boldSmall.copyWith(
                          color: AppColors.redButton,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
