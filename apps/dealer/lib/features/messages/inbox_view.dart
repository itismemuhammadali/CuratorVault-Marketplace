import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/global_header/header_controller_provider.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  final TextEditingController _searchController = TextEditingController();
  bool _headerSet = false;

  final List<_InboxConversation> _conversations = [
    _InboxConversation(
      name: 'John Davis',
      preview: 'Yes, it comes with a certificate of authenticity',
      time: '10:36 AM',
      unreadCount: 0,
      itemImage: AppImages.productOne,
      avatarImage: AppImages.userImg,
      itemTitle: 'Victorian Mahogany Chair',
      avatarRingColor: Color(0xFF7C3AED),
    ),
    _InboxConversation(
      name: 'Sarah Martinez',
      preview: 'When can you ship this?',
      time: 'Yesterday',
      unreadCount: 2,
      itemImage: AppImages.productTwo,
      avatarImage: AppImages.userImg,
      itemTitle: 'Antique Oak Cabinet',
      avatarRingColor: Color(0xFFD1D5DB),
    ),
    _InboxConversation(
      name: 'Michael Chen',
      preview: 'Thank you! Looking forward to receiving it.',
      time: '2 days ago',
      unreadCount: 0,
      itemImage: AppImages.productThree,
      avatarImage: AppImages.userImg,
      itemTitle: 'Porcelain Vase Collection',
      avatarRingColor: Color(0xFFD1D5DB),
    ),
    _InboxConversation(
      name: 'Emma Wilson',
      preview: 'Is this still available?',
      time: '3 days ago',
      unreadCount: 1,
      itemImage: AppImages.productFive,
      avatarImage: AppImages.userImg,
      itemTitle: 'Vintage Pocket Watch',
      avatarRingColor: Color(0xFFD1D5DB),
    ),
    _InboxConversation(
      name: 'Robert Taylor',
      preview: "Perfect! I'll take it.",
      time: '1 week ago',
      unreadCount: 0,
      itemImage: AppImages.productFour,
      avatarImage: AppImages.userImg,
      itemTitle: 'Art Deco Mirror',
      avatarRingColor: Color(0xFFD1D5DB),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateHeader() {
    final unreadCount = _conversations.fold<int>(
      0,
      (total, item) => total + item.unreadCount,
    );

    HeaderControllerProvider.of(context).value = HeaderConfig(
      title: Text(
        'Messages',
        style: TextStyles.boldLarge.copyWith(
          color: AppColors.bodyBg,
          fontSize: 24.sp,
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Text(
          '$unreadCount unread',
          style: TextStyles.mediumSmall.copyWith(color: AppColors.bodyBg),
        ),
      ),
      height: 120.h,
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
      color: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
        child: Column(
          children: [
            ..._conversations.map(
              (conversation) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _InboxTile(
                  item: conversation,
                  onTap: () => context.push('/single_message'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InboxConversation {
  final String name;
  final String preview;
  final String time;
  final int unreadCount;
  final String itemImage;
  final String avatarImage;
  final String itemTitle;
  final Color avatarRingColor;

  const _InboxConversation({
    required this.name,
    required this.preview,
    required this.time,
    required this.unreadCount,
    required this.itemImage,
    required this.avatarImage,
    required this.itemTitle,
    required this.avatarRingColor,
  });
}

class _InboxTile extends StatelessWidget {
  final _InboxConversation item;
  final VoidCallback onTap;

  const _InboxTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: const Color(0xFFE3E7ED), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 58.w,
              height: 58.w,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: item.avatarRingColor, width: 2.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Image.asset(item.avatarImage, fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.boldMedium.copyWith(
                            color: AppColors.gradientColor1,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        item.time,
                        style: TextStyles.regularSmall.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.asset(
                          item.itemImage,
                          width: 32.w,
                          height: 24.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          item.itemTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.regularSmall.copyWith(
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    item.preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.lightText.withValues(alpha: 0.68),
                    ),
                  ),
                ],
              ),
            ),
            if (item.unreadCount > 0) ...[
              SizedBox(width: 10.w),
              Container(
                height: 24.w,
                width: 24.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF7C3AED),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${item.unreadCount}',
                    style: TextStyles.semiBoldExtraSmall.copyWith(
                      color: AppColors.bodyBg,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
