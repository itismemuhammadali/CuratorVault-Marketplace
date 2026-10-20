import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/services/api_service.dart';
import 'package:vintage_app/core/services/auth_service.dart';

import '../../../core/components/global_header/header_config.dart';
import '../../../core/components/global_header/header_controller_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/images.dart';
import '../../../core/theme/text_styles.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _headerSet = false;

  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  String _name = 'Customer User';
  String _email = 'customer@vintagevibers.com';
  String _membershipLabel = 'Gold Member';
  String _pointsValue = '2,341';
  String _itemsScanned = '47';
  String _collectionValue = '\$8.6k';
  String _avgRating = '4.9';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        if (user.email != null && user.email!.isNotEmpty) {
          _email = user.email!;
        }
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          _name = user.displayName!;
        }
      });
    }

    try {
      final res = await ApiService.get('/api/v1/profile/me');
      if (res is Map && mounted) {
        final data = Map<String, dynamic>.from(res);
        setState(() {
          _name = (data['name'] ?? data['firstName'] ?? _name).toString();
          _email = (data['email'] ?? _email).toString();
          _membershipLabel = (data['membership'] ?? 'Gold Member').toString();
          _pointsValue = (data['points'] ?? '2,341').toString();
          _itemsScanned = (data['itemsScanned'] ?? '47').toString();
          _collectionValue = (data['collectionValue'] ?? '\$8.6k').toString();
          _avgRating = (data['avgRating'] ?? '4.9').toString();
        });
        _updateHeader();
      }
    } catch (e) {
      debugPrint('Error loading customer profile from backend: $e');
    }
  }

  void _updateHeader() {
    if (!mounted) return;
    HeaderControllerProvider.of(context).value = HeaderConfig(
      title: Expanded(
        child: _ProfileHeaderCard(
          name: _name,
          email: _email,
          membershipLabel: _membershipLabel,
          pointsValue: _pointsValue,
          pointsLabel: 'Points',
          avatarAsset: AppImages.userImg,
        ),
      ),
      height: 240.h,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_headerSet) {
      _headerSet = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateHeader();
      });
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Logout',
          style: TextStyles.boldMedium.copyWith(
            color: AppColors.gradientColor1,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: TextStyles.regularSmall.copyWith(
            color: AppColors.lightText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: TextStyles.semiBoldSmall.copyWith(
                color: AppColors.greyText,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Logout',
              style: TextStyles.semiBoldSmall.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await AuthService().signOut();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 120.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    customIcon: AppImages.packageIcon,
                    value: _itemsScanned,
                    label: 'Items Scanned',
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: _StatTile(
                    icon: Icons.trending_up,
                    value: _collectionValue,
                    label: 'Collection Value',
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: _StatTile(
                    icon: Icons.star_border_rounded,
                    value: _avgRating,
                    label: 'Avg. Rating',
                  ),
                ),
              ],
            ),
            SizedBox(height: 26.h),
            Text(
              'Account',
              style: TextStyles.boldMedium.copyWith(
                fontSize: 20.sp,
                color: AppColors.lightText,
              ),
            ),
            SizedBox(height: 12.h),
            _SettingsGroup(
              items: [
                _SettingsItem(
                  customIcon: AppImages.profileIcon,
                  label: 'Edit Profile',
                  type: _SettingsItemType.chevron,
                  onTap: () async {
                    await context.push('/user/editprofile');
                    _loadProfileData();
                  },
                ),
                _SettingsItem(
                  customIcon: AppImages.walletIcon,
                  label: 'My Wallet',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/wallet');
                  },
                ),
                _SettingsItem(
                  customIcon: AppImages.packageIcon,
                  label: 'Order History',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/orders/history',
                        extra: {'from': 'profile'});
                  },
                ),
                _SettingsItem(
                  customIcon: AppImages.packageIcon,
                  label: 'My Offer',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/my-finds/offers');
                  },
                ),
                _SettingsItem(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Rewards & Achievements',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/rewards-achievements');
                  },
                  isLast: true,
                ),
              ],
              onTap: (_) {},
            ),
            SizedBox(height: 26.h),
            Text(
              'Community & Membership',
              style: TextStyles.boldMedium.copyWith(
                fontSize: 20.sp,
                color: AppColors.lightText,
              ),
            ),
            SizedBox(height: 12.h),
            _SettingsGroup(
              items: [
                _SettingsItem(
                  icon: Icons.emoji_events_outlined,
                  label: 'Achievements',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/achievements');
                  },
                ),
                _SettingsItem(
                  customIcon: AppImages.crownIconSvg,
                  label: 'Membership & Points',
                  type: _SettingsItemType.chevron,
                  onTap: () => context.push('/user/membership-rewards'),
                ),
                _SettingsItem(
                  iconText: '\$',
                  label: 'Purchase History',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/purchase-history');
                  },
                ),
                _SettingsItem(
                  icon: Icons.notifications_active_outlined,
                  label: 'Notification Center',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/notifications');
                  },
                ),
                _SettingsItem(
                  icon: Icons.thumb_up_alt_outlined,
                  label: 'Reviews & Ratings',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/reviews');
                  },
                  isLast: true,
                ),
              ],
              onTap: (_) {},
            ),
            SizedBox(height: 26.h),
            Text(
              'Preferences',
              style: TextStyles.boldMedium.copyWith(
                fontSize: 20.sp,
                color: AppColors.lightText,
              ),
            ),
            SizedBox(height: 12.h),
            _SettingsGroup(
              items: [
                _SettingsItem(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifications',
                  type: _SettingsItemType.toggle,
                  toggleValue: _notificationsEnabled,
                  onToggle: (v) => setState(() => _notificationsEnabled = v),
                ),
                _SettingsItem(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark Mode',
                  type: _SettingsItemType.toggle,
                  toggleValue: _darkModeEnabled,
                  onToggle: (v) => setState(() => _darkModeEnabled = v),
                ),
                _SettingsItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/app-settings');
                  },
                  isLast: true,
                ),
              ],
              onTap: (_) {},
            ),
            SizedBox(height: 26.h),
            Text(
              'Support',
              style: TextStyles.boldMedium.copyWith(
                fontSize: 20.sp,
                color: AppColors.lightText,
              ),
            ),
            SizedBox(height: 12.h),
            _SettingsGroup(
              items: [
                _SettingsItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & FAQ',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/help-faq');
                  },
                ),
                _SettingsItem(
                  customIcon: AppImages.shieldIconSvg,
                  label: 'Privacy & Terms',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/privacy-terms');
                  },
                  isLast: true,
                ),
              ],
              onTap: (_) {},
            ),
            SizedBox(height: 24.h),
            _LogoutButton(
              onTap: _handleLogout,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String membershipLabel;
  final String pointsValue;
  final String pointsLabel;
  final String avatarAsset;

  const _ProfileHeaderCard({
    required this.name,
    required this.email,
    required this.membershipLabel,
    required this.pointsValue,
    required this.pointsLabel,
    required this.avatarAsset,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 208.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 76.h,
                width: 76.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.darkText.withValues(alpha: 0.75),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    avatarAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.darkText.withValues(alpha: 0.12),
                        child: Center(
                          child: Image.asset(
                            AppImages.navProfile,
                            width: 30.w,
                            height: 30.w,
                            color: AppColors.bodyBg,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                right: -2.w,
                bottom: -2.h,
                child: Container(
                  height: 26.h,
                  width: 26.h,
                  decoration: BoxDecoration(
                    color: AppColors.redButton,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bodyBg, width: 2),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.workspace_premium_outlined,
                      size: 15.sp,
                      color: AppColors.bodyBg,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            name,
            style: TextStyles.boldMedium.copyWith(
              fontSize: 24.sp,
              color: AppColors.bodyBg,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            email,
            style: TextStyles.regularSmall.copyWith(
              color: AppColors.darkText,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Pill(
                icon: Icons.workspace_premium_outlined,
                label: membershipLabel,
              ),
              SizedBox(width: 18.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pointsValue,
                    style: TextStyles.boldSmall.copyWith(
                      fontSize: 16.sp,
                      color: AppColors.bodyBg,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    pointsLabel,
                    style: TextStyles.regularExtraSmall.copyWith(
                      color: AppColors.darkText,
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
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.redButton,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: AppColors.bodyBg),
          SizedBox(width: 10.w),
          Text(
            label,
            style: TextStyles.boldSmall.copyWith(
              color: AppColors.bodyBg,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData? icon;
  final String? customIcon;
  final String value;
  final String label;

  const _StatTile({
    this.icon,
    this.customIcon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 96.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8E8C7),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customIcon != null
              ? SvgPicture.asset(
                  customIcon!,
                  width: 22.sp,
                  height: 22.sp,
                  colorFilter: const ColorFilter.mode(
                    AppColors.lightText,
                    BlendMode.srcIn,
                  ),
                )
              : Icon(icon, size: 22.sp, color: AppColors.lightText),
          SizedBox(height: 8.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.boldMedium.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyles.regularExtraSmall.copyWith(
              color: AppColors.lightText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

enum _SettingsItemType { chevron, toggle }

class _SettingsItem {
  final IconData? icon;
  final String? customIcon;
  final String? iconText;
  final String label;
  final _SettingsItemType type;

  final bool isLast;

  final bool? toggleValue;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;

  _SettingsItem({
    this.icon,
    this.customIcon,
    this.iconText,
    required this.label,
    required this.type,
    this.isLast = false,
    this.toggleValue,
    this.onToggle,
    this.onTap,
  });
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  final ValueChanged<_SettingsItem> onTap;

  const _SettingsGroup({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: AppColors.shadowColor.withValues(alpha: 0.10),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.08),
            blurRadius: 28.r,
            spreadRadius: -18,
            offset: Offset(0, 14.h),
          ),
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.04),
            blurRadius: 10.r,
            spreadRadius: -6,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          return _SettingsRow(
            item: item,
            onTap: item.onTap ?? () => onTap(item),
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final _SettingsItem item;
  final VoidCallback onTap;

  const _SettingsRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.redButton.withValues(alpha: 0.20);

    return InkWell(
      onTap: item.type == _SettingsItemType.toggle ? null : onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: item.isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: borderColor,
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          children: [
            _LeadingIcon(
                icon: item.icon,
                customIcon: item.customIcon,
                iconText: item.iconText),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                item.label,
                style: TextStyles.mediumSmall.copyWith(
                  color: AppColors.lightText,
                ),
              ),
            ),
            if (item.type == _SettingsItemType.chevron)
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.lightText.withValues(alpha: 0.38),
              ),
            if (item.type == _SettingsItemType.toggle)
              Switch(
                value: item.toggleValue ?? false,
                onChanged: item.onToggle,
                activeThumbColor: AppColors.bodyBg,
                activeTrackColor: AppColors.lightText,
                inactiveThumbColor: AppColors.lightText,
                inactiveTrackColor:
                    AppColors.lightText.withValues(alpha: 0.15),
              ),
          ],
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final IconData? icon;
  final String? customIcon;
  final String? iconText;

  const _LeadingIcon({this.icon, this.customIcon, this.iconText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.h,
      width: 38.h,
      decoration: BoxDecoration(
        color: AppColors.redButton.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: iconText != null
            ? Text(
                iconText!,
                style: TextStyles.boldMedium.copyWith(
                  fontSize: 20.sp,
                  color: AppColors.redButton,
                ),
              )
            : customIcon != null
                ? SvgPicture.asset(
                    customIcon!,
                    width: 20.sp,
                    height: 20.sp,
                    colorFilter: const ColorFilter.mode(
                      AppColors.redButton,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(
                    icon,
                    color: AppColors.redButton,
                    size: 20.sp,
                  ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 16.r,
            spreadRadius: -10,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.redButton),
          backgroundColor: AppColors.bodyBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 18.h),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: AppColors.redButton,
              size: 18.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              'Logout',
              style: TextStyles.boldSmall.copyWith(
                color: AppColors.redButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
