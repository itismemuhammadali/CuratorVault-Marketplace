import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/global_footer/footer_config.dart';
import 'package:vintage_app/core/components/global_footer/global_footer.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AppSettingsView extends StatelessWidget {
  const AppSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          height: 170.h,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldSection.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Manage Account',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.semiBoldExtraSmall.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.88),
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: const GlobalFooter(flow: FooterFlow.admin),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 16.h),
        child: Column(
          children: [
            _profileCard(context),
            SizedBox(height: 10.h),
            _settingsTile(
              svgPath: 'assets/icons/admin_nav_users.svg',
              iconColor: const Color(0xFF4F79FF),
              iconBg: const Color(0xFFF0F5FF),
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () => context.push('/dealer/editprofile'),
            ),
            SizedBox(height: 7.h),
            _settingsTile(
              icon: Icons.lock_outline_rounded,
              iconColor: const Color(0xFFAF5CFF),
              iconBg: const Color(0xFFF9F0FF),
              title: 'Change Password',
              subtitle: 'Update your security credentials',
              onTap: () => context.push('/dealer/app-settings/change-password'),
            ),
            SizedBox(height: 7.h),
            _settingsTile(
              svgPath: 'assets/icons/wallet_icon.svg',
              iconColor: const Color(0xFF20B957),
              iconBg: const Color(0xFFEFFCF4),
              title: 'Payment Management',
              subtitle: 'Balance, cards & transactions',
              onTap: () => context.push('/dealer/wallet'),
            ),
            SizedBox(height: 7.h),
            _settingsTile(
              icon: Icons.inventory_2_outlined,
              iconColor: const Color(0xFF7A6CFF),
              iconBg: const Color(0xFFF1F1FF),
              title: 'Escrow Sales',
              subtitle: 'Manage platform transactions',
              onTap: () => context.push('/dealer/wallet/escrow-payments'),
            ),
            SizedBox(height: 7.h),
            _settingsTile(
              svgPath: 'assets/icons/settings_icon.svg',
              iconColor: const Color(0xFF22C55E),
              iconBg: const Color(0xFFEFFCF4),
              title: 'Settings',
              subtitle: 'App preferences and configurations',
              onTap: () => context.push('/dealer/app-settings/preferences'),
            ),

            SizedBox(height: 14.h),
            _signOutButton(context),
            SizedBox(height: 16.h),
            Text(
              'Vintage Vinnie Admin v1.0.0',
              style: TextStyles.mediumExtraSmall.copyWith(
                color: const Color(0xFF9199A8),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(11.w, 12.h, 11.w, 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFF),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFD8E1FF)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.asset(
                  AppImages.adminProfileImg,
                  width: 64.w,
                  height: 64.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin User',
                      style: TextStyles.boldSmall.copyWith(
                        color: const Color(0xFF344054),
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F79FF),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      child: Text(
                        'Super Admin',
                        style: TextStyles.semiBoldExtraSmall.copyWith(
                          color: AppColors.bodyBg,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _profileInfoLine(
                      icon: Icons.mail_outline_rounded,
                      text: 'admin@vintagevinnie.com',
                    ),
                    SizedBox(height: 4.h),
                    _profileInfoLine(
                      icon: Icons.phone_outlined,
                      text: '+1 (555) 000-0000',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(height: 1.h, color: const Color(0xFFD6E1FF)),
          Container(
            constraints: BoxConstraints(minHeight: 70.h),
            decoration: const BoxDecoration(color: Color(0x55FFFFFF)),
            child: Row(
              children: [
                Expanded(
                  child: _dateBlock(
                    icon: Icons.calendar_month_outlined,
                    label: 'Joined',
                    date: 'January 15, 2024',
                    time: 'Time: 10:45 AM',
                  ),
                ),
                Container(width: 1.w, height: 48.h, color: Colors.white),
                Expanded(
                  child: _dateBlock(
                    icon: Icons.shield_outlined,
                    label: 'Last Login',
                    date: 'January 30, 2026',
                    time: 'Time: 10:45 AM',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileInfoLine({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 13.sp, color: const Color(0xFF687281)),
        SizedBox(width: 7.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularExtraSmall.copyWith(
              color: const Color(0xFF687281),
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateBlock({
    required IconData icon,
    required String label,
    required String date,
    required String time,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(6.w, 10.h, 6.w, 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14.sp, color: const Color(0xFF4F79FF)),
          SizedBox(width: 6.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyles.boldExtraSmall.copyWith(
                    color: const Color(0xFF4F79FF),
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.mediumExtraSmall.copyWith(
                    color: const Color(0xFF344054),
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.boldExtraSmall.copyWith(
                    color: const Color(0xFF344054),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({

    IconData? icon,
    String? svgPath,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: AppColors.bodyBg,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          constraints: BoxConstraints(minHeight: 72.h),
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFE9EAED)),
          ),
          child: Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: svgPath != null
                    ? Padding(
                        padding: EdgeInsets.all(9.r),
                        child: SvgPicture.asset(
                          svgPath,
                          colorFilter: ColorFilter.mode(
                            iconColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      )
                    : Icon(icon, size: 19.sp, color: iconColor),
              ),

              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.boldSmall.copyWith(
                        color: const Color(0xFF344054),
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.regularExtraSmall.copyWith(
                        color: const Color(0xFF667085),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22.sp,
                color: const Color(0xFF9AA4B2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signOutButton(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/login'),
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        width: double.infinity,
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: const Color(0xFFFF4D5A)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              size: 14.sp,
              color: const Color(0xFFE02434),
            ),
            SizedBox(width: 10.w),
            Text(
              'Sign Out',
              style: TextStyles.semiBoldExtraSmall.copyWith(
                color: const Color(0xFFE02434),
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
