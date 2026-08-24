import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class EditEventView extends StatefulWidget {
  final String eventId;

  const EditEventView({super.key, required this.eventId});

  @override
  State<EditEventView> createState() => _EditEventViewState();
}

class _EditEventViewState extends State<EditEventView> {
  bool _isVirtual = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.eventEditBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Event',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldTitle.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 28.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Update event details',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.84),
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          height: 170.h,
        ),
      ),
      body: Column(
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
                        const _ReadOnlyField('Downtown AR Treasure Hunt'),
                        SizedBox(height: 14.h),
                        _fieldLabel('Event Type'),
                        const _ReadOnlyField(
                          'AR Treasure Hunt',
                          showChevron: true,
                          textColor: AppColors.lightText,
                        ),
                        SizedBox(height: 14.h),
                        _fieldLabel('Description'),
                        const _ReadOnlyField(
                          'Join the ultimate AR treasure hunt through\n'
                          'downtown! Find hidden vintage items using\n'
                          'augmented reality and win amazing prizes.',
                          height: 78,
                          textColor: AppColors.lightText,
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
                          width: 24.w,
                          height: 13.h,
                          toggleSize: 11.h,
                          padding: 1.w,
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
                        const _ReadOnlyField(
                          'Downtown District',
                          filled: false,
                          textColor: AppColors.lightText,
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
                              child: _fieldGroup(
                                label: 'Start Date',
                                value: '02/01/2026',
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _fieldGroup(
                                label: 'Start Time',
                                value: '10:00 AM',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _fieldGroup(
                                label: 'End Date',
                                value: '02/03/2026',
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _fieldGroup(
                                label: 'End Time',
                                value: '16:00 PM',
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
                    child: const _ReadOnlyField(
                      'Public',
                      filled: false,
                      showChevron: true,
                      textColor: AppColors.lightText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const _EditEventActions(),
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

  Widget _fieldGroup({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        _ReadOnlyField(value, filled: false, textColor: AppColors.lightText),
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
}

class _ReadOnlyField extends StatelessWidget {
  final String value;
  final double? height;
  final bool filled;
  final bool showChevron;
  final Color textColor;

  const _ReadOnlyField(
    this.value, {
    this.height,
    this.filled = true,
    this.showChevron = false,
    this.textColor = AppColors.eventMetaText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height?.h ?? 40.h,
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: filled ? AppColors.authBackBg : AppColors.bodyBg,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: filled ? AppColors.authBackBg : AppColors.eventTabBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              value,
              style: TextStyles.regularExtraSmall.copyWith(
                color: textColor,
                fontSize: 15.sp,
                height: 1.25,
              ),
            ),
          ),
          if (showChevron)
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.eventMetaText,
              size: 14.sp,
            ),
        ],
      ),
    );
  }
}

class _EditEventActions extends StatelessWidget {
  const _EditEventActions();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
      color: AppColors.bodyBg,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: _BottomButton(
                  label: 'Cancel',
                  backgroundColor: AppColors.bodyBg,
                  textColor: AppColors.lightText,
                  borderColor: AppColors.eventTabBorder,
                  onTap: () => context.pop(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.w, right: 10.w),
                child: _BottomButton(
                  label: 'Update Event',
                  backgroundColor: AppColors.gradientColor1,
                  textColor: AppColors.bodyBg,
                  borderColor: AppColors.gradientColor1,
                  onTap: () => context.pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _BottomButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
