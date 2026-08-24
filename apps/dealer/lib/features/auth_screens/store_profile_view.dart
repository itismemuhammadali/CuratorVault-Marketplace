import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/auth_screens/dealer_onboarding_scaffold.dart';

class StoreProfileView extends StatefulWidget {
  const StoreProfileView({super.key});

  @override
  State<StoreProfileView> createState() => _StoreProfileViewState();
}

class _StoreProfileViewState extends State<StoreProfileView> {
  final _storeNameController = TextEditingController(text: 'Vintage Treasures');
  final _descriptionController = TextEditingController(
    text:
        'Tell buyers about your store, your expertise, and what makes your antiques special...',
  );
  final _websiteController = TextEditingController(
    text: 'https://yourstore.com',
  );
  final _instagramController = TextEditingController(text: '@yourstorename');
  final _facebookController = TextEditingController(
    text: 'facebook.com/yourstore',
  );

  final Set<String> _specialties = {'Furniture', 'Jewelry'};

  final List<String> _allSpecialties = const [
    'Furniture',
    'Jewelry',
    'Art & Paintings',
    'Ceramics & Pottery',
    'Glassware',
    'Textiles',
    'Books & Manuscripts',
    'Collectibles',
    'Silver & Metalwork',
    'Vintage Fashion',
  ];

  @override
  void dispose() {
    _storeNameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    super.dispose();
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyles.mediumMedium.copyWith(
          color: AppColors.lightText,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, {int maxLines = 1, String? svgIcon}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyles.regularMedium.copyWith(
        color: AppColors.lightText,
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        prefixIcon: svgIcon != null
            ? Padding(
                padding: EdgeInsets.all(12.w),
                child: SvgPicture.asset(
                  svgIcon,
                  width: 4.sp,
                  height: 4.sp,
                  colorFilter: const ColorFilter.mode(
                    AppColors.greyText,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF7F8FB),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: AppColors.lightText.withValues(alpha: 0.10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: AppColors.lightText.withValues(alpha: 0.10),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: AppColors.redButton.withValues(alpha: 0.28),
          ),
        ),
      ),
    );
  }

  Widget _uploadRow() {
    return Row(
      children: [
        Container(
          width: 58.w,
          height: 58.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F7),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE3E6EC)),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: SvgPicture.asset(
              'assets/icons/image_icon.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.greyText,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: CustomButton(
            onTap: () {},
            height: 44.h,
            borderRadius: 12.r,
            btnColor: AppColors.gradientColor1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/upload_icon.svg',
                  width: 18.sp,
                  height: 18.sp,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Upload Logo',
                  style: TextStyles.mediumMedium.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bannerUpload() {
    return Container(
      width: double.infinity,
      height: 112.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FB),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE3E6EC)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/image_icon.svg',
            width: 30.sp,
            height: 30.sp,
            colorFilter: const ColorFilter.mode(
              AppColors.greyText,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Click to upload banner',
            style: TextStyles.regularSmall.copyWith(color: AppColors.greyText),
          ),
        ],
      ),
    );
  }

  Widget _specialtyChip(String label) {
    final selected = _specialties.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) {
            _specialties.remove(label);
          } else {
            _specialties.add(label);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.gradientColor1 : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFE3E6EC)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.regularSmall.copyWith(
              fontSize: 12.sp,
              color: selected ? Colors.white : AppColors.lightText,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DealerOnboardingScaffold(
      title: 'Store Profile',
      subtitle: 'Create your dealer storefront',
      step: 3,
      totalSteps: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Store Logo *'),
          _uploadRow(),
          SizedBox(height: 8.h),
          Text(
            'Recommended: 500x500px, PNG or JPG',
            style: TextStyles.regularSmall.copyWith(color: AppColors.greyText),
          ),
          SizedBox(height: 16.h),
          _fieldLabel('Store Banner'),
          _bannerUpload(),
          SizedBox(height: 8.h),
          Text(
            'Recommended: 1200x400px, PNG or JPG',
            style: TextStyles.regularSmall.copyWith(color: AppColors.greyText),
          ),
          SizedBox(height: 16.h),
          _fieldLabel('Store Name *'),
          _input(_storeNameController, svgIcon: 'assets/icons/store_icon.svg'),
          SizedBox(height: 16.h),
          _fieldLabel('Store Description *'),
          _input(_descriptionController, maxLines: 4),
          SizedBox(height: 6.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '0/500 characters',
              style: TextStyles.regularSmall.copyWith(
                color: AppColors.greyText,
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'Your Specialties *',
            style: TextStyles.boldMedium.copyWith(
              color: AppColors.lightText,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Select all that apply (minimum 2)',
            style: TextStyles.regularSmall.copyWith(color: AppColors.greyText),
          ),
          SizedBox(height: 12.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final chipWidth = (constraints.maxWidth - 10.w) / 2;

              return Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: _allSpecialties
                    .map(
                      (specialty) => SizedBox(
                        width: chipWidth,
                        child: _specialtyChip(specialty),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          SizedBox(height: 18.h),
          Text(
            'Social Media (Optional)',
            style: TextStyles.boldMedium.copyWith(
              color: AppColors.lightText,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 14.h),
          _fieldLabel('Website'),
          _input(_websiteController),
          SizedBox(height: 14.h),
          _fieldLabel('Instagram'),
          _input(_instagramController),
          SizedBox(height: 14.h),
          _fieldLabel('Facebook'),
          _input(_facebookController),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFD0E2FF)),
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyles.regularSmall.copyWith(
                  color: const Color(0xFF2E5AAC),
                  height: 1.4,
                ),
                children: const [
                  TextSpan(
                    text: 'Pro Tip:\n',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text:
                        'A complete profile with great photos helps build buyer trust and increases sales by up to 70%.',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          CustomButton(
            onTap: () => context.push('/dealer/identity-verification'),
            height: 50.h,
            borderRadius: 14.r,
            btnColor: AppColors.gradientColor1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue',
                  style: TextStyles.mediumMedium.copyWith(
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
