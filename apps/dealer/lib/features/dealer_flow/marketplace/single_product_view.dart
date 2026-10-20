import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/collapsible_image_header.dart';
import 'package:vintage_app/core/components/global_header/transparent_header.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/items_service.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';

import '../../../core/components/layout_components/horizontal_divider.dart';

class SingleProductView extends StatefulWidget {
  final String productId;
  const SingleProductView({super.key, required this.productId});

  @override
  State<SingleProductView> createState() => _SingleProductViewState();
}

class _SingleProductViewState extends State<SingleProductView> {
  final ScrollController scrollController = ScrollController();
  bool _isLoading = true;
  Map<String, dynamic>? _itemData;
  List<String> productImages = [AppImages.productOne];
  String selectedImage = AppImages.productOne;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
    });

    final data = await ItemsService.getItemDetail(widget.productId);
    if (mounted) {
      setState(() {
        _itemData = data;
        if (data != null) {
          final imgs = data['images'] as List?;
          if (imgs != null && imgs.isNotEmpty) {
            productImages = imgs.map((e) => e.toString()).toList();
          } else if (data['imageUrl'] != null) {
            productImages = [data['imageUrl'].toString()];
          }
          selectedImage = productImages.first;
        }
        _isLoading = false;
      });
    }
  }

  void _updateImage(String image) {
    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bodyBg,
        body: const Center(
          child: JumpingDots(color: AppColors.redButton),
        ),
      );
    }

    final title = _itemData?['title'] ?? 'Victorian Antique Piece';
    final category = _itemData?['category'] ?? 'Horology';
    final era = _itemData?['era'] ?? 'Late Victorian (1880-1900)';
    final price = (_itemData?['price'] ?? 1450.0).toDouble();
    final estMax = (_itemData?['estimatedValueMax'] ?? (price * 1.25)).toDouble();
    final description = _itemData?['description'] ?? 'Expert-inspected antique available for trade acquisition.';
    final condition = _itemData?['condition'] ?? 'Excellent';
    final provenance = _itemData?['provenance'] ?? 'Private Estate Collection';
    final sellerName = _itemData?['sellerName'] ?? 'Heritage Antiques';
    final sellerRating = (_itemData?['sellerRating'] ?? 4.9).toString();
    final materials = (_itemData?['materials'] as List?)?.join(', ') ?? 'Original Components & Joinery';

    return TransparentHeader(
      backgroundColor: AppColors.bodyBg,
      title: Text(
        title,
        style: TextStyles.boldMedium.copyWith(
          color: AppColors.bodyBg,
          fontSize: 20.sp,
        ),
      ),
      trailing: const SizedBox.shrink(),
      leading: IconBox(
        icon: AppImages.backIcon,
        iconColor: const Color(0xFFF8E8C7),
        bgColor: const Color(0xFFF8E8C7).withValues(alpha: 0.2),
        height: 40.h,
        width: 40.w,
        borderRadius: 100.r,
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/market');
          }
        },
      ),
      body: Column(
        children: [
          CollapsibleImageHeader(
            image: selectedImage.contains('assets/') ? selectedImage : AppImages.productOne,
            maxHeight: 340.h,
            minHeight: 200.h,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 80.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              itemBuilder: (context, index) {
                final image = productImages[index];
                final isSelected = image == selectedImage;

                return GestureDetector(
                  onTap: () => _updateImage(image),
                  child: Container(
                    height: 80.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: isSelected
                          ? Border.all(color: AppColors.redButton, width: 2)
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.asset(
                        image.contains('assets/') ? image : AppImages.productOne,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemCount: productImages.length,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
              child: Container(
                color: AppColors.bodyBg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.semiBoldLarge.copyWith(
                        color: AppColors.lightText,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkText,
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                          child: Text(
                            category,
                            style: TextStyles.regularExtraSmall.copyWith(
                              color: AppColors.lightText,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.r),
                            border: Border.all(
                              color: AppColors.darkText,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            era,
                            style: TextStyles.regularExtraSmall.copyWith(
                              color: AppColors.lightText,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${price.toInt()}',
                          style: TextStyles.boldLarge.copyWith(
                            fontSize: 30.sp,
                            color: AppColors.redButton,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '\$${estMax.toInt()}',
                          style: TextStyles.regularMedium.copyWith(
                            color: AppColors.greyText,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greenSuccess,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'AUTHENTICATED',
                            style: TextStyles.boldExtraSmall.copyWith(
                              color: AppColors.bodyBg,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.authBackBg,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          IconBox(
                            icon: AppImages.sheildIcon,
                            bgColor: AppColors.redButton,
                            iconColor: AppColors.bodyBg,
                            height: 44.h,
                            width: 44.w,
                            borderRadius: 999.r,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sellerName,
                                  style: TextStyles.semiBoldSmall,
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: 14.sp,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '$sellerRating (Verified Dealer)',
                                      style: TextStyles.regularExtraSmall
                                          .copyWith(color: AppColors.lightText),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          CustomButton(
                            height: 36.h,
                            width: 90.w,
                            borderRadius: 999.r,
                            btnColor: Colors.transparent,
                            borderColor: AppColors.redButton,
                            onTap: () => context.push('/single_message'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  AppImages.chatBubbleIcon,
                                  color: AppColors.redButton,
                                  width: 15.w,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Chat',
                                  style: TextStyles.regularSmall.copyWith(
                                    color: AppColors.redButton,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    Text('Description', style: TextStyles.semiBoldMedium),
                    SizedBox(height: 8.h),
                    Text(
                      description,
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Text('Specifications', style: TextStyles.semiBoldMedium),
                    SizedBox(height: 12.h),
                    _specRow('Era', era),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: HorizontalDivider(width: double.infinity),
                    ),
                    _specRow('Condition', condition),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: HorizontalDivider(width: double.infinity),
                    ),
                    _specRow('Materials', materials),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: HorizontalDivider(width: double.infinity),
                    ),
                    _specRow('Provenance', provenance),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: HorizontalDivider(width: double.infinity),
                    ),

                    SizedBox(height: 24.h),

                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            height: 52.h,
                            borderRadius: 14.r,
                            btnText: 'Acquire Lot',
                            btnColor: AppColors.redButton,
                            textColor: Colors.white,
                            onTap: () => context.push('/market/checkout/shipping'),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomButton(
                            height: 52.h,
                            borderRadius: 14.r,
                            btnText: 'Dealer Offer',
                            btnColor: AppColors.bodyBg,
                            textColor: AppColors.redButton,
                            onTap: () => context.push(
                              '/market/product/${widget.productId}/offer',
                            ),
                            borderColor: AppColors.redButton,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _specRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.regularMedium.copyWith(color: AppColors.greyText),
          ),
        ),
        Text(value, style: TextStyles.regularMedium),
      ],
    ),
  );
}

