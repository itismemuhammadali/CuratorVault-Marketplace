import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/items_service.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

enum OffersTab { received, send }

class OffersView extends StatefulWidget {
  const OffersView({
    super.key,
    this.initialTab = OffersTab.received,
    this.showSubmittedToast = false,
  });

  final OffersTab initialTab;
  final bool showSubmittedToast;

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  late OffersTab _selectedTab;
  bool _showCounterForm = false;
  OverlayEntry? _toastOverlay;
  bool _isLoading = true;
  List<Map<String, dynamic>> _receivedOffers = [];
  List<Map<String, dynamic>> _sentOffers = [];

  final TextEditingController _counterAmountController = TextEditingController(
    text: '\$ 0.00',
  );
  final TextEditingController _counterMessageController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _loadOffers();

    if (widget.showSubmittedToast) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showSuccessToast('Offer submitted successfully');
      });
    }
  }

  Future<void> _loadOffers() async {
    setState(() {
      _isLoading = true;
    });
    final received = await ItemsService.getOffers(type: 'received');
    final sent = await ItemsService.getOffers(type: 'sent');
    if (mounted) {
      setState(() {
        _receivedOffers = received;
        _sentOffers = sent;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _toastOverlay?.remove();
    _counterAmountController.dispose();
    _counterMessageController.dispose();
    super.dispose();
  }

  void _showSuccessToast(String message) {
    _toastOverlay?.remove();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 20.w,
          right: 20.w,
          top: MediaQuery.of(context).padding.top + 18.h,
          child: IgnorePointer(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.bodyBg,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor.withValues(alpha: 0.18),
                      blurRadius: 20,
                      spreadRadius: -12,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 22.w,
                      width: 22.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_rounded,
                          size: 13.sp,
                          color: AppColors.bodyBg,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyles.mediumMedium.copyWith(
                          color: AppColors.lightText,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    _toastOverlay = entry;
    overlay.insert(entry);

    Future<void>.delayed(const Duration(seconds: 2), () {
      if (_toastOverlay == entry) {
        entry.remove();
        _toastOverlay = null;
      }
    });
  }

  HeaderConfig _headerConfig(BuildContext context) {
    return HeaderConfig(
      title: Text(
        'Offers & Negotiations',
        style: TextStyles.boldLarge.copyWith(color: AppColors.bodyBg),
      ),
      leading: GestureDetector(
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/user/market');
          }
        },
        child: Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF8E8C7).withValues(alpha: 0.20),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.arrow_back_rounded,
              color: const Color(0xFFF8E8C7),
              size: 20.sp,
            ),
          ),
        ),
      ),
      bottomWidget: Row(
        children: [
          Expanded(
            child: _OfferTabButton(
              label: 'Received (${_receivedOffers.length})',
              isSelected: _selectedTab == OffersTab.received,
              onTap: () {
                setState(() {
                  _selectedTab = OffersTab.received;
                });
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _OfferTabButton(
              label: 'Sent (${_sentOffers.length})',
              isSelected: _selectedTab == OffersTab.send,
              onTap: () {
                setState(() {
                  _selectedTab = OffersTab.send;
                  _showCounterForm = false;
                });
              },
            ),
          ),
        ],
      ),
      height: 210.h,
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _selectedTab == OffersTab.received ? _receivedOffers : _sentOffers;

    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: SimpleHeader(config: _headerConfig(context)),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: JumpingDots(color: AppColors.redButton))
            : list.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_offer_outlined, size: 54.sp, color: Colors.grey),
                        SizedBox(height: 12.h),
                        Text(
                          _selectedTab == OffersTab.received
                              ? 'No offers received on your listings yet'
                              : 'You have not submitted any offers yet',
                          style: TextStyles.mediumSmall.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadOffers,
                    color: AppColors.redButton,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 28.h),
                      child: _selectedTab == OffersTab.received
                          ? _ReceivedOfferCard(
                              showCounterForm: _showCounterForm,
                              amountController: _counterAmountController,
                              messageController: _counterMessageController,
                              onCounterTap: () {
                                setState(() {
                                  _showCounterForm = !_showCounterForm;
                                });
                              },
                              onCancelCounter: () {
                                setState(() {
                                  _showCounterForm = false;
                                });
                              },
                              onSendCounter: () async {
                                final text = _counterAmountController.text.replaceAll(RegExp(r'[^0-9.]'), '');
                                final price = double.tryParse(text) ?? 1350.0;
                                await ItemsService.respondOffer('offer_1', 'counter', counterPrice: price, message: _counterMessageController.text);
                                setState(() {
                                  _showCounterForm = false;
                                });
                                _showSuccessToast('Counter offer sent');
                                _loadOffers();
                              },
                              onDecline: () async {
                                await ItemsService.respondOffer('offer_1', 'decline');
                                _showSuccessToast('Offer declined');
                                _loadOffers();
                              },
                              onAccept: () async {
                                await ItemsService.respondOffer('offer_1', 'accept');
                                _showSuccessToast('Offer accepted! Order ready for checkout.');
                                _loadOffers();
                              },
                            )
                          : _SentOfferCard(
                              onWithdraw: () async {
                                await ItemsService.respondOffer('offer_2', 'decline');
                                _showSuccessToast('Offer withdrawn');
                                _loadOffers();
                              },
                            ),
                    ),
                  ),
      ),
    );
  }
}


class _OfferTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OfferTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42.h,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.darkText.withValues(alpha: 0.22)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.darkText,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.darkText,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReceivedOfferCard extends StatelessWidget {
  final bool showCounterForm;
  final TextEditingController amountController;
  final TextEditingController messageController;
  final VoidCallback onCounterTap;
  final VoidCallback onCancelCounter;
  final VoidCallback onSendCounter;
  final VoidCallback onDecline;
  final VoidCallback onAccept;

  const _ReceivedOfferCard({
    required this.showCounterForm,
    required this.amountController,
    required this.messageController,
    required this.onCounterTap,
    required this.onCancelCounter,
    required this.onSendCounter,
    required this.onDecline,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _OfferProductHeader(
            badgeText: 'Counter Offer',
            badgeTextColor: Color(0xFF3478F6),
            badgeBorderColor: Color(0xFF3478F6),
            badgeIcon: Icons.trending_up_rounded,
          ),
          SizedBox(height: 16.h),
          _OfferValueRow(
            label: 'Your Offer:',
            value: '\$1200.00',
            valueColor: AppColors.lightText,
          ),
          SizedBox(height: 14.h),
          _OfferValueRow(
            label: 'Counter Offer:',
            value: '\$1350.00',
            valueColor: const Color(0xFF3478F6),
          ),
          SizedBox(height: 8.h),
          const _OfferMetaRow(
            leftText: '2 hours ago',
            rightText: '22 hours left',
          ),
          SizedBox(height: 14.h),
          const _OfferMessageBubble(
            label: 'Your Message:',
            icon: Icons.chat_bubble_outline_rounded,
            iconColor: AppColors.redButton,
            backgroundColor: Color(0xFFFCF6F2),
            text:
                "I'm a serious collector and would love to add this to my collection. This is my best offer.",
          ),
          SizedBox(height: 12.h),
          const _OfferMessageBubble(
            label: "Seller's Response:",
            icon: Icons.chat_bubble_outline_rounded,
            iconColor: Color(0xFF3478F6),
            backgroundColor: Color(0xFFEFF4FF),
            text:
                'Thank you for your interest! I can meet you at \$1,350. This piece is in exceptional condition with documented provenance.',
          ),
          if (showCounterForm) ...[
            SizedBox(height: 16.h),
            _CounterForm(
              amountController: amountController,
              messageController: messageController,
              onCancel: onCancelCounter,
              onSendCounter: onSendCounter,
            ),
          ] else ...[
            SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Decline',
                      textColor: const Color(0xFFFF4E4E),
                      borderColor: const Color(0xFFFF4E4E),
                      backgroundColor: Colors.transparent,
                      onTap: onDecline,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _ActionButton(
                      label: 'Counter Again',
                      textColor: AppColors.lightText,
                      backgroundColor: const Color(0xFFF7E5B9),
                      onTap: onCounterTap,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _ActionButton(
                      label: 'Accept',
                      textColor: AppColors.bodyBg,
                      backgroundColor: const Color(0xFF22C55E),
                      onTap: onAccept,
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}

class _SentOfferCard extends StatelessWidget {
  final VoidCallback onWithdraw;

  const _SentOfferCard({required this.onWithdraw});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _OfferProductHeader(
            badgeText: 'Pending',
            badgeTextColor: Color(0xFFF59E0B),
            badgeBorderColor: Color(0xFFF59E0B),
            badgeIcon: Icons.access_time_rounded,
          ),
          SizedBox(height: 16.h),
          _OfferValueRow(
            label: 'Your Offer:',
            value: '\$1250.00',
            valueColor: AppColors.lightText,
          ),
          SizedBox(height: 8.h),
          const _OfferMetaRow(
            leftText: '5 hours ago',
            rightText: '19 hours left',
          ),
          SizedBox(height: 16.h),
          const _OfferMessageBubble(
            label: 'Your Message:',
            icon: Icons.chat_bubble_outline_rounded,
            iconColor: AppColors.redButton,
            backgroundColor: Color(0xFFFCF6F2),
            text:
                'Would love to purchase this beautiful piece for my antique collection.',
          ),
          SizedBox(height: 18.h),
          _ActionButton(
            label: 'Withdraw Offer',
            textColor: const Color(0xFFFF4E4E),
            borderColor: const Color(0xFFFF4E4E),
            backgroundColor: Colors.transparent,
            onTap: () {
              onWithdraw();
            },
            width: double.infinity,
            height: 42.h,
          ),
        ],
      ),
    );
  }
}

class _OfferProductHeader extends StatelessWidget {
  final String badgeText;
  final Color badgeTextColor;
  final Color badgeBorderColor;
  final IconData badgeIcon;

  const _OfferProductHeader({
    required this.badgeText,
    required this.badgeTextColor,
    required this.badgeBorderColor,
    required this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Image.asset(
                AppImages.productOne,
                width: 58.w,
                height: 58.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Victorian Pocket Watch',
                    style: TextStyles.semiBoldMedium.copyWith(
                      color: AppColors.gradientColor1,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Heritage Antiques',
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.greyText,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: badgeBorderColor, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(badgeIcon, size: 14.sp, color: badgeTextColor),
                        SizedBox(width: 4.w),
                        Text(
                          badgeText,
                          style: TextStyles.regularExtraSmall.copyWith(
                            color: badgeTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Container(
          height: 1,
          color: AppColors.darkText.withValues(alpha: 0.90),
        ),
      ],
    );
  }
}

class _OfferValueRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _OfferValueRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.greyText,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyles.mediumLarge.copyWith(
            color: valueColor,
            fontSize: 19.sp,
          ),
        ),
      ],
    );
  }
}

class _OfferMetaRow extends StatelessWidget {
  final String leftText;
  final String rightText;

  const _OfferMetaRow({required this.leftText, required this.rightText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            leftText,
            style: TextStyles.regularExtraSmall.copyWith(
              color: AppColors.greyText,
            ),
          ),
        ),
        Text(
          rightText,
          style: TextStyles.regularExtraSmall.copyWith(
            color: AppColors.greyText,
          ),
        ),
      ],
    );
  }
}

class _OfferMessageBubble extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String text;

  const _OfferMessageBubble({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.sp, color: iconColor),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyles.regularExtraSmall.copyWith(
                  color: AppColors.gradientColor1,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            text,
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.lightText,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterForm extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController messageController;
  final VoidCallback onCancel;
  final VoidCallback onSendCounter;

  const _CounterForm({
    required this.amountController,
    required this.messageController,
    required this.onCancel,
    required this.onSendCounter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF8F4),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Counter Amount',
            style: TextStyles.mediumMedium.copyWith(
              color: AppColors.gradientColor1,
            ),
          ),
          SizedBox(height: 10.h),
          _InputShell(
            child: TextField(
              controller: amountController,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
              ),
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.greyText,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Message',
            style: TextStyles.mediumMedium.copyWith(
              color: AppColors.gradientColor1,
            ),
          ),
          SizedBox(height: 10.h),
          _InputShell(
            minHeight: 120.h,
            child: TextField(
              controller: messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Add a message...',
                hintStyle: TextStyles.regularMedium.copyWith(
                  color: AppColors.greyText,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
              ),
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Cancel',
                  textColor: AppColors.lightText,
                  borderColor: AppColors.grey.withValues(alpha: 0.7),
                  backgroundColor: AppColors.bodyBg,
                  onTap: onCancel,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _ActionButton(
                  label: 'Send Counter',
                  textColor: AppColors.lightText,
                  backgroundColor: const Color(0xFFF7E5B9),
                  onTap: onSendCounter,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InputShell extends StatelessWidget {
  final Widget child;
  final double? minHeight;

  const _InputShell({required this.child, this.minHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight ?? 44.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: child,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final Color? borderColor;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const _ActionButton({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.onTap,
    this.borderColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height ?? 38.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: borderColor ?? Colors.transparent),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.mediumSmall.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: AppColors.bodyBg,
    borderRadius: BorderRadius.circular(18.r),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowColor.withValues(alpha: 0.14),
        blurRadius: 20.r,
        spreadRadius: -10,
        offset: Offset(0, 12.h),
      ),
      BoxShadow(
        color: AppColors.shadowColor.withValues(alpha: 0.08),
        blurRadius: 10.r,
        spreadRadius: -6,
        offset: Offset(0, 4.h),
      ),
    ],
  );
}
