import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/includes/auth_header.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AuthScreensLayout extends StatefulWidget {
  final String bottomText;
  final Widget body;
  const AuthScreensLayout({
    super.key,
    required this.bottomText,
    required this.body,
  });

  @override
  State<AuthScreensLayout> createState() => _AuthScreensLayoutState();
}

class _AuthScreensLayoutState extends State<AuthScreensLayout> {
  final double _headerHeight = 300.h;
  final double radius = 45.r;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(color: AppColors.bodyBg),
                padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
                child: Column(
                  children: [
                    Container(
                      // height: MediaQuery.of(
                      //   context,
                      // ).size.height, // will be removed
                      decoration: BoxDecoration(
                        color: AppColors.bodyBg,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.r),
                          bottomRight: Radius.circular(40.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 50,
                            offset: Offset(0, 25),
                            spreadRadius: -12,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: _headerHeight - 80.h),
                        child: widget.body,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (widget.bottomText.trim().isNotEmpty)
                      Text(
                        widget.bottomText,
                        textAlign: TextAlign.center,
                        style: TextStyles.regularExtraSmall.copyWith(
                          decoration: TextDecoration.none,
                          color: AppColors.gradientColor1,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          AuthHeader(headerHeight: _headerHeight),
        ],
      ),
    );
  }
}
