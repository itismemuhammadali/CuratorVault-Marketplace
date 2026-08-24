import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class MembershipRewardsView extends StatelessWidget {
  const MembershipRewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF8E8C7).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: const Color(0xFFF8E8C7),
                  size: 20.sp,
                ),
              ),
            ),
          ),
          title: Text(
            'Membership & Rewards',
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
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Membership Tier Card
              _currentTierCard(),
              SizedBox(height: 20.h),
              // Membership Tiers Section
              Text(
                'Membership Tiers',
                style: TextStyles.boldLarge.copyWith(
                  color: AppColors.lightText,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 14.h),
              _tierCard(
                icon: Icons.shield_outlined,
                title: 'Bronze',
                points: '0-999 points',
                benefits: [
                  'Basic AI Recognition',
                  'Community Access',
                  'Standard Support',
                ],
                backgroundColor: const Color(0xFFC97A6D),
              ),
              SizedBox(height: 12.h),
              _tierCard(
                icon: Icons.shield_outlined,
                title: 'Silver',
                points: '1,000-2,499 points',
                benefits: [
                  'All Bronze benefits',
                  'Advanced AI Features',
                  'Priority Support',
                  '5% Marketplace Discount',
                ],
                backgroundColor: const Color(0xFFC0C0C0),
              ),
              SizedBox(height: 12.h),
              _tierCard(
                icon: Icons.shield_outlined,
                title: 'Gold',
                points: '2,500+ points',
                benefits: [
                  'All Silver benefits',
                  'Expert Authentication',
                  'VIP Support',
                  '10% Marketplace Discount',
                  'Exclusive Events',
                ],
                backgroundColor: const Color(0xFFD4AF37),
                isCurrentTier: true,
              ),
              SizedBox(height: 24.h),
              // Available Rewards Section
              Row(
                children: [
                  Text(
                    'Available Rewards',
                    style: TextStyles.boldLarge.copyWith(
                      color: AppColors.lightText,
                      fontSize: 20.sp,
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/icons/growth_icon.svg',
                    width: 28.sp,
                    height: 28.sp,
                    colorFilter: const ColorFilter.mode(
                      AppColors.redButton,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              _rewardCard(
                icon: 'gift',
                title: '\$5 Market Credit',
                points: '500 points',
                buttonLabel: 'Redeem',
                isAvailable: true,
              ),
              SizedBox(height: 12.h),
              _rewardCard(
                icon: 'gift',
                title: '\$10 Market Credit',
                points: '1000 points',
                buttonLabel: 'Redeem',
                isAvailable: true,
              ),
              SizedBox(height: 12.h),
              _rewardCard(
                icon: 'lightning',
                title: 'Free Premium Scan',
                points: '750 points',
                buttonLabel: 'Redeem',
                isAvailable: true,
              ),
              SizedBox(height: 12.h),
              _rewardCard(
                icon: 'gift',
                title: '\$25 Market Credit',
                points: '2500 points',
                buttonLabel: 'Locked',
                isAvailable: false,
              ),
              SizedBox(height: 24.h),
              // How to Earn Points Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A574).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/reward_icon.svg',
                          width: 24.sp,
                          height: 24.sp,
                          colorFilter: const ColorFilter.mode(
                            AppColors.redButton,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'How to Earn Points',
                          style: TextStyles.boldLarge.copyWith(
                            color: AppColors.lightText,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _earnPointsItem('Scan an antique', '+10 pts'),
                    SizedBox(height: 12.h),
                    _earnPointsItem('Complete a purchase', '+50 pts'),
                    SizedBox(height: 12.h),
                    _earnPointsItem('Receive 5-star review', '+25 pts'),
                    SizedBox(height: 12.h),
                    _earnPointsItem('Daily login', '+5 pts'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currentTierCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD4A574), Color(0xFFC09461)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4A574).withValues(alpha: 0.20),
            blurRadius: 20,
            spreadRadius: -8,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background crown icon
          Positioned(
            right: -20.w + 15.w,
            top: -20.h + 10.h + 5.h,
            child: SvgPicture.asset(
              'assets/icons/crown_icon.svg',
              width: 100.sp,
              height: 100.sp,
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: 0.15),
                BlendMode.srcIn,
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Current Tier',
                  style: TextStyles.regularSmall.copyWith(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Gold Member',
                style: TextStyles.boldLarge.copyWith(
                  color: Colors.white,
                  fontSize: 26.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '2,341 Points',
                style: TextStyles.regularMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        height: 8.h,
                        color: Colors.white24,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.65,
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    '659 to next reward',
                    style: TextStyles.regularSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tierCard({
    required IconData icon,
    required String title,
    required String points,
    required List<String> benefits,
    required Color backgroundColor,
    bool isCurrentTier = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(20.r),
        border: isCurrentTier
            ? Border(
                left: BorderSide(color: backgroundColor, width: 4.w),
              )
            : Border.all(color: AppColors.greyText.withValues(alpha: 0.08)),
      ),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: backgroundColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/crown_icon.svg',
                        width: 28.sp,
                        height: 28.sp,
                        colorFilter: ColorFilter.mode(
                          backgroundColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: TextStyles.boldLarge.copyWith(
                                color: AppColors.lightText,
                                fontSize: 22.sp,
                              ),
                            ),
                            if (isCurrentTier) ...[
                              SizedBox(width: 12.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  'Current',
                                  style: TextStyles.regularSmall.copyWith(
                                    color: AppColors.bodyBg,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          points,
                          style: TextStyles.regularMedium.copyWith(
                            color: AppColors.greyText,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ...benefits.asMap().entries.map((entry) {
                final isLast = entry.key == benefits.length - 1;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : 12.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_outline_rounded,
                        size: 20.sp,
                        color: backgroundColor.withValues(alpha: 0.6),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyles.regularMedium.copyWith(
                            color: AppColors.lightText,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
    );
  }

  Widget _rewardCard({
    required String icon,
    required String title,
    required String points,
    required String buttonLabel,
    required bool isAvailable,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.greyText.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: isAvailable
                  ? const Color(0xFFFFE8E0)
                  : AppColors.lightText.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: icon == 'gift'
                  ? SvgPicture.asset(
                      'assets/icons/gift_icon.svg',
                      width: 24.sp,
                      height: 24.sp,
                      colorFilter: ColorFilter.mode(
                        isAvailable ? const Color(0xFFC65A46) : AppColors.greyText.withValues(alpha: 0.4),
                        BlendMode.srcIn,
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/icons/lightning_icon.svg',
                      width: 24.sp,
                      height: 24.sp,
                      colorFilter: ColorFilter.mode(
                        isAvailable ? const Color(0xFFC65A46) : AppColors.greyText.withValues(alpha: 0.4),
                        BlendMode.srcIn,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.boldMedium.copyWith(
                    color: isAvailable ? AppColors.lightText : AppColors.greyText.withValues(alpha: 0.5),
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  points,
                  style: TextStyles.regularSmall.copyWith(
                    color: AppColors.greyText,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: isAvailable
                  ? AppColors.redButton
                  : AppColors.lightText.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              buttonLabel,
              style: TextStyles.mediumMedium.copyWith(
                color: isAvailable ? AppColors.bodyBg : AppColors.greyText,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _earnPointsItem(String activity, String points) {
    return Row(
      children: [
        Expanded(
          child: Text(
            activity,
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.lightText,
              fontSize: 14.sp,
            ),
          ),
        ),
        Text(
          points,
          style: TextStyles.boldMedium.copyWith(
            color: AppColors.redButton,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
