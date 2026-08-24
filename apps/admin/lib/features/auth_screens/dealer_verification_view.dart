import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';
import 'package:vintage_app/features/auth_screens/layout.dart';

enum DealerAccountType { business, individual }

class DealerVerificationView extends StatefulWidget {
  const DealerVerificationView({super.key});

  @override
  State<DealerVerificationView> createState() => _DealerVerificationViewState();
}

class _DealerVerificationViewState extends State<DealerVerificationView> {
  DealerAccountType _selectedType = DealerAccountType.business;

  Widget _optionCard({
    required DealerAccountType type,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final selected = _selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedType = type);
        if (type == DealerAccountType.business) {
          context.push('/dealer/business-info');
        } else {
          context.push('/dealer/verification-progress');
        }
      },
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: selected ? AppColors.redButton : const Color(0xFFE3E6EC),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F7),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, color: AppColors.gradientColor1, size: 26.sp),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              style: TextStyles.mediumLarge.copyWith(
                color: AppColors.gradientColor1,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              subtitle,
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.greyText,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreensLayout(
      bottomText: '',
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Dealer Verification',
              textAlign: TextAlign.center,
              style: TextStyles.semiBoldLarge.copyWith(
                color: AppColors.gradientColor1,
                fontSize: 26.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Choose your account type to get started',
              textAlign: TextAlign.center,
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.greyText,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 24.h),
            _optionCard(
              type: DealerAccountType.business,
              icon: Icons.business_outlined,
              title: 'Business Account',
              subtitle: 'For registered antique dealers and shops',
            ),
            SizedBox(height: 16.h),
            _optionCard(
              type: DealerAccountType.individual,
              icon: Icons.person_outline_rounded,
              title: 'Individual Account',
              subtitle: 'For individual collectors and sellers',
            ),
          ],
        ),
      ),
    );
  }
}
