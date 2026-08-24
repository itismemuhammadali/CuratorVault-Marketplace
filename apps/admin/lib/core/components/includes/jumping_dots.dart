import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JumpingDotsProgress extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Color dotColor;

  const JumpingDotsProgress({
    super.key,
    required this.text,
    required this.textStyle,
    this.dotColor = Colors.white,
  });

  @override
  State<JumpingDotsProgress> createState() => _JumpingDotsProgressState();
}

class _JumpingDotsProgressState extends State<JumpingDotsProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.text, style: widget.textStyle),
        SizedBox(width: 4.w),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double delay = index * 0.2;
                final double progress = (_controller.value - delay) % 1.0;
                final double offsetY = progress < 0.5
                    ? -7.h * (1 - ((progress * 2) - 1).abs())
                    : 0;
                return Transform.translate(
                  offset: Offset(0, offsetY),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    width: 5.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      color: widget.dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
