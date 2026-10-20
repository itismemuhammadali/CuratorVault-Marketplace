import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/transparent_header.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'listing_action_sheets.dart';

class ListingDetailView extends StatelessWidget {
  final ListingDetailData data;

  const ListingDetailView({super.key, required this.data});

  void _showFlagSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlagCounterfeitSheet(
        title: data.title,
        price: data.price,
        seller: data.seller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TransparentHeader(
      backgroundColor: AppColors.bodyBg,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(bottom: 110.h),
            children: [
              _HeroImage(image: data.image),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 22.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: TextStyles.boldMedium.copyWith(
                        color: const Color(0xFF1F2A44),
                        fontSize: 17.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        _Tag(
                          label: data.price,
                          bgColor: const Color(0xFF2D3E55),
                        ),
                        SizedBox(width: 8.w),
                        _Tag(
                          label: data.qualityLabel,
                          bgColor: const Color(0xFF00C853),
                        ),
                        SizedBox(width: 8.w),
                        _Tag(
                          label: data.statusLabel,
                          bgColor: const Color(0xFF00C853),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Description',
                      style: TextStyles.boldSmall.copyWith(
                        color: const Color(0xFF1F2A44),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      data.description,
                      style: TextStyles.regularSmall.copyWith(
                        color: const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      'Product Information',
                      style: TextStyles.boldSmall.copyWith(
                        color: const Color(0xFF1F2A44),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _InfoRow(
                      svgPath: 'assets/icons/category_icon.svg',
                      label: 'Category:',
                      value: data.category,
                    ),
                    SizedBox(height: 10.h),
                    _InfoRow(
                      svgPath: 'assets/icons/profile_icon.svg',
                      label: 'Seller:',
                      value: data.seller,
                    ),
                    SizedBox(height: 10.h),
                    _InfoRow(
                      svgPath: 'assets/icons/package_icon.svg',
                      label: 'Condition:',
                      value: data.condition,
                    ),
                    SizedBox(height: 16.h),
                    _ScoreCard(score: data.score),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomActions(
              onFlagTap: () => _showFlagSheet(context),
              onApproveTap: () => context.go('/dealer/market'),
            ),
          ),
        ],
      ),
    );
  }
}

class ListingDetailData {
  final String title;
  final String image;
  final String price;
  final String qualityLabel;
  final String statusLabel;
  final String description;
  final String category;
  final String seller;
  final String condition;
  final int score;

  const ListingDetailData({
    required this.title,
    required this.image,
    required this.price,
    required this.qualityLabel,
    required this.statusLabel,
    required this.description,
    required this.category,
    required this.seller,
    required this.condition,
    required this.score,
  });
}

class _HeroImage extends StatelessWidget {
  final String image;

  const _HeroImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 298.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(image, fit: BoxFit.cover),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color bgColor;

  const _Tag({required this.label, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyles.boldExtraSmall.copyWith(
          color: AppColors.bodyBg,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String? svgPath;
  final String label;
  final String value;

  const _InfoRow({
    this.svgPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (svgPath != null) ...[
          SvgPicture.asset(
            svgPath!,
            width: 16.sp,
            height: 16.sp,
            colorFilter: const ColorFilter.mode(
              Color(0xFF6B7280),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 8.w),
        ],
        Text(
          label,
          style: TextStyles.regularSmall.copyWith(
            color: const Color(0xFF6B7280),
            fontSize: 12.sp,
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            value,
            style: TextStyles.semiBoldSmall.copyWith(
              color: const Color(0xFF1F2A44),
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final int score;

  const _ScoreCard({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F2FF),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/growth_icon.svg',
                width: 16.sp,
                height: 16.sp,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1F2A44),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'AI Authenticity Score',
                style: TextStyles.semiBoldSmall.copyWith(
                  color: const Color(0xFF1F2A44),
                  fontSize: 12.sp,
                ),
              ),
              const Spacer(),
              Text(
                '$score%',
                style: TextStyles.boldSmall.copyWith(
                  color: const Color(0xFF1F2A44),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _ScoreBar(score: score),
          SizedBox(height: 8.h),
          Text(
            'High confidence - Likely authentic',
            style: TextStyles.regularExtraSmall.copyWith(
              color: const Color(0xFF6B7280),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final int score;

  const _ScoreBar({required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          FractionallySizedBox(
            widthFactor: score / 100,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF00C853),
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final VoidCallback onFlagTap;
  final VoidCallback onApproveTap;

  const _BottomActions({required this.onFlagTap, required this.onApproveTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0CA541),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  elevation: 0,
                ),
                onPressed: onApproveTap,
                child: Text(
                  'Approved',
                  style: TextStyles.semiBoldSmall.copyWith(
                    color: AppColors.bodyBg,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFF04A3A)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onPressed: onFlagTap,
                icon: Icon(
                  Icons.warning_amber_rounded,
                  color: const Color(0xFFF04A3A),
                  size: 16.sp,
                ),
                label: Text(
                  'Flag Counterfeit',
                  style: TextStyles.semiBoldSmall.copyWith(
                    color: const Color(0xFFF04A3A),
                    fontSize: 12.sp,
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
