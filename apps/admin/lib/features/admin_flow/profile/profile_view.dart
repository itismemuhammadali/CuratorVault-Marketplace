import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 520.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 250.h,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(22.w, 54.h, 22.w, 24.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.gradientColor1,
                            AppColors.gradientColor2,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(34.r),
                          bottomRight: Radius.circular(34.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor.withValues(
                              alpha: 0.18,
                            ),
                            blurRadius: 24,
                            spreadRadius: -12,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: AppColors.bodyBg.withValues(alpha: 0.22),
                                shape: BoxShape.circle,
                              ),
                              child: Center(

                                child: SvgPicture.asset(
                                  'assets/icons/arrow_back_icon.svg',
                                  width: 16.w,
                                  height: 16.w,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.darkText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'Profile',
                            style: TextStyles.boldLarge.copyWith(
                              color: AppColors.bodyBg,
                              fontSize: 28.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16.w,
                      right: 16.w,
                      top: 165.h,
                      child: _profileCard(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Business Information'),
                    SizedBox(height: 10.h),
                    _businessInfoCard(),
                    SizedBox(height: 14.h),
                    _reviewsHeader(),
                    SizedBox(height: 10.h),
                    ...List.generate(
                      3,
                      (_) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: _reviewCard(),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _sectionTitle('Settings'),
                    SizedBox(height: 10.h),
                    _settingsCard(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyles.boldMedium.copyWith(
        color: AppColors.lightText,
        fontSize: 20.sp,
      ),
    );
  }

  Widget _profileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.12),
            blurRadius: 18,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 84.w,
                height: 84.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gradientColor1, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(AppImages.userImg, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                right: -2.w,
                bottom: -2.h,
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: AppColors.gradientColor1,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bodyBg, width: 2),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(6.r),
                    child: SvgPicture.asset(
                      'assets/icons/camera_add_icon.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.bodyBg,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Antique Dealer Shop',
                style: TextStyles.boldMedium.copyWith(
                  color: AppColors.lightText,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(Icons.verified, color: const Color(0xFF3B82F6), size: 18.sp),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            '@antiquedealershop',
            style: TextStyles.regularMedium.copyWith(color: AppColors.greyText),
          ),
          SizedBox(height: 16.h),
          Row(
            children: const [
              Expanded(
                child: _MetricChip(
                  value: '48',
                  label: 'Sales',
                  bg: Color(0xFFE5EEF9),
                  valueColor: Color(0xFF2563EB),
                  labelColor: Color(0xFF2563EB),
                ),
              ),
              Expanded(
                child: _MetricChip(
                  value: '4.9 ★',
                  label: 'Rating',
                  bg: Color(0xFFFFF2D8),
                  valueColor: Color(0xFFF59E0B),
                  labelColor: Color(0xFFF59E0B),
                ),
              ),
              Expanded(
                child: _MetricChip(
                  value: '24',
                  label: 'Active',
                  bg: Color(0xFFE3F7E8),
                  valueColor: Color(0xFF16A34A),
                  labelColor: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          GestureDetector(
            onTap: () => context.push('/dealer/editprofile'),
            child: Container(
              width: double.infinity,
              height: 54.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.gradientColor1, AppColors.gradientColor2],
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: AppColors.bodyBg,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Edit Profile',
                    style: TextStyles.mediumMedium.copyWith(
                      color: AppColors.bodyBg,
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

  Widget _businessInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFDCE3EC)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.10),
            blurRadius: 16,
            spreadRadius: -10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _businessRow(
            icon: Icons.location_on_outlined,
            iconBg: const Color(0xFFD946EF),
            title: 'Location',
            value: 'New York, United States',
          ),
          SizedBox(height: 14.h),
          _businessRow(
            icon: Icons.phone_outlined,
            iconBg: const Color(0xFF10B981),
            title: 'Phone',
            value: '+1 (555) 123-4567',
          ),
          SizedBox(height: 14.h),
          _businessRow(
            icon: Icons.mail_outline,
            iconBg: const Color(0xFF4F79FF),
            title: 'Email',
            value: 'dealer@antiques.com',
          ),
        ],
      ),
    );
  }

  Widget _businessRow({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, size: 20.sp, color: AppColors.bodyBg),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.mediumMedium.copyWith(
                  color: iconBg,
                  fontSize: 17.sp,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                value,
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.lightText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _reviewsHeader() {
    return Row(
      children: [
        _sectionTitle('Reviews'),
        const Spacer(),
        Text(
          '3 reviews',
          style: TextStyles.regularMedium.copyWith(color: AppColors.greyText),
        ),
      ],
    );
  }

  Widget _reviewCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE6EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Sarah Martinez',
                style: TextStyles.mediumMedium.copyWith(
                  color: AppColors.lightText,
                ),
              ),
              const Spacer(),
              Text(
                '2 weeks ago',
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.greyText,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: List.generate(
              5,
              (_) => Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Icon(
                  Icons.star,
                  color: const Color(0xFFF59E0B),
                  size: 18.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Excellent seller! Item exactly as described.\nFast shipping.',
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.lightText,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Purchase: Victorian Chair',
            style: TextStyles.regularMedium.copyWith(color: AppColors.greyText),
          ),
        ],
      ),
    );
  }

  Widget _settingsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE6EAF0)),
      ),
      child: Column(
        children: [
          _settingsRow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Wallet',
            onTap: () => context.push('/dealer/wallet'),
          ),
          _settingsRow(
            icon: Icons.verified_user_outlined,
            label: 'Verification Status',
            onTap: () => context.push('/dealer/verification-status'),
          ),
          _settingsRow(
            icon: Icons.settings_outlined,
            label: 'App Settings',
            onTap: () => context.push('/dealer/app-settings'),
          ),
          _settingsRow(
            icon: Icons.logout,
            label: 'Sign Out',
            labelColor: AppColors.redButton,
            iconColor: AppColors.redButton,
            chevronColor: AppColors.redButton,
            onTap: () => context.go('/login'),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _settingsRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color labelColor = AppColors.lightText,
    Color iconColor = const Color(0xFF7B8797),
    Color chevronColor = const Color(0xFF9AA4B2),
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: const Color(0xFFE9EDF3), width: 1),
                ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: iconColor),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyles.mediumMedium.copyWith(color: labelColor),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20.sp, color: chevronColor),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.value,
    required this.label,
    required this.bg,
    required this.valueColor,
    required this.labelColor,
  });

  final String value;
  final String label;
  final Color bg;
  final Color valueColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyles.boldMedium.copyWith(
              color: valueColor,
              fontSize: 30.sp,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            label,
            style: TextStyles.regularMedium.copyWith(color: labelColor),
          ),
        ],
      ),
    );
  }
}
