import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/global_header/global_header.dart';
import '../../../core/components/global_header/header_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/images.dart';
import '../../../core/theme/text_styles.dart';

class MakeOfferView extends StatefulWidget {
  const MakeOfferView({super.key, required this.productId});

  final String productId;

  @override
  State<MakeOfferView> createState() => _MakeOfferViewState();
}

class _MakeOfferViewState extends State<MakeOfferView> {
  static const double _askingPrice = 1450.00;

  late final TextEditingController _offerAmountController;
  late final TextEditingController _messageController;

  final List<_QuickOfferOption> _quickOptions = const [
    _QuickOfferOption(label: '10% off', amount: 1305.00),
    _QuickOfferOption(label: '15% off', amount: 1233.00),
    _QuickOfferOption(label: '20% off', amount: 1160.00),
  ];

  final List<String> _durations = const ['12h', '24h', '48h', '7 days'];

  int? _selectedQuickOption;
  int _selectedDuration = 1;

  @override
  void initState() {
    super.initState();
    _offerAmountController = TextEditingController(text: _formatCurrency(0));
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _offerAmountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  void _applyQuickAmount(int index) {
    setState(() {
      _selectedQuickOption = index;
      _offerAmountController.text =
          _formatCurrency(_quickOptions[index].amount);
    });
  }

  void _submitOffer() {
    context.go('/user/offers?tab=send&submitted=1');
  }

  HeaderConfig _headerConfig() {
    return HeaderConfig(
      title: Text(
        'Make an Offer',
        style: TextStyles.boldLarge.copyWith(color: AppColors.bodyBg),
      ),
      bottomWidget: _ProductSummaryCard(
        askingPriceText: _formatCurrency(_askingPrice),
      ),
      height: 290.h,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.subPageBg,
      appBar: SimpleHeader(config: _headerConfig()),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Offer Amount',
                            style: TextStyles.mediumLarge.copyWith(
                              color: AppColors.gradientColor1,
                              fontSize: 17.sp,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                              color: AppColors.bodyBg,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.redButton.withValues(
                                  alpha: 0.35,
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: _offerAmountController,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              style: TextStyles.mediumLarge.copyWith(
                                color: AppColors.gradientColor1,
                                fontSize: 22.sp,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 14.h,
                                ),
                              ),
                              onChanged: (_) {
                                if (_selectedQuickOption != null) {
                                  setState(() {
                                    _selectedQuickOption = null;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Quick Select:',
                            style: TextStyles.regularMedium.copyWith(
                              color: AppColors.gradientColor1,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: List.generate(_quickOptions.length, (index) {
                              final option = _quickOptions[index];
                              final selected = _selectedQuickOption == index;
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: index == _quickOptions.length - 1
                                        ? 0
                                        : 10.w,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _applyQuickAmount(index),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? AppColors.grey
                                            : AppColors.bodyBg,
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(
                                          color: AppColors.redButton.withValues(
                                            alpha: selected ? 0.7 : 0.35,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            option.label,
                                            style: TextStyles.regularSmall.copyWith(
                                              color: AppColors.gradientColor1,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            _formatCurrency(option.amount),
                                            style: TextStyles.mediumMedium.copyWith(
                                              color: AppColors.gradientColor1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 20.sp,
                                color: AppColors.redButton,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Message to Seller',
                                style: TextStyles.mediumLarge.copyWith(
                                  color: AppColors.gradientColor1,
                                  fontSize: 17.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.bodyBg,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.redButton.withValues(
                                  alpha: 0.35,
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: _messageController,
                              maxLines: 5,
                              style: TextStyles.regularMedium.copyWith(
                                color: AppColors.lightText,
                                height: 1.45,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Explain why you\'re making this offer (e.g., "I\'m a serious collector and would love to add this to my collection...")',
                                hintStyle: TextStyles.regularMedium.copyWith(
                                  color: AppColors.greyText,
                                  height: 1.45,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.fromLTRB(
                                  14.w,
                                  14.h,
                                  14.w,
                                  14.h,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'A thoughtful message increases your chances of acceptance',
                            style: TextStyles.regularSmall.copyWith(
                              color: AppColors.greyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 20.sp,
                                color: AppColors.redButton,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Offer Valid For',
                                style: TextStyles.mediumLarge.copyWith(
                                  color: AppColors.gradientColor1,
                                  fontSize: 17.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: List.generate(_durations.length, (index) {
                              final selected = _selectedDuration == index;
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: index == _durations.length - 1
                                        ? 0
                                        : 10.w,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedDuration = index;
                                      });
                                    },
                                    child: Container(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? const Color(0xFFD8A976)
                                            : AppColors.bodyBg,
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(
                                          color: AppColors.redButton.withValues(
                                            alpha: 0.35,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _durations[index],
                                          style: TextStyles.mediumMedium.copyWith(
                                            color: AppColors.gradientColor1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How It Works',
                            style: TextStyles.mediumLarge.copyWith(
                              color: AppColors.gradientColor1,
                              fontSize: 17.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ...const [
                            'Your offer will be sent to the seller for review',
                            'Seller can accept, decline, or make a counter-offer',
                            'You\'ll be notified of any updates',
                            'Offer automatically expires after selected time',
                          ].map(
                            (text) => Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: _HowItWorksRow(text: text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 18.h),
              decoration: BoxDecoration(
                color: AppColors.bodyBg,
                border: Border(
                  top: BorderSide(
                    color: AppColors.lightText.withValues(alpha: 0.08),
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: _submitOffer,
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: AppColors.gradientColor1,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.attach_money_rounded,
                        color: AppColors.bodyBg,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Submit Offer',
                        style: TextStyles.semiBoldLarge.copyWith(
                          color: AppColors.bodyBg,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.12),
            blurRadius: 20,
            spreadRadius: -12,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ProductSummaryCard extends StatelessWidget {
  const _ProductSummaryCard({
    required this.askingPriceText,
  });

  final String askingPriceText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.12),
            blurRadius: 20,
            spreadRadius: -12,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              AppImages.productOne,
              width: 72.w,
              height: 72.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Victorian Pocket Watch',
                  style: TextStyles.semiBoldLarge.copyWith(
                    color: AppColors.gradientColor1,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Heritage Antiques',
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.greyText,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      askingPriceText,
                      style: TextStyles.semiBoldLarge.copyWith(
                        color: AppColors.redButton,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999.r),
                        border: Border.all(
                          color: AppColors.redButton.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Text(
                        'Asking Price',
                        style: TextStyles.regularExtraSmall.copyWith(
                          color: AppColors.redButton,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksRow extends StatelessWidget {
  const _HowItWorksRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 7.h, right: 10.w),
          child: Container(
            width: 5.w,
            height: 5.w,
            decoration: const BoxDecoration(
              color: AppColors.redButton,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.greyText,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickOfferOption {
  const _QuickOfferOption({
    required this.label,
    required this.amount,
  });

  final String label;
  final double amount;
}
