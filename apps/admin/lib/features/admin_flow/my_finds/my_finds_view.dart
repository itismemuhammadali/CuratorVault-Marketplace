import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/global_layout/main_layout.dart';
import 'package:vintage_app/core/components/includes/horizontal_chip_bar.dart';
import 'package:vintage_app/features/admin_flow/my_finds/widgets/delete_item_dialog.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class MyFindsView extends StatefulWidget {
  const MyFindsView({super.key});

  @override
  State<MyFindsView> createState() => _MyFindsViewState();
}

class _MyFindsViewState extends State<MyFindsView> {
  int _selectedFilterIndex = 0;

  final List<String> filters = const [
    'All (4)',
    'Live (2)',
    'Sold (1)',
    'Draft (1)',
  ];

  final List<_InventoryItem> _items = const [
    _InventoryItem(
      id: '1',
      title: 'Victorian Mahogany Chair',
      price: '\$850',
      views: '124',
      status: 'Live',
      statusColor: Color(0xFF19D36B),
      image: AppImages.productOne,
    ),
    _InventoryItem(
      id: '2',
      title: 'Antique Oak Cabinet',
      price: '\$1,200',
      views: '89',
      status: 'Live',
      statusColor: Color(0xFF19D36B),
      image: AppImages.productFour,
    ),
    _InventoryItem(
      id: '3',
      title: 'Porcelain Vase Collection',
      price: '\$650',
      views: '156',
      status: 'Sold',
      statusColor: Color(0xFF1F2937),
      image: AppImages.productThree,
    ),
    _InventoryItem(
      id: '4',
      title: 'Vintage Pocket Watch',
      price: '\$450',
      views: '0',
      status: 'Draft',
      statusColor: Color(0xFFB56C3A),
      image: AppImages.productFive,
    ),
  ];

  HeaderConfig _buildHeader() {
    return HeaderConfig(
      title: Text(
        'Inventory',
        style: TextStyles.boldLarge.copyWith(color: AppColors.bodyBg),
      ),
      bottomWidget: HorizontalChipBar(
        items: filters,
        selectedIndex: _selectedFilterIndex,
        padding: EdgeInsets.zero,
        chipPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        chipHeight: 36.h,
        spacing: 10.w,
        activeBackgroundColor: AppColors.bodyBg,
        inactiveBackgroundColor: AppColors.darkText.withValues(alpha: 0.22),
        activeTextColor: AppColors.redButton,
        inactiveTextColor: AppColors.bodyBg,
        textStyle: TextStyles.mediumSmall,
        borderRadius: BorderRadius.circular(12.r),
        onChanged: (index) {
          setState(() {
            _selectedFilterIndex = index;
          });
        },
      ),
      height: 175.h,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLayout(
      headerConfig: _buildHeader(),
      body: Container(
        color: AppColors.subPageBg,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 18.h),
          child: Column(
            children: [
              for (final item in _items) ...[
                _InventoryCard(
                  item: item,
                  onEdit: () => context.push('/user/my-finds/edit/${item.id}'),
                  onDelete: () =>
                      showDeleteItemDialog(context, itemTitle: item.title),
                  onTap: () => context.push('/user/my-finds/item/${item.id}'),
                ),
                SizedBox(height: 12.h),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryItem {
  final String id;
  final String title;
  final String price;
  final String views;
  final String status;
  final Color statusColor;
  final String image;

  const _InventoryItem({
    required this.id,
    required this.title,
    required this.price,
    required this.views,
    required this.status,
    required this.statusColor,
    required this.image,
  });
}

class _InventoryCard extends StatelessWidget {
  final _InventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _InventoryCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E6EE)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.r),
              topRight: Radius.circular(18.r),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: Image.asset(
                      item.image,
                      width: 86.w,
                      height: 86.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyles.mediumMedium.copyWith(
                            color: AppColors.lightText,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          item.price,
                          style: TextStyles.mediumMedium.copyWith(
                            color: AppColors.redButton,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.infoCardBg,
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 14.sp,
                                    color: const Color(0xFF2F80FF),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    item.views,
                                    style: TextStyles.mediumSmall.copyWith(
                                      color: const Color(0xFF2F80FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: item.statusColor,
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyles.mediumSmall.copyWith(
                                  color: Colors.white,
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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFF9FAFB), Color(0xFFEFF6FF)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18.r),
                bottomRight: Radius.circular(18.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onEdit,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(

                            'assets/icons/edit_icon.svg',
                            width: 16.w,
                            height: 16.w,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF2F80FF),
                              BlendMode.srcIn,
                            ),
                          ),

                          SizedBox(width: 6.w),
                          Text(
                            'Edit',
                            style: TextStyles.mediumMedium.copyWith(
                              color: const Color(0xFF2F80FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 22.h,
                  color: const Color(0xFFD4DCE9),
                ),
                Expanded(
                  child: InkWell(
                    onTap: onDelete,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.trashOutlinedIcon,
                            width: 16.w,
                            height: 16.w,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Delete',
                            style: TextStyles.mediumMedium.copyWith(
                              color: AppColors.redButton,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
