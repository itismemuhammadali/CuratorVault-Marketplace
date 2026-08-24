import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vintage_app/core/components/global_header/transparent_header.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class EventDetailView extends StatefulWidget {
  final String eventId;

  const EventDetailView({super.key, required this.eventId});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  bool _isRegistered = false;
  OverlayEntry? _toastOverlay;

  @override
  void dispose() {
    _toastOverlay?.remove();
    super.dispose();
  }

  void _showRegistrationToast() {
    _toastOverlay?.remove();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (context) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bodyBg,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor.withValues(alpha: 0.18),
                        blurRadius: 20,
                        spreadRadius: -12,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 22.w,
                        width: 22.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1F1F),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check_rounded,
                            size: 14.sp,
                            color: AppColors.bodyBg,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Successfully registered for the event!',
                              style: TextStyles.semiBoldMedium.copyWith(
                                color: const Color(0xFF1F1F1F),
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Check your notifications for event updates',
                              style: TextStyles.regularSmall.copyWith(
                                color: AppColors.lightText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    _toastOverlay = entry;
    overlay.insert(entry);

    Future<void>.delayed(const Duration(milliseconds: 2500), () {
      if (_toastOverlay == entry) {
        entry.remove();
        _toastOverlay = null;
      }
    });
  }

  void _register() {
    setState(() {
      _isRegistered = true;
    });
    _showRegistrationToast();
  }

  @override
  Widget build(BuildContext context) {
    final registeredCount = _isRegistered ? 48 : 47;
    final spotsLeft = 100 - registeredCount;
    final progress = registeredCount / 100;

    return TransparentHeader(
      backgroundColor: AppColors.bodyBg,
      title: const SizedBox.shrink(),
      trailing: const SizedBox.shrink(),
      showBackButton: true,
      showDivider: true,
      extendBodyBehindAppBar: true,
      headerPadding: EdgeInsets.zero,
      body: Stack(
        children: [
          Column(
            children: [
              _EventHero(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 110.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Downtown AR Treasure Hunt',
                        style: TextStyles.boldLarge.copyWith(
                          color: AppColors.gradientColor1,
                          fontSize: 24.sp,
                        ),
                      ),
                      if (_isRegistered) ...[
                        SizedBox(height: 14.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2FFF6),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: const Color(0xFFB8F0C9),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                color: const Color(0xFF22C55E),
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "You're registered for this event",
                                style: TextStyles.mediumSmall.copyWith(
                                  color: const Color(0xFF22C55E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 4.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: const _InfoTile(
                              icon: Icons.calendar_today_outlined,
                              label: 'Date',
                              value: 'Feb 5, 2026',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: const _InfoTile(
                              icon: Icons.access_time_rounded,
                              label: 'Time',
                              value: '2:00 PM - 6:00 PM',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: const _InfoTile(
                              icon: Icons.location_on_outlined,
                              label: 'Location',
                              value: 'Downtown Historic\nDistrict',
                              useSvgIcon: true,
                              svgIconPath: 'assets/icons/location_marker_icon.svg',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: const _InfoTile(
                              icon: Icons.workspace_premium_outlined,
                              label: 'Reward',
                              value: '500 pts + Rare Badge',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      _ParticipationCard(
                        registeredCount: registeredCount,
                        spotsLeft: spotsLeft,
                        progress: progress,
                      ),
                      SizedBox(height: 14.h),
                      const _ContentCard(
                        title: 'About This Event',
                        child: Text(
                          'Explore the historic downtown area and discover hidden antique treasures using AR technology. This immersive experience combines cutting-edge augmented reality with the thrill of treasure hunting.',
                        ),
                      ),
                      SizedBox(height: 14.h),
                      _ContentCard(
                        title: 'Event Highlights',
                        child: Column(
                          children: const [
                            _HighlightRow(
                              text: '10+ AR checkpoints throughout downtown',
                            ),
                            _HighlightRow(
                              text: 'Real antique items to discover',
                            ),
                            _HighlightRow(text: 'Expert guides available'),
                            _HighlightRow(
                              text: 'Networking with fellow collectors',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),
                      _ContentCard(
                        title: 'Requirements',
                        titleIcon: Icons.info_outline_rounded,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _RequirementRow(
                              text: 'Smartphone with AR capability',
                            ),
                            _RequirementRow(
                              text: 'Vintage Vibers app installed',
                            ),
                            _RequirementRow(text: 'Comfortable walking shoes'),
                            _RequirementRow(text: 'Fully charged device'),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),
                      _OrganizerCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color(0xFFFFF8F0),
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
              child: _isRegistered
                  ? Container(
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF848484),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor.withValues(
                              alpha: 0.16,
                            ),
                            blurRadius: 18,
                            spreadRadius: -10,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.bodyBg,
                            size: 18.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "You're registered for this event!",
                            style: TextStyles.mediumMedium.copyWith(
                              color: AppColors.bodyBg,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: _register,
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: AppColors.redButton,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColor.withValues(
                                alpha: 0.16,
                              ),
                              blurRadius: 18,
                              spreadRadius: -10,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Register for Event',
                            style: TextStyles.semiBoldMedium.copyWith(
                              color: AppColors.bodyBg,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventHero extends StatelessWidget {
  const _EventHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.exploreBanner, fit: BoxFit.cover),
          Container(color: AppColors.gradientColor1.withValues(alpha: 0.30)),
          Positioned(
            left: 18.w,
            bottom: 16.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.redButton,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Medium',
                style: TextStyles.regularSmall.copyWith(
                  color: AppColors.bodyBg,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;
  final bool useSvgIcon;
  final String? svgIconPath;

  const _InfoTile({
    this.icon,
    required this.label,
    required this.value,
    this.useSvgIcon = false,
    this.svgIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.lightText.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (useSvgIcon && svgIconPath != null)
                SvgPicture.asset(
                  svgIconPath!,
                  width: 19.sp,
                  height: 19.sp,
                  colorFilter: const ColorFilter.mode(
                    AppColors.redButton,
                    BlendMode.srcIn,
                  ),
                )
              else
                Icon(icon, color: AppColors.redButton, size: 19.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyles.regularSmall.copyWith(
                  color: AppColors.greyText,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            value,
            style: TextStyles.mediumMedium.copyWith(
              color: AppColors.gradientColor1,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipationCard extends StatelessWidget {
  final int registeredCount;
  final int spotsLeft;
  final double progress;

  const _ParticipationCard({
    required this.registeredCount,
    required this.spotsLeft,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.lightText.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/participant_icon.svg',
                width: 20.sp,
                height: 20.sp,
                colorFilter: const ColorFilter.mode(
                  AppColors.redButton,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '$registeredCount / 100 registered',
                  style: TextStyles.mediumMedium.copyWith(
                    color: AppColors.gradientColor1,
                  ),
                ),
              ),
              Text(
                '$spotsLeft spots left',
                style: TextStyles.regularSmall.copyWith(
                  color: AppColors.redButton,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: SizedBox(
              height: 8.h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: AppColors.darkText),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(color: AppColors.redButton),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? titleIcon;

  const _ContentCard({
    required this.title,
    required this.child,
    this.titleIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.lightText.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (titleIcon != null) ...[
                Icon(titleIcon, color: AppColors.redButton, size: 18.sp),
                SizedBox(width: 8.w),
              ],
              Text(
                title,
                style: TextStyles.boldLarge.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          DefaultTextStyle(
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.lightText,
              height: 1.7,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _HighlightRow extends StatelessWidget {
  final String text;

  const _HighlightRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.redButton,
            size: 18.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String text;

  const _RequirementRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 9.h),
            width: 5.w,
            height: 5.w,
            decoration: const BoxDecoration(
              color: AppColors.redButton,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _OrganizerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.lightText.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Organized By',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.gradientColor1,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  AppImages.userImg,
                  width: 44.w,
                  height: 44.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Heritage Events Team',
                    style: TextStyles.mediumLarge.copyWith(
                      color: AppColors.gradientColor1,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Event Organizer',
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
