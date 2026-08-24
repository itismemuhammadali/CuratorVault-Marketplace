import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFF2B2B2B),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.exploreBanner, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.12),
                  Colors.black.withValues(alpha: 0.28),
                  const Color(0xFF101729).withValues(alpha: 0.96),
                ],
                stops: const [0.0, 0.52, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 4.w,
            right: 4.w,
            top: 4.h,
            bottom: 4.h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 200.h,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.34),
                ),
                child: ClipOval(
                  child: Image.asset(
                    AppImages.userImg,
                    width: 114.w,
                    height: 114.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 28.w,
            right: 28.w,
            bottom: 24.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Antiques Market',
                  style: TextStyles.boldLarge.copyWith(
                    color: Colors.white,
                    fontSize: 22.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Explore Market of antiques buy and sell product',
                  style: TextStyles.regularMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.90),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 28.h),
                CustomButton(
                  onTap: () => context.go('/introSlider'),
                  height: 54.h,
                  borderRadius: 14.r,
                  btnColor: AppColors.redButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyles.boldMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ],
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
