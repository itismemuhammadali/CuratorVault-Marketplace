import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/components/icons/icon_box_transparent.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AppSettingsView extends StatefulWidget {
  const AppSettingsView({super.key});

  @override
  State<AppSettingsView> createState() => _AppSettingsViewState();
}

class _AppSettingsViewState extends State<AppSettingsView> {
  bool _orderUpdates = true;
  bool _messages = true;
  bool _promotions = false;
  bool _priceAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
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
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                iconAsset: AppImages.notificationBellIcon,
                title: 'Notifications',
              ),
              SizedBox(height: 10.h),
              _card(
                child: Column(
                  children: [
                    _toggleRow(
                      title: 'Order Updates',
                      subtitle: 'New orders and status changes',
                      value: _orderUpdates,
                      onChanged: (v) => setState(() => _orderUpdates = v),
                    ),
                    _divider(),
                    _toggleRow(
                      title: 'Messages',
                      subtitle: 'New buyer messages',
                      value: _messages,
                      onChanged: (v) => setState(() => _messages = v),
                    ),
                    _divider(),
                    _toggleRow(
                      title: 'Promotions',
                      subtitle: 'Special offers and updates',
                      value: _promotions,
                      onChanged: (v) => setState(() => _promotions = v),
                    ),
                    _divider(),
                    _toggleRow(
                      title: 'Price Alerts',
                      subtitle: 'Market price notifications',
                      value: _priceAlerts,
                      onChanged: (v) => setState(() => _priceAlerts = v),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              _sectionTitle(
                iconAsset: AppImages.sheildIcon,
                title: 'Account & Security',
              ),
              SizedBox(height: 10.h),
              _card(
                child: Column(
                  children: [
                    _navRow(
                      iconAsset: AppImages.iconLock,
                      title: 'Change Password',
                      subtitle: 'Update your password',
                      onTap: () =>
                          context.push('/dealer/app-settings/change-password'),
                      useSvgLock: true,
                    ),
                    _divider(),
                    _navRow(
                      iconAsset: AppImages.sheildIcon,
                      title: 'Two-Factor Authentication',
                      subtitle: 'Add extra security',
                      onTap: () =>
                          context.push('/dealer/app-settings/two-factor-auth'),
                      useSvgShield: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              _sectionTitle(
                iconAsset: AppImages.globeIcon,
                title: 'Preferences',
              ),
              SizedBox(height: 10.h),
              _card(
                child: Column(
                  children: [
                    _navRow(
                      iconAsset: AppImages.globeIcon,
                      title: 'Language',
                      subtitle: 'English (US)',
                      onTap: () =>
                          context.push('/dealer/app-settings/language'),
                    ),
                    _divider(),
                    _toggleRow(
                      title: 'Dark Mode',
                      subtitle: 'Coming soon',
                      value: false,
                      enabled: false,
                      onChanged: (_) {},
                      isMoonIcon: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              _sectionTitle(
                iconAsset: AppImages.helpQuestionIcon,
                title: 'Support & Legal',
              ),
              SizedBox(height: 10.h),
              _card(
                child: Column(
                  children: [
                    _navRow(
                      iconAsset: AppImages.helpQuestionIcon,
                      title: 'Help Center',
                      onTap: () => context.push('/dealer/help-faq'),
                    ),
                    _divider(),
                    _navRow(
                      iconAsset: AppImages.documentIcon,
                      title: 'Terms of Service',
                      onTap: () => context.push('/dealer/privacy-terms'),
                    ),
                    _divider(),
                    _navRow(
                      iconAsset: AppImages.shieldImg,
                      title: 'Privacy Policy',
                      onTap: () => context.push('/dealer/privacy-policy'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle({required String iconAsset, required String title}) {
    return Row(
      children: [
        IconBoxTransparent(icon: iconAsset, color: AppColors.lightText),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyles.boldMedium.copyWith(
            color: AppColors.lightText,
            fontSize: 20.sp,
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFDDE3EB)),
      ),
      child: child,
    );
  }

  Widget _divider() {
    return Container(height: 1, color: const Color(0xFFE4E9F0));
  }

  Widget _toggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
    bool isMoonIcon = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      child: Row(
        children: [
          if (isMoonIcon) ...[
            SvgPicture.asset(
              'assets/icons/moon_icon.svg',
              width: 22.w,
              height: 22.w,
              colorFilter: ColorFilter.mode(
                AppColors.lightText,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.mediumMedium.copyWith(
                    color: AppColors.lightText,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.90,
            child: Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeThumbColor: AppColors.bodyBg,
              activeTrackColor: const Color(0xFF344967),
              inactiveThumbColor: AppColors.bodyBg,
              inactiveTrackColor: const Color(0xFFB9B9B9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navRow({
    required String iconAsset,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool useSvgLock = false,
    bool useSvgShield = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
        child: Row(
          children: [
            if (useSvgLock)
              SvgPicture.asset(
                'assets/icons/lock_icon.svg',
                width: 20.w,
                height: 20.w,
                colorFilter: ColorFilter.mode(
                  AppColors.lightText,
                  BlendMode.srcIn,
                ),
              )
            else if (useSvgShield)
              IconBoxTransparent(icon: iconAsset, color: AppColors.lightText)
            else
              Image.asset(
                iconAsset,
                width: 20.sp,
                height: 20.sp,
                color: AppColors.lightText,
              ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.mediumMedium.copyWith(
                      color: AppColors.lightText,
                      fontSize: 18.sp,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconBox(
              icon: AppImages.chevronIcon,
              width: 22.sp,
              height: 22.sp,
              bgColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
