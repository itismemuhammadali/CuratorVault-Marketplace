import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/global_layout/main_layout.dart';
import 'package:vintage_app/core/components/includes/horizontal_chip_bar.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/items_service.dart';
import 'package:vintage_app/features/dealer_flow/my_finds/widgets/delete_item_dialog.dart';
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
  bool _isLoading = true;
  List<Map<String, dynamic>> _items = [];

  final List<String> filters = const [
    'All Items',
    'Live',
    'Sold',
    'Draft',
  ];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });

    final allItems = await ItemsService.getMyFinds();
    if (mounted) {
      setState(() {
        _items = allItems;
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredItems {
    if (_selectedFilterIndex == 0) return _items;
    final filterStatus = filters[_selectedFilterIndex].toLowerCase();
    return _items.where((i) => (i['status'] ?? '').toString().toLowerCase() == filterStatus).toList();
  }

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
        child: _isLoading
            ? const Center(
                child: JumpingDots(color: AppColors.redButton),
              )
            : RefreshIndicator(
                onRefresh: _loadItems,
                color: AppColors.redButton,
                child: _filteredItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 54.sp, color: Colors.grey),
                            SizedBox(height: 12.h),
                            Text(
                              'No inventory items found',
                              style: TextStyles.mediumSmall.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 18.h),
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            for (final item in _filteredItems) ...[
                              _InventoryCard(
                                item: item,
                                onEdit: () => context.push('/dealer/my-finds/edit/${item['id']}'),
                                onDelete: () => showDeleteItemDialog(
                                  context,
                                  itemTitle: item['title'] ?? 'Item',
                                ),
                                onTap: () => context.push('/dealer/my-finds/item/${item['id']}'),
                              ),
                              SizedBox(height: 12.h),
                            ],
                          ],
                        ),
                      ),
              ),
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
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
    final title = item['title'] ?? 'Vintage Item';
    final price = item['price'] ?? '\$1,200';
    final views = (item['views'] ?? 0).toString();
    final status = item['status'] ?? 'Live';
    final imgPath = item['image'] ?? item['imageUrl'] ?? AppImages.productOne;

    Color statusColor = const Color(0xFF19D36B);
    if (status.toString().toLowerCase() == 'sold') {
      statusColor = const Color(0xFF1F2937);
    } else if (status.toString().toLowerCase() == 'draft') {
      statusColor = const Color(0xFFB56C3A);
    }

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
                    child: imgPath.toString().startsWith('http')
                        ? Image.network(
                            imgPath,
                            width: 86.w,
                            height: 86.w,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              AppImages.productOne,
                              width: 86.w,
                              height: 86.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            imgPath.toString().contains('assets/') ? imgPath : AppImages.productOne,
                            width: 86.w,
                            height: 86.w,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              AppImages.productOne,
                              width: 86.w,
                              height: 86.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyles.mediumMedium.copyWith(
                            color: AppColors.lightText,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          price,
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
                                    views,
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
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Text(
                                status,
                                style: TextStyles.mediumSmall.copyWith(
                                  color: statusColor,
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
            height: 1,
            color: const Color(0xFFE2E6EE),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit_outlined, size: 16.sp, color: AppColors.lightText),
                  label: Text(
                    'Edit',
                    style: TextStyles.mediumSmall.copyWith(color: AppColors.lightText),
                  ),
                ),
                SizedBox(width: 8.w),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline, size: 16.sp, color: AppColors.redButton),
                  label: Text(
                    'Delete',
                    style: TextStyles.mediumSmall.copyWith(color: AppColors.redButton),
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
