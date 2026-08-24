import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/cards/app_item_card.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

import '../../../core/components/global_header/header_config.dart';
import '../../../core/components/global_header/header_controller_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  bool _headerSet = false;


  final _recentScans = const [
    (
      title: 'Victorian Pocket Watch',
      dateTime: 'Oct 14, 2025 2:30 pm',
      price: '\$1,200 - \$1,800',
      badge: AppItemCardBadge.hot,
      image: AppImages.productFive,
    ),
    (
      title: 'Digital Fitness Tracker',
      dateTime: 'Oct 11, 2025 9:07 pm',
      price: '\$150 - \$250',
      badge: AppItemCardBadge.trendy,
      image: AppImages.productSix,
    ),
    (
      title: 'Modern Smartwatch',
      dateTime: 'Sep 28, 2025 3:40 am',
      price: '\$300 - \$700',
      badge: AppItemCardBadge.cool,
      image: AppImages.productSeven,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_headerSet) {
      _headerSet = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        HeaderControllerProvider.of(context).value = HeaderConfig(
          title: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lori Porter',
                  style: TextStyles.semiBoldLarge.copyWith(
                    color: AppColors.bodyBg,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Welcome back,',
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
          trailing: IconBox(
            icon: AppImages.chatBubbleIcon,
            height: 40.h,
            width: 40.w,
            bgColor: AppColors.messageIconBg,
            borderRadius: 60.r,
            iconColor: AppColors.messageIcon,
            onTap: (){
              context.push("/user/chat");
            },
          ),
          bottomWidget: AppTextField(
            controller: controller,
            hintText: "Search antiques, categories, or experts...",
            prefix: IconBox(
              icon: AppImages.magnifineGlassIcon,
              bgColor: Colors.transparent,
            ),
          ),
          height: 215.h,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<({
    String title,
    String price,
    String image,
    VoidCallback? onTap,
    })> highlights = [
      (
      title: 'Victorian Pocket Watch',
      price: '\$1,198',
      image: AppImages.productOne,
      onTap: () {
        context.push("/market/product/1");
      },
      ),
      (
      title: 'Victorian Pocket Watch',
      price: '\$4,785',
      image: AppImages.productTwo,
      onTap: null,
      ),
      (
      title: 'Art Deco Table Clock',
      price: '\$2,450',
      image: AppImages.productThree,
      onTap: null,
      ),
      (
      title: 'Art Deco Table Clock',
      price: '\$5,600',
      image: AppImages.productFour,
      onTap: null,
      ),
    ];
    return Container(
      color: AppColors.bodyBg,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomePromoCard(
              imageAsset: AppImages.exploreBanner,
              title: 'Discover\nUnmatched Antiques',
              subtitle: 'For Timeless Living',
              buttonLabel: 'Explore',
              onTap: () {
                context.go('/user/market');
              },
            ),
            SizedBox(height: 22.h),
            _SectionHeader(
              title: "Today's Highlights",
              actionLabel: 'View All',
              onActionTap: () {
                context.go('/user/market');
              },
            ),
            SizedBox(height: 14.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 14.h,
                childAspectRatio: 0.78,
              ),
              itemCount: highlights.length,
              itemBuilder: (context, index) {
                final item = highlights[index];

                return AppItemCard(
                  layout: AppItemCardLayout.grid,
                  title: item.title,
                  priceText: item.price,
                  priceColor: AppColors.lightText,
                  imageAsset: item.image,
                  gridTitleMaxLines: 1,
                  gridActionIcon: Icons.visibility_outlined,
                  gridActionPosition: AppItemCardGridActionPosition.bottomRight,
                  onGridActionTap: item.onTap,
                );
              },
            ),
            SizedBox(height: 22.h),
            _SectionHeader(
              title: 'Upcoming Events',
              actionLabel: 'View All',
              onActionTap: () {
                context.go("/events");
              },
            ),
            SizedBox(height: 14.h),
            _UpcomingEventCard(
              location: 'Downtown Historic District',
              title: 'AR Treasure Hunt',
              description:
                  'Join the hunt — Find hidden antiques in your area\n'
                  'and earn exclusive badges!',
              buttonLabel: 'Register',
              onTap: () {
                context.push('/events/1');
              },
            ),
            SizedBox(height: 22.h),
            _SectionHeader(
              title: 'Recent Scan',
              actionLabel: 'View All',
              onActionTap: () {
                context.go('/user/my-finds');
              },
            ),
            SizedBox(height: 14.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentScans.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = _recentScans[index];

                return AppItemCard(
                  layout: AppItemCardLayout.list,
                  title: item.title,
                  dateTimeText: item.dateTime,
                  priceText: item.price,
                  badge: item.badge,
                  confidence: 0.94,
                  imageAsset: item.image,
                  isFavorite: false,
                  onTap: () {},
                  onFavoriteTap: () {},
                  onViewTap: () {
                    context.push('/market/product/${index + 1}');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback? onActionTap;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyles.boldMedium.copyWith(
              fontSize: 18.sp,
              color: AppColors.lightText,
            ),
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionLabel,
            style: TextStyles.boldSmall.copyWith(
              color: AppColors.redButton,
            ),
          ),
        ),
      ],
    );
  }
}

class _HomePromoCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback? onTap;

  const _HomePromoCard({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 18.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imageAsset, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  AppColors.gradientColor2.withValues(alpha: 0.85),
                  AppColors.gradientColor2.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.boldLarge.copyWith(
                          fontSize: 20.sp,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        subtitle,
                        style: TextStyles.regularSmall.copyWith(
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      buttonLabel,
                      style: TextStyles.boldSmall.copyWith(
                        fontSize: 13.sp,
                        color: AppColors.lightText,
                      ),
                    ),
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

class _UpcomingEventCard extends StatelessWidget {
  final String location;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback? onTap;

  const _UpcomingEventCard({
    required this.location,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.authBackBg,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientColor1, AppColors.gradientColor2],
          ),
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 18.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18.sp,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.regularSmall.copyWith(
                      fontSize: 13.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyles.boldLarge.copyWith(
                fontSize: 20.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: TextStyles.regularSmall.copyWith(
                fontSize: 13.sp,
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.25,
              ),
            ),
            SizedBox(height: 16.h),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    buttonLabel,
                    style: TextStyles.boldSmall.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.lightText,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
