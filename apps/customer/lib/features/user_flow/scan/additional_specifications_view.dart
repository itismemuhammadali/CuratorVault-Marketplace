import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AdditionalSpecificationsView extends StatefulWidget {
  final String? imagePath;

  const AdditionalSpecificationsView({super.key, this.imagePath});

  @override
  State<AdditionalSpecificationsView> createState() =>
      _AdditionalSpecificationsViewState();
}

enum _ListingType { fixedPrice, auction }

class _AdditionalSpecificationsViewState
    extends State<AdditionalSpecificationsView> {
  _ListingType _selectedListingType = _ListingType.fixedPrice;

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _startingBidController = TextEditingController();
  String? _selectedDuration;

  static const List<String> _durations = [
    '3 days',
    '5 days',
    '7 days',
    '14 days',
  ];

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/user/scan/result');
  }

  @override
  void dispose() {
    _priceController.dispose();
    _startingBidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: IconBox(
            icon: AppImages.backIcon,
            bgColor: AppColors.darkText.withValues(alpha: 0.20),
            onTap: _goBack,
            iconColor: AppColors.darkText,
            height: 40.h,
            width: 40.w,
            borderRadius: 100.r,
          ),
          title: Text(
            'Listing Type',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 24.sp,
            ),
          ),
          height: 170.h,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ListingCard(
                      icon: AppImages.offerIcon,
                      title: 'Fixed Price',
                      subtitle: 'Set a fixed price for immediate purchase',
                      selected: _selectedListingType == _ListingType.fixedPrice,
                      onTap: () {
                        setState(() {
                          _selectedListingType = _ListingType.fixedPrice;
                        });
                      },
                    ),
                    SizedBox(height: 12.h),
                    _ListingCard(
                      icon: AppImages.clockIcon,
                      title: 'Auction',
                      subtitle: 'Let buyers bid with a starting price',
                      selected: _selectedListingType == _ListingType.auction,
                      onTap: () {
                        setState(() {
                          _selectedListingType = _ListingType.auction;
                        });
                      },
                    ),
                    SizedBox(height: 14.h),
                    if (_selectedListingType == _ListingType.fixedPrice) ...[
                      _fieldLabel('Price'),
                      _priceField(controller: _priceController),
                    ] else ...[
                      _fieldLabel('Starting Bid'),
                      _priceField(controller: _startingBidController),
                      SizedBox(height: 10.h),
                      _fieldLabel('Auction Duration'),
                      _durationDropdown(),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 12.h),
              child: CustomButton(
                height: 52.h,
                borderRadius: 12.r,
                btnColor: const Color(0xFF2B3F5F),
                onTap: () => context.go('/user/my-finds'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.bodyBg,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.bodyBg,
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: TextStyles.mediumMedium.copyWith(color: const Color(0xFF374151)),
      ),
    );
  }

  Widget _priceField({required TextEditingController controller}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD3D8E0)),
      ),
      child: Row(
        children: [
          Text(
            '\$',
            style: TextStyles.mediumMedium.copyWith(
              color: const Color(0xFF94A3B8),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyles.mediumMedium.copyWith(
                color: const Color(0xFF111827),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '0.00',
                hintStyle: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _durationDropdown() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD3D8E0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedDuration,
          isExpanded: true,
          hint: Text(
            'Select duration',
            style: TextStyles.regularMedium.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: const Color(0xFF9CA3AF),
          ),
          style: TextStyles.mediumMedium.copyWith(
            color: const Color(0xFF111827),
          ),
          dropdownColor: AppColors.bodyBg,
          items: _durations
              .map(
                (duration) => DropdownMenuItem<String>(
                  value: duration,
                  child: Text(duration),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedDuration = value;
            });
          },
        ),
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ListingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? AppColors.redButton
        : const Color(0xFFD8DDE5);
    final backgroundColor = selected ? AppColors.authBackBg : AppColors.bodyBg;
    final radioBorder = selected
        ? AppColors.redButton
        : const Color(0xFFC7CFDA);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: AppColors.redButton.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Image.asset(
                  icon,
                  width: 20.w,
                  height: 20.w,
                  color: AppColors.redButton,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    style: TextStyles.boldMedium.copyWith(
                      color: const Color(0xFF202124),
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    subtitle,
                    style: TextStyles.regularMedium.copyWith(
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.redButton : Colors.transparent,
                border: Border.all(color: radioBorder, width: 1.4),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
