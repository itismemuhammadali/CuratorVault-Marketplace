import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AddNewItemView extends StatefulWidget {
  const AddNewItemView({super.key});

  @override
  State<AddNewItemView> createState() => _AddNewItemViewState();
}

class _AddNewItemViewState extends State<AddNewItemView> {
  final ImagePicker _picker = ImagePicker();

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/homeScreen');
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (!mounted || image == null) return;
      if (mounted) {
        // ignore: use_build_context_synchronously
        context.push('/dealer/scan/result', extra: image.path);
      }
    } catch (e) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    if (mounted) {
      // ignore: use_build_context_synchronously
      context.push('/dealer/scan/camera');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: IconBox(
            icon: AppImages.backIcon,
            bgColor: AppColors.darkText.withValues(alpha: 0.20),
            onTap: () => _goBack(context),
            iconColor: AppColors.darkText,
            height: 40.h,
            width: 40.w,
            borderRadius: 100.r,
          ),
          title: Text(
            'Add New Item',
            style: TextStyles.boldLarge.copyWith(color: AppColors.bodyBg),
          ),
          height: 170.h,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
          child: Column(
            children: [
              _ScanOptionCard(
                icon: Icons.photo_camera_outlined,
                title: 'Scan via Camera',
                subtitle: 'Take photos of your antique item',
                onTap: () => _pickFromCamera(context),
              ),
              SizedBox(height: 18.h),
              _ScanOptionCard(
                icon: Icons.image_outlined,
                title: 'Upload from Gallery',
                subtitle: 'Choose existing photos',
                onTap: () => _pickFromGallery(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ScanOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 28.h),
        decoration: BoxDecoration(
          color: AppColors.authBackBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFD2D7DE), width: 1),
        ),
        child: Column(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: AppColors.redButton.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: AppColors.redButton, size: 28.sp),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              style: TextStyles.semiBoldLarge.copyWith(
                color: const Color(0xFF202124),
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyles.regularMedium.copyWith(
                color: const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
