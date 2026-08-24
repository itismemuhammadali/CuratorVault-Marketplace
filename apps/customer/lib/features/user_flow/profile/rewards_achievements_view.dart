import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class RewardsAchievementsView extends StatelessWidget {
  const RewardsAchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    const achievements = [
      _AchievementItem(
        title: 'First Find',
        subtitle: 'Successfully identified your first antique',
        reward: '+100',
        icon: Icons.emoji_events_outlined,
      ),
      _AchievementItem(
        title: 'Collector Level 5',
        subtitle: 'Reached level 5 in your collecting journey',
        reward: '+250',
        icon: Icons.star_border_rounded,
      ),
      _AchievementItem(
        title: 'Marketplace Maven',
        subtitle: 'Complete 10 marketplace purchases',
        reward: '+500',
        icon: Icons.workspace_premium_outlined,
      ),
      _AchievementItem(
        title: 'Treasure Hunter',
        subtitle: 'Find 50 unique antiques (38/50)',
        icon: Icons.gps_fixed,
        progress: 0.76,
      ),
      _AchievementItem(
        title: 'Speed Scanner',
        subtitle: 'Scan 100 items in a week (65/100)',
        icon: Icons.bolt_outlined,
        progress: 0.65,
        progressText: '65%',
      ),
      _AchievementItem(
        title: 'Gold Collector',
        subtitle: 'Reach Gold tier status',
        reward: '+1000',
        icon: Icons.workspace_premium_outlined,
      ),
    ];

    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Rewards & Achievement',
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
              _pointsCard(),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Text(
                    'Achievements',
                    style: TextStyles.boldLarge.copyWith(
                      color: AppColors.lightText,
                      fontSize: 22.sp,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.redButton,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '6/12 Completed',
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.bodyBg,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              ...achievements.map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _achievementCard(item),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pointsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientColor1, AppColors.gradientColor2],
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.18),
            blurRadius: 24,
            spreadRadius: -12,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25.w,
            top: -35.h,
            child: Icon(
              Icons.emoji_events_outlined,
              size: 200.sp,
              color: AppColors.bodyBg.withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.bodyBg.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/crown_icon.svg',
                        width: 44.sp,
                        height: 44.sp,
                        colorFilter: ColorFilter.mode(
                          AppColors.darkText,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Points',
                        style: TextStyles.regularMedium.copyWith(
                          color: AppColors.darkText,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '2,341',
                        style: TextStyles.boldLarge.copyWith(
                          color: AppColors.bodyBg,
                          fontSize: 38.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Container(
                height: 1,
                color: AppColors.darkText.withValues(alpha: 0.75),
              ),
              SizedBox(height: 18.h),
              Row(
                children: const [
                  Expanded(
                    child: _StatInfo(
                      value: '12',
                      label: 'Achievements',
                    ),
                  ),
                  Expanded(
                    child: _StatInfo(
                      value: 'Gold',
                      label: 'Tier',
                    ),
                  ),
                  Expanded(
                    child: _StatInfo(
                      value: '#3',
                      label: 'Rank',
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

  Widget _achievementCard(_AchievementItem item) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.10),
            blurRadius: 18,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFDECE7),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Center(
              child: item.title == 'Gold Collector'
                  ? SvgPicture.asset(
                      'assets/icons/crown_icon.svg',
                      width: 30.sp,
                      height: 30.sp,
                      colorFilter: const ColorFilter.mode(
                        AppColors.redButton,
                        BlendMode.srcIn,
                      ),
                    )
                  : item.title == 'Treasure Hunter'
                      ? SvgPicture.asset(
                          'assets/icons/mark_icon.svg',
                          width: 30.sp,
                          height: 30.sp,
                          colorFilter: const ColorFilter.mode(
                            AppColors.redButton,
                            BlendMode.srcIn,
                          ),
                        )
                      : item.title == 'Speed Scanner'
                          ? SvgPicture.asset(
                              'assets/icons/lightning_icon.svg',
                              width: 30.sp,
                              height: 30.sp,
                              colorFilter: const ColorFilter.mode(
                                AppColors.redButton,
                                BlendMode.srcIn,
                              ),
                            )
                          : Icon(
                              item.icon,
                              color: AppColors.redButton,
                              size: 30.sp,
                            ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyles.boldMedium.copyWith(
                          color: AppColors.lightText,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    if (item.reward != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.redButton,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          item.reward!,
                          style: TextStyles.mediumMedium.copyWith(
                            color: AppColors.bodyBg,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  item.subtitle,
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.greyText,
                    height: 1.45,
                  ),
                ),
                if (item.progress != null) ...[
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Text(
                        'Progress',
                        style: TextStyles.regularMedium.copyWith(
                          color: AppColors.lightText,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item.progressText ??
                            '${(item.progress! * 100).round()}%',
                        style: TextStyles.regularMedium.copyWith(
                          color: item.progressText == null
                              ? AppColors.lightText
                              : AppColors.redButton,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999.r),
                    child: Container(
                      height: 8.h,
                      color: AppColors.lightText.withValues(alpha: 0.16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: item.progress,
                          child: Container(
                            color: AppColors.lightText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatInfo extends StatelessWidget {
  const _StatInfo({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyles.boldLarge.copyWith(
            color: AppColors.bodyBg,
            fontSize: 24.sp,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyles.regularMedium.copyWith(
            color: AppColors.darkText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AchievementItem {
  const _AchievementItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.reward,
    this.progress,
    this.progressText,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? reward;
  final double? progress;
  final String? progressText;
}
