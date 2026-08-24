import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AlertsFlagsDetailView extends StatefulWidget {
  final AlertDetailData data;

  const AlertsFlagsDetailView({super.key, required this.data});

  @override
  State<AlertsFlagsDetailView> createState() => _AlertsFlagsDetailViewState();
}

class _AlertsFlagsDetailViewState extends State<AlertsFlagsDetailView> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.data.tabIndex;
  }

  _StatusMeta _statusForIndex(int index) {
    switch (index) {
      case 1:
        return const _StatusMeta('New', Color(0xFFFF6B00));
      case 2:
        return const _StatusMeta('Reviewing', Color(0xFF2563EB));
      case 3:
        return const _StatusMeta('Resolved', Color(0xFF16A34A));
      default:
        return _StatusMeta(widget.data.statusLabel, widget.data.statusColor);
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
                widget.data.title,
                style: TextStyles.boldLarge.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Alert ID: ${widget.data.alertId} • ${widget.data.time}',
                style: TextStyles.regularSmall.copyWith(
                  color: AppColors.darkText,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          height: 140.h,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
        children: [
          _FilterBar(
            selectedIndex: _selectedTab,
            labels: const ['All', 'New', 'Reviewing', 'Resolved'],
            onChanged: (index) => setState(() => _selectedTab = index),
          ),
          SizedBox(height: 12.h),
          ...() {
            final statusMeta = _statusForIndex(_selectedTab);
            return [
          Row(
            children: [
              Text(
                'Status:',
                style: TextStyles.regularSmall.copyWith(
                  color: const Color(0xFF6B7280),
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(width: 8.w),
              _StatusPill(
                label: statusMeta.label,
                color: statusMeta.color,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _PriorityCard(
            label: 'HIGH Priority',
            color: const Color(0xFFEF4444),
          ),
          SizedBox(height: 16.h),
          _SectionTitle('Alert Message'),
          SizedBox(height: 6.h),
          Text(
            widget.data.message,
            style: TextStyles.regularSmall.copyWith(
              color: const Color(0xFF6B7280),
              fontSize: 14.sp,
              height: 1.35,
            ),
          ),
          SizedBox(height: 16.h),
          _SectionTitle('Details'),
          SizedBox(height: 6.h),
          Text(
            widget.data.details,
            style: TextStyles.regularSmall.copyWith(
              color: const Color(0xFF6B7280),
              fontSize: 14.sp,
              height: 1.35,
            ),
          ),
          SizedBox(height: 14.h),
          _SoftCard(
            title: 'Reported By',
            content: widget.data.reportedBy,
            bgColor: const Color(0xFFEFF6FF),
          ),
          SizedBox(height: 10.h),
          _SoftCard(
            title: 'Target Item',
            content: widget.data.targetItem,
            bgColor: const Color(0xFFFFF4E5),
          ),
          SizedBox(height: 14.h),
          _MiniAlertCard(
            title: 'Spam Report',
            subtitle: 'User posting excessive promotional content',
            time: '2026-02-18 2:00 PM',
            badgeLabel: 'Resolved',
            badgeColor: const Color(0xFF16A34A),
            cardColor: const Color(0xFFE0ECFF),
            borderColor: const Color(0xFF93C5FD),
            iconColor: const Color(0xFF2563EB),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/check_email_icon.svg',
                    width: 18.w,
                    height: 18.w,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: Text(
                    'Mark Resolved',
                    style: TextStyles.semiBoldSmall.copyWith(
                      color: AppColors.bodyBg,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    Icons.close,
                    size: 18.sp,
                    color: const Color(0xFFEF4444),
                  ),
                  label: Text(
                    'Dismiss',
                    style: TextStyles.semiBoldSmall.copyWith(
                      color: const Color(0xFFEF4444),
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ];
          }(),
        ],
      ),
    );
  }
}

class AlertDetailData {
  final String title;
  final String alertId;
  final String time;
  final String statusLabel;
  final Color statusColor;
  final int tabIndex;
  final String message;
  final String details;
  final String reportedBy;
  final String targetItem;

  const AlertDetailData({
    required this.title,
    required this.alertId,
    required this.time,
    required this.statusLabel,
    required this.statusColor,
    required this.tabIndex,
    required this.message,
    required this.details,
    required this.reportedBy,
    required this.targetItem,
  });
}

class _StatusMeta {
  final String label;
  final Color color;

  const _StatusMeta(this.label, this.color);
}

class _FilterBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  const _FilterBar({
    required this.selectedIndex,
    required this.labels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedIndex == i
                        ? AppColors.bodyBg
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(999.r),
                    boxShadow: selectedIndex == i
                        ? [
                            BoxShadow(
                              color:
                                  AppColors.shadowColor.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyles.semiBoldExtraSmall.copyWith(
                      color: const Color(0xFF1F2937),
                      fontSize: 13.sp,
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

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: TextStyles.semiBoldExtraSmall.copyWith(
          color: AppColors.bodyBg,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

class _PriorityCard extends StatelessWidget {
  final String label;
  final Color color;

  const _PriorityCard({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E5),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFEF4444)),
      ),
      child: Row(
        children: [
          Icon(Icons.flag_outlined, size: 18.sp, color: color),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyles.semiBoldSmall.copyWith(
              color: color,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.boldSmall.copyWith(
        color: const Color(0xFF1F2A44),
        fontSize: 16.sp,
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  final String title;
  final String content;
  final Color bgColor;

  const _SoftCard({
    required this.title,
    required this.content,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.regularExtraSmall.copyWith(
              color: const Color(0xFF6B7280),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            content,
            style: TextStyles.semiBoldSmall.copyWith(
              color: const Color(0xFF1F2A44),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniAlertCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final String badgeLabel;
  final Color badgeColor;
  final Color cardColor;
  final Color borderColor;
  final Color iconColor;

  const _MiniAlertCard({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.badgeLabel,
    required this.badgeColor,
    required this.cardColor,
    required this.borderColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: const BoxDecoration(
              color: Color(0xFFD6E5FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 16.sp,
              color: iconColor,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyles.semiBoldSmall.copyWith(
                          color: const Color(0xFF1F2937),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        badgeLabel,
                        style: TextStyles.semiBoldExtraSmall.copyWith(
                          color: AppColors.bodyBg,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  subtitle,
                  style: TextStyles.regularExtraSmall.copyWith(
                    color: const Color(0xFF6B7280),
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 13.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      time,
                      style: TextStyles.regularExtraSmall.copyWith(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 11.sp,
                      ),
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
