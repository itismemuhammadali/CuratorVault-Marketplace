import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class SettingsPreferencesView extends StatefulWidget {
  const SettingsPreferencesView({super.key});

  @override
  State<SettingsPreferencesView> createState() =>
      _SettingsPreferencesViewState();
}

class _SettingsPreferencesViewState extends State<SettingsPreferencesView> {
  bool _twoFactor = false;
  bool _loginAlerts = true;
  bool _pushNotifications = true;
  bool _emailAlerts = true;
  bool _userReports = true;
  bool _marketplaceActivity = false;
  bool _darkMode = false;
  bool _compactView = false;
  bool _debugMode = false;
  bool _performanceMonitoring = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          height: 170.h,
          leading: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              width: 31.w,
              height: 31.w,
              decoration: BoxDecoration(
                color: AppColors.bodyBg.withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 19.sp,
                color: AppColors.darkText,
              ),
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldTitle.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 28.sp,
                  height: 1.05,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'App preferences & configurations',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldSmall.copyWith(
                  color: const Color(0xffF8E8C7),
                  fontSize: 16.sp,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFAFAFB),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(19.w, 12.h, 19.w, 18.h),
          child: Column(
            children: [
              _sectionCard(
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFF22C55E),
                title: 'Security',
                children: [
                  _toggleRow(
                    title: 'Two-Factor Authentication',
                    subtitle: 'Add an extra layer of security',
                    value: _twoFactor,
                    onChanged: (value) => setState(() => _twoFactor = value),
                  ),
                  _valueRow(
                    title: 'Session Timeout',
                    subtitle: 'Automatically log out after inactivity',
                    value: '30 min',
                  ),
                  _toggleRow(
                    title: 'Login Alerts',
                    subtitle: 'Get notified of new logins',
                    value: _loginAlerts,
                    onChanged: (value) => setState(() => _loginAlerts = value),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              _sectionCard(
                icon: Icons.notifications_none_rounded,
                iconColor: const Color(0xFFFF5A5F),
                title: 'Notifications',
                children: [
                  _toggleRow(
                    title: 'Push Notifications',
                    subtitle: 'Receive instant alerts',
                    value: _pushNotifications,
                    onChanged: (value) =>
                        setState(() => _pushNotifications = value),
                  ),
                  _toggleRow(
                    title: 'Email Alerts',
                    subtitle: 'Get updates via email',
                    value: _emailAlerts,
                    onChanged: (value) => setState(() => _emailAlerts = value),
                  ),
                  _toggleRow(
                    title: 'User Reports',
                    subtitle: 'Notify on new user reports',
                    value: _userReports,
                    onChanged: (value) => setState(() => _userReports = value),
                  ),
                  _toggleRow(
                    title: 'Marketplace Activity',
                    subtitle: 'Updates on listing and sales',
                    value: _marketplaceActivity,
                    onChanged: (value) =>
                        setState(() => _marketplaceActivity = value),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              _sectionCard(
                icon: Icons.palette_outlined,
                iconColor: const Color(0xFFB75CFF),
                title: 'Appearance',
                children: [
                  _toggleRow(
                    title: 'Dark Mode',
                    subtitle: 'Switch to dark theme',
                    value: _darkMode,
                    onChanged: (value) => setState(() => _darkMode = value),
                  ),
                  _toggleRow(
                    title: 'Compact View',
                    subtitle: 'Show more items on screen',
                    value: _compactView,
                    onChanged: (value) => setState(() => _compactView = value),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              _sectionCard(
                icon: Icons.language_rounded,
                iconColor: const Color(0xFF4F79FF),
                title: 'Language & Region',
                children: [
                  _valueRow(title: 'Language', value: 'English (US)'),
                  _valueRow(title: 'Time Zone', value: 'EST (UTC-5)'),
                  _valueRow(title: 'Date Format', value: 'MM/DD/YYYY'),
                ],
              ),
              SizedBox(height: 10.h),
              _sectionCard(
                useSvgIcon: true,
                svgPath: 'assets/icons/data_icon.svg',
                iconColor: const Color(0xFF22B8CF),
                title: 'Data Management',
                children: [
                  _thinButton('Export User Data'),
                  SizedBox(height: 5.h),
                  _thinButton('Download Activity Logs'),
                  SizedBox(height: 5.h),
                  _thinButton('Backup Database'),
                ],
              ),
              SizedBox(height: 10.h),
              _sectionCard(
                useSvgIcon: true,
                svgPath: 'assets/icons/moon_icon.svg',
                iconColor: const Color(0xFF8B5CF6),
                title: 'Advanced',
                children: [
                  _toggleRow(
                    title: 'Debug Mode',
                    subtitle: 'Enable developer tools',
                    value: _debugMode,
                    onChanged: (value) => setState(() => _debugMode = value),
                  ),
                  _toggleRow(
                    title: 'Performance Monitoring',
                    subtitle: 'Track app performance metrics',
                    value: _performanceMonitoring,
                    onChanged: (value) =>
                        setState(() => _performanceMonitoring = value),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'Vintage Vinnie Admin v1.0.0',
                style: TextStyles.regularTiny.copyWith(
                  color: const Color(0xFF9199A8),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    IconData? icon,
    String? svgPath,
    bool useSvgIcon = false,
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 13.h, 14.w, 13.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: const Color(0xFFE7E8EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (useSvgIcon && svgPath != null)
                SvgPicture.asset(
                  svgPath,
                  width: 20.sp,
                  height: 20.sp,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                )
              else
                Icon(icon, size: 20.sp, color: iconColor),
              SizedBox(width: 7.w),
              Text(
                title,
                style: TextStyles.boldExtraSmall.copyWith(
                  color: const Color(0xFF344054),
                  fontSize: 17.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          ...children,
        ],
      ),
    );
  }

  Widget _toggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Expanded(
            child: _rowText(title: title, subtitle: subtitle),
          ),
          SizedBox(width: 8.w),
          _TinySwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _valueRow({
    required String title,
    String? subtitle,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Expanded(child: _rowText(title: title, subtitle: subtitle)),
          SizedBox(width: 8.w),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularTiny.copyWith(
              color: const Color(0xFF667085),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowText({required String title, String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.semiBoldExtraSmall.copyWith(
            color: const Color(0xFF344054),
            fontSize: 14.sp,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: 3.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularTiny.copyWith(
              color: const Color(0xFF667085),
              fontSize: 12.sp,
            ),
          ),
        ],
      ],
    );
  }

  Widget _thinButton(String label) {
    return Container(
      width: double.infinity,
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 9.w),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(3.r),
        border: Border.all(color: const Color(0xFFE7E8EB)),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyles.mediumExtraSmall.copyWith(
          color: const Color(0xFF344054),
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

class _TinySwitch extends StatelessWidget {
  const _TinySwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 42.w,
        height: 24.h,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF344054) : const Color(0xFFD7DCE3),
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 160),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18.w,
            height: 18.w,
            decoration: const BoxDecoration(
              color: AppColors.bodyBg,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
