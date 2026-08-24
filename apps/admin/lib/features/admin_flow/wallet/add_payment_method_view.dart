import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AddPaymentMethodView extends StatefulWidget {
  const AddPaymentMethodView({super.key});

  @override
  State<AddPaymentMethodView> createState() => _AddPaymentMethodViewState();
}

class _AddPaymentMethodViewState extends State<AddPaymentMethodView> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  bool get _canSubmit {
    return _cardNumberController.text.trim().isNotEmpty &&
        _expiryController.text.trim().isNotEmpty &&
        _cvvController.text.trim().isNotEmpty &&
        _cardHolderController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_refresh);
    _expiryController.addListener(_refresh);
    _cvvController.addListener(_refresh);
    _cardHolderController.addListener(_refresh);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.bodyBg,
      appBar: SimpleHeader(
        config: HeaderConfig(
          height: 165.h,
          leading: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: AppColors.bodyBg.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 23.sp,
                color: AppColors.darkText,
              ),
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Payment Card',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.boldLarge.copyWith(
                  color: AppColors.bodyBg,
                  fontSize: 21.sp,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Manage user subscriptions',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.mediumSmall.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.88),
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(20.w, 27.h, 20.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Card Number'),
              SizedBox(height: 7.h),
              _inputField(
                controller: _cardNumberController,
                hintText: '1234 5678 9012 3456',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
              ),
              SizedBox(height: 13.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Expiry Date'),
                        SizedBox(height: 7.h),
                        _inputField(
                          controller: _expiryController,
                          hintText: 'MM/YY',
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(5),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('CVV'),
                        SizedBox(height: 7.h),
                        _inputField(
                          controller: _cvvController,
                          hintText: '123',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 13.h),
              _label('Cardholder Name'),
              SizedBox(height: 7.h),
              _inputField(
                controller: _cardHolderController,
                hintText: 'Enter Name',
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 27.h),
              _addButton(),
              SizedBox(height: 11.h),
              _cancelButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.boldSmall.copyWith(
        color: const Color(0xFF343434),
        fontSize: 15.sp,
        height: 1.1,
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return SizedBox(
      height: 42.h,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        style: TextStyles.mediumSmall.copyWith(
          color: const Color(0xFF344054),
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: const Color(0xFFF4F4F5),
          hintText: hintText,
          hintStyle: TextStyles.mediumSmall.copyWith(
            color: const Color(0xFF8C93A1),
            fontSize: 16.sp,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 11.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
          ),
        ),
      ),
    );
  }

  Widget _addButton() {
    return InkWell(
      onTap: _canSubmit ? _submit : null,
      borderRadius: BorderRadius.circular(5.r),
      child: Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          color: _canSubmit ? AppColors.gradientColor2 : const Color(0xFF98A2AE),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Center(
          child: Text(
            'Add Card`',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldExtraSmall.copyWith(
              color: AppColors.bodyBg.withValues(alpha: 0.82),
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cancelButton(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(),
      borderRadius: BorderRadius.circular(5.r),
      child: Container(
        width: double.infinity,
        height: 36.h,
        decoration: BoxDecoration(
          color: AppColors.bodyBg,
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: const Color(0xFFE2E4E8)),
        ),
        child: Center(
          child: Text(
            'Cancel',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.boldSmall.copyWith(
              color: const Color(0xFF343434),
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment card added successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
