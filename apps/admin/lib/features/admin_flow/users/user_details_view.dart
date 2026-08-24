import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class UserDetailsData {
  final String name;
  final String email;
  final String imageAsset;
  final String role;
  final String status;
  final bool verified;

  const UserDetailsData({
    required this.name,
    required this.email,
    required this.imageAsset,
    required this.role,
    required this.status,
    required this.verified,
  });

  static const fallback = UserDetailsData(
    name: 'Sarah Dealer',
    email: 'sarah@example.com',
    imageAsset: 'assets/images/user.jpg',
    role: 'Dealer',
    status: 'Pending',
    verified: false,
  );
}

class UserDetailsView extends StatelessWidget {
  final UserDetailsData user;

  const UserDetailsView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFD),
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'User Details',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 24.sp,
            ),
          ),
          height: 142.h,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 112.h),
              child: Column(
                children: [
                  _profileCard(),
                  SizedBox(height: 14.h),
                  _contactCard(),
                  SizedBox(height: 14.h),
                  _statisticsCard(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _bottomActions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard() {
    return _card(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              user.imageAsset,
              width: 66.w,
              height: 66.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.boldMedium.copyWith(
                    color: AppColors.gradientColor1,
                    fontSize: 19.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _tinyChip(
                      user.role,
                      bgColor: AppColors.bodyBg,
                      textColor: AppColors.lightText,
                      borderColor: AppColors.cardBorder,
                      icon: Icons.storefront_outlined,
                    ),
                    SizedBox(width: 8.w),
                    _tinyChip(
                      user.status,
                      bgColor: user.verified
                          ? AppColors.tagVerified
                          : AppColors.tagPending,
                      textColor: AppColors.bodyBg,
                      borderColor: Colors.transparent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.person_outline, 'Contact Information'),
          SizedBox(height: 22.h),
          _infoRowSvg('assets/icons/mail_icon.svg', user.email),
          SizedBox(height: 12.h),
          _infoRowSvg('assets/icons/phone_icon.svg', '+1 (555) 234-5678'),
          SizedBox(height: 12.h),
          _infoRowSvg('assets/icons/location_marker_icon.svg', 'Los Angeles, CA'),
          SizedBox(height: 12.h),
          _infoRow(Icons.calendar_today_outlined, 'Joined Jan 20, 2026'),
        ],
      ),
    );
  }


  Widget _statisticsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.person_outline, 'Dealer Statistics'),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _statBox(
                  icon: Icons.hexagon_outlined,
                  label: 'Total Listings',
                  value: '24',
                  bgColor: const Color(0xFFF6EFFB),
                  accentColor: const Color(0xFF8B3FD8),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _statBox(
                  icon: Icons.trending_up,
                  label: 'Total Sales',
                  value: '18',
                  bgColor: const Color(0xFFEFF9F1),
                  accentColor: const Color(0xFF16803D),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            height: 42.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEA),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 19.sp,
                  color: const Color(0xFFE7A600),
                ),
                SizedBox(width: 8.w),
                Text(
                  '4.8 / 5.0 Rating',
                  style: TextStyles.semiBoldExtraSmall.copyWith(
                    color: AppColors.lightText.withValues(alpha: 0.78),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Text(
                'Specialization:',
                style: TextStyles.semiBoldExtraSmall.copyWith(
                  color: AppColors.lightText.withValues(alpha: 0.78),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Antique Cameras',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.regularExtraSmall.copyWith(
                    color: AppColors.greyText,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomActions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      decoration: const BoxDecoration(
        color: AppColors.bodyBg,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52.h,
                child: ElevatedButton.icon(
                  onPressed: () => context.push(
                    '/single_message',
                    extra: {'name': user.name, 'subtitle': user.role},
                  ),
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    size: 20.sp,
                    color: AppColors.bodyBg,
                  ),
                  label: Text(
                    'Send Message',
                    style: TextStyles.semiBoldExtraSmall.copyWith(
                      color: AppColors.bodyBg,
                      fontSize: 15.sp,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.gradientColor1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: SizedBox(
                height: 52.h,
                child: OutlinedButton.icon(
                  onPressed: () => _showSuspendUserSheet(context),
                  icon: Icon(
                    Icons.cancel_outlined,
                    size: 18.sp,
                    color: AppColors.tagReports,
                  ),
                  label: Text(
                    'Suspend User',
                    style: TextStyles.semiBoldExtraSmall.copyWith(
                      color: AppColors.tagReports,
                      fontSize: 15.sp,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.tagReports),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSuspendUserSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SuspendUserSheet(userName: user.name),
    );
  }

  Widget _card({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/profile_icon.svg',
          width: 22.w,
          height: 22.w,
          colorFilter: const ColorFilter.mode(
            Color(0xFF3B82F6),
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyles.boldMedium.copyWith(
            color: AppColors.gradientColor1,
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }

  Widget _infoRowSvg(String svgPath, String text) {
    return Row(
      children: [
        SvgPicture.asset(
          svgPath,
          width: 18.w,
          height: 18.w,
          colorFilter: const ColorFilter.mode(
            AppColors.greyText,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularExtraSmall.copyWith(
              color: AppColors.lightText.withValues(alpha: 0.72),
              fontSize: 15.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {

    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.greyText),
        SizedBox(width: 14.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularExtraSmall.copyWith(
              color: AppColors.lightText.withValues(alpha: 0.72),
              fontSize: 15.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tinyChip(
    String label, {
    required Color bgColor,
    required Color textColor,
    required Color borderColor,
    IconData? icon,
  }) {
    return Container(
      height: 26.h,
      padding: EdgeInsets.symmetric(horizontal: 9.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.sp, color: textColor),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: TextStyles.regularExtraSmall.copyWith(
              color: textColor,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox({
    required IconData icon,
    required String label,
    required String value,
    required Color bgColor,
    required Color accentColor,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: 80.h),
      padding: EdgeInsets.fromLTRB(10.w, 9.h, 8.w, 9.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15.sp, color: accentColor),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.semiBoldExtraSmall.copyWith(
                    color: accentColor,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyles.boldLarge.copyWith(
              color: accentColor,
              fontSize: 26.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuspendUserSheet extends StatelessWidget {
  final String userName;

  const _SuspendUserSheet({required this.userName});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final maxSheetHeight = MediaQuery.sizeOf(context).height * 0.68;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: maxSheetHeight),
        padding: EdgeInsets.fromLTRB(36.w, 28.h, 36.w, 40.h),
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
                    GestureDetector(
                      onTap: () => context.pop(),
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
                    ),
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
                _sheetLabel('Suspension Duration'),
                SizedBox(height: 8.h),
                _durationField(),
                SizedBox(height: 16.h),
                _sheetLabel('Reason for Suspension'),
                SizedBox(height: 8.h),
                _reasonField(),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 51.h,
                  child: ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: AppColors.bodyBg,
                      size: 15.sp,
                    ),
                    label: Text(
                      'Suspend User',
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.bodyBg,
                        fontSize: 16.sp,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFF47781),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 9.h),
                SizedBox(
                  width: double.infinity,
                  height: 53.h,
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.cardBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.lightText,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sheetLabel(String text) {
    return Text(
      text,
      style: TextStyles.regularMedium.copyWith(
        color: AppColors.lightText,
        fontSize: 15.sp,
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
