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
      difficultyLabel: 'Auction',
    ),
    _EventData(
      id: '2',
      imageAsset: AppImages.exploreBanner,
      title: 'Jewelry & Gems Discovery',
      location: 'Vintage Quarter',
      dateText: 'Feb 15, 2026',
      timeText: '3:00 PM - 7:00 PM',
      joinedText: '65/80 joined',
      difficultyLabel: 'Workshop',
    ),
    _EventData(
      id: '3',
      imageAsset: AppImages.exploreBanner,
      title: 'Victorian Era Collectibles Auction',
      location: 'Grand Auction House, London',
      dateText: 'Feb 12, 2026',
      timeText: '10:00 AM - 4:00 PM',
      joinedText: '156/200 attendees',
      difficultyLabel: 'Auction',
    ),
    _EventData(
      id: '4',
      imageAsset: AppImages.exploreBanner,
      title: 'Jewelry & Gems Discovery',
      location: 'Vintage Quarter',
      dateText: 'Feb 15, 2026',
      timeText: '3:00 PM - 7:00 PM',
      joinedText: '65/80 joined',
      difficultyLabel: 'Workshop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                'Join events and earn rewards',
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          height: 194.h,
        ),
      ),
      body: Padding(
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
