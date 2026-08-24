import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _navTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      context.go("/introSlider");
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.gradientColor1, AppColors.gradientColor2],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        AppImages.splashImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Discover, Scan & Collect Timeless Stories",
                  style: TextStyles.semiBoldLarge.copyWith(
                    color: AppColors.bodyBg,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                Container(
                  width: 64,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.darkText,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
