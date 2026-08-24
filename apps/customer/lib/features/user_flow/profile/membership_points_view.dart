import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

enum _MembershipTab { all, premium, free }

class MembershipPointsView extends StatefulWidget {
  const MembershipPointsView({super.key});

  @override
  State<MembershipPointsView> createState() => _MembershipPointsViewState();
}

class _MembershipPointsViewState extends State<MembershipPointsView> {
  _MembershipTab _selectedTab = _MembershipTab.all;
  String? _openMemberMenu;

  static final _members = <_MemberSubscription>[
    _MemberSubscription(
      name: 'John Collector',
      email: 'john@example.com',
      avatar: AppImages.messageAvatarJohn,
      tier: 'Premium',
      tierType: _MembershipTab.premium,
      status: 'Active',
      statusColor: AppColors.quickActionGreen,
      started: 'Jan 15, 2026',
      renews: 'Mar 15, 2026',
    ),
    _MemberSubscription(
      name: 'Sarah Dealer',
      email: 'sarah@example.com',
      avatar: AppImages.messageAvatarSarah,
      tier: 'Premium Plus',
      tierType: _MembershipTab.premium,
      status: 'Active',
      statusColor: AppColors.quickActionGreen,
      started: 'Dec 5, 2025',
      renews: 'Apr 2, 2026',
    ),
    _MemberSubscription(
      name: 'Mike Vintage',
      email: 'mike@example.com',
      avatar: AppImages.messageAvatarMichael,
      tier: 'Premium',
      tierType: _MembershipTab.premium,
      status: 'Expiring Soon',
      statusColor: AppColors.alertOrange,
      started: 'Nov 8, 2025',
      renews: 'Feb 5, 2026',
    ),
    _MemberSubscription(
      name: 'Emma Vintage',
      email: 'emma@example.com',
      avatar: AppImages.messageAvatarEmma,
      tier: 'Free',
      tierType: _MembershipTab.free,
      status: 'Active',
      statusColor: AppColors.quickActionGreen,
      started: 'Jan 5, 2026',
      renews: '-',
    ),
    _MemberSubscription(
      name: 'Tom Specialist',
      email: 'tom@example.com',
      avatar: AppImages.userImg,
      tier: 'Premium Plus',
      tierType: _MembershipTab.premium,
      status: 'Active',
      statusColor: AppColors.quickActionGreen,
      started: 'Jan 20, 2026',
      renews: 'May 1, 2026',
    ),
  ];

  List<_MemberSubscription> get _visibleMembers {
    if (_selectedTab == _MembershipTab.all) return _members;
    return _members.where((member) => member.tierType == _selectedTab).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          height: 145.h,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 29.w,
              height: 29.w,
              decoration: BoxDecoration(
                color: AppColors.bodyBg.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 17.sp,
                color: AppColors.darkText,
              ),
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Membership Management',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldSection.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 18.5.sp,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Manage user subscriptions',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.mediumExtraSmall.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.84),
                  fontSize: 11.5.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.membershipPageBg,
      body: SafeArea(
        top: false,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_openMemberMenu != null) {
              setState(() => _openMemberMenu = null);
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 16.h),
            child: Column(
              children: [
                _searchField(),
                SizedBox(height: 10.h),
                _summaryCards(),
                SizedBox(height: 9.h),
                _tabs(),
                SizedBox(height: 12.h),
                ..._visibleMembers.map(
                  (member) => Padding(
                    padding: EdgeInsets.only(bottom: 9.h),
                    child: _memberCard(member),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: 36.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.10),
            blurRadius: 10,
            spreadRadius: -7,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 10.w),
          SvgPicture.asset(
            'assets/icons/search_icon.svg',
            width: 14.sp,
            height: 14.sp,
            colorFilter: const ColorFilter.mode(
              AppColors.membershipPlaceholderText,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: TextField(
              style: TextStyles.mediumExtraSmall.copyWith(
                color: AppColors.membershipPrimaryText,
                fontSize: 12.sp,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search members...',
                hintStyle: TextStyles.mediumExtraSmall.copyWith(
                  color: AppColors.membershipPlaceholderText,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCards() {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            iconColor: AppColors.membershipPremium,
            value: '342',
            label: 'Premium',
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: _summaryCard(
            iconColor: AppColors.membershipPlus,
            value: '128',
            label: 'Plus',
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: _summaryCard(
            iconColor: AppColors.membershipFree,
            value: '1,234',
            label: 'Free',
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      height: 73.h,
      padding: EdgeInsets.fromLTRB(9.w, 9.h, 9.w, 8.h),
      decoration: BoxDecoration(
        color: AppColors.membershipSummaryBg,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.membershipCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.workspace_premium_outlined, size: 14.sp, color: iconColor),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldSmall.copyWith(
              color: AppColors.membershipPrimaryText,
              fontSize: 14.sp,
              height: 1.1,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldExtraSmall.copyWith(
              color: iconColor,
              fontSize: 9.sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    return Container(
      height: 18.h,
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: AppColors.membershipTabsBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          _tabButton('All', _MembershipTab.all),
          _tabButton('Premium', _MembershipTab.premium),
          _tabButton('Free', _MembershipTab.free),
        ],
      ),
    );
  }

  Widget _tabButton(String label, _MembershipTab tab) {
    final selected = _selectedTab == tab;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = tab),
        borderRadius: BorderRadius.circular(9.r),
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.gradientColor1 : AppColors.bodyBg,
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldExtraSmall.copyWith(
              color:
                  selected ? AppColors.bodyBg : AppColors.membershipPrimaryText,
              fontSize: 9.sp,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _memberCard(_MemberSubscription member) {
    final isMenuOpen = _openMemberMenu == member.email;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(11.w, 10.h, 11.w, 9.h),
          decoration: BoxDecoration(
            color: AppColors.bodyBg,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Image.asset(
                      member.avatar,
                      width: 34.w,
                      height: 34.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 9.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.boldSmall.copyWith(
                            color: AppColors.membershipPrimaryText,
                            fontSize: 14.sp,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          member.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.mediumExtraSmall.copyWith(
                            color: AppColors.membershipMutedText,
                            fontSize: 8.5.sp,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 4.h,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 96.w),
                              child: _tierPill(member.tier),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 96.w),
                              child: _statusPill(
                                member.status,
                                member.statusColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 7.w),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        _openMemberMenu = isMenuOpen ? null : member.email;
                      });
                    },
                    child: SizedBox(
                      width: 20.w,
                      height: 26.h,
                      child: Icon(
                        Icons.more_vert_rounded,
                        size: 17.sp,
                        color: AppColors.membershipPrimaryText,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _datePanel(
                      label: 'Started',
                      value: member.started,
                      background: AppColors.membershipDateStartedBg,
                      valueColor: AppColors.membershipDateStartedText,
                    ),
                  ),
                  Expanded(
                    child: _datePanel(
                      label: 'Renews',
                      value: member.renews,
                      background: AppColors.membershipDateRenewBg,
                      valueColor: AppColors.membershipDateRenewText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isMenuOpen)
          Positioned(
            top: 27.h,
            right: 31.w,
            child: _memberMenu(member),
          ),
      ],
    );
  }

  Widget _memberMenu(_MemberSubscription member) {
    return Material(
      color: AppColors.transparent,
      child: Container(
        width: 112.w,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(4.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.18),
              blurRadius: 10,
              spreadRadius: -4,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _memberMenuItem(
              icon: Icons.edit_outlined,
              label: 'Edit Membership',
              onTap: () {
                setState(() => _openMemberMenu = null);
                _showEditMembershipSheet(context, member);
              },
            ),
            SizedBox(height: 2.h),
            _memberMenuItem(
              icon: Icons.open_in_new_rounded,
              label: 'Renew Now',
              onTap: () => setState(() => _openMemberMenu = null),
            ),
          ],
        ),
      ),
    );
  }

  Widget _memberMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 25.h,
        padding: EdgeInsets.symmetric(horizontal: 9.w),
        child: Row(
          children: [
            Icon(icon, size: 13.sp, color: AppColors.membershipPrimaryText),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.mediumExtraSmall.copyWith(
                  color: AppColors.membershipPrimaryText,
                  fontSize: 11.sp,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tierPill(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.membershipTabsBg,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            size: 8.sp,
            color: AppColors.membershipPrimaryText,
          ),
          SizedBox(width: 3.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.boldExtraSmall.copyWith(
                color: AppColors.membershipPrimaryText,
                fontSize: 7.5.sp,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyles.boldExtraSmall.copyWith(
          color: AppColors.bodyBg,
          fontSize: 8.sp,
          height: 1,
        ),
      ),
    );
  }

  Widget _datePanel({
    required String label,
    required String value,
    required Color background,
    required Color valueColor,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: 34.h),
      padding: EdgeInsets.fromLTRB(8.w, 5.h, 8.w, 5.h),
      decoration: BoxDecoration(color: background),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.mediumExtraSmall.copyWith(
              color: AppColors.membershipMutedText,
              fontSize: 8.5.sp,
              height: 1,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldExtraSmall.copyWith(
              color: valueColor,
              fontSize: 8.sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditMembershipSheet(
    BuildContext context,
    _MemberSubscription member,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _EditMembershipSheet(member: member),
    );
  }
}

class _MemberSubscription {
  const _MemberSubscription({
    required this.name,
    required this.email,
    required this.avatar,
    required this.tier,
    required this.tierType,
    required this.status,
    required this.statusColor,
    required this.started,
    required this.renews,
  });

  final String name;
  final String email;
  final String avatar;
  final String tier;
  final _MembershipTab tierType;
  final String status;
  final Color statusColor;
  final String started;
  final String renews;
}

class _EditMembershipSheet extends StatelessWidget {
  final _MemberSubscription member;

  const _EditMembershipSheet({required this.member});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(32.w, 18.h, 32.w, 20.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.22),
              blurRadius: 22,
              spreadRadius: -8,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Edit Membership',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.boldSection.copyWith(
                          color: AppColors.lightText,
                          fontSize: 24.sp,
                          height: 1.05,
                        ),
                      ),
                    ),
                    _MembershipSheetCloseButton(
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 28.h),
                _EditMemberSummary(member: member),
                SizedBox(height: 19.h),
                Text(
                  'Membership Type',
                  style: TextStyles.mediumMedium.copyWith(
                    color: AppColors.lightText,
                    fontSize: 20.sp,
                    height: 1,
                  ),
                ),
                SizedBox(height: 10.h),
                _MembershipTypeField(tier: member.tier),
                SizedBox(height: 22.h),
                _EditMembershipNotice(),
                SizedBox(height: 61.h),
                Row(
                  children: [
                    Expanded(
                      child: _EditMembershipPrimaryButton(
                        label: 'Save Changes',
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _EditMembershipCancelButton(
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditMemberSummary extends StatelessWidget {
  final _MemberSubscription member;

  const _EditMemberSummary({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(15.w, 13.h, 15.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.membershipEditMemberBg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.membershipPrimaryText,
              fontSize: 20.sp,
              height: 1.05,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            member.email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularSmall.copyWith(
              color: AppColors.membershipMutedText,
              fontSize: 15.sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MembershipTypeField extends StatelessWidget {
  final String tier;

  const _MembershipTypeField({required this.tier});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: AppColors.membershipEditFieldBg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$tier - \$49.99/month',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.mediumMedium.copyWith(
                color: AppColors.lightText,
                fontSize: 19.sp,
                height: 1,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.membershipPlaceholderText,
            size: 24.sp,
          ),
        ],
      ),
    );
  }
}

class _EditMembershipNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.membershipEditNoticeBg,
        borderRadius: BorderRadius.circular(9.r),
        border: Border.all(color: AppColors.membershipEditNoticeBorder),
      ),
      child: Text(
        'Changes will take effect immediately. The user will be\nnotified via email.',
        style: TextStyles.regularSmall.copyWith(
          color: AppColors.membershipEditNoticeText,
          fontSize: 16.sp,
          height: 1.35,
        ),
      ),
    );
  }
}

class _MembershipSheetCloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _MembershipSheetCloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(
          Icons.close_rounded,
          size: 18.sp,
          color: AppColors.membershipMutedText,
        ),
      ),
    );
  }
}

class _EditMembershipPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _EditMembershipPrimaryButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientColor1,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.mediumMedium.copyWith(
            color: AppColors.bodyBg,
            fontSize: 18.sp,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _EditMembershipCancelButton extends StatelessWidget {
  final VoidCallback onTap;

  const _EditMembershipCancelButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.cardBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: onTap,
        child: Text(
          'Cancel',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.mediumMedium.copyWith(
            color: AppColors.lightText,
            fontSize: 18.sp,
            height: 1,
          ),
        ),
      ),
    );
  }
}
