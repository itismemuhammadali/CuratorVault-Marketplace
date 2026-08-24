import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/global_header/header_controller_provider.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _headerSet = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateHeader() {
    HeaderControllerProvider.of(context).value = HeaderConfig(
      title: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey Lori',
              style: TextStyles.boldTitle.copyWith(
                color: AppColors.bodyBg,
                fontSize: 28.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Manage all platform users',
              style: TextStyles.semiBoldMedium.copyWith(
                color: const Color(0xffF8E8C7),
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
      trailing: GestureDetector(
        onTap: () => context.push('/dealer/profile'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: Image.asset(
            AppImages.userImg,
            width: 48.w,
            height: 48.w,
            fit: BoxFit.cover,
          ),
        ),
      ),
      bottomWidget: AppTextField(
        controller: _searchController,
        hintText: 'Search antiques, categories, or experts...',
        fillColor: Colors.transparent,
        borderColor: const Color(0xffF8E8C7),
        focusedBorderColor: const Color(0xffF8E8C7),
        borderRadius: 16.r,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        prefix: Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Image.asset(
            AppImages.magnifineGlassIcon,
            width: 18.w,
            height: 18.h,
            color: AppColors.bodyBg,
          ),
        ),
        hintStyle: TextStyles.regularSmall.copyWith(
          color: AppColors.bodyBg.withValues(alpha: 0.6),
        ),
      ),
      height: 235.h,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_headerSet) {
      _headerSet = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _updateHeader();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.homeScreenBg,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _statsGrid(),
            SizedBox(height: 16.h),
            _quickActionsCard(),
            SizedBox(height: 16.h),
            _alertsFlagsCard(),
            SizedBox(height: 16.h),
            _weeklyActivityCard(),
          ],
        ),
      ),
    );
  }

  Widget _statsGrid() {
    return Wrap(
      spacing: 14.w,
      runSpacing: 14.h,
      children: [
        _statCard(
          iconColor: null,
          label: 'Total Users',
          value: '12,453',
          badgeText: '+12%',
          badgeBg: AppColors.badgeSuccessBg,
          badgeTextColor: AppColors.badgeSuccessText,
          iconAsset: AppImages.homeUserIcon,
        ),
        _statCard(
          iconColor: null,
          label: 'Active Listings',
          value: '2,341',
          badgeText: '+8%',
          badgeBg: AppColors.badgeSuccessBg,
          badgeTextColor: AppColors.badgeSuccessText,
          iconAsset: AppImages.cartIcon,
        ),
        _statCard(
          iconColor: null,
          label: 'Ongoing Events',
          value: '8',
          badgeText: '+2',
          badgeBg: AppColors.badgeSuccessBg,
          badgeTextColor: AppColors.badgeSuccessText,
          iconAsset: AppImages.calendarIcon,
        ),
        _statCard(
          iconColor: null,
          label: 'Pending Approvals',
          value: '23',
          badgeText: '-5',
          badgeBg: AppColors.badgeNegativeBg,
          badgeTextColor: AppColors.badgeNegativeText,
          iconAsset: AppImages.warningIcon,
        ),
      ],
    );
  }

  Widget _statCard({
    required Color? iconColor,
    required String label,
    required String value,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
    required String iconAsset,
  }) {
    final cardWidth = (MediaQuery.sizeOf(context).width - 20.w * 2 - 14.w) / 2;

    return Container(
      width: cardWidth,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 52.w,
                height: 52.w,
                child: Image.asset(
                  iconAsset,
                  width: 52.w,
                  height: 52.w,
                  color: iconColor,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  badgeText,
                  style: TextStyles.semiBoldExtraSmall.copyWith(
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyles.boldTitle.copyWith(color: AppColors.lightText),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyles.regularExtraSmall.copyWith(
              color: AppColors.greyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyles.boldSection.copyWith(color: AppColors.lightText),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _quickActionButton(
                  label: 'Create Event',
                  iconAsset: AppImages.plusIcon,
                  borderColor: AppColors.quickActionPink,
                  textColor: AppColors.quickActionPink,
                  onTap: () => context.push('/events/create'),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _quickActionButton(
                  label: 'Approve User',
                  iconAsset: AppImages.tickIcon,
                  borderColor: AppColors.quickActionGreen,
                  textColor: AppColors.quickActionGreenText,
                  onTap: () => context.go('/admin/users'),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _quickActionButton(
                  label: 'Review Listing',
                  iconAsset: AppImages.eyeOutlinedIcon,
                  borderColor: AppColors.quickActionPurple,
                  textColor: AppColors.quickActionPurple,
                  onTap: () => context.go('/dealer/market'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActionButton({
    required String label,
    required String iconAsset,
    required Color borderColor,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 110.h,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconAsset,
                width: 17.w,
                height: 17.h,
                color: textColor,
              ),
              SizedBox(height: 5.h),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.semiBoldSmall.copyWith(
                    color: textColor,
                    fontSize: 12.sp,
                    height: 1.12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _alertsFlagsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.alertsBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppImages.alertIcon,
                width: 18.w,
                height: 18.h,
                color: AppColors.alertOrange,
              ),
              SizedBox(width: 8.w),
              Text(
                'Alerts & Flags',
                style: TextStyles.boldSection.copyWith(
                  color: AppColors.lightText,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _alertRow(
            title: 'Report',
            subtitle: 'Listing #4521 flagged for counterfeit',
            accentColor: AppColors.alertRed,
            bgColor: AppColors.alertReportBg,
            onTap: () => context.push('/admin/alerts'),
          ),
          _alertRow(
            title: 'Dispute',
            subtitle: 'Transaction dispute - Order #9832',
            accentColor: AppColors.alertAmber,
            bgColor: AppColors.alertDisputeBg,
            onTap: () => context.push('/admin/alerts'),
          ),
          _alertRow(
            title: 'Violation',
            subtitle: 'User @collector23 policy violation',
            accentColor: AppColors.alertRed,
            bgColor: AppColors.alertReportBg,
            onTap: () => context.push('/admin/alerts'),
          ),
        ],
      ),
    );
  }

  Widget _alertRow({
    required String title,
    required String subtitle,
    required Color accentColor,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: accentColor.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.semiBoldSmall.copyWith(
                      color: AppColors.lightText,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'View',
              style: TextStyles.semiBoldSmall.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weeklyActivityCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Weekly Activity',
                  style: TextStyles.boldSection.copyWith(
                    color: AppColors.lightText,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.badgeSuccessLightBg,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppImages.arrowTopRightIcon,
                      width: 14.w,
                      height: 14.h,
                      color: AppColors.quickActionGreenText,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '+12.5%',
                      style: TextStyles.mediumSmall.copyWith(
                        color: AppColors.quickActionGreenText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 210.h,
            width: double.infinity,
            child: CustomPaint(painter: _WeeklyActivityChartPainter()),
          ),
        ],
      ),
    );
  }
}

class _WeeklyActivityChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 36.0;
    const topPad = 22.0;
    const rightPad = 16.0;
    const bottomPad = 34.0;

    final chartRect = Rect.fromLTWH(
      leftPad,
      topPad,
      size.width - leftPad - rightPad,
      size.height - topPad - bottomPad,
    );

    final yLabels = ['80', '60', '40', '20', '0'];
    final xLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final gridPaint = Paint()
      ..color = AppColors.chartGrid
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final axisPaint = Paint()
      ..color = AppColors.chartAxis
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = AppColors.chartLine
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final labelStyle = TextStyles.regularTiny.copyWith(
      color: AppColors.chartAxis,
    );

    void drawLabel(
      String text,
      Offset offset, {
      TextAlign align = TextAlign.left,
    }) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: labelStyle),
        textDirection: TextDirection.ltr,
        textAlign: align,
      )..layout();
      painter.paint(canvas, offset);
    }

    for (int i = 0; i < 5; i++) {
      final dy = chartRect.top + chartRect.height * (i / 4);
      _drawDashedLine(
        canvas,
        Offset(chartRect.left, dy),
        Offset(chartRect.right, dy),
        gridPaint,
        dashWidth: 5,
        dashGap: 4,
      );
      drawLabel(yLabels[i], Offset(2, dy - 6));
    }

    for (int i = 0; i < xLabels.length; i++) {
      final dx = chartRect.left + chartRect.width * (i / 6);
      _drawDashedLine(
        canvas,
        Offset(dx, chartRect.top),
        Offset(dx, chartRect.bottom),
        gridPaint,
        dashWidth: 5,
        dashGap: 4,
      );
      drawLabel(xLabels[i], Offset(dx - 10, chartRect.bottom + 6));
    }

    canvas.drawLine(
      Offset(chartRect.left, chartRect.top),
      Offset(chartRect.left, chartRect.bottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(chartRect.left, chartRect.bottom),
      Offset(chartRect.right, chartRect.bottom),
      axisPaint,
    );

    final values = <double>[42, 50, 47, 62, 58, 70, 54];
    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final dx = chartRect.left + chartRect.width * (i / (values.length - 1));
      final normalized = (values[i] / 80.0).clamp(0.0, 1.0);
      final dy = chartRect.bottom - (chartRect.height * normalized);
      points.add(Offset(dx, dy));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlX1 = current.dx + (next.dx - current.dx) * 0.35;
      final controlX2 = current.dx + (next.dx - current.dx) * 0.65;
      path.cubicTo(controlX1, current.dy, controlX2, next.dy, next.dx, next.dy);
    }

    canvas.drawPath(path, linePaint);
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint, {
    double dashWidth = 4,
    double dashGap = 3,
  }) {
    final totalLength = (end - start).distance;
    final direction = (end - start) / totalLength;
    double drawn = 0;
    while (drawn < totalLength) {
      final currentStart = start + direction * drawn;
      final currentEnd =
          start + direction * (drawn + dashWidth).clamp(0, totalLength);
      canvas.drawLine(currentStart, currentEnd, paint);
      drawn += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
