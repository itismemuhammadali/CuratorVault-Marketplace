import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/collapsible_image_header.dart';
import 'package:vintage_app/core/components/global_header/transparent_header.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/components/icons/icon_box_transparent.dart';
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
  ScrollController scrollController = ScrollController();
  final List<String> productImages = [
    AppImages.productOne,
    AppImages.productTwo,
    AppImages.productThree,
  ];
  String selectedImage = AppImages.productOne;

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
    return TransparentHeader(
      backgroundColor: AppColors.bodyBg,
      title: Text(
        "Victorian Pocket Watch",
        style: TextStyles.boldMedium.copyWith(
          color: AppColors.bodyBg,
          fontSize: 20.sp,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconBox(
            icon: AppImages.heartIcon,
            bgColor: AppColors.bodyBg,
            iconColor: AppColors.redButton,
            height: 30.h,
            width: 30.w,
            borderRadius: 100.r,
          ),
          SizedBox(width: 10.w),
          IconBox(
            icon: AppImages.shareIcon,
            bgColor: AppColors.bodyBg,
            iconColor: AppColors.redButton,
            height: 30.h,
            width: 30.w,
            borderRadius: 100.r,
          ),
        ],
      ),
      body: Column(
        children: [
          CollapsibleImageHeader(
            image: selectedImage,
            maxHeight: 340.h,
            minHeight: 200.h,
            // controller: scrollController,
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
                      child: Image.asset(image, fit: BoxFit.cover),
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
                    // Title + tag
                    Text(
                      'Victorian Pocket Watch',
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
                            'Horology',
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
                            'Late Victorian (1880-1900)',
                            style: TextStyles.regularExtraSmall.copyWith(
                              color: AppColors.lightText,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Price row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$1,450',
                          style: TextStyles.boldLarge.copyWith(
                            fontSize: 30.sp,
                            color: AppColors.redButton,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '\$1,800',
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
                            '19% OFF',
                            style: TextStyles.boldExtraSmall.copyWith(
                              color: AppColors.bodyBg,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Seller section card
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
                          // Shield icon circle
                          IconBox(
                            icon: AppImages.sheildIcon,
                            bgColor: AppColors.redButton,
                            iconColor: AppColors.bodyBg,
                            height: 44.h,
                            width: 44.w,
                            borderRadius: 999.r,
                          ),
                          SizedBox(width: 12.w),
                          // Seller name + rating
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Heritage Antiques',
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
                                      '4.8 (342 reviews)',
                                      style: TextStyles.regularExtraSmall
                                          .copyWith(color: AppColors.lightText),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Outlined Chat button
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

                    // Location
                    Row(
                      children: [
                        IconBoxTransparent(
                          icon: AppImages.mapMarkerIcon,
                          color: AppColors.redButton,
                          size: 20,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            'London, England',
                            style: TextStyles.regularSmall.copyWith(
                              color: AppColors.greyText,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Description
                    Text('Description', style: TextStyles.semiBoldMedium),
                    SizedBox(height: 8.h),
                    Text(
                      'A beautifully preserved Victorian-era pocket watch featuring intricate hand-engraved patterns on the case and a pristine white enamel dial with Roman numerals. The mechanical movement is in excellent working condition, with all original components intact.',
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Specifications
                    Text('Specifications', style: TextStyles.semiBoldMedium),
                    SizedBox(height: 12.h),
                    _specRow('Diameter', '50mm'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: HorizontalDivider(width: double.infinity),
                    ),
                    _specRow('Movement', 'Mechanical, key-wind'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: HorizontalDivider(width: double.infinity),
                    ),
                    _specRow('Case Material', 'Gold-plated brass'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: HorizontalDivider(width: double.infinity),
                    ),
                    _specRow('Dial', 'White enamel'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: HorizontalDivider(width: double.infinity),
                    ),
                    _specRow('Hands', 'Original blued steel'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: HorizontalDivider(width: double.infinity),
                    ),
                    _specRow('Provenance', 'Documented'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: HorizontalDivider(width: double.infinity),
                    ),

                    SizedBox(height: 20.h),

                    // Why buy this
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Why Buy This?', style: TextStyles.semiBoldSmall),
                        Text(
                          'View All',
                          style: TextStyles.regularExtraSmall.copyWith(
                            color: AppColors.redButton,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h,),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = (constraints.maxWidth - 10.w) / 2;

                        return Wrap(
                          spacing: 10.w,
                          runSpacing: 10.h,
                          children: [
                            _whyChip(
                              'Verified by AI authentication',
                              itemWidth,
                            ),
                            _whyChip(
                              'Certified by expert horologist',
                              itemWidth,
                            ),
                            _whyChip('Original components intact', itemWidth),
                            _whyChip('Working mechanical movement', itemWidth),
                            _whyChip('Documented provenance', itemWidth),
                            _whyChip('30-day money-back guarantee', itemWidth),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 20.h),

                    // Condition section
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.authBackBg,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconBoxTransparent(
                              icon: AppImages.alertIcon,
                            size: 20,
                            color: AppColors.redButton  ,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Condition',
                                  style: TextStyles.semiBoldSmall,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Authenticated by AI and certified experts. All items come with a certificate of authenticity.',
                                  style: TextStyles.regularExtraSmall.copyWith(
                                    color: AppColors.lightText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Excellent',
                            style: TextStyles.semiBoldExtraSmall.copyWith(
                              color: AppColors.greenSuccess,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Bottom buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            height: 52.h,
                            borderRadius: 14.r,
                            btnText: 'Buy Now',
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
                            btnText: 'Make Offer',
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

Widget _whyChip(String text, double width) {
  return SizedBox(
    width: width,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.darkText.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBoxTransparent(
            icon: AppImages.tickIcon,
            color: AppColors.greenSuccess,
            size: 20,
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Text(
              text,
              softWrap: true,
              style: TextStyles.regularExtraSmall.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
