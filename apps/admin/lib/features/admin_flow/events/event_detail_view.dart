import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/api_service.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/admin_flow/events/widgets/cancel_event_sheet.dart';

class EventDetailView extends StatefulWidget {
  final String eventId;

  const EventDetailView({super.key, required this.eventId});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _event;

  @override
  void initState() {
    super.initState();
    _fetchEventDetails();
  }

  Future<void> _fetchEventDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await ApiService.get('/api/v1/events/${widget.eventId}');
      if (res is Map && res.containsKey('event') && res['event'] is Map) {
        if (mounted) {
          setState(() {
            _event = Map<String, dynamic>.from(res['event']);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _event = null;
            _errorMessage = 'Event not found';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching event details: $e');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String _formatDateText(String? start, String? end) {
    if ((start == null || start.isEmpty || start == 'TBD') &&
        (end == null || end.isEmpty || end == 'TBD')) {
      return 'Date to be announced';
    }
    if (start != null && start.isNotEmpty && (end == null || end.isEmpty || end == 'TBD')) {
      return start;
    }
    if (start != null && end != null) {
      return '$start\nto $end';
    }
    return 'Flexible / Ongoing';
  }

  String _formatTimeText(String? start, String? end) {
    if ((start == null || start.isEmpty || start == 'TBD') &&
        (end == null || end.isEmpty || end == 'TBD')) {
      return 'Flexible time';
    }
    if (start != null && start.isNotEmpty && end != null && end.isNotEmpty && end != 'TBD') {
      return '$start - $end';
    }
    return start ?? 'All day';
  }

  @override
  Widget build(BuildContext context) {
    final title = _event?['title'] ?? 'Event Details';
    final eventType = _event?['event_type'] ?? 'General';
    final status = _event?['status'] ?? 'Upcoming';
    final description = (_event?['description'] != null && _event!['description'].toString().isNotEmpty)
        ? _event!['description'].toString()
        : 'No description provided for this event.';
    final location = (_event?['location'] != null && _event!['location'].toString().isNotEmpty)
        ? _event!['location'].toString()
        : (_event?['is_virtual'] == true ? 'Online Virtual Event' : 'TBD');
    final dateText = _formatDateText(_event?['start_date'], _event?['end_date']);
    final timeText = _formatTimeText(_event?['start_time'], _event?['end_time']);
    final participantsCount = _event?['participants_count'] ?? 0;
    final rewardPoints = _event?['reward_points'] ?? 500;

    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 18.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
      body: _isLoading
          ? Center(
              child: JumpingDotsProgress(
                text: 'Loading Event Details',
                textStyle: TextStyles.semiBoldMedium.copyWith(
                  color: AppColors.lightText,
                ),
                dotColor: AppColors.gradientColor1,
              ),
            )
          : _errorMessage != null && _event == null
              ? _errorView()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(19.w, 14.h, 19.w, 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _EventTitleCard(
                              title: title,
                              eventType: eventType,
                              status: status,
                            ),
                            SizedBox(height: 16.h),
                            _sectionTitle('Description'),
                            SizedBox(height: 7.h),
                            Text(
                              description,
                              style: TextStyles.regularSmall.copyWith(
                                color: AppColors.eventMetaText,
                                fontSize: 13.sp,
                                height: 1.4,
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
                            _EventInfoCard(
                              icon: Icons.calendar_month_outlined,
                              iconBg: AppColors.eventDetailBlueBg,
                              iconColor: AppColors.eventDetailBlue,
                              label: 'Date',
                              value: dateText,
                            ),
                            SizedBox(height: 10.h),
                            _EventInfoCard(
                              icon: Icons.access_time_rounded,
                              iconBg: AppColors.eventDetailPurpleBg,
                              iconColor: AppColors.eventDetailPurple,
                              label: 'Time',
                              value: timeText,
                            ),
                            SizedBox(height: 10.h),
                            _EventInfoCard(
                              svgPath: 'assets/icons/location_marker_icon.svg',
                              iconBg: AppColors.eventDetailGreenBg,
                              iconColor: AppColors.eventDetailGreen,
                              label: 'Location',
                              value: location,
                            ),
                            SizedBox(height: 10.h),
                            _EventInfoCard(
                              svgPath: 'assets/icons/participant_icon.svg',
                              iconBg: AppColors.eventDetailOrangeBg,
                              iconColor: AppColors.eventDetailOrange,
                              label: 'Participants',
                              value: '$participantsCount registered / Unlimited',
                            ),
                            SizedBox(height: 10.h),
                            _EventInfoCard(
                              svgPath: 'assets/icons/reward_icon.svg',
                              iconBg: AppColors.eventDetailYellowBg,
                              iconColor: AppColors.eventDetailYellow,
                              label: 'Reward',
                              value: '$rewardPoints Points',
                            ),
                            SizedBox(height: 15.h),
                            Row(
                              children: [
                                Expanded(child: _ShareActionButton(eventTitle: title)),
                                SizedBox(width: 7.w),
                                Expanded(
                                  child: _ActionButton(
                                    label: 'Cancel',
                                    icon: Icons.delete_outline_rounded,
                                    color: AppColors.eventDanger,
                                    borderColor: AppColors.eventDanger,
                                    onTap: () => _showCancelEventSheet(
                                      context,
                                      title,
                                      participantsCount,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _EditEventBar(
                        eventId: widget.eventId,
                        onEditReturned: _fetchEventDetails,
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48.sp, color: AppColors.eventPink),
            SizedBox(height: 12.h),
            Text(
              'Failed to load event details',
              style: TextStyles.boldMedium.copyWith(color: AppColors.lightText),
            ),
            SizedBox(height: 6.h),
            Text(
              _errorMessage ?? '',
              textAlign: TextAlign.center,
              style: TextStyles.regularSmall.copyWith(color: AppColors.greyText),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _fetchEventDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gradientColor1,
              ),
              child: Text(
                'Retry',
                style: TextStyles.semiBoldSmall.copyWith(color: AppColors.bodyBg),
              ),
            ),
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

  Future<void> _showCancelEventSheet(
    BuildContext context,
    String eventTitle,
    int participantsCount,
  ) {
    return showEventCancelSheet(
      context,
      eventId: widget.eventId,
      eventTitle: eventTitle,
      participantsCount: participantsCount,
      onCancelled: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}

class _EventTitleCard extends StatelessWidget {
  final String title;
  final String eventType;
  final String status;

  const _EventTitleCard({
    required this.title,
    required this.eventType,
    required this.status,
  });

  Color _badgeColor(String status) {
    final s = status.toLowerCase();
    if (s == 'ongoing') {
      return AppColors.eventOngoing;
    } else if (s == 'past') {
      return AppColors.eventAmber;
    }
    return AppColors.eventDetailBlue;
  }

  @override
  Widget build(BuildContext context) {
    final badgeBg = _badgeColor(status);

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
                  title,
                  style: TextStyles.boldSmall.copyWith(
                    color: AppColors.bodyBg,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  eventType,
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
              color: badgeBg,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Text(
              status,
              style: TextStyles.boldExtraSmall.copyWith(
                color: AppColors.bodyBg,
                fontSize: 11.sp,
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
                SizedBox(height: 8.h),
                Text(
                  value,
                  style: TextStyles.boldSmall.copyWith(
                    color: AppColors.gradientColor1,
                    fontSize: 14.sp,
                    height: 1.5,
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
  final String eventTitle;

  const _ShareActionButton({required this.eventTitle});

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

    final selected = await showMenu<_ShareOption>(
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

    if (selected != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sharing "$eventTitle"...'),
          backgroundColor: AppColors.gradientColor1,
        ),
      );
    }
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
  final VoidCallback? onEditReturned;

  const _EditEventBar({required this.eventId, this.onEditReturned});

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
          onTap: () async {
            await context.push('/events/$eventId/edit');
            onEditReturned?.call();
          },
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
