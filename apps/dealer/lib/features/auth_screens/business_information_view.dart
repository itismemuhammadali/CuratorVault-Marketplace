import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/auth_screens/dealer_onboarding_scaffold.dart';

class BusinessInformationView extends StatefulWidget {
  const BusinessInformationView({super.key});

  @override
  State<BusinessInformationView> createState() =>
      _BusinessInformationViewState();
}

class _BusinessInformationViewState extends State<BusinessInformationView> {
  late final TextEditingController _businessNameController;
  late final TextEditingController _businessTypeController;
  late final TextEditingController _taxIdController;
  late final TextEditingController _phoneController;
  late final TextEditingController _yearsController;
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipController;
  late final TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController(
      text: 'Vintage Treasures Inc.',
    );
    _businessTypeController = TextEditingController(
      text: 'Select business type',
    );
    _taxIdController = TextEditingController(text: 'XX-XXXXXXX');
    _phoneController = TextEditingController(text: '+1 (555) 000-0000');
    _yearsController = TextEditingController(text: 'Select years');
    _streetController = TextEditingController(text: '123 Main Street');
    _cityController = TextEditingController(text: 'New York');
    _stateController = TextEditingController(text: 'NY');
    _zipController = TextEditingController(text: '10001');
    _countryController = TextEditingController(text: 'United States');
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessTypeController.dispose();
    _taxIdController.dispose();
    _phoneController.dispose();
    _yearsController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
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

  Widget _input(TextEditingController controller, {IconData? icon, String? svgIcon}) {
    return TextField(
      controller: controller,
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
            : (icon == null
                ? null
                : Icon(icon, size: 24.sp, color: AppColors.greyText)),
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

  Widget _responsivePair({required Widget first, required Widget second}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 420) {
          return Column(
            children: [
              first,
              SizedBox(height: 14.h),
              second,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: first),
            SizedBox(width: 12.w),
            Expanded(child: second),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DealerOnboardingScaffold(
      title: 'Business Information',
      subtitle: 'Tell us about your antique business',
      step: 2,
      totalSteps: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Business Name *'),
          _input(_businessNameController, svgIcon: 'assets/icons/business_icon.svg'),
          SizedBox(height: 14.h),
          _fieldLabel('Business Type *'),
          _input(_businessTypeController),
          SizedBox(height: 14.h),
          _fieldLabel('Tax ID / EIN *'),
          _input(_taxIdController, svgIcon: 'assets/icons/document_icon.svg'),
          SizedBox(height: 14.h),
          _fieldLabel('Business Phone *'),
          _input(_phoneController, icon: Icons.phone_outlined),
          SizedBox(height: 14.h),
          _fieldLabel('Years in Business *'),
          _input(_yearsController),
          SizedBox(height: 18.h),
          Text(
            'Business Address',
            style: TextStyles.boldMedium.copyWith(
              color: AppColors.lightText,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 14.h),
          _fieldLabel('Street Address *'),
          _input(_streetController, svgIcon: 'assets/icons/location_icon.svg'),
          SizedBox(height: 14.h),
          _responsivePair(
            first: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_fieldLabel('City *'), _input(_cityController)],
            ),
            second: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_fieldLabel('State *'), _input(_stateController)],
            ),
          ),
          SizedBox(height: 14.h),
          _responsivePair(
            first: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_fieldLabel('ZIP Code *'), _input(_zipController)],
            ),
            second: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_fieldLabel('Country *'), _input(_countryController)],
            ),
          ),
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
                    text: 'Why we need this:\n',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text:
                        'Business information helps us verify your identity and comply with regulations.',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          CustomButton(
            onTap: () => context.push('/dealer/store-profile'),
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
