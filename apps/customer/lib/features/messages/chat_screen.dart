import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/items_service.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
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
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.h),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.gradientColor1,
                AppColors.gradientColor2,
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.r),
              bottomRight: Radius.circular(40.r),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconBox(
                    icon: AppImages.backIcon,
                    bgColor: const Color(0xFFF8E8C7).withValues(alpha: 0.20),
                    onTap: () => context.pop(),
                    iconColor: const Color(0xFFF8E8C7),
                    height: 40.h,
                    width: 40.w,
                    borderRadius: 100.r,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Messages',
                    style: TextStyles.boldLarge.copyWith(
                      color: const Color(0xFFF8E8C7),
                      fontSize: 28.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search conversations...',
                        hintStyle: TextStyles.regularMedium.copyWith(
                          color: const Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Icon(
                            Icons.search,
                            color: const Color(0xFF6B7280),
                            size: 20.sp,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 4.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: JumpingDots(color: AppColors.redButton))
          : _conversations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 54.sp, color: Colors.grey),
                      SizedBox(height: 12.h),
                      Text(
                        'No active conversations yet',
                        style: TextStyles.mediumSmall.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadChats,
                  color: AppColors.redButton,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    itemCount: _conversations.length,
                    itemBuilder: (context, index) {
                      final chat = _conversations[index];
                      final chatId = chat['id'] ?? 'chat_1';
                      final name = chat['title'] ?? chat['dealerName'] ?? chat['customerName'] ?? 'Vintage Trader';
                      final lastMsg = chat['lastMessage'] ?? 'No messages yet';
                      final timeAgo = chat['updatedAt'] != null ? 'Recently' : 'Just now';
                      final unreadCount = (chat['unreadCount'] ?? 0) as int;

                      return GestureDetector(
                        onTap: () {
                          context.push('/single_message', extra: {
                            'chatId': chatId,
                            'title': name,
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                          margin: EdgeInsets.only(bottom: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48.w,
                                height: 48.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE5E7EB),
                                ),
                                child: Center(
                                  child: Text(
                                    name.isNotEmpty ? name.substring(0, (name.length >= 2 ? 2 : 1)).toUpperCase() : 'VT',
                                    style: TextStyles.semiBoldSmall.copyWith(
                                      color: AppColors.darkText,
                                    ),
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
                                        Text(
                                          name,
                                          style: TextStyles.semiBoldMedium.copyWith(
                                            color: const Color(0xFF202124),
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Text(
                                          timeAgo,
                                          style: TextStyles.regularSmall.copyWith(
                                            color: const Color(0xFF9CA3AF),
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      lastMsg,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.regularSmall.copyWith(
                                        color: const Color(0xFF6B7280),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (unreadCount > 0) ...[
                                SizedBox(width: 8.w),
                                Container(
                                  width: 20.w,
                                  height: 20.h,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDC2626),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      unreadCount.toString(),
                                      style: TextStyles.regularExtraSmall.copyWith(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
