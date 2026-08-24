import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class WriteReviewView extends StatefulWidget {
  const WriteReviewView({super.key, required this.orderId});

  final String orderId;

  @override
  State<WriteReviewView> createState() => _WriteReviewViewState();
}

class _WriteReviewViewState extends State<WriteReviewView> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _experienceController = TextEditingController();
  final List<Uint8List> _reviewPhotos = [];
  int _productRating = 0;
  int _sellerRating = 0;

  final List<String> _tags = const [
    'Exactly as described',
    'Great condition',
    'Fast shipping',
    'Well packaged',
    'Authentic',
    'Beautiful craftsmanship',
    'Good value',
    'Responsive seller',
  ];

  @override
  void dispose() {
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    if (_reviewPhotos.length >= 5) return;

    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
      );

      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (!mounted) return;

      setState(() {
        _reviewPhotos.add(bytes);
      });
    } catch (_) {
      // No-op: image picking may be unavailable on some platforms.
    }
  }

  void _submitReview() {
    context.go('/dealer/order-history/track/${widget.orderId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Write a Review',
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
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionCard(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14.r),
                            child: Image.asset(
                              AppImages.productOne,
                              width: 88.w,
                              height: 88.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Art Deco Lamp',
                                  style: TextStyles.boldMedium.copyWith(
                                    color: AppColors.gradientColor1,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Sold by Classic Collectibles',
                                  style: TextStyles.regularMedium.copyWith(
                                    color: AppColors.greyText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _title('Rate the Product'),
                          SizedBox(height: 18.h),
                          Center(
                            child: _starRow(
                              rating: _productRating,
                              onChanged: (value) {
                                setState(() {
                                  _productRating = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _title('Rate the Seller'),
                          SizedBox(height: 18.h),
                          Center(
                            child: _starRow(
                              rating: _sellerRating,
                              onChanged: (value) {
                                setState(() {
                                  _sellerRating = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _title('Share Your Experience'),
                          SizedBox(height: 14.h),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.bodyBg,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: AppColors.redButton.withValues(
                                  alpha: 0.55,
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: _experienceController,
                              maxLines: 5,
                              maxLength: 500,
                              style: TextStyles.regularMedium.copyWith(
                                color: AppColors.gradientColor1,
                                height: 1.45,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Tell us about your experience with this item. What did you like? How was the condition? Would you recommend it?',
                                hintStyle: TextStyles.regularMedium.copyWith(
                                  color: AppColors.greyText,
                                  height: 1.45,
                                ),
                                border: InputBorder.none,
                                counterText: '',
                                contentPadding: EdgeInsets.fromLTRB(
                                  14.w,
                                  14.h,
                                  14.w,
                                  14.h,
                                ),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Text(
                                'Minimum 10 characters',
                                style: TextStyles.regularSmall.copyWith(
                                  color: AppColors.greyText,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${_experienceController.text.length}/500',
                                style: TextStyles.regularSmall.copyWith(
                                  color: AppColors.redButton.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _title('Add Photos (Optional)'),
                          SizedBox(height: 14.h),
                          Wrap(
                            spacing: 12.w,
                            runSpacing: 12.h,
                            children: [
                              GestureDetector(
                                onTap: _addPhoto,
                                child: Container(
                                  width: 72.w,
                                  height: 72.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.bodyBg,
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: AppColors.redButton.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        color: const Color(0xFFD8A976),
                                        size: 22.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Add',
                                        style: TextStyles.regularSmall.copyWith(
                                          color: const Color(0xFFD8A976),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ..._reviewPhotos.map(
                                (photo) => ClipRRect(
                                  borderRadius: BorderRadius.circular(14.r),
                                  child: Image.memory(
                                    photo,
                                    width: 72.w,
                                    height: 72.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'You can add up to 5 photos',
                            style: TextStyles.regularSmall.copyWith(
                              color: AppColors.gradientColor1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _title('Quick Tags'),
                          SizedBox(height: 16.h),
                          Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: _tags
                                .map(
                                  (tag) => Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF4EE),
                                      borderRadius: BorderRadius.circular(
                                        999.r,
                                      ),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyles.regularMedium.copyWith(
                                        color: AppColors.redButton,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 18.h),
              decoration: BoxDecoration(
                color: AppColors.bodyBg,
                border: Border(
                  top: BorderSide(
                    color: AppColors.lightText.withValues(alpha: 0.08),
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: _submitReview,
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: AppColors.gradientColor1,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Text(
                      'Submit Review',
                      style: TextStyles.semiBoldMedium.copyWith(
                        color: AppColors.bodyBg,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.lightText.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.08),
            blurRadius: 18,
            spreadRadius: -12,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: TextStyles.boldMedium.copyWith(
        color: AppColors.gradientColor1,
        fontSize: 18.sp,
      ),
    );
  }

  Widget _starRow({required int rating, required ValueChanged<int> onChanged}) {
    return Wrap(
      spacing: 18.w,
      children: List.generate(5, (index) {
        final filled = index < rating;
        return GestureDetector(
          onTap: () => onChanged(index + 1),
          child: Icon(
            filled ? Icons.star_rounded : Icons.star_border_rounded,
            color: const Color(0xFFD8A976),
            size: 42.sp,
          ),
        );
      }),
    );
  }
}
