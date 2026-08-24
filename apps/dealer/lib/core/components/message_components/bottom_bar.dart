import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';

class MessageBottomBar extends StatefulWidget {
  final MessageBottomBarData data;
  const MessageBottomBar({super.key, required this.data});

  @override
  State<MessageBottomBar> createState() => _MessageBottomBarState();
}

class _MessageBottomBarState extends State<MessageBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          border: Border(top: BorderSide(color: AppColors.grey, width: 1.0)),
        ),
        child: Row(
          children: [
            widget.data.hasActionBar == true
                ? widget.data.actionBar
                : SizedBox.shrink(),
            widget.data.hasActionBar == true
                ? SizedBox(width: 8.w)
                : SizedBox.shrink(),
            Expanded(child: widget.data.inputBar),
            SizedBox(width: 8.w),
            IconBox(
              icon: AppImages.flyPaperIcon,
              bgColor: AppColors.gradientColor1,
              iconColor: AppColors.bodyBg,
              height: 40.h,
              width: 40.w,
              borderRadius: 100.r,
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBottomBarData {
  final bool? hasActionBar;
  final Widget actionBar;
  final Widget inputBar;

  const MessageBottomBarData({
    required this.actionBar,
    required this.inputBar,
    this.hasActionBar = true,
  });
}
