import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/global_header/header_config.dart';
import '../../../core/components/global_header/header_controller_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/images.dart';
import '../../../core/theme/text_styles.dart';
import 'listing_action_sheets.dart';
import 'listing_detail_view.dart';

class MarketplaceView extends StatefulWidget {
  const MarketplaceView({super.key});

  @override
  State<MarketplaceView> createState() => _MarketplaceViewState();
}

class _MarketplaceViewState extends State<MarketplaceView> {
  final TextEditingController _searchController = TextEditingController();
  bool _headerSet = false;
  int _selectedFilterIndex = 1;

  final List<String> _filters = const ['All', 'Active', 'Reported', 'Sold'];

  final List<_ListingItem> _items = const [
    _ListingItem(
      title: 'Modern Smartwatch',
      category: 'Watches',
      description: 'Latest model with fitness tracking\nand notifications',
      seller: 'Sarah Dealer',
      price: '\$350',
      score: 72,
      status: _ListingStatus.active,
      qualityLabel: 'Excellent',
      qualityColor: Color(0xFF00C853),
      image: AppImages.marketplaceWatch,
    ),
    _ListingItem(
      title: 'Fitness Tracker',
      category: 'Wearables',
      description: 'Tracks heart rate, sleep, and activity\nlevels',
      seller: 'Health Gadget',
      price: '\$99',
      score: 80,
      status: _ListingStatus.active,
      qualityLabel: 'Excellent',
      qualityColor: Color(0xFF00C853),
      image: AppImages.marketplaceStore,
    ),
    _ListingItem(
      title: 'Antique Camera',
      category: 'Cameras',
      description: 'Classic 1960s film camera with\nleather case',
      seller: 'Sarah Dealer',
      price: '\$350',
      score: 72,
      status: _ListingStatus.reported,
      qualityLabel: 'Repaired',
      qualityColor: Color(0xFFEF4444),
      image: AppImages.productThree,
    ),
    _ListingItem(
      title: 'Smart Home Speaker',
      category: 'Smart Devices',
      description: 'Voice-activated with smart assistant\nintegration',
      seller: 'Home Tech',
      price: '\$120',
      score: 78,
      status: _ListingStatus.sold,
      qualityLabel: 'Sold',
      qualityColor: Color(0xFF6B7280),
      image: AppImages.productFour,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateHeader() {
    HeaderControllerProvider.of(context).value = HeaderConfig(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Marketplace',
            style: TextStyles.boldTitle.copyWith(
              color: AppColors.bodyBg,
              fontSize: 25.sp,
              height: 1.05,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Manage all listings',
            style: TextStyles.boldSmall.copyWith(
              color: AppColors.darkText,
              fontSize: 15.sp,
              height: 1.1,
            ),
          ),
        ],
      ),
      height: 126.h,
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
    final visibleItems = _filteredItems();

    return Container(
      color: AppColors.bodyBg,
      child: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 48.h),
        children: [
          _searchBox(),
          SizedBox(height: 15.h),
          _filtersBar(),
          SizedBox(height: 23.h),
          for (final item in visibleItems) ...[
            _ListingCard(item: item),
            SizedBox(height: 18.h),
          ],
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(7.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.09),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: AppColors.lightText.withValues(alpha: 0.9),
            size: 27.sp,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Listing...',
                hintStyle: TextStyles.regularMedium.copyWith(
                  color: AppColors.lightText.withValues(alpha: 0.48),
                  fontSize: 16.sp,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filtersBar() {
    return Container(
      height: 38.h,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          for (int index = 0; index < _filters.length; index++)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilterIndex = index),
                child: _FilterPill(
                  label: _filters[index],
                  selected: _selectedFilterIndex == index,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<_ListingItem> _filteredItems() {
    switch (_selectedFilterIndex) {
      case 1:
        return _items
            .where((item) => item.status == _ListingStatus.active)
            .toList();
      case 2:
        return _items
            .where((item) => item.status == _ListingStatus.reported)
            .toList();
      case 3:
        return _items
            .where((item) => item.status == _ListingStatus.sold)
            .toList();
      default:
        return _items;
    }
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterPill({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      height: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.gradientColor1 : AppColors.bodyBg,
        borderRadius: BorderRadius.circular(100.r),
        border: selected ? null : Border.all(color: AppColors.cardBorder),
      ),
      child: Text(
        label,
        style: TextStyles.boldSmall.copyWith(
          color: selected ? AppColors.bodyBg : AppColors.lightText,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final _ListingItem item;

  const _ListingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 175.h),
      padding: EdgeInsets.fromLTRB(0, 0, 14.w, 0),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(19.r),
        border: Border.all(color: const Color(0xFFEDEDED)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(height: 0.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  item.image,
                  width: 109.w,
                  height: 108.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 17.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.boldMedium.copyWith(
                                color: AppColors.lightText,
                                fontSize: 16.sp,
                                height: 1.1,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          _ListingMenu(item: item),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        item.category,
                        style: TextStyles.regularExtraSmall.copyWith(
                          color: const Color(0xFF6B7280),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 11.h),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.regularSmall.copyWith(
                          color: const Color(0xFF4B5563),
                          fontSize: 13.sp,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 13.h),
          Padding(
            padding: EdgeInsets.only(left: 109.w),
            child: Row(
              children: [
                const Spacer(),
                _PriceBadge(price: item.price),
                SizedBox(width: 12.w),
                _QualityBadge(
                  label: item.qualityLabel,
                  color: item.qualityColor,
                ),
              ],
            ),
          ),
          SizedBox(height: 23.h),
          Padding(
            padding: EdgeInsets.only(left: 109.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Seller: ${item.seller}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.regularExtraSmall.copyWith(
                      color: const Color(0xFF6B7280),
                      fontSize: 11.sp,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'AI Score:',
                  style: TextStyles.regularExtraSmall.copyWith(
                    color: const Color(0xFF6B7280),
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                _ScoreBar(score: item.score),
                SizedBox(width: 6.w),
                Text(
                  '${item.score}%',
                  style: TextStyles.regularExtraSmall.copyWith(
                    color: const Color(0xFF374151),
                    fontSize: 11.sp,
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

class _ListingMenu extends StatelessWidget {
  final _ListingItem item;

  const _ListingMenu({required this.item});

  @override
  Widget build(BuildContext context) {
    final isSold = item.status == _ListingStatus.sold;

    return PopupMenuButton<_ListingAction>(
      padding: EdgeInsets.zero,
      elevation: 10,
      color: AppColors.bodyBg,
      offset: Offset(-6.w, 28.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      onSelected: (action) {
        if (action == _ListingAction.viewDetails) {
          context.push('/dealer/market/details', extra: item.toDetailData());
          return;
        }
        if (action == _ListingAction.remove) {
          _showRemoveSheet(context, item);
          return;
        }
        if (action == _ListingAction.flagCounterfeit) {
          _showFlagSheet(context, item);
        }
      },
      itemBuilder: (context) => [
        _menuItem(
          action: _ListingAction.viewDetails,
          label: 'View Details',
          color: const Color(0xFF1F2937),
          icon: Icons.visibility_outlined,
        ),
        if (!isSold)
          _menuItem(
            action: _ListingAction.remove,
            label: 'Remove Listing',
            color: const Color(0xFFF04A3A),
            icon: Icons.cancel_outlined,
          ),
        _menuItem(
          action: _ListingAction.flagCounterfeit,
          label: 'Flag Counterfeit',
          color: const Color(0xFFF04A3A),
          icon: Icons.warning_amber_rounded,
        ),
      ],
      child: Icon(Icons.more_vert, color: AppColors.lightText, size: 18.sp),
    );
  }

  PopupMenuItem<_ListingAction> _menuItem({
    required _ListingAction action,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return PopupMenuItem<_ListingAction>(
      value: action,
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 10.w),
          Text(
            label,
            style: TextStyles.regularSmall.copyWith(
              color: color,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

void _showRemoveSheet(BuildContext context, _ListingItem item) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => RemoveListingSheet(
      title: item.title,
      price: item.price,
      seller: item.seller,
    ),
  );
}

void _showFlagSheet(BuildContext context, _ListingItem item) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FlagCounterfeitSheet(
      title: item.title,
      price: item.price,
      seller: item.seller,
    ),
  );
}

class _PriceBadge extends StatelessWidget {
  final String price;

  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.gradientColor1,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Text(
        price,
        style: TextStyles.boldSmall.copyWith(
          color: AppColors.bodyBg,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}

class _QualityBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _QualityBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Text(
        label,
        style: TextStyles.boldSmall.copyWith(
          color: AppColors.bodyBg,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final int score;

  const _ScoreBar({required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 63.w,
      height: 5.h,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          FractionallySizedBox(
            widthFactor: score / 100,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE7B416),
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingItem {
  final String title;
  final String category;
  final String description;
  final String seller;
  final String price;
  final int score;
  final _ListingStatus status;
  final String qualityLabel;
  final Color qualityColor;
  final String image;

  const _ListingItem({
    required this.title,
    required this.category,
    required this.description,
    required this.seller,
    required this.price,
    required this.score,
    required this.status,
    required this.qualityLabel,
    required this.qualityColor,
    required this.image,
  });

  ListingDetailData toDetailData() {
    return ListingDetailData(
      title: title,
      image: image,
      price: price,
      qualityLabel: qualityLabel,
      statusLabel: status == _ListingStatus.sold ? 'Sold' : 'Active',
      description:
          'Rare 1920s pocket watch in excellent condition with original chain',
      category: category,
      seller: seller,
      condition: qualityLabel,
      score: score,
    );
  }
}

enum _ListingStatus { active, reported, sold }

enum _ListingAction { viewDetails, remove, flagCounterfeit }
