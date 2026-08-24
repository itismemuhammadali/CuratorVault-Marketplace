import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({super.key});

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  bool _isVirtual = false;
  String _selectedVisibility = 'Public';

  @override
  void dispose() {
    _eventTitleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeScreenBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Create Event',
            style: TextStyles.boldLarge.copyWith(color: AppColors.bodyBg),
          ),
          height: 150.h,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 110.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(
              title: 'Basic Information',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Event Title'),
                  AppTextField(
                    controller: _eventTitleController,
                    hintText: 'e.g., Downtown AR Treasure Hunt',
                    fillColor: AppColors.authBackBg,
                    borderColor: AppColors.authBackBg,
                    focusedBorderColor: AppColors.authBackBg,
                    borderRadius: 12.r,
                  ),
                  SizedBox(height: 14.h),
                  _fieldLabel('Event Type'),
                  _selectField('Select event type'),
                  SizedBox(height: 14.h),
                  _fieldLabel('Description'),
                  AppTextField(
                    controller: _descriptionController,
                    hintText: 'Describe the event...',
                    fillColor: AppColors.authBackBg,
                    borderColor: AppColors.authBackBg,
                    focusedBorderColor: AppColors.authBackBg,
                    borderRadius: 12.r,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            _sectionCard(
              title: 'Location',
              leadingIcon: AppImages.mapMarkerOutlinedIcon,
              trailing: Row(
                children: [
                  Text(
                    'Virtual',
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.lightText,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  FlutterSwitch(
                    value: _isVirtual,
                    width: 44.w,
                    height: 24.h,
                    toggleSize: 18.h,
                    borderRadius: 24.r,
                    padding: 2.w,
                    activeColor: AppColors.switchActiveTrack,
                    inactiveColor: AppColors.switchInactiveTrack,
                    toggleColor: AppColors.bodyBg,
                    onToggle: (value) {
                      setState(() {
                        _isVirtual = value;
                      });
                    },
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('GPS Location / Address'),
                  AppTextField(
                    controller: _locationController,
                    hintText: 'e.g., 123 Main St, City',
                    fillColor: AppColors.authBackBg,
                    borderColor: AppColors.authBackBg,
                    focusedBorderColor: AppColors.authBackBg,
                    borderRadius: 12.r,
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            _dateTimeCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('Start Date'),
                            AppTextField(
                              controller: _startDateController,
                              hintText: '02/01/2026',
                              fillColor: AppColors.authBackBg,
                              borderColor: AppColors.authBackBg,
                              focusedBorderColor: AppColors.authBackBg,
                              borderRadius: 12.r,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('Start Time'),
                            AppTextField(
                              controller: _startTimeController,
                              hintText: '10:00 AM',
                              fillColor: AppColors.authBackBg,
                              borderColor: AppColors.authBackBg,
                              focusedBorderColor: AppColors.authBackBg,
                              borderRadius: 12.r,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('End Date'),
                            AppTextField(
                              controller: _endDateController,
                              hintText: '02/03/2026',
                              fillColor: AppColors.authBackBg,
                              borderColor: AppColors.authBackBg,
                              focusedBorderColor: AppColors.authBackBg,
                              borderRadius: 12.r,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('End Time'),
                            AppTextField(
                              controller: _endTimeController,
                              hintText: '16:00 PM',
                              fillColor: AppColors.authBackBg,
                              borderColor: AppColors.authBackBg,
                              focusedBorderColor: AppColors.authBackBg,
                              borderRadius: 12.r,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            _sectionCard(
              title: 'Visibility',
              leadingIcon: AppImages.eyeOutlinedIcon,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.authBackBg,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.authBackBg),
                ),
                child: DropdownButton<String>(
                  value: _selectedVisibility,
                  isExpanded: true,
                  underline: SizedBox(),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 18.sp,
                    color: AppColors.greyText,
                  ),
                  items: ['Public', 'Private'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyles.regularSmall.copyWith(
                          color: AppColors.lightText,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedVisibility = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
          child: CustomButton(
            btnText: 'Create Event',
            btnColor: AppColors.gradientColor1,
            borderRadius: 16.r,
            textStyle: TextStyles.semiBoldMedium.copyWith(
              color: AppColors.bodyBg,
            ),
            onTap: () {},
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    String? leadingIcon,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leadingIcon != null) ...[
                Image.asset(
                  leadingIcon,
                  width: 18.w,
                  height: 18.h,
                  color: AppColors.lightText,
                ),
                SizedBox(width: 8.w),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyles.semiBoldMedium.copyWith(
                    color: AppColors.lightText,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }

  Widget _dateTimeCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 18.sp,
                color: const Color(0xFF2D3E55),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Date & Time',
                  style: TextStyles.semiBoldMedium.copyWith(
                    color: AppColors.lightText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyles.regularSmall.copyWith(color: AppColors.lightText),
      ),
    );
  }

  Widget _selectField(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.authBackBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.authBackBg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: TextStyles.regularSmall.copyWith(
                color: AppColors.greyText,
              ),
            ),
          ),
          Image.asset(
            AppImages.chevronIcon,
            width: 16.w,
            height: 16.h,
            color: AppColors.greyText,
          ),
        ],
      ),
    );
  }
}
