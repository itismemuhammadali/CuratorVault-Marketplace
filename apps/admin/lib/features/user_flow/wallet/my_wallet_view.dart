import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/theme/images.dart';

import '../../../core/components/global_header/header_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/buttons/custom_button.dart';
import '../../../core/theme/text_styles.dart';

class MyWalletView extends StatefulWidget {
  const MyWalletView({super.key});

  @override
  State<MyWalletView> createState() => _MyWalletViewState();
}

class _MyWalletViewState extends State<MyWalletView> {
  int _historyTabIndex = 0;

  OverlayEntry? _addFundsToastEntry;
  OverlayEntry? _releaseFlowToastEntry;

  final List<_EscrowTransaction> _escrowTransactions = const [
    _EscrowTransaction(
      title: 'Victorian Pocket Watch',
      orderId: 'ORD-2024-1234',
      role: 'Buying',
      buyer: 'Sarah Martinez',
      status: 'pending',
      amount: '\$1450.00',
    ),
    _EscrowTransaction(
      title: 'Art Deco Lamp',
      orderId: 'ORD-2024-5678',
      role: 'Selling',
      buyer: 'Daniel Brooks',
      status: 'pending',
      amount: '\$890.00',
      selling: true,
    ),
    _EscrowTransaction(
      title: 'Vintage Camera',
      orderId: 'ORD-2024-9012',
      role: 'Buying',
      buyer: 'Olivia Chen',
      status: 'pending',
      amount: '\$675.00',
    ),
  ];

  final List<_HistoryTransaction> _historyTransactions = const [
    _HistoryTransaction(
      title: 'Victorian Pocket Watch',
      date: '2/8/2024',
      amount: '-\$1450.00',
      status: 'pending',
      category: _HistoryCategory.buying,
      isNegative: true,
      isBagIcon: true,
    ),
    _HistoryTransaction(
      title: 'Escrow Hold - Victorian Watch',
      date: '2/8/2024',
      amount: '-\$1450.00',
      status: 'completed',
      category: _HistoryCategory.billing,
      isNegative: true,
      isBagIcon: false,
    ),
    _HistoryTransaction(
      title: 'Vintage Camera',
      date: '2/5/2024',
      amount: '-\$675.00',
      status: 'completed',
      category: _HistoryCategory.buying,
      isNegative: true,
      isBagIcon: true,
    ),
    _HistoryTransaction(
      title: 'Escrow Released - Vintage Camera',
      date: '2/6/2024',
      amount: '+\$675.00',
      status: 'completed',
      category: _HistoryCategory.billing,
      isNegative: false,
      isBagIcon: false,
    ),
    _HistoryTransaction(
      title: 'Art Deco Lamp',
      date: '2/7/2024',
      amount: '+\$890.00',
      status: 'completed',
      category: _HistoryCategory.selling,
      isNegative: false,
      isBagIcon: true,
    ),
    _HistoryTransaction(
      title: 'Payment Settlement - Art Deco Lamp',
      date: '2/7/2024',
      amount: '+\$890.00',
      status: 'pending',
      category: _HistoryCategory.selling,
      isNegative: false,
      isBagIcon: false,
    ),
  ];

  List<_HistoryTransaction> get _buyingTransactions => _historyTransactions
      .where((item) => item.category == _HistoryCategory.buying)
      .toList();

  List<_HistoryTransaction> get _sellingTransactions => _historyTransactions
      .where((item) => item.category == _HistoryCategory.selling)
      .toList();

  List<_HistoryTransaction> get _billingTransactions => _historyTransactions
      .where((item) => item.category == _HistoryCategory.billing)
      .toList();

  @override
  void dispose() {
    _addFundsToastEntry?.remove();
    _releaseFlowToastEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'My Wallet',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 28.sp,
            ),
          ),
          height: 200.h,
        ),
      ),
      backgroundColor: AppColors.subPageBg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _availableBalanceCard(),
                    SizedBox(height: 16.h),
                    _escrowSummaryCard(),
                    SizedBox(height: 16.h),
                    _sectionTitle('Quick Actions'),
                    SizedBox(height: 10.h),
                    _quickActionsRow(),
                    SizedBox(height: 16.h),
                    _sectionTitle('Escrow Transactions'),
                    SizedBox(height: 10.h),
                    ..._escrowTransactions.map(_escrowTile),
                    SizedBox(height: 16.h),
                    _paymentHeaderRow(),
                    SizedBox(height: 10.h),
                    _paymentMethodCard(
                      highlighted: true,
                      title: 'VISA •••• 4242',
                      subtitle: 'Expires 12/25',
                      showDefaultChip: true,
                    ),
                    SizedBox(height: 10.h),
                    _paymentMethodCard(
                      highlighted: false,
                      title: 'MASTERCARD •••• 8888',
                      subtitle: 'Expires 08/26',
                      showDefaultChip: false,
                    ),
                    SizedBox(height: 16.h),
                    _sectionTitle('Transaction History'),
                    SizedBox(height: 10.h),
                    _historyTabs(),
                    SizedBox(height: 10.h),
                    _historyContentByTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _availableBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientColor1, AppColors.gradientColor2],
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money, color: AppColors.bodyBg, size: 22.sp),
              SizedBox(width: 8.w),
              Text(
                'Available Balance',
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.95),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            '\$2450.75',
            style: TextStyles.semiBoldLarge.copyWith(
              color: AppColors.bodyBg,
            ),
          ),
          SizedBox(height: 14.h),
          CustomButton(
            onTap: () => context.push('/user/wallet/withdraw'),
            height: 52.h,
            borderRadius: 16.r,
            btnColor: AppColors.bodyBg.withValues(alpha: 0.92),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.sendImg,
                  width: 19.sp,
                  height: 19.sp,
                  color: AppColors.lightText,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 10.w),
                Text(
                  'Withdraw Funds',
                  style: TextStyles.mediumMedium.copyWith(
                    color: AppColors.lightText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _escrowSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.redButton,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42.w,
            width: 42.w,
            decoration: BoxDecoration(
              color: AppColors.darkText.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Image.asset(
                AppImages.clockImg,
                width: 22.sp,
                height: 22.sp,
                color: AppColors.bodyBg,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'Escrow Payment',
            style: TextStyles.mediumSmall.copyWith(color: AppColors.bodyBg),
          ),
          SizedBox(height: 8.h),
          Text(
            '\$3,450.00',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyles.boldMedium.copyWith(
        color: AppColors.gradientColor1,
      ),
    );
  }

  Widget _quickActionsRow() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            onTap: () async {
              final result = await context.push('/user/wallet/add');
              if (!mounted) return;
              if (result is double) {
                _showAddFundsToast(result);
              }
            },
            height: 80.h,
            borderRadius: 14.r,
            btnColor: AppColors.gradientColor1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.call_made, color: AppColors.bodyBg, size: 18.sp),
                SizedBox(height: 7.h),
                Text(
                  'Add Funds',
                  style: TextStyles.mediumMedium.copyWith(
                    color: AppColors.bodyBg,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: CustomButton(
            onTap: () => context.push('/user/wallet/withdraw'),
            height: 80.h,
            borderRadius: 14.r,
            btnColor: Colors.transparent,
            borderColor: AppColors.redButton,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.north_east, color: AppColors.redButton, size: 18.sp),
                SizedBox(height: 7.h),
                Text(
                  'Withdraw',
                  style: TextStyles.mediumMedium.copyWith(
                    color: AppColors.redButton,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddFundsToast(double amount) {
    _addFundsToastEntry?.remove();

    final overlay = Overlay.of(context);

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return _WalletTopToast(
          message:
              '\$${amount.toStringAsFixed(2)} added to your wallet successfully!',
          onDismissed: () {
            entry.remove();
            if (_addFundsToastEntry == entry) {
              _addFundsToastEntry = null;
            }
          },
        );
      },
    );

    _addFundsToastEntry = entry;
    overlay.insert(entry);
  }

  Widget _escrowTile(_EscrowTransaction item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: GestureDetector(
        onTap: () => _showReleaseRequestDialog(item),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.bodyBg.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.lightText.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 42.w,
                width: 42.w,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: AppColors.redButton,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.gradientColor1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.orderId,
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.lightText.withValues(alpha: 0.56),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: item.selling
                                ? AppColors.greenSuccess.withValues(alpha: 0.22)
                                : AppColors.redBackBg.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            item.role,
                            style: TextStyles.mediumExtraSmall.copyWith(
                              color: item.selling
                                  ? AppColors.greenSuccess
                                  : AppColors.redButton,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkText.withValues(alpha: 0.62),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            item.status,
                            style: TextStyles.mediumExtraSmall.copyWith(
                              color: AppColors.redButton,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                item.amount,
                style: TextStyles.semiBoldMedium.copyWith(
                  color: AppColors.gradientColor1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showReleaseRequestDialog(_EscrowTransaction item) async {
    final commentController = TextEditingController();

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.70),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 340.w),
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.32),
                  blurRadius: 28,
                  spreadRadius: -14,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 58.w,
                    width: 58.w,
                    decoration: BoxDecoration(
                      color: AppColors.gradientColor1,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor.withValues(alpha: 0.24),
                          blurRadius: 16,
                          spreadRadius: -7,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        AppImages.sendImg,
                        width: 24.sp,
                        height: 24.sp,
                        color: AppColors.bodyBg,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Request Release',
                    textAlign: TextAlign.center,
                    style: TextStyles.boldMedium.copyWith(
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Request the buyer to approve the release\nof funds for this order.',
                    textAlign: TextAlign.center,
                    style: TextStyles.regularMedium.copyWith(
                      color: const Color(0xFF6B7280),
                      fontSize: 14.sp,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF6FF),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: const Color(0xFFD7BBFF),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        _releaseInfoRow('Order ID', item.orderId),
                        SizedBox(height: 9.h),
                        _releaseInfoRow('Item', item.title),
                        SizedBox(height: 9.h),
                        _releaseInfoRow('Buyer', item.buyer),
                        SizedBox(height: 9.h),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: const Color(0xFFDCC8F3),
                        ),
                        SizedBox(height: 9.h),
                        _releaseInfoRow('Amount', item.amount, isAmount: true),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.bodyBg,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              AppImages.chatBubbleIcon,
                              width: 16.sp,
                              height: 16.sp,
                              color: const Color(0xFF667085),
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Add a comment (optional)',
                              style: TextStyles.mediumMedium.copyWith(
                                color: const Color(0xFF374151),
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          height: 118.h,
                          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
                          decoration: BoxDecoration(
                            color: AppColors.bodyBg,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: commentController,
                            maxLines: 5,
                            textAlignVertical: TextAlignVertical.top,
                            style: TextStyles.regularMedium.copyWith(
                              color: const Color(0xFF111827),
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintText:
                                  'e.g., Item has been delivered successfully, tracking number #123456',
                              hintMaxLines: 3,
                              hintStyle: TextStyles.regularMedium.copyWith(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 14.sp,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'This message will be sent to the buyer along with your release request.',
                          style: TextStyles.regularSmall.copyWith(
                            color: const Color(0xFF667085),
                            fontSize: 12.sp,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFFBDD6FF),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 18.sp,
                          width: 18.sp,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEAF2FF),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              AppImages.alertIcon,
                              width: 14.sp,
                              height: 14.sp,
                              color: const Color(0xFF2363EB),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'The buyer will be notified to review and approve your release request. Funds will be transferred once approved.',
                            style: TextStyles.mediumSmall.copyWith(
                              color: const Color(0xFF2363EB),
                              fontSize: 13.sp,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: CustomButton(
                            onTap: () => Navigator.of(dialogContext).pop(),
                            borderRadius: 14.r,
                            btnColor: AppColors.bodyBg,
                            borderColor: const Color(0xFFD1D5DB),
                            child: Text(
                              'Cancel',
                              style: TextStyles.mediumMedium.copyWith(
                                color: const Color(0xFF374151),
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomButton(
                          onTap: () async {
                            Navigator.of(dialogContext).pop();
                            final result = await context.push(
                              '/user/wallet/release-payment',
                              extra: {
                                'orderId': item.orderId,
                                'itemTitle': item.title,
                                'amount': item.amount,
                                'seller': 'Heritage Antiques',
                                'date': '2/8/2024',
                              },
                            );

                            if (!mounted || result is! Map) return;
                            final action = result['type'];

                            if (action == 'release_success') {
                              _showReleaseFlowToast(
                                label: 'Toast',
                                message: 'Payment released successfully!',
                                backgroundColor: const Color(0xFF091B3C),
                                textColor: const Color(0xFF00E676),
                                iconColor: const Color(0xFF00E676),
                                iconAsset: AppImages.tickIcon,
                              );
                            } else if (action == 'dispute_submitted') {
                              _showReleaseFlowToast(
                                label: 'Toast',
                                message:
                                    'Dispute raised. Our team will contact you shortly.',
                                backgroundColor: const Color(0xFFD9A46C),
                                textColor: const Color(0xFF111827),
                                iconColor: const Color(0xFF111827),
                                iconAsset: AppImages.alertIcon,
                              );
                            }
                          },
                          height: 48.h,
                          borderRadius: 14.r,
                          btnColor: AppColors.gradientColor1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.sendImg,
                                width: 14.sp,
                                height: 14.sp,
                                color: AppColors.bodyBg,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Send Request',
                                style: TextStyles.mediumMedium.copyWith(
                                  color: AppColors.bodyBg,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    commentController.dispose();
  }

  Widget _releaseInfoRow(
    String label,
    String value, {
    bool isAmount = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.mediumMedium.copyWith(
              color: const Color(0xFF9333EA),
              fontSize: 13.sp,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: isAmount
                ? TextStyles.boldLarge.copyWith(
                    color: const Color(0xFF6B21A8),
                    fontSize: 19.sp,
                  )
                : TextStyles.semiBoldMedium.copyWith(
                    color: const Color(0xFF6B21A8),
                    fontSize: 14.sp,
                  ),
          ),
        ),
      ],
    );
  }

  void _showReleaseFlowToast({
    required String label,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    required String iconAsset,
  }) {
    _releaseFlowToastEntry?.remove();
    final overlay = Overlay.of(context);

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return _WalletActionTopToast(
          label: label,
          message: message,
          backgroundColor: backgroundColor,
          textColor: textColor,
          iconColor: iconColor,
          iconAsset: iconAsset,
          onDismissed: () {
            entry.remove();
            if (_releaseFlowToastEntry == entry) {
              _releaseFlowToastEntry = null;
            }
          },
        );
      },
    );

    _releaseFlowToastEntry = entry;
    overlay.insert(entry);
  }

  Widget _paymentHeaderRow() {
    Widget addPaymentButton({double? width}) {
      return CustomButton(
        onTap: () async {
          try {
            await context.push('/user/wallet/payment-method');
          } catch (_) {
            if (!mounted) return;
            await context.push('/user/wallet/payment-method/add');
          }
        },
        width: width,
        height: 46.h,
        borderRadius: 12.r,
        btnColor: AppColors.redButton.withValues(alpha: 0.9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.grey, size: 20.sp),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                'Add New Payment',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.mediumSmall.copyWith(color: AppColors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = (constraints.maxWidth * 0.5).clamp(165.w, 200.w);

        return Row(
          children: [
            Expanded(child: _sectionTitle('Payment Methods')),
            SizedBox(width: 12.w),
            SizedBox(
              width: buttonWidth,
              child: addPaymentButton(width: double.infinity),
            ),
          ],
        );
      },
    );
  }

  Widget _paymentMethodCard({
    required bool highlighted,
    required String title,
    required String subtitle,
    required bool showDefaultChip,
  }) {
    final bg = highlighted
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientColor1, AppColors.gradientColor2],
          )
        : null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        gradient: bg,
        color: highlighted ? null : AppColors.bodyBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16.r),
        border: highlighted
            ? null
            : Border.all(
                color: AppColors.lightText.withValues(alpha: 0.12),
                width: 1,
              ),
      ),
      child: Row(
        children: [
          Container(
            height: 48.w,
            width: 48.w,
            decoration: BoxDecoration(
              color: highlighted
                  ? AppColors.bodyBg.withValues(alpha: 0.18)
                  : AppColors.grey,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.credit_card,
              size: 24.sp,
              color: highlighted ? AppColors.grey : AppColors.redButton,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.mediumMedium.copyWith(
                    color: highlighted
                        ? AppColors.grey
                        : AppColors.gradientColor1,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyles.regularSmall.copyWith(
                    color: highlighted
                        ? AppColors.darkText
                        : AppColors.lightText.withValues(alpha: 0.68),
                  ),
                ),
                if (showDefaultChip) ...[
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.redButton,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Default',
                      style: TextStyles.mediumExtraSmall.copyWith(
                        color: AppColors.bodyBg,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.more_vert,
            color: highlighted ? AppColors.darkText : AppColors.gradientColor1,
          ),
        ],
      ),
    );
  }

  Widget _historyTabs() {
    const labels = ['Buying', 'Selling', 'Billing'];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.lightText.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = index == _historyTabIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _historyTabIndex = index),
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.gradientColor2
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyles.mediumSmall.copyWith(
                      color: selected
                          ? AppColors.bodyBg
                          : AppColors.lightText.withValues(alpha: 0.72),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _historyContentByTab() {
    switch (_historyTabIndex) {
      case 0:
        return Column(children: _buyingTransactions.map(_historyTile).toList());
      case 1:
        return Column(
          children: _sellingTransactions.map(_historyTile).toList(),
        );
      case 2:
        return Column(
          children: _billingTransactions.map(_historyTile).toList(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _historyTile(_HistoryTransaction item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.lightText.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 46.w,
              width: 46.w,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                item.isBagIcon
                    ? Icons.shopping_bag_outlined
                    : Icons.shield_outlined,
                color: AppColors.lightText,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyles.mediumMedium.copyWith(
                      color: AppColors.gradientColor1,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    item.date,
                    style: TextStyles.regularSmall.copyWith(
                      color: AppColors.lightText.withValues(alpha: 0.56),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.amount,
                  style: TextStyles.mediumMedium.copyWith(
                    color: item.isNegative
                        ? AppColors.redButton
                        : AppColors.greenSuccess,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: item.status == 'pending'
                        ? AppColors.darkText.withValues(alpha: 0.66)
                        : AppColors.greenSuccess.withValues(alpha: 0.26),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyles.mediumExtraSmall.copyWith(
                      color: item.status == 'pending'
                          ? AppColors.redButton
                          : AppColors.greenSuccess,
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

class _EscrowTransaction {
  final String title;
  final String orderId;
  final String role;
  final String buyer;
  final String status;
  final String amount;
  final bool selling;

  const _EscrowTransaction({
    required this.title,
    required this.orderId,
    required this.role,
    required this.buyer,
    required this.status,
    required this.amount,
    this.selling = false,
  });
}

class _HistoryTransaction {
  final String title;
  final String date;
  final String amount;
  final String status;
  final _HistoryCategory category;
  final bool isNegative;
  final bool isBagIcon;

  const _HistoryTransaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    required this.category,
    required this.isNegative,
    required this.isBagIcon,
  });
}

enum _HistoryCategory { buying, selling, billing }

class _WalletTopToast extends StatefulWidget {
  const _WalletTopToast({required this.message, required this.onDismissed});

  final String message;
  final VoidCallback onDismissed;

  @override
  State<_WalletTopToast> createState() => _WalletTopToastState();
}

class _WalletActionTopToast extends StatefulWidget {
  const _WalletActionTopToast({
    required this.label,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.iconAsset,
    required this.onDismissed,
  });

  final String label;
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final String iconAsset;
  final VoidCallback onDismissed;

  @override
  State<_WalletActionTopToast> createState() => _WalletActionTopToastState();
}

class _WalletActionTopToastState extends State<_WalletActionTopToast> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _visible = true);
    });

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      setState(() => _visible = false);
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      widget.onDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            offset: _visible ? Offset.zero : const Offset(0, -0.25),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              opacity: _visible ? 1 : 0,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.bodyBg.withValues(alpha: 0.72),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 18.w,
                            width: 18.w,
                            decoration: BoxDecoration(
                              color: AppColors.bodyBg.withValues(alpha: 0.90),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Image.asset(
                                widget.iconAsset,
                                width: 10.sp,
                                height: 10.sp,
                                color: widget.iconColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              widget.message,
                              style: TextStyles.mediumMedium.copyWith(
                                color: widget.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletTopToastState extends State<_WalletTopToast> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _visible = true);
    });

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      setState(() => _visible = false);
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      widget.onDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            offset: _visible ? Offset.zero : const Offset(0, -0.25),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              opacity: _visible ? 1 : 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
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
                          color: AppColors.bodyBg,
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(
                            color: AppColors.lightText.withValues(alpha: 0.22),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            AppImages.tickIcon,
                            width: 13.sp,
                            height: 13.sp,
                            color: AppColors.lightText,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          widget.message,
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
          ),
        ),
      ),
    );
  }
}
