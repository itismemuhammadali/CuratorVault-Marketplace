import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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
  final TextEditingController _searchController = TextEditingController();

  late final List<_FaqSection> _sections = [
    _FaqSection(
      title: 'Getting Started',
      items: [
        _FaqItem(
          question: 'How do I scan an antique?',
          answer:
              'Tap the scan button in the center of the bottom navigation. Point your camera at the antique item and hold steady. Our AI will analyze the item and provide detailed information within seconds.',
        ),
        _FaqItem(
          question: 'How accurate is the AI recognition?',
          answer:
              'Our AI recognition is highly accurate for most antique items. The accuracy depends on image quality and lighting conditions. For best results, ensure good lighting and clear angles.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Marketplace',
      items: [
        _FaqItem(
          question: 'How do I buy items on the marketplace?',
          answer:
              'Browse the marketplace, find items you like, add them to your cart, and proceed to checkout. Follow the payment and shipping instructions.',
        ),
        _FaqItem(
          question: 'What payment methods do you accept?',
          answer:
              'We accept credit cards, debit cards, digital wallets, and other common payment methods. Choose your preferred option at checkout.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Collections',
      items: [
        _FaqItem(
          question: 'How do I organize my collection?',
          answer:
              'You can create collections and add scanned items to them. Use tags and categories to organize your items efficiently.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Account',
      items: [
        _FaqItem(
          question: 'How do I earn points and rewards?',
          answer:
              'Earn points by making purchases, writing reviews, and participating in our loyalty program. Redeem your points for discounts and exclusive offers.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Shipping',
      items: [
        _FaqItem(
          question: 'How long does shipping take?',
          answer:
              'Standard shipping typically takes 5-7 business days. Express shipping is available for expedited delivery. You\'ll receive tracking information via email.',
        ),
      ],
    ),
    _FaqSection(
      title: 'Returns',
      items: [
        _FaqItem(
          question: 'What is your return policy?',
          answer:
              'We offer 30-day returns on most items. Items must be in original condition. Contact support to initiate a return.',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onFilterChanged)
      ..dispose();
    super.dispose();
  }

  void _onFilterChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF8E8C7).withValues(alpha: 0.2),
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
          title: Text(
            'Help & FAQs',
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
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              _searchBar(),
              SizedBox(height: 20.h),
              // Contact Support Section
              Text(
                'Contact Support',
                style: TextStyles.boldMedium.copyWith(
                  color: AppColors.lightText,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _contactButton(
                      svgPath: 'assets/icons/admin_nav_messages.svg',
                      label: 'Chat',
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _contactButton(
                      icon: Icons.mail_outline_rounded,
                      label: 'Email',
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _contactButton(
                      icon: Icons.phone_outlined,
                      label: 'Call',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              // FAQ Sections
              ..._sections.map((section) => _faqSection(section)),
              SizedBox(height: 20.h),
              // Version
              Center(
                child: Column(
                  children: [
                    Text(
                      'Vintage Vibers',
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.lightText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Version 1.0.0',
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
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
      height: 44.h,
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyText.withValues(alpha: 0.2),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: AppColors.greyText,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyles.regularSmall.copyWith(
                color: AppColors.lightText,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Search for help...',
                hintStyle: TextStyles.regularSmall.copyWith(
                  color: AppColors.greyText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactButton({
    IconData? icon,
    String? svgPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.greyText.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF5E6D3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: svgPath != null
                    ? SvgPicture.asset(
                        svgPath,
                        width: 20.sp,
                        height: 20.sp,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF343434),
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(
                        icon,
                        color: const Color(0xFF343434),
                        size: 20.sp,
                      ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyles.mediumSmall.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _faqSection(_FaqSection section) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: TextStyles.boldMedium.copyWith(
              color: AppColors.lightText,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.h),
          ...section.items.map((item) => _faqItem(item)),
        ],
      ),
    );
  }

  Widget _faqItem(_FaqItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyText.withValues(alpha: 0.2),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: const BorderSide(color: Colors.transparent),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: const BorderSide(color: Colors.transparent),
          ),
          onExpansionChanged: (value) {
            setState(() {
              item.isExpanded = value;
            });
          },
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Text(
              item.question,
              style: TextStyles.mediumSmall.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ),
          trailing: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Icon(
              item.isExpanded
                  ? Icons.expand_less_rounded
                  : Icons.expand_more_rounded,
              color: AppColors.greyText,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Text(
                item.answer,
                style: TextStyles.regularSmall.copyWith(
                  color: AppColors.greyText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  _FaqItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;
  bool isExpanded = false;
}

class _FaqSection {
  _FaqSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<_FaqItem> items;
}
