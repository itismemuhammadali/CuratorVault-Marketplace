import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class IntroSliderLayout extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final double? customImageWidth;
  final double? customImageHeight;

  const IntroSliderLayout({
    required this.title,
    required this.description,
    required this.image,
    this.customImageWidth,
    this.customImageHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Use custom sizes if provided, otherwise default to 308
    final imageWidth = customImageWidth ?? 308.w;
    final imageHeight = customImageHeight ?? 308.h;

    return Column(
      children: [
        SizedBox(height: 28.h),
        Expanded(
          flex: 7,
          child: Center(
            child: SizedBox(
              width: imageWidth,
              height: imageHeight,
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.boldLarge.copyWith(
                  color: const Color(0xFFF8E8C7),
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyles.regularMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
