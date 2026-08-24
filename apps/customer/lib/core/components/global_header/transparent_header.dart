import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';

class TransparentHeader extends StatelessWidget {
  final Widget? title;
  final Widget trailing;
  final Widget body;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final bool showBackButton;
  final Widget? leading;
  final EdgeInsetsGeometry? headerPadding;
  final double? leadingGap;
  final bool showDivider;
  final Color? dividerColor;
  final bool extendBodyBehindAppBar;
  final double? titleSpacing;

  const TransparentHeader({
    super.key,
    this.title,
    required this.trailing,
    required this.body,
    this.backgroundColor,
    this.backgroundGradient,
    this.showBackButton = true,
    this.leading,
    this.headerPadding,
    this.leadingGap,
    this.showDivider = true,
    this.dividerColor,
    this.extendBodyBehindAppBar = true,
    this.titleSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final Widget? effectiveLeading =
        leading ??
        ((showBackButton && context.canPop())
            ? IconBox(
                icon: AppImages.backIcon,
                iconColor: AppColors.darkText,
                bgColor: AppColors.darkText.withValues(alpha: 0.20),
                height: 40.h,
                width: 40.w,
                borderRadius: 100.r,
                onTap: () {
                  context.pop();
                },
              )
            : null);

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.bodyBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: titleSpacing,
        title: Padding(
          padding: headerPadding ?? EdgeInsets.symmetric(vertical: 32.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (effectiveLeading != null) effectiveLeading,
              if (effectiveLeading != null) SizedBox(width: leadingGap ?? 20.w),
              Expanded(
                child: Row(
                  mainAxisAlignment: title != null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  crossAxisAlignment: title != null
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.end,
                  children: [if (title != null) title!, trailing],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: backgroundGradient != null
            ? Container(
                decoration: BoxDecoration(gradient: backgroundGradient),
              )
            : null,
        bottom: !showDivider
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  height: 1,
                  color: dividerColor ?? AppColors.darkText,
                ),
              ),
      ),
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: body,
    );
  }
}
