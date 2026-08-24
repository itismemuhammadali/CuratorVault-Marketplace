import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/global_footer/footer_config.dart';
import 'package:vintage_app/core/components/global_footer/global_footer.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/admin_flow/events/widgets/cancel_event_sheet.dart';

class AllEventsView extends StatefulWidget {
  const AllEventsView({super.key});

  @override
  State<AllEventsView> createState() => _AllEventsViewState();
}

class _AllEventsViewState extends State<AllEventsView> {
  int _selectedTab = 0;

  final List<_EventData> _events = const [
    _EventData(
      id: '1',
      title: 'Downtown AR Treasure Hunt',
      label: 'AR Hunt',
      location: 'Downtown District',
      dateText: '2/1/2026 - 2/3/2026',
      participantsText: '145 participants',
      rewardText: 'Reward: 500 Points',
      accentColor: AppColors.eventPink,
      backgroundColor: AppColors.eventPinkBg,
      status: _EventStatus.upcoming,
    ),
    _EventData(
      id: '2',
      title: 'Historical Landmark Tour',
      label: 'Landmark Adventure',
      location: 'Old Town',
      dateText: '4/10/2026 - 4/12/2026',
      participantsText: '120 participants',
      rewardText: 'Reward: 400 Points',
      accentColor: AppColors.eventGreen,
      backgroundColor: AppColors.eventGreenBg,
      status: _EventStatus.upcoming,
    ),
    _EventData(
      id: '3',
      title: 'Collectors Market Walk',
      label: 'Live Event',
      location: 'Vintage Quarter',
      dateText: '4/13/2026 - 4/14/2026',
      participantsText: '98 participants',
      rewardText: 'Reward: 350 Points',
      accentColor: AppColors.eventOngoing,
      backgroundColor: AppColors.eventOngoingBg,
      status: _EventStatus.ongoing,
    ),
    _EventData(
      id: '4',
      title: 'Antique Showcase Night',
      label: 'Showcase',
      location: 'Heritage Hall',
      dateText: '1/18/2026 - 1/19/2026',
      participantsText: '210 participants',
      rewardText: 'Reward: 300 Points',
      accentColor: AppColors.eventAmber,
      backgroundColor: AppColors.eventAmberBg,
      status: _EventStatus.past,
    ),
  ];

  List<_EventData> get _visibleEvents {
    final status = _EventStatus.values[_selectedTab];
    return _events.where((event) => event.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events',
                style: TextStyles.boldTitle.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'Manage events',
                style: TextStyles.semiBoldMedium.copyWith(
                  color: AppColors.darkText,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          height: 140.h,
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 26.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createEventButton(),
              SizedBox(height: 20.h),
              _tabs(),
              SizedBox(height: 18.h),
              for (final event in _visibleEvents) ...[
                _eventCard(event),
                SizedBox(height: 18.h),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const GlobalFooter(flow: FooterFlow.admin),
    );
  }

  Widget _createEventButton() {
    return GestureDetector(
      onTap: () => context.push('/events/create'),
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.gradientColor1,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.22),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.bodyBg, size: 20.sp),
            SizedBox(width: 10.w),
            Text(
              'Create New Event',
              style: TextStyles.semiBoldMedium.copyWith(
                color: AppColors.bodyBg,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.eventTabBorder),
      ),
      child: Row(
        children: [
          Expanded(child: _tabButton('Upcoming', 0)),
          Expanded(child: _tabButton('Ongoing', 1)),
          Expanded(child: _tabButton('Past', 2)),
        ],
      ),
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
        margin: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.gradientColor1 : AppColors.bodyBg,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected
                ? AppColors.gradientColor1
                : AppColors.eventTabBorder,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.boldExtraSmall.copyWith(
              color: selected ? AppColors.bodyBg : AppColors.lightText,
              fontSize: 15.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventCard(_EventData event) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      decoration: BoxDecoration(
        color: event.backgroundColor,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: event.accentColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyles.boldMedium.copyWith(
                    color: AppColors.gradientColor1,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              _eventActionsMenu(event),
            ],
          ),
          SizedBox(height: 7.h),
          _chip(event.label),
          SizedBox(height: 19.h),
          _infoRow('assets/icons/location_marker_icon.svg', event.location),
          SizedBox(height: 11.h),
          _infoRow('assets/icons/admin_nav_events.svg', event.dateText),
          SizedBox(height: 11.h),
          _infoRow('assets/icons/admin_nav_users.svg', event.participantsText),

          SizedBox(height: 20.h),
          Divider(height: 1.h, thickness: 1, color: AppColors.eventCardDivider),
          SizedBox(height: 19.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  event.rewardText,
                  style: TextStyles.mediumExtraSmall.copyWith(
                    color: AppColors.greyText,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/events/${event.id}'),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Text(
                    'View Details',
                    style: TextStyles.boldExtraSmall.copyWith(
                      color: AppColors.gradientColor1,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.eventChipBg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: TextStyles.mediumExtraSmall.copyWith(
          color: AppColors.lightText,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _eventActionsMenu(_EventData event) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) =>
          _showEventActionsMenu(context, event, details.globalPosition),
      child: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Icon(Icons.more_vert, color: AppColors.lightText, size: 20.sp),
      ),
    );
  }

  Future<void> _showEventActionsMenu(
    BuildContext context,
    _EventData event,
    Offset tapPosition,
  ) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final menuWidth = 145.w;
    final selected = await showMenu<_EventAction>(
      context: context,
      color: AppColors.bodyBg,
      elevation: 4,
      constraints: BoxConstraints(minWidth: menuWidth, maxWidth: menuWidth),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.r),
        side: BorderSide(color: AppColors.eventTabBorder),
      ),
      position: RelativeRect.fromLTRB(
        tapPosition.dx - menuWidth,
        tapPosition.dy + 4.h,
        overlay.size.width - tapPosition.dx,
        overlay.size.height - tapPosition.dy,
      ),
      items: [
        _eventActionItem(_EventAction.edit, 'Edit Event'),
        _eventActionItem(_EventAction.participants, 'View Participants'),
        _eventActionItem(
          _EventAction.cancel,
          'Cancel Event',
          color: AppColors.eventDanger,
        ),
      ],
    );

    if (selected == null) return;
    _handleEventAction(selected, event);
  }

  PopupMenuItem<_EventAction> _eventActionItem(
    _EventAction action,
    String label, {
    Color? color,
  }) {
    return PopupMenuItem<_EventAction>(
      value: action,
      height: 27.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyles.regularTiny.copyWith(
          color: color ?? AppColors.lightText,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  void _handleEventAction(_EventAction action, _EventData event) {
    switch (action) {
      case _EventAction.edit:
        context.push('/events/${event.id}/edit');
      case _EventAction.participants:
        context.push('/events/${event.id}/participants');
      case _EventAction.cancel:
        showEventCancelSheet(context);
    }
  }

  Widget _infoRow(String svgAsset, String text) {


    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          svgAsset,
          width: 18.sp,
          height: 18.sp,
          colorFilter: const ColorFilter.mode(
            AppColors.eventMetaIcon,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          text,
          style: TextStyles.regularSmall.copyWith(
            color: AppColors.eventMetaText,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

}

class _EventData {
  final String id;
  final String title;
  final String label;
  final String location;
  final String dateText;
  final String participantsText;
  final String rewardText;
  final Color accentColor;
  final Color backgroundColor;
  final _EventStatus status;

  const _EventData({
    required this.id,
    required this.title,
    required this.label,
    required this.location,
    required this.dateText,
    required this.participantsText,
    required this.rewardText,
    required this.accentColor,
    required this.backgroundColor,
    required this.status,
  });
}

enum _EventStatus { upcoming, ongoing, past }

enum _EventAction { edit, participants, cancel }
