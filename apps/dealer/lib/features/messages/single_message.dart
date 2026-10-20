import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/components/message_components/bottom_bar.dart';
import 'package:vintage_app/core/services/items_service.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class SingleMessage extends StatefulWidget {
  final String? chatId;
  final String? title;
  const SingleMessage({super.key, this.chatId, this.title});

  @override
  State<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  final TextEditingController messageBoxController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  List<Map<String, dynamic>> _messages = [];

  String get activeChatId => widget.chatId ?? 'chat_default';
  String get activeTitle => widget.title ?? 'Collector Inquiry';

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });
    final msgs = await ItemsService.getChatMessages(activeChatId);
    if (mounted) {
      setState(() {
        _messages = msgs;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSendMessage() async {
    final text = messageBoxController.text.trim();
    if (text.isEmpty) return;

    messageBoxController.clear();
    final newMsg = await ItemsService.sendMessage(activeChatId, text);
    if (mounted) {
      setState(() {
        _messages.add(newMsg);
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    messageBoxController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: SimpleHeader(config: _header(context, activeTitle)),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 90.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _isLoading
                      ? const Center(child: JumpingDots(color: AppColors.redButton))
                      : _messages.isEmpty
                          ? Center(
                              child: Text(
                                'No message history yet. Respond to the customer below.',
                                style: TextStyles.regularSmall.copyWith(color: AppColors.greyText),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.only(top: 8.h),
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                final message = _messages[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: _MessageBubble(message: message),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
          MessageBottomBar(
            data: MessageBottomBarData(
              actionBar: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _handleSendMessage,
                    child: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: const BoxDecoration(
                        color: AppColors.redButton,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
              inputBar: AppTextField(
                controller: messageBoxController,
                hintText: 'Type response to buyer...',
                borderColor: AppColors.grey,
                focusedBorderColor: AppColors.redButton,
                borderRadius: 16.r,
                onSubmitted: (_) => _handleSendMessage(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 14.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final senderRole = message['senderRole'] ?? (message['isSentByUser'] == true ? 'dealer' : 'customer');
    final isSent = senderRole == 'dealer' || message['isSentByUser'] == true;
    final text = message['text'] ?? '';
    final time = message['time'] ?? 'Just now';

    final alignment = isSent ? Alignment.centerRight : Alignment.centerLeft;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(16.r),
      topRight: Radius.circular(16.r),
      bottomLeft: Radius.circular(isSent ? 16.r : 4.r),
      bottomRight: Radius.circular(isSent ? 4.r : 16.r),
    );

    final bg = isSent ? AppColors.gradientColor1 : Colors.white;

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 280.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: borderRadius,
            border: isSent ? null : Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withValues(alpha: 0.08),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyles.regularSmall.copyWith(
                  color: isSent ? Colors.white : AppColors.lightText,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                time,
                style: TextStyles.regularExtraSmall.copyWith(
                  color: isSent ? Colors.white70 : AppColors.greyText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

HeaderConfig _header(BuildContext context, String title) {
  return HeaderConfig(
    leading: IconBox(
      icon: AppImages.backIcon,
      bgColor: const Color(0xFFF8E8C7).withValues(alpha: 0.20),
      onTap: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/inbox');
        }
      },
      iconColor: const Color(0xFFF8E8C7),
      height: 40.h,
      width: 40.w,
      borderRadius: 100.r,
    ),
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 40.w,
          width: 40.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.r),
            child: Image.asset(AppImages.userImg, fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyles.boldMedium.copyWith(color: AppColors.bodyBg),
            ),
          ],
        ),
      ],
    ),
    trailing: Text(
      'Active inquiry',
      style: TextStyles.regularMedium.copyWith(color: const Color(0xFF00E676)),
    ),
    bottomWidget: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.darkText.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              AppImages.productOne,
              width: 44.w,
              height: 44.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Authenticated Inventory Lot',
                  style: TextStyles.mediumMedium.copyWith(
                    color: AppColors.bodyBg,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 14.sp,
                      color: const Color(0xFF4ADE80),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'AI Authenticated',
                      style: TextStyles.regularSmall.copyWith(
                        color: const Color(0xFF4ADE80),
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
    height: 220.h,
  );
}

