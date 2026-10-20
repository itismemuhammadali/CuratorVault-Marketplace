import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

import 'package:vintage_app/core/services/api_service.dart';

class AcceptOrderView extends StatefulWidget {
  final String orderId;
  final String itemTitle;
  final String priceText;
  final String ageText;
  final String productImage;

  const AcceptOrderView({
    super.key,
    required this.orderId,
    required this.itemTitle,
    required this.priceText,
    required this.ageText,
    required this.productImage,
  });

  @override
  State<AcceptOrderView> createState() => _AcceptOrderViewState();
}

enum _BottomCtaState { acceptOrder, markShipped, backToHome }

class _AcceptOrderViewState extends State<AcceptOrderView> {
  _BottomCtaState _bottomCtaState = _BottomCtaState.acceptOrder;
  bool _isLoading = false;

  String get _statusTitle {
    if (_bottomCtaState == _BottomCtaState.acceptOrder) {
      return 'Awaiting Confirmation';
    }
    if (_bottomCtaState == _BottomCtaState.markShipped) {
      return 'In Transit';
    }
    return 'Shipped';
  }

  int get _completedStepCount {
    if (_bottomCtaState == _BottomCtaState.acceptOrder) {
      return 1;
    }
    if (_bottomCtaState == _BottomCtaState.markShipped) {
      return 2;
    }
    return 3;
  }

  IconData get _statusLeadingIcon {
    if (_bottomCtaState == _BottomCtaState.acceptOrder) {
      return Icons.access_time_rounded;
    }
    if (_bottomCtaState == _BottomCtaState.markShipped) {
      return Icons.inventory_2_outlined;
    }
    return Icons.local_shipping_outlined;
  }

  Future<void> _handleBottomCtaTap() async {
    if (_bottomCtaState == _BottomCtaState.acceptOrder) {
      final accepted = await _showAcceptOrderDialog();
      if (accepted == true && mounted) {
        setState(() => _isLoading = true);
        try {
          await ApiService.post('/api/v1/orders/${widget.orderId}/accept', {});
        } catch (e) {
          debugPrint('Error accepting order API: $e');
        }
        if (mounted) {
          setState(() {
            _isLoading = false;
            _bottomCtaState = _BottomCtaState.markShipped;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order accepted! Customer has been notified.')),
          );
        }
      }
      return;
    }

    if (_bottomCtaState == _BottomCtaState.markShipped) {
      final shipResult = await _showMarkShippedDialog();
      if (shipResult != null && mounted) {
        setState(() => _isLoading = true);
        try {
          await ApiService.post('/api/v1/orders/${widget.orderId}/fulfill', {
            'carrier': shipResult['carrier'] ?? 'DHL Express',
            'trackingNumber': shipResult['tracking'] ?? 'DHL123456789',
          });
        } catch (e) {
          debugPrint('Error marking order shipped API: $e');
        }
        if (mounted) {
          setState(() {
            _isLoading = false;
            _bottomCtaState = _BottomCtaState.backToHome;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order marked as shipped via ${shipResult['carrier']}!')),
          );
        }
      }
      return;
    }

    context.go('/homeScreen');
  }

  Future<bool?> _showAcceptOrderDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          backgroundColor: Colors.transparent,
          child: _dialogContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Accept Order',
                  textAlign: TextAlign.center,
                  style: TextStyles.boldLarge.copyWith(
                    color: const Color(0xFF202124),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'By accepting this order, you commit to shipping "${widget.itemTitle}" to John Collector within 3 business days. The payment of ${widget.priceText} is securely held in escrow.',
                  textAlign: TextAlign.center,
                  style: TextStyles.regularMedium.copyWith(
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 18.h),
                _dialogButton(
                  label: 'Accept Order',
                  buttonColor: AppColors.redButton,
                  textColor: AppColors.bodyBg,
                  onTap: () => Navigator.of(dialogContext).pop(true),
                ),
                SizedBox(height: 10.h),
                _dialogButton(
                  label: 'Cancel',
                  buttonColor: Colors.transparent,
                  textColor: const Color(0xFF202124),
                  borderColor: const Color(0xFFD3D8E0),
                  onTap: () => Navigator.of(dialogContext).pop(false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, String>?> _showMarkShippedDialog() {
    return showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _MarkShippedDialog(),
    );
  }

  Widget _dialogContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.authBackBg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: child,
    );
  }

  Widget _dialogButton({
    required String label,
    required Color buttonColor,
    required Color textColor,
    Color borderColor = Colors.transparent,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54.h,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.mediumMedium.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: IconBox(
            icon: AppImages.backIcon,
            bgColor: AppColors.darkText.withValues(alpha: 0.20),
            onTap: () => context.go('/dealer/orders'),
            iconColor: AppColors.darkText,
            height: 40.h,
            width: 40.w,
            borderRadius: 100.r,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Details',
                style: TextStyles.boldLarge.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 28.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.orderId,
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          height: 178.h,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 22.h),
          child: Column(
            children: [
              _statusCard(),
              SizedBox(height: 14.h),
              _itemDetailsCard(),
              SizedBox(height: 12.h),
              _buyerCard(context),
              SizedBox(height: 12.h),
              _escrowCard(),
              SizedBox(height: 22.h),
              _primaryButton(
                label: _isLoading
                    ? 'Processing...'
                    : _bottomCtaState == _BottomCtaState.acceptOrder
                    ? 'Accept Order'
                    : _bottomCtaState == _BottomCtaState.markShipped
                    ? 'Mark as Shipped'
                    : 'Back to Home',
                icon: _bottomCtaState == _BottomCtaState.acceptOrder
                    ? AppImages.circularTickIcon
                    : null,
                showShippingIcon: _bottomCtaState == _BottomCtaState.markShipped,
                onTap: _isLoading ? () {} : _handleBottomCtaTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusCard() {
    final statusColor = _bottomCtaState == _BottomCtaState.acceptOrder
        ? const Color(0xFF2D3E55)
        : _bottomCtaState == _BottomCtaState.markShipped
        ? const Color(0xFF2D3E55)
        : const Color(0xFF00A854);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8E8),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE9D3D3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _statusLeadingIcon,
                  size: 16.sp,
                  color: statusColor,
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _statusTitle,
                    style: TextStyles.mediumMedium.copyWith(color: statusColor),
                  ),
                  Text(
                    widget.ageText,
                    style: TextStyles.regularSmall.copyWith(
                      color: const Color(0xFF5F6A7D),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              _progressStep(
                svgIcon: AppImages.checkEmailIcon,
                label: 'Ordered',
                isCompleted: _completedStepCount >= 1,
              ),
              _progressLine(_completedStepCount >= 2),
              _progressStep(
                svgIcon: AppImages.packageIcon,
                label: 'Accepted',
                isCompleted: _completedStepCount >= 2,
              ),
              _progressLine(_completedStepCount >= 3),
              _progressStep(
                icon: Icons.local_shipping_outlined,
                label: 'Shipped',
                isCompleted: _completedStepCount >= 3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressLine(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        color: isCompleted ? const Color(0xFF00C950) : const Color(0xFFCED5DF),
      ),
    );
  }

  Widget _progressStep({
    required String label,
    required bool isCompleted,
    IconData? icon,
    String? svgIcon,
  }) {
    double iconSize = 18.sp;
    if (svgIcon != null) {
      iconSize = label == 'Accepted' ? 23.sp : 18.sp;
    }

    final iconColor = isCompleted ? Colors.white : const Color(0xFF99A1AF);

    return Column(
      children: [
        Container(
          width: 33.w,
          height: 33.w,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFF00C950)
                : const Color(0xFFCED5DF),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: svgIcon != null
              ? SvgPicture.asset(
                  svgIcon,
                  width: iconSize,
                  height: iconSize,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                )
              : Icon(icon, size: iconSize, color: iconColor),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyles.regularExtraSmall.copyWith(
            color: const Color(0xFF5F6A7D),
          ),
        ),
      ],
    );
  }

  Widget _itemDetailsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Item Details', style: TextStyles.boldMedium),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  widget.productImage,
                  width: 70.w,
                  height: 70.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.itemTitle,
                      style: TextStyles.mediumMedium.copyWith(
                        color: const Color(0xFF202124),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.priceText,
                      style: TextStyles.boldMedium.copyWith(
                        color: const Color(0xFFF08100),
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                'Payment Status',
                style: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF5F6A7D),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.shield_outlined,
                size: 16.sp,
                color: const Color(0xFF00A854),
              ),
              SizedBox(width: 5.w),
              Text(
                'In Escrow',
                style: TextStyles.mediumMedium.copyWith(
                  color: const Color(0xFF00A854),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                'Order Date',
                style: TextStyles.regularMedium.copyWith(
                  color: const Color(0xFF5F6A7D),
                ),
              ),
              const Spacer(),
              Text(
                widget.ageText,
                style: TextStyles.mediumMedium.copyWith(
                  color: const Color(0xFF202124),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buyerCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Buyer Information', style: TextStyles.boldMedium),
          SizedBox(height: 12.h),
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  AppImages.userImg,
                  width: 42.w,
                  height: 42.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('John Collector', style: TextStyles.mediumMedium),
                  Text(
                    'Verified Buyer',
                    style: TextStyles.regularSmall.copyWith(
                      color: const Color(0xFF5F6A7D),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Divider(height: 1, color: const Color(0xFFE2E7EF)),
          SizedBox(height: 14.h),
          _infoLine(Icons.mail_outline_rounded, 'john.collector@email.com'),
          SizedBox(height: 12.h),
          _infoLine(Icons.call_outlined, '+1 (555) 123-4567'),
          SizedBox(height: 12.h),
          _infoLine(
            Icons.location_on_outlined,
            '123 Main St, New York, NY 10001',
          ),
          SizedBox(height: 16.h),
          _primaryButton(
            label: 'Message Buyer',
            icon: AppImages.chatBubbleIcon,
            onTap: () => context.push('/single_message'),
          ),
        ],
      ),
    );
  }

  Widget _infoLine(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.sp, color: const Color(0xFF5F6A7D)),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyles.regularSmall.copyWith(
              color: const Color(0xFF5F6A7D),
            ),
          ),
        ),
      ],
    );
  }

  Widget _escrowCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFCFF2DF),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFA4E6C3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF00B85C),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_outlined,
                  size: 16.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Escrow Protection',
                style: TextStyles.boldMedium.copyWith(
                  color: const Color(0xFF0F6A3C),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            'Payment is securely held in escrow. Funds will be released to you once the buyer confirms delivery.',
            style: TextStyles.regularSmall.copyWith(
              color: const Color(0xFF0F6A3C),
              height: 1.35,
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
            decoration: BoxDecoration(
              color: AppColors.bodyBg.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              children: [
                _moneyLine(label: 'Item Price', value: widget.priceText),
                SizedBox(height: 8.h),
                _moneyLine(label: 'Platform Fee (5%)', value: '-\$42.50'),
                SizedBox(height: 8.h),
                Divider(height: 1, color: const Color(0xFFBEDBCB)),
                SizedBox(height: 8.h),
                _moneyLine(
                  label: 'Your Payout',
                  value: '\$807.50',
                  emphasize: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _moneyLine({
    required String label,
    required String value,
    bool emphasize = false,
  }) {
    final color = emphasize ? const Color(0xFF00A854) : const Color(0xFF202124);

    return Row(
      children: [
        Text(
          label,
          style: TextStyles.mediumMedium.copyWith(
            color: const Color(0xFF4B5563),
          ),
        ),
        const Spacer(),
        Text(value, style: TextStyles.boldMedium.copyWith(color: color)),
      ],
    );
  }

  Widget _primaryButton({
    required String label,
    String? icon,
    bool showShippingIcon = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2B3F5F), Color(0xFF1D2A3F)],
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Image.asset(
                  icon,
                  width: 14.w,
                  height: 14.h,
                  color: AppColors.bodyBg,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 8.w),
              ] else if (showShippingIcon) ...[
                Icon(
                  Icons.local_shipping_outlined,
                  size: 16.sp,
                  color: AppColors.bodyBg,
                ),
                SizedBox(width: 8.w),
              ],
              Text(
                label,
                style: TextStyles.mediumMedium.copyWith(
                  color: AppColors.bodyBg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarkShippedDialog extends StatefulWidget {
  const _MarkShippedDialog();

  @override
  State<_MarkShippedDialog> createState() => _MarkShippedDialogState();
}

class _MarkShippedDialogState extends State<_MarkShippedDialog> {
  late final TextEditingController _trackingController;
  String _selectedCarrier = 'DHL Express';
  final List<String> _carriers = [
    'DHL Express',
    'FedEx',
    'UPS',
    'Royal Mail',
    'USPS Priority',
  ];
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _trackingController = TextEditingController(text: 'DHL987654321');
  }

  @override
  void dispose() {
    _trackingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 18.h),
        decoration: BoxDecoration(
          color: AppColors.authBackBg,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Mark as Shipped',
                textAlign: TextAlign.center,
                style: TextStyles.boldLarge.copyWith(
                  color: const Color(0xFF202124),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Select the courier service and enter the tracking number for this shipment.',
              textAlign: TextAlign.center,
              style: TextStyles.regularMedium.copyWith(
                color: const Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Courier Service',
              style: TextStyles.mediumSmall.copyWith(color: const Color(0xFF202124)),
            ),
            SizedBox(height: 6.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFD3D8E0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCarrier,
                  isExpanded: true,
                  items: _carriers.map((carrier) {
                    return DropdownMenuItem<String>(
                      value: carrier,
                      child: Row(
                        children: [
                          Icon(Icons.local_shipping_outlined, size: 18.sp, color: AppColors.redButton),
                          SizedBox(width: 8.w),
                          Text(carrier, style: TextStyles.mediumMedium),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedCarrier = val);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              'Tracking Number',
              style: TextStyles.mediumSmall.copyWith(color: const Color(0xFF202124)),
            ),
            SizedBox(height: 6.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: _validationError == null
                      ? const Color(0xFFD3D8E0)
                      : AppColors.redButton,
                ),
              ),
              child: TextField(
                controller: _trackingController,
                style: TextStyles.mediumMedium.copyWith(
                  color: const Color(0xFF202124),
                ),
                onChanged: (_) {
                  if (_validationError != null) {
                    setState(() {
                      _validationError = null;
                    });
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'e.g. DHL987654321 / 1Z999AA10123456784',
                  hintStyle: TextStyles.regularMedium.copyWith(
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),
            if (_validationError != null) ...[
              SizedBox(height: 8.h),
              Text(
                _validationError!,
                style: TextStyles.regularSmall.copyWith(
                  color: AppColors.redButton,
                ),
              ),
            ],
            SizedBox(height: 18.h),
            GestureDetector(
              onTap: () {
                final tracking = _trackingController.text.trim();
                if (tracking.isEmpty) {
                  setState(() {
                    _validationError = 'Please enter a valid tracking number.';
                  });
                  return;
                }
                Navigator.of(context).pop({
                  'carrier': _selectedCarrier,
                  'tracking': tracking,
                });
              },
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.redButton,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    'Confirm Shipment',
                    style: TextStyles.mediumMedium.copyWith(
                      color: AppColors.bodyBg,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(null),
              child: Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFD3D8E0)),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyles.mediumMedium.copyWith(
                      color: const Color(0xFF202124),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
