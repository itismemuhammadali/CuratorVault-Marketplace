import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';

import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

enum _ReviewTab { received, given }

class ReviewsRatingsView extends StatefulWidget {
  const ReviewsRatingsView({super.key});

  @override
  State<ReviewsRatingsView> createState() => _ReviewsRatingsViewState();
}

class _ReviewsRatingsViewState extends State<ReviewsRatingsView> {
  _ReviewTab _selectedTab = _ReviewTab.received;

  @override
  Widget build(BuildContext context) {
    final receivedReviews = List.generate(5, (index) {
      return _ReviewItem(
        name: [
          'Emma Wilson',
          'Noah Carter',
          'Sophia Brooks',
          'Liam Foster',
          'Olivia Reed',
        ][index],
        date: [
          'Dec 15, 2024',
          'Dec 10, 2024',
          'Dec 4, 2024',
          'Nov 29, 2024',
          'Nov 18, 2024',
        ][index],
        message: [
          'Amazing seller! Item was exactly as described. Fast shipping and great communication.',
          'Beautiful antique and super smooth transaction. Would absolutely buy again.',
          'Packaging was excellent and the product arrived in wonderful condition.',
          'Professional seller and very responsive throughout the process.',
          'Great overall experience. Everything matched the listing perfectly.',
        ][index],
        rating: [5, 5, 4, 5, 5][index],
        tag: [
          'Victorian Pocket Watch',
          'Art Deco Lamp',
          'Vintage Camera',
          'Ming Vase',
          'Art Deco Necklace',
        ][index],
        helpfulCount: ['12 helpful', '9 helpful', '5 helpful', '6 helpful', '11 helpful'][index],
      );
    });

    final givenReviews = List.generate(2, (index) {
      return _ReviewItem(
        name: ['Heritage Antiques', 'Classic Collectibles'][index],
        date: ['Dec 12, 2024', 'Nov 30, 2024'][index],
        message: [
          'Loved the quality and authenticity. The seller was polite and shipping was quick.',
          'Really happy with the purchase. Item condition was great and packaging was secure.',
        ][index],
        rating: [5, 4][index],
        tag: ['You rated 5 stars', 'You rated 4 stars'][index],
        helpfulCount: ['Posted review', 'Posted review'][index],
      );
    });

    final activeReviews = _selectedTab == _ReviewTab.received
        ? receivedReviews
        : givenReviews;

    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Reviews & Ratings',
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
            children: [
              _ratingSummaryCard(),
              SizedBox(height: 16.h),
              _tabBar(),
              SizedBox(height: 16.h),
              ...activeReviews.map(
                (review) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _reviewCard(review),
                ),
              ),
              _tipsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.shadowColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 18.r,
            spreadRadius: -12,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '4.9',
                      style: TextStyles.boldLarge.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 56.sp,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: Icon(
                            Icons.star_rounded,
                            color: const Color(0xFFD7A169),
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '24\nreviews',
                      textAlign: TextAlign.center,
                      style: TextStyles.regularMedium.copyWith(
                        color: const Color(0xFF98A1B0),
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: Column(
                  children: const [
                    _RatingBarRow(star: '5', count: '22', fill: 0.92),
                    _RatingBarRow(star: '4', count: '2', fill: 0.27),
                    _RatingBarRow(star: '3', count: '0', fill: 0.18),
                    _RatingBarRow(star: '2', count: '0', fill: 0.18),
                    _RatingBarRow(star: '1', count: '0', fill: 0.18),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            height: 1,
            color: AppColors.shadowColor.withValues(alpha: 0.10),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: const Color(0xFF4ADE80),
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Rating improved by ',
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.gradientColor1,
                      ),
                    ),
                    TextSpan(
                      text: '12%',
                      style: TextStyles.regularMedium.copyWith(
                        color: const Color(0xFF4ADE80),
                      ),
                    ),
                    TextSpan(
                      text: ' this month',
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.gradientColor1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Row(
      children: [
        Expanded(
          child: _tabButton(
            label: 'Received (5)',
            isSelected: _selectedTab == _ReviewTab.received,
            onTap: () {
              setState(() => _selectedTab = _ReviewTab.received);
            },
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _tabButton(
            label: 'Given (2)',
            isSelected: _selectedTab == _ReviewTab.given,
            onTap: () {
              setState(() => _selectedTab = _ReviewTab.given);
            },
          ),
        ),
      ],
    );
  }

  Widget _tabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.redButton : AppColors.bodyBg,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: isSelected ? 0.10 : 0.06),
              blurRadius: 18.r,
              spreadRadius: -12,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.mediumMedium.copyWith(
              color: isSelected ? AppColors.bodyBg : AppColors.gradientColor1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewCard(_ReviewItem review) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.08),
            blurRadius: 18.r,
            spreadRadius: -12,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.asset(
                  AppImages.userImg,
                  width: 48.w,
                  height: 48.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 17.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      review.date,
                      style: TextStyles.regularMedium.copyWith(
                        color: const Color(0xFF98A1B0),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: Icon(
                      Icons.star_rounded,
                      color: index < review.rating 
                        ? const Color(0xFFD7A169)
                        : const Color(0xFFE8E8E8),
                      size: 17.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            review.message,
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.gradientColor1,
              height: 1.55,
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            height: 1,
            color: AppColors.shadowColor.withValues(alpha: 0.10),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5EB),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  review.tag,
                  style: TextStyles.regularSmall.copyWith(
                    color: const Color(0xFFD7A169),
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.thumb_up_alt_outlined,
                color: const Color(0xFF98A1B0),
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                review.helpfulCount,
                style: TextStyles.regularSmall.copyWith(
                  color: const Color(0xFF98A1B0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tipsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFD4A574).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFD4A574).withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/admin_nav_messages.svg',
                width: 20.sp,
                height: 20.sp,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFC65A46),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Tips for Better Reviews',
                style: TextStyles.boldMedium.copyWith(
                  color: const Color(0xFF2D3E55),
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tipBullet('Respond promptly to buyer messages'),
              SizedBox(height: 8.h),
              _tipBullet('Package items carefully and securely'),
              SizedBox(height: 8.h),
              _tipBullet('Provide accurate item descriptions'),
              SizedBox(height: 8.h),
              _tipBullet('Ship items within 2 business days'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tipBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: TextStyles.regularMedium.copyWith(
            color: AppColors.gradientColor1,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.gradientColor1,
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingBarRow extends StatelessWidget {
  const _RatingBarRow({
    required this.star,
    required this.count,
    required this.fill,
  });

  final String star;
  final String count;
  final double fill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 10.w,
            child: Text(
              star,
              style: TextStyles.regularSmall.copyWith(
                color: AppColors.gradientColor1,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.star_rounded,
            color: const Color(0xFFD7A169),
            size: 14.sp,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999.r),
              child: Container(
                height: 8.h,
                color: const Color(0xFFF2E7DA),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: fill,
                    child: Container(
                      color: const Color(0xFFD7A169),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 24.w,
            child: Text(
              count,
              style: TextStyles.regularSmall.copyWith(
                color: const Color(0xFF98A1B0),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem {
  const _ReviewItem({
    required this.name,
    required this.date,
    required this.message,
    required this.rating,
    required this.tag,
    required this.helpfulCount,
  });

  final String name;
  final String date;
  final String message;
  final int rating;
  final String tag;
  final String helpfulCount;
}
