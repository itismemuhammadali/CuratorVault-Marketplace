import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/global_header/header_controller_provider.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class InboxView extends StatefulWidget {
  final bool standalone;

  const InboxView({super.key, this.standalone = false});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  bool _headerSet = false;

  final List<_InboxConversation> _conversations = const [
    _InboxConversation(
      name: 'John Davis',
      preview: 'Yes, it comes with a certificate of authenticity',
      time: '10:36 AM',
      unreadCount: 0,
      avatarImage: AppImages.messageAvatarJohn,
      role: 'Collector',
      roleColor: AppColors.tagCollector,
    ),
    _InboxConversation(
      name: 'Sarah Martinez',
      preview: 'When can you ship this?',
      time: 'Yesterday',
      unreadCount: 2,
      avatarImage: AppImages.messageAvatarSarah,
      role: 'Dealer',
      roleColor: AppColors.tagDealer,
    ),
    _InboxConversation(
      name: 'Michael Chen',
      preview: 'Thank you! Looking forward to receiving it.',
      time: '2 days ago',
      unreadCount: 0,
      avatarImage: AppImages.messageAvatarMichael,
      role: 'Dealer',
      roleColor: AppColors.tagDealer,
    ),
    _InboxConversation(
      name: 'Emma Wilson',
      preview: 'Is this still available?',
      time: '3 days ago',
      unreadCount: 1,
      avatarImage: AppImages.messageAvatarEmma,
      role: 'Collector',
      roleColor: AppColors.tagCollector,
    ),
  ];

  void _updateHeader() {
    HeaderControllerProvider.of(context).value = _headerConfig();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.standalone) return;

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
    final body = Container(
      color: AppColors.bodyBg,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 13.h, 20.w, 24.h),
        itemCount: _conversations.length,
        separatorBuilder: (context, index) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final conversation = _conversations[index];

          return _InboxTile(
            item: conversation,
            onTap: () => context.push(
              '/single_message',
              extra: {
                'name': conversation.name,
                'subtitle': '${conversation.name.split(' ').first} '
                    '${conversation.role}',
              },
            ),
          );
        },
      ),
    );

    if (!widget.standalone) return body;

    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: SimpleHeader(config: _headerConfig()),
      body: body,
    );
  }
}

HeaderConfig _headerConfig() {
  return HeaderConfig(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Messages',
          style: TextStyles.boldLarge.copyWith(
            color: AppColors.bodyBg,
            fontSize: 21.sp,
            height: 1.1,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'All Conversations',
          style: TextStyles.mediumSmall.copyWith(
            color: AppColors.bodyBg.withValues(alpha: 0.72),
            fontSize: 13.sp,
          ),
        ),
      ],
    ),
    height: 165.h,
  );
}

class _InboxConversation {
  final String name;
  final String preview;
  final String time;
  final int unreadCount;
  final String avatarImage;
  final String role;
  final Color roleColor;

  const _InboxConversation({
    required this.name,
    required this.preview,
    required this.time,
    required this.unreadCount,
    required this.avatarImage,
    required this.role,
    required this.roleColor,
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
        constraints: BoxConstraints(minHeight: 99.h),
        padding: EdgeInsets.fromLTRB(27.w, 17.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFE6E6E6), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.asset(
                item.avatarImage,
                width: 53.w,
                height: 53.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 20.w),
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
                            color: const Color(0xFF121827),
                            fontSize: 18.sp,
                            height: 1.1,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        item.time,
                        style: TextStyles.regularSmall.copyWith(
                          color: const Color(0xFF667085),
                          fontSize: 12.sp,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  _RoleBadge(label: item.role, color: item.roleColor),
                  SizedBox(height: 8.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          item.preview,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.regularMedium.copyWith(
                            color: const Color(0xFF121827).withValues(
                              alpha: item.unreadCount > 0 ? 1 : 0.62,
                            ),
                            fontSize: 14.sp,
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (item.unreadCount > 0) ...[
                        SizedBox(width: 10.w),
                        _UnreadBadge(count: item.unreadCount),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _RoleBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyles.regularExtraSmall.copyWith(
          color: color,
          fontSize: 11.sp,
          height: 1.1,
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;

  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: const BoxDecoration(
        color: Color(0xFF253347),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: TextStyles.boldExtraSmall.copyWith(
          color: AppColors.bodyBg,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
