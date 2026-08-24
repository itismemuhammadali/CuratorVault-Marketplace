import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/global_footer/footer_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class GlobalFooter extends StatelessWidget {
  final FooterFlow flow;

  const GlobalFooter({super.key, required this.flow});

  int _currentIndex(BuildContext context, List<FooterItemData> items) {
    final location = GoRouterState.of(context).uri.toString();

    for (int i = 0; i < items.length; i++) {
      final route = items[i].routePath;
      if (route.isNotEmpty && location.startsWith(route)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final config = FooterConfigs.of(flow);
    final originalItems = config.items;
    final hasCenter = config.centerButton != null;

    // Build visible items list and inject a dummy slot if center button exists
    final List<FooterItemData?> visibleItems = [];
    if (hasCenter && originalItems.isNotEmpty) {
      final mid = (originalItems.length / 2).ceil();
      visibleItems
        ..addAll(originalItems.take(mid))
        ..add(null) // dummy transparent item for center button spacing
        ..addAll(originalItems.skip(mid));
    } else {
      visibleItems.addAll(originalItems);
    }

    final currentIndex = _currentIndex(context, originalItems);

    return BottomAppBar(
      color: AppColors.gradientColor1,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: visibleItems.asMap().entries.map((entry) {
                final visibleIndex = entry.key;
                final item = entry.value;

                // Dummy slot: keep horizontal space but render nothing
                if (item == null) {
                  return SizedBox(width: 50.w, height: 40.h);
                }

                // Map visible index back to original index for selection state
                int originalIndex = visibleIndex;
                if (hasCenter) {
                  final mid = (originalItems.length / 2).ceil();
                  if (visibleIndex > mid) {
                    originalIndex = visibleIndex - 1;
                  }
                }

                final isSelected = originalIndex == currentIndex;

                return GestureDetector(
                  onTap: () => context.go(item.routePath),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      item.iconPath.endsWith('.svg')
                          ? SvgPicture.asset(
                              item.iconPath,
                              height: 24.h,
                              width: 24.w,
                              colorFilter: ColorFilter.mode(
                                isSelected
                                    ? AppColors.redButton
                                    : AppColors.grey,
                                BlendMode.srcIn,
                              ),
                            )
                          : Image.asset(
                              item.iconPath,
                              height: 24.h,
                              width: 24.w,
                              color: isSelected
                                  ? AppColors.redButton
                                  : AppColors.grey,
                            ),
                      isSelected
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 0.5.h),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.redButton,
                                    shape: BoxShape.circle,
                                  ),
                                  height: 3.h,
                                  width: 3.w,
                                ),
                                SizedBox(height: 0.5.h),
                              ],
                            )
                          : SizedBox(height: 6.h),
                      Text(
                        item.label,
                        style: TextStyles.regularSmall.copyWith(
                          color: isSelected
                              ? AppColors.redButton
                              : AppColors.bodyBg,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          if (config.centerButton != null)
            Positioned(
              // Move the center button up by roughly 50% of its own height (70.h)
              top: -50.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
        onTap: () {
          final currentLocation = GoRouterState.of(context).uri.path;
          
          // Pass current location as returnPath parameter
          context.go('${config.centerButton!.routePath}?returnPath=$currentLocation');
        },
                  child: Container(
                    height: 70.h,
                    width: 70.w,
                    decoration: BoxDecoration(
                      color: const Color(0xff343434),
                      shape: BoxShape.circle,
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
                    ),
                    child: Center(
                      child: Container(
                        height: 52.h,
                        width: 52.w,
                        decoration: BoxDecoration(
                          color: AppColors.redButton,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: config.centerButton!.iconPath.endsWith('.svg')
                              ? SvgPicture.asset(
                                  config.centerButton!.iconPath,
                                  height: 24.h,
                                  width: 24.w,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.bodyBg,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : Image.asset(
                                  config.centerButton!.iconPath,
                                  height: 24.h,
                                  width: 24.w,
                                  color: AppColors.bodyBg,
                                ),

                        ),
                      ),
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
