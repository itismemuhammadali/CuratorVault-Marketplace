import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/components/includes/intro_slider_layout.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({super.key});

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  
  final PageController _controller = PageController();
  int currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.gradientColor1, AppColors.gradientColor2],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: SizedBox(
            height: 60,
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                AppImages.splashImage,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          actions: [
            // CustomButton(
            //   onTap: () {},
            //   btnText: currentIndex == 2 ? '' : 'Skip',
            //   textColor: AppColors.darkText,
            //   textStyle: TextStyles.normalParaDarkText,
            //   width: double.minPositive,
            //   height: 0,
            // ),
            TextButton(
              onPressed: () {
                context.go("/login");
              },
              child: Text(
                currentIndex == 2 ? '' : 'Skip',
                style: TextStyles.regularSmall.copyWith(
                  color: AppColors.darkText,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                children: const [
                  IntroSliderLayout(
                    title: 'AI-Powered Recognition',
                    description:
                        'Simply scan any antique with your camera and our advanced AI instantly identifies it, providing detailed information about its origin, age, and market value.',
                    image: 'assets/images/intro1.png',
                  ),
                  IntroSliderLayout(
                    title: 'Build Your Collection',
                    description:
                        'Save every discovery in your personal digital collection. Track authenticity scores, export detailed reports, and organize items by category, era, or value.',
                    image: 'assets/images/intro2.png',
                  ),
                  IntroSliderLayout(
                    title: 'Verified & Secure',
                    description:
                        'All items are verified by AI and certified experts. Your data is encrypted and secure. Buy, sell, and trade antiques with confidence on our trusted marketplace.',
                    image: 'assets/images/intro3.png',
                  ),
                ],
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: AppColors.darkText,
                        dotColor: AppColors.grey.withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(height: 16),
                    CustomButton(
                      onTap: () {
                        if (currentIndex == 2) {
                          context.go("/login");
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      height: 60.h,
                      btnText: currentIndex == 2 ? 'Start' : 'Next',
                      btnColor: AppColors.redButton,
                      textStyle: TextStyles.boldMedium.copyWith(
                        color: AppColors.darkText,
                      ),
                      borderRadius: 5.sp,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
