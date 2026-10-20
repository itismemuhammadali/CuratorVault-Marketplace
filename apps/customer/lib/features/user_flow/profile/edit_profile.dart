import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/includes/app_text_field.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';
import 'package:vintage_app/core/services/api_service.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

import '../../../core/components/global_header/header_config.dart';
import '../../../core/theme/images.dart';

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
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
      _fullNameController.text = user.displayName ?? '';
    }

    try {
      final res = await ApiService.get('/api/v1/profile/me');
      if (res is Map && mounted) {
        final data = Map<String, dynamic>.from(res);
        _fullNameController.text =
            (data['name'] ?? data['firstName'] ?? _fullNameController.text)
                .toString();
        _emailController.text =
            (data['email'] ?? _emailController.text).toString();
        _phoneController.text = (data['phone'] ?? '').toString();
        _locationController.text = (data['location'] ?? '').toString();
        _websiteController.text = (data['website'] ?? '').toString();
        _bioController.text = (data['bio'] ?? '').toString();
      }
    } catch (e) {
      debugPrint('Error loading profile from backend in EditProfile: $e');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

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

      setState(() {
        _profileImageBytes = bytes;
      });
    } catch (_) {
      // No-op: image picking may be unavailable on some platforms.
    }
  }

  Future<void> _saveProfile() async {
    final name = _fullNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: AppColors.redButton,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
      }

      final payload = {
        'name': name,
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'location': _locationController.text.trim(),
        'website': _websiteController.text.trim(),
        'bio': _bioController.text.trim(),
      };

      await ApiService.put('/api/v1/profile/me', payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: AppColors.redButton,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageBg = AppColors.subPageBg;
    final cardRadius = 16.r;
    final valueHintStyle = TextStyles.regularSmall.copyWith(
      color: AppColors.lightText,
    );

    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          leading: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 18.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          title: Text(
            'Edit Profile',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 28.sp,
              height: 1.05,
            ),
          ),
          height: 170.h,
        ),
      ),
      backgroundColor: pageBg,
      body: _isLoading
          ? Center(
              child: JumpingDotsProgress(
                text: 'Loading Profile',
                textStyle: TextStyles.semiBoldMedium.copyWith(
                  color: AppColors.lightText,
                ),
                dotColor: AppColors.gradientColor1,
              ),
            )
          : SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 8.h),
                          GestureDetector(
                            onTap: _pickProfileImage,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 110.w,
                                  height: 110.w,
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.redButton,
                                      width: 3.w,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: _profileImageBytes == null
                                        ? Image.asset(
                                            AppImages.userImg,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.memory(
                                            _profileImageBytes!,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  right: -2.w,
                                  bottom: -2.w,
                                  child: Container(
                                    height: 34.w,
                                    width: 34.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.redButton,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: pageBg, width: 3.w),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        AppImages.camImg,
                                        height: 18.h,
                                        width: 18.w,
                                        color: AppColors.bodyBg,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            'Tap to change profile photo',
                            style: TextStyles.regularSmall.copyWith(
                              color: AppColors.greyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bodyBg,
                        borderRadius: BorderRadius.circular(cardRadius),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.shadowColor.withValues(alpha: 0.10),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            controller: _fullNameController,
                            labelText: 'Full Name',
                            hintText: 'Your Name',
                            hintStyle: valueHintStyle,
                            labelStyle: TextStyles.regularExtraSmall.copyWith(
                              color: AppColors.lightText,
                            ),
                            fillColor: AppColors.bodyBg,
                            borderColor: AppColors.authBackBg,
                            focusedBorderColor: AppColors.gradientColor1,
                            borderRadius: 10.r,
                          ),
                          SizedBox(height: 14.h),
                          AppTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            hintText: 'your.email@domain.com',
                            hintStyle: valueHintStyle,
                            keyboardType: TextInputType.emailAddress,
                            labelStyle: TextStyles.regularExtraSmall.copyWith(
                              color: AppColors.lightText,
                            ),
                            fillColor: AppColors.bodyBg,
                            borderColor: AppColors.authBackBg,
                            focusedBorderColor: AppColors.gradientColor1,
                            borderRadius: 10.r,
                          ),
                          SizedBox(height: 14.h),
                          AppTextField(
                            controller: _phoneController,
                            labelText: 'Phone Number',
                            hintText: '+1 234 567 8900',
                            hintStyle: valueHintStyle,
                            keyboardType: TextInputType.phone,
                            labelStyle: TextStyles.regularExtraSmall.copyWith(
                              color: AppColors.lightText,
                            ),
                            fillColor: AppColors.bodyBg,
                            borderColor: AppColors.authBackBg,
                            focusedBorderColor: AppColors.gradientColor1,
                            borderRadius: 10.r,
                          ),
                          SizedBox(height: 14.h),
                          AppTextField(
                            controller: _locationController,
                            labelText: 'Location',
                            hintText: 'New York, NY',
                            hintStyle: valueHintStyle,
                            labelStyle: TextStyles.regularExtraSmall.copyWith(
                              color: AppColors.lightText,
                            ),
                            fillColor: AppColors.bodyBg,
                            borderColor: AppColors.authBackBg,
                            focusedBorderColor: AppColors.gradientColor1,
                            borderRadius: 10.r,
                          ),
                          SizedBox(height: 14.h),
                          AppTextField(
                            controller: _websiteController,
                            labelText: 'Website',
                            hintText: 'www.yourwebsite.com',
                            hintStyle: valueHintStyle,
                            keyboardType: TextInputType.url,
                            labelStyle: TextStyles.regularExtraSmall.copyWith(
                              color: AppColors.lightText,
                            ),
                            fillColor: AppColors.bodyBg,
                            borderColor: AppColors.authBackBg,
                            focusedBorderColor: AppColors.gradientColor1,
                            borderRadius: 10.r,
                          ),
                          SizedBox(height: 14.h),
                          AppTextField(
                            controller: _bioController,
                            labelText: 'Bio',
                            hintText:
                                'Tell us about yourself and your collection...',
                            maxLines: 4,
                            labelStyle: TextStyles.regularExtraSmall.copyWith(
                              color: AppColors.lightText,
                            ),
                            fillColor: AppColors.bodyBg,
                            borderColor: AppColors.authBackBg,
                            focusedBorderColor: AppColors.gradientColor1,
                            borderRadius: 10.r,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 14.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    CustomButton(
                      height: 54.h,
                      borderRadius: 14.r,
                      btnColor: AppColors.redButton,
                      onTap: _isSaving ? () {} : _saveProfile,
                      child: _isSaving
                          ? JumpingDotsProgress(
                              text: 'Saving',
                              textStyle: TextStyles.semiBoldMedium.copyWith(
                                color: AppColors.bodyBg,
                              ),
                              dotColor: AppColors.bodyBg,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.saveImg,
                                  height: 18.h,
                                  width: 18.w,
                                  color: AppColors.bodyBg,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Save Changes',
                                  style: TextStyles.semiBoldMedium.copyWith(
                                    color: AppColors.bodyBg,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
    );
  }
}
