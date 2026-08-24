import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class EditItemView extends StatefulWidget {
  final String itemId;
  final bool isNewItem;
  final Map<String, dynamic> listingData;

  const EditItemView({
    super.key,
    required this.itemId,
    this.isNewItem = false,
    this.listingData = const {},
  });

  @override
  State<EditItemView> createState() => _EditItemViewState();
}

class _EditItemViewState extends State<EditItemView> {
  String _selectedCondition = 'Excellent';
  String? _selectedCategory;

  static const List<String> _conditions = ['Excellent', 'Good', 'Fair', 'Poor'];
  static const List<String> _categories = ['Horology', 'Furniture'];

  static final Map<String, _EditableItem> _items = {
    '1': const _EditableItem(
      title: 'Victorian Mahogany Chair',
      views: '124',
      image: AppImages.productOne,
      categoryHint: 'Select category',
      eraHint: 'e.g., Victorian Era (1837-1901)',
      caseMaterialHint: 'e.g. Gold-plated brass',
      diameterHint: 'e.g. Victorian Era (1837-1901)',
    ),
    '2': const _EditableItem(
      title: 'Antique Oak Cabinet',
      views: '89',
      image: AppImages.productFour,
      categoryHint: 'Select category',
      eraHint: 'e.g., Victorian Era (1837-1901)',
      caseMaterialHint: 'e.g. Gold-plated brass',
      diameterHint: 'e.g. Victorian Era (1837-1901)',
    ),
    '3': const _EditableItem(
      title: 'Porcelain Vase Collection',
      views: '156',
      image: AppImages.productThree,
      categoryHint: 'Select category',
      eraHint: 'e.g., Victorian Era (1837-1901)',
      caseMaterialHint: 'e.g. Gold-plated brass',
      diameterHint: 'e.g. Victorian Era (1837-1901)',
    ),
    '4': const _EditableItem(
      title: 'Vintage Pocket Watch',
      views: '0',
      image: AppImages.productFive,
      categoryHint: 'Select category',
      eraHint: 'e.g., Victorian Era (1837-1901)',
      caseMaterialHint: 'e.g. Gold-plated brass',
      diameterHint: 'e.g. Victorian Era (1837-1901)',
    ),
  };

  _EditableItem get _item => _items[widget.itemId] ?? _items['1']!;

  void _goInventory() {
    context.go('/dealer/my-finds');
  }

  String get _headerTitle => widget.isNewItem ? 'Item Details' : 'Edit Item';

  @override
  Widget build(BuildContext context) {
    final item = _item;

    return Scaffold(
      backgroundColor: AppColors.authBackBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: IconBox(
            icon: AppImages.backIcon,
            bgColor: AppColors.darkText.withValues(alpha: 0.20),
            onTap: _goInventory,
            iconColor: AppColors.darkText,
            height: 40.h,
            width: 40.w,
            borderRadius: 100.r,
          ),
          title: Text(
            _headerTitle,
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 28.sp,
            ),
          ),
          height: 170.h,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 18.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: const Color(0xFFD3D8E0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: widget.isNewItem && widget.listingData['imagePath'] != null
                            ? Image.file(
                                File(widget.listingData['imagePath'] as String),
                                height: 250.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                item.image,
                                height: 250.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC8F0DA),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Live',
                            style: TextStyles.mediumMedium.copyWith(
                              color: const Color(0xFF0A8F4D),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowColor.withValues(
                                  alpha: 0.09,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye_outlined,
                                size: 17.sp,
                                color: const Color(0xFF2F6BFF),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '${item.views} views',
                                style: TextStyles.mediumMedium.copyWith(
                                  color: const Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _fieldLabel('Title'),
                    _textField(hint: 'e.g., Victorian Mahogany Chair'),
                    SizedBox(height: 10.h),
                    _fieldLabel('Category'),
                    _categoryDropdown(hint: item.categoryHint),
                    SizedBox(height: 10.h),
                    _fieldLabel('Era / Style'),
                    _textField(hint: item.eraHint),
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
                                  color: _selectedCondition == _conditions[i]
                                      ? AppColors.bodyBg
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: const Color(0xFFD3D8E0),
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
                    _textField(hint: item.diameterHint),
                    SizedBox(height: 10.h),
                    _fieldLabel('Case Material'),
                    _textField(hint: item.caseMaterialHint),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _goInventory,
                            child: Container(
                              height: 54.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1D5DB),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Cancel',
                                style: TextStyles.mediumMedium.copyWith(
                                  color: const Color(0xFF374151),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: _goInventory,
                            child: Container(
                              height: 54.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D2F4D),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Save Changes',
                                style: TextStyles.mediumMedium.copyWith(
                                  color: AppColors.bodyBg,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: maxLines,
              minLines: maxLines,
              style: TextStyles.mediumMedium.copyWith(
                color: const Color(0xFF111827),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
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

class _EditableItem {
  final String title;
  final String views;
  final String image;
  final String categoryHint;
  final String eraHint;
  final String diameterHint;
  final String caseMaterialHint;

  const _EditableItem({
    required this.title,
    required this.views,
    required this.image,
    required this.categoryHint,
    required this.eraHint,
    required this.diameterHint,
    required this.caseMaterialHint,
  });
}
