import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vintage_app/core/components/global_footer/footer_config.dart';
import 'package:vintage_app/core/components/global_footer/global_footer.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/services/auth_service.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AppSettingsView extends StatefulWidget {
  const AppSettingsView({super.key});

  @override
  State<AppSettingsView> createState() => _AppSettingsViewState();
}

class _AppSettingsViewState extends State<AppSettingsView> {
  final AuthService _authService = AuthService();

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return 'Time: N/A';
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return 'Time: $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
                style: TextStyles.boldTitle.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 25.sp,
                  height: 1.05,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Manage Account',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldSmall.copyWith(
                  color: const Color(0xffF8E8C7),
                  fontSize: 15.sp,
                  height: 1.1,
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
            user != null
                ? StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('admins')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      Map<String, dynamic>? adminData;
                      if (snapshot.hasData && snapshot.data!.exists) {
                        adminData = snapshot.data!.data() as Map<String, dynamic>?;
                      }

                      final name = adminData?['name'] ?? user.displayName ?? 'System Admin';
                      final role = adminData?['role'] ?? 'Super Admin';
                      final email = user.email ?? adminData?['email'] ?? 'admin@vintagevinne.com';
                      final phone = adminData?['phone'] ?? '+1 (555) 000-0000';

                      DateTime? joinedDate = user.metadata.creationTime;
                      if (adminData?['createdAt'] is Timestamp) {
                        joinedDate = (adminData!['createdAt'] as Timestamp).toDate();
                      }

                      DateTime? lastLoginDate = user.metadata.lastSignInTime;
                      if (adminData?['lastLoginAt'] is Timestamp) {
                        lastLoginDate = (adminData!['lastLoginAt'] as Timestamp).toDate();
                      }

                      return _profileCard(
                        context: context,
                        name: name,
                        role: role,
                        email: email,
                        phone: phone,
                        joinedDateStr: _formatDate(joinedDate),
                        joinedTimeStr: _formatTime(joinedDate),
                        lastLoginDateStr: _formatDate(lastLoginDate),
                        lastLoginTimeStr: _formatTime(lastLoginDate),
                      );
                    },
                  )
                : _profileCard(
                    context: context,
                    name: 'System Admin',
                    role: 'Super Admin',
                    email: 'admin@vintagevinne.com',
                    phone: '+1 (555) 000-0000',
                    joinedDateStr: 'January 15, 2024',
                    joinedTimeStr: 'Time: 10:45 AM',
                    lastLoginDateStr: 'January 30, 2026',
                    lastLoginTimeStr: 'Time: 10:45 AM',
                  ),
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
              svgPath: 'assets/icons/lock_icon.svg',
              iconColor: const Color(0xFFAF5CFF),
              iconBg: const Color(0xFFF9F0FF),
              title: 'Change Password',
              subtitle: 'Update your security credentials',
              onTap: () => context.push('/dealer/app-settings/change-password'),
            ),
            SizedBox(height: 7.h),
            _settingsTile(
              text: '\$',
              iconColor: const Color(0xFF20B957),
              iconBg: const Color(0xFFEFFCF4),
              title: 'Payment Management',
              subtitle: 'Balance, cards & transactions',
              onTap: () => context.push('/dealer/wallet'),
            ),
            SizedBox(height: 7.h),
            _settingsTile(
              svgPath: 'assets/icons/escrow_icon.svg',
              iconColor: const Color(0xFF7A6CFF),
              iconBg: const Color(0xFFF1F1FF),
              title: 'Escrow Sales',
              subtitle: 'Manage platform transactions',
              onTap: () => context.push('/dealer/wallet/escrow-payments'),
            ),
            SizedBox(height: 7.h),
            _settingsTile(
              svgPath: 'assets/icons/admin_nav_settings.svg',
              iconColor: const Color(0xFF22C55E),
              iconBg: const Color(0xFFF0FDF4),
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

  Widget _profileCard({
    required BuildContext context,
    required String name,
    required String role,
    required String email,
    required String phone,
    required String joinedDateStr,
    required String joinedTimeStr,
    required String lastLoginDateStr,
    required String lastLoginTimeStr,
  }) {
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
                      name,
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
                        role,
                        style: TextStyles.semiBoldExtraSmall.copyWith(
                          color: AppColors.bodyBg,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _profileInfoLine(
                      icon: Icons.mail_outline_rounded,
                      text: email,
                    ),
                    SizedBox(height: 4.h),
                    _profileInfoLine(
                      icon: Icons.phone_outlined,
                      text: phone,
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
                    date: joinedDateStr,
                    time: joinedTimeStr,
                    color: const Color(0xFF4F79FF),
                  ),
                ),
                Container(width: 1.w, height: 48.h, color: Colors.white),
                Expanded(
                  child: _dateBlock(
                    icon: Icons.shield_outlined,
                    label: 'Last Login',
                    date: lastLoginDateStr,
                    time: lastLoginTimeStr,
                    color: const Color(0xFF8200DB),
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
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(6.w, 10.h, 6.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 14.sp, color: color),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyles.boldExtraSmall.copyWith(
                  color: color,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(left: 0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
    String? text,
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
                    : text != null
                        ? Center(
                            child: Text(
                              text,
                              style: TextStyles.boldLarge.copyWith(
                                color: iconColor,
                                fontSize: 20.sp,
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
      onTap: () async {
        await _authService.signOut();
        if (context.mounted) {
          context.go('/login');
        }
      },
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
