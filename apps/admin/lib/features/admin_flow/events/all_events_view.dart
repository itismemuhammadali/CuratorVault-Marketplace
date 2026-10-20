import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/global_footer/footer_config.dart';
import 'package:vintage_app/core/components/global_footer/global_footer.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/api_service.dart';
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
  bool _isLoading = true;
  String? _errorMessage;
  List<_EventData> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await ApiService.get('/api/v1/events');
      if (res is Map && res.containsKey('events') && res['events'] is List) {
        final rawList = res['events'] as List;
        final parsed = rawList
            .map((item) => _EventData.fromJson(Map<String, dynamic>.from(item)))
            .toList();

        if (mounted) {
          setState(() {
            _events = parsed;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _events = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching events from backend: $e');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  List<_EventData> get _visibleEvents {
    final status = _EventStatus.values[_selectedTab];
    return _events.where((event) => event.status == status).toList();
  }

  String _tabTitle(int index) {
    switch (index) {
      case 0:
        return 'Upcoming';
      case 1:
        return 'Ongoing';
      case 2:
        return 'Past';
      default:
        return '';
    }
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
        child: RefreshIndicator(
          onRefresh: _fetchEvents,
          color: AppColors.gradientColor1,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 26.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _createEventButton(),
                SizedBox(height: 20.h),
                _tabs(),
                SizedBox(height: 18.h),
                if (_isLoading)
                  Container(
                    height: 220.h,
                    alignment: Alignment.center,
                    child: JumpingDotsProgress(
                      text: 'Loading Events',
                      textStyle: TextStyles.semiBoldMedium.copyWith(
                        color: AppColors.lightText,
                      ),
                      dotColor: AppColors.gradientColor1,
                    ),
                  )
                else if (_errorMessage != null && _events.isEmpty)
                  _errorCard()
                else if (_visibleEvents.isEmpty)
                  _emptyStateCard()
                else
                  for (final event in _visibleEvents) ...[
                    _eventCard(event),
                    SizedBox(height: 18.h),
                  ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const GlobalFooter(flow: FooterFlow.admin),
    );
  }

  Widget _createEventButton() {
    return GestureDetector(
      onTap: () async {
        await context.push('/events/create');
        _fetchEvents();
      },
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

  Widget _emptyStateCard() {
    final tabName = _tabTitle(_selectedTab);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.eventChipBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 48.sp,
            color: AppColors.greyText,
          ),
          SizedBox(height: 12.h),
          Text(
            'No $tabName Events',
            style: TextStyles.boldMedium.copyWith(
              color: AppColors.lightText,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Events categorized as $tabName will appear here.',
            textAlign: TextAlign.center,
            style: TextStyles.regularSmall.copyWith(
              color: AppColors.greyText,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.eventPinkBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.eventPink),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 40.sp, color: AppColors.eventPink),
          SizedBox(height: 10.h),
          Text(
            'Failed to load events',
            style: TextStyles.boldMedium.copyWith(color: AppColors.lightText),
          ),
          SizedBox(height: 6.h),
          Text(
            _errorMessage ?? '',
            textAlign: TextAlign.center,
            style: TextStyles.regularSmall.copyWith(color: AppColors.greyText),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: _fetchEvents,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gradientColor1,
            ),
            child: Text(
              'Retry',
              style: TextStyles.regularSmall.copyWith(color: AppColors.bodyBg),
            ),
          ),
        ],
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

  void _handleEventAction(_EventAction action, _EventData event) async {
    switch (action) {
      case _EventAction.edit:
        await context.push('/events/${event.id}/edit');
        _fetchEvents();
      case _EventAction.participants:
        await context.push('/events/${event.id}/participants');
      case _EventAction.cancel:
        showEventCancelSheet(
          context,
          eventId: event.id,
          eventTitle: event.title,
          onCancelled: _fetchEvents,
        );
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
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularSmall.copyWith(
              color: AppColors.eventMetaText,
              fontSize: 14.sp,
            ),
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

  factory _EventData.fromJson(Map<String, dynamic> json) {
    final statusRaw = (json['status'] ?? '').toString().toLowerCase().trim();
    _EventStatus status;
    if (statusRaw == 'ongoing') {
      status = _EventStatus.ongoing;
    } else if (statusRaw == 'past') {
      status = _EventStatus.past;
    } else if (statusRaw == 'upcoming') {
      status = _EventStatus.upcoming;
    } else {
      status = _parseStatus(json['start_date']?.toString(), json['end_date']?.toString());
    }

    final title = (json['title'] ?? 'Untitled Event').toString();
    final eventType = (json['event_type'] ?? 'General').toString();
    final location = (json['location'] != null && json['location'].toString().isNotEmpty)
        ? json['location'].toString()
        : (json['is_virtual'] == true ? 'Online Virtual Event' : 'TBD');

    final startDate = json['start_date']?.toString() ?? '';
    final endDate = json['end_date']?.toString() ?? '';
    String dateText;
    if (startDate.isNotEmpty && endDate.isNotEmpty && startDate != 'TBD' && endDate != 'TBD') {
      dateText = '$startDate - $endDate';
    } else if (startDate.isNotEmpty && startDate != 'TBD') {
      dateText = startDate;
    } else {
      dateText = 'Flexible / Ongoing';
    }

    final participantsCount = json['participants_count'] ?? 0;
    final reward = json['reward_points'] ?? 500;

    Color accentColor;
    Color backgroundColor;
    switch (status) {
      case _EventStatus.upcoming:
        accentColor = AppColors.eventPink;
        backgroundColor = AppColors.eventPinkBg;
      case _EventStatus.ongoing:
        accentColor = AppColors.eventOngoing;
        backgroundColor = AppColors.eventOngoingBg;
      case _EventStatus.past:
        accentColor = AppColors.eventAmber;
        backgroundColor = AppColors.eventAmberBg;
    }

    return _EventData(
      id: json['id']?.toString() ?? '',
      title: title,
      label: eventType,
      location: location,
      dateText: dateText,
      participantsText: '$participantsCount participants',
      rewardText: 'Reward: $reward Points',
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      status: status,
    );
  }

  static _EventStatus _parseStatus(String? start, String? end) {
    if (start == null || start.isEmpty || start == 'TBD') {
      return _EventStatus.upcoming;
    }
    try {
      final now = DateTime.now();
      DateTime? parse(String s) {
        final parts = s.split('/');
        if (parts.length == 3) {
          final m = int.tryParse(parts[0]);
          final d = int.tryParse(parts[1]);
          final y = int.tryParse(parts[2]);
          if (m != null && d != null && y != null) {
            return DateTime(y, m, d);
          }
        }
        return DateTime.tryParse(s);
      }

      final startDate = parse(start);
      final endDate = end != null ? parse(end) : null;

      final today = DateTime(now.year, now.month, now.day);
      if (startDate != null) {
        final startDay = DateTime(startDate.year, startDate.month, startDate.day);
        if (today.isBefore(startDay)) {
          return _EventStatus.upcoming;
        }
        if (endDate != null) {
          final endDay = DateTime(endDate.year, endDate.month, endDate.day);
          if (today.isAfter(endDay)) {
            return _EventStatus.past;
          }
        }
        return _EventStatus.ongoing;
      }
    } catch (_) {}
    return _EventStatus.upcoming;
  }
}

enum _EventStatus { upcoming, ongoing, past }

enum _EventAction { edit, participants, cancel }
