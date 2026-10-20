import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/global_header/header_controller_provider.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/items_service.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  final TextEditingController _searchController = TextEditingController();
  bool _headerSet = false;
  bool _isLoading = true;
  List<Map<String, dynamic>> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    setState(() {
      _isLoading = true;
    });
    final chats = await ItemsService.getChats();
    if (mounted) {
      setState(() {
        _conversations = chats;
        _isLoading = false;
      });
      _updateHeader();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateHeader() {
    final unreadCount = _conversations.fold<int>(
      0,
      (total, item) => total + ((item['unreadCount'] ?? 0) as int),
    );

    HeaderControllerProvider.of(context).value = HeaderConfig(
      title: Text(
        'Dealer Inbox',
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
      child: _isLoading
          ? const Center(child: JumpingDots(color: AppColors.redButton))
          : _conversations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mark_email_unread_outlined, size: 54.sp, color: Colors.grey),
                      SizedBox(height: 12.h),
                      Text(
                        'No dealer inquiries or chat threads yet',
                        style: TextStyles.mediumSmall.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadChats,
                  color: AppColors.redButton,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
                    child: Column(
                      children: [
                        ..._conversations.map(
                          (chat) {
                            final chatId = chat['id'] ?? 'chat_1';
                            final name = chat['customerName'] ?? chat['title'] ?? 'Customer Inquiry';
                            final lastMsg = chat['lastMessage'] ?? 'No messages yet';
                            final unreadCount = (chat['unreadCount'] ?? 0) as int;

                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: GestureDetector(
                                onTap: () => context.push('/single_message', extra: {
                                  'chatId': chatId,
                                  'title': name,
                                }),
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
                                        width: 50.w,
                                        height: 50.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFE5E7EB),
                                        ),
                                        child: Center(
                                          child: Text(
                                            name.isNotEmpty ? name.substring(0, (name.length >= 2 ? 2 : 1)).toUpperCase() : 'CU',
                                            style: TextStyles.boldMedium.copyWith(color: AppColors.darkText),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyles.boldMedium.copyWith(
                                                      color: AppColors.gradientColor1,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Active',
                                                  style: TextStyles.regularSmall.copyWith(
                                                    color: const Color(0xFF64748B),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6.h),
                                            Text(
                                              lastMsg,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyles.regularMedium.copyWith(
                                                color: AppColors.lightText.withValues(alpha: 0.68),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (unreadCount > 0) ...[
                                        SizedBox(width: 10.w),
                                        Container(
                                          height: 22.w,
                                          width: 22.w,
                                          decoration: const BoxDecoration(
                                            color: AppColors.redButton,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$unreadCount',
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
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}



