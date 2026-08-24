import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class IntroSliderLayout extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const IntroSliderLayout({
    required this.title,
    required this.description,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 28.h),
        Expanded(
          flex: 7,
          child: Center(
            child: SizedBox(
              width: 308.w,
              height: 308.h,
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
