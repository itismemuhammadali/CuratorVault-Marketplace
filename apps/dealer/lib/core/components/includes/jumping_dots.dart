import 'package:flutter/material.dart';

class JumpingDots extends StatefulWidget {
  final Color color;
  final double radius;
  final int numberOfDots;
  final Duration animationDuration;

  const JumpingDots({
    super.key,
    this.color = Colors.white,
    this.radius = 4.0,
    this.numberOfDots = 3,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<JumpingDots> createState() => _JumpingDotsState();
}

class _JumpingDotsState extends State<JumpingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _controllers = List.generate(
      widget.numberOfDots,
      (index) => AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: -6.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    for (int i = 0; i < widget.numberOfDots; i++) {
      _controllers[i].addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controllers[i].reverse();
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _controllers[i].forward();
            }
          });
        }
      });
    }

    _startAnimations();
  }

  void _startAnimations() async {
    for (int i = 0; i < widget.numberOfDots; i++) {
      await Future.delayed(Duration(milliseconds: i * 150));
      if (mounted) {
        _controllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.numberOfDots, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: widget.radius / 2),
                width: widget.radius * 2,
                height: widget.radius * 2,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class JumpingDotsProgress extends StatelessWidget {
  final String? text;
  final TextStyle? textStyle;
  final Color? dotColor;
  final Color color;
  final double radius;

  const JumpingDotsProgress({
    super.key,
    this.text,
    this.textStyle,
    this.dotColor,
    this.color = Colors.white,
    this.radius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDotColor = dotColor ?? color;

    if (text == null || text!.isEmpty) {
      return JumpingDots(
        color: effectiveDotColor,
        radius: radius,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text!,
          style: textStyle ?? const TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(width: 8),
        JumpingDots(
          color: effectiveDotColor,
          radius: radius,
        ),
      ],
    );
  }
}
