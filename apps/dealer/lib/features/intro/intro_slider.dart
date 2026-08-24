import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vintage_app/core/components/includes/intro_slider_layout.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({super.key});

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFF2B2B2B),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 4.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2C3B53), Color(0xFF182436)],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  28.w,
                  topInset + 12.h,
                  28.w,
                  28.h,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            AppImages.userImg,
                            width: 54.w,
                            height: 54.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            _currentIndex == 2 ? '' : 'Skip',
                            style: TextStyles.regularMedium.copyWith(
                              color: const Color(0xFFF8E8C7),
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: PageView(
                        controller: _controller,
                        onPageChanged: (index) {
                          setState(() => _currentIndex = index);
                        },
                        children: const [
                          IntroSliderLayout(
                            title: 'List Antiques Easily',
                            description:
                                'Scan or upload items to create listings instantly',
                            image: 'assets/images/intro1.png',
                          ),
                          IntroSliderLayout(
                            title: 'Reach Verified Buyers',
                            description:
                                'Sell through a trusted escrow-based marketplace',
                            image: 'assets/images/intro2.png',
                          ),
                          IntroSliderLayout(
                            title: 'Grow with Insights',
                            description:
                                'Track sales, views, and performance analytics',
                            image: 'assets/images/intro3.png',
                          ),
                        ],
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        dotHeight: 6.h,
                        dotWidth: 6.w,
                        spacing: 7.w,
                        expansionFactor: 3.2,
                        activeDotColor: const Color(0xFFF8E8C7),
                        dotColor: Colors.white.withValues(alpha: 0.45),
                      ),
                    ),
                    SizedBox(height: 26.h),
                    CustomButton(
                      onTap: () {
                        if (_currentIndex == 2) {
                          context.go('/login');
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                      height: 56.h,
                      borderRadius: 14.r,
                      btnColor: AppColors.redButton,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentIndex == 2 ? 'Sign in' : 'Next',
                            style: TextStyles.boldMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
