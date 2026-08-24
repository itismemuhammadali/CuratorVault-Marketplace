import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class HelpFaqView extends StatefulWidget {
  const HelpFaqView({super.key});

  @override
  State<HelpFaqView> createState() => _HelpFaqViewState();
}

class _HelpFaqViewState extends State<HelpFaqView> {
  late final List<_FaqSection> _sections = [
    _FaqSection(
      title: 'Getting Started',
      items: [
        _FaqItem(
          question: 'How do I scan an antique?',
          answer:
              'Tap the scan button in the center of the bottom navigation. Point your camera at the antique item and hold steady. Our AI will analyze the item and provide detailed information within seconds.',
          isExpanded: true,
        ),
        _FaqItem(
          question: 'How accurate is the AI recognition?',
          answer:
              'Our recognition is designed to give strong first-pass results for common antique categories. You can always review details, compare references, and save scans for later verification.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Marketplace',
      items: [
        _FaqItem(
          question: 'How do I buy items on the marketplace?',
          answer:
              'Open the product page, review the details, and continue through checkout. You can buy instantly or submit an offer when that option is available.',
        ),
        _FaqItem(
          question: 'What payment methods do you accept?',
          answer:
              'For now, the app supports saved cards and linked payment methods in your wallet flow. Additional payment options can be added from the payment methods screen.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Collections',
      items: [
        _FaqItem(
          question: 'How do I organize my collection?',
          answer:
              'Use My Finds to save, sort, and review items you have scanned or added manually. You can also group similar pieces and revisit product details anytime.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Account',
      items: [
        _FaqItem(
          question: 'How do I earn points and rewards?',
          answer:
              'You can earn points by scanning antiques, completing purchases, receiving positive reviews, and staying active in the app. Your progress appears in Membership & Rewards.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Shipping',
      items: [
        _FaqItem(
          question: 'How long does shipping take?',
          answer:
              'Shipping times vary by seller and carrier, but most marketplace orders arrive within a few business days after processing. Track Order shows the latest shipping status.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Returns',
      items: [
        _FaqItem(
          question: 'What is your return policy?',
          answer:
              'Return eligibility depends on the seller and item condition. Review the listing carefully and contact support or the seller if you need help with a return request.',
        ),
      ],
    ),
  ];

  void _toggleItem(_FaqItem item) {
    setState(() {
      item.isExpanded = !item.isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Help & FAQ',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 28.sp,
            ),
          ),
          bottomWidget: _searchBar(),
          height: 210.h,
        ),
      ),
      backgroundColor: AppColors.subPageBg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Support',
                style: TextStyles.boldMedium.copyWith(
                  color: AppColors.gradientColor1,
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: const [
                  Expanded(
                    child: _SupportCard(
                      icon: Icons.mail_outline_rounded,
                      label: 'Email',
                    ),
                  ),
                  Expanded(
                    child: _SupportCard(
                      icon: Icons.call_outlined,
                      label: 'Call',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              ..._sections.map(
                (section) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _section(section),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.bodyBg.withValues(alpha: 0.35),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: AppColors.bodyBg.withValues(alpha: 0.55),
            size: 22.sp,
          ),
          SizedBox(width: 10.w),
          Text(
            'Search for help...',
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.bodyBg.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(_FaqSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: TextStyles.boldMedium.copyWith(
            color: AppColors.redButton,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 10.h),
        ...section.items.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _accordionCard(item),
          ),
        ),
      ],
    );
  }

  Widget _accordionCard(_FaqItem item) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.shadowColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.05),
            blurRadius: 16.r,
            spreadRadius: -12,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _toggleItem(item),
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.question,
                      style: TextStyles.mediumMedium.copyWith(
                        color: AppColors.gradientColor1,
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                  Icon(
                    item.isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: item.isExpanded
                        ? AppColors.redButton
                        : const Color(0xFFA2ABBA),
                    size: 22.sp,
                  ),
                ],
              ),
              if (item.isExpanded) ...[
                SizedBox(height: 14.h),
                Container(
                  height: 1,
                  color: AppColors.shadowColor.withValues(alpha: 0.10),
                ),
                SizedBox(height: 14.h),
                Text(
                  item.answer,
                  style: TextStyles.regularMedium.copyWith(
                    color: const Color(0xFF667287),
                    height: 1.55,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.shadowColor.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF8EEE7),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFB66A2D),
              size: 24.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyles.regularMedium.copyWith(
              color: AppColors.gradientColor1,
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqSection {
  _FaqSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<_FaqItem> items;
}

class _FaqItem {
  _FaqItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  final String question;
  final String answer;
  bool isExpanded;
}
