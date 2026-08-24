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

class UploadFromGalleryView extends StatefulWidget {
  const UploadFromGalleryView({super.key});

  @override
  State<UploadFromGalleryView> createState() => _UploadFromGalleryViewState();
}

class _UploadFromGalleryViewState extends State<UploadFromGalleryView> {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  Future<void> _pickImage() async {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
    });

    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (!mounted || image == null) return;
      context.push('/dealer/scan/result', extra: image.path);
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: IconBox(
            icon: AppImages.backIcon,
            bgColor: AppColors.darkText.withValues(alpha: 0.20),
            onTap: () => context.pop(),
            iconColor: AppColors.darkText,
            height: 40.h,
            width: 40.w,
            borderRadius: 100.r,
          ),
          title: Text(
            'Upload from Gallery',
            style: TextStyles.boldLarge.copyWith(color: AppColors.bodyBg),
          ),
          height: 170.h,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBF8),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.redButton.withValues(alpha: 0.50),
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          color: AppColors.redButton.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Icon(
                          Icons.file_upload_outlined,
                          color: AppColors.redButton,
                          size: 30.sp,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        _isPicking ? 'Opening Gallery...' : 'Upload an Image',
                        style: TextStyles.semiBoldLarge.copyWith(
                          color: AppColors.gradientColor1,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Tap to select a photo from your gallery',
                        textAlign: TextAlign.center,
                        style: TextStyles.regularMedium.copyWith(
                          color: AppColors.lightText,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            color: AppColors.redButton,
                            size: 15.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'JPG, PNG, or WEBP (max 10MB)',
                            style: TextStyles.regularSmall.copyWith(
                              color: AppColors.redButton,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 22.h),
              Text(
                'Tips for Best Results:',
                style: TextStyles.boldMedium.copyWith(
                  color: AppColors.gradientColor1,
                ),
              ),
              SizedBox(height: 14.h),
              const _TipRow(index: '1', text: 'Use good lighting and a plain background'),
              const _TipRow(index: '2', text: 'Capture the entire item in the frame'),
              const _TipRow(index: '3', text: "Include close-ups of maker's marks or signatures"),
              const _TipRow(index: '4', text: 'Show any damage or unique features clearly'),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final String index;
  final String text;

  const _TipRow({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18.w,
            height: 18.w,
            decoration: const BoxDecoration(
              color: AppColors.darkText,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                index,
                style: TextStyles.regularExtraSmall.copyWith(
                  color: AppColors.redButton,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.regularMedium.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
