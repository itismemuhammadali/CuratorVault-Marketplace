import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/cards/app_item_card.dart';
import '../../../core/components/global_header/header_config.dart';
import '../../../core/components/global_header/header_controller_provider.dart';
import '../../../core/components/icons/icon_box.dart';
import '../../../core/components/includes/app_text_field.dart';
import '../../../core/components/includes/horizontal_chip_bar.dart';
import '../../../core/components/includes/jumping_dots.dart';
import '../../../core/services/items_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/images.dart';
import '../../../core/theme/text_styles.dart';

class MarketplaceView extends StatefulWidget {
  const MarketplaceView({super.key});

  @override
  State<MarketplaceView> createState() => _MarketplaceViewState();
}

class _MarketplaceViewState extends State<MarketplaceView> {
  final TextEditingController _searchController = TextEditingController();
  bool _headerSet = false;
  int _selectedFilterIndex = 0;
  bool _isLoading = true;
  List<Map<String, dynamic>> _items = [];

  final List<String> filters = const [
    'All',
    'Furniture',
    'Horology',
    'Pottery',
    'Jewelry',
    'Art',
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

    final selectedCat = filters[_selectedFilterIndex];
    final items = await ItemsService.getMarketplaceItems(
      category: selectedCat == 'All' ? null : selectedCat,
      search: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
    );

    if (mounted) {
      setState(() {
        _items = items;
        _isLoading = false;
      });
    }
  }

  void _updateHeader() {
    HeaderControllerProvider.of(context).value = HeaderConfig(
      title: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dealer Exchange',
              style: TextStyles.semiBoldLarge.copyWith(color: AppColors.bodyBg),
            ),
            SizedBox(height: 4.h),
            Text(
              'Discover authenticated antique lots & trade inventory',
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.darkText,
              ),
            ),
          ],
        ),
      ),
      bottomWidget: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _searchController,
              hintText: 'Search marketplace & lots...',
              fillColor: Colors.white,
              onSubmitted: (_) => _loadItems(),
              prefix: IconBox(
                icon: AppImages.magnifineGlassIcon,
                bgColor: Colors.transparent,
                onTap: _loadItems,
              ),
            ),
          ),
        ],
      ),
      height: 220.h,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_headerSet) {
      _headerSet = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _updateHeader();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bodyBg,
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadItems,
              color: AppColors.redButton,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                child: Column(
                  children: [
                    HorizontalChipBar(
                      items: filters,
                      selectedIndex: _selectedFilterIndex,
                      onChanged: (index) {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                        _loadItems();
                      },
                      activeBackgroundColor: AppColors.redButton,
                      inactiveBackgroundColor: Colors.transparent,
                      inactiveTextColor: AppColors.lightText,
                      activeTextColor: AppColors.bodyBg,
                    ),
                    SizedBox(height: 20.h),
                    if (_isLoading)
                      Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: const Center(child: JumpingDots(color: AppColors.redButton)),
                      )
                    else if (_items.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.storefront_outlined, size: 48.sp, color: Colors.grey),
                              SizedBox(height: 12.h),
                              Text(
                                'No inventory found matching criteria',
                                style: TextStyles.mediumSmall.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          final id = item['id'] ?? (index + 1).toString();
                          final title = item['title'] ?? 'Vintage Item';
                          final location = item['provenance'] ?? item['sellerName'] ?? 'London, UK';
                          final price = '\$${(item['price'] ?? 1200).toInt()}';
                          final img = item['imageUrl'] ?? item['image'] ?? AppImages.productOne;
                          final conf = ((item['authenticityScore'] ?? 94) / 100.0).clamp(0.1, 1.0);

                          return AppItemCard(
                            layout: AppItemCardLayout.grid,
                            title: title,
                            locationText: location,
                            priceText: price,
                            priceColor: AppColors.redButton,
                            imageAsset: img.toString().contains('assets/') ? img : AppImages.productOne,
                            badge: AppItemCardBadge.hot,
                            confidence: conf,
                            gridTitleMaxLines: 1,
                            onGridActionTap: () {},
                            onTap: () {
                              context.push('/market/product/$id');
                            },
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

