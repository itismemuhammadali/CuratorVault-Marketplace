import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/global_header/header_controller_provider.dart';
import 'package:vintage_app/core/components/includes/horizontal_chip_bar.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/items_service.dart';
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
  bool _isLoading = true;
  List<Map<String, dynamic>> _finds = [];

  final List<String> filters = const [
    'All Items',
    'Furniture',
    'Horology',
    'Pottery',
    'Jewelry',
  ];

  @override
  void initState() {
    super.initState();
    _loadFinds();
  }

  Future<void> _loadFinds() async {
    setState(() {
      _isLoading = true;
    });

    final selectedCategory = filters[_selectedFilterIndex];
    final items = await ItemsService.getMyFinds(
      category: selectedCategory == 'All Items' ? null : selectedCategory,
    );

    if (mounted) {
      setState(() {
        _finds = items;
        _isLoading = false;
      });
    }
  }

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
            _loadFinds();
          },
        ),
        height: 175.h,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: AppColors.subPageBg,
        child: const Center(
          child: JumpingDots(color: AppColors.redButton),
        ),
      );
    }

    if (_finds.isEmpty) {
      return Container(
        color: AppColors.subPageBg,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined, size: 54.sp, color: Colors.grey),
              SizedBox(height: 12.h),
              Text(
                'No items found in this category',
                style: TextStyles.mediumSmall.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: AppColors.subPageBg,
      child: RefreshIndicator(
        onRefresh: _loadFinds,
        color: AppColors.redButton,
        child: GridView.builder(
          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 18.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: 0.75,
          ),
          itemCount: _finds.length,
          itemBuilder: (context, index) {
            final item = _finds[index];
            return _CollectionCard(
              item: item,
              onTap: () => context.push('/market/product/${item['id']}'),
            );
          },
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const _CollectionCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = item['title'] ?? 'Vintage Item';
    final price = item['price'] ?? '\$1,200 - \$1,800';
    final score = item['authenticityScore'] ?? 94;
    final imgPath = item['image'] ?? item['imageUrl'] ?? AppImages.productOne;

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
              child: imgPath.toString().startsWith('http')
                  ? Image.network(
                      imgPath,
                      width: double.infinity,
                      height: 140.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        AppImages.productOne,
                        width: double.infinity,
                        height: 140.h,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      imgPath.toString().contains('assets/') ? imgPath : AppImages.productOne,
                      width: double.infinity,
                      height: 140.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        AppImages.productOne,
                        width: double.infinity,
                        height: 140.h,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
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
                    price,
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
                              '$score%',
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
                                  widthFactor: (score / 100.0).clamp(0.1, 1.0),
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
