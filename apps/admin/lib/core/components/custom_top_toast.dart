import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTopToast extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;

  const CustomTopToast({super.key, required this.message, required this.onDismissed});

  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return CustomTopToast(
          message: message,
          onDismissed: () {
            entry.remove();
          },
        );
      },
    );
    overlay.insert(entry);
  }

  @override
  State<CustomTopToast> createState() => _CustomTopToastState();
}

class _CustomTopToastState extends State<CustomTopToast> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _visible = true);
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => _visible = false);
    });

    Future.delayed(const Duration(milliseconds: 2100), () {
      if (!mounted) return;
      widget.onDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 0),
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            offset: _visible ? Offset.zero : const Offset(0, -0.25),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              opacity: _visible ? 1 : 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF031E1B),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFF0A3A34),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: const Color(0xFF00C853),
                        size: 18.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            height: 19.5 / 13,
                            letterSpacing: 0,
                            color: const Color(0xFF00C853),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
