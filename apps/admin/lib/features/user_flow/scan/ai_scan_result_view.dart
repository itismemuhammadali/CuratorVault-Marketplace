import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AiScanResultView extends StatelessWidget {
  final String? imagePath;

  const AiScanResultView({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    final pageBg = AppColors.subPageBg;

    final titleColor = AppColors.bodyBg;
    final closeBg = AppColors.bodyBg.withValues(alpha: 0.20);
    final closeIcon = AppColors.bodyBg;

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.gradientColor1, AppColors.gradientColor2],
            ),
          ),
        ),
        titleSpacing: 24.w,
        title: Text(
          'Ai Scanner',
          style: TextStyles.semiBoldMedium.copyWith(
            color: titleColor,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                height: 40.w,
                width: 40.w,
                decoration: BoxDecoration(
                  color: closeBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: _CloseXIcon(
                    color: closeIcon,
                    size: 14.w,
                    strokeWidth: 2.2.w,
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.bodyBg.withValues(alpha: 0.12),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 22.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ResultImage(imagePath: imagePath, borderRadius: 28.r),
              SizedBox(height: 16.h),
              _DetailsCard(),
              SizedBox(height: 18.h),
              CustomButton(
                height: 64.h,
                borderRadius: 16.r,
                btnColor: AppColors.redButton,
                onTap: () => context.go('/user/my-finds'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomPaint(
                      size: Size.square(18.w),
                      painter: _BookmarkPainter(
                        color: AppColors.bodyBg,
                        strokeWidth: 1.9.w,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Save to My Finds',
                      style: TextStyles.semiBoldMedium.copyWith(
                        color: AppColors.bodyBg,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      height: 56.h,
                      borderRadius: 14.r,
                      btnColor: Colors.transparent,
                      borderColor: AppColors.darkText.withValues(alpha: 0.80),
                      onTap: () => context.push('/single_message'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.chatBubbleIcon,
                            width: 18.w,
                            color: AppColors.lightText,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Ask Expert',
                            style: TextStyles.semiBoldSmall.copyWith(
                              color: AppColors.lightText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: CustomButton(
                      height: 56.h,
                      borderRadius: 14.r,
                      btnColor: Colors.transparent,
                      borderColor: AppColors.darkText.withValues(alpha: 0.80),
                      onTap: () => context.go('/user/market'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomPaint(
                            size: Size.square(18.w),
                            painter: _ExternalLinkPainter(
                              color: AppColors.lightText,
                              strokeWidth: 1.9.w,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Similar Items',
                            style: TextStyles.semiBoldSmall.copyWith(
                              color: AppColors.lightText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                decoration: BoxDecoration(
                  color: AppColors.redButton.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: AppColors.redButton.withValues(alpha: 0.35),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: CustomPaint(
                        size: Size.square(18.w),
                        painter: _AlertPainter(
                          color: AppColors.redButton,
                          strokeWidth: 2.0.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'Ai analysis provides estimates. For official authentication,\nconsult with a certified expert.',
                        style: TextStyles.regularExtraSmall.copyWith(
                          color: AppColors.redButton,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultImage extends StatelessWidget {
  final String? imagePath;
  final double borderRadius;

  const _ResultImage({required this.imagePath, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final image =
        (!kIsWeb && imagePath != null && File(imagePath!).existsSync())
        ? Image.file(File(imagePath!), fit: BoxFit.cover)
        : Image.asset(AppImages.productOne, fit: BoxFit.cover);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          SizedBox(height: 260.h, width: double.infinity, child: image),
          Positioned(
            top: 14.h,
            right: 14.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.redButton,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppImages.tickIcon,
                    width: 14.w,
                    height: 14.w,
                    color: Colors.white,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Verified',
                    style: TextStyles.regularSmall.copyWith(
                      color: Colors.white,
                    ),
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

class _DetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = AppColors.lightText;
    final muted = AppColors.greyText;
    final accent = AppColors.redButton;

    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Victorian Pocket Watch',
            style: TextStyles.semiBoldLarge.copyWith(
              color: title,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.darkText,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Horology',
                  style: TextStyles.regularExtraSmall.copyWith(
                    color: AppColors.lightText,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.darkText, width: 1.6.w),
                ),
                child: Text(
                  'England',
                  style: TextStyles.regularExtraSmall.copyWith(
                    color: AppColors.lightText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Authenticity Score',
                  style: TextStyles.regularSmall.copyWith(color: title),
                ),
              ),
              Text(
                '94%',
                style: TextStyles.semiBoldSmall.copyWith(
                  color: accent,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _ScoreBar(value: 0.94),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _SpecColumn(
                  label: 'Period',
                  value: 'Late 19th Century\n(1880-1900)',
                ),
              ),
              Expanded(
                child: _SpecColumn(
                  label: 'Condition',
                  value: 'Excellent',
                  alignEnd: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
            decoration: BoxDecoration(
              color: AppColors.marketValueBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Market Value',
                  style: TextStyles.regularExtraSmall.copyWith(color: muted),
                ),
                SizedBox(height: 6.h),
                Text(
                  '\$1,200 – \$1,800',
                  style: TextStyles.semiBoldMedium.copyWith(
                    color: title,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'Ai Analysis',
            style: TextStyles.regularSmall.copyWith(
              color: muted,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'A beautifully preserved Victorian-era pocket watch\nfeaturing intricate engravings and a white enamel dial.\nThe movement appears to be in working condition\nwith original components.',
            style: TextStyles.regularSmall.copyWith(color: title, height: 1.35),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Provenance',
                  style: TextStyles.regularSmall.copyWith(
                    color: muted,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Text(
                'Verified',
                style: TextStyles.regularSmall.copyWith(
                  color: title,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            height: 1,
            width: double.infinity,
            color: AppColors.authBackBg,
          ),
        ],
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final double value;

  const _ScoreBar({required this.value});

  @override
  Widget build(BuildContext context) {
    final track = AppColors.darkText.withValues(alpha: 0.65);
    final fill = AppColors.redButton;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        height: 8.h,
        color: track,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(color: fill),
          ),
        ),
      ),
    );
  }
}

class _SpecColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _SpecColumn({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.greyText;
    final title = AppColors.lightText;

    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyles.regularExtraSmall.copyWith(color: muted)),
        SizedBox(height: 6.h),
        Text(
          value,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: TextStyles.regularSmall.copyWith(color: title, height: 1.25),
        ),
      ],
    );
  }
}

class _CloseXIcon extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const _CloseXIcon({
    required this.color,
    required this.size,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _CloseXIconPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _CloseXIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _CloseXIconPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final inset = size.width * 0.18;
    canvas.drawLine(
      Offset(inset, inset),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CloseXIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

class _BookmarkPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _BookmarkPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.22,
        size.height * 0.12,
        size.width * 0.56,
        size.height * 0.76,
      ),
      Radius.circular(size.width * 0.10),
    );

    final path = Path()..addRRect(r);
    // notch
    path.moveTo(size.width * 0.22, size.height * 0.88);
    path.lineTo(size.width * 0.50, size.height * 0.70);
    path.lineTo(size.width * 0.78, size.height * 0.88);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BookmarkPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

class _ExternalLinkPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _ExternalLinkPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final box = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.18,
        size.height * 0.28,
        size.width * 0.56,
        size.height * 0.56,
      ),
      Radius.circular(size.width * 0.14),
    );
    canvas.drawRRect(box, paint);

    final start = Offset(size.width * 0.44, size.height * 0.36);
    final end = Offset(size.width * 0.82, size.height * 0.10);
    canvas.drawLine(start, end, paint);

    canvas.drawLine(
      Offset(size.width * 0.68, size.height * 0.10),
      Offset(size.width * 0.82, size.height * 0.10),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.82, size.height * 0.10),
      Offset(size.width * 0.82, size.height * 0.24),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ExternalLinkPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

class _AlertPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _AlertPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width * 0.48, paint);

    canvas.drawLine(
      Offset(center.dx, size.height * 0.30),
      Offset(center.dx, size.height * 0.62),
      paint,
    );

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx, size.height * 0.74),
      strokeWidth * 0.55,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AlertPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
