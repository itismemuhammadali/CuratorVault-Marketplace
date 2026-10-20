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
  double _gradientOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
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

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double offset = scrollController.offset;
    double opacity = 0.0;
    if (offset > 200) {
      opacity = ((offset - 200) / 100).clamp(0.0, 1.0);
    }
    if (opacity != _gradientOpacity) {
      setState(() {
        _gradientOpacity = opacity;
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

    final title = _itemData?['title'] ?? 'Victorian Antique';
    final category = _itemData?['category'] ?? 'Furniture';
    final era = _itemData?['era'] ?? 'Late 19th Century';
    final price = (_itemData?['price'] ?? 1450.0).toDouble();
    final estMax = (_itemData?['estimatedValueMax'] ?? (price * 1.2)).toDouble();
    final description = _itemData?['description'] ?? 'Authenticated antique piece with certified provenance.';
    final condition = _itemData?['condition'] ?? 'Excellent';
    final provenance = _itemData?['provenance'] ?? 'Private Collection';
    final sellerName = _itemData?['sellerName'] ?? 'Verified Dealer';
    final sellerRating = (_itemData?['sellerRating'] ?? 4.9).toString();
    final materials = (_itemData?['materials'] as List?)?.join(', ') ?? 'Solid Timber, Handcrafted Joinery';

    return TransparentHeader(
      backgroundColor: AppColors.bodyBg,
      extendBodyBehindAppBar: true,
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
            context.go('/user/market');
          }
        },
      ),
      headerPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      leadingGap: 16.w,
      showDivider: false,
      backgroundGradient: _gradientOpacity > 0
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2D3E55).withValues(alpha: _gradientOpacity),
                Color(0xFF1A2332).withValues(alpha: _gradientOpacity),
              ],
            )
          : null,
      title: Text(
        title,
        style: TextStyles.boldMedium.copyWith(
          color: Colors.white,
          fontSize: 20.sp,
        ),
      ),
      trailing: const SizedBox.shrink(),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
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
                      width: 80.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isSelected ? AppColors.redButton : Colors.transparent,
                          width: 2,
                        ),
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
                separatorBuilder: (context, index) => SizedBox(width: 10.w),
                itemCount: productImages.length,
              ),
            ),
            Padding(
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
                    const HorizontalDivider(),
                    SizedBox(height: 16.h),
                    Text(
                      'Description',
                      style: TextStyles.semiBoldMedium.copyWith(
                        color: AppColors.lightText,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      description,
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    const HorizontalDivider(),
                    SizedBox(height: 16.h),
                    Text(
                      'Item Specifications',
                      style: TextStyles.semiBoldMedium.copyWith(
                        color: AppColors.lightText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _specRow('Era', era),
                    _specRow('Condition', condition),
                    _specRow('Materials', materials),
                    _specRow('Provenance', provenance),
                    _specRow('Seller', sellerName),
                    _specRow('Seller Rating', '$sellerRating ★'),
                    SizedBox(height: 16.h),
                    const HorizontalDivider(),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF7F2),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: const Color(0xFFEADBCE)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.shield_outlined, color: AppColors.redButton, size: 24.sp),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Guaranteed Authenticity',
                                  style: TextStyles.semiBoldSmall.copyWith(color: AppColors.lightText),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Inspected by certified appraisers and backed by buyer protection.',
                                  style: TextStyles.regularExtraSmall.copyWith(color: AppColors.greyText),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            height: 52.h,
                            borderRadius: 14.r,
                            btnText: 'Buy Now',
                            btnColor: AppColors.redButton,
                            textColor: Colors.white,
                            onTap: () {
                              context.push('/user/checkout', extra: {'productId': widget.productId});
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomButton(
                            height: 52.h,
                            borderRadius: 14.r,
                            btnText: 'Make Offer',
                            btnColor: AppColors.bodyBg,
                            textColor: AppColors.redButton,
                            onTap: () {
                              context.push('/user/make-offer', extra: {'productId': widget.productId});
                            },
                            borderColor: AppColors.redButton,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
