import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
  bool _voiceControlEnabled = false;
  bool _darkModeEnabled = false;

  void _updateHeader() {
    HeaderControllerProvider.of(context).value = HeaderConfig(
      title: Expanded(
        child: _ProfileHeaderCard(
          name: 'Lori Porter',
          email: 'sarah.johnson@email.com',
          membershipLabel: 'Gold Member',
          pointsValue: '2,341',
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
        if (!mounted) return;
        _updateHeader();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bodyBg,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 120.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: _StatTile(
                    icon: Icons.inventory_2_outlined,
                    value: '47',
                    label: 'Items Scanned',
                  ),
                ),
                SizedBox(width: 14.w),
                const Expanded(
                  child: _StatTile(
                    icon: Icons.trending_up,
                    value: '\$8.6k',
                    label: 'Collection Value',
                  ),
                ),
                SizedBox(width: 14.w),
                const Expanded(
                  child: _StatTile(
                    icon: Icons.star_border_rounded,
                    value: '4.9',
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
                  icon: Icons.person_outline,
                  label: 'Edit Profile',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push("/user/editprofile");
                  },
                ),
                _SettingsItem(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'My Wallet',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/wallet');
                  },
                ),
                _SettingsItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Order History',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/order-history');
                  },
                ),
                _SettingsItem(
                  icon: Icons.local_offer_outlined,
                  label: 'My Offers',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/offers');
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
                  icon: Icons.card_membership_outlined,
                  label: 'Membership & Points',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/membership-points');
                  },
                ),
                _SettingsItem(
                  icon: Icons.payments_outlined,
                  label: 'Purchase History',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/purchase-history');
                  },
                ),
                _SettingsItem(
                  icon: Icons.thumb_up_alt_outlined,
                  label: 'Reviews & Ratings',
                  type: _SettingsItemType.chevron,
                  onTap: () {
                    context.push('/user/reviews-ratings');
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
                  icon: Icons.record_voice_over_outlined,
                  label: 'Voice Control',
                  type: _SettingsItemType.toggle,
                  toggleValue: _voiceControlEnabled,
                  onToggle: (v) => setState(() => _voiceControlEnabled = v),
                ),
                _SettingsItem(
                  icon: Icons.language_outlined,
                  label: 'Language',
                  type: _SettingsItemType.valueChevron,
                  valueText: 'English',
                  onTap: () {
                    context.push('/user/language');
                  },
                ),
                _SettingsItem(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark Mode',
                  type: _SettingsItemType.toggle,
                  toggleValue: _darkModeEnabled,
                  onToggle: (v) => setState(() => _darkModeEnabled = v),
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
                  icon: Icons.privacy_tip_outlined,
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
            _LogoutButton(onTap: () {}),
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
            style: TextStyles.regularSmall.copyWith(color: AppColors.darkText),
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
            style: TextStyles.boldSmall.copyWith(color: AppColors.bodyBg),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 96.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.darkText.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22.sp, color: AppColors.lightText),
          SizedBox(height: 8.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.boldMedium.copyWith(color: AppColors.lightText),
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

enum _SettingsItemType { chevron, toggle, valueChevron }

class _SettingsItem {
  final IconData icon;
  final String label;
  final _SettingsItemType type;
  final String? valueText;

  final bool isLast;

  final bool? toggleValue;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.type,
    this.valueText = '',
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
              : Border(bottom: BorderSide(color: borderColor, width: 1)),
        ),
        child: Row(
          children: [
            _LeadingIcon(icon: item.icon),
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
            if (item.type == _SettingsItemType.valueChevron)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.valueText ?? '',
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.lightText.withValues(alpha: 0.55),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.lightText.withValues(alpha: 0.38),
                  ),
                ],
              ),
            if (item.type == _SettingsItemType.toggle)
              Switch(
                value: item.toggleValue ?? false,
                onChanged: item.onToggle,
                activeThumbColor: AppColors.bodyBg,
                activeTrackColor: AppColors.lightText,
                inactiveThumbColor: AppColors.lightText,
                inactiveTrackColor: AppColors.lightText.withValues(alpha: 0.15),
              ),
          ],
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final IconData icon;

  const _LeadingIcon({required this.icon});

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
        child: Icon(icon, color: AppColors.redButton, size: 20.sp),
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
            Icon(Icons.logout_rounded, color: AppColors.redButton, size: 18.sp),
            SizedBox(width: 10.w),
            Text(
              'Logout',
              style: TextStyles.boldSmall.copyWith(color: AppColors.redButton),
            ),
          ],
        ),
      ),
    );
  }
}
