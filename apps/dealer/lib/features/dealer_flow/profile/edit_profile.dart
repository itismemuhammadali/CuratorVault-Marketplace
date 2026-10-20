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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vintage_app/core/services/api_service.dart';
import 'package:vintage_app/core/components/includes/jumping_dots.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _profileImageBytes;

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _bioController.text = '';
    _bioController.addListener(() {
      if (mounted) setState(() {});
    });
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.email != null) _emailController.text = user.email!;
      if (user.displayName != null) {
        _businessNameController.text = user.displayName!;
        _usernameController.text = user.displayName!;
      }
    }

    setState(() => _isLoading = true);
    try {
      final res = await ApiService.get('/api/v1/profile/me');
      if (res is Map && mounted) {
        final data = Map<String, dynamic>.from(res);
        _businessNameController.text = (data['storeName'] ?? data['name'] ?? _businessNameController.text).toString();
        _usernameController.text = (data['ownerName'] ?? data['name'] ?? _usernameController.text).toString();
        _emailController.text = (data['email'] ?? _emailController.text).toString();
        _phoneController.text = (data['phone'] ?? '').toString();
        _locationController.text = (data['location'] ?? '').toString();
        _bioController.text = (data['bio'] ?? '').toString();
        _websiteController.text = (data['website'] ?? '').toString();
      }
    } catch (e) {
      debugPrint('Error fetching dealer profile for edit: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() => _isSaving = true);
    FocusScope.of(context).unfocus();

    try {
      final payload = {
        'name': _businessNameController.text.trim(),
        'storeName': _businessNameController.text.trim(),
        'ownerName': _usernameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'location': _locationController.text.trim(),
        'bio': _bioController.text.trim(),
        'website': _websiteController.text.trim(),
      };

      await ApiService.put('/api/v1/profile/me', payload);

      if (user != null) {
        await FirebaseFirestore.instance.collection('dealers').doc(user.uid).set(
          payload,
          SetOptions(merge: true),
        );
        if (_businessNameController.text.trim().isNotEmpty) {
          await user.updateDisplayName(_businessNameController.text.trim());
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dealer profile updated successfully!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
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

  @override
  void dispose() {
    _businessNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Edit Profile',
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
        child: _isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: JumpingDotsProgress(color: AppColors.gradientColor1),
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 120.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickProfileImage,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 106.w,
                            height: 106.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.gradientColor1,
                                width: 2,
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
                            bottom: -2.h,
                            child: Container(
                              width: 34.w,
                              height: 34.w,
                              decoration: BoxDecoration(
                                color: AppColors.gradientColor1,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.bodyBg,
                                  width: 2.5,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 17.sp,
                                color: AppColors.bodyBg,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Tap to change profile photo',
                      style: TextStyles.regularMedium.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              _label('Business Name'),
              _filledField(
                controller: _businessNameController,
                icon: null,
                svgIcon: 'assets/icons/business_icon.svg',
                hintText: 'Antique Dealer Shop',
              ),
              SizedBox(height: 12.h),
              _label('Username'),
              _filledField(
                controller: _usernameController,
                icon: null,
                svgIcon: 'assets/icons/profile_icon.svg',
                hintText: '@antiquedealershop',
              ),
              SizedBox(height: 12.h),
              _label('Bio'),
              _bioField(),
              SizedBox(height: 6.h),
              Text(
                '${_bioController.text.length}/200 characters',
                style: TextStyles.regularMedium.copyWith(
                  color: AppColors.greyText,
                ),
              ),
              SizedBox(height: 12.h),
              _label('Location'),
              _filledField(
                controller: _locationController,
                icon: null,
                svgIcon: 'assets/icons/location_icon.svg',
                hintText: 'New York, United States',
              ),
              SizedBox(height: 12.h),
              _label('Phone'),
              _filledField(
                controller: _phoneController,
                icon: Icons.phone_outlined,
                svgIcon: null,
                keyboardType: TextInputType.phone,
                hintText: '+1 (555) 123-4567',
              ),
              SizedBox(height: 12.h),
              _label('Email'),
              _filledField(
                controller: _emailController,
                icon: null,
                svgIcon: 'assets/icons/mail_icon.svg',
                keyboardType: TextInputType.emailAddress,
                hintText: 'dealer@antiques.com',
              ),
              SizedBox(height: 12.h),
              _label('Website (Optional)'),
              _filledField(
                controller: _websiteController,
                icon: null,
                svgIcon: 'assets/icons/web_icon.svg',
                keyboardType: TextInputType.url,
                hintText: 'www.antiquedealershop.com',
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFD3E1FC)),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Profile Tip:\n',
                        style: TextStyles.semiBoldMedium.copyWith(
                          color: const Color(0xFF2C4FA2),
                        ),
                      ),
                      TextSpan(
                        text:
                            'A complete profile with accurate information helps\nbuild trust with buyers and increases your sales.',
                        style: TextStyles.regularMedium.copyWith(
                          color: const Color(0xFF2C4FA2),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.subPageBg,
          border: Border(
            top: BorderSide(
              color: AppColors.lightText.withValues(alpha: 0.14),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      height: 54.h,
                      decoration: BoxDecoration(
                        color: AppColors.bodyBg,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFD7DCE3)),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyles.mediumMedium.copyWith(
                            color: AppColors.lightText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: GestureDetector(
                    onTap: _isSaving ? null : _saveChanges,
                    child: Container(
                      height: 54.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.gradientColor1,
                            AppColors.gradientColor2,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: _isSaving
                          ? const Center(child: JumpingDotsProgress())
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/save_icon.svg',
                                  width: 17.w,
                                  height: 17.w,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Save Changes',
                                  style: TextStyles.mediumMedium.copyWith(
                                    color: AppColors.bodyBg,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.h),
      child: Text(
        text,
        style: TextStyles.semiBoldMedium.copyWith(
          color: AppColors.lightText,
          fontSize: 19.sp,
        ),
      ),
    );
  }

  Widget _filledField({
    required TextEditingController controller,
    required IconData? icon,
    String? svgIcon,
    TextInputType? keyboardType,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyles.mediumMedium.copyWith(color: AppColors.lightText),
      decoration: InputDecoration(
        prefixIcon: svgIcon != null
            ? Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 8.w, 12.h),
                child: SvgPicture.asset(
                  svgIcon,
                  width: 12.w,
                  height: 12.w,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF8B95A5),
                    BlendMode.srcIn,
                  ),
                ),
              )
            : Icon(icon, size: 24.sp, color: const Color(0xFF8B95A5)),
        hintText: hintText,
        hintStyle: TextStyles.mediumMedium.copyWith(color: AppColors.lightText),
        filled: true,
        fillColor: const Color(0xFFF0F2F6),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: const Color(0xFFD9DEE7), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: const Color(0xFFD9DEE7), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.gradientColor1.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _bioField() {
    return TextField(
      controller: _bioController,
      maxLength: 200,
      maxLines: 3,
      style: TextStyles.regularMedium.copyWith(color: AppColors.lightText),
      decoration: InputDecoration(
        hintText: 'Tell buyers about your business...',
        hintStyle: TextStyles.regularMedium.copyWith(color: AppColors.greyText),
        counterText: '',
        filled: true,
        fillColor: const Color(0xFFF0F2F6),
        contentPadding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: const Color(0xFFD9DEE7), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: const Color(0xFFD9DEE7), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.gradientColor1.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
      ),
    );
  }
}
