import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class MyWalletView extends StatefulWidget {
  const MyWalletView({super.key});

  @override
  State<MyWalletView> createState() => _MyWalletViewState();
}

class _MyWalletViewState extends State<MyWalletView> {
  String? _openPaymentMenu;

  static const _transactions = <_TransactionItem>[
    _TransactionItem(
      icon: Icons.north_east_rounded,
      iconBg: Color(0xFFD9FBE7),
      iconColor: Color(0xFF22C55E),
      title: 'Balance Top-up',
      date: 'Feb 2, 2026',
      amount: '+\$500.00',
      amountColor: Color(0xFF16A34A),
      status: 'completed',
      statusBg: Color(0xFF22C55E),
    ),
    _TransactionItem(
      icon: Icons.south_west_rounded,
      iconBg: Color(0xFFFFE5E8),
      iconColor: Color(0xFFFF5364),
      title: 'Bank Transfer',
      date: 'Feb 1, 2026',
      amount: '-\$250.00',
      amountColor: Color(0xFFE02434),
      status: 'completed',
      statusBg: Color(0xFF22C55E),
    ),
    _TransactionItem(
      icon: Icons.workspace_premium_rounded,
      iconBg: Color(0xFFF1DFFF),
      iconColor: Color(0xFFB35CFF),
      title: 'Premium Plus Renewal',
      date: 'Jan 30, 2026',
      amount: '\$9.99',
      amountColor: Color(0xFF344054),
      status: 'completed',
      statusBg: Color(0xFF22C55E),
    ),
    _TransactionItem(
      icon: Icons.north_east_rounded,
      iconBg: Color(0xFFD9FBE7),
      iconColor: Color(0xFF22C55E),
      title: 'Balance Top-up',
      date: 'Jan 28, 2026',
      amount: '+\$500.00',
      amountColor: Color(0xFF16A34A),
      status: 'pending',
      statusBg: Color(0xFFFF8A00),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          height: 145.h,
          leading: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              width: 31.w,
              height: 31.w,
              decoration: BoxDecoration(
                color: AppColors.bodyBg.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 19.sp,
                color: AppColors.darkText,
              ),
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Management',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldSection.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 21.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Balance, cards & transactions',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.semiBoldExtraSmall.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.80),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFAFAFB),
      body: SafeArea(
        top: false,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_openPaymentMenu != null) {
              setState(() => _openPaymentMenu = null);
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(14.w, 11.h, 14.w, 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _balanceCard(context),
                SizedBox(height: 12.h),
                _premiumCard(),
                SizedBox(height: 18.h),
                _sectionHeader(context),
                SizedBox(height: 10.h),
                _paymentMethodCard(
                  brand: 'Visa',
                  tail: '4242',
                  expires: '12/28',
                  isDefault: true,
                ),
                SizedBox(height: 8.h),
                _paymentMethodCard(
                  brand: 'Mastercard',
                  tail: '5555',
                  expires: '08/27',
                ),
                SizedBox(height: 16.h),
                _transactionsCard(),
                SizedBox(height: 14.h),
                _outlineAction(
                  svgPath: 'assets/icons/crown_icon.svg',
                  label: 'Manage Member Ships',
                  borderColor: const Color(0xFFD75CFF),
                  textColor: const Color(0xFFB35CFF),
                  onTap: () => context.push('/dealer/membership-points'),
                ),
                SizedBox(height: 8.h),
                _outlineAction(
                  svgPath: 'assets/icons/escrow_icon.svg',
                  label: 'Escrow Sales Management',
                  subtitle: 'View all running sales & transactions',
                  borderColor: const Color(0xFF7A6CFF),
                  textColor: const Color(0xFF5B5BDB),
                  onTap: () => context.push('/dealer/wallet/escrow-payments'),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    'Vintage Vinnie Admin v1.0.0',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.boldExtraSmall.copyWith(
                      color: const Color(0xFF9AA4B2),
                      fontSize: 9.5.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _balanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFBF3),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFCBEFDA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/wallet_icon2.svg',
                width: 15.sp,
                height: 15.sp,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF22C55E),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  'Available Balance',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.semiBoldExtraSmall.copyWith(
                    color: const Color(0xFF667085),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '\$12,450.75',
              maxLines: 1,
              style: TextStyles.boldLarge.copyWith(
                color: const Color(0xFF0F9F52),
                fontSize: 29.sp,
                letterSpacing: 0,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _miniBalanceTile(
                  title: 'Pending',
                  value: '\$3,200.50',
                  valueColor: const Color(0xFFFF3D2E),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _miniBalanceTile(
                  title: 'Total',
                  value: '\$15,651.25',
                  valueColor: const Color(0xFF4F63DF),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          InkWell(
            onTap: () => context.push('/dealer/wallet/withdraw'),
            borderRadius: BorderRadius.circular(4.r),
            child: Container(
              height: 40.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bodyBg,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: const Color(0xFF22C55E)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: 135 * 3.14159 / 180,
                    child: Icon(
                      Icons.arrow_outward_rounded,
                      size: 14.sp,
                      color: const Color(0xFF16A34A),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      'Withdraw',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.boldExtraSmall.copyWith(
                        color: const Color(0xFF16A34A),
                        fontSize: 14.sp,
                      ),
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

  Widget _miniBalanceTile({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.mediumExtraSmall.copyWith(
              color: const Color(0xFF667085),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldExtraSmall.copyWith(
              color: valueColor,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _premiumCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5FF),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFF0DDF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B4658),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/crown_icon.svg',
                    width: 21.sp,
                    height: 21.sp,
                    colorFilter: const ColorFilter.mode(
                      AppColors.bodyBg,
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
                      'Premium Plus',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.boldSmall.copyWith(
                        color: const Color(0xFF344054),
                        fontSize: 17.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/crown_icon.svg',
                          width: 12.sp,
                          height: 12.sp,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF667085),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            'Renews May 15, 2026',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.semiBoldExtraSmall.copyWith(
                              color: const Color(0xFF667085),
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              _statusPill(
                label: 'Active',
                background: const Color(0xFF22C55E),
                fontSize: 10.sp,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(height: 1.h, color: const Color(0xFFEDE4ED)),
          SizedBox(height: 12.h),
          Text(
            'Membership Benefits',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.semiBoldExtraSmall.copyWith(
              color: const Color(0xFF344054),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          _benefitLine('Unlimited Access'),
          SizedBox(height: 5.h),
          _benefitLine('Priority Support'),
          SizedBox(height: 5.h),
          _benefitLine('Advanced Analytics'),
        ],
      ),
    );
  }

  Widget _benefitLine(String text) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 14.sp,
          color: const Color(0xFF22C55E),
        ),
        SizedBox(width: 7.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.mediumExtraSmall.copyWith(
              color: const Color(0xFF344054),
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Payment Methods',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldSmall.copyWith(
              color: const Color(0xFF344054),
              fontSize: 17.sp,
            ),
          ),
        ),
        InkWell(
          onTap: () => context.push('/dealer/wallet/payment-method/add'),
          borderRadius: BorderRadius.circular(4.r),
          child: Container(
            height: 25.h,
            padding: EdgeInsets.symmetric(horizontal: 9.w),
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: const Color(0xFF4F79FF)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 13.sp,
                  color: const Color(0xFF4F79FF),
                ),
                SizedBox(width: 4.w),
                Text(
                  'Add Card',
                  style: TextStyles.mediumExtraSmall.copyWith(
                    color: const Color(0xFF4F79FF),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _paymentMethodCard({
    required String brand,
    required String tail,
    required String expires,
    bool isDefault = false,
  }) {
    final isMenuOpen = _openPaymentMenu == tail;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 90.h),
          padding: EdgeInsets.fromLTRB(12.w, 14.h, 10.w, 14.h),
          decoration: BoxDecoration(
            color: AppColors.bodyBg,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFE9EAED)),
          ),
          child: Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B4658),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.credit_card_rounded,
                  size: 22.sp,
                  color: AppColors.bodyBg,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6.w,
                      runSpacing: 2.h,
                      children: [
                        Text(
                          brand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.boldExtraSmall.copyWith(
                            color: const Color(0xFF344054),
                            fontSize: 14.sp,
                            height: 1.05,
                          ),
                        ),
                        if (isDefault) _defaultPill(),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '.... $tail',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.semiBoldExtraSmall.copyWith(
                        color: const Color(0xFF667085),
                        fontSize: 13.sp,
                        height: 1.05,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Expires $expires',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.mediumExtraSmall.copyWith(
                        color: const Color(0xFF9AA4B2),
                        fontSize: 11.sp,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _openPaymentMenu = isMenuOpen ? null : tail;
                  });
                },
                child: SizedBox(
                  width: 20.w,
                  height: 32.h,
                  child: Icon(
                    Icons.more_vert_rounded,
                    size: 18.sp,
                    color: const Color(0xFF344054),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isMenuOpen)
          Positioned(
            top: 40.h,
            right: 0,
            child: _removeMenu(),
          ),
      ],
    );
  }

  Widget _removeMenu() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _openPaymentMenu = null),
        borderRadius: BorderRadius.circular(4.r),
        child: Container(
          width: 86.w,
          height: 32.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.bodyBg,
            borderRadius: BorderRadius.circular(4.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 10,
                spreadRadius: -4,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            'Remove',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.mediumExtraSmall.copyWith(
              color: const Color(0xFFE02434),
              fontSize: 9.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _defaultPill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFF4F79FF),
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Text(
        'Default',
        style: TextStyles.boldExtraSmall.copyWith(
          color: AppColors.bodyBg,
          fontSize: 8.5.sp,
        ),
      ),
    );
  }

  Widget _transactionsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 8.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE9EAED)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                size: 16.sp,
                color: const Color(0xFF22C55E),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Recent Transactions',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.boldExtraSmall.copyWith(
                    color: const Color(0xFF344054),
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          for (final item in _transactions) _transactionRow(item),
        ],
      ),
    );
  }

  Widget _transactionRow(_TransactionItem item) {
    final canOpenDetails = item.title == 'Bank Transfer';

    return Padding(
      padding: EdgeInsets.only(bottom: 9.h),
      child: InkWell(
        onTap: canOpenDetails ? () => _showTransactionDetailsDialog() : null,
        borderRadius: BorderRadius.circular(8.r),
        child: Row(
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: item.iconBg,
                shape: BoxShape.circle,
              ),
              child: item.title == 'Premium Plus Renewal'
                  ? Center(
                      child: SvgPicture.asset(
                        'assets/icons/crown_icon.svg',
                        width: 15.sp,
                        height: 15.sp,
                        colorFilter: ColorFilter.mode(
                          item.iconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : Icon(item.icon, size: 18.sp, color: item.iconColor),
            ),
            SizedBox(width: 9.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.boldExtraSmall.copyWith(
                      color: const Color(0xFF344054),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    item.date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.mediumExtraSmall.copyWith(
                      color: const Color(0xFF9AA4B2),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 84.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.amount,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.boldExtraSmall.copyWith(
                      color: item.amountColor,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  _statusPill(
                    label: item.status,
                    background: item.statusBg,
                    fontSize: 9.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTransactionDetailsDialog() {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.42),
      builder: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 598.h, maxHeight: 650.h),
            padding: EdgeInsets.fromLTRB(24.w, 26.h, 24.w, 16.h),
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(4.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 18,
                  spreadRadius: -6,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.south_west_rounded,
                      size: 19.sp,
                      color: const Color(0xFFFF2D2D),
                    ),
                    SizedBox(width: 11.w),
                    Expanded(
                      child: Text(
                        'Transaction Details',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.boldLarge.copyWith(
                          color: const Color(0xFF1F1F1F),
                          fontSize: 20.sp,
                          height: 1.1,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(dialogContext).pop(),
                      borderRadius: BorderRadius.circular(18.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          Icons.close_rounded,
                          size: 25.sp,
                          color: const Color(0xFF5A5A5A),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Complete information about this transaction.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.regularSmall.copyWith(
                    color: const Color(0xFF667085),
                    fontSize: 15.sp,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 18.h),
                _transactionAmountPanel(),
                SizedBox(height: 17.h),
                _transactionInfoRow(
                  icon: Icons.tag_rounded,
                  iconBg: const Color(0xFFEAF2FF),
                  iconColor: const Color(0xFF2E73F2),
                  label: 'Transaction ID',
                  value: 'TXN-WD-001-2026',
                ),
                SizedBox(height: 15.h),
                _transactionInfoRow(
                  icon: Icons.calendar_month_outlined,
                  iconBg: const Color(0xFFF5E8FF),
                  iconColor: const Color(0xFFA855F7),
                  label: 'Date & Time',
                  value: 'Feb 1, 2026',
                  subtitle: '10:30 AM',
                ),
                SizedBox(height: 15.h),
                _transactionInfoRow(
                  icon: Icons.account_balance_outlined,
                  iconBg: const Color(0xFFFFF1E7),
                  iconColor: const Color(0xFFFF6B1A),
                  label: 'Destination Account',
                  value: 'Bank of America ....5678',
                ),
                SizedBox(height: 15.h),
                _transactionInfoRow(
                  icon: Icons.check_circle_outline_rounded,
                  iconBg: const Color(0xFFE3FAE8),
                  iconColor: const Color(0xFF22C55E),
                  label: 'Status',
                  value: '',
                  status: _statusPill(
                    label: 'Completed',
                    background: const Color(0xFF22C55E),
                    fontSize: 13.sp,
                  ),
                ),
                const Spacer(),
                _dialogCloseButton(dialogContext),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _transactionAmountPanel() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F5),
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: const Color(0xFFFFB8B8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                r'$',
                style: TextStyles.regularLarge.copyWith(
                  color: const Color(0xFFE00012),
                  fontSize: 22.sp,
                  height: 1,
                ),
              ),
              SizedBox(width: 17.w),
              Expanded(
                child: Text(
                  'Amount Withdrawn',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.boldSmall.copyWith(
                    color: const Color(0xFF5B6472),
                    fontSize: 14.sp,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '-\$250.00',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldLarge.copyWith(
              color: const Color(0xFFC40000),
              fontSize: 29.sp,
              height: 1,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Bank Transfer',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.mediumSmall.copyWith(
              color: const Color(0xFF344054),
              fontSize: 13.sp,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionInfoRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
    String? subtitle,
    Widget? status,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, size: 21.sp, color: iconColor),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.regularSmall.copyWith(
                  color: const Color(0xFF667085),
                  fontSize: 13.sp,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 5.h),
              if (status != null)
                status
              else
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.boldSmall.copyWith(
                    color: const Color(0xFF2D3E55),
                    fontSize: 15.sp,
                    height: 1.1,
                  ),
                ),
              if (subtitle != null) ...[
                SizedBox(height: 7.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.regularSmall.copyWith(
                    color: const Color(0xFF667085),
                    fontSize: 13.sp,
                    height: 1.1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _dialogCloseButton(BuildContext dialogContext) {
    return InkWell(
      onTap: () => Navigator.of(dialogContext).pop(),
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: double.infinity,
        height: 53.h,
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFFE2E4E8)),
        ),
        child: Center(
          child: Text(
            'Close',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.mediumMedium.copyWith(
              color: const Color(0xFF1F2937),
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _outlineAction({
    IconData? icon,
    String? svgPath,
    required String label,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: subtitle == null ? 55.h : 68.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (svgPath != null)
                  SvgPicture.asset(
                    svgPath,
                    width: 16.sp,
                    height: 16.sp,
                    colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
                  )
                else if (icon != null)
                  Icon(icon, size: 16.sp, color: textColor),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyles.boldExtraSmall.copyWith(
                      color: textColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              SizedBox(height: 4.h),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyles.semiBoldExtraSmall.copyWith(
                  color: const Color(0xFF667085),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusPill({
    required String label,
    required Color background,
    required double fontSize,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyles.boldExtraSmall.copyWith(
          color: AppColors.bodyBg,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class _TransactionItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String date;
  final String amount;
  final Color amountColor;
  final String status;
  final Color statusBg;

  const _TransactionItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.date,
    required this.amount,
    required this.amountColor,
    required this.status,
    required this.statusBg,
  });
}
