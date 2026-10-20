import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/icons/icon_box_transparent.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';

import '../../../core/components/global_header/global_header.dart';
import '../../../core/components/global_header/header_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';

import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/api_service.dart';

class AllEventsView extends StatefulWidget {
  const AllEventsView({super.key});

  @override
  State<AllEventsView> createState() => _AllEventsViewState();
}

class _AllEventsViewState extends State<AllEventsView> {
  int _selectedTab = 0;
  List<EventData> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final res = await ApiService.get('/api/v1/events');
      if (res is Map && res.containsKey('events') && res['events'] is List) {
        final rawList = res['events'] as List;
        final parsed = rawList
            .map((item) => EventData.fromJson(Map<String, dynamic>.from(item)))
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
      debugPrint('Error fetching events in dealer app: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<EventData> get _visibleEvents {
    if (_selectedTab == 0) {
      return _events.where((e) => e.status == 'Upcoming' || e.status == 'Ongoing').toList();
    } else if (_selectedTab == 1) {
      return _events.where((e) => e.status == 'Upcoming').toList();
    } else if (_selectedTab == 2) {
      return _events.where((e) => e.status == 'Ongoing').toList();
    } else {
      return _events.where((e) => e.status == 'Past').toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['All', 'Upcoming', 'Ongoing', 'Past'];

    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events',
                style: TextStyles.boldLarge.copyWith(color: AppColors.bodyBg),
              ),
              SizedBox(height: 8.h),
              Text(
                'Explore auctions, workshops & gatherings',
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          height: 194.h,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchEvents,
        color: AppColors.gradientColor1,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    final isSelected = _selectedTab == index;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = index),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.gradientColor1 : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isSelected ? AppColors.gradientColor1 : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            tabs[index],
                            style: TextStyles.mediumSmall.copyWith(
                              color: isSelected ? Colors.white : AppColors.lightText,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16.h),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: JumpingDotsProgress(color: AppColors.gradientColor1),
                  ),
                )
              else if (_visibleEvents.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Column(
                      children: [
                        Icon(Icons.event_busy, size: 48.sp, color: AppColors.greyText),
                        SizedBox(height: 12.h),
                        Text(
                          'No events found in this tab.',
                          style: TextStyles.regularMedium.copyWith(color: AppColors.greyText),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    for (final event in _visibleEvents) ...[
                      EventCard(
                        imageAsset: event.imageAsset,
                        title: event.title,
                        location: event.location,
                        dateText: event.dateText,
                        timeText: event.timeText,
                        joinedText: event.joinedText,
                        difficultyLabel: event.difficultyLabel,
                        status: event.status,
                        onViewDetails: () {
                          context.push('/events/${event.id}');
                        },
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventData {
  final String id;
  final String imageAsset;
  final String title;
  final String location;
  final String dateText;
  final String timeText;
  final String joinedText;
  final String difficultyLabel;
  final String status;

  const EventData({
    required this.id,
    required this.imageAsset,
    required this.title,
    required this.location,
    required this.dateText,
    required this.timeText,
    required this.joinedText,
    required this.difficultyLabel,
    required this.status,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    final startDate = (json['start_date'] ?? json['startDate'] ?? '').toString();
    final endDate = (json['end_date'] ?? json['endDate'] ?? '').toString();
    final startTime = (json['start_time'] ?? json['startTime'] ?? '').toString();
    final endTime = (json['end_time'] ?? json['endTime'] ?? '').toString();
    final participants = json['participants_count'] ?? json['participantsCount'] ?? 0;
    final maxParticipants = json['max_participants'] ?? json['maxParticipants'] ?? 100;

    String dateFormatted = startDate;
    if (endDate.isNotEmpty && endDate != startDate) {
      dateFormatted = '$startDate - $endDate';
    }

    String timeFormatted = startTime;
    if (endTime.isNotEmpty && endTime != startTime) {
      timeFormatted = '$startTime - $endTime';
    }

    return EventData(
      id: (json['id'] ?? '').toString(),
      imageAsset: AppImages.exploreBanner,
      title: (json['title'] ?? 'Vintage Event').toString(),
      location: (json['location'] ?? 'Online / Main Hall').toString(),
      dateText: dateFormatted.isNotEmpty ? dateFormatted : 'Upcoming Date',
      timeText: timeFormatted.isNotEmpty ? timeFormatted : '10:00 AM - 4:00 PM',
      joinedText: '$participants/$maxParticipants joined',
      difficultyLabel: (json['event_type'] ?? json['type'] ?? 'Auction').toString(),
      status: (json['status'] ?? 'Upcoming').toString(),
    );
  }
}

class EventCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String location;
  final String dateText;
  final String timeText;
  final String joinedText;
  final String difficultyLabel;
  final String? status;
  final VoidCallback onViewDetails;

  const EventCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.location,
    required this.dateText,
    required this.timeText,
    required this.joinedText,
    required this.difficultyLabel,
    this.status,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: const Color(0xFFE8E1D6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28.r),
              topRight: Radius.circular(28.r),
            ),
            child: Image.asset(
              imageAsset,
              height: 170.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.semiBoldMedium.copyWith(
                    color: AppColors.lightText,
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                _dataRow(AppImages.mapMarkerOutlinedIcon, location, null),
                SizedBox(height: 8.h),
                _dataRow(AppImages.calenderEmptyIcon, dateText, null),
                SizedBox(height: 8.h),
                _dataRow(AppImages.clockIcon, timeText, null),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dataRow(
                      AppImages.usersIcon,
                      joinedText,
                      AppColors.lightText,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: difficultyLabel == 'Workshop'
                                ? const Color(
                                    0xFF2F80FF,
                                  ).withValues(alpha: 0.12)
                                : const Color(0xFFF0E6FF),
                            borderRadius: BorderRadius.circular(999.r),
                            border: Border.all(
                              color: difficultyLabel == 'Workshop'
                                  ? const Color(
                                      0xFF2F80FF,
                                    ).withValues(alpha: 0.22)
                                  : const Color(
                                      0xFFB56CFF,
                                    ).withValues(alpha: 0.22),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                AppImages.rewardBadgeIcon,
                                width: 14.w,
                                height: 14.h,
                                color: difficultyLabel == 'Workshop'
                                    ? const Color(0xFF2F80FF)
                                    : const Color(0xFFB56CFF),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                difficultyLabel,
                                style: TextStyles.regularSmall.copyWith(
                                  color: difficultyLabel == 'Workshop'
                                      ? const Color(0xFF2F80FF)
                                      : const Color(0xFFB56CFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        CustomButton(
                          onTap: onViewDetails,
                          btnText: 'View Details',
                          height: 40.h,
                          btnColor: const Color(0xFFC85D45),
                          textStyle: TextStyles.mediumMedium.copyWith(
                            color: AppColors.bodyBg,
                            fontSize: 14.sp,
                          ),
                          width: 145.w,
                          borderRadius: 18.r,
                        ),
                      ],
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
}

Widget _dataRow(String icon, String text, Color? textColor) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      IconBoxTransparent(
        icon: icon,
        color: const Color(0xFFC85D45),
        size: 14.h,
      ),
      SizedBox(width: 8.w),
      Text(
        text,
        style: TextStyles.regularExtraSmall.copyWith(
          color: textColor ?? AppColors.greyText,
        ),
      ),
    ],
  );
}
