import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class FlagCounterfeitSheet extends StatelessWidget {
  final String title;
  final String price;
  final String seller;

  const FlagCounterfeitSheet({
    super.key,
    required this.title,
    required this.price,
    required this.seller,
  });

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE9DE),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Center(
                  child: Image.asset(
                    AppImages.flagIcon,
                    width: 18.w,
                    height: 18.w,
                    color: const Color(0xFFF04A3A),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flag as Counterfeit',
                      style: TextStyles.boldMedium.copyWith(
                        color: const Color(0xFF1F2A44),
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Report suspicious or fake items',
                      style: TextStyles.regularSmall.copyWith(
                        color: const Color(0xFF6B7280),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              _SheetCloseButton(onTap: () => Navigator.pop(context)),
            ],
          ),
          SizedBox(height: 16.h),
          _ListingSummaryCard(title: title, price: price, seller: seller),
          SizedBox(height: 16.h),
          Text(
            'Reason for Flagging *',
            style: TextStyles.semiBoldSmall.copyWith(
              color: const Color(0xFF1F2A44),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 8.h),
          _FieldBox(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Select a reason',
                    style: TextStyles.regularSmall.copyWith(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF9CA3AF),
                  size: 20.sp,
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'Additional Notes (Optional)',
            style: TextStyles.semiBoldSmall.copyWith(
              color: const Color(0xFF1F2A44),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 8.h),
          _FieldBox(
            height: 94.h,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Provide any additional details...',
                style: TextStyles.regularSmall.copyWith(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFBFD7FF)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16.sp,
                  color: const Color(0xFF2563EB),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'This listing will be immediately hidden from the marketplace '
                    'and flagged for expert review. The seller will be notified '
                    'and asked to provide additional verification.',
                    style: TextStyles.regularExtraSmall.copyWith(
                      color: const Color(0xFF1D4ED8),
                      fontSize: 11.sp,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF04A3A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: Text(
                'Flag as Counterfeit',
                style: TextStyles.semiBoldSmall.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          _SheetCancelButton(onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

class RemoveListingSheet extends StatelessWidget {
  final String title;
  final String price;
  final String seller;

  const RemoveListingSheet({
    super.key,
    required this.title,
    required this.price,
    required this.seller,
  });

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE9DE),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Center(
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEEE),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF04A3A)),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 12.sp,
                      color: const Color(0xFFF04A3A),
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
                      'Remove Listing?',
                      style: TextStyles.boldMedium.copyWith(
                        color: const Color(0xFF1F2A44),
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'This action cannot be undone',
                      style: TextStyles.regularSmall.copyWith(
                        color: const Color(0xFF6B7280),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              _SheetCloseButton(onTap: () => Navigator.pop(context)),
            ],
          ),
          SizedBox(height: 16.h),
          _ListingSummaryCard(title: title, price: price, seller: seller),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7DB),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFFFE08A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16.sp,
                  color: const Color(0xFFB45309),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Warning: Removing this listing will permanently '
                    'delete it from the marketplace. The seller will be '
                    'notified via email.',
                    style: TextStyles.regularExtraSmall.copyWith(
                      color: const Color(0xFF92400E),
                      fontSize: 11.sp,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: Text(
                'Yes, Remove Listing',
                style: TextStyles.semiBoldSmall.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          _SheetCancelButton(onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

class _ListingSummaryCard extends StatelessWidget {
  final String title;
  final String price;
  final String seller;

  const _ListingSummaryCard({
    required this.title,
    required this.price,
    required this.seller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3EA),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFFFCBA9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.boldSmall.copyWith(
              color: const Color(0xFF7C2D12),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Price: $price',
            style: TextStyles.regularSmall.copyWith(
              color: const Color(0xFFB45309),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Seller: $seller',
            style: TextStyles.regularSmall.copyWith(
              color: const Color(0xFFB45309),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldBox extends StatelessWidget {
  final double? height;
  final Widget child;

  const _FieldBox({this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: child,
    );
  }
}

class _SheetFrame extends StatelessWidget {
  final Widget child;

  const _SheetFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.22),
              blurRadius: 22,
              spreadRadius: -8,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SheetCloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SheetCloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(
          Icons.close,
          size: 16.sp,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }
}

class _SheetCancelButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SheetCancelButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.cardBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: onTap,
        child: Text(
          'Cancel',
          style: TextStyles.semiBoldSmall.copyWith(
            color: const Color(0xFF1F2A44),
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}
