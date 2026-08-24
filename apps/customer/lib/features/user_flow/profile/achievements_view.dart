import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AchievementsView extends StatelessWidget {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      _AchievementEntry(
        title: 'First Scan',
        subtitle: 'Scanned your first antique',
        statusText: 'Unlocked on Dec 1, 2024',
        reward: '+50',
        icon: Icons.emoji_events_outlined,
      ),
      _AchievementEntry(
        title: 'Collector',
        subtitle: 'Added 10 items to collection',
        statusText: 'Unlocked on Dec 5, 2024',
        reward: '+100',
        icon: Icons.workspace_premium_outlined,
      ),
      _AchievementEntry(
        title: 'Expert Eye',
        subtitle: 'Identified 25 rare antiques',
        statusText: 'Unlocked on Dec 10, 2024',
        reward: '+200',
        svgPath: 'assets/icons/mark_icon.svg',
        useCustomColor: true,
        customColor: Color(0xFFD4A574),
      ),
      _AchievementEntry(
        title: 'Five Star',
        subtitle: 'Received 5-star rating from seller',
        statusText: 'Unlocked on Dec 12, 2024',
        reward: '+150',
        icon: Icons.star_border_rounded,
        useCustomColor: true,
        customColor: Color(0xFFD4A574),
      ),
      _AchievementEntry(
        title: 'Speed Scanner',
        subtitle: 'Scan 50 items in one day',
        statusText: 'Unlocked on Dec 14, 2024',
        reward: '+250',
        svgPath: 'assets/icons/lightning_icon.svg',
        useCustomColor: true,
        customColor: Color(0xFFD4A574),
      ),
      _AchievementEntry(
        title: 'Gold Member',
        subtitle: 'Reached Gold membership tier',
        statusText: 'Unlocked on Dec 15, 2024',
        reward: '+500',
        svgPath: 'assets/icons/crown_icon.svg',
        useCustomColor: true,
        customColor: Color(0xFFD4A574),
      ),
      _AchievementEntry(
        title: 'Master Collector',
        subtitle: 'Collection worth over \$10,000',
        statusText: 'Locked',
        reward: '+1000',
        svgPath: 'assets/icons/lock_icon.svg',
        isLocked: true,
      ),
      _AchievementEntry(
        title: 'Community Star',
        subtitle: 'Get 100 likes on posts',
        statusText: 'Locked',
        reward: '+300',
        svgPath: 'assets/icons/lock_icon.svg',
        isLocked: true,
      ),
    ];

    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Achievements',
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
              _summaryCard(),
              SizedBox(height: 18.h),
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
                      horizontal: 12.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.redButton,
                      borderRadius: BorderRadius.circular(10.r),
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
              SizedBox(height: 12.h),
              ...achievements.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _achievementCard(entry),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.redButton, Color(0xFFC95D47)],
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.12),
            blurRadius: 22.r,
            spreadRadius: -12,
            offset: Offset(0, 14.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achievements Unlocked',
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.bodyBg,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '6/8',
                  style: TextStyles.boldLarge.copyWith(
                    color: AppColors.bodyBg,
                    fontSize: 38.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Total Points: 1250',
                  style: TextStyles.mediumMedium.copyWith(
                    color: AppColors.bodyBg,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 92.w,
            height: 92.w,
            decoration: BoxDecoration(
              color: AppColors.bodyBg.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events_outlined,
              size: 44.sp,
              color: AppColors.bodyBg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _achievementCard(_AchievementEntry entry) {
    final isLocked = entry.isLocked;
    final useCustomColor = entry.useCustomColor && !isLocked;
    final customColor = entry.customColor ?? AppColors.redButton;
    
    final iconBg = isLocked 
        ? const Color(0xFFF3F3F3) 
        : useCustomColor
            ? customColor.withValues(alpha: 0.08)
            : const Color(0xFFFCEFEB);
    
    final iconColor = isLocked 
        ? const Color(0xFFB8C0CC) 
        : useCustomColor
            ? customColor
            : AppColors.redButton;
    
    final titleColor = isLocked ? const Color(0xFF97A0AE) : AppColors.lightText;
    final subtitleColor = isLocked
        ? const Color(0xFF2D3E55)
        : AppColors.lightText.withValues(alpha: 0.88);
    final statusColor = isLocked
        ? const Color(0xFF97A0AE)
        : useCustomColor
            ? customColor.withValues(alpha: 0.75)
            : const Color(0xFFD48D5E);
    
    final rewardBg = isLocked 
        ? const Color(0xFFF1F1F1) 
        : useCustomColor
            ? customColor.withValues(alpha: 0.08)
            : const Color(0xFFFCEFEB);
    
    final rewardColor = isLocked 
        ? const Color(0xFFB8C0CC) 
        : useCustomColor
            ? customColor
            : AppColors.redButton;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.shadowColor.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.08),
            blurRadius: 18.r,
            spreadRadius: -12,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: entry.svgPath != null
                  ? SvgPicture.asset(
                      entry.svgPath!,
                      width: 24.sp,
                      height: 24.sp,
                      colorFilter: ColorFilter.mode(
                        iconColor,
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(
                      entry.icon,
                      size: 24.sp,
                      color: iconColor,
                    ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        entry.title,
                        style: TextStyles.boldMedium.copyWith(
                          color: titleColor,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: rewardBg,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        entry.reward,
                        style: TextStyles.mediumMedium.copyWith(
                          color: rewardColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  entry.subtitle,
                  style: TextStyles.regularMedium.copyWith(
                    color: subtitleColor,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  entry.statusText,
                  style: TextStyles.regularSmall.copyWith(
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementEntry {
  const _AchievementEntry({
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.reward,
    this.icon,
    this.svgPath,
    this.useCustomColor = false,
    this.customColor,
    this.isLocked = false,
  });

  final String title;
  final String subtitle;
  final String statusText;
  final String reward;
  final IconData? icon;
  final String? svgPath;
  final bool useCustomColor;
  final Color? customColor;
  final bool isLocked;
}
