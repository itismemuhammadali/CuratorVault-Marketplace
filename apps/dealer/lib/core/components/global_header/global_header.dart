import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';

import '../../theme/images.dart';
import '../icons/icon_box.dart';

class SimpleHeader extends StatefulWidget implements PreferredSizeWidget {
  final HeaderConfig config;

  const SimpleHeader({super.key, required this.config});

  @override
  Size get preferredSize => Size.fromHeight(config.height);

  @override
  State<SimpleHeader> createState() => _SimpleHeaderState();
}

class _SimpleHeaderState extends State<SimpleHeader> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientColor1, AppColors.gradientColor2],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 6,
                spreadRadius: -4,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 15,
                spreadRadius: -3,
                offset: const Offset(0, 10),
              ),
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.r),
              bottomRight: Radius.circular(40.r),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.config.leading ??
                          (context.canPop()
                              ? IconBox(
                                  icon: AppImages.backIcon,
                                  bgColor: AppColors.darkText.withValues(alpha: 0.20),
                                  onTap: () => Navigator.pop(context),
                                  iconColor: AppColors.darkText,
                                  height: 40.h,
                                  width: 40.w,
                                  borderRadius: 100.r,
                                )
                              : const SizedBox.shrink()),
                      widget.config.trailing ?? const SizedBox.shrink(),
                    ],
                  ),
                  (widget.config.leading != null || context.canPop())
                      ? SizedBox(height: 16.h)
                      : const SizedBox.shrink(),
                  widget.config.title,
                  if (widget.config.bottomWidget != null) ...[
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: widget.config.bottomWidget!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
