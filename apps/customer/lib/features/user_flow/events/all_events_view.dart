import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/api_service.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';

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
      debugPrint('Error fetching events in customer app from backend: $e');
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
    final tabs = ['All Events', 'Upcoming', 'Ongoing', 'Past'];

    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.gradientColor2,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconBox(
                        icon: AppImages.backIcon,
                        iconColor: const Color(0xFFF8E8C7),
                        bgColor: const Color(0xFFF8E8C7).withValues(alpha: 0.20),
                        height: 40.h,
                        width: 40.w,
                        borderRadius: 100.r,
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/homeScreen');
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Events',
                    style: TextStyles.boldLarge.copyWith(
                      color: AppColors.bodyBg,
                      fontSize: 28.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Join events and earn rewards',
                    style: TextStyles.regularMedium.copyWith(
                      color: const Color(0xFFF8E8C7),
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),
          // Status Tabs Filter Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: List.generate(tabs.length, (index) {
                final isSelected = _selectedTab == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = index),
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.gradientColor1 : AppColors.authBackBg,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected ? AppColors.gradientColor1 : AppColors.eventTabBorder,
                      ),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyles.semiBoldSmall.copyWith(
                        color: isSelected ? Colors.white : AppColors.lightText,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: _isLoading
                ? Center(
                    child: JumpingDotsProgress(
                      text: 'Loading Events',
                      textStyle: TextStyles.semiBoldMedium.copyWith(
                        color: AppColors.lightText,
                      ),
                      dotColor: AppColors.gradientColor1,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchEvents,
                    color: AppColors.gradientColor1,
                    child: _visibleEvents.isEmpty
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 80.h, horizontal: 24.w),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.event_busy_outlined,
                                      size: 54.sp,
                                      color: AppColors.greyText,
                                    ),
                                    SizedBox(height: 14.h),
                                    Text(
                                      'No events found',
                                      style: TextStyles.boldMedium.copyWith(
                                        color: AppColors.lightText,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      'Pull down to refresh and check for new events.',
                                      textAlign: TextAlign.center,
                                      style: TextStyles.regularSmall.copyWith(
                                        color: AppColors.greyText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 30.h),
                            itemCount: _visibleEvents.length,
                            separatorBuilder: (context, index) => SizedBox(height: 16.h),
                            itemBuilder: (context, index) {
                              final event = _visibleEvents[index];
                              return EventCard(
                                event: event,
                                onViewDetails: () {
                                  context.push('/events/${event.id}');
                                },
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}

class EventData {
  final String id;
  final String title;
  final String location;
  final String dateText;
  final String timeText;
  final String joinedText;
  final String status;
  final String reward;

  const EventData({
    required this.id,
    required this.title,
    required this.location,
    required this.dateText,
    required this.timeText,
    required this.joinedText,
    required this.status,
    required this.reward,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? 'Vintage Event').toString();
    final location = (json['location'] ?? (json['is_virtual'] == true ? 'Virtual Event' : 'Downtown District')).toString();
    final startDate = (json['start_date'] ?? 'Upcoming').toString();
    final endDate = (json['end_date'] ?? '').toString();
    final startTime = (json['start_time'] ?? '').toString();
    final endTime = (json['end_time'] ?? '').toString();

    final dateText = (endDate.isNotEmpty && endDate != startDate)
        ? '$startDate - $endDate'
        : startDate;

    final timeText = endTime.isNotEmpty
        ? '$startTime - $endTime'
        : (startTime.isNotEmpty ? startTime : 'All Day');

    final status = (json['status'] ?? json['event_type'] ?? 'Upcoming').toString();
    final participants = json['participants_count'] ?? 15;

    return EventData(
      id: (json['id'] ?? '').toString(),
      title: title,
      location: location,
      dateText: dateText,
      timeText: timeText,
      joinedText: '$participants registered',
      status: status,
      reward: '${json['reward_points'] ?? 500} pts + Badge',
    );
  }
}

class EventCard extends StatelessWidget {
  final EventData event;
  final VoidCallback onViewDetails;

  const EventCard({
    super.key,
    required this.event,
    required this.onViewDetails,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return const Color(0xFF16A34A);
      case 'past':
        return AppColors.greyText;
      default:
        return const Color(0xFFC65A46);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22.r),
              topRight: Radius.circular(22.r),
            ),
            child: Image.asset(
              AppImages.exploreBanner,
              height: 150.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.boldMedium.copyWith(
                          color: AppColors.gradientColor1,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(event.status).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: _getStatusColor(event.status).withValues(alpha: 0.30),
                        ),
                      ),
                      child: Text(
                        event.status,
                        style: TextStyles.semiBoldSmall.copyWith(
                          color: _getStatusColor(event.status),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _rowItem(
                  icon: Icons.location_on_outlined,
                  text: event.location,
                ),
                SizedBox(height: 8.h),
                _rowItem(
                  icon: Icons.calendar_month_outlined,
                  text: event.dateText,
                ),
                SizedBox(height: 8.h),
                _rowItem(
                  icon: Icons.access_time,
                  text: event.timeText,
                ),
                SizedBox(height: 8.h),
                _rowItem(
                  icon: Icons.people_outline_rounded,
                  text: event.joinedText,
                ),
                SizedBox(height: 14.h),
                Container(
                  height: 1,
                  color: AppColors.eventTabBorder,
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          color: const Color(0xFFC65A46),
                          size: 20.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          event.reward,
                          style: TextStyles.mediumMedium.copyWith(
                            color: const Color(0xFFC65A46),
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                    CustomButton(
                      onTap: onViewDetails,
                      btnText: 'View Details',
                      height: 38.h,
                      btnColor: const Color(0xFFC65A46),
                      textStyle: TextStyles.mediumMedium.copyWith(
                        color: AppColors.bodyBg,
                        fontSize: 13.sp,
                      ),
                      width: 125.w,
                      borderRadius: 10.r,
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

  Widget _rowItem({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: const Color(0xFFC85D45),
          size: 16.sp,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularSmall.copyWith(
              color: const Color(0xFF7A8995),
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    );
  }
}
