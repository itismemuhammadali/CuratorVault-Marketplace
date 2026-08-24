import 'dart:io';

import 'package:flutter/foundation.dart';
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

class AiScanResultView extends StatefulWidget {
  final String? imagePath;

  const AiScanResultView({super.key, this.imagePath});

  @override
  State<AiScanResultView> createState() => _AiScanResultViewState();
}

class _AiScanResultViewState extends State<AiScanResultView> {
  String _selectedCondition = 'Excellent';
  String? _selectedCategory;

  static const List<String> _conditions = ['Excellent', 'Good', 'Fair', 'Poor'];
  static const List<String> _categories = ['Furniture', 'Horology'];

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/user/scan');
  }

  @override
  Widget build(BuildContext context) {
    final selectedImage =
        (!kIsWeb &&
            widget.imagePath != null &&
            File(widget.imagePath!).existsSync())
        ? Image.file(File(widget.imagePath!), fit: BoxFit.cover)
        : Image.asset(AppImages.productTwo, fit: BoxFit.cover);

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
            'Item Details',
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
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: SizedBox(
                        width: double.infinity,
                        height: 168.h,
                        child: selectedImage,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _fieldLabel('Title'),
                    _textField(hint: 'e.g., Victorian Mahogany Chair'),
                    SizedBox(height: 10.h),
                    _fieldLabel('Category'),
                    _categoryDropdown(hint: 'Select category'),
                    SizedBox(height: 10.h),
                    _fieldLabel('Era / Style'),
                    _textField(hint: 'e.g., Victorian Era (1837-1901)'),
                    SizedBox(height: 12.h),
                    _fieldLabel('Condition'),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        for (int i = 0; i < _conditions.length; i++) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCondition = _conditions[i];
                                });
                              },
                              child: Container(
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: AppColors.authBackBg,
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: _selectedCondition == _conditions[i]
                                        ? const Color(0xFFB8BFC9)
                                        : const Color(0xFFD3D8E0),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _conditions[i],
                                  style: TextStyles.mediumMedium.copyWith(
                                    color: const Color(0xFF202124),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (i != _conditions.length - 1) SizedBox(width: 8.w),
                        ],
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _fieldLabel('Description'),
                    _textField(
                      hint:
                          "Describe the item's history, features, and provenance...",
                      maxLines: 4,
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'Specifications',
                      style: TextStyles.boldLarge.copyWith(
                        color: const Color(0xFF202124),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _fieldLabel('Diameter'),
                    _textField(hint: 'e.g., Victorian Era (1837-1901)'),
                    SizedBox(height: 10.h),
                    _fieldLabel('Case Material'),
                    _textField(hint: 'e.g Gold-plated brass'),
                    SizedBox(height: 12.h),
                    OutlinedButton(
                      onPressed: () {
                        context.push(
                          '/user/scan/result/additional-specifications',
                          extra: widget.imagePath,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 52.h),
                        side: const BorderSide(color: Color(0xFF445A7A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'Add another specifications',
                        style: TextStyles.mediumMedium.copyWith(
                          color: const Color(0xFF334155),
                        ),
                      ),
                    ),
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

  Widget _textField({required String hint, int maxLines = 1}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD3D8E0)),
      ),
      child: TextField(
        maxLines: maxLines,
        minLines: maxLines,
        style: TextStyles.mediumMedium.copyWith(color: const Color(0xFF111827)),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyles.regularMedium.copyWith(
            color: const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _categoryDropdown({required String hint}) {
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
          value: _selectedCategory,
          isExpanded: true,
          hint: Text(
            hint,
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
          items: _categories
              .map(
                (category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
        ),
      ),
    );
  }
}
