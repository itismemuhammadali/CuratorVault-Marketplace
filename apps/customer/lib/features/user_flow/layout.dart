import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_footer/footer_config.dart';
import 'package:vintage_app/core/components/global_footer/global_footer.dart';
import 'package:vintage_app/core/theme/app_colors.dart';

class UserFlowLayout extends StatelessWidget {
  final Widget child;
  final FooterFlow flow;

  const UserFlowLayout({super.key, required this.child, required this.flow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(bottom: 110.h),
              child: child,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GlobalFooter(flow: flow),
          ),
        ],
      ),
    );
  }
}
