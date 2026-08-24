import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
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

  // Sample conversation data
  final List<_Conversation> conversations = [
    _Conversation(
      name: 'Classic Collectibles',
      lastMessage: 'The item is in excellent conditio...',
      timeAgo: '2m ago',
      unreadCount: 0,
      isOnline: true,
    ),
    _Conversation(
      name: 'Heritage Antiques',
      lastMessage: 'Yes, I can ship it to your locatio...',
      timeAgo: '1h ago',
      unreadCount: 0,
      isOnline: true,
    ),
    _Conversation(
      name: 'Vintage Treasures Co',
      lastMessage: 'Thank you for your interest',
      timeAgo: '3h ago',
      unreadCount: 1,
      isOnline: false,
    ),
    _Conversation(
      name: 'Antique Gallery',
      lastMessage: "I'll get back to you with more detail...",
      timeAgo: 'Yesterday',
      unreadCount: 0,
      isOnline: true,
    ),
    _Conversation(
      name: 'Timeless Finds',
      lastMessage: 'The authentication is 98% verfie...',
      timeAgo: '2 days ago',
      unreadCount: 0,
      isOnline: false,
    ),
  ];

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
                  // Back button - first row
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
                  // Messages title - second row
                  Text(
                    'Messages',
                    style: TextStyles.boldLarge.copyWith(
                      color: const Color(0xFFF8E8C7),
                      fontSize: 28.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Search field
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
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return _ConversationTile(
            conversation: conversation,
            onTap: () {
              context.push('/single_message');
            },
          );
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final _Conversation conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            // Avatar with online indicator
            Stack(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE5E7EB),
                  ),
                  child: Center(
                    child: Text(
                      conversation.name.substring(0, 2).toUpperCase(),
                      style: TextStyles.semiBoldSmall.copyWith(
                        color: AppColors.darkText,
                      ),
                    ),
                  ),
                ),
                if (conversation.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.name,
                        style: TextStyles.semiBoldMedium.copyWith(
                          color: const Color(0xFF202124),
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        conversation.timeAgo,
                        style: TextStyles.regularSmall.copyWith(
                          color: const Color(0xFF9CA3AF),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    conversation.lastMessage,
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
            SizedBox(width: 8.w),
            // Item image and unread badge
            Stack(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: const Color(0xFFE5E7EB),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Icon(
                      Icons.image_outlined,
                      size: 20.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
                if (conversation.unreadCount > 0)
                  Positioned(
                    top: -8.h,
                    right: -8.w,
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          conversation.unreadCount.toString(),
                          style: TextStyles.regularExtraSmall.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
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
    );
  }
}

class _Conversation {
  final String name;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final bool isOnline;

  _Conversation({
    required this.name,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
    required this.isOnline,
  });
}
