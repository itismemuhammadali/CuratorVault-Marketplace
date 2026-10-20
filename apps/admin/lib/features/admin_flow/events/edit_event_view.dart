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
import 'package:vintage_app/core/theme/text_styles.dart';

class EditEventView extends StatefulWidget {
  final String eventId;

  const EditEventView({super.key, required this.eventId});

  @override
  State<EditEventView> createState() => _EditEventViewState();
}

class _EditEventViewState extends State<EditEventView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isVirtual = false;
  String _selectedEventType = 'General';
  String _selectedVisibility = 'Public';
  String _selectedStatus = 'Upcoming';

  final List<String> _eventTypes = [
    'General',
    'Treasure Hunt',
    'Auction',
    'Exhibition',
    'Fair'
  ];

  final List<String> _statuses = [
    'Upcoming',
    'Ongoing',
    'Past',
  ];

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    try {
      final res = await ApiService.get('/api/v1/events/${widget.eventId}');
      if (res is Map && res.containsKey('event') && res['event'] is Map) {
        final data = Map<String, dynamic>.from(res['event']);
        setState(() {
          _titleController.text = data['title'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _locationController.text = data['location'] ?? '';
          _startDateController.text = data['start_date'] ?? '';
          _startTimeController.text = data['start_time'] ?? '';
          _endDateController.text = data['end_date'] ?? '';
          _endTimeController.text = data['end_time'] ?? '';
          _isVirtual = data['is_virtual'] ?? false;
          _selectedEventType = data['event_type'] ?? 'General';
          if (!_eventTypes.contains(_selectedEventType)) {
            _selectedEventType = 'General';
          }
          _selectedVisibility = data['visibility'] ?? 'Public';
          _selectedStatus = data['status'] ?? 'Upcoming';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error loading event to edit: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
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

  Future<void> _saveChanges() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an event title'),
          backgroundColor: AppColors.redButton,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final payload = {
        'title': _titleController.text.trim(),
        'event_type': _selectedEventType,
        'description': _descriptionController.text.trim(),
        'is_virtual': _isVirtual,
        'location': _locationController.text.trim(),
        'start_date': _startDateController.text.trim(),
        'start_time': _startTimeController.text.trim(),
        'end_date': _endDateController.text.trim(),
        'end_time': _endTimeController.text.trim(),
        'visibility': _selectedVisibility,
        'status': _selectedStatus,
      };

      await ApiService.put('/api/v1/events/${widget.eventId}', payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update event: $e'),
            backgroundColor: AppColors.redButton,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
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
      backgroundColor: AppColors.eventEditBg,
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Event',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldTitle.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Update event details',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.84),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          height: 160.h,
        ),
      ),
      body: _isLoading
          ? Center(
              child: JumpingDotsProgress(
                text: 'Loading Event',
                textStyle: TextStyles.semiBoldMedium.copyWith(
                  color: AppColors.lightText,
                ),
                dotColor: AppColors.gradientColor1,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(15.w, 16.h, 15.w, 14.h),
                    child: Column(
                      children: [
                        _sectionCard(
                          title: 'Basic Information',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel('Event Title'),
                              AppTextField(
                                controller: _titleController,
                                hintText: 'Event Title',
                                fillColor: AppColors.bodyBg,
                                borderColor: AppColors.eventTabBorder,
                                focusedBorderColor: AppColors.gradientColor1,
                                borderRadius: 8.r,
                              ),
                              SizedBox(height: 14.h),
                              _fieldLabel('Event Type'),
                              _dropdownContainer(
                                value: _selectedEventType,
                                items: _eventTypes,
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedEventType = val);
                                  }
                                },
                              ),
                              SizedBox(height: 14.h),
                              _fieldLabel('Status'),
                              _dropdownContainer(
                                value: _selectedStatus,
                                items: _statuses,
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedStatus = val);
                                  }
                                },
                              ),
                              SizedBox(height: 14.h),
                              _fieldLabel('Description'),
                              AppTextField(
                                controller: _descriptionController,
                                hintText: 'Description',
                                fillColor: AppColors.bodyBg,
                                borderColor: AppColors.eventTabBorder,
                                focusedBorderColor: AppColors.gradientColor1,
                                borderRadius: 8.r,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _sectionCard(
                          title: 'Location',
                          icon: Icons.location_on_outlined,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Virtual',
                                style: TextStyles.semiBoldExtraSmall.copyWith(
                                  color: AppColors.lightText,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              FlutterSwitch(
                                value: _isVirtual,
                                width: 36.w,
                                height: 20.h,
                                toggleSize: 16.h,
                                padding: 2.w,
                                borderRadius: 12.r,
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
                                hintText: _isVirtual ? 'Virtual Event Link' : 'Location / Address',
                                fillColor: AppColors.bodyBg,
                                borderColor: AppColors.eventTabBorder,
                                focusedBorderColor: AppColors.gradientColor1,
                                borderRadius: 8.r,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _sectionCard(
                          title: 'Date & Time',
                          icon: Icons.calendar_month_outlined,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _datePickerField(
                                      label: 'Start Date',
                                      controller: _startDateController,
                                      onTap: () => _pickDate(_startDateController),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: _datePickerField(
                                      label: 'Start Time',
                                      controller: _startTimeController,
                                      onTap: () => _pickTime(_startTimeController),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: _datePickerField(
                                      label: 'End Date',
                                      controller: _endDateController,
                                      onTap: () => _pickDate(_endDateController),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: _datePickerField(
                                      label: 'End Time',
                                      controller: _endTimeController,
                                      onTap: () => _pickTime(_endTimeController),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _sectionCard(
                          title: 'Visibility',
                          icon: Icons.visibility_outlined,
                          child: _dropdownContainer(
                            value: _selectedVisibility,
                            items: ['Public', 'Private'],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedVisibility = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _editEventActions(),
              ],
            ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
    IconData? icon,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 13.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.eventMetaText, size: 14.sp),
                SizedBox(width: 6.w),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyles.boldMedium.copyWith(
                    color: AppColors.gradientColor1,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _dropdownContainer({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.eventTabBorder),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.eventMetaText,
          size: 20.sp,
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyles.regularSmall.copyWith(
                color: AppColors.lightText,
                fontSize: 14.sp,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _datePickerField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            child: AppTextField(
              controller: controller,
              hintText: 'Select',
              fillColor: AppColors.bodyBg,
              borderColor: AppColors.eventTabBorder,
              focusedBorderColor: AppColors.gradientColor1,
              borderRadius: 8.r,
            ),
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.h),
      child: Text(
        label,
        style: TextStyles.boldExtraSmall.copyWith(
          color: AppColors.lightText,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _editEventActions() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
      color: AppColors.bodyBg,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: _bottomButton(
                label: 'Cancel',
                backgroundColor: AppColors.bodyBg,
                textColor: AppColors.lightText,
                borderColor: AppColors.eventTabBorder,
                onTap: () => context.pop(),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _bottomButton(
                label: _isSaving ? 'Updating...' : 'Update Event',
                backgroundColor: AppColors.gradientColor1,
                textColor: AppColors.bodyBg,
                borderColor: AppColors.gradientColor1,
                onTap: _isSaving ? () {} : _saveChanges,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            if (backgroundColor == AppColors.gradientColor1)
              BoxShadow(
                color: AppColors.shadowColor.withValues(alpha: 0.14),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.boldExtraSmall.copyWith(
              color: textColor,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}
