import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/custom_top_toast.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class TFAVerifyView extends StatefulWidget {
  const TFAVerifyView({super.key});

  @override
  State<TFAVerifyView> createState() => _TFAVerifyViewState();
}

class _TFAVerifyViewState extends State<TFAVerifyView> {
  late List<TextEditingController> _codeControllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _codeControllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      }
    }
  }

  void _onCodeBackspace(int index, String value) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _fullCode {
    return _codeControllers.map((c) => c.text).join();
  }

  bool get _isCodeComplete => _fullCode.length == 6;

  void _handleVerifyAndEnable() {
    if (!_isCodeComplete) return;

    CustomTopToast.show(context, '2FA enabled successfully');

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        context.push('/dealer/app-settings/two-factor-auth/success');
      }
    });
  }

  Widget _codeDigitField(int index) {
    return Container(
      height: 52.w,
      width: 52.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F9),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFDDE2EA)),
      ),
      child: TextField(
        controller: _codeControllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: TextStyles.boldLarge.copyWith(
          fontSize: 18.sp,
          color: AppColors.lightText,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            _onCodeChanged(index, value);
          } else {
            _onCodeBackspace(index, value);
          }
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Two-Factor Authentication',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 25.sp,
            ),
          ),
          height: 170.h,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 20.h),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.bodyBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFE2E7EE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Verification Code',
                      style: TextStyles.boldMedium.copyWith(
                        color: AppColors.lightText,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Enter the 6-digit code from your authenticator app',
                      style: TextStyles.regularSmall.copyWith(
                        color: AppColors.greyText,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                        (index) => _codeDigitField(index),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2FF),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFBED1FF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tip:',
                            style: TextStyles.boldSmall.copyWith(
                              color: const Color(0xFF1D4ED8),
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'The code changes every 30 seconds. Make sure to enter the current code from your app.',
                            style: TextStyles.regularSmall.copyWith(
                              color: const Color(0xFF1E40AF),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () => context.pop(),
                      height: 52.h,
                      borderRadius: 13.r,
                      btnColor: AppColors.bodyBg,
                      borderColor: const Color(0xFFE2E7EE),
                      btnText: 'Back to Setup',
                      textStyle: TextStyles.boldSmall.copyWith(
                        color: AppColors.lightText,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: IgnorePointer(
                      ignoring: !_isCodeComplete,
                      child: Opacity(
                        opacity: _isCodeComplete ? 1 : 0.55,
                        child: CustomButton(
                          onTap: _handleVerifyAndEnable,
                          height: 52.h,
                          borderRadius: 13.r,
                          btnColor: const Color(0xFF2D3E55),
                          btnText: 'Verify and Enable',
                          textStyle: TextStyles.boldSmall.copyWith(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
