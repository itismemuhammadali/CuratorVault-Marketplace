import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
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
  final List<_EventData> _events = const [
    _EventData(
      id: '1',
      imageAsset: AppImages.exploreBanner,
      title: 'Victorian Era Collectibles Auction',
      location: 'Grand Auction House, London',
      dateText: 'Feb 12, 2026',
      timeText: '10:00 AM - 4:00 PM',
      joinedText: '156/200 attendees',
      difficultyLabel: 'Easy',
    ),
    _EventData(
      id: '2',
      imageAsset: AppImages.exploreBanner,
      title: 'Jewelry & Gems Discovery',
      location: 'Vintage Quarter',
      dateText: 'Feb 15, 2026',
      timeText: '3:00 PM - 7:00 PM',
      joinedText: '65/80 joined',
      difficultyLabel: 'Medium',
    ),
    _EventData(
      id: '3',
      imageAsset: AppImages.exploreBanner,
      title: 'Victorian Era Collectibles Auction',
      location: 'Grand Auction House, London',
      dateText: 'Feb 12, 2026',
      timeText: '10:00 AM - 4:00 PM',
      joinedText: '156/200 attendees',
      difficultyLabel: 'Hard',
    ),
    _EventData(
      id: '4',
      imageAsset: AppImages.exploreBanner,
      title: 'Jewelry & Gems Discovery',
      location: 'Vintage Quarter',
      dateText: 'Feb 15, 2026',
      timeText: '3:00 PM - 7:00 PM',
      joinedText: '65/80 joined',
      difficultyLabel: 'Easy',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
            child: SafeArea(
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
                          context.go('/homeScreen');
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
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Events',
                      style: TextStyles.semiBoldMedium.copyWith(
                        color: AppColors.lightText,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Column(
                      children: [
                        for (final event in _events) ...[
                          EventCard(
                            imageAsset: event.imageAsset,
                            title: event.title,
                            location: event.location,
                            dateText: event.dateText,
                            timeText: event.timeText,
                            joinedText: event.joinedText,
                            difficultyLabel: event.difficultyLabel,
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
          ),
        ],
      ),
    );
  }
}

class _EventData {
  final String id;
  final String imageAsset;
  final String title;
  final String location;
  final String dateText;
  final String timeText;
  final String joinedText;
  final String difficultyLabel;

  const _EventData({
    required this.id,
    required this.imageAsset,
    required this.title,
    required this.location,
    required this.dateText,
    required this.timeText,
    required this.joinedText,
    required this.difficultyLabel,
  });
}

class EventCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String location;
  final String dateText;
  final String timeText;
  final String joinedText;
  final String difficultyLabel;
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
          Stack(
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
            ],
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
                SizedBox(height: 12.h),
                _svgDataRow('assets/icons/location_icon.svg', location),
                SizedBox(height: 10.h),
                _svgDataRow('assets/icons/admin_nav_events.svg', dateText),
                SizedBox(height: 10.h),
                _iconDataRow(Icons.access_time, timeText),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _svgDataRow('assets/icons/participant_icon.svg', joinedText),
                    _difficultyBadge(difficultyLabel),
                  ],
                ),
                SizedBox(height: 14.h),
                Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D4C4),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.47,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFA0663C),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          color: const Color(0xFFC65A46),
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '500 pts + Rare Badge',
                          style: TextStyles.mediumMedium.copyWith(
                            color: const Color(0xFFC65A46),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    CustomButton(
                      onTap: onViewDetails,
                      btnText: 'View Details',
                      height: 40.h,
                      btnColor: const Color(0xFFC65A46),
                      textStyle: TextStyles.mediumMedium.copyWith(
                        color: AppColors.bodyBg,
                        fontSize: 14.sp,
                      ),
                      width: 145.w,
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
}

Widget _svgDataRow(String svgPath, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SvgPicture.asset(
        svgPath,
        width: 18.w,
        height: 18.h,
        colorFilter: const ColorFilter.mode(
          Color(0xFFC85D45),
          BlendMode.srcIn,
        ),
      ),
      SizedBox(width: 10.w),
      Text(
        text,
        style: TextStyles.regularSmall.copyWith(
          color: const Color(0xFF7A8995),
          fontSize: 14.sp,
        ),
      ),
    ],
  );
}

Widget _iconDataRow(IconData icon, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(
        icon,
        color: const Color(0xFFC85D45),
        size: 18.sp,
      ),
      SizedBox(width: 10.w),
      Text(
        text,
        style: TextStyles.regularSmall.copyWith(
          color: const Color(0xFF7A8995),
          fontSize: 14.sp,
        ),
      ),
    ],
  );
}

Widget _difficultyBadge(String difficulty) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 12.w,
      vertical: 6.h,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFFC65A46),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Text(
      difficulty,
      style: TextStyles.mediumSmall.copyWith(
        color: Colors.white,
        fontSize: 12.sp,
      ),
    ),
  );
}

