import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'release_payment_view.dart';

class MyWalletView extends StatefulWidget {
  const MyWalletView({super.key});

  @override
  State<MyWalletView> createState() => _MyWalletViewState();
}

class _MyWalletViewState extends State<MyWalletView> {
  int _selectedTransactionTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: Column(
        children: [
          // Header with back button
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2D3E55), Color(0xFF1A2332)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconBox(
                        icon: AppImages.backIcon,
                        iconColor: const Color(0xFFF8E8C7),
                        bgColor: const Color(0xFFF8E8C7).withValues(alpha: 0.20),
                        height: 40.h,
                        width: 40.w,
                        borderRadius: 100.r,
                        onTap: () {
                          context.pop();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'My Wallet',
                    style: TextStyles.boldLarge.copyWith(
                      color: AppColors.bodyBg,
                      fontSize: 28.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Available Balance Card
                  _availableBalanceCard(context),
                  SizedBox(height: 16.h),
                  // Escrow Payment Card
                  _escrowPaymentCard(),
                  SizedBox(height: 20.h),
                  // Quick Actions
                  _quickActionsSection(context),
                  SizedBox(height: 20.h),
                  // Escrow Transactions
                  _escrowTransactionsSection(),
                  SizedBox(height: 20.h),
                  // Payment Methods
                  _paymentMethodsSection(context),
                  SizedBox(height: 20.h),
                  // Transaction History
                  _transactionHistorySection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _availableBalanceCard(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2D3E55), Color(0xFF1A2332)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: EdgeInsets.all(18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 18.sp,
                color: AppColors.bodyBg.withValues(alpha: 0.85),
              ),
              SizedBox(width: 4.w),
              Text(
                'Available Balance',
                style: TextStyles.mediumMedium.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.85),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '\$2450.75',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 36.sp,
            ),
          ),
          SizedBox(height: 14.h),
          GestureDetector(
            onTap: () => context.push('/user/wallet/withdraw'),
            child: Container(
              width: double.infinity,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.bodyBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/send_icon.svg',
                    width: 18.w,
                    height: 18.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF2D3E55),
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Withdraw Funds',
                    style: TextStyles.mediumMedium.copyWith(
                      color: const Color(0xFF2D3E55),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _escrowPaymentCard() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA75500), Color(0xFFC65A46)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: EdgeInsets.all(18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF).withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.schedule_rounded,
              size: 22.sp,
              color: AppColors.bodyBg,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Escrow Payment',
            style: TextStyles.mediumMedium.copyWith(
              color: AppColors.bodyBg,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '\$3,450.00',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 28.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyles.boldMedium.copyWith(
            color: AppColors.lightText,
            fontSize: 21.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => context.push('/user/wallet/add-funds'),
                child: Container(
                  height: 70.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2D3E55), Color(0xFF1A2332)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/arrow_bottom_icon.svg',
                        width: 20.w,
                        height: 20.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFFFFFF),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: 6.h),
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
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: () => context.push('/user/wallet/withdraw'),
                child: Container(
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: AppColors.bodyBg,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFB75D4F), width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/arrow_top_icon.svg',
                        width: 20.w,
                        height: 20.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFB75D4F),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Withdraw',
                        style: TextStyles.mediumMedium.copyWith(
                          color: const Color(0xFFB75D4F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _escrowTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escrow Transactions',
          style: TextStyles.boldMedium.copyWith(
            color: AppColors.lightText,
            fontSize: 21.sp,
          ),
        ),
        SizedBox(height: 12.h),
        _transactionItem(
          context: context,
          title: 'Victorian Pocket Watch',
          orderId: 'ORD-2024-1234',
          type: 'Buying',
          status: 'pending',
          amount: '\$1450.00',
          buyer: 'John Smith',
        ),
        SizedBox(height: 10.h),
        _transactionItem(
          context: context,
          title: 'Art Deco Lamp',
          orderId: 'ORD-2024-5678',
          type: 'Selling',
          status: 'pending',
          amount: '\$890.00',
          buyer: 'Sarah Martinez',
        ),
        SizedBox(height: 10.h),
        _transactionItem(
          context: context,
          title: 'Vintage Camera',
          orderId: 'ORD-2024-9012',
          type: 'Buying',
          status: 'pending',
          amount: '\$675.00',
          buyer: 'Emma Wilson',
        ),
      ],
    );
  }

  Widget _transactionItem({
    required BuildContext context,
    required String title,
    required String orderId,
    required String type,
    required String status,
    required String amount,
    required String buyer,
  }) {
    return GestureDetector(
      onTap: () => _showRequestReleaseModal(
        context: context,
        orderId: orderId,
        itemTitle: title,
        buyer: buyer,
        amount: amount,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE8E1D6), width: 1),
        ),
        padding: EdgeInsets.all(14.w),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB75D4F).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/shield_protection_icon.svg',
                      width: 18.w,
                      height: 18.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFB75D4F),
                        BlendMode.srcIn,
                      ),
                    ),
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
                          color: AppColors.lightText,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        orderId,
                        style: TextStyles.regularSmall.copyWith(
                          color: AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amount,
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.lightText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: type == 'Buying'
                            ? const Color(0xFFB75D4F).withValues(alpha: 0.10)
                            : const Color(0xFFD9F5E4),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        type,
                        style: TextStyles.regularSmall.copyWith(
                          color: type == 'Buying'
                              ? const Color(0xFFB75D4F)
                              : const Color(0xFF07BA54),
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        status,
                        style: TextStyles.regularSmall.copyWith(
                          color: const Color(0xFFF59E0B),
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: AppColors.greyText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Methods',
              style: TextStyles.boldMedium.copyWith(
                color: AppColors.lightText,
                fontSize: 21.sp,
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/user/wallet/payment-methods'),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: const BoxDecoration(
                  color: Color(0xFFB75D4F),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 14.sp,
                      color: const Color(0xFFF8E8C7),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Add New',
                      style: TextStyles.regularSmall.copyWith(
                        color: const Color(0xFFF8E8C7),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _paymentCard('VISA', '4242', 'Expires 12/25'),
        SizedBox(height: 8.h),
        _paymentCard('MASTERCARD', '8888', 'Expires 08/28', isSecondary: true),
      ],
    );
  }

  Widget _paymentCard(String type, String last4, String expiry,
      {bool isSecondary = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: isSecondary
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2D3E55), Color(0xFF1A2332)],
              ),
        color: isSecondary ? AppColors.bodyBg : null,
        borderRadius: BorderRadius.circular(12.r),
        border: isSecondary
            ? Border.all(color: const Color(0xFFE8E1D6), width: 1)
            : null,
      ),
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isSecondary
                  ? const Color(0xFFFEEDEA)
                  : const Color(0xFFF8E8C7).withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.credit_card,
              size: 20.sp,
              color: isSecondary ? const Color(0xFFB75D4F) : const Color(0xFFF8E8C7),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type •••• $last4',
                  style: TextStyles.mediumMedium.copyWith(
                    color: isSecondary ? AppColors.lightText : const Color(0xFFF8E8C7),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  expiry,
                  style: TextStyles.regularSmall.copyWith(
                    color: isSecondary
                        ? AppColors.greyText
                        : const Color(0xFFF8E8C7).withValues(alpha: 0.7),
                  ),
                ),
                if (!isSecondary) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB75D4F),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'default',
                      style: TextStyles.regularSmall.copyWith(
                        color: const Color(0xFFF8E8C7),
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.more_vert,
            size: 20.sp,
            color: isSecondary ? AppColors.greyText : const Color(0xFFF8E8C7),
          ),
        ],
      ),
    );
  }

  Widget _transactionHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction History',
          style: TextStyles.boldMedium.copyWith(
            color: AppColors.lightText,
            fontSize: 21.sp,
          ),
        ),
        SizedBox(height: 12.h),
        // Tabs
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: const Color(0xFF717182).withValues(alpha: 0.30),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              _tabButton('Buying', 0),
              _tabButton('Selling', 1),
              _tabButton('Billing', 2),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        // Transaction items
        if (_selectedTransactionTab == 0) ...[
          // Buying tab
          _historyItemCard('Art Deco Lamp', '2/7/2024', '+\$890.00', 'pending', false, false),
          SizedBox(height: 8.h),
          _historyItemCard('Escrow Hold - Art Deco Lamp', '2/7/2024', '+\$890.00', 'completed', true, false),
          SizedBox(height: 8.h),
          _historyItemCard('Vintage Camera', '2/5/2024', '+\$675.00', 'completed', false, false),
          SizedBox(height: 8.h),
          _historyItemCard('Escrow Released - Vintage Camera', '2/6/2024', '+\$675.00', 'completed', true, false),
        ] else if (_selectedTransactionTab == 1) ...[
          // Selling tab
          _historyItemCard('Art Deco Lamp', '2/7/2024', '+\$890.00', 'pending', false, true),
          SizedBox(height: 8.h),
          _historyItemCard('Escrow Hold - Art Deco Lamp', '2/7/2024', '+\$890.00', 'completed', true, true),
          SizedBox(height: 8.h),
          _historyItemCard('Antique Vase', '2/1/2024', '+\$1250.00', 'completed', false, true),
          SizedBox(height: 8.h),
          _historyItemCard('Escrow Released - Antique Vase', '2/3/2024', '+\$1250.00', 'completed', true, true),
        ] else ...[
          // Billing tab - same as Selling but without pending
          _historyItemCard('Escrow Hold - Art Deco Lamp', '2/7/2024', '+\$890.00', 'completed', true, true),
          SizedBox(height: 8.h),
          _historyItemCard('Antique Vase', '2/1/2024', '+\$1250.00', 'completed', false, true),
          SizedBox(height: 8.h),
          _historyItemCard('Escrow Released - Antique Vase', '2/3/2024', '+\$1250.00', 'completed', true, true),
        ],
      ],
    );
  }

  Widget _tabButton(String label, int index) {
    bool isSelected = _selectedTransactionTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTransactionTab = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A2332) : Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyles.mediumSmall.copyWith(
                color: isSelected ? AppColors.bodyBg : AppColors.greyText,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _historyItemCard(String title, String date, String amount, String status, bool useShieldIcon, bool isSelling) {
    // Determine icon based on useShieldIcon and isSelling
    String icon;
    if (isSelling && !useShieldIcon) {
      icon = 'assets/icons/growth_icon.svg';
    } else {
      icon = useShieldIcon
          ? 'assets/icons/shield_protection_icon.svg'
          : 'assets/icons/escrow_icon.svg';
    }

    // Background color based on tab
    Color bgColor;
    if (isSelling) {
      bgColor = const Color(0xFF22C55E).withValues(alpha: 0.10);
    } else {
      bgColor = const Color(0xFFB75D4F).withValues(alpha: 0.10);
    }

    // Amount color and prefix
    Color amountColor;
    String amountPrefix;
    if (isSelling) {
      amountColor = const Color(0xFF22C55E);
      amountPrefix = '+';
    } else {
      amountColor = const Color(0xFFC85D45);
      amountPrefix = '-';
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E1D6), width: 1),
      ),
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF000000),
                  BlendMode.srcIn,
                ),
              ),
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
                    color: AppColors.lightText,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  date,
                  style: TextStyles.regularSmall.copyWith(
                    color: AppColors.greyText,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix${amount.replaceAll('+', '').replaceAll('-', '')}',
                style: TextStyles.mediumMedium.copyWith(
                  color: amountColor,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: status == 'completed'
                      ? const Color(0xFF22C55E).withValues(alpha: 0.10)
                      : const Color(0xFFF59E0B).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  status,
                  style: TextStyles.regularSmall.copyWith(
                    color: status == 'completed'
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFF59E0B),
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showRequestReleaseModal({
    required BuildContext context,
    required String orderId,
    required String itemTitle,
    required String buyer,
    required String amount,
  }) async {
    final commentController = TextEditingController();

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 14.h),
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 58.w,
                    width: 58.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2D3E55),
                          Color(0xFF1A2332),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor.withValues(alpha: 0.24),
                          blurRadius: 16,
                          spreadRadius: -8,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/send_icon.svg',
                        width: 24.w,
                        height: 24.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFFFFFF),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    'Request Release',
                    style: TextStyles.boldMedium.copyWith(
                      color: const Color(0xFF1F2937),
                      fontSize: 24.sp.clamp(20, 24),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Center(
                  child: Text(
                    'Request the buyer to approve the release\nof funds for this order.',
                    textAlign: TextAlign.center,
                    style: TextStyles.regularMedium.copyWith(
                      color: const Color(0xFF475467),
                      fontSize: 14.sp.clamp(12, 14),
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFAF5FF),
                        Color(0xFFFDF2F8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xFFE9D4FF)),
                  ),
                  child: Column(
                    children: [
                      _modalInfoRow('Order ID', orderId),
                      SizedBox(height: 8.h),
                      _modalInfoRow('Item', itemTitle),
                      SizedBox(height: 8.h),
                      _modalInfoRow('Buyer', buyer),
                      SizedBox(height: 8.h),
                      Container(height: 1, color: const Color(0xFFE9D4FF)),
                      SizedBox(height: 8.h),
                      _modalInfoRow('Amount', amount, isEmphasis: true),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.bodyBg,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xFFD8DEE6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 14.sp,
                            color: const Color(0xFF667085),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Add a comment (optional)',
                            style: TextStyles.mediumMedium.copyWith(
                              color: const Color(0xFF344054),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFD0D5DD)),
                        ),
                        child: TextField(
                          controller: commentController,
                          minLines: 4,
                          maxLines: 4,
                          style: TextStyles.regularMedium.copyWith(
                            color: const Color(0xFF1F2937),
                            fontSize: 12.sp,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(
                              12.w,
                              10.h,
                              12.w,
                              10.h,
                            ),
                            hintText:
                                'e.g., Item has been delivered\nsuccessfully, tracking number #123456',
                            hintStyle: TextStyles.regularMedium.copyWith(
                              color: const Color(0xFF98A2B3),
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'This message will be sent to the buyer along\nwith your release request.',
                        style: TextStyles.regularMedium.copyWith(
                          color: const Color(0xFF667085),
                          fontSize: 12.sp,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7EDFF),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xFFBFD0FF)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/exclamation_circle_icon.svg',
                        width: 16.w,
                        height: 16.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1D4ED8),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'The buyer will be notified to review and approve your release request. Funds will be transferred once approved.',
                          style: TextStyles.regularMedium.copyWith(
                            color: const Color(0xFF1D4ED8),
                            fontSize: 12.sp,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: Container(
                          height: 44.h,
                          decoration: BoxDecoration(
                            color: AppColors.bodyBg,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFFD0D5DD)),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyles.mediumMedium.copyWith(
                                color: const Color(0xFF344054),
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          _showReleasePaymentDialog(
                            context: context,
                            orderId: orderId,
                            itemTitle: itemTitle,
                            amount: amount,
                            buyer: buyer,
                          );
                        },
                        child: Container(
                          height: 44.h,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2D3E55),
                                Color(0xFF1A2332),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/send_icon.svg',
                                width: 16.w,
                                height: 16.h,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFFFFFFFF),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Send Request',
                                style: TextStyles.mediumMedium.copyWith(
                                  color: AppColors.bodyBg,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    commentController.dispose();
  }

  Widget _modalInfoRow(String label, String value, {bool isEmphasis = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.regularMedium.copyWith(
              color: const Color(0xFF8200DB),
              fontSize: 12.sp,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyles.mediumMedium.copyWith(
            color: isEmphasis ? const Color(0xFF59168B) : const Color(0xFF59168B),
            fontSize: isEmphasis ? 13.sp : 12.sp,
          ),
        ),
      ],
    );
  }

  Future<void> _showReleasePaymentDialog({
    required BuildContext context,
    required String orderId,
    required String itemTitle,
    required String amount,
    required String buyer,
  }) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => ReleasePaymentView(
          orderId: orderId,
          itemTitle: itemTitle,
          amount: amount,
          seller: buyer,
          date: '2/8/2024',
        ),
      ),
    );

    if (result != null && context.mounted) {
      if (result['type'] == 'release_success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment released successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (result['type'] == 'dispute_submitted') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dispute submitted. We will review it soon.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}
