import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/includes/auth_header_clipper.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';

class RecoveryScaffold extends StatelessWidget {
  final Widget child;

  const RecoveryScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final topInset = MediaQuery.of(context).padding.top;
    final headerHeight = 232.h + topInset;
    final overlap = 42.h;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F7),
      body: Column(
        children: [
          SizedBox(
            height: headerHeight,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: HeaderArcClipper(),
                  child: Container(
                    width: double.infinity,
                    height: headerHeight,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.gradientColor1,
                          AppColors.gradientColor2,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: topInset + 22.h,
                  left: 22.w,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 42.w,
                      height: 42.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.darkText,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -32.h,
                  child: Center(
                    child: ClipOval(
                      child: Image.asset(
                        AppImages.userImg,
                        width: 92.w,
                        height: 92.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -overlap),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 18.h),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(34.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor.withValues(alpha: 0.16),
                        blurRadius: 28,
                        spreadRadius: -14,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 88.h, 20.w, 30.h),
                    child: child,
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
