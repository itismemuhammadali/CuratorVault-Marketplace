import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';

import 'package:vintage_app/core/components/global_header/header_controller_provider.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/admin_flow/users/user_details_view.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({super.key});

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedTab = 0;
  bool _headerSet = false;

  final List<_UserCardData> _users = [
    _UserCardData(
      name: 'John Collector',
      email: 'jessica.hanson@example.com',
      imageAsset: AppImages.userImg,
      role: UserRole.collector,
      status: UserStatus.active,
      verification: VerificationStatus.verified,
    ),
    _UserCardData(
      name: 'Kristin Watson',
      email: 'michelle.rivera@example.com',
      imageAsset: AppImages.userImg,
      role: UserRole.dealer,
      status: UserStatus.active,
      verification: VerificationStatus.pending,
    ),
    _UserCardData(
      name: 'Albert Flores',
      email: 'michael.mitc@example.com',
      imageAsset: AppImages.userImg,
      role: UserRole.dealer,
      status: UserStatus.active,
      verification: VerificationStatus.verified,
    ),
    _UserCardData(
      name: 'Leslie Alexander',
      email: 'dolores.chambers@example.com',
      imageAsset: AppImages.userImg,
      role: UserRole.dealer,
      status: UserStatus.active,
      verification: VerificationStatus.pending,
    ),
    _UserCardData(
      name: 'Guy Hawkins',
      email: 'georgia.young@example.com',
      imageAsset: AppImages.userImg,
      role: UserRole.collector,
      status: UserStatus.active,
      verification: VerificationStatus.pending,
    ),
    _UserCardData(
      name: 'Jacob Jones',
      email: 'bill.sanders@example.com',
      imageAsset: AppImages.userImg,
      role: UserRole.dealer,
      status: UserStatus.active,
      verification: VerificationStatus.verified,
      reports: 1,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateHeader() {
    HeaderControllerProvider.of(context).value = HeaderConfig(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Management',
            style: TextStyles.boldTitle.copyWith(color: AppColors.bodyBg),
          ),
          SizedBox(height: 4.h),
          Text(
            'Manage all platform users',
            style: TextStyles.semiBoldMedium.copyWith(
              color: const Color(0xffF8E8C7),
            ),
          ),
        ],
      ),
      trailing: _messageBadge(),
      height: 170.h,
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
    final filtered = _filteredUsers();

    return Container(
      color: AppColors.homeScreenBg,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          children: [
            AppTextField(
              controller: _searchController,
              hintText: 'Search antiques, categories, or experts...',
              fillColor: AppColors.bodyBg,
              borderColor: AppColors.cardBorder,
              focusedBorderColor: AppColors.cardBorder,
              borderRadius: 14.r,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              prefix: SvgPicture.asset(
                'assets/icons/search_icon.svg',
                width: 18.w,
                height: 18.h,
                colorFilter: ColorFilter.mode(
                  AppColors.lightText.withValues(alpha: 0.7),
                  BlendMode.srcIn,
                ),
              ),

            ),
            SizedBox(height: 14.h),
            _tabs(),
            SizedBox(height: 16.h),
            Column(
              children: [
                for (final user in filtered) ...[
                  _userCard(user),
                  SizedBox(height: 14.h),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageBadge() {
    return GestureDetector(
      onTap: () => context.push('/messages'),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Image.asset(
                AppImages.iconMail,
                width: 20.w,
                height: 20.h,
                color: AppColors.gradientColor1,
              ),
            ),
          ),
          Positioned(
            top: -4.h,
            right: -4.w,
            child: Container(
              width: 18.w,
              height: 18.w,
              decoration: const BoxDecoration(
                color: AppColors.tagReports,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '3',
                  style: TextStyles.semiBoldExtraSmall.copyWith(
                    color: AppColors.bodyBg,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    return Row(
      children: [
        Expanded(child: _tabButton('All', 0)),
        SizedBox(width: 10.w),
        Expanded(child: _tabButton('Collectors', 1)),
        SizedBox(width: 10.w),
        Expanded(child: _tabButton('Dealers', 2)),
      ],
    );
  }

  Widget _tabButton(String label, int index) {
    final selected = _selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.userTabActiveBg
              : AppColors.userTabInactiveBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.userTabBorder),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.semiBoldSmall.copyWith(
              color: selected ? AppColors.bodyBg : AppColors.lightText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _userCard(_UserCardData user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999.r),
                child: Image.asset(
                  user.imageAsset,
                  width: 46.w,
                  height: 46.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyles.semiBoldMedium.copyWith(
                        color: AppColors.gradientColor1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      user.email,
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              ),
              _userActionsMenu(user),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _roleChip(user.role),
              _statusChip(user.status),
              _verificationChip(user.verification),
              if (user.reports > 0) _reportsChip(user.reports),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roleChip(UserRole role) {
    final color = role == UserRole.collector
        ? AppColors.tagCollector
        : AppColors.tagDealer;
    final label = role == UserRole.collector ? 'Collector' : 'Dealer';

    return _outlinedChip(label, color);
  }

  Widget _statusChip(UserStatus status) {
    if (status == UserStatus.suspended) {
      return _filledChip('Suspended', AppColors.tagReports);
    }

    return _filledChip('Active', AppColors.tagActive);
  }

  Widget _verificationChip(VerificationStatus status) {
    if (status == VerificationStatus.pending) {
      return _filledChip('Pending', AppColors.tagPending);
    }

    return _filledChip('Verified', AppColors.tagVerified, showCheck: true);
  }

  Widget _reportsChip(int count) {
    return _filledChip('$count Reports', AppColors.tagReports);
  }

  Widget _outlinedChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyles.semiBoldExtraSmall.copyWith(
          color: color,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _filledChip(String label, Color color, {bool showCheck = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showCheck) ...[
            Icon(Icons.check_rounded, size: 12.sp, color: AppColors.bodyBg),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: TextStyles.semiBoldExtraSmall.copyWith(
              color: AppColors.bodyBg,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userActionsMenu(_UserCardData user) {
    return PopupMenuButton<_UserAction>(
      padding: EdgeInsets.zero,
      color: AppColors.bodyBg,
      elevation: 6,
      offset: Offset(-6.w, 28.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      constraints: BoxConstraints(minWidth: 128.w),
      onSelected: (action) => _handleUserAction(action, user),
      itemBuilder: (context) {
        return [
          _actionMenuItem(
            action: _UserAction.viewDetails,
            icon: Icons.visibility_outlined,
            label: 'View Details',
            color: AppColors.lightText,
          ),
          _actionMenuItem(
            action: _UserAction.approve,
            icon: Icons.check_circle_outline,
            label: 'Approve',
            color: AppColors.quickActionGreenText,
          ),
          _actionMenuItem(
            action: _UserAction.suspend,
            icon: Icons.cancel_outlined,
            label: 'Suspend',
            color: AppColors.tagReports,
          ),
        ];
      },
      child: Icon(Icons.more_vert, color: AppColors.lightText, size: 20.sp),
    );
  }

  PopupMenuItem<_UserAction> _actionMenuItem({
    required _UserAction action,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return PopupMenuItem<_UserAction>(
      value: action,
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyles.regularExtraSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  void _handleUserAction(_UserAction action, _UserCardData user) {
    switch (action) {
      case _UserAction.viewDetails:
        context.push('/admin/users/details', extra: user.detailsData);
      case _UserAction.approve:
        _showApproveUserSheet(user);
      case _UserAction.suspend:
        _showSuspendUserSheet(user);
    }
  }

  Future<void> _showApproveUserSheet(_UserCardData user) async {
    final approved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ApproveUserSheet(user: user),
    );

    if (approved != true) return;
    _updateUser(
      user,
      user.copyWith(
        status: UserStatus.active,
        verification: VerificationStatus.verified,
      ),
    );
  }

  Future<void> _showSuspendUserSheet(_UserCardData user) async {
    final suspended = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SuspendUserSheet(userName: user.name),
    );

    if (suspended != true) return;
    _updateUser(user, user.copyWith(status: UserStatus.suspended));
  }

  void _updateUser(_UserCardData currentUser, _UserCardData updatedUser) {
    final index = _users.indexOf(currentUser);
    if (index == -1) return;

    setState(() {
      _users[index] = updatedUser;
    });
  }

  List<_UserCardData> _filteredUsers() {
    if (_selectedTab == 1) {
      return _users.where((user) => user.role == UserRole.collector).toList();
    }
    if (_selectedTab == 2) {
      return _users.where((user) => user.role == UserRole.dealer).toList();
    }
    return _users;
  }
}

class _ApproveUserSheet extends StatelessWidget {
  final _UserCardData user;

  const _ApproveUserSheet({required this.user});

  @override
  Widget build(BuildContext context) {
    final role = user.role == UserRole.collector ? 'Collector' : 'Dealer';

    return _UserActionSheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFDDFBE7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: const Color(0xFF16A34A),
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Approve User?',
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.lightText,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Grant full platform access',
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              ),
              _SheetCloseButton(onTap: () => context.pop(false)),
            ],
          ),
          SizedBox(height: 32.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(17.w, 17.h, 17.w, 17.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FFF4),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFB8F2C7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyles.boldMedium.copyWith(
                    color: const Color(0xFF14532D),
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  user.email,
                  style: TextStyles.regularMedium.copyWith(
                    color: const Color(0xFF15803D),
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 7.h),
                RichText(
                  text: TextSpan(
                    style: TextStyles.regularSmall.copyWith(
                      color: const Color(0xFF166534),
                    ),
                    children: [
                      const TextSpan(text: 'Role: '),
                      TextSpan(
                        text: role,
                        style: TextStyles.boldSmall.copyWith(
                          color: const Color(0xFF166534),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What happens next:',
                  style: TextStyles.boldSmall.copyWith(
                    color: const Color(0xFF1E3A8A),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                _ApproveInfoRow(
                  icon: Icons.check_circle_outline,
                  text: 'User account status will change to ',
                  boldText: 'Active',
                ),
                SizedBox(height: 10.h),
                _ApproveInfoRow(
                  icon: Icons.mail_outline,
                  text: 'Welcome email will be sent with account details',
                ),
                SizedBox(height: 10.h),
                _ApproveInfoRow(
                  icon: Icons.notifications_none,
                  text: 'User will receive push notification of approval',
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(15.w, 14.h, 15.w, 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: const Color(0xFFEAB308),
                  size: 14.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyles.regularExtraSmall.copyWith(
                        color: AppColors.lightText.withValues(alpha: 0.82),
                        height: 1.3,
                      ),
                      children: [
                        TextSpan(
                          text: 'Note: ',
                          style: TextStyles.boldExtraSmall.copyWith(
                            color: AppColors.lightText.withValues(alpha: 0.82),
                          ),
                        ),
                        const TextSpan(
                          text:
                              'The user will gain full access to marketplace features including buying, selling, and community participation based on their role.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          _SheetPrimaryButton(
            label: 'Yes, Approve User',
            color: const Color(0xFF05A83B),
            onPressed: () => context.pop(true),
          ),
          SizedBox(height: 10.h),
          _SheetSecondaryButton(
            label: 'Cancel',
            onPressed: () => context.pop(false),
          ),
        ],
      ),
    );
  }
}

class _ApproveInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? boldText;

  const _ApproveInfoRow({
    required this.icon,
    required this.text,
    this.boldText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF2563EB), size: 16.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyles.regularSmall.copyWith(
                color: const Color(0xFF1D4ED8),
                height: 1.25,
              ),
              children: [
                TextSpan(text: text),
                if (boldText != null)
                  TextSpan(
                    text: boldText,
                    style: TextStyles.boldSmall.copyWith(
                      color: const Color(0xFF1E40AF),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SuspendUserSheet extends StatelessWidget {
  final String userName;

  const _SuspendUserSheet({required this.userName});

  @override
  Widget build(BuildContext context) {
    return _UserActionSheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.tagReports,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Suspend User',
                  style: TextStyles.boldMedium.copyWith(
                    color: AppColors.tagReports,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              _SheetCloseButton(onTap: () => context.pop(false)),
            ],
          ),
          SizedBox(height: 24.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7F7),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFFFB9B9)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Icon(
                    Icons.cancel_outlined,
                    color: AppColors.tagReports,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Warning',
                        style: TextStyles.boldSmall.copyWith(
                          color: const Color(0xFF9B1C1C),
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'You are about to suspend  $userName\nThis will temporarily restrict their account access.',
                        style: TextStyles.regularExtraSmall.copyWith(
                          color: const Color(0xFFDC2626),
                          fontSize: 12.sp,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _SheetLabel('Suspension Duration'),
          SizedBox(height: 8.h),
          _durationField(),
          SizedBox(height: 16.h),
          _SheetLabel('Reason for Suspension'),
          SizedBox(height: 8.h),
          _reasonField(),
          SizedBox(height: 12.h),
          _SheetPrimaryButton(
            label: 'Suspend User',
            color: const Color(0xFFF47781),
            icon: Icons.cancel_outlined,
            onPressed: () => context.pop(true),
          ),
          SizedBox(height: 9.h),
          _SheetSecondaryButton(
            label: 'Cancel',
            onPressed: () => context.pop(false),
          ),
        ],
      ),
    );
  }

  Widget _durationField() {
    return Container(
      width: double.infinity,
      height: 54.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '7 Days',
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.lightText,
                fontSize: 15.sp,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.greyText,
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _reasonField() {
    return SizedBox(
      height: 138.h,
      child: TextField(
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: 'Provide a detailed reason for this suspension...',
          hintStyle: TextStyles.regularMedium.copyWith(
            color: const Color(0xFF7B8190),
            fontSize: 16.sp,
          ),
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          contentPadding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _UserActionSheetFrame extends StatelessWidget {
  final Widget child;

  const _UserActionSheetFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final maxSheetHeight = MediaQuery.sizeOf(context).height * 0.68;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: maxSheetHeight),
        padding: EdgeInsets.fromLTRB(36.w, 28.h, 36.w, 24.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.18),
              blurRadius: 28,
              spreadRadius: -10,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SheetCloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SheetCloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(
          Icons.close_rounded,
          color: AppColors.greyText,
          size: 17.sp,
        ),
      ),
    );
  }
}

class _SheetLabel extends StatelessWidget {
  final String text;

  const _SheetLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.regularMedium.copyWith(
        color: AppColors.lightText,
        fontSize: 15.sp,
      ),
    );
  }
}

class _SheetPrimaryButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final VoidCallback onPressed;

  const _SheetPrimaryButton({
    required this.label,
    required this.color,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 51.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon == null
            ? const SizedBox.shrink()
            : Icon(icon, color: AppColors.bodyBg, size: 15.sp),
        label: Text(
          label,
          style: TextStyles.boldMedium.copyWith(
            color: AppColors.bodyBg,
            fontSize: 16.sp,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
      ),
    );
  }
}

class _SheetSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _SheetSecondaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 53.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.cardBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyles.regularMedium.copyWith(
            color: AppColors.lightText,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}

enum UserRole { collector, dealer }

enum UserStatus { active, suspended }

enum VerificationStatus { pending, verified }

enum _UserAction { viewDetails, approve, suspend }

class _UserCardData {
  final String name;
  final String email;
  final String imageAsset;
  final UserRole role;
  final UserStatus status;
  final VerificationStatus verification;
  final int reports;

  const _UserCardData({
    required this.name,
    required this.email,
    required this.imageAsset,
    required this.role,
    required this.status,
    required this.verification,
    this.reports = 0,
  });

  _UserCardData copyWith({
    String? name,
    String? email,
    String? imageAsset,
    UserRole? role,
    UserStatus? status,
    VerificationStatus? verification,
    int? reports,
  }) {
    return _UserCardData(
      name: name ?? this.name,
      email: email ?? this.email,
      imageAsset: imageAsset ?? this.imageAsset,
      role: role ?? this.role,
      status: status ?? this.status,
      verification: verification ?? this.verification,
      reports: reports ?? this.reports,
    );
  }

  UserDetailsData get detailsData {
    return UserDetailsData(
      name: name,
      email: email,
      imageAsset: imageAsset,
      role: role == UserRole.collector ? 'Collector' : 'Dealer',
      status: verification == VerificationStatus.pending
          ? 'Pending'
          : 'Verified',
      verified: verification == VerificationStatus.verified,
    );
  }
}
