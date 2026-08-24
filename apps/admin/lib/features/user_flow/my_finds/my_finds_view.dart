import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/includes/horizontal_chip_bar.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/components/cards/app_item_card.dart';

import '../../../core/components/global_header/header_config.dart';
import '../../../core/components/global_layout/main_layout.dart';
import '../../../core/components/icons/icon_box.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/images.dart';
import '../../../core/theme/text_styles.dart';

class MyFindsView extends StatefulWidget {
  const MyFindsView({super.key});

  @override
  State<MyFindsView> createState() => _MyFindsViewState();
}

class _MyFindsViewState extends State<MyFindsView> {
  int _selectedFilterIndex = 0;

  List<String> filters = [
    'All Items',
    'Horology',
    'Pottery',
    'Jewelry',
    'Photography',
  ];

  final List<({String id, String title, String price, String image})> _items = const [
    (
      id: '1',
      title: 'Victorian Pocket',
      price: '\$1,200 - \$1,800',
      image: AppImages.productOne,
    ),
    (
      id: '2',
      title: 'Ming Dynasty Vase',
      price: '\$1,200 - \$1,800',
      image: AppImages.productTwo,
    ),
    (
      id: '3',
      title: 'Ming Dynasty Vase',
      price: '\$1,200 - \$1,800',
      image: AppImages.productTwo,
    ),
    (
      id: '4',
      title: 'Art Deco Necklace',
      price: '\$1,200 - \$1,800',
      image: AppImages.productThree,
    ),
    (
      id: '5',
      title: 'Leica M3 Camera',
      price: '\$1,200 - \$1,800',
      image: AppImages.productSeven,
    ),
    (
      id: '6',
      title: 'Louis XV Chair',
      price: '\$1,200 - \$1,800',
      image: AppImages.productFive,
    ),
    (
      id: '7',
      title: 'First Edition Books',
      price: '\$1,200 - \$1,800',
      image: AppImages.productSix,
    ),
  ];

  HeaderConfig _buildHeader() {
    return HeaderConfig(
      title: Text(
        'My Collection',
        style: TextStyles.boldLarge.copyWith(color: AppColors.bodyBg),
      ),
      trailing: _collectionHeaderAction(),
      bottomWidget: HorizontalChipBar(
        items: filters,
        selectedIndex: _selectedFilterIndex,
        padding: EdgeInsets.zero,
        chipPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        chipHeight: 48.h,
        spacing: 12.w,
        activeBackgroundColor: AppColors.redButton,
        inactiveBackgroundColor: AppColors.darkText.withValues(alpha: 0.18),
        activeTextColor: AppColors.bodyBg,
        inactiveTextColor: AppColors.darkText,
        textStyle: TextStyles.regularMedium,
        borderRadius: BorderRadius.circular(999.r),
        onChanged: (index) {
          setState(() {
            _selectedFilterIndex = index;
          });
        },
      ),
      height: 188.h,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLayout(
      headerConfig: _buildHeader(),
      body: Container(
        color: AppColors.bodyBg,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      height: 56.h,
                      btnColor: AppColors.lightText,
                      borderRadius: 14.r,
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppImages.offerIcon,
                            width: 20.w,
                            height: 20.w,
                            color: AppColors.bodyBg,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Export PDF',
                            style: TextStyles.semiBoldSmall.copyWith(
                              color: AppColors.bodyBg,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: CustomButton(
                      height: 56.h,
                      btnColor: AppColors.redButton,
                      borderRadius: 14.r,
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppImages.shareIcon,
                            width: 20.w,
                            height: 20.w,
                            color: AppColors.bodyBg,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Share',
                            style: TextStyles.semiBoldSmall.copyWith(
                              color: AppColors.bodyBg,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 520 ? 3 : 2;
                  final mainAxisExtent = crossAxisCount == 3
                      ? 262.h
                      : constraints.maxWidth < 360
                          ? 264.h
                          : 272.h;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14.w,
                      mainAxisSpacing: 14.h,
                      mainAxisExtent: mainAxisExtent,
                    ),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];

                      return AppItemCard(
                        layout: AppItemCardLayout.grid,
                        title: item.title,
                        priceText: item.price,
                        imageAsset: item.image,
                        verified: true,
                        confidence: 0.94,
                        isFavorite: false,
                        onTap: () => context.push('/market/product/${item.id}'),
                        onFavoriteTap: () {},
                        unfavoriteIconColor: AppColors.redButton,
                        gridImageAspectRatio: 1.08,
                        gridTitleMaxLines: 1,
                        gridTitleStyle: TextStyles.semiBoldSmall,
                        gridShowDivider: true,
                        gridShowConfidenceOverlay: false,
                        gridShowConfidenceBar: true,
                        gridConfidenceBarWidth: 72.w,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _collectionHeaderAction() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconBox(
          icon: AppImages.offerIcon,
          height: 54.w,
          width: 54.w,
          bgColor: AppColors.darkText.withValues(alpha: 0.18),
          borderRadius: 60.r,
          iconColor: AppColors.darkText,
          onTap: () => context.push('/user/offers'),
        ),
        Positioned(
          top: -4.h,
          right: -4.w,
          child: Container(
            height: 28.w,
            width: 28.w,
            decoration: const BoxDecoration(
              color: AppColors.redButton,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '1',
                style: TextStyles.mediumSmall.copyWith(
                  color: AppColors.bodyBg,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
