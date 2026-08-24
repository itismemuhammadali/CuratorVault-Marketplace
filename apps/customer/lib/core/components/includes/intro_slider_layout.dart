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
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    
    // Calculate responsive image size based on screen height
    final maxImageSize = (screenHeight * 0.45).clamp(200.0, 520.0);
    final imageSize = maxImageSize.w;
    
    return Column(
      children: [
        // Image section - independently positioned, more centered vertically
        Expanded(
          flex: 5,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 80.h),
              child: SizedBox(
                width: imageSize,
                height: imageSize,
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        
        // Text section - independently positioned at bottom, won't move with image
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 80.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyles.boldLarge.copyWith(
                      color: const Color(0xFFF8E8C7),
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyles.regularMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.86),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
