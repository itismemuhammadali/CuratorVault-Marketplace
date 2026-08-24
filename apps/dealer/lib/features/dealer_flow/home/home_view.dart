import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              'Welcome back, Dealer',
              style: TextStyles.boldLarge.copyWith(
                color: AppColors.bodyBg,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "Here's your business overview",
              style: TextStyles.semiBoldMedium.copyWith(
                color: AppColors.darkText,
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
            width: 40.w,
            height: 40.w,
            fit: BoxFit.cover,
          ),
        ),
      ),
      bottomWidget: AppTextField(
        controller: _searchController,
        hintText: 'Search antiques, categories, or experts...',
        fillColor: Colors.white,
        borderColor: Colors.transparent,
        focusedBorderColor: Colors.transparent,
        borderRadius: 18.r,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        prefix: SvgPicture.asset(
          'assets/icons/search_icon.svg',
          width: 18.w,
          height: 18.h,
          colorFilter: ColorFilter.mode(
            AppColors.lightText.withValues(alpha: 0.95),
            BlendMode.srcIn,
          ),
        ),

      ),
      height: 220.h,
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
      color: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _totalSalesCard(),
            SizedBox(height: 14.h),
            _statsGrid(),
            SizedBox(height: 16.h),
            _weeklySalesCard(),
            SizedBox(height: 16.h),
            _upcomingEventsCard(context),
            SizedBox(height: 16.h),
            _recentActivityCard(),
          ],
        ),
      ),
    );
  }

  Widget _totalSalesCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Sale (This Month)',
            style: TextStyles.mediumMedium.copyWith(color: Colors.white),
          ),
          SizedBox(height: 10.h),
          Text(
            '\$12,450',
            style: TextStyles.boldLarge.copyWith(
              color: Colors.white,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              '+18% from last month',
              style: TextStyles.mediumSmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsGrid() {
    return Wrap(
      spacing: 14.w,
      runSpacing: 14.h,
      children: [
        _miniCard(
          bgColor: const Color(0xFF3B82F6),
          label: 'Active Listings',
          value: '24',
          iconAsset: AppImages.shippingBoxIcon,
        ),
        _miniCard(
          bgColor: const Color(0xFFF7B500),
          label: 'Pending Orders',
          value: '3',
          iconAsset: AppImages.shippingBoxWithHandleIcon,
        ),
        _miniCard(
          bgColor: const Color(0xFF00C853),
          label: 'Total Sale',
          value: '\$48K',
          iconAsset: AppImages.dollarIcon,
        ),
        _miniCard(
          bgColor: const Color(0xFFA855F7),
          label: 'Rating',
          value: '4.9',
          iconAsset: AppImages.starOutlinedIcon,
        ),
      ],
    );
  }

  Widget _miniCard({
    required Color bgColor,
    required String label,
    required String value,
    required String iconAsset,
  }) {
    final cardWidth = (MediaQuery.sizeOf(context).width - 20.w * 2 - 14.w) / 2;

    return Container(
      width: cardWidth,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 16.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Image.asset(
                iconAsset,
                width: 20.w,
                height: 20.h,
                color: Colors.white,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyles.regularMedium.copyWith(color: Colors.white),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyles.boldLarge.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _weeklySalesCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFFE8DEF8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.07),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Sales',
                      style: TextStyles.boldLarge.copyWith(
                        color: AppColors.lightText,
                        fontSize: 17.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Last 7 days performance',
                      style: TextStyles.mediumMedium.copyWith(
                        color: const Color(0xFF7E22CE),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF7F1),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppImages.arrowTopRightIcon,
                      width: 14.w,
                      height: 14.h,
                      color: const Color(0xFF16A34A),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '+12.5%',
                      style: TextStyles.mediumSmall.copyWith(
                        color: const Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 210.h,
            width: double.infinity,
            child: CustomPaint(painter: _WeeklySalesChartPainter()),
          ),
        ],
      ),
    );
  }

  Widget _upcomingEventsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFFE8DEF8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Upcoming Events',
                  style: TextStyles.boldLarge.copyWith(
                    color: AppColors.lightText,
                    fontSize: 17.sp,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/events'),
                child: Text(
                  'View All',
                  style: TextStyles.mediumMedium.copyWith(
                    color: AppColors.redButton,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.gradientColor1, AppColors.gradientColor2],
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      AppImages.mapMarkerOutlinedIcon,
                      width: 18.w,
                      height: 18.h,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'New York',
                      style: TextStyles.mediumMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Antique Furniture Restoration Workshop',
                  style: TextStyles.boldLarge.copyWith(
                    color: Colors.white,
                    fontSize: 19.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Join the hunt - Find hidden antiques in your area and earn exclusive badges!',
                  style: TextStyles.regularMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => context.push('/events/1'),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5EFE6),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyles.mediumMedium.copyWith(
                          color: AppColors.lightText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentActivityCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF6FF),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFFCADEFA)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent Activity',
                  style: TextStyles.boldLarge.copyWith(
                    color: AppColors.lightText,
                    fontSize: 17.sp,
                  ),
                ),
              ),
              Text(
                'View All',
                style: TextStyles.mediumMedium.copyWith(
                  color: AppColors.gradientColor1,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _activityTile(
            iconAsset: 'assets/icons/escrow_icon.svg',
            iconBg: const Color(0xFFD8F7E3),
            title: 'New order received',
            subtitle: 'Victorian Clock',
            value: '\$850',
            time: '2h ago',
            onTap: () => context.go('/dealer/orders'),
          ),
          _activityTile(
            iconAsset: AppImages.eyeOutlinedIcon,
            iconBg: const Color(0xFFDCEAFF),
            title: 'Listing viewed',
            subtitle: 'Antique Vase',
            value: '12 views today',
            time: '4h ago',
            onTap: () => context.go('/dealer/orders'),
          ),
          _activityTile(
            iconAsset: AppImages.starOutlinedIcon,
            iconBg: const Color(0xFFFFF1D6),
            title: 'New review received',
            subtitle: '5 stars from Sarah M.',
            value: '',
            time: '1d ago',
            onTap: () => context.go('/dealer/orders'),
          ),
          _activityTile(
            iconAsset: AppImages.circularTickIcon,
            iconBg: const Color(0xFFEDE2FF),
            title: 'Item sold',
            subtitle: 'Porcelain Vase Collection',
            value: '\$650',
            time: '1d ago',
            onTap: () => context.go('/dealer/orders'),
          ),
        ],
      ),
    );
  }

  Widget _activityTile({
    required String iconAsset,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String value,
    required String time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: iconAsset.endsWith('.svg')
                    ? SvgPicture.asset(
                        iconAsset,
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                          AppColors.lightText,
                          BlendMode.srcIn,
                        ),
                      )
                    : Image.asset(
                        iconAsset,
                        width: 20.w,
                        height: 20.h,
                        color: AppColors.lightText,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.mediumMedium.copyWith(
                      color: AppColors.lightText,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (value.isNotEmpty)
                  Text(
                    value,
                    style: TextStyles.mediumMedium.copyWith(
                      color: AppColors.gradientColor1,
                    ),
                  ),
                Text(
                  time,
                  style: TextStyles.regularSmall.copyWith(
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklySalesChartPainter extends CustomPainter {
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

    final yLabels = ['\$6k', '\$4.5k', '\$3k', '\$1.5k', '\$0k'];
    final xLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final gridPaint = Paint()
      ..color = const Color(0xFFD7E1F4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final axisPaint = Paint()
      ..color = const Color(0xFF9AA4B6)
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = const Color(0xFF485A7B)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final labelStyle = TextStyle(
      color: const Color(0xFF9AA4B6),
      fontSize: 10.sp,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
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

    final values = <double>[2.8, 3.2, 2.6, 4.1, 3.8, 4.5, 3.9];
    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final dx = chartRect.left + chartRect.width * (i / (values.length - 1));
      final normalized = (values[i] / 6.0).clamp(0.0, 1.0);
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

    final dotOuterPaint = Paint()..color = const Color(0xFF56648B);
    final dotInnerPaint = Paint()..color = Colors.white;
    for (final point in points) {
      canvas.drawCircle(point, 6.2, dotOuterPaint);
      canvas.drawCircle(point, 3.1, dotInnerPaint);
    }
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
