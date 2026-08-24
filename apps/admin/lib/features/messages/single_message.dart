import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class SingleMessage extends StatefulWidget {
  final String name;
  final String subtitle;

  const SingleMessage({
    super.key,
    this.name = 'John Davis',
    this.subtitle = 'John Collector',
  });

  @override
  State<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  final TextEditingController messageBoxController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = const [
    _ChatMessage(
      text: 'Hello. I have a question about my\naccount.',
      time: '10:30 AM',
      isSentByUser: false,
    ),
    _ChatMessage(
      text: 'Hi John! How can I help you today?',
      time: '10:32 AM',
      isSentByUser: true,
    ),
    _ChatMessage(
      text: 'I need to update my\npayment method.',
      time: '10:35 AM',
      isSentByUser: false,
    ),
    _ChatMessage(
      text:
          'Sure, you can do that in your profile\nsettings under Payment\nManagement.',
      time: '10:37 AM',
      isSentByUser: true,
    ),
    _ChatMessage(
      text: 'Thank you for your help!',
      time: '10:40 AM',
      isSentByUser: false,
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
      appBar: SimpleHeader(
        config: _header(name: widget.name, subtitle: widget.subtitle),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 14.h, 14.w, 86.h),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _MessageBubble(message: _messages[index]),
                );
              },
            ),
          ),
          _messageInputBar(),
        ],
      ),
    );
  }

  Widget _messageInputBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
        decoration: const BoxDecoration(
          color: AppColors.bodyBg,
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46.h,
                  child: TextField(
                    controller: messageBoxController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: AppColors.gradientColor1,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.send_outlined,
                  color: AppColors.bodyBg,
                  size: 19.sp,
                ),
              ),
            ],
          ),
        ),
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

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 236.w),
        child: Column(
          crossAxisAlignment: isSent
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: isSent
                    ? AppColors.gradientColor1
                    : const Color(0xFFF4F5F7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                message.text,
                style: TextStyles.regularSmall.copyWith(
                  color: isSent ? AppColors.bodyBg : AppColors.lightText,
                  fontSize: 13.sp,
                  height: 1.25,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              message.time,
              style: TextStyles.regularExtraSmall.copyWith(
                color: AppColors.greyText,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

HeaderConfig _header({required String name, required String subtitle}) {
  return HeaderConfig(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyles.boldLarge.copyWith(
            color: AppColors.bodyBg,
            fontSize: 22.sp,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          subtitle,
          style: TextStyles.regularSmall.copyWith(
            color: AppColors.bodyBg.withValues(alpha: 0.72),
            fontSize: 14.sp,
          ),
        ),
      ],
    ),
    trailing: Text(
      'Active now',
      style: TextStyles.semiBoldExtraSmall.copyWith(
        color: const Color(0xFF22C55E),
        fontSize: 12.sp,
      ),
    ),
    height: 160.h,
  );
}
