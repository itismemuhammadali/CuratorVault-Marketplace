import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/global_header/header_controller_provider.dart';
import 'package:vintage_app/core/components/layout_components/horizontal_divider.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/user_flow/my_finds/widgets/delete_item_dialog.dart';

class InventoryItemDetailView extends StatefulWidget {
  final String itemId;

  const InventoryItemDetailView({super.key, required this.itemId});

  @override
  State<InventoryItemDetailView> createState() =>
      _InventoryItemDetailViewState();
}

class _InventoryItemDetailViewState extends State<InventoryItemDetailView> {
  bool _headerSet = false;

  _InventoryDetails get _item => _items[widget.itemId] ?? _items['1']!;

  static final Map<String, _InventoryDetails> _items = {
    '1': const _InventoryDetails(
      image: AppImages.productOne,
      title: 'Victorian Pocket Watch',
      category: 'Horology',
      era: 'Late Victorian (1880-1900)',
      price: '\$1,450',
      comparePrice: '\$1,800',
      discount: '19% OFF',
      description:
          'A beautifully preserved Victorian-era pocket watch featuring intricate hand-engraved patterns on the case and a pristine white enamel dial with Roman numerals. The mechanical movement is in excellent working condition with all original components intact.',
      specs: [
        ('Diameter', '50mm'),
        ('Movement', 'Mechanical, key-wind'),
        ('Case Material', 'Gold-plated brass'),
        ('Dial', 'White enamel'),
        ('Hands', 'Original blued steel'),
        ('Provenance', 'Documented'),
      ],
      views: '124',
      favorites: '12',
      inquiries: '3',
    ),
    '2': const _InventoryDetails(
      image: AppImages.productFour,
      title: 'Antique Oak Cabinet',
      category: 'Furniture',
      era: 'Victorian Period',
      price: '\$1,200',
      comparePrice: '\$1,500',
      discount: '20% OFF',
      description:
          'A restored antique oak cabinet with original brass fittings, detailed woodwork, and excellent storage capacity for collectibles.',
      specs: [
        ('Height', '160cm'),
        ('Material', 'Solid oak'),
        ('Finish', 'Natural wood'),
        ('Doors', '2'),
        ('Handles', 'Original brass'),
        ('Provenance', 'Documented'),
      ],
      views: '89',
      favorites: '8',
      inquiries: '2',
    ),
    '3': const _InventoryDetails(
      image: AppImages.productThree,
      title: 'Porcelain Vase Collection',
      category: 'Ceramics',
      era: 'Early 20th Century',
      price: '\$650',
      comparePrice: '\$800',
      discount: '18% OFF',
      description:
          'A curated porcelain vase collection with delicate floral detailing and excellent glaze quality.',
      specs: [
        ('Height', '30cm'),
        ('Material', 'Porcelain'),
        ('Origin', 'France'),
        ('Set', '3 pieces'),
        ('Condition', 'Excellent'),
        ('Provenance', 'Documented'),
      ],
      views: '156',
      favorites: '10',
      inquiries: '4',
    ),
    '4': const _InventoryDetails(
      image: AppImages.productFive,
      title: 'Vintage Pocket Watch',
      category: 'Horology',
      era: 'Victorian',
      price: '\$450',
      comparePrice: '\$600',
      discount: '25% OFF',
      description:
          'A compact vintage pocket watch with a beautifully aged case and a restored internal mechanism.',
      specs: [
        ('Diameter', '42mm'),
        ('Movement', 'Mechanical'),
        ('Case Material', 'Brass'),
        ('Dial', 'White enamel'),
        ('Hands', 'Original steel'),
        ('Provenance', 'Partial'),
      ],
      views: '0',
      favorites: '4',
      inquiries: '1',
    ),
  };

  Future<void> _showDeleteDialog() async {
    await showDeleteItemDialog(context, itemTitle: _item.title);
  }

  void _openEditPage() {
    context.push('/user/my-finds/edit/${widget.itemId}');
  }

  void _updateHeader() {
    HeaderControllerProvider.of(context).value = HeaderConfig(
      leading: IconBox(
        icon: AppImages.backIcon,
        bgColor: AppColors.darkText.withValues(alpha: 0.20),
        onTap: () => context.go('/user/my-finds'),
        iconColor: AppColors.darkText,
        height: 40.h,
        width: 40.w,
        borderRadius: 100.r,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 34.h),
          Text(
            'Item Details',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 26.sp,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconBox(
            icon: AppImages.editBoxedIcon,
            bgColor: AppColors.darkText.withValues(alpha: 0.20),
            onTap: _openEditPage,
            iconColor: AppColors.bodyBg,
            height: 40.h,
            width: 40.w,
            borderRadius: 100.r,
          ),
          SizedBox(width: 10.w),
          IconBox(
            icon: AppImages.trashOutlinedIcon,
            bgColor: AppColors.redButton,
            onTap: _showDeleteDialog,
            iconColor: AppColors.bodyBg,
            height: 40.h,
            width: 40.w,
            borderRadius: 100.r,
          ),
        ],
      ),
      height: 182.h,
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
    final item = _item;

    return Container(
      color: AppColors.subPageBg,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bodyBg,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: Image.asset(
                    item.image,
                    height: 240.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFF8E8),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Live',
                    style: TextStyles.mediumMedium.copyWith(
                      color: const Color(0xFF0F9D58),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bodyBg,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFE2E6EE)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        size: 16.sp,
                        color: const Color(0xFF2F80FF),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${item.views} views',
                        style: TextStyles.mediumMedium.copyWith(
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              item.title,
              style: TextStyles.boldLarge.copyWith(
                color: AppColors.lightText,
                fontSize: 22.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkText,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    item.category,
                    style: TextStyles.regularExtraSmall.copyWith(
                      color: AppColors.bodyBg,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.darkText, width: 2),
                  ),
                  child: Text(
                    item.era,
                    style: TextStyles.regularExtraSmall.copyWith(
                      color: AppColors.lightText,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.price,
                  style: TextStyles.boldLarge.copyWith(
                    color: AppColors.redButton,
                    fontSize: 30.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  item.comparePrice,
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.greyText,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.greenSuccess,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    item.discount,
                    style: TextStyles.boldExtraSmall.copyWith(
                      color: AppColors.bodyBg,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Text('Description', style: TextStyles.semiBoldMedium),
            SizedBox(height: 8.h),
            Text(
              item.description,
              style: TextStyles.regularSmall.copyWith(
                color: AppColors.greyText,
                height: 1.5,
              ),
            ),
            SizedBox(height: 18.h),
            Text('Specifications', style: TextStyles.semiBoldMedium),
            SizedBox(height: 10.h),
            for (int i = 0; i < item.specs.length; i++) ...[
              _specRow(item.specs[i].$1, item.specs[i].$2),
              if (i != item.specs.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: HorizontalDivider(width: double.infinity),
                ),
            ],
            SizedBox(height: 18.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
              decoration: BoxDecoration(
                color: AppColors.gradientColor1,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance',
                    style: TextStyles.boldMedium.copyWith(
                      color: AppColors.bodyBg,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _performanceMetric(
                        Icons.remove_red_eye_outlined,
                        item.views,
                        'Views',
                      ),
                      _performanceMetric(
                        Icons.star_outline_rounded,
                        item.favorites,
                        'Favorites',
                      ),
                      _performanceMetric(
                        Icons.inventory_2_outlined,
                        item.inquiries,
                        'Inquiries',
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

  Widget _specRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.regularMedium.copyWith(color: AppColors.greyText),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          value,
          style: TextStyles.mediumMedium.copyWith(color: AppColors.lightText),
        ),
      ],
    );
  }

  Widget _performanceMetric(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.bodyBg, size: 26.sp),
        SizedBox(height: 10.h),
        Text(
          value,
          style: TextStyles.boldLarge.copyWith(
            color: AppColors.bodyBg,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyles.regularSmall.copyWith(color: AppColors.bodyBg),
        ),
      ],
    );
  }
}

class _InventoryDetails {
  final String image;
  final String title;
  final String category;
  final String era;
  final String price;
  final String comparePrice;
  final String discount;
  final String description;
  final List<(String, String)> specs;
  final String views;
  final String favorites;
  final String inquiries;

  const _InventoryDetails({
    required this.image,
    required this.title,
    required this.category,
    required this.era,
    required this.price,
    required this.comparePrice,
    required this.discount,
    required this.description,
    required this.specs,
    required this.views,
    required this.favorites,
    required this.inquiries,
  });
}
