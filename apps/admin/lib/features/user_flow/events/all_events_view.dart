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
  // Simple in-memory list of events to render
  final List<_EventData> _events = List.generate(6, (index) {
    final id = index + 1;
    return _EventData(
      id: '$id',
      imageAsset: 'assets/images/explore.jpg',
      title: 'Downtown AR Treasure Hunt #$id',
      location: 'Downtown Historic District',
      dateText: 'Feb 5, 2026',
      timeText: '2:00 PM - 6:00 PM',
      joinedText: '${40 + id}/100 joined',
      difficultyLabel: 'Medium',
      progress: (40 + id) / 100,
      rewardText: '🏆 ${500 + 50 * id} pts + Expert Badge',
    );
  });

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
              SizedBox(height: 10.h),
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
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
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
              SizedBox(height: 16.h),
              // Build 6 EventCards from the _events list
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
                      difficultyColor: AppColors.redButton,
                      progress: event.progress,
                      rewardText: event.rewardText,
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
  final double progress;
  final String rewardText;

  const _EventData({
    required this.id,
    required this.imageAsset,
    required this.title,
    required this.location,
    required this.dateText,
    required this.timeText,
    required this.joinedText,
    required this.difficultyLabel,
    required this.progress,
    required this.rewardText,
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
  final Color difficultyColor;
  final double progress; // 0.0 - 1.0
  final String rewardText;
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
    required this.difficultyColor,
    required this.progress,
    required this.rewardText,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey, width: 1),
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: Image.asset(
              imageAsset,
              height: 160.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.semiBoldMedium.copyWith(
                    color: AppColors.lightText,
                  ),
                ),
                SizedBox(height: 8.h),
                _dataRow(AppImages.mapMarkerIcon, location, null),
                SizedBox(height: 8.h),
                _dataRow(AppImages.calenderEmptyIcon, dateText, null),
                SizedBox(height: 8.h),
                _dataRow(AppImages.clockIcon, timeText, null),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _dataRow(
                      AppImages.usersIcon,
                      joinedText,
                      AppColors.lightText,
                    ),
                    Badge(
                      label: Text(
                        difficultyLabel,
                        style: TextStyles.regularExtraSmall.copyWith(
                          color: AppColors.bodyBg,
                        ),
                      ),
                      backgroundColor: AppColors.redButton,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                _EventProgressBar(progress: progress),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      rewardText,
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.redButton,
                      ),
                    ),
                    CustomButton(
                      onTap: onViewDetails,
                      btnText: "View Details",
                      height: 36.h,
                      btnColor: AppColors.redButton,
                      textStyle: TextStyles.regularMedium.copyWith(
                        color: AppColors.bodyBg,
                      ),
                      width: 120.w,
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

class _EventProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0

  const _EventProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    final value = progress.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999.r),
      child: SizedBox(
        height: 8.h,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // background track (light beige)
            Container(color: AppColors.darkText),
            // filled portion (brown-ish) based on progress
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: Container(color: AppColors.redButton),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _dataRow(String icon, String text, Color? textColor) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      IconBoxTransparent(icon: icon, color: AppColors.redButton, size: 14.h),
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
