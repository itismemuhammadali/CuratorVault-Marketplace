import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'alerts_flags_detail_view.dart';

class AlertsFlagsView extends StatefulWidget {
  const AlertsFlagsView({super.key});

  @override
  State<AlertsFlagsView> createState() => _AlertsFlagsViewState();
}

class _AlertsFlagsViewState extends State<AlertsFlagsView> {
  int _selectedFilterIndex = 0;

  final List<_AlertFilter> _filters = const [
    _AlertFilter('All', _AlertStatus.all),
    _AlertFilter('New', _AlertStatus.newAlert),
    _AlertFilter('Reviewing', _AlertStatus.reviewing),
    _AlertFilter('Resolved', _AlertStatus.resolved),
  ];

  final List<_AlertItem> _items = const [
    _AlertItem(
      title: 'Fake Product Report',
      description:
          'Product "Vintage Watch XYZ" flagged as\ncounterfeit by multiple users',
      time: '2026-02-19 10:30 AM',
      status: _AlertStatus.newAlert,
      badgeLabel: 'New',
      badgeColor: Color(0xFFFF6B00),
      cardColor: Color(0xFFFFE5E5),
      borderColor: Color(0xFFFCA5A5),
      icon: Icons.report_outlined,
      iconBg: Color(0xFFFFD6D6),
      iconColor: Color(0xFFEF4444),
      useSvgIcon: true,
      svgPath: 'assets/icons/escrow_icon.svg',
    ),
    _AlertItem(
      title: 'Inappropriate Content',
      description: 'Community post contains offensive language',
      time: '2026-02-19 9:15 AM',
      status: _AlertStatus.reviewing,
      badgeLabel: 'Reviewing',
      badgeColor: Color(0xFF2563EB),
      cardColor: Color(0xFFFFE5E5),
      borderColor: Color(0xFFFCA5A5),
      icon: Icons.chat_bubble_outline,
      iconBg: Color(0xFFFFD6D6),
      iconColor: Color(0xFFEF4444),
      useSvgIcon: false,
      svgPath: null,
    ),
    _AlertItem(
      title: 'Suspicious Activity',
      description: 'User account shows abnormal login patterns',
      time: '2026-02-18 11:45 PM',
      status: _AlertStatus.newAlert,
      badgeLabel: 'New',
      badgeColor: Color(0xFFFF6B00),
      cardColor: Color(0xFFFFF4CC),
      borderColor: Color(0xFFFDE68A),
      icon: Icons.person_outline,
      iconBg: Color(0xFFFFEDB3),
      iconColor: Color(0xFFB45309),
      useSvgIcon: true,
      svgPath: 'assets/icons/profile_icon.svg',
    ),
    _AlertItem(
      title: 'Price Manipulation',
      description: 'Seller rapidly changing prices to manipulate\nrankings',
      time: '2026-02-18 6:20 PM',
      status: _AlertStatus.reviewing,
      badgeLabel: 'Reviewing',
      badgeColor: Color(0xFF2563EB),
      cardColor: Color(0xFFFFF4CC),
      borderColor: Color(0xFFFDE68A),
      icon: Icons.sell_outlined,
      iconBg: Color(0xFFFFEDB3),
      iconColor: Color(0xFFB45309),
      useSvgIcon: true,
      svgPath: 'assets/icons/escrow_icon.svg',
    ),
    _AlertItem(
      title: 'Spam Report',
      description: 'User posting excessive promotional content',
      time: '2026-02-18 2:00 PM',
      status: _AlertStatus.resolved,
      badgeLabel: 'Resolved',
      badgeColor: Color(0xFF16A34A),
      cardColor: Color(0xFFE0ECFF),
      borderColor: Color(0xFF93C5FD),
      icon: Icons.chat_bubble_outline,
      iconBg: Color(0xFFD6E5FF),
      iconColor: Color(0xFF2563EB),
      useSvgIcon: false,
      svgPath: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleItems = _filteredItems();

    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alerts & Flags',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldLarge.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Detailed information about the sale transaction',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.regularSmall.copyWith(
                  color: AppColors.darkText,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          height: 170.h,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
        children: [
          Row(
            children: const [
              _MetricCard(
                value: '2',
                label: 'High Priority',
                borderColor: Color(0xFFFCA5A5),
                textColor: Color(0xFFEF4444),
                bgColor: Color(0xFFFFF0F0),
              ),
              SizedBox(width: 6),
              _MetricCard(
                value: '2',
                label: 'New Alerts',
                borderColor: Color(0xFFFDE68A),
                textColor: Color(0xFFF59E0B),
                bgColor: Color(0xFFFFF8E8),
              ),
              SizedBox(width: 6),
              _MetricCard(
                value: '2',
                label: 'In Review',
                borderColor: Color(0xFFBFDBFE),
                textColor: Color(0xFF2563EB),
                bgColor: Color(0xFFEFF6FF),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _FilterBar(
            filters: _filters,
            selectedIndex: _selectedFilterIndex,
            onChanged: (index) => setState(() => _selectedFilterIndex = index),
          ),
          SizedBox(height: 12.h),
          for (final item in visibleItems) ...[
            _AlertCard(
              item: item,
              onTap: () => context.push(
                '/admin/alerts/details',
                extra: item.toDetailData(),
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ],
      ),
    );
  }

  List<_AlertItem> _filteredItems() {
    final filter = _filters[_selectedFilterIndex].status;
    if (filter == _AlertStatus.all) return _items;
    return _items.where((item) => item.status == filter).toList();
  }
}

class _MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final Color borderColor;
  final Color textColor;
  final Color bgColor;

  const _MetricCard({
    required this.value,
    required this.label,
    required this.borderColor,
    required this.textColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.boldLarge.copyWith(
                color: textColor,
                fontSize: 22.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.regularExtraSmall.copyWith(
                color: const Color(0xFF6B7280),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final List<_AlertFilter> filters;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _FilterBar({
    required this.filters,
    required this.selectedIndex,
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
          for (int i = 0; i < filters.length; i++)
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
                              color: AppColors.shadowColor.withValues(
                                alpha: 0.08,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    filters[i].label,
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

class _AlertCard extends StatelessWidget {
  final _AlertItem item;
  final VoidCallback onTap;

  const _AlertCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 110.h),
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
        decoration: BoxDecoration(
          color: item.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: item.borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: item.iconBg,
                shape: BoxShape.circle,
              ),
              child: item.useSvgIcon
                  ? Center(
                      child: SvgPicture.asset(
                        item.svgPath!,
                        width: 20.w,
                        height: 20.w,
                        colorFilter: ColorFilter.mode(
                          item.iconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : Icon(item.icon, size: 19.sp, color: item.iconColor),
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
                          item.title,
                          style: TextStyles.semiBoldSmall.copyWith(
                            color: const Color(0xFF1F2937),
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                      _StatusPill(
                        label: item.badgeLabel,
                        color: item.badgeColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.description,
                    style: TextStyles.regularExtraSmall.copyWith(
                      color: const Color(0xFF6B7280),
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: const Color(0xFF9CA3AF),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        item.time,
                        style: TextStyles.regularExtraSmall.copyWith(
                          color: const Color(0xFF9CA3AF),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

class _AlertFilter {
  final String label;
  final _AlertStatus status;

  const _AlertFilter(this.label, this.status);
}

class _AlertItem {
  final String title;
  final String description;
  final String time;
  final _AlertStatus status;
  final String badgeLabel;
  final Color badgeColor;
  final Color cardColor;
  final Color borderColor;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final bool useSvgIcon;
  final String? svgPath;

  const _AlertItem({
    required this.title,
    required this.description,
    required this.time,
    required this.status,
    required this.badgeLabel,
    required this.badgeColor,
    required this.cardColor,
    required this.borderColor,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.useSvgIcon = false,
    this.svgPath,
  });

  AlertDetailData toDetailData() {
    return AlertDetailData(
      title: title,
      alertId: '#1',
      time: time,
      statusLabel: badgeLabel,
      statusColor: badgeColor,
      tabIndex: status == _AlertStatus.newAlert
          ? 1
          : status == _AlertStatus.reviewing
              ? 2
              : status == _AlertStatus.resolved
                  ? 3
                  : 0,
      message:
          'Product "Vintage Watch XYZ" flagged as counterfeit by\nmultiple users',
      details:
          'Three users have reported this item as a potential\ncounterfeit. '
          'The seller has a history of 2 previous warnings.\n'
          'The product images appear to be stock photos from\nanother website.',
      reportedBy: 'John Doe, Sarah Smith, Mike Johnson',
      targetItem: 'Vintage Watch XYZ (ID: 12345)',
    );
  }
}

enum _AlertStatus { all, newAlert, reviewing, resolved }
