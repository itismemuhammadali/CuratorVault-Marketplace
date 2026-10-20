import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/services/api_service.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class DealerNotificationsView extends StatefulWidget {
  const DealerNotificationsView({super.key});

  @override
  State<DealerNotificationsView> createState() => _DealerNotificationsViewState();
}

class _DealerNotificationsViewState extends State<DealerNotificationsView> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  String _activeFilter = 'All';

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final res = await ApiService.get('/api/v1/notifications');
      if (res is Map && res['notifications'] is List && mounted) {
        setState(() {
          _notifications = List<Map<String, dynamic>>.from(res['notifications']);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching dealer notifications: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await ApiService.put('/api/v1/notifications/read-all', {});
      if (mounted) {
        setState(() {
          for (var notif in _notifications) {
            notif['isRead'] = true;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read')),
        );
      }
    } catch (e) {
      debugPrint('Error marking dealer notifications read: $e');
    }
  }

  Future<void> _handleNotificationTap(Map<String, dynamic> notif) async {
    final id = notif['id'];
    if (notif['isRead'] != true && id != null) {
      setState(() => notif['isRead'] = true);
      try {
        await ApiService.put('/api/v1/notifications/$id/read', {});
      } catch (_) {}
    }

    final actionUrl = notif['actionUrl'] as String?;
    if (actionUrl != null && actionUrl.isNotEmpty && mounted) {
      context.push(actionUrl);
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return Icons.local_shipping_outlined;
      case 'offer':
        return Icons.local_offer_outlined;
      case 'wallet':
        return Icons.account_balance_wallet_outlined;
      case 'message':
        return Icons.chat_bubble_outline_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return const Color(0xFF2B3F5F);
      case 'offer':
        return const Color(0xFFF08100);
      case 'wallet':
        return const Color(0xFF00A854);
      case 'message':
        return const Color(0xFF3B82F6);
      default:
        return AppColors.redButton;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _notifications.where((n) {
      if (_activeFilter == 'All') return true;
      if (_activeFilter == 'Unread') return n['isRead'] != true;
      if (_activeFilter == 'Orders') return n['type'] == 'order';
      if (_activeFilter == 'Offers') return n['type'] == 'offer';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.subPageBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: IconBox(
            icon: AppImages.backIcon,
            bgColor: AppColors.darkText.withValues(alpha: 0.20),
            onTap: () => context.pop(),
            iconColor: AppColors.darkText,
            height: 40.h,
            width: 40.w,
            borderRadius: 100.r,
          ),
          title: Text(
            'Dealer Alerts',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 26.sp,
            ),
          ),
          trailing: GestureDetector(
            onTap: _markAllAsRead,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Mark All Read',
                style: TextStyles.mediumSmall.copyWith(color: Colors.white),
              ),
            ),
          ),
          height: 160.h,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(height: 12.h),
            _filterChips(),
            SizedBox(height: 8.h),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_off_outlined,
                                size: 56.sp,
                                color: AppColors.greyText.withValues(alpha: 0.5),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'No notifications available',
                                style: TextStyles.mediumMedium.copyWith(
                                  color: AppColors.greyText,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final notif = filtered[index];
                            final isRead = notif['isRead'] == true;
                            final type = (notif['type'] ?? 'system').toString();
                            final color = _getColorForType(type);
                            final icon = _getIconForType(type);

                            return GestureDetector(
                              onTap: () => _handleNotificationTap(notif),
                              child: Container(
                                padding: EdgeInsets.all(14.w),
                                decoration: BoxDecoration(
                                  color: isRead ? AppColors.bodyBg : const Color(0xFFFFF9F5),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: isRead
                                        ? const Color(0xFFE5E7EB)
                                        : AppColors.redButton.withValues(alpha: 0.3),
                                    width: isRead ? 1 : 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadowColor.withValues(alpha: 0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 42.w,
                                      height: 42.w,
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(icon, color: color, size: 20.sp),
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
                                                  notif['title'] ?? 'Notification',
                                                  style: TextStyles.boldMedium.copyWith(
                                                    color: AppColors.gradientColor1,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                              ),
                                              if (!isRead)
                                                Container(
                                                  width: 8.w,
                                                  height: 8.w,
                                                  decoration: const BoxDecoration(
                                                    color: AppColors.redButton,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            notif['body'] ?? '',
                                            style: TextStyles.regularSmall.copyWith(
                                              color: const Color(0xFF4B5563),
                                              height: 1.35,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Text(
                                            notif['timeAgo'] ?? 'Just now',
                                            style: TextStyles.regularExtraSmall.copyWith(
                                              color: AppColors.greyText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChips() {
    final filters = ['All', 'Unread', 'Orders', 'Offers'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: filters.map((f) {
          final isSelected = _activeFilter == f;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () => setState(() => _activeFilter = f),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.redButton : AppColors.bodyBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? AppColors.redButton : const Color(0xFFD3D8E0),
                  ),
                ),
                child: Text(
                  f,
                  style: TextStyles.mediumSmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.gradientColor1,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
