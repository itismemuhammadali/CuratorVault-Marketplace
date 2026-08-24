import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/admin_flow/events/widgets/cancel_event_sheet.dart';

class EventDetailView extends StatelessWidget {
  final String eventId;

  const EventDetailView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Event Details',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldTitle.copyWith(
              color: AppColors.bodyBg,
              fontSize: 24.sp,
            ),
          ),
          height: 160.h,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(19.w, 14.h, 19.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _EventTitleCard(),
                  SizedBox(height: 16.h),
                  _sectionTitle('Description'),
                  SizedBox(height: 7.h),
                  Text(
                    'Join the ultimate AR treasure hunt through downtown!\n'
                    'Find hidden vintage items using augmented reality and win\n'
                    'amazing prizes.',
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.eventMetaText,
                      fontSize: 11.sp,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    height: 1.h,
                    thickness: 1,
                    color: AppColors.eventDetailSectionDivider,
                  ),
                  SizedBox(height: 16.h),
                  _sectionTitle('Event Information'),
                  SizedBox(height: 11.h),
                  const _EventInfoCard(
                    icon: Icons.calendar_month_outlined,
                    iconBg: AppColors.eventDetailBlueBg,
                    iconColor: AppColors.eventDetailBlue,
                    label: 'Date',
                    value:
                        'Sunday, February 1, 2026\n'
                        'to Tuesday, February 3, 2026',
                  ),
                  SizedBox(height: 10.h),
                  const _EventInfoCard(
                    icon: Icons.access_time_rounded,
                    iconBg: AppColors.eventDetailPurpleBg,
                    iconColor: AppColors.eventDetailPurple,
                    label: 'Time',
                    value: '10:00 AM - 6:00 PM',
                  ),
                  SizedBox(height: 10.h),
                  const _EventInfoCard(
                    svgPath: 'assets/icons/location_marker_icon.svg',
                    iconBg: AppColors.eventDetailGreenBg,
                    iconColor: AppColors.eventDetailGreen,
                    label: 'Location',
                    value: 'Downtown District',
                  ),
                  SizedBox(height: 10.h),
                  const _EventInfoCard(
                    svgPath: 'assets/icons/participant_icon.svg',
                    iconBg: AppColors.eventDetailOrangeBg,
                    iconColor: AppColors.eventDetailOrange,
                    label: 'Participants',
                    value: '145 registered / 200 max',
                  ),
                  SizedBox(height: 10.h),
                  const _EventInfoCard(
                    svgPath: 'assets/icons/reward_icon.svg',
                    iconBg: AppColors.eventDetailYellowBg,
                    iconColor: AppColors.eventDetailYellow,
                    label: 'Reward',
                    value: '500 Points',
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(child: _ShareActionButton()),
                      SizedBox(width: 7.w),
                      Expanded(
                        child: _ActionButton(
                          label: 'Cancel',
                          icon: Icons.delete_outline_rounded,
                          color: AppColors.eventDanger,
                          borderColor: AppColors.eventDanger,
                          onTap: () => _showCancelEventSheet(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _EditEventBar(eventId: eventId),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyles.boldSmall.copyWith(
        color: AppColors.gradientColor1,
        fontSize: 14.sp,
      ),
    );
  }

  Future<void> _showCancelEventSheet(BuildContext context) {
    return showEventCancelSheet(context);
  }
}

class _EventTitleCard extends StatelessWidget {
  const _EventTitleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 13.h, 12.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.gradientColor1,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Downtown AR Treasure Hunt',
                  style: TextStyles.boldSmall.copyWith(
                    color: AppColors.bodyBg,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'AR Hunt',
                  style: TextStyles.regularExtraSmall.copyWith(
                    color: AppColors.bodyBg.withValues(alpha: 0.86),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.eventDetailBlue,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Text(
              'Upcoming',
              style: TextStyles.boldExtraSmall.copyWith(
                color: AppColors.bodyBg,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventInfoCard extends StatelessWidget {
  final IconData? icon;
  final String? svgPath;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;

  const _EventInfoCard({
    this.icon,
    this.svgPath,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(13.w, 16.h, 14.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.eventDetailInfoBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: svgPath != null
                ? Padding(
                    padding: EdgeInsets.all(8.r),
                    child: SvgPicture.asset(
                      svgPath!,
                      colorFilter: ColorFilter.mode(
                        iconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyles.regularSmall.copyWith(
                    color: AppColors.eventMetaText,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  value,
                  style: TextStyles.boldSmall.copyWith(
                    color: AppColors.gradientColor1,
                    fontSize: 14.sp,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 39.h,
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 15.sp),
            SizedBox(width: 10.w),
            Text(
              label,
              style: TextStyles.boldExtraSmall.copyWith(
                color: color,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ActionButton(
      label: 'Share',
      icon: Icons.share_outlined,
      color: AppColors.lightText,
      borderColor: AppColors.eventTabBorder,
      onTap: () => _showShareMenu(context),
    );
  }

  Future<void> _showShareMenu(BuildContext context) async {
    final buttonBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final buttonOffset = buttonBox.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final menuHeight = 106.h;

    await showMenu<_ShareOption>(
      context: context,
      color: AppColors.bodyBg,
      elevation: 3,
      constraints: BoxConstraints(
        minWidth: buttonBox.size.width,
        maxWidth: buttonBox.size.width,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.r),
        side: BorderSide(color: AppColors.eventTabBorder),
      ),
      position: RelativeRect.fromLTRB(
        buttonOffset.dx,
        buttonOffset.dy - menuHeight - 4.h,
        overlay.size.width - buttonOffset.dx - buttonBox.size.width,
        overlay.size.height - buttonOffset.dy,
      ),
      items: const [
        _ShareMenuItem(
          value: _ShareOption.copyLink,
          icon: Icons.link_rounded,
          label: 'Copy Link',
        ),
        _ShareMenuItem(
          value: _ShareOption.email,
          icon: Icons.mail_outline_rounded,
          label: 'Share via Email',
        ),
        _ShareMenuItem(
          value: _ShareOption.twitter,
          icon: Icons.alternate_email_rounded,
          label: 'Share on Twitter',
        ),
        _ShareMenuItem(
          value: _ShareOption.facebook,
          icon: Icons.facebook_outlined,
          label: 'Share on Facebook',
        ),
      ],
    );
  }
}

class _ShareMenuItem extends PopupMenuEntry<_ShareOption> {
  final _ShareOption value;
  final IconData icon;
  final String label;

  const _ShareMenuItem({
    required this.value,
    required this.icon,
    required this.label,
  });

  @override
  double get height => 24.h;

  @override
  bool represents(_ShareOption? value) => value == this.value;

  @override
  State<_ShareMenuItem> createState() => _ShareMenuItemState();
}

class _ShareMenuItemState extends State<_ShareMenuItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context, widget.value),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 9.w),
        child: Row(
          children: [
            Icon(widget.icon, color: AppColors.eventMetaText, size: 11.sp),
            SizedBox(width: 8.w),
            Text(
              widget.label,
              style: TextStyles.regularTiny.copyWith(
                color: AppColors.lightText,
                fontSize: 9.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ShareOption { copyLink, email, twitter, facebook }

class _EditEventBar extends StatelessWidget {
  final String eventId;

  const _EditEventBar({required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        border: Border(
          top: BorderSide(color: AppColors.eventDetailSectionDivider),
        ),
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () => context.push('/events/$eventId/edit'),
          child: Container(
            height: 56.h,
            decoration: BoxDecoration(
              color: AppColors.gradientColor1,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/edit_icon2.svg',
                  width: 18.w,
                  height: 18.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xffF8E8C7),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  'Edit Event',
                  style: TextStyles.boldSmall.copyWith(
                    color: AppColors.bodyBg,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
