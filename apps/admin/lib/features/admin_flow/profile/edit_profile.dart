import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:image_picker/image_picker.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _profileImageBytes;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  Future<void> _pickProfileImage() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
      );

      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (!mounted) return;

      setState(() => _profileImageBytes = bytes);
    } catch (_) {
      // Image picking can be unavailable on some platforms.
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          height: 145.h,
          leading: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              width: 29.w,
              height: 29.w,
              decoration: BoxDecoration(
                color: AppColors.bodyBg.withValues(alpha: 0.22),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/icons/arrow_back_icon.svg',
                width: 18.sp,
                height: 18.sp,
                colorFilter: const ColorFilter.mode(
                  AppColors.darkText,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profile',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldSection.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Update your information',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.regularExtraSmall.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.82),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFAFAFB),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(17.w, 12.h, 17.w, 24.h),
          child: Column(
            children: [
              _photoCard(),
              SizedBox(height: 12.h),
              _informationCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomActions(context),
    );
  }

  Widget _photoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 17.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE4E6EA)),
      ),
      child: Row(
        children: [
          ClipOval(
            child: _profileImageBytes == null
                ? Image.asset(
                    AppImages.adminProfileImg,
                    width: 55.w,
                    height: 55.w,
                    fit: BoxFit.cover,
                  )
                : Image.memory(
                    _profileImageBytes!,
                    width: 55.w,
                    height: 55.w,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Picture',
                  style: TextStyles.boldSmall.copyWith(
                    color: const Color(0xFF344054),
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Update your profile photo',
                  style: TextStyles.regularSmall.copyWith(
                    color: const Color(0xFF667085),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: Container(
                    height: 22.h,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: AppColors.bodyBg,
                      borderRadius: BorderRadius.circular(3.r),
                      border: Border.all(color: const Color(0xFF4F79FF)),
                    ),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        'Change Photo',
                        style: TextStyles.mediumSmall.copyWith(
                          color: const Color(0xFF2563EB),
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _informationCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(13.w, 13.h, 13.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.bodyBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE4E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/admin_nav_users.svg',
                width: 16.sp,
                height: 16.sp,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF4F79FF),
                  BlendMode.srcIn,
                ),
              ),

              SizedBox(width: 8.w),
              Text(
                'Personal Information',
                style: TextStyles.boldMedium.copyWith(
                  color: const Color(0xFF344054),
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          _fieldBlockWithSvg(
            label: 'Full Name',
            svgPath: 'assets/icons/profile_icon.svg',
            controller: _fullNameController,
            hintText: 'Elan new',
          ),
          SizedBox(height: 13.h),
          _fieldBlockWithSvg(
            label: 'Email Address',
            svgPath: 'assets/icons/mail_icon.svg',
            controller: _emailController,
            hintText: 'admin@vintagevinnie.com',
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 13.h),
          _fieldBlockWithSvg(
            label: 'Phone Number',
            svgPath: 'assets/icons/phone_icon.svg',
            controller: _phoneController,
            hintText: '+1 (555) 000-0000',
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 13.h),
          _fieldBlockWithSvg(
            label: 'Location',
            svgPath: 'assets/icons/location_marker_icon.svg',
            controller: _locationController,
            hintText: 'New York, NY',
          ),
          SizedBox(height: 13.h),
          Text(
            'Bio',
            style: TextStyles.semiBoldSmall.copyWith(
              color: const Color(0xFF344054),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 8.h),
          _bioField(),
        ],
      ),
    );
  }

  Widget _fieldBlock({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18.sp, color: const Color(0xFF8B95A5)),
            SizedBox(width: 7.w),
            Text(
              label,
              style: TextStyles.semiBoldExtraSmall.copyWith(
                color: const Color(0xFF344054),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyles.regularSmall.copyWith(
            color: const Color(0xFF344054),
            fontSize: 13.sp,
          ),
          decoration: _fieldDecoration(hintText: hintText),
        ),
      ],
    );
  }

  Widget _fieldBlockWithSvg({
    required String label,
    required String svgPath,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              svgPath,
              width: 18.sp,
              height: 18.sp,
              colorFilter: const ColorFilter.mode(
                Color(0xFF8B95A5),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 7.w),
            Text(
              label,
              style: TextStyles.semiBoldSmall.copyWith(
                color: const Color(0xFF344054),
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyles.regularSmall.copyWith(
            color: const Color(0xFF344054),
            fontSize: 13.sp,
          ),
          decoration: _fieldDecoration(hintText: hintText),
        ),
      ],
    );
  }

  Widget _bioField() {
    return TextField(
      controller: _bioController,
      minLines: 5,
      maxLines: 5,
      style: TextStyles.regularSmall.copyWith(
        color: const Color(0xFF344054),
        fontSize: 13.sp,
      ),
      decoration: _fieldDecoration(
        hintText: 'Tell us about yourself',
        contentPadding: EdgeInsets.fromLTRB(10.w, 13.h, 10.w, 13.h),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hintText,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      hintStyle: TextStyles.regularSmall.copyWith(
        color: const Color(0xFF8E96A3),
        fontSize: 13.sp,
      ),
      filled: true,
      fillColor: const Color(0xFFF0F0F2),
      contentPadding:
          contentPadding ??
          EdgeInsets.symmetric(horizontal: 10.w, vertical: 13.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: Color(0xFF4F79FF), width: 1),
      ),
    );
  }

  Widget _bottomActions(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bodyBg,
        border: Border(top: BorderSide(color: Color(0xFFE9EAED))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
          child: Row(
            children: [
              Expanded(
                child: _actionButton(
                  label: 'Cancel',
                  textColor: const Color(0xFF222B37),
                  background: AppColors.bodyBg,
                  borderColor: const Color(0xFFE4E6EA),
                  onTap: () => context.pop(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _actionButton(
                  label: 'Save Changes',
                  textColor: AppColors.bodyBg,
                  background: AppColors.gradientColor2,
                  icon: Icons.save_outlined,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color textColor,
    required Color background,
    required VoidCallback onTap,
    Color borderColor = Colors.transparent,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13.sp, color: textColor),
              SizedBox(width: 8.w),
            ],
            Text(
              label,
              style: TextStyles.semiBoldExtraSmall.copyWith(
                color: textColor,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
