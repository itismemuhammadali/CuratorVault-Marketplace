import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class MyWalletView extends StatelessWidget {
  const MyWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Wallet',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 28.sp,
            ),
          ),
          height: 170.h,
        ),
      ),
      backgroundColor: AppColors.subPageBg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 110.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _availableBalanceCard(context),
              SizedBox(height: 14.h),
              _escrowPaymentCard(context),
              SizedBox(height: 14.h),
              _escrowProtectionCard(),
              SizedBox(height: 14.h),
              _walletOptionsCard(context),
              SizedBox(height: 14.h),
              _secureProtectedCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.subPageBg,
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () => context.go('/homeScreen'),
            child: Container(
              height: 54.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.gradientColor1, AppColors.gradientColor2],
                ),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: Text(
                  'Back to Home',
                  style: TextStyles.mediumMedium.copyWith(
                    color: AppColors.bodyBg,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _availableBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientColor1, AppColors.gradientColor2],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money, size: 22.sp, color: AppColors.bodyBg),
              SizedBox(width: 8.w),
              Text(
                'Available Balance',
                style: TextStyles.mediumMedium.copyWith(
                  color: AppColors.bodyBg,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '\$6,450.00',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 40.sp,
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => context.push('/dealer/wallet/withdraw'),
            child: Container(
              width: double.infinity,
              height: 52.h,
              decoration: BoxDecoration(
                color: AppColors.bodyBg,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/send_icon.svg',
                    width: 17.sp,
                    height: 17.sp,
                    colorFilter: const ColorFilter.mode(
                      AppColors.lightText,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Withdraw Funds',
                    style: TextStyles.mediumMedium.copyWith(
                      color: AppColors.lightText,
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

  Widget _escrowPaymentCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/dealer/wallet/escrow-payments'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB56400), Color(0xFFD25A44)],
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: AppColors.bodyBg.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.schedule,
                    size: 18.sp,
                    color: AppColors.bodyBg,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: AppColors.bodyBg.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    size: 18.sp,
                    color: AppColors.bodyBg,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              'Escrow Payment',
              style: TextStyles.mediumMedium.copyWith(color: AppColors.bodyBg),
            ),
            SizedBox(height: 6.h),
            Text(
              '\$3,450.00',
              style: TextStyles.boldLarge.copyWith(
                color: AppColors.bodyBg,
                fontSize: 30.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _escrowProtectionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFD9F5E4),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFA8E5C1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF07BA54),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_outlined,
                  size: 22.sp,
                  color: AppColors.bodyBg,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Escrow Protection',
                style: TextStyles.boldMedium.copyWith(
                  color: const Color(0xFF0E6B3D),
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Payment is securely held in escrow. Funds will be\nreleased to you once the buyer confirms delivery.',
            style: TextStyles.regularMedium.copyWith(
              color: const Color(0xFF0E6B3D),
              height: 1.35,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
            decoration: BoxDecoration(
              color: AppColors.bodyBg.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              children: [
                _priceRow('Item Price', '\$850'),
                SizedBox(height: 8.h),
                _priceRow('Platform Fee (5%)', '-\$42.50'),
                SizedBox(height: 10.h),
                Container(height: 1, color: const Color(0xFF9EC8B2)),
                SizedBox(height: 10.h),
                _priceRow('Your Payout', '\$807.50', highlight: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool highlight = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyles.mediumMedium.copyWith(
            color: AppColors.lightText,
            fontSize: 15.sp,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyles.semiBoldMedium.copyWith(
            color: highlight ? const Color(0xFF07A547) : AppColors.lightText,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }

  Widget _walletOptionsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE4E8EF)),
      ),
      child: Column(
        children: [
          _walletOptionRow(
            context: context,
            iconBg: const Color(0xFFE846C3),
            icon: Icons.credit_card_outlined,
            title: 'Payment Methods',
            subtitle: 'Manage cards & bank accounts',
            onTap: () => context.push('/dealer/wallet/payment-method'),
          ),
          Container(height: 1, color: const Color(0xFFE8ECF3)),
          _walletOptionRow(
            context: context,
            iconBg: const Color(0xFF24A6F2),
            icon: Icons.receipt_long_outlined,
            title: 'Transaction History',
            subtitle: 'View all transactions',
            onTap: () => context.push('/dealer/wallet/transaction-history'),
          ),
        ],
      ),
    );
  }

  Widget _walletOptionRow({
    required BuildContext context,
    required Color iconBg,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
        child: Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, size: 22.sp, color: AppColors.bodyBg),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.boldMedium.copyWith(
                      color: AppColors.lightText,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 22.sp,
              color: const Color(0xFF97A3B4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secureProtectedCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F0FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFBCD0FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: const BoxDecoration(
              color: Color(0xFF2E73F2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_outlined,
              size: 21.sp,
              color: AppColors.bodyBg,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure & Protected',
                  style: TextStyles.boldMedium.copyWith(
                    color: const Color(0xFF2149B2),
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'All transactions are encrypted and\nprotected. Funds in escrow are\nreleased after buyer confirmation.',
                  style: TextStyles.regularMedium.copyWith(
                    color: const Color(0xFF2149B2),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
