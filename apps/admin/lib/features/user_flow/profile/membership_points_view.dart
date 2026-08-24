import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class MembershipPointsView extends StatelessWidget {
  const MembershipPointsView({super.key});

  @override
  Widget build(BuildContext context) {
    const tiers = [
      _MembershipTier(
        title: 'Bronze',
        points: '0-999 points',
        benefits: [
          'Basic AI Recognition',
          'Community Access',
          'Standard Support',
        ],
      ),
      _MembershipTier(
        title: 'Silver',
        points: '1,000-2,499 points',
        benefits: [
          'All Bronze benefits',
          'Advanced AI Features',
          'Priority Support',
          '5% Marketplace Discount',
        ],
        isMuted: true,
      ),
      _MembershipTier(
        title: 'Gold',
        points: '2,500+ points',
        benefits: [
          'All Silver benefits',
          'Expert Authentication',
          'VIP Support',
          '10% Marketplace Discount',
          'Exclusive Events',
        ],
        isCurrent: true,
      ),
    ];

    const rewards = [
      _RewardItem(
        title: '\$5 Market Credit',
        points: '500 points',
        iconAsset: AppImages.giftBoxIcon,
      ),
      _RewardItem(
        title: '\$10 Market Credit',
        points: '1000 points',
        iconAsset: AppImages.giftBoxIcon,
      ),
      _RewardItem(
        title: 'Free Premium Scan',
        points: '750 points',
        iconAsset: AppImages.lightningIcon,
      ),
      _RewardItem(
        title: '\$25 Market Credit',
        points: '2500 points',
        iconAsset: AppImages.giftBoxIcon,
        isLocked: true,
      ),
    ];

    const earnPoints = [
      _PointRule(label: 'Scan an antique', value: '+10 pts'),
      _PointRule(label: 'Complete a purchase', value: '+50 pts'),
      _PointRule(label: 'Receive 5-star review', value: '+25 pts'),
      _PointRule(label: 'Daily login', value: '+5 pts'),
    ];

    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
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
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _currentTierCard(),
              SizedBox(height: 18.h),
              _sectionTitle('Membership Tiers'),
              SizedBox(height: 12.h),
              ...tiers.map(
                (tier) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _tierCard(tier),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _sectionTitle('Available Rewards'),
                  const Spacer(),
                  Image.asset(
                    AppImages.lineGraphIcon,
                    width: 16.w,
                    height: 16.h,
                    color: AppColors.redButton,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ...rewards.map(
                (reward) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _rewardCard(reward),
                ),
              ),
              SizedBox(height: 4.h),
              _howToEarnCard(earnPoints),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currentTierCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDCAF74), Color(0xFFCA9B63)],
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.12),
            blurRadius: 24.r,
            spreadRadius: -12,
            offset: Offset(0, 14.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 6.w,
            top: 0,
            child: Opacity(
              opacity: 0.18,
              child: Image.asset(
                AppImages.crownIcon,
                width: 104.w,
                height: 104.w,
                color: AppColors.bodyBg,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.bodyBg.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Current Tier',
                  style: TextStyles.mediumSmall.copyWith(
                    color: AppColors.bodyBg,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Gold Member',
                style: TextStyles.boldLarge.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 30.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '2,341 Points',
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.bodyBg,
                ),
              ),
              SizedBox(height: 18.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(999.r),
                child: LinearProgressIndicator(
                  value: 0.56,
                  minHeight: 8.h,
                  backgroundColor: AppColors.bodyBg.withValues(alpha: 0.35),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.bodyBg,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                '659 to next reward',
                style: TextStyles.mediumSmall.copyWith(
                  color: AppColors.bodyBg,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyles.boldMedium.copyWith(
        color: AppColors.lightText,
        fontSize: 22.sp,
      ),
    );
  }

  Widget _tierCard(_MembershipTier tier) {
    final isCurrent = tier.isCurrent;
    final isMuted = tier.isMuted;
    final accentColor = isCurrent
        ? const Color(0xFFE2A56F)
        : AppColors.shadowColor.withValues(alpha: 0.08);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 18.r,
            spreadRadius: -14,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: isCurrent ? 3.w : 1.w,
                color: accentColor,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.bodyBg,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42.w,
                            height: 42.w,
                            decoration: BoxDecoration(
                              color: isMuted
                                  ? const Color(0xFFF4F4F4)
                                  : const Color(0xFFFCEFEB),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Image.asset(
                                AppImages.crownIcon,
                                width: 20.w,
                                height: 20.w,
                                color: isMuted
                                    ? const Color(0xFFC3C8D1)
                                    : const Color(0xFFD59143),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tier.title,
                                  style: TextStyles.boldMedium.copyWith(
                                    color: isMuted
                                        ? const Color(0xFF4B5667)
                                        : AppColors.lightText,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  tier.points,
                                  style: TextStyles.regularMedium.copyWith(
                                    color: const Color(0xFF8993A4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isCurrent)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD6A36C),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'Current',
                                style: TextStyles.mediumSmall.copyWith(
                                  color: AppColors.bodyBg,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      ...tier.benefits.map(
                        (benefit) => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 2.h),
                                child: Image.asset(
                                  AppImages.rewardBadgeIcon,
                                  width: 14.w,
                                  height: 14.w,
                                  color: isMuted
                                      ? const Color(0xFFC3C8D1)
                                      : const Color(0xFFD59143),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: TextStyles.regularMedium.copyWith(
                                    color: const Color(0xFF647083),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rewardCard(_RewardItem reward) {
    final isLocked = reward.isLocked;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.shadowColor.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: isLocked ? const Color(0xFFF4F4F4) : const Color(0xFFFCEFEB),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: Image.asset(
                reward.iconAsset,
                width: 24.w,
                height: 24.w,
                color: isLocked ? const Color(0xFFC3C8D1) : AppColors.redButton,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: TextStyles.boldMedium.copyWith(
                    color: isLocked ? const Color(0xFFA7AFBC) : AppColors.lightText,
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  reward.points,
                  style: TextStyles.regularMedium.copyWith(
                    color: isLocked ? const Color(0xFFA7AFBC) : const Color(0xFF667287),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isLocked ? const Color(0xFFF1F1F1) : AppColors.redButton,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Text(
              isLocked ? 'Locked' : 'Redeem',
              style: TextStyles.mediumMedium.copyWith(
                color: isLocked ? const Color(0xFFC3C8D1) : AppColors.bodyBg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _howToEarnCard(List<_PointRule> items) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6EB),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppImages.rewardBadgeIcon,
                color: AppColors.redButton,
                width: 22.w,
                height: 22.w,
              ),
              SizedBox(width: 10.w),
              Text(
                'How to Earn Points',
                style: TextStyles.boldMedium.copyWith(
                  color: AppColors.lightText,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.lightText,
                      ),
                    ),
                  ),
                  Text(
                    item.value,
                    style: TextStyles.mediumMedium.copyWith(
                      color: AppColors.redButton,
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

class _MembershipTier {
  const _MembershipTier({
    required this.title,
    required this.points,
    required this.benefits,
    this.isCurrent = false,
    this.isMuted = false,
  });

  final String title;
  final String points;
  final List<String> benefits;
  final bool isCurrent;
  final bool isMuted;
}

class _RewardItem {
  const _RewardItem({
    required this.title,
    required this.points,
    required this.iconAsset,
    this.isLocked = false,
  });

  final String title;
  final String points;
  final String iconAsset;
  final bool isLocked;
}

class _PointRule {
  const _PointRule({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
