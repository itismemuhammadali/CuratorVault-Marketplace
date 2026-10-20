import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vintage_app/core/components/global_header/transparent_header.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/api_service.dart';
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
  bool _isLoading = true;
  bool _isRegistered = false;
  OverlayEntry? _toastOverlay;

  Map<String, dynamic>? _eventData;

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  Future<void> _loadEventDetails() async {
    try {
      final res = await ApiService.get('/api/v1/events/${widget.eventId}');
      if (res is Map && res.containsKey('event') && res['event'] is Map) {
        setState(() {
          _eventData = Map<String, dynamic>.from(res['event']);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error loading event detail: $e');
      setState(() => _isLoading = false);
    }
  }

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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bodyBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: JumpingDotsProgress(
            text: 'Loading Event',
            textStyle: TextStyles.semiBoldMedium.copyWith(
              color: AppColors.lightText,
            ),
            dotColor: AppColors.gradientColor1,
          ),
        ),
      );
    }

    final title = (_eventData?['title'] ?? 'Downtown AR Treasure Hunt').toString();
    final startDate = (_eventData?['start_date'] ?? 'Feb 5, 2026').toString();
    final endDate = (_eventData?['end_date'] ?? '').toString();
    final dateDisplay = endDate.isNotEmpty && endDate != startDate
        ? '$startDate - $endDate'
        : startDate;
    final startTime = (_eventData?['start_time'] ?? '2:00 PM').toString();
    final endTime = (_eventData?['end_time'] ?? '6:00 PM').toString();
    final timeDisplay = '$startTime - $endTime';
    final location = (_eventData?['location'] ??
            (_eventData?['is_virtual'] == true ? 'Virtual Event' : 'Downtown Historic District'))
        .toString();
    final description = (_eventData?['description'] ??
            'Explore the historic downtown area and discover hidden antique treasures using AR technology. This immersive experience combines cutting-edge augmented reality with the thrill of treasure hunting.')
        .toString();

    final registeredCount = _isRegistered ? 48 : 47;
    final spotsLeft = 100 - registeredCount;
    final progress = registeredCount / 100;

    return TransparentHeader(
      backgroundColor: AppColors.bodyBg,
      title: const SizedBox.shrink(),
      trailing: const SizedBox.shrink(),
      showBackButton: true,
      showDivider: false,
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
                        title,
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
                      SizedBox(height: 14.h),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _InfoTile(
                                  icon: Icons.calendar_today_outlined,
                                  label: 'Date',
                                  value: dateDisplay,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _InfoTile(
                                  icon: Icons.access_time_rounded,
                                  label: 'Time',
                                  value: timeDisplay,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: _InfoTile(
                                  svgIcon: 'assets/icons/location_icon.svg',
                                  label: 'Location',
                                  value: location,
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
                        ],
                      ),
                      SizedBox(height: 14.h),
                      _ParticipationCard(
                        registeredCount: registeredCount,
                        spotsLeft: spotsLeft,
                        progress: progress,
                      ),
                      SizedBox(height: 14.h),
                      _ContentCard(
                        title: 'About This Event',
                        child: Text(
                          description,
                          style: TextStyles.regularSmall.copyWith(
                            color: AppColors.lightText,
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      _ContentCard(
                        title: 'Event Highlights',
                        child: Column(
                          children: const [
                            _HighlightRow(
                              text: '10+ AR checkpoints throughout district',
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
                            style: TextStyles.semiBoldMedium.copyWith(
                              color: AppColors.bodyBg,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 52.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 6,
                          shadowColor: AppColors.shadowColor.withValues(
                            alpha: 0.22,
                          ),
                        ),
                        onPressed: _register,
                        child: Text(
                          'Register for Event',
                          style: TextStyles.boldMedium.copyWith(
                            color: AppColors.bodyBg,
                            fontSize: 16.sp,
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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 310.h,
          width: double.infinity,
          child: Image.asset(
            AppImages.exploreBanner,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 90.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.bodyBg.withValues(alpha: 0.90),
                  AppColors.bodyBg,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData? icon;
  final String? svgIcon;
  final String label;
  final String value;

  const _InfoTile({
    this.icon,
    this.svgIcon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.shadowColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 16,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36.w,
            width: 36.w,
            decoration: BoxDecoration(
              color: AppColors.redButton.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: svgIcon != null
                  ? SvgPicture.asset(
                      svgIcon!,
                      width: 18.w,
                      height: 18.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.redButton,
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(
                      icon,
                      color: AppColors.redButton,
                      size: 18.sp,
                    ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyles.regularExtraSmall.copyWith(
                    color: AppColors.darkText,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyles.semiBoldSmall.copyWith(
                    color: AppColors.gradientColor1,
                    fontSize: 13.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.shadowColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 16,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Participation',
                style: TextStyles.boldMedium.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 16.sp,
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
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8.h,
              backgroundColor: const Color(0xFFF1EAE2),
              valueColor: const AlwaysStoppedAnimation(AppColors.redButton),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$registeredCount registered',
                style: TextStyles.regularSmall.copyWith(
                  color: AppColors.darkText,
                ),
              ),
              Text(
                '100 max',
                style: TextStyles.regularSmall.copyWith(
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final String title;
  final IconData? titleIcon;
  final Widget child;

  const _ContentCard({
    required this.title,
    this.titleIcon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.shadowColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 16,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          ),
        ],
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
                style: TextStyles.boldMedium.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          child,
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
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.redButton,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.regularSmall.copyWith(
                color: AppColors.lightText,
                height: 1.25,
              ),
            ),
          ),
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
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            height: 6.w,
            width: 6.w,
            decoration: const BoxDecoration(
              color: AppColors.redButton,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.regularSmall.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrganizerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.shadowColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 16,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              AppImages.userImg,
              height: 48.w,
              width: 48.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vintage Vibers Community',
                  style: TextStyles.boldMedium.copyWith(
                    color: AppColors.gradientColor1,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Official Event Organizer',
                  style: TextStyles.regularExtraSmall.copyWith(
                    color: AppColors.darkText,
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
