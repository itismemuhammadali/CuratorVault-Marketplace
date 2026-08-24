import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class EventParticipantsView extends StatelessWidget {
  final String eventId;

  const EventParticipantsView({super.key, required this.eventId});

  static final List<_ParticipantData> _participants = [
    _ParticipantData(
      name: 'Sarah Johnson',
      email: 'sarah.j@email.com',
      phone: '+1 (555) 123-456',
      registeredDate: 'Feb 15, 2026',
      tickets: '2 tickets',
      status: _ParticipantStatus.confirmed,
      avatar: AppImages.messageAvatarSarah,
    ),
    _ParticipantData(
      name: 'Emily Carter',
      email: 'emily.c@email.com',
      phone: '+1 (555) 555-1234',
      registeredDate: 'Jan 25, 2026',
      tickets: '3 tickets',
      status: _ParticipantStatus.pending,
      avatar: AppImages.messageAvatarEmma,
    ),
    _ParticipantData(
      name: 'Michael Thompson',
      email: 'michael.t@email.cc',
      phone: '+1 (555) 987-6543',
      registeredDate: 'Mar 10, 2026',
      tickets: '1 ticket',
      status: _ParticipantStatus.confirmed,
      avatar: AppImages.messageAvatarMichael,
    ),
    _ParticipantData(
      name: 'David Lee',
      email: 'david.l@email.com',
      phone: '+1 (555) 444-5678',
      registeredDate: 'Apr 20, 2026',
      tickets: '0 tickets',
      status: _ParticipantStatus.canceled,
      avatar: AppImages.userImg,
    ),
    _ParticipantData(
      name: 'Linda Martinez',
      email: 'linda.m@email.com',
      phone: '+1 (555) 333-4311',
      registeredDate: 'Feb 28, 2026',
      tickets: '2 tickets',
      status: _ParticipantStatus.confirmed,
      avatar: AppImages.messageAvatarJohn,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event Participants',
                style: TextStyles.boldTitle.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                'Downtown AR Treasure Hunt',
                style: TextStyles.regularExtraSmall.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.7),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          height: 154.h,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
          child: Column(
            children: [
              _statsRow(),
              SizedBox(height: 11.h),
              _searchBox(),
              SizedBox(height: 10.h),
              for (final participant in _participants) ...[
                _ParticipantCard(participant: participant),
                SizedBox(height: 11.h),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        const Expanded(
          child: _StatCard(
            value: '5',
            label: 'Total',
            color: AppColors.eventParticipantsTotalBg,
            valueColor: AppColors.eventParticipantsMessage,
          ),
        ),
        SizedBox(width: 8.w),
        const Expanded(
          child: _StatCard(
            value: '3',
            label: 'Confirmed',
            color: AppColors.eventParticipantsConfirmedBg,
            valueColor: AppColors.eventGreen,
          ),
        ),
        SizedBox(width: 8.w),
        const Expanded(
          child: _StatCard(
            value: '1',
            label: 'Pending',
            color: AppColors.eventParticipantsPendingBg,
            valueColor: AppColors.eventAmber,
          ),
        ),
      ],
    );
  }

  Widget _searchBox() {
    return Container(
      height: 31.h,
      decoration: BoxDecoration(
        color: AppColors.eventParticipantsSearchBg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        children: [
          SizedBox(width: 11.w),
          Icon(Icons.search, color: AppColors.eventMetaText, size: 13.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Search participants...',
              style: TextStyles.regularExtraSmall.copyWith(
                color: AppColors.eventMetaText,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color valueColor;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyles.boldSmall.copyWith(
              color: valueColor,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyles.regularTiny.copyWith(
              color: AppColors.eventMetaText,
              fontSize: 9.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantCard extends StatelessWidget {
  final _ParticipantData participant;

  const _ParticipantCard({required this.participant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(9.w, 9.h, 10.w, 9.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: AppColors.eventTabBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.asset(
              participant.avatar,
              width: 25.w,
              height: 25.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        participant.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.boldExtraSmall.copyWith(
                          color: AppColors.gradientColor1,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.workspace_premium_outlined,
                      color: AppColors.eventAmber,
                      size: 11.sp,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                _StatusPill(status: participant.status),
                SizedBox(height: 7.h),
                _metaLine(Icons.mail_outline, participant.email),
                SizedBox(height: 5.h),
                _metaLine(Icons.phone_outlined, participant.phone),
                SizedBox(height: 8.h),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 7.w,
                  runSpacing: 5.h,
                  children: [
                    Text(
                      'Registered: ${participant.registeredDate}',
                      style: TextStyles.regularTiny.copyWith(
                        color: AppColors.eventMetaText,
                        fontSize: 9.sp,
                      ),
                    ),
                    _TicketPill(label: participant.tickets),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 4.w),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(top: 75.h),
              child: GestureDetector(
                onTap: () => context.push(
                  '/single_message',
                  extra: {
                    'name': participant.name,
                    'subtitle': 'Downtown AR Treasure Hunt',
                  },
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: AppColors.eventParticipantsMessage,
                      size: 11.sp,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Message',
                      style: TextStyles.boldExtraSmall.copyWith(
                        color: AppColors.eventParticipantsMessage,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.eventMetaText, size: 9.sp),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularTiny.copyWith(
              color: AppColors.eventMetaText,
              fontSize: 9.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final _ParticipantStatus status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      _ParticipantStatus.confirmed => AppColors.eventGreen,
      _ParticipantStatus.pending => AppColors.eventAmber,
      _ParticipantStatus.canceled => AppColors.eventDanger,
    };
    final label = switch (status) {
      _ParticipantStatus.confirmed => 'Confirmed',
      _ParticipantStatus.pending => 'Pending',
      _ParticipantStatus.canceled => 'Canceled',
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: TextStyles.boldExtraSmall.copyWith(
          color: AppColors.bodyBg,
          fontSize: 8.sp,
        ),
      ),
    );
  }
}

class _TicketPill extends StatelessWidget {
  final String label;

  const _TicketPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.eventParticipantsTicketBg,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: AppColors.eventTabBorder),
      ),
      child: Text(
        label,
        style: TextStyles.boldExtraSmall.copyWith(
          color: AppColors.eventMetaText,
          fontSize: 8.sp,
        ),
      ),
    );
  }
}

class _ParticipantData {
  final String name;
  final String email;
  final String phone;
  final String registeredDate;
  final String tickets;
  final _ParticipantStatus status;
  final String avatar;

  const _ParticipantData({
    required this.name,
    required this.email,
    required this.phone,
    required this.registeredDate,
    required this.tickets,
    required this.status,
    required this.avatar,
  });
}

enum _ParticipantStatus { confirmed, pending, canceled }
