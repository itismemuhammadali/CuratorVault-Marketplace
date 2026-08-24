import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/api_service.dart';
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
  String _selectedEventType = 'General';
  String _selectedVisibility = 'Public';
  bool _isSubmitting = false;

  final List<String> _eventTypes = [
    'General',
    'Treasure Hunt',
    'Auction',
    'Exhibition',
    'Fair'
  ];

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

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      final formatted =
          "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      controller.text = formatted;
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (picked != null) {
      if (!mounted) return;
      controller.text = picked.format(context);
    }
  }

  Future<void> _submitEvent() async {
    final title = _eventTitleController.text.trim();
    final description = _descriptionController.text.trim();
    final location = _locationController.text.trim();
    final startDate = _startDateController.text.trim();
    final startTime = _startTimeController.text.trim();
    final endDate = _endDateController.text.trim();
    final endTime = _endTimeController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an event title'),
          backgroundColor: AppColors.redButton,
        ),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a description for the event'),
          backgroundColor: AppColors.redButton,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final payload = {
        'title': title,
        'event_type': _selectedEventType,
        'description': description,
        'is_virtual': _isVirtual,
        'location': location.isEmpty ? (_isVirtual ? 'Online Virtual Event' : 'TBD') : location,
        'start_date': startDate.isEmpty ? 'TBD' : startDate,
        'start_time': startTime.isEmpty ? 'TBD' : startTime,
        'end_date': endDate.isEmpty ? 'TBD' : endDate,
        'end_time': endTime.isEmpty ? 'TBD' : endTime,
        'visibility': _selectedVisibility,
      };

      await ApiService.post('/api/v1/events', payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event created successfully via Python Backend!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create event: $e'),
            backgroundColor: AppColors.redButton,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeScreenBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 18.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
                  _eventTypeDropdown(),
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
                    hintText: _isVirtual
                        ? 'Virtual Event Link / Platform'
                        : 'e.g., 123 Main St, City',
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
                            GestureDetector(
                              onTap: () => _pickDate(_startDateController),
                              child: AbsorbPointer(
                                child: AppTextField(
                                  controller: _startDateController,
                                  hintText: 'Select date',
                                  fillColor: AppColors.authBackBg,
                                  borderColor: AppColors.authBackBg,
                                  focusedBorderColor: AppColors.authBackBg,
                                  borderRadius: 12.r,
                                ),
                              ),
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
                            GestureDetector(
                              onTap: () => _pickTime(_startTimeController),
                              child: AbsorbPointer(
                                child: AppTextField(
                                  controller: _startTimeController,
                                  hintText: 'Select time',
                                  fillColor: AppColors.authBackBg,
                                  borderColor: AppColors.authBackBg,
                                  focusedBorderColor: AppColors.authBackBg,
                                  borderRadius: 12.r,
                                ),
                              ),
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
                            GestureDetector(
                              onTap: () => _pickDate(_endDateController),
                              child: AbsorbPointer(
                                child: AppTextField(
                                  controller: _endDateController,
                                  hintText: 'Select date',
                                  fillColor: AppColors.authBackBg,
                                  borderColor: AppColors.authBackBg,
                                  focusedBorderColor: AppColors.authBackBg,
                                  borderRadius: 12.r,
                                ),
                              ),
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
                            GestureDetector(
                              onTap: () => _pickTime(_endTimeController),
                              child: AbsorbPointer(
                                child: AppTextField(
                                  controller: _endTimeController,
                                  hintText: 'Select time',
                                  fillColor: AppColors.authBackBg,
                                  borderColor: AppColors.authBackBg,
                                  focusedBorderColor: AppColors.authBackBg,
                                  borderRadius: 12.r,
                                ),
                              ),
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
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.authBackBg,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.authBackBg),
                ),
                child: DropdownButton<String>(
                  value: _selectedVisibility,
                  isExpanded: true,
                  underline: const SizedBox(),
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
            btnText: _isSubmitting ? '' : 'Create Event',
            btnColor: AppColors.gradientColor1,
            borderRadius: 16.r,
            textStyle: TextStyles.semiBoldMedium.copyWith(
              color: AppColors.bodyBg,
            ),
            onTap: _isSubmitting ? () {} : _submitEvent,
            child: _isSubmitting
                ? JumpingDotsProgress(
                    text: 'Creating Event',
                    textStyle: TextStyles.semiBoldMedium.copyWith(
                      color: AppColors.bodyBg,
                    ),
                    dotColor: AppColors.bodyBg,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _eventTypeDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.authBackBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.authBackBg),
      ),
      child: DropdownButton<String>(
        value: _selectedEventType,
        isExpanded: true,
        underline: const SizedBox(),
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 18.sp,
          color: AppColors.greyText,
        ),
        items: _eventTypes.map((String value) {
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
              _selectedEventType = newValue;
            });
          }
        },
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
}
