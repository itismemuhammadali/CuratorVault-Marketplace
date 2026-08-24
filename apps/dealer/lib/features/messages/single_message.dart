import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/components/message_components/bottom_bar.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class SingleMessage extends StatefulWidget {
  const SingleMessage({super.key});

  @override
  State<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  final TextEditingController messageBoxController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Simple chat data: mix of sent/received messages
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text:
          'Hello! Thank you for your interest in the Victorian Pocket Watch. How can I help you?',
      time: '8:30 PM',
      isSentByUser: false,
    ),
    _ChatMessage(
      text:
          "Hi! I'm curious about the movement condition and whether it has been serviced recently.",
      time: '8:31 PM',
      isSentByUser: true,
    ),
    _ChatMessage(
      text:
          'Great question! The movement was professionally serviced 3 months ago and is keeping excellent time.',
      time: '8:32 PM',
      isSentByUser: false,
    ),
    _ChatMessage(
      text: 'Awesome. Are there any visible scratches on the case or crystal?',
      time: '8:33 PM',
      isSentByUser: true,
    ),
    _ChatMessage(
      text:
          'There are only minor hairline marks consistent with careful use—no deep scratches or chips.',
      time: '8:34 PM',
      isSentByUser: false,
    ),
    _ChatMessage(
      text: 'Perfect, thank you for the details!',
      time: '8:35 PM',
      isSentByUser: true,
    ),
  ];

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
      appBar: SimpleHeader(config: _header()),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 90.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true, // chat-style bottom-to-top growth
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
                  Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.darkText.withValues(alpha: 0.20),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        AppImages.imageIcon,
                        width: 18.w,
                        height: 18.w,
                        color: AppColors.lightText,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              inputBar: AppTextField(
                controller: messageBoxController,
                hintText: 'Type a message...',
                borderColor: AppColors.grey,
                focusedBorderColor: AppColors.redButton,
                borderRadius: 16.r,
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

class _ChatMessage {
  final String text;
  final String time;
  final bool isSentByUser;

  const _ChatMessage({
    required this.text,
    required this.time,
    required this.isSentByUser,
  });
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isSent = message.isSentByUser;

    // Align right for sent, left for received
    final alignment = isSent ? Alignment.centerRight : Alignment.centerLeft;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(16.r),
      topRight: Radius.circular(16.r),
      bottomLeft: Radius.circular(isSent ? 16.r : 4.r),
      bottomRight: Radius.circular(isSent ? 4.r : 16.r),
    );

    final bg = isSent
        ? AppColors.gradientColor1
        : AppColors.bodyBg; // will use gradient for sent

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 280.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withValues(alpha: 0.10),
                blurRadius: 10.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isSent
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.text,
                style: TextStyles.regularSmall.copyWith(
                  color: isSent ? AppColors.bodyBg : AppColors.lightText,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                message.time,
                style: TextStyles.regularExtraSmall.copyWith(
                  color: isSent
                      ? AppColors.bodyBg.withValues(alpha: 0.85)
                      : AppColors.greyText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

HeaderConfig _header() {
  return HeaderConfig(
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 44.w,
          width: 44.w,
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
              'John Davis',
              style: TextStyles.boldMedium.copyWith(color: AppColors.bodyBg),
            ),
          ],
        ),
      ],
    ),
    trailing: Text(
      'Active now',
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
              width: 52.w,
              height: 52.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Victorian Mahogany Chair',
                  style: TextStyles.mediumMedium.copyWith(
                    color: AppColors.bodyBg,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 14.sp,
                      color: const Color(0xFF4ADE80),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Order #ORD-2451',
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
    height: 245.h,
  );
}
