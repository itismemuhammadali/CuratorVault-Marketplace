import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/services/api_service.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

Future<void> showEventCancelSheet(
  BuildContext context, {
  required String eventId,
  String? eventTitle,
  int participantsCount = 0,
  VoidCallback? onCancelled,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EventCancelSheet(
      eventId: eventId,
      eventTitle: eventTitle ?? 'This Event',
      participantsCount: participantsCount,
      onCancelled: onCancelled,
    ),
  );
}

class EventCancelSheet extends StatefulWidget {
  final String eventId;
  final String eventTitle;
  final int participantsCount;
  final VoidCallback? onCancelled;

  const EventCancelSheet({
    super.key,
    required this.eventId,
    required this.eventTitle,
    this.participantsCount = 0,
    this.onCancelled,
  });

  @override
  State<EventCancelSheet> createState() => _EventCancelSheetState();
}

class _EventCancelSheetState extends State<EventCancelSheet> {
  bool _isCancelling = false;

  Future<void> _cancelEvent() async {
    setState(() => _isCancelling = true);
    try {
      await ApiService.delete('/api/v1/events/${widget.eventId}');
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event cancelled successfully'),
            backgroundColor: AppColors.gradientColor1,
          ),
        );
        widget.onCancelled?.call();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCancelling = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel event: $e'),
            backgroundColor: AppColors.redButton,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.22),
              blurRadius: 22,
              spreadRadius: -8,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CancelSheetHeader(onClose: () => context.pop()),
                SizedBox(height: 16.h),
                _CancelEventNotice(
                  eventTitle: widget.eventTitle,
                  participantsCount: widget.participantsCount,
                ),
                SizedBox(height: 16.h),
                const _CancelWarningNotice(),
                SizedBox(height: 18.h),
                _SheetPrimaryButton(
                  label: _isCancelling ? 'Cancelling Event...' : 'Yes, Cancel Event',
                  isLoading: _isCancelling,
                  onTap: _isCancelling ? () {} : _cancelEvent,
                ),
                SizedBox(height: 10.h),
                _SheetSecondaryButton(
                  label: 'Keep Event',
                  onTap: () => context.pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CancelSheetHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _CancelSheetHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: AppColors.eventCancelIconBg,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.eventDanger,
                  size: 22.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cancel Event?',
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.lightText,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'This action cannot be undone',
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.eventMetaText,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: AppColors.bodyBg,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.eventTabBorder),
              ),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.eventMetaText,
                size: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CancelEventNotice extends StatelessWidget {
  final String eventTitle;
  final int participantsCount;

  const _CancelEventNotice({
    required this.eventTitle,
    required this.participantsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.eventCancelNoticeBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.eventCancelNoticeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eventTitle,
            style: TextStyles.boldSmall.copyWith(
              color: AppColors.eventCancelTitle,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              style: TextStyles.regularSmall.copyWith(
                color: AppColors.eventCancelText,
                fontSize: 12.sp,
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'Canceling this event will notify all '),
                TextSpan(
                  text: '$participantsCount registered participants',
                  style: TextStyles.boldSmall.copyWith(
                    color: AppColors.eventCancelText,
                    fontSize: 12.sp,
                    height: 1.4,
                  ),
                ),
                const TextSpan(text: ' via email and push notification.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelWarningNotice extends StatelessWidget {
  const _CancelWarningNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.eventWarningBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.eventWarningBorder),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyles.regularExtraSmall.copyWith(
            color: AppColors.eventWarningText,
            fontSize: 11.sp,
            height: 1.3,
          ),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(right: 9.w),
                child: Icon(
                  Icons.warning_rounded,
                  color: AppColors.eventWarningText,
                  size: 16.sp,
                ),
              ),
            ),
            TextSpan(
              text: 'Warning:',
              style: TextStyles.boldExtraSmall.copyWith(
                color: AppColors.eventWarningText,
                fontSize: 11.sp,
              ),
            ),
            const TextSpan(
              text:
                  ' This action is permanent and cannot be reversed. '
                  'All participant registrations will be cancelled.',
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const _SheetPrimaryButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.eventCancelButton,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.semiBoldSmall.copyWith(
              color: AppColors.bodyBg,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SheetSecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.semiBoldSmall.copyWith(
              color: AppColors.lightText,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }
}
