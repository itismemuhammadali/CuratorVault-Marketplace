import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/components/icons/icon_box_transparent.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class HelpFaqView extends StatefulWidget {
  const HelpFaqView({super.key});

  @override
  State<HelpFaqView> createState() => _HelpFaqViewState();
}

class _HelpFaqViewState extends State<HelpFaqView> {
  final TextEditingController _searchController = TextEditingController();

  static const String _allCategory = 'All';
  static const List<String> _categories = [
    _allCategory,
    'Getting Started',
    'Orders & Shipping',
    'Payments',
    'Account & Security',
    'Inventory',
  ];

  late final List<_FaqItem> _faqItems = [
    _FaqItem(
      category: 'Getting Started',
      question: 'How do I list my first item?',
      answer:
          'To list your first item, tap the "+" button on the home screen, fill in the item details including title, description, price, and upload photos. Once you\'re done, tap "Publish" to make your item live.',
      isExpanded: true,
    ),
    _FaqItem(
      category: 'Getting Started',
      question: 'What documents do I need for verification?',
      answer:
          'You need a valid government-issued ID and your business information. Make sure uploaded images are clear and all details are readable for faster approval.',
    ),
    _FaqItem(
      category: 'Orders & Shipping',
      question: 'How do I ship an order?',
      answer:
          'Open Orders, select the order, tap Accept, and follow the shipping prompts. Add tracking details so buyers can monitor delivery progress.',
    ),
    _FaqItem(
      category: 'Orders & Shipping',
      question: 'What happens if a buyer requests a return?',
      answer:
          'You can review return requests from order details. If approved, coordinate return shipping and complete the refund process from the order flow.',
    ),
    _FaqItem(
      category: 'Payments',
      question: 'When do I receive my payment?',
      answer:
          'Payments are released after order completion based on your selected payout settings. Processing time can vary by payment method and bank.',
    ),
    _FaqItem(
      category: 'Payments',
      question: 'What are the seller fees?',
      answer:
          'Seller fees depend on the plan and transaction type. You can review the latest fee breakdown in wallet and policy pages.',
    ),
    _FaqItem(
      category: 'Account & Security',
      question: 'How do I enable two-factor authentication?',
      answer:
          'Go to Settings, open Two-Factor Authentication, and complete setup using an authenticator app to protect your account.',
    ),
    _FaqItem(
      category: 'Account & Security',
      question: 'How do I change my password?',
      answer:
          'Go to Settings > Change Password. Enter your current password, create a new one that meets all rules, and confirm it.',
    ),
    _FaqItem(
      category: 'Inventory',
      question: 'Can I edit a listing after publishing?',
      answer:
          'Yes. Open My Finds, choose the item, and use Edit to update details, pricing, or photos.',
    ),
    _FaqItem(
      category: 'Inventory',
      question: 'How do I mark an item as sold?',
      answer:
          'Open the item in My Finds and update its status to sold. This keeps your catalog accurate for buyers.',
    ),
  ];

  String _selectedCategory = _allCategory;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onFiltersChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onFiltersChanged)
      ..dispose();
    super.dispose();
  }

  void _onFiltersChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleItem(_FaqItem item) {
    setState(() {
      item.isExpanded = !item.isExpanded;
    });
  }

  List<_FaqItem> _filteredFaqs() {
    final query = _searchController.text.trim().toLowerCase();
    return _faqItems.where((item) {
      final categoryMatches =
          _selectedCategory == _allCategory ||
          item.category == _selectedCategory;
      final queryMatches =
          query.isEmpty ||
          item.question.toLowerCase().contains(query) ||
          item.answer.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
      return categoryMatches && queryMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Help Center',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 28.sp,
            ),
          ),
          bottomWidget: _searchBar(),
          height: 220.h,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _liveChatCard(),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: _SupportCard(
                      iconAsset: AppImages.iconMail,
                      title: 'Email',
                      subtitle: '24h response',
                    ),
                  ),
                  Expanded(
                    child: _SupportCard(
                      iconAsset: AppImages.iconPhoneCall,
                      title: 'Phone',
                      subtitle: 'Mon-Fri 9-5',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                'Categories',
                style: TextStyles.boldMedium.copyWith(
                  color: const Color(0xFF111827),
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(height: 10.h),
              _categoryChips(),
              SizedBox(height: 12.h),
              Row(
                children: [
                  IconBoxTransparent(
                    icon: AppImages.helpQuestionIcon,
                    color: AppColors.lightText,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Frequently Asked Questions',
                    style: TextStyles.boldMedium.copyWith(
                      color: const Color(0xFF111827),
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              _faqListCard(),
              SizedBox(height: 14.h),
              _ticketCard(),
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
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.bodyBg.withValues(alpha: 0.35)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          IconBox(
            icon: AppImages.magnifineGlassIcon,
            width: 32.sp,
            height: 32.sp,
            bgColor: Colors.transparent,
            iconColor: AppColors.bodyBg.withValues(alpha: 0.75),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyles.regularMedium.copyWith(color: AppColors.bodyBg),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Search for help...',
                hintStyle: TextStyles.regularMedium.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _liveChatCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: IconBox(
              icon: AppImages.chatBubbleIcon,
              width: 50.w,
              height: 50.w,
              bgColor: Colors.transparent,
              iconColor: Colors.white,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Chat',
                  style: TextStyles.boldMedium.copyWith(
                    color: Colors.white,
                    fontSize: 27.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Get instant help from our team',
                  style: TextStyles.regularSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
          IconBox(
            icon: AppImages.chevronIcon,
            width: 18.sp,
            height: 18.sp,
            bgColor: Colors.transparent,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _categoryChips() {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return InkWell(
            onTap: () => setState(() => _selectedCategory = category),
            borderRadius: BorderRadius.circular(999.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1F3048) : AppColors.bodyBg,
                borderRadius: BorderRadius.circular(999.r),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1F3048)
                      : const Color(0xFFD5DAE3),
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyles.mediumMedium.copyWith(
                    color: isSelected ? Colors.white : const Color(0xFF475467),
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _faqListCard() {
    final items = _filteredFaqs();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFDDE3EB)),
      ),
      child: items.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  'No FAQs found.',
                  style: TextStyles.regularMedium.copyWith(
                    color: AppColors.greyText,
                  ),
                ),
              ),
            )
          : Column(
              children: List.generate(items.length, (index) {
                final item = items[index];
                return _accordionRow(
                  item: item,
                  isLast: index == items.length - 1,
                );
              }),
            ),
    );
  }

  Widget _accordionRow({required _FaqItem item, required bool isLast}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleItem(item),
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCE9FF),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        item.category,
                        style: TextStyles.mediumMedium.copyWith(
                          color: const Color(0xFF2563EB),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 48.w,
                      height: 48.h,
                      child: Transform.rotate(
                        angle: item.isExpanded ? -math.pi / 2 : math.pi / 2,
                        child: IconBox(
                          icon: AppImages.chevronIcon,
                          width: 28.sp,
                          height: 28.sp,
                          bgColor: Colors.transparent,
                          iconColor: const Color(0xFF98A2B3),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  item.question,
                  style: TextStyles.mediumMedium.copyWith(
                    color: const Color(0xFF111827),
                    fontSize: 17.sp,
                  ),
                ),
                if (item.isExpanded) ...[
                  SizedBox(height: 12.h),
                  Text(
                    item.answer,
                    style: TextStyles.regularMedium.copyWith(
                      color: const Color(0xFF667085),
                      height: 1.5,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ticketCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFAD46FF), Color(0xFF9810FA)],
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Still need help?',
            style: TextStyles.boldMedium.copyWith(
              color: Colors.white,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Our support team is available 24/7 to assist you with any questions or concerns.',
            style: TextStyles.regularMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.45,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.bodyBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Text(
                'Submit a Support Ticket',
                style: TextStyles.boldSmall.copyWith(
                  color: const Color(0xFF7E22CE),
                  fontSize: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({
    required this.iconAsset,
    required this.title,
    required this.subtitle,
  });

  final String iconAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD8DEE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBoxTransparent(
            icon: iconAsset,
            color: AppColors.lightText,
            size: 30.h,
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyles.boldMedium.copyWith(
              color: const Color(0xFF1F2937),
              fontSize: 17.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyles.regularSmall.copyWith(
              color: const Color(0xFF667085),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem {
  _FaqItem({
    required this.category,
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  final String category;
  final String question;
  final String answer;
  bool isExpanded;
}
