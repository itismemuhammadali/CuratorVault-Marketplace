import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _darkMode = false;
  bool _autoplayVideos = false;
  bool _voiceControl = false;
  bool _biometricAuth = true;

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
            'Settings',
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
              // Notifications Section
              _sectionTitle('Notifications'),
              SizedBox(height: 12.h),
              _sectionCard([
                _settingItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Push Notifications',
                  subtitle: 'Receive push notifications for updates',
                  value: _pushNotifications,
                  onChanged: (value) => setState(() => _pushNotifications = value),
                ),
                _divider(),
                _settingItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Email Notifications',
                  subtitle: 'Receive email updates',
                  value: _emailNotifications,
                  onChanged: (value) => setState(() => _emailNotifications = value),
                ),
              ]),
              SizedBox(height: 20.h),
              // Appearance Section
              _sectionTitle('Appearance'),
              SizedBox(height: 12.h),
              _sectionCard([
                _settingItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme throughout the app',
                  value: _darkMode,
                  onChanged: (value) => setState(() => _darkMode = value),
                ),
                _divider(),
                _settingItem(
                  icon: null,
                  svgPath: 'assets/icons/voice_icon.svg',
                  title: 'Auto-play Videos',
                  subtitle: 'Automatically play videos in feed',
                  value: _autoplayVideos,
                  onChanged: (value) => setState(() => _autoplayVideos = value),
                ),
              ]),
              SizedBox(height: 20.h),
              // Accessibility Section
              _sectionTitle('Accessibility'),
              SizedBox(height: 12.h),
              _sectionCard([
                _settingItem(
                  icon: null,
                  svgPath: 'assets/icons/voice_icon.svg',
                  title: 'Voice Control',
                  subtitle: 'Control app with voice commands',
                  value: _voiceControl,
                  onChanged: (value) => setState(() => _voiceControl = value),
                ),
              ]),
              SizedBox(height: 20.h),
              // Security Section
              _sectionTitle('Security'),
              SizedBox(height: 12.h),
              _sectionCard([
                _settingItem(
                  icon: null,
                  svgPath: 'assets/icons/shield_protection_icon.svg',
                  title: 'Biometric Authentication',
                  subtitle: 'Use fingerprint or face ID',
                  value: _biometricAuth,
                  onChanged: (value) => setState(() => _biometricAuth = value),
                ),
              ]),
              SizedBox(height: 20.h),
              // Language Section
              _sectionTitle('Language'),
              SizedBox(height: 12.h),
              _sectionCard([
                _settingItemWithValue(
                  icon: Icons.language_rounded,
                  title: 'App Language',
                  subtitle: 'English (US)',
                  valueText: 'Change',
                  onTap: () {},
                ),
              ]),
              SizedBox(height: 20.h),
              // Privacy & Data Section
              _sectionTitle('Privacy & Data'),
              SizedBox(height: 12.h),
              _sectionCard([
                _settingItemTile(
                  icon: Icons.visibility_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'View our privacy policy',
                  onTap: () {},
                ),
                _divider(),
                _settingItemTile(
                  icon: null,
                  svgPath: 'assets/icons/shield_protection_icon.svg',
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                  onTap: () => context.push('/user/privacy-terms'),
                ),
                _divider(),
                _settingItemTileDestructive(
                  svgPath: 'assets/icons/delete_icon.svg',
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  onTap: () {},
                ),
              ]),
              SizedBox(height: 20.h),
              // Version
              Center(
                child: Column(
                  children: [
                    Text(
                      'Vintage Vibers',
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.lightText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Version 1.0.0',
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
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
        fontSize: 16.sp,
      ),
    );
  }

  Widget _sectionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFFF5E6D3),
      indent: 0,
      endIndent: 0,
    );
  }

  Widget _settingItem({
    required IconData? icon,
    String? svgPath,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF5E6D3),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: svgPath != null
                  ? SvgPicture.asset(
                      svgPath,
                      width: 22.sp,
                      height: 22.sp,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF343434),
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(icon, color: const Color(0xFF343434), size: 22.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.mediumMedium.copyWith(
                    color: AppColors.lightText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyles.regularSmall.copyWith(
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.redButton,
          ),
        ],
      ),
    );
  }

  Widget _settingItemWithValue({
    required IconData icon,
    required String title,
    required String subtitle,
    required String valueText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF5E6D3),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: const Color(0xFF343434), size: 22.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.mediumMedium.copyWith(
                      color: AppColors.lightText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              valueText,
              style: TextStyles.mediumSmall.copyWith(
                color: AppColors.redButton,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingItemTile({
    required IconData? icon,
    String? svgPath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF5E6D3),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: svgPath != null
                    ? SvgPicture.asset(
                        svgPath,
                        width: 22.sp,
                        height: 22.sp,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF343434),
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(
                        icon,
                        color: const Color(0xFF343434),
                        size: 22.sp,
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
                    style: TextStyles.mediumMedium.copyWith(
                      color: isDestructive
                          ? AppColors.redButton
                          : AppColors.lightText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.lightText.withValues(alpha: 0.38),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingItemTileDestructive({
    required String svgPath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgPath,
                  width: 22.sp,
                  height: 22.sp,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFDC2626),
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
                    style: TextStyles.mediumMedium.copyWith(
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
